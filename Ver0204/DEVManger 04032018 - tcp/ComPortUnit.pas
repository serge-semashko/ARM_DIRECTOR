unit ComPortUnit;

interface

uses Windows, Forms, SysUtils, Classes, MainUnit, Dialogs, Registry;
// RusErrorStr,

type
    // определим тип TComThread - наследника класса TThread
    TCommThread = class(TThread)
    private
        { Private declarations }
        // процедура, занимающаяся опросом порта
        Procedure QueryPort;
    protected
        // переопределим метод запуска потока

        Procedure Execute; override;
    end;

function StartService: boolean;
Procedure StopService;
Procedure WriteStrToPort(Str: ansistring);
Procedure WriteCharToPort(Ch: ansistring);
Procedure WriteBuffToPort(cnt: Cardinal);
function GetSerialPortNames(lst: TStrings): string;
function MyGetCommState : boolean;

// глобальные переменные
Var
    // необходимые переменные
    CommThreadExists: boolean = false;
    CommThread: TCommThread;
    // наш поток, в котором будет работать процедура опроса порта
    hPort: Integer; // дескриптор порта
    // совсем не обязательные переменые, используемые для "украшения" приложения
    SendBytes: Cardinal; // количество переданных в порт байт
    ReciveBytes: Cardinal; // количество считанных из порта байт
    lstCommMes: TStrings;
    CommDataRead: boolean = false;
    InBuff: array [0 .. 1023] of ansichar;

implementation

uses UMyInitFile, UCommon, umyinfo;

function GetSerialPortNames(lst: TStrings): string;
var
    reg: TRegistry;
    l: TStringList;
    n: Integer;
begin
    l := TStringList.Create;
    reg := TRegistry.Create;
    lst.Clear;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM');
        reg.GetValueNames(l);
        for n := 0 to l.Count - 1 do
        begin
            lst.Add(reg.ReadString(l[n]));
        end;
        Result := lst.CommaText;
    finally
        reg.Free;
        l.Free;
    end;
end;

Procedure StartComThread;
Begin { StartComThread }
    CommThread := TCommThread.Create(false);
    If CommThread = Nil then
    begin { Nil }
        SysErrorMessage(GetLastError);
        StopService;
        Exit;
    End; { Nil }
    CommThreadExists := true;
End; { StartComThread }

Procedure TCommThread.Execute;
Begin { Execute }
    try
        if PortRSStoped then
            Exit;
        while not Terminated do
        begin
            sleep(10);
            QueryPort;
        end;
        // Repeat
        // QueryPort;//процедура опроса порта будет производиться пока поток не будет прекращен
        // Until Terminated;
    except
    end;
End; { Execute }

Procedure TCommThread.QueryPort;
Var
    MyBuff: Array [0 .. 1023] Of ansichar; // буфер для чтения данных
    ByteReaded: Cardinal; // количество считанных байт
    Str, s1, s2, lststr: ansistring; // вспомогательная строка
    Status: DWord; // статус устройства (модема)
    ipos, i: Integer;
    stat: TComStat;
    commErrors: DWord;
