unit uwebserv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

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
     DateTimeSTR           :array[0..5] of ansichar;
     UpdateCounter         :int64;
     VersionSignature      :array[0..5] of ansichar;
     JSONAll : array[0..10000000] of ansichar;
  end;
  PHardRec = ^THardRec;
var
HardRec :phardrec;
testbuf : array[0..1000] of byte absolute hardrec;
shared : tsharedmem;

var
  PortNum : integer = 9091;
var
  tmpjSon : ansistring;
  Jevent, JDev, jAirsecond : TStringList;
  Jmain : ansistring;
  jsonresult : ansistring;
procedure BeginJson;
procedure SaveJson;
Function addVariable (ObjNum : integer; varname, VarValue : string) : integer; overload;
Function addVariable (ObjNum : integer; arrName, Elementid, varname, VarValue : string) : integer; overload;


implementation

procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;


Procedure BeginJson;
  var
    i : integer;
  begin
    tmpjSon := '{';
    for i := 0 to 255 do
      Jevent[i] := '';
    for i := 0 to 255 do
      Jdev[i] := '';
    for i := 0 to 255 do
      JairSecond[i] := '';
  end;


procedure SaveJson;
  var
    tmpres : ansistring;
    Procedure addjlist (arrName : ansistring; arrlist : TStringList);
      var
        i : integer;
      begin
        tmpJson :=tmpJson+arrname+':{';
        for i := 0 to arrlist.Count - 1 do
          begin
            if arrlist[i]<>'' then
               tmpJson :=tmpJson+ IntToStr(i)+':{'+arrlist[i]+'},';
          end;
        tmpJson :=tmpJson+'},';
      end;
var
    freq, sttime, msectime :int64;
    msec : string;
begin
  QueryPerformanceFrequency(freq);
  QueryPerformanceCounter(sttime);
  msectime := trunc(STTIME*1000000/freq);
  msec := inttostr(msectime);
  addvariable(1,'timeStamp',msec);
 // SetStretchBltMode(Cv.Handle, COLORONCOLOR);
  addjlist ('Event', Jevent);
  addjlist ('Dev', JDev);
  addjlist ('airSecond', jAirsecond);
  jsonresult := tmpjSon + '}';
  strpcopy(hardrec.JSONAll, jsonresult);
end;

Function addVariable (ObjNum : integer; varname, VarValue : string) : integer;
  var
    resstr : ansistring;
    utf8val : string;
  begin
    utf8val := stringOf(tencoding.UTF8.GetBytes(varValue));
    tmpjSon := tmpjSon + varname + ':' + '"' + utf8Val + '",';
  end;

Function addVariable (ObjNum : integer; arrName, Elementid, varname, VarValue : string) : integer; overload;
  var
    teststr : ansistring;
    list : TStringList;
    numElement : integer;
    utf8val : string;
  begin
    utf8val := stringOf(tencoding.UTF8.GetBytes(varValue));
    if arrName = 'Event' then
      list := Jevent;
    if arrName = 'Dev' then
      list := JDev;
    if arrName = 'airSecond' then
      list := jAirsecond;
    numElement := strToInt (Elementid);
    list[numElement] :=    list[numElement]+ varname + ':' + '"' + utf8val + '",';
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
    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
        Size, PChar(Name));
    if FHandle = 0 then abort;
    FCreated := GetLastError = 0;
    { We still need to map a pointer to the handle of the shared memory region }
    FFileView := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, Size);
    if FFileView = nil then abort;
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
  i : integer;

initialization
   shared := tsharedmem.Create('webredis tempore mutanur',10000000);
   HardRec:=Pointer(Integer(shared.Buffer)+100);

Jevent := TStringList.Create;
for i := 0 to 255 do
  Jevent.Add ('');
JDev := TStringList.Create;
for i := 0 to 255 do
  JDev.Add ('');
jAirsecond := TStringList.Create;
for i := 0 to 255 do
  jAirsecond.Add ('');

end.
