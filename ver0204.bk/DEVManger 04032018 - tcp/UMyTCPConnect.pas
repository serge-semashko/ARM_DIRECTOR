unit UMyTCPConnect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Samples.Spin,tcpip,pingsend,
  tcpclient, StrUtils, System.Win.ScktComp;

var
  myTCPConnect : Ttcpsend;
  myTelnet : TTelnetSend;
  myWinSocket: TClientSocket;

  TCPCount : integer = 0;
  isTCPConnect : boolean = false;

function TelnetConnect : boolean;
procedure TelnetLogout;
procedure WriteStrToTCP(stri : string);
Procedure WriteBuffToTCP(cnt: Cardinal);
function TelnetSend(sendstr : string) : boolean;
function TelnetSendBuffer(sendstr : ansistring) : boolean;

function TCPConnect : boolean;

procedure WinSocketConnect;
procedure WinSocketDisconnect;
procedure recvinfoport(stri : string);
procedure sendinfoport(stri : string);

implementation
uses MainUnit, UCommon, UMyInfo, ComPortUnit;

procedure sendinfoport(stri : string);
begin
  InfoPort.SetData(5,infoport.Options[4].Text);
  InfoPort.SetData(4,infoport.Options[3].Text);
  InfoPort.SetData(3,infoport.Options[2].Text);
  InfoPort.SetData(2,stri);
  infoport.SetData(1, MyDateTimeToStr(now));
  InfoPort.SetData(11,inttostr(SendBytes));
  InfoPort.SetData(12,inttostr(ReciveBytes));
end;

procedure recvinfoport(stri : string);
begin
  InfoPort.SetData(10,infoport.Options[9].Text);
  InfoPort.SetData(9,infoport.Options[8].Text);
  InfoPort.SetData(8,infoport.Options[7].Text);
  InfoPort.SetData(7,stri);
  infoport.SetData(6, MyDateTimeToStr(now));
  InfoPort.SetData(11,inttostr(SendBytes));
  InfoPort.SetData(12,inttostr(ReciveBytes));
end;

procedure WinSocketConnect;
begin
   try
    WinSocketDisconnect;
    fmMain.clientsocket1 := tclientsocket.Create(fmMain);
    //if fmMain.clientsocket1.Socket.Connected then fmMain.clientsocket1.Close;

    fmMain.clientsocket1.ClientType := ctNonBlocking;
    fmMain.clientsocket1.Address:=IPAdress;
    fmMain.clientsocket1.Port:=strtoint(IPPort);
    fmMain.clientsocket1.OnConnect := fmMain.ClientSocket1Connect;
    fmMain.clientsocket1.OnError := fmMain.clientsocket1Error;
    fmMain.clientsocket1.OnRead := fmMain.clientsocket1Read;
    fmMain.clientsocket1.OnWrite := fmMain.clientsocket1Write;
    fmMain.clientsocket1.OnDisconnect := fmMain.ClientSocket1Disconnect;
    fmMain.clientsocket1.Open;
    //sleep(300);
    //if fmMain.clientsocket1.Socket.Connected then begin
    //  InfoIP.SetData(5,'Подключён');
    //  isTCPConnect := true;
    //  recvinfoport(fmMain.clientsocket1.Socket.ReceiveText);
    //end else begin
    //  InfoIP.SetData(5,'Сервер не подключён');
    //  isTCPConnect := false;
    //end;
  except
    InfoIP.SetData(5,'Сервер не найден');
    isTCPConnect := false;
  end;
end;

procedure WinSocketDisconnect;
begin
  if fmMain.clientsocket1 <> nil then begin
    fmMain.clientsocket1.Close;
    fmMain.clientsocket1.Free;
    fmMain.clientsocket1 := nil;
  end;
end;


procedure GetStrings(stri : string; var lst : tstrings);
var i, pss, pse : integer;
    s1, s2 : string;
