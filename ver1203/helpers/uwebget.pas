unit uwebget;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
<<<<<<< HEAD
    Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, system.win.crtl, ucommon,
    system.json, mmsystem, Web.Win.Sockets, Winapi.WinSock, System.SyncObjs;
=======
    Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, httpsend, system.win.crtl,
    ucommon, system.json;
>>>>>>> 567489eb579fa25cb906471546da671d36020444

const
    stop = 0;
    Play = 1;
    Paused = 2;
<<<<<<< HEAD
    Max_Refresh = 2;
=======
>>>>>>> 567489eb579fa25cb906471546da671d36020444

type
    TPlayerMode = integer;

<<<<<<< HEAD
    TIORedisThread = class(tthread)
        var
            TCPCli: TTcpClient;
        function SendWebVarToServer(ID: integer): integer;
        function GetWebVarFromServer(ID: integer): integer;
        procedure Update_Webvars;
        function Reddis_Exchange: ansistring;
        function Process_TCPRequest(instr: AnsiString; var resp, chtime: ansistring): ansistring;
        procedure Execute; override;
    end;

    TWebVar = packed record
        Name: ansistring;
        baseName: ansistring;
        changed: int64;
        jsonStr: ansistring;
        json: TJSONObject;
        LastUpdate: int64;
        Refresh: int64;
    end;

procedure addVariableToJson(var json: tjsonobject; varName: string; varvalue: variant);

function getVariableFromJson(var json: tjsonobject; varName: string; varvalue: variant): variant;

function GetJsonStrFromServer(varName: ansistring): ansistring;

function PutJsonStrToServer(varName: ansistring; varvalue: ansistring): ansistring;

var
    webvars_critsect: Tcriticalsection;
    answerTimeOut: integer = 120;
    webvar_count: integer = 0;
    WebVars: array[0..2000] of twebvar;
    EmptyWebVar: TWebVar; // = ('','',-1,'',nil); /
    jsonware_url: string;
    server_port: string;
    server_addr: string;
    LoadProject_active: boolean = true;
    webredis_errlasttime: double = -1;
    webredis_connect_lasttime: double = -1;
    local_vlcMode: integer = -1;
    oldCTC: string;
//    TCPClient: Ttcpclient;
    IOredis: TIORedisThread;
=======
Procedure addVariableToJson(var json: tjsonobject; varName: string;
  varvalue: variant);
Function getVariableFromJson(var json: tjsonobject; varName: string;
  varvalue: variant): variant;

function GetJsonStrFromServer(varName: ansistring): ansistring;
function PutJsonStrToServer(varName: ansistring; varvalue: ansistring)
  : ansistring;

var
    jsonware_url: string;
    LoadProject_active: boolean = true;
    webredis_errlasttime: double = -1;
    local_vlcMode: integer = -1;
>>>>>>> 567489eb579fa25cb906471546da671d36020444

implementation

var
    PortNum: integer = 9090;
<<<<<<< HEAD
    chbuf: array[0..100000] of char;
=======
    chbuf: array [0 .. 100000] of char;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    tmpjSon: ansistring;
    Jevent, JDev, jAirsecond: TStringList;
    Jmain: ansistring;
    jsonresult: ansistring;

<<<<<<< HEAD
procedure webWriteLog(FileName: string; log: widestring);
var
    F: TextFile;
    txt, FN: ansistring;
    Day, Month, Year: Word;
    pathlog: string;
    ff: TFileStream;
begin
    try

        if FileExists(FileName) then
            ff := TFileStream.create(FileName, fmOpenWrite or fmShareDenyNone)
        else
            ff := TFileStream.create(FileName, fmCreate or fmShareDenyNone);
        ff.seek(0, soFromEnd);
        DecodeDate(now, Year, Month, Day);
        txt := FormatDateTime('dd.mm.yyyy hh:mm:ss:ms ', now);
        txt := txt + log + #13#10;
        ff.write(txt[1], length(txt));
        ff.free;
    finally

    end;
end;

function getVariableFromJson(var json: tjsonobject; varName: string; varvalue: variant): variant;
=======
Function getVariableFromJson(var json: tjsonobject; varName: string;
  varvalue: variant): variant;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
var
    tmpjSon: tjsonvalue;
    tmpstr: string;
    res: variant;
begin
    tmpjSon := json.GetValue(varName);
