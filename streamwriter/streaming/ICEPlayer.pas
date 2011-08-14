{
    ------------------------------------------------------------------------
    streamWriter
    Copyright (c) 2010-2011 Alexander Nottelmann

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 3
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
    ------------------------------------------------------------------------
}
unit ICEPlayer;

interface

uses
  Windows, SysUtils, Classes, DynBASS, ExtendedStream, SyncObjs, AppData,
  AudioStream, Logging;

type
  TICEPlayer = class
  private
    FMem: TExtendedStream;
    FLock: TCriticalSection;
    FPlayer: DWORD;
    FPausing, FStopping: Boolean;
    FPlayStartBuffer: Cardinal;

    function FGetPlaying: Boolean;
    function FGetPaused: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Play;
    procedure Pause;
    procedure Stop;
    procedure SetVolume(Vol: Integer);

    procedure PushData(Buf: Pointer; Len: Integer);

    property Playing: Boolean read FGetPlaying;
    property Paused: Boolean read FGetPaused;
    property Pausing: Boolean read FPausing;
    property Stopping: Boolean read FStopping;
    property Mem: TExtendedStream read FMem;
  end;

implementation

procedure EndSyncProc(handle: HSYNC; channel, data: DWORD; user: Pointer); stdcall;
var
  P: TICEPlayer;
begin
  P := TICEPlayer(user);
  if P.FPausing then
    BASSChannelPause(channel)
  else if P.Stopping then       
    BASSStreamFree(channel);
  TICEPlayer(user).FPausing := False;
  TICEPlayer(user).FStopping := False;
end;

procedure BASSClose(user: Pointer); stdcall;
begin

end;

function BASSLen(user: Pointer): QWORD; stdcall;
begin
  Result := 0;
end;

function BASSRead(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
var
  Mem: TExtendedStream;
  CopyLen: Cardinal;
  Tries: Integer;
begin
  Tries := 0;
  Result := 0;

  while not TICEPlayer(user).FLock.TryEnter do
  begin
    Inc(Tries);
    Sleep(10);

    if Tries > 20 then
      Exit;
  end;

  try
    Mem := TICEPlayer(user).FMem;

    Tries := 0;
    while Mem.Size = 0 do
    begin
      Inc(Tries);
      Sleep(10);

      if Tries > 100 then
        Exit;
    end;

    CopyLen := Mem.Size;
    if Length < CopyLen then
      CopyLen := Length;

    CopyMemory(Buffer, Mem.Memory, CopyLen);
    Result := CopyLen;

    Mem.RemoveRange(0, CopyLen);
  finally
    TICEPlayer(user).FLock.Leave;
  end;
end;

function BASSSeek(offset: QWORD; user: Pointer): BOOL; stdcall;
begin
  Result := BOOL(0);
end;

{ TPlayThread }

constructor TICEPlayer.Create;
begin
  inherited Create;

  FMem := TAudioStreamMemory.Create;
  FLock := TCriticalSection.Create;
  FPlayer := 0;
  FPlayStartBuffer := 0;
end;

destructor TICEPlayer.Destroy;
begin
  if FPlayer > 0 then
  begin
    BASSStreamFree(FPlayer);
    FPlayer := 0;
  end;
  FMem.Free;
  FLock.Free;

  inherited;
end;

function TICEPlayer.FGetPlaying: Boolean;
begin
  Result := (FPlayer > 0) and (FStopping or (BASSChannelIsActive(FPlayer) = BASS_ACTIVE_PLAYING) or (BASSChannelIsActive(FPlayer) = BASS_ACTIVE_STALLED));
end;

function TICEPlayer.FGetPaused: Boolean;
begin
  Result := (FPlayer > 0) and ((BASSChannelIsActive(FPlayer) = BASS_ACTIVE_PAUSED) or FPausing);
end;

procedure TICEPlayer.Play;
var
  Funcs: BASS_FILEPROCS;
  R: Integer;
begin
  if (FPlayStartBuffer = 0) or (not Paused and (FMem.Size < FPlayStartBuffer)) then
    Exit;

  if not Playing then
  begin
    BASSSetDevice(AppGlobals.SoundDevice);

    Funcs.close := BASSClose;
    Funcs.length := BASSLen;
    Funcs.seek := BASSSeek;
    Funcs.read := BASSRead;

    if FPlayer > 0 then
      BASSStreamFree(FPlayer);
    FPlayer := BASSStreamCreateFileUser(STREAMFILE_BUFFER, 0, Funcs, Self);

    SetVolume(AppGlobals.PlayerVolume);

    BASSChannelPlay(FPlayer, False);

    R := BASSErrorGetCode;

    if R <> 0 then
    begin
      BASSStreamFree(FPlayer);
      FPlayer := 0;
    end;
  end;
end;

procedure TICEPlayer.Pause;
var
  State: Cardinal;
begin
  if FPlayer > 0 then
  begin
    State := BASSChannelIsActive(FPlayer);
    if State = BASS_ACTIVE_PLAYING then
    begin
      FPausing := True;
      BASSChannelSlideAttribute(FPlayer, 2, 0, 300);
      BASSChannelSetSync(FPlayer, BASS_SYNC_SLIDE, 0, EndSyncProc, Self);
    end;
  end;
end;

procedure TICEPlayer.Stop;
var
  State: Cardinal;
begin
  if FPlayer > 0 then
  begin
    State := BASSChannelIsActive(FPlayer);
    if State = BASS_ACTIVE_PLAYING then
    begin
      FStopping := True;
      BASSChannelSlideAttribute(FPlayer, 2, 0, 300);
      BASSChannelSetSync(FPlayer, BASS_SYNC_SLIDE, 0, EndSyncProc, Self);
    end else
    begin
      BASSStreamFree(FPlayer);
    end;
  end;
  FPlayer := 0;
end;

procedure TICEPlayer.SetVolume(Vol: Integer);
begin
  if FPlayer > 0 then
    BASSChannelSetAttribute(FPlayer, 2, Vol / 100);
end;

procedure TICEPlayer.PushData(Buf: Pointer; Len: Integer);
var
  Time: Double;
  BufLen: Int64;
  TempPlayer, BitRate: Cardinal;
const
  MAX_BUFFER_SIZE = 1048576;
begin
  FLock.Enter;
  try
    FMem.Seek(0, soFromEnd);
    FMem.Write(Buf^, Len);

    while FMem.Size > MAX_BUFFER_SIZE do
    begin
      // Puffer "rotieren"
      FMem.RemoveRange(0, 65536);
    end;

    if FMem.Size < 8192 then
      Exit;

    if (not Playing) and (not Paused) then
    begin
      TempPlayer := BASSStreamCreateFile(True, FMem.Memory, 0, FMem.Size, BASS_STREAM_DECODE);
      if TempPlayer = 0 then
        raise Exception.Create('');
      try
        BASSChannelSetPosition(TempPlayer, FMem.Size, BASS_POS_BYTE);
        Time := BASSChannelBytes2Seconds(TempPlayer, BASSChannelGetLength(TempPlayer, BASS_POS_BYTE));
        BufLen := BASSStreamGetFilePosition(TempPlayer, BASS_FILEPOS_END);
        if BufLen = -1 then
          raise Exception.Create('');
        BitRate := Trunc(BufLen / (125 * Time) + 0.5);

        FPlayStartBuffer := BitRate * 1100;
      finally
        BASSStreamFree(TempPlayer);
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

end.
