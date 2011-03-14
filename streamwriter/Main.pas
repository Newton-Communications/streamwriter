{
    ------------------------------------------------------------------------
    streamWriter
    Copyright (c) 2010 Alexander Nottelmann

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
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WinSock, ICEClient, StdCtrls, ExtCtrls, ImgList, Menus,
  XPMan, VirtualTrees, ComCtrls, ToolWin, ClientView, ICEThread,
  Settings, DataManager, ActnList, DragDrop, DropTarget,
  DragDropInternet, DragDropText, DragDropFile, Update, UpdateClient,
  LanguageObjects, AppDataBase, Functions, ClientManager, ShellAPI, DropSource,
  About, MsgDlg, HomeCommunication, StreamBrowserView, Clipbrd,
  StationCombo, GUIFunctions, StreamInfoView, StreamDebugView, Plugins,
  Buttons, DynBass, ClientTab, CutTab, MControls, Tabs, SavedTab,
  CheckFilesThread, ListsTab, CommCtrl, PngImageList, CommunityLogin;

type
  TfrmStreamWriterMain = class(TForm)
    addStatus: TStatusBar;
    addXP: TXPManifest;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuSettings: TMenuItem;
    N3: TMenuItem;
    mnuExit: TMenuItem;
    mnuStreams: TMenuItem;
    mnuStartStreaming2: TMenuItem;
    mnuStopStreaming2: TMenuItem;
    mnuRemove2: TMenuItem;
    mnuUpdate: TMenuItem;
    mnuCheckUpdate: TMenuItem;
    ActionList1: TActionList;
    actStart: TAction;
    actStop: TAction;
    actRemove: TAction;
    mnuStreamPopup: TPopupMenu;
    mnuStartStreaming1: TMenuItem;
    mnuStopStreaming1: TMenuItem;
    Entfernen1: TMenuItem;
    tmrSpeed: TTimer;
    mnuStreamSettings1: TMenuItem;
    mnuStreamSettings2: TMenuItem;
    TrayIcon1: TTrayIcon;
    mnuTray: TPopupMenu;
    mnuShow: TMenuItem;
    N2: TMenuItem;
    Beenden1: TMenuItem;
    mnuTuneIn1: TMenuItem;
    N4: TMenuItem;
    mnuTuneIn2: TMenuItem;
    mnuSavePlaylist2: TMenuItem;
    N6: TMenuItem;
    mnuSavePlaylist1: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    actExit: TAction;
    actSettings: TAction;
    actAbout: TAction;
    N8: TMenuItem;
    N9: TMenuItem;
    View1: TMenuItem;
    mnuShowStreamBrowser: TMenuItem;
    actShowSideBar: TAction;
    actTuneInStream: TAction;
    actTuneInFile: TAction;
    mnuListenToStream2: TMenuItem;
    mnuListenToFile2: TMenuItem;
    mnuListenToStream1: TMenuItem;
    mnuListenToFile1: TMenuItem;
    actSavePlaylistStream: TAction;
    actSavePlaylistFile: TAction;
    actSavePlaylistStream1: TMenuItem;
    actSavePlaylistFile1: TMenuItem;
    Stream1: TMenuItem;
    Stream2: TMenuItem;
    mnuReset1: TMenuItem;
    mnuReset11: TMenuItem;
    actResetData: TAction;
    tbClients: TToolBar;
    cmdStart: TToolButton;
    cmdStop: TToolButton;
    ToolButton3: TToolButton;
    cmdRemove: TToolButton;
    ToolButton2: TToolButton;
    cmdStartPlay: TToolButton;
    cmdStopPlay: TToolButton;
    ToolButton1: TToolButton;
    ToolButton6: TToolButton;
    ToolButton4: TToolButton;
    cmdShowStreamBrowser: TToolButton;
    actCutSave: TAction;
    actCutSaveAs: TAction;
    mnuHelp2: TMenuItem;
    N1: TMenuItem;
    actHelp: TAction;
    actPlay: TAction;
    actStopPlay: TAction;
    mnuStartPlay2: TMenuItem;
    mnuStopPlay2: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    mnuStartPlay1: TMenuItem;
    mnuStopPlay1: TMenuItem;
    actNewCategory: TAction;
    Addcategory1: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    Newcategory1: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    actStreamSettings: TAction;
    cmdStreamSettings: TToolButton;
    actOpenWebsite: TAction;
    mnuOpenWebsite1: TMenuItem;
    Openwebsite1: TMenuItem;
    cmdPause: TToolButton;
    actPause: TAction;
    Pause1: TMenuItem;
    Pause2: TMenuItem;
    tmrRecordings: TTimer;
    imgClients: TPngImageList;
    imgImages: TPngImageList;
    imgLog: TPngImageList;
    Community1: TMenuItem;
    actLogOn: TAction;
    Login1: TMenuItem;
    actLogOff: TAction;
    Logoff1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrSpeedTimer(Sender: TObject);
    procedure actStreamSettingsExecute(Sender: TObject);
    procedure addTrayClick(Sender: TObject);
    procedure mnuCheckUpdateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuShowClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mnuStreamPopupPopup(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure mnuStreamSettingsToolbarPopup(Sender: TObject);
    procedure pagSidebarChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actHelpExecute(Sender: TObject);
    procedure addStatusResize(Sender: TObject);
    procedure addStatusDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure tmrRecordingsTimer(Sender: TObject);
    procedure actLogOnExecute(Sender: TObject);
    procedure Community1Click(Sender: TObject);
    procedure actLogOffExecute(Sender: TObject);
  private
    FCommunityLogin: TfrmCommunityLogin;

    // Statusbar Icons
    IconConnected, IconDisconnected: THandle;
    IconLoggedIn, IconLoggedOff: THandle;
    IconGroup: THandle;

    FStreams: TDataLists;
    FUpdater: TUpdateClient;
    FUpdateOnExit: Boolean;

    FClientCount: Cardinal;
    FRecordingCount: Cardinal;
    FLastLocalRecordingCount: Cardinal;

    FWasActivated: Boolean;
    FWasShown: Boolean;
    FWasMaximized: Boolean;

    FCheckFiles: TCheckFilesThread;
    FClients: TClientManager;
    pagMain: TMainPageControl;
    tabClients: TClientTab;
    tabSaved: TSavedTab;
    tabLists: TListsTab;

    procedure OneInstanceMessage(var Msg: TMessage); message WM_USER + 1234;
    procedure QueryEndSession(var Msg: TMessage); message WM_QUERYENDSESSION;
    procedure EndSession(var Msg: TMessage); message WM_ENDSESSION;
    procedure SysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure Hotkey(var Msg: TWMHotKey); message WM_HOTKEY;

    function CanExitApp: Boolean;
    procedure ExitApp(Shutdown: Boolean);
    procedure ShowSettings(BrowseDir: Boolean);
    procedure ShowUpdate(Version: string = ''; UpdateURL: string = '');
    procedure UpdateButtons;
    procedure UpdateStatus;
    procedure SetConnected;
    procedure ToggleWindow(AlwaysShow: Boolean = False);
    procedure UpdaterUpdateFound(Sender: TObject);
    procedure UpdaterNoUpdateFound(Sender: TObject);
    function HandleLoadError(E: Exception): Integer;
    procedure CheckFilesTerminate(Sender: TObject);
    procedure RegisterHotkeys(Reg: Boolean);
    procedure ShowCommunityLogin;

    procedure CommunityLoginClose(Sender: TObject; var Action: TCloseAction);

    procedure HomeCommStateChanged(Sender: TObject);
    procedure HomeCommServerInfo(Sender: TObject; ClientCount, RecordingCount: Cardinal);
    procedure HomeCommError(Sender: TObject; ID: TCommErrors; Msg: string);

    procedure PreTranslate;
    procedure PostTranslate;

    procedure tabClientsUpdateButtons(Sender: TObject);
    procedure tabClientsCut(Entry: TStreamEntry; Track: TTrackInfo);
    procedure tabSavedRefresh(Sender: TObject);

    procedure tabClientsTrackAdded(Entry: TStreamEntry; Track: TTrackInfo);
    procedure tabClientsTrackRemoved(Entry: TStreamEntry; Track: TTrackInfo);
    procedure tabClientsAddIgnoreList(Sender: TObject; Data: string);

    procedure tabSavedTrackRemoved(Entry: TStreamEntry; Track: TTrackInfo);

    procedure tabCutSaved(Sender: TObject);
  protected

  public

  end;

  TStatusHint = class(TCustomHint)
  private
  protected
    procedure SetHintSize(HintWindow: TCustomHintWindow); override;
    procedure PaintHint(HintWindow: TCustomHintWindow); override;
  public
    constructor Create(AOwner: TComponent);
  end;

implementation

uses
  AppData;

{$R *.dfm}

procedure TfrmStreamWriterMain.ExitApp(Shutdown: Boolean);
var
  i: Integer;
  Res: Integer;
  StartTime: Cardinal;
  Saved, Hard: Boolean;
begin
  AppGlobals.MainMaximized := WindowState = wsMaximized;
  if not AppGlobals.MainMaximized then
  begin
    AppGlobals.MainLeft := Left;
    AppGlobals.MainTop := Top;
    AppGlobals.MainWidth := Width;
    AppGlobals.MainHeight := Height;
  end;

  AppGlobals.ShowSidebar := tabClients.SideBar.Visible;
  AppGlobals.SidebarWidth := tabClients.SideBar.Width;

  for i := 0 to tabClients.ClientView.Header.Columns.Count - 1 do
    AppGlobals.HeaderWidth[i] := tabClients.ClientView.Header.Columns[i].Width;

  TrayIcon1.Visible := False;
  tmrSpeed.Enabled := False;

  Hide;

  FUpdater.Kill;

  if not Shutdown then
    AppGlobals.Save(Handle)
  else
    try
      AppGlobals.Save;
    except end;

  Saved := False;
  while not Saved do
  begin
    try
      tabClients.UpdateStreams(FStreams);
      FStreams.Save;
      Break;
    except
      if not Shutdown then
      begin
        Res := MsgBox(Handle, Format(_('An error occured while saving the data file. Please make sure you can write to "%s" and that the file is not in use by another application. Click "Yes" to try again, "No" to exit without saving data.'), [AppGlobals.DataFile]), _('Info'), MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON1);
        if Res = IDNO then
          Break;
      end else
        Break;
    end;
  end;

  tabClients.ClientView.Clear;

  FClients.Terminate;

  HomeComm.Terminate;

  if FCheckFiles <> nil then
    FCheckFiles.Terminate;

  Hard := False;
  StartTime := GetTickCount;
  while (FClients.Count > 0) or (HomeComm.Connected) or (FClients.Active) or (FCheckFiles <> nil) or (FUpdater.Active) do
  begin
    // 5 Sekunden warten, f�r sauberes beenden
    if StartTime < GetTickCount - 5000 then
    begin
      Hard := True;
      Break;
    end;
    Sleep(100);
    Application.ProcessMessages;
  end;

  if FUpdateOnExit then
    FUpdater.RunUpdate(Handle);

  if Hard then
    Halt
  else
    Application.Terminate;
end;

procedure TfrmStreamWriterMain.actSettingsExecute(Sender: TObject);
begin
  ShowSettings(False);
end;

procedure TfrmStreamWriterMain.actAboutExecute(Sender: TObject);
var
  F: TfrmAbout;
begin
  F := TfrmAbout.Create(Self, _('About'));
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TfrmStreamWriterMain.actExitExecute(Sender: TObject);
begin
  if CanExitApp then
    ExitApp(False);
end;

procedure TfrmStreamWriterMain.actHelpExecute(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(AppGlobals.ProjectHelpLink), '', '', 1);
end;

procedure TfrmStreamWriterMain.actLogOnExecute(Sender: TObject);
begin
  ShowCommunityLogin;
end;

procedure TfrmStreamWriterMain.actLogOffExecute(Sender: TObject);
begin
  HomeComm.Logoff;
end;

procedure TfrmStreamWriterMain.actStreamSettingsExecute(Sender: TObject);
var
  Clients: TClientArray;
  S: TfrmSettings;
  Settings: TStreamSettingsArray;
  i: Integer;
begin
  Clients := tabClients.ClientView.NodesToClients(tabClients.ClientView.GetNodes(ntClient, True));
  SetLength(Settings, Length(Clients));

  for i := 0 to Length(Clients) - 1 do
    Settings[i] := Clients[i].Entry.Settings;

  if Length(Clients) > 0 then
  begin
    S := TfrmSettings.Create(Self, Settings);
    S.ShowModal;

    if S.SaveSettings then
    begin
      Clients := tabClients.ClientView.NodesToClients(tabClients.ClientView.GetNodes(ntClient, True));
      for i := 0 to Length(Clients) - 1 do
        if not Clients[i].AutoRemove then
          Clients[i].Entry.Settings.Assign(S.StreamSettings[i]);
    end;
  end;

  // Damit die Entries im Hauptmen� angepasst werden, falls von Popup was ge�ndert wurde.
  UpdateButtons;
end;

procedure TfrmStreamWriterMain.addStatusDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  SetConnected;
end;

procedure TfrmStreamWriterMain.addStatusResize(Sender: TObject);
begin
  SetConnected;
end;

procedure TfrmStreamWriterMain.addTrayClick(Sender: TObject);
begin
  ToggleWindow(False);
end;

procedure TfrmStreamWriterMain.FormActivate(Sender: TObject);
begin
  if FWasActivated then
    Exit;

  FWasActivated := True;

  if not DirectoryExists(AppGlobals.Dir) then
  begin
    MsgBox(Handle, _('The folder for saved songs does not exist.'#13#10'Please select a folder now.'), _('Info'), MB_ICONINFORMATION);
    ShowSettings(True);
  end;

  if AppGlobals.FirstStart then
  begin
    TfrmMsgDlg.ShowMsg(Self, _('This is the first time you are running streamWriter. There are two ways to record music:'#13#10 +
                               '1) You can record streams by double-clicking them in the stream-browser on the right.'#13#10 +
                               '2) Desired songs can be recorded by adding them to the wishlist on the Filter-tab at the top. ' +
                               'When a song from the wishlist is being played on a stream, streamWriter will automatically tune in to record your song. ' +
                               'Please add some artists/titles to your wishlist to try this new feature.'), btOK);
  end else if IsVersionNewer(AppGlobals.LastUsedVersion, AppGlobals.AppVersion) then
  begin
    // TODO: Das muss raus, sobald ich gr��er als 2.0.0.0 oder 1.5.0.0 release!
    //       Sonst werden Menschenkinder genervt!
    TfrmMsgDlg.ShowMsg(Self, _('You have updated from a streamWriter version that did not have community features. ' +
                               'With this version, the wishlist becomes more important:'#13#10'When streamWriter detects a stream playing something on your wishlist, ' +
                               'it will tune into the station and record your desired song. Please try this feature and add some artists/titles to your wishlist.'), btOK);
  end;
end;

procedure TfrmStreamWriterMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caNone;
  if (AppGlobals.Tray) and (not AppGlobals.TrayOnMinimize) then
  begin
    if (Visible) or (IsIconic(Handle)) then
    begin
      TrayIcon1.Visible := True;
      FWasMaximized := WindowState = wsMaximized;
      Hide;
    end;
  end else
  begin
    if CanExitApp then
      ExitApp(False);
  end;
end;

procedure TfrmStreamWriterMain.FormCreate(Sender: TObject);
begin
  FStreams := TDataLists.Create;
  FClients := TClientManager.Create(FStreams);

  HomeComm.OnStateChanged := HomeCommStateChanged;
  HomeComm.OnServerInfo := HomeCommServerInfo;
  HomeComm.OnError := HomeCommError;
  HomeComm.Connect;

  pagMain := TMainPageControl.Create(Self);
  pagMain.Parent := Self;
  pagMain.Visible := True;
  pagMain.Align := alClient;
  pagMain.Images := imgImages;

  tabClients := TClientTab.Create(pagMain);
  tabClients.PageControl := pagMain;
  tabClients.Setup(tbClients, ActionList1, mnuStreamPopup, imgImages, imgClients,
    FClients, FStreams);
  tabClients.SideBar.BrowserView.StreamTree.Images := imgImages;
//  tabClients.SideBar.BrowserView.StreamTree.PopupMenu.Images := imgStations;
  tabClients.AddressBar.Stations.Images := imgImages;
  tabClients.SideBar.DebugView.DebugView.DebugView.Images := imgLog;
  tabClients.OnUpdateButtons := tabClientsUpdateButtons;
  tabClients.OnCut := tabClientsCut;
  tabClients.OnTrackAdded := tabClientsTrackAdded;
  tabClients.OnTrackRemoved := tabClientsTrackRemoved;
  tabClients.OnAddIgnoreList := tabClientsAddIgnoreList;

  tabLists := TListsTab.Create(pagMain);
  tabLists.PageControl := pagMain;

  tabSaved := TSavedTab.Create(pagMain);
  tabSaved.PageControl := pagMain;
  tabSaved.OnCut := tabClientsCut;
  tabSaved.OnTrackRemoved := tabSavedTrackRemoved;
  tabSaved.OnRefresh := tabSavedRefresh;

  IconConnected := LoadImage(HInstance, 'CONNECT', IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR);
  IconDisconnected := LoadImage(HInstance, 'DISCONNECT', IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR);
  IconLoggedIn := LoadImage(HInstance, 'USER_GO', IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR);
  IconLoggedOff := LoadImage(HInstance, 'USER_DELETE', IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR);
  IconGroup := LoadImage(HInstance, 'GROUP', IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR);

  FWasActivated := False;
  FWasShown := False;
  FUpdateOnExit := False;

  try
    FStreams.Load;
  except
    on E: Exception do
    begin
      try
        FStreams.Free;
      except end;
      FStreams := TDataLists.Create;
      // Damit nichts �berschrieben wird.
      FStreams.LoadError := True;

      if HandleLoadError(E) = IDYES then
      begin
        DeleteFile(E.Message);
        FStreams.LoadError := False;
      end;
    end;
  end;

  tabClients.AddressBar.Stations.BuildList(FStreams.RecentList);
  tabClients.BuildTree(FStreams);

  // Ist hier unten, weil hier erst Tracks geladen wurden
  tabSaved.Setup(FStreams, imgImages);

  tabClients.AddressBar.Stations.Sort;

  {$IFDEF DEBUG}Caption := Caption + ' --::: DEBUG BUiLD :::--';{$ENDIF}

  UpdateButtons;
  UpdateStatus;
  tmrSpeed.Enabled := True;
  TrayIcon1.Visible := AppGlobals.Tray;

  FUpdater := TUpdateClient.Create;
  FUpdater.OnNoUpdateFound := UpdaterNoUpdateFound;
  FUpdater.OnUpdateFound := UpdaterUpdateFound;
  if (AppGlobals.AutoUpdate) and (AppGlobals.LastUpdateChecked + 1 < Now) then
    FUpdater.Start(uaVersion);

  Width := AppGlobals.MainWidth;
  Height := AppGlobals.MainHeight;
  if (AppGlobals.MainLeft = -1) or (AppGlobals.MainTop = -1) then
  begin
    AppGlobals.MainLeft := Screen.Width div 2 - Width div 2;
    AppGlobals.MainTop := Screen.Height div 2 - Height div 2;
  end;
  Left := AppGlobals.MainLeft;
  Top := AppGlobals.MainTop;

  addStatus.CustomHint := TStatusHint.Create(Self);

  Language.Translate(Self);
end;

procedure TfrmStreamWriterMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FClients);
  FreeAndNil(FUpdater);
  FreeAndNil(FStreams);
end;

procedure TfrmStreamWriterMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    actHelp.Execute;
end;

procedure TfrmStreamWriterMain.FormShow(Sender: TObject);
begin
  if FWasShown then
    Exit;

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  FWasShown := True;

  tabSavedRefresh(nil);

  RegisterHotkeys(True);

  AppGlobals.WindowHandle := Handle;

  if AppGlobals.MainMaximized then
    WindowState := wsMaximized;
  FWasMaximized := WindowState = wsMaximized;

  tabClients.Shown;
  tabLists.Setup(FStreams, imgImages);
  actShowSideBar.Checked := tabClients.SideBar.Visible;
end;

function TfrmStreamWriterMain.HandleLoadError(E: Exception): Integer;
begin
  if E is EVersionException then
    begin
      Result := MsgBox(0, Format(_('The file "%s" could not be loaded because it was saved with a newer version of streamWriter. ' +
                                   'To use the current file, exit streamWriter and use a newer version of the application. ' +
                                   'To delete the file and continue to use this version click "Yes".'#13#10 +
                                   'WARNING: All data saved in the file will be lost!'#13#10 +
                                   'The file will not be overwritten with new data until it was loaded or deleted.'),
                                 [E.Message]),
                                 _('Info'), MB_YESNO or MB_ICONEXCLAMATION or MB_DEFBUTTON2);
    end else
    begin
      Result := MsgBox(0, Format(_('The file "%s" could not be loaded because it is corrupted. ' +
                                   'You can delete it to avoid this error when streamWriter starts by clicking "Yes".'#13#10 +
                                   'WARNING: All data saved in the file will be lost!'#13#10 +
                                   'The file will not be overwritten with new data until it was loaded or deleted.'),
                                 [E.Message]),
                                 _('Info'), MB_YESNO or MB_ICONEXCLAMATION or MB_DEFBUTTON2);
    end;
end;

procedure TfrmStreamWriterMain.HomeCommError(Sender: TObject; ID: TCommErrors; Msg: string);
begin
  case ID of
    ceUnknown:
      MsgBox(Handle, Format(_('An error occured while communicating with the server: '#13#10'%s'), [Msg]), _('Error'), MB_ICONERROR);
    ceAuthRequired:
      begin
        if MsgBox(Handle, _('You need to be logged in to perform that action.'#13#10'Do you want to login now?'), _('Question'), MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1) = IDYES then
          ShowCommunityLogin;
      end;
    ceNotification:
      begin
        MsgBox(Handle, Format(_('A notification from the server was received:'#13#10'%s'), [Msg]), _('Info'), MB_ICONINFORMATION);
      end;
  end;
end;

procedure TfrmStreamWriterMain.HomeCommServerInfo(Sender: TObject;
  ClientCount, RecordingCount: Cardinal);
begin
  FClientCount := ClientCount;
  FRecordingCount := RecordingCount;
  SetConnected;
end;

procedure TfrmStreamWriterMain.HomeCommStateChanged(Sender: TObject);
begin
  UpdateStatus;
  tabClients.SideBar.BrowserView.HomeCommStateChanged(Sender);
  if FCommunityLogin <> nil then
    FCommunityLogin.HomeCommStateChanged(Sender);
end;

procedure TfrmStreamWriterMain.Hotkey(var Msg: TWMHotKey);
  procedure StopPlay;
  var
    i: Integer;
    Clients: TClientArray;
  begin
    Clients := tabClients.ClientView.NodesToClients(tabClients.ClientView.GetNodes(ntClient, False));
    for i := 0 to Length(Clients) - 1 do
      Clients[i].StopPlay;
  end;
var
  i: Integer;
  NextIsPlaying: Boolean;
  Nodes: TNodeArray;
  NodeData: PClientNodeData;
  Clients: TClientArray;
  PlayingClient: TICEClient;
  StartPlayClient: TICEClient;
begin
  NextIsPlaying := False;
  PlayingClient := nil;
  StartPlayClient := nil;

  case Msg.HotKey of
    0:
      begin
        //StopPlay;
        Nodes := tabClients.ClientView.GetNodes(ntClient, True);
        if Length(Nodes) > 0 then
        begin
          NodeData := tabClients.ClientView.GetNodeData(Nodes[0]);
          if not NodeData.Client.Playing then
            StopPlay;
          NodeData.Client.StartPlay;
        end else
        begin
          Nodes := tabClients.ClientView.GetNodes(ntClient, False);
          if Length(Nodes) > 0 then
          begin
            NodeData := tabClients.ClientView.GetNodeData(Nodes[0]);
            if not NodeData.Client.Playing then
              StopPlay;
            NodeData.Client.StartPlay;
          end;
        end;
        //actPlay.Execute;
      end;
    1:
      actPause.Execute;
    2:
      //StopPlay;
      actStopPlay.Execute;
    3:
      begin
        Clients := tabClients.ClientView.NodesToClients(tabClients.ClientView.GetNodes(ntClient, False));
        for i := 0 to Length(Clients) - 1 do
          if Clients[i].Playing then
            PlayingClient := Clients[i];
        if PlayingClient <> nil then
        begin
          for i := 0 to Length(Clients) - 1 do
          begin
            if NextIsPlaying then
            begin
              StartPlayClient := Clients[i];
              Break;
            end;
            if Clients[i].Playing then
              NextIsPlaying := True;
          end;

          if StartPlayClient = nil then
            if Length(Clients) > 0 then
              StartPlayClient := Clients[0];

          if StartPlayClient <> PlayingClient then
          begin
            StopPlay;
            StartPlayClient.StartPlay;
          end;
        end;
      end;
    4:
      begin
        Clients := tabClients.ClientView.NodesToClients(tabClients.ClientView.GetNodes(ntClient, False));
        for i := 0 to Length(Clients) - 1 do
          if Clients[i].Playing then
            PlayingClient := Clients[i];
        if PlayingClient <> nil then
        begin
          for i := Length(Clients) - 1 downto 0 do
          begin
            if NextIsPlaying then
            begin
              StartPlayClient := Clients[i];
              Break;
            end;
            if Clients[i].Playing then
              NextIsPlaying := True;
          end;

          if StartPlayClient = nil then
            if Length(Clients) > 0 then
              StartPlayClient := Clients[High(Clients)];

          if StartPlayClient <> PlayingClient then
          begin
            StopPlay;
            StartPlayClient.StartPlay;
          end;
        end;
      end;
  end;
end;

procedure TfrmStreamWriterMain.mnuCheckUpdateClick(Sender: TObject);
begin
  ShowUpdate;
end;

procedure TfrmStreamWriterMain.mnuShowClick(Sender: TObject);
begin
  ToggleWindow(False);
end;

procedure TfrmStreamWriterMain.OneInstanceMessage(var Msg: TMessage);
begin
  ToggleWindow(True);
end;

procedure TfrmStreamWriterMain.pagSidebarChange(Sender: TObject);
begin
  // Damit Child-Controls passende Dimensionen in ShowInfo haben
  Application.ProcessMessages;
end;

procedure TfrmStreamWriterMain.PreTranslate;
begin

end;

procedure TfrmStreamWriterMain.PostTranslate;
begin
  tabClients.SideBar.BrowserView.Translate;
  tabClients.SideBar.InfoView.Translate;
end;

procedure TfrmStreamWriterMain.mnuStreamPopupPopup(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfrmStreamWriterMain.mnuStreamSettingsToolbarPopup(
  Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfrmStreamWriterMain.QueryEndSession(var Msg: TMessage);
begin
  inherited;
  Msg.Result := 1;
end;

procedure ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(HotKey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
  Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
  Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
  Modifiers := Modifiers or MOD_CONTROL;
end;

procedure TfrmStreamWriterMain.RegisterHotkeys(Reg: Boolean);
var
  K: Word;
  M: Cardinal;
begin
  UnregisterHotKey(Handle, 0);
  UnregisterHotKey(Handle, 1);
  UnregisterHotKey(Handle, 2);
  UnregisterHotKey(Handle, 3);
  UnregisterHotKey(Handle, 4);

  if not Reg then
    Exit;

  if AppGlobals.ShortcutPlay > 0 then
  begin
    ShortCutToHotKey(AppGlobals.ShortcutPlay, K, M);
    RegisterHotKey(Handle, 0, M, K);
  end;

  if AppGlobals.ShortcutPause > 0 then
  begin
    ShortCutToHotKey(AppGlobals.ShortcutPause, K, M);
    RegisterHotKey(Handle, 1, M, K);
  end;

  if AppGlobals.ShortcutStop > 0 then
  begin
    ShortCutToHotKey(AppGlobals.ShortcutStop, K, M);
    RegisterHotKey(Handle, 2, M, K);
  end;

  if AppGlobals.ShortcutNext > 0 then
  begin
    ShortCutToHotKey(AppGlobals.ShortcutNext, K, M);
    RegisterHotKey(Handle, 3, M, K);
  end;

  if AppGlobals.ShortcutPrev > 0 then
  begin
    ShortCutToHotKey(AppGlobals.ShortcutPrev, K, M);
    RegisterHotKey(Handle, 4, M, K);
  end;
end;

procedure TfrmStreamWriterMain.EndSession(var Msg: TMessage);
begin
  if WordBool(Msg.WParam) then
  begin
    Msg.Result := 1;
    ExitApp(True);
  end;
end;

procedure TfrmStreamWriterMain.SetConnected;
begin
  if HomeComm.Connected then
  begin
    if FClientCount > 0 then
      addStatus.Panels[2].Text := IntToStr(FClientCount) + '/' + IntToStr(FRecordingCount)
    else
      addStatus.Panels[2].Text := '';
    addStatus.Panels[1].Text := _('Connected');

    SendMessage(addStatus.Handle, SB_SETICON, 0, IconConnected);
  end else
  begin
    addStatus.Panels[2].Text := '';
    addStatus.Panels[1].Text := _('Connecting...');
    SendMessage(addStatus.Handle, SB_SETICON, 0, IconDisconnected);
  end;

  if HomeComm.Authenticated then
    SendMessage(addStatus.Handle, SB_SETICON, 1, IconLoggedIn)
  else
    SendMessage(addStatus.Handle, SB_SETICON, 1, IconLoggedOff);

  SendMessage(addStatus.Handle, SB_SETICON, 2, IconGroup);
end;

procedure TfrmStreamWriterMain.ShowCommunityLogin;
begin
  if FCommunityLogin <> nil then
  begin
    FCommunityLogin.SetFocus;
    Exit;
  end;

  FCommunityLogin := TfrmCommunityLogin.Create(Self);
  FCommunityLogin.OnClose := CommunityLoginClose;
  FCommunityLogin.Show;
end;

procedure TfrmStreamWriterMain.ShowSettings(BrowseDir: Boolean);
var
  S: TfrmSettings;
begin
  RegisterHotkeys(False);
  S := TfrmSettings.Create(Self, BrowseDir);
  try
    S.ShowModal;
  finally
    S.Free;
  end;

  Language.Translate(Self, PreTranslate, PostTranslate);
  AppGlobals.PluginManager.ReInitPlugins;
  TrayIcon1.Visible := AppGlobals.Tray;
  RegisterHotkeys(True);
end;

procedure TfrmStreamWriterMain.ShowUpdate(Version: string = '';
  UpdateURL: string = '');
var
  S: TfrmUpdate;
begin
  S := TfrmUpdate.Create(Self, Version, UpdateURL);
  S.ShowModal;
  if (S.Updated) and (S.Exit) then
  begin
    S.Free;
    if CanExitApp then
    begin
      FUpdateOnExit := True;
      ExitApp(False);
    end;
  end else if S.Updated then
  begin
    AppGlobals.InstallUpdateOnStart := True;
    mnuCheckUpdate.Enabled := False;
    S.Free;
  end;
end;

procedure TfrmStreamWriterMain.SysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
  begin
    FWasMaximized := WindowState = wsMaximized;

    if (AppGlobals.Tray) and (AppGlobals.TrayOnMinimize) then
    begin
      TrayIcon1.Visible := True;
      Hide;
      Exit;
    end;
  end;
  DefaultHandler(Msg);
end;

procedure TfrmStreamWriterMain.tabClientsCut(Entry: TStreamEntry;
  Track: TTrackInfo);
var
  tabCut: TCutTab;
begin
  if (LowerCase(ExtractFileExt(Track.Filename)) <> '.mp3') and (LowerCase(ExtractFileExt(Track.Filename)) <> '.aac') then
  begin
    Exit;
  end;

  tabCut := TCutTab(pagMain.FindCut(Track.Filename));
  if tabCut = nil then
  begin
    tabCut := TCutTab.Create(pagMain);
    tabCut.PageControl := pagMain;
    tabCut.OnSaved := tabCutSaved;

    pagMain.ActivePage := tabCut;

    tabCut.Setup(Track.Filename, imgImages);
  end else
  begin
    pagMain.ActivePageIndex := tabCut.PageIndex;
  end;
end;

procedure TfrmStreamWriterMain.tabSavedRefresh(Sender: TObject);
var
  i: Integer;
  Files: TList;
begin
  if FCheckFiles <> nil then
    Exit;

  Files := TList.Create;
  try
    for i := 0 to FStreams.TrackList.Count - 1 do
      Files.Add(TFileEntry.Create(FStreams.TrackList[i].Filename, FStreams.TrackList[i].Filesize, eaNone));
    FCheckFiles := TCheckFilesThread.Create(Files);
    FCheckFiles.OnTerminate := CheckFilesTerminate;
    FCheckFiles.Resume;
  finally
    // Wird vom Thread erledigt. Unsch�n, aber...
    // Files.Free;
  end;
end;

procedure TfrmStreamWriterMain.tabClientsTrackAdded(Entry: TStreamEntry;
  Track: TTrackInfo);
begin
  tabSaved.AddTrack(Entry, Track);
end;

procedure TfrmStreamWriterMain.tabClientsTrackRemoved(Entry: TStreamEntry;
  Track: TTrackInfo);
begin
  tabSaved.RemoveTrack(Track);
end;

procedure TfrmStreamWriterMain.tabClientsAddIgnoreList(Sender: TObject;
  Data: string);
var
  Ignore: TTitleInfo;
begin
  Ignore := TTitleInfo.Create(Data);
  FStreams.IgnoreList.Add(Ignore);
  tabLists.AddIgnore(Ignore);
end;

procedure TfrmStreamWriterMain.tabClientsUpdateButtons(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfrmStreamWriterMain.tabSavedTrackRemoved(Entry: TStreamEntry; Track: TTrackInfo);
begin

end;

procedure TfrmStreamWriterMain.tabCutSaved(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FStreams.TrackList.Count - 1 do
    if LowerCase(FStreams.TrackList[i].Filename) = LowerCase(TCutTab(Sender).Filename) then
    begin
      FStreams.TrackList[i].Filesize := GetFileSize(FStreams.TrackList[i].Filename);
      FStreams.TrackList[i].WasCut := True;
      Exit;
    end;
end;

procedure TfrmStreamWriterMain.tmrRecordingsTimer(Sender: TObject);
var
  i: Integer;
  C: Cardinal;
begin
  C := 0;
  for i := 0 to FClients.Count - 1 do
    if FClients[i].Recording and not FClients[i].AutoRemove then
      Inc(C);
  if AppGlobals.SubmitStats then
    HomeComm.UpdateStats(C);
end;

procedure TfrmStreamWriterMain.tmrSpeedTimer(Sender: TObject);
var
  Active: Boolean;
  i: Integer;
begin
  UpdateStatus;

  tabClients.TimerTick;

  Active := False;
  for i := 0 to FClients.Count - 1 do
    if FClients[i].Recording then
    begin
      Active := True;
      Break;
    end;

  if Active and not DiskSpaceOkay(AppGlobals.Dir, AppGlobals.MinDiskSpace) then
  begin
    for i := 0 to FClients.Count - 1 do
      FClients[i].StopRecording;
    tmrSpeed.Enabled := False;
    MsgBox(Handle, _('Available disk space is below the set limit, so recording will be stopped.'), _('Info'), MB_ICONINFORMATION);
    tmrSpeed.Enabled := True;
  end;
end;

procedure TfrmStreamWriterMain.ToggleWindow(AlwaysShow: Boolean);
begin
  if IsIconic(Handle) then
  begin
    if not Visible then
      Show;
    OpenIcon(Handle);

    if FWasMaximized then
      WindowState := wsMaximized;

    SetForegroundWindow(Handle);
  end else
  begin
    if not Visible then
    begin
      Show;
      SetForegroundWindow(Handle);
    end else
    begin
      if not AlwaysShow then
      begin
        FWasMaximized := WindowState = wsMaximized;
        CloseWindow(Handle);
        Hide;
      end else
        SetForegroundWindow(Handle);
    end;
  end;
end;

procedure TfrmStreamWriterMain.UpdateButtons;
var
  i: Integer;
  B, B4, OnlyAutomatedSelected, OnlyAutomatedCatsSelected: Boolean;
  URLFound, FilenameFound, OnePlaying: Boolean;
  Clients, AllClients: TClientArray;
  Client: TICEClient;
  CatNodes: TNodeArray;
begin
  // Enabled und so wird hier immer nur gesetzt, wenn sich der Status ge�ndert hat.
  // Das hilft gut gegen flackern, wenn das Popup aufgeklappt ist, w�hrend das hier
  // aufgerufen wird.

  Clients := tabClients.ClientView.NodesToClients(tabClients.ClientView.GetNodes(ntClient, True));
  AllClients := tabClients.ClientView.NodesToClients(tabClients.ClientView.GetNodes(ntClient, False));
  CatNodes := tabClients.ClientView.GetNodes(ntCategory, True);

  FilenameFound := False;
  OnlyAutomatedSelected := True;
  OnePlaying := False;
  OnlyAutomatedCatsSelected := Length(Clients) = 0;
  for Client in Clients do
  begin
    if not Client.AutoRemove then
      OnlyAutomatedSelected := False;
    if Client.Filename <> '' then
      FilenameFound := True;
    if Client.Playing then
      OnePlaying := True;
  end;
  for i := 0 to Length(CatNodes) - 1 do
    if not PClientNodeData(tabClients.ClientView.GetNodeData(CatNodes[i])).Category.IsAuto then
    begin
      OnlyAutomatedSelected := False;
      if Length(Clients) = 0 then
        OnlyAutomatedCatsSelected := False;
    end;

  B := Length(Clients) > 0;
  if actStart.Enabled <> B and not OnlyAutomatedSelected then
    actStart.Enabled := B and not OnlyAutomatedSelected;
  if actStop.Enabled <> B and not OnlyAutomatedSelected then
    actStop.Enabled := B and not OnlyAutomatedSelected;
  mnuStartStreaming1.Default := False;
  mnuStopStreaming1.Default := False;

  if actRemove.Enabled <> (B or (Length(CatNodes) > 0)) and not OnlyAutomatedCatsSelected then
    actRemove.Enabled := (B or (Length(CatNodes) > 0)) and not OnlyAutomatedCatsSelected;

  if actStreamSettings.Enabled <> ((Length(Clients) > 0) and not OnlyAutomatedSelected) then
    actStreamSettings.Enabled := (Length(Clients) > 0) and not OnlyAutomatedSelected;

  URLFound := False;
  if Length(Clients) = 1 then
    if Trim(Clients[0].Entry.StreamURL) <> '' then
      URLFound := True;
  if actOpenWebsite.Enabled <> URLFound then
    actOpenWebsite.Enabled := URLFound;

  if mnuTuneIn1.Enabled <> B then
    mnuTuneIn1.Enabled := B;
  if mnuTuneIn2.Enabled <> B then
    mnuTuneIn2.Enabled := B;
  if mnuSavePlaylist1.Enabled <> B then
    mnuSavePlaylist1.Enabled := B;
  if mnuSavePlaylist2.Enabled <> B then
    mnuSavePlaylist2.Enabled := B;

  if actResetData.Enabled <> B then
    actResetData.Enabled := B;
  if actTuneInFile.Enabled <> FilenameFound then
    actTuneInFile.Enabled := FilenameFound;

  if actStopPlay.Enabled <> OnePlaying then
    actStopPlay.Enabled := OnePlaying;
  if actPause.Enabled <> OnePlaying then
    actPause.Enabled := OnePlaying;

  if actPlay.Enabled <> (Length(Clients) = 1) then
    actPlay.Enabled := Length(Clients) = 1;

  {
  if Length(Clients) = 1 then
  begin
    Client := Clients[0];
    case AppGlobals.DefaultAction of
      caStartStop:
        if Client.Recording then
          if not mnuStopStreaming1.Default then
            mnuStopStreaming1.Default := True
        else
          if not mnuStartStreaming1.Default then
            mnuStartStreaming1.Default := True;
      caStreamIntegrated:
        if Client.Playing then
          if not mnuStopPlay1.Default then
            mnuStopPlay1.Default := True
        else
          if not mnuStartPlay1.Default then
            mnuStartPlay1.Default := True;
      caStream:
        if not mnuListenToStream1.Default then
          mnuListenToStream1.Default := True;
      caFile:
        if not mnuListenToFile1.Default then
          mnuListenToFile1.Default := True;
    end;
  end;
  }
end;

procedure TfrmStreamWriterMain.UpdaterNoUpdateFound(Sender: TObject);
begin
  AppGlobals.LastUpdateChecked := Trunc(Now);
end;

procedure TfrmStreamWriterMain.UpdaterUpdateFound(Sender: TObject);
var
  Res: Integer;
begin
  AppGlobals.LastUpdateChecked := Trunc(Now);
  Res := MsgBox(Handle, _('A new version was found.'#13#10'Do you want to download the update now?'), _('Question'), MB_ICONQUESTION or MB_YESNO);
  if Res = IDYES then
  begin
    if AppGlobals.RunningFromInstalledLocation then
      ShowUpdate(FUpdater.FoundVersion.AsString, FUpdater.UpdateURL)
    else
      ShellExecute(Handle, 'open', PChar(AppGlobals.ProjectLink), nil, nil, 1);
  end;
end;

procedure TfrmStreamWriterMain.UpdateStatus;
var
  Clients: TNodeDataArray;
  Client: PClientNodeData;
  Speed: UInt64;
begin
  Speed := 0;
  Clients := tabClients.ClientView.NodesToData(tabClients.ClientView.GetNodes(ntClient, False));
  for Client in Clients do
  begin
    Speed := Speed + Client.Client.Speed;
    tabClients.ClientView.RefreshClient(Client.Client);
  end;

  SetConnected;

  addStatus.Panels[3].Text := MakeSize(Speed) + '/s';
  addStatus.Panels[4].Text := Format(_('%s/%s received'), [MakeSize(tabClients.Received), MakeSize(FStreams.Received)]);
  addStatus.Panels[5].Text := Format(_('%d songs saved'), [FClients.SongsSaved]);
end;

function TfrmStreamWriterMain.CanExitApp: Boolean;
var
  Clients: TNodeDataArray;
  Client: PClientNodeData;
  Rec: Boolean;
begin
  Result := True;
  Rec := False;

  Clients := tabClients.ClientView.NodesToData(tabClients.ClientView.GetNodes(ntClient, False));

  for Client in Clients do
    if Client.Client.Recording then
    begin
      Rec := True;
      Break;
    end;

  if Rec then
  begin
    if TfrmMsgDlg.ShowMsg(Self, _('You are recording at least one stream at the moment. Exiting the application will abort streaming.'#13#10'Do you really want to quit?'), 1, btOKCancel) = mtCancel then
    begin
      Result := False;
    end;
  end;
end;

procedure TfrmStreamWriterMain.CheckFilesTerminate(Sender: TObject);
var
  i, n: Integer;
  Track: TTrackInfo;
  E: TFileEntry;
begin
  for i := 0 to FCheckFiles.Files.Count - 1 do
  begin
    E := TFileEntry(FCheckFiles.Files[i]);

    if E.Action = eaNone then
      Continue;

    for n := 0 to FStreams.TrackList.Count - 1 do
      if FStreams.TrackList[n].Filename = E.Filename then
      begin
        Track := FStreams.TrackList[n];
        case E.Action of
          eaNone: ;
          eaSize:
            Track.Filesize := E.Size;
          eaRemove:
            begin
              FStreams.TrackList.Delete(n);
              tabSaved.RemoveTrack(Track);
              Track.Free;
            end;
        end;
        Break;
      end;
  end;

  FCheckFiles := nil;
end;

procedure TfrmStreamWriterMain.Community1Click(Sender: TObject);
begin
 actLogOn.Enabled := not HomeComm.Authenticated and HomeComm.Connected;
 actLogOff.Enabled := HomeComm.Authenticated and HomeComm.Connected;
end;

procedure TfrmStreamWriterMain.CommunityLoginClose(Sender: TObject; var Action: TCloseAction);
begin
  FCommunityLogin := nil;
end;

{ TStatusHint }

constructor TStatusHint.Create(AOwner: TComponent);
begin
  inherited;

  Delay := 500;
end;

procedure TStatusHint.PaintHint(HintWindow: TCustomHintWindow);
begin

  inherited;
end;

procedure TStatusHint.SetHintSize(HintWindow: TCustomHintWindow);
var
  Pos: TPoint;
  R: TRect;
begin
  inherited;

  Pos := Mouse.CursorPos;
  Pos := TfrmStreamWriterMain(Owner).addStatus.ScreenToClient(Pos);
  TfrmStreamWriterMain(Owner).addStatus.Perform(SB_GETRECT, 2, Integer(@R));
  R.Top := 0;

  if not PtInRect(R, Pos) then
  begin
    HintWindow.Width := 0;
    HintWindow.Height := 0;
  end;
end;

end.
