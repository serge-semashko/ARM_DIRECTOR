unit mainsrv;

// fdgsdfgsdf
interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, HTTPSend, blcksock, winsock, Synautil,
    strutils, system.json, AppEvnts, Menus, inifiles, das_const,
    TeEngine, Series, TeeProcs, Chart, VclTee.TeeGDIPlus, System.Generics.Collections,
    mmsystem,web.win.sockets, zlibexapi,ZLIBEX;
type
    THTTPSRVForm = class(TForm)
        Panel1: TPanel;
        Timer1: TTimer;
        Memo2: TMemo;
        URLED: TEdit;
        BitBtn1: TBitBtn;
        PopupMenu2: TPopupMenu;
        Restore1: TMenuItem;
        Minimize1: TMenuItem;
        quit1: TMenuItem;
        Memo1: TMemo;
        txt1: TStaticText;
        txt2: TStaticText;
        webreqtxt: TStaticText;
        mmo1: TMemo;
        procedure FormCreate(Sender: TObject);
        procedure terminate1Click(Sender: TObject);
        procedure Panel1Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormDestroy(Sender: TObject);
        procedure Restore1Click(Sender: TObject);
        procedure Minimize1Click(Sender: TObject);
        procedure quit1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure TcpserverAccept(Sender: TObject; ClientSocket: TCustomIpClient);
        procedure webSocketserverAccept(Sender: TObject; ClientSocket: TCustomIpClient);
        procedure TcphttpserverAccept(Sender: TObject; ClientSocket: TCustomIpClient);
        procedure Timer1Timer(Sender: TObject);
    private
    protected
        procedure ControlWindow(var Msg: TMessage); message WM_SYSCOMMAND;
        procedure IconMouse(var Msg: TMessage); message WM_USER + 1;
    public
        procedure Ic(n: Integer; Icon: TIcon);
    end;


//    TTCPHttpThrd = class(TThread)
//    private
//        Sock: TTCPBlockSocket;
//    public
//        inbuff : array[0..5000000] of ansichar;
//        outbuff : array[0..5000000] of ansichar;
//        Headers: TStringList;
//        InputData, OutputData: TMemoryStream;
//        constructor Create(hsock: tSocket);
//        destructor Destroy; override;
//        procedure Execute; override;
//        procedure doExecute;
//    end;


    TWebVar = packed record
        Name: ansistring;
        baseName: ansistring;
        base_ind : integer;
        changed: int64;
        jsonStr: ansistring;
        json: TJSONvalue;
    end;
    TWebarray = packed record
        Name: ansistring;
        changed: int64;
        values : tstringlist;
    end;

function compress2send(instr:ansistring):ansistring;
function ProcessRequest(URI: string): AnsiString;
function myHTTPProcessRequest(URI: string): AnsiString;
Procedure Update_Array(basename:string;baseind, changed: integer; varvalue:ansistring);

var
   var_array : array[0..1000] of TWebarray;
   array_count : integer = 0;

        TCPHTTPsrv: TTcpServer;
        webSocketsrv: TTcpServer;
        TCPsrv: TTcpServer;
    TerminateAll : boolean = false;
    LocalTCPPort: string = '9085';
    EmptyWebVar: TWebVar; // = ('','',-1,'',nil); //'','',-1,'',nil);

    VarCount: integer = 0;
    webvars : array[0..10000] of twebvar;

    KeyNames: tstringlist;
    Keyvalues: tstringlist;
    JsonVars: tstringlist;
    PrevUpdates: Integer = 0;
    PortNum: Integer = 9090;
    textfromjson: string = '[]';
    currentData: string = '{}';
    HTTP: THTTPSend = nil;
    HTTPSRVFORM: THTTPSRVForm;
    URL: string;
    TLP_position : ansistring= '';
    TLP_value : ansistring= '';
    TLP_Time: int64 = -1;
    TLP_count: int64 = 0;
    TLP_speed: ansistring = '';
    CTC_Time: int64 = -1;
    CTC_count: int64 = 0;
    CTC_speed: ansistring = '';
    hexmap : array[0..15] of ansichar = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

implementation

uses
    shellapi, uwebredis_common;
{$R *.dfm}
function compress2send(instr:ansistring):ansistring;
var
   tmpstr : ansistring;
   i1 : integer;
   t1,t2,st : int64;
   pch : pansichar;
begin
     st := timegettime;
     getmem(pch,10000000);

    tmpstr := ZCompressStr(INSTR,zcLevel3);
    Assert(length(tmpstr)<=3000000,'Строка после компрессии больше 3мб');
    t1 := timeGetTime-st;
    result := '';
    FillChar(pch^,10000000,0);
    for i1 := 1 to length(tmpstr) do begin
                                        pch[2*(i1-1)] := hexmap[ord(tmpstr[i1]) shr 4];
                                        pch[2*(i1-1)+1] := hexmap[ord(tmpstr[i1]) and $0f];
                                     end;
    result := pch;
    t2 := timeGetTime-st;
    webWriteLog('len('+inttostr(length(instr))+')='+inttostr(length(result))+' compress , total time='+IntToStr(t1)+' '+IntToStr(t2));
    freemem(pch);
