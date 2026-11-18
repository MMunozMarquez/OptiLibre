unit dlgAbout;

{$MODE Delphi}

interface

uses
  LCLIntf, Classes, Controls, Forms, Graphics, StdCtrls;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    FSL: TLabel;
    license: TLabel;
    github: TLabel;
    Author: TGroupBox;
    Henri_email: TLabel;
    Title: TLabel;
    Button1: TButton;
    lp_solve_authors: TLabel;
    Michel2: TLabel;
    by: TLabel;
    mmarquez: TLabel;
    lazarus: TLabel;
    xli_url: TLabel;
    third: TGroupBox;
    lpsolve_url: TLabel;
    lpsolve_group: TLabel;
    Michel_email: TLabel;
    Jeroen_email: TLabel;
    Kjell_email: TLabel;
    Peter_email: TLabel;
    xli_Matrhprog: TLabel;
    xli_Kjell: TLabel;
    xli_Kjell_email: TLabel;
    lp_solve: TGroupBox;
    Michel: TLabel;
    Jeroen: TLabel;
    Kjell: TLabel;
    Peter: TLabel;
    lpsolveIDE: TGroupBox;
    lpsolveIDE_Henri: TLabel;
    lpsolveIDE_Peter: TLabel;
    lpsolveIDE_authors: TLabel;
    lpsolveIDE_William: TLabel;
    lazarus_url: TLabel;
    procedure URLClick(Sender: TObject);
    procedure EmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

procedure TAboutForm.URLClick(Sender: TObject);
begin
  OpenURL(TLabel(Sender).Caption);
end;

procedure TAboutForm.EmailClick(Sender: TObject);
begin
  OpenURL('mailto:' + TLabel(Sender).Caption);
end;

end.
