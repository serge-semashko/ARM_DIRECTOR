unit Unit1;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Sockets,WinSock, ExtCtrls, mmsystem;

type
    TForm1 = class(TForm)
        TcpClient1: TTcpClient;
        btn1: TButton;
        btn2: TButton;
        edt1: TEdit;
        btn3: TButton;
        btn4: TButton;
        mmo1: TMemo;
        grp1: TGroupBox;
        rbClient: TRadioButton;
        rbServer: TRadioButton;
        TcpServer1: TTcpServer;
    Panel1: TPanel;
        procedure btn1Click(Sender: TObject);
        procedure btn2Click(Sender: TObject);
        procedure TcpClient1Connect(Sender: TObject);
        procedure TcpClient1Disconnect(Sender: TObject);
        procedure btn3Click(Sender: TObject);
        procedure btn4Click(Sender: TObject);
        procedure TcpServer1Accept(Sender: TObject; ClientSocket: TCustomIpClient);
        procedure TcpClient1Receive(Sender: TObject; Buf: PAnsiChar; var DataLen: Integer);
    private
    { Private declarations }
    public
    { Public declarations }
    end;

var
    Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
    tcpserver1.LocalPort := '9091';
    TcpServer1.Active := True;           //слушаем порт
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
    TCPClient1.RemotePort := '9091' ;
    TCPClient1.Active := True;           //коннект  к серверу
end;

procedure TForm1.TcpClient1Connect(Sender: TObject);
begin
    Form1.Caption := 'Connected'
end;

procedure TForm1.TcpClient1Disconnect(Sender: TObject);
begin
    Form1.Caption := 'Disconnect';
end;

procedure TForm1.btn3Click(Sender: TObject);
var
   st : int64;
   rc : integer;
   rcstr : string;
begin
    if rbClient.Checked then begin
//        TCPClient1.Disconnect;
        st := timegettime;
        TCPClient1.Connect;
        rc :=WSAGetLastError;
        rcstr :=IntToStr(rc)+' '+syserrormessage(rc)+' ';
        TCPClient1.Sendln(edt1.Text);   //посылаем серверу
        rc :=WSAGetLastError;
        rcstr :=rcstr+IntToStr(rc)+' '+syserrormessage(rc)+' ';
//        TCPClient1.disConnect;
//        rc :=WSAGetLastError;
        rcstr :=rcstr+IntToStr(rc)+' '+syserrormessage(rc)+' ';
        caption := IntToStr(timegettime-st)+' '+ rcstr;
    end
    else
        TcpServer1.Sendln(edt1.Text);                      //посылаем клиенту
end;

procedure TForm1.btn4Click(Sender: TObject);
var
    Buffer, l: integer;
begin
    Buffer := StrToInt(edt1.Text);                           //просто берем буфер из edit`a
    l := Length(edt1.text);                                 //длинна буфера
    if rbClient.Checked then
        TCPClient1.SendBuf(Buffer, l)
    else
        TcpServer1.SendBuf(Buffer, l);
end;

procedure TForm1.TcpServer1Accept(Sender: TObject;       //пришло сообщение
    ClientSocket: TCustomIpClient);
var
    txt: string;
    buffer: array [0..1000000] of char;
    tmpBuffer: integer;
    rcstr, hstr : string;
    rc : Integer;

begin
    hstr :=IntToStr(ClientSocket.Handle);
    mmo1.Lines.add(FormatDateTime('HH:NN:SS ', now) + 'accept'+hstr);
    while True do begin
        rc := ClientSocket.ReceiveBuf(Buffer, 1000000);  //берем буфер
        rcstr := ' '+IntToStr(rc)+' ';
        if rc <=0 then begin
            mmo1.Lines.Add(hstr+rcstr+syserrormessage(wsagetlasterror));
            exit;
        end;
        if Length(buffer) <> 0 then
            mmo1.Lines.Add(hstr+rcstr+'Server_Buf::' + buffer);
    end;

end;

procedure TForm1.TcpClient1Receive(Sender: TObject; Buf: PAnsiChar; var DataLen: Integer);
var
    txt, buffer: string;
    tmpBuffer: integer;
begin
    txt := TCPClient1.Receiveln;                                     //тоже самое что и у сервера
    TcpClient1.ReceiveBuf(tmpBuffer, Length(edt1.text));
    buffer := IntToStr(tmpBuffer);
    if Length(txt) <> 0 then
        mmo1.Lines.Add('Client_Text::' + txt);
    if Length(buffer) <> 0 then
        mmo1.Lines.Add('Client_Buf::' + buffer);
end;

end.

