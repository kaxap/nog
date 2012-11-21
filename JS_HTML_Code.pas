unit JS_HTML_Code;

interface

const
  //subtitle word add HTML code
  HTML_CODE_A_WORD =
    '<li class="menu">' +
    '<ul>' +
    '<li class="button"><a href="#" class="green">%s<span></span></a></li>' +
    '<li class="dropdown">' +
    '</li></ul></li>';

  JS_CODE_INIT1 = 'document.write("' +
  '<body bgColor=black>' +
  '<div style=''text-align: center; color: white; font-family: Tahoma; font-size: 20; margin-top: 40px;''>' +
  'Загрузка...</div></body>");';

  //CefRegisterExtension Javascript code
  JS_CODE_INIT2 =
   'var cef;'+
   'if (!cef)'+
   '  cef = {};'+
   'if (!cef.translation)'+
   '  cef.translation = {};' +
   '(function() {'+
   '  cef.translation.translator = function() {'+
   '    native function GetTranslatorObject();'+
   '    return GetTranslatorObject();'+
   '  };'+
   '})();';

   //clear word list code
   JS_CODE_CLEAR = 'clearWords();';
   JS_CODE_APPEND_MASK = 'appendWord("%s", "%s");';
   JS_CODE_REGISTER_EVENTS = 'registerEvents();';
   JS_CODE_SHOW_WORD_BY_NUM = 'showWordByNum(%d);';
   JS_CODE_APPEND_PHRASEWORD = 'addWord("%s");';
   JS_CODE_ADD_TRANSLATE_ALL_BUTTON = 'addTranslateAllButton();';
   JS_CODE_UI_SET_STATEPLAY = 'changeStatePlay();';
   JS_CODE_UI_SET_STATEPAUSE = 'changeStatePause();';
   JS_CODE_UI_SET_SLIDERPOS = 'setSliderPosition(%d);';
   JS_CODE_UI_SET_VOLUME = 'setVolume(%d)';
   JS_CODE_UI_SET_CURPOS = 'setCurPos("%s")';
   JS_CODE_UI_SET_DURATION = 'setDuration("%s")';
   JS_CODE_UI_SET_CURPOS2 = 'setCurPos2("%s")';


   HTML_CODE_GOOGLE_BUTTON = '<div class="externallink google" goto="%s"><a href="%s">translate.google.ru</a></div> <BR>';
   HTML_CODE_URBANDIC_BUTTON = '<div class="externallink urbandictionary" goto="%s"><a href="%s">urbandictionary.com</a></div> <BR> ';
   HTML_CODE_WIKIPEDIA_BUTTON = '<div class="externallink wikies" goto="%s"><a href="%s">wikipedia.org</a></div> <BR> ';
   HTML_CODE_WIKTIONARY_BUTTON = '<div class="externallink wikies" goto="%s"><a href="%s">wiktionary.org</a></div> <BR> ';

   HTML_TRANSLATE_HEADER_MASK = 'Значение слова <a class="speech">%s</a>: <hr /> ';
   HTML_CODE_WORD_NOT_FOUND = '<BR><i>Слово не найдено :(</i> ';
   HTML_MB_WORD_FROM_MASK = '<BR>Возможно, производное от <b>%s</b> <BR>';
   HTML_CODE_LOOK_INTERNET = '<BR><BR> Значение слова можно поискать в Интернете: <hr class="hr_gray">';
   HTML_CODE_NOT_FOUND_LOOK_INTERNET = '<BR><BR> Попробуйте поискать в Интернете: <hr class="hr_gray">';
   HTML_CODE_LOOK_GARBAGE = '<BR><BR> <b>Будь мужиком, следи за осанкой!</b> <hr class="hr_gray">';
   HTML_CODE_GUTTENBERG_MASK = 'Место в <abbr  title="wiktionary.org - TV/movie frequency list (2006)">частотном словаре</abbr>: <a class="guttenberg">%d</a>';
   HTML_CODE_WORD_MASK = '<a class="view_word">%s</a>';
   HTML_CODE_GOOGLE_OPINION = '<BR> <a class="google_opinion" word="%s">Ask Google</a> <BR>';
   HTML_CODE_BING_OPINION = '<BR> <a class="bing_opinion" word="%s">ask Bing!</a> <BR>';


implementation

end.
