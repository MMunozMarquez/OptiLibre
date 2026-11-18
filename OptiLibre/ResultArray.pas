unit ResultArray;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, lpsolve;

type
  TResultArray = class
  private
    FList: TList;
    function GetValue(const Row, Col: Integer): Double;
    procedure SetValue(const Row, Col: Integer; const Value: Double);
    function GetColCount: Integer;
  public
    function Add(Size: Integer): PFloatArray;
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
    property Value[const Row, Col: Integer]: Double
      read GetValue write SetValue; default;
    property ColCount: Integer read GetColCount;
  end;

implementation

type
  PResultBuffer = ^TResultBuffer;
  TResultBuffer = record
    Data: PFloatArray;
    Size: Integer;
  end;

function TResultArray.Add(Size: Integer): PFloatArray;
var
  Buffer: PResultBuffer;
begin
  if Size < 0 then
    raise ERangeError.Create('Array size cannot be negative');
  if Int64(Size) > (Int64(High(SizeInt)) div SizeOf(Double)) - 1 then
    raise ERangeError.Create('Array size is too large');
  New(Buffer);
  Buffer^.Data := nil;
  Buffer^.Size := Size;
  try
    GetMem(Buffer^.Data, (Size + 1) * SizeOf(Double));
    FillChar(Buffer^.Data^, (Size + 1) * SizeOf(Double), 0);
    FList.Add(Buffer);
  except
    if Buffer^.Data <> nil then
      FreeMem(Buffer^.Data);
    Dispose(Buffer);
    raise;
  end;
  Result := Buffer^.Data;
end;

procedure TResultArray.Clear;
var
  I: Integer;
  Buffer: PResultBuffer;
begin
  for I := 0 to FList.Count - 1 do
  begin
    Buffer := PResultBuffer(FList[I]);
    FreeMem(Buffer^.Data);
    Dispose(Buffer);
  end;
  FList.Clear;
end;

constructor TResultArray.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TResultArray.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TResultArray.GetColCount: Integer;
begin
  Result := FList.Count;
end;

function TResultArray.GetValue(const Row, Col: Integer): Double;
var
  Buffer: PResultBuffer;
begin
  if (Row < 0) or (Row >= FList.Count) then
    raise ERangeError.Create('Result column index is out of range');
  if Col < 0 then
    raise ERangeError.Create('Result row index cannot be negative');
  Buffer := PResultBuffer(FList[Row]);
  if Col > Buffer^.Size then
    raise ERangeError.Create('Result row index is out of range');
  Result := Buffer^.Data^[Col];
end;

procedure TResultArray.SetValue(const Row, Col: Integer;
  const Value: Double);
var
  Buffer: PResultBuffer;
begin
  if (Row < 0) or (Row >= FList.Count) then
    raise ERangeError.Create('Result column index is out of range');
  if Col < 0 then
    raise ERangeError.Create('Result row index cannot be negative');
  Buffer := PResultBuffer(FList[Row]);
  if Col > Buffer^.Size then
    raise ERangeError.Create('Result row index is out of range');
  Buffer^.Data^[Col] := Value;
end;

end.
