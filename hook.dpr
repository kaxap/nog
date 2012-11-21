library hook;

{$DEFINE DEBUG}

uses
  Windows,
  Messages;

type
  tagKBDLLHOOKSTRUCT = record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;

  PKBDLLHOOKSTRUCT = ^tagKBDLLHOOKSTRUCT;

const
  WH_KEYBOARD_LL = 13;
  WM_HOOKKEYDOWN = WM_USER + $10;
  WM_HOOKKEYUP   = WM_USER + $11;

var
  hCurHook: HHook;
  hCaller: HWND;
  hParent: HWND;
  moduleName: String;

function GetMainWindow(wnd: HWND): HWND;
begin
  repeat
    Result := wnd;
    wnd := GetWindow(wnd, GW_OWNER);
  until wnd = 0;  
end;

function HookProc(nCode: integer; wParam: longInt; lParam: longInt): LRESULT; stdcall;
var dwMsg: DWORD;
begin
 

  {$IFDEF DEBUG}
    OutputDebugString('Hook.dll: entered to HookProc');
  {$ENDIF}


  if nCode < 0 then
    Result := CallNextHookEx(0, nCode, wParam, lParam)
  else
    begin
      
      case wParam of

        WM_KEYDOWN, WM_SYSKEYDOWN:
          dwMsg := WM_HOOKKEYDOWN;

        WM_KEYUP, WM_SYSKEYUP:
          dwMsg := WM_HOOKKEYUP;

        else dwMsg := 0;
      end;

      if (dwMsg = 0) or (GetMainWindow(GetForegroundWindow) <> hParent) or
        (SendMessage(hCaller, dwMsg,
                     PKBDLLHOOKSTRUCT(lParam)^.vkCode,
                     PKBDLLHOOKSTRUCT(lParam)^.scanCode) = 0) then
         Result := CallNextHookEx(0, nCode, wParam, lParam) else Result := 0;
    end;

  {$IFDEF DEBUG}
    OutputDebugString('Hook.dll: exit HookProc');
    if Result <> 0 then
      OutputDebugString('Hook.dll: !!! Result != NULL !!! ');
  {$ENDIF}

end;

procedure SetHook(WND, parent: hwnd);stdcall;
begin
  {$IFDEF DEBUG}
    OutputDebugString('Hook.dll: entered to SetHook');
  {$ENDIF}

  hCaller := WND;
  hParent := parent;
  hCurHook := SetWindowsHookEx(WH_KEYBOARD_LL, @HookProc, hInstance, 0);
  if hCurHook = 0 then
  begin
    {$IFDEF DEBUG}
      OutputDebugString(' !!! SetWindowsHookEx returned NULL !!! ');
    {$ENDIF}
    CloseWindow(hCaller);
  end;

  {$IFDEF DEBUG}
    OutputDebugString('Hook.dll: entered to SetHook');
  {$ENDIF}

end;

procedure LibraryProc(Reason: Integer);
begin

  case Reason of
    DLL_PROCESS_ATTACH:
    begin
      
    end;

    DLL_PROCESS_DETACH:
    begin
      
    end;
  end;

end;


procedure ReleaseHook;
begin
  {$IFDEF DEBUG}
    OutputDebugString('Hook.dll: entered to ReleaseHook');
  {$ENDIF}
  UnhookWindowsHookEx(hCurHook);
end;

exports
  SetHook, ReleaseHook;
begin

end.
