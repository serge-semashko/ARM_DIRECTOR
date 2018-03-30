unit uwebredis_common;

interface

uses
    mmsystem, system.classes, system.sysutils, Web.Win.Sockets, winsock;

const
    SOH = #01; // Start of header - Начало блока данных
    EOT = #04; // End of transmit - Конец  блока данных

function ReceiveBlob(sock: thandle; var buff: array of ansichar; len: integer): Integer;

procedure webWriteLog(log: widestring); overload;

procedure webWriteLog(partname, log: widestring); overload;

procedure ABSWriteLog(log: widestring);

var
    FullLogMode: boolean = false;

implementation

procedure ABSWriteLog(log: widestring);
var
    F: TextFile;
    txt, FN: ansistring;
    Day, Month, Year: Word;
    pathlog: string;
    ff: TFileStream;
    lfname: ansistring;
begin
    try
        lfname := paramstr(0) + '.log.txt';
        if FileExists(lfname) then
            ff := TFileStream.create(lfname, fmOpenWrite or fmShareDenyNone)
        else
            ff := TFileStream.create(lfname, fmCreate or fmShareDenyNone);
        ff.seek(0, soFromEnd);
        DecodeDate(now, Year, Month, Day);
        txt := FormatDateTime('dd.mm.yyyy hh:mm:ss:zzz ', now);
        txt := '!!! ' + txt + log + #13#10;
        ff.write(txt[1], length(txt));
        ff.free;
    finally

    end;
end;

procedure webWriteLog(log: widestring); overload;
var
    F: TextFile;
    txt, FN: ansistring;
    Day, Month, Year: Word;
    pathlog: string;
    ff: TFileStream;
    lfname: ansistring;
begin
    webWriteLog('', log);
end;

procedure webWriteLog(partname, log: widestring); overload;
var
    F: TextFile;
    txt, FN: ansistring;
    Day, Month, Year: Word;
    pathlog: string;
    ff: TFileStream;
    lfname: ansistring;
begin
    if not FullLogMode then
        exit;

    try
        lfname := paramstr(0) + '.log.txt';
        if FileExists(lfname) then
            ff := TFileStream.create(lfname, fmOpenWrite or fmShareDenyNone)
        else
            ff := TFileStream.create(lfname, fmCreate or fmShareDenyNone);
        ff.seek(0, soFromEnd);
        DecodeDate(now, Year, Month, Day);
        txt := FormatDateTime('dd.mm.yyyy hh:mm:ss:zzz ', now);
        txt := txt + partname + log + #13#10;
        ff.write(txt[1], length(txt));
        ff.free;
    finally

    end;
end;

function CharPos(lookchar: ansichar; membuff: array of ansichar; len: integer): integer;
var
    i1: integer;
begin
    result := -1;
    for i1 := 0 to len - 1 do begin
        if membuff[i1] <> lookchar then
            continue;
        result := i1;
        exit;
    end;
end;

function ReceiveBlob(sock: thandle; var buff: array of ansichar; len: integer): Integer;
var
    rc: integer;
    incount: integer;
    readLen: integer;
    Blockfinished: boolean;
    BlockStarted: boolean;
    st, i1, i2, StartOfHeaderPos: int64;
begin
    st := timeGetTime;
    webWriteLog('RB>', '===================Receive blob begin=======================' + ' DTime = ' + IntToStr(TimegetTime - st));
    FillChar(buff, high(buff), 0);
    readLen := 0;
    result := -1;
    Blockfinished := false;
    BlockStarted := false;
    while (true) do begin
        sleep(2);
        rc := ioctlsocket(sock, FIONREAD, incount);
        if incount = 0 then begin
            if timegettime - st > 1000 then begin
                result := readLen;
                break;
            end;
            Continue
        end;
        st := TimegetTime;

        if not BlockStarted then begin
            FillChar(buff, high(buff), 0);
            rc := recv(sock, buff[readLen], incount, MSG_PEEK);
            webWriteLog('GB>', '====== Look start text =========' + IntToStr(incount) + ' DTime = ' + IntToStr(TimegetTime - st));
            webWriteLog('GB>', buff);
            StartOfHeaderPos := CharPos(SOH, buff, incount);
            if StartOfHeaderPos >= 0 then
                incount := StartOfHeaderPos;

            FillChar(buff, high(buff), 0);
            rc := recv(sock, buff[readLen], incount, 0);

            if StartOfHeaderPos >= 0 then
                BlockStarted := true;
            if BlockStarted then
                webWriteLog('GB>', 'OK SOH Skip ========================== ' + IntToStr(incount))
            else
                webWriteLog('GB>', 'NO SOH Skip ========================== ' + IntToStr(incount));
            webWriteLog('GB>', buff);
            webWriteLog('GB>', ' end skip ==========================');

            if not BlockStarted then
                continue;
            webWriteLog('GB>', '==================== BLOCK STARTED =======================');
        end;
        rc := ioctlsocket(sock, FIONREAD, incount);
        if rc <> 0 then begin
            rc := wsagetlasterror;
            webWriteLog('GB>', '==== DISconnect BY ERROR AFTER ioctl = ' + syserrormessage(rc));
            Exit;
        end;
        if incount < 0 then begin
            rc := wsagetlasterror;
            if rc <> 0 then begin
                webWriteLog('GB>', '===== INCOUNT <0 ??? DISconnect BY ERROR AFTER RECEIVE = ' + syserrormessage(rc));
            end
        end;
        rc := recv(sock, buff[readLen], incount, 0);
        if rc <= 0 then begin
            rc := WSAGetLastError;
            webWriteLog('GB>', 'Error receive block ' + syserrormessage(rc));
            exit;
        end;
        webWriteLog('GB>', '=================== STREAM DATA BLOCK=========' + IntToStr(incount) + ' DTime = ' + IntToStr(TimegetTime - st));
        webWriteLog('GB>', system.copy(buff,readLen,incount));
        for i1 := readLen to readLen + rc - 1 do begin
            if buff[i1] <> EOT then
                continue;
            Blockfinished := true;
            buff[i1] := #0;
            result := readLen;
            webWriteLog('GB>', '==================== BLOCK FINISHED OK with EOT =======================len =' + IntToSTr(readLen) + ' DTime = ' + IntToStr(TimegetTime - st));
            readLen := readLen + rc;
            exit;
        end;
        readLen := readLen + rc;
    end;
    webWriteLog('GB>', '==================== BLOCK FINISHED by TIMEOUT ======================= len =' + IntToSTr(readLen) + ' DTime = ' + IntToStr(TimegetTime - st));
    result := readLen;
end;

var
    i1: integer;
    lfname: ansistring;

initialization
    for i1 := 0 to ParamCount do
        if AnsiUpperCase(ParamStr(i1)) = 'NETLOG' then
            FullLogMode := true
        else
            FullLogMode := false;
    lfname := paramstr(0) + '.log.txt';
    if FileExists(lfname) then
        DeleteFile(lfname);

end.

