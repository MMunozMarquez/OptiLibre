program OptiLibre;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, Forms, SysUtils, main;

{$IFDEF UNIX}
const
  LC_NUMERIC = 1;

function c_setlocale(Category: LongInt; Locale: PChar): PChar; cdecl;
  external 'c' name 'setlocale';
{$ENDIF}

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  {$IFDEF UNIX}
  // lp_solve parses model numbers using the C decimal separator.
  if c_setlocale(LC_NUMERIC, 'C') = nil then
    raise Exception.Create('Could not set C numeric locale for lp_solve.');
  {$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
