unit LPModelHighlighter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, SynEditTypes, SynEditHighlighter;

type
  TModelSyntax = (msLP, msMPS, msMathProg);
  TModelTokenKind = (mtComment, mtIdentifier, mtKeyword, mtNull, mtNumber,
    mtSpace, mtString, mtSymbol);

  TLPModelHighlighter = class(TSynCustomHighlighter)
  private
    FLineText: string;
    FLine: PChar;
    FRun: Integer;
    FTokenPos: Integer;
    FTokenKind: TModelTokenKind;
    FInBlockComment: Boolean;
    FSyntax: TModelSyntax;
    FCommentAttri: TSynHighlighterAttributes;
    FIdentifierAttri: TSynHighlighterAttributes;
    FKeywordAttri: TSynHighlighterAttributes;
    FNumberAttri: TSynHighlighterAttributes;
    FStringAttri: TSynHighlighterAttributes;
    FSymbolAttri: TSynHighlighterAttributes;
    procedure SetSyntax(const Value: TModelSyntax);
  protected
    function GetIdentChars: TSynIdentChars; override;
  public
    class function GetLanguageName: string; override;
    constructor Create(AOwner: TComponent); override;
    function IsKeyword(const AToken: string): Boolean; override;
    function GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetRange: Pointer; override;
    function GetToken: string; override;
    procedure GetTokenEx(out TokenStart: PChar; out TokenLength: Integer);
      override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: Integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    procedure SetLine(const NewValue: string; LineNumber: Integer); override;
  published
    property Syntax: TModelSyntax read FSyntax write SetSyntax;
  end;

implementation

uses
  SynEditStrConst;

constructor TLPModelHighlighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment);
  FCommentAttri.Foreground := clGreen;
  FCommentAttri.Style := [fsItalic];
  AddAttribute(FCommentAttri);
  FIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(FIdentifierAttri);
  FKeywordAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord);
  FKeywordAttri.Foreground := clBlue;
  FKeywordAttri.Style := [fsBold];
  AddAttribute(FKeywordAttri);
  FNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber);
  FNumberAttri.Foreground := clNavy;
  AddAttribute(FNumberAttri);
  FStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrString);
  FStringAttri.Foreground := clMaroon;
  AddAttribute(FStringAttri);
  FSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol);
  AddAttribute(FSymbolAttri);
  SetAttributesOnChange(@DefHighlightChange);
  FSyntax := msLP;
  FTokenKind := mtNull;
end;

class function TLPModelHighlighter.GetLanguageName: string;
begin
  Result := 'LP model';
end;

function TLPModelHighlighter.GetIdentChars: TSynIdentChars;
begin
  Result := inherited GetIdentChars + ['_', '0'..'9'];
end;

function TLPModelHighlighter.GetDefaultAttribute(
  Index: Integer): TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := FCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := FIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := FKeywordAttri;
    SYN_ATTR_STRING: Result := FStringAttri;
    SYN_ATTR_WHITESPACE: Result := nil;
    SYN_ATTR_SYMBOL: Result := FSymbolAttri;
  else
    Result := nil;
  end;
end;

function TLPModelHighlighter.GetEol: Boolean;
begin
  Result := FTokenKind = mtNull;
end;

function TLPModelHighlighter.GetRange: Pointer;
begin
  if FInBlockComment then
    Result := @FInBlockComment
  else
    Result := nil;
end;

procedure TLPModelHighlighter.SetRange(Value: Pointer);
begin
  FInBlockComment := Value <> nil;
end;

procedure TLPModelHighlighter.ResetRange;
begin
  FInBlockComment := False;
end;

procedure TLPModelHighlighter.SetLine(const NewValue: string;
  LineNumber: Integer);
begin
  inherited SetLine(NewValue, LineNumber);
  FLineText := NewValue;
  FLine := PChar(FLineText);
  FRun := 0;
  Next;
end;

function TLPModelHighlighter.GetToken: string;
begin
  SetString(Result, FLine + FTokenPos, FRun - FTokenPos);
end;

procedure TLPModelHighlighter.GetTokenEx(out TokenStart: PChar;
  out TokenLength: Integer);
begin
  TokenStart := FLine + FTokenPos;
  TokenLength := FRun - FTokenPos;
end;

function TLPModelHighlighter.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case FTokenKind of
    mtComment: Result := FCommentAttri;
    mtIdentifier: Result := FIdentifierAttri;
    mtKeyword: Result := FKeywordAttri;
    mtNumber: Result := FNumberAttri;
    mtString: Result := FStringAttri;
    mtSymbol: Result := FSymbolAttri;
  else
    Result := nil;
  end;
end;

function TLPModelHighlighter.GetTokenKind: Integer;
begin
  Result := Ord(FTokenKind);
end;

function TLPModelHighlighter.GetTokenPos: Integer;
begin
  Result := FTokenPos;
