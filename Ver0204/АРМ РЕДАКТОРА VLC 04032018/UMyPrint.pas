unit UMyPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, MyData, Buttons, Grids, JPEG, StdCtrls,
  Spin, printers, umytexttable;

type
  PPalEntriesArray = ^TPalEntriesArray; { for palette re-construction }
  TPalEntriesArray = array [0 .. 0] of TPaletteEntry;

  TfrMyPrint = class(TForm)
    Panel2: TPanel;
    Panel5: TPanel;
    OpenDialog1: TOpenDialog;
    Image3: TImage;
    SpeedButton2: TSpeedButton;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    cbTexts: TComboBox;
    cbDevices: TComboBox;
    cbTypePrint: TComboBox;
    cbDataPrint: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    Panel4: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel2: TBevel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cbDevicesChange(Sender: TObject);
    procedure cbTypePrintChange(Sender: TObject);
    procedure cbDataPrintChange(Sender: TObject);
    procedure cbTextsChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frMyPrint: TfrMyPrint;
  LPX, LPY: integer;
  CountPages: integer = 0;

function SelectPrinter: boolean;
Procedure PrintTimelines;

implementation

uses upagesetup, umain, ucommon, uinitforms, utimeline, ugrtimelines, umyevents,
  upagedraw;

{$R *.dfm}

function findpostimeline(ps: integer; typetl: TTypeTimeline): integer;
var
  i, tl: integer;
begin
  result := -1;
  tl := 0;
  for i := 0 to TLZone.Count - 1 do
  begin
    if TLZone.Timelines[i].typetl = typetl then
    begin
      if tl = ps then
      begin
        result := i;
        exit;
      end;
      tl := tl + 1;
    end;
  end;
end;

function DrawPageMaketTitle(cv: tcanvas; tp: integer): integer;
var
  wdth, hght, hght1, CurW, CurH: integer;
  txt: string;
begin
  cv.Brush.Color := clWhite;
  cv.Brush.Style := bsSolid;
  cv.FillRect(cv.ClipRect);
  cv.Pen.Width := 2;
  cv.Pen.Color := clBlack;

  cv.Font.Size := Form1.Font.Size + 4;
  CurW := MaketOptions.Left;
  CurH := MaketOptions.Top;
  txt := '[' + pntlprep.GetText('Nom') + ']';
  wdth := cv.TextWidth(txt);
  hght := cv.TextHeight(txt);
  cv.TextOut(CurW, CurH, txt);
  cv.TextOut(CurW + wdth + 5 * MaketOptions.mmHorz, CurH,
    pntlprep.GetText('ClipName'));

  cv.Font.Size := Form1.Font.Size + 6;
  wdth := cv.TextWidth(frMyPrint.cbTypePrint.Items[tp]);
  cv.TextOut(MaketOptions.Right - wdth, CurH, frMyPrint.cbTypePrint.Items[tp]);

  cv.Font.Size := 12; // Form1.lbSongName.Font.Size;
  // cv.Refresh;
  CurH := CurH + hght + 3 * MaketOptions.mmVert;
  hght := cv.TextHeight(pntlprep.GetText('SongName'));
  cv.TextOut(CurW, CurH, pntlprep.GetText('SongName'));

  cv.Font.Size := Form1.Font.Size;
  CurH := CurH + hght + 3 * MaketOptions.mmVert;
  hght := cv.TextHeight(pntlprep.GetText('SingerName'));
  // Form1.lbClipSinger.Caption);
  cv.TextOut(CurW, CurH, pntlprep.GetText('SingerName'));

  result := CurH + hght;
end;

procedure DrawMaketTableTitle(cv: tcanvas; posy: integer);
var
  hght: integer;
begin
  cv.Font.Size := 8;
  hght := cv.TextHeight('0');
  hght := posy - hght;
  cv.TextOut(MaketOptions.Left, hght, PrintCol1);
  cv.TextOut(MaketOptions.X1, hght, PrintCol2);
  cv.TextOut(MaketOptions.X2, hght, PrintCol3);
  cv.TextOut(MaketOptions.X3, hght, PrintCol4);
  cv.TextOut(MaketOptions.X4, hght, PrintCol5);
  if frMyPrint.cbDataPrint.ItemIndex = 0 then
    cv.TextOut(MaketOptions.X5, hght, PrintCol61)
  else
    cv.TextOut(MaketOptions.X5, hght, PrintCol62);