<<<<<<< HEAD
    if (tmpjSon <> nil) then begin
        tmpstr := tmpjSon.Value;
        tmpstr := AnsiReplaceStr(tmpstr, '#$%#$%', ' ');
=======
    if (tmpjSon <> nil) then
    begin
        tmpstr := tmpjSon.Value;
        tmpstr := AnsiReplaceStr(tmpstr,'#$%#$%', ' ');


        // varValue := tmpStr;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
        result := tmpstr;
    end;
end;

<<<<<<< HEAD
procedure addVariableToJson(var json: tjsonobject; varName: string; varvalue: variant);
=======
Procedure addVariableToJson(var json: tjsonobject; varName: string;
  varvalue: variant);
>>>>>>> 567489eb579fa25cb906471546da671d36020444
var
    teststr: ansistring;
    List: TStringList;
    numElement: integer;
    utf8val: string;
    tmpjSon: tjsonvalue;
    retval: string;
    strValue, s1: string;
    vType: tvarType;
    tmpInt: integer;
begin
    FormatSettings.DecimalSeparator := '.';
    vType := varType(varvalue);
    strValue := varvalue;
<<<<<<< HEAD
    s1 := AnsiReplaceStr(strValue, ' ', '#$%#$%');
    strValue := AnsiReplaceStr(strValue, ' ', '#$%#$%');
=======
    // if varName = 'Name'  then begin
    s1 := AnsiReplaceStr(strValue, ' ', '#$%#$%');
    strValue := AnsiReplaceStr(strValue, ' ', '#$%#$%');
    // end;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    utf8val := stringOf(tencoding.UTF8.GetBytes(strValue));
    json.AddPair(varName, strValue);
end;

<<<<<<< HEAD
function ReceiveBlob(sock: thandle; var buff: array of ansichar; len: integer): Integer;
var
    rc: integer;
    incount: integer;
    readLen: integer;
    ST: INT64;
begin

    webWriteLog('webget', 'Receive block begin');
    FillChar(buff, high(buff), 0);
    readLen := 0;
    result := -1;
    ST := TIMEGETTIME;
    while true do begin
        rc := ioctlsocket(sock, FIONREAD, incount);
        if rc < 0 then begin
            webWriteLog('webget', ' Error  ioctl. Wait for incoming message ');
            Exit;
        end;
        if incount > 3 then
            break;
        if TimegetTime - ST > answerTimeOut then begin
            webWriteLog('webget', 'Timeout. Wait for incoming message ');
            Exit;
        end;
    end;

    repeat
        sleep(2);
//        synWriteLog('webget', ' IOCTL');
        rc := ioctlsocket(sock, FIONREAD, incount);
        if incount = 0 then
            break;

        if incount > 8000 then
//            synWriteLog('webget', ' LARGE TCP To read = ' + IntToStr(incount));
//        synWriteLog('webget', ' TCP To read = ' + IntToStr(incount));
            if rc <> 0 then begin
                rc := wsagetlasterror;
                webWriteLog('webget', ' DISconnect BY ERROR AFTER ioctl = ' + syserrormessage(rc));
                Exit;
            end;
        if incount < 0 then begin
            rc := wsagetlasterror;
            if rc <> 0 then begin
                webWriteLog('webget', ' DISconnect BY ERROR AFTER RECEIVE = ' + syserrormessage(rc));
            end
            else
                webWriteLog('webget', ' DISconnect BY ERROR AFTER RECEIVE incount= ' + IntToStr(incount));
            Exit;
        end;
        rc := recv(sock, buff[readLen], incount, 0);
        if rc <= 0 then begin
            rc := WSAGetLastError;
            webWriteLog('webget', 'Error receive ' + syserrormessage(rc));
            exit;
        end;
        readLen := readLen + rc;

    until incount <= 0;
    webWriteLog('webget', 'Receive block ok len =' + IntToSTr(readLen) + ' Time=' + IntToStr(TimegetTime - ST));
    result := readLen;
end;

function TIORedisThread.Process_TCPRequest(instr: AnsiString; var resp, chtime: ansistring): ansistring;
var
    rc: integer;
    st: int64;
    SendString: ansistring;
    incount: u_long;
    INBUF: array[0..200000] of ansiCHAR;

    procedure FillBuff(var buff: array of ansichar; instr: ansistring);
    var
        i1, len: integer;
        lstr: tstringlist;
    begin