end;


procedure THTTPSRVForm.TcpserverAccept(Sender: TObject;       //пришло сообщение
    ClientSocket: TCustomIpClient);
var
    txt: string;
    Inbuffer: array[0..5000000] of ansichar;
    OUTBUffer: array[0..5000000] of ansichar;
    tmpBuffer: integer;
    rcstr, hstr: string;
    rc: Integer;
    outstr, instr, uri: AnsiString;
    resp: ansistring;
    i1: integer;
    incount: integer;
    st: int64;
    chTime: ansistring;
begin
    hstr := 'Connect H=' + IntToStr(ClientSocket.Handle) + ' ';
    webWriteLog('webget', hstr);
//    mmo1.Lines.add(FormatDateTime('HH:NN:SS ', now) + 'accept' + hstr);
    while not TerminateAll  do begin
        sleep(1);
        webWriteLog('TCPaccept>', ' Wait for request');

        rc := recv(ClientSocket.Handle, inbuffer[0], 1, MSG_PEEK);
        if rc <= 0 then begin
            rc := WSAGetlastError;
            webWriteLog('TCPaccept>', ' DISconnect by other sid. Checked on wait incoming packet' + SysErrorMessage(rc));
            ClientSocket.Disconnect;
            Exit;
        end;
        st := timegettime;
        webWriteLog('TCPaccept>', 'Begin receive block');

        rc := ReceiveBlob(ClientSocket.Handle, inbuffer, 200000);
        if rc < 0 then begin
            rc := WSAGetlastError;
            ;
            webWriteLog('TCPaccept>', ' DISconnect BY ERROR AFTER receive blob');
            ClientSocket.Disconnect;
            Exit;
        end;

        instr := inbuffer;

        webWriteLog('TCPaccept>', Format('Received len=%d time=%d ', [rc, timegettime - st]) + ' Request= ' + system.copy(instr, 1, 30));
        while length(instr) > 5 do begin
            if system.copy(instr, 1, 5) = '/GET_' then
                break;
            if system.copy(instr, 1, 5) = '/SET_' then
                break;
            if system.copy(instr, 1, 5) = '/DEL_' then
                break;
            if system.copy(instr, 1, 5) = '/TIM_' then
                break;
            if system.copy(instr, 1, 5) = '/ADD_' then
                break;
            if system.copy(instr, 1, 5) = '/UPD_' then
                break;
            if system.copy(instr, 1, 5) = '/LST_' then
                break;
            system.Delete(instr, 1, 1);

        end;
        uri := instr;
        i1 := pos(' ', uri) - 1;
        if i1 > 1 then
            uri := system.copy(uri, 1, i1);
        webWriteLog('TCPaccept>', ' Request ' + system.copy(uri, 1, 30));

        outstr :=soh+ ProcessRequest(uri)+eot+#0;
        if pos('GET_', uri) > 0 then begin

//            synWriteLog('GET_', uri + ' =  ' + outstr);
        end;
        webWriteLog('TCPaccept>', ' Answer ' + system.copy(outstr, 1, 190));

        strpcopy(outbuffer,outstr);
        webWriteLog('TCPaccept>', Format('Processed len=%d time=%d ', [rc, timegettime - st]) + ' Answer= ' + system.copy(outstr, 1, 30));
        rc := Send(ClientSocket.handle, outbuffer[0], length(outstr), 0);
        webWriteLog('wTCPaccept>', ' send ' + IntToStr(rc));
        if rc < 0 then begin
            rc := WSAGetlastError;
            webWriteLog('TCPaccept>', ' DISconnect BY ERROR AFTER SEND ERR = ' + syserrormessage(rc));
            ClientSocket.Disconnect;
            Exit;
        end;
        webWriteLog('TCPaccept>', Format('Completed time=%d ', [timegettime - st]));
    end;

end;


procedure THTTPSRVForm.webSocketserverAccept(Sender: TObject;       //пришло сообщение
    ClientSocket: TCustomIpClient);
var
    txt: string;
    Inbuffer: array[0..5000000] of ansichar;
    OUTBUffer: array[0..5000000] of ansichar;
    tmpBuffer: integer;
    rcstr, hstr: string;
    rc: Integer;
    outstr, instr, uri: AnsiString;
    resp: ansistring;
    i1: integer;
    incount: integer;
    st: int64;
    chTime: ansistring;
