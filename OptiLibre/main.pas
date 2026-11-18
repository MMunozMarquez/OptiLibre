unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Math, Forms, Controls, Dialogs, Menus, ComCtrls, ExtCtrls,
  ActnList, Buttons,
  LCLType,
  StdCtrls, SynEdit, SynEditTypes, SynHighlighterPas, LPModelHighlighter,
  IniFiles,
  SynEditExport,
  SynExportHTML, Graphics, ImgList, Grids,
  dlgAbout, dlgSearchText, dlgReplaceText, dlgGotoLineNumber, dlgHelp, lpsolve,
  MathProgReader, MathProgWriter, ResultArray, SolverOptions, OptionsPanel
  {$IFDEF MSWINDOWS}, UnicodeHelper{$ENDIF};

type

  TSourceExportFormat = (sefHTML, sefRTF, sefTeX);
  TResultExportFormat = (refCSV, refHTML, refRTF);
  TMatrixExportFormat = (mefCSV, mefHTML, mefRTF);

  TScriptFormat = (sfMPS, sfFreeMPS, sfLP, sfXLI, sfMathProg);

  { TMainForm }

  TMainForm = class(TForm)
    BottomPanel: TPanel;
    Editor: TSynEdit;
    Matrix: TTabSheet;
    MemoLog: TSynEdit;
    MemoMessages: TSynEdit;
    Priority: TComboBox;
    PriorityLabel: TLabel;
    PriorityPanel: TPanel;
    PageControl: TPageControl;
    PageControl2: TPageControl;
    Splitter1: TSplitter;
    StatusBar: TStatusBar;
    TabSheet2: TTabSheet;
    TabSheetEditor: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheetOptions: TTabSheet;
    SynPasSyn1: TSynPasSyn;
    TopPanel: TPanel;
    ToolBar1: TToolBar;
    ToolButton11: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton14: TToolButton;
    ToolButton17: TToolButton;
    ToolButton13: TToolButton;
    ToolButton4: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton12: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    MainMenu: TMainMenu;
    OutputPopupMenu: TPopupMenu;
    ClearOutput1: TMenuItem;
    mFile: TMenuItem;
    NewFile: TMenuItem;
    NewLPscript1: TMenuItem;
    NewFixedMPSscript1: TMenuItem;
    NewFreeMPSscript1: TMenuItem;
    NewMathProgScript1: TMenuItem;
    Open1: TMenuItem;
    Save2: TMenuItem;
    Save1: TMenuItem;
    Export1: TMenuItem;
    ExporttoHtml1: TMenuItem;
    ExporttoRtf1: TMenuItem;
    ExporttoTex1: TMenuItem;
    ExportMatrice1: TMenuItem;
    acMatExpCsv1: TMenuItem;
    acMatExpHtml1: TMenuItem;
    acMatExpRtf1: TMenuItem;
    Result1: TMenuItem;
    ExporttoCSV1: TMenuItem;
    ExporttoHTML2: TMenuItem;
    ExporttoRTF2: TMenuItem;
    N7: TMenuItem;
    ExporttoCSV2: TMenuItem;
    ExporttoHTML3: TMenuItem;
    ExporttoRTF3: TMenuItem;
    Sensitivity1: TMenuItem;
    ObjectivetoCSV1: TMenuItem;
    ObjectivetoHTML1: TMenuItem;
    ObjectivetoRTF1: TMenuItem;
    N6: TMenuItem;
    ObjectivetoCSV2: TMenuItem;
    ObjectivetoHTML2: TMenuItem;
    ObjectivetoRTF2: TMenuItem;
    Quit1: TMenuItem;
    Edit1: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    N1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    Search1: TMenuItem;
    Search2: TMenuItem;
    Searchagain1: TMenuItem;
    Findprevious1: TMenuItem;
    Replace1: TMenuItem;
    N4: TMenuItem;
    Gotolinenumber1: TMenuItem;
    Problem1: TMenuItem;
    Solve1: TMenuItem;
    SolveRelaxed1: TMenuItem;
    LoadBasis1: TMenuItem;
    Stop1: TMenuItem;
    SyntaxCheck1: TMenuItem;
    Statistics1: TMenuItem;
    Savebasis1: TMenuItem;
    View: TMenuItem;
    LP1: TMenuItem;
    MPS1: TMenuItem;
    FreeMPS1: TMenuItem;
    MathProg1: TMenuItem;
    Options1: TMenuItem;
    Saveoptions1: TMenuItem;
    Loadoptions1: TMenuItem;
    N5: TMenuItem;
    Saveasdefault1: TMenuItem;
    SolverMenu1: TMenuItem;
    DisplayMenu1: TMenuItem;
    SaveDisplaySettings1: TMenuItem;
    LoadDisplaySettings1: TMenuItem;
    IncreaseFont1: TMenuItem;
    DecreaseFont1: TMenuItem;
    ResetFont1: TMenuItem;
    ClearOutputOnSolve1: TMenuItem;
    N8: TMenuItem;
    Resetoptions1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Help2: TMenuItem;
    ActionList1: TActionList;
    acNew: TAction;
    acNewLP: TAction;
    acNewFixedMPS: TAction;
    acNewFreeMPS: TAction;
    acNewMathProg: TAction;
    acOpen: TAction;
    acSave: TAction;
    acSaveAs: TAction;
    OpenDialogScript: TOpenDialog;
    OpenDialogBasis: TOpenDialog;
    SaveDialogScript: TSaveDialog;
    SaveDialogBasis: TSaveDialog;
    ExportDialog: TSaveDialog;
    acSolve: TAction;
    acSolveBasis: TAction;
    acSolveRelaxed: TAction;
    acStop: TAction;
    acUndo: TAction;
    acRedo: TAction;
    acFind: TAction;
    acFindPrev: TAction;
    acFindNext: TAction;
    acReplace: TAction;
    ImageList: TImageList;
    MenuImageList: TImageList;
    procedure MenuCommandClick(Sender: TObject);
    procedure ViewFormatClick(Sender: TObject);
    procedure MenuHelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SaveOptionsClick(Sender: TObject);
    procedure LoadOptionsClick(Sender: TObject);
    procedure SaveDefaultOptionsClick(Sender: TObject);
    procedure ResetOptionsClick(Sender: TObject);
    procedure ClearOutput1Click(Sender: TObject);
    procedure ClearOutputOnSolveClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acOpenExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acSolveExecute(Sender: TObject);
    procedure acSolveBasisExecute(Sender: TObject);
    procedure acSolveRelaxedExecute(Sender: TObject);
    procedure acSaveBasisExecute(Sender: TObject);
    procedure acSyntaxCheckExecute(Sender: TObject);
    procedure acStopExecute(Sender: TObject);
    procedure PriorityChange(Sender: TObject);
    procedure PriorityDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure acNewLPExecute(Sender: TObject);
    procedure acMatExpCsvExecute(Sender: TObject);
    procedure acMatExpHtmlExecute(Sender: TObject);
    procedure acMatExpRtfExecute(Sender: TObject);
    procedure acExportHTMLExecute(Sender: TObject);
    procedure acExportRtfExecute(Sender: TObject);
    procedure acExportTexExecute(Sender: TObject);
    procedure ResultExportClick(Sender: TObject);
    procedure acNewFixedMPSExecute(Sender: TObject);
    procedure acNewFreeMPSExecute(Sender: TObject);
    procedure acNewMathProgExecute(Sender: TObject);
    procedure acQuitExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PriorityPanelClick(Sender: TObject);
    procedure EditorChange(Sender: TObject);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure StatusBarDrawPanel(AStatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure StatusBarMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure acUndoExecute(Sender: TObject);
    procedure acRedoExecute(Sender: TObject);
    procedure EditCutClick(Sender: TObject);
    procedure EditCopyClick(Sender: TObject);
    procedure EditPasteClick(Sender: TObject);
    procedure SearchDialogSearch(Sender: TObject);
    procedure ReplaceTextDialogAction(Sender: TObject;
      AAction: TReplaceTextAction);
    procedure acFindExecute(Sender: TObject);
    procedure acFindNextExecute(Sender: TObject);
    procedure acFindPrevExecute(Sender: TObject);
    procedure acReplaceExecute(Sender: TObject);
    procedure GoToLineNumberClick(Sender: TObject);
  private
    FCurrentFile: TFileName;
    FEditorBaseline: string;
    FDataFile: TFileName;
    FDataBaseline: string;
    FUseDataFile: Boolean;
    FDataTab: TTabSheet;
    FDataEditor: TSynEdit;
    FFontSize, FDefaultFontSize, FSavedFontSize: Integer;
    FClearOutputOnSolve: Boolean;
    FSavedClearOutputOnSolve: Boolean;
    FGridBaseFontSize, FGridBaseRowHeight, FGridBaseTextHeight: Integer;
    FDisplayDialogSave: TSaveDialog;
    FDisplayDialogOpen: TOpenDialog;
    FLastOpenFile: string;
    FLastLineCount: Integer;
    FScriptFormat: TScriptFormat;
    FModelHighlighter: TLPModelHighlighter;
    FCloseQueryActive: Boolean;
    FCloseApproved: Boolean;
    FSearchDialog: TdlgSearchText;
    FReplaceDialog: TdlgReplaceText;
    FGotoLineDialog: TdlgGotoLineNumber;
    FOptions: TSolverOptions;
    FSavedOptions: TSolverOptions;
    FOptionsCorrected: Boolean;
    FOptionsPanel: TSolverOptionsPanel;
    FOptionsDialogSave: TSaveDialog;
    FOptionsDialogOpen: TOpenDialog;
    FSearchText: string;
    FSearchOptions: TSynSearchOptions;
    FSearchControl: TWinControl;
    FSearchHighlightGrid: TStringGrid;
    FSearchHighlightRow: Integer;
    FSearchHighlightCol: Integer;
    FIsSolving: Boolean;
    FAbortRequested: Boolean;
    FQuitAfterSolve: Boolean;
    FPendingOpenFile: string;
    FPendingBasisFile: string;
    FRelaxIntegers: Boolean;
    FLastSolvedLP: THandle;
    FResultPopup: TPopupMenu;
    FFilterEdit: TEdit;
    FShowAllItem, FShowAllItem2, FNonNullItem: TMenuItem;
    FResultPopup2: TPopupMenu;
    FResultInfinite: Double;
    FVarNames, FRowNames: TStringList;
    FObjSensOwner, FRHSSensOwner: array of Integer;
    FLastSolvedSource: string;
    FLastSolvedFormat: TScriptFormat;
    FLastAbortCheck: QWord;
    FInvertCount: Integer;
    FHasIntegerVariables: Boolean;
    FIntegerBestCount: Integer;
    FIntegerSolutionCaptureError: string;
    FBestIterationGap: Double;
    FRootBound: Double;
    FHasRootBound: Boolean;
    FFinalReportedGap: string;
    FObjectives: TResultArray;
    FConstraints: TResultArray;
    FObjectivesSens: TResultArray;
    FRHSSens: TResultArray;
    FResultHeaders: TStringList;
    FResultSortAscending: array[0..3] of Boolean;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    PageControl3: TPageControl;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    ObjectiveTable: TStringGrid;
    ConstraintTable: TStringGrid;
    ObjectiveSensTable: TStringGrid;
    RHSSensTable: TStringGrid;
    MatrixTable: TStringGrid;
    MatrixStatusLabel: TLabel;
    FMatrixDirty: Boolean;
    procedure CreateResultsUI;
    procedure CreateMatrixUI;
    procedure ClearMatrix;
    procedure ExportSource(Format: TSourceExportFormat;
      const Extension, Filter: string);
    procedure ExportResult(Grid: TStringGrid; Format: TResultExportFormat;
      const NameSuffix: string);
    procedure ExportMatrix(Format: TMatrixExportFormat);
    procedure UpdateMatrix;
    procedure PageControlChange(Sender: TObject);
    procedure MatrixGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      ARect: TRect; AState: TGridDrawState);
    function CollectOptions: Boolean;
    function OptionsModified: Boolean;
    function ConfirmSaveOptions: Boolean;
    function DefaultOptionsFile: string;
    function UISettingsFile: string;
    procedure ApplyFontSize;
    procedure ChangeFontSize(Delta: Integer);
    function ConfirmSaveDisplaySettings: Boolean;
    procedure SaveDisplaySettings(const FileName: string);
    function LoadDisplaySettings(const FileName: string): Boolean;
    procedure SaveDisplaySettingsClick(Sender: TObject);
    procedure LoadDisplaySettingsClick(Sender: TObject);
    procedure UpdateClearOutputOnSolveItem;
    procedure FontSizeClick(Sender: TObject);
    procedure EditorMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    function LoadLPFromEditor(var TempFile, MathProgMPSFile: string;
      out LoadError: string; Verbose: Integer;
      const DataFileOverride: string = ''; UseDataFileOverride: Boolean = False): THandle;
    procedure ConfigureResultGrid(Grid: TStringGrid; ParentPage: TTabSheet;
      const FirstColumnTitle: string; SortIndex: Integer);
    procedure AutoSizeResultColumns(Grid: TStringGrid);
    procedure ObjectiveTableHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure ConstraintTableHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure ObjectiveSensTableHeaderClick(Sender: TObject;
      IsColumn: Boolean; Index: Integer);
    procedure RHSSensTableHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure ResultGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      ARect: TRect; AState: TGridDrawState);
    procedure SortResultGrid(Grid: TStringGrid; Column, SortIndex: Integer);
    procedure AddCurrentResult(LP: PtrUInt; const Header: string;
      IncludeSensitivity: Boolean = True);
    procedure UpdateResultTables(LP: PtrUInt);
    procedure RenderResultTables;
    procedure CreateResultPopupMenu;
    procedure ShowAllIntegerSolutionsChanged(Sender: TObject);
    procedure ShowAllItemClick(Sender: TObject);
    procedure NonNullItemClick(Sender: TObject);
    procedure ClearResultTables;
    procedure HideFilterEdit;
    procedure ApplyResultFilter(Grid: TStringGrid);
    function FilterRowClicked(Grid: TStringGrid): Boolean;
    procedure ResultGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResultGridLayoutChanged(Sender: TObject);
    procedure ResultGridHeaderSized(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure FocusFilterEdit(Data: PtrInt);
    procedure FilterEditChange(Sender: TObject);
    procedure FilterEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FilterEditExit(Sender: TObject);
    procedure UpdateEditorStatus;
    procedure UpdateUndoRedoActions;
    procedure UpdateSearchActions;
    procedure InitializeSearchDialog;
    procedure EnsureSearchControl;
    function SearchEditor(ContinueSearch, Backwards: Boolean): Integer;
    function SearchSynEdit(Target: TSynEdit; ContinueSearch,
      Backwards: Boolean): Integer;
    function SearchGrid(Target: TStringGrid; ContinueSearch,
      Backwards: Boolean): Integer;
    function SearchCurrentTarget(ContinueSearch, Backwards: Boolean): Integer;
    procedure SearchControlEnter(Sender: TObject);
    procedure ReportSearchResult(FoundCount: Integer);
    procedure UpdateViewFormat;
    procedure SelectViewFormat;
    function ConvertModelFormat(var NewFormat: TScriptFormat): Boolean;
    procedure UpdateGapDisplay(GapPercent: Double);
    procedure UpdateGapFromSolver(LP: PtrUInt; CaptureRoot: Boolean);
    procedure SetCurrentFile(filename: string);
    procedure CheckGutter;
    procedure NewScript(ScFormat: TScriptFormat);
    procedure SolverLog(Log: PChar);
    procedure SolverAbort(var Abort: Boolean);
    procedure SolverProgress(LP: PtrUInt; Message: Integer);
    procedure RequestQuitDuringSolve;
    procedure OpenFile(const Filename: string);
    procedure LoadDataFile(const Filename: string;
      KeepModelEditorActive: Boolean = False);
    function PrepareMathProgData: Boolean;
    procedure UpdateDataTabColor;
    procedure EnsureDataEditor;
    function ActiveEditor: TSynEdit;
    function ConfirmSaveChanges(ConfirmData: Boolean = True): Boolean;
    function ConfirmDataChanges: Boolean;
    function CloseDataEditor: Boolean;
    function SaveCurrentFile: Boolean;
    function SaveFileAs: Boolean;
    function SaveCurrentDataFile: Boolean;
    function SaveDataFileAs: Boolean;
  public
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{$PUSH}
{$HINTS OFF}
function SolverAbortCallback(LP: PtrUInt;
  UserHandle: Pointer): Integer; stdcall;
var
  Abort: Boolean;
begin
  Abort := False;
  TMainForm(UserHandle).SolverAbort(Abort);
  if Abort then
    Result := 1
  else
    Result := 0;
end;
{$POP}

{$PUSH}
{$HINTS OFF}
procedure SolverLogCallback(LP: PtrUInt; UserHandle: Pointer;
  Buffer: PChar); stdcall;
begin
  if Buffer <> nil then
    TMainForm(UserHandle).SolverLog(Buffer);
end;
{$POP}

{$PUSH}
{$HINTS OFF}
procedure SolverMessageCallback(LP: PtrUInt; UserHandle: Pointer;
  Message: Integer); stdcall;
begin
  TMainForm(UserHandle).SolverProgress(LP, Message);
end;
{$POP}

function MessageDlgEnglish(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: LongInt): Integer;
var
  Dialog: TForm;
  I: Integer;
begin
  Dialog := CreateMessageDialog(Msg, DlgType, Buttons);
  try
    Dialog.HelpContext := HelpCtx;
    for I := 0 to Dialog.ComponentCount - 1 do
      if Dialog.Components[I] is TBitBtn then
        case TBitBtn(Dialog.Components[I]).ModalResult of
          mrOk: TBitBtn(Dialog.Components[I]).Caption := 'OK';
          mrCancel: TBitBtn(Dialog.Components[I]).Caption := 'Cancel';
          mrYes: TBitBtn(Dialog.Components[I]).Caption := 'Yes';
          mrNo: TBitBtn(Dialog.Components[I]).Caption := 'No';
        end;
    Result := Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

function NormalizeMessageLineBreaks(const Value: string): string;
begin
  Result := StringReplace(Value, '\\r\\n', LineEnding, [rfReplaceAll]);
  Result := StringReplace(Result, '\\n', LineEnding, [rfReplaceAll]);
  Result := StringReplace(Result, '\\r', LineEnding, [rfReplaceAll]);
  Result := StringReplace(Result, '\r\n', LineEnding, [rfReplaceAll]);
  Result := StringReplace(Result, '\n', LineEnding, [rfReplaceAll]);
  Result := StringReplace(Result, '\r', LineEnding, [rfReplaceAll]);
end;

procedure AddMessageText(Lines: TStrings; const Value: string);
var
  MessageLines: TStringList;
begin
  MessageLines := TStringList.Create;
  try
    MessageLines.Text := NormalizeMessageLineBreaks(Value);
    if MessageLines.Count = 0 then
      Lines.Add('')
    else
      Lines.AddStrings(MessageLines);
  finally
    MessageLines.Free;
  end;
end;

procedure ReportOptionProblems(Problems: TStrings);
begin
  if Problems.Count > 0 then
    MessageDlgEnglish('Some options in the file have invalid values:' +
      LineEnding + LineEnding + Problems.Text, mtWarning, [mbOK], 0);
end;

procedure TMainForm.CreateResultsUI;
begin
  TabSheet2.Caption := 'Results';

  PageControl1 := TPageControl.Create(Self);
  PageControl1.Parent := TabSheet2;
  PageControl1.Align := alClient;

  TabSheet3 := TTabSheet.Create(Self);
  TabSheet3.PageControl := PageControl1;
  TabSheet3.Caption := 'Objective';
  ObjectiveTable := TStringGrid.Create(Self);
  ConfigureResultGrid(ObjectiveTable, TabSheet3, 'Variables', 0);
  ObjectiveTable.OnHeaderClick := @ObjectiveTableHeaderClick;
  ObjectiveTable.OnDrawCell := @ResultGridDrawCell;
  ObjectiveTable.OnEnter := @SearchControlEnter;

  TabSheet4 := TTabSheet.Create(Self);
  TabSheet4.PageControl := PageControl1;
  TabSheet4.Caption := 'Constraints';
  ConstraintTable := TStringGrid.Create(Self);
  ConfigureResultGrid(ConstraintTable, TabSheet4, 'Constraints', 1);
  ConstraintTable.OnHeaderClick := @ConstraintTableHeaderClick;
  ConstraintTable.OnDrawCell := @ResultGridDrawCell;
  ConstraintTable.OnEnter := @SearchControlEnter;

  TabSheet1 := TTabSheet.Create(Self);
  TabSheet1.PageControl := PageControl1;
  TabSheet1.Caption := 'Sensitivity';

  PageControl3 := TPageControl.Create(Self);
  PageControl3.Parent := TabSheet1;
  PageControl3.Align := alClient;

  TabSheet7 := TTabSheet.Create(Self);
  TabSheet7.PageControl := PageControl3;
  TabSheet7.Caption := 'Objective';
  ObjectiveSensTable := TStringGrid.Create(Self);
  ConfigureResultGrid(ObjectiveSensTable, TabSheet7, 'Variables', 2);
  ObjectiveSensTable.OnHeaderClick := @ObjectiveSensTableHeaderClick;
  ObjectiveSensTable.OnDrawCell := @ResultGridDrawCell;
  ObjectiveSensTable.OnEnter := @SearchControlEnter;

  TabSheet8 := TTabSheet.Create(Self);
  TabSheet8.PageControl := PageControl3;
  TabSheet8.Caption := 'Duals';
  RHSSensTable := TStringGrid.Create(Self);
  ConfigureResultGrid(RHSSensTable, TabSheet8, 'Constraints / Variables', 3);
  RHSSensTable.OnHeaderClick := @RHSSensTableHeaderClick;
  RHSSensTable.OnDrawCell := @ResultGridDrawCell;
  RHSSensTable.OnEnter := @SearchControlEnter;

  PageControl1.OnChange := @PageControlChange;
  PageControl3.OnChange := @PageControlChange;
  PageControl1.ActivePage := TabSheet3;
  PageControl3.ActivePage := TabSheet7;
  CreateResultPopupMenu;

  FFilterEdit := TEdit.Create(Self);
  FFilterEdit.Visible := False;
  FFilterEdit.Parent := ObjectiveTable;
  FFilterEdit.OnKeyDown := @FilterEditKeyDown;
  FFilterEdit.OnExit := @FilterEditExit;
end;

procedure TMainForm.ConfigureResultGrid(Grid: TStringGrid;
  ParentPage: TTabSheet; const FirstColumnTitle: string; SortIndex: Integer);
begin
  Grid.Parent := ParentPage;
  Grid.Align := alClient;
  Grid.FixedCols := 1;
  // Row 1 holds the column filters; row 2 is the objective row.
  Grid.ColCount := 2;
  Grid.RowCount := 3;
  Grid.FixedRows := 2;
  Grid.OnMouseDown := @ResultGridMouseDown;
  Grid.OnTopLeftChanged := @ResultGridLayoutChanged;
  Grid.OnHeaderSized := @ResultGridHeaderSized;
  Grid.DefaultColWidth := 120;
  Grid.Options := Grid.Options +
    [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine] -
    [goEditing, goRangeSelect];
  Grid.Cells[0, 0] := FirstColumnTitle;
  Grid.Cells[1, 0] := 'Result 1';
  FResultSortAscending[SortIndex] := True;
end;

procedure TMainForm.CreateMatrixUI;
var
  HeaderPanel: TPanel;
begin
  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Matrix;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 36;
  HeaderPanel.BevelOuter := bvNone;

  MatrixStatusLabel := TLabel.Create(Self);
  MatrixStatusLabel.Parent := HeaderPanel;
  MatrixStatusLabel.Align := alClient;
  MatrixStatusLabel.Layout := tlCenter;

  MatrixTable := TStringGrid.Create(Self);
  MatrixTable.Parent := Matrix;
  MatrixTable.Align := alClient;
  MatrixTable.FixedCols := 1;
  MatrixTable.FixedRows := 1;
  MatrixTable.ColCount := 2;
  MatrixTable.RowCount := 2;
  MatrixTable.DefaultColWidth := 100;
  MatrixTable.ColWidths[0] := 150;
  MatrixTable.Options := MatrixTable.Options +
    [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine] -
    [goEditing, goRangeSelect];
  MatrixTable.Cells[0, 0] := 'Row';
  MatrixTable.Cells[1, 0] := 'RHS';
  MatrixTable.OnDrawCell := @MatrixGridDrawCell;
  MatrixTable.OnEnter := @SearchControlEnter;
  FMatrixDirty := True;
end;

procedure TMainForm.ClearMatrix;
begin
  MatrixTable.ColCount := 2;
  MatrixTable.RowCount := 2;
  MatrixTable.Cells[0, 0] := 'Row';
  MatrixTable.Cells[1, 0] := 'RHS';
  MatrixTable.Cells[0, 1] := '';
  MatrixTable.Cells[1, 1] := '';
  MatrixStatusLabel.Caption := '';
  FMatrixDirty := True;
end;

procedure TMainForm.UpdateMatrix;
var
  LP: THandle;
  TempFile, MathProgMPSFile, LoadError: string;
  RowCount, ColumnCount, Row, Column: Integer;
  ModelName: PChar;
begin
  if FIsSolving then
    Exit;

  LP := 0;
  TempFile := '';
  MathProgMPSFile := '';
  LoadError := '';
  Screen.Cursor := crHourGlass;
  try
    try
      LP := LoadLPFromEditor(TempFile, MathProgMPSFile, LoadError, NEUTRAL);
      if LP = 0 then
      begin
        ClearMatrix;
        Exit;
      end;

      RowCount := get_Nrows(LP);
      ColumnCount := get_Ncolumns(LP);
      MatrixTable.BeginUpdate;
      try
        MatrixTable.ColCount := ColumnCount + 2;
        MatrixTable.RowCount := RowCount + 2;
        MatrixTable.Cells[0, 0] := 'Row';
        for Column := 1 to ColumnCount do
        begin
          ModelName := get_col_name(LP, Column);
          if (ModelName <> nil) and (StrPas(ModelName) <> '') then
            MatrixTable.Cells[Column, 0] := StrPas(ModelName)
          else
            MatrixTable.Cells[Column, 0] := Format('x%d', [Column]);
        end;
        MatrixTable.Cells[ColumnCount + 1, 0] := 'RHS';

        for Row := 0 to RowCount do
        begin
          if Row = 0 then
          begin
            if is_maxim(LP) then
              MatrixTable.Cells[0, Row + 1] := 'max'
            else
              MatrixTable.Cells[0, Row + 1] := 'min';
          end
          else
          begin
            ModelName := get_row_name(LP, Row);
            if (ModelName <> nil) and (StrPas(ModelName) <> '') then
              MatrixTable.Cells[0, Row + 1] := StrPas(ModelName)
            else
              MatrixTable.Cells[0, Row + 1] := Format('Constraint %d', [Row]);
          end;

          for Column := 1 to ColumnCount do
            MatrixTable.Cells[Column, Row + 1] :=
              FloatToStr(get_mat(LP, Row, Column));
          MatrixTable.Cells[ColumnCount + 1, Row + 1] :=
            FloatToStr(get_rh(LP, Row));
        end;
      finally
        MatrixTable.EndUpdate;
      end;
      MatrixTable.ColWidths[0] := 150;
      MatrixStatusLabel.Caption := Format('%d constraints, %d variables',
        [RowCount, ColumnCount]);
      FMatrixDirty := False;
    except
      on Exception do
        ClearMatrix;
    end;
  finally
    if LP <> 0 then
      delete_lp(LP);
    if TempFile <> '' then
      DeleteFile(TempFile);
    if MathProgMPSFile <> '' then
      DeleteFile(MathProgMPSFile);
    Screen.Cursor := crDefault;
  end;
end;

function GridCellsToCSV(Grid: TStringGrid): string;
var
  Row, Col: Integer;
  Cell: string;
  Dummy: Double;
begin
  Result := '';
  for Row := 0 to Grid.RowCount - 1 do
  begin
    if ((Grid.FixedRows >= 2) and (Row = 1)) or (Grid.RowHeights[Row] = 0) then
      Continue;
    for Col := 0 to Grid.ColCount - 1 do
    begin
      Cell := Grid.Cells[Col, Row];
      if Col > 0 then
        Result := Result + ';';
      if (Row > 0) and (Col > 0) and TryStrToFloat(Cell, Dummy) then
        Result := Result + Cell
      else
        Result := Result + '"' + StringReplace(Cell, '"', '""',
          [rfReplaceAll]) + '"';
    end;
    Result := Result + LineEnding;
  end;
end;

function GridCellsToHTML(Grid: TStringGrid): string;
var
  Row, Col: Integer;
  Cell, Tag: string;
begin
  Result := '<html><head><meta charset="utf-8"></head><body>' + LineEnding +
    '<table border="1" cellspacing="0" cellpadding="3">' + LineEnding;
  for Row := 0 to Grid.RowCount - 1 do
  begin
    if ((Grid.FixedRows >= 2) and (Row = 1)) or (Grid.RowHeights[Row] = 0) then
      Continue;
    Result := Result + '<tr>';
    for Col := 0 to Grid.ColCount - 1 do
    begin
      Cell := Grid.Cells[Col, Row];
      Cell := StringReplace(Cell, '&', '&amp;', [rfReplaceAll]);
      Cell := StringReplace(Cell, '<', '&lt;', [rfReplaceAll]);
      Cell := StringReplace(Cell, '>', '&gt;', [rfReplaceAll]);
      if (Row = 0) or (Col = 0) then
        Tag := 'th'
      else
        Tag := 'td';
      Result := Result + '<' + Tag + '>' + Cell + '</' + Tag + '>';
    end;
    Result := Result + '</tr>' + LineEnding;
  end;
  Result := Result + '</table>' + LineEnding + '</body></html>' + LineEnding;
end;

function RtfEscape(const Text: string): string;
var
  Wide: UnicodeString;
  I: Integer;
begin
  Result := '';
  Wide := UTF8Decode(Text);
  for I := 1 to Length(Wide) do
    case Wide[I] of
      '\', '{', '}': Result := Result + '\' + Char(Wide[I]);
      #0..#31, #127..#65535: Result := Result + '\u' + IntToStr(SmallInt(Word(Wide[I]))) + '?';
    else
      Result := Result + Char(Wide[I]);
    end;
end;

function GridCellsToRTF(Grid: TStringGrid): string;
const
  CellWidth = 1800;
var
  Row, Col: Integer;
begin
  Result := '{\rtf1\ansi\deff0{\fonttbl{\f0 Arial;}}\f0\fs20' + LineEnding;
  for Row := 0 to Grid.RowCount - 1 do
  begin
    if ((Grid.FixedRows >= 2) and (Row = 1)) or (Grid.RowHeights[Row] = 0) then
      Continue;
    Result := Result + '\trowd\trgaph70';
    for Col := 0 to Grid.ColCount - 1 do
      Result := Result + '\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx' +
        IntToStr((Col + 1) * CellWidth);
    for Col := 0 to Grid.ColCount - 1 do
    begin
      Result := Result + '\intbl ';
      if (Row = 0) or (Col = 0) then
        Result := Result + '\b ' + RtfEscape(Grid.Cells[Col, Row]) + '\b0\cell'
      else
        Result := Result + RtfEscape(Grid.Cells[Col, Row]) + '\cell';
    end;
    Result := Result + '\row' + LineEnding;
  end;
  Result := Result + '}' + LineEnding;
end;

procedure TMainForm.ExportMatrix(Format: TMatrixExportFormat);
var
  Dialog: TSaveDialog;
  Data, Ext: string;
  Stream: TFileStream;
begin
  if FMatrixDirty then
    UpdateMatrix;

  Dialog := TSaveDialog.Create(Self);
  try
    Dialog.Options := Dialog.Options + [ofOverwritePrompt];
    case Format of
      mefCSV:
        begin
          Ext := '.csv';
          Dialog.Filter := 'CSV files (*.csv)|*.csv|All files|*';
        end;
      mefHTML:
        begin
          Ext := '.html';
          Dialog.Filter := 'HTML files (*.htm;*.html)|*.htm;*.html|All files|*';
        end;
      mefRTF:
        begin
          Ext := '.rtf';
          Dialog.Filter := 'RTF files (*.rtf)|*.rtf|All files|*';
        end;
    end;
    Dialog.DefaultExt := Ext;
    if FCurrentFile <> '' then
      Dialog.FileName := ChangeFileExt(ExtractFileName(FCurrentFile), Ext);
    if not Dialog.Execute then
      Exit;

    case Format of
      mefCSV: Data := GridCellsToCSV(MatrixTable);
      mefHTML: Data := GridCellsToHTML(MatrixTable);
      mefRTF: Data := GridCellsToRTF(MatrixTable);
    end;
    try
      Stream := TFileStream.Create(Dialog.FileName, fmCreate);
      try
        if Data <> '' then
          Stream.WriteBuffer(Data[1], Length(Data));
      finally
        Stream.Free;
      end;
    except
      on E: Exception do
        MessageDlgEnglish('Could not export the matrix: ' + E.Message,
          mtError, [mbOK], 0);
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TMainForm.acMatExpCsvExecute(Sender: TObject);
begin
  ExportMatrix(mefCSV);
end;

procedure TMainForm.acMatExpHtmlExecute(Sender: TObject);
begin
  ExportMatrix(mefHTML);
end;

procedure TMainForm.acMatExpRtfExecute(Sender: TObject);
begin
  ExportMatrix(mefRTF);
end;

procedure TMainForm.acExportHTMLExecute(Sender: TObject);
begin
  ExportSource(sefHTML, '.htm', 'HTML files (*.htm;*.html)|*.htm;*.html');
end;

procedure TMainForm.acExportRtfExecute(Sender: TObject);
begin
  ExportSource(sefRTF, '.rtf', 'RTF files (*.rtf)|*.rtf');
end;

procedure TMainForm.acExportTexExecute(Sender: TObject);
begin
  ExportSource(sefTeX, '.tex', 'TeX files (*.tex)|*.tex');
end;

procedure TMainForm.ResultExportClick(Sender: TObject);
begin
  if (Sender = ExporttoCSV1) or (Sender = ExporttoHTML2) or
     (Sender = ExporttoRTF2) then
  begin
    if Sender = ExporttoCSV1 then
      ExportResult(ObjectiveTable, refCSV, 'objective')
    else if Sender = ExporttoHTML2 then
      ExportResult(ObjectiveTable, refHTML, 'objective')
    else
      ExportResult(ObjectiveTable, refRTF, 'objective');
  end
  else if (Sender = ExporttoCSV2) or (Sender = ExporttoHTML3) or
          (Sender = ExporttoRTF3) then
  begin
    if Sender = ExporttoCSV2 then
      ExportResult(ConstraintTable, refCSV, 'constraints')
    else if Sender = ExporttoHTML3 then
      ExportResult(ConstraintTable, refHTML, 'constraints')
    else
      ExportResult(ConstraintTable, refRTF, 'constraints');
  end;
  if (Sender = ObjectivetoCSV1) or (Sender = ObjectivetoHTML1) or
     (Sender = ObjectivetoRTF1) then
  begin
    if Sender = ObjectivetoCSV1 then
      ExportResult(ObjectiveSensTable, refCSV, 'objective_sensitivity')
    else if Sender = ObjectivetoHTML1 then
      ExportResult(ObjectiveSensTable, refHTML, 'objective_sensitivity')
    else
      ExportResult(ObjectiveSensTable, refRTF, 'objective_sensitivity');
  end
  else if (Sender = ObjectivetoCSV2) or (Sender = ObjectivetoHTML2) or
          (Sender = ObjectivetoRTF2) then
  begin
    if Sender = ObjectivetoCSV2 then
      ExportResult(RHSSensTable, refCSV, 'dual_sensitivity')
    else if Sender = ObjectivetoHTML2 then
      ExportResult(RHSSensTable, refHTML, 'dual_sensitivity')
    else
      ExportResult(RHSSensTable, refRTF, 'dual_sensitivity');
  end;
end;

procedure TMainForm.PageControlChange(Sender: TObject);
begin
  if Sender = PageControl2 then
  begin
    if PageControl2.ActivePage = TabSheet5 then
      FSearchControl := MemoLog
    else
      FSearchControl := MemoMessages;
    Exit;
  end;

  if Sender = PageControl3 then
  begin
    if PageControl3.ActivePage = TabSheet7 then
      FSearchControl := ObjectiveSensTable
    else
      FSearchControl := RHSSensTable;
    Exit;
  end;

  if Sender = PageControl1 then
  begin
    if PageControl1.ActivePage = TabSheet3 then
      FSearchControl := ObjectiveTable
    else if PageControl1.ActivePage = TabSheet4 then
      FSearchControl := ConstraintTable
    else if PageControl3.ActivePage = TabSheet7 then
      FSearchControl := ObjectiveSensTable
    else
      FSearchControl := RHSSensTable;
    Exit;
  end;

  UpdateUndoRedoActions;
  if PageControl.ActivePage = TabSheetEditor then
    FSearchControl := Editor
  else if Assigned(FDataTab) and (PageControl.ActivePage = FDataTab) then
    FSearchControl := FDataEditor
  else if PageControl.ActivePage = Matrix then
  begin
    UpdateMatrix;
    FSearchControl := MatrixTable;
  end
  else if PageControl.ActivePage = TabSheet2 then
  begin
    if PageControl1.ActivePage = TabSheet3 then
      FSearchControl := ObjectiveTable
    else if PageControl1.ActivePage = TabSheet4 then
      FSearchControl := ConstraintTable
    else if PageControl3.ActivePage = TabSheet7 then
      FSearchControl := ObjectiveSensTable
    else
      FSearchControl := RHSSensTable;
  end
  else
    FSearchControl := nil;
  UpdateDataTabColor;
end;

procedure TMainForm.MatrixGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  ARect: TRect; AState: TGridDrawState);
var
  Grid: TStringGrid;
