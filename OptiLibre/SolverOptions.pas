unit SolverOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, lpsolve;

type
  TSolverOptions = record
    AntiDegen: Integer;
    Presolve: Integer;
    Scaling: Integer;
    Improve: Integer;
    Pivoting: Integer;
    BBRule: Integer;
    Messages: Integer;
    BasisCrash: Integer;
    SimplexType: Integer;
    BBFloorFirst: Integer;
    BBDepthLimit: Integer;
    SolutionLimit: Integer;
    Timeout: Integer;
    MaxPivot: Integer;
    PrintSol: Integer;
    Verbose: Integer;
    BreakAtFirst: Boolean;
    BoundsTighter: Boolean;
    Debug: Boolean;
    Trace: Boolean;
    LagTrace: Boolean;
    ObjBound: Double;
    Infinite: Double;
    Epsb: Double;
    Epsd: Double;
    Epsel: Double;
    EpsInt: Double;
    EpsPerturb: Double;
    EpsPivot: Double;
    ScaleLimit: Double;
    BreakAtValue: Double;
    NegRange: Double;
    MipGapAbs: Double;
    MipGapRel: Double;
    EpsLevel: Integer;
    PartialPrice: Integer;
    PartialPriceRows: Boolean;
    MultiPrice: Integer;
    PresolveLoops: Integer;
    VarBranch: Integer;
    ShowAllIntegerSolutions: Boolean;
    ShowOnlyNonNullValues: Boolean;
  end;

const
  MESSAGES_ALL = MSG_PRESOLVE or MSG_ITERATION or MSG_INVERT or
    MSG_LPFEASIBLE or MSG_LPOPTIMAL or MSG_LPEQUAL or MSG_LPBETTER or
    MSG_MILPFEASIBLE or MSG_MILPEQUAL or MSG_MILPBETTER or MSG_MILPSTRATEGY or
    MSG_MILPOPTIMAL or MSG_PERFORMANCE or MSG_INITPSEUDOCOST;
  // Needed to capture MILP solutions, whatever the user selects.
  MESSAGES_REQUIRED = MSG_MILPFEASIBLE or MSG_MILPBETTER;
  SIMPLEX_TYPE_VALUES: array[0..3] of Integer = (5, 6, 9, 10);
  // Text stored in the ini file for the options chosen from a list.
  BB_RULE_NAMES: array[0..7] of string = ('First', 'Gap', 'Range', 'Fraction',
    'Pseudo Cost', 'Pseudo Non Int', 'Pseudo Ratio', 'User');
  BRANCH_NAMES: array[0..3] of string = ('Ceiling', 'Floor', 'Automatic',
    'Default');
  SCALE_TYPE_NAMES: array[0..7] of string = ('Linear', 'Extreme', 'Range',
    'Mean', 'Geometric', 'Future1', 'Future2', 'Curtis-Reid');
  PIVOT_RULE_NAMES: array[0..3] of string = ('First Index', 'Dantzig',
    'Devex', 'Steepest Edge');
  BASIS_CRASH_NAMES: array[0..3] of string = ('Nothing', 'Non Basic Bounds',
    'Most Feasible', 'Least Degenerate');
  SIMPLEX_TYPE_NAMES: array[0..3] of string = ('Primal Primal', 'Dual Primal',
    'Primal Dual', 'Dual Dual');
  EPS_LEVEL_NAMES: array[0..3] of string = ('Tight', 'Medium', 'Loose',
    'Baggy');
  PRINT_SOL_NAMES: array[0..3] of string = ('False', 'True', 'Automatic',
    'Dynamic');
  VERBOSE_NAMES: array[0..6] of string = ('Neutral', 'Critical', 'Severe',
    'Important', 'Normal', 'Detailed', 'Full');

procedure GetDefaultSolverOptions(out Options: TSolverOptions);
procedure ApplySolverOptions(LP: THandle; const Options: TSolverOptions);
procedure SaveSolverOptions(const FileName: string;
  const Options: TSolverOptions);
function LoadSolverOptions(const FileName: string;
  var Options: TSolverOptions; Problems: TStrings = nil): Boolean;
function SolverFloatToStr(Value: Double): string;
function SolverTryStrToFloat(const Text: string; out Value: Double): Boolean;

implementation

const
  Section = 'Options';
  DefaultNoSelection = 'BB Floor First';

function InvariantSettings: TFormatSettings;
begin
  Result := DefaultFormatSettings;
  Result.DecimalSeparator := '.';
  Result.ThousandSeparator := #0;
