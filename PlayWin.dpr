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
  Unit2 in '..\image_mirr_multirator\Unit2.pas' {Form2};

{$R *.res}

begin
  SetThreadLocale(1049);
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TColorControlForm, ColorControlForm);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
