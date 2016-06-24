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

unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ImgList, ComCtrls, ShellAPI,
  ShlObj, AppData, LanguageObjects, Functions, GUIFunctions, SettingsBase,
  PostProcess, StrUtils, DynBASS, ICEClient, Generics.Collections, Menus,
  MsgDlg, PngImageList, PngSpeedButton, pngimage, VirtualTrees, Math,
  DataManager, PngBitBtn, Logging, ToolWin, ListsTab, DownloadAddons,
  ExtendedStream, AddonManager, AddonBase, Generics.Defaults,
  SettingsAddPostProcessor, ConfigureEncoder, AudioFunctions,
  SWFunctions, TypeDefs, SharedData, PerlRegEx, MControls;

type
  TSettingsTypes = (stApp, stAuto, stStream);

  TBlacklistNodeData = record
    Name: string;
  end;
  PBlacklistNodeData = ^TBlacklistNodeData;

  TBlacklistTree = class(TVirtualStringTree)
  private
    FColTitle: TVirtualTreeColumn;
  protected
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var Text: UnicodeString); override;
    function DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var Index: Integer): TCustomImageList; override;
    procedure DoHeaderClick(HitInfo: TVTHeaderHitInfo); override;
    function DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; override;
    function DoIncrementalSearch(Node: PVirtualNode;
      const Text: string): Integer; override;
    procedure DoFreeNode(Node: PVirtualNode); override;
    procedure DoMeasureItem(TargetCanvas: TCanvas; Node: PVirtualNode;
      var NodeHeight: Integer); override;

  public
    constructor Create(AOwner: TComponent; Streams: TStringList); reintroduce;
    destructor Destroy; override;
    procedure UpdateList(List: TStringList);
    procedure RemoveSelected;
  end;

  TfrmSettings = class(TfrmSettingsBase)
    pnlStreams: TPanel;
    pnlMain: TPanel;
    chkTray: TCheckBox;
    pnlAdvanced: TPanel;
    txtMaxRetries: TLabeledEdit;
    txtRetryDelay: TLabeledEdit;
    Label1: TLabel;
    txtMinDiskSpace: TLabeledEdit;
    Label7: TLabel;
    pnlPostProcess: TPanel;
    lstPostProcess: TListView;
    Label3: TLabel;
    pnlCut: TPanel;
    txtSongBuffer: TLabeledEdit;
    Label5: TLabel;
    chkSearchSilence: TCheckBox;
    Label10: TLabel;
    txtSilenceLevel: TEdit;
    Label12: TLabel;
    txtSilenceLength: TEdit;
    Label13: TLabel;
    lstDefaultAction: TComboBox;
    Label14: TLabel;
    chkDeleteStreams: TCheckBox;
    optClose: TRadioButton;
    optMinimize: TRadioButton;
    chkAddSavedToIgnore: TCheckBox;
    lblDefaultFilter: TLabel;
    lstDefaultFilter: TComboBox;
    dlgOpen: TOpenDialog;
    btnAdd: TButton;
    btnRemove: TButton;
    txtApp: TLabeledEdit;
    txtAppParams: TLabeledEdit;
    lblAppParams: TLabel;
    btnBrowseApp: TPngSpeedButton;
    pnlHotkeys: TPanel;
    lstHotkeys: TListView;
    txtHotkey: THotKey;
    Label9: TLabel;
    chkSeparateTracks: TCheckBox;
    chkSaveStreamsToDisk: TCheckBox;
    chkOnlyIfCut: TCheckBox;
    chkOnlySaveFull: TCheckBox;
    lblPanelCut: TLabel;
    chkOverwriteSmaller: TCheckBox;
    Label6: TLabel;
    txtSilenceBufferSeconds: TEdit;
    Label15: TLabel;
    PngImageList1: TPngImageList;
    pnlAutoRecord: TPanel;
    chkAutoTuneIn: TCheckBox;
    lstSoundDevice: TComboBox;
    lblSoundDevice: TLabel;
    Label16: TLabel;
    lstMinQuality: TComboBox;
    Label17: TLabel;
    lstFormat: TComboBox;
    btnHelpPostProcess: TPngSpeedButton;
    btnMoveDown: TPngSpeedButton;
    btnMoveUp: TPngSpeedButton;
    chkDiscardSmaller: TCheckBox;
    pnlFilenames: TPanel;
    lblFilePattern: TLabel;
    Label18: TLabel;
    lstDefaultActionBrowser: TComboBox;
    pnlCommunityBlacklist: TPanel;
    pnlBlacklist: TPanel;
    btnBlacklistRemove: TButton;
    Label19: TLabel;
    chkSnapMain: TCheckBox;
    pnlStreamsAdvanced: TPanel;
    txtRegEx: TLabeledEdit;
    btnResetTitlePattern: TPngSpeedButton;
    btnConfigure: TButton;
    chkRememberRecordings: TCheckBox;
    chkDisplayPlayNotifications: TCheckBox;
    chkAutoTuneInConsiderIgnore: TCheckBox;
    pnlBandwidth: TPanel;
    Label11: TLabel;
    txtMaxSpeed: TLabeledEdit;
    chkLimit: TCheckBox;
    lblIgnoreTitles: TLabel;
    lstIgnoreTitles: TListView;
    btnRemoveIgnoreTitlePattern: TButton;
    btnAddIgnoreTitlePattern: TButton;
    txtIgnoreTitlePattern: TLabeledEdit;
    chkAddSavedToStreamIgnore: TCheckBox;
    chkAdjustTrackOffset: TCheckBox;
    txtAdjustTrackOffset: TLabeledEdit;
    optAdjustBackward: TRadioButton;
    optAdjustForward: TRadioButton;
    chkAutoTuneInAddToIgnore: TCheckBox;
    pnlFilenamesExt: TPanel;
    txtRemoveChars: TLabeledEdit;
    txtFilePatternDecimals: TLabeledEdit;
    txtFilePattern: TLabeledEdit;
    btnResetFilePattern: TPngSpeedButton;
    txtPreview: TLabeledEdit;
    txtIncompleteFilePattern: TLabeledEdit;
    btnResetIncompleteFilePattern: TPngSpeedButton;
    txtAutomaticFilePattern: TLabeledEdit;
    btnResetAutomaticFilePattern: TPngSpeedButton;
    btnResetRemoveChars: TPngSpeedButton;
    txtStreamFilePattern: TLabeledEdit;
    btnResetStreamFilePattern: TPngSpeedButton;
    chkAutoRemoveSavedFromWishlist: TCheckBox;
    chkRemoveSavedFromWishlist: TCheckBox;
    chkNormalizeVariables: TCheckBox;
    chkManualSilenceLevel: TCheckBox;
    pnlAddons: TPanel;
    lstAddons: TListView;
    lblOutputFormat: TLabel;
    lstOutputFormat: TComboBox;
    btnConfigureEncoder: TPngSpeedButton;
    pnlCommunity: TPanel;
    Label2: TLabel;
    chkSubmitStreamInfo: TCheckBox;
    Label8: TLabel;
    chkSubmitStats: TCheckBox;
    chkShowSplashScreen: TCheckBox;
    chkDisplayPlayedSong: TCheckBox;
    dlgSave: TSaveDialog;
    chkMonitorMode: TCheckBox;
    Label20: TLabel;
    txtMonitorCount: TLabeledEdit;
    chkCoverPanelAlwaysVisible: TCheckBox;
    chkDiscardAlways: TCheckBox;
    chkAutostart: TCheckBox;
    Label21: TLabel;
    lstRegExes: TListView;
    btnAddRegEx: TButton;
    btnRemoveRegEx: TButton;
    Label22: TLabel;
    txtDir: TLabeledEdit;
    btnBrowse: TPngSpeedButton;
    Bevel1: TBevel;
    btnBrowseLogFile: TPngSpeedButton;
    txtLogFile: TLabeledEdit;
    chkRememberPlaying: TCheckBox;
    txtShortLengthSeconds: TLabeledEdit;
    Label4: TLabel;
    chkSkipShort: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lstPostProcessSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure txtFilePatternChange(Sender: TObject);
    procedure chkSkipShortClick(Sender: TObject);
    procedure chkSearchSilenceClick(Sender: TObject);
    procedure chkTrayClick(Sender: TObject);
    procedure btnBrowseAppClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure txtAppParamsChange(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure txtHotkeyChange(Sender: TObject);
    procedure lstHotkeysChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure txtShortLengthSecondsChange(Sender: TObject);
    procedure txtSilenceLevelChange(Sender: TObject);
    procedure txtSilenceLengthChange(Sender: TObject);
    procedure txtSongBufferChange(Sender: TObject);
    procedure txtMaxRetriesChange(Sender: TObject);
    procedure txtRetryDelayChange(Sender: TObject);
    procedure chkDeleteStreamsClick(Sender: TObject);
    procedure chkAddSavedToIgnoreClick(Sender: TObject);
    procedure lstDefaultFilterChange(Sender: TObject);
    procedure chkSeparateTracksClick(Sender: TObject);
    procedure chkSaveStreamsToDiskClick(Sender: TObject);
    procedure chkOnlyIfCutClick(Sender: TObject);
    procedure chkOnlySaveFullClick(Sender: TObject);
    procedure chkOverwriteSmallerClick(Sender: TObject);
    procedure txtSilenceBufferSecondsChange(Sender: TObject);
    procedure lstPostProcessResize(Sender: TObject);
    procedure chkAutoTuneInClick(Sender: TObject);
    procedure chkDiscardSmallerClick(Sender: TObject);
    procedure lstHotkeysResize(Sender: TObject);
    procedure txtFilePatternDecimalsChange(Sender: TObject);
    procedure btnBlacklistRemoveClick(Sender: TObject);
    procedure txtRegExChange(Sender: TObject);
    procedure btnResetTitlePatternClick(Sender: TObject);
    procedure btnResetFilePatternClick(Sender: TObject);
    procedure lstPostProcessItemChecked(Sender: TObject; Item: TListItem);
    procedure btnConfigureClick(Sender: TObject);
    procedure txtRemoveCharsChange(Sender: TObject);
    procedure chkLimitClick(Sender: TObject);
    procedure lstIgnoreTitlesResize(Sender: TObject);
    procedure txtIgnoreTitlePatternChange(Sender: TObject);
    procedure lstIgnoreTitlesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnAddIgnoreTitlePatternClick(Sender: TObject);
    procedure btnRemoveIgnoreTitlePatternClick(Sender: TObject);
    procedure chkAddSavedToStreamIgnoreClick(Sender: TObject);
    procedure chkAdjustTrackOffsetClick(Sender: TObject);
    procedure txtAdjustTrackOffsetChange(Sender: TObject);
    procedure optAdjustClick(Sender: TObject);
    procedure lstIgnoreTitlesEdited(Sender: TObject; Item: TListItem;
      var S: string);
    procedure btnResetRemoveCharsClick(Sender: TObject);
    procedure txtStreamFilePatternChange(Sender: TObject);
    procedure txtStreamFilePatternClick(Sender: TObject);
    procedure chkRemoveSavedFromWishlistClick(Sender: TObject);
    procedure chkNormalizeVariablesClick(Sender: TObject);
    procedure chkManualSilenceLevelClick(Sender: TObject);
    procedure txtFilePatternEnter(Sender: TObject);
    procedure lstAddonsResize(Sender: TObject);
    procedure lstAddonsItemChecked(Sender: TObject; Item: TListItem);
    procedure lstOutputFormatSelect(Sender: TObject);
    procedure btnConfigureEncoderClick(Sender: TObject);
    procedure btnBrowseLogFileClick(Sender: TObject);
    procedure chkMonitorModeClick(Sender: TObject);
    procedure chkSubmitStatsClick(Sender: TObject);
    procedure chkDiscardAlwaysClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure chkSubmitStreamInfoClick(Sender: TObject);
    procedure lstRegExesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstRegExesEdited(Sender: TObject; Item: TListItem;
      var S: string);
    procedure lstRegExesResize(Sender: TObject);
    procedure btnAddRegExClick(Sender: TObject);
    procedure btnRemoveRegExClick(Sender: TObject);
  private
    FSettingsType: TSettingsTypes;
    FInitialized: Boolean;
    FOptionChanging: Boolean;
    FBrowseDir: Boolean;
    FDefaultActionIdx: Integer;
    FDefaultActionBrowserIdx: Integer;
    FDefaultFilterIdx: Integer;
    FOutputFormatIdx: Integer;
    FMinQualityIdx: Integer;
    FFormatIdx: Integer;
    FTemporaryPostProcessors: TPostProcessorList;
    FStreamSettings: TStreamSettingsArray;
    FIgnoreFieldList: TList;
    lstBlacklist: TBlacklistTree;
    btnReset: TBitBtn;
    FActivePreviewField: TLabeledEdit;
    OutputFormatLastIndex: Integer;

    procedure CreateApp(AOwner: TComponent; BrowseDir: Boolean);
    procedure CreateAuto(AOwner: TComponent; BrowseDir: Boolean);
    procedure CreateStreams(AOwner: TComponent);
    procedure CreateGeneral;
    procedure SetFields;

    function ValidatePattern(Text, Patterns: string): string;
    function GetNewID: Integer;

    function GetStringListHash(Lst: TStringList): Cardinal;
    procedure BuildHotkeys;
    function RemoveGray(C: TControl; ShowMessage: Boolean = True): Boolean;
    procedure EnablePanel(Panel: TPanel; Enable: Boolean);
    procedure FillFields(Settings: TStreamSettings);
    procedure SetGray;
    procedure RebuildPostProcessingList;
    procedure UpdatePostProcessUpDown;
    procedure ShowEncoderNeededMessage;

    procedure BlacklistTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure BlacklistTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnResetClick(Sender: TObject);
  protected
    procedure RegisterPages; override;
    procedure Finish; override;
    function CanFinish: Boolean; override;
    procedure SetPage(Page: TPage); override;
    procedure PreTranslate; override;
    procedure PostTranslate; override;
    procedure GetExportDataHeader(Stream: TExtendedStream); override;
    procedure GetExportData(Stream: TExtendedStream); override;
    function CheckImportFile(Filename: string): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent; SettingsType: TSettingsTypes;
      StreamSettings: TStreamSettingsArray; BrowseDir: Boolean);

    destructor Destroy; override;
    property StreamSettings: TStreamSettingsArray read FStreamSettings;
  end;

const
  WARNING_STREAMRECORDING = 'When changing this option for a stream which is recording, stop and start recording again for the new setting to become active.';

  LABEL_TRACKPATTERN = 'Valid variables for saved tracks: %artist%, %title%, %album%, %streamtitle%, %streamname%, %number%, %day%, %month%, %year%, %hour%, %minute%, %second%';
  LABEL_STREAMPATTERN = 'Valid variables for saved streams: %streamname%, %day%, %month%, %year%, %hour%, %minute%, %second%';
  LABEL_PATTERNSEPARATOR = 'Backslashes can be used to seperate directories.';

implementation

{$R *.dfm}

destructor TfrmSettings.Destroy;
var
  i: Integer;
begin
  FIgnoreFieldList.Free;

  for i := 0 to lstAddons.Items.Count - 1 do
    TAddonBase(lstAddons.Items[i].Data).Free;

  for i := 0 to FTemporaryPostProcessors.Count - 1 do
    FTemporaryPostProcessors[i].Free;
  FTemporaryPostProcessors.Free;

  for i := 0 to Length(FStreamSettings) - 1 do
    FStreamSettings[i].Free;

  inherited;
