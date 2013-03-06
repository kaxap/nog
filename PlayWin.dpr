program PlayWin;

uses
  Windows,
  Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  ColorControl in 'ColorControl.pas' {ColorControlForm},
  Misc in 'Misc.pas',
  Subtitles in 'Subtitles.pas',
  cef in 'chromium\cef.pas',
  ceflib in 'chromium\ceflib.pas',
  Dictionaries in 'Dictionaries.pas',
  Constants in 'Constants.pas',
  JS_HTML_Code in 'JS_HTML_Code.pas',
  CefExtension_Translate in 'CefExtension_Translate.pas',
  Translate in 'Translate.pas',
  DirectVobSub in 'DirectVobSub.pas',
  Transparency in 'Transparency.pas',
  IntegerList in 'IntegerList.pas',
  SubtitlesAnalyzer in 'SubtitlesAnalyzer.pas',
  uMsgReceiver in 'uMsgReceiver.pas' {frmMsgReceiver},
  uStartup in 'uStartup.pas',
  EVR9 in 'EVR9.pas',
  uMkvExtractor in 'uMkvExtractor.pas' {frmMkvExtractor},
  uAbout in 'uAbout.pas' {frmAbout};

{$R *.res}

begin
  SetThreadLocale(1049);

  

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TColorControlForm, ColorControlForm);
  Application.CreateForm(TfrmMsgReceiver, frmMsgReceiver);
  Application.CreateForm(TfrmMkvExtractor, frmMkvExtractor);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
