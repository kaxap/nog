unit DVobSubControls;

interface

uses DirectShow9, ActiveX, Windows, Classes, Dialogs, SysUtils;

const
CLSID_DVobSubDecoder : TGuid = '{9852A670-F845-491B-9BE6-EBD841B8A613}';
IID_IDirectVobSubFilter : TGUID = (D1:$3a58b97b;D2:$a2cc;D3:$46b3;D4:($8A,$57,$48,$FA,$B1,$53,$AE,$EE));
IID_IDirectVobSubFilterA: TGuid = '{EBE1FB08-3957-47ca-AF13-5827E5442E56}';
IID_IDirectVobSubFilter2 : TGUID = (D1:$639a5c61;D2:$0d72;D3:$4921;D4:($AD,$1A,$B9,$C5,$EC,$A4,$CB,$AF));
// {639A5C61-0D72-4921-AD1A-B9C5ECA4CBAF}
type TLangs=array[1..32] of array[1..256] of char;
type MyLangs=array[1..256] of array[1..32] of char;
type
IDirectVobSubFilter = interface(IUnknown)
['{EBE1FB08-3957-47ca-AF13-5827E5442E56}']
//['{3A58B97B-A2CC-46b3-8A57-48FAB153AEEE}']
function get_MyFilterData(out fn:Char; out fFlipPicture:boolean; out fHideSubs: boolean; out fNoYUY2Colors:boolean): HResult; stdcall;
function put_MyFilterData(fn:Char; fFlipPicture:boolean; fHideSubs: boolean; fNoYUY2Colors:boolean): HResult; stdcall;
function get_VobSubSettings(out fBuffer:boolean; out iSelected:integer; out nLangs:integer; out pLangs:MyLangs): HResult; stdcall;
function put_VobSubSettings(fBuffer:boolean; iSelected:integer): HResult; stdcall;
function get_TextSettings(out lf:LOGFONT; out color:COLORREF; out fShadow:boolean; out fOutline:boolean; out fAdvancedRenderer:boolean): HResult; stdcall;
function put_TextSettings(lf:LOGFONT; color:COLORREF; fShadow:boolean; fOutline:boolean; fAdvancedRenderer:boolean): HResult; stdcall;
function getSubtitleTiming(out delay: Integer; out speedmul: Integer; out speeddiv: Integer): HResult; stdcall;
function UnknownFunction: HResult; stdcall;
end;

type
IDirectVobSubFilter2 = interface(IDirectVobSubFilter)
['{639A5C61-0D72-4921-AD1A-B9C5ECA4CBAF}']
function get_FileName(out fn:wChar): HResult; stdcall;
function UnknownFunction: HResult; stdcall;
end;

var
FGrp: IGraphBuilder;


function FindFilter(Cid: TGuid): IBaseFilter;

function IsDVobSubUsed: Boolean;
procedure GetTextSettings(out lf:LOGFONT; out color:COLORREF; out fShadow:boolean; out fOutline:boolean; out fAdvancedRenderer:boolean);
procedure SetTextSettings(lf:LOGFONT; color:COLORREF; fShadow:boolean; fOutline:boolean; fAdvancedRenderer:boolean);
procedure GetVobSubFilename(out fn:wchar);


implementation

procedure GetVobSubFilename(out fn:wchar);
var DVobSub: IbaseFilter;
Setup: IDirectVobSubFilter2;
v: integer;
begin
if FGrp = nil then Exit;
DVobSub:= FindFilter(CLSID_DVobSubDecoder); if DVobSub = nil then Exit;

DVobSub.QueryInterface(IID_IDirectVobSubFilter2, Setup);
if Setup = nil then begin DVobSub:= nil; exit; end;

Setup.get_FileName(fn);

DVobSub:= nil;
Setup:= nil;

end;

procedure SetTextSettings(lf:LOGFONT; color:COLORREF; fShadow:boolean; fOutline:boolean; fAdvancedRenderer:boolean);
var DVobSub: IBasefilter;
Setup: IDirectVobSubFilter;
v: Integer;
begin
if FGrp = nil then Exit;
DVobSub:= FindFilter(CLSID_DVobSubDecoder); if DVobSub = nil then Exit;

DVobSub.QueryInterface(IID_IDirectVobSubFilter, Setup);
if Setup = nil then begin DVobSub:= nil; exit; end;

// v:= Value; if v <-128 then v:=-128; if v>128 then v:=128;

Setup.put_TextSettings(lf,color,fShadow,fOutline,fAdvancedRenderer);

DVobSub:= nil;
Setup:= nil;
end;

procedure GetTextSettings(out lf:LOGFONT; out color:COLORREF; out fShadow:boolean; out fOutline:boolean; out fAdvancedRenderer:boolean);
var DVobSub: IbaseFilter;
Setup: IDirectVobSubFilter;
v: integer;
begin
if FGrp = nil then Exit;
DVobSub:= FindFilter(CLSID_DVobSubDecoder); if DVobSub = nil then Exit;

DVobSub.QueryInterface(IID_IDirectVobSubFilter, Setup);
if Setup = nil then begin DVobSub:= nil; exit; end;

Setup.get_TextSettings(lf,color,fShadow,fOutline,fAdvancedRenderer);

DVobSub:= nil;
Setup:= nil;

end;


function IsDVobSubUsed: Boolean;
begin
Result:= FindFilter(CLSID_DVobSubDecoder) <> nil;
end;

function FindFilter(Cid: TGUID): IBaseFilter;
var EnumF: IEnumFilters;
Fetched: ULong;
Fi: IBaseFilter;
g: TGuid;
FFi: TFilterInfo;
begin
Result:= nil;
if FGrp = nil then Exit;

FGrp.EnumFilters(EnumF);
while EnumF.Next(1, Fi, @Fetched)=S_Ok do begin
Fi.GetClassID(G);
Fi.QueryFilterInfo(FFi);
if IsEqualGUID(g, cid) then begin Result:= Fi; end;
end;
Fi:= nil;
EnumF:= nil;
end;



end.