end;

procedure TfrmSettings.EnablePanel(Panel: TPanel; Enable: Boolean);
var
  i: Integer;
begin
  for i := 0 to Panel.ControlCount - 1 do
  begin
    Panel.Controls[i].Visible := Enable;

    if (Panel = pnlCut) and (FSettingsType <> stStream) then
    begin
      chkAdjustTrackOffset.Visible := False;
      txtAdjustTrackOffset.Visible := False;
      optAdjustBackward.Visible := False;
      optAdjustForward.Visible := False;
    end;
  end;

  if Enable then
    Panel.Tag := 0
  else
    Panel.Tag := 1;

  if Enable then
    lblPanelCut.Visible := False
  else
    lblPanelCut.Visible := True;
end;

procedure TfrmSettings.FillFields(Settings: TStreamSettings);
var
  i: Integer;
begin
  lstDefaultAction.ItemIndex := Integer(AppGlobals.DefaultAction);
  lstDefaultActionBrowser.ItemIndex := Integer(AppGlobals.DefaultActionBrowser);
  lstDefaultFilter.ItemIndex := Integer(Settings.Filter);
  chkSeparateTracks.Checked := Settings.SeparateTracks;
  chkSaveStreamsToDisk.Checked := not Settings.SaveToMemory;
  chkOnlySaveFull.Checked := Settings.OnlySaveFull;

  Language.Translate(Self, PreTranslate, PostTranslate);

  pnlGeneral.BringToFront;

  AppGlobals.Lock;
  try
    txtFilePattern.Text := Settings.FilePattern;
    txtAutomaticFilePattern.Text := Settings.FilePattern;
    txtIncompleteFilePattern.Text := Settings.IncompleteFilePattern;
    txtStreamFilePattern.Text := Settings.StreamFilePattern;
    txtFilePatternDecimals.Text := IntToStr(Settings.FilePatternDecimals);
    txtRemoveChars.Text := Settings.RemoveChars;
    chkNormalizeVariables.Checked := Settings.NormalizeVariables;

    if FSettingsType = stAuto then
    begin
      txtDir.EditLabel.Caption := _('Folder for automatically saved songs:');
      txtDir.Text := AppGlobals.DirAuto;
    end else
    begin
      txtDir.EditLabel.Caption := _('Folder for saved songs:');
      txtDir.Text := AppGlobals.Dir;
    end;

    chkDeleteStreams.Checked := Settings.DeleteStreams;
    chkAddSavedToIgnore.Checked := Settings.AddSavedToIgnore;
    chkAddSavedToStreamIgnore.Checked := Settings.AddSavedToStreamIgnore;
    chkRemoveSavedFromWishlist.Checked := Settings.RemoveSavedFromWishlist;
    chkOverwriteSmaller.Checked := Settings.OverwriteSmaller;
    chkDiscardSmaller.Checked := Settings.DiscardSmaller;
    chkDiscardAlways.Checked := Settings.DiscardAlways;

    chkSkipShort.Checked := Settings.SkipShort;
    chkSearchSilence.Checked := Settings.SearchSilence;
    chkManualSilenceLevel.Checked := not Settings.AutoDetectSilenceLevel;

    chkSearchSilenceClick(nil);
    chkManualSilenceLevelClick(nil);

    chkAutostart.Checked := FileExists(IncludeTrailingPathDelimiter(GetShellFolder(CSIDL_STARTUP)) + AppGlobals.AppName + '.lnk');
    chkTray.Checked := AppGlobals.Tray;
    chkSnapMain.Checked := AppGlobals.SnapMain;
    chkRememberRecordings.Checked := AppGlobals.RememberRecordings;
    chkRememberPlaying.Checked := AppGlobals.RememberPlaying;
    chkDisplayPlayedSong.Checked := AppGlobals.DisplayPlayedSong;
    chkDisplayPlayNotifications.Checked := AppGlobals.DisplayPlayNotifications;
    chkShowSplashScreen.Checked := AppGlobals.ShowSplashScreen;
    chkCoverPanelAlwaysVisible.Checked := AppGlobals.CoverPanelAlwaysVisible;
    optClose.Checked := not AppGlobals.TrayOnMinimize;
    optMinimize.Checked := AppGlobals.TrayOnMinimize;

    chkTrayClick(nil);

    chkAutoTuneIn.Checked := AppGlobals.AutoTuneIn;
    chkAutoTuneInConsiderIgnore.Checked := AppGlobals.AutoTuneInConsiderIgnore;
    chkAutoTuneInAddToIgnore.Checked := Settings.AddSavedToIgnore;
    chkAutoRemoveSavedFromWishlist.Checked := Settings.RemoveSavedFromWishlist;
    lstMinQuality.ItemIndex := AppGlobals.AutoTuneInMinQuality;
    lstFormat.ItemIndex := AppGlobals.AutoTuneInFormat;
    chkSubmitStreamInfo.Checked := AppGlobals.SubmitStreamInfo;
    chkSubmitStats.Checked := AppGlobals.SubmitStats;
    chkMonitorMode.Checked := AppGlobals.MonitorMode;
    txtMonitorCount.Text := IntToStr(AppGlobals.MonitorCount);
    chkLimit.Checked := AppGlobals.LimitSpeed;
    if AppGlobals.MaxSpeed > 0 then
      txtMaxSpeed.Text := IntToStr(AppGlobals.MaxSpeed);

    chkSubmitStreamInfoClick(nil);
    chkSubmitStatsClick(nil);
    chkMonitorModeClick(nil);

    txtShortLengthSeconds.Text := IntToStr(Settings.ShortLengthSeconds);
    txtSongBuffer.Text := IntToStr(Settings.SongBuffer);
    txtMaxRetries.Text := IntToStr(Settings.MaxRetries);
    txtRetryDelay.Text := IntToStr(Settings.RetryDelay);
    txtMinDiskSpace.Text := IntToStr(AppGlobals.MinDiskSpace);
    txtLogFile.Text := AppGlobals.LogFile;

    txtSilenceLevel.Text := IntToStr(Settings.SilenceLevel);
    txtSilenceLength.Text := IntToStr(Settings.SilenceLength);
    txtSilenceBufferSeconds.Text := IntToStr(Settings.SilenceBufferSecondsStart);

    chkAdjustTrackOffset.Checked := Settings.AdjustTrackOffset;
    txtAdjustTrackOffset.Text := IntToStr(Settings.AdjustTrackOffsetMS);
    if Settings.AdjustTrackOffsetDirection = toForward then
      optAdjustForward.Checked := True
    else
      optAdjustBackward.Checked := True;

    if ((FSettingsType = stAuto) and not DirectoryExists(AppGlobals.DirAuto)) or
       ((FSettingsType <> stAuto) and not DirectoryExists(AppGlobals.Dir)) then
    begin
      txtDir.Text := '';
    end;
  finally
    AppGlobals.Unlock;
  end;

  SetGray;

  if not chkSaveStreamsToDisk.Checked then
  begin
    chkSeparateTracks.Enabled := False;
    chkSeparateTracks.Checked := True;
    chkDeleteStreams.Enabled := False;
    chkDeleteStreams.Checked := False;
  end;

  if not chkSeparateTracks.Checked then
  begin
    chkDeleteStreams.Enabled := False;
    chkDeleteStreams.Checked := False;

    chkOnlySaveFull.Enabled := False;
  end;

  if chkDiscardAlways.Checked then
  begin
    chkDiscardSmaller.Enabled := False;
    chkDiscardSmaller.Checked := False;
    chkOverwriteSmaller.Enabled := False;
    chkOverwriteSmaller.Checked := False;
  end;

  // ---------------------------------------------------------------------------------------------------------
  if FTemporaryPostProcessors <> nil then
  begin
    for i := 0 to FTemporaryPostProcessors.Count - 1 do
      FTemporaryPostProcessors[i].Free;
    FTemporaryPostProcessors.Free;
  end;
  FTemporaryPostProcessors := TPostProcessorList.Create;

  lstOutputFormat.ItemIndex := Integer(Settings.OutputFormat);
  OutputFormatLastIndex := lstOutputFormat.ItemIndex;

  for i := 0 to Settings.PostProcessors.Count - 1 do
  begin
    if Settings.PostProcessors[i].Hidden then
      Continue;

    FTemporaryPostProcessors.Add(Settings.PostProcessors[i].Copy);
  end;

  FTemporaryPostProcessors.Sort(TComparer<TPostProcessBase>.Construct(
    function (const L, R: TPostProcessBase): integer
    begin
      if L.GroupID <> R.GroupID then
        Result := CmpInt(L.GroupID, R.GroupID)
      else
        Result := CmpInt(L.Order, R.Order);
    end
  ));

  RebuildPostProcessingList;
  if lstPostProcess.Items.Count > 0 then
    lstPostProcess.Items[0].Selected := True;
  // ---------------------------------------------------------------------------------------------------------

  txtShortLengthSeconds.Enabled := chkSkipShort.State <> cbUnchecked;
  Label4.Enabled := txtShortLengthSeconds.Enabled;

  EnablePanel(pnlCut, (not chkSaveStreamsToDisk.Checked or (chkSeparateTracks.Checked and chkSeparateTracks.Enabled)) or (FSettingsType = stAuto));
  chkSkipShort.Enabled := (not chkSaveStreamsToDisk.Checked or (chkSeparateTracks.Checked and chkSeparateTracks.Enabled)) or (FSettingsType = stAuto);
  txtShortLengthSeconds.Enabled := chkSkipShort.Enabled and chkSkipShort.Checked;
end;

procedure TfrmSettings.Finish;
var
  i, k, n: Integer;
  PostProcessor: TPostProcessBase;
  EP: TExternalPostProcess;
  Item: TListItem;
