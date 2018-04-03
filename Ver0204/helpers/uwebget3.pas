unit uwebget;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, system.win.crtl, ucommon,
    system.json, mmsystem, Web.Win.Sockets, Winapi.WinSock, System.SyncObjs;

const
    stop = 0;
    Play = 1;
    Paused = 2;
    Max_Refresh = 2;
    Get_timeout = 300;

type
    TPlayerMode = integer;

    TIORedisThread = class(tthread)
        var
            INBUF: array[0..300000] of ansiCHAR;
            outBUF: array[0..300000] of ansiCHAR;
            TCPCli: TTcpClient;
        function SendWebVarToServer(ID: integer): integer;
        function GetWebVarFromServer(ID: integer): integer;
        procedure Update_Webvars;
        function Reddis_Exchange: ansistring;
        function Process_TCPRequest(instr: AnsiString; var resp, chtime: ansistring; Long: boolean): ansistring;
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

function ExtractJson(instr: ansistring): ansistring;

procedure Disconnect_redis;

var
    server_connected: boolean = false;
    server_once_connected: boolean = false;
    webvars_critsect: Tcriticalsection;
    answerTimeOut: integer = 120;
    webvar_count: integer = 0;
    WebVars: array[0..2000] of twebvar;
    EmptyWebVar: TWebVar; // = ('','',-1,'',nil); /
    //jsonware_url: string;
    server_port: string = '9085';
    server_addr: string = '127.0.0.1';
    LoadProject_active: boolean = true;
    webredis_errlasttime: double = -1;
    webredis_connect_lasttime: double = -1;
    local_vlcMode: integer = -1;
    oldCTC: string;
//    TCPClient: Ttcpclient;
    IOredis: TIORedisThread;
    FastVars: tstringList;
    ChangeServerIP: boolean = false;

implementation
uses uwebredis_common;
var
    PortNum: integer = 9090;
    chbuf: array[0..100000] of char;
    tmpjSon: ansistring;
    Jevent, JDev, jAirsecond: TStringList;
    Jmain: ansistring;
    jsonresult: ansistring;

procedure Disconnect_redis;
begin
    IOredis.TCPCli.Disconnect;
end;


function getVariableFromJson(var json: tjsonobject; varName: string; varvalue: variant): variant;
var
    tmpjSon: tjsonvalue;
    tmpstr: string;
    res: variant;
begin
    tmpjSon := json.GetValue(varName);
    if (tmpjSon <> nil) then begin
        tmpstr := tmpjSon.Value;
        tmpstr := AnsiReplaceStr(tmpstr, '#$%#$%', ' ');
        result := tmpstr;
    end;
end;

procedure addVariableToJson(var json: tjsonobject; varName: string; varvalue: variant);
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
    s1 := AnsiReplaceStr(strValue, ' ', '#$%#$%');
    strValue := AnsiReplaceStr(strValue, ' ', '#$%#$%');
    utf8val := stringOf(tencoding.UTF8.GetBytes(strValue));
    json.AddPair(varName, strValue);
end;

    procedure FillBuff(var buff: array of ansichar; str: ansistring);
    var
        i1, len: integer;
        lstr: tstringlist;
    begin
//        lstr := tstringlist.Create;
//        if length(instr) > 8000 then begin
//            lstr.text := instr;
//            lstr.SaveToFile(FormatDateTime('HH_NN_SS_ZZZ', now) + '.txt');
//        end;

        len := length(str);
        for i1 := 0 to length(str) - 1 do
            buff[i1] := str[i1 + 1];

    end;

function TIORedisThread.Process_TCPRequest(instr: AnsiString; var resp, chtime: ansistring; Long: boolean): ansistring;
var
    rc: integer;
    st: int64;
    SendString: ansistring;
    incount: u_long;


begin
    result := 'Error';
    st := timegettime;
    if not TCPCli.connected then begin
        if (now - webredis_connect_lasttime) * 24 * 3600 < 10 then begin
