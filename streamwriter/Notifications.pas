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

unit Notifications;

interface

uses
  Windows, SysUtils, Messages, Classes, Controls, Forms, StdCtrls,
  Graphics, UxTheme, Math, GUIFunctions, LanguageObjects, Logging,
  pngimage, PngFunctions, ExtCtrls;

type
  TNotificationStates = (nsFadingIn, nsVisible, nsFadingOut);

  TfrmNotification = class(TForm)
    lblTitle: TLabel;
    lblStream: TLabel;
    imgLogo: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FState: TNotificationStates;
    FDisplayOnEndTitle: string;
    FDisplayOnEndStream: string;

    class function OtherWindowIsFullscreen: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoShow; override;
    procedure WMMouseActivate(var Message: TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  public
    constructor Create(AOwner: TComponent); reintroduce;

    class procedure Act(Title, Stream: string);
    class procedure Stop;

    procedure Display(Title, Stream: string);
    procedure StopDisplay;
  end;

var
  NotificationForm: TfrmNotification;

implementation

{$R *.dfm}

{ TfrmNotification }

class procedure TfrmNotification.Act(Title, Stream: string);
begin
  if OtherWindowIsFullscreen then
    Exit;

  if NotificationForm = nil then
  begin
    NotificationForm := TfrmNotification.Create(nil);
    NotificationForm.Display(Title, Stream);
  end else
  begin
    NotificationForm.Display(Title, Stream);
  end;
end;

constructor TfrmNotification.Create(AOwner: TComponent);
begin
  inherited;

  FState := nsFadingIn;
  Parent := nil;
end;

procedure TfrmNotification.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.WndParent := 0;
  Params.Style := WS_POPUP or WS_THICKFRAME or WS_EX_TOPMOST;
  Params.ExStyle := Params.ExStyle or WS_EX_NOACTIVATE;
end;

procedure TfrmNotification.Display(Title, Stream: string);
var
  TitleTextWidth, TitleTextHeight: Integer;
  StreamTextHeight, StreamTextWidth: Integer;
begin
  case FState of
    nsFadingIn:
      begin
        Title := StringReplace(Title, '&', '&&', [rfReplaceAll]);
        if Trim(Stream) <> '' then
          Stream := Format(_('on %s'), [StringReplace(Stream, '&', '&&', [rfReplaceAll])]);

        TitleTextWidth := GetTextSize(Title, lblTitle.Font).cx;
        TitleTextHeight := GetTextSize(Title, lblTitle.Font).cy;
        StreamTextWidth := GetTextSize(Stream, lblStream.Font).cx;
        StreamTextHeight := GetTextSize(Stream, lblStream.Font).cy;

        if TitleTextWidth > 350 then
          TitleTextWidth := 350;
        if StreamTextWidth > 350 then
          StreamTextWidth := 350;

        lblStream.Top := lblTitle.Top + TitleTextHeight + 8;

        ClientWidth := lblTitle.Left * 2 + imgLogo.Width + 16 + Max(TitleTextWidth, StreamTextWidth);
        ClientHeight := Max(lblTitle.Top * 2 + TitleTextHeight + StreamTextHeight + 8, imgLogo.Height);

        imgLogo.Left := ClientWidth - imgLogo.Width - lblTitle.Left;
        imgLogo.Top := ClientHeight div 2 - imgLogo.Height div 2;

        Left := Screen.PrimaryMonitor.WorkareaRect.Right - ClientWidth - GlassFrame.Right * 2 - 15;
        Top := Screen.PrimaryMonitor.WorkareaRect.Bottom - ClientHeight - GlassFrame.Top * 2 - 15;

        DoShow;
        lblTitle.Caption := TruncateText(Title, TitleTextWidth, lblTitle.Font);
        if Stream <> '' then
          lblStream.Caption := TruncateText(Stream, StreamTextWidth, lblStream.Font)
        else
          lblStream.Caption := '';

        ShowWindow(Handle, SW_HIDE);
        ShowWindow(Handle, SW_SHOWNOACTIVATE);
      end;
    nsVisible, nsFadingOut:
      begin
        FDisplayOnEndTitle := Title;
        FDisplayOnEndStream := Stream;
        KillTimer(Handle, 0);
        KillTimer(Handle, 1);
        KillTimer(Handle, 2);
        SetTimer(Handle, 2, 20, nil);
      end;
  end;
end;

procedure TfrmNotification.DoShow;
begin
  AlphaBlend := True;
  AlphaBlendValue := 0;
  ShowWindow(Handle, SW_SHOWNOACTIVATE);
  SetTimer(Handle, 0, 20, nil);
  SetTimer(Handle, 10, 50, nil);
end;

procedure TfrmNotification.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  KillTimer(Handle, 10);
  Action := caFree;
  NotificationForm := nil;
end;

class function TfrmNotification.OtherWindowIsFullscreen: Boolean;
  function RectMatches(R: TRect; R2: TRect): Boolean;
  begin
    Result := (R.Left = R2.Left) and (R.Top = R2.Top) and (R.Right = R2.Right) and (R.Bottom = R2.Bottom);
  end;
type
  TGetShellWindow = function(): HWND; stdcall;
var
  i: Integer;
  H, Handle: Cardinal;
  R: TRect;
  GetShellWindow: TGetShellWindow;
begin
  H := GetForegroundWindow;

  @GetShellWindow := nil;
  Handle := GetModuleHandle('user32.dll');
  if (Handle > 0) then
    @GetShellWindow := GetProcAddress(Handle, 'GetShellWindow');

  if ((H <> GetDesktopWindow) and ((@GetShellWindow <> nil) and (H <> GetShellWindow))) then
  begin
    GetWindowRect(H, R);
    for i := 0 to Screen.MonitorCount - 1 do
      if RectMatches(Screen.Monitors[i].BoundsRect, R) then
        Exit(True);
  end;

  Exit(False);
end;

class procedure TfrmNotification.Stop;
begin
  if NotificationForm <> nil then
    NotificationForm.StopDisplay;
end;

procedure TfrmNotification.StopDisplay;
begin
  FDisplayOnEndTitle := '';
  FDisplayOnEndStream := '';
  KillTimer(Handle, 0);
  KillTimer(Handle, 1);
  KillTimer(Handle, 2);
  SetTimer(Handle, 2, 5, nil);
end;

procedure TfrmNotification.WMMouseActivate(var Message: TWMMouseActivate);
begin
  inherited;
  Message.Result := MA_NOACTIVATEANDEAT;
end;

procedure TfrmNotification.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTCLIENT;
end;

procedure TfrmNotification.WMTimer(var Message: TWMTimer);
begin
  if Message.TimerID = 0 then
  begin
    if AlphaBlendValue + 20 < 225 then
      AlphaBlendValue := AlphaBlendValue + 20
    else
    begin
      AlphaBlendValue := 225;
      KillTimer(Handle, 0);
      SetTimer(Handle, 1, 4000, nil);
      FState := nsVisible;
    end;
  end else if Message.TimerID = 1 then
  begin
    KillTimer(Handle, 1);
    SetTimer(Handle, 2, 20, nil);
    FState := nsFadingOut;
  end else if Message.TimerID = 2 then
  begin
    if AlphaBlendValue - 20 > 0 then
      AlphaBlendValue := AlphaBlendValue - 20
    else
    begin
      AlphaBlendValue := 0;
      KillTimer(Handle, 2);

      if FDisplayOnEndTitle <> '' then
      begin
        FState := nsFadingIn;
        Display(FDisplayOnEndTitle, FDisplayOnEndStream);
        FDisplayOnEndTitle := '';
        FDisplayOnEndStream := '';
      end else
      begin
        Close;
      end;
    end;
  end;

  if Message.TimerID = 10 then
  begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  end;
end;

end.
