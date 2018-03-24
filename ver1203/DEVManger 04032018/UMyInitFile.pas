unit UMyInitFile;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, Buttons, Vcl.ComCtrls, IniFiles;

var
    ini: tinifile;

procedure ReadIniFile(Name: string);
procedure WriteIniFile(Name: string);
function StringParameters(Baud, Bits, StopBit, Parity,
  Control: Cardinal): string;
function UniqueApp: Boolean;
Procedure AutoStartEnable;
Procedure AutoStartDisable;
procedure SetIconApplication(img: timage; Nom: integer);

implementation

uses MainUnit, ucommon, ShellApi, shlobj, registry;

procedure ReadIniFile(Name: string);
begin
    ini := tinifile.Create(Name);
    // GridFile:=ini.ReadString('Files','GridFile',AppPath + AppName + '.grid');
    // CommandFile:=ini.ReadString('Files','CommandFile',AppPath + AppName + '.comn');

    // Основные параметры программы
    // SerialNumber := ini.ReadString('MAIN', 'SerialNumber', SerialNumber);
    ManagerNumber := ini.ReadInteger('MAIN', 'ManagerNumber', ManagerNumber);
    Port422Name := ini.ReadString('MAIN', 'Port422Name', Port422Name);
    Port422Number := ini.ReadInteger('MAIN', 'Port422Number', Port422Number);
    Port422Speed := ini.ReadString('MAIN', 'Port422Speed', Port422Speed);
    Port422Bits := ini.ReadString('MAIN', 'Port422Bits', Port422Bits);
    Port422Parity := ini.ReadString('MAIN', 'Port422Parity', Port422Parity);
    Port422Stop := ini.ReadString('MAIN', 'Port422Stop', Port422Stop);
    Port422Flow := ini.ReadString('MAIN', 'Port422Flow', Port422Flow);
    IPAdress := ini.ReadString('MAIN', 'IPAdress', IPAdress);
    IPPort := ini.ReadString('MAIN', 'IPPort', IPPort);
    IPLogin := ini.ReadString('MAIN', 'IPLogin', IPLogin);
    IPPassword := ini.ReadString('MAIN', 'IPPassword', IPPassword);
    URLServer := ini.ReadString('MAIN', 'URLServer', URLServer);
    Port422select := ini.ReadBool('MAIN', 'Port422select', Port422select);
    MakeLogging := ini.ReadBool('MAIN', 'MakeLogging', MakeLogging);
    AutoStart := ini.ReadBool('MAIN', 'AutoStart', AutoStart);
    MTFontSize := ini.ReadInteger('MAIN', 'MTFontSize', MTFontSize);
    ini.Free;
end;

procedure WriteIniFile(Name: string);
begin
    ini := tinifile.Create(Name);
    // ini.WriteString('Files','GridFile',GridFile);
    // ini.WriteString('Files','CommandFile',CommandFile);

    // Основные параметры программы
    // ini.WriteString('MAIN', 'SerialNumber', SerialNumber);
    ini.WriteInteger('MAIN', 'ManagerNumber', ManagerNumber);
    ini.WriteString('MAIN', 'Port422Name', Port422Name);
    ini.WriteInteger('MAIN', 'Port422Number', Port422Number);
    ini.WriteString('MAIN', 'Port422Speed', Port422Speed);
    ini.WriteString('MAIN', 'Port422Bits', Port422Bits);
    ini.WriteString('MAIN', 'Port422Parity', Port422Parity);
    ini.WriteString('MAIN', 'Port422Stop', Port422Stop);
    ini.WriteString('MAIN', 'Port422Flow', Port422Flow);
    ini.WriteString('MAIN', 'IPAdress', IPAdress);
    ini.WriteString('MAIN', 'IPPort', IPPort);
    ini.WriteString('MAIN', 'IPLogin', IPLogin);
    ini.WriteString('MAIN', 'IPPassword', IPPassword);
    ini.WriteString('MAIN', 'URLServer', URLServer);
    ini.WriteBool('MAIN', 'Port422select', Port422select);
    ini.WriteBool('MAIN', 'MakeLogging', MakeLogging);
    ini.WriteBool('MAIN', 'AutoStart', AutoStart);
    ini.WriteInteger('MAIN', 'MTFontSize', MTFontSize);
    ini.Free;
end;

function StringParameters(Baud, Bits, StopBit, Parity,
  Control: Cardinal): string;
var
    val: Cardinal;
    s: string;