end;

function TLPModelHighlighter.IsKeyword(const AToken: string): Boolean;
const
  LPWords = ' MAX MIN MINIMIZE MAXIMIZE MINIMISE MAXIMISE INT INTEGER '
    + 'GENERAL GENERALS BIN BINARY BINARIES FREE BOUND BOUNDS SEC '
    + 'SOS SOSX SUBJECT TO SUCH THAT ST END INFINITY INF ';
  MPSWords = ' NAME ROWS COLUMNS RHS RANGES BOUNDS SOS ENDATA OBJSENSE '
    + ' OBJNAME N L G E LO UP FX FR MI PL BV LI UI SC SI MARKER '
    + ' INTORG INTEND ';
  MathProgWords = ' SET PARAM VAR BINARY INTEGER SYMBOLIC MINIMIZE MAXIMIZE '
    + ' MIN MAX SUBJECT TO S.T. DATA END AND OR NOT IN WITHIN CROSS UNION '
    + ' INTER DIFF SYMDIFF IF THEN ELSE FOR SUM PROD FORALL DISPLAY SOLVE '
    + ' CHECK DEFAULT DIMEN SETOF EXISTS ';
begin
  case FSyntax of
    msLP: Result := Pos(' ' + UpperCase(AToken) + ' ', LPWords) > 0;
    msMPS: Result := Pos(' ' + UpperCase(AToken) + ' ', MPSWords) > 0;
  else
    Result := Pos(' ' + UpperCase(AToken) + ' ', MathProgWords) > 0;
  end;
end;

procedure TLPModelHighlighter.SetSyntax(const Value: TModelSyntax);
begin
  if FSyntax <> Value then
  begin
    FSyntax := Value;
    FInBlockComment := False;
    DefHighlightChange(Self);
  end;
end;

procedure TLPModelHighlighter.Next;
var
  Start: Integer;
  Quote: Char;
begin
  FTokenPos := FRun;
  if FLine[FRun] = #0 then
  begin
    FTokenKind := mtNull;
    Exit;
  end;

  if FInBlockComment then
  begin
    FTokenKind := mtComment;
    while FLine[FRun] <> #0 do
    begin
      if (FLine[FRun] = '*') and (FLine[FRun + 1] = '/') then
      begin
        Inc(FRun, 2);
        FInBlockComment := False;
        Break;
      end;
      Inc(FRun);
    end;
    Exit;
  end;

  if (FSyntax = msMPS) and (FRun = 0) and (FLine[FRun] = '*') then
  begin
    FTokenKind := mtComment;
    while FLine[FRun] <> #0 do Inc(FRun);
    Exit;
  end;

  if FLine[FRun] in [#1..#32] then
  begin
    FTokenKind := mtSpace;
    repeat
      Inc(FRun);
    until not (FLine[FRun] in [#1..#32]);
    Exit;
  end;

  if ((FSyntax = msMathProg) and (FLine[FRun] = '#')) or
     ((FSyntax <> msMPS) and (FLine[FRun] = '/') and
      (FLine[FRun + 1] = '/')) then
  begin
    FTokenKind := mtComment;
    while FLine[FRun] <> #0 do Inc(FRun);
    Exit;
  end;

  if (FSyntax <> msMPS) and (FLine[FRun] = '/') and
     (FLine[FRun + 1] = '*') then
  begin
    FTokenKind := mtComment;
    FInBlockComment := True;
    Inc(FRun, 2);
    while FLine[FRun] <> #0 do
    begin
      if (FLine[FRun] = '*') and (FLine[FRun + 1] = '/') then
      begin
        Inc(FRun, 2);
        FInBlockComment := False;
        Break;
      end;
      Inc(FRun);
    end;
    Exit;
  end;

  if FLine[FRun] in ['''', '"'] then
  begin
    FTokenKind := mtString;
    Quote := FLine[FRun];
    Inc(FRun);
    while (FLine[FRun] <> #0) and (FLine[FRun] <> Quote) do Inc(FRun);
    if FLine[FRun] = Quote then Inc(FRun);
    Exit;
  end;

  if FLine[FRun] in ['0'..'9'] then
  begin
    FTokenKind := mtNumber;
    repeat
      Inc(FRun);
    until not (FLine[FRun] in ['0'..'9', '.', 'e', 'E']);
    Exit;
  end;

  if FLine[FRun] in ['A'..'Z', 'a'..'z', '_'] then
  begin
    Start := FRun;
    repeat
      Inc(FRun);
    until not (FLine[FRun] in ['A'..'Z', 'a'..'z', '0'..'9', '_']);
    if IsKeyword(Copy(FLineText, Start + 1, FRun - Start)) then
      FTokenKind := mtKeyword
    else
      FTokenKind := mtIdentifier;
    Exit;
  end;

  FTokenKind := mtSymbol;
  Inc(FRun);
end;

end.