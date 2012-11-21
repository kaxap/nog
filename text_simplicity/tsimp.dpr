program tsimp;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  Subtitles in 'Subtitles.pas',
  SubtitlesAnalyzer in 'SubtitlesAnalyzer.pas',
  Misc in 'Misc.pas',
  Constants in 'Constants.pas',
  IntegerList in 'IntegerList.pas',
  Dictionaries in 'Dictionaries.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
