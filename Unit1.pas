unit Unit1;

interface

//{$DEFINE KOSTYL}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DSPack, DirectShow9, StdCtrls, ActiveX, DSUtil, Menus,
  ExtCtrls, ComCtrls, Buttons, ImgList, Subtitles, ComObj, Misc, cef, ceflib,
  Dictionaries, shellapi, OleServer, SpeechLib_TLB, XPMan, ShellCtrls,
  Inifiles, jpeg, AppEvnts, Constants, DirectVobSub, EVR9;

type
  PPlayListItem = ^TPlayListItem;
  TPlayListItem = record
    Filename : String;
    Path : String;
  end;

  TfrmMain = class(TForm)
    FilterGraph1: TFilterGraph;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuOpenFile: TMenuItem;
    mnuExit: TMenuItem;
    Panel1: TPanel;
    sbPlay: TSpeedButton;
    sbPause: TSpeedButton;
    sbStop: TSpeedButton;
    ImageList1: TImageList;
    sbFullscreen: TSpeedButton;
    sbColorControl: TSpeedButton;
    pmVideoController: TPopupMenu;
    Play1: TMenuItem;
    Pause1: TMenuItem;
    Stop1: TMenuItem;
    N1: TMenuItem;
    Fullscreen1: TMenuItem;
    Panel3: TPanel;
    ColorControl1: TMenuItem;
    N2: TMenuItem;
    SoundLevel: TTrackBar;
    Label3: TLabel;
    ImageList2: TImageList;
    splitFileList: TSplitter;
    pmFiles: TPopupMenu;
    mnuAddFile: TMenuItem;
    mnuRemoveFile: TMenuItem;
    mnuClearFiles: TMenuItem;
    View1: TMenuItem;
    mnuAspectRatio: TMenuItem;
    mnuStretched: TMenuItem;
    mnuLetterBox: TMenuItem;
    mnuCrop: TMenuItem;
    sbPrev: TSpeedButton;
    sbNext: TSpeedButton;
    pnlFiles: TPanel;
    lbFiles: TListBox;
    sbDesktopView: TSpeedButton;
    N3: TMenuItem;
    Exit2: TMenuItem;
    cbMonitors: TComboBox;
    DSTrackBar1: TDSTrackBar;
    Label2: TLabel;
    Bevel1: TBevel;
    test1: TMenuItem;
    tmrCheckSubs: TTimer;
    mnuVobsubs: TMenuItem;
    Audio1: TMenuItem;
    mnuStreams: TMenuItem;
    Button1: TButton;
    SpVoice1: TSpVoice;
    mnuSpeech: TMenuItem;
    StatusBar1: TStatusBar;
    est1: TMenuItem;
    command21: TMenuItem;
    XPManifest1: TXPManifest;
    Opensubtitles1: TMenuItem;
    N4: TMenuItem;
    OpenSubtitlesDialog: TOpenDialog;
    command41: TMenuItem;
    txtSubDelay: TEdit;
    Label1: TLabel;
    tmrLoading: TTimer;
    chromiumUI: TChromium;
    tmrUpdateUIControls: TTimer;
    Subtitles1: TMenuItem;
    tmrCheckCommandline: TTimer;
    mnuOpenNext: TMenuItem;
    DSVideoWindowEx1: TPanel;
    txtVideoWindowFocusHolder: TEdit;
    imgLoading: TImage;
    chromiumPhrase: TChromium;
    chromiumMueller: TChromium;
    tmrHideCursor: TTimer;
    tmrWindowActive: TTimer;
    procedure mnuOpenFileClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DSVideoWindowEx1ColorKeyChanged(Sender: TObject);
    procedure sbPlayClick(Sender: TObject);
    procedure sbPauseClick(Sender: TObject);
    procedure sbStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbFullscreenClick(Sender: TObject);
    procedure sbColorControlClick(Sender: TObject);
    procedure DSTrackBar1Timer(sender: TObject; CurrentPos,
      StopPos: Cardinal);
    procedure SoundLevelChange(Sender: TObject);
    procedure CheckColorControlSupport;
    procedure pmFilesPopup(Sender: TObject);
    procedure mnuAddFileClick(Sender: TObject);
    procedure lbFilesDblClick(Sender: TObject);
    procedure PlayFile(Filename : String);
    procedure FilterGraph1GraphComplete(sender: TObject; Result: HRESULT;
      Renderer: IBaseFilter);
    procedure mnuStretchedClick(Sender: TObject);
    procedure mnuLetterBoxClick(Sender: TObject);
    procedure mnuCropClick(Sender: TObject);
    procedure sbDesktopViewClick(Sender: TObject);
    procedure pmVideoControllerPopup(Sender: TObject);
    procedure sbNextClick(Sender: TObject);
    procedure sbPrevClick(Sender: TObject);
    procedure mnuClearFilesClick(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure FilterGraph1DSEvent(sender: TComponent; Event, Param1,
      Param2: Integer);
    procedure DSVideoWindowEx1OverlayVisible(Sender: TObject;
      Visible: Boolean);
    procedure mnuVobsubsClick(Sender: TObject);
    procedure chromiumMuellerJsAlert(Sender: TCustomChromium;
      const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring; out Result: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chromiumMuellerBeforeMenu(Sender: TCustomChromium;
      const browser: ICefBrowser; const menuInfo: PCefHandlerMenuInfo;
      out Result: Boolean);
    procedure chromiumMuellerKeyEvent(Sender: TCustomChromium;
      const browser: ICefBrowser; event: TCefHandlerKeyEventType; code,
      modifiers: Integer; isSystemKey: Boolean; out Result: Boolean);
    procedure command21Click(Sender: TObject);
    procedure chromiumMuellerConsoleMessage(Sender: TCustomChromium;
      const browser: ICefBrowser; message, source: ustring; line: Integer;
      out Result: Boolean);
    procedure Opensubtitles1Click(Sender: TObject);
    procedure DSVideoWindowEx1MouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure command41Click(Sender: TObject);
    procedure tmrCheckSubsTimer(Sender: TObject);
    procedure txtSubDelayChange(Sender: TObject);
    procedure txtSubDelayKeyPress(Sender: TObject; var Key: Char);
    procedure chromiumMuellerAfterCreated(Sender: TCustomChromium;
      const browser: ICefBrowser);
    procedure DSVideoWindowEx1MouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure chromiumPhraseAfterCreated(Sender: TCustomChromium;
      const browser: ICefBrowser);
    procedure tmrLoadingTimer(Sender: TObject);
    procedure txtVideoWindowFocusHolderKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure DSVideoWindowEx1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chromiumUIAfterCreated(Sender: TCustomChromium;
      const browser: ICefBrowser);
    procedure tmrUpdateUIControlsTimer(Sender: TObject);
    procedure Subtitles1Click(Sender: TObject);
    procedure FilterGraph1GraphBufferingData(sender: TObject;
      Buffering: Boolean);
    procedure tmrCheckCommandlineTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DSVideoWindowEx1DblClick(Sender: TObject);
    procedure mnuOpenNextClick(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure DSVideoWindowEx1Resize(Sender: TObject);
    procedure DSVideoWindowEx1Exit(Sender: TObject);
    procedure tmrHideCursorTimer(Sender: TObject);
    procedure tmrWindowActiveTimer(Sender: TObject);
    procedure DSVideoWindowEx1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FSubDelay: Integer;
    FSubSpeedMul: Integer;
    FSubSpeedDiv: Integer;
    FQuickWordIndex: Integer;
    FWordCountInList: Integer;
    FPhraseTranslated: Boolean;
    FPhraseSubtitle: string;
    FFormCaption: string;
    FIgnoreKeyboard: Boolean;
    FCommandlineChecked: Boolean;
    FPrevWindowLeft: Integer;
    FPrevWindowTop: Integer;
    FPrevWindowWidth: Integer;
    FPrevWindowHeight: Integer;
    FEnhancedFullScreen: Boolean;
    FSubtitlesHidden: Boolean;
    FDisplayControl: IMFVideoDisplayControl;
    FEVR: IBaseFilter;
    FCanUpdateVideoSize: Boolean;
    FMainWindowActive: Boolean;
    procedure AddAudioStreamsToMenu(bDisconnectAfterFirst: Boolean = False);
    procedure mnuAudioStreamClick(Sender: TObject);
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
    function HandleKeyPress(code: Integer): Boolean;
    procedure mnuSpeechClick(Sender: TObject);
    procedure CheckSubs;
    procedure UpdateDelayFromDVobSub;
    function SetSubDelay(delay: Integer): Boolean;
    function ShowWordTranslationByNum(num: Integer): Boolean;
    procedure ParsePhraseToBottom;
    procedure HOOKKEYDOWN(var msg: TMessage); message WM_HOOKKEYDOWN;
    procedure HOOKKEYUP(var msg: TMessage); message WM_HOOKKEYUP;
    procedure SeekWithSlider(const pos: Integer);
    procedure ManagePlayPause;
    procedure ShowPhraseInBottom;
    procedure HidePhraseInBottom;
    procedure SwitchToStream(const activeStreamName: String;
      bRestartEverything: Boolean = True);
    function GetVobSubFilter: IDirectVobSub;
    procedure SetupEVR;
    procedure UpdateVideoSize;
  public
    { Public declarations }
    FOsdChanged : Boolean;
    FPlayListItem : PPlayListItem;
    FPlayingIndex : Integer;
    FSubtitles: TSrtSubtitles;
    FBrowser: ICefBrowser;
    FPhraseBrowser: ICefBrowser;
    FOldSubIndex: Integer;
    FVoices: ISpeechObjectTokens;
    FAliases: TSimpleAliasList;
    FPhrasesBrowserLoaded: Boolean;
    FMainBrowserLoaded: Boolean;
    FCanOpenFile: Boolean;
    FUIBrowser: ICefBrowser;
    FIMediaSeek: IMediaSeeking;
    FUIBrowserLoaded: Boolean;
    FTemp: Boolean;
    procedure SeekBack();
    procedure SeekForward();
    procedure ChangePosition(diff: Int64);
    procedure SetVideoPosition(pp: Int64);
    function GetVideoPosition(var p: Int64): Boolean;
    procedure UpdateUIControls;
    procedure CheckCommandlineArguments;
    procedure SwitchEnhancedFullScreen;
    function ShowSubtitles(const show: Boolean): Boolean;
    function SwitchSubtitlesVisibility: Boolean;
    function OpenFileUI(filenames: TStrings): Boolean;
    procedure OpenNextFile;
    procedure ShowCursorOnVideo;
    procedure HideCursorOnVideo;
  end;

var
  frmMain: TfrmMain;
  sRootDir: String;
  temp: Integer;

implementation

uses ColorControl, JS_HTML_Code, CefExtension_Translate,
  Translate, StrUtils, uMkvExtractor;

{$R *.dfm}

{$IFDEF KOSTYL}
procedure SetHook(hCaller, hParent: HWND); stdcall; external 'Hook.dll';
procedure ReleaseHook; external 'Hook.dll';
{$ENDIF}

function TfrmMain.OpenFileUI(filenames: TStrings): Boolean;
var
  i : Integer;
begin
  lbFiles.Items.Clear;
  lbFiles.Sorted := True;
  // Now go thru every files selected in the opendialog and add
  // them one by one to the Players playlist.
  // The first file added to the players playlist will loaded
  // automaticly
  for i := filenames.Count - 1 downto 0 do
  begin
    New(FPlayListItem);
    FPlayListItem^.Filename := ExtractFilename(filenames[i]);
    FPlayListItem^.Path := ExtractFilePath(filenames[i]);
    lbFiles.Items.AddObject(FPlayListItem^.Filename, TObject(FPlayListItem));
  end;

  Caption := FFormCaption + ' - ' + FPlayListItem^.Filename;

  //refresh dialog's filename
  OpenDialog1.FileName := filenames[0];

  lbFiles.ItemIndex := 0;
  PlayFile(filenames[0]);
  FPlayingIndex := 0;
end;

procedure TfrmMain.mnuOpenFileClick(Sender: TObject);
var
  i: Integer;
begin
  if NOT FCanOpenFile then
    Exit;
    
  FCanOpenFile := False;
  
  // The Add file to playerlist was selected.
  if OpenDialog1.Execute then
  begin
    i := 0;
    //wait while browsers are loading
    while (NOT FPhrasesBrowserLoaded OR NOT FMainBrowserLoaded) do
    begin
      Sleep(500);
      Inc(i);
      Application.ProcessMessages;
      if (i >= TIME_WAIT_UNTIL_LOAD) then
      begin
        FCanOpenFile := True;
        Exit;
      end;
    end;

    FCanOpenFile := True;

    OpenFileUI(OpenDialog1.Files);
  end else
    FCanOpenFile := True;


  if FPlayingIndex < lbFiles.Items.Count -1 then
    sbNext.Enabled := True;


end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  //clear graph before exit
  FilterGraph1.ClearGraph;

  FilterGraph1.Active := false;
  Close;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ini: TIniFile;
  voice: String;
  i: Integer;
begin
  //mnuExitClick(nil)
  try
    if FTranslatedWords.Count > 0 then
    begin
      FTranslatedWords.SaveToFile(sRootDir + FILENAME_TRANSLATED);
    end;
  except
  end;


  ini := nil;
  try
    ini := TIniFile.Create(sRootDir + FILENAME_SETTINGS);

    voice := '';
    for i := 0 to mnuSpeech.Count - 1 do
      if mnuSpeech.Items[i].Checked then
      begin
        voice := mnuSpeech.Items[i].Caption;
        break;
      end;

    if voice <> '' then
      ini.WriteString(INI_VOICE_SECTION, INI_VOICE_NAME, voice);
  
  except
  end;

  if ini <> nil then
    ini.Free;

  {$IFDEF KOSTYL}
  ReleaseHook;
  {$ENDIF}
end;

procedure TfrmMain.DSVideoWindowEx1ColorKeyChanged(Sender: TObject);
begin
  //set colorkey for volume control
  {if DSVideoWindowEx1.OverlayVisible then
  begin
    ImageList2.BkColor := DSVideoWindowEx1.ColorKey;
  end
  else
  begin
    ImageList2.BkColor := DSVideoWindowEx1.Color;
  end;}
end;

procedure TfrmMain.sbPlayClick(Sender: TObject);
begin

  if not FilterGraph1.Active then
    mnuOpenFileClick(nil)
  else
    FilterGraph1.Play;
    
  CheckColorControlSupport;
end;

procedure TfrmMain.sbPauseClick(Sender: TObject);
begin
  FilterGraph1.Pause;
end;

procedure TfrmMain.sbStopClick(Sender: TObject);
begin
  FilterGraph1.Stop;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: Integer;
  ss: TStringList;
  Item: TMenuItem;
  ini: TIniFile;
  savedVoiceName: String;
  selected: Boolean;
begin
  FUIBrowserLoaded := False;
  FIMediaSeek := nil;
  FIgnoreKeyboard := False;
  FFormCaption := Caption;
  FPhrasesBrowserLoaded := False;
  FMainBrowserLoaded := False;
  FCanOpenFile := True;
  FCommandlineChecked := False;
  FEnhancedFullScreen := False;
  FCanUpdateVideoSize := True;

  FPhraseTranslated := False;
  FBrowser := nil;
  FPhraseBrowser := nil;
  FUIBrowser := nil;
  FPhraseSubtitle := '';

  //init delay with 0
  FSubDelay := 0;

  //load last selected TTS voice name
  savedVoiceName := '';

  try ini := TIniFile.Create(sRootDir + FILENAME_SETTINGS);
    savedVoiceName :=
      ini.ReadString(INI_VOICE_SECTION, INI_VOICE_NAME, '');
  finally
    if nil <> ini then ini.Free;
  end;


  //assign images to buttons
  Imagelist1.GetBitmap(3, sbPlay.Glyph);
  Imagelist1.GetBitmap(2, sbPause.Glyph);
  Imagelist1.GetBitmap(4, sbStop.Glyph);
  Imagelist1.GetBitmap(9, sbFullscreen.Glyph);
  Imagelist1.GetBitmap(8, sbDesktopView.Glyph);
  Imagelist1.GetBitmap(0, sbPrev.Glyph);
  Imagelist1.GetBitmap(6, sbNext.Glyph);

  //define aspect ratio
  {case DSVideoWindowEx1.AspectRatio of
    rmStretched : mnuStretched.Checked := True;
    rmLetterBox : mnuLetterBox.Checked := True;
    rmCrop      : mnuCrop.Checked := True;
  end;}
  
  //add monitors
  cbMonitors.Items.Add('Current Monitor');
  if Screen.MonitorCount > 1 then
  begin
    for I := 0 to Screen.MonitorCount - 1 do
      cbMonitors.Items.Add('Monitor'+inttostr(I));
    cbMonitors.Enabled := True;
  end;
  cbMonitors.ItemIndex := 0;

  //get root path
  sRootDir := ExtractFilePath(Application.ExeName);

  //get mkvtoolnix path
  uMkvExtractor.mkvtoolnix_path := sRootDir + uMkvExtractor.mkvtoolnix_path;

  //init global vars
  FSubtitles := nil;
  FOldSubIndex := -1;
  FTranslatedWords := TStringList.Create;

  if FileExists(sRootDir + FILENAME_TRANSLATED) then
    FTranslatedWords.LoadFromFile(sRootDir + FILENAME_TRANSLATED);

  //load and index dictionaries
  FMuellerDic := TStringList.Create;
  FPrefDic := TStringList.Create;
  FPostDic := TStringList.Create;
  ss := TStringList.Create;
  FFreqDict := TWordDictionary.Create;
  FMuellerIndex := TWordDictionary.Create;

  FMuellerDic.LoadFromFile(sRootDir + DIR_DIC + FILENAME_MUELLER_DICT);
  FPrefDic.LoadFromFile(sRootDir + DIR_DIC + FILENAME_PREF_DICT);
  FPostDic.LoadFromFile(sRootDir + DIR_DIC + FILENAME_POST_DICT);
  ss.LoadFromFile(sRootDir + DIR_DIC + FILENAME_FREQ_DICT);

  //indexing frequency dictionary
  try
    for i := 0 to ss.Count - 1 do
      FFreqDict.Add(ss[i], i);
  finally
    ss.Free;
  end;

  ss := TStringList.Create;
  try
    ss.LoadFromFile(sRootDir + DIR_DIC + FILENAME_ADDITIONAL_DICT);
    FMuellerDic.AddStrings(ss);
  finally
    ss.Free;
  end;

  //indexing mueller base dictionary
  for i := 0 to FMuellerDic.Count - 1 do
    if FMuellerDic[i] = DIC_SEPARATOR then
      FMuellerIndex.Add(FMuellerDic[i + 2], i + 2);

  // get voices
  selected := False;
  FVoices := SpVoice1.GetVoices('', '');
  for i := 0 to FVoices.Count - 1 do
  begin
    Item := TMenuItem.Create(mnuSpeech);
    Item.Caption := ExtractFileName(FVoices.Item(i).Id);
    Item.Tag := i;
    Item.GroupIndex := 2;
    Item.RadioItem := True;
    Item.AutoCheck := True;
    Item.OnClick := mnuSpeechClick;

    //set voice to saved
    if (savedVoiceName = Item.Caption) then
    begin
      spVoice1.Voice := FVoices.Item(i);
      Item.Checked := True;
      selected := True;
    end;

    mnuSpeech.Add(Item);
  end;

  if NOT selected then
  try
    for i := 0 to FVoices.Count - 1 do
    begin
      if spVoice1.Voice.Id = FVoices.Item(i).Id then
        mnuSpeech.Items[i].Checked := True;
    end;
  except
  end;  
  
  //set to last voice
  {mnuSpeech.Items.Find(spVoice1.Voice.Id
  if (spVoice1.Voice = nil) AND (mnuSpeech.Count > 0) then
  begin
    mnuSpeech.Items[mnuSpeech.Count - 1].Checked := True;
    spVoice1.Voice := FVoices.Item(FVoices.Count - 1);
  end;}

  //set voice rate to "not fast"
  SpVoice1.Rate := -5;

  //set background color for video window
  DSVideoWindowEx1.Color := COLOR_VIDEOWINDOW_BACKGROUND;

  //load aliases for words
  FAliases := TSimpleAliasList.Create;
  try
    FAliases.LoadFromFile(sRootDir + DIR_DIC + FILENAME_ALIAS_DICT,
      DELIMITER_ALIAS);
  except
  end;

  //add extention filter to open file dialog
  OpenDialog1.Filter := Format('All supported files (%s)|%s',
    [STR_EXTENTIONS, STR_EXTENTIONS]);

  {$IFDEF KOSTYL}
  SetHook(Handle, Application.Handle);
  {$ENDIF}
end;

procedure TfrmMain.sbFullscreenClick(Sender: TObject);
begin
  //Windows.Beep(4000, 100);
  (*try
    if DSVideoWindowEx1.FullScreen then
    begin
      {try
        txtVideoWindowFocusHolder.SetFocus;
        Windows.Beep(1000, 100);
      except
      end;
      Application.ProcessMessages;}

      DSVideoWindowEx1.NormalPlayback;

    end else
    begin
      //start fullscreen mode on selected monitor
      if cbMonitors.ItemIndex > 0 then
        DSVideoWindowEx1.StartFullScreen(Screen.Monitors[cbMonitors.Itemindex -1])
      else
        DSVideoWindowEx1.StartFullScreen;

    end;
  except
  end;

  sbFullscreen.Down := DSVideoWindowEx1.FullScreen;
  *)
end;

procedure TfrmMain.sbColorControlClick(Sender: TObject);
begin
  ColorControlForm.Show;
end;

procedure TfrmMain.DSTrackBar1Timer(sender: TObject; CurrentPos,
  StopPos: Cardinal);
var
  CurrPos : Int64;
  Value, H, M, S : Integer;
  MediaSeeking: IMediaSeeking;
  cur, dur: Int64;
  i: Integer;
begin
    if (FIMediaSeek <> nil) then
    begin
      if SUCCEEDED(FIMediaSeek.GetPositions(cur, dur)) then
        if SUCCEEDED(FIMediaSeek.GetDuration(dur)) then
        begin
          i := ((cur * UI_SLIDER_MAX) div dur);
          FUIBrowser.GetMainFrame.ExecuteJavaScript(
            Format(JS_CODE_UI_SET_SLIDERPOS, [i]), '', 0);

          FUIBrowser.GetMainFrame.ExecuteJavaScript(
            Format(JS_CODE_UI_SET_CURPOS, [ConvertDSTimeUnitsToText(cur)]), '', 0);

        end;

    end;

  Exit;

  //get video position and output it
  FilterGraph1.QueryInterface(IMediaSeeking, MediaSeeking);
  with MediaSeeking do
  begin
    GetCurrentPosition(CurrPos);
    Value := Trunc(CurrPos / 10000000);
    H := value div 3600;
    M := (value mod 3600) div 60;
    S := (value mod 3600) mod 60;
    StatusBar1.Panels[0].Text := Format('%d:%2.2d:%2.2d', [H, M, S]);
  end;

  // osd changed (sound volume)
  {if FOsdChanged then
  begin
    DSVideoWindowEx1.ClearBack;
    FOsdChanged := False;
  end;}
  
end;

procedure TfrmMain.SoundLevelChange(Sender: TObject);
var
  tmp : TBitmap;
begin
  {//sound changed = draw/redraw sound level on video window
  tmp := TBitmap.Create;
  Imagelist2.GetBitmap(0, tmp);
  FilterGraph1.Volume := SoundLevel.Position;

  //draw empty
  DSVideoWindowEx1.Canvas.CopyRect(
    Rect(10,
      DSVideoWindowEx1.Height - 65,
      218,
      DSVideoWindowEx1.Height - 27),
    tmp.Canvas,
    Rect(0, 0, 104, 23));

  Imagelist2.GetBitmap(1, tmp);

  //draw filled
  DSVideoWindowEx1.Canvas.CopyRect(
    Rect(10,
      DSVideoWindowEx1.Height - 65,
      10 + Trunc((104 / 10000) * SoundLevel.Position) * 2,
      DSVideoWindowEx1.Height - 27),
    tmp.Canvas,
    Rect(0,
      0,
      Trunc((104 / 10000) * SoundLevel.Position),
      23));

  tmp.Free;

  //set osd changed flag
  FOsdChanged := True;}
end;

procedure TfrmMain.CheckColorControlSupport;
begin
  sbColorControl.Enabled := True;
  ColorControl1.Enabled := True;
end;

procedure TfrmMain.pmFilesPopup(Sender: TObject);
begin
  //check availability of menu items
  if lbFiles.ItemIndex <> -1 then
    mnuRemoveFile.Enabled := True
  else
    mnuRemoveFile.Enabled := False;
  if lbFiles.Items.Count > 0 then
    mnuClearFiles.Enabled := True
  else
    mnuClearFiles.Enabled := False;
end;

procedure TfrmMain.mnuAddFileClick(Sender: TObject);
var
  i : Integer;
begin
  if lbFiles.Items.Count < 1 then
  begin
    //if no files in list
    mnuOpenFileClick(nil);
    sbPrev.Enabled := False;
    sbNext.Enabled := False;
    Exit;
  end;

  if OpenDialog1.Execute then
  begin
    with OpenDialog1.Files do
      // Now go thru every files selected in the opendialog and add
      // them one by one to the Players playlist.
      // The first file added to the players playlist will loaded
      // automaticly
      for I := Count - 1 downto 0 do
      begin
        New(FPlayListItem);
        FPlayListItem^.Filename := ExtractFilename(Strings[I]);
        FPlayListItem^.Path := ExtractFilePath(Strings[I]);
        lbFiles.Items.AddObject(FPlayListItem^.Filename, TObject(FPlayListItem));
      end;
  end;

  //check availability of prev/next buttons
  if FPlayingIndex > 0 then
    sbPrev.Enabled := True;
  if FPlayingIndex < lbFiles.Items.Count -1 then
    sbNext.Enabled := True;
end;

procedure TfrmMain.lbFilesDblClick(Sender: TObject);
var
  Filename : String;
begin
  //play file on dbl click on list

  //exit if already playing
  if lbFiles.ItemIndex = FPlayingIndex then Exit;

  //get path and filename
  FPlayListItem := PPlayListItem(lbFiles.Items.Objects[lbFiles.Itemindex]);
  Filename := FPlayListItem^.Path;

  if Filename[Length(Filename)] <> '\' then
    Filename := Filename + '\';
    
  Filename := Filename + FPlayListItem^.Filename;

  //play file
  PlayFile(Filename);
  FPlayingIndex := lbFiles.Itemindex;

  //set availability of prev/next buttons
  if FPlayingIndex > 0 then
    sbPrev.Enabled := True
  else
    sbPrev.Enabled := False;
  if FPlayingIndex < lbFiles.Items.Count -1 then
    sbNext.Enabled := True
  else
    sbNext.Enabled := False;
end;

procedure TfrmMain.PlayFile(Filename : String);
var
  subname: String;
  path: String;
  waysubs: TStringList;
  subs: String;
  bFound: Boolean;
  i: Integer;
  dur: Int64;
  NR: TNormalizedRect;
  R: TRect;
  hr: HRESULT;
begin
  FilterGraph1.ClearGraph;

  // --------------------------------------------------------------------------------------
  // This is a workaround the problem that we don't always get the EC_CLOCK_CHANGED.
  // and because we didn't get the EC_CLOCK_CHANGED the DSTrackbar and DSVideoWindowEx1
  // didn't got reassigned and that returned in misfuntions.
  FilterGraph1.Active := False;
  FilterGraph1.Active := True;
  // --------------------------------------------------------------------------------------

  SetupEVR();

  FilterGraph1.RenderFile(FileName);
  SoundLevel.Position := FilterGraph1.Volume;
  AddAudioStreamsToMenu(true);
  FilterGraph1.Play;

  FIMediaSeek := nil;
  FIMediaSeek := (FilterGraph1 as IMediaSeeking);

  if (FIMediaSeek <> nil) then
  begin
    if (FUIBrowser <> nil) AND (FUIBrowserLoaded) then
    begin
      if SUCCEEDED(FIMediaSeek.GetDuration(dur)) then
      begin
        FUIBrowser.GetMainFrame.ExecuteJavaScript(
          Format(JS_CODE_UI_SET_DURATION,[ConvertDSTimeUnitsToText(dur)]), '', 0);
      end;
    end;
  end;
  
  CheckColorControlSupport;

  //create subtitles class if empty
  if (FSubtitles = nil) then
  begin
    FSubtitles := TSrtSubtitles.Create;
  end;

  try
    //load subtitle
    path := ExtractFilePath(FileName);
    subname := ExtractFileName(Filename);
    subname := Copy(subname, 1, LastDelimiter('.', subname) - 1);

    waysubs := TStringList.Create;
    try
      waysubs.Add('%s%s.srt');
      waysubs.Add('%s\subtitle\%s.srt');
      waysubs.Add('%s\subtitles\%s.srt');
      waysubs.Add('%s\english\%s.srt');
      waysubs.Add('%s\eng\%s.srt');
      waysubs.Add('%s%s.eng.srt');
      waysubs.Add('%s%s.en.srt');
      waysubs.Add('%s%s.sub.eng.srt');
      waysubs.Add('%s%s.eng.sub.srt');

      subs := '';
      bFound := False;

      for i := 0 to waysubs.Count - 1 do
      begin
        subs := Format(waysubs[i], [path, subname]);
        if FileExists(subs) then
        begin
          bFound := True;
          Break;
        end;
      end;

    finally
      waysubs.Free;
    end;

    if bFound then
    begin
      FSubtitles.LoadFromFile(subs);
      chromiumMueller.Visible := True;
    end
    else
    begin
      //try to extract subtitles from matroska mkv
      if AnsiLowerCase(ExtractFileExt(filename)) = '.mkv' then
      begin

      end;


      FSubtitles.Clear;
      chromiumMueller.Visible := False;
    end;


  except
  end;

  UpdateDelayFromDVobSub;

  //hide mueller tool
  chromiumMueller.Visible := False;
end;

procedure TfrmMain.FilterGraph1GraphComplete(sender: TObject;
  Result: HRESULT; Renderer: IBaseFilter);
var
  Filename : String;
begin
  //play next file if available
  if FPlayingIndex < lbFiles.Items.Count -1 then
  begin
    //get filename and path
    lbFiles.ItemIndex := lbFiles.ItemIndex +1;
    FPlayListItem := PPlayListItem(lbFiles.Items.Objects[lbFiles.ItemIndex]);
    Filename := FPlayListItem^.Path;
    if Filename[Length(Filename)] <> '\' then
      Filename := Filename + '\';
    Filename := Filename + FPlayListItem^.Filename;

    //play it
    PlayFile(Filename);
    FPlayingIndex := lbFiles.Itemindex;
  end;

  //set prev/next buttons availablity
  //TODO: rafactor in one proc/func all these shitty repeating pieces
  if FPlayingIndex > 0 then
    sbPrev.Enabled := True
  else
    sbPrev.Enabled := False;
  if FPlayingIndex < lbFiles.Items.Count -1 then
    sbNext.Enabled := True
  else
    sbNext.Enabled := False;
end;

procedure TfrmMain.mnuStretchedClick(Sender: TObject);
begin
  {DSVideoWindowEx1.AspectRatio := rmStretched;}
end;

procedure TfrmMain.mnuLetterBoxClick(Sender: TObject);
begin
  {DSVideoWindowEx1.AspectRatio := rmLetterBox;}
end;

procedure TfrmMain.mnuCropClick(Sender: TObject);
begin
  {DSVideoWindowEx1.AspectRatio := rmCrop;}
end;

procedure TfrmMain.sbDesktopViewClick(Sender: TObject);
begin
  //TODO: remove all code related to desktop playback
 { if not DSVideoWindowEx1.DesktopPlayback then
  begin
    //play on selected monitor
    if cbMonitors.ItemIndex > 0 then
      DSVideoWindowEx1.StartDesktopPlayback(Screen.Monitors[cbMonitors.Itemindex -1])
    else
      DSVideoWindowEx1.StartDesktopPlayback;
  end
  else
    DSVideoWindowEx1.NormalPlayback;}
end;

procedure TfrmMain.pmVideoControllerPopup(Sender: TObject);
begin
  {FullScreen1.Checked := DSVideoWindowEx1.FullScreen;}
end;

procedure TfrmMain.sbNextClick(Sender: TObject);
var
  Filename : String;
begin
  if FPlayingIndex < lbFiles.Items.Count - 1 then
  begin
    //TODO: refactor all this repeating code into one proc/func
    //get filename and path
    lbFiles.ItemIndex := lbFiles.ItemIndex +1;
    FPlayListItem := PPlayListItem(lbFiles.Items.Objects[lbFiles.ItemIndex]);
    Filename := FPlayListItem^.Path;
    if Filename[Length(Filename)] <> '\' then
      Filename := Filename + '\';
    Filename := Filename + FPlayListItem^.Filename;

    //play it
    PlayFile(Filename);
    FPlayingIndex := lbFiles.Itemindex;
  end;

  //check availability of prev/next buttons
  if FPlayingIndex > 0 then
    sbPrev.Enabled := True
  else
    sbPrev.Enabled := False;
  if FPlayingIndex < lbFiles.Items.Count -1 then
    sbNext.Enabled := True
  else
    sbNext.Enabled := False;
end;

procedure TfrmMain.sbPrevClick(Sender: TObject);
var
  Filename : String;
begin
  //omg not again. See sbNextClick func comments
  if FPlayingIndex > 0 then
  begin
    lbFiles.ItemIndex := lbFiles.ItemIndex -1;
    FPlayListItem := PPlayListItem(lbFiles.Items.Objects[lbFiles.ItemIndex]);
    Filename := FPlayListItem^.Path;
    if Filename[Length(Filename)] <> '\' then
      Filename := Filename + '\';
    Filename := Filename + FPlayListItem^.Filename;
    PlayFile(Filename);
    FPlayingIndex := lbFiles.Itemindex;
  end;
  if FPlayingIndex > 0 then
    sbPrev.Enabled := True
  else
    sbPrev.Enabled := False;
  if FPlayingIndex < lbFiles.Items.Count -1 then
    sbNext.Enabled := True
  else
    sbNext.Enabled := False;
end;

procedure TfrmMain.mnuClearFilesClick(Sender: TObject);
begin
  //clear files
  //BUG: should we free pFPlayListItem(s) from lbFiles first? O_o
  FilterGraph1.Stop;
  FilterGraph1.ClearGraph;
  FilterGraph1.Active := False;
  lbFiles.Items.Clear;
end;

procedure TfrmMain.Exit2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FilterGraph1DSEvent(sender: TComponent; Event, Param1,
  Param2: Integer);
begin
  //graph eventhandler for debugging purposes
  //Memo1.Lines.Add(GetEventCodeDef(event));
end;

procedure TfrmMain.DSVideoWindowEx1OverlayVisible(Sender: TObject;
  Visible: Boolean);
begin
  {if Visible then
    pnlTimer.Color := DSVideoWindowEx1.ColorKey
  else
    pnlTimer.Color := DSVideoWindowEx1.Color;}
end;

procedure TfrmMain.CheckSubs;

  function Compare(List: TStringList; Index1, Index2: Integer): Integer;
  //*  compare function for subtitle-word sort purposes  */
  var x, y: Integer;
  begin
    x := Integer(List.Objects[Index1]);
    y := Integer(List.Objects[Index2]);
    if (x < 0) then
      x := High(Integer);
    if (y < 0) then
      y := High(Integer);
    Result := y - x;    
  end;

var
  CurrPos : Int64;
  Value: Integer;
  MediaSeeking: IMediaSeeking;
  sub: String;
  subIndex: Integer;
  i, u, c: Integer;
  s, t: String;
  ss: TStringList;
  tagged: Boolean;
begin
  {if FilterGraph1.State <> gsPlaying then
    Exit;}

  //exit if no subtitles
  if nil = FSubtitles then
    Exit;

  //get media seeking interface  
  FilterGraph1.QueryInterface(IMediaSeeking, MediaSeeking);
  if nil = MediaSeeking then
    Exit;

  with MediaSeeking do
  begin
    //get current position in 100-nanoseconds units
    GetCurrentPosition(CurrPos);

    //transform it to milliseconds
    Value := Trunc(CurrPos / 10000) - FSubDelay;
    
    //StatusBar1.Panels[0].Text  := Format('Pos: %f', [Value / 1000]);

    //get subtitle index for current time
    subIndex := FSubtitles.GetTextForTime(Value, sub);

    //if same as previous then exit
    if subIndex = FOldSubIndex then
      Exit;

    //save index
    FOldSubIndex := subIndex;

    //exit if empty/invisible subtitle
    if Trim(sub) = '' then
      Exit;

    //replace two-char doublequotes into one-char
    sub := AnsiReplaceStr(sub, '''''', '"') + ' ';
    //sub := sub + ' ';

    //for phrase browser
    FPhraseSubtitle := sub;
    FPhraseTranslated := False;

    //create and setup string list class
    ss := TStringList.Create;
    try
      ss.Sorted := True;
      ss.Duplicates := dupIgnore;

      //tagged flag for subtitle tags like <i> </i>
      tagged := False;

      i := 0;
      while i < Length(sub) do
      begin
        Inc(i);

        //do not add tags to subtitle list
        if ('<' = sub[i]) then
          tagged := True
        else if '>' = sub[i] then
        begin
          tagged := False;
          Continue;
        end;

        if tagged then
          Continue;

        //latin letters and single quote (')
        if (sub[i] in ['A'..'Z', 'a'..'z', '''']) then
          s := s + sub[i]
        else
        begin
          //else complete word

          //if word not empty or invisible
          if (Trim(s) <> '') AND (Trim(s) <> '''')  then
          begin
            //find possible alias for word from alias list
            t := FAliases.FindAlias(s);
            if '' = t then
              ss.Add(AnsiLowerCase(s))
            else
            begin
              //if found - add alias to the end of subtitle
              //it will be parsed afterwards
              //WARNING: infinite cycle possible
              sub := sub + t + ' ';
            end;
            s := '';
          end;
        end;

      end;

      //set sorted to false
      //because it won't able to change words in the list
      ss.Sorted := False;
      i := 0;

      //add frequency place to objects of string list
      while i < ss.Count do
      begin
        c := FFreqDict.Find(ss[i]);
        if c < 0 then
        begin
          //find single quote (')
          u := Pos('''', ss[i]);
          if u > 0 then
          begin
            //if found get letter after it
            t := Copy(ss[i], u + 1, Length(ss[i]));
            if 's' = t then
            begin
              //truncate word
              //"everything's" become "everything"
              ss[i] := Copy(ss[i], 1, u - 1);
              c := FFreqDict.Find(ss[i]);
            end;
          end;
        end;
        ss.Objects[i] := Pointer(c);
        Inc(i);
      end;

      //custom sort with respect to frequency of every word
      ss.CustomSort(@Compare);
      //ss.Sort;
      c := 0;

      //clear word list in browser
      FBrowser.GetMainFrame.ExecuteJavaScript(JS_CODE_CLEAR, '', 0);

      //add new
      for i := 0 to ss.Count - 1 do
      begin
        t := Format(JS_CODE_APPEND_MASK, [EscapeHtmlChars(ss[i]), WORD_COLORS[c]]);
        FBrowser.GetMainFrame.ExecuteJavaScript(t, '', 0);
        Inc(c);
        if c > High(WORD_COLORS) then
          c := 0;
      end;

      // save word count
      FWordCountInList := ss.Count;
      
    finally
      ss.Free;
    end;

    //bind JS event handlers to newly added words 
    FBrowser.GetMainFrame.ExecuteJavaScript(JS_CODE_REGISTER_EVENTS, '', 0);

    //clear quick word index
    FQuickWordIndex := 0;

    if chromiumPhrase.Visible then
      ParsePhraseToBottom;
  end;

end;

procedure TfrmMain.mnuVobsubsClick(Sender: TObject);
var
  vobfil: IBaseFilter;
  pEnum: IEnumFilters;
  pInfo: _FilterInfo;
  pPage: ISpecifyPropertyPages;
  pUnk: IUnknown;
  IID_IUnknown: TGuid;
  caGUID: CAUUID;
  classid: TGUID;
begin
  //display vobsub filter property page
  try
    (FilterGraph1 as IGraphBuilder).EnumFilters(pEnum);
  except
    Exit;
  end;

  vobfil := nil;

  //enum all filters in the graph
  if (pEnum <> nil) then
  begin
    while SUCCEEDED(pEnum.Next(1, vobfil, nil)) do
    begin
      if nil = vobfil then
        Break;

      vobfil.QueryFilterInfo(pInfo);
      //compare name
      if Pos(STR_FILTERNAME_VOBSUB, pInfo.achName) > 0 then
        Break;
    end;
  end;


  if vobfil <> nil then
  begin


    vobfil.QueryInterface(IID_ISpecifyPropertyPages, pPage);
    IID_IUnknown := IUnknown;
    vobfil.QueryInterface(IID_IUnknown, pUnk);
    pPage.GetPages(caGUID);
    //pPage._Release;

    OleCreatePropertyFrame(
        Handle,                   // Parent window
        0, 0,                     // Reserved
        pInfo.achName,            // Caption for the dialog box
        1,                        // Number of objects (just the filter)
        @pUnk,                    // Array of object pointers.
        caGUID.cElems,            // Number of property pages
        caGUID.pElems,            // Array of property page CLSIDs
        0,                        // Locale identifier
        0, nil                    // Reserved
    );
    CoTaskMemFree(caGUID.pElems);
    UpdateDelayFromDVobSub;
  end;
end;

procedure TfrmMain.AddAudioStreamsToMenu(bDisconnectAfterFirst: Boolean = False);
var
  baseFilter: IBaseFilter;
  pEnum: IEnumFilters;
  pInfo: _FilterInfo;
  pPinEnum: IEnumPins;
  pPin: IPin;
  Item: TMenuItem;
  bFirst: Boolean;
  i: Integer;
begin
  //simple proc that enumerates directsound renderer filters
  //and adds it to menu

  mnuStreams.Clear;
  bFirst := True;

  (FilterGraph1 as IGraphBuilder).EnumFilters(pEnum);

  baseFilter := nil;

  i := 0;

  //enum filters
  if (pEnum <> nil) then
  begin
    while SUCCEEDED(pEnum.Next(1, baseFilter, nil)) do
    begin
      Inc(i);

      if nil = baseFilter then
        Break;

      baseFilter.QueryFilterInfo(pInfo);
      //compare filter name
      if Pos(STR_FILTERNAME_DIRECTSOUND, pInfo.achName) > 0 then
      begin
        //add to menu
        Item := TMenuItem.Create(mnuStreams);
        Item.AutoHotkeys := maManual;
        Item.Caption := pInfo.achName;

        Item.GroupIndex := 1;
        Item.RadioItem := True;

        if bFirst then
        begin
          bFirst := False;
          //Item.Checked := True;
        end;
        Item.OnClick := mnuAudioStreamClick;
        mnuStreams.Add(Item);

        //disconnect all filters except first one
        if bDisconnectAfterFirst then
        begin
          if i = DS_ENGLISH_STREAM_NUM then
          begin
            //check first one
            Item.Checked := True;
          end else
          begin
            //disconnect others

            try
              baseFilter.EnumPins(pPinEnum);
              if nil <> pPinEnum then
              begin
                while SUCCEEDED(pPinEnum.Next(1, pPin, nil)) do
                begin
                  if nil = pPin then
                    Break;

                  //disconnect
                  pPin.Disconnect;

                end;
              end;

            except
              //ShowMessage('An error was encountered while switching audio streams');
            end;
            
          end;

        end;

      end;
    end;
  end;

end;

procedure TfrmMain.mnuAudioStreamClick(Sender: TObject);
var
  activeStreamName: String;
begin
  if NOT (Sender is TMenuItem) then
    Exit;

  TMenuItem(Sender).Checked := True;
  activeStreamName := TMenuItem(Sender).Caption;

  SwitchToStream(activeStreamName);

end;

procedure TfrmMain.chromiumMuellerJsAlert(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame;
  const message: ustring; out Result: Boolean);
var
  pref: String;
  body: String;
  param: String;
  i: Integer;
  dur, cur: Int64;
begin
  //JS code may call alert to pass an event to application
  //should contain prefix and body
  Result := False;
  i := Pos(':', message);
  if i < 0 then
    Exit;

  //get prefix and boy of alert message  
  pref := Copy(message, 1, i);
  body := Copy(message, i + 1, Length(message));

  //open browser
  if ALERT_PREFIX_GOTO = pref then
  begin
    ShellExecute(Handle, 'open', PChar(body), nil, nil, SW_SHOW);
    Result := True;
    Exit;
  end;

  //speak with TTS
  if ALERT_PREFIX_SPEAK = pref then
  begin
    SpVoice1.Speak(body, SVSFlagsAsync);
    Result := True;
    Exit;
  end;

  //notification
  if ALERT_PREFIX_NOTIFICATION = pref then
  begin
    if (body = NOTIFICATION_PHRASE) then
    begin
      FPhrasesBrowserLoaded := True;

      //when app goes to fullscreen
      //browser changes his parrent by
      //destroying self and recreating in new parent control
      //so we need to reparse subtitle and show in browser
      if FPhraseTranslated then
      begin
        FPhraseTranslated := False;
        ParsePhraseToBottom;
      end;

    end else if (body = NOTIFICATION_MAIN) then
      FMainBrowserLoaded := True
    else if (body = NOTIFICATION_UI) then
      FUIBrowserLoaded := True;

    //check command line arguments when browsers are loaded
    if (FMainBrowserLoaded AND FUIBrowserLoaded AND FPhrasesBrowserLoaded) then
      tmrCheckCommandline.Enabled := True;  

    Result := True;
    Exit;
  end;

  //implemented in JS code
  {if ALERT_PREFIX_FIND = pref then
  begin
    t := Translate.getFormattedTranslation(body);
    if Pos('''', t) > 0 then
      ShowMessage('O');
    FBrowser.GetMainFrame.ExecuteJavaScript('setPage(''' + t + ''');', '', 0);
    Result := RV_HANDLED;
    Exit;
  end;}

  if ALERT_PREFIX_EVENT = pref then
  begin
    i := Pos('(', body);
    if i <= 0 then
      Exit;
    param := Copy(body, i + 1, Pos(')', body) - i - 1);
    body := Copy(body, 1, i - 1);

    if body = EVENT_PLAY then
    begin
      FilterGraph1.Play;
    end else
    if body = EVENT_PAUSE then
    begin
      FilterGraph1.Pause;
    end else if body = EVENT_SEEK then
    begin
      i := StrToInt(param);
      SeekWithSlider(i);
    end else if body = EVENT_VOLUME then
    begin
      i := StrToInt(param);
      FilterGraph1.Volume := i * 100;
    end else if body = EVENT_SLIDERCHANGE then
    begin
      i := StrToInt(param);
      if (FIMediaSeek <> nil) then
      begin
        if SUCCEEDED(FIMediaSeek.GetDuration(dur)) then
        begin
          if (FUIBrowser <> nil) AND (FUIBrowserLoaded) then
          begin
            cur := dur * i div UI_SLIDER_MAX;
            FUIBrowser.GetMainFrame.ExecuteJavaScript(
              Format(JS_CODE_UI_SET_CURPOS2, [ConvertDSTimeUnitsToText(cur)]), '', 0);
          end;    

        end;
      end;
    end;


    Result := True;
    Exit;
  end;


end;

procedure TfrmMain.SeekBack;
var
  i, o: Integer;
  p: Int64;
  start, ends, time: Integer;
begin
  //seek to previous subtitle

  if NOT (GetVideoPosition(p)) then
    Exit;

  //calculate current time in milliseconds
  time := p div VIDEO_UNITS_IN_ONE_MILLISECOND - FSubDelay;

  // check if previous subtitle index is saved or not 
  if FOldSubIndex < 0 then
    i := FSubtitles.GetLastIndexForTime(time)
  else
    i := FOldSubIndex;

  if (i < 0) then
    Exit;

  //get end time for current subtitle
  ends := FSubtitles.GetTimeForIndex(i, False);

  //if subtitle still showing then go to previous
  //TODO: check i for negative
  if (ends >= time) then
    Dec(i);

  o := FSubtitles.GetTimeForIndex(i) + FSubDelay;
  if o >= 0 then
    SetVideoPosition(Int64(o) * VIDEO_UNITS_IN_ONE_MILLISECOND +
      SUBTITLE_SEEK_PREFIX_TIME);

  StatusBar1.Panels[1].Text := Format('Seek to %f seconds from %f (#%d))',
    [o / 1000, (time) / 1000, i]);

end;

procedure TfrmMain.SeekForward;
var
  i, j, o: Integer;
  p: Int64;
  time: Integer;
begin
  //seek forward to next subtitle
  if NOT (GetVideoPosition(p)) then
    Exit;

  time := p div VIDEO_UNITS_IN_ONE_MILLISECOND - FSubDelay;

  if FOldSubIndex < 0 then
    i := FSubtitles.GetLastIndexForTime(time)
  else
    i := FOldSubIndex;

  if (i < 0) then
    Exit;

  
  //seek forward until next sub reached
  //possibly may cause stucks
  j := 0;
  repeat
    Inc(j);
    o := FSubtitles.GetTimeForIndex(i + j);
    if (o < 0) then
      Break;
  until (time < o);

  o := o + FSubDelay;

  (*
  //permanently increase class global var FOldSubIndex
  Inc(FOldSubIndex);
  o := FSubtitles.GetTimeForIndex(FOldSubIndex) +  + FSubDelay;
  *)

  if o >= 0 then
    SetVideoPosition(Int64(o) * VIDEO_UNITS_IN_ONE_MILLISECOND);

  StatusBar1.Panels[1].Text := Format('Seek to %f seconds from %f (#%d))',
    [o / 1000, (time) / 1000, i + 1]);
    
end;

procedure TfrmMain.ChangePosition(diff: Int64);
var
  MediaSeeking: IMediaSeeking;
  pos, stop: Int64;
begin
  //changes video position (relative)
  
  FilterGraph1.QueryInterface(IMediaSeeking, MediaSeeking);
  if nil = MediaSeeking then
    Exit;

  with MediaSeeking do
  begin
    MediaSeeking.GetPositions(pos, stop);
    pos := pos + diff;
    MediaSeeking.SetPositions(pos, AM_SEEKING_AbsolutePositioning, diff,
      AM_SEEKING_NoPositioning);
  end;
end;

procedure TfrmMain.CMDialogKey(var Msg: TWMKey);
begin
  {if NOT HandleKeyPress(Msg.CharCode) then
    inherited;}
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if txtSubDelay.Focused then
    Exit;

  {$IFNDEF KOSTYL}
  if HandleKeyPress(Key) then
    Key := 0;
  {$ENDIF}

end;

procedure TfrmMain.chromiumMuellerBeforeMenu(Sender: TCustomChromium;
  const browser: ICefBrowser; const menuInfo: PCefHandlerMenuInfo;
  out Result: Boolean);
begin
  Result := True;
end;

procedure TfrmMain.chromiumMuellerKeyEvent(Sender: TCustomChromium;
  const browser: ICefBrowser; event: TCefHandlerKeyEventType; code,
  modifiers: Integer; isSystemKey: Boolean; out Result: Boolean);
begin
  {$IFNDEF KOSTYL}
  Result := HandleKeyPress(code);
  {$ENDIF}
end;

function TfrmMain.HandleKeyPress(code: Integer): Boolean;
begin
  Result := True;
  case code of
    VK_RETURN:
    begin
      {txtVideoWindowFocusHolder.SetFocus;
      Application.ProcessMessages;
      sbFullscreenClick(sbFullscreen);}
      SwitchEnhancedFullScreen;
    end;

    VK_SPACE, VK_NUMPAD0, Ord('W'): ManagePlayPause;

    VK_NUMPAD4, VK_NUMPAD1, VK_NUMPAD7,
      Ord('Q'), Ord('A'): SeekBack();     //seek to prev subtitle pos

    VK_NUMPAD6, VK_NUMPAD3, VK_NUMPAD9,
      Ord('E'), Ord('D'): SeekForward();  //seek to next subtitle pos

    VK_LEFT: ChangePosition(-TIME_DIFF_REWIND *
      VIDEO_UNITS_IN_ONE_MILLISECOND);     //seek few seconds back

    VK_RIGHT: ChangePosition(TIME_DIFF_FORWARD *
      VIDEO_UNITS_IN_ONE_MILLISECOND);    //seek few seconds forward

    VK_NUMPAD2:
      begin
        //show translation by index
        if (FQuickWordIndex < FWordCountInList) then
          Inc(FQuickWordIndex);
        ShowWordTranslationByNum(FQuickWordIndex);
      end;

    VK_NUMPAD8:
      begin
        //show translation by index
        if (FQuickWordIndex > 0) then
          Dec(FQuickWordIndex);
        ShowWordTranslationByNum(FQuickWordIndex);
      end;

    VK_ADD:
      begin
        SetSubDelay(FSubDelay + 1000);
      end;

    VK_SUBTRACT:
      begin
        SetSubDelay(FSubDelay - 1000);
      end;

    VK_DECIMAL:
      begin
        SwitchSubtitlesVisibility();
      end;

    VK_F2:
      begin
        OpenNextFile;
      end;

    Ord('0')..Ord('9'): ShowWordTranslationByNum(code - Ord('0'));  //open words by pressing 0-9 keyboard buttons
  else
    Result := False;
  end;

end;

procedure TfrmMain.mnuSpeechClick(Sender: TObject);
begin
  //change voice engine
  SpVoice1.Voice := FVoices.Item(TMenuItem(Sender).Tag);
  //test it
  SpVoice1.Speak('Hello!', SVSFlagsAsync);

  TMenuItem(Sender).Checked := True;
end;

function TfrmMain.GetVideoPosition(var p: Int64): Boolean;
var
  MediaSeeking: IMediaSeeking;
begin
  //return current video position in 100-nanosecond units
  Result := False;
  FilterGraph1.QueryInterface(IMediaSeeking, MediaSeeking);
  if nil = MediaSeeking then
    Exit;

  Result := SUCCEEDED(MediaSeeking.GetCurrentPosition(p));
  //Caption := Format('%d sec', [p div VIDEO_UNITS_IN_ONE_MILLISECOND]);
end;

procedure TfrmMain.SetVideoPosition(pp: Int64);
var
  MediaSeeking: IMediaSeeking;
begin
  //sets current vidio position
  FilterGraph1.QueryInterface(IMediaSeeking, MediaSeeking);
  if nil = MediaSeeking then
    Exit;

  with MediaSeeking do
  begin
    MediaSeeking.SetPositions(pp, AM_SEEKING_AbsolutePositioning, pp,
      AM_SEEKING_NoPositioning);
  end;

  //refresh subtitles
  tmrCheckSubs.OnTimer(tmrCheckSubs);
end;

procedure TfrmMain.command21Click(Sender: TObject);
begin
  FBrowser.GetMainFrame.ExecuteJavaScript('loadPage()', '', 0);
end;

procedure TfrmMain.chromiumMuellerConsoleMessage(Sender: TCustomChromium;
  const browser: ICefBrowser; message, source: ustring; line: Integer;
  out Result: Boolean);
var
  msg, src: String;
begin
 
  msg := EscapeInvalidChars(message);
  src := EscapeInvalidChars(source);
  //track JS/HTML errors
  ShowMessage(Format('В этой программе опять что-то пошло не так: %s (%s line #%d)',
    [String(msg), String(src), line]));
  Result := True;  
end;

procedure TfrmMain.Opensubtitles1Click(Sender: TObject);
begin

  if OpenSubtitlesDialog.Execute then
  begin
    //create subtitles class if empty
    if (FSubtitles = nil) then
    begin
      FSubtitles := TSrtSubtitles.Create;
    end;

    FSubtitles.LoadFromFile(OpenSubtitlesDialog.FileName)

  end;

end;

procedure TfrmMain.DSVideoWindowEx1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //seek between subtitles using mouse
  if Button = mbRight then
    if FSubtitles <> nil then
    begin
      if (x >= DSVideoWindowEx1.Width div 2) then
        SeekBack()
      else
        SeekForward();
    end;
end;

procedure TfrmMain.command41Click(Sender: TObject);
var
  vob: IDirectVobSub;
  vobfil: IBaseFilter;
  pEnum: IEnumFilters;
  pInfo: _FilterInfo;
  delay, speedmul, speeddiv: Integer;
  hr: HRESULT;
begin
  //display vobsub filter property page
  try
    (FilterGraph1 as IGraphBuilder).EnumFilters(pEnum);
  except
    Exit;
  end;

  vobfil := nil;

  //enum all filters in the graph
  if (pEnum <> nil) then
  begin
    while SUCCEEDED(pEnum.Next(1, vobfil, nil)) do
    begin
      if nil = vobfil then
        Break;

      vobfil.QueryFilterInfo(pInfo);
      //compare name
      if Pos(STR_FILTERNAME_VOBSUB, pInfo.achName) > 0 then
        Break;
    end;
  end;


  if vobfil <> nil then
  begin
    vob := nil;
    vobfil.QueryInterface(IID_IDirectVobSub, vob);
    if vob = nil then
    begin
      ShowMessage('second filter not found');
      Exit;
    end;

    delay := 0;
    speedmul := 0;
    speeddiv := 0;
    hr := vob.get_SubtitleTiming(delay, speedmul, speeddiv);
    if FAILED(hr) then
    begin
      ShowMessage(GetErrorString(hr));
    end;
    ShowMessage(IntToStr(delay));
  end;

end;

procedure TfrmMain.tmrCheckSubsTimer(Sender: TObject);
begin
  CheckSubs();
end;

procedure TfrmMain.UpdateDelayFromDVobSub;
var
  vob: IDirectVobSub;
  delay, speedmul, speeddiv: Integer;
begin
  try
    vob := FindFilter(FilterGraph1 as IGraphBuilder,
      CLSID_DVobSubAutoLoadingVersion) as IDirectVobSub;
    if (vob = nil) then
    begin
      //ShowMessage('Cannot find vobsub filter (no subs or invalid subtitle file?)');
      delay := 0;
      speedmul := 0;
      speeddiv := 0;
    end else
      vob.get_SubtitleTiming(delay, speedmul, speeddiv);
  except
    delay := 0;
    speedmul := 0;
    speeddiv := 0;
  end;

  FSubDelay := delay;
  FSubSpeedMul := speedmul;
  FSubSpeedDiv := speeddiv;

  txtSubDelay.Text := IntToStr(delay);
  txtSubDelay.Font.Color := clGray;
  txtSubDelay.Font.Style := [fsBold];
end;

procedure TfrmMain.txtSubDelayChange(Sender: TObject);
begin
  txtSubDelay.Font.Color := clBlack;
  txtSubDelay.Font.Style := [];
end;

procedure TfrmMain.txtSubDelayKeyPress(Sender: TObject; var Key: Char);
var
  i: Integer;
begin
  if (Key = Chr(VK_RETURN)) then
  begin
    if TryStrToInt(Trim(txtSubDelay.Text), i) then
    begin
      if (SetSubDelay(i)) then
      begin
        Key := #0;
        txtSubDelay.Font.Color := clGray;
        txtSubDelay.Font.Style := [fsBold];
        try
          txtVideoWindowFocusHolder.SetFocus;
        finally
        end;  
      end;
      
    end;
  end;
end;

function TfrmMain.SetSubDelay(delay: Integer): Boolean;
var
  vob: IDirectVobSub;
  filter: IBaseFilter;
  builder: IGraphBuilder;
begin
  Result := False;
  try
    vob := GetVobSubFilter;
    if (nil <> vob) then
      vob.put_SubtitleTiming(delay, FSubSpeedMul, FSubSpeedDiv);
  finally
    FSubDelay := delay;
    CheckSubs();
    Result := True;
  end;
end;

function TfrmMain.ShowWordTranslationByNum(num: Integer): Boolean;
begin
  //open scrolls with translations by pressing 1-0 buttons

  //pass 0 as 9
  if num = 0 then num := 9
    else num := num - 1;

  // call JS script JS_CODE_SHOW_WORD_BY_NUM
  FBrowser.GetMainFrame.ExecuteJavaScript(
    UString(Format(JS_CODE_SHOW_WORD_BY_NUM, [num])), '', 0);
end;

procedure TfrmMain.chromiumMuellerAfterCreated(Sender: TCustomChromium;
  const browser: ICefBrowser);
begin

  //save browser interface pointer
  FBrowser := browser;

  //register translation extention
  //for future calls from JS code to native code
  if NOT (CefRegisterExtension('v8/translation', JS_CODE_INIT2,
    TCefTranslateExtension.Create as ICefV8Handler)) then
    ShowMessage('Error on CefRegisterExtension :(');

  //execute initialization code
  browser.GetMainFrame.ExecuteJavaScript(JS_CODE_INIT1, '', 0);

  //navigate to demo.html
  browser.GetMainFrame.LoadUrl(ExtractFilePath(ParamStr(0)) +
    '\template2\demo.html');

end;

procedure TfrmMain.DSVideoWindowEx1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ShowCursorOnVideo;
  tmrHideCursor.Enabled := False;
  tmrHideCursor.Enabled := True;

  if (FPhraseSubtitle = '') then
    Exit;

  if (FilterGraph1.State = gsPaused) then
    Exit;

  try
    if (y > DSVideoWindowEx1.Height - chromiumPhrase.Height) then
      ShowPhraseInBottom
    else
      HidePhraseInBottom;
  except
  end;

  

end;

procedure TfrmMain.chromiumPhraseAfterCreated(Sender: TCustomChromium;
  const browser: ICefBrowser);
begin
  FPhraseBrowser := browser;
  FPhrasesBrowserLoaded := False;

  //navigate to phrase.html
  browser.GetMainFrame.LoadUrl(ExtractFilePath(ParamStr(0)) +
    '\template2\phrase.html');


end;

procedure TfrmMain.ParsePhraseToBottom;
var
  i: Integer;
  ss: TStringList;
begin
  if FPhraseTranslated then
    Exit;

  if (FPhraseBrowser <> nil) then
  begin
    ss := TStringList.Create;
    try
      ExplodeToWords(FPhraseSubtitle, ss);
      FPhraseBrowser.GetMainFrame.ExecuteJavaScript(JS_CODE_CLEAR, '', 0);
      for i := 0 to ss.Count - 1 do
      begin
        FPhraseBrowser.GetMainFrame.ExecuteJavaScript(
          Format(JS_CODE_APPEND_PHRASEWORD, [ss[i]]), '', 0);
      end;

      //add translate all button at the end of phrase
      FPhraseBrowser.GetMainFrame.ExecuteJavaScript(JS_CODE_ADD_TRANSLATE_ALL_BUTTON,
         '', 0);
      FPhraseBrowser.GetMainFrame.ExecuteJavaScript(JS_CODE_REGISTER_EVENTS,
         '', 0);
     finally
       ss.Free;
     end;
    FPhraseTranslated := True;
  end;

end;

procedure TfrmMain.tmrLoadingTimer(Sender: TObject);
begin
  imgLoading.Visible := (NOT FMainBrowserLoaded OR NOT FPhrasesBrowserLoaded);
  tmrLoading.Enabled := imgLoading.Visible;
end;

procedure TfrmMain.txtVideoWindowFocusHolderKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  {$IFNDEF KOSTYL}
  if HandleKeyPress(Key) then
    Key := 0;
  {$ENDIF}
end;

procedure TfrmMain.DSVideoWindowEx1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$IFNDEF KOSTYL}
  if HandleKeyPress(Key) then
    Key := 0;
  {$ENDIF}
end;

procedure TfrmMain.HOOKKEYDOWN(var msg: TMessage);
var
    bResult: boolean;
    wnd: HWND;
    threadInfo: tagGUITHREADINFO;
begin
  msg.Result := 0;

  OutputDebugString(PAnsiChar(Format('Playwin: %d, %d',
    [msg.WParam, msg.LParam])));


  if txtSubDelay.Focused then
    Exit;

  threadInfo.cbSize := SizeOf(threadInfo);
  GetGUIThreadInfo(GetCurrentThreadId, threadInfo);

  //if window in menu mode
  if (threadInfo.flags AND GUI_INMENUMODE = GUI_INMENUMODE) then
    Exit;

  if FIgnoreKeyboard then
    Exit;

  if (GetForegroundWindow = Handle) OR
    (chromiumPhrase.Parent.Parent.Handle = GetForegroundWindow) then
    msg.Result := Integer(NOT HandleKeyPress(msg.WParam));

end;

procedure TfrmMain.HOOKKEYUP(var msg: TMessage);
begin

end;

procedure TfrmMain.chromiumUIAfterCreated(Sender: TCustomChromium;
  const browser: ICefBrowser);
begin
  FUIBrowser := browser;

  //navigate to demo.html
  browser.GetMainFrame.LoadUrl(ExtractFilePath(ParamStr(0)) +
    '\template2\ui_bottom.html');

end;

procedure TfrmMain.SeekWithSlider(const pos: Integer);
var
  dur: Int64;
begin
  if (FIMediaSeek <> nil) then
  begin
    if FAILED(FIMediaSeek.GetDuration(dur)) then
      Exit;
    dur := Int64((Int64(pos) * dur) div UI_SLIDER_MAX);
    FIMediaSeek.SetPositions(dur, AM_SEEKING_AbsolutePositioning, dur, AM_SEEKING_NoPositioning);
  end;

end;

procedure TfrmMain.tmrUpdateUIControlsTimer(Sender: TObject);
begin
  UpdateUIControls;
end;

procedure TfrmMain.UpdateUIControls;
var
  dur, cur: Int64;
  i: Integer;
begin

  if (FUIBrowser = nil) then
    Exit;

  if (NOT FUIBrowserLoaded) then
    Exit;

  try
    if FilterGraph1.State = gsPlaying then
      FUIBrowser.GetMainFrame.ExecuteJavaScript(JS_CODE_UI_SET_STATEPLAY, '', 0)
    else
      FUIBrowser.GetMainFrame.ExecuteJavaScript(JS_CODE_UI_SET_STATEPAUSE, '', 0);

    FUIBrowser.GetMainFrame.ExecuteJavaScript(
      Format(JS_CODE_UI_SET_VOLUME,[FilterGraph1.Volume div 100]), '', 0);

  except
  end;
end;

procedure TfrmMain.Subtitles1Click(Sender: TObject);
var
  s: String;
begin
  s := IntToStr(FSubDelay);
  if (InputQuery('Subtitles delay', 'Enter subtitles delay including negative numbers in milliseconds:', s)) then
  begin
    SetSubDelay(StrToInt(Trim(s)));
  end;
end;

procedure TfrmMain.FilterGraph1GraphBufferingData(sender: TObject;
  Buffering: Boolean);
begin
  tmrUpdateUIControls.Enabled := NOT Buffering;
end;

procedure TfrmMain.CheckCommandlineArguments;
var
  filename: String;
  filenames: TStringList;
begin
  if FCommandlineChecked then
    Exit;
  filename := ParamStr(1);

  if (filename <> '') AND (FileExists(filename)) then
  begin
    try
      filenames := TStringList.Create;
      filenames.Add(filename);
      OpenFileUI(filenames);
    finally
      filenames.Free;
      FCommandlineChecked := True;
    end;
  end;
end;

procedure TfrmMain.tmrCheckCommandlineTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := False;
  CheckCommandlineArguments;
  TTimer(Sender).Enabled := True;
end;

procedure TfrmMain.SwitchEnhancedFullScreen;
begin
  //stop updating video size
  FCanUpdateVideoSize := False;

  if NOT FEnhancedFullScreen then
  begin
    //enter fullscreen mode by hiding window menu and border

    //save coords
    FPrevWindowLeft := Left;
    FPrevWindowTop := Top;
    FPrevWindowWidth := Width;
    FPrevWindowHeight := Height;

    //WindowState := wsMaximized;
    Menu := nil;
    chromiumUI.Visible := False;
    pnlFiles.Visible := False;
    splitFileList.Visible := False;
    //chromiumMueller.Visible := False;

    //remove borders
    SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) XOR WS_OVERLAPPEDWINDOW);

    //make always on top
    SetWindowPos(Handle, HWND_TOP,
      Monitor.Left, Monitor.Top, Monitor.Width, Monitor.Height,
      SWP_SHOWWINDOW);

    FEnhancedFullScreen := True;
  end else
  begin
    //show elements in right order
    Menu := MainMenu1;
    chromiumUI.Visible := True;

    //chromiumMueller.Visible := False;
    pnlFiles.Visible := True;
    //chromiumMueller.Visible := True;
    splitFileList.Visible := True;

    //restore window style in order to show borders
    SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE)
      OR WS_OVERLAPPEDWINDOW);

    //restore position
    SetWindowPos(Handle, HWND_NOTOPMOST,
      FPrevWindowLeft, FPrevWindowTop,
      FPrevWindowWidth, FPrevWindowHeight,
      SWP_SHOWWINDOW);

    FEnhancedFullScreen := False;
  end;

  FCanUpdateVideoSize := True;
  UpdateVideoSize;
end;

procedure TfrmMain.ManagePlayPause;
//pauses/plays video
//also manages control visibility in fullscreen mode
begin
  if FilterGraph1.State = gsPlaying then
  begin
    FilterGraph1.Pause;
    chromiumMueller.Visible := True;
    ShowPhraseInBottom;
  end else
  begin
    chromiumMueller.Visible := False;
    HidePhraseInBottom;
    FilterGraph1.Play;
  end;
end;

procedure TfrmMain.ShowPhraseInBottom;
//show interactive phrase in bottom
//and calls for subtitle parse
begin
  chromiumPhrase.Align := alBottom;
  {if (DSVideoWindowEx1.FullScreen) then
    chromiumPhrase.Width := Monitor.Width
  else
    chromiumPhrase.Width := DSVideoWindowEx1.Width;}

  chromiumPhrase.Visible := True;
  ParsePhraseToBottom();
end;

procedure TfrmMain.HidePhraseInBottom;
//hides interactive phrase in bottom
begin
  if chromiumPhrase.Visible then
  begin
    chromiumPhrase.Visible := False;
    Application.ProcessMessages;
    txtVideoWindowFocusHolder.SetFocus;
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //TODO: Handle properly
  if Key = #13 then
    Key := #0;
end;

procedure TfrmMain.DSVideoWindowEx1DblClick(Sender: TObject);
begin
  SwitchEnhancedFullScreen;
end;

procedure TfrmMain.SwitchToStream(const activeStreamName: String;
  bRestartEverything: Boolean = True);
var
  baseFilter: IBaseFilter;
  pEnum: IEnumFilters;
  pPinEnum: IEnumPins;
  pInfo: _FilterInfo;
  pPin: IPin;

  Filename: String;
  MediaSeeking: IMediaSeeking;
  CurrPos: Int64;
begin

  if bRestartEverything then
  begin
    //stop graph for rebuild
    FilterGraph1.Stop;

    //save current video position
    FilterGraph1.QueryInterface(IMediaSeeking, MediaSeeking);
    with MediaSeeking do
      GetCurrentPosition(CurrPos);

    //rebuild graph
    FilterGraph1.ClearGraph;
    FilterGraph1.Active := False;
    FilterGraph1.Active := True;

    SetupEVR();

    //get filename and path
    Filename := FPlayListItem^.Path;
    if Filename[Length(Filename)] <> '\' then
      Filename := Filename + '\';
    Filename := Filename + FPlayListItem^.Filename;
    FilterGraph1.RenderFile(Filename);
  end;

  //enum filters and find direct sound renderers
  (FilterGraph1 as IGraphBuilder).EnumFilters(pEnum);
  baseFilter := nil;

  if (pEnum <> nil) then
  begin
    while SUCCEEDED(pEnum.Next(1, baseFilter, nil)) do
    begin
      if nil = baseFilter then
        Break;

      baseFilter.QueryFilterInfo(pInfo);
      //check filter's name
      if Pos(STR_FILTERNAME_DIRECTSOUND, pInfo.achName) > 0 then
      begin
        //compare with active stream name

        if String(pInfo.achName) <> activeStreamName then
        begin
          //enum pins
          //usually direct sound filter has only one pin - input pin
          baseFilter.EnumPins(pPinEnum);
          if nil <> pPinEnum then
          begin
            while SUCCEEDED(pPinEnum.Next(1, pPin, nil)) do
            begin
              if nil = pPin then
                Break;

              //disconnect
              pPin.Disconnect;

            end;
          end;

        end;

      end;
    end;
  end;

  if bRestartEverything then
  begin
    //save filter graph for debugging purposes
    //SaveGraphFile(FilterGraph1 as IGraphBuilder, 'x:\graph.grf');
    FilterGraph1.Play;

    //refresh sub delay after graph has been rebuilt
    SetSubDelay(FSubDelay);

    //process messages (redrawings etc.) (IMPORTANT)
    Application.ProcessMessages;

    //re set positions
    FilterGraph1.QueryInterface(IMediaSeeking, MediaSeeking);
    with MediaSeeking do
      SetPositions(CurrPos, AM_SEEKING_AbsolutePositioning, CurrPos,
        AM_SEEKING_NoPositioning);

    FIMediaSeek := MediaSeeking;
  end;

end;

function TfrmMain.GetVobSubFilter: IDirectVobSub;
var
  vob: IDirectVobSub;
  filter: IBaseFilter;
  builder: IGraphBuilder;
begin
  Result := nil;
  try
    if SUCCEEDED(FilterGraph1.QueryInterface(IID_IGraphBuilder, builder)) then
    begin
      filter := FindFilter(builder, CLSID_DVobSubAutoLoadingVersion);
      if filter <> nil then
      begin
        if SUCCEEDED(filter.QueryInterface(IID_IDirectVobSub, vob)) then
        begin
          Result := vob;
        end;
      end;
    end;
  finally
  end;
end;

function TfrmMain.ShowSubtitles(const show: Boolean): Boolean;
var
  vob: IDirectVobSub;
begin
  Result := False;
  vob := GetVobSubFilter;
  if vob <> nil then
  begin
    try
      FSubtitlesHidden := NOT Show;
      vob.put_HideSubtitles(FSubtitlesHidden);
      Result := True;
    except
    end;
  end;
end;

function TfrmMain.SwitchSubtitlesVisibility: Boolean;
var
  vob: IDirectVobSub;
begin
  Result := False;
  vob := GetVobSubFilter;
  if vob <> nil then
  begin
    try
      FSubtitlesHidden := NOT FSubtitlesHidden;
      vob.put_HideSubtitles(FSubtitlesHidden);
      Result := True;
    except
    end;
  end;
end;

procedure TfrmMain.mnuOpenNextClick(Sender: TObject);
begin
  OpenNextFile;
end;

procedure TfrmMain.File1Click(Sender: TObject);
begin
  //check availability of next file
  mnuOpenNext.Enabled :=
    GetNextFile(OpenDialog1.FileName, STR_EXTENTIONS) <> '';
end;

procedure TfrmMain.OpenNextFile;
var
  filenames: TStringList;
  filename: String;
begin
  filename := GetNextFile(OpenDialog1.FileName, STR_EXTENTIONS);

  if (filename <> '') AND (FileExists(filename)) then
  begin
    try
      filenames := TStringList.Create;
      filenames.Add(filename);
      OpenFileUI(filenames);
    finally
      filenames.Free;
    end;
  end else
    ShowMessage('There is no next file. Sorry.');
end;

procedure TfrmMain.UpdateVideoSize;
var
  NR: TNormalizedRect;
  R: TRect;
begin
  if NOT FCanUpdateVideoSize then
    Exit;
    
  NR.Left := 0;
  NR.Top := 0;
  NR.Right := 1;
  NR.Bottom := 1;
  R := DSVideoWindowEx1.ClientRect;

  if Assigned(FDisplayControl) then
    FDisplayControl.SetVideoPosition(@nr, @r);
end;

procedure TfrmMain.DSVideoWindowEx1Resize(Sender: TObject);
begin
  UpdateVideoSize;
end;

procedure TfrmMain.SetupEVR;
begin
  if not Succeeded(CoCreateInstance(CLSID_EnhancedVideoRenderer, nil, CLSCTX_INPROC, IID_IBaseFilter, FEVR)) then
  begin
    MessageDlg('Could not create the Enhanced video renderer. Please check .NET Framework 3.0 or later is installed.', mtError, [mbOk], -1);
    Exit;
  end;

  (FilterGraph1 as IFilterGraph).AddFilter(FEVR, PWideChar(WideString('EVR')));
  (FEVR as IMFGetService).GetService(MR_VIDEO_RENDER_SERVICE, IID_IMFVideoDisplayControl, FDisplayControl);
  FDisplayControl.SetAspectRatioMode(MFVideoARMode_None);
  FDisplayControl.SetVideoWindow(DSVideoWindowEx1.Handle);

  UpdateVideoSize;
  FDisplayControl.SetAspectRatioMode(MFVideoARMode_PreservePicture);
end;

procedure TfrmMain.DSVideoWindowEx1Exit(Sender: TObject);
begin
  tmrHideCursor.Enabled := False;
end;

procedure TfrmMain.HideCursorOnVideo;
begin
  DSVideoWindowEx1.Cursor := crNone;
end;

procedure TfrmMain.ShowCursorOnVideo;
begin
  DSVideoWindowEx1.Cursor := crHandPoint;
end;

procedure TfrmMain.tmrHideCursorTimer(Sender: TObject);
begin
  HideCursorOnVideo;
end;

procedure TfrmMain.tmrWindowActiveTimer(Sender: TObject);
begin
  FMainWindowActive := GetForegroundWindow = Handle;
end;

procedure TfrmMain.DSVideoWindowEx1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //handle left click only
  if Button <> mbLeft then
    Exit;

  if FMainWindowActive OR (FilterGraph1.State <> gsPlaying) then
    ManagePlayPause
end;

end.

//TODO: open en.srt