end;

function SolverFloatToStr(Value: Double): string;
begin
  Result := FloatToStr(Value, InvariantSettings);
end;

function SolverTryStrToFloat(const Text: string; out Value: Double): Boolean;
begin
  Result := TryStrToFloat(Trim(Text), Value, InvariantSettings) or
    TryStrToFloat(Trim(Text), Value);
end;

procedure GetDefaultSolverOptions(out Options: TSolverOptions);
var
  LP: THandle;
begin
  Options := Default(TSolverOptions);
  LP := make_lp(0, 0);
  if LP <> 0 then
  try
    Options.AntiDegen := get_anti_degen(LP);
    Options.Presolve := get_presolve(LP);
    Options.Scaling := get_scaling(LP);
    Options.Improve := get_improve(LP);
    Options.Pivoting := get_pivoting(LP);
    Options.BBRule := get_bb_rule(LP);
    Options.BasisCrash := get_basiscrash(LP);
    Options.SimplexType := get_simplextype(LP);
    // Automatic (BRANCH_AUTOMATIC) is the default branching direction.
    Options.BBFloorFirst := 2;
    Options.BBDepthLimit := get_bb_depthlimit(LP);
    // get_solutionlimit reports 1, which stops B&B after the first improved solution.
    Options.SolutionLimit := 0;
    Options.Timeout := get_timeout(LP);
    Options.MaxPivot := get_maxpivot(LP);
    Options.PrintSol := get_print_sol(LP);
    Options.BreakAtFirst := is_break_at_first(LP);
    Options.BoundsTighter := get_bounds_tighter(LP);
    Options.Debug := is_debug(LP);
    Options.Trace := is_trace(LP);
    Options.LagTrace := is_lag_trace(LP);
    Options.ObjBound := get_obj_bound(LP);
    Options.Infinite := get_infinite(LP);
    Options.Epsb := get_epsb(LP);
    Options.Epsd := get_epsd(LP);
    Options.Epsel := get_epsel(LP);
    Options.EpsInt := get_epsint(LP);
    Options.EpsPerturb := get_epsperturb(LP);
    Options.EpsPivot := get_epspivot(LP);
    Options.ScaleLimit := get_scalelimit(LP);
    Options.BreakAtValue := get_break_at_value(LP);
    Options.NegRange := get_negrange(LP);
    Options.MipGapAbs := get_mip_gap(LP, True);
    Options.MipGapRel := get_mip_gap(LP, False);
    Options.EpsLevel := 0;
    Options.PartialPrice := 1;
    Options.PartialPriceRows := False;
    Options.MultiPrice := 1;
    // get_presolveloops reports MAXINT32 for the default, so use -1 instead.
    Options.PresolveLoops := -1;
    Options.VarBranch := 2;
    Options.ShowAllIntegerSolutions := True;
    Options.ShowOnlyNonNullValues := False;
  finally
    delete_lp(LP);
  end;
  // Same verbosity and message reporting the IDE has always used.
  Options.Verbose := 4;
  Options.Messages := MESSAGES_ALL;
end;

procedure ApplyPartialPrice(LP: THandle; const Options: TSolverOptions);
var
  Items, Count, Step, I: Integer;
  Starts: array of Integer;
begin
  Starts := nil;
  Count := Options.PartialPrice;
  if Options.PartialPriceRows then
    Items := get_Nrows(LP)
  else
    Items := get_Ncolumns(LP);
  if Count <= 1 then
    Exit;
  if Count > Items then
    Count := Items;
  if Count <= 1 then
    Exit;
  Step := (Items + Count - 1) div Count;
  SetLength(Starts, Count);
  for I := 0 to Count - 1 do
    Starts[I] := 1 + I * Step;
  set_partialprice(LP, Count, @Starts[0], Options.PartialPriceRows);
end;

procedure ApplyVariableOptions(LP: THandle; const Options: TSolverOptions);
var
  Columns, I: Integer;
begin
  Columns := get_Ncolumns(LP);
  if Options.VarBranch <> 3 then
    for I := 1 to Columns do
      set_var_branch(LP, I, Options.VarBranch);
end;