begin
    hstr := 'Connect H=' + IntToStr(ClientSocket.Handle) + ' ';
    sleep(300);
    FillChar(Inbuffer,1000000,0);
    rc := recv(ClientSocket.Handle, inbuffer,1000000, 0);
    webWriteLog('websocket>', inbuffer);
    outstr := 'HTTP/1.1 101 Switching Protocols'+crlf+
            'Date: Wed, 25 Oct 2017 10:07:34 GMT'+crlf+
            'Connection: Upgrade'+crlf+
            'Upgrade: WebSocket'+crlf+crlf;
    strpcopy(outbuffer,outstr);
    rc := Send(ClientSocket.handle, outbuffer[0], length(outstr), 0);
        if rc <= 0 then begin
            rc := WSAGetlastError;
            webWriteLog('websocket>', ' DISconnect by other sid. Checked on wait incoming packet' + SysErrorMessage(rc));
            ClientSocket.Disconnect;
            Exit;
        end;
    rc := Send(ClientSocket.handle, outbuffer[0], length(outstr), 0);
        if rc <= 0 then begin
            rc := WSAGetlastError;
            webWriteLog('websocket>', ' DISconnect by other sid. Checked on wait incoming packet' + SysErrorMessage(rc));
            ClientSocket.Disconnect;
            Exit;
        end;
    rc := Send(ClientSocket.handle, outbuffer[0], length(outstr), 0);
        if rc <= 0 then begin
            rc := WSAGetlastError;
            webWriteLog('websocket>', ' DISconnect by other sid. Checked on wait incoming packet' + SysErrorMessage(rc));
            ClientSocket.Disconnect;
            Exit;
        end;

//    mmo1.Lines.add(FormatDateTime('HH:NN:SS ', now) + 'accept' + hstr);
    while not TerminateAll  do begin
        sleep(1);
        webWriteLog('websocket>', ' Wait for request');

        rc := recv(ClientSocket.Handle, inbuffer[0], 1, MSG_PEEK);
        if rc <= 0 then begin
            rc := WSAGetlastError;
            webWriteLog('websocket>', ' DISconnect by other sid. Checked on wait incoming packet' + SysErrorMessage(rc));
            ClientSocket.Disconnect;
            Exit;
        end;
        st := timegettime;
        webWriteLog('websocket>', 'Begin receive block');

        rc := ReceiveBlob(ClientSocket.Handle, inbuffer, 200000);
        if rc < 0 then begin
            rc := WSAGetlastError;
            ;
            webWriteLog('websocket>', ' DISconnect BY ERROR AFTER receive blob');
            ClientSocket.Disconnect;
            Exit;
        end;

        instr := inbuffer;

        webWriteLog('websocket>', Format('Received len=%d time=%d ', [rc, timegettime - st]) + ' Request= ' + system.copy(instr, 1, 30));
        while length(instr) > 5 do begin
            if system.copy(instr, 1, 5) = '/GET_' then
                break;
            if system.copy(instr, 1, 5) = '/SET_' then
                break;
            if system.copy(instr, 1, 5) = '/DEL_' then
                break;
            if system.copy(instr, 1, 5) = '/TIM_' then
                break;
            if system.copy(instr, 1, 5) = '/ADD_' then
                break;
            if system.copy(instr, 1, 5) = '/UPD_' then
                break;
            if system.copy(instr, 1, 5) = '/LST_' then
                break;
            system.Delete(instr, 1, 1);

        end;
        uri := instr;
        i1 := pos(' ', uri) - 1;
        if i1 > 1 then
            uri := system.copy(uri, 1, i1);
        webWriteLog('websocket>', ' Request ' + system.copy(uri, 1, 30));

        outstr :=soh+ ProcessRequest(uri)+eot+#0;
        if pos('GET_', uri) > 0 then begin

//            synWriteLog('GET_', uri + ' =  ' + outstr);
        end;
        webWriteLog('websocket>', ' Answer ' + system.copy(outstr, 1, 190));

        strpcopy(outbuffer,outstr);
        webWriteLog('websocket>', Format('Processed len=%d time=%d ', [rc, timegettime - st]) + ' Answer= ' + system.copy(outstr, 1, 30));
        rc := Send(ClientSocket.handle, outbuffer[0], length(outstr), 0);
        webWriteLog('wwebsocket>', ' send ' + IntToStr(rc));
        if rc < 0 then begin
            rc := WSAGetlastError;
            webWriteLog('websocket>', ' DISconnect BY ERROR AFTER SEND ERR = ' + syserrormessage(rc));
            ClientSocket.Disconnect;
            Exit;
        end;
        webWriteLog('websocket>', Format('Completed time=%d ', [timegettime - st]));
    end;

end;



procedure THTTPSRVForm.TcpHTTPserverAccept(Sender: TObject;       //пришло сообщение
    ClientSocket: TCustomIpClient);
var
    txt: string;
    buffer: array[0..10000000] of ansichar;
    tmpBuffer: integer;
    rcstr, hstr: string;
    rc: Integer;
    outstr, instr, uri: AnsiString;
    resp: ansistring;
    i1: integer;

    procedure FillBuff(buff: array of ansichar; instr: ansistring);
    var
        i1: integer;
    begin
        for i1 := 0 to length(instr) do
            buff[i1] := instr[i1];

    end;

