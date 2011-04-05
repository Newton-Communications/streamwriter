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
unit ClientTab;

interface

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  MControls, ClientView, StreamBrowserView, StreamDebugView, StreamInfoView,
  LanguageObjects, HomeCommunication, StationCombo, Menus, ActnList, ImgList,
  DataManager, ICEClient, ClientManager, VirtualTrees, Clipbrd, Functions,
  GUIFunctions, AppData, DragDrop, DropTarget, DropComboTarget, ShellAPI, Tabs,
  Graphics, SharedControls, Generics.Collections, Generics.Defaults;

type
  TSidebar = class(TPageControl)
  private
    FPage1, FPage2, FPage3: TTabSheet;

    FBrowserView: TMStreamBrowserView;
    FInfoView: TMStreamInfoView;
    FDebugView: TMStreamDebugView;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init;

    property BrowserView: TMStreamBrowserView read FBrowserView;
    property InfoView: TMStreamInfoView read FInfoView;
    property DebugView: TMStreamDebugView read FDebugView;
  end;

  TClientAddressBar = class(TPanel)
  private
    FLabel: TLabel;
    FStations: TMStationCombo;
    FStart: TSpeedButton;
    FDropTarget: TDropComboTarget;

    FOnStart: TNotifyEvent;

    procedure FStationsChange(Sender: TObject);
    procedure FStationsKeyPress(Sender: TObject; var Key: Char);
    procedure FStartClick(Sender: TObject);

    procedure DropTargetDrop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Setup;

    property Stations: TMStationCombo read FStations;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
  end;

  TClientTab = class(TMainTabSheet)
  private
    FToolbarPanel: TPanel;
    FVolume: TVolumePanel;
    FToolbar: TToolBar;
    FAddressBar: TClientAddressBar;
    FClientView: TMClientView;
    FSplitter: TSplitter;
    FSideBar: TSideBar;

    FClients: TClientManager;
    FStreams: TDataLists;
    FHomeCommunication: THomeCommunication;

    FReceived: UInt64;
    FRefreshInfo: Boolean;

    FActionRemove: TAction;
    FActionShowSideBar: TAction;
    FActionPlay: TAction;
    FActionPause: TAction;
    FActionStopPlay: TAction;
    FActionTuneInFile: TAction;
    FActionTuneInStream: TAction;

    FOnUpdateButtons: TNotifyEvent;
    FOnCut: TTrackEvent;
    FOnTrackAdded: TTrackEvent;
    FOnTrackRemoved: TTrackEvent;
    FOnAddIgnoreList: TStringEvent;
    //FOnSetVolume: TIntegerEvent;
    FOnVolumeChanged: TSeekChangeEvent;

    procedure ShowInfo;

    procedure ActionNewCategoryExecute(Sender: TObject);
    procedure ActionStartExecute(Sender: TObject);
    procedure ActionStopExecute(Sender: TObject);
    procedure ActionOpenWebsiteExecute(Sender: TObject);
    procedure ActionRemoveExecute(Sender: TObject);
    procedure ActionPlayExecute(Sender: TObject);
    procedure ActionPauseExecute(Sender: TObject);
    procedure ActionPlayStopExecute(Sender: TObject);
    procedure ActionResetDataExecute(Sender: TObject);
    procedure ActionShowSideBarExecute(Sender: TObject);
    procedure ActionSavePlaylistStreamExecute(Sender: TObject);
    procedure ActionSavePlaylistFileExecute(Sender: TObject);
    procedure ActionTuneInStreamExecute(Sender: TObject);
    procedure ActionTuneInFileExecute(Sender: TObject);

    procedure ClientManagerDebug(Sender: TObject);
    procedure ClientManagerRefresh(Sender: TObject);
    procedure ClientManagerAddRecent(Sender: TObject);
    procedure ClientManagerClientAdded(Sender: TObject);
    procedure ClientManagerClientRemoved(Sender: TObject);
    procedure ClientManagerSongSaved(Sender: TObject; Filename, Title: string; Filesize: UInt64; WasCut: Boolean);
    procedure ClientManagerTitleChanged(Sender: TObject; Title: string);
    procedure ClientManagerICYReceived(Sender: TObject; Received: Integer);
    procedure ClientManagerTitleAllowed(Sender: TObject; Title: string;
      var Allowed: Boolean; var Match: string; var Filter: Integer);

    procedure FClientViewChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FClientViewDblClick(Sender: TObject);
    procedure FClientViewKeyPress(Sender: TObject; var Key: Char);
    procedure FClientViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FClientViewStartStreaming(Sender: TObject; URL: string; Node: PVirtualNode; Mode: TVTNodeAttachMode);

    procedure StreamBrowserAction(Sender: TObject; Action: TOpenActions; Streams: TStreamDataArray);

    procedure VolumeTrackbarChange(Sender: TObject);

    procedure AddressBarStart(Sender: TObject);

    procedure DebugClear(Sender: TObject);

    procedure FSetVolume(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Setup(Toolbar: TToolbar; Actions: TActionList; Popup: TPopupMenu; MenuImages,
      ClientImages: TImageList; Clients: TClientManager;
      Streams: TDataLists);
    procedure Shown;
    function StartStreaming(Name, URL: string; StartPlay: Boolean;
      HitNode: PVirtualNode; Mode: TVTNodeAttachMode): Boolean;
    procedure TimerTick;
    procedure UpdateStreams(Streams: TDataLists);
    procedure BuildTree(Streams: TDataLists);

    property AddressBar: TClientAddressBar read FAddressBar;
    property ClientView: TMClientView read FClientView;
    property SideBar: TSideBar read FSideBar;
    property Received: UInt64 read FReceived;
    property Volume: Integer write FSetVolume;

    property OnUpdateButtons: TNotifyEvent read FOnUpdateButtons write FOnUpdateButtons;
    property OnCut: TTrackEvent read FOnCut write FOnCut;
    property OnTrackAdded: TTrackEvent read FOnTrackAdded write FOnTrackAdded;
    property OnTrackRemoved: TTrackEvent read FOnTrackRemoved write FOnTrackRemoved;
    property OnAddIgnoreList: TStringEvent read FOnAddIgnoreList write FOnAddIgnoreList;
    property OnVolumeChanged: TSeekChangeEvent read FOnVolumeChanged write FOnVolumeChanged;
    //property OnSetVolume: TIntegerEvent read FOnSetVolume write FOnSetVolume;
  end;

implementation

{ TClientAddressBar }

constructor TClientAddressBar.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TClientAddressBar.Destroy;
begin

  inherited;
end;

procedure TClientAddressBar.DropTargetDrop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
begin
  FStations.ItemIndex := -1;
  if FDropTarget.URL <> '' then
    FStations.Text := string(FDropTarget.URL);
  if FDropTarget.Text <> '' then
    FStations.Text := string(FDropTarget.Text);
  if FDropTarget.Files.Count > 0 then
    FStations.Text := string(FDropTarget.Files[0]);
end;

procedure TClientAddressBar.Setup;
begin
  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Left := 4;
  FLabel.Top := 6;
  FLabel.Caption := _('Playlist/Stream-URL:');

  FStart := TSpeedButton.Create(Self);
  FStart.Parent := Self;
  FStart.Width := 24;
  FStart.Height := 24;
  FStart.Top := 6;
  FStart.Left := ClientWidth - 4 - FStart.Width;
  FStart.Anchors := [akRight];
  FStart.Flat := True;
  FStart.Hint := _('Add and start recording');
  FStart.ShowHint := True;
  FStart.NumGlyphs := 2;
  FStart.OnClick := FStartClick;

  GetBitmap('ADD', 2, FStart.Glyph);

  FStations := TMStationCombo.Create(Self);
  FStations.Parent := Self;
  FStations.DropDownCount := 15;
  FStations.Left := FLabel.Left + FLabel.Width + 8;

  FStations.Top := 2;
  FStations.Width := ClientWidth - FStations.Left - FStart.Width - 8;
  FStations.Anchors := [akLeft, akTop, akRight];
  FStations.OnKeyPress := FStationsKeyPress;
  FStations.OnChange := FStationsChange;
  Height := FStations.Top + FStations.Height + FStations.Top;

  FDropTarget := TDropComboTarget.Create(Self);
  FDropTarget.Formats := [mfText, mfURL, mfFile];
  FDropTarget.Register(FStations);
  FDropTarget.OnDrop := DropTargetDrop;

  BevelOuter := bvNone;

  FStationsChange(FStations);
end;

procedure TClientAddressBar.FStationsChange(Sender: TObject);
begin
  FStart.Enabled := (Length(Trim(FStations.Text)) > 0) or (FStations.ItemIndex > -1);
end;

procedure TClientAddressBar.FStationsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FStart.Click;
  end else
  begin
    FStations.ItemIndex := -1;
  end;
end;

procedure TClientAddressBar.FStartClick(Sender: TObject);
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

{ TClientTab }

procedure TClientTab.ActionNewCategoryExecute(Sender: TObject);
var
  NodeData: PClientNodeData;
begin
  NodeData := FClientView.GetNodeData(FClientView.AddCategory);
  FStreams.CategoryList.Add(NodeData.Category);
end;

procedure TClientTab.ActionStartExecute(Sender: TObject);
var
  Clients: TClientArray;
  Client: TICEClient;
begin
  if not DiskSpaceOkay(AppGlobals.Dir, AppGlobals.MinDiskSpace) then
  begin
    MsgBox(Handle, _('Available disk space is below the set limit, so recording will not start.'), _('Info'), MB_ICONINFORMATION);
    Exit;
  end;

  Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, True));
  for Client in Clients do
  begin
    if not Client.AutoRemove then
      Client.StartRecording;
  end;
