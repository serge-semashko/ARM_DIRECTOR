unit UMyLists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, JPEG;

Type
  TDependentField = Class(Tobject)
  public
    Name : string;
    visible : boolean;
    TypeObject : string;
    TypeField : string;
    Text : string;
    Data : longint;
    Bool : Boolean;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    constructor Create;
    destructor  Destroy; override;
  end;

  TOneString = Class(Tobject)
    public
    Value : String;
    count : integer;
    Lists : array of TDependentField;
    procedure Clear;
    function AddField(Name : string) : integer;
    procedure SetVisible(Name : string; Visible : boolean);
    function Visible(Name : string) : boolean;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    constructor Create;
    destructor  Destroy; override;
  end;

  TOneList = Class(Tobject)
    public
    Name : String;
    count : integer;
    Lists : array of TOneString;
    procedure Clear;
    function AddString(Value : string) : integer;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    constructor Create;
    destructor  Destroy; override;
  end;

  TProgrammLists = Class(Tobject)
    public
    count : integer;
    Lists : array of TOneList;
    procedure Names(var lst : tstrings);
    function ReadList(Name : string; lst : tstrings) : integer;
    procedure ReadListNumber(Index : integer; var lst : tstrings);
    procedure Clear;
    function AddList(Name : string) : integer;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    constructor Create;
    destructor  Destroy; override;
  end;

Var ProgrammLists : TProgrammLists;
    AIndex, APos, AFld : integer;
implementation

//************* TDependentField *****************
Constructor TDependentField.Create;
begin
  inherited;
  Name :='';
  Visible := true;
  TypeObject := 'Phrase';
  TypeField := 'integer';
  Text :='';
  Data :=0;
  Bool := false;
end;

Destructor TDependentField.Destroy;
begin
  FreeMem(@Name);
  FreeMem(@Visible);
  FreeMem(@TypeObject);
  FreeMem(@TypeField);
  FreeMem(@Text);
  FreeMem(@Data);
  FreeMem(@Bool);
  inherited;
end;

Procedure TDependentField.WriteToStream(F : tStream);
begin
  //WriteBufferStr(F, Name);
  F.WriteBuffer(visible, SizeOf(Boolean));
  //WriteBufferStr(F, TypeObject);
  //WriteBufferStr(F, TypeField);
  //WriteBufferStr(F, Text);
  F.WriteBuffer(Data, SizeOf(longint));
  F.WriteBuffer(Bool, SizeOf(Boolean));
end;

Procedure TDependentField.ReadFromStream(F : tStream);
begin
  //ReadBufferStr(F, Name);
  F.ReadBuffer(visible, SizeOf(Boolean));
  //ReadBufferStr(F, TypeObject);
  //ReadBufferStr(F, TypeField);
  //ReadBufferStr(F, Text);
  F.ReadBuffer(Data, SizeOf(longint));
  F.ReadBuffer(Bool, SizeOf(Boolean));
end;

//************* TOneString *********************
Constructor TOneString.Create;
begin
  inherited;
  Value :='';
  count :=0;
end;

Destructor TOneString.Destroy;
var i : integer;
begin
  FreeMem(@Value);
  FreeMem(@count);
  Clear;
  FreeMem(@Lists);
  inherited;
end;

Procedure TOneString.Clear;
var i : integer;
begin
  for i:=count-1 downto 0 do Lists[i].FreeInstance;
  count := 0;
  Setlength(Lists,Count);
end;

function TOneString.AddField(Name : String) : integer;
begin
  Count := Count+1;
  Setlength(Lists,Count);
  Lists[Count-1] := TDependentField.Create;
  Lists[Count-1].Name:=Name;
  Lists[Count-1].Visible:=true;
  result := Count-1;
end;

procedure TOneString.SetVisible(Name : string; Visible : boolean);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if trim(lowercase(Name)) = trim(lowercase(Lists[i].Name)) then begin
      Lists[i].Visible:=Visible;
      exit;
    end;
  end;
end;

function TOneString.Visible(Name : string) : boolean;
var i : integer;
begin
  result := false;
  for i:=0 to Count-1 do begin
    if trim(lowercase(Name)) = trim(lowercase(Lists[i].Name)) then begin
      result:=Lists[i].Visible;
      exit;
    end;
  end;
end;

Procedure TOneString.WriteToStream(F : tStream);
var i : integer;
begin
  //WriteBufferStr(F, Value);
  F.WriteBuffer(count, SizeOf(integer));
  for i:=0 to count-1 do Lists[i].WriteToStream(F);
end;

Procedure TOneString.ReadFromStream(F : tStream);
var i : integer;
begin
  //ReadBufferStr(F, Value);
  F.ReadBuffer(count, SizeOf(integer));
  clear;
  for i:=0 to count-1 do begin
    Setlength(Lists, i+1);
    Lists[i] := TDependentField.Create;
    Lists[i].ReadFromStream(F);
  end;
end;

//************* TOneList *********************
Constructor TOneList.Create;
begin
  inherited;
  Name :='';
  count :=0;
end;

Destructor TOneList.Destroy;
var i : integer;
begin
  FreeMem(@Name);
  FreeMem(@count);
  Clear;
  FreeMem(@Lists);
  inherited;
end;

Procedure TOneList.Clear;
var i : integer;
begin
  for i:=count-1 downto 0 do Lists[i].FreeInstance;
  count := 0;
  Setlength(Lists,Count);
end;

function TOneList.AddString(Value : string) : integer;
begin
  Count := Count+1;
  Setlength(Lists,Count);
  Lists[Count-1] := TOneString.Create;
  Lists[Count-1].Value:=Value;
  result := Count-1;
end;