procedure ApplySolverOptions(LP: THandle; const Options: TSolverOptions);
begin
  set_anti_degen(LP, Options.AntiDegen);
  set_presolve(LP, Options.Presolve, Options.PresolveLoops);
  set_scaling(LP, Options.Scaling);
  set_improve(LP, Options.Improve);
  set_pivoting(LP, Options.Pivoting);
  set_bb_rule(LP, Options.BBRule);
  set_basiscrash(LP, Options.BasisCrash);
  set_simplextype(LP, Options.SimplexType);
  set_bb_floorfirst(LP, Options.BBFloorFirst);
  set_bb_depthlimit(LP, Options.BBDepthLimit);
  set_solutionlimit(LP, Options.SolutionLimit);
  set_timeout(LP, Options.Timeout);
  set_maxpivot(LP, Options.MaxPivot);
  set_print_sol(LP, Options.PrintSol);
  set_verbose(LP, Options.Verbose);
  set_break_at_first(LP, Options.BreakAtFirst);
  set_bounds_tighter(LP, Options.BoundsTighter);
  set_debug(LP, Options.Debug);
  set_trace(LP, Options.Trace);
  set_lag_trace(LP, Options.LagTrace);
  set_obj_bound(LP, Options.ObjBound);
  set_infinite(LP, Options.Infinite);
  set_epsb(LP, Options.Epsb);
  set_epsd(LP, Options.Epsd);
  set_epsel(LP, Options.Epsel);
  set_epsint(LP, Options.EpsInt);
  set_epsperturb(LP, Options.EpsPerturb);
  set_epspivot(LP, Options.EpsPivot);
  set_scalelimit(LP, Options.ScaleLimit);
  set_break_at_value(LP, Options.BreakAtValue);
  set_negrange(LP, Options.NegRange);
  set_mip_gap(LP, True, Options.MipGapAbs);
  set_mip_gap(LP, False, Options.MipGapRel);
  set_epslevel(LP, Options.EpsLevel);
  ApplyPartialPrice(LP, Options);
  set_multiprice(LP, Options.MultiPrice);
  ApplyVariableOptions(LP, Options);
end;

