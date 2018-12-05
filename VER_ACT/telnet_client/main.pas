unit main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, WinSock, ExtCtrls, mmsystem, Web.Win.Sockets,
    Vcl.Buttons;

const
    cTelnetProtocol = '23';
    cSSHProtocol = '22';

    TLNT_EOR = #239;
    TLNT_SE = #240;
    TLNT_NOP = #241;
    TLNT_DATA_MARK = #242;
    TLNT_BREAK = #243;
    TLNT_IP = #244;
    TLNT_AO = #245;
    TLNT_AYT = #246;
    TLNT_EC = #247;
    TLNT_EL = #248;
    TLNT_GA = #249;
    TLNT_SB = #250;
    TLNT_WILL = #251;
    TLNT_WONT = #252;
    TLNT_DO = #253;
    TLNT_DONT = #254;
    TLNT_IAC = #255;

type
    { :@abstract(State of telnet protocol). Used internaly by TTelnetSend. }
    TTelnetState = (tsDATA, tsIAC, tsIAC_SB, tsIAC_WILL, tsIAC_DO, tsIAC_WONT,
      tsIAC_DONT, tsIAC_SBIAC, tsIAC_SBDATA, tsSBDATA_IAC);

    Tmainform = class(TForm)
        btn1: TButton;
        edt1: TEdit;
        btn3: TButton;
        mmo1: TMemo;
        Panel1: TPanel;
        PortED: TLabeledEdit;
        AddrEd: TLabeledEdit;
        SpeedButton1: TSpeedButton;
        Button1: TButton;
        procedure btn3Click(Sender: TObject);
        procedure btn1Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

function Negotiate(sock: thandle; const Buf: Ansistring): Ansistring;

var
    tcpclient1: ttcpclient;
    mainform: Tmainform;
    INBUF: array [0 .. 6000000] of ansiCHAR;
    outBUF: array [0 .. 6000000] of ansiCHAR;
    FState: TTelnetState = tsDATA;
    FSubNeg: Ansistring;
    FSubType: ansiCHAR;
    FTermType: Ansistring;

implementation

{$R *.dfm}

procedure WriteLog(FileName: string; log: widestring);
var
    F: TextFile;
    txt, FN: Ansistring;
    Day, Month, Year: Word;
    pathlog: string;
    ff: TFileStream;
    lfname: Ansistring;
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
        txt := txt + #13#10;
        ff.write(txt[1], length(txt));
        ff.free;
    finally

    end;
end;

function Process_TCPRequest(TCPCli: ttcpclient; instr: Ansistring;
  var resp: Ansistring): Ansistring;
var
    rc: integer;
    st: int64;
    SendString, server_addr, server_port: Ansistring;
    incount: u_long;
begin
    result := 'Error';
    st := timegettime;
    if not TCPCli.connected then
    begin
        WriteLog('TCP', ' connect ' + server_addr + ' ' + server_port +
          ' Time = ' + IntToStr(timegettime - st));
        TCPCli.RemoteHost := server_addr;
        TCPCli.RemotePORT := server_port;
        result := 'error';
        if not TCPCli.Connect then
        begin
            rc := WSAGetLastError;
            WriteLog('TCP', ' DISconnect BY ERROR on connect' +
              syserrormessage(rc) + ' Time = ' + IntToStr(timegettime - st));
            TCPCli.Disconnect;
            exit;
        end;

        WriteLog('TCP>', ' CHECK STATUS AFTER CONNECT' + ' Time = ' +
          IntToStr(timegettime - st));
        rc := WSAGetLastError;
        if rc <> 0 then
        begin
            WriteLog('TCP', ' DISconnect BY ERROR status after connect' +
              ' Time = ' + IntToStr(timegettime - st));
            TCPCli.Disconnect;
            WriteLog('TCP', ' TCPERROR = ' + syserrormessage(rc));
            exit;
        end;
    end;

    FillChar(outBUF[0], 250000, 0);
    SendString := instr;
    strpcopy(outBUF, SendString);
    WriteLog('TCP>', ' send blob(' + IntToStr(length(SendString)) + ')= ' +
      system.copy(SendString, 1, 190));
    rc := Send(TCPCli.handle, outBUF[0], length(SendString), 0);
    if rc < 0 then
    begin
        rc := WSAGetLastError;
        WriteLog('TCP>', ' DISconnect BY ERROR AFTER SEND = ' +
          syserrormessage(rc));
        TCPCli.Disconnect;
        exit;
    end;
    WriteLog('TCP>', ' peek answer');
    sleep(100);
    rc := ioctlsocket(TCPCli.handle, FIONREAD, incount);
    if incount > 0 then
    begin
        WriteLog('TCP', ' FLUSH input data  ' + IntToStr(incount));
        FillChar(INBUF[0], 250000, 0);

        rc := recv(TCPCli.handle, INBUF[0], incount, 0);
    end
    else
        exit;
    if rc < 0 then
    begin
        rc := WSAGetLastError;
        WriteLog('TCP>', ' DISconnect BY ERROR pn peek answer' +
          syserrormessage(rc));
        TCPCli.Disconnect;
        exit;
    end;
    resp := INBUF;
    WriteLog('TCP>', ' success. TIME = ' + IntToStr(timegettime - st) + '  len='
      + IntToStr(length(resp)) + ' Ans=' + system.copy(resp, 1, 283));
    result := '';
