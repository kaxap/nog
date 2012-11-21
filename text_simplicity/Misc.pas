unit Misc;

interface
  uses Classes, ActiveX, SysUtils, DirectShow9;

  function FindFilter(graph: IGraphBuilder; iid: TGUID): IBaseFilter;

  function isRomanDigits(const s: String): Boolean;
  function isLatinWord(const s: String): Boolean;
  function ConvertStrTimeToMilliseconds(const s: String;
     const delimiters: String): Integer;

  function EscapeHtmlChars(const s: String): String;

  function EscapeInvalidChars(const s: String): String;

  //deprecated
  type
    TPinItem = class
      Pin: IPin;
      MediaType: _AMMediaType;
    end;

    TPinCollector = class
    private
      List: TList;
    public
      constructor Create;
      destructor Destroy; override;
      function Add(PinItem: TPinItem): Integer;
      procedure Delete(Index: Integer);
      function Get(Index: Integer): TPinItem;
      procedure Put(Index: Integer; Item: TPinItem);
      procedure Clear;
      property Items[Index: Integer]: TPinItem read Get write Put; default;
      function Find(Pin: IPin): Integer;
    end;

    procedure ExplodeToWords(s: string; ss: TStringList);
    procedure ExplodeToWordsOnlyLetters(s: String; ss: TStringList);


implementation

uses Constants;

procedure ExplodeToWordsOnlyLetters(s: String; ss: TStringList);
const
  SEPARATOR = ' =~!@#$%^&*()_+'#9'|\?/>.<,][{}:;"';
var i, j: Integer;
    w: String;
    bFound: Boolean;
begin
  w := '';
  for i := 1 to Length(s) do
  begin
    bFound := False;
    for j := 1 to Length(SEPARATOR) do
    begin
      if s[i] = SEPARATOR[j] then
      begin
        bFound := True;
        Break;
      end;
    end;

    if (bFound) then
    begin
      if (w <> '') then
      begin
        ss.Add(w);
        w := '';
      end;
    end else
      w := w + s[i];
  end;
end;

procedure ExplodeToWords(s: String; ss: TStringList);
const
  SEPARATOR = ' =~!@#$%^&*()_+'#9'|\?/>.<,][{}:;"';
var i, j: Integer;
    w: String;
    bFound: Boolean;
begin
  w := '';
  for i := 1 to Length(s) do
  begin
    {bFound := False;
    for j := 1 to Length(SEPARATOR) do
    begin
      if s[i] = SEPARATOR[j] then
      begin
        bFound := True;
        Break;
      end;
    end;}

    if ({bFound} s[i] = #$20) then
    begin
      if (w <> '') then
      begin
        {if (s[i] <> '"') then
          ss.Add(w + s[i])
        else
          ss.Add(w + '\"');}
        ss.Add(w);
        w := '';
      end;
    end else
    begin
      if (s[i] <> '"') then
        w := w + s[i]
      else
        w := w + '\"';
    end;
  end;
end;


function EscapeInvalidChars(const s: String): String;
const
  VALID = '`-=~!@#$%^&*()_+'#9'|\?/>.<,][{}:;"''';
var
  i, j: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
  begin
    if (s[i] in [' ', 'a'..'z']) then
      Result := Result + s[i]
      else if (s[i] in ['A'..'Z']) then
        Result := Result + s[i]
        else if (s[i] in ['0'..'9']) then
         Result := Result + s[i]
           else if (s[i] in ['À'..'ß']) then
             Result := Result + s[i]
               else if (s[i] in ['à'..'ÿ']) then
                  Result := Result + s[i];
    for j := 1 to Length(VALID) do
    begin
      if s[i] = VALID[j] then
      begin
        Result := Result + s[i];
        Break;
      end;
    end;
  end;
end;

function findFilter(graph: IGraphBuilder; iid: TGUID): IBaseFilter;
var
  vobfil: IBaseFilter;
  pEnum: IEnumFilters;
  hr: HRESULT;
  classid: TGUID;
begin
  Result := nil;
  //display vobsub filter property page
  try
    graph.EnumFilters(pEnum);
  except
    Exit;
  end;

  vobfil := nil;

  //enum all filters in the graph
  if (pEnum <> nil) then
  begin
    while SUCCEEDED(pEnum.Next(1, vobfil, nil)) do
    begin
      if nil = vobfil then
        Break;

      if SUCCEEDED(vobfil.GetClassID(classid)) then
      begin

        if IsEqualGUID(classid, iid) then
        begin
          Result := vobfil;
          Exit;
        end;
      end;

    end;
  end;


end;

function isLatinWord(const s: String): Boolean;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
  begin
    if NOT (s[i] in LATIN_WORD_LETTERS) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function isRomanDigits(const s: String): Boolean;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
  begin
    if NOT (s[i] in ROME_DIGITS) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function ConvertStrTimeToMilliseconds(const s: String;
   const delimiters: String): Integer;
var
  times: array[1..4] of Integer;
  dindex, i: Integer;
  t: String;

begin
  times[1] := 0;
  times[2] := 0;
  times[3] := 0;
  times[4] := 0;

  Result := -1;
  dindex := 1;
  i := 0;
  t := '';
  while dindex <= Length(delimiters) do
  begin
    Inc(i);
    if s[i] <> delimiters[dindex] then
    begin
      t := t + s[i];
    end else
    begin
      times[dindex] := StrToInt(Trim(t));
      Inc(dindex);
      t := '';
    end;
  end;

  t := Copy(s, i + 1, Length(s));
  times[4] := StrToInt(Trim(t));
  Result := times[1] * 3600 * 1000 + times[2] * 60 * 1000 + times[3] * 1000 +
     times[4];
end;

function EscapeHtmlChars(const s: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
  begin
    case s[i] of
      ' ': Result := Result + '&nbsp;';
      '"': Result := Result + '&quot;';
      '&': Result := Result + '&amp;';
      '<': Result := Result + '&lt;';
      '>': Result := Result + '&gt;';
    else
      Result := Result + s[i];
    end;    
  end;
end;

{ TPinCollector }

function TPinCollector.Add(PinItem: TPinItem): Integer;
begin
  Result := List.Add(PinItem)
end;

procedure TPinCollector.Clear;
var
  i: Integer;
begin
  for i := 0 to List.Count - 1 do
  begin
    TPinItem(List[i]).Free;
    List[i] := nil;
  end;

  List.Clear;
end;

constructor TPinCollector.Create;
begin
  List := TList.Create;
end;

procedure TPinCollector.Delete(Index: Integer);
begin
  TPinItem(List[Index]).Free;
  List.Delete(Index);
end;

destructor TPinCollector.Destroy;
begin
  try
    Clear;
  finally
    List.Free;
    inherited;
  end;  
end;

function TPinCollector.Find(Pin: IPin): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to List.Count - 1 do
    if Self[i].Pin = Pin then
    begin
      Result := i;
      Break;
    end;
end;

function TPinCollector.Get(Index: Integer): TPinItem;
begin
  Result := List[Index];
end;

procedure TPinCollector.Put(Index: Integer; Item: TPinItem);
begin
  if (List[Index] <> Item) then
  begin
    TPinItem(List[Index]).Free;
    List[Index] := Item;
  end;
end;

end.