begin
  if Length(FStreamSettings) > 0 then
  begin
    if FSettingsType = stAuto then
    begin
      AppGlobals.Lock;
      try
        AppGlobals.AutoTuneIn := chkAutoTuneIn.Checked;
        AppGlobals.AutoTuneInConsiderIgnore := chkAutoTuneInConsiderIgnore.Checked;
        AppGlobals.AutoTuneInMinQuality := lstMinQuality.ItemIndex;
        AppGlobals.AutoTuneInFormat := lstFormat.ItemIndex;
        AppGlobals.DirAuto := txtDir.Text;

        lstBlacklist.UpdateList(AppGlobals.Data.StreamBlacklist);
      finally
        AppGlobals.Unlock;
      end;
    end;

    if FSettingsType = stApp then
    begin
      AppGlobals.Lock;
      try
        if lstSoundDevice.ItemIndex > -1 then
          AppGlobals.SoundDevice := TBassDevice(lstSoundDevice.Items.Objects[lstSoundDevice.ItemIndex]).ID;

        if chkAutostart.Checked then
        begin
          CreateLink(Application.ExeName, PChar(GetShellFolder(CSIDL_STARTUP)), AppGlobals.AppName, '-minimize', False);
        end else
        begin
          CreateLink(Application.ExeName, PChar(GetShellFolder(CSIDL_STARTUP)), AppGlobals.AppName, '', True);
        end;

        AppGlobals.Dir := txtDir.Text;

        AppGlobals.Tray := chkTray.Checked;
        AppGlobals.SnapMain := chkSnapMain.Checked;
        AppGlobals.RememberRecordings := chkRememberRecordings.Checked;
        AppGlobals.RememberPlaying := chkRememberPlaying.Checked;
        AppGlobals.DisplayPlayedSong := chkDisplayPlayedSong.Checked;
        AppGlobals.DisplayPlayNotifications := chkDisplayPlayNotifications.Checked;
        AppGlobals.ShowSplashScreen := chkShowSplashScreen.Checked;
        AppGlobals.CoverPanelAlwaysVisible := chkCoverPanelAlwaysVisible.Checked;
        AppGlobals.TrayOnMinimize := optMinimize.Checked;

        AppGlobals.AutoTuneIn := chkAutoTuneIn.Checked;
        AppGlobals.SubmitStreamInfo := chkSubmitStreamInfo.Checked;
        AppGlobals.SubmitStats := chkSubmitStats.Checked;
        AppGlobals.MonitorMode := chkMonitorMode.Checked;
        AppGlobals.MonitorCount := StrToIntDef(txtMonitorCount.Text, 3);
        AppGlobals.LimitSpeed := chkLimit.Checked;
        if StrToIntDef(txtMaxSpeed.Text, -1) > 0 then
          AppGlobals.MaxSpeed := StrToInt(txtMaxSpeed.Text);

        AppGlobals.MinDiskSpace := StrToIntDef(txtMinDiskSpace.Text, 5);
        AppGlobals.LogFile := txtLogFile.Text;
        AppGlobals.DefaultAction := TClientActions(lstDefaultAction.ItemIndex);
        AppGlobals.DefaultActionBrowser := TStreamOpenActions(lstDefaultActionBrowser.ItemIndex);

        if lstHotkeys.Items[0].SubItems[0] <> '' then
          AppGlobals.ShortcutPlay := TextToShortCut(lstHotkeys.Items[0].SubItems[0])
        else
          AppGlobals.ShortcutPlay := 0;

        if lstHotkeys.Items[1].SubItems[0] <> '' then
          AppGlobals.ShortcutPause := TextToShortCut(lstHotkeys.Items[1].SubItems[0])
        else
          AppGlobals.ShortcutPause := 0;

        if lstHotkeys.Items[2].SubItems[0] <> '' then
          AppGlobals.ShortcutStop := TextToShortCut(lstHotkeys.Items[2].SubItems[0])
        else
          AppGlobals.ShortcutStop := 0;

        if lstHotkeys.Items[3].SubItems[0] <> '' then
          AppGlobals.ShortcutNext := TextToShortCut(lstHotkeys.Items[3].SubItems[0])
        else
          AppGlobals.ShortcutNext := 0;

        if lstHotkeys.Items[4].SubItems[0] <> '' then
          AppGlobals.ShortcutPrev := TextToShortCut(lstHotkeys.Items[4].SubItems[0])
        else
          AppGlobals.ShortcutPrev := 0;

        if lstHotkeys.Items[5].SubItems[0] <> '' then
          AppGlobals.ShortcutVolUp := TextToShortCut(lstHotkeys.Items[5].SubItems[0])
        else
          AppGlobals.ShortcutVolUp := 0;

        if lstHotkeys.Items[6].SubItems[0] <> '' then
          AppGlobals.ShortcutVolDown := TextToShortCut(lstHotkeys.Items[6].SubItems[0])
        else
          AppGlobals.ShortcutVolDown := 0;

        if lstHotkeys.Items[7].SubItems[0] <> '' then
          AppGlobals.ShortcutMute := TextToShortCut(lstHotkeys.Items[7].SubItems[0])
        else
          AppGlobals.ShortcutMute := 0;
      finally
        AppGlobals.Unlock;
      end;
    end;

    for i := 0 to Length(FStreamSettings) - 1 do
    begin
      if FSettingsType = stAuto then
        FStreamSettings[i].FilePattern := Trim(txtAutomaticFilePattern.Text)
      else if FIgnoreFieldList.IndexOf(txtFilePattern) = -1 then
        FStreamSettings[i].FilePattern := Trim(txtFilePattern.Text);

      if FIgnoreFieldList.IndexOf(txtIncompleteFilePattern) = -1 then
        FStreamSettings[i].IncompleteFilePattern := Trim(txtIncompleteFilePattern.Text);

      if FIgnoreFieldList.IndexOf(txtStreamFilePattern) = -1 then
        FStreamSettings[i].StreamFilePattern := Trim(txtStreamFilePattern.Text);

      if FIgnoreFieldList.IndexOf(txtFilePatternDecimals) = -1 then
        FStreamSettings[i].FilePatternDecimals := StrToIntDef(txtFilePatternDecimals.Text, 3);

      if FIgnoreFieldList.IndexOf(txtRemoveChars) = -1 then
        FStreamSettings[i].RemoveChars := txtRemoveChars.Text;

      if FIgnoreFieldList.IndexOf(chkNormalizeVariables) = -1 then
        FStreamSettings[i].NormalizeVariables := chkNormalizeVariables.Checked;

      if FIgnoreFieldList.IndexOf(chkDeleteStreams) = -1 then
        FStreamSettings[i].DeleteStreams := chkDeleteStreams.Checked and chkDeleteStreams.Enabled;

      if FSettingsType = stAuto then
        FStreamSettings[i].AddSavedToIgnore := chkAutoTuneInAddToIgnore.Checked
      else if FIgnoreFieldList.IndexOf(chkAddSavedToIgnore) = -1 then
        FStreamSettings[i].AddSavedToIgnore := chkAddSavedToIgnore.Checked;

      if FIgnoreFieldList.IndexOf(chkAddSavedToStreamIgnore) = -1 then
        FStreamSettings[i].AddSavedToStreamIgnore := chkAddSavedToStreamIgnore.Checked;

      if FSettingsType = stAuto then
        FStreamSettings[i].RemoveSavedFromWishlist := chkAutoRemoveSavedFromWishlist.Checked
      else if FIgnoreFieldList.IndexOf(chkRemoveSavedFromWishlist) = -1 then
        FStreamSettings[i].RemoveSavedFromWishlist := chkRemoveSavedFromWishlist.Checked;

      if FIgnoreFieldList.IndexOf(chkOverwriteSmaller) = -1 then
        FStreamSettings[i].OverwriteSmaller := chkOverwriteSmaller.Checked;

      if FIgnoreFieldList.IndexOf(chkDiscardSmaller) = -1 then
        FStreamSettings[i].DiscardSmaller := chkDiscardSmaller.Checked;

      if FIgnoreFieldList.IndexOf(chkDiscardAlways) = -1 then
        FStreamSettings[i].DiscardAlways := chkDiscardAlways.Checked;

      if pnlCut.Tag = 0 then
      begin
        if FIgnoreFieldList.IndexOf(chkSkipShort) = -1 then
          FStreamSettings[i].SkipShort := chkSkipShort.Checked;

        if FIgnoreFieldList.IndexOf(txtSongBuffer) = -1 then
          FStreamSettings[i].SongBuffer := StrToIntDef(txtSongBuffer.Text, 0);

        if FIgnoreFieldList.IndexOf(txtShortLengthSeconds) = -1 then
          FStreamSettings[i].ShortLengthSeconds := StrToIntDef(txtShortLengthSeconds.Text, 45);

        if FIgnoreFieldList.IndexOf(chkSearchSilence) = -1 then
          FStreamSettings[i].SearchSilence := chkSearchSilence.Checked;

        if FIgnoreFieldList.IndexOf(chkManualSilenceLevel) = -1 then
          FStreamSettings[i].AutoDetectSilenceLevel := not chkManualSilenceLevel.Checked;

        if FIgnoreFieldList.IndexOf(txtSilenceLevel) = -1 then
          FStreamSettings[i].SilenceLevel := StrToIntDef(txtSilenceLevel.Text, 5);

        if FIgnoreFieldList.IndexOf(txtSilenceLength) = -1 then
          FStreamSettings[i].SilenceLength := StrToIntDef(txtSilenceLength.Text, 100);

        if FIgnoreFieldList.IndexOf(txtSilenceBufferSeconds) = -1 then
        begin
          FStreamSettings[i].SilenceBufferSecondsStart := StrToIntDef(txtSilenceBufferSeconds.Text, 10);
          FStreamSettings[i].SilenceBufferSecondsEnd := StrToIntDef(txtSilenceBufferSeconds.Text, 10);
        end;

        if Length(FStreamSettings) > 0 then
        begin
          if FIgnoreFieldList.IndexOf(chkAdjustTrackOffset) = -1 then
            FStreamSettings[i].AdjustTrackOffset := chkAdjustTrackOffset.Checked;

          if FIgnoreFieldList.IndexOf(txtAdjustTrackOffset) = -1 then
            FStreamSettings[i].AdjustTrackOffsetMS := StrToInt(txtAdjustTrackOffset.Text);

          if FIgnoreFieldList.IndexOf(optAdjustBackward) = -1 then
          begin
            if optAdjustBackward.Checked then
              FStreamSettings[i].AdjustTrackOffsetDirection := toBackward
            else
              FStreamSettings[i].AdjustTrackOffsetDirection := toForward;
          end;
        end;
      end;

      if FIgnoreFieldList.IndexOf(txtMaxRetries) = -1 then
        FStreamSettings[i].MaxRetries := StrToIntDef(txtMaxRetries.Text, 100);

      if FIgnoreFieldList.IndexOf(txtRetryDelay) = -1 then
        FStreamSettings[i].RetryDelay := StrToIntDef(txtRetryDelay.Text, 5);

      if FIgnoreFieldList.IndexOf(lstDefaultFilter) = -1 then
        FStreamSettings[i].Filter := TUseFilters(lstDefaultFilter.ItemIndex);

      if FIgnoreFieldList.IndexOf(chkSeparateTracks) = -1 then
        FStreamSettings[i].SeparateTracks := chkSeparateTracks.Checked and chkSeparateTracks.Enabled;

      if FIgnoreFieldList.IndexOf(chkSaveStreamsToDisk) = -1 then
        FStreamSettings[i].SaveToMemory := not chkSaveStreamsToDisk.Checked;

      if FIgnoreFieldList.IndexOf(chkOnlySaveFull) = -1 then
        FStreamSettings[i].OnlySaveFull := chkOnlySaveFull.Checked;

      if (FIgnoreFieldList.IndexOf(lstRegExes) = -1) and (Length(FStreamSettings) > 0) then
      begin
        FStreamSettings[i].RegExes.Clear;
        for n := 0 to lstRegExes.Items.Count - 1 do
          FStreamSettings[i].RegExes.Add(lstRegExes.Items[n].Caption);
      end;

      if (FIgnoreFieldList.IndexOf(lstIgnoreTitles) = -1) and (Length(FStreamSettings) > 0) then
      begin
        FStreamSettings[i].IgnoreTrackChangePattern.Clear;
        for n := 0 to lstIgnoreTitles.Items.Count - 1 do
          FStreamSettings[i].IgnoreTrackChangePattern.Add(lstIgnoreTitles.Items[n].Caption);
      end;

      if FIgnoreFieldList.IndexOf(lstOutputFormat) = -1 then
        FStreamSettings[i].OutputFormat := TAudioTypes(lstOutputFormat.ItemIndex);

      if FIgnoreFieldList.IndexOf(lstPostProcess) = -1 then
      begin
        // -----------------------------------------------------------
        for k := 0 to FTemporaryPostProcessors.Count - 1 do
        begin
          PostProcessor := FStreamSettings[i].PostProcessors.Find(FTemporaryPostProcessors[k]);

          if (PostProcessor = nil) or (FTemporaryPostProcessors[k].IsNew) then
          begin
            // Ein neuer PostProcessor kann nur TExternalPostProcessor sein.
            PostProcessor := FTemporaryPostProcessors[k].Copy;
            FStreamSettings[i].PostProcessors.Add(PostProcessor);
          end;

          Item := nil;
          for n := 0 to lstPostProcess.Items.Count - 1 do
            if lstPostProcess.Items[n].Data = FTemporaryPostProcessors[k] then
            begin
              Item := lstPostProcess.Items[n];
              Break;
            end;

          PostProcessor.OnlyIfCut := FTemporaryPostProcessors[k].OnlyIfCut;
          PostProcessor.Order := Item.Index;
          PostProcessor.Active := Item.Checked;

          PostProcessor.Assign(FTemporaryPostProcessors[k]);
        end;

        // Vom Benutzer entfernte PostProcessors aus den echten PostProcessors entfernen..
        for k := FStreamSettings[i].PostProcessors.Count - 1 downto 0 do
        begin
          if FStreamSettings[i].PostProcessors[k] is TExternalPostProcess then
          begin
            EP := nil;
            for n := 0 to FTemporaryPostProcessors.Count - 1 do
              if FTemporaryPostProcessors[n] is TExternalPostProcess then
                if TExternalPostProcess(FTemporaryPostProcessors[n]).Identifier = TExternalPostProcess(FStreamSettings[i].PostProcessors[k]).Identifier then
                  begin
                    EP := TExternalPostProcess(FStreamSettings[i].PostProcessors[k]);
                    Break;
                  end;
            if EP = nil then
            begin
              FStreamSettings[i].PostProcessors[k].Free;
              FStreamSettings[i].PostProcessors.Delete(k);
              Continue;
            end;
          end;
          FStreamSettings[i].PostProcessors[k].IsNew := False;
        end;
        // -----------------------------------------------------------
      end;
    end;
  end else
    raise Exception.Create('not Length(FStreamSettings) > 0');

  inherited;
end;

procedure TfrmSettings.FormActivate(Sender: TObject);
begin
  if FBrowseDir then
  begin
    SetPage(FPageList.Find(TPanel(txtDir.Parent)));
    btnBrowse.Click;
  end;
  FBrowseDir := False;
end;

procedure TfrmSettings.FormResize(Sender: TObject);
begin
  inherited;

  lblPanelCut.Top := pnlCut.ClientHeight div 2 - lblPanelCut.Height div 2;
  lblPanelCut.Left := pnlCut.ClientWidth div 2 - lblPanelCut.Width div 2;

  txtSilenceLength.Left := Label12.Left + Label12.Width + 4;
  Label13.Left := txtSilenceLength.Left + txtSilenceLength.Width + 4;

  txtSilenceBufferSeconds.Left := Label6.Left + Label6.Width + 4;
  Label15.Left := txtSilenceBufferSeconds.Left + txtSilenceBufferSeconds.Width + 4;

  if btnReset <> nil then
  begin
    btnReset.Width := MulDiv(210, Screen.PixelsPerInch, 96);
    btnReset.Height := btnOK.Height;
    btnReset.Left := 4;
    btnReset.Top := btnOK.Top;
  end;
end;

procedure TfrmSettings.GetExportData(Stream: TExtendedStream);
begin
  inherited;

  AppGlobals.Lock;
  try
    AppGlobals.Data.Save(Stream, True);
  finally
    AppGlobals.Unlock;
  end;
end;

procedure TfrmSettings.GetExportDataHeader(Stream: TExtendedStream);
begin
  inherited;

  Stream.Write(EXPORTMAGIC[0], Length(EXPORTMAGIC));
end;

function TfrmSettings.GetNewID: Integer;
var
  i: Integer;
  Exists: Boolean;
begin
  Result := 1;

  while True do
  begin
    Exists := False;
    for i := 0 to lstPostProcess.Items.Count - 1 do
    begin
      if TPostProcessBase(lstPostProcess.Items[i].Data) is TExternalPostProcess then
        if TExternalPostProcess(lstPostProcess.Items[i].Data).Identifier = Result then
        begin
          Inc(Result);
          Exists := True;
          Break;
        end;
    end;

    if not Exists then
      Break;
  end;
end;

function TfrmSettings.GetStringListHash(Lst: TStringList): Cardinal;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Lst.Count - 1 do
    Result := Result + HashString(Lst[i]);
end;

procedure TfrmSettings.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

  if Key = VK_F1 then
  begin
    case FSettingsType of
      stApp:
        ShellExecute(Handle, 'open', PChar(AppGlobals.ProjectHelpLinkSettings), '', '', 1);
      stAuto:
        ShellExecute(Handle, 'open', PChar(AppGlobals.ProjectHelpLinkAutoSettings), '', '', 1);
      stStream:
        ShellExecute(Handle, 'open', PChar(AppGlobals.ProjectHelpLinkStreamSettings), '', '', 1);
    end;
  end;
end;

procedure TfrmSettings.Label20Click(Sender: TObject);
begin
  inherited;

  chkMonitorMode.Checked := not chkMonitorMode.Checked;
end;

procedure TfrmSettings.Label2Click(Sender: TObject);
begin
  inherited;

  chkSubmitStreamInfo.Checked := not chkSubmitStreamInfo.Checked;
end;

procedure TfrmSettings.Label8Click(Sender: TObject);
begin
  inherited;

  chkSubmitStats.Checked := not chkSubmitStats.Checked;
end;

procedure TfrmSettings.lstDefaultFilterChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(lstDefaultFilter);
end;

procedure TfrmSettings.lstHotkeysChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  txtHotkey.Enabled := lstHotkeys.Selected <> nil;
  if txtHotkey.Enabled then
  begin
    txtHotkey.HotKey := TextToShortCut(lstHotkeys.Selected.SubItems[0]);
    txtHotkey.ApplyFocus;
  end else
    txtHotkey.HotKey := 0;
end;

procedure TfrmSettings.lstHotkeysResize(Sender: TObject);
begin
  inherited;

  lstHotkeys.Columns[0].Width := lstHotkeys.ClientWidth div 2;
  lstHotkeys.Columns[1].Width := lstHotkeys.ClientWidth div 2 - 25;
end;

procedure TfrmSettings.lstIgnoreTitlesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  btnRemoveIgnoreTitlePattern.Enabled := lstIgnoreTitles.Selected <> nil;
end;

procedure TfrmSettings.lstIgnoreTitlesEdited(Sender: TObject;
  Item: TListItem; var S: string);
begin
  inherited;

  if Trim(S) = '' then
    S := Item.Caption
  else
    RemoveGray(lstIgnoreTitles);
end;

procedure TfrmSettings.lstIgnoreTitlesResize(Sender: TObject);
begin
  lstIgnoreTitles.Columns[0].Width := lstIgnoreTitles.ClientWidth - 25;
end;

procedure TfrmSettings.lstOutputFormatSelect(Sender: TObject);
var
  i: Integer;
begin
  inherited;

  if not FInitialized then
    Exit;

  RemoveGray(lstOutputFormat);

  if lstOutputFormat.ItemIndex = 0 then
  begin
    btnConfigureEncoder.Enabled := False;
    OutputFormatLastIndex := lstOutputFormat.ItemIndex;
    Exit;
  end;

  if AppGlobals.AddonManager.CanEncode(TAudioTypes(lstOutputFormat.ItemIndex)) <> ceOkay then
    if MsgBox(Handle, _('Additional addons are needed to use the selected output format. Do you want to download these addons now?'), _('Question'), MB_YESNO or MB_DEFBUTTON1 or MB_ICONQUESTION) = IDYES then
      AppGlobals.AddonManager.InstallEncoderFor(Self, TAudioTypes(lstOutputFormat.ItemIndex));

  if AppGlobals.AddonManager.CanEncode(TAudioTypes(lstOutputFormat.ItemIndex)) <> ceOkay then
    lstOutputFormat.ItemIndex := OutputFormatLastIndex
  else
    OutputFormatLastIndex := lstOutputFormat.ItemIndex;

  lstAddons.OnItemChecked := nil;
  for i := 0 to lstAddons.Items.Count - 1 do
    lstAddons.Items[i].Checked := TAddonBase(lstAddons.Items[i].Data).PackageDownloaded;
  lstAddons.OnItemChecked := lstAddonsItemChecked;

  btnConfigureEncoder.Enabled := lstOutputFormat.ItemIndex > 0;
