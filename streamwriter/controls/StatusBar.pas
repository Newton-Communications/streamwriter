{
    ------------------------------------------------------------------------
    streamWriter
    Copyright (c) 2010-2016 Alexander Nottelmann

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

{ This unit contains the StatusBar streamWriter is showing at it's bottom }
unit StatusBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ComCtrls, AppData,
  Functions, LanguageObjects, CommCtrl, GUIFunctions, Forms, ExtCtrls;

type
  THomeConnectionState = (cshUndefined, cshConnected, cshConnectedSecure, cshDisconnected, cshFail);

  TSWStatusBar = class(TStatusBar)
  private
    FConnectionState: THomeConnectionState;
    FLoggedIn: Boolean;
    FNotifyTitleChanges: Boolean;
    FClients: Integer;
    FRecordings: Integer;
    FSpeed: UInt64;
    FSongsSaved: Cardinal;
    FOverallSongsSaved: Cardinal;
    FCurrentReceived: UInt64;
    FOverallReceived: UInt64;
    FLastPos: Integer;
    FSpace: Integer;
    FDots: string;

    FTimer: TTimer;
    FSpeedBmp: TBitmap;
    IconConnected, IconConnectedSecure, IconDisconnected: TIcon;
    IconLoggedIn, IconLoggedOff: TIcon;
    IconAutoRecordEnabled: TIcon;
    IconAutoRecordDisabled: TIcon;
    IconGroup: TIcon;
    IconRecord: TIcon;

    procedure TimerTimer(Sender: TObject);
    procedure PaintPanel(Index: Integer);
    procedure FSetSpeed(Value: UInt64);
    procedure FSetCurrentReceived(Value: UInt64);
    procedure FSetOverallReceived(Value: UInt64);
  protected
    procedure DrawPanel(Panel: TStatusPanel; const R: TRect); override;
    procedure Resize; override;
    procedure CNDrawitem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;

    procedure SetState(ConnectionState: THomeConnectionState; LoggedIn, NotifyTitleChanges: Boolean;
      Clients, Recordings: Integer; SongsSaved, OverallSongsSaved: Cardinal);
    procedure BuildSpeedBmp;
    property Speed: UInt64 read FSpeed write FSetSpeed;
    property CurrentReceived: UInt64 read FCurrentReceived write FSetCurrentReceived;
    property OverallReceived: UInt64 read FOverallReceived write FSetOverallReceived;
  published
  end;

implementation

{ TSWStatusBar }

procedure TSWStatusBar.BuildSpeedBmp;
var
  P: Integer;
  NewBmp: TBitmap;
begin
  NewBmp := TBitmap.Create;
  NewBmp.Width := 35;
  NewBmp.Height := ClientHeight - 4;
  NewBmp.Canvas.Pen.Width := 1;
  NewBmp.Canvas.Brush.Color := clBtnFace;
  NewBmp.Canvas.Pen.Color := clBlack;
  NewBmp.Canvas.FillRect(Rect(0, 0, NewBmp.Width, NewBmp.Height));

  if FSpeedBmp <> nil then
  begin
    NewBmp.Canvas.Draw(-1, 0, FSpeedBmp);
  end;
  FSpeedBmp.Free;
  FSpeedBmp := NewBmp;

  P := 0;
  if AppGlobals.MaxSpeed > 0 then
  begin
    P := Trunc(((FSpeed / 1024) / AppGlobals.MaxSpeed) * NewBmp.Height - 1);
    if P > NewBmp.Height - 1 then
      P := NewBmp.Height - 1;
    if P < 1 then
      P := 1;
  end;

  FSpeedBmp.Canvas.MoveTo(0, FSpeedBmp.Height - 1);
  FSpeedBmp.Canvas.LineTo(FSpeedBmp.Width - 1, FSpeedBmp.Height - 1);

  FSpeedBmp.Canvas.MoveTo(FSpeedBmp.Width - 1, FSpeedBmp.Height - P);
  FSpeedBmp.Canvas.LineTo(FSpeedBmp.Width - 1, FSpeedBmp.Height);

  if MulDiv(P, 100, FSpeedBmp.Height) >= 65 then
  begin
    FSpeedBmp.Canvas.Brush.Color := HTML2Color('4b1616');
    FSpeedBmp.Canvas.Pen.Color := HTML2Color('4b1616');
    FSpeedBmp.Canvas.FillRect(Rect(FSpeedBmp.Width - 1, FSpeedBmp.Height - MulDiv(75, FSpeedBmp.Height, 100), FSpeedBmp.Width, FSpeedBmp.Height - MulDiv(65, FSpeedBmp.Height, 100)));
  end;

  if MulDiv(P, 100, FSpeedBmp.Height) >= 75 then
  begin
    FSpeedBmp.Canvas.Brush.Color := HTML2Color('722222');
    FSpeedBmp.Canvas.Pen.Color := HTML2Color('722222');
    FSpeedBmp.Canvas.FillRect(Rect(FSpeedBmp.Width - 1, FSpeedBmp.Height - MulDiv(85, FSpeedBmp.Height, 100), FSpeedBmp.Width, FSpeedBmp.Height - MulDiv(75, FSpeedBmp.Height, 100)));
  end;

  if MulDiv(P, 100, FSpeedBmp.Height) >= 85 then
  begin
    FSpeedBmp.Canvas.Brush.Color := HTML2Color('9d2626');
    FSpeedBmp.Canvas.Pen.Color := HTML2Color('9d2626');
    FSpeedBmp.Canvas.FillRect(Rect(FSpeedBmp.Width - 1, FSpeedBmp.Height - MulDiv(90, FSpeedBmp.Height, 100), FSpeedBmp.Width, FSpeedBmp.Height - MulDiv(85, FSpeedBmp.Height, 100)));
  end;

  if MulDiv(P, 100, FSpeedBmp.Height) >= 90 then
  begin
    FSpeedBmp.Canvas.Brush.Color := HTML2Color('c42c2c');
    FSpeedBmp.Canvas.Pen.Color := HTML2Color('c42c2c');
    FSpeedBmp.Canvas.FillRect(Rect(FSpeedBmp.Width - 1, FSpeedBmp.Height - MulDiv(95, FSpeedBmp.Height, 100), FSpeedBmp.Width, FSpeedBmp.Height - MulDiv(90, FSpeedBmp.Height, 100)));
  end;

  if MulDiv(P, 100, FSpeedBmp.Height) >= 95 then
  begin
    FSpeedBmp.Canvas.Brush.Color := HTML2Color('d71717');
    FSpeedBmp.Canvas.Pen.Color := HTML2Color('d71717');
    FSpeedBmp.Canvas.FillRect(Rect(FSpeedBmp.Width - 1, FSpeedBmp.Height - MulDiv(100, FSpeedBmp.Height, 100), FSpeedBmp.Width, FSpeedBmp.Height - MulDiv(95, FSpeedBmp.Height, 100)));
  end;

  FLastPos := P;
end;

procedure TSWStatusBar.CNDrawitem(var Message: TWMDrawItem);
begin
  inherited;

  Message.Result := 1;
end;

constructor TSWStatusBar.Create(AOwner: TComponent);
var
  P: TStatusPanel;
begin
  inherited;

  Height := GetTextSize('Wyg', Font).cy + 4;

  ShowHint := False;

  FTimer := TTimer.Create(Self);
  FTimer.OnTimer := TimerTimer;
  FTimer.Interval := 1000;
  FTimer.Enabled := True;

  IconConnected := TIcon.Create;
  IconConnected.Handle := LoadImage(HInstance, 'CONNECT_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconConnectedSecure := TIcon.Create;
  IconConnectedSecure.Handle := LoadImage(HInstance, 'CONNECT_SECURE_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconDisconnected := TIcon.Create;
  IconDisconnected.Handle := LoadImage(HInstance, 'DISCONNECT_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconLoggedIn := TIcon.Create;
  IconLoggedIn.Handle := LoadImage(HInstance, 'USER_ENABLED_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconLoggedOff := TIcon.Create;
  IconLoggedOff.Handle := LoadImage(HInstance, 'USER_DISABLED_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconAutoRecordEnabled := TIcon.Create;
  IconAutoRecordEnabled.Handle := LoadImage(HInstance, 'AUTO_ENABLED_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconAutoRecordDisabled := TIcon.Create;
  IconAutoRecordDisabled.Handle := LoadImage(HInstance, 'AUTO_DISABLED_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconGroup := TIcon.Create;
  IconGroup.Handle := LoadImage(HInstance, 'GROUP_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);
  IconRecord := TIcon.Create;
  IconRecord.Handle := LoadImage(HInstance, 'RECORD_15', IMAGE_ICON, 15, 15, LR_DEFAULTCOLOR);

  FSpace := MulDiv(GetTextSize('WWW', Font).cx, Screen.PixelsPerInch, 96);

  P := Panels.Add;
  P.Width := 2 + 56 + GetTextSize(_('Connecting...'), Font).cx + FSpace;
  P.Style := psOwnerDraw;

  P := Panels.Add;
  P.Width := 18 + 4 + 18 + GetTextSize('00000000', Font).cx + MulDiv(GetTextSize('W', Font).cx, Screen.PixelsPerInch, 96) + 10;
  P.Style := psOwnerDraw;

  P := Panels.Add;
  P.Style := psOwnerDraw;

  P := Panels.Add;
  P.Width := 2 + GetTextSize(Format(_('%s/%s received'), ['000,00 kb', '000,00 kb']), Font).cx + FSpace;
  P.Style := psOwnerDraw;

  P := Panels.Add;
  P.Style := psOwnerDraw;
end;

destructor TSWStatusBar.Destroy;
begin
  IconConnected.Free;
  IconConnectedSecure.Free;
  IconDisconnected.Free;
  IconLoggedIn.Free;
  IconLoggedOff.Free;
  IconAutoRecordEnabled.Free;
  IconAutoRecordDisabled.Free;
  IconGroup.Free;
  IconRecord.Free;
  FSpeedBmp.Free;

  inherited;
end;

procedure TSWStatusBar.DrawPanel(Panel: TStatusPanel; const R: TRect);
var
  R2: TRect;
begin
  inherited;

  {
  Hint := _('Users/active streams');
  if (FConnectionState = cshConnected) and FNotifyTitleChanges then
    Hint := Hint + _(' (automatic recordings enabled)')
  else
    Hint := Hint + _(' (automatic recordings disabled)');
  }

  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(R);

  case Panel.Index of
    0:
      begin
        case FConnectionState of
          cshConnected:
            begin
              FTimer.Enabled := False;
              FDots := '';

              Canvas.Draw(R.Left, R.Top + (R.Bottom - R.Top) div 2 - IconConnected.Height div 2, IconConnected);
              Canvas.TextOut(R.Left + 56, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(_('Connected')) div 2, _('Connected'));
            end;
          cshConnectedSecure:
            begin
              FTimer.Enabled := False;
              FDots := '';

              Canvas.Draw(R.Left, R.Top + (R.Bottom - R.Top) div 2 - IconConnected.Height div 2, IconConnectedSecure);
              Canvas.TextOut(R.Left + 56, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(_('Connected')) div 2, _('Connected'));
            end;
          cshDisconnected:
            begin
              FTimer.Enabled := True;

              if Length(FDots) mod 2 = 0 then
                Canvas.Draw(R.Left, R.Top + (R.Bottom - R.Top) div 2 - IconDisconnected.Height div 2, IconDisconnected)
              else
                Canvas.Draw(R.Left, R.Top + (R.Bottom - R.Top) div 2 - IconDisconnected.Height div 2, IconConnected);

              Canvas.TextOut(R.Left + 56, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(_('Connecting') + FDots) div 2, _('Connecting') + FDots);
            end;
          cshFail:
            begin
              FTimer.Enabled := False;
              FDots := '';

              Canvas.Draw(R.Left, R.Top + (R.Bottom - R.Top) div 2 - IconDisconnected.Height div 2, IconDisconnected);
              Canvas.TextOut(R.Left + 56, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(_('Error')) div 2, _('Error'));
            end;
        end;

        if FLoggedIn then
          Canvas.Draw(R.Left + 18, R.Top + (R.Bottom - R.Top) div 2 - IconLoggedIn.Height div 2, IconLoggedIn)
        else
          Canvas.Draw(R.Left + 18, R.Top + (R.Bottom - R.Top) div 2 - IconLoggedOff.Height div 2, IconLoggedOff);

        if FNotifyTitleChanges then
          Canvas.Draw(R.Left + 36, R.Top + (R.Bottom - R.Top) div 2 - IconAutoRecordEnabled.Height div 2, IconAutoRecordEnabled)
        else
          Canvas.Draw(R.Left + 36, R.Top + (R.Bottom - R.Top) div 2 - IconAutoRecordDisabled.Height div 2, IconAutoRecordDisabled);
      end;
    1:
      begin
        if (FConnectionState = cshConnected) or (FConnectionState = cshConnectedSecure) then
        begin
          Canvas.Draw(R.Left, R.Top + (R.Bottom - R.Top) div 2 - IconGroup.Height div 2, IconGroup);
          Canvas.TextOut(R.Left + 18, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(IntToStr(FClients)) div 2, IntToStr(FClients));

          Canvas.Draw(R.Left + 18 + Canvas.TextWidth(IntToStr(FClients)) + 4, R.Top + (R.Bottom - R.Top) div 2 - IconRecord.Height div 2, IconRecord);
          Canvas.TextOut(R.Left + 18 + Canvas.TextWidth(IntToStr(FClients)) + 4 + 18, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(IntToStr(FRecordings)) div 2, IntToStr(FRecordings));
        end else
        begin
          R2 := R;
          // -2, weil es unten im PaintPanel() so addiert wird.
          // Und dann noch etwas mehr ins Minus gehen, damit der Rahmen links verschwindet.
          R2.Left := R2.Left - 6;
          Canvas.FillRect(R2);
        end;
      end;
    2:
      begin
        Canvas.TextOut(R.Left + 2, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(MakeSize(FSpeed) + '/s') div 2, MakeSize(FSpeed) + '/s');
        if AppGlobals.LimitSpeed and (AppGlobals.MaxSpeed > 0) then
        begin
          Panels[2].Width := 2 + 35 + GetTextSize(_('0000/KBs'), Font).cx + FSpace;
          if FSpeedBmp <> nil then
            Canvas.Draw(R.Right - FSpeedBmp.Width - 2, R.Bottom - FSpeedBmp.Height, FSpeedBmp);
        end else
          Panels[2].Width := 2 + GetTextSize(_('0000/KBs'), Font).cx + FSpace;
      end;
    3:
      Canvas.TextOut(R.Left + 2, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(Format(_('%s/%s received'), [MakeSize(FCurrentReceived), MakeSize(FOverallReceived)])) div 2, Format(_('%s/%s received'), [MakeSize(FCurrentReceived), MakeSize(FOverallReceived)]));
    4:
      Canvas.TextOut(R.Left + 2, R.Top + ((R.Bottom - R.Top) div 2) - Canvas.TextHeight(Format(_('%d/%d songs saved'), [FSongsSaved, FOverallSongsSaved])) div 2, Format(_('%d/%d songs saved'), [FSongsSaved, FOverallSongsSaved]));
  end;
end;

procedure TSWStatusBar.FSetCurrentReceived(Value: UInt64);
var
  C: Boolean;
begin
  C := FCurrentReceived <> Value;
  FCurrentReceived := Value;

  if C then
    PaintPanel(3);
end;

procedure TSWStatusBar.FSetOverallReceived(Value: UInt64);
var
  C: Boolean;
begin
  C := FOverallReceived <> Value;
  FOverallReceived := Value;

  if C then
    PaintPanel(3);
end;

procedure TSWStatusBar.FSetSpeed(Value: UInt64);
begin
  FSpeed := Value;
  BuildSpeedBmp;
  PaintPanel(2);
end;

procedure TSWStatusBar.PaintPanel(Index: Integer);
var
  R: TRect;
begin
  Perform(SB_GETRECT, Index, Integer(@R));
  R.Right := R.Right - 2;
  R.Top := R.Top + 1;
  // Achtung: Wenn ich das �ndere, muss ich auch DrawPanel() f�r Panel 1 �ndern,
  // f�r den Fall, dass keine Verbindung zum Server da ist.
  R.Left := R.Left + 2;
  R.Bottom := R.Bottom - 1;
  DrawPanel(Panels[Index], R);
end;

procedure TSWStatusBar.Resize;
begin
  inherited;

  BuildSpeedBmp;
end;

procedure TSWStatusBar.SetState(ConnectionState: THomeConnectionState; LoggedIn, NotifyTitleChanges: Boolean;
  Clients, Recordings: Integer; SongsSaved, OverallSongsSaved: Cardinal);
var
  OldConnectionState: THomeConnectionState;
  OldLoggedIn, OldNotifyTitleChanges: Boolean;
  OldClients, OldRecordings: Integer;
  OldSongsSaved, OldOverallSongsSaved: Cardinal;
begin
  OldConnectionState := FConnectionState;
  OldLoggedIn := FLoggedIn;
  OldNotifyTitleChanges := FNotifyTitleChanges;
  OldClients := FClients;
  OldRecordings := FRecordings;
  OldSongsSaved := FSongsSaved;
  OldOverallSongsSaved := FOverallSongsSaved;

  FConnectionState := ConnectionState;
  FLoggedIn := LoggedIn;
  FNotifyTitleChanges := NotifyTitleChanges;
  if (ConnectionState = cshConnected) or (ConnectionState = cshConnectedSecure) then
  begin
    FClients := Clients;
    FRecordings := Recordings;
  end else
  begin
    FClients := 0;
    FRecordings := 0;
  end;

  FSongsSaved := SongsSaved;
  FOverallSongsSaved := OverallSongsSaved;

  if (OldConnectionState <> FConnectionState) or (OldLoggedIn <> FLoggedIn) then
  begin
    Repaint;
    PaintPanel(0);
    PaintPanel(1);
  end;

  if (OldClients <> FClients) or (OldRecordings <> FRecordings) or (OldNotifyTitleChanges <> FNotifyTitleChanges) then
  begin
    PaintPanel(0);
    PaintPanel(1);
  end;

  if (OldSongsSaved <> FSongsSaved) or (OldOverallSongsSaved <> FOverallSongsSaved) then
    PaintPanel(4);
end;

procedure TSWStatusBar.TimerTimer(Sender: TObject);
begin
  FDots := FDots + '.';
  if Length(FDots) = 4 then
    FDots := '';
  PaintPanel(0);
end;

procedure TSWStatusBar.WMPaint(var Message: TWMPaint);
var
  i: Integer;
begin
  // Alles wegmachen, sonst ist da Mist �ber...
  Canvas.FillRect(ClientRect);

  inherited;

  for i := 0 to Panels.Count - 1 do
  begin
    PaintPanel(i);
  end;
end;

end.
