unit Subtitles;

interface
uses
  Classes, Sysutils, Dialogs;

const
  HEADER_UNICODE = $FEFF;
  MAX_SRT_FILESIZE = 1024 * 1024 * 2; // 2 Mb

type
   TSubtitle = class
   private
     FIndex: Integer;
     FBeginTime: Integer;
     FEndTime: Integer;
     FText: String;
   public
     function isInTime(pos1, pos2: Integer): Boolean; overload;
     function isInTime(time_pos: Integer): Boolean; overload;
     property IntervalStart: Integer read FBeginTime write FBeginTime;
     property IntervalEnd: Integer read FEndTime write FEndTime;
     property Text: String read FText write FText;
     property id: Integer read FIndex write FIndex;
   end;

   PSubtitle = ^TSubtitle;

   TSrtSubtitles = class
   private
     FSubList: TList;
     function ParseTimings(const time: String;
       out ABegin, AEnd: Integer): Boolean;
    function GetSubtitle(Index: Integer): TSubtitle;
    procedure SetSubtitle(Index: Integer; const Value: TSubtitle);
   public
     constructor Create;
     destructor Destroy; override;
     function LoadFromFile(const filename: String): Boolean;
     function LoadUnicodeSubs(const filename: String): Boolean;
     function LoadFromStream(Stream: TStream): Boolean;
     function LoadFromStrings(Strings: TStrings): Boolean;
     function GetTextForTime(milisecs: Integer;
       out Text: String): Integer;
     procedure Clear;
     function GetTimeForIndex(Index: Integer;
       bStartTime: Boolean = True): Integer;
     function GetLastIndexForTime(millisecs: Integer): Integer;
     function Count: Integer;
     property Items[Index: Integer]: TSubtitle read GetSubtitle write SetSubtitle; default;
   end;

implementation

uses Misc;



{ TSubtitle }

function TSubtitle.isInTime(pos1, pos2: Integer): Boolean;
begin
  Result := (pos1 >= FBeginTime) AND (pos2 <= FEndTime);
end;

function TSubtitle.isInTime(time_pos: Integer): Boolean;
begin
  Result := (time_pos >= FBeginTime) AND (time_pos <= FEndTime);
end;

{ TSrtSubtitles }

procedure TSrtSubtitles.Clear;
var
  i: Integer;
begin
  for i := 0 to FSubList.Count - 1 do
  begin
    TSubtitle(FSubList[i]).Free;
    FSubList[i] := nil;
  end;
  FSubList.Clear;
end;

function TSrtSubtitles.Count: Integer;
begin
  Result := FSubList.Count;
end;

constructor TSrtSubtitles.Create;
begin
  FSubList := TList.Create;
end;

destructor TSrtSubtitles.Destroy;
begin
  try
    Clear;
  finally
    FSubList.Free;
    inherited;
  end;
end;