end;

procedure TClientTab.ActionStopExecute(Sender: TObject);
var
  Clients: TClientArray;
  Client: TICEClient;
begin
  Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, True));
  for Client in Clients do
  begin
    if not Client.AutoRemove then
      Client.StopRecording;
  end;
end;

procedure TClientTab.ActionRemoveExecute(Sender: TObject);
var
  Node, ChildNode: PVirtualNode;
  Nodes, ChildNodes: TNodeArray;
  NodeData, ChildNodeData: PClientNodeData;
begin
  Nodes := FClientView.GetNodes(ntClient, True);
  for Node in Nodes do
  begin
    NodeData := FClientView.GetNodeData(Node);
    if NodeData.Client <> nil then
      FClients.RemoveClient(NodeData.Client);
  end;

  Nodes := FClientView.GetNodes(ntCategory, True);
  for Node in Nodes do
  begin
    NodeData := FClientView.GetNodeData(Node);
    if NodeData.Category <> nil then
      if not NodeData.Category.IsAuto then
      begin
        ChildNodes := FClientView.GetNodes(ntAll, False);
        for ChildNode in ChildNodes do
        begin
          if ChildNode.Parent = Node then
          begin
            ChildNodeData := FClientView.GetNodeData(ChildNode);
            FClients.RemoveClient(ChildNodeData.Client);
          end;
        end;
      end;
  end;

  // Wenn alle Clients weg sind k�nnen jetzt Kategorien gekickt werden.
  Nodes := FClientView.GetNodes(ntCategory, True);
  for Node in Nodes do
  begin
    NodeData := FClientView.GetNodeData(Node);
    if NodeData.Category.IsAuto then
      Continue;
    if FClientView.ChildCount[Node] = 0 then
    begin
      FStreams.CategoryList.Remove(NodeData.Category);
      NodeData.Category.Free;
      FClientView.DeleteNode(Node);
    end else
    begin
      NodeData.Category.Killed := True;
    end;
  end;