begin

    Result := trim(Port422Name);
    Result := Result + ': Baud: ' + inttostr(Baud) + '; Bits=' + inttostr(Bits)
      + '; Stop=';
    case StopBit of
        0:
            Result := Result + '1; Parity=';
        1:
            Result := Result + '1.5; Parity=';
        2:
            Result := Result + '2; Parity=';
    end;
    case Parity of
        0:
            Result := Result + 'Нет; Flow=';
        1:
            Result := Result + 'Нечет.; Flow=';
        2:
            Result := Result + 'Четн.; Flow=';
        3:
            Result := Result + 'Маркер(1); Flow=';
        4:
            Result := Result + 'Пробел(0); Flow=';
    end;
    // result := result + inttohex(Control);

    s := IntToHex(Control);
    if (Control and $00000300) <> 0 then
        Result := Result + 'XOn/XOff'
    else if (Control and $00002004) <> 0 then
        Result := Result + 'Аппаратное'
    else if (Control and $00000011) <> 0 then
        Result := Result + 'Нет';
end;

function UniqueApp: Boolean;
Var
    HM: THandle;
begin
    HM := CreateMutex(nil, False, PChar(Application.Title));
    Result := GetLastError <> ERROR_ALREADY_EXISTS;
end;

Procedure AutoStartEnable;
var
    reg: tRegistry;
begin
    reg := tRegistry.Create();
    try
        reg.RootKey := HKEY_CURRENT_USER;
        if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True)
        then
        begin
            reg.WriteString(Application.Title, Application.ExeName);
            reg.CloseKey();
        end;
    finally
        reg.Free;
    end;
end;

Procedure AutoStartDisable;
var
    reg: tRegistry;
begin
    reg := tRegistry.Create();
    try
        reg.RootKey := HKEY_CURRENT_USER;
        if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False)
        then
        begin
            reg.DeleteValue(Application.Title);
            reg.CloseKey();
        end;
    finally
        reg.Free;
    end;
end;

function BitmapToIcon(const Bitmap: TBitmap; Icon: TIcon;
  MaskColor: TColor): Boolean;
{ Render an icon from a 16x16 bitmap. Return false if error.
  MaskColor is a color that will be rendered transparently. Use clNone for
  no transparency. }
var
    BitmapImageList: TImageList;
begin
    BitmapImageList := TImageList.CreateSize(48, 48);
    try
        Result := False;
        BitmapImageList.AddMasked(Bitmap, MaskColor);
        BitmapImageList.GetIcon(0, Icon);
        Result := True;
    finally
        BitmapImageList.Free;
    end;
end;

procedure SetIconApplication(img: timage; Nom: integer);
var
    bmp: TBitmap;
    Icon: TIcon;
    lf, tp: integer;
    s: string;
begin
    Icon := TIcon.Create;
    try

        bmp := TBitmap.Create;
        try
            bmp.Width := 48;
            bmp.Height := 48;
            bmp.Canvas.Brush.Color := clBlue;
            bmp.Canvas.Brush.Style := bsSolid;
            bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
            bmp.Canvas.Font.Color := clWhite; // clYellow;
            bmp.Canvas.Pen.Color := clWhite;
            bmp.Canvas.Pen.Width := 3;
            bmp.Canvas.Brush.Style := bsClear;
            bmp.Canvas.Rectangle(bmp.Canvas.ClipRect);
            // bmp.Canvas.Font.Size:=10;//bmp.Height div 2;
            // s:='COM';
            // lf:=(bmp.Width-bmp.Canvas.TextWidth(s)) div 2;
            // bmp.Canvas.TextOut(lf,1,s);
            s := inttostr(Nom);
            bmp.Canvas.Font.Size := 22;
            tp := (bmp.Height - bmp.Canvas.TextHeight(s)) div 2;
            lf := (bmp.Width - bmp.Canvas.TextWidth(s)) div 2;
            bmp.Canvas.TextOut(lf, tp, s);

            BitmapToIcon(bmp, Icon, clBlue);
            // img.canvas.CopyRect(img.Canvas.ClipRect,bmp.Canvas,bmp.Canvas.ClipRect);
            // DrawIcon(img.Picture.Icon.Handle,0,0,bmp.Handle);
            // img.Picture.Icon.Assign(bmp);
            Application.Icon.Assign(Icon);
            InvalidateRect(Application.Handle, nil, True);
            s := 'Модуль управления устройствами ' + s;
            fmMain.UpdateTrayIcon(Icon, s);
        finally
            bmp.Free;
        end;
    finally
        Icon.Free;
    end;


    // img.Picture.Icon.;
    // Application.Icon.Assign(img.Picture.Icon);

    // inc(IconIndex);
    // case IconIndex of
    // 1 : Application.Icon.Assign(Image1.Picture.Icon);
    // 2 : Application.Icon.Assign(Image2.Picture.Icon);
    // else IconIndex := 0;
    // end;

end;

end.
