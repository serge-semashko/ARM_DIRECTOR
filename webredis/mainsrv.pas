unit mainsrv;

// fdgsdfgsdf
interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, HTTPSend, blcksock, winsock, Synautil,
    strutils, system.json, AppEvnts, Menus, inifiles, das_const, ipcthrd,
    TeEngine, Series, TeeProcs, Chart, VclTee.TeeGDIPlus, System.Generics.Collections,
    mmsystem;

type
    THTTPSRVForm = class(TForm)
        Panel1: TPanel;
        Timer1: TTimer;
        Memo2: TMemo;
        URLED: TEdit;
        SpeedButton1: TSpeedButton;
        BitBtn1: TBitBtn;
        PopupMenu2: TPopupMenu;
        Restore1: TMenuItem;
        Minimize1: TMenuItem;
        quit1: TMenuItem;
    Memo1: TMemo;
    txt1: TStaticText;
        procedure FormCreate(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure terminate1Click(Sender: TObject);
        procedure Panel1Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormDestroy(Sender: TObject);
        procedure Restore1Click(Sender: TObject);
        procedure Minimize1Click(Sender: TObject);
        procedure quit1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
    protected
        procedure ControlWindow(var Msg: TMessage); message WM_SYSCOMMAND;
        procedure IconMouse(var Msg: TMessage); message WM_USER + 1;
    public
        procedure Ic(n: Integer; Icon: TIcon);
    end;

    TTCPHttpDaemon = class(TThread)
    private
        Sock: TTCPBlockSocket;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Execute; override;
    end;

    TTCPHttpThrd = class(TThread)
    private
        Sock: TTCPBlockSocket;
    public
        Headers: TStringList;
        InputData, OutputData: TMemoryStream;
        constructor Create(hsock: tSocket);
        destructor Destroy; override;
        procedure Execute; override;
        function ProcessHttpRequest(Request, URI: string): Integer;
    end;

    THardRec = packed record
        DateTimeSTR: array[0..5] of ansichar;
        UpdateCounter: int64;
        VersionSignature: array[0..5] of ansichar;
        JSONAll: array[0..1000000] of ansichar;
        JSONStore: array[0..1000000] of ansichar;
    end;

    PHardRec = ^THardRec;

    TWebVar = packed record
        Name: ansistring;
        baseName: ansistring;
        changed: int64;
        jsonStr: ansistring;
        json: TJSONObject;
    end;

var
    EmptyWebVar: TWebVar = (); //'','',-1,'',nil);
    VarCount: integer = 0;
    webvars: array[0..10000] of twebvar;
    KeyNames: tstringlist;
    Keyvalues: tstringlist;
    JsonVars: tstringlist;
    PrevUpdates: Integer = 0;
    HardRec: PHardRec;
    testbuf: array[0..1000] of byte absolute HardRec;
    shared: tsharedmem;
    PortNum: Integer = 9999;
    textfromjson: string = '[]';
    currentData: string = '{}';
    testjson: string = '[{"time":"18:57:40","sbrkgu1":0,"sbrkgu2":0,"k1t6":272.73,"k1t12":295.05,"k1t13":288.41,"k1dt5t6":12.15,"k1dt3t4":2.73,"k1sbr":0,' + '"k1vanna":0,"k1bo1":0.37,"k1bo2":0,"k2t6":108.89,"k2t12":211.58,"k2t13":286.86,"k2dt5t6":-2.02,"k2dt3t4":-1.91,"k2sbr":0,"k2vanna":0,' + '"k2bo1":0,"k2bo2":58.79}]';
    starttime: double;
    HTTP: THTTPSend = nil;
    PrevUpdate: double = 0;
    HTTPsrv: TTCPHttpDaemon;
    HTTPSRVFORM: THTTPSRVForm;
    URL: string;
    intsum: Integer = 0;
    intcount: Integer = 0;
    maxint: Integer = 0;
    minint: Integer = 10000;
    lastReq: double;

implementation

uses
    shellapi;
{$R *.dfm}

procedure THTTPSRVForm.IconMouse(var Msg: TMessage);
var
    p: tpoint;
begin
    GetCursorPos(p); // Запоминаем координаты курсора мыши
    case Msg.LParam of  // Проверяем какая кнопка была нажата
        WM_LBUTTONUP, WM_LBUTTONDBLCLK: {Действия, выполняемый по одинарному или двойному щелчку левой кнопки мыши на значке. В нашем случае это просто активация приложения}
            begin
//        ShowWindow(Application.Handle, SW_SHOW); // Восстанавливаем кнопку программы
                ShowWindow(Handle, SW_SHOW); // Восстанавливаем окно программы
            end;
        WM_RBUTTONUP: {Действия, выполняемый по одинарному щелчку правой кнопки мыши}
            begin
                SetForegroundWindow(Handle);                   // Восстанавливаем программу в качестве переднего окна
                PopupMenu2.Popup(p.X, p.Y);  // Заставляем всплыть тот самый TPopUp о котором я говорил чуть раньше
                PostMessage(Handle, WM_NULL, 0, 0);
            end;
    end;
end;

procedure THTTPSRVForm.Minimize1Click(Sender: TObject);
begin
    ShowWindow(Handle, SW_hide); // Âîññòàíàâëèâàåì îêíî ïðîãðàììû
    application.Minimize;
end;

procedure THTTPSRVForm.Ic(n: Integer; Icon: TIcon);
var
    Nim: TNotifyIconData;
begin
    Nim.cbSize := SizeOf(Nim);
    with Nim do begin
        Wnd := Handle;
        uID := 1;
        uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
        hicon := Icon.Handle;
        uCallbackMessage := wm_user + 1;
        szTip := 'WEB-Shell interface server';
    end;
    case n of
        1:
            Shell_NotifyIcon(Nim_Add, @Nim);
        2:
            Shell_NotifyIcon(Nim_Delete, @Nim);
        3:
            Shell_NotifyIcon(Nim_Modify, @Nim);
    end;
end;

procedure THTTPSRVForm.ControlWindow(var Msg: TMessage);
begin
    if Msg.WParam = SC_MINIMIZE then begin
        ShowWindow(Handle, SW_HIDE);  // ???????? ?????????
//    ShowWindow(Application.Handle, SW_HIDE);  // ???????? ?????? ? TaskBar'?
    end
    else
        inherited;
end;

procedure THTTPSRVForm.Panel1Click(Sender: TObject);
begin
    HTTP := THTTPSend.Create;
    try
//    HTTP.ProxyHost := Edit8.Text;
//    HTTP.ProxyPort := Edit9.Text;
        HTTP.HTTPMethod('GET', URLED.text);
        Memo2.Lines.Assign(HTTP.Headers);
      Memo1.Lines.LoadFromStream(HTTP.Document);
    finally
        HTTP.Free;
    end;
end;

procedure THTTPSRVForm.quit1Click(Sender: TObject);
begin
    halt;
end;

procedure THTTPSRVForm.Restore1Click(Sender: TObject);
begin
    ShowWindow(Handle, SW_SHOW);
end;

procedure THTTPSRVForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ShowWindow(Handle, SW_hide);
    Action := caNone;

end;

procedure THTTPSRVForm.FormCreate(Sender: TObject);
var
    ff: tfilestream;
    str1: string;
    objFileName: string;
    strlist: TStringList;
begin

    starttime := now;
    while (now - starttime) * 24 * 3600 < 3 do
        Application.ProcessMessages;

    HTTPsrv := TTCPHttpDaemon.Create;
    lastReq := -1;
    Ic(1, Application.Icon);
    Timer1.Enabled := true;
    application.Minimize;

end;

procedure THTTPSRVForm.FormDestroy(Sender: TObject);
begin
    Ic(2, Application.Icon);
end;

procedure THTTPSRVForm.FormShow(Sender: TObject);
begin
    ShowWindow(Application.Handle, SW_HIDE);
    ShowWindow(Application.MainForm.Handle, SW_HIDE);

end;

constructor TTCPHttpDaemon.Create;
begin
    inherited Create(false);
    Sock := TTCPBlockSocket.Create;
    FreeOnTerminate := true;
    Priority := tpNormal;
end;

destructor TTCPHttpDaemon.Destroy;
begin
    Sock.free;
    inherited Destroy;
end;

procedure TTCPHttpDaemon.Execute;
var
    ClientSock: tSocket;
begin
  // writeTimeLog('open sock');
    with Sock do begin
        CreateSocket;
        setLinger(true, 10);
        bind('0.0.0.0', IntToStr(PortNum));
        listen;
    // writeTimeLog('Listen sock');
        repeat
            if terminated then
                break;
            if canread(1000) then begin
        // writeTimeLog('Client read sock');
                ClientSock := accept;
                if lastError = 0 then
                    TTCPHttpThrd.Create(ClientSock);
            end;
        until false;
    end;
end;

{ TTCPHttpThrd }

constructor TTCPHttpThrd.Create(hsock: tSocket);
begin
    writeTimeLog('TCPHttpThrd.Create');

    inherited Create(false);
    Sock := TTCPBlockSocket.Create;
    Headers := TStringList.Create;
    InputData := TMemoryStream.Create;
    OutputData := TMemoryStream.Create;
    Sock.socket := hsock;
    FreeOnTerminate := true;
    Priority := tpNormal;
end;

destructor TTCPHttpThrd.Destroy;
begin
    Sock.free;
    Headers.free;
    InputData.free;
    OutputData.free;
    inherited Destroy;
end;

procedure TTCPHttpThrd.Execute;
var
    b: byte;
    timeout: Integer;
    s: string;
    method, URI, protocol: string;
    size: Integer;
    X, n: Integer;
    resultcode: Integer;
begin
    writeTimeLog('123');
    timeout := 120000;
  // read request line
    s := Sock.RecvString(timeout);
    writeTimeLog('rec1');
    writeTimeLog('   '+s);
    if Sock.lastError <> 0 then
        Exit;
    if s = '' then
        Exit;
    method := fetch(s, ' ');
    if (s = '') or (method = '') then
        Exit;
    URI := fetch(s, ' ');
    if URI = '' then
        Exit;
    protocol := fetch(s, ' ');
//    protocol :=  'HTTP/1.0';
    Headers.Clear;
    size := -1;
  // read request headers
    if protocol <> '' then begin
        if pos('HTTP/', protocol) <> 1 then
            Exit;
        repeat
            s := Sock.RecvString(timeout);
            writeTimeLog('rec2');
            writeTimeLog('   '+s);

            if Sock.lastError <> 0 then
                Exit;
            if s <> '' then
                Headers.add(s);
            if pos('CONTENT-LENGTH:', Uppercase(s)) = 1 then
                size := StrToIntDef(SeparateRight(s, ' '), -1);
        until s = '';
    end;
  // recv document...
    InputData.Clear;
    if size >= 0 then begin
        InputData.SetSize(size);
        X := Sock.RecvBufferEx(InputData.Memory, size, timeout);
        InputData.SetSize(X);
        if Sock.lastError <> 0 then
            Exit;
    end;
    OutputData.Clear;
    resultcode := ProcessHttpRequest(method, URI);
    Sock.SendString('HTTP/1.0 ' + IntToStr(resultcode) + CRLF);
    if protocol <> '' then begin
        Headers.add('Content-length: ' + IntToStr(OutputData.size));
        Headers.add('Connection: close');
        Headers.add('Date: ' + Rfc822DateTime(now));
        Headers.add('Server: Synapse HTTP server demo');
        Headers.add('');
        for n := 0 to Headers.count - 1 do
            Sock.SendString(Headers[n] + CRLF);
    end;
    if Sock.lastError <> 0 then
        Exit;
    Sock.SendBuffer(OutputData.Memory, OutputData.size);
    if lastReq > 0 then begin
        intsum := intsum + trunc((now - lastReq) * 24 * 3600 * 1000);
        inc(intcount);
        if (now - lastReq) * 24 * 3600 * 1000 > maxint then
            maxint := trunc((now - lastReq) * 24 * 3600 * 1000);
        if (now - lastReq) * 24 * 3600 * 1000 < minint then
            minint := trunc((now - lastReq) * 24 * 3600 * 1000);
    end;
    lastReq := now;
    Sock.CloseSocket;
end;

procedure AddWebVar(keyname: ansistring; KeyValue: ansistring; json: tjsonobject);
var
    i1, i2, i3: integer;
    tnow: int64;
    JSvalue : TJSONValue;
    posstr : string;
begin
    tnow := timeGetTime;
    if keyname = 'TLP' then begin

      jsvalue := json.GetValue('Position');
      if JSvalue<>nil
         then posstr := JSvalue.Value
         else posstr := 'NIL';

      HTTPSRVForm.txt1.Caption := formatdatetime('TLP: HH:NN:SS ZZZ ',now)+' position:'+posstr;

    end;

    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].Name) <> ansiuppercase(keyname) then
            continue;
        webvars[i1].BaseName := keyname;

        if pos('[', keyname) > 1 then
            webvars[i1].BaseName := system.Copy(keyname, 1, pos('[', keyname) - 1);
        webvars[i1].changed := tnow;
        webvars[i1].jsonstr := KeyValue;
        webvars[i1].json.free;
        webvars[i1].json := json;
        exit;
    end;
    inc(varCount);
    i1 := varCount - 1;
    if pos('[', keyname) > 1 then
        webvars[i1].BaseName := system.Copy(keyname, 1, pos('[', keyname) - 1);
    webvars[i1].changed := tnow;
    webvars[i1].jsonstr := KeyValue;
    webvars[i1].name := keyname;

