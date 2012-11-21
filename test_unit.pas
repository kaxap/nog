unit test_unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cef, ceflib, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Chromium1: TChromium;
    RichEdit1: TRichEdit;
    procedure Chromium1ConsoleMessage(Sender: TCustomChromium;
      const browser: ICefBrowser; message, source: ustring; line: Integer;
      out Result: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Chromium1ConsoleMessage(Sender: TCustomChromium;
  const browser: ICefBrowser; message, source: ustring; line: Integer;
  out Result: Boolean);
begin
  RichEdit1.Lines.Add(message + ' :: ' + source + ':' + IntToStr(Line));
end;

end.
