unit OptionsPanel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, StdCtrls, ComCtrls, Forms, Graphics, Contnrs, SolverOptions;

type
  TFlagDef = record
    Caption: string;
    Value: Integer;
  end;

  { TSolverOptionsPanel }

  TOptionMark = class
    Control, Target: TControl;
    DefaultText: string;
    Baseline: string;
    IniName: string;
    Corrected: Boolean;
  end;

  TSolverOptionsPanel = class(TPageControl)
  private
    FDefaultOptions: TSolverOptions;
    FTopics: TStringList;
    FMarks: TObjectList;
    FBaselineSet: Boolean;
    FAntiDegen, FPresolve, FImprove, FBBMode, FScaleMode, FPivotMode,
      FMessages: TGroupBox;
    FBBRuleSelect, FBBFloorFirst, FScaleType, FPivotRule, FBasisCrash,
      FSimplexType, FPrintSol, FVerbose: TComboBox;
    FDepthLimit, FObjBound, FScaleLimit, FMaxPivot, FSolutionLimit, FTimeout,
      FInfinite, FEpsb, FEpsd, FEpsel, FEpsInt, FEpsPerturb, FEpsPivot,
      FBreakAtValue, FNegRange, FMipGapAbs, FMipGapRel, FPartialPrice, FMultiPrice,
      FPresolveLoops: TEdit;
    FEpsLevel, FVarBranch: TComboBox;
    FPartialPriceRows: TCheckBox;
    FBoundsTighter, FBreakAtFirst, FDebug, FTrace, FLagTrace,
      FShowAllIntSolutions, FShowNonNull: TCheckBox;
    FOnShowAllChanged: TNotifyEvent;
    procedure RegisterMark(Control, Target: TControl; const Group, ACaption: string);
    procedure ControlChanged(Sender: TObject);
    procedure RefreshMarks;
    procedure AssignOptionHint(Control: TControl; const Group, ACaption: string);
    function AddScrollTab(const ACaption: string): TScrollBox;
    function AddFlags(AParent: TWinControl; const ACaption: string;
      const Defs: array of TFlagDef; Columns: Integer): TGroupBox;
    function AddFields(AParent: TWinControl; const ACaption: string): TGroupBox;
    function AddCombo(Group: TGroupBox; const ACaption: string;
      const Items: array of string): TComboBox;
    function AddEdit(Group: TGroupBox; const ACaption: string): TEdit;
    function AddCheck(Group: TGroupBox; const ACaption: string): TCheckBox;
    function GetFlags(Group: TGroupBox): Integer;
    procedure SetFlags(Group: TGroupBox; Value: Integer);
    procedure ReadInt(Edit: TEdit; const FieldName: string; var Value: Integer;
      var Error: string);
    procedure ReadFloat(Edit: TEdit; const FieldName: string;
      var Value: Double; var Error: string);
    procedure BuildOptionsTab;
    procedure BuildAdvancedTab;
    procedure AddFlagBoxes(Group: TGroupBox; const Defs: array of TFlagDef);
    procedure BuildMessagesTab;
    function GetShowOnlyNonNullValues: Boolean;
    procedure SetShowOnlyNonNullValues(Value: Boolean);
    function GetShowAllIntegerSolutions: Boolean;
    procedure SetShowAllIntegerSolutions(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HelpTopicOf(Control: TControl): string;
    property ShowAllIntegerSolutions: Boolean
      read GetShowAllIntegerSolutions write SetShowAllIntegerSolutions;
    property ShowOnlyNonNullValues: Boolean
      read GetShowOnlyNonNullValues write SetShowOnlyNonNullValues;
    property OnDisplayOptionChanged: TNotifyEvent
      read FOnShowAllChanged write FOnShowAllChanged;
    procedure ShowOptions(const Opts: TSolverOptions);
    procedure MarkCorrectedOptions(Problems: TStrings);
    procedure CommitBaseline;
    function TryGetOptions(var Opts: TSolverOptions;
      out Error: string): Boolean;
  end;

implementation

function HelpTopicFor(const Group, ACaption: string): string;
const
  Topics: array[0..46] of array[0..1] of string = (
    ('Pivot Rule', 'set_pivoting'), ('Max Pivot', 'set_maxpivot'),
    ('Partial Price', 'set_pivoting'), ('Partial Price Rows', 'set_pivoting'),
    ('Multi Price', 'set_pivoting'), ('Scale Type', 'set_scaling'),
    ('Scale Limit', 'set_scalelimit'), ('BB Rule Select', 'set_bb_rule'),
    ('BB Floor First', 'set_bb_floorfirst'), ('Depth Limit', 'set_bb_depthlimit'),
    ('Obj Bound', 'set_obj_bound'), ('MIP Gap Abs', 'set_mip_gap'),
    ('MIP Gap Rel', 'set_mip_gap'), ('Var Branch', 'set_var_branch'),
    ('Basis Crash', 'set_basiscrash'), ('Simplex Type', 'set_simplextype'),
    ('Solution Limit', 'set_solutionlimit'), ('Timeout', 'set_timeout'),
    ('Infinite', 'set_infinite'), ('EPSB', 'set_epsb'), ('EPSD', 'set_epsd'),
    ('EPSEL', 'set_epsel'), ('EPS Int', 'set_epsint'),
    ('EPS Perturb', 'set_epsperturb'), ('EPS Pivot', 'set_epspivot'),
    ('Break at Value', 'set_break_at_value'), ('Neg Range', 'set_negrange'),
    ('EPS Level', 'set_epslevel'), ('Presolve Loops', 'set_presolve'),
    ('Bounds Tighter', 'set_bounds_tighter'),
    ('Break at first', 'set_break_at_first'), ('Debug', 'set_debug'),
    ('Trace', 'set_trace'), ('Lag Trace', 'set_lag_trace'),
    ('Print Sol', 'set_print_sol'), ('Verbose', 'set_verbose'),
    ('Pivot Mode', 'set_pivoting'), ('Scale Mode', 'set_scaling'),
    ('BB Rule Mode', 'set_bb_rule'), ('Anti Degen', 'set_anti_degen'),
    ('Presolve', 'set_presolve'), ('Improve', 'set_improve'),
    ('Messages', 'put_msgfunc'), ('Branch & Bound', 'lp_solve'),
    ('Pivot', 'set_pivoting'), ('Scale', 'set_scaling'),
    ('General', 'lp_solve'));
var
  I: Integer;
begin
  Result := 'lp_solve';
  for I := Low(Topics) to High(Topics) do
    if Topics[I][0] = ACaption then
      Exit(Topics[I][1] + '.htm');
  for I := Low(Topics) to High(Topics) do
    if Topics[I][0] = Group then
      Exit(Topics[I][1] + '.htm');
  Result := 'lp_solve.htm';
end;

function HintFor(const Group, ACaption: string): string;
var
  Key: string;
begin
  Key := Group + '|' + ACaption;
  case Key of
    'Anti Degen|Fixed vars': Result := 'Anti-degeneracy: perturb fixed variables.';
    'Anti Degen|Column Check': Result := 'Anti-degeneracy: check columns for degeneracy.';
    'Anti Degen|Stalling': Result := 'Anti-degeneracy: apply when the simplex stalls.';
    'Anti Degen|Num Failure': Result := 'Anti-degeneracy: apply after a numerical failure.';
    'Anti Degen|Lost Feas': Result := 'Anti-degeneracy: apply when feasibility is lost.';
    'Anti Degen|Infeasible': Result := 'Anti-degeneracy: apply when the problem looks infeasible.';
    'Anti Degen|Dynamic': Result := 'Anti-degeneracy: dynamic application.';
    'Anti Degen|DuringBB': Result := 'Anti-degeneracy: also apply during branch and bound.';
    'Anti Degen|RhsPerturb': Result := 'Anti-degeneracy: perturb the right-hand side.';
    'Anti Degen|BoundFlip': Result := 'Anti-degeneracy: use bound flipping.';
    'Presolve|Rows': Result := 'Presolve and remove redundant rows. Results then show the reduced model.';
    'Presolve|Cols': Result := 'Presolve and remove redundant columns. Results then show the reduced model.';
    'Presolve|Lindep': Result := 'Eliminate linearly dependent rows.';
    'Presolve|Aggregate': Result := 'Aggregate columns.';
    'Presolve|Sparser': Result := 'Improve the model sparsity.';
    'Presolve|SOS': Result := 'Presolve SOS constraints.';
    'Presolve|Reduce MIP': Result := 'Skip presolve steps that would hurt MIP branching.';
    'Presolve|KnapSack': Result := 'Convert knapsack-like constraints to binary variables.';
    'Presolve|Elimeq2': Result := 'Eliminate equality constraints with two variables.';
    'Presolve|ImpliedFree': Result := 'Identify implied free variables.';
    'Presolve|Reduce GCD': Result := 'Reduce coefficients using the greatest common divisor.';
    'Presolve|ProbeFix': Result := 'Fix binary variables by probing.';
    'Presolve|ProbeReduce': Result := 'Reduce coefficients by probing.';
    'Presolve|RowDominate': Result := 'Delete dominated rows.';
    'Presolve|ColDominate': Result := 'Delete dominated columns.';
    'Presolve|MergeRows': Result := 'Merge rows with identical coefficients.';
    'Presolve|Implied SLK': Result := 'Convert implied slack variables.';
    'Presolve|ColFixDual': Result := 'Fix columns using dual information.';
    'Presolve|Bounds': Result := 'Tighten variable bounds.';
    'Presolve|Duals': Result := 'Calculate duals (needed for sensitivity analysis).';
    'Presolve|Sens Duals': Result := 'Calculate sensitivity duals.';
    'Improve|Solution': Result := 'Iterative improvement of the solution.';
    'Improve|DualFeas': Result := 'Check and restore dual feasibility.';
    'Improve|ThetaGap': Result := 'Dynamic adjustment of the theta gap.';
    'Improve|BBSimplex': Result := 'Use the simplex in branch and bound improvement.';
    'Messages|Presolve': Result := 'Report presolve messages.';
    'Messages|Iteration': Result := 'Report every simplex iteration.';
    'Messages|Invert': Result := 'Report basis refactorizations.';
    'Messages|Lp Feasible': Result := 'Report when a feasible LP solution is found.';
    'Messages|Lp Optimal': Result := 'Report when the LP optimum is found.';
    'Messages|Lp Equal': Result := 'Report equal LP solutions.';
    'Messages|Lp Better': Result := 'Report improved LP solutions.';
    'Messages|Mipl Feasible': Result := 'Report feasible integer solutions (always enabled by the IDE).';
    'Messages|Mipl Equal': Result := 'Report equal integer solutions.';
    'Messages|Mipl Better': Result := 'Report improved integer solutions (always enabled by the IDE).';
    'Messages|Mipl Strategy': Result := 'Report branch and bound strategy messages.';
    'Messages|Mipl Optimal': Result := 'Report when the MIP optimum is found.';
    'Messages|Performance': Result := 'Report performance information.';
    'Messages|Init Pseudo Cost': Result := 'Report pseudo-cost initialization.';
    'Pivot Mode|Primal Fall Back': Result := 'Fall back to primal simplex when the dual fails.';
    'Pivot Mode|Multiple': Result := 'Multiple pricing.';
    'Pivot Mode|Partial': Result := 'Partial pricing.';
    'Pivot Mode|Adaptive': Result := 'Temporarily use alternative strategies on stalling.';
    'Pivot Mode|Hybrid': Result := 'Hybrid pricing strategy.';
    'Pivot Mode|Randomize': Result := 'Add a small random value to the pricing.';
    'Pivot Mode|AutoPartial': Result := 'Automatic partial pricing.';
    'Pivot Mode|AutoMultiple': Result := 'Automatic multiple pricing.';
    'Pivot Mode|LoopLeft': Result := 'Scan entering/leaving candidates left to right.';
    'Pivot Mode|LoopAlternate': Result := 'Alternate the scan direction.';
    'Pivot Mode|HarrisTwoPass': Result := 'Use the Harris ratio test with two passes.';
    'Pivot Mode|True Norm Init': Result := 'Use true norms for pricing initialization.';
    'Scale Mode|Quadratic': Result := 'Scale to a quadratic mean.';
    'Scale Mode|Logarithmic': Result := 'Scale based on the logarithm of the values.';
    'Scale Mode|Power2': Result := 'Round scale factors to a power of 2.';
    'Scale Mode|Equilibrate': Result := 'Make sure that no scaled number is above 1.';
    'Scale Mode|Integers': Result := 'Also scale integer columns.';
    'Scale Mode|DynUpdate': Result := 'Dynamically recompute scale factors.';
    'Scale Mode|RowsOnly': Result := 'Scale rows only.';
    'Scale Mode|ColsOnly': Result := 'Scale columns only.';
    'BB Rule Mode|Weight Reverse': Result := 'Select the branching variable by reversed weight.';
    'BB Rule Mode|Branch Reverse': Result := 'Branch in the opposite direction.';
    'BB Rule Mode|Greedy': Result := 'Use a greedy approach to select the branching variable.';
    'BB Rule Mode|Pseudo Cost': Result := 'Use pseudo-cost information.';
    'BB Rule Mode|Depth First': Result := 'Select the deepest node first.';
    'BB Rule Mode|Randomize': Result := 'Randomize the branching variable selection.';
    'BB Rule Mode|Gub': Result := 'Enable GUB branching.';
    'BB Rule Mode|Dynamic': Result := 'Dynamically adapt the branching strategy.';
    'BB Rule Mode|Restart': Result := 'Restart B&B when the first improved solution is found.';
    'BB Rule Mode|Breadth First': Result := 'Select the shallowest node first.';
    'BB Rule Mode|AutoOrder': Result := 'Automatically order the branching variables.';
    'BB Rule Mode|RCostFixing': Result := 'Fix variables using reduced costs.';
    'BB Rule Mode|StrongInit': Result := 'Initialize pseudo-costs by strong branching.';
    'Branch & Bound|BB Rule Select': Result := 'Rule used to select the next variable to branch on.';
    'Branch & Bound|BB Floor First': Result := 'Default branching direction: ceiling, floor or automatic.';
    'Branch & Bound|Depth Limit': Result := 'Maximum B&B depth. Negative values are relative to the number of variables.';
    'Branch & Bound|Obj Bound': Result := 'Initial bound on the objective function. Nodes worse than this are pruned.';
    'Branch & Bound|MIP Gap Abs': Result := 'Absolute MIP gap: B&B stops pruning nodes whose improvement is below this value.';
    'Branch & Bound|MIP Gap Rel': Result := 'Relative MIP gap: B&B stops pruning nodes whose relative improvement is below this value.';
    'Branch & Bound|Var Branch': Result := 'Branching mode applied to every variable.';
    'Pivot|Pivot Rule': Result := 'Rule used to select the entering variable.';
    'Pivot|Max Pivot': Result := 'Maximum number of pivots between basis refactorizations.';
    'Pivot|Partial Price': Result := 'Number of blocks for partial pricing. 1 disables it; 0 leaves block selection to lp_solve.';
    'Pivot|Partial Price Rows': Result := 'Apply partial pricing to rows instead of columns.';
    'Pivot|Multi Price': Result := 'Multiple pricing block divisor.';
    'Scale|Scale Type': Result := 'Scaling algorithm.';
    'Scale|Scale Limit': Result := 'Maximum number of scaling iterations; values between 0 and 1 set the convergence threshold.';
    'Tolerances and limits|Basis Crash': Result := 'Method used to build the initial basis.';
    'Tolerances and limits|Simplex Type': Result := 'Simplex phase 1 and phase 2 algorithms.';
    'Tolerances and limits|Solution Limit': Result := 'Maximum number of improved solutions to find (0 = no limit).';
    'Tolerances and limits|Timeout': Result := 'Maximum solving time in seconds (0 = no limit).';
    'Tolerances and limits|Infinite': Result := 'Value treated as infinity.';
    'Tolerances and limits|EPSB': Result := 'Tolerance for the right-hand side.';
    'Tolerances and limits|EPSD': Result := 'Tolerance for reduced costs.';
    'Tolerances and limits|EPSEL': Result := 'General rounding tolerance.';
    'Tolerances and limits|EPS Int': Result := 'Tolerance to consider a value integer.';
    'Tolerances and limits|EPS Perturb': Result := 'Perturbation scalar used by anti-degeneracy.';
    'Tolerances and limits|EPS Pivot': Result := 'Minimum value accepted as a pivot.';
    'Tolerances and limits|EPS Level': Result := 'Predefined tolerance level.';
    'Tolerances and limits|Presolve Loops': Result := 'Maximum number of presolve passes (-1 = lp_solve default, 0 = no limit).';
    'Tolerances and limits|Break at Value': Result := 'Stop B&B when a solution at least this good is found.';
    'Tolerances and limits|Neg Range': Result := 'Negative value below which variables are split into negative and positive part.';
    'General|Bounds Tighter': Result := 'Try to tighten the variable bounds.';
    'General|Break at first': Result := 'Stop at the first found integer solution.';
    'Debugging|Debug': Result := 'Print all intermediate valid solutions (B&B debug mode).';
    'Debugging|Trace': Result := 'Print function calls while solving.';
    'Debugging|Lag Trace': Result := 'Print Lagrangian relaxation information.';
    'Solutions|Show all integer solutions': Result := 'Keep every improved integer solution in the result tabs. When cleared, only the latest solution is shown.';
    'Solutions|Show only non-null values': Result := 'In the Objective and Duals tabs, hide the rows whose values are all null (absolute value below EPSEL).';
    'Solutions|Print Sol': Result := 'Print all intermediate valid solutions.';
    'Messages|Verbose': Result := 'Level of the messages written to the log.';
  else
    Result := '';
  end;
end;

function DefaultFor(Control: TControl; const Group, ACaption: string;
  const Defaults: TSolverOptions): string;
var
  FlagValue, Value, I: Integer;
  HasFlag, IsCombo: Boolean;
begin
  Result := '';
  HasFlag := False;
  IsCombo := False;
  Value := -1;
  FlagValue := 0;

  if Control is TCheckBox then
  begin
    case Group of
      'Anti Degen': begin FlagValue := Defaults.AntiDegen; HasFlag := True; end;
      'Presolve': begin FlagValue := Defaults.Presolve; HasFlag := True; end;
      'Improve': begin FlagValue := Defaults.Improve; HasFlag := True; end;
      'Messages': begin FlagValue := Defaults.Messages; HasFlag := True; end;
      'Pivot Mode': begin FlagValue := Defaults.Pivoting; HasFlag := True; end;
      'Scale Mode': begin FlagValue := Defaults.Scaling; HasFlag := True; end;
      'BB Rule Mode': begin FlagValue := Defaults.BBRule; HasFlag := True; end;
      'Pivot':
        if ACaption = 'Partial Price Rows' then
          Result := BoolToStr(Defaults.PartialPriceRows, True);
      'General':
        if ACaption = 'Bounds Tighter' then
          Result := BoolToStr(Defaults.BoundsTighter, True)
        else if ACaption = 'Break at first' then
          Result := BoolToStr(Defaults.BreakAtFirst, True);
      'Solutions':
        if ACaption = 'Show all integer solutions' then
          Result := BoolToStr(Defaults.ShowAllIntegerSolutions, True)
        else if ACaption = 'Show only non-null values' then
          Result := BoolToStr(Defaults.ShowOnlyNonNullValues, True);
      'Debugging':
        if ACaption = 'Debug' then
          Result := BoolToStr(Defaults.Debug, True)
        else if ACaption = 'Trace' then
          Result := BoolToStr(Defaults.Trace, True)
        else if ACaption = 'Lag Trace' then
          Result := BoolToStr(Defaults.LagTrace, True);
    end;
    if HasFlag then
      if (FlagValue and Control.Tag) <> 0 then
        Result := 'Enabled'
      else
        Result := 'Disabled'
    else if Result <> '' then
      if Result = 'True' then
        Result := 'Enabled'
      else
        Result := 'Disabled';
    Exit;
  end;

  case Group + '|' + ACaption of
    'Branch & Bound|BB Rule Select':
      begin Value := Defaults.BBRule and 7; IsCombo := True; end;
    'Branch & Bound|BB Floor First':
      begin Value := Defaults.BBFloorFirst; IsCombo := True; end;
    'Branch & Bound|Depth Limit': Result := IntToStr(Defaults.BBDepthLimit);
    'Branch & Bound|Obj Bound': Result := SolverFloatToStr(Defaults.ObjBound);
    'Branch & Bound|MIP Gap Abs': Result := SolverFloatToStr(Defaults.MipGapAbs);
    'Branch & Bound|MIP Gap Rel': Result := SolverFloatToStr(Defaults.MipGapRel);
    'Branch & Bound|Var Branch':
      begin Value := Defaults.VarBranch; IsCombo := True; end;
    'Pivot|Pivot Rule':
      begin Value := Defaults.Pivoting and 3; IsCombo := True; end;
    'Pivot|Max Pivot': Result := IntToStr(Defaults.MaxPivot);
    'Pivot|Partial Price': Result := IntToStr(Defaults.PartialPrice);
    'Pivot|Partial Price Rows':
      Result := BoolToStr(Defaults.PartialPriceRows, True);
    'Pivot|Multi Price': Result := IntToStr(Defaults.MultiPrice);
    'Scale|Scale Type':
      begin Value := Defaults.Scaling and 7; IsCombo := True; end;
    'Scale|Scale Limit': Result := SolverFloatToStr(Defaults.ScaleLimit);
    'Tolerances and limits|Basis Crash':
      begin Value := Defaults.BasisCrash; IsCombo := True; end;
    'Tolerances and limits|Simplex Type':
      begin
        Value := -1;
        for I := Low(SIMPLEX_TYPE_VALUES) to High(SIMPLEX_TYPE_VALUES) do
          if SIMPLEX_TYPE_VALUES[I] = Defaults.SimplexType then
            Value := I;
        IsCombo := True;
      end;
    'Tolerances and limits|Solution Limit':
      Result := IntToStr(Defaults.SolutionLimit);
    'Tolerances and limits|Timeout': Result := IntToStr(Defaults.Timeout);
    'Tolerances and limits|Infinite': Result := SolverFloatToStr(Defaults.Infinite);
    'Tolerances and limits|EPSB': Result := SolverFloatToStr(Defaults.Epsb);
    'Tolerances and limits|EPSD': Result := SolverFloatToStr(Defaults.Epsd);
    'Tolerances and limits|EPSEL': Result := SolverFloatToStr(Defaults.Epsel);
    'Tolerances and limits|EPS Int': Result := SolverFloatToStr(Defaults.EpsInt);
    'Tolerances and limits|EPS Perturb':
      Result := SolverFloatToStr(Defaults.EpsPerturb);
    'Tolerances and limits|EPS Pivot': Result := SolverFloatToStr(Defaults.EpsPivot);
    'Tolerances and limits|EPS Level':
      begin Value := Defaults.EpsLevel; IsCombo := True; end;
    'Tolerances and limits|Presolve Loops':
      Result := IntToStr(Defaults.PresolveLoops);
    'Tolerances and limits|Break at Value':
      Result := SolverFloatToStr(Defaults.BreakAtValue);
    'Tolerances and limits|Neg Range': Result := SolverFloatToStr(Defaults.NegRange);
    'Solutions|Print Sol':
      begin Value := Defaults.PrintSol; IsCombo := True; end;
    'Messages|Verbose':
      begin Value := Defaults.Verbose; IsCombo := True; end;
  end;

  if IsCombo and (Control is TComboBox) and (Value >= 0) and
     (Value < TComboBox(Control).Items.Count) then
    Result := TComboBox(Control).Items[Value];
end;

procedure TSolverOptionsPanel.AssignOptionHint(Control: TControl;
  const Group, ACaption: string);
begin
  Control.Hint := HintFor(Group, ACaption);
  FTopics.AddObject(HelpTopicFor(Group, ACaption), Control);
  if Control.Hint <> '' then
    Control.Hint := Control.Hint + ' Default: ' +
      DefaultFor(Control, Group, ACaption, FDefaultOptions) + '.';
  Control.ShowHint := Control.Hint <> '';
end;

function Flag(const ACaption: string; AValue: Integer): TFlagDef;
begin
  Result.Caption := ACaption;
  Result.Value := AValue;
end;

constructor TSolverOptionsPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTopics := TStringList.Create;
  FMarks := TObjectList.Create(True);
  GetDefaultSolverOptions(FDefaultOptions);
  BuildOptionsTab;
  BuildAdvancedTab;
  BuildMessagesTab;
  ActivePage := Pages[0];
end;

destructor TSolverOptionsPanel.Destroy;
begin
  FMarks.Free;
  FTopics.Free;
  inherited Destroy;
end;

function TSolverOptionsPanel.HelpTopicOf(Control: TControl): string;
var
  I: Integer;
begin
  Result := '';
  while (Control <> nil) and (Result = '') do
  begin
    I := FTopics.IndexOfObject(Control);
    if I >= 0 then
      Result := FTopics[I];
    Control := Control.Parent;
  end;
end;

function IsDefaultValue(Mark: TOptionMark): Boolean;
var
  Combo: TComboBox;
  A, B: Double;
begin
  Result := True;
  if Mark.Control is TCheckBox then
    Result := TCheckBox(Mark.Control).Checked = (Mark.DefaultText = 'Enabled')
  else if Mark.Control is TComboBox then
  begin
    Combo := TComboBox(Mark.Control);
    if Combo.ItemIndex < 0 then
      Result := Combo.Items.IndexOf(Mark.DefaultText) < 0
    else
      Result := Combo.Items[Combo.ItemIndex] = Mark.DefaultText;
  end
  else if (Mark.Control is TEdit) and (Mark.DefaultText <> '') then
  begin
    Result := Trim(TEdit(Mark.Control).Text) = Mark.DefaultText;
    if not Result and SolverTryStrToFloat(TEdit(Mark.Control).Text, A) and
       SolverTryStrToFloat(Mark.DefaultText, B) then
      Result := A = B;
  end;
end;

function MarkState(Mark: TOptionMark): string;
begin
  if Mark.Control is TCheckBox then
    Result := BoolToStr(TCheckBox(Mark.Control).Checked, True)
  else if Mark.Control is TComboBox then
    Result := IntToStr(TComboBox(Mark.Control).ItemIndex)
  else
    Result := Trim(TEdit(Mark.Control).Text);
end;

procedure TSolverOptionsPanel.RegisterMark(Control, Target: TControl;
  const Group, ACaption: string);
var
  Mark: TOptionMark;
begin
  Mark := TOptionMark.Create;
  Mark.Control := Control;
  Mark.Target := Target;
  Mark.DefaultText := DefaultFor(Control, Group, ACaption, FDefaultOptions);
  case ACaption of
    'Scale Type': Mark.IniName := 'ScaleType';
    'Pivot Rule': Mark.IniName := 'PivotRule';
    'BB Rule Select': Mark.IniName := 'BBRuleSelect';
    'Basis Crash': Mark.IniName := 'BasisCrash';
    'Simplex Type': Mark.IniName := 'SimplexType';
    'BB Floor First': Mark.IniName := 'BBFloorFirst';
    'Print Sol': Mark.IniName := 'PrintSol';
    'Show all integer solutions': Mark.IniName := 'ShowAllIntegerSolutions';
    'Show only non-null values': Mark.IniName := 'ShowOnlyNonNullValues';
    'Verbose': Mark.IniName := 'Verbose';
    'EPS Level': Mark.IniName := 'EpsLevel';
    'Var Branch': Mark.IniName := 'VarBranch';
  end;
  FMarks.Add(Mark);
  if Control is TCheckBox then
    TCheckBox(Control).OnChange := @ControlChanged
  else if Control is TComboBox then
    TComboBox(Control).OnChange := @ControlChanged
  else if Control is TEdit then
    TEdit(Control).OnChange := @ControlChanged;
end;

procedure TSolverOptionsPanel.ControlChanged(Sender: TObject);
begin
  RefreshMarks;
  if ((Sender = FShowAllIntSolutions) or (Sender = FShowNonNull)) and
     Assigned(FOnShowAllChanged) then
    FOnShowAllChanged(Self);
end;

function TSolverOptionsPanel.GetShowOnlyNonNullValues: Boolean;
begin
  Result := FShowNonNull.Checked;
end;

procedure TSolverOptionsPanel.SetShowOnlyNonNullValues(Value: Boolean);
begin
  FShowNonNull.Checked := Value;
end;

function TSolverOptionsPanel.GetShowAllIntegerSolutions: Boolean;
begin
  Result := FShowAllIntSolutions.Checked;
end;

procedure TSolverOptionsPanel.SetShowAllIntegerSolutions(Value: Boolean);
begin
  FShowAllIntSolutions.Checked := Value;
end;

procedure TSolverOptionsPanel.RefreshMarks;
var
  I: Integer;
  Mark: TOptionMark;
  FontStyle: TFontStyles;
begin
  for I := 0 to FMarks.Count - 1 do
  begin
    Mark := TOptionMark(FMarks[I]);
    FontStyle := Mark.Target.Font.Style - [fsBold];
    if not IsDefaultValue(Mark) then
      Include(FontStyle, fsBold);
    Mark.Target.Font.Style := FontStyle;
    if Mark.Corrected or (MarkState(Mark) <> Mark.Baseline) then
      Mark.Target.Font.Color := clBlue
    else
      Mark.Target.Font.Color := clDefault;
  end;
end;

procedure TSolverOptionsPanel.MarkCorrectedOptions(Problems: TStrings);
var
  I, J: Integer;
  Mark: TOptionMark;
begin
  for I := 0 to FMarks.Count - 1 do
  begin
    Mark := TOptionMark(FMarks[I]);
    Mark.Corrected := False;
    if Mark.IniName = '' then
      Continue;
    for J := 0 to Problems.Count - 1 do
      if Pos(Mark.IniName + ':', Problems[J]) = 1 then
      begin
        Mark.Corrected := True;
        Break;
      end;
  end;
  RefreshMarks;
end;

procedure TSolverOptionsPanel.CommitBaseline;
var
  I: Integer;
begin
  for I := 0 to FMarks.Count - 1 do
  begin
    TOptionMark(FMarks[I]).Baseline := MarkState(TOptionMark(FMarks[I]));
    TOptionMark(FMarks[I]).Corrected := False;
  end;
  RefreshMarks;
end;

function TSolverOptionsPanel.AddScrollTab(const ACaption: string): TScrollBox;
var
  Sheet: TTabSheet;
begin
  Sheet := TTabSheet.Create(Self);
  Sheet.PageControl := Self;
  Sheet.Caption := ACaption;
  Result := TScrollBox.Create(Self);
  Result.Parent := Sheet;
  Result.Align := alClient;
  Result.BorderStyle := bsNone;
end;

function TSolverOptionsPanel.AddFields(AParent: TWinControl;
  const ACaption: string): TGroupBox;
begin
  Result := TGroupBox.Create(Self);
  Result.Caption := ACaption;
  Result.Align := alTop;
  Result.AutoSize := True;
  Result.BorderSpacing.Around := 6;
  Result.ChildSizing.Layout := cclLeftToRightThenTopToBottom;
  Result.ChildSizing.ControlsPerLine := 2;
  Result.ChildSizing.HorizontalSpacing := 16;
  Result.ChildSizing.VerticalSpacing := 6;
  Result.ChildSizing.LeftRightSpacing := 10;
  Result.ChildSizing.TopBottomSpacing := 6;
  // Later groups get a smaller Top, so they are displayed above earlier ones.
  Result.Top := 100000 - AParent.ControlCount * 1000;
  Result.Parent := AParent;
end;

function TSolverOptionsPanel.AddFlags(AParent: TWinControl;
  const ACaption: string; const Defs: array of TFlagDef;
  Columns: Integer): TGroupBox;
begin
  Result := AddFields(AParent, ACaption);
  Result.ChildSizing.ControlsPerLine := Columns;
  AddFlagBoxes(Result, Defs);
end;

procedure TSolverOptionsPanel.AddFlagBoxes(Group: TGroupBox;
  const Defs: array of TFlagDef);
var
  I: Integer;
  Box: TCheckBox;
begin
  for I := Low(Defs) to High(Defs) do
  begin
    Box := TCheckBox.Create(Self);
    Box.Caption := Defs[I].Caption;
    Box.Tag := Defs[I].Value;
    AssignOptionHint(Box, Group.Caption, Defs[I].Caption);
    Box.Parent := Group;
    RegisterMark(Box, Box, Group.Caption, Defs[I].Caption);
  end;
end;

function TSolverOptionsPanel.AddCombo(Group: TGroupBox;
  const ACaption: string; const Items: array of string): TComboBox;
var
  LabelControl: TLabel;
  I: Integer;
begin
  LabelControl := TLabel.Create(Self);
  LabelControl.Caption := ACaption;
  LabelControl.Layout := Graphics.tlCenter;
  LabelControl.Parent := Group;
  Result := TComboBox.Create(Self);
  Result.Style := csDropDownList;
  for I := Low(Items) to High(Items) do
    Result.Items.Add(Items[I]);
  AssignOptionHint(Result, Group.Caption, ACaption);
  LabelControl.Hint := Result.Hint;
  LabelControl.ShowHint := Result.ShowHint;
  Result.ItemIndex := 0;
  Result.Parent := Group;
  RegisterMark(Result, LabelControl, Group.Caption, ACaption);
end;

function TSolverOptionsPanel.AddEdit(Group: TGroupBox;
  const ACaption: string): TEdit;
var
  LabelControl: TLabel;
begin
  LabelControl := TLabel.Create(Self);
  LabelControl.Caption := ACaption;
  LabelControl.Layout := Graphics.tlCenter;
  LabelControl.Parent := Group;
  AssignOptionHint(LabelControl, Group.Caption, ACaption);
  Result := TEdit.Create(Self);
  AssignOptionHint(Result, Group.Caption, ACaption);
  Result.Width := 160;
  Result.Parent := Group;
  RegisterMark(Result, LabelControl, Group.Caption, ACaption);
end;

function TSolverOptionsPanel.AddCheck(Group: TGroupBox;
  const ACaption: string): TCheckBox;
begin
  Result := TCheckBox.Create(Self);
  Result.Caption := ACaption;
  AssignOptionHint(Result, Group.Caption, ACaption);
  Result.Parent := Group;
  RegisterMark(Result, Result, Group.Caption, ACaption);
end;

procedure TSolverOptionsPanel.BuildOptionsTab;
var
  Tab: TScrollBox;
  Group: TGroupBox;
begin
  Tab := AddScrollTab('Options');

  // Groups are alTop, so they are created in reverse display order.
  FPivotMode := AddFlags(Tab, 'Pivot Mode', [
    Flag('Primal Fall Back', 4), Flag('Multiple', 8), Flag('Partial', 16),
    Flag('Adaptive', 32), Flag('Hybrid', 64), Flag('Randomize', 128),
    Flag('AutoPartial', 256), Flag('AutoMultiple', 512),
    Flag('LoopLeft', 1024), Flag('LoopAlternate', 2048),
    Flag('HarrisTwoPass', 4096), Flag('True Norm Init', 16384)], 4);
  Group := AddFields(Tab, 'Pivot');
  FPivotRule := AddCombo(Group, 'Pivot Rule',
    ['First Index', 'Dantzig', 'Devex', 'Steepest Edge']);
  FMaxPivot := AddEdit(Group, 'Max Pivot');
  FPartialPrice := AddEdit(Group, 'Partial Price');
  FPartialPriceRows := AddCheck(Group, 'Partial Price Rows');
  // Empty label keeps the two-column label/control pairing aligned.
  TLabel.Create(Self).Parent := Group;
  FMultiPrice := AddEdit(Group, 'Multi Price');

  FScaleMode := AddFlags(Tab, 'Scale Mode', [
    Flag('Quadratic', 8), Flag('Logarithmic', 16), Flag('Power2', 32),
    Flag('Equilibrate', 64), Flag('Integers', 128), Flag('DynUpdate', 256),
    Flag('RowsOnly', 512), Flag('ColsOnly', 1024)], 4);
  Group := AddFields(Tab, 'Scale');
  FScaleType := AddCombo(Group, 'Scale Type', ['Linear', 'Extreme', 'Range',
    'Mean', 'Geometric', 'Future1', 'Future2', 'Curtis-Reid']);
  FScaleLimit := AddEdit(Group, 'Scale Limit');

  FBBMode := AddFlags(Tab, 'BB Rule Mode', [
    Flag('Weight Reverse', 8), Flag('Branch Reverse', 16), Flag('Greedy', 32),
    Flag('Pseudo Cost', 64), Flag('Depth First', 128), Flag('Randomize', 256),
    Flag('Gub', 512), Flag('Dynamic', 1024), Flag('Restart', 2048),
    Flag('Breadth First', 4096), Flag('AutoOrder', 8192),
    Flag('RCostFixing', 16384), Flag('StrongInit', 32768)], 4);
  Group := AddFields(Tab, 'Branch & Bound');
  FBBRuleSelect := AddCombo(Group, 'BB Rule Select', ['First', 'Gap', 'Range',
    'Fraction', 'Pseudo Cost', 'Pseudo Non Int', 'Pseudo Ratio', 'User']);
  FBBFloorFirst := AddCombo(Group, 'BB Floor First',
    ['Ceiling', 'Floor', 'Automatic']);
  FDepthLimit := AddEdit(Group, 'Depth Limit');
  FObjBound := AddEdit(Group, 'Obj Bound');
  FMipGapAbs := AddEdit(Group, 'MIP Gap Abs');
  FMipGapRel := AddEdit(Group, 'MIP Gap Rel');
  FVarBranch := AddCombo(Group, 'Var Branch',
    ['Ceiling', 'Floor', 'Automatic']);
end;

procedure TSolverOptionsPanel.BuildAdvancedTab;
var
  Tab: TScrollBox;
  Group: TGroupBox;
begin
  Tab := AddScrollTab('Advanced');

  FAntiDegen := AddFlags(Tab, 'Anti Degen', [
    Flag('Fixed vars', 1), Flag('Column Check', 2), Flag('Stalling', 4),
    Flag('Num Failure', 8), Flag('Lost Feas', 16), Flag('Infeasible', 32),
    Flag('Dynamic', 64), Flag('DuringBB', 128), Flag('RhsPerturb', 256),
    Flag('BoundFlip', 512)], 4);
  FPresolve := AddFlags(Tab, 'Presolve', [
    Flag('Rows', 1), Flag('Cols', 2), Flag('Lindep', 4), Flag('Aggregate', 8),
    Flag('Sparser', 16), Flag('SOS', 32), Flag('Reduce MIP', 64),
    Flag('KnapSack', 128), Flag('Elimeq2', 256), Flag('ImpliedFree', 512),
    Flag('Reduce GCD', 1024), Flag('ProbeFix', 2048),
    Flag('ProbeReduce', 4096), Flag('RowDominate', 8192),
    Flag('ColDominate', 16384), Flag('MergeRows', 32768),
    Flag('Implied SLK', 65536), Flag('ColFixDual', 131072),
    Flag('Bounds', 262144), Flag('Duals', 524288),
    Flag('Sens Duals', 1048576)], 4);
  Group := AddFields(Tab, 'Tolerances and limits');
  FBasisCrash := AddCombo(Group, 'Basis Crash', ['Nothing', 'Non Basic Bounds',
    'Most Feasible', 'Least Degenerate']);
  FSimplexType := AddCombo(Group, 'Simplex Type',
    ['Primal Primal', 'Dual Primal', 'Primal Dual', 'Dual Dual']);
  FSolutionLimit := AddEdit(Group, 'Solution Limit');
  FTimeout := AddEdit(Group, 'Timeout');
  FInfinite := AddEdit(Group, 'Infinite');
  FEpsb := AddEdit(Group, 'EPSB');
  FEpsd := AddEdit(Group, 'EPSD');
  FEpsel := AddEdit(Group, 'EPSEL');
  FEpsInt := AddEdit(Group, 'EPS Int');
  FEpsPerturb := AddEdit(Group, 'EPS Perturb');
  FEpsPivot := AddEdit(Group, 'EPS Pivot');
  FBreakAtValue := AddEdit(Group, 'Break at Value');
  FNegRange := AddEdit(Group, 'Neg Range');
  FEpsLevel := AddCombo(Group, 'EPS Level', ['Tight', 'Medium', 'Loose', 'Baggy']);
  FPresolveLoops := AddEdit(Group, 'Presolve Loops');
  FImprove := AddFlags(Tab, 'Improve', [
    Flag('Solution', 1), Flag('DualFeas', 2), Flag('ThetaGap', 4),
    Flag('BBSimplex', 8)], 4);
  Group := AddFields(Tab, 'General');
  FBoundsTighter := AddCheck(Group, 'Bounds Tighter');
  FBreakAtFirst := AddCheck(Group, 'Break at first');
end;

procedure TSolverOptionsPanel.BuildMessagesTab;
var
  Tab: TScrollBox;
  Group: TGroupBox;
begin
  Tab := AddScrollTab('Output');

  FMessages := AddFields(Tab, 'Messages');
  FMessages.ChildSizing.ControlsPerLine := 4;
  FVerbose := AddCombo(FMessages, 'Verbose', ['Neutral', 'Critical', 'Severe',
    'Important', 'Normal', 'Detailed', 'Full']);
  // Empty labels fill the rest of the row so the flags start on a new line.
  TLabel.Create(Self).Parent := FMessages;
  TLabel.Create(Self).Parent := FMessages;
  AddFlagBoxes(FMessages, [
    Flag('Presolve', 1), Flag('Iteration', 2), Flag('Invert', 4),
    Flag('Lp Feasible', 8), Flag('Lp Optimal', 16), Flag('Lp Equal', 32),
    Flag('Lp Better', 64), Flag('Mipl Feasible', 128),
    Flag('Mipl Equal', 256), Flag('Mipl Better', 512),
    Flag('Mipl Strategy', 1024), Flag('Mipl Optimal', 2048),
    Flag('Performance', 4096), Flag('Init Pseudo Cost', 8192)]);
  Group := AddFields(Tab, 'Debugging');
  FDebug := AddCheck(Group, 'Debug');
  FTrace := AddCheck(Group, 'Trace');
  FLagTrace := AddCheck(Group, 'Lag Trace');
  Group := AddFields(Tab, 'Solutions');
  FShowAllIntSolutions := AddCheck(Group, 'Show all integer solutions');
  FShowNonNull := AddCheck(Group, 'Show only non-null values');
  FPrintSol := AddCombo(Group, 'Print Sol',
    ['False', 'True', 'Automatic', 'Dynamic']);
end;

function TSolverOptionsPanel.GetFlags(Group: TGroupBox): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Group.ControlCount - 1 do
    if (Group.Controls[I] is TCheckBox) and
       TCheckBox(Group.Controls[I]).Checked then
      Result := Result or Group.Controls[I].Tag;
end;

procedure TSolverOptionsPanel.SetFlags(Group: TGroupBox; Value: Integer);
var
  I: Integer;
begin
  for I := 0 to Group.ControlCount - 1 do
    if Group.Controls[I] is TCheckBox then
      TCheckBox(Group.Controls[I]).Checked :=
        (Value and Group.Controls[I].Tag) <> 0;
end;

procedure TSolverOptionsPanel.ReadInt(Edit: TEdit; const FieldName: string;
  var Value: Integer; var Error: string);
var
  Parsed: Integer;
begin
  if TryStrToInt(Trim(Edit.Text), Parsed) then
    Value := Parsed
  else if Error = '' then
    Error := Format('"%s" must be an integer number.', [FieldName]);
end;

procedure TSolverOptionsPanel.ReadFloat(Edit: TEdit; const FieldName: string;
  var Value: Double; var Error: string);
var
  Parsed: Double;
begin
  if SolverTryStrToFloat(Edit.Text, Parsed) then
    Value := Parsed
  else if Error = '' then
    Error := Format('"%s" must be a number.', [FieldName]);
end;

procedure TSolverOptionsPanel.ShowOptions(const Opts: TSolverOptions);
begin
  SetFlags(FAntiDegen, Opts.AntiDegen);
  SetFlags(FPresolve, Opts.Presolve);
  SetFlags(FImprove, Opts.Improve);
  SetFlags(FMessages, Opts.Messages);
  SetFlags(FBBMode, Opts.BBRule and not 7);
  FBBRuleSelect.ItemIndex := Opts.BBRule and 7;
  SetFlags(FScaleMode, Opts.Scaling and not 7);
  FScaleType.ItemIndex := Opts.Scaling and 7;
  SetFlags(FPivotMode, Opts.Pivoting and not 3);
  FPivotRule.ItemIndex := Opts.Pivoting and 3;
  FBasisCrash.ItemIndex := Opts.BasisCrash;
  FSimplexType.ItemIndex := 1;
  if Opts.SimplexType = SIMPLEX_TYPE_VALUES[0] then
    FSimplexType.ItemIndex := 0
  else if Opts.SimplexType = SIMPLEX_TYPE_VALUES[2] then
    FSimplexType.ItemIndex := 2
  else if Opts.SimplexType = SIMPLEX_TYPE_VALUES[3] then
    FSimplexType.ItemIndex := 3;
  FBBFloorFirst.ItemIndex := Opts.BBFloorFirst;
  if FBBFloorFirst.ItemIndex >= FBBFloorFirst.Items.Count then
    FBBFloorFirst.ItemIndex := -1;
  FPrintSol.ItemIndex := Opts.PrintSol;
  FVerbose.ItemIndex := Opts.Verbose;
  FDepthLimit.Text := IntToStr(Opts.BBDepthLimit);
  FSolutionLimit.Text := IntToStr(Opts.SolutionLimit);
  FTimeout.Text := IntToStr(Opts.Timeout);
  FMaxPivot.Text := IntToStr(Opts.MaxPivot);
  FBreakAtFirst.Checked := Opts.BreakAtFirst;
  FShowAllIntSolutions.Checked := Opts.ShowAllIntegerSolutions;
  FShowNonNull.Checked := Opts.ShowOnlyNonNullValues;
  FBoundsTighter.Checked := Opts.BoundsTighter;
  FDebug.Checked := Opts.Debug;
  FTrace.Checked := Opts.Trace;
  FLagTrace.Checked := Opts.LagTrace;
  FObjBound.Text := SolverFloatToStr(Opts.ObjBound);
  FInfinite.Text := SolverFloatToStr(Opts.Infinite);
  FEpsb.Text := SolverFloatToStr(Opts.Epsb);
  FEpsd.Text := SolverFloatToStr(Opts.Epsd);
  FEpsel.Text := SolverFloatToStr(Opts.Epsel);
  FEpsInt.Text := SolverFloatToStr(Opts.EpsInt);
  FEpsPerturb.Text := SolverFloatToStr(Opts.EpsPerturb);
  FEpsPivot.Text := SolverFloatToStr(Opts.EpsPivot);
  FScaleLimit.Text := SolverFloatToStr(Opts.ScaleLimit);
  FBreakAtValue.Text := SolverFloatToStr(Opts.BreakAtValue);
  FNegRange.Text := SolverFloatToStr(Opts.NegRange);
  FMipGapAbs.Text := SolverFloatToStr(Opts.MipGapAbs);
  FMipGapRel.Text := SolverFloatToStr(Opts.MipGapRel);
  FEpsLevel.ItemIndex := Opts.EpsLevel;
  FPartialPrice.Text := IntToStr(Opts.PartialPrice);
  FPartialPriceRows.Checked := Opts.PartialPriceRows;
  FMultiPrice.Text := IntToStr(Opts.MultiPrice);
  FPresolveLoops.Text := IntToStr(Opts.PresolveLoops);
  FVarBranch.ItemIndex := Opts.VarBranch;
  if FVarBranch.ItemIndex >= FVarBranch.Items.Count then
    FVarBranch.ItemIndex := -1;
  // Values shown when the program starts are the reference for "modified".
  if not FBaselineSet then
  begin
    FBaselineSet := True;
    CommitBaseline;
  end
  else
    RefreshMarks;
end;

function TSolverOptionsPanel.TryGetOptions(var Opts: TSolverOptions;
  out Error: string): Boolean;
var
  NewOptions: TSolverOptions;
begin
  Error := '';
  NewOptions := Opts;
  NewOptions.AntiDegen := GetFlags(FAntiDegen);
  NewOptions.Presolve := GetFlags(FPresolve);
  NewOptions.Improve := GetFlags(FImprove);
  NewOptions.Messages := GetFlags(FMessages);
  NewOptions.BBRule := GetFlags(FBBMode) or FBBRuleSelect.ItemIndex;
  NewOptions.Scaling := GetFlags(FScaleMode) or FScaleType.ItemIndex;
  NewOptions.Pivoting := GetFlags(FPivotMode) or FPivotRule.ItemIndex;
  NewOptions.BasisCrash := FBasisCrash.ItemIndex;
  NewOptions.SimplexType := SIMPLEX_TYPE_VALUES[FSimplexType.ItemIndex];
  if FBBFloorFirst.ItemIndex >= 0 then
    NewOptions.BBFloorFirst := FBBFloorFirst.ItemIndex;
  NewOptions.PrintSol := FPrintSol.ItemIndex;
  NewOptions.Verbose := FVerbose.ItemIndex;
  NewOptions.BreakAtFirst := FBreakAtFirst.Checked;
  NewOptions.ShowAllIntegerSolutions := FShowAllIntSolutions.Checked;
  NewOptions.ShowOnlyNonNullValues := FShowNonNull.Checked;
  NewOptions.BoundsTighter := FBoundsTighter.Checked;
  NewOptions.Debug := FDebug.Checked;
  NewOptions.Trace := FTrace.Checked;
  NewOptions.LagTrace := FLagTrace.Checked;

  ReadInt(FDepthLimit, 'Depth Limit', NewOptions.BBDepthLimit, Error);
  ReadInt(FSolutionLimit, 'Solution Limit', NewOptions.SolutionLimit, Error);
  ReadInt(FTimeout, 'Timeout', NewOptions.Timeout, Error);
  ReadInt(FMaxPivot, 'Max Pivot', NewOptions.MaxPivot, Error);
  ReadFloat(FObjBound, 'Obj Bound', NewOptions.ObjBound, Error);
  ReadFloat(FInfinite, 'Infinite', NewOptions.Infinite, Error);
  ReadFloat(FEpsb, 'EPSB', NewOptions.Epsb, Error);
  ReadFloat(FEpsd, 'EPSD', NewOptions.Epsd, Error);
  ReadFloat(FEpsel, 'EPSEL', NewOptions.Epsel, Error);
  ReadFloat(FEpsInt, 'EPS Int', NewOptions.EpsInt, Error);
  ReadFloat(FEpsPerturb, 'EPS Perturb', NewOptions.EpsPerturb, Error);
  ReadFloat(FEpsPivot, 'EPS Pivot', NewOptions.EpsPivot, Error);
  ReadFloat(FScaleLimit, 'Scale Limit', NewOptions.ScaleLimit, Error);
  ReadFloat(FBreakAtValue, 'Break at Value', NewOptions.BreakAtValue, Error);
  ReadFloat(FNegRange, 'Neg Range', NewOptions.NegRange, Error);
  ReadFloat(FMipGapAbs, 'MIP Gap Abs', NewOptions.MipGapAbs, Error);
  ReadFloat(FMipGapRel, 'MIP Gap Rel', NewOptions.MipGapRel, Error);
  ReadInt(FPartialPrice, 'Partial Price', NewOptions.PartialPrice, Error);
  ReadInt(FMultiPrice, 'Multi Price', NewOptions.MultiPrice, Error);
  ReadInt(FPresolveLoops, 'Presolve Loops', NewOptions.PresolveLoops, Error);
  NewOptions.EpsLevel := FEpsLevel.ItemIndex;
  NewOptions.PartialPriceRows := FPartialPriceRows.Checked;
  if FVarBranch.ItemIndex >= 0 then
    NewOptions.VarBranch := FVarBranch.ItemIndex;

  Result := Error = '';
  if Result then
    Opts := NewOptions;
end;

end.
