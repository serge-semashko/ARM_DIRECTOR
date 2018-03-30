unit UPageSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Printers, StdCtrls, Buttons, ExtCtrls, ComCtrls, TabNotBk, Math,
  WinSpool,
  Spin, IniFiles;

type

  TOffset = record
    X, Y: integer;
  end;

  TPageParameters = Class(TObject)
  private
    FPrinterExists: Boolean;
  protected
    procedure SetPrinterExists(Value: Boolean);
  public
    pOrientation: TPrinterOrientation; // ориентациия страницы
    FormatPage: string; // формат листа
    // FormatPrinter   : string;               // формат листа поддерживаемый принтером
    XScrInMM: Real; // количество пиксилей в мм для экрана по горизонтали
    YScrInMM: Real; // количество пиксилей в мм для экрана по вертикали
    XPixInMM: Real; // количество пиксилей в мм для принтера по горизонтали
    YPixInMM: Real; // количество пиксилей в мм для принтера по вертикали
    Width: Real; // ширина страницы в мм.
    Height: Real; // высода страницы в мм.
    SpaceLeft: Real; // левый отступ в мм.
    SpaceTop: Real; // верхний отступ в мм.
    SpaceRight: Real; // правый отступ в мм.
    SpaceBottom: Real; // нижней отступ в мм.
    HeadLineTop: Real; // верхний колонтитул в мм.
    HLTopText: String; // значение верхнего колонтитула
    Heading: Real; // размер по высоте заголовка в мм.
    WWorkingArea: Real; // размер по ширине рабочей области в мм.
    HWorkingArea: Real; // размер по высоте рабочей области в мм.
    Footer: Real; // размер по высоте нижней сноски в мм.
    HeadLineBottom: Real; // растояние до нижней границы колонтитула в мм.
    HLBottomText: String; // значение нижнего колонтитула;
    PixOffsetH: Real; // отступ по горизонтали в пикселях
    PixOffsetY: Real; // отступ по вертикали в пикселях
    ScaleX: Real; // Коэфициент по X
    ScaleY: Real; // Коэфициент по Y
    PixPrinterOffset: TOffset; // отступы от границ листа на принтере в пикселях
    PageDirect: Boolean;
    // Направление просмотра страниц Истина сверху-вниз Ложь слева-направо
    PrintFixCols: Boolean; // Печать фиксированные столбцы на всех листах
    PrintFixRows: Boolean; // Печатать фиксированные строки на всех листах
    PrintReportName: Boolean; // Печатать заголовок отчета на каждой странице
    Constructor Create;
    destructor Destroy; override;
    procedure Refresh;
    // function        PageParamToStr : string;
    // procedure       StrToPageParam(str : string);
    // procedure       SaveToFile(FileName : string);
    // procedure       LoadFromFile(FileName : string);
    // procedure       WriteToIniFile(FileName, Section, Ident  : string);
    // procedure       ReadFromIniFile(FileName, Section, Ident  : string);
    property PrinterExists: Boolean read FPrinterExists write SetPrinterExists
      default false;

  end;

  TFPage = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    sbBitBtn1: TSpeedButton;
    sbBitBtn2: TSpeedButton;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Image3: TImage;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    SpinButton1: TSpinButton;
    SpinButton2: TSpinButton;
    SpinButton3: TSpinButton;
    SpinButton4: TSpinButton;
    SpinButton5: TSpinButton;
    SpinButton6: TSpinButton;
    GroupBox4: TGroupBox;
    ComboBox2: TComboBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Panel5: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label9: TLabel;
    Bevel1: TBevel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Image5: TImage;
    Image4: TImage;
    Panel6: TPanel;
    Label11: TLabel;
    Label10: TLabel;
    Image7: TImage;
    Image6: TImage;
    Bevel3: TBevel;
    Bevel2: TBevel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel7: TPanel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure SpinButton2DownClick(Sender: TObject);
    procedure SpinButton2UpClick(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure SpinButton3DownClick(Sender: TObject);
    procedure SpinButton3UpClick(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure SpinButton6DownClick(Sender: TObject);
    procedure SpinButton6UpClick(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure SpinButton5DownClick(Sender: TObject);
    procedure SpinButton5UpClick(Sender: TObject);
    procedure SpinButton4DownClick(Sender: TObject);
    procedure SpinButton4UpClick(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure sbBitBtn2Click(Sender: TObject);
    procedure sbBitBtn1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPage: TFPage;
  PrintPageParameters: TPageParameters;
  lstsz: tstrings;
  OffsetHorz, OffSetVert: Real;

function PageSetup(pgstp: TPageParameters): Boolean;
Procedure SetPaperFormat(Name: string);
function CurrentPaperFormat: string;

implementation

uses umain, ucommon, uinitforms, umyprint;

{$R *.dfm}

destructor TPageParameters.Destroy;
begin
  freemem(@pOrientation);
  freemem(@FormatPage);
  freemem(@XScrInMM);
  freemem(@YScrInMM);
  freemem(@XPixInMM);
  freemem(@YPixInMM);
  freemem(@Width);
  freemem(@Height);
  freemem(@SpaceLeft);
  freemem(@SpaceTop);
  freemem(@SpaceRight);
  freemem(@SpaceBottom);
  freemem(@HeadLineTop);
  freemem(@HLTopText);
  freemem(@Heading);
  freemem(@WWorkingArea);
  freemem(@HWorkingArea);
  freemem(@Footer);
  freemem(@HeadLineBottom);
  freemem(@HLBottomText);
  freemem(@PixOffsetH);
  freemem(@PixOffsetY);
  freemem(@ScaleX);
  freemem(@ScaleY);
  freemem(@PixPrinterOffset);
  freemem(@PageDirect);
  freemem(@PrintFixCols);
  freemem(@PrintFixRows);
  freemem(@PrintReportName);
  inherited Destroy;
end;

function ValueFromEdit(st: string): Real;
var
  s, ss: string;
begin
  s := trim(st);
  if s = '' then
  begin
    result := 0;
    exit;
  end;
  ss := copy(s, length(s) - 2, 4);
  if (trim(ss) = 'см.') or (trim(ss) = 'cм.') or (trim(ss) = 'cm.') or
    (trim(ss) = 'сm.') then
    s := copy(s, 1, length(s) - 3);
  result := strtofloat(s);
end;

function EditToMM(st: string): integer;
var
  s, ss: string;
  rr: Real;
begin
  s := trim(st);
  if s = '' then
  begin
    result := 0;
    exit;
  end;
  ss := copy(s, length(s) - 2, 4);
  if (trim(ss) = 'см.') or (trim(ss) = 'cм.') or (trim(ss) = 'cm.') or
    (trim(ss) = 'сm.') then
    s := copy(s, 1, length(s) - 3);
  rr := strtofloat(s);
  result := trunc(rr * 10);
end;

Procedure SetDirectImage;
Begin
  if FPage.RadioButton3.Checked then
  begin
    FPage.Image4.Visible := true;
    FPage.Image5.Visible := false;
  end
  else
  begin
    FPage.Image5.Visible := true;
    FPage.Image4.Visible := false;
  end;
end;

procedure DrawListImage;
var
  wdt, hgt, sptp, spbt, splf, sprt, vrcl, ngcl: integer;
  i, imwdt, imhgt, zn: integer;
  kfx, kfy: Real;
  znx, znw, dlx, zny, znh, dly: integer;
begin
  FPage.Image3.Picture.Bitmap := nil;
  wdt := EditToMM(FPage.Edit1.Text);
  hgt := EditToMM(FPage.Edit2.Text);
  if (wdt = 0) or (hgt = 0) then
    exit;
  sptp := EditToMM(FPage.Edit3.Text);
  spbt := EditToMM(FPage.Edit7.Text);
  splf := EditToMM(FPage.Edit6.Text);
  sprt := EditToMM(FPage.Edit5.Text);
  vrcl := EditToMM(FPage.Edit4.Text);
  ngcl := EditToMM(FPage.Edit8.Text);
  if wdt >= hgt then
  begin
    // FPage.Panel1.Left:=93;
    // FPage.Panel1.Top:=70;
    FPage.Panel1.Width := 150;
    // Panel1.Left := GroupBox1.Left + (GroupBox1.Width - Panel1.Width) div 2;
    FPage.Panel1.Height := 112;
    // Panel1.Top := GroupBox1.Top + (GroupBox1.Height - Panel1.Height) div 2;
  end
  else
  begin
    // FPage.Panel1.Left:=113;
    // FPage.Panel1.Top:=56;
    FPage.Panel1.Width := 112;
    FPage.Panel1.Height := 142;
  end;
  FPage.Panel1.Left := (FPage.GroupBox1.Width - FPage.Panel1.Width) div 2;
  FPage.Panel1.Top := (FPage.GroupBox1.Height - FPage.Panel1.Height) div 2;
  FPage.Panel2.Left := FPage.Panel1.Left - 3;
  FPage.Panel2.Top := FPage.Panel1.Top - 3;
  FPage.Panel2.Width := FPage.Panel1.Width;
  FPage.Panel2.Height := FPage.Panel1.Height;
  FPage.Image3.Picture.Bitmap.Width := FPage.Panel2.Width - 4;
  FPage.Image3.Picture.Bitmap.Height := FPage.Panel2.Height - 4;
  imwdt := FPage.Image3.Picture.Bitmap.Width - 1;
  imhgt := FPage.Image3.Picture.Bitmap.Height - 1;
  kfx := imwdt / wdt;
  kfy := imhgt / hgt;
  FPage.Image3.Canvas.Pen.Style := psDot;
  FPage.Image3.Canvas.Pen.Color := clOlive;
  FPage.Image3.Canvas.Pen.Width := 1;
  zn := trunc(splf * kfx);
  FPage.Image3.Canvas.MoveTo(zn, 0);
  FPage.Image3.Canvas.LineTo(zn, imhgt);
  zn := trunc(sprt * kfx);
  FPage.Image3.Canvas.MoveTo(imwdt - zn, 0);
  FPage.Image3.Canvas.LineTo(imwdt - zn, imhgt);
  zn := trunc(sptp * kfy);
  FPage.Image3.Canvas.MoveTo(0, zn);
  FPage.Image3.Canvas.LineTo(imwdt, zn);
  zn := trunc(vrcl * kfy);
  FPage.Image3.Canvas.MoveTo(0, zn);
  FPage.Image3.Canvas.LineTo(imwdt, zn);
  zn := trunc(spbt * kfy);
  FPage.Image3.Canvas.MoveTo(0, imhgt - zn);
  FPage.Image3.Canvas.LineTo(imwdt, imhgt - zn);
  zn := trunc(ngcl * kfy);
  FPage.Image3.Canvas.MoveTo(0, imhgt - zn);
  FPage.Image3.Canvas.LineTo(imwdt, imhgt - zn);
  znx := trunc(splf * kfx) + 2;
  dlx := trunc(30 * kfx);
  zny := trunc(sptp * kfy) + 2;
  dly := trunc(15 * kfy);
  zn := (imhgt - trunc(spbt * kfy) - zny - 2) div dly;
  if zn > 6 then
    zn := 6;
  znh := zny + zn * dly;

  FPage.Image3.Canvas.Pen.Style := psSolid;
  FPage.Image3.Canvas.Pen.Color := clSilver;
  znw := znx - dlx;
  for i := 0 to 5 do
  begin
    znw := znw + dlx;
    if znw > (imwdt - trunc(sprt * kfx) - 2) then
    begin
      znw := znw - dlx;
      continue;
    end;
    FPage.Image3.Canvas.MoveTo(znw, zny);
    FPage.Image3.Canvas.LineTo(znw, znh);
  end;
  for i := 0 to zn do
  begin
    FPage.Image3.Canvas.MoveTo(znx, zny + i * dly);
    FPage.Image3.Canvas.LineTo(znw, zny + i * dly);
  end;
end;

function StrToPoint(s: string): TPoint;
var
  s1, s2: string;
  ps: integer;
begin
  ps := pos('x', s);
  s1 := trim(copy(s, 1, ps - 1));
  s2 := trim(copy(s, ps + 1, length(s)));
  result.X := strtoint(s1);
  result.Y := strtoint(s2);
end;

procedure EditPlusFloat(edit: TEdit; dlt, lmt: Real);
var
  s, ss: string;
  rr: Real;
begin
  s := trim(edit.Text);
  ss := copy(s, length(s) - 2, 4);
  if (trim(ss) = 'см.') or (trim(ss) = 'cм.') or (trim(ss) = 'cm.') or
    (trim(ss) = 'сm.') then
    s := copy(s, 1, length(s) - 3);
  try
    rr := strtofloat(s);
    rr := rr + dlt;
    if rr > lmt then
      rr := lmt;
    edit.Text := floattostr(rr) + ' см.';
    // DrawListImage;
  except
    raise Exception.Create('Значение ' + edit.Text + ' указано неверно');
    FPage.ActiveControl := edit;
  end;
end;

procedure EditChange(edit: TEdit; llmt, hlmt: Real);
var
  s, ss: string;
  rr: Real;
begin
  s := trim(edit.Text);
  if trim(s) = '' then
  begin
    edit.Text := floattostr(RoundTo(llmt, -2)) + ' см.';
    exit;
  end;
  ss := copy(s, length(s) - 2, 4);
  if (trim(ss) = 'см.') or (trim(ss) = 'cм.') or (trim(ss) = 'cm.') or
    (trim(ss) = 'сm.') then
    s := copy(s, 1, length(s) - 3);
  try
    rr := strtofloat(s);
    if rr < llmt then
      edit.Text := floattostr(RoundTo(llmt, -2)) + ' см.'
    else if (rr > hlmt) and (hlmt > 0) then
      edit.Text := floattostr(RoundTo(hlmt, -1)) + ' см.'
    else
      edit.Text := floattostr(RoundTo(rr, -2)) + ' см.';
  except
    raise Exception.Create('Значение ' + edit.Text + ' указано неверно');
    FPage.ActiveControl := edit;
  end;
end;

procedure EditMinusFloat(edit: TEdit; dlt, lmt: Real);
var
  s, ss: string;
  rr: Real;
begin
  s := trim(edit.Text);
  ss := copy(s, length(s) - 2, 4);
  if (trim(ss) = 'см.') or (trim(ss) = 'cм.') or (trim(ss) = 'cm.') or
    (trim(ss) = 'сm.') then
    s := copy(s, 1, length(s) - 3);
  try
    rr := strtofloat(s);
    rr := rr - dlt;
    if rr < lmt then
      rr := lmt;
    edit.Text := floattostr(rr) + ' см.';
  except
    raise Exception.Create('Значение ' + edit.Text + ' указано неверно');
    FPage.ActiveControl := edit;
  end;
end;

function GetPaperFormats(pfmt, psz: tstrings; deffmt: string): string;
type
  TPaperName = Array [0 .. 63] of Char;
  TPaperNameArray = Array [1 .. 500] of TPaperName;
  PPaperNameArray = ^TPaperNameArray;
  TPaperSizeArray = Array [1 .. 500] of TPoint;
  PPaperSizeArray = ^TPaperSizeArray;
var
  Device, Driver, Port: Array [0 .. 255] of Char;
  hDevMode: THandle;
  pdmode: pdevmode;
  i, numPaperFormats, numPaperSize: integer;
  pPaperFormats: PPaperNameArray;
  pPaperSize: PPaperSizeArray;
  bl: Boolean;
  ss: string;
  PixelsX, PixelsY: integer;
begin
  bl := false;
  Printer.PrinterIndex := Printer.PrinterIndex;
  if Printer.PrinterIndex = -1 then
    Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevMode);

  PixelsX := GetDeviceCaps(Printer.Handle, LogPixelsX);
  PixelsY := GetDeviceCaps(Printer.Handle, LogPixelsY);
  ss := inttostr(PixelsX) + ' x ' + inttostr(PixelsY);
  numPaperFormats := WinSpool.DeviceCapabilities(Device, Port, DC_PAPERNAMES,
    Nil, Nil);
  numPaperSize := WinSpool.DeviceCapabilities(Device, Port, DC_PAPERSIZE,
    Nil, Nil);
  if numPaperFormats > 0 then
  begin
    GetMem(pPaperFormats, numPaperFormats * Sizeof(TPaperName));
    try
      GetMem(pPaperSize, numPaperSize * Sizeof(TPoint));
      try
        WinSpool.DeviceCapabilities(Device, Port, DC_PAPERNAMES,
          Pchar(pPaperFormats), Nil);
        WinSpool.DeviceCapabilities(Device, Port, DC_PAPERSIZE,
          Pchar(pPaperSize), Nil);
        pfmt.clear;
        psz.clear;
        for i := 1 to numPaperFormats do
        begin
          ss := pPaperFormats^[i];
          if ss = deffmt then
            bl := true;
          pfmt.add(pPaperFormats^[i]);
          psz.add(inttostr(pPaperSize^[i].X) + ' x ' +
            inttostr(pPaperSize^[i].Y));
        end;
      finally
        freemem(pPaperSize);
      end;
    finally
      freemem(pPaperFormats);
    end;
  end;
  if not bl then
  begin
    pdmode := GlobalLock(hDevMode);
    result := pdmode^.dmFormName;
    GlobalUnlock(hDevMode);
  end
  else
    result := deffmt;
  Printer.PrinterIndex := Printer.PrinterIndex;
end;

function GetPaperBins(sl: tstrings): smallint;
type
  TBinName = array [0 .. 23] of Char;
  TBinNameArray = array [1 .. High(integer) div Sizeof(TBinName)] of TBinName;
  PBinnameArray = ^TBinNameArray;
  TBinArray = array [1 .. High(integer) div Sizeof(Word)] of Word;
  PBinArray = ^TBinArray;
var
  Device, Driver, Port: array [0 .. 255] of Char;
  hDevMode: THandle;
  pdmode: pdevmode;
  i, numBinNames, numBins, temp: integer;
  pBinNames: PBinnameArray;
  pBins: PBinArray;
begin
  Printer.PrinterIndex := Printer.PrinterIndex;
  if Printer.PrinterIndex = -1 then
    Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevMode);
  numBinNames := WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES,
    nil, nil);
  numBins := WinSpool.DeviceCapabilities(Device, Port, DC_BINS, nil, nil);
  if numBins <> numBinNames then
  begin
    raise Exception.Create
      ('DeviceCapabilities reports different number of bins and bin names!');
  end;
  if numBinNames > 0 then
  begin
    pBins := nil;
    GetMem(pBinNames, numBinNames * Sizeof(TBinName));
    GetMem(pBins, numBins * Sizeof(Word));
    try
      WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES,
        Pchar(pBinNames), nil);
      WinSpool.DeviceCapabilities(Device, Port, DC_BINS, Pchar(pBins), nil);
      sl.clear;
      for i := 1 to numBinNames do
      begin
        temp := pBins^[i];
        sl.addObject(pBinNames^[i], TObject(temp));
      end;
    finally
      freemem(pBinNames);
      if pBins <> nil then
        freemem(pBins);
    end;
  end;
  pdmode := GlobalLock(hDevMode);
  result := pdmode^.dmDefaultSource;
  GlobalUnlock(hDevMode);
  Printer.PrinterIndex := Printer.PrinterIndex;