end;

procedure TfrmSettings.lstAddonsItemChecked(Sender: TObject;
  Item: TListItem);
var
  i: Integer;
begin
  if not FInitialized then
    Exit;

  lstAddons.Selected := Item;

  lstAddons.OnItemChecked := nil;
  Item.Checked := AppGlobals.AddonManager.EnableAddon(Self, TAddonBase(Item.Data), True);
  lstAddons.OnItemChecked := lstAddonsItemChecked;

  // Eventuell wurden Abhängigkeiten mitinstalliert. Also alles mal aktualisieren.
  lstAddons.OnItemChecked := nil;
  for i := 0 to lstAddons.Items.Count - 1 do
    lstAddons.Items[i].Checked := TAddonBase(lstAddons.Items[i].Data).FilesExtracted;
  lstAddons.OnItemChecked := lstAddonsItemChecked;
end;

procedure TfrmSettings.lstAddonsResize(Sender: TObject);
begin
  inherited;

  lstAddons.Columns[0].Width := lstAddons.ClientWidth;
end;

procedure TfrmSettings.lstPostProcessItemChecked(Sender: TObject; Item: TListItem);
var
  i: Integer;
begin
  if not FInitialized then
    Exit;

  RemoveGray(lstPostProcess);

  if Item.Data = nil then
    Exit;

  if TObject(Item.Data) is TInternalPostProcess then
  begin
    lstPostProcess.OnItemChecked := nil;
    Item.Checked := AppGlobals.PostProcessManager.EnablePostProcess(Self, Item.Checked, TInternalPostProcess(Item.Data));
    lstPostProcess.OnItemChecked := lstPostProcessItemChecked;

    btnConfigure.Enabled := Item.Checked and TPostProcessBase(Item.Data).CanConfigure;
  end;

  FTemporaryPostProcessors.Find(TPostProcessBase(Item.Data)).Active := Item.Checked;

  if TPostProcessBase(Item.Data).NeedsWave and Item.Checked then
    ShowEncoderNeededMessage;

  lstAddons.OnItemChecked := nil;
  for i := 0 to lstAddons.Items.Count - 1 do
    lstAddons.Items[i].Checked := TAddonBase(lstAddons.Items[i].Data).PackageDownloaded;
  lstAddons.OnItemChecked := lstAddonsItemChecked;

  lstPostProcess.Selected := Item;
end;

procedure TfrmSettings.lstPostProcessResize(Sender: TObject);
begin
  inherited;

  lstPostProcess.Columns[0].Width := lstPostProcess.ClientWidth - 25;
end;

procedure TfrmSettings.lstPostProcessSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Item.Data = nil then
    Exit;

  btnConfigure.Enabled := False;

  btnHelpPostProcess.Enabled := (Item <> nil) and Selected and (TPostProcessBase(Item.Data).Help <> '');
  btnRemove.Enabled := (Item <> nil) and Selected and (TPostProcessBase(Item.Data) is TExternalPostProcess);

  UpdatePostProcessUpDown;

  chkOnlyIfCut.Checked := (Item <> nil) and Selected and TPostProcessBase(Item.Data).OnlyIfCut;
  chkOnlyIfCut.Enabled := (Item <> nil) and Selected;

  if Selected and (TPostProcessBase(Item.Data) is TExternalPostProcess) then
  begin
    txtApp.Text := TExternalPostProcess(Item.Data).Exe;
    txtAppParams.Text := TExternalPostProcess(Item.Data).Params;
    txtApp.Enabled := True;
    txtAppParams.Enabled := True;
    btnBrowseApp.Enabled := True;
    lblAppParams.Enabled := True;
    btnRemove.Enabled := True;
  end else
  begin
    txtApp.Text := '';
    txtAppParams.Text := '';
    txtApp.Enabled := False;
    txtAppParams.Enabled := False;
    btnBrowseApp.Enabled := False;
    lblAppParams.Enabled := False;
    btnRemove.Enabled := False;
  end;

  btnConfigure.Enabled := (Item <> nil) and Item.Checked and TPostProcessBase(Item.Data).CanConfigure;
end;

procedure TfrmSettings.lstRegExesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  btnRemoveRegEx.Enabled := lstRegExes.Selected <> nil;
end;

procedure TfrmSettings.lstRegExesEdited(Sender: TObject; Item: TListItem;
  var S: string);
begin
  inherited;

  if Trim(S) = '' then
    S := Item.Caption
  else
    RemoveGray(lstRegExes);
end;

procedure TfrmSettings.lstRegExesResize(Sender: TObject);
begin
  inherited;

  lstRegExes.Columns[0].Width := lstRegExes.ClientWidth - 25;
end;

procedure TfrmSettings.optAdjustClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
  begin
    RemoveGray(optAdjustBackward);
    RemoveGray(optAdjustForward);
  end;
end;

procedure TfrmSettings.PreTranslate;
begin
  inherited;

  FDefaultActionIdx := lstDefaultAction.ItemIndex;
  FDefaultActionBrowserIdx := lstDefaultActionBrowser.ItemIndex;
  FDefaultFilterIdx := lstDefaultFilter.ItemIndex;
  FOutputFormatIdx := lstOutputFormat.ItemIndex;
  FMinQualityIdx := lstMinQuality.ItemIndex;
  FFormatIdx := lstFormat.ItemIndex;
end;

procedure TfrmSettings.PostTranslate;
var
  i, LastIdx: Integer;
begin
  inherited;

  if FSettingsType = stAuto then
  begin
    lblFilePattern.Caption := _(LABEL_TRACKPATTERN) + #13#10 + _(LABEL_PATTERNSEPARATOR);
  end else
  begin
    lblFilePattern.Caption := _(LABEL_TRACKPATTERN) + #13#10 + _(LABEL_STREAMPATTERN) + #13#10 + _(LABEL_PATTERNSEPARATOR);
  end;

  lblAppParams.Caption := _('Valid variables: %filename%, %artist%, %title%, %album%, %streamtitle%, %streamname%, %number%, %day%, %month%, %year%, %hour%, %minute%, %second%'#13#10 +
                            'Every parameter should be quoted using ".');

  if lstPostProcess.Selected <> nil then
  begin
    lstPostProcessSelectItem(lstPostProcess, lstPostProcess.Selected, True);
  end;

  for i := 0 to lstAddons.Items.Count - 1 do
    lstAddons.Items[i].Caption := TAddonBase(lstAddons.Items[i].Data).Name;

  for i := 0 to lstPostProcess.Items.Count - 1 do
  begin
    // Damit Sprache neu gesetzt wird und so..
    //TPostProcessBase(lstPostProcess.Items[i].Data).Initialize;
    lstPostProcess.Items[i].Caption := TPostProcessBase(lstPostProcess.Items[i].Data).Name;
  end;

  if (lstSoundDevice.Items.Count > 0) and (lstSoundDevice.Items.Objects[0] <> nil) and
     (TBassDevice(lstSoundDevice.Items.Objects[0]).IsDefault) then
  begin
    LastIdx := lstSoundDevice.ItemIndex;
    lstSoundDevice.Items[0] := _('Default device');
    lstSoundDevice.ItemIndex := LastIdx;
  end;

  lstPostProcess.Groups[0].Header := _('Processing when in WAVE-format');
  lstPostProcess.Groups[1].Header := _('Processing after conversion to destination format');

  BuildHotkeys;

  lstDefaultAction.ItemIndex := FDefaultActionIdx;
  lstDefaultActionBrowser.ItemIndex := FDefaultActionBrowserIdx;
  lstDefaultFilter.ItemIndex := FDefaultFilterIdx;
  lstOutputFormat.ItemIndex := FOutputFormatIdx;
  lstMinQuality.ItemIndex := FMinQualityIdx;
  lstFormat.ItemIndex := FFormatIdx;

  if not lstSoundDevice.Enabled then
    lstSoundDevice.Text := _('(no devices available)');

  FormResize(Self);
end;

function TfrmSettings.ValidatePattern(Text, Patterns: string): string;
var
  i: Integer;
  Arr: TPatternReplaceArray;
  PList: TStringList;
begin
  inherited;

  PList := TStringList.Create;
  try
    Explode('|', Patterns, PList);

    SetLength(Arr, PList.Count);

    for i := 0 to PList.Count - 1 do
    begin
      Arr[i].C := PList[i];

      if Arr[i].C = 'artist' then
        Arr[i].Replace := _('Artist')
      else if Arr[i].C = 'title' then
        Arr[i].Replace := _('Title')
      else if Arr[i].C = 'album' then
        Arr[i].Replace := _('Album')
      else if Arr[i].C = 'streamtitle' then
        Arr[i].Replace := _('Title on stream')
      else if Arr[i].C = 'streamname' then
        Arr[i].Replace := _('Streamname')
      else if Arr[i].C = 'number' then
        Arr[i].Replace := Format('%.*d', [StrToIntDef(txtFilePatternDecimals.Text, 3), 78])
      else if Arr[i].C = 'day' then
        Arr[i].Replace := FormatDateTime('dd', Now)
      else if Arr[i].C = 'month' then
        Arr[i].Replace := FormatDateTime('mm', Now)
      else if Arr[i].C = 'year' then
        Arr[i].Replace := FormatDateTime('yy', Now)
      else if Arr[i].C = 'hour' then
        Arr[i].Replace := FormatDateTime('hh', Now)
      else if Arr[i].C = 'minute' then
        Arr[i].Replace := FormatDateTime('nn', Now)
      else if Arr[i].C = 'second' then
        Arr[i].Replace := FormatDateTime('ss', Now)
    end;
  finally
    PList.Free;
  end;

  Result := PatternReplaceNew(Text, Arr);

  Result := FixPatternFilename(Result);

  Result := FixPathName(Result + '.mp3');
end;

procedure TfrmSettings.RebuildPostProcessingList;
var
  i: Integer;
  Item: TListItem;
begin
  lstPostProcess.Items.BeginUpdate;
  try
    lstPostProcess.Items.Clear;
    for i := 0 to FTemporaryPostProcessors.Count - 1 do
    begin
      Item := lstPostProcess.Items.Add;
      Item.GroupID := FTemporaryPostProcessors[i].GroupID;
      Item.Caption := FTemporaryPostProcessors[i].Name;
      Item.Checked := FTemporaryPostProcessors[i].Active;
      // Data must be set at last that events (i.e. lstPostProcessItemChecked) do not fire
      Item.Data := FTemporaryPostProcessors[i];

      if FTemporaryPostProcessors[i] is TInternalPostProcess then
      begin
        Item.ImageIndex := 4;
      end else
      begin
        Item.ImageIndex := 5;
      end;
    end;
  finally
    lstPostProcess.Items.EndUpdate;
  end;
end;

procedure TfrmSettings.RegisterPages;
begin
  case FSettingsType of
    stApp:
      begin
        FPageList.Add(TPage.Create('Settings', pnlMain, 'PROPERTIES'));
        FPageList.Add(TPage.Create('Recordings', pnlStreams, 'STREAM'));
        FPageList.Add(TPage.Create('Filenames', pnlFilenames, 'FILENAMES'));
        FPageList.Add(TPage.Create('Advanced', pnlFilenamesExt, 'FILENAMESEXT', FPageList.Find(pnlFilenames)));
        FPageList.Add(TPage.Create('Cut songs', pnlCut, 'CUT'));
        FPageList.Add(TPage.Create('Addons', pnlAddons, 'ADDONS_PNG'));
        FPageList.Add(TPage.Create('Postprocessing', pnlPostProcess, 'LIGHTNING'));
        FPageList.Add(TPage.Create('Bandwidth', pnlBandwidth, 'BANDWIDTH'));
        FPageList.Add(TPage.Create('Community', pnlCommunity, 'GROUP_PNG'));
        FPageList.Add(TPage.Create('Hotkeys', pnlHotkeys, 'KEYBOARD'));
        FPageList.Add(TPage.Create('Advanced', pnlAdvanced, 'MISC'));
      end;
    stAuto:
      begin
        FPageList.Add(TPage.Create('Recordings', pnlAutoRecord, 'STREAM'));
        FPageList.Add(TPage.Create('Blacklist', pnlCommunityBlacklist, 'BLACKLIST', FPageList.Find(pnlAutoRecord)));
        FPageList.Add(TPage.Create('Filenames', pnlFilenames, 'FILENAMES'));
        FPageList.Add(TPage.Create('Cut songs', pnlCut, 'CUT'));
        FPageList.Add(TPage.Create('Postprocessing', pnlPostProcess, 'LIGHTNING'));
      end;
    stStream:
      begin
        FPageList.Add(TPage.Create('Recordings', pnlStreams, 'STREAM'));
        FPageList.Add(TPage.Create('Advanced', pnlStreamsAdvanced, 'MISC', FPageList.Find(pnlStreams)));
        FPageList.Add(TPage.Create('Filenames', pnlFilenames, 'FILENAMES'));
        FPageList.Add(TPage.Create('Advanced', pnlFilenamesExt, 'FILENAMESEXT', FPageList.Find(pnlFilenames)));
        FPageList.Add(TPage.Create('Cut songs', pnlCut, 'CUT'));
        FPageList.Add(TPage.Create('Postprocessing', pnlPostProcess, 'LIGHTNING'));
        FPageList.Add(TPage.Create('Advanced', pnlAdvanced, 'MISC'));
      end;
  end;

  inherited;
end;

function TfrmSettings.RemoveGray(C: TControl; ShowMessage: Boolean = True): Boolean;
begin
  Result := False;
  if FIgnoreFieldList = nil then
    Exit;

  if ShowMessage and (FIgnoreFieldList.IndexOf(C) > -1) and (not FOptionChanging) then
  begin
    TfrmMsgDlg.ShowMsg(Self, _('The setting''s configuration you are about to change differs for the selected streams. The new setting will be applied to every selected stream when saving settings using "OK".'), mtInformation, [mbOK], mbOK, 13);
  end;

  FIgnoreFieldList.Remove(C);

  if (TControl(C) is TEdit) or (TControl(C) is TLabeledEdit) then
  begin
    TEdit(C).Color := clWindow;
  end else if TControl(C) is TCheckBox then
  begin

  end else if TControl(C) is TComboBox then
  begin

  end else if TControl(C) is TListView then
  begin
    TListView(C).Color := clWindow;
  end;

  Result := True;
end;

procedure TfrmSettings.SetFields;
  procedure AddField(F: TControl);
  begin
    if FIgnoreFieldList.IndexOf(F) = -1 then
      FIgnoreFieldList.Add(F);
  end;
var
  i: Integer;
  S: TStreamSettings;
  F, ShowDialog: Boolean;