begin
  lst.Clear;
  pss := 1;
  pse := posex(#13#10,stri,1);
  while pse<>0 do begin
    s1 := copy(stri,pss,pse-pss);
    lst.Add(s1);
    pss:=pse+2;
    pse := posex(#13#10,stri,pss);
  end;
  s1 := copy(stri,pss,length(stri));
  lst.Add(s1);
end;

function TelnetReadBuffer(out stri : string) : boolean;
var i : integer;
    MyBuff: Array [0 .. 1023] Of ansichar;
    ss : string;
begin
  result := false;
  stri := '';
  myTelnet.Sock.SetTimeout(60000);
  FillChar(MyBuff, SizeOf(MyBuff), #0);
  myTelnet.Sock.RecvBuffer(@MyBuff,1000);
  ss := myTelnet.Sock.GetErrorDescEx;
  if myTelnet.Sock.GetErrorDescEx <>'' then begin
    InfoIP.SetData(5,'Ошибка:' + myTelnet.Sock.GetErrorDescEx);
    exit;
  end;

  i := 0;
  while (MyBuff[i]<>#0) and (i < 1000) do begin
    stri := stri + MyBuff[i];
    i := i + 1;
  end;

  result := true;
end;

function TelnetWaitString(cnt : integer; stri : string) : boolean;
var i, j : integer;
    answer : string;
    lst : tstrings;
    res : boolean;
begin
   result := false;
   lst := tstringlist.Create;
   lst.Clear;
   try
     for i := 0 to cnt-1 do begin
       res := TelnetReadBuffer(answer);

       if res then begin
         if trim(answer)='' then continue;
         GetStrings(answer,lst)
       end else break;

       for j := 0 to lst.Count -1 do begin
         recvinfoport(lst.Strings[j]);
         if trim(lowercase(lst.Strings[j])) = stri  then begin
           result := true;
           break;
         end;
       end;
       if result then break;
     end;
   finally
     lst.Free;
   end;
end;

function TelnetConnect : boolean;
var answer, err, ss :string;
    i, j, ps : integer;
begin

  result := false;
  myTelnet := TTelnetSend.Create;
  myTelnet.TargetHost := IPAdress;
  myTelnet.TargetPort := IPPort;
  myTelnet.UserName := IPLogin;
  myTelnet.Password := IPPassword;
  //myTelnet.Timeout := 1;
  //myTelnet.Sock.SetTimeout(1);
  //myTelnet.Sock.SocksTimeout:=1;
  //myTelnet.Sock.SetRecvTimeout(1);
  myTelnet.Login;

  //myTelnet.Sock.

  if myTelnet.Sock.GetErrorDescEx <>'' then begin
    InfoIP.SetData(5,'Ошибка:' + myTelnet.Sock.GetErrorDescEx);
    application.ProcessMessages;
    exit;
  end;

  //myTelnet.Sock.RecvBuffer(@MyBuff,100);

  if TelnetWaitString(5, 'login:') then begin
    TelnetSendBuffer(IPLogin);

    if TelnetReadBuffer(answer) then begin
      ss := lowercase(trim(answer));
      ps := pos('login:',ss);
      if ps<>0 then begin
        InfoIP.SetData(5,'Неправильный логин или паспорт');
        exit;
      end;
      ps := pos('password:',ss);
      if ps<>0 then begin
        TelnetSendBuffer(IPPassword);
        if TelnetReadBuffer(answer) then begin
          ss := lowercase(trim(answer));
          ps := pos('login:',ss);
          if ps<>0 then begin
            InfoIP.SetData(5,'Неправильный логин или паспорт');
            exit;
          end;
        end;
        //InfoIP.SetData(5,'Неправильный логин или паспорт');
        //exit;
      end;
    end;
  end;

  InfoIP.SetData(5,'Подключён');
  result := true;
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

function TelnetSendBuffer(sendstr : ansistring) : boolean;
var i : integer;
    MyBuff: Array [0 .. 1023] Of ansichar;
    ss : ansistring;
begin
  FillChar(MyBuff, SizeOf(MyBuff), #0);
  ss := sendstr;
  for i := 1 to length(ss) do begin
    MyBuff[i-1]:=sendstr[i];
  end;
    MyBuff[length(ss)]:=#13;
    MyBuff[length(ss)+1]:=#10;
  result := true;
  myTelnet.Sock.SendBuffer(@MyBuff,length(ss)+2);
  //myTelnet.Send(sendstr+#13#10);
  FillChar(MyBuff, SizeOf(MyBuff), #0);
  if myTelnet.Sock.GetErrorDescEx <>'' then begin
     InfoIP.SetData(5,'Ошибка передачи:' + myTelnet.Sock.GetErrorDescEx);
     isTCPConnect := false;
     result := false;
  end;
end;



function TCPSend(sendstr : string) : boolean;
var answer, err :string;
begin
  result := true;
  myTCPConnect.Send(sendstr+#13#10);
  err := myTCPConnect.Sock.GetErrorDescEx;
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
  answer, err :ansistring;
  MyBuff: Array [0 .. 1023] Of ansichar;
  i : integer;
begin
 result := false;
 myTCPConnect := TtcpSend.Create;
 myTCPConnect.TargetHost := IPAdress;
 myTCPConnect.TargetPort := IPPort;
// myTCPConnect.UserName := IPLogin;
// myTCPConnect.Password := IPPassword;
 myTCPConnect.Connect;
 myTCPConnect.Timeout := 300;
 err := myTCPConnect.Sock.GetErrorDescEx;
  if myTCPConnect.Sock.GetErrorDescEx <>'' then begin
   InfoIP.SetData(5,'Ошибка подключения:' + myTCPConnect.Sock.GetErrorDescEx);
   exit
 end;
   myTCPConnect.Sock.SetTimeout(1);
   FillChar(MyBuff, SizeOf(MyBuff), #0);
   myTCPConnect.Sock.RecvBuffer(@MyBuff,1000);
   //myTCPConnect.Send('open');
   FillChar(MyBuff, SizeOf(MyBuff), #0);
   err := 'open';
   for i := 1 to length(err) do begin
     MyBuff[i-1]:=err[i];
   end;
    MyBuff[length(err)]:=#13;
    MyBuff[length(err)+1]:=#10;
  result := true;
//  myTCPConnect.Sock.SendBuffer(@MyBuff,length(err)+2);


   //TCPSend('open');
   sleep(500);
   FillChar(MyBuff, SizeOf(MyBuff), #0);
   myTCPConnect.Sock.RecvBuffer(@MyBuff,1000);

   sleep(300);
   answer := myTCPConnect.RecvString;

 err := myTCPConnect.Sock.GetErrorDescEx;
 if myTCPConnect.Sock.GetErrorDescEx <>'' then begin
   //memo1.Lines.add('Error receive:'+myTCPConnect.Sock.GetErrorDescEx);
   exit
 end;
 result:=true;
   //memo1.Lines.add(answer);
end;

function TCPDisconnect : boolean;
begin
  myTCPConnect.Free;
  myTCPConnect := nil;
end;

//procedure WriteStrToTCP(stri : string);
//var answer : string;
//begin

//  if TelnetSend(stri) then begin
//    sendinfoport(stri);
//  end;
//  sleep(20);
//  answer := myTelnet.RecvString;
//  if myTelnet.Sock.GetErrorDescEx <>'' then begin
//    InfoIP.SetData(5,'Ошибка:' + myTelnet.Sock.GetErrorDescEx);
//    isTCPConnect := false;
//    exit
//  end;
//  recvinfoport(answer);
//end;

procedure WriteStrToTCP(stri : string);
begin
  try
    if port422select then exit;
    if fmMain.ClientSocket1 = nil then exit;
    if fmMain.ClientSocket1.Active then begin
      fmMain.ClientSocket1.Socket.SendText(stri + #13#10);
      sleep(2);
      SendBytes := SendBytes + length(stri) + 2;
      sendinfoport(stri);
    end;
  except
    WinSocketDisconnect;
  end;
end;

//Procedure WriteBuffToTCP(cnt: Cardinal);
//Var
//    ByteWritten: Cardinal;
//    stri: string;
//    i: Integer;
//Begin { WriteStrToPort }
//    // передаем данные
//    try
//      isTCPConnect := true;
//      myTelnet.Sock.SendBuffer(@InBuff,cnt);
//      i := 0;
//      stri := '';
//      while (InBuff[i]<>#0) and (i < 1023) do stri := stri + InBuff[i];
//      if myTelnet.Sock.GetErrorDescEx <>'' then begin
//        InfoIP.SetData(5,'Ошибка передачи:' + myTelnet.Sock.GetErrorDescEx);
//        isTCPConnect := false;
//      end else begin
//        sendinfoport(stri);
//        TelnetReadBuffer(stri);
//        recvinfoport(stri);
//      end;
//    except
//      isTCPConnect := false;
//    end;
//End; { WriteStrToPort }

Procedure WriteBuffToTCP(cnt: Cardinal);
Var
    ByteWritten: Cardinal;
    stri: string;
    i: Integer;
Begin { WriteStrToPort }
    // передаем данные
    try
      if port422select then exit;
      if fmMain.ClientSocket1 = nil then exit;
      i := 0;
      stri := '';
      for i := 0 to cnt-1
        do stri := stri + InBuff[i];
      if fmMain.ClientSocket1.Active then begin
        fmMain.ClientSocket1.Socket.SendText(stri);
        SendBytes := SendBytes + length(stri);
        sendinfoport(stri);
      end;

    except
      WinSocketDisconnect;
    end;
End; { WriteStrToPort }

end.