end;

Procedure DrawMaket;
var
  pnt: TPoint;
  i: integer;
  s: string;
begin
  i := FPage.ComboBox1.Items.IndexOf(FPage.ComboBox1.Text);
  if (i < 0) and (lstsz.count > 0) then
    i := 0;
  pnt := StrToPoint(lstsz.Strings[i]);
  if FPage.RadioButton1.Checked then
  begin
    FPage.Edit1.Text := floattostr(RoundTo(pnt.X / 100, -2)) + ' см.';
    FPage.Edit2.Text := floattostr(RoundTo(pnt.Y / 100, -2)) + ' см.';
  end
  else
  begin
    FPage.Edit1.Text := floattostr(RoundTo(pnt.Y / 100, -2)) + ' см.';
    FPage.Edit2.Text := floattostr(RoundTo(pnt.X / 100, -2)) + ' см.';
  end;
  DrawListImage;
end;

procedure TPageParameters.SetPrinterExists(Value: Boolean);
begin
  if Printer.PrinterIndex = -1 then
    FPrinterExists := false
  else
    FPrinterExists := true;
end;

Procedure TPageParameters.Refresh;
Var
  PixPageWidth, PixPageHeight: integer;
  PixX, PixY, ScrX, ScrY: integer;
  scrhdc: THandle;
