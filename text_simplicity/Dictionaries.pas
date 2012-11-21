unit Dictionaries;

interface
  uses Classes, Sysutils, Dialogs;

const
  CHAR_LOW = 0;
  CHAR_MAX = 255;
type

  TWord = record
    key: Integer;
    hash: Integer;
  end;

  PWord = ^TWord;

  TWordDictionary = class
  private
    FCount: Integer;
    FList: array[CHAR_LOW..CHAR_MAX] of TStringList;
    function hashStr(const s: String): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(word: String; Key: Integer);
    procedure Delete(word: String);
    procedure Clear;
    function Find(word: String): Integer;
    function UpdateKeyOrCreate(word: String; Value: Integer): Boolean;
    function GetStringList(var ss: TStringList): Boolean;
    property Count: Integer read FCount;
  end;

  TSimpleAliasList = class
  private
    FWords: TStringList;
    FAliases: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const word, alias: String): Integer;
    function Get(Index: Integer; out word, alias: String): Boolean;
    function FindAlias(const word: String): String;
    function FindWord(const alias: String): String;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Count: Integer;
    procedure LoadFromStrings(ss: TStrings; const delimiter: String);
    procedure LoadFromFile(const filename, delimiter: String);
 end;


implementation

{ TWordDictionary }

procedure TWordDictionary.Add(word: String; Key: Integer);
var
  first: Integer;
  pW: PWord;
begin
  word := AnsiLowerCase(word);
  first := Ord(word[1]);
  if NOT (Assigned(FList[first])) then
  begin
    FList[first] := TStringList.Create;
    //FList[first].Sorted := True;
    //FList[first].CaseSensitive := True;
  end;

  New(pW);
  pW^.key := Key;
  //compute string hash
  pW^.hash := hashStr(word);
  FList[first].AddObject(word, TObject(pW));

  Inc(FCount);
end;

procedure TWordDictionary.Clear;
var
  i, j: Integer;
  pW: PWord;
begin
  FCount := 0;
  
  //clear and dispose PWord objects from the list
  for i := CHAR_LOW to CHAR_MAX do
    if Assigned(FList[i]) then
    begin
      for j := 0 to FList[i].Count - 1 do
      begin
        pW := PWord(FList[i].Objects[j]);
        Dispose(pW);
      end;
      FList[i].Free;
      FList[i] := nil;
    end;

end;

constructor TWordDictionary.Create;
var
  i: Integer;
begin
  FCount := 0;
  
  //initialize array with nils
  for i := CHAR_LOW to CHAR_MAX do
    FList[i] := nil;
end;

procedure TWordDictionary.Delete(word: String);
var
  first: Integer;
  i, hash: Integer;
  pW: PWord;
begin
  word := AnsiLowerCase(word);
  first := Ord(word[1]);
  if NOT (Assigned(FList[first])) then
    Exit;

  hash := hashStr(word);
  
  //find string by hash and direct compare it
  //then dispose and delete
  for i := 0 to FList[first].Count - 1 do
  begin
    pW := PWord(FList[first].Objects[i]);
    if (pW^.hash = hash) AND (FList[first][i] = word) then
    begin
      Dispose(pW);
      FList[first].Delete(i);
      Dec(FCount);
      Exit;
    end;
  end;


end;

destructor TWordDictionary.Destroy;
begin
  Clear;
  inherited;
end;

function TWordDictionary.Find(word: String): Integer;
var
  first: Integer;
  i: Integer;
  pW: PWord;
  hash: Integer;
begin
  Result := -1;
  if '' = word then
    Exit;

  //find word by hash and direct
  //return key as result
  word := AnsiLowerCase(word);

  first := Ord(word[1]);
  if NOT (Assigned(FList[first])) then
    Exit;

  hash := hashStr(word);

  for i := 0 to FList[first].Count - 1 do
  begin
    pW := PWord(FList[first].Objects[i]);
    if (pW^.hash = hash) AND (FList[first][i] = word) then
    begin
      Result := pW^.key;
      Exit;
    end;
  end;

end;

