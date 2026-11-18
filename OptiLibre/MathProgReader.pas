unit MathProgReader;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils{$IFDEF MSWINDOWS}, UnicodeHelper{$ENDIF};

function ConvertMathProgToMPS(const ModelFile, DataFile, MPSFile: string;
  out Maximize: Boolean; out ObjectiveConstant: Double;
  out DataFileLoaded: Boolean; out ErrorMessage: string): Boolean;
function HasDataSection(const FileName: string): Boolean;

implementation

type
  TGLPProblem = Pointer;
  TGLPTranslator = Pointer;
  TGLPTermHook = function(Info: Pointer; const MessageText: PChar): Integer; cdecl;

var
  FGLPKMessages: string;

const
  {$IFDEF OPTILIBRE_WINDOWS}
  GLPKLIB = 'glpk_4_65.dll';
  {$ELSE}
  GLPKLIB = 'glpk';
  {$ENDIF}

function glp_create_prob: TGLPProblem; cdecl; external GLPKLIB;
procedure glp_delete_prob(Problem: TGLPProblem); cdecl; external GLPKLIB;
function glp_get_obj_dir(Problem: TGLPProblem): Integer; cdecl; external GLPKLIB;
function glp_get_obj_coef(Problem: TGLPProblem; Index: Integer): Double;
  cdecl; external GLPKLIB;
function glp_write_mps(Problem: TGLPProblem; Format: Integer; Parameters: Pointer;
  const FileName: PChar): Integer; cdecl; external GLPKLIB;
function glp_mpl_alloc_wksp: TGLPTranslator; cdecl; external GLPKLIB;
function glp_mpl_read_model(Translator: TGLPTranslator; const FileName: PChar;
  SkipData: Integer): Integer; cdecl; external GLPKLIB;
function glp_mpl_read_data(Translator: TGLPTranslator;
  const FileName: PChar): Integer; cdecl; external GLPKLIB;
function glp_mpl_generate(Translator: TGLPTranslator;
  const OutputFile: PChar): Integer; cdecl; external GLPKLIB;
procedure glp_mpl_build_prob(Translator: TGLPTranslator;
  Problem: TGLPProblem); cdecl; external GLPKLIB;
procedure glp_mpl_free_wksp(Translator: TGLPTranslator); cdecl; external GLPKLIB;
procedure glp_term_hook(Hook: TGLPTermHook; Info: Pointer); cdecl; external GLPKLIB;

{$PUSH}
{$HINTS OFF}
function GLPKTermHook(Info: Pointer; const MessageText: PChar): Integer; cdecl;
begin
  if MessageText <> nil then
    FGLPKMessages := FGLPKMessages + StrPas(MessageText);
  Result := 1;
end;
{$POP}

function CleanGLPKMessages(const Messages, ModelFile, DataFile,
  MPSFile: string): string;
var
  InputLines, OutputLines: TStringList;
  I: Integer;
begin
  InputLines := TStringList.Create;
  OutputLines := TStringList.Create;
  try
    InputLines.Text := Messages;
    for I := 0 to InputLines.Count - 1 do
      if not SameText(Copy(TrimLeft(InputLines[I]), 1,
        Length('Reading model section')), 'Reading model section') then
        OutputLines.Add(InputLines[I]);
    Result := Trim(OutputLines.Text);
    if ModelFile <> '' then
      Result := StringReplace(Result, ModelFile, 'model',
        [rfReplaceAll, rfIgnoreCase]);
    if DataFile <> '' then
      Result := StringReplace(Result, DataFile, 'data file',
        [rfReplaceAll, rfIgnoreCase]);
    if MPSFile <> '' then
      Result := StringReplace(Result, MPSFile, 'generated MPS file',
        [rfReplaceAll, rfIgnoreCase]);
  finally
    OutputLines.Free;
    InputLines.Free;
  end;
end;

function HasDataSection(const FileName: string): Boolean;
type
  TScanState = (ssCode, ssLineComment, ssBlockComment, ssSingleQuote,
    ssDoubleQuote);
var
  Source, Clean: string;
  State: TScanState;
  I, J, Start: Integer;
  C: Char;
  SL: TStringList;