begin
  try
    Printer.PrinterIndex := Printer.PrinterIndex;
    if Printer.PrinterIndex = -1 then
      Printer.PrinterIndex := -1;
    PixX := GetDeviceCaps(Printer.Handle, LogPixelsX);
    PixY := GetDeviceCaps(Printer.Handle, LogPixelsY);
    scrhdc := GetDC(0);

    ScrX := GetDeviceCaps(scrhdc, LogPixelsX);
    ScrY := GetDeviceCaps(scrhdc, LogPixelsY);

    ScaleX := PixX / ScrX;
    ScaleY := PixY / ScrY;

    XScrInMM := ScrX / 25.4;
    YScrInMM := ScrY / 25.4;

    XPixInMM := PixX / 25.4;
    YPixInMM := PixY / 25.4;

    SetPaperFormat(FormatPage);
    FormatPage := CurrentPaperFormat;
    Printer.Orientation := pOrientation;

{$IFDEF WIN32}
    PixPageWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
    PixPageHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
    PixPrinterOffset.X := trunc(GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX));
    PixPrinterOffset.Y := trunc(GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY));
{$ELSE}
    retval := Escape(Printer.Handel, GETPRINTINGOFFSET, 0, nil,
      @PixPrinterOffset);
    PixPageWidth := Printer.PageWidth;
    PixPageHeight := Printer.PageHeight;
{$ENDIF}
    Width := PixPageWidth / XPixInMM;
    Height := PixPageHeight / YPixInMM;
    PixOffsetH := PixPrinterOffset.X / XPixInMM;
    PixOffsetY := PixPrinterOffset.Y / YPixInMM;
    HWorkingArea := Height - SpaceTop - SpaceBottom;
    WWorkingArea := Width - SpaceLeft - SpaceRight;
    Printer.PrinterIndex := Printer.PrinterIndex;
  except
  end;
