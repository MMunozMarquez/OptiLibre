unit MathProgWriter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, lpsolve{$IFDEF MSWINDOWS}, UnicodeHelper{$ENDIF};

{ Writes the model loaded in lp as a GNU MathProg model. Semi-continuous
  variables and SOS sets are linearized with auxiliary binary variables. }
function WriteMathProgModel(LP: THandle; const FileName: string;
  out ErrorMessage: string): Boolean;

implementation

type
  TSOSSet = record
    SetType: Integer;
    Members: array of Integer;
  end;

const
  Reserved: array[0..47] of string = (
    'and', 'by', 'check', 'cross', 'data', 'diff', 'display', 'div', 'else',
    'end', 'for', 'if', 'in', 'Infinity', 'inter', 'less', 'maximize',
    'minimize', 'mod', 'not', 'option', 'or', 'param', 'printf', 'set',
    'solve', 'subject', 'symbolic', 'symdiff', 'then', 'to', 'union',
    'var', 'within', 'binary', 'integer', 'real', 'default', 'dimen',
    'setof', 'table', 'prod', 'sum', 'min', 'max', 'card', 'length', 'abs');

function Num(Value: Double): string;
begin
  Result := FloatToStrF(Value, ffGeneral, 15, 0, DefaultFormatSettings);
  if Pos('E', UpperCase(Result)) > 0 then
    Result := StringReplace(UpperCase(Result), 'E+', 'e', []);
end;

function IsReserved(const Name: string): Boolean;
var
  I: Integer;
begin
  for I := Low(Reserved) to High(Reserved) do
    if Name = Reserved[I] then
      Exit(True);
  Result := False;
end;

function MakeName(const Raw, Default: string; Index: Integer): string;
var
  I: Integer;
  C: Char;
begin
  if Raw = '' then
    Exit(Default + IntToStr(Index));
  Result := Raw;
  for I := 1 to Length(Result) do
  begin
    C := Result[I];
    if not ((C in ['a'..'z', 'A'..'Z', '_']) or ((I > 1) and (C in ['0'..'9']))) then
      Result[I] := '_';
  end;
  if Result[1] in ['0'..'9'] then
    Result := '_' + Result;
  if IsReserved(Result) then
    Result := Result + '_';
end;

function WriteMathProgModel(LP: THandle; const FileName: string;
  out ErrorMessage: string): Boolean;