Procedure TOneList.WriteToStream(F : tStream);
var i : integer;
begin
  //WriteBufferStr(F, Name);
  F.WriteBuffer(count, SizeOf(integer));
  for i:=0 to count-1 do Lists[i].WriteToStream(F);
end;

Procedure TOneList.ReadFromStream(F : tStream);
var i : integer;
begin
  //ReadBufferStr(F, Name);
  F.ReadBuffer(count, SizeOf(integer));
  clear;
  for i:=0 to count-1 do begin
    Setlength(Lists, i+1);
    Lists[i] := TOneString.Create;
    Lists[i].ReadFromStream(F);
  end;
end;

//************* TProgrammLists *********************
Constructor TProgrammLists.Create;
begin
  inherited;
  count :=0;
end;

Destructor TProgrammLists.Destroy;
var i : integer;
begin
  FreeMem(@count);
  Clear;
  FreeMem(@Lists);
  inherited;
end;

Procedure TProgrammLists.Clear;
var i : integer;
begin
  for i:=count-1 downto 0 do Lists[i].FreeInstance;
  count := 0;
  Setlength(Lists,Count);
end;

function TProgrammLists.AddList(Name : string) : integer;
begin
  Count := Count+1;
  Setlength(Lists,Count);
  Lists[Count-1] := TOneList.Create;
  Lists[Count-1].Name:=Name;
  result := Count-1;
end;

procedure TProgrammLists.Names(var lst : tstrings);
var i : integer;
begin
  lst.Clear;
  for i:=0 to Count-1 do lst.Add(Lists[i].Name);
end;

function TProgrammLists.ReadList(Name : string; lst : tstrings) : integer;
var i, j : integer;
begin
  result := -1;
  for i:=0 to Count-1 do begin
    if trim(lowercase(Lists[i].Name))=trim(lowercase(Name)) then begin
       lst.Clear;
       for j:=0 to Lists[i].count-1 do lst.Add(Lists[i].Lists[j].Value);
       result:=i;
       exit;
    end;
  end;
end;

procedure TProgrammLists.ReadListNumber(Index : integer; var lst : tstrings);
var i : integer;
begin
  lst.Clear;
  for i:=0 to Lists[index].count-1 do lst.Add(Lists[index].Lists[i].Value);
end;

Procedure TProgrammLists.WriteToStream(F : tStream);
var i : integer;
begin
  F.WriteBuffer(count, SizeOf(integer));
  for i:=0 to count-1 do Lists[i].WriteToStream(F);
end;

Procedure TProgrammLists.ReadFromStream(F : tStream);
var i : integer;
begin
  F.ReadBuffer(count, SizeOf(integer));
  clear;
  for i:=0 to count-1 do begin
    Setlength(Lists, i+1);
    Lists[i] := TOneList.Create;
    Lists[i].ReadFromStream(F);
  end;
end;

initialization

  ProgrammLists := TProgrammLists.Create;

  // список переходов протокола GVG100
  AIndex := ProgrammLists.AddList('GVG100Command');
  APos := ProgrammLists.Lists[AIndex].AddString('Cut');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Duration');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=false;
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Set');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=false;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';

  APos := ProgrammLists.Lists[AIndex].AddString('Mix');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Duration');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=true;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeField:='shorttimecode';
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Set');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=false;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';

  APos := ProgrammLists.Lists[AIndex].AddString('Wipe');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Duration');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=true;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeField:='shorttimecode';
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Set');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=true;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';

  APos := ProgrammLists.Lists[AIndex].AddString('Ignore');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Duration');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=false;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('Set');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Visible:=false;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Phrase';

  // список наборов для протокола GVG100
  AIndex := ProgrammLists.AddList('GVG100Set');
  APos := ProgrammLists.Lists[AIndex].AddString('0');
  APos := ProgrammLists.Lists[AIndex].AddString('1');
  APos := ProgrammLists.Lists[AIndex].AddString('2');
  APos := ProgrammLists.Lists[AIndex].AddString('3');
  APos := ProgrammLists.Lists[AIndex].AddString('4');
  APos := ProgrammLists.Lists[AIndex].AddString('5');
  APos := ProgrammLists.Lists[AIndex].AddString('6');
  APos := ProgrammLists.Lists[AIndex].AddString('7');
  APos := ProgrammLists.Lists[AIndex].AddString('8');
  APos := ProgrammLists.Lists[AIndex].AddString('9');
  APos := ProgrammLists.Lists[AIndex].AddString('10');
  APos := ProgrammLists.Lists[AIndex].AddString('11');
  APos := ProgrammLists.Lists[AIndex].AddString('12');
  APos := ProgrammLists.Lists[AIndex].AddString('13');
  APos := ProgrammLists.Lists[AIndex].AddString('14');
  APos := ProgrammLists.Lists[AIndex].AddString('15');

  // список основных цветов
  AIndex := ProgrammLists.AddList('MainColors');
  APos := ProgrammLists.Lists[AIndex].AddString('White');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clWhite;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Aqua');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clAqua;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Fuchsia');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clFuchsia;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Blue');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clBlue;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Yellow');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clYellow;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Lime');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clLime;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Red');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clRed;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Silver');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clSilver;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Gray');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clGray;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Teal');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clTeal;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Purple');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clPurple;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Navy');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clNavy;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Olive');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clOlive;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Green');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clGreen;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Maroon');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clMaroon;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  APos := ProgrammLists.Lists[AIndex].AddString('Black');
  AFld := ProgrammLists.Lists[AIndex].Lists[APos].AddField('FontColor');
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].Data:=clBlack;
  ProgrammLists.Lists[AIndex].Lists[APos].Lists[AFld].TypeObject:='Event';

  //

end.