end;

procedure TClientTab.ActionPlayExecute(Sender: TObject);
var
  Clients: TNodeDataArray;
  SelectedClient, Client: PClientNodeData;
begin
  Clients := FClientView.NodesToData(FClientView.GetNodes(ntClient, True));
  if Length(Clients) <> 1 then
    Exit
  else
    SelectedClient := Clients[0];

  Clients := FClientView.NodesToData(FClientView.GetNodes(ntClient, False));
  for Client in Clients do
    if Client <> SelectedClient then
      Client.Client.StopPlay;

  SelectedClient.Client.StartPlay;
end;

procedure TClientTab.ActionPauseExecute(Sender: TObject);
var
  Clients: TClientArray;
  Client: TICEClient;
begin
  Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, False));
  for Client in Clients do
  begin
    Client.PausePlay;
  end;
end;

procedure TClientTab.ActionPlayStopExecute(Sender: TObject);
var
  Clients: TClientArray;
  Client: TICEClient;
begin
  Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, False));
  for Client in Clients do
  begin
    Client.StopPlay;
  end;
end;

procedure TClientTab.ActionOpenWebsiteExecute(Sender: TObject);
var
  Clients: TClientArray;
begin
  Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, True));
  if Length(Clients) = 1 then
  begin
    ShellExecute(Handle, 'open', PChar(Clients[0].Entry.StreamURL), '', '', 1);
  end;
end;

procedure TClientTab.ActionResetDataExecute(Sender: TObject);
var
  Res: Integer;
  Clients: TNodeDataArray;
  Client: PClientNodeData;
begin
  Res := MsgBox(Handle, _('This will reset the saved song and bytes received counters.'#13#10 +
                          'The tracknumber of new saved titles will be 1 if you specified the tracknumber in the filename pattern, this number will also be set in ID3 tags.'#13#10 +
                          'Do you want to continue?'), _('Question'), MB_ICONQUESTION or MB_YESNO);
  if Res = IDYES then
  begin
    Clients := FClientView.NodesToData(FClientView.GetNodes(ntClient, True));
    for Client in Clients do
    begin
      if Client.Client.AutoRemove then
        Continue;
      Client.Client.Entry.SongsSaved := 0;
      Client.Client.Entry.BytesReceived := 0;

      FClientView.RefreshClient(Client.Client);
    end;
  end;
  ShowInfo;
end;

procedure TClientTab.ActionShowSideBarExecute(Sender: TObject);
begin
  FSideBar.Visible := not FSideBar.Visible;
  FSplitter.Visible := not FSplitter.Visible;
  FActionShowSideBar.Checked := FSideBar.Visible;
end;

procedure TClientTab.ActionSavePlaylistStreamExecute(Sender: TObject);
var
  Entries: TPlaylistEntryArray;
begin
  Entries := FClientView.GetEntries(etStream);
  SavePlaylist(Entries, False);
end;

procedure TClientTab.ActionSavePlaylistFileExecute(Sender: TObject);
var
  Entries: TPlaylistEntryArray;
begin
  Entries := FClientView.GetEntries(etFile);
  SavePlaylist(Entries, False);
end;

procedure TClientTab.ActionTuneInStreamExecute(Sender: TObject);
var
  Entries: TPlaylistEntryArray;
begin
  Entries := FClientView.GetEntries(etStream);
  SavePlaylist(Entries, True);
end;

procedure TClientTab.ActionTuneInFileExecute(Sender: TObject);
var
  Entries: TPlaylistEntryArray;
begin
  if FActionTuneInFile.Enabled then
  begin
    Entries := FClientView.GetEntries(etFile);
    SavePlaylist(Entries, True);
  end;
end;

constructor TClientTab.Create(AOwner: TComponent);
begin
  inherited;

  ShowCloseButton := False;
  ImageIndex := 16;