end;

procedure RemoveWebVar(keyname: ansistring);
var
    i1, i2, i3: integer;
    tnow: int64;
begin
    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].Name) <> ansiuppercase(keyname) then
            continue;
        webvars[i1].changed := -1;
        exit;
    end;
end;

function getWebVarTime(keyname: ansistring): int64;
var
    i1, i2, i3: integer;
    tnow: int64;
begin
    result := -1;
    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].Name) <> ansiuppercase(keyname) then
            continue;
        result := webvars[i1].changed;
        exit;
    end;
end;

procedure ParseKeyName(KeyName: ansistring; var baseName: ansistring; var Selkey: ansistring; var SelValue: ansistring);
var
    pair: string;
    st, fn: integer;
begin
    Selkey := '';
    baseName := KeyName;
    if pos('(', KeyName) = 0 then
        exit;
    if pos(')', KeyName) = 0 then
        exit;
    baseName := system.Copy(KeyName, 1, pos('(', KeyName) - 1);
    st := pos('(', KeyName) + 1;
    fn := pos(')', KeyName);
    pair := system.Copy(KeyName, st, fn - st);

    Selkey := system.Copy(pair, 1, pos(':', pair) - 1);
    SelValue := system.Copy(pair, pos(':', pair) + 1, Length(pair));