function TSrtSubtitles.GetLastIndexForTime(millisecs: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FSubList.Count - 1 do
  begin
    if (TSubtitle(FSubList[i]).IntervalStart > millisecs) then
    begin
      Result := i - 1;
      Exit;
    end;
  end;
  Result := FSubList.Count - 1;
end;

function TSrtSubtitles.GetSubtitle(Index: Integer): TSubtitle;
begin
  Result := FSubList[Index];
end;

function TSrtSubtitles.GetTextForTime(milisecs: Integer;
  out Text: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  Text := '';
  for i := 0 to FSubList.Count - 1 do
  begin
    if TSubtitle(FSubList[i]).isInTime(milisecs) then
    begin
      Text := TSubtitle(FSubList[i]).Text;
      Result := i;
      Exit;
    end;
  end;
end;

function TSrtSubtitles.GetTimeForIndex(Index: Integer;
  bStartTime: Boolean): Integer;
begin
  Result := -1;
  if (Index >= FSubList.Count) OR (Index < 0) then
    Exit;
  if bStartTime then
    Result := TSubtitle(FSubList[Index]).IntervalStart
  else
    Result := TSubtitle(FSubList[Index]).IntervalEnd;
end;

function TSrtSubtitles.LoadFromFile(const filename: String): Boolean;
var
  ss: TStringList;
begin
  Result := False;

  if NOT LoadUnicodeSubs(filename) then
  begin
    ss := TStringList.Create;
    try
      ss.LoadFromFile(filename);
      Result := LoadFromStrings(ss);
    finally
      ss.Free;
    end;
  end;  
end;

function TSrtSubtitles.LoadFromStream(Stream: TStream): Boolean;
var
  ss: TStringList;
begin
  Result := False;
  ss := TStringList.Create;
  try
    ss.LoadFromStream(Stream);
    Result := LoadFromStrings(ss);
  finally
    ss.Free;
  end;
end;

function TSrtSubtitles.LoadFromStrings(Strings: TStrings): Boolean;
const
  DELIMITER_SUB = '';
var
  i, u, v: Integer;
  sub: TSubtitle;
  ABegin, AEnd: Integer;
begin
  (*

SRT Subtitles

SRT is perhaps the most basic of all subtitle formats.

It consists of four parts, all in text..

1. A number indicating the which subtitle it is in the sequence.
2. The time that the subtitle should appear on the screen, and then disappear.
3. The subtitle itself.
4. A blank line indicating the start of a new subtitle.

When placing SRT in Matroska, part 3 is converted to UTF-8 and placed in the
data portion of the Block. Part 2 is used to set the timecode of the Block,
and BlockDuration element. Nothing else is used.

Here is an example SRT file:

---------------------------------------------------
1
00:02:17,440 --> 00:02:20,375
Senator, we're making
our final approach into Coruscant.

2
00:02:20,476 --> 00:02:22,501
Very good, Lieutenant.

---------------------------------------------------
  *)

  Result := False;
  Clear;
  i := 0;
  while i < Strings.Count do
  begin
    u := i;
    //locate position of next subs
    while (i < Strings.Count) do
    begin
      if (Strings[i] = DELIMITER_SUB) then
        if (i < Strings.Count - 1) AND (Strings[i + 1] <> DELIMITER_SUB) then
          Break;
      Inc(i);
    end;

    //if i >= Strings.Count then
      //i := Strings.Count - 1;

    sub := TSubtitle.Create;
    try
      sub.id := StrToInt(Strings[u]);
    except
      //do not show subtitle error for line 0
      //often occured with UTF-8 files which have special header
      //TODO: process properly
      if u <> 0 then
        ShowMessage(Format('Error in subtitles: %d line', [u]));
      Inc(i);
      Continue;
    end;
    Inc(u);

    try
      if NOT ParseTimings(Strings[u], ABegin, AEnd) then
        raise Exception.Create('cannot parse subtitle timings: ' + Strings[u]);
    except
      ShowMessage(Format('Error in subtitles: %d line', [u]));
    end;

    if (ABegin >= AEnd) then
    begin
      //invalid subtitles - skip
      ShowMessage(Format('Invalid subtitles timing: %d line', [u]));
      Inc(i);
      Continue;
    end;

    sub.IntervalStart := ABegin;
    sub.IntervalEnd := AEnd;
    sub.Text := '';
    Inc(u);

    for v := u to i - 1 do
    begin
      sub.Text := sub.Text + Strings[v] + ' ';
    end;

    FSubList.Add(sub);


    Inc(i);
  end;

  Result := True;
end;

function TSrtSubtitles.LoadUnicodeSubs(const filename: String): Boolean;
var
  Stream: TFileStream;
  MemStream: TMemoryStream;
  wHeader: Word;
  Buffer: Word;
  wstr: WideString;
  len: Integer;
  ss: TStringList;
begin

  //check size and header
  Stream := TFileStream.Create(filename, fmOpenRead);
  Result := False;
  try
    Stream.Position := 0;
    Stream.Read(wHeader, SizeOf(wHeader));
    if (wHeader <> HEADER_UNICODE) OR (Stream.Size > MAX_SRT_FILESIZE) then
    begin
      Stream.Free;
      Stream := nil;
      Exit;
    end;

    //prepare
    len := Stream.Size - SizeOf(wHeader);
    SetLength(wstr, len div SizeOf(Word));


    //parse file
    if Stream.Read(wstr[1], len) = len then
    begin
      ss := TStringList.Create;
      try
        ss.SetText(PAnsiChar(String(wstr)));
        Result := Self.LoadFromStrings(ss);
      finally
        ss.Free;
      end;
    end;

  finally
    Stream.Free;
    SetLength(wstr, 0);
  end;
end;

function TSrtSubtitles.ParseTimings(const time: String; out ABegin,
  AEnd: Integer): Boolean;
const
  DELIMITER_TIME = ' --> ';
var
  po: Integer;
  s: String;
begin
  Result := False;
  po := Pos(DELIMITER_TIME, time);
  if po < 0 then
    Exit;
  ABegin := ConvertStrTimeToMilliseconds(Trim(Copy(time, 1, po)), '::,');

  s := Trim(Copy(time, po + Length(DELIMITER_TIME), Length(time)));
  try
    AEnd := ConvertStrTimeToMilliseconds(s, '::,');
  except
    //there also could be subs coordinates after space character
    //cut it
    s := Copy(s, 1, Pos(' ', s) - 1);
    AEnd := ConvertStrTimeToMilliseconds(s, '::,');
  end;
  Result := True;
end;

procedure TSrtSubtitles.SetSubtitle(Index: Integer;
  const Value: TSubtitle);
begin
  if Index < Count then
  begin
    TSubtitle(FSubList[Index]).Free;
    FSubList[Index] := Value;
  end else
  begin
    raise Exception.Create('SetSubtitle: Index >= Count');
  end;
end;

end.
