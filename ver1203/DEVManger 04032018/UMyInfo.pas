unit UMyInfo;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
    Vcl.ExtCtrls,
    Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, Utils,
    StrUtils,
    Vcl.Buttons;

type
    TOneRec = class
        Name: string;
        RTN: trect;
        Text: string;
        RTT: trect;
        constructor create(SName, SText: string);
        destructor destroy;
    end;

    TMyInfo = class
        Count: integer;
        Options: array of TOneRec;
        function Add(Name, Text: string): integer;
        procedure SetData(Name, Text: string); overload;
        procedure SetData(index: integer; Text: string); overload;
        procedure Draw(cv: tcanvas; HeightRow: integer);
        procedure clear;
        constructor create;
        destructor destroy;
    end;

var
    InfoProtocol: TMyInfo;
    Info422: TMyInfo;
    InfoIP: TMyInfo;
    InfoWEB: TMyInfo;
    InfoPort: TMyInfo;

procedure UpdateInfoProtocol;
procedure UpdateInfo422;
procedure UpdateInfoIP;

implementation

uses ucommon;

constructor TMyInfo.create;
begin
    Count := 0;
end;

procedure TMyInfo.clear;
var
    i: integer;
begin
    for i := Count - 1 downto 0 do
    begin
        Options[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Options, Count);
    end;
    Count := 0;
end;

destructor TMyInfo.destroy;
begin
    clear;
    freemem(@Count);
    freemem(@Options);
end;

function TMyInfo.Add(Name, Text: string): integer;
begin
    Count := Count + 1;
    setlength(Options, Count);
    Options[Count - 1] := TOneRec.create(Name, Text);
    result := Count - 1;
end;

procedure TMyInfo.SetData(Name, Text: string);
var
    i: integer;
begin
    for i := 0 to Count - 1 do
    begin
        if ansilowercase(trim(Options[i].Name)) = ansilowercase(trim(Name)) then
        begin
            Options[i].Text := Text;
            exit;
        end;
    end;
end;

procedure TMyInfo.SetData(index: integer; Text: string);
begin
    Options[index].Text := Text;
end;

procedure TMyInfo.Draw(cv: tcanvas; HeightRow: integer);
var
    tmp: tfastdib;
    i, wdth, hght, rowhght, top, ps: integer;
begin
    // init(cv);
    tmp := tfastdib.create;
    try
        wdth := cv.ClipRect.Right - cv.ClipRect.Left;
        hght := cv.ClipRect.Bottom - cv.ClipRect.top;
        tmp.SetSize(wdth, hght, 32);
        tmp.clear(TColorToTfcolor(ProgrammColor));
        tmp.SetBrush(bs_solid, 0, colortorgb(ProgrammColor));
        tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
        tmp.SetTransparent(true);
        tmp.SetPen(ps_Solid, 1, colortorgb(ProgrammFontColor));
        tmp.SetTextColor(colortorgb(ProgrammFontColor));
        tmp.SetFont(ProgrammFontName, MTFontSize);
        top := 10;
        ps := (wdth - 10) div 2;
        for i := 0 to Count - 1 do
        begin
            Options[i].RTN.Left := 5;
            Options[i].RTN.Right := Options[i].RTN.Left + ps - 5;
            Options[i].RTN.top := top;
            top := top + HeightRow;
            Options[i].RTN.Bottom := top;
            Options[i].RTT.Left := Options[i].RTN.Right + 5;
            Options[i].RTT.Right := wdth - 5;
            Options[i].RTT.top := Options[i].RTN.top;
            Options[i].RTT.Bottom := Options[i].RTN.Bottom;
            tmp.DrawText(Options[i].Name, Options[i].RTN,
              DT_VCENTER or DT_SINGLELINE);
            tmp.DrawText(Options[i].Text, Options[i].RTT,
              DT_VCENTER or DT_SINGLELINE);
        end;
        tmp.SetTransparent(false);
        tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.top,
          cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
        cv.Refresh;
    finally
        tmp.Free;
        tmp := nil;
    end;
end;

constructor TOneRec.create(SName, SText: string);
begin
    Name := SName;
    initrect(RTN);
    Text := SText;
    initrect(RTT);
end;

destructor TOneRec.destroy;
begin
    freemem(@Name);
    freemem(@RTN);
    freemem(@Text);
    freemem(@RTT);
end;