begin

    hstr := 'H=' + IntToStr(ClientSocket.Handle) + ' ';
    TCPHTTPsrv.FreeOnRelease;
//    mmo1.Lines.add(FormatDateTime('HH:NN:SS ', now) + 'accept' + hstr);
        webWriteLog('HTTPaccept>', ' connect from ' + ClientSocket.RemoteHost);
        FillChar(buffer, 0, High(buffer));
        rc := ClientSocket.ReceiveBuf(buffer, 10000);  //берем буфер
        rcstr := ' ' + IntToStr(rc) + ' ';
        if rc <= 0 then begin
            mmo1.Lines.Add(IntToStr(rc) + ' err:' + hstr + syserrormessage(wsagetlasterror));
            exit;
        end;
        if Length(buffer) <> 0 then
        webWriteLog('HTTPaccept>', ' <Request> ');
        webWriteLog('HTTPaccept>', buffer);
        webWriteLog('HTTPaccept>', ' </Request> ');
//           system.Copy(buffer,0,300));
            instr := buffer;
//        for i1 := 1 to length(instr) do uri := u
        i1 := pos(#13, instr) - 1;
        if i1 < 1 then
            i1 := pos(#10, instr) - 1;
        if i1 < 1 then
            i1 := length(instr) - 1;
        uri := system.copy(instr, 1, i1);
        uri := system.copy(uri, Pos('/', uri), Length(uri));
        i1 := pos(' ', uri) - 1;
        if i1 < 1 then
            i1 := length(uri) - 1;
        uri := system.copy(uri, 1, i1);

        outstr := myHTTPProcessRequest(uri);
        if pos('GET_', uri) > 0 then begin

//            webWriteLog('GET_', uri + ' =  ' + outstr);
        end;
        ClientSocket.Sendln('HTTP/1.0 ' + '200' + CRLF +
        'Access-Control-Allow-Origin: *'+ CRLF +
        'Content-type: Text/Html' + #13#10 +
        'Content-length: ' + IntToStr(length(outstr)) + #13#10 +
        'Connection: close' + #13#10 +
        'Date: Tue, 20 Mar 2018 14:04:45 +0300' + #13#10 +
        'Server: Synapse HTTP server demo' + #13#10 + #13#10 + outstr + crlf);
        ClientSocket.Close;


end;

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
var
    st: int64;
begin
    st := timeGetTime;

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

    webreqtxt.Caption := ' WEBTIME = ' + IntToStr(timeGetTime - st);

end;

procedure THTTPSRVForm.quit1Click(Sender: TObject);
begin
    webWriteLog('HALT>Start');
    terminateAll := true;
    TCPsrv.Close;
    TCPHTTPsrv.Close;
    sleep(200);
    TCPsrv.free;
    TCPHTTPsrv.free;
    webWriteLog('HALT>Finish');
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
    rc: integer;
begin

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





{ TTCPHttpThrd }

//constructor TTCPHttpThrd.Create(hsock: tSocket);
//begin
////    writeTimeLog('TCPHttpThrd.Create');
//    inherited Create(false);
//    sock := TTCPBlockSocket.Create;
//    Headers := TStringList.Create;
//    InputData := TMemoryStream.Create;
//    OutputData := TMemoryStream.Create;
//    sock.socket := hsock;
//    FreeOnTerminate := true;
//    Priority := tpNormal;
//end;
//
//destructor TTCPHttpThrd.Destroy;
//begin
//    sock.free;
//    Headers.free;
//    InputData.free;
//    OutputData.free;
//    inherited Destroy;
//end;
//
//procedure TTCPHttpThrd.doExecute;
//var
//    b: byte;
//    timeout: Integer;
//    s: string;
//    method, URI, protocol: string;
//    size: Integer;
//    X, n: Integer;
//    resultcode: Integer;
//    rsstr: string;
//    st: int64;
//
//    procedure addMark(num: integer);
//    begin
//        rsstr := rsstr + format('%d %dms ', [num, TimegetTime - st]);
//        st := TimegetTime;
//    end;
//
//begin
//    rsstr := '';
//    st := timegettime;
//    addMark(1);
//    timeout := 1200;
//  // read request line
//    s := sock.RecvString(timeout);
//    WriteLog('URI ' + s);
//    addMark(2);
//    if sock.lastError <> 0 then
//        Exit;
//    if s = '' then
//        Exit;
//    method := fetch(s, ' ');
//    if (s = '') or (method = '') then
//        Exit;
//    URI := fetch(s, ' ');
//    if URI = '' then
//        Exit;
//    protocol := fetch(s, ' ');
////    protocol :=  'HTTP/1.0';
//    Headers.Clear;
//    size := -1;
//  // read request headers
//    if protocol <> '' then begin
//        if pos('HTTP/', protocol) <> 1 then
//            Exit;
//        repeat
//
//            s := sock.RecvString(timeout);
//            if pos('Host:', s) > 0 then
//                rsstr := s + rsstr;
//            addMark(3);
//            if sock.lastError <> 0 then
//                Exit;
//            if s <> '' then
//                Headers.add(s);
//            if pos('CONTENT-LENGTH:', Uppercase(s)) = 1 then
//                size := StrToIntDef(SeparateRight(s, ' '), -1);
//        until s = '';
//    end;
//  // recv document...
//    InputData.Clear;
//    if size >= 0 then begin
//        InputData.SetSize(size);
//        X := sock.RecvBufferEx(InputData.Memory, size, timeout);
//        addMark(4);
//        InputData.SetSize(X);
//        if sock.lastError <> 0 then
//            Exit;
//    end;
//    OutputData.Clear;
//    resultcode := ProcessHttpRequest(method, URI);
//    sock.SendString('HTTP/1.0 ' + IntToStr(resultcode) + CRLF);
//    if protocol <> '' then begin
//        Headers.add('Content-length: ' + IntToStr(OutputData.size));
//        Headers.add('Connection: close');
//        Headers.add('Date: ' + Rfc822DateTime(now));
//        Headers.add('Server: Synapse HTTP server demo');
//        Headers.add('');
//        addMark(5);
//        for n := 0 to Headers.count - 1 do
//            sock.SendString(Headers[n] + CRLF);
//        addMark(6);
//        headers.SaveToFile('g:\home\headers.txt');
//    end;
//    if sock.lastError <> 0 then
//        Exit;
//    sock.SendBuffer(OutputData.Memory, OutputData.size);
//    addMark(7);
//    addMark(8);
//
//    sock.CloseSocket;
//    addMark(9);
//    webWriteLog('tcpip', 'Request process ' + rsstr);
//    webWriteLog('Request process ' + rsstr);
//end;
//
//procedure TTCPHttpThrd.Execute;
//var
//    st: int64;
//begin
//    st := timegettime;
//    doExecute;
////  WriteLog('Request process time = '+IntToStr(timeGetTime-st));
//end;

Procedure Update_Array(basename:string;baseind, changed: integer; varvalue:ansistring);
var
 i1,i2,i3 : integer;
 lst : tstringlist;
begin
if basename = 'TLO' then
   baseind := baseind-1;

  for i1 := 0  to array_count-1 do
  begin
       if basename<> var_array[i1].Name then continue;
       while var_array[i1].values.Count<=baseind do var_array[i1].values.Add('{}');
       var_array[i1].values[baseind]:=varvalue;
       var_array[i1].changed:=changed;
       exit;

  end;
  inc(array_count);
  var_array[array_count-1].Name := basename;
  var_array[array_count-1].changed := changed;
  var_array[array_count-1].values := tstringlist.Create;
  while var_array[array_count-1].values.Count<=baseind do var_array[array_count-1].values.Add('{}');
  var_array[array_count-1].values[baseind]:=varvalue;






end;
procedure AddWebVar(keyname: ansistring; KeyValue: ansistring; json: tjsonvalue);
var
    i1, i2, i3: integer;
    tnow: int64;
    JSvalue: TJSONValue;
    posstr: string;
    s1 : string;
begin
    webWriteLog('addWebVar>'+keyname);
    tnow := timeGetTime;
    if keyname = 'TLP' then begin

        if TimegetTime - TLP_Time < 1000 then
            Inc(TLP_count)
        else begin
            TLP_speed := format('%f', [TLP_count * 1000.0 / (TimegetTime - TLP_Time)]);
            TLP_count := 0;
            TLP_time := TimeGetTime;
        end;
        JSvalue := tjsonobject(json).GetValue('Position');
        if JSvalue <> nil then begin
           TLP_value := KeyValue;
            posstr := JSvalue.Value;
            TLP_position :=posstr;
        end  else
            posstr := 'NIL';
        posstr := posstr + ' UPD/sec = ' + TLP_speed;
        HTTPSRVForm.txt1.Caption := 'TLP:' + formatdatetime('TLP: HH:NN:SS ZZZ ', now) + ' position:' + posstr;

    end
    else if keyname = 'CTC' then begin

        if TimegetTime - CTC_Time < 1000 then
            Inc(CTC_count)
        else begin
            CTC_speed := IntToStr(CTC_count);
            CTC_speed := format('%f', [CTC_count * 1000.0 / (TimegetTime - CTC_Time)]);
            CTC_count := 0;
            CTC_time := TimeGetTime;
        end;
        posstr := ' UPD/sec = ' + CTC_speed;

        HTTPSRVForm.txt2.Caption := 'CTC:' + formatdatetime(' HH:NN:SS ZZZ ', now) + posstr;
    end
    else
        HTTPSRVForm.memo1.lines.Values[keyname] := formatdatetime('HH:NN:SS ZZZ ', now)
            +AnsiReplaceStr(UTF8Decode( UTF8Decode(system.copy((UTF8encode(KeyValue)), 1, 150))),'#$%#$%', ' ');

    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].Name) <> ansiuppercase(keyname) then
            continue;
        webvars[i1].changed := tnow;
        webvars[i1].jsonstr := KeyValue;
        webvars[i1].json.free;
        webvars[i1].json := json;
        if webvars[i1].BaseName<>'' then update_array(webvars[i1].BaseName, webvars[i1].base_ind,webvars[i1].changed,KeyValue);
        exit;
    end;
    inc(varCount);
    i1 := varCount - 1;
    if keyname = 'TLO[3]' then
    i1 := varCount - 1;

    webvars[i1].changed := tnow;
    webvars[i1].jsonstr := KeyValue;
    webvars[i1].name := keyname;
    if pos('[', keyname) > 1 then begin
        webvars[i1].BaseName := system.Copy(keyname, 1, pos('[', keyname) - 1);
        if pos(']', keyname) > 1 then begin
            s1 := system.Copy(keyname,pos('[', keyname)+1, pos(']', keyname) - pos('[', keyname)-1 );
            val(s1,i2,i3);
            if i3=0 then begin
                     webvars[i1].BaseName := system.Copy(keyname, 1, pos('[', keyname) - 1);
                     webvars[i1].Base_ind := i2;
                     update_array(webvars[i1].BaseName, webvars[i1].base_ind,webvars[i1].changed,KeyValue);
            end;
        end;
    end;


end;

function RemoveWebVar(keyname: ansistring): ansistring;
var
    i1, i2, i3: integer;
    tnow: int64;
begin
    result := '{"RC":0,"status":"Not exist"}';

    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].Name) <> ansiuppercase(keyname) then
            continue;
        IF keyname<>'TLP' THEN  HTTPSRVForm.memo1.lines.Values[keyname] := 'deleted ' + formatdatetime('HH:NN:SS ZZZ', now);
        webvars[i1].changed := -1;
        result := '{"RC":0,"status":"Deleted"}';

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