begin
  Grid := TStringGrid(Sender);
  if (Grid = FSearchHighlightGrid) and (ARow = FSearchHighlightRow) then
  begin
    Grid.Canvas.Brush.Color := clHighlight;
    Grid.Canvas.Font.Color := clHighlightText;
    Grid.Canvas.FillRect(ARect);
    Grid.Canvas.TextRect(ARect, ARect.Left + 4, ARect.Top + 2,
      Grid.Cells[ACol, ARow]);
    Exit;
  end;
  if ARow <> 2 then
    Exit;
  if gdSelected in AState then
  begin
    Grid.Canvas.Brush.Color := clHighlight;
    Grid.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    Grid.Canvas.Brush.Color := clInfoBk;
    Grid.Canvas.Font.Color := clInfoText;
  end;
  Grid.Canvas.FillRect(ARect);
  Grid.Canvas.TextRect(ARect, ARect.Left + 4, ARect.Top + 2,
    Grid.Cells[ACol, ARow]);
end;

procedure TMainForm.ExportSource(Format: TSourceExportFormat;
  const Extension, Filter: string);
var
  Exporter: TSynCustomExporter;
  SourceText: string;
  OutputText: string;
  UnicodeSource: UnicodeString;
  Output: TStringStream;
  Stream: TFileStream;
  I, CodeUnit: Integer;

  procedure WriteText(const Value: string);
  begin
    Output.WriteString(Value);
  end;