end;

Constructor TPageParameters.Create;
Var
  PixPageWidth, PixPageHeight: integer;
  PixX, PixY, ScrX, ScrY: integer;
  scrhdc: THandle;
begin
  try
    inherited;
    Printer.PrinterIndex := Printer.PrinterIndex;
    if Printer.PrinterIndex = -1 then
      Printer.PrinterIndex := -1;
    PixX := GetDeviceCaps(Printer.Handle, LogPixelsX);
    PixY := GetDeviceCaps(Printer.Handle, LogPixelsY);
    scrhdc := GetDC(0);

    ScrX := GetDeviceCaps(scrhdc, LogPixelsX);
    ScrY := GetDeviceCaps(scrhdc, LogPixelsY);

    ScaleX := PixX / ScrX;
    ScaleY := PixY / ScrY;

    XScrInMM := ScrX / 25.4;
    YScrInMM := ScrY / 25.4;

    XPixInMM := PixX / 25.4;
    YPixInMM := PixY / 25.4;

    pOrientation := Printer.Orientation;
    FormatPage := CurrentPaperFormat;
    SpaceLeft := PrintSpaceLeft;
    SpaceTop := PrintSpaceTop;
    SpaceRight := PrintSpaceRight;
    SpaceBottom := PrintSpaceBottom;
    HeadLineTop := PrintHeadLineTop;
    HLTopText := '';
    Heading := 15.0;
    Footer := 0;
    HeadLineBottom := PrintHeadLineBottom;
    HLBottomText := '';

    PrintFixCols := true;
    PrintFixRows := true;
    PrintReportName := true;
    PageDirect := false;