//function GetVarBySelection(baseName, SelName, Selvalue: string): twebvar;
//var
//    i1, i2, i3: integer;
//    jvalue: tjsonvalue;
//    jstr: string;
//begin
//    for i1 := 0 to VarCount - 1 do begin
//        if ansiuppercase(webvars[i1].baseName) <> ansiuppercase(baseName) then
//            continue;
//        jvalue := webvars[i1].json.GetValue(SelName);
//        if jvalue = nil then
//            Continue;
//        jstr := jvalue.Value;
//        if jstr <> Selvalue then
//            continue;
//        result := webvars[i1];
//        exit;
//    end;
//    Result := EmptyWebVar;
//
//end;

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
//    ParseKeyName(keyName, baseName, SelName, Selvalue);
//    if SelName <> '' then begin
//        Result := GetVarBySelection(baseName, SelName, Selvalue);
//        exit;
//    end;

    for i1 := 0 to VarCount - 1 do begin
        if ansiuppercase(webvars[i1].Name) <> ansiuppercase(keyName) then
            continue;
        if webvars[i1].changed > 0 then
            result := webvars[i1];
        exit;
    end;

end;

function GetWeb_ARRay(keyName: ansistring): TWebVar;
var
    i1, i2, i3: integer;
    str1: string;
    json: tjsonobject;
    baseName: ansistring;
    SelName: AnsiString;
    Selvalue: AnsiString;
    jsarr :TJSONArray;
    maxid : integer;
    tmjs : TWebVar;