begin
  if Length(FStreamSettings) <= 1 then
    Exit;

  ShowDialog := False;
  S := FStreamSettings[0];

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
    if GetStringListHash(S.IgnoreTrackChangePattern) <> GetStringListHash(FStreamSettings[i].IgnoreTrackChangePattern) then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  if F then
    AddField(lstIgnoreTitles);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.FilePattern <> FStreamSettings[i].FilePattern then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtFilePattern);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.IncompleteFilePattern <> FStreamSettings[i].IncompleteFilePattern then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtIncompleteFilePattern);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.StreamFilePattern <> FStreamSettings[i].StreamFilePattern then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtStreamFilePattern);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.FilePatternDecimals <> FStreamSettings[i].FilePatternDecimals then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtFilePatternDecimals);

  F := False;
  for i := 0 to Length(FStreamSettings) - 1 do
  begin
    if S.RemoveChars <> FStreamSettings[i].RemoveChars then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtRemoveChars);

  F := False;
  for i := 0 to Length(FStreamSettings) - 1 do
  begin
    if S.NormalizeVariables <> FStreamSettings[i].NormalizeVariables then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkNormalizeVariables);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.DeleteStreams <> FStreamSettings[i].DeleteStreams then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkDeleteStreams);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.AddSavedToIgnore <> FStreamSettings[i].AddSavedToIgnore then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkAddSavedToIgnore);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.AddSavedToStreamIgnore <> FStreamSettings[i].AddSavedToStreamIgnore then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkAddSavedToStreamIgnore);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.RemoveSavedFromWishlist <> FStreamSettings[i].RemoveSavedFromWishlist then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkRemoveSavedFromWishlist);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.OverwriteSmaller <> FStreamSettings[i].OverwriteSmaller then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkOverwriteSmaller);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.DiscardSmaller <> FStreamSettings[i].DiscardSmaller then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkDiscardSmaller);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.DiscardAlways <> FStreamSettings[i].DiscardAlways then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkDiscardAlways);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SkipShort <> FStreamSettings[i].SkipShort then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkSkipShort);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
    if GetStringListHash(S.RegExes) <> GetStringListHash(FStreamSettings[i].RegExes) then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  if F then
    AddField(lstRegExes);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SearchSilence <> FStreamSettings[i].SearchSilence then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkSearchSilence);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.AutoDetectSilenceLevel <> FStreamSettings[i].AutoDetectSilenceLevel then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkManualSilenceLevel);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SilenceLevel <> FStreamSettings[i].SilenceLevel then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtSilenceLevel);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SilenceLength <> FStreamSettings[i].SilenceLength then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtSilenceLength);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SilenceBufferSecondsStart <> FStreamSettings[i].SilenceBufferSecondsStart then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtSilenceBufferSeconds);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.ShortLengthSeconds <> FStreamSettings[i].ShortLengthSeconds then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtShortLengthSeconds);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SongBuffer <> FStreamSettings[i].SongBuffer then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtSongBuffer);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.MaxRetries <> FStreamSettings[i].MaxRetries then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtMaxRetries);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.RetryDelay <> FStreamSettings[i].RetryDelay then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtRetryDelay);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.Filter <> FStreamSettings[i].Filter then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(lstDefaultFilter);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SeparateTracks <> FStreamSettings[i].SeparateTracks then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkSeparateTracks);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.SaveToMemory <> FStreamSettings[i].SaveToMemory then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkSaveStreamsToDisk);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.OnlySaveFull <> FStreamSettings[i].OnlySaveFull then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkOnlySaveFull);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.AdjustTrackOffset <> FStreamSettings[i].AdjustTrackOffset then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(chkAdjustTrackOffset);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.AdjustTrackOffsetMS <> FStreamSettings[i].AdjustTrackOffsetMS then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(txtAdjustTrackOffset);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.AdjustTrackOffsetDirection <> FStreamSettings[i].AdjustTrackOffsetDirection then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
  begin
    AddField(optAdjustBackward);
    AddField(optAdjustForward);
  end;

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.OutputFormat <> FStreamSettings[i].OutputFormat then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(lstOutputFormat);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.PostProcessors.Hash <> FStreamSettings[i].PostProcessors.Hash then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(lstPostProcess);

  F := False;
  for i := 1 to Length(FStreamSettings) - 1 do
  begin
    if S.EncoderSettings.Hash <> FStreamSettings[i].EncoderSettings.Hash then
    begin
      F := True;
      ShowDialog := True;
      Break;
    end;
  end;
  if F then
    AddField(btnConfigureEncoder);

  // Gegen die Warnung..
  if ShowDialog then
  begin

  end;
end;

procedure TfrmSettings.SetGray;
var
  i: Integer;
begin
  if FIgnoreFieldList = nil then
    Exit;

  for i := 0 to FIgnoreFieldList.Count - 1 do
    if (TControl(FIgnoreFieldList[i]) is TEdit) or (TControl(FIgnoreFieldList[i]) is TLabeledEdit) then
    begin
      TEdit(FIgnoreFieldList[i]).Color := clGrayText;
    end else if TControl(FIgnoreFieldList[i]) is TCheckBox then
    begin
      TCheckBox(FIgnoreFieldList[i]).State := cbGrayed;
    end else if TControl(FIgnoreFieldList[i]) is TComboBox then
    begin

    end else if TControl(FIgnoreFieldList[i]) is TListView then
      TListView(FIgnoreFieldList[i]).Color := clGrayText;
end;

procedure TfrmSettings.SetPage(Page: TPage);
begin
  inherited;

  if Page = FPageList.Find(pnlFilenames) then
    txtPreview.Text := '';
end;

procedure TfrmSettings.ShowEncoderNeededMessage;
begin
  TfrmMsgDlg.ShowMsg(Self, _('You enabled a postprocessor that needs a WAVE-file which will be reencoded after processing. ' +
                             'Make sure an encoder for the stream''s format is installed if you did not select another encoder by checking the "Addons" page. ' +
                             'To configure the encoder, select it at the top of the "Postprocessing" page and click the button next to it.'),
                             mtInformation, [mbOK], mbOK, 14);
end;

procedure TfrmSettings.txtAdjustTrackOffsetChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtAdjustTrackOffset);
end;

procedure TfrmSettings.txtAppParamsChange(Sender: TObject);
begin
  inherited;
  if (lstPostProcess.Selected <> nil) and txtAppParams.Focused then
    TExternalPostProcess(lstPostProcess.Selected.Data).Params := txtAppParams.Text;
end;

procedure TfrmSettings.txtFilePatternChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
  begin
    RemoveGray(Sender as TLabeledEdit);

    FActivePreviewField := Sender as TLabeledEdit;

    if Sender = txtAutomaticFilePattern then
      txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'artist|title|album|streamtitle|streamname|day|month|year|hour|minute|second')
    else if Sender = txtStreamFilePattern then
      txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'streamname|day|month|year|hour|minute|second')
    else
      txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'artist|title|album|streamtitle|number|streamname|day|month|year|hour|minute|second');

    if Trim(RemoveFileExt(txtPreview.Text)) = '' then
      txtPreview.Text := '';
  end;
end;

procedure TfrmSettings.txtFilePatternDecimalsChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtFilePatternDecimals);
end;

procedure TfrmSettings.txtHotkeyChange(Sender: TObject);
begin
  inherited;
  lstHotkeys.Selected.SubItems[0] := ShortCutToText(txtHotkey.HotKey);
end;

procedure TfrmSettings.txtIgnoreTitlePatternChange(Sender: TObject);
begin
  btnAddIgnoreTitlePattern.Enabled := Length(Trim(txtIgnoreTitlePattern.Text)) >= 1;
end;

procedure TfrmSettings.txtFilePatternEnter(Sender: TObject);
begin
  inherited;

  FActivePreviewField := Sender as TLabeledEdit;

  if Sender = txtAutomaticFilePattern then
    txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'artist|title|album|streamtitle|streamname|day|month|year|hour|minute|second')
  else if Sender = txtStreamFilePattern then
    txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'streamname|day|month|year|hour|minute|second')
  else
    txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'artist|title|album|streamtitle|number|streamname|day|month|year|hour|minute|second');

  if Trim(RemoveFileExt(txtPreview.Text)) = '' then
    txtPreview.Text := '';
end;

procedure TfrmSettings.txtMaxRetriesChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtMaxRetries);
end;

procedure TfrmSettings.txtRemoveCharsChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtRemoveChars);
end;

procedure TfrmSettings.txtRetryDelayChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtRetryDelay);
end;

procedure TfrmSettings.txtShortLengthSecondsChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtShortLengthSeconds);
end;

procedure TfrmSettings.txtSilenceBufferSecondsChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtSilenceBufferSeconds);
end;

procedure TfrmSettings.txtSilenceLengthChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtSilenceLength);
end;

procedure TfrmSettings.txtSilenceLevelChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtSilenceLevel);
end;

procedure TfrmSettings.txtSongBufferChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(txtSongBuffer);
end;

procedure TfrmSettings.txtStreamFilePatternChange(Sender: TObject);
begin
  inherited;

  if FInitialized then
  begin
    RemoveGray(Sender as TLabeledEdit);

    FActivePreviewField := Sender as TLabeledEdit;
    txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'streamname|day|month|year|hour|minute|second');

    if Trim(RemoveFileExt(txtPreview.Text)) = '' then
      txtPreview.Text := '';
  end;
end;

procedure TfrmSettings.txtStreamFilePatternClick(Sender: TObject);
begin
  inherited;

  FActivePreviewField := Sender as TLabeledEdit;
  txtPreview.Text := ValidatePattern(FActivePreviewField.Text, 'streamname|day|month|year|hour|minute|second');

  if Trim(RemoveFileExt(txtPreview.Text)) = '' then
    txtPreview.Text := '';
end;

procedure TfrmSettings.txtRegExChange(Sender: TObject);
begin
  inherited;

  btnAddRegEx.Enabled := Length(Trim(txtRegEx.Text)) >= 1;
end;

procedure TfrmSettings.UpdatePostProcessUpDown;
begin
  btnMoveUp.Enabled := (lstPostProcess.Selected <> nil) and (TObject(lstPostProcess.Selected.Data) is TExternalPostProcess) and (not (lstPostProcess.Selected.Index = 0)) and (not (lstPostProcess.Items[lstPostProcess.Selected.Index - 1].GroupID <> lstPostProcess.Selected.GroupID));
  btnMoveDown.Enabled := (lstPostProcess.Selected <> nil) and (TObject(lstPostProcess.Selected.Data) is TExternalPostProcess) and (not (lstPostProcess.Selected.Index = lstPostProcess.Items.Count - 1)) and (not (lstPostProcess.Items[lstPostProcess.Selected.Index + 1].GroupID <> lstPostProcess.Selected.GroupID));
end;

procedure TfrmSettings.BlacklistTreeChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnBlacklistRemove.Enabled := lstBlacklist.SelectedCount > 0;
end;

procedure TfrmSettings.BlacklistTreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    btnBlacklistRemoveClick(nil);
  end;
end;

procedure TfrmSettings.btnAddIgnoreTitlePatternClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lstIgnoreTitles.Items.Add;
  Item.Caption := txtIgnoreTitlePattern.Text;
  Item.ImageIndex := 1;
  txtIgnoreTitlePattern.Text := '';
  txtIgnoreTitlePattern.ApplyFocus;

  RemoveGray(lstIgnoreTitles);
end;