end;

procedure TClientTab.AddressBarStart(Sender: TObject);
var
  Entry: TRecentEntry;
begin
  if FAddressBar.FStations.ItemIndex = -1 then
    StartStreaming('', FAddressBar.FStations.Text, False, nil, amNoWhere)
  else
  begin
    Entry := TRecentEntry(FAddressBar.FStations.ItemsEx[FAddressBar.FStations.ItemIndex].Data);
    StartStreaming(Entry.Name, Entry.StartURL, False, nil, amNoWhere);
  end;
end;

procedure TClientTab.DebugClear(Sender: TObject);
var
  Clients: TNodeDataArray;
  i: Integer;
begin
  Clients := FClientView.NodesToData(FClientView.GetNodes(ntClient, False));
  for i := 0 to Length(Clients) - 1 do
    if Clients[i].Client = FSideBar.FDebugView.DebugView.Client then
    begin
      Clients[i].Client.DebugLog.Clear;
      Break;
    end;
end;

destructor TClientTab.Destroy;
begin

  inherited;
end;

procedure TClientTab.Setup(Toolbar: TToolbar; Actions: TActionList;
  Popup: TPopupMenu; MenuImages,
  ClientImages: TImageList; Clients: TClientManager; Streams: TDataLists);
  function GetAction(Name: string): TAction;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to Actions.ActionCount - 1 do
      if Actions[i].Name = Name then
      begin
        Result := Actions[i] as TAction;
        Break;
      end;
    if Result = nil then
      raise Exception.Create('');
  end;
begin
  FRefreshInfo := False;
  FReceived := 0;

  FClients := Clients;
  FClients.OnClientDebug := ClientManagerDebug;
  FClients.OnClientRefresh := ClientManagerRefresh;
  FClients.OnClientAddRecent := ClientManagerAddRecent;
  FClients.OnClientAdded := ClientManagerClientAdded;
  FClients.OnClientRemoved := ClientManagerClientRemoved;
  FClients.OnClientSongSaved := ClientManagerSongSaved;
  FClients.OnClientTitleChanged := ClientManagerTitleChanged;
  FClients.OnClientICYReceived := ClientManagerICYReceived;
  FClients.OnClientTitleAllowed := ClientManagerTitleAllowed;

  FStreams := Streams;

  FHomeCommunication := HomeComm;

  Caption := _('Streams');

  FAddressBar := TClientAddressBar.Create(Self);
  FAddressBar.Parent := Self;
  FAddressBar.Align := alTop;
  FAddressBar.Visible := True;
  FAddressBar.Setup;
  FAddressBar.OnStart := AddressBarStart;

  FToolbarPanel := TPanel.Create(Self);
  FToolbarPanel.Align := alTop;
  FToolbarPanel.BevelOuter := bvNone;
  FToolbarPanel.Parent := Self;
  FToolbarPanel.ClientHeight := 24;

  FToolbar := Toolbar;
  FToolbar.Align := alLeft;
  FToolbar.Width := FToolbarPanel.ClientWidth - 130;
  FToolbar.Height := 24;
  FToolbar.Parent := FToolbarPanel;

  FVolume := TVolumePanel.Create(Self);
  FVolume.Parent := FToolbarPanel;
  FVolume.Align := alRight;
  FVolume.Setup;
  FVolume.Width := 140;
  FVolume.Volume := AppGlobals.PlayerVolume;
  FVolume.OnVolumeChange := VolumeTrackbarChange;

  FActionPlay := GetAction('actPlay');
  FActionPause := GetAction('actPause');
  FActionStopPlay := GetAction('actStopPlay');
  FActionTuneInStream := GetAction('actTuneInStream');
  FActionTuneInFile := GetAction('actTuneInFile');
  FActionRemove := GetAction('actRemove');
  FActionShowSideBar := GetAction('actShowSideBar');

  FActionPlay.OnExecute := ActionPlayExecute;
  FActionPause.OnExecute := ActionPauseExecute;
  FActionStopPlay.OnExecute := ActionPlayStopExecute;
  FActionTuneInStream.OnExecute := ActionTuneInStreamExecute;
  FActionTuneInFile.OnExecute := ActionTuneInFileExecute;
  FActionRemove.OnExecute := ActionRemoveExecute;
  FActionShowSideBar.OnExecute := ActionShowSideBarExecute;

  GetAction('actNewCategory').OnExecute := ActionNewCategoryExecute;
  GetAction('actStart').OnExecute := ActionStartExecute;
  GetAction('actStop').OnExecute := ActionStopExecute;
  GetAction('actOpenWebsite').OnExecute := ActionOpenWebsiteExecute;
  GetAction('actResetData').OnExecute := ActionResetDataExecute;
  GetAction('actSavePlaylistStream').OnExecute := ActionSavePlaylistStreamExecute;
  GetAction('actSavePlaylistFile').OnExecute := ActionSavePlaylistFileExecute;

  FClientView := TMClientView.Create(Self, Popup);
  FClientView.Parent := Self;
  FClientView.Align := alClient;
  FClientView.Visible := True;
  FClientView.PopupMenu := Popup;
  FClientView.Images := ClientImages;
  FClientView.OnChange := FClientViewChange;
  FClientView.OnDblClick := FClientViewDblClick;
  FClientView.OnKeyPress := FClientViewKeyPress;
  FClientView.OnKeyDown := FClientViewKeyDown;
  FClientView.OnStartStreaming := FClientViewStartStreaming;
  FClientView.Show;

  FSplitter := TSplitter.Create(Self);
  FSplitter.Parent := Self;
  FSplitter.Align := alRight;
  FSplitter.Visible := True;
  FSplitter.Width := 4;
  FSplitter.MinSize := 220;
  FSplitter.AutoSnap := False;
  FSplitter.ResizeStyle := rsUpdate;

  FSideBar := TSidebar.Create(Self);
  FSideBar.Parent := Self;
  FSideBar.Align := alRight;
  FSideBar.Visible := True;
  FSideBar.Init;

  FSideBar.FDebugView.DebugView.OnClear := DebugClear;
  FSideBar.FBrowserView.StreamTree.OnAction := StreamBrowserAction;
  FSideBar.FBrowserView.StreamTree.PopupMenu2.Images := MenuImages;
  //FSideBar.FInfoView.InfoView.Tree.OnAction := StreamInfoAction;

  FSplitter.Left := FSideBar.Left - 5;

  FSideBar.Visible := AppGlobals.ShowSidebar;
  FSplitter.Visible := AppGlobals.ShowSidebar;
  FSideBar.Width := AppGlobals.SidebarWidth;