//        lstr := tstringlist.Create;
//        if length(instr) > 8000 then begin
//            lstr.text := instr;
//            lstr.SaveToFile(FormatDateTime('HH_NN_SS_ZZZ', now) + '.txt');
//        end;

        len := length(instr);
        for i1 := 0 to length(instr) - 1 do
            buff[i1] := instr[i1 + 1];

    end;

begin
    result := 'Error';
    st := timegettime;
    if not TCPCli.connected then begin
        if (now - webredis_connect_lasttime) * 24 * 3600 < 10 then begin
//            webWriteLog('webget', ' not connectet delay after error');
            exit;
        end;
        webredis_connect_lasttime := now;
        webWriteLog('webget', ' connect ' + server_addr + ' ' + server_port + ' Time = ' + IntToStr(timeGetTime - st));

        TCPCli.RemoteHost := server_addr;
        TCPCli.RemotePORT := server_PORT;
        result := 'error';
        if not TCPCli.Connect then begin
            rc := WSAGetLastError;
            webWriteLog('webget', ' DISconnect BY ERROR on connect' + syserrormessage(rc) + ' Time = ' + IntToStr(timeGetTime - st));
            TCPCli.Disconnect;
            exit;
        end;

        webWriteLog('webget', ' CHECK STATUS AFTER CONNECT' + ' Time = ' + IntToStr(timeGetTime - st));
        rc := wsagetlasterror;
        if rc <> 0 then begin
            webWriteLog('webget', ' DISconnect BY ERROR status after connect' + ' Time = ' + IntToStr(timeGetTime - st));
            TCPCli.Disconnect;
            webWriteLog('webget', ' TCPERROR = ' + syserrormessage(rc));
            Exit;
        end;
    end;
    FillChar(INBUF[0], 200000, 0);
    if chtime <> '' then
        SendString := instr + #00 + #255
    else
        SendString := '/TIME=[' + chtime + ']' + instr + #00 + #255;

    fillbuff(INBUF, SendString);

    webWriteLog('webget', ' sendln ' + system.copy(instr, 1, 20));
    rc := Send(tcpcli.handle, INBUF[0], length(SendString), 0);
    if rc < 0 then begin
        rc := WSAGetlastError;
        ;
        webWriteLog('webget', ' DISconnect BY ERROR AFTER SEND = ' + syserrormessage(rc));
        TCPCli.Disconnect;
        Exit;
    end;
    webWriteLog('webget', ' peek answer');
    rc := recv(tcpCli.Handle, INBUF[0], 4000, MSG_PEEK);
    if rc < 0 then begin
        rc := WSAGetlastError;
        webWriteLog('webget', ' DISconnect BY ERROR pn peek answer');
        tcpCli.Disconnect;
        Exit;
    end;

    rc := ReceiveBlob(tcpCli.Handle, INBUF, 200000);
    if rc < 0 then begin
        rc := WSAGetlastError;
        webWriteLog('webget', ' DISconnect BY ERROR AFTER receive blob');
        tcpCli.Disconnect;
        Exit;
    end;
    resp := INBUF;
    webWriteLog('webget', ' success. TIME = ' + IntToStr(timeGetTime - st) + '  len=' + IntToStr(length(resp)) + ' Ans=' + system.copy(resp, 1, 33));
    result := '';

end;

function GetJsonStrFromServer(varName: ansistring): ansistring;
var
    i, i1: integer;
    str1: ansistring;
    mstr: tmemorystream;
    ff: tfilestream;
    putcommand: ansistring;
    st: int64;
begin
    webWriteLog('webvars', 'Get ' + varName);
    result := '';
    webvars_critsect.Acquire;
    for i := 0 to webvar_count - 1 do begin
        if webvars[i].name <> varName then
            continue;
        if webvars[i].changed = -1 then begin
            webvars_critsect.Leave;
            exit;
        end;
        result := webvars[i].jsonstr;
        webvars_critsect.Leave;
        exit;
    end;
    inc(webvar_count);
    webWriteLog('webvar', 'GetJSON  Add var ' + varName + ' VCount=' + IntToStr(webvar_count));
    i := webvar_count - 1;
    webvars[i].Name := varName;
    webvars[i].jsonstr := '';
    webvars[i].json := nil;
    webvars[i].changed := -1;
    webvars[i].LastUpdate := -1;
    webvars[i].Refresh := 500;
    webvars_critsect.Leave;
end;

function PutJsonStrToServer(varName: ansistring; varvalue: ansistring): ansistring;
var
    i, i1: integer;
    str1: ansistring;
    mstr: tmemorystream;
    ff: tfilestream;
    putcommand: ansistring;
    st: int64;
