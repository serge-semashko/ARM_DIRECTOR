unit UMyTCPConnect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin,tcpip,pingsend, tcpclient;

var
  myTCPConnect : Ttcpsend;
  myTelnet : TTelnetSend;

  TCPCount : integer = 0;
  isTCPConnect : boolean = false;

function TelnetConnect : boolean;
procedure TelnetLogout;
procedure WriteStrToTCP(stri : string);

implementation
uses UCommon, UMyInfo;

procedure sendinfoport(stri : string);
begin
  InfoPort.SetData(5,infoport.Options[4].Text);
  InfoPort.SetData(4,infoport.Options[3].Text);
  InfoPort.SetData(3,infoport.Options[2].Text);
  InfoPort.SetData(2,stri);
  infoport.SetData(1, MyDateTimeToStr(now));
end;

procedure recvinfoport(stri : string);
begin
  InfoPort.SetData(10,infoport.Options[9].Text);
  InfoPort.SetData(9,infoport.Options[8].Text);
  InfoPort.SetData(8,infoport.Options[7].Text);
  InfoPort.SetData(7,stri);
  infoport.SetData(6, MyDateTimeToStr(now));
end;


function TelnetConnect : boolean;
var answer, err :string;
begin
 result := false;
 myTelnet := TTelnetSend.Create;
 myTelnet.TargetHost := IPAdress;
 myTelnet.TargetPort := IPPort;
 myTelnet.UserName := IPLogin;
 myTelnet.Password := IPPassword;
 myTelnet.Timeout := 1;
 if trim(IPLogin)<>'' then begin
   myTelnet.SSHLogin;
 end else begin
   myTelnet.Login;
 end;

 err := myTelnet.Sock.GetErrorDescEx;

 if myTelnet.Sock.GetErrorDescEx <>'' then begin
   InfoIP.SetData(5,'Ошибка:' + myTelnet.Sock.GetErrorDescEx);
   application.ProcessMessages;
   exit;
 end;

 sleep(300);
 answer := myTelnet.RecvString;


 if myTelnet.Sock.GetErrorDescEx <>'' then begin
   InfoIP.SetData(5,'Ошибка:' + myTelnet.Sock.GetErrorDescEx);
//   application.ProcessMessages;
   exit
 end;
 InfoIP.SetData(5,'Подключён');
 recvinfoport(answer);
 result := true;
// application.ProcessMessages;
 //  memo1.Lines.add(answer);
end;

procedure TelnetLogout;
begin
  if myTelnet = nil then exit;

  //if myTelnet.Sock.SocksOpen then begin
    myTelnet.Logout;
    InfoIP.SetData(5,'Отключён');
    sleep(100);
    isTCPConnect := false;
  //end;
end;

function TelnetSend(sendstr : string) : boolean;
var answer :string;
begin
  result := true;
  myTelnet.Send(sendstr+#13#10);
  if myTelnet.Sock.GetErrorDescEx <>'' then begin
     InfoIP.SetData(5,'Ошибка передачи:' + myTelnet.Sock.GetErrorDescEx);
     isTCPConnect := false;
     result := false;
  end;
end;



function TCPSend(sendstr : string) : boolean;
var answer :string;
begin
  result := true;
  myTCPConnect.Send(sendstr+#13#10);
  if myTCPConnect.Sock.GetErrorDescEx <>'' then begin
     InfoIP.SetData(5,'Ошибка передачи:' + myTCPConnect.Sock.GetErrorDescEx);
     result := false;
  end;
end;

function TCPRecive(out answ : string) : boolean;
begin
  //myTelnet.UserName
end;

function TCPConnect : boolean;
var
  answer :string;
begin
 result := false;
 myTCPConnect := TtcpSend.Create;
 myTCPConnect.TargetHost := IPAdress;
 myTCPConnect.TargetPort := IPPort;
 myTCPConnect.UserName := IPLogin;
 myTCPConnect.Password := IPPassword;
 myTCPConnect.Connect;
 myTCPConnect.Timeout := 1;
  if myTCPConnect.Sock.GetErrorDescEx <>'' then begin
   InfoIP.SetData(5,'Ошибка подключения:' + myTCPConnect.Sock.GetErrorDescEx);
   exit
 end;

   sleep(300);
   answer := myTCPConnect.RecvString;


 if myTCPConnect.Sock.GetErrorDescEx <>'' then begin
   //memo1.Lines.add('Error receive:'+myTCPConnect.Sock.GetErrorDescEx);
   exit
 end;
   //memo1.Lines.add(answer);
end;

function TCPDisconnect : boolean;
begin
  myTCPConnect.Free;
  myTCPConnect := nil;
end;

procedure WriteBuffToTCP(cnt : cardinal);
begin

end;

procedure WriteStrToTCP(stri : string);
var answer : string;
begin

  if TelnetSend(stri) then begin
    sendinfoport(stri);
  end;
  sleep(20);
  answer := myTelnet.RecvString;
  if myTelnet.Sock.GetErrorDescEx <>'' then begin
    InfoIP.SetData(5,'Ошибка:' + myTelnet.Sock.GetErrorDescEx);
    isTCPConnect := false;
    exit
  end;
  recvinfoport(answer);
end;

end.