procedure UpdateInfoProtocol;
begin
    InfoProtocol.SetData(0, URLServer);
    InfoProtocol.SetData(2, INFOTypeDevice);
    InfoProtocol.SetData(3, INFOVendor);
    InfoProtocol.SetData(4, INFODevice);
    InfoProtocol.SetData(5, INFOProt);
    InfoProtocol.Options[6].Name := INFOName1;
    InfoProtocol.SetData(6, INFOText1);
    InfoProtocol.Options[7].Name := INFOName2;
    InfoProtocol.SetData(7, INFOText2);
    InfoProtocol.Options[8].Name := INFOName3;
    InfoProtocol.SetData(8, INFOText3);
end;

procedure UpdateInfo422;
begin
    Info422.SetData(1, Port422Name);
    Info422.SetData(2, Port422Speed);
    Info422.SetData(3, Port422Bits);
    Info422.SetData(4, Port422Parity);
    Info422.SetData(5, Port422Stop);
    Info422.SetData(6, Port422Flow);
end;

procedure UpdateInfoIP;
begin
    InfoIP.SetData(1, IPAdress);
    InfoIP.SetData(2, IPPort);
    InfoIP.SetData(3, IPLogin);
    InfoIP.SetData(4, IPPassword);
end;

initialization

InfoProtocol := TMyInfo.create;
InfoProtocol.Add('URL WEB Сервера:', URLServer);
InfoProtocol.Add('Статус:', 'Не доступен');
InfoProtocol.Add('Тип оборудования:', INFOTypeDevice);
InfoProtocol.Add('Производитель:', INFOVendor);
InfoProtocol.Add('Устройство:', INFODevice);
InfoProtocol.Add('Протокол:', INFOProt);
InfoProtocol.Add(INFOName1, INFOText1);
InfoProtocol.Add(INFOName2, INFOText2);
InfoProtocol.Add(INFOName3, INFOText3);

Info422 := TMyInfo.create;
Info422.Add('Тип передачи', 'RS232/422');
Info422.Add('Имя порта:', Port422Name);
Info422.Add('Скорость:', Port422Speed);
Info422.Add('Кол-во бит:', Port422Bits);
Info422.Add('Четность', Port422Parity);
Info422.Add('Стоп бит', Port422Stop);
Info422.Add('Управ. потоком:', Port422Flow);
Info422.Add('Status', 'Не доступен');

InfoIP := TMyInfo.create;
InfoIP.Add('Тип передачи:', 'IP Адрес');
InfoIP.Add('IP Адрес:', IPAdress);
InfoIP.Add('IP Порт:', IPPort);
InfoIP.Add('Абонент:', IPLogin);
InfoIP.Add('Пароль:', IPPassword);
InfoIP.Add('Статус:', 'Не доступен');

InfoWEB := TMyInfo.create;
InfoWEB.Add('Тайм код системы:', '00:00:00:00');
InfoWEB.Add('Тайм код воспр. (Хронометраж):', '00:00:00:00  (00:00:00:00)');
InfoWEB.Add('Текущий кадр:', '');
InfoWEB.Add('Количество событий (текущее):', '');
InfoWEB.Add('Режим воспроизведения:', '');
InfoWEB.Add('Хрономометраж события:', '');
InfoWEB.Add('Следующее переключение:', '');
InfoWEB.Add('До переключения осталось', '00:00:00:00');
InfoWEB.Add('Текущее устройство:', '');
InfoWEB.Add('Переход:', '');
InfoWEB.Add('Команда:', '');
InfoWEB.Add('Следующее устройство:', '');
InfoWEB.Add('Переход:', '');
InfoWEB.Add('Команда:', '');

InfoPort := TMyInfo.create;
InfoPort.Add('', '');
InfoPort.Add('Время передачи:', '');
InfoPort.Add('Переданные данные:', '');
InfoPort.Add('', '');
InfoPort.Add('', '');
InfoPort.Add('', '');

InfoPort.Add('Время получения:', '');
InfoPort.Add('Полученные данные:', '');
InfoPort.Add('', '');
InfoPort.Add('', '');
InfoPort.Add('', '');
InfoPort.Add('Отправлено байт:', '');
InfoPort.Add('Полученно байт', '');

finalization

InfoProtocol.FreeInstance;
InfoProtocol := nil;

Info422.FreeInstance;
Info422 := nil;

InfoIP.FreeInstance;
InfoIP := nil;

InfoWEB.FreeInstance;
InfoWEB := nil;

InfoPort.FreeInstance;
InfoPort := nil;

end.