begin
  if FCurrentFile <> '' then
    ExportDialog.FileName := ExtractFileName(FCurrentFile) + Extension
  else
    ExportDialog.FileName := '';
  ExportDialog.Filter := Filter;
  if not ExportDialog.Execute then
    Exit;

  if Format = sefHTML then
  begin
    Exporter := TSynExporterHTML.Create(nil);
    try
      TSynExporterHTML(Exporter).ExportAsText := True;
      Exporter.Highlighter := Editor.Highlighter;
      Exporter.ExportAll(Editor.Lines);
      Exporter.SaveToFile(ExportDialog.FileName);
    finally
      Exporter.Free;
    end;
    Exit;
  end;

  Output := TStringStream.Create('');
  try
    SourceText := Editor.Text;
    if Format = sefRTF then
    begin
      WriteText('{\rtf1\ansi\deff0{\fonttbl{\f0\fmodern Courier New;}}' +
        '\f0\fs20 ');
      UnicodeSource := UTF8Decode(SourceText);
      for I := 1 to Length(UnicodeSource) do
      begin
        CodeUnit := Ord(UnicodeSource[I]);
        case CodeUnit of
          9: WriteText('\tab ');
          10: WriteText('\line ');
          13:
            if (I = Length(UnicodeSource)) or (UnicodeSource[I + 1] <> #10) then
              WriteText('\line ');
          123: WriteText('\{');
          125: WriteText('\}');
          92: WriteText('\\');
        else
          if (CodeUnit >= 32) and (CodeUnit <= 126) then
            WriteText(Chr(CodeUnit))
          else if CodeUnit > 126 then
          begin
            if CodeUnit > 32767 then
              Dec(CodeUnit, 65536);
            WriteText('\u' + IntToStr(CodeUnit) + '?');
          end;
        end;
      end;
      WriteText('}');
    end
    else
    begin
      WriteText('\documentclass{article}' + LineEnding +
        '\usepackage[utf8]{inputenc}' + LineEnding +
        '\usepackage[T1]{fontenc}' + LineEnding +
        '\begin{document}' + LineEnding + '\ttfamily' + LineEnding);
      for I := 1 to Length(SourceText) do
        case SourceText[I] of
          #9: WriteText('\quad ');
          #10: WriteText('\\' + LineEnding);
          #13:
            if (I = Length(SourceText)) or (SourceText[I + 1] <> #10) then
              WriteText('\\' + LineEnding);
          '\': WriteText('\textbackslash{}');
          '{': WriteText('\{');
          '}': WriteText('\}');
          '#': WriteText('\#');
          '$': WriteText('\$');
          '%': WriteText('\%');
          '&': WriteText('\&');
          '_': WriteText('\_');
          '^': WriteText('\textasciicircum{}');
          '~': WriteText('\textasciitilde{}');
          ' ': WriteText('\ ');
        else
          WriteText(SourceText[I]);
        end;
      WriteText(LineEnding + '\end{document}' + LineEnding);
    end;
    OutputText := Output.DataString;
    Stream := TFileStream.Create(ExportDialog.FileName, fmCreate);
    try
      if OutputText <> '' then
        Stream.WriteBuffer(OutputText[1], Length(OutputText));
    finally
      Stream.Free;
    end;
  finally
    Output.Free;
  end;
end;

procedure TMainForm.ExportResult(Grid: TStringGrid;
  Format: TResultExportFormat; const NameSuffix: string);
var
  Dialog: TSaveDialog;
  Data, Extension: string;
  Stream: TFileStream;
begin
  Dialog := TSaveDialog.Create(Self);
  try
    Dialog.Options := Dialog.Options + [ofOverwritePrompt, ofPathMustExist];
    case Format of
      refCSV:
        begin
          Extension := '.csv';
          Dialog.Filter := 'CSV files (*.csv)|*.csv|All files (*.*)|*.*';
        end;
      refHTML:
        begin
          Extension := '.html';
          Dialog.Filter := 'HTML files (*.htm;*.html)|*.htm;*.html|All files (*.*)|*.*';
        end;
      refRTF:
        begin
          Extension := '.rtf';
          Dialog.Filter := 'RTF files (*.rtf)|*.rtf|All files (*.*)|*.*';
        end;
    end;
    Dialog.DefaultExt := Copy(Extension, 2, Length(Extension));
    if FCurrentFile <> '' then
      Dialog.FileName := ChangeFileExt(ExtractFileName(FCurrentFile),
        '_' + NameSuffix + Extension);
    if not Dialog.Execute then
      Exit;

    case Format of
      refCSV: Data := GridCellsToCSV(Grid);
      refHTML: Data := GridCellsToHTML(Grid);
      refRTF: Data := GridCellsToRTF(Grid);
    end;
    try
      Stream := TFileStream.Create(Dialog.FileName, fmCreate);
      try
        if Data <> '' then
          Stream.WriteBuffer(Data[1], Length(Data));
      finally
        Stream.Free;
      end;
    except
      on E: Exception do
        MessageDlgEnglish('Could not export the result: ' + E.Message,
          mtError, [mbOK], 0);
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TMainForm.AutoSizeResultColumns(Grid: TStringGrid);
var
  Column, Row, RequiredWidth: Integer;
begin
  for Column := 1 to Grid.ColCount - 1 do
  begin
    RequiredWidth := Grid.DefaultColWidth;
    for Row := 2 to Grid.RowCount - 1 do
      RequiredWidth := Max(RequiredWidth,
        Grid.Canvas.TextWidth(Grid.Cells[Column, Row]) + 16);
    Grid.ColWidths[Column] := RequiredWidth;
  end;
end;

procedure TMainForm.SortResultGrid(Grid: TStringGrid; Column,
  SortIndex: Integer);
var
  Row, OtherRow, CurrentCol: Integer;
  SwapValue: string;
  LeftNumber, RightNumber: Double;
  Comparison: Integer;
begin
  if (Column < 0) or (Column >= Grid.ColCount) then
    Exit;
  FResultSortAscending[SortIndex] := not FResultSortAscending[SortIndex];
  for Row := 3 to Grid.RowCount - 1 do
    for OtherRow := Row + 1 to Grid.RowCount - 1 do
    begin
      if TryStrToFloat(Grid.Cells[Column, Row], LeftNumber) and
         TryStrToFloat(Grid.Cells[Column, OtherRow], RightNumber) then
      begin
        if LeftNumber < RightNumber then
          Comparison := -1
        else if LeftNumber > RightNumber then
          Comparison := 1
        else
          Comparison := 0;
      end
      else
        Comparison := CompareText(Grid.Cells[Column, Row],
          Grid.Cells[Column, OtherRow]);

      if (FResultSortAscending[SortIndex] and (Comparison > 0)) or
         (not FResultSortAscending[SortIndex] and (Comparison < 0)) then
        for CurrentCol := 0 to Grid.ColCount - 1 do
        begin
          SwapValue := Grid.Cells[CurrentCol, Row];
          Grid.Cells[CurrentCol, Row] := Grid.Cells[CurrentCol, OtherRow];
          Grid.Cells[CurrentCol, OtherRow] := SwapValue;
        end;
    end;
  ApplyResultFilter(Grid);
end;

procedure TMainForm.ObjectiveTableHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  if IsColumn and not FilterRowClicked(ObjectiveTable) then
    SortResultGrid(ObjectiveTable, Index, 0);
end;

procedure TMainForm.ConstraintTableHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  if IsColumn and not FilterRowClicked(ConstraintTable) then
    SortResultGrid(ConstraintTable, Index, 1);
end;

procedure TMainForm.ObjectiveSensTableHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  if IsColumn and not FilterRowClicked(ObjectiveSensTable) then
    SortResultGrid(ObjectiveSensTable, Index, 2);
end;

procedure TMainForm.RHSSensTableHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  if IsColumn and not FilterRowClicked(RHSSensTable) then
    SortResultGrid(RHSSensTable, Index, 3);
end;

procedure TMainForm.ResultGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  ARect: TRect; AState: TGridDrawState);
var
  Grid: TStringGrid;
begin
  Grid := TStringGrid(Sender);
  if (Grid = FSearchHighlightGrid) and (ARow = FSearchHighlightRow) then
  begin
    Grid.Canvas.Brush.Color := clHighlight;
    Grid.Canvas.Font.Color := clHighlightText;
    Grid.Canvas.FillRect(ARect);
    Grid.Canvas.TextRect(ARect, ARect.Left + 4, ARect.Top + 2,
      Grid.Cells[ACol, ARow]);
    Exit;
  end;
  if ARow <> 1 then
    Exit;
  if gdSelected in AState then
  begin
    Grid.Canvas.Brush.Color := clHighlight;
    Grid.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    Grid.Canvas.Brush.Color := clInfoBk;
    Grid.Canvas.Font.Color := clInfoText;
  end;
  Grid.Canvas.FillRect(ARect);
  Grid.Canvas.TextRect(ARect, ARect.Left + 4, ARect.Top + 2,
    Grid.Cells[ACol, ARow]);
end;

procedure TMainForm.AddCurrentResult(LP: PtrUInt; const Header: string;
  IncludeSensitivity: Boolean);
var
  VariableCount, ConstraintCount, SensitivityCount, I: Integer;
  Variables, ConstraintBuffer: PFloatArray;
  ObjFrom, ObjTill, ObjFromValue, ObjTillValue: PFloatArray;
  Duals, DualsFrom, DualsTill: PFloatArray;
  ObjectiveValues, ConstraintValues: PFloatArray;
  SensitivityValues: array[0..3] of PFloatArray;
  DualValues: array[0..2] of PFloatArray;
  VariablesLoaded, ConstraintsLoaded, ObjectiveSensitivityLoaded,
    DualSensitivityLoaded: Boolean;
begin
  VariableCount := get_Ncolumns(LP);
  ConstraintCount := get_Nrows(LP);
  Variables := nil;
  ConstraintBuffer := nil;
  ObjFrom := nil;
  ObjTill := nil;
  ObjFromValue := nil;
  ObjTillValue := nil;
  Duals := nil;
  DualsFrom := nil;
  DualsTill := nil;
  VariablesLoaded := False;
  ConstraintsLoaded := False;
  ObjectiveSensitivityLoaded := False;
  DualSensitivityLoaded := False;
  try
    if VariableCount > 0 then
    begin
      GetMem(Variables, VariableCount * SizeOf(Double));
      FillChar(Variables^, VariableCount * SizeOf(Double), 0);
    end;
    if ConstraintCount > 0 then
    begin
      GetMem(ConstraintBuffer, ConstraintCount * SizeOf(Double));
      FillChar(ConstraintBuffer^, ConstraintCount * SizeOf(Double), 0);
    end;

    VariablesLoaded := (VariableCount = 0) or get_variables(LP, Variables);
    if not VariablesLoaded then
      raise Exception.Create('lp_solve did not return variable values.');
    ConstraintsLoaded := (ConstraintCount = 0) or
      get_constraints(LP, ConstraintBuffer);

    ObjectiveValues := FObjectives.Add(VariableCount);
    ObjectiveValues^[0] := get_objective(LP);
    for I := 1 to VariableCount do
      ObjectiveValues^[I] := Variables^[I - 1];

    if ConstraintsLoaded then
    begin
      ConstraintValues := FConstraints.Add(ConstraintCount);
      ConstraintValues^[0] := get_objective(LP);
      for I := 1 to ConstraintCount do
        ConstraintValues^[I] := ConstraintBuffer^[I - 1];
    end;

    if IncludeSensitivity and (VariableCount > 0) then
    begin
      GetMem(ObjFrom, VariableCount * SizeOf(Double));
      GetMem(ObjTill, VariableCount * SizeOf(Double));
      GetMem(ObjFromValue, VariableCount * SizeOf(Double));
      GetMem(ObjTillValue, VariableCount * SizeOf(Double));
      FillChar(ObjFrom^, VariableCount * SizeOf(Double), 0);
      FillChar(ObjTill^, VariableCount * SizeOf(Double), 0);
      FillChar(ObjFromValue^, VariableCount * SizeOf(Double), 0);
      FillChar(ObjTillValue^, VariableCount * SizeOf(Double), 0);
      ObjectiveSensitivityLoaded := get_sensitivity_objex(LP, ObjFrom,
        ObjTill, ObjFromValue, ObjTillValue);
      if ObjectiveSensitivityLoaded then
      begin
        SensitivityCount := FObjectivesSens.ColCount;
        for I := 0 to 3 do
          SensitivityValues[I] := FObjectivesSens.Add(VariableCount);
        for I := 1 to VariableCount do
        begin
          SensitivityValues[0]^[I] := ObjFrom^[I - 1];
          SensitivityValues[1]^[I] := ObjTill^[I - 1];
          SensitivityValues[2]^[I] := ObjFromValue^[I - 1];
          SensitivityValues[3]^[I] := ObjTillValue^[I - 1];
        end;
        SetLength(FObjSensOwner, Length(FObjSensOwner) + 1);
        FObjSensOwner[High(FObjSensOwner)] := FObjectives.ColCount - 1;
        if SensitivityCount mod 4 <> 0 then
          raise Exception.Create('Objective sensitivity result data is inconsistent.');
      end;
    end;

    SensitivityCount := ConstraintCount + VariableCount;
    if IncludeSensitivity and (SensitivityCount > 0) then
    begin
      GetMem(Duals, SensitivityCount * SizeOf(Double));
      GetMem(DualsFrom, SensitivityCount * SizeOf(Double));
      GetMem(DualsTill, SensitivityCount * SizeOf(Double));
      FillChar(Duals^, SensitivityCount * SizeOf(Double), 0);
      FillChar(DualsFrom^, SensitivityCount * SizeOf(Double), 0);
      FillChar(DualsTill^, SensitivityCount * SizeOf(Double), 0);
      DualSensitivityLoaded := get_sensitivity_rhs(LP, Duals, DualsFrom,
        DualsTill);
      if DualSensitivityLoaded then
      begin
        for I := 0 to 2 do
          DualValues[I] := FRHSSens.Add(SensitivityCount);
        for I := 1 to SensitivityCount do
        begin
          DualValues[0]^[I] := Duals^[I - 1];
          DualValues[1]^[I] := DualsFrom^[I - 1];
          DualValues[2]^[I] := DualsTill^[I - 1];
        end;
        SetLength(FRHSSensOwner, Length(FRHSSensOwner) + 1);
        FRHSSensOwner[High(FRHSSensOwner)] := FObjectives.ColCount - 1;
      end;
    end;
  finally
    if Variables <> nil then
      FreeMem(Variables);
    if ConstraintBuffer <> nil then
      FreeMem(ConstraintBuffer);
    if ObjFrom <> nil then
      FreeMem(ObjFrom);
    if ObjTill <> nil then
      FreeMem(ObjTill);
    if ObjFromValue <> nil then
      FreeMem(ObjFromValue);
    if ObjTillValue <> nil then
      FreeMem(ObjTillValue);
    if Duals <> nil then
      FreeMem(Duals);
    if DualsFrom <> nil then
      FreeMem(DualsFrom);
    if DualsTill <> nil then
      FreeMem(DualsTill);
  end;

  if not ConstraintsLoaded then
    MemoMessages.Lines.Add('Constraint values are unavailable for this result.');
  if IncludeSensitivity and
     (not ObjectiveSensitivityLoaded or not DualSensitivityLoaded) then
    MemoMessages.Lines.Add('Sensitivity data is unavailable for this result.');
  FResultHeaders.Add(Header);
  UpdateResultTables(LP);
end;

procedure TMainForm.UpdateResultTables(LP: PtrUInt);
var
  I: Integer;
  NamePtr: PChar;
begin
  FResultInfinite := get_infinite(LP);
  FVarNames.Clear;
  for I := 1 to get_Ncolumns(LP) do
  begin
    NamePtr := get_col_name(LP, I);
    if NamePtr <> nil then
      FVarNames.Add(StrPas(NamePtr))
    else
      FVarNames.Add(Format('x%d', [I]));
  end;
  FRowNames.Clear;
  for I := 1 to get_Nrows(LP) do
  begin
    NamePtr := get_row_name(LP, I);
    if NamePtr <> nil then
      FRowNames.Add(StrPas(NamePtr))
    else
      FRowNames.Add(Format('Constraint %d', [I]));
  end;
  // Display problems must never abort the solver.
  try
    RenderResultTables;
  except
    on E: Exception do
      MemoMessages.Lines.Add('Could not update the result tables: ' +
        E.Message);
  end;
  PageControl.ActivePage := TabSheet2;
  PageControl1.ActivePage := TabSheet3;
  FSearchControl := ObjectiveTable;
end;

procedure TMainForm.RenderResultTables;
var
  I, J, K, VariableCount, ConstraintCount, ResultCount, FirstResult,
    Column, ResOwner, Groups, VisibleGroups: Integer;
  Keep: Boolean;
  ShowAll, OnlyNonNull: Boolean;
  VarRows, DualRows: array of Integer;

  function IsNull(Value: Double): Boolean;
  begin
    Result := Abs(Value) < FOptions.Epsel;
  end;

  function Fmt(Value: Double): string;
  begin
    if Abs(Value) >= FResultInfinite then
    begin
      if Value < 0 then
        Result := '-inf'
      else
        Result := '+inf';
    end
    else
      Result := FloatToStr(Value);
  end;

  function HeaderOf(Index: Integer): string;
  begin
    if (Index >= 0) and (Index < FResultHeaders.Count) then
      Result := FResultHeaders[Index]
    else
      Result := Format('Result %d', [Index + 1]);
  end;

  function OwnerOf(const Owners: array of Integer; Group: Integer): Integer;
  begin
    if Group <= High(Owners) then
      Result := Owners[Group]
    else
      Result := Group;
  end;

begin
  VariableCount := FVarNames.Count;
  ConstraintCount := FRowNames.Count;
  ResultCount := FObjectives.ColCount;
  ShowAll := FOptionsPanel.ShowAllIntegerSolutions;
  if ShowAll or (ResultCount = 0) then
    FirstResult := 0
  else
    FirstResult := ResultCount - 1;

  OnlyNonNull := FOptionsPanel.ShowOnlyNonNullValues;
  VarRows := nil;
  DualRows := nil;
  for J := 1 to VariableCount do
  begin
    Keep := not OnlyNonNull;
    for I := FirstResult to ResultCount - 1 do
      if not IsNull(FObjectives[I, J]) then
        Keep := True;
    if Keep then
    begin
      SetLength(VarRows, Length(VarRows) + 1);
      VarRows[High(VarRows)] := J;
    end;
  end;

  ObjectiveTable.ColCount := Max(2, ResultCount - FirstResult + 1);
  ObjectiveTable.RowCount := Max(3, Length(VarRows) + 3);
  ObjectiveTable.Cells[0, 0] := 'Variables';
  ObjectiveTable.Cells[0, 2] := 'Objective';
  for I := FirstResult to ResultCount - 1 do
  begin
    Column := I - FirstResult + 1;
    ObjectiveTable.Cells[Column, 0] := HeaderOf(I);
    ObjectiveTable.Cells[Column, 2] := Fmt(FObjectives[I, 0]);
    for J := 0 to High(VarRows) do
      ObjectiveTable.Cells[Column, J + 3] := Fmt(FObjectives[I, VarRows[J]]);
  end;
  for J := 0 to High(VarRows) do
    ObjectiveTable.Cells[0, J + 3] := FVarNames[VarRows[J] - 1];

  ConstraintTable.ColCount := Max(2, FConstraints.ColCount - FirstResult + 1);
  ConstraintTable.RowCount := Max(3, ConstraintCount + 3);
  ConstraintTable.Cells[0, 0] := 'Constraints';
  ConstraintTable.Cells[0, 2] := 'Objective';
  for I := FirstResult to FConstraints.ColCount - 1 do
  begin
    Column := I - FirstResult + 1;
    ConstraintTable.Cells[Column, 0] := HeaderOf(I);
    ConstraintTable.Cells[Column, 2] := Fmt(FConstraints[I, 0]);
    for J := 1 to ConstraintCount do
      ConstraintTable.Cells[Column, J + 2] := Fmt(FConstraints[I, J]);
  end;
  for J := 1 to ConstraintCount do
    ConstraintTable.Cells[0, J + 2] := FRowNames[J - 1];

  Groups := FObjectivesSens.ColCount div 4;
  VisibleGroups := 0;
  for I := 0 to Groups - 1 do
    if OwnerOf(FObjSensOwner, I) >= FirstResult then
      Inc(VisibleGroups);
  ObjectiveSensTable.ColCount := Max(2, VisibleGroups * 4 + 1);
  ObjectiveSensTable.Cells[0, 0] := 'Variables';
  if VisibleGroups = 0 then
  begin
    ObjectiveSensTable.RowCount := 3;
    ObjectiveSensTable.Cells[0, 2] := '';
    ObjectiveSensTable.Cells[1, 0] := 'Sensitivity unavailable';
    ObjectiveSensTable.Cells[1, 2] := '';
  end
  else
  begin
    ObjectiveSensTable.RowCount := Max(3, VariableCount + 3);
    ObjectiveSensTable.Cells[0, 2] := 'Objective';
    for J := 1 to VariableCount do
      ObjectiveSensTable.Cells[0, J + 2] := FVarNames[J - 1];
  end;
  Column := 1;
  for I := 0 to Groups - 1 do
  begin
    ResOwner := OwnerOf(FObjSensOwner, I);
    if ResOwner < FirstResult then
      Continue;
    ObjectiveSensTable.Cells[Column, 0] := 'From';
    ObjectiveSensTable.Cells[Column + 1, 0] := 'Till';
    ObjectiveSensTable.Cells[Column + 2, 0] := 'From value';
    ObjectiveSensTable.Cells[Column + 3, 0] := 'Till value';
    if ResOwner < ResultCount then
      ObjectiveSensTable.Cells[Column, 2] := Fmt(FObjectives[ResOwner, 0])
    else
      ObjectiveSensTable.Cells[Column, 2] := '';
    ObjectiveSensTable.Cells[Column + 1, 2] := '';
    ObjectiveSensTable.Cells[Column + 2, 2] := '';
    ObjectiveSensTable.Cells[Column + 3, 2] := '';
    for J := 1 to VariableCount do
      for K := 0 to 3 do
        ObjectiveSensTable.Cells[Column + K, J + 2] :=
          Fmt(FObjectivesSens[I * 4 + K, J]);
    Inc(Column, 4);
  end;

  Groups := FRHSSens.ColCount div 3;
  VisibleGroups := 0;
  for I := 0 to Groups - 1 do
    if OwnerOf(FRHSSensOwner, I) >= FirstResult then
      Inc(VisibleGroups);
  RHSSensTable.ColCount := Max(2, VisibleGroups * 3 + 1);
  RHSSensTable.Cells[0, 0] := 'Constraints / Variables';
  if VisibleGroups = 0 then
  begin
    RHSSensTable.RowCount := 3;
    RHSSensTable.Cells[0, 2] := '';
    RHSSensTable.Cells[1, 0] := 'Sensitivity unavailable';
    RHSSensTable.Cells[1, 2] := '';
  end
  else
  begin
    SetLength(DualRows, 0);
    for J := 1 to ConstraintCount + VariableCount do
    begin
      Keep := not OnlyNonNull;
      for I := 0 to Groups - 1 do
        if (OwnerOf(FRHSSensOwner, I) >= FirstResult) and
           not IsNull(FRHSSens[I * 3, J]) then
          Keep := True;
      if Keep then
      begin
        SetLength(DualRows, Length(DualRows) + 1);
        DualRows[High(DualRows)] := J;
      end;
    end;
    RHSSensTable.RowCount := Max(3, Length(DualRows) + 3);
    RHSSensTable.Cells[0, 2] := 'Objective';
    for J := 0 to High(DualRows) do
      if DualRows[J] <= ConstraintCount then
        RHSSensTable.Cells[0, J + 3] := FRowNames[DualRows[J] - 1]
      else
        RHSSensTable.Cells[0, J + 3] :=
          FVarNames[DualRows[J] - ConstraintCount - 1];
  end;
  Column := 1;
  for I := 0 to Groups - 1 do
  begin
    ResOwner := OwnerOf(FRHSSensOwner, I);
    if ResOwner < FirstResult then
      Continue;
    RHSSensTable.Cells[Column, 0] := 'Value';
    RHSSensTable.Cells[Column + 1, 0] := 'From';
    RHSSensTable.Cells[Column + 2, 0] := 'Till';
    if ResOwner < ResultCount then
      RHSSensTable.Cells[Column, 2] := Fmt(FObjectives[ResOwner, 0])
    else
      RHSSensTable.Cells[Column, 2] := '';
    for J := 0 to High(DualRows) do
      for K := 0 to 2 do
        RHSSensTable.Cells[Column + K, J + 3] :=
          Fmt(FRHSSens[I * 3 + K, DualRows[J]]);
    Inc(Column, 3);
  end;

  HideFilterEdit;
  ApplyResultFilter(ObjectiveTable);
  ApplyResultFilter(ConstraintTable);
  ApplyResultFilter(ObjectiveSensTable);
  ApplyResultFilter(RHSSensTable);
  AutoSizeResultColumns(ObjectiveTable);
  AutoSizeResultColumns(ConstraintTable);
  AutoSizeResultColumns(ObjectiveSensTable);
  AutoSizeResultColumns(RHSSensTable);
end;

procedure TMainForm.HideFilterEdit;
begin
  if Assigned(FFilterEdit) and FFilterEdit.Visible then
    FFilterEdit.Visible := False;
end;

procedure TMainForm.ApplyResultFilter(Grid: TStringGrid);
var
  Row, Column: Integer;
  RowShown: Boolean;
  Filter: string;
begin
  for Row := 3 to Grid.RowCount - 1 do
  begin
    RowShown := True;
    for Column := 0 to Grid.ColCount - 1 do
    begin
      Filter := Grid.Cells[Column, 1];
      if (Filter <> '') and
         (Pos(LowerCase(Filter), LowerCase(Grid.Cells[Column, Row])) = 0) then
      begin
        RowShown := False;
        Break;
      end;
    end;
    if RowShown then
      Grid.RowHeights[Row] := Grid.DefaultRowHeight
    else
      Grid.RowHeights[Row] := 0;
  end;
end;

function TMainForm.FilterRowClicked(Grid: TStringGrid): Boolean;
var
  P: TPoint;
  Column, Row: Integer;
begin
  P := Grid.ScreenToClient(Mouse.CursorPos);
  Grid.MouseToCell(P.X, P.Y, Column, Row);
  Result := Row = 1;
end;

procedure TMainForm.ResultGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Grid: TStringGrid;
  Column, Row: Integer;
begin
  Grid := TStringGrid(Sender);
  HideFilterEdit;
  if (Button <> mbLeft) or (ssCtrl in Shift) then
    Exit;
  Grid.MouseToCell(X, Y, Column, Row);
  if (Row <> 1) or (Column < 0) then
    Exit;
  FFilterEdit.Parent := Grid;
  FFilterEdit.BoundsRect := Grid.CellRect(Column, 1);
  FFilterEdit.Tag := Column;
  FFilterEdit.OnChange := nil;
  FFilterEdit.Text := Grid.Cells[Column, 1];
  FFilterEdit.OnChange := @FilterEditChange;
  FFilterEdit.Visible := True;
  Application.QueueAsyncCall(@FocusFilterEdit, 0);
end;

procedure TMainForm.FocusFilterEdit(Data: PtrInt);
begin
  if (Data = 0) and FFilterEdit.Visible and FFilterEdit.CanFocus then
  begin
    FFilterEdit.SetFocus;
    FFilterEdit.SelStart := Length(FFilterEdit.Text);
  end;
end;

procedure TMainForm.ResultGridLayoutChanged(Sender: TObject);
begin
  HideFilterEdit;
end;

procedure TMainForm.ResultGridHeaderSized(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
begin
  if IsColumn or (Index >= 0) then
    HideFilterEdit;
end;

procedure TMainForm.FilterEditChange(Sender: TObject);
var
  Grid: TStringGrid;
begin
  Grid := TStringGrid(FFilterEdit.Parent);
  Grid.Cells[FFilterEdit.Tag, 1] := FFilterEdit.Text;
  ApplyResultFilter(Grid);
end;

procedure TMainForm.FilterEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Grid: TStringGrid;
begin
  if (Key in [VK_RETURN, VK_ESCAPE, VK_TAB]) and (Shift - [ssShift] = []) then
  begin
    Grid := TStringGrid(FFilterEdit.Parent);
    Key := 0;
    HideFilterEdit;
    Grid.SetFocus;
  end;
end;

procedure TMainForm.FilterEditExit(Sender: TObject);
begin
  HideFilterEdit;
end;

procedure TMainForm.ShowAllIntegerSolutionsChanged(Sender: TObject);
begin
  FShowAllItem.Checked := FOptionsPanel.ShowAllIntegerSolutions;
  FShowAllItem2.Checked := FOptionsPanel.ShowAllIntegerSolutions;
  FNonNullItem.Checked := FOptionsPanel.ShowOnlyNonNullValues;
  if FObjectives.ColCount > 0 then
    RenderResultTables;
end;

procedure TMainForm.ShowAllItemClick(Sender: TObject);
begin
  FOptionsPanel.ShowAllIntegerSolutions := TMenuItem(Sender).Checked;
end;

procedure TMainForm.NonNullItemClick(Sender: TObject);
begin
  FOptionsPanel.ShowOnlyNonNullValues := FNonNullItem.Checked;
end;

procedure TMainForm.CreateResultPopupMenu;
  function NewItem(Popup: TPopupMenu; const ACaption: string;
    Checked: Boolean; Handler: TNotifyEvent): TMenuItem;
  begin
    Result := TMenuItem.Create(Self);
    Result.Caption := ACaption;
    Result.AutoCheck := True;
    Result.Checked := Checked;
    Result.OnClick := Handler;
    Popup.Items.Add(Result);
  end;
begin
  FResultPopup := TPopupMenu.Create(Self);
  FShowAllItem := NewItem(FResultPopup, 'Show all integer solutions', True,
    @ShowAllItemClick);
  FResultPopup2 := TPopupMenu.Create(Self);
  FShowAllItem2 := NewItem(FResultPopup2, 'Show all integer solutions', True,
    @ShowAllItemClick);
  FNonNullItem := NewItem(FResultPopup2, 'Show only non-null values', False,
    @NonNullItemClick);
  ConstraintTable.PopupMenu := FResultPopup;
  ObjectiveSensTable.PopupMenu := FResultPopup;
  ObjectiveTable.PopupMenu := FResultPopup2;
  RHSSensTable.PopupMenu := FResultPopup2;
end;

procedure TMainForm.ClearResultTables;
var
  Grid: TStringGrid;
begin
  FObjectives.Clear;
  FConstraints.Clear;
  FObjectivesSens.Clear;
  FRHSSens.Clear;
  HideFilterEdit;
  FResultHeaders.Clear;
  FVarNames.Clear;
  FRowNames.Clear;
  FObjSensOwner := nil;
  FRHSSensOwner := nil;
  ObjectiveTable.ColCount := 2;
  ObjectiveTable.RowCount := 3;
  ObjectiveTable.Cells[1, 0] := '';
  ObjectiveTable.Cells[0, 1] := '';
  ObjectiveTable.Cells[1, 1] := '';
  ObjectiveTable.Cells[0, 2] := '';
  ObjectiveTable.Cells[1, 2] := '';
  ConstraintTable.ColCount := 2;
  ConstraintTable.RowCount := 3;
  ConstraintTable.Cells[1, 0] := '';
  ConstraintTable.Cells[0, 1] := '';
  ConstraintTable.Cells[1, 1] := '';
  ConstraintTable.Cells[0, 2] := '';
  ConstraintTable.Cells[1, 2] := '';
  ObjectiveSensTable.ColCount := 2;
  ObjectiveSensTable.RowCount := 3;
  ObjectiveSensTable.Cells[1, 0] := '';
  ObjectiveSensTable.Cells[0, 1] := '';
  ObjectiveSensTable.Cells[1, 1] := '';
  ObjectiveSensTable.Cells[0, 2] := '';
  ObjectiveSensTable.Cells[1, 2] := '';
  RHSSensTable.ColCount := 2;
  RHSSensTable.RowCount := 3;
  RHSSensTable.Cells[1, 0] := '';
  RHSSensTable.Cells[0, 1] := '';
  RHSSensTable.Cells[1, 1] := '';
  RHSSensTable.Cells[0, 2] := '';
  RHSSensTable.Cells[1, 2] := '';
  for Grid in [ObjectiveTable, ConstraintTable, ObjectiveSensTable,
    RHSSensTable] do
    ApplyResultFilter(Grid);
  ObjectiveTable.Cells[0, 0] := 'Variables';
  ConstraintTable.Cells[0, 0] := 'Constraints';
  ObjectiveSensTable.Cells[0, 0] := 'Variables';
  RHSSensTable.Cells[0, 0] := 'Constraints / Variables';
end;

procedure TMainForm.FormCreate(Sender: TObject);
const
  IconNames: array[0..29] of string = (
    'file-earmark',
    'folder2-open',
    'floppy',
    'play-fill',
    'solve-basis',
    'stop-fill',
    'arrow-counterclockwise',
    'arrow-clockwise',
    'search',
    'arrow-left',
    'arrow-right',
    'arrow-repeat',
    'scissors',
    'files',
    'clipboard',
    'check-circle-fill',
    'bar-chart-fill',
    'file-earmark-code',
    'table',
    'question-circle',
    'door-open',
    'goto-line',
    'table-green',
    'mathprog',
    'arrow-counterclockwise-red',
    'play-fill-red',
    'zoom-in',
    'zoom-out',
    'text-size',
    'sliders'
  );
var
  I: Integer;
  IconPath, StartupFile: string;
  Png: TPortableNetworkGraphic;
  Bitmap: TBitmap;
  Problems: TStringList;

  procedure RefreshMenuItemIcons(MenuItem: TMenuItem);
  var
    ItemIndex, ImageIndex: Integer;
  begin
    ImageIndex := MenuItem.ImageIndex;
    if (ImageIndex >= 0) and (ImageIndex < MenuImageList.Count) then
    begin
      MenuItem.ImageIndex := -1;
      MenuItem.ImageIndex := ImageIndex;
    end;
    for ItemIndex := 0 to MenuItem.Count - 1 do
      RefreshMenuItemIcons(MenuItem.Items[ItemIndex]);
  end;

begin
  {$IFDEF OPTILIBRE_WINDOWS}
  MemoLog.Font.Name := 'Consolas';
  MemoLog.Font.Quality := fqDefault;
  MemoMessages.Font.Name := 'Consolas';
  MemoMessages.Font.Quality := fqDefault;
  Editor.Font.Name := 'Consolas';
  Editor.Font.Quality := fqDefault;
  {$ENDIF}
  FScriptFormat := sfLP;
  FModelHighlighter := TLPModelHighlighter.Create(Self);
  Editor.Highlighter := FModelHighlighter;
  UpdateViewFormat;
  FIsSolving := False;
  FAbortRequested := False;
  FObjectives := TResultArray.Create;
  FConstraints := TResultArray.Create;
  FObjectivesSens := TResultArray.Create;
  FRHSSens := TResultArray.Create;
  FResultHeaders := TStringList.Create;
  FVarNames := TStringList.Create;
  FRowNames := TStringList.Create;
  CreateResultsUI;
  CreateMatrixUI;
  StatusBar.OnMouseMove := @StatusBarMouseMove;
  PageControl.OnChange := @PageControlChange;
  PageControl2.OnChange := @PageControlChange;
  PageControl.Options := PageControl.Options + [nboHidePageListPopup];
  PageControl2.Options := PageControl2.Options + [nboHidePageListPopup];
  PageControl1.Options := PageControl1.Options + [nboHidePageListPopup];
  PageControl3.Options := PageControl3.Options + [nboHidePageListPopup];
  Editor.OnEnter := @SearchControlEnter;
  MemoLog.OnEnter := @SearchControlEnter;
  MemoMessages.OnEnter := @SearchControlEnter;
  IncreaseFont1.OnClick := @FontSizeClick;
  DecreaseFont1.OnClick := @FontSizeClick;
  ResetFont1.OnClick := @FontSizeClick;
  Editor.OnMouseWheel := @EditorMouseWheel;
  MemoLog.OnMouseWheel := @EditorMouseWheel;
  MemoMessages.OnMouseWheel := @EditorMouseWheel;
  FDefaultFontSize := Abs(Editor.Font.Size);
  FGridBaseFontSize := Abs(ObjectiveTable.Font.Size);
  if FGridBaseFontSize = 0 then
    FGridBaseFontSize := Screen.SystemFont.Size;
  ObjectiveTable.Canvas.Font.Assign(ObjectiveTable.Font);
  FGridBaseTextHeight := ObjectiveTable.Canvas.TextHeight('Wg');
  FGridBaseRowHeight := ObjectiveTable.DefaultRowHeight;
  ObjectiveTable.OnMouseWheel := @EditorMouseWheel;
  ConstraintTable.OnMouseWheel := @EditorMouseWheel;
  ObjectiveSensTable.OnMouseWheel := @EditorMouseWheel;
  RHSSensTable.OnMouseWheel := @EditorMouseWheel;
  MatrixTable.OnMouseWheel := @EditorMouseWheel;
  FFontSize := FDefaultFontSize;
  FClearOutputOnSolve := True;
  FSavedClearOutputOnSolve := FClearOutputOnSolve;
  FSavedFontSize := FFontSize;
  LoadDisplaySettings(UISettingsFile);
  FDisplayDialogSave := TSaveDialog.Create(Self);
  FDisplayDialogSave.Filter := 'display settings (*.ini)|*.ini|All files|*.*';
  FDisplayDialogSave.DefaultExt := 'ini';
  FDisplayDialogSave.Title := 'Save display settings';
  FDisplayDialogOpen := TOpenDialog.Create(Self);
  FDisplayDialogOpen.Filter := FDisplayDialogSave.Filter;
  FDisplayDialogOpen.Title := 'Load display settings';
  SaveDisplaySettings1.OnClick := @SaveDisplaySettingsClick;
  LoadDisplaySettings1.OnClick := @LoadDisplaySettingsClick;
  FSearchControl := Editor;
  FLastLineCount := -1;
  FCloseQueryActive := False;
  FCloseApproved := False;
  FSearchText := '';
  FSearchOptions := [];
  FLastSolvedLP := 0;
  FLastSolvedSource := '';
  FLastSolvedFormat := FScriptFormat;
  Savebasis1.Enabled := False;
  FSearchDialog := TdlgSearchText.Create(Self);
  FSearchDialog.OnSearch := @SearchDialogSearch;
  FReplaceDialog := TdlgReplaceText.Create(Self);
  FReplaceDialog.OnAction := @ReplaceTextDialogAction;
  FGotoLineDialog := TdlgGotoLineNumber.Create(Self);
  FOptionsPanel := TSolverOptionsPanel.Create(Self);
  FOptionsPanel.Parent := TabSheetOptions;
  FOptionsPanel.Align := alClient;
  FOptionsPanel.Options := FOptionsPanel.Options + [nboHidePageListPopup];
  FOptionsPanel.OnDisplayOptionChanged := @ShowAllIntegerSolutionsChanged;
  FOptionsDialogSave := TSaveDialog.Create(Self);
  FOptionsDialogSave.Filter := 'Solver options files (*.ini)|*.ini|All files|*.*';
  FOptionsDialogSave.DefaultExt := 'ini';
  FOptionsDialogSave.Title := 'Save solver options';
  FOptionsDialogOpen := TOpenDialog.Create(Self);
  FOptionsDialogOpen.Filter := FOptionsDialogSave.Filter;
  FOptionsDialogOpen.Title := 'Load solver options';
  Saveoptions1.OnClick := @SaveOptionsClick;
  Loadoptions1.OnClick := @LoadOptionsClick;
  Saveasdefault1.OnClick := @SaveDefaultOptionsClick;
  Resetoptions1.OnClick := @ResetOptionsClick;
  GetDefaultSolverOptions(FOptions);
  Problems := TStringList.Create;
  try
    if FileExists(DefaultOptionsFile) then
      LoadSolverOptions(DefaultOptionsFile, FOptions, Problems);
    FOptionsPanel.ShowOptions(FOptions);
    FOptionsPanel.MarkCorrectedOptions(Problems);
    FSavedOptions := FOptions;
    FOptionsCorrected := Problems.Count > 0;
    ReportOptionProblems(Problems);
  finally
    Problems.Free;
  end;
  UpdateSearchActions;
  FEditorBaseline := Editor.Text;
  UpdateEditorStatus;
  Editor.ClearUndo;
  UpdateUndoRedoActions;
  Editor.Keystrokes.ResetDefaults;
  Editor.Options := Editor.Options - [eoScrollPastEol] + [eoKeepCaretX];
  EditorStatusChange(Editor, [scCaretX, scCaretY]);
  PriorityPanel.ParentColor := False;
  PriorityPanel.Color := ToolBar1.Color;
  Priority.ParentColor := False;
  Priority.Color := ToolBar1.Color;
  FSearchDialog.btnFind.Color := ToolBar1.Color;
  FSearchDialog.btnClose.Color := ToolBar1.Color;
  FReplaceDialog.btnFind.Color := ToolBar1.Color;
  FReplaceDialog.btnReplace.Color := ToolBar1.Color;
  FReplaceDialog.btnReplaceAll.Color := ToolBar1.Color;
  FReplaceDialog.btnClose.Color := ToolBar1.Color;
  Png := TPortableNetworkGraphic.Create;
  Bitmap := TBitmap.Create;
  try
    for I := Low(IconNames) to High(IconNames) do
    begin
      IconPath := ExtractFilePath(ParamStr(0)) + 'icons/bootstrap/' +
        IconNames[I] + '.png';
      Png.LoadFromFile(IconPath);
      Bitmap.Assign(Png);
      ImageList.Add(Bitmap, nil);
      MenuImageList.Add(Bitmap, nil);
    end;
  finally
    Bitmap.Free;
    Png.Free;
  end;
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(MenuImageList.Width, MenuImageList.Height);
    Bitmap.Canvas.Brush.Color := clFuchsia;
    Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
    Bitmap.Canvas.Pen.Color := clMenuText;
    Bitmap.Canvas.Pen.Width := 2;
    Bitmap.Canvas.Brush.Style := bsClear;
    Bitmap.Canvas.Rectangle(4, 4, 20, 20);
    MenuImageList.AddMasked(Bitmap, clFuchsia);
    Bitmap.Canvas.Brush.Style := bsSolid;
    Bitmap.Canvas.Brush.Color := clFuchsia;
    Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));
    Bitmap.Canvas.Brush.Style := bsClear;
    Bitmap.Canvas.Rectangle(4, 4, 20, 20);
    Bitmap.Canvas.MoveTo(7, 12);
    Bitmap.Canvas.LineTo(10, 16);
    Bitmap.Canvas.LineTo(17, 8);
    MenuImageList.AddMasked(Bitmap, clFuchsia);
  finally
    Bitmap.Free;
  end;
  UpdateClearOutputOnSolveItem;
  RefreshMenuItemIcons(MainMenu.Items);
  FormResize(Self);
  if ParamCount > 0 then
  begin
    StartupFile := ExpandFileName(ParamStr(1));
    try
      OpenFile(StartupFile);
    except
      on E: Exception do
        MessageDlgEnglish(Format('Could not open "%s": %s',
          [StartupFile, E.Message]), mtError, [mbOK], 0);
    end;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