//            webWriteLog('webget', ' not connectet delay after error');
            exit;
        end;
        webredis_connect_lasttime := now;
        webWriteLog('TCP>', ' connect ' + server_addr + ' ' + server_port + ' Time = ' + IntToStr(timeGetTime - st));

        TCPCli.RemoteHost := server_addr;
        TCPCli.RemotePORT := server_PORT;
        result := 'error';
        if not TCPCli.Connect then begin
            rc := WSAGetLastError;
            webWriteLog('TCP>', ' DISconnect BY ERROR on connect' + syserrormessage(rc) + ' Time = ' + IntToStr(timeGetTime - st));
            TCPCli.Disconnect;
            exit;
        end;

        webWriteLog('TCP>', ' CHECK STATUS AFTER CONNECT' + ' Time = ' + IntToStr(timeGetTime - st));
        rc := wsagetlasterror;
        if rc <> 0 then begin
            webWriteLog('TCP>', ' DISconnect BY ERROR status after connect' + ' Time = ' + IntToStr(timeGetTime - st));
            TCPCli.Disconnect;
            webWriteLog('TCP>', ' TCPERROR = ' + syserrormessage(rc));
            Exit;
        end;
    end;

    rc := ioctlsocket(tcpcli.handle, FIONREAD, incount);
    if incount > 0 then begin
        webWriteLog('TCP>', ' FLUSH input data  '+ IntToSTR(incount));
        rc := recv(tcpcli.handle, INBUF[0], incount, 0);
    end;
    FillChar(outBUF[0], 250000, 0);
    if chtime <> '' then
        SendString :=SOH +instr + EOT + #00
    else
        SendString :=soh+ '/TIME=[' + chtime + ']' + instr+ eot + #00 ;
    fillbuff(outBUF, SendString);
    webWriteLog('TCP>', ' send blob(' +IntToStr(length(SendString))+')= '+ system.copy(SendString, 1, 190));
    rc := Send(tcpcli.handle, outBUF[0], length(SendString), 0);
    if rc < 0 then begin
        rc := WSAGetlastError;
        ;
        webWriteLog('TCP>', ' DISconnect BY ERROR AFTER SEND = ' + syserrormessage(rc));
        TCPCli.Disconnect;
        Exit;
    end;
//    webWriteLog('TCP>', ' peek answer');
//    rc := recv(tcpCli.Handle, INBUF[0], 4000, MSG_PEEK);
//    if rc < 0 then begin
//        rc := WSAGetlastError;
//        webWriteLog('TCP>', ' DISconnect BY ERROR pn peek answer');
//        tcpCli.Disconnect;
//        Exit;
//    end;
//    if Long then begin
//        webWriteLog('TCP>', ' Sleep before long');
//        sleep(300);
//    end;

    webWriteLog('TCP>', ' GET ANSWER for request');
    rc := ReceiveBlob(tcpCli.Handle, INBUF, 200000);
    if rc < 0 then begin
        rc := WSAGetlastError;
        webWriteLog('TCP>', ' DISconnect BY ERROR AFTER receive blob');
        tcpCli.Disconnect;
        Exit;
    end;
    resp := INBUF;
    webWriteLog('TCP>', ' success. TIME = ' + IntToStr(timeGetTime - st) + '  len=' + IntToStr(length(resp)) + ' Ans=' + system.copy(resp, 1, 283));
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
//    webWriteLog('webvars', 'Get ' + varName);
    result := '';
    for i := 0 to webvar_count - 1 do begin
        if webvars[i].name <> varName then
            continue;
        if webvars[i].changed = -1 then begin
            exit;
        end;
        result := webvars[i].jsonstr;
//        webWriteLog('webvars', 'Got ' + varName + ' resp=' + system.copy(result, 1, 20));
        exit;
    end;
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
    webWriteLog('PutJsonStrToServer ' + varName + ' = ' + system.copy(varvalue, 1, 60));
    if not DevicesOn then
        exit;

    Result := 'ok';
    webvars_critsect.Acquire;
    for i := 0 to webvar_count - 1 do begin
        if webvars[i].name <> varName then
            continue;
        webWriteLog('webvars', 'SET TO OUT find ' + varName + ' =  ' + IntToStr(webvars[i].changed));

        if (webvars[i].jsonstr = varvalue) and (webvars[i].changed < -5) then begin
            webWriteLog('webvars', 'Set to OUT not changed ' + varName + ' =  ' + IntToStr(webvars[i].changed));
            webvars_critsect.Leave;
            exit;
        end;

        webvars[i].jsonstr := varvalue;
        webvars[i].changed := -10;
        webvars_critsect.Leave;
        webvars[i].LastUpdate := -1;
        webWriteLog('webvars', 'Set to OUT ' + varName + ' =  ' + IntToStr(webvars[i].changed));
        webvars_critsect.Leave;
        exit;
    end;
    webWriteLog('webvar', 'Set to OUT Add var ' + varName + ' webvar Count=' + IntToStr(webvar_count));
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
function GetWebVarID(varName: ansistring): integer;
begin
    for result := 0 to webvar_count - 1 do begin
        if ansiUppercase(varName) <> ansiUppercase(webvars[result].Name) then
            continue;
        exit;
    end;
    result := -1;
