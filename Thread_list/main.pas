unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls, system.json;

type
  TForm1 = class(TForm)

    Memo1: TMemo;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Function SaveToJSON: string;
  end;

var
  Form1: TForm1;
    aint: integer =1;
    aint64: int64 = 64;
    adbl: double = 0.456;
    astr : string = '\\\\"""';
    abool    :Boolean =  false;
    acolor : tcolor = $0000FF;
    aintarr : array[0..4] of string = ('1','2','3','4','5');


implementation
uses PsAPI, TlHelp32;
{$R *.dfm}
function Tform1.SaveToJSON: string;
var
  json: tjsonobject;
    jsondata :string;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)
  function getVariableFromJson(varName: string;var  varvalue: variant): boolean;
  var
    tmpjson: tjsonvalue;
    tmpstr : string;
  begin
    tmpjson := json.GetValue(varName);
    if (tmpjson <> nil) then
    begin
     tmpStr:= tmpjson.Value;
     varValue := tmpStr;
    end;

  end;
  Procedure addVariableToJson(varName: string; varvalue: variant);
  var
    teststr: ansistring;
    list: TStringList;
    numElement: integer;
    utf8val: string;
    tmpjson: tjsonvalue;
    retval: string;
    strValue : string;
    vType : tvarType;
    tmpInt : integer;
  begin
    FormatSettings.DecimalSeparator := '.';
    vtype:=varType(varValue);
    strValue := varValue;
    utf8val := stringOf(tencoding.UTF8.GetBytes(strValue));
    json.AddPair(varName, strvalue);
  end;

begin
  json := tjsonobject.Create;
  try
  except
    on E: Exception do
  end;
  addVariableToJson('aint',aint);
  getVariableFromJson('aint',tmpInt);
  addVariableToJson('aint64',aint64);
  getVariableFromJson('aint',tmpInt)
  addVariableToJson('afloat',adbl);
  addVariableToJson('abool',abool);
  addVariableToJson('astr',astr);
  addVariableToJson('aint',aint);
  addVariableToJson('acolor',acolor);
  JsonData := json.ToString;
  json.free;
  result := jsonData;
end;

function GetThreadsInfo(PID:Cardinal): Boolean;
  var
    SnapProcHandle: THandle;
    NextProc      : Boolean;
    ThreadEntry  : TThreadEntry32;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //Создаем снэпшот всех существующих потоков
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//получаем первый поток
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then begin //проверка на принадлежность к процессу
              Writeln('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('');
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//получаем следующий поток
        end;
      finally
        CloseHandle(SnapProcHandle);//освобождаем снэпшот
      end;
  end;
procedure TForm1.SpeedButton1Click(Sender: TObject);
function GetThreadsInfo(PID:Cardinal): Boolean;
  var
    SnapProcHandle: THandle;
    NextProc      : Boolean;
    ThreadEntry  : TThreadEntry32;
    infostr : string;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //Создаем снэпшот всех существующих потоков
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
            infostr := '';
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//получаем первый поток
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then begin //проверка на принадлежность к процессу
//              Writeln('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
              infostr := infostr +('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
//              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
              infostr := infostr +(' base priority  ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
              infostr := infostr +(' delta priority ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('');
                memo1.Lines.Add(infostr);
                infostr := '';
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//получаем следующий поток
        end;
      finally
        CloseHandle(SnapProcHandle);//освобождаем снэпшот
      end;
  end;

begin
 memo1.Clear;
 memo1.Lines.Add(SaveToJSON);
// GetThreadsInfo(GetCurrentProcessId);

end;

end.