end;

function GetVarBySelection(baseName, SelName, Selvalue: string): twebvar;
var
    i1, i2, i3: integer;
    jvalue: tjsonvalue;
    jstr: string;
begin
    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].baseName) <> ansiuppercase(baseName) then
            continue;
        jvalue := webvars[i1].json.GetValue(SelName);
        if jvalue = nil then
            Continue;
        jstr := jvalue.Value;
        if jstr <> Selvalue then
            continue;
        result := webvars[i1];
        exit;
    end;
    Result := EmptyWebVar;

end;

function GetWebVar(keyName: ansistring): TWebVar;
var
    i1, i2, i3: integer;
    str1: string;
    json: tjsonobject;
    baseName: ansistring;
    SelName: AnsiString;
    Selvalue: AnsiString;
begin
    result := EmptyWebVar;
    ;
    ParseKeyName(keyName, baseName, SelName, Selvalue);
    if SelName <> '' then begin
        Result := GetVarBySelection(baseName, SelName, Selvalue);
        exit;
    end;

    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].Name) <> ansiuppercase(keyName) then
            continue;
        result := webvars[i1];
        exit;
    end;

end;

function TTCPHttpThrd.ProcessHttpRequest(Request, URI: string): Integer;
var
    l: TStringList;
    str1, str2, resp: ansistring;
    pos_var_name: integer;
    str3: string;
    stmp, jreq: string;
    amppos: Integer;
    json, json1: tjsonobject;
    i1, i2, i3: integer;
    keyname: ansistring;
    keyval: ansistring;
    I: Integer;
    MyRequest: string;
    jSONSTR: string;