end;

function DrawMaketTableRow(cv: tcanvas;
  pstl, psev, Top, Bottom: integer): integer;
var
  Rect: trect;
  i, CurH, hght, hght1: integer;
  flag, flag1: word;
  txt: string;
begin
  flag := DT_LEFT or DT_WORDBREAK or DT_TOP;
  flag1 := DT_TOP or DT_CENTER;
  cv.Font.Size := 12;
  Rect.Top := Top;
  Rect.Bottom := Bottom;
  // ==============================================================================
  txt := inttostr(psev + 1 + PrintEventShift);
  Rect.Left := MaketOptions.Left;
  Rect.Right := MaketOptions.X1;
  DrawText(cv.Handle, PChar(txt), length(txt), Rect, flag1);
  // ==============================================================================
  // txt := FramesToShortStr(TLZone.Timelines[pstl].Events[psev].Start - TLParameters.Preroll);
  txt := FramesToShortStr(PrintListEvents.Rows[psev].Start);
  Rect.Left := MaketOptions.X1;
  Rect.Right := MaketOptions.X2;
  DrawText(cv.Handle, PChar(txt), length(txt), Rect, flag1);
  // ==============================================================================
  // txt := FramesToShortStr(TLZone.Timelines[pstl].Events[psev].Finish - TLZone.Timelines[pstl].Events[psev].Start);
  txt := FramesToShortStr(PrintListEvents.Rows[psev].Duration);
  Rect.Left := MaketOptions.X2;
  Rect.Right := MaketOptions.X3;
  DrawText(cv.Handle, PChar(txt), length(txt), Rect, flag1);
  // ==============================================================================
  // txt := TLZone.Timelines[pstl].Events[psev].ReadPhraseText('Device');
  txt := inttostr(PrintListEvents.Rows[psev].Device);
  Rect.Left := MaketOptions.X3;
  Rect.Right := MaketOptions.X4;
  DrawText(cv.Handle, PChar(txt), length(txt), Rect, flag1);
  // ==============================================================================
  // cv.Font.Size:=12;
  // ==============================================================================
  // txt := TLZone.Timelines[pstl].Events[psev].ReadPhraseText('Text');
  txt := PrintListEvents.Rows[psev].Text;
  Rect.Left := MaketOptions.X4;
  Rect.Right := MaketOptions.X5;
  hght := DrawText(cv.Handle, PChar(txt), length(txt), Rect, flag);
  // ==============================================================================
  // txt := TLZone.Timelines[pstl].Events[psev].ReadPhraseText('Comment');
  // txt := PrintListEvents.Rows[psev].Comment;
  if frMyPrint.cbDataPrint.ItemIndex = 0 then
    txt := PrintListEvents.Rows[psev].Comment
  else
    txt := PrintListEvents.Rows[psev].Lyrics;
  Rect.Left := MaketOptions.X5;
  Rect.Right := MaketOptions.Right;
  // Rect.Top := CurH;
  // Rect.Bottom := MaketOptions.LowBorder;
  hght1 := DrawText(cv.Handle, PChar(txt), length(txt), Rect, flag);
  // ==============================================================================
  if hght1 > hght then
    hght := hght1;
  if hght < MaketOptions.RowHeight then
    hght := MaketOptions.RowHeight;
  CurH := Rect.Top + hght + MaketOptions.mmVert;
  cv.MoveTo(MaketOptions.Left, Rect.Top);
  cv.LineTo(MaketOptions.Right, Rect.Top);
  cv.MoveTo(MaketOptions.Left, CurH);
  cv.LineTo(MaketOptions.Right, CurH);

  cv.Pen.Width := 1;
  cv.MoveTo(MaketOptions.Left, Rect.Top);
  cv.LineTo(MaketOptions.Left, CurH);
  cv.MoveTo(MaketOptions.X1, Rect.Top);
  cv.LineTo(MaketOptions.X1, CurH);
  cv.MoveTo(MaketOptions.X2, Rect.Top);
  cv.LineTo(MaketOptions.X2, CurH);
  cv.MoveTo(MaketOptions.X3, Rect.Top);
  cv.LineTo(MaketOptions.X3, CurH);
  cv.MoveTo(MaketOptions.X4, Rect.Top);
  cv.LineTo(MaketOptions.X4, CurH);
  cv.MoveTo(MaketOptions.X5, Rect.Top);
  cv.LineTo(MaketOptions.X5, CurH);
  cv.MoveTo(MaketOptions.Right, Rect.Top);
  cv.LineTo(MaketOptions.Right, CurH);
  result := CurH;
