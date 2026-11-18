unit dlgReplaceText;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, StdCtrls, ExtCtrls;

type
  TReplaceTextAction = (rtaFind, rtaReplace, rtaReplaceAll);
  TReplaceTextEvent = procedure(Sender: TObject;
    Action: TReplaceTextAction) of object;

  TdlgReplaceText = class(TForm)
    btnClose: TButton;
    btnFind: TButton;
    btnReplace: TButton;
    btnReplaceAll: TButton;
    cbEntireScope: TCheckBox;
    cbMatchCase: TCheckBox;
    cbRegExpr: TCheckBox;
    cbSelectedOnly: TCheckBox;
    cbWholeWord: TCheckBox;
    edReplaceText: TEdit;
    edSearchText: TEdit;
    lblReplaceText: TLabel;
    lblSearchText: TLabel;
    rgDirection: TRadioGroup;
    procedure btnCloseClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure edSearchTextChange(Sender: TObject);
  private
    FOnAction: TReplaceTextEvent;
    procedure UpdateSearchButtons;
    procedure DoSearchAction(AAction: TReplaceTextAction);
  public
    property OnAction: TReplaceTextEvent read FOnAction write FOnAction;
  end;

implementation

{$R *.lfm}

procedure TdlgReplaceText.UpdateSearchButtons;
begin
  btnFind.Enabled := edSearchText.Text <> '';
  btnReplace.Enabled := edSearchText.Text <> '';
  btnReplaceAll.Enabled := edSearchText.Text <> '';
end;

procedure TdlgReplaceText.edSearchTextChange(Sender: TObject);
begin
  UpdateSearchButtons;
end;

procedure TdlgReplaceText.DoSearchAction(AAction: TReplaceTextAction);
begin
  if (edSearchText.Text <> '') and Assigned(FOnAction) then
    FOnAction(Self, AAction);
end;

procedure TdlgReplaceText.btnFindClick(Sender: TObject);
begin
  DoSearchAction(rtaFind);
end;

procedure TdlgReplaceText.btnReplaceClick(Sender: TObject);
begin
  DoSearchAction(rtaReplace);
end;

procedure TdlgReplaceText.btnReplaceAllClick(Sender: TObject);
begin
  DoSearchAction(rtaReplaceAll);
end;

procedure TdlgReplaceText.btnCloseClick(Sender: TObject);
begin
  Hide;
end;

end.