end;

procedure TClientTab.ShowInfo;
var
  Clients: TNodeDataArray;
  Client: PClientNodeData;
  Entries: TStreamList;
begin
  Clients := FClientView.NodesToData(FClientView.GetNodes(ntClient, True));

  Entries := TStreamList.Create;
  try
    for Client in Clients do
      Entries.Add(Client.Client.Entry);

    if Entries.Count > 0 then
      FSideBar.InfoView.ShowInfo(Entries)
    else
      FSideBar.InfoView.ShowInfo(nil);
  finally
    Entries.Free;
  end;
end;

procedure TClientTab.Shown;
var
  i: Integer;
begin
  FSideBar.FBrowserView.Setup;

  if FClientView.RootNodeCount > 0 then
  begin
    FClientView.Selected[FClientView.GetFirst] := True;
    FClientView.FocusedNode := FClientView.GetFirst;
  end;

  for i := 0 to FClientView.Header.Columns.Count - 1 do
    FClientView.Header.Columns[i].Width := AppGlobals.HeaderWidth[i];
end;

procedure TClientTab.ClientManagerAddRecent(Sender: TObject);
var
  Client: TICEClient;
begin
  Client := Sender as TICEClient;

  if not Client.AutoRemove then
  begin
    FAddressBar.Stations.AddItem(Client.Entry.Name, Client.Entry.StartURL);

    if FStreams.SubmittedStreamList.IndexOf(Client.Entry.StartURL) = -1 then
    begin
      FHomeCommunication.SubmitStream(Client.Entry.StartURL);
      FStreams.SubmittedStreamList.Add(Client.Entry.StartURL);
    end;
  end;

  ShowInfo;
end;

procedure TClientTab.ClientManagerDebug(Sender: TObject);
begin
  if FSideBar.FDebugView.DebugView.Client = Sender then
  begin
    FSideBar.FDebugView.ShowDebug(TICEClient(Sender));
  end;
end;

procedure TClientTab.ClientManagerICYReceived(Sender: TObject;
  Received: Integer);
var
  Client: TICEClient;
begin
  Client := Sender as TICEClient;

  FReceived := FReceived + Received;
  FStreams.Received := FStreams.Received + Received;
  Client.Entry.BytesReceived := Client.Entry.BytesReceived + Received;

  FRefreshInfo := True;
end;

procedure TClientTab.ClientManagerTitleAllowed(Sender: TObject; Title: string;
  var Allowed: Boolean; var Match: string; var Filter: Integer);
var
  i: Integer;
  List: TTitleList;
begin
  Match := '';
  if Length(Title) < 1 then
    Exit;

  case TICEClient(Sender).Entry.Settings.Filter of
    ufWish:
      begin
        Allowed := False;
        Filter := 0;
        List := FStreams.SaveList;
      end;
    ufIgnore:
      begin
        Allowed := True;
        Filter := 1;
        List := FStreams.IgnoreList;
      end
    else
      begin
        Allowed := True;
        Exit;
      end;
  end;

  Title := LowerCase(Title);
  for i := 0 to List.Count - 1 do
  begin
    if Like(Title, List[i].Pattern) then
    begin
      Allowed := not Allowed;
      Match := List[i].Title;
      Exit;
    end;
  end;
end;

procedure TClientTab.ClientManagerRefresh(Sender: TObject);
begin
  FClientView.RefreshClient(Sender as TICEClient);

  if Assigned(FOnUpdateButtons) then
    FOnUpdateButtons(Sender);
end;

procedure TClientTab.ClientManagerClientAdded(Sender: TObject);
var
  Client: TICEClient;
begin
  Client := Sender as TICEClient;
  FClientView.AddClient(Client);
end;