{$IFDEF WIN32}
    PixPageWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
    PixPageHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
    PixPrinterOffset.X := trunc(GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX));
    PixPrinterOffset.Y := trunc(GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY));
{$ELSE}
    retval := Escape(Printer.Handel, GETPRINTINGOFFSET, 0, nil,
      @PixPrinterOffset);
    PixPageWidth := Printer.PageWidth;
    PixPageHeight := Printer.PageHeight;
{$ENDIF}
    Width := PixPageWidth / XPixInMM;
    Height := PixPageHeight / YPixInMM;
    PixOffsetH := PixPrinterOffset.X / XPixInMM;
    PixOffsetY := PixPrinterOffset.Y / YPixInMM;
    HWorkingArea := Height - SpaceTop - SpaceBottom;
    WWorkingArea := Width - SpaceLeft - SpaceRight;
    Printer.PrinterIndex := Printer.PrinterIndex;
  except
  end;
end;

Procedure SetDefaultParam(fmt: string; ornt: TPrinterOrientation);
var
  currformat: string;
  defbin: smallint;
begin
  currformat := GetPaperFormats(FPage.ComboBox1.Items, lstsz, fmt);
  FPage.ComboBox1.ItemIndex := FPage.ComboBox1.Items.IndexOf(currformat);
  defbin := GetPaperBins(FPage.ComboBox2.Items);
  if (defbin >= 0) and (defbin <= FPage.ComboBox2.Items.count - 1) then
    FPage.ComboBox2.ItemIndex := defbin
  else
    FPage.ComboBox2.ItemIndex := 0;
  if ornt = poPortrait then
  begin
    FPage.RadioButton1.Checked := true;
  end
  else
  begin
    FPage.RadioButton2.Checked := true;
  end;
  DrawMaket;
end;

