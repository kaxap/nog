unit uMkvExtractor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils, StdCtrls, ComCtrls;

const
  WM_EXTRACTIONCOMPLETE = WM_USER + $01;
  WM_CONSOLEDATA = WM_USER + $02;

type
  TfrmMkvExtractor = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    btnCancel: TButton;
    lblProgress: TLabel;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FMKVFilename: String;
    FSubtitleFilename: String;
    FStopEverything: Boolean;
    procedure OnExtractionComplete(var msg: TMessage); message WM_EXTRACTIONCOMPLETE;
    procedure OnConsoleData(var msg: TMessage); message WM_CONSOLEDATA;
    function ExtractSubtitlesTrack(const filename: String; track_num: Integer;
      window_handle: THandle): String;
    function GetEnglishSubTrackNum(const filename: String): Integer;
    procedure OpenVideo;
  public
    function SubtitleWorthy(const filename: String): Boolean;
    function StartExtractionAndGetFilename(const filename: String): String;
  end;

var
  frmMkvExtractor: TfrmMkvExtractor;
  mkvtoolnix_path: String = 'mkvtoolnix\';

implementation

uses Unit1;


procedure ExecuteConsoleApp(const CommandLine: String;
  var Output: TStringList; Errors: TStringList;
  CallBackWindowHandle: THandle = 0);
var
  sa: TSECURITYATTRIBUTES;
  si: TSTARTUPINFO;
  pi: TPROCESSINFORMATION;
  hPipeOutputRead: THandle;
  hPipeOutputWrite: THandle;
  hPipeErrorsRead: THandle;
  hPipeErrorsWrite: THandle;
  Res, bTest: boolean;
  szBuffer: array [0 .. 255] of AnsiChar;
  dwNumberOfBytesRead: dword;
  Stream: TMemoryStream;
begin
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := true;
  sa.lpSecurityDescriptor := nil;
  CreatePipe(hPipeOutputRead, hPipeOutputWrite, @sa, 0);
  CreatePipe(hPipeErrorsRead, hPipeErrorsWrite, @sa, 0);
  ZeroMemory(@si, sizeof(si));
  ZeroMemory(@pi, sizeof(pi));
  si.cb := sizeof(si);
  si.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  si.wShowWindow := SW_HIDE;
  si.hStdInput := 0;
  si.hStdOutput := hPipeOutputWrite;
  si.hStdError := hPipeErrorsWrite;

  (* Remember that if you want to execute an app with no parameters you nil the
    second parameter and use the first, you can also leave it as is with no
    problems. *)
  Res := CreateProcess(nil, PChar(CommandLine), nil, nil, true,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, si, pi);

  // Procedure will exit if CreateProcess fail
  if not Res then
  begin
    CloseHandle(hPipeOutputRead);
    CloseHandle(hPipeOutputWrite);
    CloseHandle(hPipeErrorsRead);
    CloseHandle(hPipeErrorsWrite);
    Exit;
  end;
  CloseHandle(hPipeOutputWrite);
  CloseHandle(hPipeErrorsWrite);

  // Read output pipe
  Stream := TMemoryStream.Create;
  try
    while true do
    begin
      bTest := ReadFile(hPipeOutputRead, szBuffer, sizeof(szBuffer), dwNumberOfBytesRead, nil);
      if not bTest then
        break;
      Stream.Write(szBuffer, dwNumberOfBytesRead);
      if (CallBackWindowHandle <> 0) then
      begin
        if SendMessage(CallBackWindowHandle, WM_CONSOLEDATA,
          dwNumberOfBytesRead, lParam(@szBuffer[0])) <> 0 then
        begin
          //stop everything
          TerminateProcess(pi.hProcess, 0);
        end;
      end;

    end;
    Stream.Position := 0;
    Output.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  // Read error pipe
  Stream := TMemoryStream.Create;
  try
    while true do
    begin
      bTest := ReadFile(hPipeErrorsRead, szBuffer, sizeof(szBuffer), dwNumberOfBytesRead, nil);
      if not bTest then
        break;
      Stream.Write(szBuffer, dwNumberOfBytesRead);
    end;
    Stream.Position := 0;
    Errors.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  WaitForSingleObject(pi.hProcess, INFINITE);
  CloseHandle(pi.hProcess);
  CloseHandle(hPipeOutputRead);
  CloseHandle(hPipeErrorsRead);
end;

function TfrmMkvExtractor.GetEnglishSubTrackNum(const filename: String): Integer;
const
  STR_ID_ENG = 'language:eng';
  STR_ID_TRACK_NUM = 'Track ID ';
  STR_ID_TRACK_NUM_END = ':';
  STR_ID_SUBTITLES = '(S_TEXT/UTF8)';
var
  output, errors: TStringList;
  i, j, k: Integer;
  s: String;
begin
  Result := -1;
  output := TStringList.Create;
  errors := TStringList.Create;

  try
    //get info from mkv file
    ExecuteConsoleApp(mkvtoolnix_path + 'mkvmerge.exe -I "' + filename + '"',
      output, errors);

    if errors.Count > 0 then
      Exit;

    for i := 0 to output.Count - 1 do
    begin
      //find english track
      if Pos(STR_ID_ENG, output[i]) > 0 then
      begin
        //get track number position
        j := Pos(STR_ID_TRACK_NUM, output[i]);

        //if this track is a subtitle track
        if (j > 0) AND (Pos(STR_ID_SUBTITLES, output[i]) > 0) then
        begin
          //move to last char of STR_ID_TRACK_NUM
          j := j + Length(STR_ID_TRACK_NUM);

          //extract number
          k := PosEx(STR_ID_TRACK_NUM_END, output[i], j);
          if k > 0 then
          begin
            s := Copy(output[i], j, k - j);
            if NOT TryStrToInt(s, Result) then
              Result := -1;
          end;
        end;
      end;
    end;
  finally
    errors.Free;
    output.Free;
  end;