procedure TfrmSettings.btnAddRegExClick(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
  RValid, ArtistFound, TitleFound: Boolean;
  R: TPerlRegEx;
begin
  for i := 0 to lstRegExes.Items.Count - 1 do
    if Trim(txtRegEx.Text) = Trim(lstRegExes.Items[i].Caption) then
    begin
      MsgBox(Handle, _('The specified regular expression is already on the list.'), _('Info'), MB_ICONINFORMATION);
      Exit;
    end;

  RValid := False;
  R := TPerlRegEx.Create;
  try
    R.RegEx := txtRegEx.Text;
    try
      R.Compile;
      RValid := True;
    except end;
  finally
    R.Free;
  end;

  ArtistFound := (Pos('(?P<a>.*)', txtRegEx.Text) > 0) or (Pos('(?P<a>.*?)', txtRegEx.Text) > 0);
  TitleFound := (Pos('(?P<t>.*)', txtRegEx.Text) > 0) or (Pos('(?P<t>.*?)', txtRegEx.Text) > 0);

  if (Trim(txtRegEx.Text) = '') or (not RValid) or (not ArtistFound) or (not TitleFound) then
  begin
    MsgBox(Handle, _('Please supply a valid regular expression containing the groups (?P<a>.*)/(?P<a>.*?) and (?P<t>.*)/(?P<t>.*?).'), _('Info'), MB_ICONINFORMATION);
    Exit;
  end;

  Item := lstRegExes.Items.Add;
  Item.Caption := txtRegEx.Text;
  Item.ImageIndex := 7;
  txtRegEx.Text := '';
  txtRegEx.ApplyFocus;

  RemoveGray(lstRegExes);
end;

procedure TfrmSettings.btnAddClick(Sender: TObject);

  function HighestGroupIndex(GroupID: Integer): Integer;
  var
    i: Integer;
    MaxVal: Integer;
  begin
    MaxVal := -1;
    for i := 0 to FTemporaryPostProcessors.Count - 1 do
      if (FTemporaryPostProcessors[i].GroupID = GroupID) and (i > MaxVal) then
        MaxVal := i;
    Result := MaxVal;
  end;

var
  i: Integer;
  Item: TListItem;
  PostProcessor: TExternalPostProcess;
  AddPostProcessorForm: TfrmSettingsAddPostProcessor;
begin
  inherited;

  if not FInitialized then
    Exit;

  RemoveGray(lstPostProcess);

  AddPostProcessorForm := TfrmSettingsAddPostProcessor.Create(Self);
  try
    AddPostProcessorForm.ShowModal;
    if AddPostProcessorForm.Result <= 1 then
    begin
      if dlgOpen.Execute then
      begin
        if FileExists(dlgOpen.FileName) then
        begin
          Item := lstPostProcess.Items.Insert(HighestGroupIndex(AddPostProcessorForm.Result) + 1);
          Item.Caption := ExtractFileName(dlgOpen.FileName);
          PostProcessor := TExternalPostProcess.Create(dlgOpen.FileName, '"%f"', True, False, GetNewID, 100000, AddPostProcessorForm.Result);
          PostProcessor.IsNew := True;
          FTemporaryPostProcessors.Insert(HighestGroupIndex(AddPostProcessorForm.Result) + 1, PostProcessor);
          Item.GroupID := PostProcessor.GroupID;
          Item.Checked := PostProcessor.Active;
          Item.Data := PostProcessor;
          Item.ImageIndex := 5;
          Item.Selected := True;

          if TPostProcessBase(Item.Data).NeedsWave then
          begin
            ShowEncoderNeededMessage;
          end;

          RebuildPostProcessingList;

          for i := 0 to lstPostProcess.Items.Count - 1 do
            if TPostProcessBase(lstPostProcess.Items[i].Data) = PostProcessor then
            begin
              lstPostProcess.Items[i].Selected := True;
              Break;
            end;
        end;
      end;
    end;
  finally
    AddPostProcessorForm.Free;
  end;
end;

procedure TfrmSettings.btnBlacklistRemoveClick(Sender: TObject);
begin
  lstBlacklist.RemoveSelected;
end;

procedure TfrmSettings.btnBrowseAppClick(Sender: TObject);
begin
  inherited;
  if dlgOpen.Execute then
  begin
    if FileExists(dlgOpen.FileName) then
    begin
      txtApp.Text := dlgOpen.FileName;
      lstPostProcess.Selected.Caption := ExtractFileName(dlgOpen.FileName);
      TExternalPostProcess(lstPostProcess.Selected.Data).Exe := dlgOpen.FileName;
    end;
  end;
end;

procedure TfrmSettings.btnBrowseClick(Sender: TObject);
var
  Msg: string;
  Dir: string;
begin
  if FSettingsType = stAuto then
    Msg := 'Select folder for automatically saved songs'
  else
    Msg := 'Select folder for saved songs';

  Dir := BrowseDialog(Handle, _(Msg), BIF_RETURNONLYFSDIRS);

  if Dir = '' then
    Exit;

  if DirectoryExists(Dir) then
    txtDir.Text := IncludeTrailingBackslash(Dir)
  else
    MsgBox(Self.Handle, _('The selected folder does not exist. Please choose another one.'), _('Info'), MB_ICONINFORMATION);
end;

procedure TfrmSettings.btnBrowseLogFileClick(Sender: TObject);
begin
  inherited;

  if dlgSave.Execute then
  begin
    if dlgSave.FileName <> '' then
    begin
      if ExtractFileExt(LowerCase(dlgSave.FileName)) = '' then
        dlgSave.FileName := dlgSave.FileName + '.txt';
      txtLogFile.Text := dlgSave.FileName;
    end;
  end;
end;

procedure TfrmSettings.btnConfigureClick(Sender: TObject);
begin
  inherited;

  if not FInitialized then
    Exit;

  if lstPostProcess.Selected <> nil then
  begin
    RemoveGray(lstPostProcess);

    TPostProcessBase(lstPostProcess.Selected.Data).Configure(Self, 0, True);
  end;
end;

procedure TfrmSettings.btnConfigureEncoderClick(Sender: TObject);
var
  i: Integer;
  F: TfrmConfigureEncoder;
  EncoderSettings: TEncoderSettings;
begin
  inherited;

  if not FInitialized then
    Exit;

  RemoveGray(btnConfigureEncoder);

  EncoderSettings := FStreamSettings[0].EncoderSettings.Find(TAudioTypes(lstOutputFormat.ItemIndex)).Copy;

  F := TfrmConfigureEncoder.Create(Self, EncoderSettings);
  try
    F.ShowModal;

    if F.Save then
      for i := 0 to High(FStreamSettings) do
        FStreamSettings[i].EncoderSettings.Find(TAudioTypes(lstOutputFormat.ItemIndex)).Assign(F.EncoderSettings);
  finally
    EncoderSettings.Free;
    F.Free;
  end;
end;

procedure TfrmSettings.btnHelpClick(Sender: TObject);
var
  PostProcess: TPostProcessBase;
begin
  if lstPostProcess.Selected = nil then
    Exit;
  PostProcess := lstPostProcess.Selected.Data;
  MessageBox(Handle, PChar(PostProcess.Help), 'Info', MB_ICONINFORMATION);
end;

procedure TfrmSettings.btnMoveClick(Sender: TObject);
var
  i: integer;
  Selected: TPostProcessBase;
begin
  if lstPostProcess.Selected = nil then
    Exit;

  Selected := TPostProcessBase(lstPostProcess.Selected.Data);

  for i := 0 to FTemporaryPostProcessors.Count - 1 do
    if FTemporaryPostProcessors[i] = TPostProcessBase(lstPostProcess.Selected.Data) then
    begin
      if Sender = btnMoveUp then
      begin
        FTemporaryPostProcessors.Exchange(i, i - 1);
      end else
      begin
        FTemporaryPostProcessors.Exchange(i, i + 1);
      end;
      Break;
    end;

  RebuildPostProcessingList;

  for i := 0 to lstPostProcess.Items.Count - 1 do
    if TPostProcessBase(lstPostProcess.Items[i].Data) = Selected then
    begin
      lstPostProcess.Items[i].Selected := True;
      Break;
    end;

  UpdatePostProcessUpDown;
end;

procedure TfrmSettings.btnRemoveClick(Sender: TObject);
begin
  if not FInitialized then
    Exit;

  if lstPostProcess.Selected <> nil then
  begin
    RemoveGray(lstPostProcess);

    FTemporaryPostProcessors.Remove(TExternalPostProcess(lstPostProcess.Selected.Data));
    TExternalPostProcess(lstPostProcess.Selected.Data).Free;
    //lstPostProcess.Selected.Delete;

    RebuildPostProcessingList;
  end;
end;

procedure TfrmSettings.btnRemoveIgnoreTitlePatternClick(Sender: TObject);
begin
  lstIgnoreTitles.Items.Delete(lstIgnoreTitles.Selected.Index);

  RemoveGray(lstIgnoreTitles);
end;

procedure TfrmSettings.btnRemoveRegExClick(Sender: TObject);
begin
  lstRegExes.Items.Delete(lstRegExes.Selected.Index);

  RemoveGray(lstRegExes);
end;

procedure TfrmSettings.btnResetClick(Sender: TObject);
var
  i: Integer;
begin
  FInitialized := False;
  if FIgnoreFieldList <> nil then
  begin
    while FIgnoreFieldList.Count > 0 do
      RemoveGray(TControl(FIgnoreFieldList[0]), False);
  end;
  FillFields(AppGlobals.Data.StreamSettings);

  btnConfigureEncoder.Enabled := TAudioTypes(lstOutputFormat.ItemIndex) <> atNone;

  if TAudioTypes(lstOutputFormat.ItemIndex) <> atNone then
  begin
    for i := 0 to High(FStreamSettings) do
    begin
      FStreamSettings[i].EncoderSettings.Find(TAudioTypes(lstOutputFormat.ItemIndex)).Assign(AppGlobals.Data.StreamSettings.EncoderSettings.Find(TAudioTypes(lstOutputFormat.ItemIndex)));
    end;
  end;

  FInitialized := True;
end;

procedure TfrmSettings.btnResetFilePatternClick(Sender: TObject);
begin
  inherited;

  if Sender = btnResetFilePattern then
  begin
    txtFilePattern.Text := '%streamname%\%artist% - %title%';
    txtFilePattern.ApplyFocus;
    RemoveGray(txtFilePattern);
  end else if Sender = btnResetIncompleteFilePattern then
  begin
    txtIncompleteFilePattern.Text := '%streamname%\%artist% - %title%';
    txtIncompleteFilePattern.ApplyFocus;
    RemoveGray(txtIncompleteFilePattern);
  end else if Sender = btnResetAutomaticFilePattern then
  begin
    txtAutomaticFilePattern.Text := '%streamname%\%artist% - %title%';
    txtAutomaticFilePattern.ApplyFocus;
    RemoveGray(txtAutomaticFilePattern);
  end else
  begin
    txtStreamFilePattern.Text := '%streamname%';
    txtStreamFilePattern.ApplyFocus;
  end;
end;

procedure TfrmSettings.btnResetRemoveCharsClick(Sender: TObject);
begin
  inherited;

  txtRemoveChars.Text := '[]{}#$§%~^';
  txtRemoveChars.ApplyFocus;
  RemoveGray(txtRemoveChars);
end;

procedure TfrmSettings.btnResetTitlePatternClick(Sender: TObject);
begin
  inherited;

  txtRegEx.Text := '(?P<a>.*) - (?P<t>.*)';
  txtRegEx.ApplyFocus;
end;

procedure TfrmSettings.BuildHotkeys;
var
  Item: TListItem;
begin
  if lstHotkeys.Items.Count > 0 then
  begin
    lstHotkeys.Items[0].Caption := _('Play');
    lstHotkeys.Items[1].Caption := _('Pause');
    lstHotkeys.Items[2].Caption := _('Stop');
    lstHotkeys.Items[3].Caption := _('Next stream');
    lstHotkeys.Items[4].Caption := _('Previous stream');
    lstHotkeys.Items[5].Caption := _('Volume up');
    lstHotkeys.Items[6].Caption := _('Volume down');
    lstHotkeys.Items[7].Caption := _('Mute');
  end else
  begin
    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Play');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutPlay));

    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Pause');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutPause));

    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Stop');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutStop));

    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Next stream');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutNext));

    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Previous stream');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutPrev));

    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Volume up');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutVolUp));

    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Volume down');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutVolDown));

    Item := lstHotkeys.Items.Add;
    Item.Caption := _('Mute');
    Item.SubItems.Add(ShortCutToText(AppGlobals.ShortcutMute));
  end;
end;

function TfrmSettings.CanFinish: Boolean;
  function ControlVisible(C: TControl): Boolean;
  var
    i: Integer;
    P: TControl;
  begin
    if not C.Visible then
      Exit(False);

    for i := 0 to FPageList.Count - 1 do
    begin
      P := C.Parent;
      while not P.InheritsFrom(TForm) do
      begin
        if P = FPageList[i].Panel then
          if P.Visible then
            Exit(True)
          else
            Exit(False);
        P := P.Parent;
      end;
    end;
    Exit(False);
  end;
var
  i, n: Integer;
begin
  Result := False;

  if not inherited then
    Exit;

  if Trim(txtMinDiskSpace.Text) = '' then
  begin
    MsgBox(Handle, _('Please enter the minumum free space that must be available for recording.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtMinDiskSpace.Parent)));
    txtMinDiskSpace.ApplyFocus;
    Exit;
  end;

  if ControlVisible(txtFilePattern) and (Trim(RemoveFileExt(ValidatePattern(txtFilePattern.Text, 'artist|title|album|streamtitle|number|streamname|day|month|year|hour|minute|second'))) = '') then
  begin
    MsgBox(Handle, _('Please enter a valid pattern for filenames of completely recorded tracks so that a preview is shown.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtFilePattern.Parent)));
    txtFilePattern.ApplyFocus;
    Exit;
  end;

  if ControlVisible(txtIncompleteFilePattern) and (Trim(RemoveFileExt(ValidatePattern(txtIncompleteFilePattern.Text, 'artist|title|album|streamtitle|number|streamname|day|month|year|hour|minute|second'))) = '') then
  begin
    MsgBox(Handle, _('Please enter a valid pattern for filenames of incompletely recorded tracks so that a preview is shown.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtIncompleteFilePattern.Parent)));
    txtIncompleteFilePattern.ApplyFocus;
    Exit;
  end;

  if ControlVisible(txtAutomaticFilePattern) and (Trim(RemoveFileExt(ValidatePattern(txtAutomaticFilePattern.Text, 'artist|title|album|streamtitle|streamname|day|month|year|hour|minute|second'))) = '') then
  begin
    MsgBox(Handle, _('Please enter a valid pattern for filenames of automatically recorded tracks so that a preview is shown.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtAutomaticFilePattern.Parent)));
    txtAutomaticFilePattern.ApplyFocus;
    Exit;
  end;

  if ControlVisible(txtStreamFilePattern) and (Trim(RemoveFileExt(ValidatePattern(txtStreamFilePattern.Text, 'streamname|day|month|year|hour|minute|second'))) = '') then
  begin
    MsgBox(Handle, _('Please enter a valid pattern for filenames of stream files so that a preview is shown.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtStreamFilePattern.Parent)));
    txtStreamFilePattern.ApplyFocus;
    Exit;
  end;

  if ControlVisible(txtFilePatternDecimals) and ((StrToIntDef(txtFilePatternDecimals.Text, -1) > 9) or (StrToIntDef(txtFilePatternDecimals.Text, -1) < 1)) then
  begin
    MsgBox(Handle, _('Please enter the minimum count of decimals for tracknumbers in filenames.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtFilePatternDecimals.Parent)));
    txtFilePatternDecimals.ApplyFocus;
    Exit;
  end;

  if ControlVisible(txtDir) and (not DirectoryExists(txtDir.Text)) then
  begin
    if FSettingsType = stAuto then
      MsgBox(Handle, _('The selected folder for automatically saved songs does not exist.'#13#10'Please select another folder.'), _('Info'), MB_ICONINFORMATION)
    else
      MsgBox(Handle, _('The selected folder for saved songs does not exist.'#13#10'Please select another folder.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtDir.Parent)));
    btnBrowse.Click;
    Exit;
  end;

  if pnlCut.Tag = 0 then
  begin
    if Trim(txtShortLengthSeconds.Text) = '' then
    begin
      if chkSkipShort.Checked then
      begin
        MsgBox(Handle, _('Please enter the maximum length for songs that should be considered as ads.'), _('Info'), MB_ICONINFORMATION);
        SetPage(FPageList.Find(TPanel(txtShortLengthSeconds.Parent)));
        txtShortLengthSeconds.ApplyFocus;
        Exit;
      end else
        if Length(FStreamSettings) = 1 then
          txtShortLengthSeconds.Text := IntToStr(FStreamSettings[0].ShortLengthSeconds)
        else
          txtShortLengthSeconds.Text := IntToStr(AppGlobals.Data.StreamSettings.ShortLengthSeconds);
    end;

    if (StrToIntDef(txtSilenceLevel.Text, -1) > 100) or (StrToIntDef(txtSilenceLevel.Text, -1) < 1) then
    begin
      if chkSearchSilence.Checked and (chkManualSilenceLevel.Checked) then
      begin
        MsgBox(Handle, _('Please enter the maximum volume level for silence detection as a value ranging from 1 to 100.'), _('Info'), MB_ICONINFORMATION);
        SetPage(FPageList.Find(TPanel(txtSilenceLevel.Parent)));
        txtSilenceLevel.ApplyFocus;
        Exit;
      end else
        if Length(FStreamSettings) = 1 then
          txtSilenceLevel.Text := IntToStr(FStreamSettings[0].SilenceLevel)
        else
          txtSilenceLevel.Text := IntToStr(AppGlobals.Data.StreamSettings.SilenceLevel);
    end;

    if StrToIntDef(txtSilenceLength.Text, -1) < 20 then
    begin
      if chkSearchSilence.Checked then
      begin
        MsgBox(Handle, _('Please enter the minimum length for silence (at least 20 ms).'), _('Info'), MB_ICONINFORMATION);
        SetPage(FPageList.Find(TPanel(txtSilenceLength.Parent)));
        txtSilenceLength.ApplyFocus;
        Exit;
      end else
        if Length(FStreamSettings) = 1 then
          txtSilenceLength.Text := IntToStr(FStreamSettings[0].SilenceLength)
        else
          txtSilenceLength.Text := IntToStr(AppGlobals.Data.StreamSettings.SilenceLength);
    end;

    if (StrToIntDef(txtSilenceBufferSeconds.Text, -1) < 1) or (StrToIntDef(txtSilenceBufferSeconds.Text, -1) > 15) then
    begin
      if chkSearchSilence.Checked then
      begin
        MsgBox(Handle, _('Please enter the length in seconds to search for silence at beginning and end of song as a value ranging from 1 to 15.'), _('Info'), MB_ICONINFORMATION);
        SetPage(FPageList.Find(TPanel(txtSilenceBufferSeconds.Parent)));
        txtSilenceBufferSeconds.ApplyFocus;
        Exit;
      end else
        if Length(FStreamSettings) = 1 then
          txtSilenceBufferSeconds.Text := IntToStr(FStreamSettings[0].SilenceBufferSecondsStart)
        else
          txtSilenceBufferSeconds.Text := IntToStr(AppGlobals.Data.StreamSettings.SilenceBufferSecondsStart);
    end;

    if Trim(txtSongBuffer.Text) = '' then
    begin
      MsgBox(Handle, _('Please enter the length of the buffer that should be added to every beginning/end of saved titles if no silence could be found.'), _('Info'), MB_ICONINFORMATION);
      SetPage(FPageList.Find(TPanel(txtSongBuffer.Parent)));
      txtSongBuffer.ApplyFocus;
      Exit;
    end;

    if Length(FStreamSettings) > 0 then
      if StrToIntDef(txtAdjustTrackOffset.Text, -1) = -1 then
      begin
        if chkAdjustTrackOffset.Checked then
        begin
          MsgBox(Handle, _('Please enter the length in seconds for track change detection adjustment.'), _('Info'), MB_ICONINFORMATION);
          SetPage(FPageList.Find(TPanel(txtAdjustTrackOffset.Parent)));
          txtAdjustTrackOffset.ApplyFocus;
          Exit;
        end else
          if Length(FStreamSettings) = 1 then
            txtAdjustTrackOffset.Text := IntToStr(FStreamSettings[0].AdjustTrackOffsetMS)
          else
            txtAdjustTrackOffset.Text := IntToStr(AppGlobals.Data.StreamSettings.AdjustTrackOffsetMS);
      end;
  end;

  if ControlVisible(txtMaxRetries) and (Trim(txtMaxRetries.Text) = '') then
  begin
    MsgBox(Handle, _('Please enter the number of maximum connect retries.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtMaxRetries.Parent)));
    txtMaxRetries.ApplyFocus;
    Exit;
  end;

  if ControlVisible(txtRetryDelay) and (Trim(txtRetryDelay.Text) = '') then
  begin
    MsgBox(Handle, _('Please enter the delay between connect retries.'), _('Info'), MB_ICONINFORMATION);
    SetPage(FPageList.Find(TPanel(txtRetryDelay.Parent)));
    txtRetryDelay.ApplyFocus;
    Exit;
  end;

  if chkLimit.Checked then
    if ControlVisible(txtMaxSpeed) and (StrToIntDef(txtMaxSpeed.Text, -1) <= 0) then
    begin
      MsgBox(Handle, _('Please enter the maximum bandwidth in KB/s available to streamWriter.'), _('Info'), MB_ICONINFORMATION);
      SetPage(FPageList.Find(TPanel(txtMaxSpeed.Parent)));
      txtMaxSpeed.ApplyFocus;
      Exit;
    end;

  if chkMonitorMode.Checked then
  begin
    if ControlVisible(txtMonitorCount) and (StrToIntDef(txtMonitorCount.Text, -1) <= 0) then
    begin
      MsgBox(Handle, _('Please enter the maximum number of streams to monitor.'), _('Info'), MB_ICONINFORMATION);
      SetPage(FPageList.Find(TPanel(txtMonitorCount.Parent)));
      txtMonitorCount.ApplyFocus;
      Exit;
    end;

    if ControlVisible(txtMonitorCount) and (StrToIntDef(txtMonitorCount.Text, -1) > 50) then
    begin
      if TfrmMsgDlg.ShowMsg(GetParentForm(Self), _('You entered a high number for streams to monitor. This affects your bandwidth and resources in general. streamWriter might become slow and unresponsible depending on your system. Are you sure you want to do this?'),
                                                   mtConfirmation, mbOKCancel, mbCancel, 17) = mrCancel then
      begin
        SetPage(FPageList.Find(TPanel(txtMonitorCount.Parent)));
        txtMonitorCount.ApplyFocus;
        Exit;
      end;
    end;
  end;

  if ControlVisible(lstHotkeys) then
    for i := 0 to lstHotkeys.Items.Count - 1 do
      for n := 0 to lstHotkeys.Items.Count - 1 do
      begin
        if (lstHotkeys.Items[i] <> lstHotkeys.Items[n]) and
           (lstHotkeys.Items[i].SubItems[0] <> '') and
           (lstHotkeys.Items[i].SubItems[0] = lstHotkeys.Items[n].SubItems[0]) then
        begin
          MsgBox(Handle, _('A hotkey can be defined only once. Please edit the key mappings.'), _('Info'), MB_ICONINFORMATION);
          SetPage(FPageList.Find(pnlHotkeys));
          Exit;
        end;
      end;

  if ControlVisible(txtRetryDelay) and (StrToIntDef(txtRetryDelay.Text, 5) > 999) then
    txtRetryDelay.Text := '999';

  Result := True;
end;

function TfrmSettings.CheckImportFile(Filename: string): Boolean;
var
  S: TExtendedStream;
begin
  Result := inherited;

  try
    S := TExtendedStream.Create;
    try
      S.LoadFromFile(Filename);
      TDataLists.VerifyMagic(S, 10, False);
    finally
      S.Free;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      if E is EUnsupportedFormatException then
        MsgBox(0, _('The file could not be imported because it contains regular saved data and no exported profile.'), _('Error'), MB_ICONERROR)
      else if E is EUnknownFormatException then
        MsgBox(0, _('The file could not be imported because it''s format is unknown.'), _('Error'), MB_ICONERROR)
      else
        MsgBox(0, _('The file could not be imported.'), _('Error'), MB_ICONERROR);
    end;
  end;
end;

procedure TfrmSettings.chkAddSavedToIgnoreClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(chkAddSavedToIgnore);
end;

procedure TfrmSettings.chkAddSavedToStreamIgnoreClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(chkAddSavedToStreamIgnore);
end;

procedure TfrmSettings.chkAdjustTrackOffsetClick(Sender: TObject);
begin
  inherited;

  txtAdjustTrackOffset.Enabled := chkAdjustTrackOffset.State <> cbUnchecked;
  optAdjustBackward.Enabled := chkAdjustTrackOffset.State <> cbUnchecked;
  optAdjustForward.Enabled := chkAdjustTrackOffset.State <> cbUnchecked;

  if FInitialized then
    RemoveGray(chkAdjustTrackOffset);
end;

procedure TfrmSettings.chkManualSilenceLevelClick(Sender: TObject);
begin
  inherited;

  txtSilenceLevel.Enabled := (not (chkManualSilenceLevel.State = cbUnchecked)) and (chkSearchSilence.State <> cbUnchecked);
  txtSilenceLength.Enabled := (not (chkManualSilenceLevel.State = cbUnchecked)) and (chkSearchSilence.State <> cbUnchecked);
  Label10.Enabled := (not (chkManualSilenceLevel.State = cbUnchecked)) and (chkSearchSilence.State <> cbUnchecked);
  Label14.Enabled := (not (chkManualSilenceLevel.State = cbUnchecked)) and (chkSearchSilence.State <> cbUnchecked);
  Label12.Enabled := (not (chkManualSilenceLevel.State = cbUnchecked)) and (chkSearchSilence.State <> cbUnchecked);
  Label13.Enabled := (not (chkManualSilenceLevel.State = cbUnchecked)) and (chkSearchSilence.State <> cbUnchecked);

  if FInitialized then
    RemoveGray(chkManualSilenceLevel);
end;

procedure TfrmSettings.chkMonitorModeClick(Sender: TObject);
begin
  inherited;

  Label20.Enabled := (chkMonitorMode.State <> cbUnchecked) or (chkSubmitStats.State <> cbUnchecked);
  txtMonitorCount.Enabled := (chkMonitorMode.State <> cbUnchecked) and (chkSubmitStats.State <> cbUnchecked);
end;

procedure TfrmSettings.chkAutoTuneInClick(Sender: TObject);
begin
  inherited;

  lstMinQuality.Enabled := chkAutoTuneIn.Checked;
  lstFormat.Enabled := chkAutoTuneIn.Checked;
  chkAutoTuneInConsiderIgnore.Enabled := chkAutoTuneIn.Checked;
  chkAutoTuneInAddToIgnore.Enabled := chkAutoTuneIn.Checked;
  chkAutoRemoveSavedFromWishlist.Enabled := chkAutoTuneIn.Checked;
end;

procedure TfrmSettings.chkOverwriteSmallerClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(chkOverwriteSmaller);
end;

procedure TfrmSettings.chkRemoveSavedFromWishlistClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(chkRemoveSavedFromWishlist);
end;

procedure TfrmSettings.chkDeleteStreamsClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(chkDeleteStreams);
end;

procedure TfrmSettings.chkDiscardAlwaysClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
  begin
    RemoveGray(chkDiscardAlways);

    FOptionChanging := True;

    if chkDiscardAlways.Checked then
    begin
      chkDiscardSmaller.Enabled := False;
      chkDiscardSmaller.Checked := False;
      chkOverwriteSmaller.Enabled := False;
      chkOverwriteSmaller.Checked := False;
    end else
    begin
      chkDiscardSmaller.Enabled := True;
      chkDiscardSmaller.Checked := FStreamSettings[0].DiscardSmaller;
      chkOverwriteSmaller.Enabled := True;
      chkOverwriteSmaller.Checked := FStreamSettings[0].OverwriteSmaller;
    end;

    FOptionChanging := False;
  end;
end;

procedure TfrmSettings.chkDiscardSmallerClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(chkDiscardSmaller);
end;

procedure TfrmSettings.chkLimitClick(Sender: TObject);
begin
  inherited;

  txtMaxSpeed.Enabled := chkLimit.Checked;
end;

procedure TfrmSettings.chkNormalizeVariablesClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(chkNormalizeVariables);
end;

procedure TfrmSettings.chkOnlyIfCutClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
    RemoveGray(lstPostProcess);

  if (lstPostProcess.Selected <> nil) and chkOnlyIfCut.Focused then
    TPostProcessBase(lstPostProcess.Selected.Data).OnlyIfCut := chkOnlyIfCut.Checked;
end;

procedure TfrmSettings.chkOnlySaveFullClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
  begin
    RemoveGray(chkOnlySaveFull);

    if (FSettingsType = stStream) and (Length(FStreamSettings) > 0) and (not FOptionChanging) then
      TfrmMsgDlg.ShowMsg(Self, _(WARNING_STREAMRECORDING),
                         mtInformation, [mbOK], mbOK, 5);
  end;
end;

procedure TfrmSettings.chkSeparateTracksClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
  begin
    RemoveGray(chkSeparateTracks);

    FOptionChanging := True;

    chkDeleteStreams.Enabled := chkSeparateTracks.Checked;
    chkDeleteStreams.Checked := chkSaveStreamsToDisk.Checked and FStreamSettings[0].DeleteStreams;

    chkOnlySaveFull.Enabled := chkSeparateTracks.Checked;
    chkOnlySaveFull.Checked := chkSeparateTracks.Checked and FStreamSettings[0].OnlySaveFull;

    pnlCut.Enabled := False;
    if (not chkSeparateTracks.Checked) or (not chkSaveStreamsToDisk.Checked) then
      chkDeleteStreams.Checked := False;

    FOptionChanging := False;

    Application.ProcessMessages;

    EnablePanel(pnlCut, (not chkSaveStreamsToDisk.Checked or (chkSeparateTracks.Checked and chkSeparateTracks.Enabled)) or (FSettingsType = stAuto));

    chkSkipShort.Enabled := (not chkSaveStreamsToDisk.Checked or (chkSeparateTracks.Checked and chkSeparateTracks.Enabled)) or (FSettingsType = stAuto);
    txtShortLengthSeconds.Enabled := chkSkipShort.Enabled and chkSkipShort.Checked;
    if (not chkSeparateTracks.Checked) or (not chkSaveStreamsToDisk.Checked) then
      chkSkipShort.Checked := False;
  end;
end;

procedure TfrmSettings.chkSaveStreamsToDiskClick(Sender: TObject);
begin
  inherited;

  if FInitialized then
  begin
    RemoveGray(chkSaveStreamsToDisk);

    chkSeparateTracks.Enabled := chkSaveStreamsToDisk.Checked;
    chkSeparateTracks.Checked := True;

    // Weil das hier drüber die Seite abschaltet, schalten wir sie wieder an..
    EnablePanel(pnlCut, (not chkSaveStreamsToDisk.Checked or (chkSeparateTracks.Checked and chkSeparateTracks.Enabled)) or (FSettingsType = stAuto));
    chkDeleteStreams.Enabled := (not chkSeparateTracks.Checked) or (chkSaveStreamsToDisk.Checked);
    chkDeleteStreams.Checked := chkDeleteStreams.Enabled and FStreamSettings[0].DeleteStreams;

    chkSkipShort.Enabled := (not chkSaveStreamsToDisk.Checked or (chkSeparateTracks.Checked and chkSeparateTracks.Enabled)) or (FSettingsType = stAuto);
    txtShortLengthSeconds.Enabled := chkSkipShort.Enabled and chkSkipShort.Checked;

    if (FSettingsType = stStream) and (Length(FStreamSettings) > 0) then
      TfrmMsgDlg.ShowMsg(Self, _(WARNING_STREAMRECORDING),
                         mtInformation, [mbOK], mbOK, 3);
  end;
end;

procedure TfrmSettings.chkSearchSilenceClick(Sender: TObject);
begin
  inherited;

  txtSilenceBufferSeconds.Enabled := chkSearchSilence.Checked;
  Label12.Enabled := chkSearchSilence.Checked;
  Label13.Enabled := chkSearchSilence.Checked;
  Label6.Enabled := chkSearchSilence.Checked;
  Label15.Enabled := chkSearchSilence.Checked;

  chkManualSilenceLevelClick(chkManualSilenceLevel);

  chkManualSilenceLevel.Enabled := chkSearchSilence.Checked;

  if FInitialized then
    RemoveGray(chkSearchSilence);
end;

procedure TfrmSettings.chkSkipShortClick(Sender: TObject);
begin
  inherited;
  txtShortLengthSeconds.Enabled := chkSkipShort.State <> cbUnchecked;
  Label4.Enabled := txtShortLengthSeconds.Enabled;

  if FInitialized then
    RemoveGray(chkSkipShort);
end;

procedure TfrmSettings.chkSubmitStatsClick(Sender: TObject);
begin
  inherited;

  //Label8.Enabled := chkSubmitStats.State <> cbUnchecked;
  chkMonitorMode.Enabled := chkSubmitStats.State <> cbUnchecked;

  Label20.Enabled := chkMonitorMode.Enabled;
  txtMonitorCount.Enabled := (chkMonitorMode.State <> cbUnchecked) and (chkSubmitStats.State <> cbUnchecked);
end;

procedure TfrmSettings.chkSubmitStreamInfoClick(Sender: TObject);
begin
  inherited;

  //Label2.Enabled := chkSubmitStreamInfo.State <> cbUnchecked;
end;

procedure TfrmSettings.chkTrayClick(Sender: TObject);
begin
  inherited;

  optClose.Enabled := chkTray.Checked;
  optMinimize.Enabled := chkTray.Checked;
end;

constructor TfrmSettings.Create(AOwner: TComponent; SettingsType: TSettingsTypes; StreamSettings: TStreamSettingsArray; BrowseDir: Boolean);
var
  i: Integer;
begin
  FSettingsType := SettingsType;

  FIgnoreFieldList := TList.Create;

  SetLength(FStreamSettings, Length(StreamSettings));
  for i := 0 to Length(StreamSettings) - 1 do
  begin
    FStreamSettings[i] := StreamSettings[i].Copy;
  end;

  case SettingsType of
    stApp:
      CreateApp(AOwner, BrowseDir);
    stAuto:
      CreateAuto(AOwner, BrowseDir);
    stStream:
      CreateStreams(AOwner);
  end;

  lblPanelCut.Caption := _('Settings for cutting are only available'#13#10'if ''Save separated tracks'' is enabled.');

  FInitialized := True;
end;

procedure TfrmSettings.CreateApp(AOwner: TComponent; BrowseDir: Boolean);
var
  i, Tmp: Integer;
  Item: TListItem;
begin
  FBrowseDir := BrowseDir;

  // Wir geben AOwner mit, so dass das MsgDlg zentriert angezeigt wird.
  // Self ist nämlich noch nicht Visible, haben kein Handle, etc..
  if not BrowseDir then
  begin
    TfrmMsgDlg.ShowMsg(TForm(AOwner), _('Settings from the categories "Streams", "Filenames", "Cut", "Postprocessing" and "Advanced" configured in the general settings window are only applied to new streams you add to the list.'#13#10 +
                                        'To change those settings for streams in the list, select these streams, then right-click one of them and select "Settings" from the popupmenu.'), mtInformation, [mbOK], mbOK, 4);
  end;

  inherited Create(AOwner, True);

  FillFields(FStreamSettings[0]);

  // Dateinamen ordentlich machen
  Tmp := txtStreamFilePattern.Top;
  txtAutomaticFilePattern.Visible := False;
  btnResetAutomaticFilePattern.Visible := False;
  txtStreamFilePattern.Top := txtAutomaticFilePattern.Top;
  btnResetStreamFilePattern.Top := btnResetAutomaticFilePattern.Top;
  txtPreview.Top := Tmp;
  lblFilePattern.Top := txtPreview.Top + txtPreview.Height + MulDiv(8, Screen.PixelsPerInch, 96);

  // Offseteinstellungen verstecken
  chkAdjustTrackOffset.Visible := False;
  txtAdjustTrackOffset.Visible := False;
  optAdjustBackward.Visible := False;
  optAdjustForward.Visible := False;

  for i := 0 to AppGlobals.AddonManager.Addons.Count - 1 do
  begin
    Item := lstAddons.Items.Add;
    Item.Caption := AppGlobals.AddonManager.Addons[i].Name;
    Item.Checked := AppGlobals.AddonManager.Addons[i].FilesExtracted;
    Item.Data := AppGlobals.AddonManager.Addons[i].Copy;

    Item.ImageIndex := 6;
  end;
  if lstAddons.Items.Count > 0 then
    lstAddons.Items[0].Selected := True;

  BuildHotkeys;

  if (Bass.DeviceAvailable) and (Bass.Devices.Count > 0) then
  begin
    for i := 0 to Bass.Devices.Count - 1 do
    begin
      if Bass.Devices[i].IsDefault then
        lstSoundDevice.Items.AddObject(_('Default device'), Bass.Devices[i])
      else
        lstSoundDevice.Items.AddObject(Bass.Devices[i].Name, Bass.Devices[i]);
    end;

    if lstSoundDevice.Items.Count > 0 then
      lstSoundDevice.ItemIndex := 0;

    try
      for i := 0 to lstSoundDevice.Items.Count - 1 do
        if TBassDevice(lstSoundDevice.Items.Objects[i]).ID = AppGlobals.SoundDevice then
        begin
          lstSoundDevice.ItemIndex := i;
          Break;
        end;
    except end;
  end else
  begin
    lstSoundDevice.Style := csDropDown;
    lstSoundDevice.ItemIndex := -1;
    lstSoundDevice.Enabled := False;
    lstSoundDevice.Text := _('(no devices available)');
  end;

  CreateGeneral;
end;

procedure TfrmSettings.CreateAuto(AOwner: TComponent; BrowseDir: Boolean);
var
  i: Integer;
begin
  FBrowseDir := BrowseDir;

  inherited Create(AOwner, False);

  FillFields(FStreamSettings[0]);

  lstBlacklist := TBlacklistTree.Create(Self, AppGlobals.Data.StreamBlacklist);
  lstBlacklist.OnChange := BlacklistTreeChange;
  lstBlacklist.OnKeyDown := BlacklistTreeKeyDown;
  lstBlacklist.Images := PngImageList1;
  lstBlacklist.Parent := pnlBlacklist;
  lstBlacklist.Align := alClient;

  // Werbung überspringen ausblenden
  chkSkipShort.Visible := False;
  txtShortLengthSeconds.Visible := False;
  Label4.Visible := False;

  // Offset setzen ausblenden
  chkAdjustTrackOffset.Visible := False;
  txtAdjustTrackOffset.Visible := False;
  optAdjustBackward.Visible := False;
  optAdjustForward.Visible := False;

  // Offseteinstellungen verstecken
  chkAdjustTrackOffset.Visible := False;
  txtAdjustTrackOffset.Visible := False;
  optAdjustBackward.Visible := False;
  optAdjustForward.Visible := False;

  // Dateinamen ordentlich machen
  for i := 0 to pnlFilenames.ControlCount - 1 do
    if ((pnlFilenames.Controls[i].ClassType = TLabeledEdit) or (pnlFilenames.Controls[i].ClassType = TPngSpeedButton))
       and (pnlFilenames.Controls[i].Top > txtDir.Top) then
    begin
      pnlFilenames.Controls[i].Visible := False;
    end;
  txtAutomaticFilePattern.Top := txtFilePattern.Top;
  txtAutomaticFilePattern.Visible := True;
  btnResetAutomaticFilePattern.Top := btnResetFilePattern.Top;
  btnResetAutomaticFilePattern.Visible := True;
  txtPreview.Top := txtIncompleteFilePattern.Top;
  txtPreview.Visible := True;
  lblFilePattern.Top := txtPreview.Top + txtPreview.Height + MulDiv(8, Screen.PixelsPerInch, 96);

  chkAutoTuneInAddToIgnore.Checked := FStreamSettings[0].AddSavedToIgnore;
  chkAutoRemoveSavedFromWishlist.Checked := FStreamSettings[0].RemoveSavedFromWishlist;

  Caption := _('Settings for automatic recordings');
  lblTop.Caption := _('Settings for automatic recordings');

  chkAutoTuneInClick(chkAutoTuneIn);

  CreateGeneral;
end;

procedure TfrmSettings.CreateStreams(AOwner: TComponent);
var
  i, Substract: Integer;
  Tmp: Integer;
  Item: TListItem;
begin
  inherited Create(AOwner, False);

  SetFields;
  FillFields(FStreamSettings[0]);

  CreateGeneral;

  txtDir.Visible := False;
  btnBrowse.Visible := False;

  Substract := chkSaveStreamsToDisk.Top;
  for i := 0 to pnlStreams.ControlCount - 1 do
  begin
    if pnlStreams.Controls[i].ClassType = TCheckBox then
      pnlStreams.Controls[i].Top := pnlStreams.Controls[i].Top - Substract;
  end;

  Substract := txtFilePattern.EditLabel.Top;
  for i := 0 to pnlFilenames.ControlCount - 1 do
  begin
    pnlFilenames.Controls[i].Top := pnlFilenames.Controls[i].Top - Substract;
  end;

  // Dateinamen ordentlich machen
  Tmp := txtStreamFilePattern.Top;
  txtAutomaticFilePattern.Visible := False;
  btnResetAutomaticFilePattern.Visible := False;
  txtStreamFilePattern.Top := txtAutomaticFilePattern.Top;
  btnResetStreamFilePattern.Top := btnResetAutomaticFilePattern.Top;
  txtPreview.Top := Tmp;
  lblFilePattern.Top := txtPreview.Top + txtPreview.Height + MulDiv(8, Screen.PixelsPerInch, 96);

  // Erweitert ordentlich machen
  lstSoundDevice.Visible := False;
  lblSoundDevice.Visible := False;
  txtLogFile.Visible := False;
  btnBrowseLogFile.Visible := False;

  btnReset := TBitBtn.Create(Self);
  btnReset.Parent := pnlNav;
  btnReset.Caption := _('A&pply general settings');
  btnReset.OnClick := btnResetClick;

  for i := 0 to FStreamSettings[0].RegExes.Count - 1 do
  begin
    Item := lstRegExes.Items.Add;
    Item.Caption := FStreamSettings[0].RegExes[i];
    Item.ImageIndex := 7;
  end;

  for i := 0 to FStreamSettings[0].IgnoreTrackChangePattern.Count - 1 do
  begin
    Item := lstIgnoreTitles.Items.Add;
    Item.Caption := FStreamSettings[0].IgnoreTrackChangePattern[i];
    Item.ImageIndex := 1;
  end;

  Caption := _('Stream settings');
  lblTop.Caption := _('Stream settings');
end;

procedure TfrmSettings.CreateGeneral;
var
  i: Integer;
  B: TBitmap;
  P: TPngImage;
begin
  for i := 0 to Self.ControlCount - 1 do
  begin
    if Self.Controls[i] is TPanel then
    begin
      if TPanel(Self.Controls[i]) = pnlLeft then
        Continue;
      Self.Controls[i].Left := 96;
      Self.Controls[i].Top := 36;
      TPanel(Self.Controls[i]).BevelOuter := bvNone;
    end;
  end;

  B := TBitmap.Create;
  P := TPngImage.Create;
  try
    P.LoadFromResourceName(HInstance, 'ARROWUP');
    btnMoveUp.PngImage := P;
    P.LoadFromResourceName(HInstance, 'ARROWDOWN');
    btnMoveDown.PngImage := P;
    P.LoadFromResourceName(HInstance, 'QUESTION');
    btnHelpPostProcess.PngImage := P;
    P.LoadFromResourceName(HInstance, 'CONFIGURE');
    btnConfigureEncoder.PngImage := P;

    btnBrowse.PngImage := modSharedData.imgImages.PngImages[85].PngImage;
    btnBrowseApp.PngImage := modSharedData.imgImages.PngImages[85].PngImage;
    btnBrowseLogFile.PngImage := modSharedData.imgImages.PngImages[85].PngImage;
  finally
    B.Free;
    P.Free;
  end;

  btnConfigureEncoder.Enabled := lstOutputFormat.ItemIndex > 0;
end;

{ TBlacklistTree }

constructor TBlacklistTree.Create(AOwner: TComponent; Streams: TStringList);
var
  i: Integer;
  Node: PVirtualNode;
  NodeData: PBlacklistNodeData;
begin
  inherited Create(AOwner);

  NodeDataSize := SizeOf(TBlacklistNodeData);
  IncrementalSearch := isVisibleOnly;
  Header.Options := [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible];
  TreeOptions.SelectionOptions := [toMultiSelect, toRightClickSelect, toFullRowSelect];
  TreeOptions.AutoOptions := [toAutoScrollOnExpand];
  TreeOptions.PaintOptions := [toThemeAware, toHideFocusRect];
  TreeOptions.MiscOptions := TreeOptions.MiscOptions - [toAcceptOLEDrop];
  Header.Options := Header.Options + [hoAutoResize];
  Header.Options := Header.Options - [hoDrag];
  Header.AutoSizeIndex := 0;
  Header.Height := GetTextSize('Wyg', Font).cy + 6;
  DragMode := dmManual;
  ShowHint := True;
  HintMode := hmTooltip;

  for i := 0 to Streams.Count - 1 do
  begin
    Node := AddChild(nil);
    NodeData := GetNodeData(Node);
    NodeData.Name := Streams[i];
  end;

  FColTitle := Header.Columns.Add;
  FColTitle.Text := _('Name');

  Sort(nil, 0, Header.SortDirection);

  Header.SortColumn := 0;
  Header.SortDirection := sdAscending;
end;

destructor TBlacklistTree.Destroy;
begin

  inherited;
end;

procedure TBlacklistTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var Text: UnicodeString);
var
  NodeData: PBlacklistNodeData;
begin
  inherited;

  if TextType = ttNormal then
  begin
    NodeData := GetNodeData(Node);
    case Column of
      0: Text := NodeData.Name;
    end;
  end;
end;

function TBlacklistTree.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean;
  var Index: Integer): TCustomImageList;
begin
  Result := inherited;

  if Column = 0 then
    Index := 1;
end;

procedure TBlacklistTree.DoHeaderClick(HitInfo: TVTHeaderHitInfo);
begin
  inherited;
  if HitInfo.Button = mbLeft then
  begin
    if Header.SortColumn <> HitInfo.Column then
    begin
      Header.SortColumn := HitInfo.Column;
      Header.SortDirection := sdAscending;
    end else
    begin
      if Header.SortDirection = sdAscending then
        Header.SortDirection := sdDescending
      else
        Header.SortDirection := sdAscending;
    end;
    Sort(nil, HitInfo.Column, Header.SortDirection);
  end;
end;

function TBlacklistTree.DoIncrementalSearch(Node: PVirtualNode;
  const Text: string): Integer;
var
  S: string;
  NodeData: PBlacklistNodeData;
begin
  S := Text;
  NodeData := GetNodeData(Node);
  Result := StrLIComp(PChar(S), PChar(NodeData.Name),
    Min(Length(S), Length(NodeData.Name)));
end;

procedure TBlacklistTree.DoMeasureItem(TargetCanvas: TCanvas;
  Node: PVirtualNode; var NodeHeight: Integer);
begin
  inherited;

  NodeHeight := GetTextSize('Wyg', Font).cy + 6;
end;

procedure TBlacklistTree.RemoveSelected;
var
  Node, Node2: PVirtualNode;
begin
  Node := GetLast;
  BeginUpdate;
  while Node <> nil do
  begin
    if Selected[Node] then
    begin
      Node2 := GetPrevious(Node);
      DeleteNode(Node);
      Node := Node2;
    end else
      Node := GetPrevious(Node);
  end;
  EndUpdate;
end;

procedure TBlacklistTree.UpdateList(List: TStringList);
var
  Node: PVirtualNode;
  NodeData: PBlacklistNodeData;
begin
  List.Clear;

  Node := GetLast;
  BeginUpdate;
  while Node <> nil do
  begin
    NodeData := GetNodeData(Node);
    List.Add(NodeData.Name);
    Node := GetPrevious(Node);
  end;
  EndUpdate;
end;

function TBlacklistTree.DoCompare(Node1, Node2: PVirtualNode;
  Column: TColumnIndex): Integer;
  function CmpTime(a, b: TDateTime): Integer;
  begin
    if a > b then
      Result := 1
    else if a < b then
      Result := -1
    else
      Result := 0;
  end;
var
  ND1, ND2: PBlacklistNodeData;
begin
  Result := 0;

  ND1 := GetNodeData(Node1);
  ND2 := GetNodeData(Node2);
  case Column of
    0: Result := CompareText(ND1.Name, ND2.Name);
  end;
end;

procedure TBlacklistTree.DoFreeNode(Node: PVirtualNode);
begin
  Finalize(PBlacklistNodeData(GetNodeData(Node)).Name);

  inherited;
end;

end.
