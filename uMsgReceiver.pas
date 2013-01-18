unit uMsgReceiver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrmMsgReceiver = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure UserData(var msg: TMessage); message WM_COPYDATA;
  public
    { Public declarations }
  end;

var
  frmMsgReceiver: TfrmMsgReceiver;

implementation 

uses Constants, Unit1;

{$R *.dfm}

procedure TfrmMsgReceiver.FormCreate(Sender: TObject);
begin
  Caption := CAPTION_MSG_RECEIVER_WINDOW;
end;

procedure TfrmMsgReceiver.UserData(var msg: TMessage);
var
  filename: String;
  filenames: TStringList;
begin
  filename := StrPas(PCopyDataStruct(msg.lParam)^.lpData);

  if (filename <> '') AND (FileExists(filename)) then
  begin
    filenames := TStringList.Create;
    try
      filenames.Add(filename);
      frmMain.OpenFileUI(filenames);
    finally
      filenames.Free;
    end;
  end;
end;

end.
