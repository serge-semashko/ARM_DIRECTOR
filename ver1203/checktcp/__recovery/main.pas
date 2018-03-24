unit main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, WinSock, ExtCtrls, mmsystem, Web.Win.Sockets, Vcl.Buttons, system.json;

type
    Tmainform = class(TForm)
        btn1: TButton;
        edt1: TEdit;
        btn3: TButton;
        mmo1: TMemo;
        Panel1: TPanel;
        PortED: TLabeledEdit;
        AddrEd: TLabeledEdit;
        SpeedButton1: TSpeedButton;
        procedure btn3Click(Sender: TObject);
        procedure Tcpserver3Accept(Sender: TObject; ClientSocket: TCustomIpClient);
        procedure btn1Click(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
    private
    { Private declarations }
    public
        tcpclient1: ttcpclient;
        tcpserver1: ttcpserver;
    { Public declarations }
    end;

var
    mainform: Tmainform;

implementation

{$R *.dfm}

procedure Tmainform.btn1Click(Sender: TObject);
var
    rc: integer;
begin
    tcpserver1 := ttcpserver.Create(nil);
    tcpserver1.LocalPort := PortEd.text;
    tcpserver1.OnAccept := Tcpserver3Accept;
    tcpserver1.Active := true;
    rc := WSAGetlastError;
    if rc <> 0 then begin
        mmo1.Lines.add(IntToStr(rc) + ' ' + syserrormessage(rc) + ' ');
        tcpserver1.Free;
        exit;
    end;
    btn1.Enabled := false;
    btn3.Enabled := false;
end;

procedure Tmainform.btn3Click(Sender: TObject);
var
    st: int64;
    rc: integer;
    rcstr: string;
    buff: array[0..10000] of ansichar;
    reclen: integer;
begin
    tcpclient1 := TTcpclient.Create(nil);
    tcpclient1.RemoteHost := AddrEd.text;
    tcpclient1.Remoteport := ported.text;

    TCPClient1.Active := True;           //коннект  к серверу
    panel1.Caption := 'Client';
    btn1.Enabled := false;
    btn3.Enabled := false;
    TCPClient1.Disconnect;
    st := timegettime;
    TCPClient1.Connect;
    rc := WSAGetLastError;
    if rc <> 0 then
        rcstr := IntToStr(rc) + ' ' + syserrormessage(rc) + ' '
    else begin
        TCPClient1.Sendln(edt1.Text);   //посылаем серверу
        rc := WSAGetLastError;
        if rc <> 0 then
            rcstr := rcstr + IntToStr(rc) + ' ' + syserrormessage(rc) + ' '
        else begin
            FillChar(buff, 10000, 0);
            reclen := TCPClient1.ReceiveBuf(buff, 10000);
            rc := WSAGetLastError;
            if rc <> 0 then
                rcstr := rcstr + IntToStr(rc) + ' ' + syserrormessage(rc) + ' '
            else begin
                mmo1.Lines.add(buff);

            end;
        end;

    end;
    caption := IntToStr(timegettime - st) + ' ' + rcstr;
    mmo1.Lines.add(caption);
    TCPClient1.disConnect;
    rc := WSAGetLastError;
    btn1.Enabled := true;
    btn3.Enabled := true;
    tcpclient1.Free;

end;
function LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonObject;
begin
  json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
    as tjsonObject;
  result := true;
  if json = nil then
  begin
    result := false;
  end;

end;

procedure Tmainform.SpeedButton1Click(Sender: TObject);
var
    st, i1, len : int64;
    str1, jsonstr : ansistring;
    s1, s2: ansistring;
    b1 : boolean;
    su1, su2: string;
    json, js1, js2 : tjsonobject;
begin
     js1 := TJSONObject.Create;
     js2 := TJSONObject.Create;

   s1 := '1234567890';
   su1 := 'ЙЦУКЕНГШЩЗ';
   s2 := '1234567890';
   su2 := 'ЙЦУКЕНГШЩЗ';
    for st := 0 to 1 do begin
      s1 := s1 +s1;
      s2 := s2 +s2;
      su1 := su1 +su1;
      su2 := su2 +su2;
    end;
    st := timegettime;
    len :=length(s1);
    for i1 := 0 to  200  do js1.AddPair(IntToStr(i1),'dsfgfsadfasdfasdf');
    showmessage ('Generate json len='+FloatToStr(js1.Count)+' ansi cmp ='+IntToStr(Timegettime -st));

    st := timegettime;
        for i1 := 0 to  1000  do str1 := js1.ToString;
    showmessage ('To String ='+IntToStr(((Timegettime -st))));

    st := timegettime;
     for i1 := 0 to  1000  do    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(str1), 0) as TJSONObject;
    if js2 <> nil then

    showmessage ('from  cmp ='+IntToStr(((Timegettime -st))));
end;

procedure Tmainform.Tcpserver3Accept(Sender: TObject;       //пришло сообщение
    ClientSocket: TCustomIpClient);
var
    txt: string;
    buffer: array[0..10000] of ansichar;
    tmpBuffer: integer;
    rcstr, hstr: string;
    rc: Integer;
    outstr: AnsiString;
begin
    hstr := 'H=' + IntToStr(ClientSocket.Handle) + ' ';
    mmo1.Lines.add(FormatDateTime('HH:NN:SS ', now) + 'accept' + hstr);
    while True do begin
        rc := ClientSocket.ReceiveBuf(buffer, 10000);  //берем буфер
        rcstr := ' ' + IntToStr(rc) + ' ';
        if rc <= 0 then begin
            mmo1.Lines.Add(IntToStr(rc) + ' err:' + hstr + syserrormessage(wsagetlasterror));
            exit;
        end;
        if Length(buffer) <> 0 then
            mmo1.Lines.Add(hstr + rcstr + ' Read:' + buffer);
        outstr := buffer;
        ClientSocket.Sendln('HTTP/1.0 ' + '200' + CRLF + 'Content-type: Text/Html' + #13#10 + 'Content-length: ' + IntToStr(length(outstr)) + #13#10 + 'Connection: close' + #13#10 + 'Date: Tue, 20 Mar 2018 14:04:45 +0300' + #13#10 + 'Server: Synapse HTTP server demo' + #13#10 + #13#10 + outstr + #255);
        exit;
    end;

end;

end.