var
  Out_: TStringList;
  Ncols, Nrows, I, J, K, L, N, ConstrType: Integer;
  Names: TStringList;
  Used: TStringList;
  Infinite, Lo, Hi, Lb, Ub, Rh, Range, A: Double;
  Cols: PIntArray;
  Vals: PFloatArray;
  SOSSets: array of TSOSSet;
  HasSC: Boolean;
  TmpLP, S, Sect, Item: string;
  Lines: TStringList;
  Cnt: Integer;
  ScY: array of string;
  SosY: array of array of string;

  function ColN(J: Integer): string;
  begin
    Result := Names[J - 1];
  end;

  function RowN(I: Integer): string;
  begin
    Result := Names[Ncols + I];
  end;

  function Aux(const Prefix, Tail: string): string;
  begin
    Result := Prefix + Tail;
    while Used.IndexOf(Result) >= 0 do
      Result := Result + '_';
    Used.Add(Result);
  end;

  function Expr(Row: Integer; out Count: Integer): string;
  var
    T: Integer;
  begin
    Count := 0;
    Result := '';
    N := get_rowex(LP, Row, Vals, Cols);
    for T := 0 to N - 1 do
    begin
      A := Vals^[T];
      if A = 0 then
        Continue;
      if Count = 0 then
      begin
        if A < 0 then
          Result := '-';
      end
      else if A < 0 then
        Result := Result + ' - '
      else
        Result := Result + ' + ';
      if Abs(A) <> 1 then
        Result := Result + Num(Abs(A)) + '*';
      Result := Result + ColN(Cols^[T]);
      Inc(Count);
    end;
  end;

  procedure LoadSOS;
  var
    InSOS: Boolean;
    Idx, Colon, Le, Cnt: Integer;
    Header, Spec, Member: string;
    Parts: TStringList;
    Q, J: Integer;
  begin
    TmpLP := GetTempFileName(GetTempDir(False), 'opti');
    Lines := TStringList.Create;
    Parts := TStringList.Create;
    try
      if not write_lp(LP, PChar(TmpLP)) then
        Exit;
      Lines.LoadFromFile(TmpLP);
      InSOS := False;
      for Idx := 0 to Lines.Count - 1 do
      begin
        S := Trim(Lines[Idx]);
        if SameText(S, 'sos') or SameText(S, 'sos1') or SameText(S, 'sos2') then
        begin
          InSOS := True;
          Continue;
        end;
        if not InSOS then
          Continue;
        if (S = '') or (Pos('/*', S) = 1) then
          Continue;
        Colon := Pos(':', S);
        Le := Pos('<=', S);
        if (Colon = 0) or (Le = 0) then
          Continue;
        Spec := Trim(Copy(S, Colon + 1, Le - Colon - 1));
        Header := Trim(Copy(S, Le + 2, MaxInt));
        if (Header <> '') and (Header[Length(Header)] = ';') then
          SetLength(Header, Length(Header) - 1);
        Colon := Pos(':', Header);
        if Colon > 0 then
          Header := Copy(Header, 1, Colon - 1);
        Cnt := Length(SOSSets);
        SetLength(SOSSets, Cnt + 1);
        SOSSets[Cnt].SetType := StrToIntDef(Trim(Header), 1);
        Parts.Clear;
        Parts.Delimiter := ',';
        Parts.StrictDelimiter := True;
        Parts.DelimitedText := Spec;
        for Q := 0 to Parts.Count - 1 do
        begin
          Member := Trim(Parts[Q]);
          if Pos(':', Member) > 0 then
            Member := Trim(Copy(Member, 1, Pos(':', Member) - 1));
          for J := 1 to Ncols do
            if SameStr(StrPas(get_col_name(LP, J)), Member) then
            begin
              SetLength(SOSSets[Cnt].Members, Length(SOSSets[Cnt].Members) + 1);
              SOSSets[Cnt].Members[High(SOSSets[Cnt].Members)] := J;
              Break;
            end;
        end;
      end;
    finally
      Parts.Free;
      Lines.Free;
      if FileExists(TmpLP) then
        DeleteFile(TmpLP);
    end;
  end;

