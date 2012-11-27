unit Translate;

interface
  uses Classes, SysUtils, Dictionaries, Constants, JS_HTML_Code, StrUtils;

var
  FFreqDict: TWordDictionary;
  FMuellerIndex: TWordDictionary;
  FMuellerDic: TStringList;
  FPrefDic: TStringList;
  FPostDic: TStringList;
  FTranslatedWords: TStringList;

  function findTranslation(const w: String; out translation: String): Boolean;
  function getFormattedTranslation(const w: String): String;

implementation

uses Misc;

function transformReferenceToLink(const text, delimiter: String;
 out Res: String): Boolean;
var
  i: Integer;
  dPos: Integer;
  s: String;
begin

  Result := False;
  dPos := Pos(delimiter, text);

  if dPos <= 0 then
  begin
    Res := text;
    Exit;
  end;

  dPos := dPos + Length(delimiter);
  Res := Copy(text, 1, dPos - 1);

  s := '';
  for i := dPos to Length(text) do
  begin
    if NOT (text[i] in LATIN_WORD_LETTERS) then
    begin

      if (text[i] in CYRILLIC_WORD_LETTERS) then
      begin
        Res := Res + s + Copy(text, i, Length(text));
        Exit;
      end;

      if s = '' then
      begin
        Res := Res + text[i];
        Continue;
      end;

      {if NOT isLatinWord(s) then
      begin
        Result := Result + s + Copy(text, i, Length(text));
        Exit;
      end;}

      if NOT isRomanDigits(s) then
      begin
        Res := Res + Format(HTML_CODE_WORD_MASK, [s]) + text[i];
        Result := True;
      end else
        Res := Res + s + text[i];

      s := '';
    end else
      s := s + text[i];
  end;

  if NOT isLatinWord(s) then
  begin
    Res := Res + s;
    Exit;
  end;

  if NOT isRomanDigits(s) then
  begin
    Res := Res + Format(HTML_CODE_WORD_MASK, [s]);
    Result := True;
  end else
    Res := Res + s;


end;

function getFormattedTranslation(const w: String): String;
var
  t, tr, url: String;
  bFound: Boolean;
  gutten: Integer;
begin
  Result := '';

    //add word to list for future control list
    FTranslatedWords.Add(w);
  
    t := Format(HTML_TRANSLATE_HEADER_MASK, [w]);

    t := t + Format(HTML_CODE_GOOGLE_OPINION, [w]);
    t := t + Format(HTML_CODE_BING_OPINION, [w]);

    //AnsiReplaceStr(t, '''', '&#39;');
    //find and add translation if possible
    bFound := FindTranslation(w, tr);

    t := t + tr;

    if bFound then
    begin
      t := t + '<BR>';

      gutten := FFreqDict.Find(w);
      if gutten >= 0 then
        t := t + Format(HTML_CODE_GUTTENBERG_MASK, [gutten + 1]);

      //add internet links
      if Length(tr) > MAX_TRANSLATE_SYMBOLS then
        t := t + HTML_CODE_LOOK_GARBAGE
      else
        t := t + HTML_CODE_LOOK_INTERNET;
    end else
    begin
      t := t + HTML_CODE_NOT_FOUND_LOOK_INTERNET;
    end;

    url := Format(LINK_URBANDIC_MASK, [w]);
    t := t + Format(HTML_CODE_URBANDIC_BUTTON, [url, url]);
    url := Format(LINK_GOOGLE_MASK, [w]);
    t := t + Format(HTML_CODE_GOOGLE_BUTTON, [url, url]);

    url := Format(LINK_WIKTIONARY_MASK, [w]);
    t := t + Format(HTML_CODE_WIKTIONARY_BUTTON, [url, url]);
    url := Format(LINK_WIKIPEDIA_MASK, [w]);
    t := t + Format(HTML_CODE_WIKIPEDIA_BUTTON, [url, url]);


  Result := t;
end;

function FindTranslation(const w: String; out translation: String): Boolean;