function PageSetup(pgstp: TPageParameters): Boolean;
begin
  result := false;
  lstsz := tstringlist.Create;
  lstsz.clear;
  PrintPageParameters := pgstp;
  OffsetHorz := RoundTo(pgstp.PixOffsetH / 10, -1);
  OffSetVert := RoundTo(pgstp.PixOffsetY / 10, -1);

  // fpage.Edit3.Text:=floattostr(roundto(pgstp.SpaceTop/10,-2)) + ' см.';
  // fpage.Edit4.Text:=floattostr(roundto(pgstp.HeadLineTop/10,-2)) + ' см.';
  // fpage.Edit5.Text:=floattostr(roundto(pgstp.SpaceRight/10,-2)) + ' см.';
  // fpage.Edit6.Text:=floattostr(roundto(pgstp.SpaceLeft/10,-2)) + ' см.';
  // fpage.Edit8.Text:=floattostr(roundto(pgstp.HeadLineBottom/10,-2)) + ' см.';
  // fpage.Edit7.Text:=floattostr(roundto(pgstp.SpaceBottom/10,-2)) + ' см.';

  FPage.Edit3.Text := floattostr(RoundTo(PrintSpaceTop / 10, -2)) + ' см.';
  FPage.Edit4.Text := floattostr(RoundTo(PrintHeadLineTop / 10, -2)) + ' см.';
  FPage.Edit5.Text := floattostr(RoundTo(PrintSpaceRight / 10, -2)) + ' см.';
  FPage.Edit6.Text := floattostr(RoundTo(PrintSpaceLeft / 10, -2)) + ' см.';
  FPage.Edit8.Text := floattostr(RoundTo(PrintHeadLineBottom / 10, -2))
    + ' см.';
  FPage.Edit7.Text := floattostr(RoundTo(PrintSpaceBottom / 10, -2)) + ' см.';

  FPage.CheckBox1.Checked := pgstp.PrintFixCols;
  FPage.CheckBox2.Checked := pgstp.PrintFixRows;
  FPage.CheckBox3.Checked := pgstp.PrintReportName;
  FPage.RadioButton4.Checked := pgstp.PageDirect;
  SetDefaultParam(pgstp.FormatPage, pgstp.pOrientation);
  SetDirectImage;

  FPage.ShowModal;
  if FPage.ModalResult = mrOk then
  begin
    pgstp.FormatPage := FPage.ComboBox1.Text;
    if FPage.RadioButton1.Checked then
      pgstp.pOrientation := poPortrait
    else
      pgstp.pOrientation := poLandscape;
    pgstp.Width := ValueFromEdit(FPage.Edit1.Text) * 10;
    pgstp.Height := ValueFromEdit(FPage.Edit2.Text) * 10;
    pgstp.SpaceTop := ValueFromEdit(FPage.Edit3.Text) * 10;
    pgstp.HeadLineTop := ValueFromEdit(FPage.Edit4.Text) * 10;
    pgstp.SpaceLeft := ValueFromEdit(FPage.Edit6.Text) * 10;
    pgstp.SpaceRight := ValueFromEdit(FPage.Edit5.Text) * 10;
    pgstp.SpaceBottom := ValueFromEdit(FPage.Edit7.Text) * 10;
    pgstp.HeadLineBottom := ValueFromEdit(FPage.Edit8.Text) * 10;

    PrintSpaceTop := ValueFromEdit(FPage.Edit3.Text) * 10;
    PrintHeadLineTop := ValueFromEdit(FPage.Edit4.Text) * 10;
    PrintSpaceLeft := ValueFromEdit(FPage.Edit6.Text) * 10;
    PrintSpaceRight := ValueFromEdit(FPage.Edit5.Text) * 10;
    PrintSpaceBottom := ValueFromEdit(FPage.Edit7.Text) * 10;
    PrintHeadLineBottom := ValueFromEdit(FPage.Edit8.Text) * 10;

    pgstp.PrintFixCols := FPage.CheckBox1.Checked;
    pgstp.PrintFixRows := FPage.CheckBox2.Checked;
    pgstp.PrintReportName := FPage.CheckBox3.Checked;
    pgstp.PageDirect := FPage.RadioButton4.Checked;
    pgstp.HLTopText := PrintPageParameters.HLTopText;
    pgstp.HLBottomText := PrintPageParameters.HLBottomText;
    pgstp.Refresh;
    result := true;
  end;
end;

procedure SetPaperFormat(Name: string);
// Функция устанавливает формат листа
type
  TPaperName = Array [0 .. 63] of Char;
  TPaperNameArray = Array [1 .. 500] of TPaperName;
  PPaperNameArray = ^TPaperNameArray;
  TPgFormatsArray = Array [1 .. 500] of Word;
  PPgFormatsArray = ^TPgFormatsArray;
var
  Device, Driver, Port: Array [0 .. 255] of Char;
  hDevMode: THandle;
  pdmode: pdevmode;
  i, j, numPaperFormats: integer;
  pPaperFormats: PPaperNameArray;
  pPgFormats: PPgFormatsArray;
  fss: string;
begin
  Printer.PrinterIndex := Printer.PrinterIndex;
  if Printer.PrinterIndex = -1 then
    Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevMode);
  numPaperFormats := WinSpool.DeviceCapabilities(Device, Port, DC_PAPERNAMES,
    Nil, Nil);
  if numPaperFormats > 0 then
  begin
    GetMem(pPaperFormats, numPaperFormats * Sizeof(TPaperName));
    GetMem(pPgFormats, numPaperFormats * 2);
    try
      GetMem(pPgFormats, numPaperFormats * 2);
      try
        WinSpool.DeviceCapabilities(Device, Port, DC_PAPERNAMES,
          Pchar(pPaperFormats), Nil);
        WinSpool.DeviceCapabilities(Device, Port, DC_PAPERS,
          Pchar(pPgFormats), Nil);
        for i := 1 to numPaperFormats do
        begin
          if ansilowercase(trim(pPaperFormats^[i])) = ansilowercase(trim(Name))
          then
          begin
            pdmode := GlobalLock(hDevMode);
            pdmode^.dmPaperSize := pPgFormats^[i];
            fss := trim(Name);
            for j := 0 to length(fss) do
              pdmode^.dmFormName[j] := fss[j + 1];
            GlobalUnlock(hDevMode);
          end;
        end;
      finally
        freemem(pPgFormats);
      end;
    finally
      freemem(pPaperFormats);
    end;
  end;
  Printer.PrinterIndex := Printer.PrinterIndex;