var
  I, PanelCount, BaseWidth, ExtraPixels: Integer;
begin
  PanelCount := StatusBar.Panels.Count;
  if PanelCount = 0 then
    Exit;

  BaseWidth := StatusBar.ClientWidth div PanelCount;
  ExtraPixels := StatusBar.ClientWidth mod PanelCount;
  for I := 0 to PanelCount - 1 do
    StatusBar.Panels[I].Width := BaseWidth + Ord(I < ExtraPixels);
end;

destructor TMainForm.Destroy;
begin
  if FLastSolvedLP <> 0 then
    delete_lp(FLastSolvedLP);
  FreeAndNil(FResultHeaders);
  FreeAndNil(FVarNames);
  FreeAndNil(FRowNames);
  FreeAndNil(FRHSSens);
  FreeAndNil(FObjectivesSens);
  FreeAndNil(FConstraints);
  FreeAndNil(FObjectives);
  inherited Destroy;
end;

procedure TMainForm.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if (scCaretX in Changes) or (scCaretY in Changes) then
    StatusBar.Panels[0].Text := Format('%d:%d',
      [TSynEdit(Sender).CaretY, TSynEdit(Sender).CaretX]);
  UpdateEditorStatus;
  UpdateUndoRedoActions;
end;

procedure TMainForm.EditorChange(Sender: TObject);
begin
  if FLastSolvedLP <> 0 then
  begin
    delete_lp(FLastSolvedLP);
    FLastSolvedLP := 0;
    FLastSolvedSource := '';
    Savebasis1.Enabled := False;
  end;
  UpdateEditorStatus;
  UpdateUndoRedoActions;
  UpdateDataTabColor;
  FMatrixDirty := True;
  if Assigned(MatrixStatusLabel) then
    MatrixStatusLabel.Caption :=
      'Model changed; select Refresh to update the matrix.';
end;

function TMainForm.ActiveEditor: TSynEdit;
begin
  if Assigned(FDataTab) and (PageControl.ActivePage = FDataTab) then
    Result := FDataEditor
  else
    Result := Editor;
end;

procedure TMainForm.acUndoExecute(Sender: TObject);
begin
  if acUndo.Enabled then
    ActiveEditor.Undo;
end;

procedure TMainForm.acRedoExecute(Sender: TObject);
begin
  if acRedo.Enabled then
    ActiveEditor.Redo;
end;

procedure TMainForm.EditCutClick(Sender: TObject);
begin
  ActiveEditor.CutToClipboard;
end;

procedure TMainForm.EditCopyClick(Sender: TObject);
begin
  ActiveEditor.CopyToClipboard;
end;

procedure TMainForm.EditPasteClick(Sender: TObject);
begin
  ActiveEditor.PasteFromClipboard;
end;

procedure TMainForm.EnsureSearchControl;
begin
  // Tabs changed from code do not trigger OnChange, so the target may be stale.
  if Assigned(FSearchControl) and FSearchControl.Showing then
    Exit;
  if PageControl.ActivePage = TabSheetEditor then
    FSearchControl := Editor
  else if Assigned(FDataTab) and (PageControl.ActivePage = FDataTab) then
    FSearchControl := FDataEditor
  else if PageControl.ActivePage = Matrix then
    FSearchControl := MatrixTable
  else if PageControl.ActivePage = TabSheet2 then
  begin
    if PageControl1.ActivePage = TabSheet3 then
      FSearchControl := ObjectiveTable
    else if PageControl1.ActivePage = TabSheet4 then
      FSearchControl := ConstraintTable
    else if PageControl3.ActivePage = TabSheet7 then
      FSearchControl := ObjectiveSensTable
    else
      FSearchControl := RHSSensTable;
  end;
end;

procedure TMainForm.InitializeSearchDialog;
begin
  EnsureSearchControl;
  if FSearchDialog.edSearchText.Text = '' then
  begin
    if (FSearchControl is TSynEdit) and TSynEdit(FSearchControl).SelAvail then
      FSearchDialog.edSearchText.Text := TSynEdit(FSearchControl).SelText
    else if FSearchControl is TStringGrid then
      FSearchDialog.edSearchText.Text :=
        TStringGrid(FSearchControl).Cells[TStringGrid(FSearchControl).Col,
          TStringGrid(FSearchControl).Row];
  end;
  FSearchDialog.cbMatchCase.Checked := ssoMatchCase in FSearchOptions;
  FSearchDialog.cbWholeWord.Checked := ssoWholeWord in FSearchOptions;
  FSearchDialog.cbEntireScope.Checked := ssoEntireScope in FSearchOptions;
  FSearchDialog.cbSelectedOnly.Checked := ssoSelectedOnly in FSearchOptions;
  FSearchDialog.cbRegExpr.Checked := ssoRegExpr in FSearchOptions;
  if ssoBackwards in FSearchOptions then
    FSearchDialog.rgDirection.ItemIndex := 1
  else
    FSearchDialog.rgDirection.ItemIndex := 0;
end;

function TMainForm.SearchEditor(ContinueSearch, Backwards: Boolean): Integer;
begin
  Result := SearchSynEdit(ActiveEditor, ContinueSearch, Backwards);
end;

function TMainForm.SearchSynEdit(Target: TSynEdit; ContinueSearch,
  Backwards: Boolean): Integer;
var
  SearchOptions: TSynSearchOptions;
begin
  Result := 0;
  if FSearchText = '' then
    Exit;

  SearchOptions := FSearchOptions - [ssoBackwards, ssoFindContinue,
    ssoReplace, ssoReplaceAll, ssoPrompt];
  if Backwards then
    Include(SearchOptions, ssoBackwards);
  if ContinueSearch then
  begin
    Exclude(SearchOptions, ssoEntireScope);
    Include(SearchOptions, ssoFindContinue);
  end;
  Result := Target.SearchReplace(FSearchText, '', SearchOptions);