function TWordDictionary.UpdateKeyOrCreate(word: String;
  Value: Integer): Boolean;
var
  first: Integer;
  i: Integer;
  pW: PWord;
  hash: Integer;
begin
  Result := False;
  if '' = word then
    Exit;

  //find word by hash and direct
  word := AnsiLowerCase(word);

  first := Ord(word[1]);
  if NOT (Assigned(FList[first])) then
  begin
    //create new one
    Self.Add(word, Value);
    Result := True;
    Exit;
  end;

  hash := hashStr(word);

  for i := 0 to FList[first].Count - 1 do
  begin
    pW := PWord(FList[first].Objects[i]);
    if (pW^.hash = hash) AND (FList[first][i] = word) then
    begin
      //key found
      //update it
      pW^.key := pW^.key + Value;
      Result := True;
      Exit;
    end;
  end;

  //create new one
  Self.Add(word, Value);
  Result := True;
end;

function TWordDictionary.GetStringList(var ss: TStringList): Boolean;
var
  i, j: Integer;
  pW: PWord;
begin
  Result := False;
  if (ss = nil) then
    Exit;

  //clear and dispose PWord objects from the list
  for i := CHAR_LOW to CHAR_MAX do
    if Assigned(FList[i]) then
    begin
      for j := 0 to FList[i].Count - 1 do
      begin
        pW := PWord(FList[i].Objects[j]);
        ss.AddObject(FList[i][j], Pointer(pW^.key));
      end;
    end;
end;

function TWordDictionary.hashStr(const s: String): Integer;
var
  i : Integer;
begin
  //compute hash of given string
  Result := Length(s);
  for i := 1 to Length(s) do
    Result := ((Result shr 5) xor (Result shl 27)) xor Ord(s[i]);
end;

{ TSimpleAlias }

function TSimpleAliasList.Add(const word, alias: String): Integer;
begin
  Result := FWords.Add(word);
  FAliases.Add(alias);
end;

procedure TSimpleAliasList.Clear;
begin
  FWords.Clear;
  FAliases.Clear;
end;

function TSimpleAliasList.Count: Integer;
begin
  Result := FWords.Count;
end;

constructor TSimpleAliasList.Create;
begin
  FWords := TStringList.Create;
  FAliases := TStringList.Create;
end;

procedure TSimpleAliasList.Delete(Index: Integer);
begin
  FWords.Delete(Index);
  FAliases.Delete(Index);
end;

destructor TSimpleAliasList.Destroy;
begin
  FWords.Free;
  FAliases.Free;
  inherited;
end;

function TSimpleAliasList.FindAlias(const word: String): String;
var
  i: Integer;
begin
  i := FWords.IndexOf(word);
  if i >= 0 then
    Result := FAliases[i]
  else
    Result := '';
end;

function TSimpleAliasList.FindWord(const alias: String): String;
var
  i: Integer;
begin
  i := FAliases.IndexOf(alias);
  if i >= 0 then
    Result := FWords[i]
  else
    Result := '';
end;

function TSimpleAliasList.Get(Index: Integer; out word,
  alias: String): Boolean;
begin
  if Index >= FWords.Count then
  begin
    Result := False;
    Exit;
  end;

  word := FWords[Index];
  alias := FAliases[Index];
  Result := True;
end;

procedure TSimpleAliasList.LoadFromFile(const filename, delimiter: String);
var
  ss: TStringList;
begin
  ss := TStringList.Create;
  try
    ss.LoadFromFile(filename);
    LoadFromStrings(ss, delimiter);
  finally
    ss.Free;
  end;
end;

procedure TSimpleAliasList.LoadFromStrings(ss: TStrings;
  const delimiter: String);
var
  i, j: Integer;
  alias, word: String;
begin
  for i := 0 to ss.Count - 1 do
  begin
    j := Pos(delimiter, ss[i]);
    if j > 0 then
    begin
      word := Copy(ss[i], 1, j - 1);
      alias := Copy(ss[i], j + 1, Length(ss[i]));
      FWords.Add(word);
      FAliases.Add(alias);
    end;
  end;
end;



end.
