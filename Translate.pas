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
        //������ � ������� ��������� �������, ������� ����� DIC_SEPARATOR
        if FMuellerDic[i] = DIC_SEPARATOR then
          if w = FMuellerDic[i + 2] then
          begin
            //������������ �������, ��������� ������� �������� � �������
            Dec(ARecursionDeepness);
            Result := i;
            Exit;
          end;
       end;

      //case insensetive search
      //convert word to lower case
      w := AnsiLowerCase(w);

      for i := 0 to FMuellerDic.Count - 1 do
      begin
        //articles in the dictionary separated by DIC_SEPARATOR
        if FMuellerDic[i] = DIC_SEPARATOR then
          if w = LowerCase(FMuellerDic[i + 2]) then
          begin
            //found the word, now decrease recursion level and exit
            Dec(ARecursionDeepness);
            Result := i;
            Exit;
          end;
      end;}

      
    end;



    if bOnlyExact then
    begin
      //decrease recursion level before exit
      Dec(ARecursionDeepness);
      Exit;
    end;  

    //exact match not found
    //lets try some tricks

    //tricks with endings
    //enumerate all known endings
    //from postfix dictionary
    for i := 0 to FPostDic.Count - 1 do
    begin
      //compare word's ending with next postfix from dictionary
      if Copy(w, Length(w) - Length(FPostDic[i]) + 1, Length(FPostDic[i])) = FPostDic[i] then
      begin
        //if matched then
        //remove the ending
        s := Copy(w, 1, Length(w) - Length(FPostDic[i]));

        //check for double consonant after short vowel
        if i < 5 then
        begin
          if (Length(s) > 2) AND (s[Length(s)] = s[Length(s) - 1]) then
          begin
            s := Copy(s, 1, Length(s) - 1); //like bigger-big, beginner-begin etc.
            //search for new word recursively
            Result := FindWord(s);
            //if found
            if Result >= 0 then
            begin
              //decrease recursion level and exit
              Dec(ARecursionDeepness);
              Exit;
            end;

          end;
        end;

        //check for clean match without any manipulation with postfixes
        Result := FindWord(s, true);  //clean matching, like goods-good, playing-play etc.
        //if found
        if Result >= 0 then
        begin
          //decrease recursion level and exit
          Dec(ARecursionDeepness);
          Exit;
        end;


        //first 16 postfixes in postfix dictionary always change stem of a word
        if i < 16 then //s, es, ing, ed, ly, er, est, or etc.
        begin
          //check 'e' rule e.g. add 'e' to stem of a word and search for it recursively
          Result := FindWord(s + 'e'); //like creating-create, lived-live, whiter-white, whitest-white
          //if found
          if Result >= 0 then
          begin
            //decrease recursion level and exit
            Dec(ARecursionDeepness);
            Exit;
          end;

          //test for 'i' in the end of a word stem
          if s[Length(s)] = 'i' then
          begin
            //try to substitute 'i' to 'y'
            s[Length(s)] := 'y'; //like copier-copy, earlier-early etc.
            //search for new word recursively
            Result := FindWord(s);

            //if found
            if Result >= 0 then
            begin
              //decrease recursion level and exit
              Dec(ARecursionDeepness);
              Exit;
            end;

          end;

          //check for 'v' in the end of a word stem
          if s[Length(s)] = 'v' then
          begin
            //try to substitute 'v' to 'f'
            s[Length(s)] := 'f'; //like yourselves - yourself, elves - elf
            //search for new word recursively
            Result := FindWord(s);

            //if found
            if Result >= 0 then
            begin
              //decrease recursion level and exit
              Dec(ARecursionDeepness);
              Exit;
            end;

          end;

        end;

        //get stem of a word again
        s := Copy(w, 1, Length(w) - Length(FPostDic[i]));

        //check for clean match, stem only
        Result := FindWord(s, False, True);  //clean matching, like goods-good, playing-play etc.
        //if found then
        if Result >= 0 then
        begin
          //decrease recursion level and exit
          Dec(ARecursionDeepness);
          Exit;
        end;

        //check for noun
        //add 'ion' to word's stem
        //search for new word recursively
        Result := FindWord(s + 'ion'); //like creating-creation, destinated-destination
        //if found then
        if Result >= 0 then
        begin
          //decrease recursion level and exit
          Dec(ARecursionDeepness);
          Exit;
        end;

      end;

    end;

    //get rid of possible prefixes using prefix dictionary
    for i := 0 to FPrefDic.Count - 1 do
    begin
      //check with dictionary
      if Copy(w, 1, Length(FPrefDic[i])) = FPrefDic[i] then
      begin
        //get rid of matched prefix
        s := Copy(w, Length(FPrefDic[i]) + 1, Length(w));

        //if stem and prefix separated by '-'
        //delete '-'
        if (s <> '') AND (s[1] = '-') then //self-extractor, semi-colon etc.
          s := Copy(s, 2, Length(s));

        //search for new word recursively
        Result := FindWord(s);

        //if found
        if Result >= 0 then
        begin
          //decrease recursion level and exit
          Dec(ARecursionDeepness);
          Exit;
        end;

      end;
    end;

    //decrease recursion level before exiting
    Dec(ARecursionDeepness);

  end;

var
  i: Integer;
  t: String;
begin

  // init recursion level variable
  ARecursionDeepness := 0;

  //search for word
  i := FindWord(w);

  begin
    Result := False;
    translation := '';

    //if translation found then
    if i >= 0 then
    begin
      //if word is stemmed, add trivia
      if AnsiLowerCase(FMuellerDic[i]) <> AnsiLowerCase(w) then
        translation := translation
           + Format(HTML_MB_WORD_FROM_MASK, [FMuellerDic[i]]);

      Inc(i);

      //add translation
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
      translation := translation + (HTML_CODE_WORD_NOT_FOUND); //translation not found
  end;    
end;


end.