begin
  // sample of precessing HTTP request:
  // InputData is uploaded document, headers is stringlist with request headers.
  // Request is type of request and URI is URI of request
  // OutputData is document with reply, headers is stringlist with reply headers.
  // Result is result code
    result := 504;
    if Request = 'GET' then begin
        Headers.Clear;
        Headers.add('Content-type: Text/Html');
        l := TStringList.Create;
        try
            if (pos('callback=', URI) <> 0) then begin
                stmp := copy(URI, pos('callback=', URI) + 9, length(URI));
                amppos := pos('get_member', stmp);
                if amppos > 0 then
                    jreq := copy(stmp, 1, amppos - 2);
            end;
            resp := HardRec.JSONAll;

            i1 := pos('&', URI);
            if i1 <= 0 then
                i1 := length(URI) + 1;
            MyRequest := System.Copy(URI, 2, i1 - 2);
            if pos('GET_', MyRequest) <> 0 then begin
                resp := GetWebVar(system.copy(MyRequest, 5, Length(MyRequest))).jSONSTR;
            end;
            pos_var_name := pos('SET_', ansiuppercase(URI)) + 4;
            if pos_var_name > 5 then begin
                resp := '{"status":"ok"}';
                i1 := pos('=', URI);
                if i1 > 5 then begin
                    keyname := copy(URI, pos_var_name, i1 - pos_var_name);
                    str1 := copy(URI, i1 + 1, Length(URI));
                    while (str1[length(str1)] <> '}') and (length(str1) > 1) do
                        system.delete(str1, length(str1), 1);
                    json := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(str1), 0) as TJSONObject;
                    if json <> nil then
                        AddWebVar(keyname, str1, json)
                    else
                        resp := '{"status":"errformat"}';
                end;
            end;

            resp := jreq + '(' + resp + ');';
            l.add(resp);
            l.SaveToStream(OutputData);
        finally
            l.free;
        end;
        result := 200;
    end;