end;

function TMainForm.SearchGrid(Target: TStringGrid; ContinueSearch,
  Backwards: Boolean): Integer;
var
  CellCount, StartIndex, Index, Row, Column, MatchPos, I: Integer;
  CellText, SearchFor, ComparisonText: string;
  MatchFound, WholeWord: Boolean;
begin
  Result := 0;
  if (FSearchText = '') or (Target.ColCount = 0) or
     (Target.RowCount = 0) then
    Exit;

  CellCount := Target.ColCount * Target.RowCount;
  StartIndex := Target.Row * Target.ColCount + Target.Col;
  // Fixed cells cannot be selected, so the real match position is kept separately.
  if (Target = FSearchHighlightGrid) and
     (Target.Row = Max(FSearchHighlightRow, Target.FixedRows)) and
     (Target.Col = Max(FSearchHighlightCol, Target.FixedCols)) and
     (FSearchHighlightRow < Target.RowCount) and
     (FSearchHighlightCol < Target.ColCount) then
    StartIndex := FSearchHighlightRow * Target.ColCount + FSearchHighlightCol;

  if ContinueSearch then
  begin
    if Backwards then
      Dec(StartIndex)
    else
      Inc(StartIndex);
  end;
  SearchFor := FSearchText;
  WholeWord := ssoWholeWord in FSearchOptions;

  for I := 0 to CellCount - 1 do
  begin
    if Backwards then
      Index := ((StartIndex - I) mod CellCount + CellCount) mod CellCount
    else
      Index := (StartIndex + I) mod CellCount;
    Row := Index div Target.ColCount;
    Column := Index mod Target.ColCount;
    if (Target.RowHeights[Row] = 0) or
       ((Target.FixedRows = 2) and (Row = 1)) then
      Continue;
    CellText := Target.Cells[Column, Row];
    if ssoMatchCase in FSearchOptions then
    begin
      ComparisonText := SearchFor;
    end
    else
    begin
      CellText := LowerCase(CellText);
      ComparisonText := LowerCase(SearchFor);
    end;

    MatchPos := Pos(ComparisonText, CellText);
    MatchFound := MatchPos > 0;
    if MatchFound and WholeWord then
    begin
      MatchFound := ((MatchPos = 1) or
        not (CellText[MatchPos - 1] in ['A'..'Z', 'a'..'z', '0'..'9', '_'])) and
        ((MatchPos + Length(ComparisonText) > Length(CellText)) or
        not (CellText[MatchPos + Length(ComparisonText)] in
          ['A'..'Z', 'a'..'z', '0'..'9', '_']));
    end;
    if MatchFound then
    begin
      Target.Col := Column;
      Target.Row := Row;
      if FSearchHighlightGrid <> nil then
        FSearchHighlightGrid.Invalidate;
      FSearchHighlightGrid := Target;
      FSearchHighlightRow := Row;
      FSearchHighlightCol := Column;
      Target.Invalidate;
      Target.SetFocus;
      Result := 1;
      Exit;
    end;
  end;
end;

function TMainForm.SearchCurrentTarget(ContinueSearch,
  Backwards: Boolean): Integer;
begin
  EnsureSearchControl;
  if FSearchControl is TSynEdit then
    Result := SearchSynEdit(TSynEdit(FSearchControl), ContinueSearch,
      Backwards)
  else if FSearchControl is TStringGrid then
    Result := SearchGrid(TStringGrid(FSearchControl), ContinueSearch,
      Backwards)
  else
    Result := 0;
end;

procedure TMainForm.SearchControlEnter(Sender: TObject);
begin
  if Sender is TWinControl then
    FSearchControl := TWinControl(Sender);
end;

procedure TMainForm.ReportSearchResult(FoundCount: Integer);
begin
  if FoundCount = 0 then
    MessageDlgEnglish(Format('"%s" was not found.', [FSearchText]),
      mtInformation, [mbOK], 0);
end;

procedure TMainForm.SearchDialogSearch(Sender: TObject);
begin
  FSearchText := FSearchDialog.edSearchText.Text;
  FSearchOptions := [];
  if FSearchDialog.cbMatchCase.Checked then
    Include(FSearchOptions, ssoMatchCase);
  if FSearchDialog.cbWholeWord.Checked then
    Include(FSearchOptions, ssoWholeWord);
  if FSearchDialog.cbEntireScope.Checked then
    Include(FSearchOptions, ssoEntireScope);
  if FSearchDialog.cbSelectedOnly.Checked then
    Include(FSearchOptions, ssoSelectedOnly);
  if FSearchDialog.cbRegExpr.Checked then
    Include(FSearchOptions, ssoRegExpr);
  if FSearchDialog.rgDirection.ItemIndex = 1 then
    Include(FSearchOptions, ssoBackwards);
  UpdateSearchActions;
  ReportSearchResult(SearchCurrentTarget(False,
    FSearchDialog.rgDirection.ItemIndex = 1));
end;

procedure TMainForm.ReplaceTextDialogAction(Sender: TObject;
  AAction: TReplaceTextAction);
var
  ReplaceOptions: TSynSearchOptions;
  ReplacedCount: Integer;
  Backwards: Boolean;
  TargetEditor: TSynEdit;
begin
  TargetEditor := ActiveEditor;
  FSearchText := FReplaceDialog.edSearchText.Text;
  FSearchOptions := [];
  if FReplaceDialog.cbMatchCase.Checked then
    Include(FSearchOptions, ssoMatchCase);
  if FReplaceDialog.cbWholeWord.Checked then
    Include(FSearchOptions, ssoWholeWord);
  if FReplaceDialog.cbEntireScope.Checked then
    Include(FSearchOptions, ssoEntireScope);
  if FReplaceDialog.cbSelectedOnly.Checked then
    Include(FSearchOptions, ssoSelectedOnly);
  if FReplaceDialog.cbRegExpr.Checked then
    Include(FSearchOptions, ssoRegExpr);
  Backwards := FReplaceDialog.rgDirection.ItemIndex = 1;
  if Backwards then
    Include(FSearchOptions, ssoBackwards);
  UpdateSearchActions;

  if AAction = rtaFind then
  begin
    ReportSearchResult(SearchEditor(False, Backwards));
    Exit;
  end;

  if FSearchText = '' then
    Exit;

  ReplaceOptions := FSearchOptions - [ssoBackwards, ssoFindContinue,
    ssoReplace, ssoReplaceAll, ssoPrompt];
  if AAction = rtaReplaceAll then
  begin
    Include(ReplaceOptions, ssoEntireScope);
    Include(ReplaceOptions, ssoReplaceAll);
    ReplacedCount := TargetEditor.SearchReplace(FSearchText,
      FReplaceDialog.edReplaceText.Text, ReplaceOptions);
    ReportSearchResult(ReplacedCount);
    Exit;
  end;

  if (ssoRegExpr in ReplaceOptions) and TargetEditor.SelAvail then
  begin
    Include(ReplaceOptions, ssoSelectedOnly);
    Include(ReplaceOptions, ssoEntireScope);
    Include(ReplaceOptions, ssoReplace);
    ReplacedCount := TargetEditor.SearchReplace(FSearchText,
      FReplaceDialog.edReplaceText.Text, ReplaceOptions);
  end
  else if TargetEditor.SelAvail and
    (((ssoMatchCase in ReplaceOptions) and
      (TargetEditor.SelText = FSearchText)) or
     (not (ssoMatchCase in ReplaceOptions) and
      SameText(TargetEditor.SelText, FSearchText))) then
  begin
    TargetEditor.SelText := FReplaceDialog.edReplaceText.Text;
    ReplacedCount := 1;
  end
  else
  begin
    Include(ReplaceOptions, ssoReplace);
    ReplacedCount := TargetEditor.SearchReplace(FSearchText,
      FReplaceDialog.edReplaceText.Text, ReplaceOptions);
  end;
  if ReplacedCount > 0 then
    SearchEditor(True, Backwards);
  ReportSearchResult(ReplacedCount);
end;

procedure TMainForm.acFindExecute(Sender: TObject);
begin
  InitializeSearchDialog;
  FSearchDialog.Show;
  FSearchDialog.BringToFront;
  FSearchDialog.edSearchText.SetFocus;
end;

procedure TMainForm.acFindNextExecute(Sender: TObject);
begin
  ReportSearchResult(SearchCurrentTarget(True, ssoBackwards in FSearchOptions));
end;

procedure TMainForm.acFindPrevExecute(Sender: TObject);
begin
  ReportSearchResult(SearchCurrentTarget(True, not (ssoBackwards in FSearchOptions)));
end;

procedure TMainForm.acReplaceExecute(Sender: TObject);
var
  TargetEditor: TSynEdit;
begin
  TargetEditor := ActiveEditor;
  if (FReplaceDialog.edSearchText.Text = '') then
  begin
    if FSearchText <> '' then
      FReplaceDialog.edSearchText.Text := FSearchText
    else if TargetEditor.SelAvail then
      FReplaceDialog.edSearchText.Text := TargetEditor.SelText;
  end;
  FReplaceDialog.cbMatchCase.Checked := ssoMatchCase in FSearchOptions;
  FReplaceDialog.cbWholeWord.Checked := ssoWholeWord in FSearchOptions;
  FReplaceDialog.cbEntireScope.Checked := ssoEntireScope in FSearchOptions;
  FReplaceDialog.cbSelectedOnly.Checked := ssoSelectedOnly in FSearchOptions;
  FReplaceDialog.cbRegExpr.Checked := ssoRegExpr in FSearchOptions;
  if ssoBackwards in FSearchOptions then
    FReplaceDialog.rgDirection.ItemIndex := 1
  else
    FReplaceDialog.rgDirection.ItemIndex := 0;
  FReplaceDialog.Show;
  FReplaceDialog.BringToFront;
  FReplaceDialog.edSearchText.SetFocus;
end;

procedure TMainForm.GoToLineNumberClick(Sender: TObject);
var
  TargetEditor: TSynEdit;
begin
  TargetEditor := ActiveEditor;
  FGotoLineDialog.edtLineNumber.MaxValue := TargetEditor.Lines.Count;
  FGotoLineDialog.edtLineNumber.Value := TargetEditor.CaretY;
  if FGotoLineDialog.ShowModal = mrOk then
  begin
    TargetEditor.CaretXY := Point(1, FGotoLineDialog.edtLineNumber.Value);
    TargetEditor.EnsureCursorPosVisible;
    TargetEditor.SetFocus;
  end;
end;

procedure TMainForm.UpdateEditorStatus;
begin
  if Editor.Text = FEditorBaseline then
    TabSheetEditor.Caption := 'Editor'
  else
    TabSheetEditor.Caption := 'Editor *';
  if Assigned(FDataTab) then
    if FDataEditor.Text = FDataBaseline then
      FDataTab.Caption := 'Data'
    else
      FDataTab.Caption := 'Data *';

  if (Editor.Text = FEditorBaseline) and
     (not Assigned(FDataEditor) or
      (FDataEditor.Text = FDataBaseline)) then
  begin
    if FCurrentFile <> '' then
      Caption := Format('OptiLibre - %s', [FCurrentFile])
    else
      Caption := 'OptiLibre';
  end;
  StatusBar.Invalidate;
end;

procedure TMainForm.StatusBarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
const
  PanelHints: array[0..8] of string = (
    'Cursor position in the editor (line:column)',
    'ITE: total number of simplex iterations',
    'GAP: gap between the best integer solution found and the best bound. Shown only for models with integer restrictions (not with Solve relaxed)',
    'IPS: simplex iterations per second',
    'INV: number of basis inversions (refactorizations)',
    'NOD: total number of branch-and-bound nodes explored',
    'TME: elapsed solving time in seconds',
    'Current solver status or phase',
    'Format of the model in the editor');
var
  I, PanelLeft: Integer;
  NewHint: string;
begin
  if Shift <> [] then
    Application.CancelHint;
  NewHint := '';
  PanelLeft := 0;
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    if (Y < 0) or (Y >= StatusBar.Height) then
      Break;
    if (X >= PanelLeft) and (X < PanelLeft + StatusBar.Panels[I].Width) then
    begin
      if I <= High(PanelHints) then
        NewHint := PanelHints[I];
      Break;
    end;
    Inc(PanelLeft, StatusBar.Panels[I].Width);
  end;
  if NewHint <> StatusBar.Hint then
  begin
    Application.CancelHint;
    StatusBar.Hint := NewHint;
  end;
  StatusBar.ShowHint := NewHint <> '';
end;