end;

function Negotiate(sock: thandle; const Buf: Ansistring): Ansistring;
var
    n: integer;
    c: ansiCHAR;
    Reply: Ansistring;
    SubReply: Ansistring;
    sendstr: Ansistring;
begin
    result := '';
    for n := 1 to length(Buf) do
    begin
        c := Buf[n];
        Reply := '';
        case FState of
            tsDATA:
                if c = TLNT_IAC then
                    FState := tsIAC
                else
                    result := result + c;

            tsIAC:
                case c of
                    TLNT_IAC:
                        begin
                            FState := tsDATA;
                            result := result + TLNT_IAC;
                        end;
                    TLNT_WILL:
                        FState := tsIAC_WILL;
                    TLNT_WONT:
                        FState := tsIAC_WONT;
                    TLNT_DONT:
                        FState := tsIAC_DONT;
                    TLNT_DO:
                        FState := tsIAC_DO;
                    TLNT_EOR:
                        FState := tsDATA;
                    TLNT_SB:
                        begin
                            FState := tsIAC_SB;
                            FSubType := #0;
                            FSubNeg := '';
                        end;
                else
                    FState := tsDATA;
                end;

            tsIAC_WILL:
                begin
                    case c of
                        #3: // suppress GA
                            Reply := TLNT_DO;
                    else
                        Reply := TLNT_DONT;
                    end;
                    FState := tsDATA;
                end;

            tsIAC_WONT:
                begin
                    Reply := TLNT_DONT;
                    FState := tsDATA;
                end;

            tsIAC_DO:
                begin
                    case c of
                        #24: // termtype
                            Reply := TLNT_WILL;
                    else
                        Reply := TLNT_WONT;
                    end;
                    FState := tsDATA;
                end;

            tsIAC_DONT:
                begin
                    Reply := TLNT_WONT;
                    FState := tsDATA;
                end;

            tsIAC_SB:
                begin
                    FSubType := c;
                    FState := tsIAC_SBDATA;
                end;

            tsIAC_SBDATA:
                begin
                    if c = TLNT_IAC then
                        FState := tsSBDATA_IAC
                    else
                        FSubNeg := FSubNeg + c;
                end;

            tsSBDATA_IAC:
                case c of
                    TLNT_IAC:
                        begin
                            FState := tsIAC_SBDATA;
                            FSubNeg := FSubNeg + c;
                        end;
                    TLNT_SE:
                        begin
                            SubReply := '';
                            case FSubType of
                                #24: // termtype
                                    begin
                                        if (FSubNeg <> '') and (FSubNeg[1] = #1)
                                        then
                                        SubReply := #0 + FTermType;
                                    end;
                            end;
                            sendstr := TLNT_IAC + TLNT_SB + FSubType + SubReply
                              + TLNT_IAC + TLNT_SE;

                            Send(sock, sendstr[1], length(sendstr), 0);
                            FState := tsDATA;
                        end;
                else
                    FState := tsDATA;
                end;

        else
            FState := tsDATA;
        end;
        if Reply <> '' then
        begin
            sendstr := TLNT_IAC + Reply + c;
            Send(sock, sendstr[1], length(sendstr), 0);
        end;
    end;

end;

procedure Tmainform.btn1Click(Sender: TObject);
var
    st: int64;
    rc: integer;
    rcstr: string;
    incount, reclen: integer;

begin
    FSubNeg := '';
    FSubType := #0;
    FTermType := 'SYNAPSE';
    tcpclient1.RemoteHost := AddrEd.text;
    tcpclient1.RemotePORT := PortED.text;

    tcpclient1.Active := True; // коннект  к серверу
    tcpclient1.Disconnect;
    st := timegettime;
    tcpclient1.Connect;
    rc := WSAGetLastError;
    if rc <> 0 then
    begin
        mmo1.Lines.add(IntToStr(rc) + ' ' + syserrormessage(rc) + ' ');
        tcpclient1.free;
        exit;

    end;

    Panel1.Caption := 'Client';
    // btn1.Enabled := false;
    // btn3.Enabled := True;
    sleep(300);
    rc := ioctlsocket(tcpclient1.handle, FIONREAD, incount);
    if incount > 0 then
    begin
        WriteLog('TCP', ' FLUSH input data  ' + IntToStr(incount));
        FillChar(INBUF[0], 250000, 0);
        rc := recv(tcpclient1.handle, INBUF[0], incount, 0);
        mmo1.Lines.add(Negotiate(tcpclient1.handle, INBUF));
    end;

    sleep(300);
    rc := ioctlsocket(tcpclient1.handle, FIONREAD, incount);
    if incount > 0 then
    begin
        WriteLog('TCP', ' FLUSH input data  ' + IntToStr(incount));
        FillChar(INBUF[0], 250000, 0);
        rc := recv(tcpclient1.handle, INBUF[0], incount, 0);
        mmo1.Lines.add(Negotiate(tcpclient1.handle, INBUF));
    end;

end;
function achr(b:byte):ansichar;
begin
    result := ansichar(chr(b));
end;
procedure Convert1251_866(var s: ansistring);
{ ANSI -> ASCII }
var
    i: integer;
begin
    for i := 1 to length(s) do
        if ord(s[i]) in [192 .. 239] then
            s[i] := achr(ord(s[i]) - 64)
        else if ord(s[i]) in [240 .. 255] then
            s[i] := achr(ord(s[i]) - 16)
        else if ord(s[i]) = 168 then
            s[i] := chr(ord(240))
        else if ord(s[i]) = 184 then
            s[i] := achr(ord(241));
end;

procedure Convert866_1251(var a: ansistring); { ASCII->ANSI }
var
    i: integer;
begin
    for i := 1 to length(a) do
        if ord(a[i]) in [128 .. 175] then
            a[i] := achr(ord(a[i]) + 64)
        else if ord(a[i]) in [224 .. 239] then
            a[i] := achr(ord(a[i]) + 16)
        else if ord(a[i]) = 240 then
            a[i] := achr(ord(168))
        else if ord(a[i]) = 241 then
            a[i] := achr(ord(184));
end;

procedure Tmainform.btn3Click(Sender: TObject);
var
    st: int64;
    i1, i2: integer;
    rc: integer;
    rcstr: Ansistring;
    outbuff: array [0 .. 10000] of ansiCHAR;
    incount, reclen: integer;
    respx, resp, sendstr: Ansistring;
begin
    mmo1.Lines.add
      ('-------------------------------------------------------------');

    sendstr := edt1.text + #13#10;
    rc := Send(tcpclient1.handle, sendstr[1], length(sendstr), 0);
    if rc < 0 then
    begin
        rc := WSAGetLastError;
        WriteLog('TCP>', ' DISconnect BY ERROR on send' + syserrormessage(rc));
        tcpclient1.Disconnect;
        exit;
    end;
    sleep(30);
    rc := ioctlsocket(tcpclient1.handle, FIONREAD, incount);
    if rc < 0 then
    begin
        rc := WSAGetLastError;
        WriteLog('TCP>', ' ERR IOCTL  получение ответа' + syserrormessage(rc));
        tcpclient1.Disconnect;
        exit;
    end;

    if incount > 0 then
    begin
        WriteLog('TCP', ' FLUSH input data  ' + IntToStr(incount));
        FillChar(INBUF[0], 250000, 0);
        rc := recv(tcpclient1.handle, INBUF[0], incount, 0);
        if rc < 0 then
        begin
            rc := WSAGetLastError;
            WriteLog('TCP>', ' ERR recv  получение ответа' +
              syserrormessage(rc));
            tcpclient1.Disconnect;
            exit;
        end;
        // resp := '';
        // for i1 := 0 to 1000 do
        // begin
        // if INBUF[i1]=#0  then break;
        // resp := resp+format('%x',[ord(inbuf[i1])]);
        // end;

        resp := Negotiate(tcpclient1.handle, INBUF);
        Convert866_1251(resp);
        mmo1.Lines.add(resp);
    end;

end;

procedure Tmainform.Button1Click(Sender: TObject);
begin
    tcpclient1.Disconnect;
end;

initialization

tcpclient1 := ttcpclient.create(nil);

end.