begin
    result := EmptyWebVar;
    for i1 := 0 to array_count - 1 do begin
        if var_array[i1].Name <> keyName then
            continue;
        if var_array[i1].changed < 0 then continue;
        result.jsonStr:='[';
        for i2 := 0 to var_array[i1].values.Count-1 do
        begin
          if length(var_array[i1].values[i2])<5 then
          begin
             result.jsonStr := '';
             result.changed := -1;
             exit;
          end;

          if i2  = (var_array[i1].values.Count-1)
          then
              result.jsonStr:=result.jsonStr+ansistring(var_array[i1].values[i2])
          else
              result.jsonStr:=result.jsonStr+ansistring(var_array[i1].values[i2])+',';

        end;

       result.jsonStr:=result.jsonStr+']';
       result.changed := var_array[i1].changed;

    end;
end;




function ListWebVars: ansistring;overload;
var
    i1, i2, i3: integer;
    str1: string;
    json: tjsonobject;
    baseName: ansistring;
    SelName: AnsiString;
    Selvalue: AnsiString;
begin
    result := '{';
    for i1 := 0 to VarCount - 1 do begin
        if i1 = VarCount - 1 then
            result := result + '"' + webvars[i1].Name + '"' + ':"' + IntToStr(webvars[i1].changed) + '"'
        else
            result := result + '"' + webvars[i1].Name + '"' + ':"' + IntToStr(webvars[i1].changed) + '",';
    end;
    result := result + '}';
end;