end;

procedure THTTPSRVForm.SpeedButton1Click(Sender: TObject);
var
    jtype: string;
    jsonstr: string;
    i, id: Integer;
    r1, r2: double;
  // rl : tstringlist;
    offset, position, h, g: Integer;
    s: string;
    ff: tfilestream;
    r: array[0..255] of string;
    pointpos: Integer;
    resrecord: string;
    FullProgPath: PwideChar;
    str22: string;

    procedure SliceSeries(Chart: TChart; maxlen: Integer);
    var
        Ic: Integer;
    begin
        for Ic := 0 to Chart.SeriesCount - 1 do begin
            while Chart.Series[Ic].count > maxlen do
                Chart.Series[Ic].Delete(0);
        end;
    end;

var
    st: double;
begin
    caption := formatDateTime('dd/mm/yyyy HH:NN:SS', now) + formatDateTime(' Старт:dd/mm/yyyy HH:NN:SS', starttime);
    Timer1.Enabled := false;
    Application.ProcessMessages;
    while true do begin
        st := now;
        while (now - st) * 24 * 3600 * 1000 < 1 do begin
            sleep(1);
            Application.ProcessMessages;
        end;
        textfromjson := HardRec.JSONAll;
    // memo2.Lines.Clear;
    // memo2.Text:=textfromJson;
        PrevUpdates := HardRec.UpdateCounter;
        intsum := 0;
        intcount := 0;
        minint := 1000;
        maxint := 0;

    end;
    Timer1.Enabled := true;
end;

procedure THTTPSRVForm.terminate1Click(Sender: TObject);
begin
    halt;
end;

var
    jcount: Integer;
    str: string;

var
    ini: tinifile;

initialization
    shared := tsharedmem.Create('webredis tempore mutanur', sizeof(ThardRec) + 1000);

    HardRec := Pointer(Integer(shared.Buffer) + 100);

    if (HardRec.UpdateCounter <> 13131313) then begin
        fillchar(HardRec.JSONAll, 1000000, 0);
        HardRec.UpdateCounter := 13131313
    end;
    HardRec.UpdateCounter := 0;
    lastReq := now;
//    varNames := tstringlist.Create;
//    Varvalues:= tstringlist.Create;
      EmptyWebVar.Name := '';
      EmptyWebVar.baseName := '';
      EmptyWebVar.jsonStr := '';
      EmptyWebVar.changed := -1;
      EmptyWebVar.json := nil;

end.