procedure TClientTab.ClientManagerClientRemoved(Sender: TObject);
var
  Client: TICEClient;
  Node, RemoveNode: PVirtualNode;
  NodeData: PClientNodeData;
  FreeCategory: TListCategory;
begin
  Client := Sender as TICEClient;

  FreeCategory := nil;
  RemoveNode := nil;

  // Wenn es zum Client eine Category gibt, die auf Killed = True ist,
  // und es keinen anderen Client mehr gibt, die Category entfernen.
  Node := FClientView.GetClientNode(Client);

  // Node kann irgendwie nil sein bei Programmende..
  if Node = nil then
    Exit;

  if Node.Parent <> FClientView.RootNode then
  begin
    NodeData := FClientView.GetNodeData(Node.Parent);
    if NodeData.Category.Killed and (FClientView.ChildCount[Node.Parent] <= 1) then
    begin
      FreeCategory := NodeData.Category;
      RemoveNode := Node.Parent;
    end;
  end;

  FClientView.RemoveClient(Client);

  if FSidebar.FDebugView.DebugView.Client = Client then
    FSidebar.FDebugView.ShowDebug(nil);

  ShowInfo;

  if RemoveNode <> nil then
  begin
    FStreams.CategoryList.Remove(FreeCategory);
    FreeCategory.Free;
    FClientView.DeleteNode(RemoveNode);
  end;
end;

procedure TClientTab.ClientManagerSongSaved(Sender: TObject;
  Filename, Title: string; Filesize: UInt64; WasCut: Boolean);
var
  Client: TICEClient;
  Track: TTrackInfo;
  i, NumChars: Integer;
  Pattern, LowerFilename: string;
  Hash: Cardinal;

 Found: Boolean;
begin
  Client := Sender as TICEClient;

  Track := nil;
  LowerFilename := LowerCase(Filename);
  for i := 0 to FStreams.TrackList.Count - 1 do
    if LowerCase(FStreams.TrackList[i].Filename) = LowerFilename then
    begin
      Track := FStreams.TrackList[i];
      Break;
    end;

  if Track = nil then
  begin
    Track := TTrackInfo.Create(Now, Filename, Client.Entry.Name);
    FStreams.TrackList.Add(Track);
  end;

  Track.Streamname := Client.Entry.Name;
  Track.Filesize := Filesize;
  Track.WasCut := WasCut;
  Track.BitRate := Client.Entry.Bitrate;
  Track.IsAuto := Client.AutoRemove;

  if Assigned(FOnTrackAdded) then
    FOnTrackAdded(Client.Entry, Track);

  Client := Sender as TICEClient;
  if Client.Entry.Settings.AddSavedToIgnore then
  begin
    Pattern := BuildPattern(Title, Hash, NumChars);
    if NumChars > 3 then
    begin
      Found := False;
      for i := 0 to FStreams.IgnoreList.Count - 1 do
        if FStreams.IgnoreList[i].Hash = Hash then
        begin
          Found := True;
          Break;
        end;

      if not Found then
      begin
        if Assigned(FOnAddIgnoreList) then
          FOnAddIgnoreList(Self, Title);
      end;
    end;
  end;

  ShowInfo;
end;

procedure TClientTab.ClientManagerTitleChanged(Sender: TObject;
  Title: string);
begin
  // Ist hier, weil wenn FFilename im Client gesetzt wird, das hier aufgerufen wird.
  // Relativ unsch�n so, aber Hauptsache es tut..
  if Assigned(FOnUpdateButtons) then
    FOnUpdateButtons(Sender);
end;

procedure TClientTab.FClientViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    FActionRemove.Execute;
  end;
end;

procedure TClientTab.FClientViewStartStreaming(Sender: TObject;
  URL: string; Node: PVirtualNode; Mode: TVTNodeAttachMode);
begin
  StartStreaming('', URL, False, Node, Mode);
end;

procedure TClientTab.FSetVolume(Value: Integer);
var
  Clients: TClientArray;
  Client: TICEClient;
begin
  FVolume.NotifyOnMove := False;
  FVolume.Volume := Value;
  FVolume.NotifyOnMove := True;

  Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, False));
  for Client in Clients do
  begin
    Client.SetVolume(FVolume.Volume);
  end;
end;