begin
  Result := False;
  Source := '';
  SL := TStringList.Create;
  try
    {$IFDEF MSWINDOWS}
    LoadFileWithUnicodePath(FileName, SL);
    {$ELSE}
    SL.LoadFromFile(FileName);
    {$ENDIF}
    Source := SL.Text;
  finally
    SL.Free;
  end;

  Clean := StringOfChar(' ', Length(Source));
  State := ssCode;
  I := 1;
  while I <= Length(Source) do
  begin
    C := Source[I];
    case State of
      ssCode:
        if (C = '#') then
          State := ssLineComment
        else if (C = '/') and (I < Length(Source)) and
          (Source[I + 1] = '*') then
        begin
          State := ssBlockComment;
          Inc(I);
        end
        else if C = '''' then
          State := ssSingleQuote
        else if C = '"' then
          State := ssDoubleQuote
        else
          Clean[I] := C;
      ssLineComment:
        if C in [#10, #13] then
        begin
          State := ssCode;
          Clean[I] := C;
        end;
      ssBlockComment:
        if (C = '*') and (I < Length(Source)) and
          (Source[I + 1] = '/') then
        begin
          State := ssCode;
          Inc(I);
        end;
      ssSingleQuote, ssDoubleQuote:
        if ((State = ssSingleQuote) and (C = '''')) or
           ((State = ssDoubleQuote) and (C = '"')) then
        begin
          if (I < Length(Source)) and (Source[I + 1] = C) then
            Inc(I)
          else
            State := ssCode;
        end
        else if (C = '\') and (I < Length(Source)) then
          Inc(I);
    end;
    Inc(I);
  end;

  I := 1;
  while I <= Length(Clean) do
  begin
    if Clean[I] in ['A'..'Z', 'a'..'z', '_'] then
    begin
      Start := I;
      while (I <= Length(Clean)) and
        (Clean[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) do
        Inc(I);
      if SameText(Copy(Clean, Start, I - Start), 'data') then
      begin
        J := I;
        while (J <= Length(Clean)) and (Clean[J] <= ' ') do
          Inc(J);
        if (J <= Length(Clean)) and (Clean[J] = ';') then
          Exit(True);
      end;
    end
    else
      Inc(I);
  end;
end;

function ConvertMathProgToMPS(const ModelFile, DataFile, MPSFile: string;
  out Maximize: Boolean; out ObjectiveConstant: Double;
  out DataFileLoaded: Boolean; out ErrorMessage: string): Boolean;
var
  Translator: TGLPTranslator;
  Problem: TGLPProblem;
  Status: Integer;
  UseDataFile: Boolean;
  TempModelFile, TempDataFile, TempMPSFile: string;
  TempStream, FileStream: TFileStream;
begin
  Result := False;
  Maximize := False;
  ObjectiveConstant := 0;
  DataFileLoaded := False;
  ErrorMessage := '';
  UseDataFile := (DataFile <> '') and not HasDataSection(ModelFile);
  FGLPKMessages := '';
  Translator := nil;
  Problem := nil;
  TempModelFile := '';
  TempDataFile := '';
  TempMPSFile := '';
  glp_term_hook(@GLPKTermHook, nil);
  try
    try
      { Handle non-ASCII paths by copying to temporary files (Windows only) }
      {$IFDEF MSWINDOWS}
      if HasNonASCIIChars(ModelFile) then
      begin
        TempModelFile := CopyToTempLocation(ModelFile);
        if TempModelFile = '' then
          raise Exception.Create('Could not create temporary copy of model file.');
      end
      else
        TempModelFile := ModelFile;

      if UseDataFile and HasNonASCIIChars(DataFile) then
      begin
        TempDataFile := CopyToTempLocation(DataFile);
        if TempDataFile = '' then
          raise Exception.Create('Could not create temporary copy of data file.');
      end
      else
        TempDataFile := DataFile;

      if HasNonASCIIChars(MPSFile) then
        TempMPSFile := GetSafeTempFilePath('opti')
      else
        TempMPSFile := MPSFile;
      {$ELSE}
      TempModelFile := ModelFile;
      TempDataFile := DataFile;
      TempMPSFile := MPSFile;
      {$ENDIF}

      Translator := glp_mpl_alloc_wksp;
      if Translator = nil then
        raise Exception.Create('GLPK could not initialize the MathProg parser.');

      Status := glp_mpl_read_model(Translator, PChar(TempModelFile),
        Ord(UseDataFile));
      if Status <> 0 then
        raise Exception.Create('Could not read the MathProg model.');

      if UseDataFile then
      begin
        Status := glp_mpl_read_data(Translator, PChar(TempDataFile));
        if Status <> 0 then
          raise Exception.Create('Could not read the MathProg data file.');
        DataFileLoaded := True;
      end;

      Status := glp_mpl_generate(Translator, nil);
      if Status <> 0 then
        raise Exception.Create('Could not generate the MathProg problem.');

      Problem := glp_create_prob;
      if Problem = nil then
        raise Exception.Create('GLPK could not create the problem.');
      glp_mpl_build_prob(Translator, Problem);
      Maximize := glp_get_obj_dir(Problem) = 2;
      ObjectiveConstant := glp_get_obj_coef(Problem, 0);

      Status := glp_write_mps(Problem, 2, nil, PChar(TempMPSFile));
      if Status <> 0 then
        raise Exception.Create('Could not export the MathProg problem.');

      { Copy temporary MPS file to final destination if needed }
      if TempMPSFile <> MPSFile then
      begin
        try
          TempStream := TFileStream.Create(TempMPSFile, fmOpenRead or fmShareDenyNone);
          try
            FileStream := TFileStream.Create(MPSFile, fmCreate);
            try
              FileStream.CopyFrom(TempStream, TempStream.Size);
            finally
              FileStream.Free;
            end;
          finally
            TempStream.Free;
          end;
        except
          raise Exception.Create('Could not write MPS file.');
        end;
      end;

      Result := True;
    except
      on E: Exception do
      begin
        if FGLPKMessages <> '' then
          ErrorMessage := CleanGLPKMessages(FGLPKMessages, ModelFile,
            DataFile, MPSFile)
        else
          ErrorMessage := E.Message;
        if ErrorMessage = '' then
          ErrorMessage := E.Message;
      end;
    end;
  finally
    glp_term_hook(nil, nil);
    if Problem <> nil then
      glp_delete_prob(Problem);
    if Translator <> nil then
      glp_mpl_free_wksp(Translator);
    { Clean up temporary files }
    if (TempModelFile <> '') and (TempModelFile <> ModelFile) and FileExists(TempModelFile) then
      DeleteFile(TempModelFile);
    if (TempDataFile <> '') and (TempDataFile <> DataFile) and FileExists(TempDataFile) then
      DeleteFile(TempDataFile);
    if (TempMPSFile <> '') and (TempMPSFile <> MPSFile) and FileExists(TempMPSFile) then
      DeleteFile(TempMPSFile);
  end;
end;

end.