var
  ARecursionDeepness: Integer;

  function FindWord(w: String; bOnlyExact: Boolean = False;
     bSkipExact: Boolean = False): Integer;
  ///////////////////////////////////////
  //recursive procedure
  //excludes known prefixes and postfixes 
  //and finds translation for a word
  ///////////////////////////////////////

  var
    i: Integer;
    s: String;
  begin
    Result := -1;
    //increase recursion level
    Inc(ARecursionDeepness);

    //max recursion level = 3
    if ARecursionDeepness > 3 then
    begin
      //exit if exceeded
      Dec(ARecursionDeepness);
      Exit;
    end;


    if NOT bSkipExact then
    begin
      //try to find exact match

      i := FMuellerIndex.Find(w);
      if i >= 0 then
      begin
        Dec(ARecursionDeepness);
        Result := i;
        Exit;
      end;

      {
      //case sensitive search
      for i := 0 to FMuellerDic.Count - 1 do
      begin
        //статьи в словаре разделены строкой, которая равна DIC_SEPARATOR
        if FMuellerDic[i] = DIC_SEPARATOR then
          if w = FMuellerDic[i + 2] then
          begin
            //соответствие найдено, уменьшаем глубину рекурсии и выходим
            Dec(ARecursionDeepness);
            Result := i;
            Exit;
          end;
       end;

      //регистроНЕчувствительный поиск
      //переводим искомое слово в нижний регистр
      w := AnsiLowerCase(w);

      for i := 0 to FMuellerDic.Count - 1 do
      begin
        //статьи в словаре разделены строкой, которая равна DIC_SEPARATOR
        if FMuellerDic[i] = DIC_SEPARATOR then
          if w = LowerCase(FMuellerDic[i + 2]) then
          begin
            //соответствие найдено, уменьшаем глубину рекурсии и выходим
            Dec(ARecursionDeepness);
            Result := i;
            Exit;
          end;
      end;}

      
    end;



    if bOnlyExact then
    begin
      //перед выходом из процедуры - уменьшаем глубину рекурсии
      Dec(ARecursionDeepness);
      Exit;
    end;  

    //точное совпадение не найдено
    //попробуем пару трюков

    //трюки с окончаниями
    //перебираем все известные окончания
    //по словарю постфиксов
    for i := 0 to FPostDic.Count - 1 do
    begin
      //берем окончание слова и сравниваем с очередным из словаря постфиксов
      if Copy(w, Length(w) - Length(FPostDic[i]) + 1, Length(FPostDic[i])) = FPostDic[i] then
      begin
        //если произошло совпадение по окончанию
        //удаляем это окончание
        s := Copy(w, 1, Length(w) - Length(FPostDic[i]));

        //проверяем по правилу удвоения согласного после короткого гласного
        //надо поставить до "+e", иначе gripping = grippe = грип, должно быть grip = сжатие
        if i < 5 then
        begin
          if (Length(s) > 2) AND (s[Length(s)] = s[Length(s) - 1]) then
          begin
            s := Copy(s, 1, Length(s) - 1); //like bigger-big, beginner-begin etc.
            //рекурсивно ищем новое слово
            Result := FindWord(s);
            //если нашли, то
            if Result >= 0 then
            begin
              //уменьшаем глубину рекурсии и выходим
              Dec(ARecursionDeepness);
              Exit;
            end;

          end;
        end;

        //проверяем по чистому совпадению, без проверки корней
        Result := FindWord(s, true);  //clean matching, like goods-good, playing-play etc.
        //если нашли, то
        if Result >= 0 then
        begin
          //уменьшаем глубину рекурсии и выходим
          Dec(ARecursionDeepness);
          Exit;
        end;


        //первые 16 окончаний в словаре постфиксов - окончания, изменяющие корень слова
        if i < 16 then //s, es, ing, ed, ly, er, est, or etc.
        begin
          //проверяем на правило "e", то есть добавляем к корню "e" и рекурсивно ищем новое слово
          Result := FindWord(s + 'e'); //like creating-create, lived-live, whiter-white, whitest-white
          //если нашли, то
          if Result >= 0 then
          begin
            //уменьшаем глубину рекурсии и выходим
            Dec(ARecursionDeepness);
            Exit;
          end;

          //проверка на i в конце корня слова
          if s[Length(s)] = 'i' then
          begin
            //пробуем заменить i на y
            s[Length(s)] := 'y'; //like copier-copy, earlier-early etc.
            //рекурсивно ищем новое слово
            Result := FindWord(s);

            //если нашли, то
            if Result >= 0 then
            begin
              //уменьшаем глубину рекурсии и выходим
              Dec(ARecursionDeepness);
              Exit;
            end;

          end;

          //проверка на v в конце корня слова
          if s[Length(s)] = 'v' then
          begin
            //пробуем заменить v на f
            s[Length(s)] := 'f'; //like yourselves - yourself, elves - elf
            //рекурсивно ищем новое слово
            Result := FindWord(s);

            //если нашли, то
            if Result >= 0 then
            begin
              //уменьшаем глубину рекурсии и выходим
              Dec(ARecursionDeepness);
              Exit;
            end;

          end;

        end;

        //снова получаем корень из исходного слова
        s := Copy(w, 1, Length(w) - Length(FPostDic[i]));

        //проверяем по чистому совпадению, на этот раз только корни
        Result := FindWord(s, False, True);  //clean matching, like goods-good, playing-play etc.
        //если нашли, то
        if Result >= 0 then
        begin
          //уменьшаем глубину рекурсии и выходим
          Dec(ARecursionDeepness);
          Exit;
        end;

        //проверяем на происхождение от существительного
        //путем добавления к корню окончания "ion"
        //рекурсивно ищем новое слово
        Result := FindWord(s + 'ion'); //like creating-creation, destinated-destination
        //если нашли, то
        if Result >= 0 then
        begin
          //уменьшаем глубину рекурсии и выходим
          Dec(ARecursionDeepness);
          Exit;
        end;

      end;

    end;

    //сотрем возможные префиксы, известные программе по словарю префиксов
    for i := 0 to FPrefDic.Count - 1 do
    begin
      //сравниваем по словарю
      if Copy(w, 1, Length(FPrefDic[i])) = FPrefDic[i] then
      begin
        //если нашли, то получаем корень слова без префикса
        s := Copy(w, Length(FPrefDic[i]) + 1, Length(w));

        //если слово и префикс разделены знаком "-", то стираем этот знак
        if (s <> '') AND (s[1] = '-') then //self-extractor, semi-colon etc.
          s := Copy(s, 2, Length(s));

        //рекурсивно ищем полученное слово
        Result := FindWord(s);

        //если нашли, то
        if Result >= 0 then
        begin
          //уменьшаем глубину рекурсии и выходим
          Dec(ARecursionDeepness);
          Exit;
        end;

      end;
    end;

    //перед выходом из процедуры - уменьшаем глубину рекурсии
    Dec(ARecursionDeepness);

  end;