Begin { QueryPort }
    try
        If Not GetCommModemStatus(hPort, Status) then
        begin
            SysErrorMessage(GetLastError);
            if CommThread <> nil then
                StopService;
            Port422Init := false; // fmMain.btnStop.Click;
            Exit;
        end; { ошибка при получении статуса модема }

        // Проверяем есть ли символы для чтения. stat.cbInQue - количество байтов в очереди
        if not PortRSStoped then
        begin
            if not ClearCommError(hPort, commErrors, @stat) then
                RaiseLastwin32error;
            If stat.cbInQue < 1 Then
                Exit;
            // читаем буфер из Com-порта
            FillChar(MyBuff, SizeOf(MyBuff), #0);
            If Not ReadFile(hPort, MyBuff, SizeOf(MyBuff), ByteReaded, nil) then
            begin
                SysErrorMessage(GetLastError);
                if CommThread <> nil then
                    StopService;
                Port422Init := false; // fmMain.btnStop.Click;
                Exit;
            end; { ошибка при чтении данных }

            If ByteReaded > 0 then
            begin
                ReciveBytes := ReciveBytes + ByteReaded;
                // Str:='<' + ansistring(MyBuff) +'>';
                // str:='';
                for i := 0 to ByteReaded - 1 do
                    Str := Str + inttohex(ord(MyBuff[i]));

                s1 := Str;
                lststr := ''; // lstCommMes.Clear;
                lststr := lststr + s1; // lstCommMes.Add(s1);
                CommDataRead := true;
                // отправим строку на просмотр

                // fmMain.Memo1.Text:=fmMain.Memo1.Text+#13#10+lststr;//fmMain.Memo1.Lines.AddStrings(lstCommMes);
                infoport.SetData(9, infoport.Options[8].Text);
                infoport.SetData(8, infoport.Options[7].Text);
                infoport.SetData(7, Str);
                infoport.SetData(6, MyDateTimeToStr(now));
                infoport.SetData(12, inttostr(ReciveBytes));
                // fmMain.lbRecv.Caption:='recv: '+IntToStr(ReciveBytes)+' bytes...';
            End; { ByteReaded>0 }
            // application.ProcessMessages;
        end;
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { QueryPort }

function MyGetCommState : boolean;
Var DCB: TDCB;
begin
  result := true;
  If (hPort < 0) Or Not SetupComm(hPort, 2048, 2048) Or
  Not GetCommState(hPort, DCB) then
  begin
    SysErrorMessage(GetLastError);
    StopService;
    Result := false;
    Exit;
  End; { ошибка }
  Port422Speed := inttostr(DCB.BaudRate);
  Port422Bits := inttostr(DCB.ByteSize);
      case DCB.Parity of
  0 : Port422Parity := 'нет';
  1 : Port422Parity := 'нечет';
  2 : Port422Parity := 'чет';
  3 : Port422Parity := 'маркер';
  4 : Port422Parity := 'пробел';
      end;

      case DCB.StopBits of
  0 : Port422Stop := '1';
  1 : Port422Stop := '1.5';
  2 : Port422Stop := '2';
      end;

      if (DCB.Flags and $00002015)=$00002015 then Port422Flow := 'Аппаратное'
      else if (DCB.Flags and $00000311)=$00000311 then Port422Flow := 'XOn/XOff'
      else if (DCB.Flags and $00000011)=$00000011 then Port422Flow := 'нет';
end;

function InitPort: boolean;
Var
    DCB: TDCB; // структура для хранения настроек порта
    CT: TCommTimeouts; // стркутура для хранения тайм-аутов
    lpcc: _COMMCONFIG;
    sz: DWord;
Begin { InitPort }
    try
        try
            Result := true;
            hPort := CreateFile(Pchar(port422name), GENERIC_READ or
              GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
              OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

            If (hPort < 0) Or Not SetupComm(hPort, 2048, 2048) Or
              Not GetCommState(hPort, DCB) then
            begin
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ошибка }

            GetCommState(hPort, DCB);

            // Port422Flow : string = 'нет';

            if trim(Port422Speed) = '' then
                DCB.BaudRate := strtoint(Port422Speed)
            else
                DCB.BaudRate := StrToInt(Port422Speed);
            if trim(Port422Bits) = '' then
                DCB.ByteSize := 8
            else
                DCB.ByteSize := StrToInt(Port422Bits);
            if trim(Port422Parity) = '' then
                DCB.Parity := 1
            else if ansilowercase(trim(Port422Parity)) = 'нечет' then
                DCB.Parity := 1
            else if ansilowercase(trim(Port422Parity)) = 'нет' then
                DCB.Parity := 0
            else if ansilowercase(trim(Port422Parity)) = 'чет' then
                DCB.Parity := 2
            else if ansilowercase(trim(Port422Parity)) = 'маркер' then
                DCB.Parity := 3
            else if ansilowercase(trim(Port422Parity)) = 'пробел' then
                DCB.Parity := 4;

            if trim(Port422Stop) = '' then
                DCB.StopBits := 0
            else if ansilowercase(trim(Port422Stop)) = '1' then
                DCB.StopBits := 0
            else if ansilowercase(trim(Port422Stop)) = '1.5' then
                DCB.StopBits := 1
            else if ansilowercase(trim(Port422Stop)) = '2' then
                DCB.StopBits := 2;

            if trim(Port422Flow) = '' then
                DCB.Flags := DCB.Flags or $00000011
            else if ansilowercase(trim(Port422Flow)) = 'нет' then
                DCB.Flags := DCB.Flags and $00000011
            else if ansilowercase(trim(Port422Flow)) = 'XOn/XOff' then
                DCB.Flags := DCB.Flags and $00000311
            else if ansilowercase(trim(Port422Flow)) = 'Аппаратное' then
                DCB.Flags := DCB.Flags and $00002015;


            // fmMain.StatusBar1.Panels[0].Text:=StringParameters(DCB.BaudRate,DCB.ByteSize,DCB.StopBits,DCB.Parity,DCB.Flags);

            If Not SetCommState(hPort, DCB) then
            begin { ошибка }
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ошибка }

            // устанавливаем параметры тайм-аутов
            If Not GetCommTimeouts(hPort, CT) then
            begin { ошибка }
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ошибка }
            // тайм-ауты
            CT.ReadTotalTimeoutConstant := 50; // 50;
            CT.ReadIntervalTimeout := 50; // 50;
            CT.ReadTotalTimeoutMultiplier := 10;
            CT.WriteTotalTimeoutMultiplier := 10; // 10;
            CT.WriteTotalTimeoutConstant := 10; // 10;

            If Not SetCommTimeouts(hPort, CT) then
            begin { ошибка }
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ошибка }
        except
            MessageDlg('Ошибка обращения к порту ' + port422name + '.',
              mtInformation, [mbOk], 0, mbOk);
            Result := false;
        end;
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { InitPort }