end;

procedure DrawMaketLowTitle(cv: tcanvas);
var
  flag: word;
  Rect: trect;
  txt: string;
begin
  cv.Font.Size := 10;
  flag := DT_RIGHT;
  Rect.Left := MaketOptions.Left;
  Rect.Right := MaketOptions.Right;
  Rect.Top := MaketOptions.Bottom - cv.TextHeight('0');
  Rect.Bottom := MaketOptions.Bottom;
  txt := DateToStr(now) + '  ' + TimeToStr(now);
  DrawText(cv.Handle, PChar(txt), length(txt), Rect, flag);
end;

procedure DrawPageMaket(tp: integer);
var
  bmp: tbitmap;
  Rect: trect;
  dvs, i, j, wdth, hght, hght1, CurW, CurH: integer;
  txt: string;
  flag, flag1: word;
begin
  bmp := tbitmap.Create;
  try
    frMyPrint.Panel3.Height :=
      trunc((PrintPageParameters.Height / PrintPageParameters.Width) *
      frMyPrint.Panel3.Width);
    frMyPrint.Panel3.Left :=
      (frMyPrint.Panel2.Width - frMyPrint.Panel3.Width) div 2;
    frMyPrint.Panel3.Top :=
      (frMyPrint.Panel2.Height - frMyPrint.Panel3.Height) div 2;
    frMyPrint.Panel1.Left := frMyPrint.Panel3.Left + 10;
    frMyPrint.Panel1.Width := frMyPrint.Panel3.Width;
    frMyPrint.Panel1.Top := frMyPrint.Panel3.Top + 10;
    frMyPrint.Panel1.Height := frMyPrint.Panel3.Height;
    frMyPrint.Image3.Picture.Bitmap.Width := frMyPrint.Image3.Width;
    frMyPrint.Image3.Picture.Bitmap.Height := frMyPrint.Image3.Height;

    MaketOptions.SetOptions(tmScreen, PrintPageParameters);
    bmp.Width := MaketOptions.Width; // * MaketOptions.mmHorz;
    bmp.Height := MaketOptions.Height; // * MaketOptions.mmVert;

    CurH := DrawPageMaketTitle(bmp.Canvas, tp) + 10 * MaketOptions.mmVert;

    DrawMaketTableTitle(bmp.Canvas, CurH);

    bmp.Canvas.Brush.Style := bsClear;

    for i := 0 to PrintListEvents.Count - 1 do
    begin
      case tp of
        1:
          CurH := DrawMaketTableRow(bmp.Canvas, 0, i, CurH,
            MaketOptions.Bottom);
        2 .. 34:
          begin
            dvs := tp - 1;
            if PrintListEvents.Rows[i].Device = dvs then
              CurH := DrawMaketTableRow(bmp.Canvas, 0, i, CurH,
                MaketOptions.Bottom);
          end;
      end;
      if CurH > MaketOptions.LowBorder - 1 then
        break;
    end;

    DrawMaketLowTitle(bmp.Canvas);

    stretchblt(frMyPrint.Image3.Canvas.Handle, frMyPrint.Image3.Left,
      frMyPrint.Image3.Top, frMyPrint.Image3.Width, frMyPrint.Image3.Height,
      bmp.Canvas.Handle, 0, 0, bmp.Width, bmp.Height, SRCCOPY);
  finally
    bmp.Free;
    bmp := nil;
  end;
end;

