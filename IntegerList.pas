unit IntegerList;

interface
  uses Classes;

type
  TIntegerList = class
  protected
    FList: TList;
    function Get(Index: Integer): Integer;
    procedure Put(Index: Integer; const Value: Integer);
  private
    FBiggest: Integer;
    FBiggestIndex: Integer;
    FLowest: Integer;
    FLowestIndex: Integer;
    FExpected: Integer;
    procedure SetCount(const Value: Integer);
    function GetCount: Integer;
    function GetCapacity: Integer;
    procedure SetCapacity(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: Integer): Integer;
    procedure Delete(Index: Integer);
    function First: Integer;
    function IndexOf(Item: Integer): Integer;
    procedure Insert(Index: Integer; Item: Integer);
    function Last: Integer;
    function Remove(Item: Integer): Integer;
    procedure Sort;
    procedure Clear;
    function CollectInfo(total: Integer = 0): Integer;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: Integer read Get write Put; default;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property TheBiggest: Integer read FBiggest;
    property TheBiggestIndex: Integer read FBiggestIndex;
    property TheLowest: Integer read FLowest;
    property TheLowestIndex: Integer read FLowestIndex;
    property ExpectedValue: Integer read FExpected;
  end;



implementation

function Compare(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(Item1) - Integer(Item2);
end;

{ TIntegerList }

function TIntegerList.Add(Item: Integer): Integer;
begin
  Result := FList.Add(Pointer(Item));
end;

procedure TIntegerList.Clear;
begin
  FList.Clear;
end;

constructor TIntegerList.Create;
begin
  FList := TList.Create;
end;

procedure TIntegerList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TIntegerList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TIntegerList.First: Integer;
begin
  Result := Integer(FList.First);
end;

function TIntegerList.Get(Index: Integer): Integer;
begin
  Result := Integer(FList[Index]);
end;

function TIntegerList.CollectInfo(total: Integer = 0): Integer;
var
  i, j: Integer;
  mean: Double;
begin
  FLowest := High(Integer);
  FLowestIndex := -1;
  FBiggest := Low(Integer);
  FBiggestIndex := -1;

  //if total not given
  if (total = 0) then
    for i := 0 to FList.Count - 1 do
       total := total + (Integer(FList[i]));

  mean := 0.0;
       
  for i := 0 to FList.Count - 1 do
  begin
    j := Integer(FList[i]);

    if j > FBiggest then
    begin
      FBiggest := j;
      FBiggestIndex := i;
    end;

    if j < FLowest then
    begin
      FLowest := j;
      FLowestIndex := i;
    end;

    mean := mean + (j / total * i);
  end;

  FExpected := Round(mean);
end;

function TIntegerList.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TIntegerList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TIntegerList.IndexOf(Item: Integer): Integer;
begin
  Result := FList.IndexOf(Pointer(Item));
end;

procedure TIntegerList.Insert(Index, Item: Integer);
begin
  FList.Insert(Index, Pointer(Item));
  inherited;

end;

function TIntegerList.Last: Integer;
begin
  Result := Integer(FList.Last);
end;

procedure TIntegerList.Put(Index: Integer; const Value: Integer);
begin
  FList[Index] := Pointer(Value);
end;

function TIntegerList.Remove(Item: Integer): Integer;
begin
  Result := FList.Remove(Pointer(Item));
end;

procedure TIntegerList.SetCapacity(const Value: Integer);
begin
  FList.Capacity := Value;
end;

procedure TIntegerList.SetCount(const Value: Integer);
begin
  FList.Count := Value;
end;

procedure TIntegerList.Sort;
var
  c: TListSortCompare;
begin
  c := Compare;
  FList.Sort(c);
end;

end.
