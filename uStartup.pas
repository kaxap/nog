unit uStartup;

interface
  uses Windows, Messages, SysUtils;

  procedure Check;
  procedure CheckAlreadyRunning;

implementation

uses Constants, uMsgReceiver;

procedure CheckAlreadyRunning;
var
  wnd: HWND;
  filename: String;
  data: TCopyDataStruct;
  fakefrm: TfrmMsgReceiver;
begin
  wnd := FindWindow(nil, CAPTION_MSG_RECEIVER_WINDOW);

  if wnd <> 0 then
  begin
    filename := ParamStr(1);
    data.dwData := 0;
    data.cbData := Length(filename) + 1;
    data.lpData := @filename[1];
    fakefrm := TfrmMsgReceiver.Create(nil);
    SendMessage(wnd, WM_COPYDATA, fakefrm.Handle, lParam(@data));
    Halt;
  end;
end;

procedure Check;
begin
  CheckAlreadyRunning;
end;

initialization
  Check;


end.