Procedure WriteStrToPort(Str: ansistring);
Var
    ByteWritten: Cardinal;
    MyBuff: Array [0 .. 1023] Of ansichar;
Begin { WriteStrToPort }
    try
        FillChar(MyBuff, SizeOf(MyBuff), #0);
        StrLCopy(MyBuff, PansiChar(Str), Length(Str));

        infoport.SetData(1, MyDateTimeToStr(now));
        infoport.SetData(4, infoport.Options[3].Text);
        infoport.SetData(3, infoport.Options[2].Text);

        // передаем данные
        If Not WriteFile(hPort, MyBuff, Length(Str), ByteWritten, Nil) then
        begin
            SysErrorMessage(GetLastError);
            StopService;
            infoport.SetData(2, 'Ошибка передачи');
            Exit;
        End; { ошибка }
        // считаем байтики
        infoport.SetData(2, Str);
        SendBytes := SendBytes + ByteWritten;
        infoport.SetData(11, inttostr(SendBytes));
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { WriteStrToPort }

//Procedure WriteBuffToPort(cnt: Cardinal);
//Var
//    ByteWritten: Cardinal;
//    stri: string;
//    i: Integer;
//Begin { WriteStrToPort }
//    // передаем данные
//    try
//        sleep(5);
//        infoport.SetData(1, MyDateTimeToStr(now));
//        infoport.SetData(4, infoport.Options[3].Text);
//        infoport.SetData(3, infoport.Options[2].Text);
//        If Not WriteFile(hPort, InBuff, cnt, ByteWritten, Nil) then
//        begin
//            SysErrorMessage(GetLastError);
//            StopService;
//            infoport.SetData(2, 'Ошибка передачи');
//            Exit;
//        End; { ошибка }
//        // считаем байтики
//        stri := '';
//        for i := 0 to cnt - 1 do
//            stri := stri + inttohex(ord(InBuff[i]));
//        infoport.SetData(2, stri);
//        SendBytes := SendBytes + ByteWritten;
//        infoport.SetData(11, inttostr(SendBytes));
//        // fmMain.lbSend.Caption:='send: ' + IntToStr(SendBytes) + ' bytes...';
//
//    except
//        if CommThread <> nil then
//            StopService;
//        Port422Init := false;
//    end;
//End; { WriteStrToPort }

Procedure WriteBuffToPort(cnt: Cardinal);
Var
    ByteWritten: Cardinal;
    stri: string;
    i: Integer;
  function myWriteFile:boolean;
  var
    i1 : integer;

  begin
     for I1 := 0 to cnt-1 do begin
       result := WriteFile(hPort, InBuff[i1], 1, ByteWritten, Nil);
       if not result  then exit;

       sleep(2);
     end;
     ByteWritten := i1+1;
  end;

Begin { WriteStrToPort }
    // передаем данные
    try
        sleep(2);
        infoport.SetData(1, MyDateTimeToStr(now));
        infoport.SetData(4, infoport.Options[3].Text);
        infoport.SetData(3, infoport.Options[2].Text);
        If Not myWriteFile then
        begin
            SysErrorMessage(GetLastError);
            StopService;
            infoport.SetData(2, 'Ошибка передачи');
            Exit;
        End; { ошибка }
        // считаем байтики
        stri := '';
        for i := 0 to cnt - 1 do
            stri := stri + inttohex(ord(InBuff[i]));
        infoport.SetData(2, stri);
        SendBytes := SendBytes + ByteWritten;
        infoport.SetData(11, inttostr(SendBytes));
        // fmMain.lbSend.Caption:='send: ' + IntToStr(SendBytes) + ' bytes...';

    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { WriteStrToPort }

Procedure WriteCharToPort(Ch: ansistring);
Var
    len, ByteWritten: Cardinal;
    s: ansistring;
    MyBuff: Array [0 .. 1023] Of ansichar;
    i: Integer;
Begin
    try
        // передаем данные
        s := Ch;
        len := Length(s);
        // for i:=1 to len do MyBuff[i-1]:=s[i];

        StrLCopy(MyBuff, PansiChar(s), Length(s));
        len := Length(s);

        infoport.SetData(1, MyDateTimeToStr(now));
        infoport.SetData(4, infoport.Options[3].Text);
        infoport.SetData(3, infoport.Options[2].Text);

        If Not WriteFile(hPort, MyBuff, len, ByteWritten, Nil) then
        begin
            SysErrorMessage(GetLastError);
            StopService;
            infoport.SetData(2, 'Ошибка передачи');
            Exit;
        End; { ошибка }
        infoport.SetData(2, s);
        // application.ProcessMessages;
        // считаем байтики
        SendBytes := SendBytes + ByteWritten;
        infoport.SetData(11, inttostr(SendBytes));
        // fmMain.lbSend.Caption:='send: ' + IntToStr(SendBytes) + ' bytes...';
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End;

Procedure StopService;
Begin { StopService }
    try
        if PortRSStoped then
            Exit;
        PortRSStoped := true;

        // fmMain.Memo1.Lines.Add('COM-port service stoped...');
        CommThread.Terminate;
        CloseHandle(hPort); // закрываем порт
        CommThreadExists := false;
        if CommThread <> nil then
            CommThread.Free;
        CommThread := nil; // "отпускаем" поток
    except

    end;
End; { StopService }

function StartService: boolean;
var
    bl: boolean;
Begin { StartService }
    try
        Result := InitPort;
        if Result then
        begin
            StartComThread;
            // если порт проинициализировался, то запускаем поток
            PortRSStoped := false;
        end;
        // fmMain.Memo1.Lines.Clear;
        // fmMain.Memo1.Lines.Add('COM-port service started...');
        SendBytes := 0;
        ReciveBytes := 0;
        infoport.SetData(11, inttostr(SendBytes));
        infoport.SetData(12, inttostr(ReciveBytes));
        // fmMain.lbSend.Caption:='send: '+IntToStr(SendBytes)+' bytes...';
        // fmMain.lbRecv.Caption:='recv: '+IntToStr(ReciveBytes)+' bytes...';
    except
    end;
End; { StartService }

initialization

lstCommMes := TStringList.Create;
lstCommMes.Clear;

finalization

lstCommMes.Free;

end.