function http_ListWebVars: ansistring;overload;
var
    i1, i2, i3: integer;
    str1: string;
    json: tjsonobject;
    baseName: ansistring;
    SelName: AnsiString;
    Selvalue: AnsiString;
begin
    result := '{';
    for i1 := 0 to array_count - 1 do begin
            result := result + '"' + var_array[i1].Name + '"' + ':"' + IntToStr(var_array[i1].changed) + '",';
    end;
    if TLP_position<>'' then
          result := result + '"TLP_value":' + TLP_value+ ',';
    for i1 := 0 to VarCount - 1 do begin
        if (webvars[i1].Name = 'TLT') or (webvars[i1].Name = 'TLO') then continue;
        result := result + '"' + webvars[i1].Name + '"' + ':"' + IntToStr(webvars[i1].changed) + '",';
    end;
    if result[length(result)]=',' then system.Delete(result,length(result),1 );

    result := result + '}';
end;


function ProcessRequest(URI: string): AnsiString;
var
    stmp, jreq, resp, keyName, keyVal, str1: ansistring;
    i1, amppos, pos_var_name: integer;
    jsval : tjsonvalue;
    varTime : string;
begin
     varTime := '';
    if (pos('callback=', URI) <> 0) then begin
        stmp := copy(URI, pos('callback=', URI) + 9, length(URI));
        amppos := pos('get_member', stmp);
        if amppos > 0 then
            jreq := copy(stmp, 1, amppos - 2);
    end;
    resp := '{"":""}';

    pos_var_name := pos('GET_', ansiuppercase(URI)) + 4;
    if pos_var_name > 4 then begin
        keyName := system.copy(URI, pos_var_name, Length(URI));
        if pos('&', keyName) > 0 then
            keyName := system.Copy(keyname, 1, pos('&', keyName) - 1);
        resp := '(' + IntToStr(GetWebVar(keyName).changed) + ')/SET_' + keyName + '=' + GetWebVar(keyName).jSONSTR;

    end;

    pos_var_name := pos('DEL_', ansiuppercase(URI)) + 4;
    if pos_var_name > 4 then begin
        keyName := system.copy(URI, pos_var_name, Length(URI));
        if pos('&', keyName) > 0 then
            keyName := system.Copy(keyname, 1, pos('&', keyName) - 1);
        resp := RemoveWebVar(keyName);
    end;
    pos_var_name := pos('LST_', ansiuppercase(URI)) + 4;
    if pos_var_name > 4 then begin
        resp := ListWebVars;
    end;

    pos_var_name := pos('SET_', ansiuppercase(URI)) + 4;
    if pos_var_name > 5 then begin
        resp := '{"status":"ok"}';
        i1 := pos('=', URI);
        if i1 > 5 then begin
            keyName := copy(URI, pos_var_name, i1 - pos_var_name);
            str1 := copy(URI, i1 + 1, Length(URI));
            str1 := AnsiReplaceStr(str1,EOT,'');
            str1 := trim(AnsiReplaceStr(str1,soh,''));
            if str1 = '' then begin
                resp := RemoveWebVar(keyName);
            end
            else begin
                 if (keyName='TLT') or  (keyName='TLO') then begin
//                                                            showmessage('TLT')
                                                        end;

                while (
                              (str1[length(str1)] <> ']') and  (str1[length(str1)] <> '}') and (length(str1) > 2)
            ) do
                    system.delete(str1, length(str1), 1);
                jsval :=TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(str1), 0);
                if jsval <> nil then
                    AddWebVar(keyName, str1, jsval)
                else
                    resp := '{"status":"errformat"}';

            end;
        end;
    end;
    resp := jreq + '(' + resp + ');';
    result := resp;
end;


function MyHTTPProcessRequest(URI: string): AnsiString;
var
    stmp, jreq, resp,compressed_resp, keyName, keyVal, str1: ansistring;
    i1, amppos, pos_var_name: integer;
    jsval : tjsonvalue;
    varTime : string;
    compress : boolean;
    ans_var :twebvar;