procedure CountPagesMaket(posi, tp: integer);
var
  bmp: tbitmap;
  Rect: trect;
  dvs, i, j, wdth, hght, hght1, CurW, CurH: integer;
  txt: string;
  flag, flag1: word;
begin
  bmp := tbitmap.Create;
  try
    frMyPrint.Panel3.Height :=
      trunc((PrintPageParameters.Height / PrintPageParameters.Width) *
      frMyPrint.Panel3.Width);
    frMyPrint.Panel3.Left :=
      (frMyPrint.Panel2.Width - frMyPrint.Panel3.Width) div 2;
    frMyPrint.Panel3.Top :=
      (frMyPrint.Panel2.Height - frMyPrint.Panel3.Height) div 2;
    frMyPrint.Panel1.Left := frMyPrint.Panel3.Left + 10;
    frMyPrint.Panel1.Width := frMyPrint.Panel3.Width;
    frMyPrint.Panel1.Top := frMyPrint.Panel3.Top + 10;
    frMyPrint.Panel1.Height := frMyPrint.Panel3.Height;
    frMyPrint.Image3.Picture.Bitmap.Width := frMyPrint.Image3.Width;
    frMyPrint.Image3.Picture.Bitmap.Height := frMyPrint.Image3.Height;

    MaketOptions.SetOptions(tmScreen, PrintPageParameters);
    bmp.Width := MaketOptions.Width; // * MaketOptions.mmHorz;
    bmp.Height := MaketOptions.Height; // * MaketOptions.mmVert;

    CurH := DrawPageMaketTitle(bmp.Canvas, tp) + 10 * MaketOptions.mmVert;
    DrawMaketTableTitle(bmp.Canvas, CurH);
    bmp.Canvas.Brush.Style := bsClear;

    for i := posi to PrintListEvents.Count - 1 do
    begin
      case tp of
        1:
          CurH := DrawMaketTableRow(bmp.Canvas, 0, i, CurH,
            MaketOptions.Bottom);
        2 .. 34:
          begin
            dvs := tp - 1;
            if PrintListEvents.Rows[i].Device = dvs then
              CurH := DrawMaketTableRow(bmp.Canvas, 0, i, CurH,
                MaketOptions.Bottom);
          end;
      end;
      if CurH > MaketOptions.LowBorder - 1 then
      begin
        DrawMaketLowTitle(bmp.Canvas);
        if i < PrintListEvents.Count - 1 then
        begin
          CountPages := CountPages + 1;
          CountPagesMaket(i + 1, tp);
          bmp.Free;
          bmp := nil;
          exit;
        end;
      end;
    end;
    DrawMaketLowTitle(bmp.Canvas);
    CountPages := CountPages + 1;
  finally
    bmp.Free;
    bmp := nil;
  end;
end;

procedure PrintMaketPages(posi, tp: integer);
var
  bmp: tbitmap;
  Rect: trect;
  dvs, i, wdth, hght, hght1, CurW, CurH: integer;
  txt: string;
  flag, flag1: word;
begin
  try
    // result := false;
    MaketOptions.SetOptions(tmPrinter, PrintPageParameters);
    CurH := DrawPageMaketTitle(Printer.Canvas, tp) + 10 * MaketOptions.mmVert;
    DrawMaketTableTitle(Printer.Canvas, CurH);
    Printer.Canvas.Brush.Style := bsClear;

    // for i:=posi to TLZone.Timelines[0].Count-1 do begin
    for i := posi to PrintListEvents.Count - 1 do
    begin
      case tp of
        1:
          CurH := DrawMaketTableRow(Printer.Canvas, 0, i, CurH,
            MaketOptions.Bottom);
        2 .. 34:
          begin
            dvs := tp - 1;
            if PrintListEvents.Rows[i].Device = dvs then
              CurH := DrawMaketTableRow(Printer.Canvas, 0, i, CurH,
                MaketOptions.Bottom);
          end;
      end;
      // CurH := DrawMaketTableRow(Printer.Canvas, 0, i, CurH, MaketOptions.Bottom);
      if CurH > MaketOptions.LowBorder - 1 then
      begin
        DrawMaketLowTitle(Printer.Canvas);
        if i < PrintListEvents.Count - 1 then
        begin
          Printer.NewPage;
          PrintMaketPages(i + 1, tp);
          exit;
        end;
      end;
    end;
    DrawMaketLowTitle(Printer.Canvas);
    // result := true;
  except
  end;
