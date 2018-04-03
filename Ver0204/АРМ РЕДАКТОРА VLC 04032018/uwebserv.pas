unit uwebserv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, system.json, system.win.crtl;

type
  THandledObject = class(TObject)
  protected
    FHandle: THandle;
  public
    destructor Destroy; override;
    property Handle: THandle read FHandle;
  end;

  TSharedMem = class(THandledObject)
  private
    FName: string;
    FSize: Integer;
    FCreated: Boolean;
    FFileView: Pointer;
  public
    constructor Create(const Name: string; Size: Integer);
    destructor Destroy; override;
    property Name: string read FName;
    property Size: Integer read FSize;
    property Buffer: Pointer read FFileView;
    property Created: Boolean read FCreated;
  end;

  // Function setVariable(ObjName,VarName:widestring;value:string);
  THardRec = packed record
    DateTimeSTR: array [0 .. 5] of ansichar;
    UpdateCounter: int64;
    VersionSignature: array [0 .. 5] of ansichar;
    JSONAll: array [0 .. 1000000] of ansichar;
    JSONStore: array [0 .. 1000000] of ansichar;

  end;

  PHardRec = ^THardRec;

var
  HardRec: PHardRec;
  testbuf: array [0 .. 1000] of byte absolute HardRec;
  shared: TSharedMem;

var
  PortNum: Integer = 9091;

var
  tmpjSon: ansistring;
  Jevent, JDev, jAirsecond: TStringList;
  Jmain: ansistring;
  jsonresult: ansistring;
procedure BeginJson;
procedure SaveJson;
Function addVariable(ObjNum: Integer; varname, VarValue: string)
  : Integer; overload;
Function addVariable(ObjNum: Integer; arrName, Elementid, varname,
  VarValue: string): Integer; overload;
Procedure AddToJSONStore(varname: string; json: tjsonobject);

implementation

Procedure AddToJSONStore(varname: string; json: tjsonobject);
var
  tmjson: tjsonobject;
  tmpstr: ansistring;
  i1: Integer;
begin
  tmjson := tjsonobject.ParseJSONValue
    (TEncoding.UTF8.GetBytes(HardRec.JSONStore), 0) as tjsonobject;
  if tmjson = nil then
    tmjson := tjsonobject.Create;

  tmjson.RemovePair(varname);
  tmjson.AddPair(varname, json);
  tmpstr := tmjson.ToString;
  i1 := length(tmpstr);
  for i1 := 0 to high(HardRec.JSONStore) do
    HardRec.JSONStore[i1] := #0;

  for i1 := 1 to length(tmpstr) do
    HardRec.JSONStore[i1 - 1] := tmpstr[i1];

end;

procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;

Procedure BeginJson;
var
  i: Integer;
begin
  tmpjSon := '{';
  for i := 0 to 255 do
    Jevent[i] := '';
  for i := 0 to 255 do
    JDev[i] := '';
  for i := 0 to 255 do
    jAirsecond[i] := '';
end;

procedure SaveJson;
var
  tmpres: ansistring;
  Procedure addjlist(arrName: ansistring; arrlist: TStringList);
  var
    i: Integer;
  begin
    tmpjSon := tmpjSon + arrName + ':{';
    for i := 0 to arrlist.Count - 1 do
    begin
      if arrlist[i] <> '' then
        tmpjSon := tmpjSon + IntToStr(i) + ':{' + arrlist[i] + '},';
    end;
    tmpjSon := tmpjSon + '},';
  end;

var
  freq, sttime, msectime: int64;
  msec: string;
begin
  QueryPerformanceFrequency(freq);
  QueryPerformanceCounter(sttime);
  msectime := sttime;
  msec := IntToStr(msectime);
  addVariable(1, 'timeStamp', msec);
  // SetStretchBltMode(Cv.Handle, COLORONCOLOR);
  addjlist('Event', Jevent);
  addjlist('Dev', JDev);
  addjlist('airSecond', jAirsecond);
  jsonresult := tmpjSon + '}';
  strpcopy(HardRec.JSONAll, jsonresult);
end;

Function addVariable(ObjNum: Integer; varname, VarValue: string): Integer;
var
  resstr: ansistring;
  utf8val: string;
begin
  VarValue := replacestr(VarValue, '"', '\"');
  utf8val := stringOf(TEncoding.UTF8.GetBytes(VarValue));

  tmpjSon := tmpjSon + varname + ':' + '"' + utf8val + '",';
end;

Function addVariable(ObjNum: Integer; arrName, Elementid, varname,
  VarValue: string): Integer; overload;
var
  teststr: ansistring;
  list: TStringList;
  numElement: Integer;
  utf8val: string;
begin
  VarValue := replacestr(VarValue, '"', '\"');
  utf8val := stringOf(TEncoding.UTF8.GetBytes(VarValue));
  if arrName = 'Event' then
    list := Jevent;
  if arrName = 'Dev' then
    list := JDev;
  if arrName = 'airSecond' then
    list := jAirsecond;
  numElement := strToInt(Elementid);
  list[numElement] := list[numElement] + varname + ':' + '"' + utf8val + '",';
end;

destructor THandledObject.Destroy;
begin
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

constructor TSharedMem.Create(const Name: string; Size: Integer);
begin
  try
    FName := Name;
    FSize := Size;
    { CreateFileMapping, when called with $FFFFFFFF for the hanlde value,
      creates a region of shared memory }
    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, Size,
      PChar(Name));
    if FHandle = 0 then
      abort;
    FCreated := GetLastError = 0;
    { We still need to map a pointer to the handle of the shared memory region }
    FFileView := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, Size);
    if FFileView = nil then
      abort;
  except
    Error(Format('Error creating shared memory %s (%d)', [Name, GetLastError]));
  end;
end;

destructor TSharedMem.Destroy;
begin
  if FFileView <> nil then
    UnmapViewOfFile(FFileView);
  inherited Destroy;
end;

var
  i: Integer;

initialization

shared := TSharedMem.Create('webredis tempore mutanur',
  sizeof(THardRec) + 1000);
HardRec := Pointer(Integer(shared.Buffer) + 100);

fillchar(HardRec.JSONAll, 1000000, 0);

fillchar(HardRec.JSONStore, 1000000, 0);
HardRec.UpdateCounter := 13131313;
Jevent := TStringList.Create;

for i := 0 to 255 do
  Jevent.Add('');
JDev := TStringList.Create;
for i := 0 to 255 do
  JDev.Add('');
jAirsecond := TStringList.Create;
for i := 0 to 255 do
  jAirsecond.Add('');

end.