end;

function AddWebVar(varName: ansistring): integer;
begin
    webvars_critsect.Enter;
    try

        Inc(webvar_count);
        webvars[webvar_count - 1].Name := varName;

        if pos('[', varName) > 0 then
            webvars[webvar_count - 1].baseName := system.copy(varName, 1, pos('[', varName) - 1)
        else
            webvars[webvar_count - 1].baseName := varName;
        webvars[webvar_count - 1].changed := -1;
        webvars[webvar_count - 1].jsonstr := '';
        webvars[webvar_count - 1].json := nil;
        webvars[webvar_count - 1].LastUpdate := -1;
        webvars[webvar_count - 1].Refresh := 500;
        if FastVars.IndexOf(varName) >= 0 then
            webvars[webvar_count - 1].Refresh := 0;

        result := webvar_count - 1;
    except
        on E: Exception do


    end;
    webvars_critsect.leave;
end;

procedure TIORedisThread.Update_Webvars;
var
    i1, i_json: integer;
    str1: ansistring;
    mstr: tmemorystream;
    ff: tfilestream;
    putcommand: ansistring;
    Refreshed: integer;
    st: int64;
    ans, resp, chtime: ansistring;
    json: tjsonobject;
    varName: AnsiString;
    varValue: ansistring;
    convResult, convValue: integer;
    tmp: tbytes;
    srvtime: AnsiString;
begin
    Refreshed := 0;
    ans := Process_TCPRequest('/LST_', resp, chtime, false);
    if ans <> '' then begin
        webWriteLog('webget', 'Error get dir list from redis = ' + ans);
        exit;
    end;
    webWriteLog(' UWV ', '/LST_ answer:' + resp);
    resp := ExtractJson(resp);
    ans := '';
    for i1 := 0 to webvar_count - 1 do
        ans := ans + ' ' + webvars[i1].Name + ':' + IntToStr(webvars[i1].changed);
    webWriteLog(' UWV ', 'Process list  = ' + resp);
    webWriteLog(' UWV ', 'Webvars = ' + ans);

    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(resp), 0) as tjsonObject;
    if json <> nil then begin
        for i_json := 0 to json.Count - 1 do begin
            st := TimegetTime;
            varName := json.get(i_json).JsonString.Value;

            varValue := json.get(i_json).JsonValue.Value;
            val(varValue, convValue, convResult);
            if convResult <> 0 then begin
                ABSWriteLog('!!! Error process VarList. Var = ' + varName + ' Lst=' + resp);
                json.free;
                exit;
            end;
            i1 := GetWebVarID(varName);
            if i1 < 0 then begin
                i1 := AddWebVar(varName);
                webWriteLog(' UWV ', 'ADD WEBVAR from server list. Var = ' + varName);
            end;
            if webvars[i1].changed < -5 then
                continue;
            if (WebVars[i1].changed > 0) and (WebVars[i1].changed = StrToInt(varValue)) then begin
                continue;
            end;

            if WebVars[i1].Refresh > 0 then begin
                webWriteLog(' UWV ', 'check refresh  Var = ' + varName);
                if st - WebVars[i1].LastUpdate < WebVars[i1].Refresh then
                    continue;
                if Refreshed > Max_refresh then
                    Continue;
            end;
            webWriteLog(' UWV ', 'Begin update ' + webvars[i1].name);

            GetWebVarFromServer(i1);
            if WebVars[i1].changed > -5 then begin
                webWriteLog(' UWV ', 'Updated ' + webvars[i1].name);
                WebVars[i1].LastUpdate := timeGetTime;
                WebVars[i1].changed := StrToInt(varValue);
                inc(Refreshed);
            end;
        end;
        for i1 := 0 to webvar_count - 1 do begin
            st := TimeGetTime;
            srvtime := '';
            if webvars[i1].changed > -5 then
                continue;
            webWriteLog(' UWV ', 'check to upload ' + webvars[i1].name);
            if json.GetValue(webvars[i1].name) <> nil then begin
                srvtime := json.GetValue(webvars[i1].name).Value;
                if (StrToInt(srvtime) <> -1) and (webvars[i1].changed < -10) then
                    continue;
            end;
            webWriteLog(' UWV ', '!!!! upload ' + webvars[i1].name);
            SendWebVarToServer(i1);
            webvars[i1].changed := -st;
            if webvars[i1].jsonStr = '' then
                webvars[i1].changed := -1;

        end;
        json.free;
    end
    else
        ABSWriteLog('Error webredis - var list = ' + resp);

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
    ans := Process_TCPRequest('/SET_' + webvars[ID].Name + '=' + webvars[ID].jsonStr, resp, chtime, false);
    if ans = '' then
        webvars[ID].changed := -St;
    webWriteLog('webget', 'Sent ' + webvars[ID].Name + ' res=' + resp);