var
  i: Integer;
  t: String;
begin

  // инициализируем переменную, которая содержит глубину рекурсии
  ARecursionDeepness := 0;

  //ищем слово
  i := FindWord(w);

  begin
    Result := False;
    translation := '';

    //добавляем переводимое слово (зеленым и жирным)
    //Result := Result + Format('<b>%s</b><BR>', [w]);

    //если перевод найден, то
    if i >= 0 then
    begin
      if AnsiLowerCase(FMuellerDic[i]) <> AnsiLowerCase(w) then
        translation := translation
           + Format(HTML_MB_WORD_FROM_MASK, [FMuellerDic[i]]);

      Inc(i);

      //добавляем в подсказку перевод из словаря
      while (i < FMuellerDic.Count) AND (FMuellerDic[i] <> DIC_SEPARATOR) do
      begin
        if NOT transformReferenceToLink(FMuellerDic[i], DELIMITER_DIC_REFERENCE1, t) then
          if NOT transformReferenceToLink(FMuellerDic[i], DELIMITER_DIC_REFERENCE2, t) then
            transformReferenceToLink(FMuellerDic[i], DELIMITER_DIC_REFERENCE3, t);

        translation := translation + t + '<BR>';
        Inc(i);
      end;

      Result := True;
    end else
      translation := translation + (HTML_CODE_WORD_NOT_FOUND); //если перевод не найден, то добавляем строку "нет совпадений"
  end;    
end;


end.