function SimplexTypeIndex(Value: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(SIMPLEX_TYPE_VALUES) to High(SIMPLEX_TYPE_VALUES) do
    if SIMPLEX_TYPE_VALUES[I] = Value then
      Exit(I);
end;

procedure SaveSolverOptions(const FileName: string;
  const Options: TSolverOptions);
var
  Ini: TIniFile;

  procedure WriteInt(const Name: string; Value: Integer);
  begin
    Ini.WriteString(Section, Name, IntToStr(Value));
  end;

  procedure WriteBool(const Name: string; Value: Boolean);
  begin
    Ini.WriteString(Section, Name, IntToStr(Ord(Value)));
  end;

  procedure WriteFloat(const Name: string; Value: Double);
  begin
    Ini.WriteString(Section, Name, SolverFloatToStr(Value));
  end;

  procedure WriteChoice(const Name: string; Value: Integer;
    const Names: array of string);
  begin
    if (Value >= Low(Names)) and (Value <= High(Names)) then
      Ini.WriteString(Section, Name, Names[Value])
    else
      WriteInt(Name, Value);
  end;

begin
  if FileExists(FileName) then
    DeleteFile(FileName);
  Ini := TIniFile.Create(FileName);
  try
    Ini.CacheUpdates := True;
    WriteInt('AntiDegen', Options.AntiDegen);
    WriteInt('Presolve', Options.Presolve);
    WriteInt('Scaling', Options.Scaling and not 7);
    WriteChoice('ScaleType', Options.Scaling and 7, SCALE_TYPE_NAMES);
    WriteInt('Improve', Options.Improve);
    WriteInt('Pivoting', Options.Pivoting and not 3);
    WriteChoice('PivotRule', Options.Pivoting and 3, PIVOT_RULE_NAMES);
    WriteInt('BBRule', Options.BBRule and not 7);
    WriteChoice('BBRuleSelect', Options.BBRule and 7, BB_RULE_NAMES);
    WriteInt('Messages', Options.Messages);
    WriteBool('ShowAllIntegerSolutions', Options.ShowAllIntegerSolutions);
    WriteBool('ShowOnlyNonNullValues', Options.ShowOnlyNonNullValues);
    WriteChoice('BasisCrash', Options.BasisCrash, BASIS_CRASH_NAMES);
    WriteChoice('SimplexType', SimplexTypeIndex(Options.SimplexType),
      SIMPLEX_TYPE_NAMES);
    // The lp_solve default (3) is not a selectable item, so it is not stored.
    if Options.BBFloorFirst <= 2 then
      WriteChoice('BBFloorFirst', Options.BBFloorFirst, BRANCH_NAMES);
    WriteInt('BBDepthLimit', Options.BBDepthLimit);
    WriteInt('SolutionLimit', Options.SolutionLimit);
    WriteInt('Timeout', Options.Timeout);
    WriteInt('MaxPivot', Options.MaxPivot);
    WriteChoice('PrintSol', Options.PrintSol, PRINT_SOL_NAMES);
    WriteChoice('Verbose', Options.Verbose, VERBOSE_NAMES);
    WriteBool('BreakAtFirst', Options.BreakAtFirst);
    WriteBool('BoundsTighter', Options.BoundsTighter);
    WriteBool('Debug', Options.Debug);
    WriteBool('Trace', Options.Trace);
    WriteBool('LagTrace', Options.LagTrace);
    WriteFloat('ObjBound', Options.ObjBound);
    WriteFloat('Infinite', Options.Infinite);
    WriteFloat('Epsb', Options.Epsb);
    WriteFloat('Epsd', Options.Epsd);
    WriteFloat('Epsel', Options.Epsel);
    WriteFloat('EpsInt', Options.EpsInt);
    WriteFloat('EpsPerturb', Options.EpsPerturb);
    WriteFloat('EpsPivot', Options.EpsPivot);
    WriteFloat('ScaleLimit', Options.ScaleLimit);
    WriteFloat('BreakAtValue', Options.BreakAtValue);
    WriteFloat('NegRange', Options.NegRange);
    WriteFloat('MipGapAbs', Options.MipGapAbs);
    WriteFloat('MipGapRel', Options.MipGapRel);
    WriteChoice('EpsLevel', Options.EpsLevel, EPS_LEVEL_NAMES);
    WriteInt('PartialPrice', Options.PartialPrice);
    WriteBool('PartialPriceRows', Options.PartialPriceRows);
    WriteInt('MultiPrice', Options.MultiPrice);
    WriteInt('PresolveLoops', Options.PresolveLoops);
    if Options.VarBranch <= 2 then
      WriteChoice('VarBranch', Options.VarBranch, BRANCH_NAMES);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

function LoadSolverOptions(const FileName: string;
  var Options: TSolverOptions; Problems: TStrings = nil): Boolean;
var
  Ini: TIniFile;
  Def: TSolverOptions;
  SimplexIndex: Integer;

  procedure ReadInt(const Name: string; var Value: Integer);
  begin
    Value := StrToIntDef(Ini.ReadString(Section, Name, ''), Value);
  end;

  procedure ReadBool(const Name: string; var Value: Boolean);
  begin
    Value := StrToIntDef(Ini.ReadString(Section, Name, ''), Ord(Value)) <> 0;
  end;

  procedure ReadFloat(const Name: string; var Value: Double);
  var
    Parsed: Double;
  begin
    if SolverTryStrToFloat(Ini.ReadString(Section, Name, ''), Parsed) then
      Value := Parsed;
  end;

  // Returns False when the key is missing. Otherwise Index is the list
  // position read, or DefaultIndex (after reporting a problem) when the text
  // is not one of the selectable items.
  function ResolveChoice(const Name: string; const Names: array of string;
    Limit, DefaultIndex: Integer; out Index: Integer): Boolean;
  var
    Text, DefaultText: string;
    I: Integer;
  begin
    Index := DefaultIndex;
    Result := Ini.ValueExists(Section, Name);
    if not Result then
      Exit;
    Text := Trim(Ini.ReadString(Section, Name, ''));
    for I := Low(Names) to High(Names) do
      if SameText(Text, Names[I]) and (I <= Limit) then
      begin
        Index := I;
        Exit;
      end;
    if Problems <> nil then
    begin
      if DefaultIndex > Limit then
        DefaultText := DefaultNoSelection
      else
        DefaultText := Names[DefaultIndex];
      Problems.Add(Format('%s: "%s" is not a valid value, using the default "%s".',
        [Name, Text, DefaultText]));
    end;
  end;

  procedure ReadChoice(const Name: string; var Value: Integer;
    const Names: array of string; Limit, DefaultValue: Integer);
  var
    Index: Integer;
  begin
    if ResolveChoice(Name, Names, Limit, DefaultValue, Index) then
      Value := Index;
  end;

  procedure ReadFlags(const Name: string; Mask: Integer; var Value: Integer);
  var
    Flags: Integer;
  begin
    Flags := Value and not Mask;
    ReadInt(Name, Flags);
    Value := (Value and Mask) or (Flags and not Mask);
  end;

  procedure ReadMaskedChoice(const Name: string; Mask: Integer;
    var Value: Integer; const Names: array of string; DefaultValue: Integer);
  var
    Index: Integer;
  begin
    if ResolveChoice(Name, Names, High(Names), DefaultValue and Mask, Index) then
      Value := (Value and not Mask) or Index;
  end;

begin
  Result := False;
  if not FileExists(FileName) then
    Exit;
  GetDefaultSolverOptions(Def);
  Ini := TIniFile.Create(FileName);
  try
    if not Ini.SectionExists(Section) then
      Exit;
    ReadInt('AntiDegen', Options.AntiDegen);
    ReadInt('Presolve', Options.Presolve);
    ReadFlags('Scaling', 7, Options.Scaling);
    ReadMaskedChoice('ScaleType', 7, Options.Scaling, SCALE_TYPE_NAMES,
      Def.Scaling);
    ReadInt('Improve', Options.Improve);
    ReadFlags('Pivoting', 3, Options.Pivoting);
    ReadMaskedChoice('PivotRule', 3, Options.Pivoting, PIVOT_RULE_NAMES,
      Def.Pivoting);
    ReadFlags('BBRule', 7, Options.BBRule);
    ReadMaskedChoice('BBRuleSelect', 7, Options.BBRule, BB_RULE_NAMES,
      Def.BBRule);
    ReadInt('Messages', Options.Messages);
    ReadBool('ShowAllIntegerSolutions', Options.ShowAllIntegerSolutions);
    ReadBool('ShowOnlyNonNullValues', Options.ShowOnlyNonNullValues);
    ReadChoice('BasisCrash', Options.BasisCrash, BASIS_CRASH_NAMES,
      High(BASIS_CRASH_NAMES), Def.BasisCrash);
    if ResolveChoice('SimplexType', SIMPLEX_TYPE_NAMES,
       High(SIMPLEX_TYPE_NAMES), SimplexTypeIndex(Def.SimplexType),
       SimplexIndex) then
      Options.SimplexType := SIMPLEX_TYPE_VALUES[SimplexIndex];
    ReadChoice('BBFloorFirst', Options.BBFloorFirst, BRANCH_NAMES, 2,
      Def.BBFloorFirst);
    ReadInt('BBDepthLimit', Options.BBDepthLimit);
    ReadInt('SolutionLimit', Options.SolutionLimit);
    ReadInt('Timeout', Options.Timeout);
    ReadInt('MaxPivot', Options.MaxPivot);
    ReadChoice('PrintSol', Options.PrintSol, PRINT_SOL_NAMES,
      High(PRINT_SOL_NAMES), Def.PrintSol);
    ReadChoice('Verbose', Options.Verbose, VERBOSE_NAMES,
      High(VERBOSE_NAMES), Def.Verbose);
    ReadBool('BreakAtFirst', Options.BreakAtFirst);
    ReadBool('BoundsTighter', Options.BoundsTighter);
    ReadBool('Debug', Options.Debug);
    ReadBool('Trace', Options.Trace);
    ReadBool('LagTrace', Options.LagTrace);
    ReadFloat('ObjBound', Options.ObjBound);
    ReadFloat('Infinite', Options.Infinite);
    ReadFloat('Epsb', Options.Epsb);
    ReadFloat('Epsd', Options.Epsd);
    ReadFloat('Epsel', Options.Epsel);
    ReadFloat('EpsInt', Options.EpsInt);
    ReadFloat('EpsPerturb', Options.EpsPerturb);
    ReadFloat('EpsPivot', Options.EpsPivot);
    ReadFloat('ScaleLimit', Options.ScaleLimit);
    ReadFloat('BreakAtValue', Options.BreakAtValue);
    ReadFloat('NegRange', Options.NegRange);
    ReadFloat('MipGapAbs', Options.MipGapAbs);
    ReadFloat('MipGapRel', Options.MipGapRel);
    ReadChoice('EpsLevel', Options.EpsLevel, EPS_LEVEL_NAMES,
      High(EPS_LEVEL_NAMES), Def.EpsLevel);
    ReadInt('PartialPrice', Options.PartialPrice);
    ReadBool('PartialPriceRows', Options.PartialPriceRows);
    ReadInt('MultiPrice', Options.MultiPrice);
    ReadInt('PresolveLoops', Options.PresolveLoops);
    ReadChoice('VarBranch', Options.VarBranch, BRANCH_NAMES, 2,
      Def.VarBranch);
    Result := True;
  finally
    Ini.Free;
  end;
end;

end.
