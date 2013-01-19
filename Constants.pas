unit Constants;

interface
  uses Messages;
  
const
  LATIN_WORD_LETTERS = ['-', 'A'..'Z', 'a'..'z'];
  ROME_DIGITS = ['I', 'i', 'V', 'v', 'X', 'x'];
  CYRILLIC_WORD_LETTERS = ['А'..'Я','а'..'я'];

  STR_FILTERNAME_DIRECTSOUND = 'DirectSound';
  STR_EXTENTIONS = '*.AVI;*.mkv;*.mp4;*.MPG;*.MPEG;*.ASF';

  DIC_SEPARATOR = '_____';
  DIR_DIC = 'dicts\';
  FILENAME_MUELLER_DICT = 'mueller-base';
  FILENAME_FREQ_DICT = 'freq';
  FILENAME_POST_DICT = 'posts';
  FILENAME_PREF_DICT = 'prefs';
  FILENAME_ALIAS_DICT = 'alias';
  FILENAME_ADDITIONAL_DICT = 'additional';
  FILENAME_TRANSLATED = 'translated.txt';
  FILENAME_SETTINGS = 'settings.ini';

  INI_VOICE_SECTION = 'voice';
  INI_VOICE_NAME = 'name';

  WORD_COLORS: array[0..3] of String =
    ('green', 'orange', 'blue', 'red');

  ALERT_PREFIX_GOTO = 'goto:';
  ALERT_PREFIX_SPEAK = 'speak:';
  ALERT_PREFIX_FIND = 'find:';
  ALERT_PREFIX_NOTIFICATION = 'notification:';
  ALERT_PREFIX_EVENT = 'event:';

  EVENT_PLAY = 'play';
  EVENT_PAUSE = 'pause';
  EVENT_SEEK = 'seek';
  EVENT_VOLUME = 'volume';
  EVENT_SLIDERCHANGE = 'sliderchange';
  
  NOTIFICATION_PHRASE = 'phrase';
  NOTIFICATION_MAIN = 'main';
  NOTIFICATION_UI = 'UI';

  LINK_GOOGLE_MASK = 'http://translate.google.ru/#en|ru|%s';
  LINK_URBANDIC_MASK = 'http://www.urbandictionary.com/define.php?term=%s';
  LINK_WIKTIONARY_MASK = 'http://en.wiktionary.org/wiki/%s';
  LINK_WIKIPEDIA_MASK = 'http://en.wikipedia.org/wiki/%s';

  COLOR_VIDEOWINDOW_BACKGROUND = $111111;

  MAX_TRANSLATE_SYMBOLS = 300;
  VIDEO_UNITS_IN_ONE_MILLISECOND = 10000;
  SUBTITLE_SEEK_PREFIX_TIME = VIDEO_UNITS_IN_ONE_MILLISECOND * 1000 div 5; // 1/5 of second

  DELIMITER_ALIAS = '=';
  DELIMITER_DIC_REFERENCE1 = ' от ';
  DELIMITER_DIC_REFERENCE2 = ' = ';
  DELIMITER_DIC_REFERENCE3 = ' см. ';

  TIME_DIFF_REWIND = 5000; //ms
  TIME_DIFF_FORWARD = 5000; //ms
  TIME_WAIT_UNTIL_LOAD = 20; // 1/2 sec

  FN_NAME_TRANSLATE = 'translate';
  FN_NAME_FINDWORD = 'findWord';
  FN_GET_TRANSLATOR_OBJECT = 'GetTranslatorObject';

  STR_FILTERNAME_VOBSUB = 'VobSub';

  WM_HOOKKEYDOWN = WM_USER + $10;
  WM_HOOKKEYUP   = WM_USER + $11;

  UI_SLIDER_MAX = 2000;

  DS_ENGLISH_STREAM_NUM = 1;

  CAPTION_MSG_RECEIVER_WINDOW = 'NOG MESSAGE RECEIVER WINDOW 7445253';

implementation

end.
