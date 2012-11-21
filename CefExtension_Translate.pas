unit CefExtension_Translate;

interface
   uses Windows, ActiveX, ceflib, cef, SysUtils, Constants, JS_HTML_Code,
     Dictionaries, Classes;

type
  TCefTranslateExtension = class(TCefv8HandlerOwn)
  private
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean; override;
  public
    function FindTranslation(const w: String; out translation: String): Boolean;
  end;

implementation

uses Translate;


function TCefTranslateExtension.Execute(const name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
var
  w, t, tr: String;
  url: String;
  gutten: Integer;
  bFound: Boolean;
begin
  if (name = FN_GET_TRANSLATOR_OBJECT) then
  begin
    SetThreadLocale(1049); //russian locale
    retval := TCefv8ValueRef.CreateObject(nil);
    retval.SetValueByKey(FN_NAME_TRANSLATE,
        TCefv8ValueRef.CreateFunction(FN_NAME_TRANSLATE, Self));
    retval.SetValueByKey(FN_NAME_FINDWORD,
        TCefv8ValueRef.CreateFunction(FN_NAME_FINDWORD, Self));
    Result := true;
  end
  else if(name = FN_NAME_TRANSLATE) then
  begin
    w := Trim(arguments[0].GetStringValue());
    t := Translate.getFormattedTranslation(w);
    retval := TCefv8ValueRef.CreateString(t);
    Result := True;
  end
  else if (name = FN_NAME_FINDWORD) then
  begin

  end else
    Result := False;
end;

function TCefTranslateExtension.FindTranslation(const w: String; out translation: String): Boolean;
begin
  Result := Translate.FindTranslation(w, translation);
end;

end.