begin
  Result := False;
  ErrorMessage := '';
  Ncols := get_Ncolumns(LP);
  Nrows := get_Nrows(LP);
  Infinite := get_infinite(LP);
  Out_ := TStringList.Create;
  Names := TStringList.Create;
  Used := TStringList.Create;
  Cols := nil;
  Vals := nil;
  ScY := nil;
  SosY := nil;
  SOSSets := nil;
  try
    GetMem(Cols, (Ncols + 1) * SizeOf(Integer));
    GetMem(Vals, (Ncols + 1) * SizeOf(Double));

    { Unique names for columns (0..Ncols-1) and rows (Ncols+0..Ncols+Nrows) }
    for J := 1 to Ncols do
      Names.Add(MakeName(StrPas(get_col_name(LP, J)), 'C', J));
    for I := 0 to Nrows do
    begin
      S := StrPas(get_row_name(LP, I));
      if (I = 0) and ((S = '') or (S = 'R0')) then
        S := 'obj';
      Names.Add(MakeName(S, 'R', I));
    end;
    for I := 0 to Names.Count - 1 do
    begin
      K := 0;
      S := Names[I];
      while Used.IndexOf(Names[I]) >= 0 do
      begin
        Inc(K);
        Names[I] := S + '_' + IntToStr(K);
      end;
      Used.Add(Names[I]);
    end;

    HasSC := False;
    for J := 1 to Ncols do
      if is_semicont(LP, J) then
      begin
        HasSC := True;
        if get_upbo(LP, J) >= Infinite then
        begin
          ErrorMessage := 'Semi-continuous variable ' + ColN(J) +
            ' has no finite upper bound.';
          Exit;
        end;
      end;

    for J := 1 to Ncols do
      if is_SOS_var(LP, J) then
      begin
        LoadSOS;
        Break;
      end;
    for I := 0 to High(SOSSets) do
      for K := 0 to High(SOSSets[I].Members) do
      begin
        J := SOSSets[I].Members[K];
        if (get_upbo(LP, J) >= Infinite) or (get_lowbo(LP, J) <= -Infinite) then
        begin
          ErrorMessage := 'SOS variable ' + ColN(J) + ' must have finite bounds.';
          Exit;
        end;
      end;

    S := StrPas(get_lp_name(LP));
    if (S <> '') and (S <> 'Unnamed') then
    begin
      Out_.Add('/* ' + StringReplace(S, '*/', '* /', [rfReplaceAll]) + ' */');
      Out_.Add('');
    end;

    Out_.Add('/* Variable definitions */');
    for J := 1 to Ncols do
    begin
      Lb := get_lowbo(LP, J);
      Ub := get_upbo(LP, J);
      S := 'var ' + ColN(J);
      if is_int(LP, J) and not is_semicont(LP, J) and (Lb = 0) and (Ub = 1) then
        S := S + ', binary'
      else
      begin
        if is_int(LP, J) then
          S := S + ', integer';
        if not is_semicont(LP, J) then
        begin
          if Lb = Ub then
            S := S + ', = ' + Num(Lb)
          else
          begin
            if Lb > -Infinite then
              S := S + ', >= ' + Num(Lb);
            if Ub < Infinite then
              S := S + ', <= ' + Num(Ub);
          end;
        end;
      end;
      Out_.Add(S + ';');
    end;

    SetLength(ScY, Ncols + 1);
    if HasSC then
    begin
      Out_.Add('');
      Out_.Add('/* Indicator variables of semi-continuous variables */');
      for J := 1 to Ncols do
        if is_semicont(LP, J) then
        begin
          ScY[J] := Aux('scy_', ColN(J));
          Out_.Add('var ' + ScY[J] + ', binary;');
        end;
    end;
    SetLength(SosY, Length(SOSSets));
    if Length(SOSSets) > 0 then
    begin
      Out_.Add('');
      Out_.Add('/* Indicator variables of SOS sets */');
      for I := 0 to High(SOSSets) do
      begin
        SetLength(SosY[I], Length(SOSSets[I].Members));
        for K := 0 to High(SOSSets[I].Members) do
        begin
          SosY[I][K] := Aux('sosy', Format('%d_%d', [I + 1, K + 1]));
          Out_.Add('var ' + SosY[I][K] + ', binary;');
        end;
      end;
    end;

    Out_.Add('');
    Out_.Add('/* Objective function */');
    Rh := get_rh(LP, 0);
    Item := Expr(0, Cnt);
    if Rh <> 0 then
    begin
      if Cnt > 0 then
      begin
        if Rh < 0 then
          Item := Item + ' - '
        else
          Item := Item + ' + ';
      end
      else if Rh < 0 then
        Item := '-';
      Item := Item + Num(Abs(Rh));
    end
    else if Cnt = 0 then
      Item := '0';
    if is_maxim(LP) then
      Sect := 'maximize '
    else
      Sect := 'minimize ';
    Out_.Add(Sect + RowN(0) + ': ' + Item + ';');

    Out_.Add('');
    Out_.Add('/* Constraints */');
    for I := 1 to Nrows do
    begin
      Rh := get_rh(LP, I);
      ConstrType := get_constr_type(LP, I);
      if ConstrType = EQ then
        Range := 0
      else
        Range := get_rh_range(LP, I);
      Lo := -Infinite;
      Hi := Infinite;
      if ConstrType = EQ then
      begin
        Lo := Rh;
        Hi := Rh;
      end
      else if ConstrType = GE then
      begin
        Lo := Rh;
        if Abs(Range) < Infinite then
          Hi := Rh + Range;
      end
      else
      begin
        Hi := Rh;
        if Abs(Range) < Infinite then
          Lo := Rh - Range;
      end;
      if (Lo <= -Infinite) and (Hi >= Infinite) then
      begin
        Out_.Add('/* free row ' + RowN(I) + ' skipped */');
        Continue;
      end;
      S := 's.t. ' + RowN(I) + ': ';
      if (Lo > -Infinite) and (Hi < Infinite) and (Lo <> Hi) then
        S := S + Num(Lo) + ' <= ';
      Item := Expr(I, Cnt);
      if Cnt = 0 then
      begin
        if Ncols >= 1 then
          Item := '0*' + ColN(1)
        else
          Item := '0';
      end;
      if Lo = Hi then
        Out_.Add(S + Item + ' = ' + Num(Lo) + ';')
      else if Hi < Infinite then
        Out_.Add(S + Item + ' <= ' + Num(Hi) + ';')
      else
        Out_.Add(S + Item + ' >= ' + Num(Lo) + ';');
    end;

    if HasSC then
    begin
      Out_.Add('');
      Out_.Add('/* Semi-continuous variable definitions */');
      for J := 1 to Ncols do
        if is_semicont(LP, J) then
        begin
          Lb := get_lowbo(LP, J);
          Ub := get_upbo(LP, J);
          Out_.Add('s.t. ' + Aux('scu_', ColN(J)) + ': ' + ColN(J) + ' <= ' +
            Num(Ub) + '*' + ScY[J] + ';');
          if Lb <> 0 then
            Out_.Add('s.t. ' + Aux('scl_', ColN(J)) + ': ' + ColN(J) + ' >= ' +
              Num(Lb) + '*' + ScY[J] + ';');
        end;
    end;

    if Length(SOSSets) > 0 then
    begin
      Out_.Add('');
      Out_.Add('/* SOS definitions (members ordered as in the set) */');
      for I := 0 to High(SOSSets) do
      begin
        S := '';
        for K := 0 to High(SOSSets[I].Members) do
        begin
          J := SOSSets[I].Members[K];
          Lb := get_lowbo(LP, J);
          Ub := get_upbo(LP, J);
          if Ub > 0 then
            Out_.Add('s.t. ' + Aux('sosu', Format('%d_%d', [I + 1, K + 1])) +
              ': ' + ColN(J) + ' <= ' + Num(Ub) + '*' + SosY[I][K] + ';');
          if Lb < 0 then
            Out_.Add('s.t. ' + Aux('sosl', Format('%d_%d', [I + 1, K + 1])) +
              ': ' + ColN(J) + ' >= ' + Num(Lb) + '*' + SosY[I][K] + ';');
          if K > 0 then
            S := S + ' + ';
          S := S + SosY[I][K];
        end;
        if S = '' then
          Continue;
        Out_.Add('s.t. ' + Aux('soscnt', IntToStr(I + 1)) + ': ' + S + ' <= ' +
          IntToStr(SOSSets[I].SetType) + ';');
        if SOSSets[I].SetType >= 2 then
          for K := 0 to High(SOSSets[I].Members) do
            for L := K + SOSSets[I].SetType to High(SOSSets[I].Members) do
              Out_.Add('s.t. ' + Aux('sosadj', Format('%d_%d_%d',
                [I + 1, K + 1, L + 1])) + ': ' + SosY[I][K] + ' + ' +
                SosY[I][L] + ' <= 1;');
      end;
    end;

    Out_.Add('');
    Out_.Add('solve;');
    Out_.Add('');
    Out_.Add('end;');
    {$IFDEF MSWINDOWS}
    SaveFileWithUnicodePath(FileName, Out_);
    {$ELSE}
    Out_.SaveToFile(FileName);
    {$ENDIF}
    Result := True;
  finally
    if Cols <> nil then
      FreeMem(Cols);
    if Vals <> nil then
      FreeMem(Vals);
    Used.Free;
    Names.Free;
    Out_.Free;
  end;
end;

end.
