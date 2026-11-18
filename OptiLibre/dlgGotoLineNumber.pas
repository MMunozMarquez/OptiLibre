unit dlgGotoLineNumber;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, StdCtrls, Spin;

type
  TdlgGotoLineNumber = class(TForm)
    btnCancel: TButton;
    btnGo: TButton;
    edtLineNumber: TSpinEdit;
    lblLineNumber: TLabel;
  end;

implementation

{$R *.lfm}

end.
