unit dlgHelp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, StdCtrls, Buttons,
  IpHtml, IpFileBroker, IpMsg;

type
  THelpForm = class(TForm)
  private
    FPanel: TIpHtmlPanel;
    FProvider: TIpHtmlDataProvider;
    procedure ProviderGetHtml(Sender: TObject; const URL: string;
      const PostData: TIpFormDataEntity; var Stream: TStream);
    procedure ProviderGetImage(Sender: TIpHtmlNode; const URL: string;
      var Picture: TPicture);
    procedure ProviderCheckURL(Sender: TObject; const URL: string;
      var Available: Boolean; var ContentType: string);
    function ProviderCanHandle(Sender: TObject; const URL: string): Boolean;
    procedure BackClick(Sender: TObject);
    procedure ForwardClick(Sender: TObject);
    procedure ContentsClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ShowTopic(const Topic: string);
  end;

procedure ShowHelpTopic(const Topic: string);

implementation

{$IFNDEF UNIX}
uses
  Windows;
{$ENDIF}

type
  THelpHtmlDataProvider = class(TIpHtmlDataProvider)
  public
    function DoGetStream(const URL: string): TStream; override;
  end;

var
  HelpForm: THelpForm;

const
  SCHEME = 'help:';

function ResourceName(const URL: string): string;
var
  P: Integer;
begin
  Result := URL;
  if LowerCase(Copy(Result, 1, Length(SCHEME))) = SCHEME then
    Delete(Result, 1, Length(SCHEME));
  P := Pos('#', Result);
  if P > 0 then
    Result := Copy(Result, 1, P - 1);
  P := Pos('?', Result);
  if P > 0 then
    Result := Copy(Result, 1, P - 1);
  while (Result <> '') and (Result[1] = '/') do
    Delete(Result, 1, 1);
  Result := UpperCase(ExtractFileName(StringReplace(Result, '\', '/', [rfReplaceAll])));
end;

function HasResource(const Name: string): Boolean;
begin
  Result := (Name <> '') and (FindResource(HInstance, PChar(Name), RT_RCDATA) <> 0);
end;

function OpenResource(const Name: string): TStream;
begin
  if HasResource(Name) then
    Result := TResourceStream.Create(HInstance, Name, RT_RCDATA)
  else
    Result := nil;
end;

function THelpHtmlDataProvider.DoGetStream(const URL: string): TStream;
begin
  Result := OpenResource(ResourceName(URL));
end;

constructor THelpForm.Create(AOwner: TComponent);
var
  Bar: TPanel;

  procedure AddButton(const ACaption: string; Handler: TNotifyEvent);
  var
    B: TButton;
  begin
    B := TButton.Create(Self);
    B.Caption := ACaption;
    B.OnClick := Handler;
    B.Align := alLeft;
    B.AutoSize := True;
    B.BorderSpacing.Around := 4;
    B.Parent := Bar;
  end;

begin
  inherited CreateNew(AOwner);
  Caption := 'OptiLibre Help';
  Position := poDefault;
  Width := 900;
  Height := 650;
  Bar := TPanel.Create(Self);
  Bar.Align := alTop;
  Bar.Height := 36;
  Bar.BevelOuter := bvNone;
  Bar.Parent := Self;
  AddButton('Contents', @ContentsClick);
  AddButton('Forward', @ForwardClick);
  AddButton('Back', @BackClick);
  FProvider := THelpHtmlDataProvider.Create(Self);
  FProvider.HandledProtocols.Clear;
  FProvider.HandledProtocols.Add('HELP');
  FProvider.OnGetHtml := @ProviderGetHtml;
  FProvider.OnGetImage := @ProviderGetImage;
  FProvider.OnCheckURL := @ProviderCheckURL;
  FProvider.OnCanHandle := @ProviderCanHandle;
  FPanel := TIpHtmlPanel.Create(Self);
  FPanel.Align := alClient;
  FPanel.DataProvider := FProvider;
  FPanel.Parent := Self;
end;

{$PUSH}
{$HINTS OFF} // PostData is unused because help pages are static resources.
procedure THelpForm.ProviderGetHtml(Sender: TObject; const URL: string;
  const PostData: TIpFormDataEntity; var Stream: TStream);
begin
  Stream := OpenResource(ResourceName(URL));
end;
{$POP}

procedure THelpForm.ProviderGetImage(Sender: TIpHtmlNode; const URL: string;
  var Picture: TPicture);
var
  S: TStream;
begin
  Picture := nil;
  S := OpenResource(ResourceName(URL));
  if S = nil then
    Exit;
  try
    Picture := TPicture.Create;
    try
      Picture.LoadFromStream(S);
    except
      FreeAndNil(Picture);
    end;
  finally
    S.Free;
  end;
end;

procedure THelpForm.ProviderCheckURL(Sender: TObject; const URL: string;
  var Available: Boolean; var ContentType: string);
var
  Ext: string;
begin
  Available := HasResource(ResourceName(URL));
  Ext := LowerCase(ExtractFileExt(ResourceName(URL)));
  if (Ext = '.gif') or (Ext = '.png') or (Ext = '.jpg') then
    ContentType := 'image/' + Copy(Ext, 2, MaxInt)
  else
    ContentType := 'text/html';
end;

function THelpForm.ProviderCanHandle(Sender: TObject; const URL: string): Boolean;
begin
  Result := Pos('://', URL) = 0;
end;

procedure THelpForm.BackClick(Sender: TObject);
begin
  FPanel.GoBack;
end;

procedure THelpForm.ForwardClick(Sender: TObject);
begin
  FPanel.GoForward;
end;

procedure THelpForm.ContentsClick(Sender: TObject);
begin
  ShowTopic('lp_solve.htm');
end;

procedure THelpForm.ShowTopic(const Topic: string);
var
  Page, Anchor: string;
  P: Integer;
begin
  Page := Topic;
  if Page = '' then
    Page := 'lp_solve.htm';
  P := Pos('#', Page);
  if P > 0 then
    Anchor := Copy(Page, P, MaxInt)
  else
    Anchor := '';
  FPanel.OpenURL(SCHEME + '/' + ResourceName(Page) + Anchor);
  Show;
  BringToFront;
end;

procedure ShowHelpTopic(const Topic: string);
begin
  if HelpForm = nil then
    HelpForm := THelpForm.Create(Application);
  HelpForm.ShowTopic(Topic);
end;

{$R help.res}

end.
