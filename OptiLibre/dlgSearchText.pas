unit dlgSearchText;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, StdCtrls, ExtCtrls;

type
  TSearchTextEvent = procedure(Sender: TObject) of object;

  TdlgSearchText = class(TForm)
    btnClose: TButton;
    btnFind: TButton;
    cbEntireScope: TCheckBox;
    cbMatchCase: TCheckBox;
    cbRegExpr: TCheckBox;
    cbSelectedOnly: TCheckBox;
    cbWholeWord: TCheckBox;
    edSearchText: TEdit;
    lblSearchText: TLabel;
    rgDirection: TRadioGroup;
    procedure btnCloseClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edSearchTextChange(Sender: TObject);
  private
    FOnSearch: TSearchTextEvent;
    procedure UpdateFindButton;
  public
    property OnSearch: TSearchTextEvent read FOnSearch write FOnSearch;
  end;

implementation

{$R *.lfm}

procedure TdlgSearchText.UpdateFindButton;
begin
  btnFind.Enabled := edSearchText.Text <> '';
end;

procedure TdlgSearchText.edSearchTextChange(Sender: TObject);
begin
  UpdateFindButton;
end;

procedure TdlgSearchText.btnFindClick(Sender: TObject);
begin
  if Assigned(FOnSearch) then
    FOnSearch(Self);
end;

procedure TdlgSearchText.btnCloseClick(Sender: TObject);
begin
  Hide;
end;

end.