procedure TMainForm.StatusBarDrawPanel(AStatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  AStatusBar.Canvas.Font.Color := clWindowText;
  AStatusBar.Canvas.TextRect(Rect, Rect.Left + 4, Rect.Top, Panel.Text);
end;

procedure TMainForm.UpdateUndoRedoActions;
var
  EditorActive: Boolean;
begin
  EditorActive := (PageControl.ActivePage = TabSheetEditor) or
    (Assigned(FDataTab) and (PageControl.ActivePage = FDataTab));
  Cut2.Enabled := EditorActive;
  acUndo.Enabled := EditorActive and ActiveEditor.CanUndo and
    not ActiveEditor.ReadOnly;
  acRedo.Enabled := EditorActive and ActiveEditor.CanRedo and
    not ActiveEditor.ReadOnly;
  acReplace.Enabled := EditorActive;
end;

procedure TMainForm.UpdateSearchActions;
begin
  acFindNext.Enabled := FSearchText <> '';
  acFindPrev.Enabled := FSearchText <> '';
end;

procedure TMainForm.UpdateViewFormat;
begin
  if Assigned(FModelHighlighter) then
  begin
    case FScriptFormat of
      sfMPS, sfFreeMPS: FModelHighlighter.Syntax := msMPS;
      sfMathProg: FModelHighlighter.Syntax := msMathProg;
    else
      FModelHighlighter.Syntax := msLP;
    end;
    Editor.Highlighter := FModelHighlighter;
    if Assigned(FDataEditor) then
      FDataEditor.Highlighter := FModelHighlighter;
  end;
  if (FLastSolvedLP <> 0) and (FLastSolvedFormat <> FScriptFormat) then
  begin
    delete_lp(FLastSolvedLP);
    FLastSolvedLP := 0;
    FLastSolvedSource := '';
    Savebasis1.Enabled := False;
  end;
  case FScriptFormat of
    sfMPS: StatusBar.Panels[8].Text := 'Fixed MPS';
    sfFreeMPS: StatusBar.Panels[8].Text := 'Free MPS';
    sfLP: StatusBar.Panels[8].Text := 'LP';
    sfMathProg: StatusBar.Panels[8].Text := 'MathProg';
  else
    StatusBar.Panels[8].Text := '';
  end;
  FMatrixDirty := True;
end;

procedure TMainForm.SelectViewFormat;
begin
  LP1.Checked := FScriptFormat = sfLP;
  MPS1.Checked := FScriptFormat = sfMPS;
  FreeMPS1.Checked := FScriptFormat = sfFreeMPS;
  MathProg1.Checked := FScriptFormat = sfMathProg;
  UpdateViewFormat;
end;

function IsFixedMPS(const Lines: TStrings): Boolean; forward;
function IsMPSModel(const Lines: TStrings): Boolean; forward;

function TMainForm.ConvertModelFormat(var NewFormat: TScriptFormat): Boolean;
var
  LP: THandle;
  TempFile, MathProgMPSFile, LoadError, OutputFile, DataPath,
    MatchingDataFile, TempDataFile, ModelCheckFile: string;
  ModelHasDataSection, UseDataOverride, DataAccepted: Boolean;
  ConvertedLines: TStringList;

  procedure OfferPartialResult(const PartialFile, ErrorMessage: string;
    PartialFormat: TScriptFormat; AskConfirmation: Boolean);
  var
    ReadError: string;
  begin
    if (PartialFile = '') or not FileExists(PartialFile) then
    begin
      MessageDlgEnglish('Could not convert the model: ' + ErrorMessage,
        mtError, [mbOK], 0);
      Exit;
    end;

    ConvertedLines := TStringList.Create;
    try
      ReadError := '';
      try
        ConvertedLines.LoadFromFile(PartialFile);
      except
        on E: Exception do
          ReadError := E.Message;
      end;
      if (ConvertedLines.Count = 0) then
      begin
        if ReadError <> '' then
          MessageDlgEnglish('Could not convert the model: ' + ErrorMessage +
            LineEnding + 'Could not read the partial result: ' + ReadError,
            mtError, [mbOK], 0)
        else
          MessageDlgEnglish('Could not convert the model: ' + ErrorMessage,
            mtError, [mbOK], 0);
        Exit;
      end;

      if AskConfirmation and
         (MessageDlgEnglish(
           'The conversion reported an error: ' + ErrorMessage + LineEnding +
           'A partial result is available. Do you want to continue and display it? The open data editor will be closed.',
           mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
          Exit;

      if Assigned(FDataTab) and not CloseDataEditor then
        Exit;
      PageControl.ActivePage := TabSheetEditor;
      Editor.Lines.Assign(ConvertedLines);
      Editor.ClearUndo;
      Editor.Modified := Editor.Text <> FEditorBaseline;
      SetCurrentFile('');
      UpdateEditorStatus;
      CheckGutter;
      UpdateUndoRedoActions;
      Editor.Invalidate;
      Editor.Update;
      Editor.SetFocus;
      NewFormat := PartialFormat;
      Result := True;
    finally
      ConvertedLines.Free;
    end;
  end;
begin
  Result := False;
  if NewFormat = FScriptFormat then
    Exit(True);
  if FIsSolving then
  begin
    MessageDlgEnglish('The model format cannot be changed while solving.',
      mtInformation, [mbOK], 0);
    Exit;
  end;
  if not (NewFormat in [sfLP, sfMPS, sfFreeMPS, sfMathProg]) then
  begin
    MessageDlgEnglish(
      'Conversion to the selected format is not supported.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  if not ConfirmSaveChanges then
    Exit;

  LP := 0;
  TempFile := '';
  MathProgMPSFile := '';
  OutputFile := '';
  TempDataFile := '';
  ModelCheckFile := '';
  DataPath := '';
  UseDataOverride := False;
  DataAccepted := True;
  LoadError := '';
  try
    try
    if FScriptFormat = sfMathProg then
    begin
      ModelCheckFile := GetTempFileName(GetTempDir(False), 'opti');
      Editor.Lines.SaveToFile(ModelCheckFile);
      ModelHasDataSection := HasDataSection(ModelCheckFile);
      if not ModelHasDataSection then
      begin
        MatchingDataFile := '';
        if (FCurrentFile <> '') then
        begin
          MatchingDataFile := ChangeFileExt(FCurrentFile, '.dat');
          if not FileExists(MatchingDataFile) then
            MatchingDataFile := '';
        end;

        if Assigned(FDataEditor) or (MatchingDataFile <> '') then
        begin
          if Assigned(FDataEditor) and (FDataFile <> '') then
            DataPath := FDataFile
          else if MatchingDataFile <> '' then
            DataPath := MatchingDataFile
          else
            DataPath := 'the open data editor';

          case MessageDlgEnglish(
            Format('A MathProg data file is available (%s). Do you want to use it for the conversion?',
              [DataPath]), mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
            mrYes:
              begin
                UseDataOverride := True;
                if Assigned(FDataEditor) then
                begin
                  TempDataFile := GetTempFileName(GetTempDir(False), 'opti');
                  FDataEditor.Lines.SaveToFile(TempDataFile);
                  DataPath := TempDataFile;
                end;
              end;
            mrNo:
              UseDataOverride := True;
            else
              DataAccepted := False;
          end;
        end;
      end;
    end;
    if not DataAccepted then
      Exit;

    LP := LoadLPFromEditor(TempFile, MathProgMPSFile, LoadError, NEUTRAL,
      DataPath, UseDataOverride);
    if LP = 0 then
    begin
      if LoadError = '' then
        LoadError := 'The model could not be loaded in its current format.';
      if (MathProgMPSFile <> '') and FileExists(MathProgMPSFile) then
      begin
        ConvertedLines := TStringList.Create;
        try
          ConvertedLines.LoadFromFile(MathProgMPSFile);
          if ConvertedLines.Count > 0 then
          begin
            if MessageDlgEnglish(
              'The conversion reported an error: ' + LoadError +
              LineEnding + 'A partial MPS result is available. Do you want to continue and display it?',
              mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
              Exit;

            LP := read_freeMPS(PChar(MathProgMPSFile), NEUTRAL);
            if LP = 0 then
            begin
              OfferPartialResult(MathProgMPSFile, LoadError, sfFreeMPS,
                False);
              Exit;
            end;
          end
          else
          begin
            MessageDlgEnglish('Could not convert the model: ' + LoadError,
              mtError, [mbOK], 0);
            Exit;
          end;
        finally
          ConvertedLines.Free;
        end;
      end
      else
      begin
        MessageDlgEnglish('Could not convert the model: ' + LoadError,
          mtError, [mbOK], 0);
        Exit;
      end;
    end;

    OutputFile := GetTempFileName(GetTempDir(False), 'opti');
    case NewFormat of
      sfLP:
        if not write_lp(LP, PChar(OutputFile)) then
          raise Exception.Create('lp_solve could not write LP format.');
      sfMPS:
        if not write_mps(LP, PChar(OutputFile)) then
          raise Exception.Create('lp_solve could not write fixed MPS format.');
      sfFreeMPS:
        if not write_freemps(LP, PChar(OutputFile)) then
          raise Exception.Create('lp_solve could not write free MPS format.');
      sfMathProg:
        if not WriteMathProgModel(LP, OutputFile, LoadError) then
          raise Exception.Create('Could not write MathProg format. ' + LoadError);
    end;

    ConvertedLines := TStringList.Create;
    try
      ConvertedLines.LoadFromFile(OutputFile);
      if Assigned(FDataTab) and not CloseDataEditor then
        Exit;
      PageControl.ActivePage := TabSheetEditor;
      Editor.Lines.Assign(ConvertedLines);
    finally
      ConvertedLines.Free;
    end;
    Editor.ClearUndo;
    Editor.Modified := Editor.Text <> FEditorBaseline;
    SetCurrentFile('');
    UpdateEditorStatus;
    CheckGutter;
    UpdateUndoRedoActions;
    Editor.Invalidate;
    Editor.Update;
    Editor.SetFocus;
    Result := True;
  except
    on E: Exception do
    begin
      OfferPartialResult(OutputFile, E.Message, NewFormat, True);
    end;
    end;
  finally
    if LP <> 0 then
      delete_lp(LP);
    if (TempFile <> '') and FileExists(TempFile) then
      DeleteFile(TempFile);
    if (MathProgMPSFile <> '') and FileExists(MathProgMPSFile) then
      DeleteFile(MathProgMPSFile);
    if (OutputFile <> '') and FileExists(OutputFile) then
      DeleteFile(OutputFile);
    if (TempDataFile <> '') and FileExists(TempDataFile) then
      DeleteFile(TempDataFile);
    if (ModelCheckFile <> '') and FileExists(ModelCheckFile) then
      DeleteFile(ModelCheckFile);
  end;
end;

procedure TMainForm.PriorityPanelClick(Sender: TObject);
begin

end;

procedure TMainForm.SetCurrentFile(filename: string);
begin
  FCurrentFile := filename;
  FMatrixDirty := True;
  UpdateEditorStatus;
end;

procedure TMainForm.CheckGutter;
begin
  if FLastLineCount <> Editor.Lines.Count then
  begin
    FLastLineCount := Editor.Lines.Count;
    Editor.Gutter.LeftOffset :=
      Editor.Canvas.TextWidth(IntToStr(Editor.Lines.Count));
  end;
end;

procedure TMainForm.NewScript(ScFormat: TScriptFormat);
begin
  if not ConfirmSaveChanges then
    Exit;

  ClearResultTables;
  FScriptFormat := ScFormat;
  Editor.Clear;
  case FScriptFormat of
    sfLP:
      begin
        Editor.Lines.Add('/* Objective function */');
        Editor.Lines.Add('min: ;');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Variable bounds */');
      end;
    sfMPS, sfFreeMPS:
      begin
        Editor.Lines.Add('* MPS file created by lp_solve v5.0!');
        Editor.Lines.Add('* Model constraints = 0 (of which 0 equalities)');
        Editor.Lines.Add('*       variables   = 0 (of which 0 integer-valued and 0 semi-continuous)');
        Editor.Lines.Add('*');
        Editor.Lines.Add('NAME');
        Editor.Lines.Add('ROWS');
        Editor.Lines.Add(' N  R0');
        Editor.Lines.Add('COLUMNS');
        Editor.Lines.Add('RHS');
        Editor.Lines.Add('ENDATA');
      end;
    sfMathProg:
      begin
        Editor.Lines.Add('/* Set definitions */');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Param definitions */');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Variable definitions */');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Objective function */');
        Editor.Lines.Add('minimize obj: ;');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Constraints */');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Data section */');
        Editor.Lines.Add('data;');
        Editor.Lines.Add('');
        Editor.Lines.Add('end;');
      end;
  end;
  Editor.ClearUndo;
  UpdateUndoRedoActions;
  SelectViewFormat;
  SetCurrentFile('');
  Editor.Modified := False;
  FEditorBaseline := Editor.Text;
  UpdateEditorStatus;
  CheckGutter;
end;

procedure TMainForm.MenuAboutClick(Sender: TObject);
var
  AboutDialog: TAboutForm;
begin
  AboutDialog := TAboutForm.Create(Self);
  try
    AboutDialog.ShowModal;
  finally
    AboutDialog.Free;
  end;
end;

procedure TMainForm.MenuHelpClick(Sender: TObject);
begin
  ShowHelpTopic('lp_solve.htm');
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Topic: string;
begin
  if (Key <> VK_F1) or (Shift <> []) then
    Exit;
  Key := 0;
  Topic := '';
  if (ActiveControl <> nil) and FOptionsPanel.IsParentOf(ActiveControl) then
  begin
    Topic := FOptionsPanel.HelpTopicOf(ActiveControl);
    if Topic = '' then
      Topic := 'lp_solve.htm';
  end;
  ShowHelpTopic(Topic);
end;

procedure TMainForm.MenuCommandClick(Sender: TObject);
begin
  // This handler is also assigned to non-View menu commands.
end;

procedure TMainForm.ViewFormatClick(Sender: TObject);
var
  TargetFormat: TScriptFormat;
begin
  if Sender = LP1 then
    TargetFormat := sfLP
  else if Sender = MPS1 then
    TargetFormat := sfMPS
  else if Sender = FreeMPS1 then
    TargetFormat := sfFreeMPS
  else if Sender = MathProg1 then
    TargetFormat := sfMathProg
  else
    Exit;

  if TargetFormat = FScriptFormat then
  begin
    SelectViewFormat;
    Exit;
  end;

  if ConvertModelFormat(TargetFormat) then
    FScriptFormat := TargetFormat;
  SelectViewFormat;
end;

procedure TMainForm.SolverLog(Log: PChar);
var
  LogLine, LowerLogLine: string;
  GapStart, GapEnd: Integer;
  GapPercent: Double;
  GapFormatSettings: TFormatSettings;
begin
  if Log <> nil then
  begin
    LogLine := Trim(NormalizeMessageLineBreaks(StrPas(Log)));
    AddMessageText(MemoLog.Lines, LogLine);
    MemoLog.CaretXY := Point(1, MemoLog.Lines.Count);
    MemoLog.EnsureCursorPosVisible;
    if FHasIntegerVariables then
    begin
      LowerLogLine := LowerCase(LogLine);
      if Pos('solution', LowerLogLine) > 0 then
        GapStart := Pos('gap ', LowerLogLine)
      else
        GapStart := 0;
      if GapStart > 0 then
      begin
        Inc(GapStart, Length('gap '));
        GapEnd := GapStart;
        while (GapEnd <= Length(LogLine)) and
          (LogLine[GapEnd] in ['0'..'9', '.']) do
          Inc(GapEnd);
        if (GapEnd > GapStart) and (GapEnd <= Length(LogLine)) and
           (LogLine[GapEnd] = '%') then
        begin
          FFinalReportedGap := Copy(LogLine, GapStart, GapEnd - GapStart);
          GapFormatSettings := DefaultFormatSettings;
          GapFormatSettings.DecimalSeparator := '.';
          if TryStrToFloat(FFinalReportedGap, GapPercent,
            GapFormatSettings) then
            UpdateGapDisplay(GapPercent);
        end;
      end;
    end;
  end;

  // Rebind after form/resource initialization so menu actions cannot replace
  // the callbacks loaded from the LFM.
  LP1.Action := nil;
  MPS1.Action := nil;
  FreeMPS1.Action := nil;
  MathProg1.Action := nil;
  LP1.RadioItem := False;
  MPS1.RadioItem := False;
  FreeMPS1.RadioItem := False;
  MathProg1.RadioItem := False;
  LP1.AutoCheck := False;
  MPS1.AutoCheck := False;
  FreeMPS1.AutoCheck := False;
  MathProg1.AutoCheck := False;
  LP1.OnClick := @ViewFormatClick;
  MPS1.OnClick := @ViewFormatClick;
  FreeMPS1.OnClick := @ViewFormatClick;
  MathProg1.OnClick := @ViewFormatClick;
end;

procedure TMainForm.UpdateGapDisplay(GapPercent: Double);
begin
  if IsNan(GapPercent) or IsInfinite(GapPercent) then
    Exit;
  if (FBestIterationGap >= 0) and (GapPercent >= FBestIterationGap) then
    Exit;

  FBestIterationGap := GapPercent;
  StatusBar.Panels[2].Text := Format('GAP: %.2f%%', [FBestIterationGap]);
  StatusBar.Invalidate;
  StatusBar.Update;
end;

procedure TMainForm.UpdateGapFromSolver(LP: PtrUInt; CaptureRoot: Boolean);
var
  Incumbent, Bound: Double;
begin
  if not FHasIntegerVariables then
    Exit;
  if CaptureRoot and not FHasRootBound then
  begin
    Bound := get_working_objective(LP);
    if not IsNan(Bound) and (Abs(Bound) < 1e15) then
    begin
      FRootBound := Bound;
      FHasRootBound := True;
    end;
  end;
  if not FHasRootBound or (get_solutioncount(LP) <= 0) then
    Exit;
  Incumbent := get_objective(LP);
  if IsNan(Incumbent) or (Abs(Incumbent) >= 1e15) then
    Exit;
  UpdateGapDisplay(Abs(FRootBound - Incumbent) / (1 + Abs(Incumbent)) * 100);
end;

procedure TMainForm.SolverAbort(var Abort: Boolean);
begin
  if (GetTickCount64 - FLastAbortCheck) > 50 then
  begin
    FLastAbortCheck := GetTickCount64;
    Application.ProcessMessages;
  end;
  Abort := FAbortRequested;
end;

procedure TMainForm.SolverProgress(LP: PtrUInt; Message: Integer);
var
  TotalIterations, ElapsedSeconds: Int64;
  ResultHeader: string;
begin
  StatusBar.Panels[5].Text := 'NOD: ' + IntToStr(get_total_nodes(LP));
  case Message of
    MSG_PRESOLVE: StatusBar.Panels[7].Text := 'Presolve';
    MSG_ITERATION:
      begin
        TotalIterations := get_total_iter(LP);
        ElapsedSeconds := Trunc(time_elapsed(LP));
        StatusBar.Panels[1].Text := 'ITE: ' + IntToStr(TotalIterations);
        UpdateGapFromSolver(LP, False);
        if ElapsedSeconds > 0 then
          StatusBar.Panels[3].Text := 'IPS: ' +
            IntToStr(TotalIterations div ElapsedSeconds);
        StatusBar.Panels[6].Text := Format('TME: %.2f', [time_elapsed(LP)]);
        StatusBar.Panels[7].Text := 'Iteration';
      end;
    MSG_INVERT:
      begin
        Inc(FInvertCount);
        StatusBar.Panels[4].Text := 'INV: ' + IntToStr(FInvertCount);
        StatusBar.Panels[7].Text := 'Invert';
      end;
    MSG_LPFEASIBLE:
      begin
        StatusBar.Panels[7].Text := 'LP feasible';
        UpdateGapFromSolver(LP, False);
      end;
    MSG_LPOPTIMAL:
      begin
        StatusBar.Panels[7].Text := 'LP optimal';
        UpdateGapFromSolver(LP, True);
      end;
    MSG_LPEQUAL: StatusBar.Panels[7].Text := 'LP equal';
    MSG_LPBETTER: StatusBar.Panels[7].Text := 'LP better';
    MSG_MILPFEASIBLE, MSG_MILPEQUAL, MSG_MILPBETTER:
      begin
        case Message of
          MSG_MILPFEASIBLE: StatusBar.Panels[7].Text := 'MILP feasible';
          MSG_MILPEQUAL: StatusBar.Panels[7].Text := 'MILP equal';
        else
          StatusBar.Panels[7].Text := 'MILP better';
        end;
        UpdateGapFromSolver(LP, False);
      end;
    MSG_MILPSTRATEGY: StatusBar.Panels[7].Text := 'MILP strategy';
    MSG_MILPOPTIMAL: StatusBar.Panels[7].Text := 'MILP optimal';
    MSG_PERFORMANCE: StatusBar.Panels[7].Text := 'Performance';
    MSG_INITPSEUDOCOST: StatusBar.Panels[7].Text := 'Initializing MILP';
  end;

  if FHasIntegerVariables and
     ((Message = MSG_MILPBETTER) or
      ((FIntegerBestCount = 0) and (Message = MSG_MILPFEASIBLE))) then
  begin
    if FIntegerBestCount = 0 then
      ResultHeader := 'MILP Feasible'
    else
      ResultHeader := 'MILP Better';
    try
      AddCurrentResult(LP, ResultHeader, False);
      Inc(FIntegerBestCount);
    except
      on E: Exception do
      begin
        FIntegerSolutionCaptureError := E.Message;
        FAbortRequested := True;
      end;
    end;
  end;
end;

procedure TMainForm.ClearOutput1Click(Sender: TObject);
begin
  if OutputPopupMenu.PopupComponent = MemoLog then
    MemoLog.Clear
  else if OutputPopupMenu.PopupComponent = MemoMessages then
    MemoMessages.Clear;
end;

function TMainForm.LoadLPFromEditor(var TempFile, MathProgMPSFile: string;
  out LoadError: string; Verbose: Integer;
  const DataFileOverride: string; UseDataFileOverride: Boolean): THandle;
var
  MathProgDataPath, MathProgDataTempFile, TempDirectory: string;
  MathProgMaximize: Boolean;
  MathProgDataLoaded, MathProgConverted: Boolean;
  MPSIsFixed: Boolean;
  MathProgObjectiveConstant: Double;
  MPSLines: TStringList;
  {$IFDEF OPTILIBRE_WINDOWS}
  MathProgDataTempDirectory: string;
  function SaveLinesToTempFile(Lines: TStrings;
    const PreferredDirectory: string): string;
  var
    FallbackDirectory: string;
  begin
    Result := '';
    try
      Result := GetTempFileName(PreferredDirectory, 'opti');
      Lines.SaveToFile(Result);
    except
      on E: Exception do
      begin
        if Result <> '' then
          DeleteFile(Result);
        FallbackDirectory := GetTempDir(False);
        if SameText(
          IncludeTrailingPathDelimiter(ExpandFileName(PreferredDirectory)),
          IncludeTrailingPathDelimiter(ExpandFileName(FallbackDirectory))) then
          raise;
        Result := GetTempFileName(FallbackDirectory, 'opti');
        try
          Lines.SaveToFile(Result);
        except
          if FileExists(Result) then
            DeleteFile(Result);
          raise;
        end;
      end;
    end;
  end;
  {$ENDIF}
begin
  Result := 0;
  TempFile := '';
  MathProgMPSFile := '';
  MathProgDataTempFile := '';
  LoadError := '';

  {$IFDEF OPTILIBRE_WINDOWS}
  if (FScriptFormat = sfMathProg) and (FCurrentFile <> '') then
    TempDirectory := ExtractFilePath(FCurrentFile)
  else
    TempDirectory := GetTempDir(False);
  TempFile := SaveLinesToTempFile(Editor.Lines, TempDirectory);
  {$ELSE}
  TempDirectory := GetTempDir(False);
  TempFile := GetTempFileName(TempDirectory, 'opti');
  Editor.Lines.SaveToFile(TempFile);
  {$ENDIF}

  case FScriptFormat of
    sfLP, sfMPS, sfFreeMPS:
      begin
        MPSLines := TStringList.Create;
        try
          MPSLines.LoadFromFile(TempFile);
          if (FScriptFormat in [sfMPS, sfFreeMPS]) or
             SameText(ExtractFileExt(FCurrentFile), '.mps') or
             IsMPSModel(MPSLines) then
          begin
            MPSIsFixed := IsFixedMPS(MPSLines);
            if MPSIsFixed then
              Result := read_MPS(PChar(TempFile), Verbose)
            else
              Result := read_freeMPS(PChar(TempFile), Verbose);
          end
          else
            Result := read_LP(PChar(TempFile), Verbose, '');
        finally
          MPSLines.Free;
        end;
      end;
    sfMathProg:
      begin
        MathProgMPSFile := GetTempFileName(GetTempDir(False), 'opti');
        if UseDataFileOverride then
          MathProgDataPath := DataFileOverride
        else if FUseDataFile and Assigned(FDataEditor) then
        begin
          if (FDataFile <> '') and not FDataEditor.Modified and
             FileExists(FDataFile) then
            MathProgDataPath := FDataFile
          else
          begin
            {$IFDEF OPTILIBRE_WINDOWS}
            if FDataFile <> '' then
              MathProgDataTempDirectory := ExtractFilePath(FDataFile)
            else
              MathProgDataTempDirectory := TempDirectory;
            MathProgDataTempFile := SaveLinesToTempFile(FDataEditor.Lines,
              MathProgDataTempDirectory);
            {$ELSE}
            // The generated MPS name has not been reserved yet.
            MathProgDataTempFile := GetTempFileName(TempDirectory, 'optd');
            {$ENDIF}
            MathProgDataPath := MathProgDataTempFile;
          end;
        end
        else
          MathProgDataPath := '';
        try
          {$IFNDEF OPTILIBRE_WINDOWS}
          if MathProgDataTempFile <> '' then
            FDataEditor.Lines.SaveToFile(MathProgDataTempFile);
          {$ENDIF}
          MathProgConverted := ConvertMathProgToMPS(TempFile,
            MathProgDataPath, MathProgMPSFile, MathProgMaximize,
            MathProgObjectiveConstant, MathProgDataLoaded, LoadError);
        finally
          if MathProgDataTempFile <> '' then
            DeleteFile(MathProgDataTempFile);
        end;
        if MathProgDataLoaded then
          MemoMessages.Lines.Add(Format('Using data file: %s',
            [MathProgDataPath]));
        if not MathProgConverted then
          Exit;
        Result := read_freeMPS(PChar(MathProgMPSFile), Verbose);
        if Result <> 0 then
        begin
          set_sense(Result, MathProgMaximize);
          set_rh(Result, 0, MathProgObjectiveConstant);
        end;
      end;
  else
    LoadError := 'The selected script format is not supported.';
  end;

  if (Result = 0) and (LoadError = '') then
    if FScriptFormat = sfMathProg then
      LoadError := 'Could not load the generated MathProg problem.'
    else
      LoadError := 'Parse error: the script could not be loaded.';
end;

function TMainForm.DefaultOptionsFile: string;
begin
  Result := IncludeTrailingPathDelimiter(GetAppConfigDir(False)) + 'default.ini';
end;

function TMainForm.UISettingsFile: string;
begin
  Result := IncludeTrailingPathDelimiter(GetAppConfigDir(False)) + 'ui.ini';
end;

// Applies the shared text size to every text editor and table of the main window.
procedure TMainForm.ApplyFontSize;
var
  Target: TSynEdit;
  Grid: TStringGrid;
  GridSize, CurrentSize, OldHeight, NewHeight, Row, Column: Integer;
begin
  for Target in [Editor, MemoLog, MemoMessages, FDataEditor] do
    if Target <> nil then
      Target.Font.Size := FFontSize;

  // Tables keep their own base size and follow the same increment.
  GridSize := Max(6, FGridBaseFontSize + FFontSize - FDefaultFontSize);
  for Grid in [ObjectiveTable, ConstraintTable, ObjectiveSensTable,
    RHSSensTable, MatrixTable] do
  begin
    if Grid = nil then
      Continue;
    CurrentSize := Abs(Grid.Font.Size);
    if CurrentSize = 0 then
      CurrentSize := FGridBaseFontSize;
    if CurrentSize = GridSize then
      Continue;
    Grid.Canvas.Font.Assign(Grid.Font);
    OldHeight := Grid.Canvas.TextHeight('Wg');
    Grid.Font.Size := GridSize;
    Grid.TitleFont.Size := GridSize;
    Grid.Canvas.Font.Assign(Grid.Font);
    NewHeight := Grid.Canvas.TextHeight('Wg');
    Grid.BeginUpdate;
    try
      // Row height follows the text height from the initial look; hidden
      // (filtered) rows keep a zero height.
      Grid.DefaultRowHeight :=
        FGridBaseRowHeight + NewHeight - FGridBaseTextHeight;
      for Row := 0 to Grid.RowCount - 1 do
        if Grid.RowHeights[Row] > 0 then
          Grid.RowHeights[Row] := Grid.DefaultRowHeight;
      for Column := 0 to Grid.ColCount - 1 do
        Grid.ColWidths[Column] :=
          Round(Grid.ColWidths[Column] * NewHeight / OldHeight);
      Grid.DefaultColWidth := Round(Grid.DefaultColWidth * NewHeight / OldHeight);
    finally
      Grid.EndUpdate;
    end;
  end;
  if FFilterEdit <> nil then
    FFilterEdit.Font.Size := GridSize;
end;

// Delta = 0 restores the default size.
procedure TMainForm.ChangeFontSize(Delta: Integer);
var
  NewSize: Integer;
begin
  if Delta = 0 then
    NewSize := FDefaultFontSize
  else
    NewSize := EnsureRange(FFontSize + Delta, 6, 48);
  if NewSize = FFontSize then
    Exit;
  FFontSize := NewSize;
  ApplyFontSize;
end;

function TMainForm.ConfirmSaveDisplaySettings: Boolean;
begin
  Result := True;
  if (FFontSize = FSavedFontSize) and
     (FClearOutputOnSolve = FSavedClearOutputOnSolve) then
    Exit;
  case MessageDlgEnglish(
    'The display settings have changed, do you want to save them as default ?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    mrYes:
      try
        SaveDisplaySettings(UISettingsFile);
      except
        on E: Exception do
        begin
          MessageDlgEnglish('Could not save the display settings: ' + E.Message,
            mtError, [mbOK], 0);
          Result := False;
        end;
      end;
    mrNo: ;
  else
    Result := False;
  end;
end;

procedure TMainForm.SaveDisplaySettings(const FileName: string);
var
  Ini: TIniFile;
begin
  ForceDirectories(ExtractFilePath(FileName));
  Ini := TIniFile.Create(FileName);
  try
    Ini.WriteInteger('Text', 'FontSize', FFontSize);
    Ini.WriteBool('Display', 'ClearOutputOnSolve',
      FClearOutputOnSolve);
  finally
    Ini.Free;
  end;
  FSavedFontSize := FFontSize;
  FSavedClearOutputOnSolve := FClearOutputOnSolve;
end;

function TMainForm.LoadDisplaySettings(const FileName: string): Boolean;
var
  Ini: TIniFile;
begin
  Result := FileExists(FileName);
  if not Result then
    Exit;
  Ini := TIniFile.Create(FileName);
  try
    FFontSize := EnsureRange(Ini.ReadInteger('Text', 'FontSize',
      FDefaultFontSize), 6, 48);
    FClearOutputOnSolve :=
      Ini.ReadBool('Display', 'ClearOutputOnSolve', True);
  finally
    Ini.Free;
  end;
  FSavedFontSize := FFontSize;
  FSavedClearOutputOnSolve := FClearOutputOnSolve;
  UpdateClearOutputOnSolveItem;
  ApplyFontSize;
end;

procedure TMainForm.UpdateClearOutputOnSolveItem;
begin
  ClearOutputOnSolve1.ImageIndex := -1;
  if FClearOutputOnSolve then
    ClearOutputOnSolve1.ImageIndex := 31
  else
    ClearOutputOnSolve1.ImageIndex := 30;
end;

procedure TMainForm.ClearOutputOnSolveClick(Sender: TObject);
begin
  FClearOutputOnSolve := not FClearOutputOnSolve;
  UpdateClearOutputOnSolveItem;
end;

procedure TMainForm.SaveDisplaySettingsClick(Sender: TObject);
begin
  if FDisplayDialogSave.Execute then
    try
      SaveDisplaySettings(FDisplayDialogSave.FileName);
    except
      on E: Exception do
        MessageDlgEnglish('Could not save the display settings: ' + E.Message,
          mtError, [mbOK], 0);
    end;
end;

procedure TMainForm.LoadDisplaySettingsClick(Sender: TObject);
begin
  if not FDisplayDialogOpen.Execute then
    Exit;
  try
    if not LoadDisplaySettings(FDisplayDialogOpen.FileName) then
      MessageDlgEnglish('Could not load the display settings.', mtError,
        [mbOK], 0);
  except
    on E: Exception do
      MessageDlgEnglish('Could not load the display settings: ' + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.FontSizeClick(Sender: TObject);
begin
  ChangeFontSize(TComponent(Sender).Tag);
end;

{$PUSH}
{$HINTS OFF}
procedure TMainForm.EditorMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if ssCtrl in Shift then
  begin
    ChangeFontSize(Sign(WheelDelta));
    Handled := True;
  end;
end;
{$POP}

function TMainForm.CollectOptions: Boolean;
var
  O: TSolverOptions;
  Error: string;
begin
  O := FOptions;
  Result := FOptionsPanel.TryGetOptions(O, Error);
  if Result then
    FOptions := O
  else
  begin
    PageControl1.ActivePage := TabSheetOptions;
    MessageDlgEnglish(Error, mtError, [mbOK], 0);
  end;
end;

function TMainForm.OptionsModified: Boolean;
var
  O: TSolverOptions;
  Error: string;
begin
  if FOptionsCorrected then
    Exit(True);
  O := FOptions;
  if not FOptionsPanel.TryGetOptions(O, Error) then
    Exit(True);
  Result := not CompareMem(@O, @FSavedOptions, SizeOf(O));
end;

function TMainForm.ConfirmSaveOptions: Boolean;
const
  ButtonCaptions: array[0..3] of string = ('Yes', 'Save as...', 'No', 'Cancel');
  ButtonResults: array[0..3] of TModalResult = (mrYes, mrYesToAll, mrNo,
    mrCancel);
  ButtonGap = 8;
  Margin = 12;
var
  Dialog: TForm;
  Buttons: array[0..3] of TCustomButton;
  I, ButtonWidth, TotalWidth, NextLeft: Integer;
  Answer: Integer;
begin
  Result := True;
  if not OptionsModified then
    Exit;
  Dialog := CreateMessageDialog(
    'The solver options have changed, do you want to save them as default ?',
    mtConfirmation, [mbYes, mbNo, mbCancel]);
  try
    for I := 0 to 3 do
      Buttons[I] := nil;
    for I := 0 to Dialog.ComponentCount - 1 do
      if Dialog.Components[I] is TCustomButton then
        case TCustomButton(Dialog.Components[I]).ModalResult of
          mrYes: Buttons[0] := TCustomButton(Dialog.Components[I]);
          mrNo: Buttons[2] := TCustomButton(Dialog.Components[I]);
          mrCancel: Buttons[3] := TCustomButton(Dialog.Components[I]);
        end;
    Buttons[1] := TBitBtn.Create(Dialog);
    Buttons[1].Parent := Buttons[0].Parent;
    ImageList.GetBitmap(acSaveAs.ImageIndex, TBitBtn(Buttons[1]).Glyph);

    if (Buttons[0] = nil) or (Buttons[2] = nil) or (Buttons[3] = nil) then
      Abort;
    ButtonWidth := 90;
    for I := 0 to 3 do
    begin
      Buttons[I].Caption := ButtonCaptions[I];
      Buttons[I].ModalResult := ButtonResults[I];
      Buttons[I].AutoSize := False;
      Buttons[I].Anchors := [akLeft, akTop];
      Buttons[I].AnchorSideLeft.Control := nil;
      Buttons[I].AnchorSideTop.Control := nil;
      Buttons[I].AnchorSideBottom.Control := nil;
      Buttons[I].AnchorSideRight.Control := nil;
      Buttons[I].Top := Buttons[0].Top;
      Buttons[I].Height := Buttons[0].Height;
      if Dialog.Canvas.TextWidth(ButtonCaptions[I]) + 24 > ButtonWidth then
        ButtonWidth := Dialog.Canvas.TextWidth(ButtonCaptions[I]) + 24;
    end;
    TotalWidth := 4 * ButtonWidth + 3 * ButtonGap;
    if Dialog.ClientWidth < TotalWidth + 2 * Margin then
      Dialog.ClientWidth := TotalWidth + 2 * Margin;
    NextLeft := (Dialog.ClientWidth - TotalWidth) div 2;
    for I := 0 to 3 do
    begin
      Buttons[I].SetBounds(NextLeft, Buttons[I].Top, ButtonWidth,
        Buttons[I].Height);
      Inc(NextLeft, ButtonWidth + ButtonGap);
    end;
    Answer := Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
  case Answer of
    mrYesToAll:
      begin
        if not CollectOptions then
          Exit(False);
        if not FOptionsDialogSave.Execute then
          Exit(False);
        try
          SaveSolverOptions(FOptionsDialogSave.FileName, FOptions);
          FSavedOptions := FOptions;
          FOptionsCorrected := False;
        except
          on E: Exception do
          begin
            MessageDlgEnglish('Could not save the solver options: ' + E.Message,
              mtError, [mbOK], 0);
            Result := False;
          end;
        end;
      end;
    mrYes:
      begin
        if not CollectOptions then
          Exit(False);
        ForceDirectories(ExtractFilePath(DefaultOptionsFile));
        try
          SaveSolverOptions(DefaultOptionsFile, FOptions);
          FSavedOptions := FOptions;
          FOptionsCorrected := False;
          FOptionsPanel.CommitBaseline;
        except
          on E: Exception do
          begin
            MessageDlgEnglish('Could not save the default solver options: ' +
              E.Message, mtError, [mbOK], 0);
            Result := False;
          end;
        end;
      end;
    mrNo: ;
  else
    Result := False;
  end;
end;

procedure TMainForm.SaveOptionsClick(Sender: TObject);
begin
  if not CollectOptions then
    Exit;
  if FOptionsDialogSave.Execute then
  begin
    try
      SaveSolverOptions(FOptionsDialogSave.FileName, FOptions);
      FSavedOptions := FOptions;
      FOptionsCorrected := False;
    except
      on E: Exception do
        MessageDlgEnglish('Could not save the solver options: ' + E.Message,
          mtError, [mbOK], 0);
    end;
  end;
end;

procedure TMainForm.LoadOptionsClick(Sender: TObject);
var
  O: TSolverOptions;
  Problems: TStringList;
begin
  if not FOptionsDialogOpen.Execute then
    Exit;
  O := FOptions;
  Problems := TStringList.Create;
  try
    if LoadSolverOptions(FOptionsDialogOpen.FileName, O, Problems) then
    begin
      FOptions := O;
      FOptionsPanel.ShowOptions(FOptions);
      FOptionsPanel.MarkCorrectedOptions(Problems);
      FSavedOptions := FOptions;
      FOptionsCorrected := Problems.Count > 0;
      ReportOptionProblems(Problems);
    end
    else
      MessageDlgEnglish('Could not load the solver options.', mtError, [mbOK], 0);
  finally
    Problems.Free;
  end;
end;

procedure TMainForm.SaveDefaultOptionsClick(Sender: TObject);
begin
  if not CollectOptions then
    Exit;
  ForceDirectories(ExtractFilePath(DefaultOptionsFile));
  try
    SaveSolverOptions(DefaultOptionsFile, FOptions);
    FSavedOptions := FOptions;
    FOptionsCorrected := False;
    FOptionsPanel.CommitBaseline;
  except
    on E: Exception do
      MessageDlgEnglish('Could not save the default solver options: ' + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.ResetOptionsClick(Sender: TObject);
begin
  GetDefaultSolverOptions(FOptions);
  FOptionsPanel.ShowOptions(FOptions);
end;

procedure TMainForm.acSolveExecute(Sender: TObject);
var
  LP: PtrUInt;
  Solution: PFloatArray;
  TempFile: string;
  MathProgMPSFile: string;
  MathProgError: string;
  SolverStatus: LongInt;
  FinalBound, FinalObjective: Double;
  StatusText: PChar;
  VariableName: PChar;
  ResultHeader: string;
  PendingFile: string;
  SolveSource: string;
  SolveError: Boolean;
  I, ColumnCount: Integer;
begin
  if FIsSolving then
    Exit;
  if not CollectOptions then
    Exit;
  if FScriptFormat = sfMathProg then
    try
      if not PrepareMathProgData then
        Exit;
    except
      on E: Exception do
      begin
        MessageDlgEnglish('Could not prepare the MathProg data file: ' +
          E.Message, mtError, [mbOK], 0);
        Exit;
      end;
    end;

  if FLastSolvedLP <> 0 then
  begin
    delete_lp(FLastSolvedLP);
    FLastSolvedLP := 0;
    FLastSolvedSource := '';
    Savebasis1.Enabled := False;
  end;
  ClearResultTables;

  FIsSolving := True;
  SolveSource := Editor.Text;
  FAbortRequested := False;
  FHasIntegerVariables := False;
  FIntegerBestCount := 0;
  FIntegerSolutionCaptureError := '';
  FBestIterationGap := -1;
  FHasRootBound := False;
  FFinalReportedGap := '';
  FLastAbortCheck := GetTickCount64;
  acSolve.Enabled := False;
  acSolveRelaxed.Enabled := False;
  acStop.Enabled := True;
  if FClearOutputOnSolve then
    MemoLog.Clear;
  FInvertCount := 0;
  for I := 1 to 7 do
    StatusBar.Panels[I].Text := '';
  StatusBar.Panels[2].Text := '';
  StatusBar.Panels[5].Text := 'NOD: 0';
  PageControl2.ActivePage := TabSheet5;
  if FClearOutputOnSolve then
    MemoMessages.Clear;
  Screen.Cursor := crHourGlass;
  LP := 0;
  TempFile := '';
  MathProgMPSFile := '';
  SolveError := False;
  SolverStatus := -1;
  try
    try
    LP := LoadLPFromEditor(TempFile, MathProgMPSFile, MathProgError, FOptions.Verbose);
    if LP = 0 then
    begin
      if FScriptFormat = sfMathProg then
      begin
        MemoMessages.Lines.Add(
          'Could not load the MathProg model:');
        if MathProgError <> '' then
          AddMessageText(MemoMessages.Lines, MathProgError)
        else
          MemoMessages.Lines.Add(
            'Could not load the generated MathProg problem.');
      end
      else
        AddMessageText(MemoMessages.Lines, MathProgError);
      SolveError := True;
      Exit;
    end;

    // Keep lp_solve output off stdout; the callbacks below send it to the UI.
    set_outputfile(LP, '');

    if (FPendingBasisFile <> '') and
       not read_basis(LP, PChar(FPendingBasisFile), nil) then
      raise Exception.CreateFmt('Could not load basis file "%s".',
        [FPendingBasisFile]);

    ColumnCount := get_Ncolumns(LP);
    if FRelaxIntegers then
    begin
      for I := 1 to ColumnCount do
        if is_SOS_var(LP, I) then
        begin
          MemoMessages.Lines.Add('Unable to remove integer conditions ' +
            'because there is at least one SOS constraint.');
          MessageDlgEnglish('Unable to remove integer conditions because ' +
            'there is at least one SOS constraint.', mtWarning, [mbOK], 0);
          SolveError := True;
          Exit;
        end;
      for I := 1 to ColumnCount do
      begin
        set_semicont(LP, I, False);
        set_int(LP, I, False);
      end;
      MemoMessages.Lines.Add(
        'Integer and semi-continuous restrictions ignored: solving the relaxed model.');
    end;
    for I := 1 to ColumnCount do
      if is_int(LP, I) then
      begin
        FHasIntegerVariables := True;
        Break;
      end;
    if FHasIntegerVariables then
      StatusBar.Panels[2].Text := 'GAP: --';
    ApplySolverOptions(LP, FOptions);
    put_logfunc(LP, @SolverLogCallback, Self);
    put_abortfunc(LP, @SolverAbortCallback, Self);
    put_msgfunc(LP, @SolverMessageCallback, Self,
      FOptions.Messages or MESSAGES_REQUIRED);
    SolverStatus := solve(LP);
    if FIntegerSolutionCaptureError <> '' then
      raise Exception.Create('Could not capture an integer solution: ' +
        FIntegerSolutionCaptureError);
    StatusBar.Panels[5].Text := 'NOD: ' + IntToStr(get_total_nodes(LP));
    if FHasIntegerVariables then
    begin
      // At a proven optimum the last estimate is stale: use the bound gap if
      // it can be computed now, otherwise the relative gap allowed by Options.
      if SolverStatus = OPTIMAL then
      begin
        FinalBound := get_working_objective(LP);
        FinalObjective := get_objective(LP);
        if FHasRootBound and not IsNan(FinalBound) and
           not IsNan(FinalObjective) and (Abs(FinalBound) < 1e15) and
           (Abs(FinalObjective) < 1e15) and
           (Abs(FinalBound - FinalObjective) /
             (1 + Abs(FinalObjective)) <= FOptions.MipGapRel) then
          StatusBar.Panels[2].Text := Format('GAP: %.2f%%',
            [Abs(FinalBound - FinalObjective) /
            (1 + Abs(FinalObjective)) * 100])
        else
          StatusBar.Panels[2].Text :=
            Format('GAP: %.2f%%', [FOptions.MipGapRel * 100]);
      end
      else if FBestIterationGap >= 0 then
        StatusBar.Panels[2].Text := Format('GAP: %.2f%%', [FBestIterationGap])
      else if FFinalReportedGap <> '' then
        StatusBar.Panels[2].Text := 'GAP: ' + FFinalReportedGap + '%'
      else
        StatusBar.Panels[2].Text := 'GAP: --';
    end;
    StatusText := get_statustext(LP, SolverStatus);
    if StatusText <> nil then
    begin
      StatusBar.Panels[7].Text := StrPas(StatusText);
      MemoMessages.Lines.Add(Format('Solver status: %s', [StrPas(StatusText)]))
    end
    else
    begin
      StatusBar.Panels[7].Text := IntToStr(SolverStatus);
      MemoMessages.Lines.Add(Format('Solver status: %d', [SolverStatus]));
    end;

    if SolverStatus in [OPTIMAL, SUBOPTIMAL] then
    begin
      ResultHeader := Format('Result %d', [FResultHeaders.Count + 1]);
      if FHasIntegerVariables then
      begin
        if FIntegerBestCount = 0 then
          AddCurrentResult(LP, 'MILP Feasible', False);
        if SolverStatus = OPTIMAL then
          AddCurrentResult(LP, 'result', False);
      end
      else
        AddCurrentResult(LP, ResultHeader);
      MemoMessages.Lines.Add(Format('Objective: %.12g', [get_objective(LP)]));
      ColumnCount := get_Ncolumns(LP);
      if ColumnCount > 0 then
      begin
        GetMem(Solution, ColumnCount * SizeOf(Double));
        try
          if get_variables(LP, Solution) then
            for I := 1 to ColumnCount do
            begin
              VariableName := get_col_name(LP, I);
              if VariableName = nil then
                MemoMessages.Lines.Add(Format('x%d = %.12g',
                  [I, Solution^[I - 1]]))
              else
                MemoMessages.Lines.Add(Format('%s = %.12g',
                  [StrPas(VariableName), Solution^[I - 1]]));
            end;
        finally
          FreeMem(Solution);
        end;
      end;
    end
    else
      SolveError := True;
    except
      on E: Exception do
      begin
        MemoMessages.Lines.Add('Error while solving: ' + E.Message);
        SolveError := True;
      end;
    end;
  finally
    if (LP <> 0) and not SolveError and
       (SolverStatus in [OPTIMAL, SUBOPTIMAL]) and
       (SolveSource = Editor.Text) then
    begin
      FLastSolvedLP := LP;
      FLastSolvedSource := SolveSource;
      FLastSolvedFormat := FScriptFormat;
      Savebasis1.Enabled := True;
      LP := 0;
    end;
    if LP <> 0 then
      delete_lp(LP);
    if TempFile <> '' then
      DeleteFile(TempFile);
    if MathProgMPSFile <> '' then
      DeleteFile(MathProgMPSFile);
    FPendingBasisFile := '';
    Screen.Cursor := crDefault;
    acSolve.Enabled := True;
    acSolveRelaxed.Enabled := True;
    acStop.Enabled := False;
    FIsSolving := False;
    if SolveError then
      PageControl2.ActivePage := TabSheet6
    else
      PageControl2.ActivePage := TabSheet5;
    PendingFile := FPendingOpenFile;
    FPendingOpenFile := '';
    if FQuitAfterSolve then
    begin
      FQuitAfterSolve := False;
      acQuitExecute(Self);
    end
    else if PendingFile <> '' then
      try
        OpenFile(PendingFile);
      except
        on E: Exception do
          MessageDlgEnglish(Format('Could not open "%s": %s',
            [PendingFile, E.Message]), mtError, [mbOK], 0);
      end;
  end;
end;

procedure TMainForm.acSolveRelaxedExecute(Sender: TObject);
begin
  if FIsSolving then
    Exit;
  FRelaxIntegers := True;
  try
    acSolveExecute(Self);
  finally
    FRelaxIntegers := False;
  end;
end;

procedure TMainForm.acSolveBasisExecute(Sender: TObject);
begin
  if FIsSolving or not OpenDialogBasis.Execute then
    Exit;

  FPendingBasisFile := OpenDialogBasis.FileName;
  try
    acSolveExecute(Self);
  finally
    FPendingBasisFile := '';
  end;
end;

procedure TMainForm.acSaveBasisExecute(Sender: TObject);
begin
  if FLastSolvedLP = 0 then
  begin
    MessageDlgEnglish('Solve the current model before saving its basis.',
      mtInformation, [mbOK], 0);
    Exit;
  end;
  if (FLastSolvedSource <> Editor.Text) or
     (FLastSolvedFormat <> FScriptFormat) then
  begin
    delete_lp(FLastSolvedLP);
    FLastSolvedLP := 0;
    FLastSolvedSource := '';
    Savebasis1.Enabled := False;
    MessageDlgEnglish('The model has changed. Solve it again before saving its basis.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  if FCurrentFile <> '' then
    SaveDialogBasis.FileName :=
      ChangeFileExt(ExtractFileName(FCurrentFile), '.bas')
  else
    SaveDialogBasis.FileName := '';
  if not SaveDialogBasis.Execute then
    Exit;

  if not write_basis(FLastSolvedLP, PChar(SaveDialogBasis.FileName)) then
    MessageDlgEnglish(Format('Could not save basis to "%s".',
      [SaveDialogBasis.FileName]), mtError, [mbOK], 0);
end;

procedure TMainForm.acSyntaxCheckExecute(Sender: TObject);
var
  LP: THandle;
  TempFile, MathProgMPSFile, LoadError: string;
  ErrorLine, MarkerPos, NumberStart, NumberEnd: Integer;
  DiagnosticText: string;
begin
  if FIsSolving then
  begin
    MessageDlgEnglish('Syntax check is unavailable while a model is solving.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  LP := 0;
  TempFile := '';
  MathProgMPSFile := '';
  LoadError := '';
  Screen.Cursor := crHourGlass;
  try
    try
      LP := LoadLPFromEditor(TempFile, MathProgMPSFile, LoadError, NEUTRAL);
      if LP <> 0 then
        MessageDlgEnglish('The script is correct.', mtInformation, [mbOK], 0)
      else if LoadError <> '' then
      begin
        ErrorLine := 0;
        DiagnosticText := LowerCase(LoadError);
        MarkerPos := Pos('line ', DiagnosticText);
        if MarkerPos > 0 then
        begin
          NumberStart := MarkerPos + Length('line ');
          while (NumberStart <= Length(DiagnosticText)) and
            (DiagnosticText[NumberStart] in [' ', ':', '#']) do
            Inc(NumberStart);
          NumberEnd := NumberStart;
          while (NumberEnd <= Length(DiagnosticText)) and
            (DiagnosticText[NumberEnd] in ['0'..'9']) do
            Inc(NumberEnd);
          if NumberEnd > NumberStart then
            ErrorLine := StrToIntDef(
              Copy(DiagnosticText, NumberStart, NumberEnd - NumberStart), 0);
        end
        else
        begin
          MarkerPos := Pos(':', DiagnosticText);
          while MarkerPos > 0 do
          begin
            NumberStart := MarkerPos + 1;
            NumberEnd := NumberStart;
            while (NumberEnd <= Length(DiagnosticText)) and
              (DiagnosticText[NumberEnd] in ['0'..'9']) do
              Inc(NumberEnd);
            if (NumberEnd > NumberStart) and (NumberEnd <=
              Length(DiagnosticText)) and (DiagnosticText[NumberEnd] = ':') then
            begin
              ErrorLine := StrToIntDef(
                Copy(DiagnosticText, NumberStart, NumberEnd - NumberStart), 0);
              if ErrorLine > 0 then
                Break;
            end;
            MarkerPos := PosEx(':', DiagnosticText, MarkerPos + 1);
          end;
        end;

        if (ErrorLine > 0) and (ErrorLine <= Editor.Lines.Count) then
        begin
          PageControl.ActivePage := TabSheetEditor;
          Editor.CaretXY := Point(1, ErrorLine);
          Editor.EnsureCursorPosVisible;
          Editor.SetFocus;
          MessageDlgEnglish(
            Format('The script has syntax error(s) at line %d.%s%s',
              [ErrorLine, LineEnding, Editor.Lines[ErrorLine - 1]]),
            mtWarning, [mbOK], 0);
        end
        else
          MessageDlgEnglish(
            'The script has syntax error(s), but the line could not be determined.',
            mtWarning, [mbOK], 0);
      end
      else
        MessageDlgEnglish('The script has syntax error(s).', mtWarning,
          [mbOK], 0);
    except
      on E: Exception do
        MessageDlgEnglish('Could not check the script: ' + E.Message,
          mtError, [mbOK], 0);
    end;
  finally
    if LP <> 0 then
      delete_lp(LP);
    if (TempFile <> '') and FileExists(TempFile) then
      DeleteFile(TempFile);
    if (MathProgMPSFile <> '') and FileExists(MathProgMPSFile) then
      DeleteFile(MathProgMPSFile);
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.acStopExecute(Sender: TObject);
begin
  FAbortRequested := True;
end;

procedure TMainForm.RequestQuitDuringSolve;
begin
  if MessageDlgEnglish(
    'A problem is currently being solved. Do you want to stop the calculation and quit?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FQuitAfterSolve := True;
    FAbortRequested := True;
  end;
end;

procedure TMainForm.acNewExecute(Sender: TObject);
begin

end;

function TMainForm.ConfirmSaveChanges(ConfirmData: Boolean): Boolean;
begin
  Result := True;
  if Editor.Modified then
    case MessageDlgEnglish(
      'The current script has been modified, do you want to save it ?',
      mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes: Result := SaveCurrentFile;
      mrNo: Result := True;
    else
      Result := False;
    end;
  if not Result or not ConfirmData then
    Exit;

  Result := ConfirmDataChanges;
end;

function TMainForm.ConfirmDataChanges: Boolean;
begin
  Result := True;
  if not Assigned(FDataEditor) or not FDataEditor.Modified then
    Exit;

  case MessageDlgEnglish(
    'The data file has been modified, do you want to save it ?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    mrYes: Result := SaveCurrentDataFile;
    mrNo: Result := True;
  else
    Result := False;
  end;
end;

function TMainForm.CloseDataEditor: Boolean;
begin
  Result := True;
  if not Assigned(FDataTab) then
    Exit;
  if not ConfirmDataChanges then
    Exit(False);

  FUseDataFile := False;
  FDataEditor := nil;
  FreeAndNil(FDataTab);
  FDataFile := '';
  FDataBaseline := '';
  UpdateEditorStatus;
  UpdateUndoRedoActions;
end;

function TMainForm.SaveCurrentFile: Boolean;
begin
  if FCurrentFile = '' then
    Exit(SaveFileAs);

  {$IFDEF MSWINDOWS}
  SaveFileWithUnicodePath(FCurrentFile, Editor.Lines);
  {$ELSE}
  Editor.Lines.SaveToFile(FCurrentFile);
  {$ENDIF}
  Editor.Modified := False;
  FEditorBaseline := Editor.Text;
  UpdateEditorStatus;
  Result := True;
end;

function TMainForm.SaveCurrentDataFile: Boolean;
begin
  if FDataFile = '' then
    Exit(SaveDataFileAs);

  {$IFDEF MSWINDOWS}
  SaveFileWithUnicodePath(FDataFile, FDataEditor.Lines);
  {$ELSE}
  FDataEditor.Lines.SaveToFile(FDataFile);
  {$ENDIF}
  FDataEditor.Modified := False;
  FDataBaseline := FDataEditor.Text;
  UpdateEditorStatus;
  Result := True;
end;

function TMainForm.SaveFileAs: Boolean;
var
  Filename: string;
  Extension: string;
  SaveFormat: TScriptFormat;
begin
  Result := False;
  SaveFormat := FScriptFormat;
  SaveDialogScript.FileName := FCurrentFile;
  case FScriptFormat of
    sfLP: SaveDialogScript.FilterIndex := 1;
    sfMPS, sfFreeMPS: SaveDialogScript.FilterIndex := 2;
    sfMathProg: SaveDialogScript.FilterIndex := 3;
    sfXLI: SaveDialogScript.FilterIndex := 1;
  end;
  if not SaveDialogScript.Execute then
    Exit;

  Filename := SaveDialogScript.FileName;
  Extension := ExtractFileExt(Filename);
  if Extension = '' then
  begin
    case SaveDialogScript.FilterIndex of
      1: SaveFormat := sfLP;
      2: SaveFormat := sfFreeMPS;
      3: SaveFormat := sfMathProg;
    end;
    if SaveFormat in [sfMPS, sfFreeMPS] then
      Filename := Filename + '.mps'
    else if SaveFormat = sfMathProg then
      Filename := Filename + '.mod'
    else
      Filename := Filename + '.lp';
  end
  else if SameText(Extension, '.mps') then
    SaveFormat := sfFreeMPS
  else if SameText(Extension, '.lp') then
    SaveFormat := sfLP
  else if SameText(Extension, '.mod') then
    SaveFormat := sfMathProg;

  {$IFDEF MSWINDOWS}
  SaveFileWithUnicodePath(Filename, Editor.Lines);
  {$ELSE}
  Editor.Lines.SaveToFile(Filename);
  {$ENDIF}
  FScriptFormat := SaveFormat;
  SelectViewFormat;
  Editor.Modified := False;
  FEditorBaseline := Editor.Text;
  UpdateEditorStatus;
  SetCurrentFile(Filename);
  Result := True;
end;

function TMainForm.SaveDataFileAs: Boolean;
var
  Filename, PreviousFilter, PreviousDefaultExt: string;
begin
  Result := False;
  PreviousFilter := SaveDialogScript.Filter;
  PreviousDefaultExt := SaveDialogScript.DefaultExt;
  try
    SaveDialogScript.Filter :=
      'Data files (*.dat)|*.dat|All files (*.*)|*.*';
    SaveDialogScript.DefaultExt := 'dat';
    SaveDialogScript.FilterIndex := 1;
    SaveDialogScript.FileName := FDataFile;
    if not SaveDialogScript.Execute then
      Exit;

    Filename := SaveDialogScript.FileName;
    if ExtractFileExt(Filename) = '' then
      Filename := Filename + '.dat';
    {$IFDEF MSWINDOWS}
    SaveFileWithUnicodePath(Filename, FDataEditor.Lines);
    {$ELSE}
    FDataEditor.Lines.SaveToFile(Filename);
    {$ENDIF}
    FDataFile := Filename;
    FDataEditor.Modified := False;
    FDataBaseline := FDataEditor.Text;
    UpdateEditorStatus;
    Result := True;
  finally
    SaveDialogScript.Filter := PreviousFilter;
    SaveDialogScript.DefaultExt := PreviousDefaultExt;
  end;
end;

procedure TMainForm.EnsureDataEditor;
begin
  if Assigned(FDataEditor) then
    Exit;

  FDataTab := TTabSheet.Create(PageControl);
  FDataTab.PageControl := PageControl;
  FDataTab.PageIndex := 1;
  FDataTab.Caption := 'Data';
  FDataEditor := TSynEdit.Create(FDataTab);
  FDataEditor.Parent := FDataTab;
  FDataEditor.Align := alClient;
  FDataEditor.Font.Assign(Editor.Font);
  FDataEditor.OnMouseWheel := @EditorMouseWheel;
  FDataEditor.Highlighter := Editor.Highlighter;
  FDataEditor.Options := Editor.Options;
  FDataEditor.Gutter.Width := Editor.Gutter.Width;
  FDataEditor.OnChange := @EditorChange;
  FDataEditor.OnStatusChange := @EditorStatusChange;
  FDataEditor.OnEnter := @SearchControlEnter;
  FDataEditor.ClearUndo;
end;

procedure TMainForm.UpdateDataTabColor;
var
  ModelTempFile: string;
  ModelHasDataSection: Boolean;
begin
  if not Assigned(FDataTab) then
    Exit;

  ModelHasDataSection := False;
  if FScriptFormat = sfMathProg then
  begin
    ModelTempFile := GetTempFileName(GetTempDir(False), 'opti');
    try
      Editor.Lines.SaveToFile(ModelTempFile);
      ModelHasDataSection := HasDataSection(ModelTempFile);
    finally
      if FileExists(ModelTempFile) then
        DeleteFile(ModelTempFile);
    end;
  end;
  if ModelHasDataSection then
    FDataTab.Font.Color := clRed
  else
    FDataTab.Font.Color := PageControl.Font.Color;
  PageControl.Invalidate;
end;

procedure TMainForm.LoadDataFile(const Filename: string;
  KeepModelEditorActive: Boolean);
var
  LoadedLines: TStringList;
  ModelTempFile: string;
  ModelHasDataSection: Boolean;
begin
  if not ConfirmDataChanges then
    Exit;

  ModelHasDataSection := False;
  if FScriptFormat = sfMathProg then
  begin
    ModelTempFile := GetTempFileName(GetTempDir(False), 'opti');
    try
      Editor.Lines.SaveToFile(ModelTempFile);
      ModelHasDataSection := HasDataSection(ModelTempFile);
    finally
      if FileExists(ModelTempFile) then
        DeleteFile(ModelTempFile);
    end;
  end;

  LoadedLines := TStringList.Create;
  Screen.Cursor := crHourGlass;
  try
    {$IFDEF MSWINDOWS}
    LoadFileWithUnicodePath(Filename, LoadedLines);
    {$ELSE}
    LoadedLines.LoadFromFile(Filename);
    {$ENDIF}
    if ModelHasDataSection then
      MessageDlgEnglish(
        'The current script already contains a data section. The contents of this .dat file will not be used.',
        mtInformation, [mbOK], 0);
    EnsureDataEditor;
    FDataEditor.Lines.Assign(LoadedLines);
    FDataEditor.ClearUndo;
    FDataEditor.Modified := False;
    FDataFile := Filename;
    FUseDataFile := not ModelHasDataSection;
    FDataBaseline := FDataEditor.Text;
    FLastOpenFile := Filename;
    if KeepModelEditorActive then
      PageControl.ActivePage := TabSheetEditor
    else
      PageControl.ActivePage := FDataTab;
    UpdateDataTabColor;
    if KeepModelEditorActive then
    begin
      Editor.CaretXY := Point(1, 1);
      Editor.EnsureCursorPosVisible;
      if Showing then
        Editor.SetFocus
      else
        ActiveControl := Editor;
    end
    else
    begin
      FDataEditor.CaretXY := Point(1, 1);
      FDataEditor.EnsureCursorPosVisible;
      if Showing then
        FDataEditor.SetFocus
      else
        ActiveControl := FDataEditor;
    end;
    UpdateEditorStatus;
    UpdateUndoRedoActions;
  finally
    Screen.Cursor := crDefault;
    LoadedLines.Free;
  end;
end;

function TMainForm.PrepareMathProgData: Boolean;
var
  ModelTempFile, DataFilename: string;

  function SelectDataFile: Boolean;
  var
    SelectedFilename: string;
    Dialog: TOpenDialog;
    Prompt: TForm;
    PromptResult, I, MaxHeight: Integer;
  begin
    Result := False;
    Prompt := CreateMessageDialog(
      'This MathProg script has no data section. Select a .dat data file to solve it or cancel to proceed without data file.',
      mtInformation, [mbOK, mbCancel]);
    try
      for I := 0 to Prompt.ComponentCount - 1 do
        if Prompt.Components[I] is TBitBtn then
          case TBitBtn(Prompt.Components[I]).ModalResult of
            mrOk: TBitBtn(Prompt.Components[I]).Caption := 'Select';
            mrCancel: TBitBtn(Prompt.Components[I]).Caption := 'Cancel';
          end;
      MaxHeight := 0;
      for I := 0 to Prompt.ComponentCount - 1 do
        if Prompt.Components[I] is TBitBtn then
          if TBitBtn(Prompt.Components[I]).Height > MaxHeight then
            MaxHeight := TBitBtn(Prompt.Components[I]).Height;
      for I := 0 to Prompt.ComponentCount - 1 do
        if Prompt.Components[I] is TBitBtn then
        begin
          TBitBtn(Prompt.Components[I]).AutoSize := False;
          TBitBtn(Prompt.Components[I]).Height := MaxHeight;
        end;
      PromptResult := Prompt.ShowModal;
    finally
      Prompt.Free;
    end;
    if PromptResult <> mrOk then
    begin
      FUseDataFile := False;
      Exit(True);
    end;
    Dialog := TOpenDialog.Create(Self);
    try
      Dialog.Title := 'Select MathProg data file';
      Dialog.Filter := 'Data files (*.dat)|*.dat|All files (*.*)|*.*';
      Dialog.DefaultExt := 'dat';
      Dialog.Options := [ofPathMustExist, ofFileMustExist];
      if not Dialog.Execute then
      begin
        FUseDataFile := False;
        Exit(True);
      end;
      SelectedFilename := Dialog.FileName;
    finally
      Dialog.Free;
    end;

    LoadDataFile(SelectedFilename);
    Result := FUseDataFile and Assigned(FDataEditor) and
      SameText(ExpandFileName(FDataFile), ExpandFileName(SelectedFilename));
  end;

begin
  Result := False;
  ModelTempFile := GetTempFileName(GetTempDir(False), 'opti');
  try
    Editor.Lines.SaveToFile(ModelTempFile);
    if HasDataSection(ModelTempFile) then
    begin
      FUseDataFile := False;
      Exit(True);
    end;
  finally
    if FileExists(ModelTempFile) then
      DeleteFile(ModelTempFile);
  end;

  DataFilename := ChangeFileExt(FCurrentFile, '.dat');
  if not Assigned(FDataEditor) or (FDataFile = '') then
    Exit(SelectDataFile);

  if SameText(ExtractFileName(FDataFile), ExtractFileName(DataFilename)) then
  begin
    FUseDataFile := True;
    Exit(True);
  end;

  if MessageDlgEnglish(
    Format('The loaded data file "%s" has a different name from the script data file "%s". Do you want to use it?',
      [FDataFile, DataFilename]),
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit(SelectDataFile);
  FUseDataFile := True;
  Result := FUseDataFile;
end;

function IsFixedMPS(const Lines: TStrings): Boolean;
var
  I: Integer;
  Line: string;
  InColumns: Boolean;
begin
  Result := False;
  InColumns := False;
  for I := 0 to Lines.Count - 1 do
  begin
    Line := Lines[I];
    if SameText(Trim(Line), 'COLUMNS') then
    begin
      InColumns := True;
      Continue;
    end;
    if not InColumns then
      Continue;
    if Trim(Line) = '' then
      Continue;
    if Line[1] = '*' then
      Continue;
    if SameText(Trim(Line), 'RHS') or SameText(Trim(Line), 'RANGES') or
       SameText(Trim(Line), 'BOUNDS') or SameText(Trim(Line), 'SOS') or
       SameText(Trim(Line), 'ENDATA') then
      Exit;

    Result := (Length(Line) >= 25) and (Trim(Copy(Line, 1, 4)) = '') and
      (Trim(Copy(Line, 5, 8)) <> '') and (Trim(Copy(Line, 13, 2)) = '') and
      (Trim(Copy(Line, 15, 8)) <> '') and (Trim(Copy(Line, 23, 2)) = '') and
      (Trim(Copy(Line, 25, 12)) <> '');
    Exit;
  end;
end;

function IsMPSModel(const Lines: TStrings): Boolean;
var
  I: Integer;
  HasRows, HasColumns: Boolean;
  Line: string;
begin
  HasRows := False;
  HasColumns := False;
  for I := 0 to Lines.Count - 1 do
  begin
    Line := Trim(Lines[I]);
    if SameText(Line, 'ROWS') then
      HasRows := True
    else if SameText(Line, 'COLUMNS') then
      HasColumns := True;
    if HasRows and HasColumns then
      Exit(True);
  end;
  Result := False;
end;

procedure TMainForm.OpenFile(const Filename: string);
var
  LoadedLines: TStringList;
  DataFilename: string;
  ContainsDataSection: Boolean;
  IsMPSFile: Boolean;
  I: Integer;
begin
  if SameText(ExtractFileExt(Filename), '.dat') then
  begin
    LoadDataFile(Filename);
    Exit;
  end;

  ContainsDataSection := SameText(ExtractFileExt(Filename), '.mod') and
    HasDataSection(Filename);
  if ContainsDataSection then
  begin
    if Assigned(FDataTab) then
    begin
      if MessageDlgEnglish(
        'This MathProg model contains a data section, which will be used. Do you want to close the Data editor?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        if not CloseDataEditor then
          Exit;
    end;
  end;

  LoadedLines := TStringList.Create;
  Screen.Cursor := crHourGlass;
  try
    {$IFDEF MSWINDOWS}
    LoadFileWithUnicodePath(Filename, LoadedLines);
    {$ELSE}
    LoadedLines.LoadFromFile(Filename);
    {$ENDIF}
    Editor.Lines.Assign(LoadedLines);
    IsMPSFile := SameText(ExtractFileExt(Filename), '.mps');
    if IsMPSFile then
    begin
      FModelHighlighter.Syntax := msMPS;
      Editor.Highlighter := FModelHighlighter;
      StatusBar.Panels[8].Text := 'MPS';
    end
    else if SameText(ExtractFileExt(Filename), '.mod') then
      FScriptFormat := sfMathProg
    else
      FScriptFormat := sfLP;
    for I := 1 to 7 do
      StatusBar.Panels[I].Text := '';
    ClearResultTables;
    Editor.ClearUndo;
    UpdateUndoRedoActions;
    SetCurrentFile(Filename);
    FLastOpenFile := Filename;
    Editor.Modified := False;
    FEditorBaseline := Editor.Text;
    UpdateEditorStatus;
    CheckGutter;
    PageControl.ActivePage := TabSheetEditor;
    Editor.CaretXY := Point(1, 1);
    Editor.EnsureCursorPosVisible;
    if Showing then
      Editor.SetFocus
    else
      ActiveControl := Editor;
    PageControl.Repaint;
    Editor.Repaint;

    if IsMPSFile then
    begin
      if IsFixedMPS(LoadedLines) then
        FScriptFormat := sfMPS
      else
        FScriptFormat := sfFreeMPS;
    end;
    SelectViewFormat;
    UpdateDataTabColor;
  finally
    Screen.Cursor := crDefault;
    LoadedLines.Free;
  end;

  if SameText(ExtractFileExt(Filename), '.mod') and
     not ContainsDataSection then
  begin
    DataFilename := ChangeFileExt(Filename, '.dat');
    if FileExists(DataFilename) then
    begin
      FUseDataFile := False;
      if MessageDlgEnglish(
        Format('A matching data file was found: "%s". Do you want to load it?',
          [DataFilename]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        try
          LoadDataFile(DataFilename, True);
        except
          on E: Exception do
            MessageDlgEnglish(Format('Could not open "%s": %s',
              [DataFilename, E.Message]), mtError, [mbOK], 0);
        end;
    end;
  end;
end;

procedure TMainForm.acSaveExecute(Sender: TObject);
begin
  if Assigned(FDataTab) and (PageControl.ActivePage = FDataTab) then
    SaveCurrentDataFile
  else
    SaveCurrentFile;
end;

procedure TMainForm.acSaveAsExecute(Sender: TObject);
begin
  if Assigned(FDataTab) and (PageControl.ActivePage = FDataTab) then
    SaveDataFileAs
  else
    SaveFileAs;
end;

procedure TMainForm.acOpenExecute(Sender: TObject);
begin
  if not ConfirmSaveChanges(False) then
    Exit;

  if not OpenDialogScript.Execute then
    Exit;

  if FIsSolving then
  begin
    if MessageDlgEnglish(
      'A problem is currently being solved. Do you want to stop it and continue loading the selected file?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;
    FPendingOpenFile := OpenDialogScript.FileName;
    FAbortRequested := True;
    Exit;
  end;

  try
    OpenFile(OpenDialogScript.FileName);
  except
    on E: Exception do
      MessageDlgEnglish(Format('Could not open "%s": %s',
        [OpenDialogScript.FileName, E.Message]), mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.PriorityChange(Sender: TObject);
begin

end;

procedure TMainForm.PriorityDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  ItemText: string;
begin
  if not (Control is TComboBox) or (Index < 0) or
     (Index >= TComboBox(Control).Items.Count) then
    Exit;

  with TComboBox(Control).Canvas do
  begin
    if odSelected in State then
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText;
    end
    else
    begin
      Brush.Color := ToolBar1.Color;
      Font.Color := clBtnText;
    end;

    FillRect(ARect);
    ItemText := TComboBox(Control).Items[Index];
    TextOut(ARect.Right - TextWidth(ItemText) - 4,
      ARect.Top + (ARect.Height - TextHeight(ItemText)) div 2, ItemText);
  end;
end;

procedure TMainForm.acNewLPExecute(Sender: TObject);
begin
  NewScript(sfLP);
end;

procedure TMainForm.acNewFixedMPSExecute(Sender: TObject);
begin
  NewScript(sfMPS);
end;

procedure TMainForm.acNewFreeMPSExecute(Sender: TObject);
begin
  NewScript(sfFreeMPS);
end;

procedure TMainForm.acNewMathProgExecute(Sender: TObject);
begin
  NewScript(sfMathProg);
end;

procedure TMainForm.acQuitExecute(Sender: TObject);
begin
  if FIsSolving then
  begin
    RequestQuitDuringSolve;
    Exit;
  end;

  if not ConfirmSaveChanges or not ConfirmSaveOptions or
    not ConfirmSaveDisplaySettings then
  begin
    FCloseApproved := False;
    Exit;
  end;

  FCloseApproved := True;
  if not FCloseQueryActive then
    Close;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FIsSolving then
  begin
    RequestQuitDuringSolve;
    CanClose := False;
    Exit;
  end;

  if FCloseApproved then
  begin
    CanClose := True;
    FCloseApproved := False;
    Exit;
  end;

  FCloseQueryActive := True;
  try
    FCloseApproved := False;
    acQuitExecute(Sender);
    CanClose := FCloseApproved;
    FCloseApproved := False;
  finally
    FCloseQueryActive := False;
  end;
end;

end.