procedure TClientTab.FClientViewKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) or (Key = #32) then
  begin
    FClientViewDblClick(FClientView);
    Key := #0;
  end;
end;

procedure TClientTab.FClientViewChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Clients: TNodeDataArray;
begin
  if Assigned(OnUpdateButtons) then
    OnUpdateButtons(Self);
  ShowInfo;

  if FClientView.SelectedCount = 1 then
  begin
    Clients := FClientView.NodesToData(FClientView.GetNodes(ntClient, True));
    if Length(Clients) = 1 then
      FSideBar.FDebugView.ShowDebug(Clients[0].Client);
  end else
    FSideBar.FDebugView.ShowDebug(nil);
end;

procedure TClientTab.FClientViewDblClick(Sender: TObject);
var
  Clients: TNodeDataArray;
begin
  Clients := FClientView.NodesToData(FClientView.GetNodes(ntClient, True));
  if Length(Clients) = 1 then
  begin
    case AppGlobals.DefaultAction of
      caStartStop:
        begin
          if Clients[0].Client.AutoRemove then
            Exit;

          if Clients[0].Client.Recording then
            Clients[0].Client.StopRecording
          else
          begin
            if not DiskSpaceOkay(AppGlobals.Dir, AppGlobals.MinDiskSpace) then
              MsgBox(Handle, _('Available disk space is below the set limit, so recording will not start.'), _('Info'), MB_ICONINFORMATION)
            else
              Clients[0].Client.StartRecording;
          end;
        end;
      caStreamIntegrated:
        if Clients[0].Client.Playing then
          if Clients[0].Client.Paused then
            FActionPlay.Execute
          else
            FActionStopPlay.Execute
        else
          FActionPlay.Execute;
      caStream:
        FActionTuneInStream.Execute;
      caFile:
        FActionTuneInFile.Execute;
    end;
  end;
end;

function TClientTab.StartStreaming(Name, URL: string; StartPlay: Boolean;
  HitNode: PVirtualNode; Mode: TVTNodeAttachMode): Boolean;
  procedure UnkillCategory;
  var
    NodeData: PClientNodeData;
  begin
    if HitNode <> nil then
    begin
      NodeData := FClientView.GetNodeData(HitNode);
      if NodeData.Category <> nil then
        NodeData.Category.Killed := False;
    end;
  end;
var
  Clients: TClientArray;
  Client: TICEClient;
  Entry: TStreamEntry;
  Node: PVirtualNode;
begin
  Result := True;

  if StartPlay then
  begin
    Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, False));
    for Client in Clients do
    begin
      Client.StopPlay;
    end;
  end;

  if (not StartPlay) and (not DiskSpaceOkay(AppGlobals.Dir, AppGlobals.MinDiskSpace)) then
  begin
    Result := False;
    MsgBox(Handle, _('Available disk space is below the set limit, so recording will not start.'), _('Info'), MB_ICONINFORMATION);
    Exit;
  end;

  URL := Trim(URL);
  if URL <> '' then
  begin
    // Ist der Client schon in der Liste?
    Client := FClients.GetClient(Name, URL, '', nil);
    if (Client <> nil) and (not Client.AutoRemove) then
    begin
      if StartPlay then
        Client.StartPlay
      else
        Client.StartRecording;
      UnkillCategory;
      Exit;
    end else
    begin
      // Ist der Client schon bekannt?
      {
      Entry := FStreams.StreamList.Get(Name, URL, nil);
      if Entry <> nil then
      begin
        Client := FClients.AddClient(Entry);

        if HitNode <> nil then
        begin
          Node := FClientView.GetClientNode(Client);
          FClientView.MoveTo(Node, HitNode, Mode, False);
        end;

        if StartPlay then
          Client.StartPlay
        else
          Client.StartRecording;
        UnkillCategory;
      end else
      }
      begin
        if ValidURL(URL) then
        begin
          Client := FClients.AddClient(Name, URL);

          if HitNode <> nil then
          begin
            Node := FClientView.GetClientNode(Client);
            FClientView.MoveTo(Node, HitNode, Mode, False);
          end;

          if StartPlay then
            Client.StartPlay
          else
            Client.StartRecording;
          UnkillCategory;
        end else
        begin
          Result := False;
          MsgBox(Handle, _('The stream could not be added to the list because the URL is invalid.'), _('Info'), MB_ICONINFORMATION);
        end;
      end;
    end;
  end;
end;

procedure TClientTab.StreamBrowserAction(Sender: TObject; Action: TOpenActions;
  Streams: TStreamDataArray);
var
  i: Integer;
  s: string;
  Entries: TPlaylistEntryArray;
begin
  if Action in [oaOpen, oaSave] then
  begin
    SetLength(Entries, 0);
    for i := 0 to Length(Streams) - 1 do
    begin
      SetLength(Entries, Length(Entries) + 1);
      Entries[i].Name := Streams[i].Name;
      Entries[i].URL := Streams[i].URL;
    end;
  end;

  case Action of
    oaStart:
      for i := 0 to Length(Streams) - 1 do
        if not StartStreaming(Streams[i].Name, Streams[i].URL, False, nil, amNoWhere) then
          Break;
    oaPlay:
      for i := 0 to Length(Streams) - 1 do
        StartStreaming(Streams[i].Name, Streams[i].URL, True, nil, amNoWhere);
    oaOpen:
      SavePlaylist(Entries, True);
    oaOpenWebsite:
      for i := 0 to Length(Streams) - 1 do
        ShellExecute(Handle, 'open', PChar(Streams[i].Website), '', '', 1);
    oaCopy:
      begin
        s := '';
        Clipboard.Clear;
        for i := 0 to Length(Streams) - 1 do
          s := s + Streams[i].URL + #13#10;
        s := Trim(s);
        Clipboard.SetTextBuf(PChar(s));
      end;
    oaSave:
      SavePlaylist(Entries, False);
  end;
end;

procedure TClientTab.VolumeTrackbarChange(Sender: TObject);
var
  Clients: TClientArray;
  Client: TICEClient;
begin
  Clients := FClientView.NodesToClients(FClientView.GetNodes(ntClient, False));
  for Client in Clients do
  begin
    Client.SetVolume(FVolume.Volume);
  end;

  if Assigned(FOnVolumeChanged) then
    FOnVolumeChanged(Self, FVolume.Volume);