begin
    webWriteLog('webvars', 'put ' + varName);
    Result := 'ok';
    webvars_critsect.Acquire;
    for i := 0 to webvar_count - 1 do begin
        if webvars[i].name <> varName then
            continue;
        if webvars[i].jsonstr = varvalue then begin
            webvars_critsect.Leave;
            exit;
        end;
        webvars[i].jsonstr := varvalue;
        webvars[i].changed := -10;
        webvars_critsect.Leave;
        webvars[i].LastUpdate := -1;
        webvars_critsect.Leave;
        exit;
    end;
    webWriteLog('webvar', 'PUTJSON Add var ' + varName + ' VCount=' + IntToStr(webvar_count));
    inc(webvar_count);
    i := webvar_count - 1;
    webvars[i].Name := varName;
    webvars[i].jsonstr := varvalue;
    webvars[i].changed := -10;
    webvars[i].LastUpdate := -1;
    webvars[i].Refresh := 500;
    webvars_critsect.Leave;
end;

{ TclientHelper }
procedure TIORedisThread.Update_Webvars;
var
=======
function GetJsonStrFromServer(varName: ansistring): ansistring;
var
    http: thttpsend;
    jsonstr: ansistring;
    strlist: TStringList;
    httpstr: ansistring;
    i, i1: integer;
    putcommand: ansistring;
    mstr: tmemorystream;
    ff: tfilestream;
begin
    // exit;
    // WriteLog('vlcmode','WEB GET '+ varName);
    result := '';
    if (now - webredis_errlasttime) * 24 * 3600 < 10 then
    begin
        // WriteLog('vlcmode',' errlasttime ');

        exit;
    end;
    strlist := TStringList.create;
    if pos('HTTP://', AnsiUpperCase(varName)) < 1 then
        putcommand := jsonware_url + 'GET_' + varName
    else
        putcommand := varName;
    if not httpgettext(putcommand, strlist) then
    begin
        strlist.Free;
        // WriteLog('vlcmode',' httpgettext error: '+putcommand);
        webredis_errlasttime := now;
        exit;
    end;
    result := strlist.text;
    strlist.Free;

    // WriteLog('vlcmode','      '+system.copy(result,1, 40));
    if length(result) < 6 then
    begin
        exit;
    end;
    i1 := pos('{', result);
    if i1 < 1 then
        exit;
    result := system.copy(result, i1, length(result) - 2);
    while (result[length(result)] <> '}') and (length(result) > 0) do
        system.delete(result, length(result), 1);
end;

function PutJsonStrToServer(varName: ansistring; varvalue: ansistring)
  : ansistring;
var
    http: thttpsend;
    strlist, plist: TStringList;
    httpstr: ansistring;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    i, i1: integer;
    str1: ansistring;
    mstr: tmemorystream;
    ff: tfilestream;
    putcommand: ansistring;
<<<<<<< HEAD
    Refreshed: integer;
    st: int64;
begin
    Refreshed := 0;
    for i := 0 to webvar_count - 1 do begin
        st := TimeGetTime;
        if webvars[i].changed = -10 then begin
//            if st - WebVars [i].LastUpdate < WebVars [i].LastUpdate then continue;

            SendWebVarToServer(i);
            continue;
        end;
        if webvars[i].changed > -5 then begin
            if st - WebVars[i].LastUpdate < WebVars[i].Refresh then
                continue;
            if Refreshed > Max_refresh then Continue;
                
            GetWebVarFromServer(i);
            WebVars[i].LastUpdate := st;
            inc(refreshed);
        end;
    end;
end;

function TIORedisThread.SendWebVarToServer(ID: integer): integer;
var
    varstr, vartime, resp: ansistring;
    ans: ansistring;
    St: int64;
    chtime: ansistring;
begin

    webWriteLog('webget', 'Send ' + webvars[ID].Name);
    St := timeGetTime;
    chtime := IntToStr(St);
    ans := Process_TCPRequest('/SET_' + webvars[ID].Name + '=' + webvars[ID].jsonStr, resp, chtime);
    if ans = '' then
        webvars[ID].changed := -St;
    webWriteLog('webget', 'Sent ' + webvars[ID].Name + ' res=' + resp);
end;

function TIORedisThread.GetWebVarFromServer(ID: integer): integer;
var
    varstr, vartime, resp: ansistring;
    ans: ansistring;
    St: int64;
    chtime: ansistring;
