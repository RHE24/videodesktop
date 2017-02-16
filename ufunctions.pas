unit ufunctions;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes;

function GetScreenshotFileName(const VidFile: string): string;
procedure SplitString(const Delimiter: char; const Str: string;
  const ListOfStrings: TStrings);
function GetMonitorName(const Hnd: HMONITOR): string;
function GetCurrentUser(): string;

implementation

uses
  SysUtils, Forms, Multimon;

function GetScreenshotFileName(const VidFile: string): string;
begin
  Result := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) +
    ChangeFileExt(ExtractFileName(VidFile), '.png');
end;

function GetMonitorName(const Hnd: HMONITOR): string;
type
  TMonitorInfoEx = record
    cbSize: DWORD;
    rcMonitor: TRect;
    rcWork: TRect;
    dwFlags: DWORD;
    szDevice: array[0..CCHDEVICENAME - 1] of AnsiChar;
  end;
var
  DispDev: TDisplayDevice;
  monInfo: TMonitorInfoEx;
begin
  Result := '';

  monInfo.cbSize := sizeof(monInfo);
  if GetMonitorInfo(Hnd, @monInfo) then
  begin
    DispDev.cb := SizeOf(DispDev);
    EnumDisplayDevices(@monInfo.szDevice, 0, @DispDev, 0);
    Result := StrPas(DispDev.DeviceString);
  end;
end;

procedure SplitString(const Delimiter: char; const Str: string;
  const ListOfStrings: TStrings);
begin
  ListOfStrings.Clear();

  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.StrictDelimiter := True;
  ListOfStrings.DelimitedText := Str;
end;

function GetCurrentUser(): string;
var
  nSize: DWord;
begin
  nSize := 1024;
  SetLength(Result, nSize);
  if GetUserName(PChar(Result), nSize) then
    SetLength(Result, nSize - 1)
  else
    Result := '';
end;

end.