end;

function TfrmMkvExtractor.ExtractSubtitlesTrack(const filename: String; track_num: Integer;
  window_handle: THandle): String;

//type for thread params  
type
  TExtractorThreadParams = record
    tracknum: Integer;
    WindowHandle: THandle;
    EventHandle: THandle;
    filename: String;
    subtitle_filename: String;
  end;

  PExtractorThreadParams = ^TExtractorThreadParams;

  procedure ExtractThread(p: PExtractorThreadParams); stdcall;
  var
    filename, subtitle_filename: String;
    tracknum: Integer;
    WindowHandle: Integer;
    output, errors: TStringList;
    command: String;
  begin
    //save params
    filename := p^.filename;
    subtitle_filename := p^.subtitle_filename;
    tracknum := p^.tracknum;
    WindowHandle := p^.WindowHandle;

    //signal main thread as soon as params saved
    SetEvent(p^.EventHandle);
    
    output := TStringList.Create;
    errors := TStringList.Create;
    try

      command := Format('%smkvextract.exe tracks "%s" -c cp1251 %d:"%s"',
        [mkvtoolnix_path, filename, tracknum, subtitle_filename]);

      //start extraction with reportings (WM_COPYDATA)
      ExecuteConsoleApp(command, output, errors, WindowHandle);

      if errors.Count = 0 then
      begin
        //send message at the end
        SendMessage(WindowHandle, WM_EXTRACTIONCOMPLETE, 0, 0);
      end;
    finally
      errors.Free;
      output.Free;
    end;

  end;

var
  subtitle_filename: String;
  extraction_params: TExtractorThreadParams;
  thread_id: DWORD;
  hThread: THandle;
begin
  Result := '';
  if (track_num < 0) then
    Exit;

  //name for subtitle file. Just change extension to SRT  
  subtitle_filename := ChangeFileExt(filename, '.SRT');

  //save it to global var
  //in case if user will interrupt the extraction process
  //we should erase the file
  FSubtitleFilename := subtitle_filename;

  //params for thread
  extraction_params.filename := filename;
  extraction_params.subtitle_filename := subtitle_filename;
  extraction_params.tracknum := track_num;
  extraction_params.WindowHandle := window_handle;

  //create event for thread
  extraction_params.EventHandle := CreateEvent(nil, True, False, 'extraction params read event');

  if (extraction_params.EventHandle <> 0) then
  begin
    //start thread
    hThread := CreateThread(nil, 0, @ExtractThread, @extraction_params, 0, thread_id);
    if (hThread = 0) then
    begin
      CloseHandle(extraction_params.EventHandle);
      Exit;
    end;

    //wait while thread reads parameters
    WaitForSingleObject(extraction_params.EventHandle, 4000); //4 seconds

    CloseHandle(extraction_params.EventHandle);
    CloseHandle(hThread);


    Result := subtitle_filename;
  end;
end;

{$R *.dfm}

{ TfrmMkvExtractor }

procedure TfrmMkvExtractor.OnConsoleData(var msg: TMessage);
const
  STR_ID_PROGRESS = 'Progress: ';
  STR_ID_END = '%';
var
  data: String;
  i, j, k: Integer;
begin
  //check for interrupt
  if FStopEverything then
    msg.Result := -1
  else
    msg.Result := 0;  

  data := Copy(PChar(msg.lParam), 1, msg.WParam);
  i := Pos(STR_ID_PROGRESS, data);
  j := Pos(STR_ID_END, data);
  if (i > 0) AND (j > 0) then
  begin
    i := i + Length(STR_ID_PROGRESS);
    if TryStrToInt(Copy(data, i, j - i), k) then
    begin
      ProgressBar1.Position := k;
      lblProgress.Caption := Format('%.2d%% complete', [k]) ;
    end;
  end;
end;

procedure TfrmMkvExtractor.OnExtractionComplete(var msg: TMessage);
begin
  if NOT FStopEverything then
  begin
    OpenVideo;
    Close;
  end;  
end;

function TfrmMkvExtractor.SubtitleWorthy(const filename: String): Boolean;
begin
  FStopEverything := False;
  Result := GetEnglishSubTrackNum(filename) >= 0;
end;

function TfrmMkvExtractor.StartExtractionAndGetFilename(
  const filename: String): String;
begin
  FStopEverything := False;
  Show;
  FMKVFilename := filename;
  Result := ExtractSubtitlesTrack(filename,
    GetEnglishSubTrackNum(filename), Handle);
end;

procedure TfrmMkvExtractor.btnCancelClick(Sender: TObject);
var
  i: Integer;
begin
  frmMain.FSkipNextMKVSubtitleCheck := True;
  FStopEverything := True;

  i := 0;
  //TODO: fix this unreliable code
  while FileExists(FSubtitleFilename) do
  begin
    Application.ProcessMessages;
    DeleteFile(FSubtitleFilename);
    //wait some time while extraction process stops
    Sleep(100);
    Inc(i);
    if (i > 100) then
      Break;
  end;

  OpenVideo;
  Close;
end;

procedure TfrmMkvExtractor.OpenVideo;
var
  filenames: TStringList;
begin
  //reopen file after extraction
  filenames := TStringList.Create;
  try
    filenames.Add(FMKVFilename);
    frmMain.OpenFileUI(filenames);
  finally
    filenames.Free;
  end;  
end;

end.