begin
     compress := false;
     varTime := '';
    if (pos('callback=', URI) <> 0) then begin
        stmp := copy(URI, pos('callback=', URI) + 9, length(URI));
        amppos := pos('get_member', stmp);
        if amppos > 0 then
            jreq := copy(stmp, 1, amppos - 2);
    end;
    resp := '';

    pos_var_name := pos('GET_', ansiuppercase(URI)) + 4;
    if pos_var_name > 4 then begin
        keyName := system.copy(URI, pos_var_name, Length(URI));
        if pos('&', keyName) > 0 then
            keyName := system.Copy(keyname, 1, pos('&', keyName) - 1);
        resp := GetWebVar(keyName).jSONSTR;
        if (keyName = 'TLT')  or (keyName = 'TLO') then compress := true;

        varTime := IntToStr(GetWebVar(keyName).changed);
    end;
    pos_var_name := pos('ARR_', ansiuppercase(URI)) + 4;
    if pos_var_name > 4 then begin
        keyName := system.copy(URI, pos_var_name, Length(URI));
        if pos('&', keyName) > 0 then
            keyName := system.Copy(keyname, 1, pos('&', keyName) - 1);
        ans_var := GetWeb_ARRay(keyName);
        resp := ans_var.jSONSTR;
        if (keyName = 'TLT')  or (keyName = 'TLO') then compress := true;

        varTime := IntToStr(ans_var.changed);
    end;

    pos_var_name := pos('DEL_', ansiuppercase(URI)) + 4;
    if pos_var_name > 4 then begin
        keyName := system.copy(URI, pos_var_name, Length(URI));
        if pos('&', keyName) > 0 then
            keyName := system.Copy(keyname, 1, pos('&', keyName) - 1);
        resp := RemoveWebVar(keyName);
    end;
    pos_var_name := pos('LST_', ansiuppercase(URI)) + 4;
    if pos_var_name > 4 then begin
        resp := http_ListWebVars;
        varTime := IntToStr(timegettime);
    end;

    pos_var_name := pos('SET_', ansiuppercase(URI)) + 4;
    if pos_var_name > 5 then begin
        resp := '{"status":"ok"}';
        i1 := pos('=', URI);
        if i1 > 5 then begin
            keyName := copy(URI, pos_var_name, i1 - pos_var_name);
            str1 := copy(URI, i1 + 1, Length(URI));
            str1 := AnsiReplaceStr(str1,EOT,'');
            str1 := trim(AnsiReplaceStr(str1,soh,''));
            if str1 = '' then begin
                resp := RemoveWebVar(keyName);
            end
            else begin
                while ((str1[length(str1)] <> ']') and  (str1[length(str1)] <> '}') and (length(str1) > 2)) do
                    system.delete(str1, length(str1), 1);
                jsval :=TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(str1), 0);
                if jsval <> nil then
                    AddWebVar(keyName, str1, jsval)
                else
                    resp := '{}';

            end;
        end;
    end;
    if resp='' then resp := '{}';
    if compress then  compressed_resp := '"'+compress2send(resp)+'"'
                else compressed_resp := resp;
    if varTime=''  then vartime := '-1';

    webWriteLog('HTTP request='+keyname+' Len orig='+inttostr(length(resp))+' len compressed='+inttostr(length(compressed_resp))+' compress='+floattostr(length(resp)/length(compressed_resp)));
    resp := jreq + '({"time":'+vartime+', "varValue": ' + compressed_resp + '});';
    result := resp;
end;



procedure THTTPSRVForm.terminate1Click(Sender: TObject);
begin
    halt;
end;

procedure THTTPSRVForm.Timer1Timer(Sender: TObject);
var
    ff: tfilestream;
    str1: string;
    objFileName: string;
    strlist: TStringList;
    rc: integer;
begin
    Timer1.Enabled := false;

    tcpsrv := ttcpserver.Create(nil);
    tcpsrv.LocalPort := IntToStr(StrToInt(LocalTCPPort));
    tcpsrv.OnAccept := TcpserverAccept;
    tcpsrv.Active := true;
    rc := WSAGetlastError;

    if rc <> 0 then begin
        webWriteLog(IntToStr(rc) + ' TCPSRV ' + syserrormessage(rc) + ' ');
        tcpsrv.Free;
    end;

    tcphttpsrv := ttcpserver.Create(nil);
    tcphttpsrv.LocalPort := IntToStr(StrToInt(LocalTCPPort) + 5);
    tcphttpsrv.OnAccept := TcpHTTPserverAccept;
    tcphttpsrv.Active := true;
    rc := WSAGetlastError;

    if rc <> 0 then begin
        webWriteLog(IntToStr(rc) + ' HTTPSRV ' + syserrormessage(rc) + ' ');
        tcphttpsrv.Free;
    end;

    webSocketsrv := ttcpserver.Create(nil);
    webSocketsrv.LocalPort := IntToStr(StrToInt(LocalTCPPort)+10);
    webSocketsrv.OnAccept := webSocketserverAccept;
    webSocketsrv.Active := true;
    rc := WSAGetlastError;

    if rc <> 0 then begin
        webWriteLog(IntToStr(rc) + ' webSocketsrv ' + syserrormessage(rc) + ' ');
        tcpsrv.Free;
    end;




end;


var
    ini: tinifile;
  INSTR, OUTSTR,tmpstr : AnsiString;
  i1 : integer;
initialization

    EmptyWebVar.Name := '';
    EmptyWebVar.baseName := '';
    EmptyWebVar.jsonStr := '{}';
    EmptyWebVar.changed := -1;
    EmptyWebVar.json := nil;
//    OUTSTR := ZCompressStr(INSTR,zcLevel3);
//    tmpstr := '';
//    for i1 := 1 to length(outstr) do tmpstr := tmpstr+format('%x',[ord(outstr[i1])]);
//
//    INSTR := '1234567890abcdefgh';


end.

