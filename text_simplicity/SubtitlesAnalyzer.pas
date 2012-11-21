unit SubtitlesAnalyzer;

interface
uses Windows, SysUtils, Classes, Graphics, Subtitles, IntegerList, Dictionaries;

type
  TSubtitlesAnalyzer = class
  private
    FSubtitles: TSrtSubtitles;
    FFreqDict: TWordDictionary;
    FData: TIntegerList;
    FSubsWordCount: Integer;
  public
    constructor Create(subs: TSrtSubtitles;
      freqDict: TWordDictionary);
    procedure Analyze;
    function GetWordCount: Integer;
    function GetExpectedValue: Integer;
    function GetVariance: Integer;
    function GetHysto(const height, width: Integer;
      skipfirst: Integer): TBitmap;
  end;


implementation

uses Misc;



{ TSubtitlesAnalyzer }

procedure TSubtitlesAnalyzer.Analyze;
var
  i, j, k: Integer;
  s: String;
  ss: TStringList;
  rating: TWordDictionary;
begin
  //clear previous data
  FData.Clear;
  FSubsWordCount := 0;

  //create temporary string list
  ss := TStringList.Create;
  //create subs dictionary
  rating := TWordDictionary.Create;

  try
    //update data count
    //last one (+1) is for unknown words
    FData.Count := FFreqDict.Count + 1;

    //enum entries
    for i := 0 to FSubtitles.Count - 1 do
    begin
      //get text and explode it to words
      s := FSubtitles[i].Text;
      ss.Clear;
      ExplodeToWordsOnlyLetters(s, ss);

      //enum words
      for j := 0 to ss.Count - 1 do
      begin
        //if exists - increment key by 1
        //otherwise create new with key 1
        //key is actually a word count
        rating.UpdateKeyOrCreate(ss[j], 1);
      end;
    end;

    //clear temporary list
    ss.Clear;
    //get string list for collected data
    rating.GetStringList(ss);

    //enum entries
    for i := 0 to ss.Count - 1 do
    begin
      //find word in frequency dictionary
      k := FFreqDict.Find(ss[i]);

      //if not found
      //add data to last column (all uknown words)
      if k < 0 then
        k := FFreqDict.Count;

     //collect data
     //add words count to data column k
      FData[k] := FData[k] + Integer(ss.Objects[i]);
      
      //increment total words count
      Inc(FSubsWordCount, Integer(ss.Objects[i]));
    end;


    FData.CollectInfo(FSubsWordCount);
  finally
    rating.Free;
    ss.Free;
  end;
end;

constructor TSubtitlesAnalyzer.Create(subs: TSrtSubtitles;
  freqDict: TWordDictionary);
begin
  FSubtitles := subs;
  FFreqDict := freqDict;
  FSubsWordCount := -1;
  FData := TIntegerList.Create;
end;

function TSubtitlesAnalyzer.GetExpectedValue: Integer;
begin
  Result := FData.ExpectedValue;
end;

function TSubtitlesAnalyzer.GetHysto(const height,
  width: Integer; skipfirst: Integer): TBitmap;

  function limitToByte(a: Integer): Integer;
  begin
    if (a < 0) then
      Result := 0
    else if (a > 255) then
      Result := 255
    else Result := a;    
  end;

var
  bm: TBitmap;
  modh: Integer;
  modw: Integer;
  i, j, k: Integer;
  data: TIntegerList;
  divisor: Integer;
begin
  Result := nil;
  bm := TBitmap.Create;
  data := TIntegerList.Create;
  try
    bm.Width := width;
    bm.Height := height;
    bm.Canvas.Brush.Color := $222222;
    bm.Canvas.FillRect(Rect(0,0,width, height));

    modw := (FData.Count - skipfirst) div width;
    data.Count := width + 1;

    j := 0;
    k := 0;
    for i := skipfirst to FData.Count - 1 do
    begin
      data[j] := data[j] + FData[i];
      Inc(k);
      if k > modw then
      begin
        Inc(j);
        k := 0;
      end;
    end;


    //data.CollectInfo;


    modh := data.TheBiggest div height;
    if modh = 0 then
      modh := 1;


    divisor := data.Count div 10;
    for i := 0 to data.Count - 1 do
    begin
      bm.Canvas.Pen.Color := RGB(limitToByte((i * 255) div divisor),
        limitToByte(255 - (255*i) div divisor), 100);
      bm.Canvas.MoveTo(i, height);
      bm.Canvas.LineTo(i, height - data[i] div modh);
    end;

    Result := bm;

  except
    Result := nil;
    bm.Free;
    data.Free;
  end;
end;

function TSubtitlesAnalyzer.GetVariance: Integer;
begin
  Result := FData.Variance;
end;

function TSubtitlesAnalyzer.GetWordCount: Integer;
begin
  Result := FSubsWordCount;
end;

end.
