unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SubtitlesAnalyzer, Subtitles, ComCtrls, Dictionaries;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    imgGysto: TImage;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    btnOpen: TButton;
    StatusBar1: TStatusBar;
    procedure btnOpenClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  freqdict: TWordDictionary;
  analyzer: TSubtitlesAnalyzer = nil;

implementation

{$R *.dfm}

procedure TfrmMain.btnOpenClick(Sender: TObject);
var
  subs: TSrtSubtitles;
  bm: TBitmap;
begin
  if (OpenDialog1.Execute) then
  begin
    StatusBar1.Panels[0].Text := 'Processing...';
    Application.ProcessMessages;
    subs := TSrtSubtitles.Create;
    subs.LoadFromFile(OpenDialog1.FileName);

    if (analyzer <> nil) then
      analyzer.Free;

    analyzer := TSubtitlesAnalyzer.Create(subs, freqdict);
    analyzer.Analyze;

    StatusBar1.Panels[0].Text := Format('Expected: %d',
      [analyzer.GetExpectedValue]);
    StatusBar1.Panels[1].Text := Format('Variance: %d',
      [analyzer.GetVariance]);
    bm := analyzer.GetHysto(imgGysto.Height, imgGysto.Width, 100);
    imgGysto.Picture.Assign(bm);
    bm.Free;
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  bm: TBitmap;
begin
  if (analyzer <> nil) then
  begin
    bm := analyzer.GetHysto(imgGysto.Height, imgGysto.Width, 100);
    imgGysto.Picture.Assign(bm);
    bm.Free;
  end;  
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: Integer;
  ss: TStringList;
begin
  freqdict := TWordDictionary.Create;
  ss := TStringList.Create;
  try
    ss.LoadFromFile('freq');

    for i := 0 to ss.Count - 1 do
    begin
      freqdict.Add(ss[i], i);
    end;

  finally
    ss.Free;
  end;
end;

initialization
begin
end;

finalization
begin
  freqdict.Free;
end;

end.
