unit Transparency;

interface
  uses Windows, Graphics;
  
const
  WS_EX_LAYERED = $80000;

  LWA_COLORKEY = 1;
  LWA_ALPHA = 2;

function SetLayeredWindowAttributes(
  hwnd : HWND; // handle to the layered window
  crKey : TColor; // specifies the color key
  bAlpha : byte; // value for the blend function
  dwFlags : DWORD // action
  ): BOOL; stdcall;

function SetLayeredWindowAttributes; external 'user32.dll';

implementation

end.