begin

    webWriteLog('webget', 'Receive ' + webvars[ID].Name);
    St := timeGetTime;
    ans := Process_TCPRequest('/GET_' + webvars[ID].Name, resp, chtime);
    if ans = '' then begin
//        webvars[ID].changed := St;
    end;

    webWriteLog('webget', 'Received ' + webvars[ID].Name + ' res=' + resp);
end;

function TIORedisThread.Reddis_exchange: ansistring;
var
    st: int64;
    rc: integer;
begin
{ IORedisThread }

    if not TCPCli.connected then begin
        if (now - webredis_connect_lasttime) * 24 * 3600 < 1 then begin
            webWriteLog('webget', ' not connectet delay after error');
            exit;
        end;
        webredis_connect_lasttime := now;
        webWriteLog('webget', ' connect ' + server_addr + ' ' + server_port + ' Time = ' + IntToStr(timeGetTime - st));

        TCPCli.RemoteHost := server_addr;
        TCPCli.RemotePORT := server_PORT;
        result := 'error';
        if not TCPCli.Connect then begin
            rc := WSAGetLastError;
            webWriteLog('webget', ' DISconnect BY ERROR on connect' + syserrormessage(rc) + ' Time = ' + IntToStr(timeGetTime - st));
            TCPCli.Disconnect;
            exit;
        end;

        webWriteLog('webget', ' CHECK STATUS AFTER CONNECT' + ' Time = ' + IntToStr(timeGetTime - st));
        rc := wsagetlasterror;
        if rc <> 0 then begin
            webWriteLog('webget', ' DISconnect BY ERROR status after connect' + ' Time = ' + IntToStr(timeGetTime - st));
            TCPCli.Disconnect;
            webWriteLog('webget', ' TCPERROR = ' + syserrormessage(rc));
            Exit;
        end;
    end;
    Update_webvars;
end;

procedure TIORedisThread.Execute;
var
    errtxt: ansistring;
begin
    TCPCli := TTcpClient.Create(nil);
    while not Terminated do begin
        sleep(1);
        errtxt := '';
        try
            Reddis_Exchange;

        except
            on E: Exception do
                errtxt := e.Message;
        end;
        if errtxt <> '' then
            ShowMessage(errtxt);
        errtxt := '';
    end;

end;

var
    i: integer;

initialization
    deletefile('webget');
    jsonware_url := 'http://localhost:9090/';
    server_addr := '127.0.0.1';
    server_port := '9085';
    EmptyWebVar.Name := '';
    EmptyWebVar.baseName := '';
    EmptyWebVar.jsonStr := '';
    EmptyWebVar.changed := -1;
    EmptyWebVar.json := nil;
    for i := 0 to 16 do begin
        Inc(webvar_count);
        webvars[i].Name := 'DEVMAN[' + IntToStr(i) + ']';
        webvars[i].baseName := 'DEVMAN';
        webvars[i].changed := -1;
        webvars[i].jsonstr := '';
        webvars[i].json := nil;
        webvars[i].LastUpdate := -1;
        webvars[i].Refresh := 1500;

    end;

//    TCPClient := TTcpClient.Create(nil);
//    TCPClient.OnReceive := TclientHelper.ClientReceive;
    webvars_critsect := TCriticalSection.Create;
    IOredis := TIORedisThread.Create;
    IOredis.Resume;

end.

=======
begin
    // exit;
    result := '';
    if LoadProject_active then
        exit;
    if (now - webredis_errlasttime) * 24 * 3600 < 10 then
        exit;
    strlist := TStringList.create;
    putcommand := jsonware_url + 'SET_' + varName + '=' + varvalue;
    if not httpgettext(putcommand, strlist) then
    begin
        webredis_errlasttime := now;
        exit;
    end;
    result := strlist.text;
    if length(strlist.text) < 6 then
    begin
        webredis_errlasttime := now;
        exit;
    end;
    i1 := pos('{', strlist.text);
    if i1 < 1 then
        exit;
    result := system.copy(strlist.text, i1, length(strlist.text) - 2);
    while (result[length(result)] <> '}') and (length(result) > 0) do
        system.delete(result, length(result), 1);
    if length(result) < 1 then
        result := ' ';
end;

initialization

jsonware_url := 'http://localhost:9090/';

end.
>>>>>>> 567489eb579fa25cb906471546da671d36020444
