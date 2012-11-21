unit DirectVobSub;

interface
  uses DirectShow9, ActiveX, Windows, Classes, Dialogs, SysUtils;

const
  CLSID_DVobSubAutoLoadingVersion : TGUID = '{9852A670-F845-491B-9BE6-EBD841B8A613}';
  IID_IDirectVobSub: TGUID = '{EBE1FB08-3957-47ca-AF13-5827E5442E56}';

type
  IDirectVobSub = interface(IUnknown)
  ['{EBE1FB08-3957-47ca-AF13-5827E5442E56}']
  function get_FileName(fn: PWideChar): HResult; stdcall; // fn should point to a buffer allocated to at least the length of MAX_PATH (=260)
  function put_FileName(fn: PWideChar): HResult; stdcall;
  function get_LanguageCount(out nLangs: Integer): HResult; stdcall;
  function get_LanguageName(iLanguage: Integer;
    out ppName: PWideChar): HResult; stdcall;  // the returned ppName is allocated with CoTaskMemAlloc
  function get_SelectedLanguage(out iSelected: Integer): HResult; stdcall;
  function put_SelectedLanguage(iSelected: Integer): HResult; stdcall;
  function get_HideSubtitles(out fHideSubtitles: BOOL): HResult; stdcall;
  function put_HideSubtitles(fHideSubtitles: BOOL): HResult; stdcall;
  function get_PreBuffering(out fDoPreBuffering: BOOL): HResult; stdcall;
  function put_PreBuffering(fDoPreBuffering: BOOL): HResult; stdcall;
  function get_Placement(out fOverridePlacement: BOOL; out xperc: Integer;
    out yperc: Integer): HResult; stdcall;
  function put_Placement(fOverridePlacement: BOOL;
     xperc, yperc: Integer): HResult; stdcall;
  function get_VobSubSettings(out fBuffer, fOnlyShowForcedSubs,
    fPolygonize: BOOL): HResult; stdcall;
  function put_VobSubSettings(fBuffer, fOnlyShowForcedSubs,
    fPolygonize: BOOL): HResult; stdcall;
  function get_TextSettings(lf: Pointer;
                            lflen: Integer; // depending on lflen, lf must point to LOGFONTA or LOGFONTW
                            out color: COLORREF;
                            out fShadow, fOutline,
                              fAdvancedRenderer: BOOL): HResult; stdcall;
  function put_TextSettings(lf: Pointer;
                            lflen: Integer;
                            color: COLORREF;
                            fShadow, fOutline,
                              fAdvancedRenderer: BOOL): HResult; stdcall;
  function get_Flip(out fPicture, fSubtitles: BOOL): HResult; stdcall;
  function put_Flip(fPicture, fSubtitles: BOOL): HResult; stdcall;
  function get_OSD(out fOSD: BOOL): HResult; stdcall;
  function put_OSD(fOSD: BOOL): HResult; stdcall;
  function get_SaveFullPath(out fSaveFullPath: BOOL): HResult; stdcall;
  function put_SaveFullPath(fSaveFullPath: BOOL): HResult; stdcall;
  function get_SubtitleTiming(out delay, speedmul,
    speeddiv: Integer): HResult; stdcall;
  function put_SubtitleTiming(delay, speedmul,
    speeddiv: Integer): HResult; stdcall;
  function get_MediaFPS(out fEnabled: BOOL; out fps: Double): HResult; stdcall;
  function put_MediaFPS(fEnabled: BOOL; out fps: Double): HResult; stdcall;
  // no longer supported (WTF?)
  function get_ColorFormat(out iPosition: Integer): HResult; stdcall;
  function put_ColorFormat(iPosition: Integer): HResult; stdcall;
  function get_ZoomRect(out rect: PNormalizedRect): HResult; stdcall;
  function put_ZoomRect(rect: PNormalizedRect): HResult; stdcall;
  function UpdateRegistry(): HResult; stdcall;
  function HasConfigDialog(iSelected: Integer): HResult; stdcall;
  function ShowConfigDialog(iSelected: Integer;
    hWndParent: HWND): HResult; stdcall;
  function IsSubtitleReloaderLocked(out fLocked: BOOL): HResult; stdcall;
  function LockSubtitleReloader(fLock: BOOL): HResult; stdcall;
  function get_SubtitleReloader(out fDisabled: BOOL): HResult; stdcall;
  function put_SubtitleReloader(fDisable: BOOL): HResult; stdcall;
  function get_ExtendPicture(out horizontal, // 0 - disabled, 1 - mod32 extension (width = (width+31) and not 31)
                                 vertical, // 0 - disabled, 1 - 16:9, 2 - 4:3, 0x80 - crop (use crop together with 16:9 or 4:3, eg 0x81 will crop to 16:9 if the picture was taller)
                                 resx2, // 0 - disabled, 1 - enabled, 2 - depends on the original resolution
                                 resx2minw, // resolution doubler will be used if width*height <= resx2minw*resx2minh (resx2minw*resx2minh equals to 384*288 by default)
                                 resxminh: Integer): HResult; stdcall;
  function put_ExtendPictire(horizontal, vertical, resx2, resx2minw,
    resxminh: Integer): HResult; stdcall;
  function get_LoadSettings(out level: Integer;  // 0 - when needed, 1 - always, 2 - disabled
                            out fExternalLoad,
                            fWebLoad,
                            fEmbeddedLoad: BOOL): HResult; stdcall;
  function put_LoadSettings(level: Integer;  // 0 - when needed, 1 - always, 2 - disabled
                            fExternalLoad,
                            fWebLoad,
                            fEmbeddedLoad: BOOL): HResult; stdcall;
end;


implementation

end.