end;

function CurrentPaperFormat: string;
var
  Device, Driver, Port: Array [0 .. 255] of Char;
  hDevMode: THandle;
  pdmode: pdevmode;
  s: string;
begin
  Printer.PrinterIndex := Printer.PrinterIndex;
  if Printer.PrinterIndex = -1 then
    Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevMode);
  pdmode := GlobalLock(hDevMode);
  s := pdmode^.dmFormName;
  result := pdmode^.dmFormName;
  GlobalUnlock(hDevMode);
  Printer.PrinterIndex := Printer.PrinterIndex;
end;

procedure TFPage.RadioButton1Click(Sender: TObject);
begin
  DrawMaket;
end;

procedure TFPage.RadioButton2Click(Sender: TObject);
begin
  DrawMaket;
end;

Procedure SetPanel(nom: integer);
begin
  case nom of
    1:
      begin
        FPage.Panel4.Visible := true;
        FPage.Panel5.Visible := false;
        FPage.Panel6.Visible := false;
        FPage.SpeedButton5.Font.Style := FPage.SpeedButton5.Font.Style +
          [fsBold, fsUnderline];
        FPage.SpeedButton6.Font.Style := FPage.SpeedButton6.Font.Style -
          [fsBold, fsUnderline];
        FPage.SpeedButton7.Font.Style := FPage.SpeedButton7.Font.Style -
          [fsBold, fsUnderline];
      end;
    2:
      begin
        FPage.Panel4.Visible := false;
        FPage.Panel5.Visible := false;
        FPage.Panel6.Visible := true;
        FPage.SpeedButton5.Font.Style := FPage.SpeedButton5.Font.Style -
          [fsBold, fsUnderline];
        FPage.SpeedButton6.Font.Style := FPage.SpeedButton6.Font.Style +
          [fsBold, fsUnderline];
        FPage.SpeedButton7.Font.Style := FPage.SpeedButton7.Font.Style -
          [fsBold, fsUnderline];
      end;
    3:
      begin
        FPage.Panel4.Visible := false;
        FPage.Panel5.Visible := true;
        FPage.Panel6.Visible := false;
        FPage.SpeedButton5.Font.Style := FPage.SpeedButton5.Font.Style -
          [fsBold, fsUnderline];
        FPage.SpeedButton6.Font.Style := FPage.SpeedButton6.Font.Style -
          [fsBold, fsUnderline];
        FPage.SpeedButton7.Font.Style := FPage.SpeedButton7.Font.Style +
          [fsBold, fsUnderline];
      end;
  end;
end;

procedure TFPage.FormCreate(Sender: TObject);
begin
  InitFPageSetup;
  SetPanel(1);
  Image6.Canvas.Brush.Style := bsSolid;
  Image6.Canvas.Brush.Color := clWhite;
  Image6.Canvas.FillRect(Image1.ClientRect);
  Image7.Canvas.Brush.Style := bsSolid;
  Image7.Canvas.Brush.Color := clWhite;
  Image7.Canvas.FillRect(Image1.ClientRect);
  Image4.Left := Image5.Left;
  Image4.Top := Image5.Top;
  Panel1.Left := GroupBox1.Left + (GroupBox1.Width - Panel1.Width) div 2;
  Panel1.Top := GroupBox1.Top + (GroupBox1.Height - Panel1.Height) div 2;
  // Panel2.Left := GroupBox1.Left + (GroupBox1.Width - Panel2.Width) div 2;
  // Panel2.Top := GroupBox1.Top + (GroupBox1.Height - Panel2.Height) div 2;
  // Fpage.TabbedNotebook1.PageIndex:=0;
end;

procedure TFPage.ComboBox1Change(Sender: TObject);
begin
  DrawMaket;
end;

procedure TFPage.SpinButton1DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit3, 0.1, ValueFromEdit(Edit4.Text));
end;

procedure TFPage.SpinButton1UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit3, 0.1, ValueFromEdit(Edit2.Text) -
    ValueFromEdit(Edit7.Text));
end;

procedure TFPage.Edit3Change(Sender: TObject);
begin
  EditChange(Edit3, ValueFromEdit(Edit4.Text), ValueFromEdit(Edit2.Text) -
    ValueFromEdit(Edit7.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton2DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit4, 0.1, OffSetVert);
end;

procedure TFPage.SpinButton2UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit4, 0.1, ValueFromEdit(Edit3.Text));
end;

procedure TFPage.Edit4Change(Sender: TObject);
begin
  EditChange(Edit4, OffSetVert, ValueFromEdit(Edit3.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton3DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit5, 0.1, OffsetHorz);
end;

procedure TFPage.SpinButton3UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit5, 0.1, ValueFromEdit(Edit1.Text) -
    ValueFromEdit(Edit6.Text));
end;

procedure TFPage.Edit5Change(Sender: TObject);
begin
  EditChange(Edit5, OffsetHorz, ValueFromEdit(Edit1.Text) -
    ValueFromEdit(Edit6.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton6DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit6, 0.1, OffsetHorz);
end;

procedure TFPage.SpinButton6UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit6, 0.1, ValueFromEdit(Edit1.Text) -
    ValueFromEdit(Edit5.Text));