end;

procedure TClientTab.TimerTick;
begin
  if FRefreshInfo then
  begin
    ShowInfo;
    FRefreshInfo := False;
  end;
end;

procedure TClientTab.UpdateStreams(Streams: TDataLists);
var
  i: Integer;
  Nodes: TNodeArray;
  NodeData: PClientNodeData;
  E: TStreamEntry;
  C: TListCategory;
  CatIdx: Integer;
  OldCategories: TListCategoryList;
begin
  CatIdx := 0;

  for i := 0 to Streams.StreamList.Count - 1 do
    Streams.StreamList[i].Free;
  Streams.StreamList.Clear;

  for i := 0 to Streams.RecentList.Count - 1 do
    Streams.RecentList[i].Free;
  Streams.RecentList.Clear;


  for i := 0 to FAddressBar.Stations.ItemsEx.Count - 1 do
  begin
    Streams.RecentList.Add(TRecentEntry(FAddressBar.Stations.ItemsEx[i].Data).Copy);
  end;

  OldCategories := TListCategoryList.Create;
  try
    for i := 0 to Streams.CategoryList.Count - 1 do
      OldCategories.Add(Streams.CategoryList[i]);

    Nodes := FClientView.GetNodes(ntAll, False);
    for i := 0 to Length(Nodes) - 1 do
    begin
      NodeData := FClientView.GetNodeData(Nodes[i]);

      if NodeData.Client <> nil then
      begin
        if NodeData.Client.AutoRemove then
          Continue;

        E := NodeData.Client.Entry.Copy;
        E.IsInList := True;
        E.Index := Nodes[i].Index;
        E.CategoryIndex := 0;
        if Nodes[i].Parent <> FClientView.RootNode then
        begin
          E.CategoryIndex := CatIdx;
        end;
        FStreams.StreamList.Add(E);
      end else
      begin
        CatIdx := Nodes[i].Index + 1;
        C := TListCategory.Create(NodeData.Category.Name, CatIdx);
        C.Expanded := FClientView.Expanded[Nodes[i]];
        C.IsAuto := NodeData.Category.IsAuto;
        Streams.CategoryList.Add(C);
      end;
    end;

    // Alte Kategorien erst hier l�schen, weil ich an der Stelle
    // nicht wie bei den StreamEntries mit Kopien arbeite.
    for i := 0 to OldCategories.Count - 1 do
    begin
      Streams.CategoryList.Remove(OldCategories[i]);
      OldCategories[i].Free;
    end;
  finally
    OldCategories.Free;
  end;
end;

procedure TClientTab.BuildTree(Streams: TDataLists);
var
  i: Integer;
  Client: TICEClient;
  Cat: TListCategory;
  Node, ParentNode: PVirtualNode;
begin
  for i := 0 to Streams.CategoryList.Count - 1 do
    FClientView.AddCategory(Streams.CategoryList[i]);

  for i := 0 to Streams.StreamList.Count - 1 do
  begin
    if not Streams.StreamList[i].IsInList then
      Continue;

    Client := FClients.AddClient(Streams.StreamList[i]);
    Node := FClientView.GetClientNode(Client);
    if Client <> nil then
    begin
      if Streams.StreamList[i].CategoryIndex > 0 then
      begin
        ParentNode := FClientView.GetCategoryNode(Streams.StreamList[i].CategoryIndex);
        if ParentNode <> nil then
          FClientView.MoveTo(Node, ParentNode, amAddChildLast, False);
      end;
    end;
  end;

  for i := 0 to Streams.CategoryList.Count - 1 do
  begin
    Node := FClientView.GetCategoryNode(Streams.CategoryList[i].Index);
    if Streams.CategoryList[i].Expanded then
      FClientView.Expanded[Node] := True;
  end;

  if FClientView.AutoNode = nil then
  begin
    Cat := TListCategory.Create(_('Managed streams'), High(Integer));
    Cat.IsAuto := True;
    FClientView.AddCategory(Cat);
    Streams.CategoryList.Add(Cat);
  end;

  Cat := PClientNodeData(FClientView.GetNodeData(FClientView.AutoNode)).Category;
  Cat.Name := _('Managed streams');

  FClientView.SortItems;
end;

{ TSidebar }

constructor TSidebar.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TSidebar.Destroy;
begin

  inherited;
end;

procedure TSidebar.Init;
begin
  FPage1 := TTabSheet.Create(Self);
  FPage1.PageControl := Self;
  FPage1.Caption := 'Browser';

  FPage2 := TTabSheet.Create(Self);
  FPage2.PageControl := Self;
  FPage2.Caption := 'Info';

  FPage3 := TTabSheet.Create(Self);
  FPage3.PageControl := Self;
  FPage3.Caption := 'Log';

  FBrowserView := TMStreamBrowserView.Create(Self);
  FInfoView := TMStreamInfoView.Create(Self);
  FDebugView := TMStreamDebugView.Create(Self);

  FBrowserView.Parent := FPage1;
  FInfoView.Parent := FPage2;
  FDebugView.Parent := FPage3;
end;

end.