end;

function CountMaketPages(tld: integer): integer;
var
  i, tp, cnt: integer;
begin
  CountPages := 0;
  tp := frMyPrint.cbTypePrint.ItemIndex;
  if tp = 0 then
  begin
    cnt := (Form1.GridTimeLines.Objects[0, tld + 1]
      as TTimelineOptions).CountDev;
    for i := 0 to cnt - 1 do
    begin
      CountPagesMaket(0, i + 2);
    end;
  end
  else
    CountPagesMaket(0, tp);
  result := CountPages;
end;

Procedure PrintTimelines;
var
  i, rw, tp, cnt, tld, tlt: integer;
begin
  readlistvisiblewindows(frMyPrint.Handle);
  Form1.Timer2.Enabled := true;
  frMyPrint.cbDevices.Clear;
  frMyPrint.cbTexts.Clear;
  for i := 1 to Form1.GridTimeLines.RowCount - 1 do
  begin
    case (Form1.GridTimeLines.Objects[0, i] as TTimelineOptions).typetl of
      tldevice:
        frMyPrint.cbDevices.Items.Add
          ((Form1.GridTimeLines.Objects[0, i] as TTimelineOptions).Name);
      tltext:
        frMyPrint.cbTexts.Items.Add
          ((Form1.GridTimeLines.Objects[0, i] as TTimelineOptions).Name);
    end;
    frMyPrint.cbDevices.ItemIndex := 0;
    frMyPrint.cbTexts.ItemIndex := 0;
  end;
  PrintPageParameters.Refresh;

  tld := findpostimeline(frMyPrint.cbDevices.ItemIndex, tldevice);
  tlt := findpostimeline(frMyPrint.cbTexts.ItemIndex, tltext);

  frMyPrint.cbDevicesChange(nil);

  PrintListEvents.LoadData(tld, tlt, true);
  tp := frMyPrint.cbTypePrint.ItemIndex;
  if frMyPrint.cbDataPrint.ItemIndex = 0 then
    frMyPrint.cbTexts.Enabled := false
  else
    frMyPrint.cbTexts.Enabled := true;

  // CountPages := 0;
  // tp := frmyprint.cbTypePrint.ItemIndex;
  // if tp = 0 then begin
  // cnt := (Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).CountDev;
  // for i:=0 to cnt - 1 do begin
  // CountPagesMaket(0,i+2);
  // end;
  // end else CountPagesMaket(0, tp);

  frMyPrint.Label8.Caption := inttostr(CountMaketPages(tld));
  if tp = 0 then
    tp := 2;
  DrawPageMaket(tp);

  frMyPrint.ShowModal;
end;

procedure BltTBitmapAsDib(DestDc: hdc; { Handle of where to blt }
  x: word; { Bit at x }
  y: word; { Blt at y }
  Width: word; { Width to stretch }
  Height: word; { Height to stretch }
  bm: tbitmap); { the TBitmap to Blt }
var
  OriginalWidth: LongInt; { width of BM }
  dc: hdc; { screen dc }
  IsPaletteDevice: bool; { if the device uses palettes }
  IsDestPaletteDevice: bool; { if the device uses palettes }
  BitmapInfoSize: integer; { sizeof the bitmapinfoheader }
  lpBitmapInfo: PBitmapInfo; { the bitmap info header }
  hBm: hBitmap; { handle to the bitmap }
  hPal: hPalette; { handle to the palette }
  OldPal: hPalette; { temp palette }
  hBits: THandle; { handle to the DIB bits }
  pBits: pointer; { pointer to the DIB bits }
  lPPalEntriesArray: PPalEntriesArray; { palette entry array }
  NumPalEntries: integer; { number of palette entries }
  i: integer; { looping variable }