end;

procedure TFPage.Edit6Change(Sender: TObject);
begin
  EditChange(Edit6, OffsetHorz, ValueFromEdit(Edit1.Text) -
    ValueFromEdit(Edit5.Text));
  DrawListImage;
end;

procedure TFPage.Edit7Change(Sender: TObject);
begin
  EditChange(Edit7, ValueFromEdit(Edit8.Text), ValueFromEdit(Edit2.Text) -
    ValueFromEdit(Edit3.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton5DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit7, 0.1, ValueFromEdit(Edit8.Text));
end;

procedure TFPage.SpinButton5UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit7, 0.1, ValueFromEdit(Edit2.Text) -
    ValueFromEdit(Edit3.Text));
end;

procedure TFPage.SpinButton4DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit8, 0.1, OffSetVert);
end;

procedure TFPage.SpinButton4UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit8, 0.1, ValueFromEdit(Edit7.Text));
end;

procedure TFPage.Edit8Change(Sender: TObject);
begin
  EditChange(Edit8, OffSetVert, ValueFromEdit(Edit7.Text));
  DrawListImage;
end;

procedure TFPage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  lstsz.Free;
end;

procedure TFPage.SpeedButton1Click(Sender: TObject);
begin
  OffsetHorz := RoundTo(PrintPageParameters.PixOffsetH / 10, -1);
  OffSetVert := RoundTo(PrintPageParameters.PixOffsetY / 10, -1);
  FPage.Edit3.Text := floattostr(RoundTo(PrintPageParameters.SpaceTop / 10, -2)
    ) + ' см.';
  FPage.Edit4.Text := floattostr(RoundTo(PrintPageParameters.HeadLineTop / 10,
    -2)) + ' см.';
  FPage.Edit5.Text := floattostr(RoundTo(PrintPageParameters.SpaceRight / 10,
    -2)) + ' см.';
  FPage.Edit6.Text := floattostr(RoundTo(PrintPageParameters.SpaceLeft / 10, -2)
    ) + ' см.';
  FPage.Edit8.Text := floattostr(RoundTo(PrintPageParameters.HeadLineBottom /
    10, -2)) + ' см.';
  FPage.Edit7.Text := floattostr(RoundTo(PrintPageParameters.SpaceBottom / 10,
    -2)) + ' см.';
  SetDefaultParam(PrintPageParameters.FormatPage,
    PrintPageParameters.pOrientation);
end;

procedure TFPage.SpeedButton2Click(Sender: TObject);
var
  ornt: TPrinterOrientation;
  predfmt: string;
begin
  predfmt := ComboBox1.Text;
  if selectprinter then
  begin
    Printer.PrinterIndex := Printer.PrinterIndex;
    if RadioButton1.Checked then
      ornt := poPortrait
    else
      ornt := poLandscape;
    SetDefaultParam(ComboBox1.Text, ornt);
    if ComboBox1.Text <> predfmt then
      MessageDlg('Принтер ' + Printer.Printers.Strings[Printer.PrinterIndex] +
        #10'не поддерживает формат листа - "' + predfmt + '".' +
        #10'Установлен формат листа - "' + ComboBox1.Text + '".', mtInformation,
        [mbOk], 0);
    PrintPageParameters.Refresh;
    OffsetHorz := RoundTo(PrintPageParameters.PixOffsetH / 10, -1);
    OffSetVert := RoundTo(PrintPageParameters.PixOffsetY / 10, -1);
    EditChange(Edit4, OffSetVert, ValueFromEdit(Edit3.Text));
    EditChange(Edit8, OffSetVert, ValueFromEdit(Edit7.Text));
    EditChange(Edit5, OffsetHorz, ValueFromEdit(Edit1.Text) -
      ValueFromEdit(Edit6.Text));
    EditChange(Edit6, OffsetHorz, ValueFromEdit(Edit1.Text) -
      ValueFromEdit(Edit5.Text));
    EditChange(Edit3, ValueFromEdit(Edit4.Text), ValueFromEdit(Edit2.Text) -
      ValueFromEdit(Edit7.Text));
    EditChange(Edit7, ValueFromEdit(Edit8.Text), ValueFromEdit(Edit2.Text) -
      ValueFromEdit(Edit3.Text));
  end;
end;

procedure TFPage.SpeedButton4Click(Sender: TObject);
begin
  // FHeadLine.Caption:='Нижний колонтитул';
  // PrintPageParameters.HLBottomText:=CreateHeadLine(PrintPageParameters.HLBottomText);
  // DrawHeadLine(Image7,ValueFromEdit(Edit7.Text)-ValueFromEdit(Edit8.Text),PrintPageParameters.HLBottomText);
end;

procedure TFPage.RadioButton3Click(Sender: TObject);
begin
  SetDirectImage;
end;

procedure TFPage.RadioButton4Click(Sender: TObject);
begin
  SetDirectImage;
end;

procedure TFPage.sbBitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFPage.sbBitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFPage.SpeedButton5Click(Sender: TObject);
begin
  SetPanel(1);
end;

procedure TFPage.SpeedButton6Click(Sender: TObject);
begin
  SetPanel(2);
end;

procedure TFPage.SpeedButton7Click(Sender: TObject);
begin
  SetPanel(3);
end;

initialization

PrintPageParameters := TPageParameters.Create;

finalization

PrintPageParameters.FreeInstance;
PrintPageParameters := nil;

end.