end;

function ExtractJson(instr: ansistring): ansistring;
var
    i1: integer;
begin
    result := '';
    i1 := pos('{', instr);
    if i1 < 1 then
        exit;
    result := System.Copy(instr, i1, Length(instr));
    i1 := length(result);
    while (i1 > 2) do begin
        if result[i1] = '}' then
            break;
        i1 := i1 - 1;
    end;
    result := System.Copy(result, 1, i1);

end;

function TIORedisThread.GetWebVarFromServer(ID: integer): integer;
var
    varstr, vartime, resp: ansistring;
    ans: ansistring;
    St: int64;
    chtime: ansistring;
    jsonstr: ansistring;
begin
    webWriteLog(' GWVFS>', 'GetWebVarFromServer = ' + webvars[ID].Name);
    if webvars[ID].changed < -5 then begin
        webWriteLog(' GWVFS>', 'NOT UPDATED - output  ' + webvars[ID].Name);
        exit;
    end;
    webWriteLog(' GWVFS>', 'Request UPDATE - ' + webvars[ID].Name + ' = ' + IntToStr(webvars[ID].changed));
    St := timeGetTime;
    ans := Process_TCPRequest('/GET_' + webvars[ID].Name, resp, chtime, webvars[ID].Refresh <> 0);

    if ans = '' then begin
        webvars_critsect.Enter;
        if webvars[ID].changed < -5 then begin
            webWriteLog(' GWVFS>', 'AFTER TCP NOT UPDATED - output  ' + webvars[ID].Name);
            webvars_critsect.Leave;
            exit;
        end;

        jsonstr := ExtractJson(resp);
        if jsonstr <> '' then begin
            webvars[ID].changed := St;
            webvars[ID].jsonstr := jsonstr;
        end
        else begin
            webvars[ID].changed := -1;
            webvars[ID].jsonstr := '';
        end;
        webvars_critsect.Leave;
        ;

    end;

//    webWriteLog('webget', 'Received ' + webvars[ID].Name + ' res=' + resp);
end;

function TIORedisThread.Reddis_exchange: ansistring;
var
    st: int64;
    rc: integer;
begin
{ IORedisThread }

    if not TCPCli.connected then begin
        server_connected := false;
        if (now - webredis_connect_lasttime) * 24 * 3600*1000 < 50 then begin
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

        webWriteLog('webget', 'CONNECTED. Check status' + ' Time = ' + IntToStr(timeGetTime - st));
        rc := wsagetlasterror;
        if rc <> 0 then begin
            webWriteLog('webget', ' DISconnect BY ERROR status after connect' + ' Time = ' + IntToStr(timeGetTime - st));
            TCPCli.Disconnect;
            webWriteLog('webget', ' TCPERROR = ' + syserrormessage(rc));
            Exit;
        end;
    end;
    server_connected := true;
    server_once_connected := true;
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
            ABSWriteLog('exception on Reddis_Exchange ' + errtxt);
        errtxt := '';
    end;

end;

var
    i: integer;

initialization
    //jsonware_url := 'http://localhost:9090/';
    server_addr := '127.0.0.1';
    server_port := '9085';
    FastVars := tstringlist.Create;
    fastvars.Add('TLP');
    fastvars.Add('CTC');
    EmptyWebVar.Name := '';
    EmptyWebVar.baseName := '';
    EmptyWebVar.jsonStr := '';
    EmptyWebVar.changed := -1;
    EmptyWebVar.json := nil;
    webvars_critsect := TCriticalSection.Create;
    IOredis := TIORedisThread.Create;
    IOredis.Resume;
    webWriteLog('WEBGET',' STARTED');
    sleep(500);
    deletefile('webget');

end.

