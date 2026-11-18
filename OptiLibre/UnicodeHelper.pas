unit UnicodeHelper;

{$mode objfpc}{$H+}

{$IFDEF MSWINDOWS}

interface

uses
  Classes, SysUtils;

{ Helper functions to handle non-ASCII paths in Windows }

function CopyToTempLocation(const SourcePath: string): string;
function GetSafeTempFilePath(const Prefix: string): string;
function HasNonASCIIChars(const S: string): Boolean;
procedure LoadFileWithUnicodePath(const FilePath: string; Dest: TStrings);
procedure SaveFileWithUnicodePath(const FilePath: string; Source: TStrings);

implementation

function GetSafeTempFilePath(const Prefix: string): string;
var
  TempDir: string;
  Counter: Integer;
begin
  TempDir := GetTempDir(False);
  Counter := 0;
  repeat
    Inc(Counter);
    Result := TempDir + Prefix + '_' + IntToStr(Counter) + '_' +
      IntToStr(Random(10000)) + '.tmp';
  until not FileExists(Result);
end;

function CopyToTempLocation(const SourcePath: string): string;
var
  Source, Dest: TFileStream;
begin
  Result := GetSafeTempFilePath('opti');
  try
    Source := TFileStream.Create(SourcePath, fmOpenRead or fmShareDenyNone);
    try
      Dest := TFileStream.Create(Result, fmCreate);
      try
        Dest.CopyFrom(Source, Source.Size);
      finally
        Dest.Free;
      end;
    finally
      Source.Free;
    end;
  except
    Result := '';
  end;
end;

function HasNonASCIIChars(const S: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do
    if Ord(S[I]) > 127 then
    begin
      Result := True;
      Exit;
    end;
end;

procedure LoadFileWithUnicodePath(const FilePath: string; Dest: TStrings);
var
  TempPath: string;
begin
  if HasNonASCIIChars(FilePath) then
  begin
    TempPath := CopyToTempLocation(FilePath);
    if TempPath <> '' then
    try
      Dest.LoadFromFile(TempPath);
    finally
      if FileExists(TempPath) then
        DeleteFile(TempPath);
    end;
  end
  else
    Dest.LoadFromFile(FilePath);
end;

procedure SaveFileWithUnicodePath(const FilePath: string; Source: TStrings);
var
  TempPath: string;
  TempStream, FileStream: TFileStream;
begin
  if HasNonASCIIChars(FilePath) then
  begin
    TempPath := GetSafeTempFilePath('opti');
    try
      Source.SaveToFile(TempPath);
      TempStream := TFileStream.Create(TempPath, fmOpenRead);
      try
        FileStream := TFileStream.Create(FilePath, fmCreate);
        try
          FileStream.CopyFrom(TempStream, TempStream.Size);
        finally
          FileStream.Free;
        end;
      finally
        TempStream.Free;
      end;
    finally
      if FileExists(TempPath) then
        DeleteFile(TempPath);
    end;
  end
  else
    Source.SaveToFile(FilePath);
end;

{$ENDIF}

end.