begin
  { If range checking is on - lets turn it off for now }
  { we will remember if range checking was on by defining }
  { a define called CKRANGE if range checking is on. }
  { We do this to access array members past the arrays }
  { defined index range without causing a range check }
  { error at runtime. To satisfy the compiler, we must }
  { also access the indexes with a variable. ie: if we }
  { have an array defined as a: array[0..0] of byte, }
  { and an integer i, we can now access a[3] by setting }
  { i := 3; and then accessing a[i] without error }
{$IFOPT R+}
{$DEFINE CKRANGE}
{$R-}
{$ENDIF}
  { Save the original width of the bitmap }
  OriginalWidth := bm.Width;

  { Get the screen's dc to use since memory dc's are not reliable }
  dc := GetDc(0);
  { Are we a palette device? }
  IsPaletteDevice := GetDeviceCaps(dc, RASTERCAPS) and RC_PALETTE = RC_PALETTE;
  { Give back the screen dc }
  dc := ReleaseDc(0, dc);

  { Allocate the BitmapInfo structure }
  if IsPaletteDevice then
    BitmapInfoSize := sizeof(TBitmapInfo) + (sizeof(TRGBQUAD) * 255)
  else
    BitmapInfoSize := sizeof(TBitmapInfo);
  GetMem(lpBitmapInfo, BitmapInfoSize);

  { Zero out the BitmapInfo structure }
  FillChar(lpBitmapInfo^, BitmapInfoSize, #0);

  { Fill in the BitmapInfo structure }
  lpBitmapInfo^.bmiHeader.biSize := sizeof(TBitmapInfoHeader);
  lpBitmapInfo^.bmiHeader.biWidth := OriginalWidth;
  lpBitmapInfo^.bmiHeader.biHeight := bm.Height;
  lpBitmapInfo^.bmiHeader.biPlanes := 1;
  if IsPaletteDevice then
    lpBitmapInfo^.bmiHeader.biBitCount := 8
  else
    lpBitmapInfo^.bmiHeader.biBitCount := 24;
  lpBitmapInfo^.bmiHeader.biCompression := BI_RGB;
  lpBitmapInfo^.bmiHeader.biSizeImage :=
    ((lpBitmapInfo^.bmiHeader.biWidth *
    LongInt(lpBitmapInfo^.bmiHeader.biBitCount)) div 8) *
    lpBitmapInfo^.bmiHeader.biHeight;
  lpBitmapInfo^.bmiHeader.biXPelsPerMeter := 0;
  lpBitmapInfo^.bmiHeader.biYPelsPerMeter := 0;
  if IsPaletteDevice then
  begin
    lpBitmapInfo^.bmiHeader.biClrUsed := 256;
    lpBitmapInfo^.bmiHeader.biClrImportant := 256;
  end
  else
  begin
    lpBitmapInfo^.bmiHeader.biClrUsed := 0;
    lpBitmapInfo^.bmiHeader.biClrImportant := 0;
  end;

  { Take ownership of the bitmap handle and palette }
  hBm := bm.ReleaseHandle;
  hPal := bm.ReleasePalette;

  { Get the screen's dc to use since memory dc's are not reliable }
  dc := GetDc(0);

  if IsPaletteDevice then
  begin
    { If we are using a palette, it must be }
    { selected into the dc during the conversion }
    OldPal := SelectPalette(dc, hPal, true);
    { Realize the palette }
    RealizePalette(dc);
  end;
  { Tell GetDiBits to fill in the rest of the bitmap info structure }
  GetDiBits(dc, hBm, 0, lpBitmapInfo^.bmiHeader.biHeight, nil,
    TBitmapInfo(lpBitmapInfo^), DIB_RGB_COLORS);

  { Allocate memory for the Bits }
  hBits := GlobalAlloc(GMEM_MOVEABLE, lpBitmapInfo^.bmiHeader.biSizeImage);
  pBits := GlobalLock(hBits);
  { Get the bits }
  GetDiBits(dc, hBm, 0, lpBitmapInfo^.bmiHeader.biHeight, pBits,
    TBitmapInfo(lpBitmapInfo^), DIB_RGB_COLORS);

  if IsPaletteDevice then
  begin
    { Lets fix up the color table for buggy video drivers }
    GetMem(lPPalEntriesArray, sizeof(TPaletteEntry) * 256);
{$IFDEF VER100}
    NumPalEntries := GetPaletteEntries(hPal, 0, 256, lPPalEntriesArray^);
{$ELSE}
    NumPalEntries := GetSystemPaletteEntries(dc, 0, 256, lPPalEntriesArray^);
{$ENDIF}
    for i := 0 to (NumPalEntries - 1) do
    begin
      lpBitmapInfo^.bmiColors[i].rgbRed := lPPalEntriesArray^[i].peRed;
      lpBitmapInfo^.bmiColors[i].rgbGreen := lPPalEntriesArray^[i].peGreen;
      lpBitmapInfo^.bmiColors[i].rgbBlue := lPPalEntriesArray^[i].peBlue;
    end;
    FreeMem(lPPalEntriesArray, sizeof(TPaletteEntry) * 256);
  end;

  if IsPaletteDevice then
  begin
    { Select the old palette back in }
    SelectPalette(dc, OldPal, true);
    { Realize the old palette }
    RealizePalette(dc);
  end;

  { Give back the screen dc }
  dc := ReleaseDc(0, dc);

  { Is the Dest dc a palette device? }
  IsDestPaletteDevice := GetDeviceCaps(DestDc, RASTERCAPS) and
    RC_PALETTE = RC_PALETTE;

  if IsPaletteDevice then
  begin
    { If we are using a palette, it must be }
    { selected into the dc during the conversion }
    OldPal := SelectPalette(DestDc, hPal, true);
    { Realize the palette }
    RealizePalette(DestDc);
  end;

  { Do the blt }
  StretchDiBits(DestDc, x, y, Width, Height, 0, 0, OriginalWidth,
    lpBitmapInfo^.bmiHeader.biHeight, pBits, lpBitmapInfo^,
    DIB_RGB_COLORS, SRCCOPY);

  if IsDestPaletteDevice then
  begin
    { Select the old palette back in }
    SelectPalette(DestDc, OldPal, true);
    { Realize the old palette }
    RealizePalette(DestDc);
  end;

  { De-Allocate the Dib Bits }
  GlobalUnLock(hBits);
  GlobalFree(hBits);

  { De-Allocate the BitmapInfo }
  FreeMem(lpBitmapInfo, BitmapInfoSize);

  { Set the ownership of the bimap handles back to the bitmap }
  bm.Handle := hBm;
  bm.Palette := hPal;

  { Turn range checking back on if it was on when we started }
{$IFDEF CKRANGE}
{$UNDEF CKRANGE}
{$R+}
{$ENDIF}
end;

function SelectPrinter: boolean;
var
  oldindex: integer;
begin
  result := false;
  with frMyPrint do
  begin
    ComboBox1.Items.Assign(Printer.printers);
    oldindex := Printer.PrinterIndex;
    ComboBox1.ItemIndex := Printer.PrinterIndex;
    Printer.PrinterIndex := ComboBox1.ItemIndex;
  end;
end;

procedure TfrMyPrint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  listvisiblewindows.Clear;
  Form1.Timer2.Enabled := false;
end;

procedure TfrMyPrint.FormCreate(Sender: TObject);
Var
  SRect: TGridRect;

begin
  InitfrMyPrint;
  ComboBox1.Items.Assign(Printer.printers);
  ComboBox1.ItemIndex := Printer.PrinterIndex;
  SRect.Left := -1;
  SRect.Top := -1;
  SRect.Right := -1;
  SRect.Bottom := -1;
  LPX := GetDeviceCaps(Printer.Handle, LogPixelsX);
  LPY := GetDeviceCaps(Printer.Handle, LogPixelsY);
end;

procedure TfrMyPrint.FormResize(Sender: TObject);
begin
  Image3.Picture.Bitmap.Width := Panel2.Width;
  Image3.Picture.Bitmap.Height := Panel2.Height;
end;

procedure TfrMyPrint.SpeedButton2Click(Sender: TObject);
var // tpgprm : tpageparameters;
  tp, tld: integer;
begin
  // tpgprm:=tpageparameters.Create;
  if PageSetup(PrintPageParameters) then
  begin
    Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
    tld := cbDevices.ItemIndex;
    frMyPrint.Label8.Caption := inttostr(CountMaketPages(tld));
    tp := frMyPrint.cbTypePrint.ItemIndex;
    if tp = 0 then
      tp := 2;
    DrawPageMaket(tp);
  end;
end;

procedure TfrMyPrint.SpeedButton1Click(Sender: TObject);
var
  tp, i, j, cnt, tld: integer;
begin
  for j := 1 to SpinEdit1.Value do
  begin
    Printer.BeginDoc;
    tp := cbTypePrint.ItemIndex;
    tld := cbDevices.ItemIndex;
    if tp = 0 then
    begin
      cnt := (Form1.GridTimeLines.Objects[0, tld + 1]
        as TTimelineOptions).CountDev;
      for i := 0 to cnt - 1 do
      begin
        PrintMaketPages(0, i + 2);
        if i <> cnt - 1 then
          Printer.NewPage;
      end;
    end
    else
      PrintMaketPages(0, tp);
    Printer.EndDoc;
  end;
end;

procedure TfrMyPrint.cbDevicesChange(Sender: TObject);
var
  i, tp, tld, tlt, cnt, inx: integer;
begin
  Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  tld := findpostimeline(frMyPrint.cbDevices.ItemIndex, tldevice);
  cnt := (Form1.GridTimeLines.Objects[0, tld + 1] as TTimelineOptions).CountDev;
  inx := cbTypePrint.ItemIndex;
  cbTypePrint.Clear;
  cbTypePrint.Items.Add('Все устройства по отдельности');
  cbTypePrint.Items.Add('Последовательность съёмки');
  for i := 1 to cnt do
    cbTypePrint.Items.Add(PrintDeviceName + ' ' + inttostr(i));
  if inx < cbTypePrint.Items.Count then
    cbTypePrint.ItemIndex := inx
  else
    cbTypePrint.ItemIndex := 0;

  tlt := findpostimeline(frMyPrint.cbTexts.ItemIndex, tltext);
  PrintListEvents.LoadData(tld, tlt, true);
  frMyPrint.Label8.Caption := inttostr(CountMaketPages(tld));
  tp := frMyPrint.cbTypePrint.ItemIndex;
  if tp = 0 then
    tp := 2;
  DrawPageMaket(tp);
end;

procedure TfrMyPrint.cbTypePrintChange(Sender: TObject);
var
  tp, tld: integer;
begin
  Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  tld := findpostimeline(frMyPrint.cbDevices.ItemIndex, tldevice);
  frMyPrint.Label8.Caption := inttostr(CountMaketPages(tld));
  tp := frMyPrint.cbTypePrint.ItemIndex;
  if tp = 0 then
    tp := 2;
  DrawPageMaket(tp);
end;

procedure TfrMyPrint.cbDataPrintChange(Sender: TObject);
var
  tp, tld: integer;
begin
  if frMyPrint.cbDataPrint.ItemIndex = 0 then
    frMyPrint.cbTexts.Enabled := false
  else
    frMyPrint.cbTexts.Enabled := true;
  Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  tld := findpostimeline(frMyPrint.cbDevices.ItemIndex, tldevice);
  frMyPrint.Label8.Caption := inttostr(CountMaketPages(tld));
  tp := frMyPrint.cbTypePrint.ItemIndex;
  if tp = 0 then
    tp := 2;
  DrawPageMaket(tp);
end;

procedure TfrMyPrint.cbTextsChange(Sender: TObject);
var
  tp, tld, tlt: integer;
begin
  Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  tld := findpostimeline(frMyPrint.cbDevices.ItemIndex, tldevice);
  tlt := findpostimeline(frMyPrint.cbTexts.ItemIndex, tltext);
  PrintListEvents.LoadData(tld, tlt, true);
  frMyPrint.Label8.Caption := inttostr(CountMaketPages(tld));
  tp := frMyPrint.cbTypePrint.ItemIndex;
  if tp = 0 then
    tp := 2;
  DrawPageMaket(tp);
end;

procedure TfrMyPrint.ComboBox1Change(Sender: TObject);
begin
  Printer.PrinterIndex := ComboBox1.ItemIndex;
end;

end.
