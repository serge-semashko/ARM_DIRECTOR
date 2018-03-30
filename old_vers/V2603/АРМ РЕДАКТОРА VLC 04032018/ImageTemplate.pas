unit ImageTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ExtDlgs, Buttons, JPEG, StdCtrls;

type
  TRectSelection = (rct, lftp, tp, tprt, rt, rtbt, bt, btlf, lf, rempt);

  TMyRect = class(TObject)
    private
      X0, Y0 : integer;
      Down : boolean;
      Selection : TRectSelection;
    public
    Color : tcolor;
    Penwidth : integer;
    Left : integer;
    Top : integer;
    Width : integer;
    Height : integer;
    rectlftp : trect;
    recttp : trect;
    recttprt : trect;
    rectrt : trect;
    rectrtbt : trect;
    rectbt : trect;
    rectbtlf : trect;
    rectlf : trect;
    procedure MoveMouse(cv : tcanvas; X,Y : integer);
    procedure DownMouse(cv : tcanvas; X,Y : integer);
    procedure UpMouse(cv : tcanvas; X,Y : integer);
    procedure Draw(cv : tcanvas);
    procedure Resize(txt : string; Border : trect);
    function Rect : trect;
    constructor Create;
    destructor Destroy;  override;
  end;

  TFGRTemplate = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    ComboBox1: TComboBox;
    Panel4: TPanel;
    Bevel1: TBevel;
    Image2: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Layer1: TImage;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Layer1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Layer1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Layer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Layer1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FGRTemplate: TFGRTemplate;
  ImgRect : TRect;
  bm: TBitMap;
  Msht : Real;
  BKGN : tcolor = clSilver;
  MyRect : TMyRect;

  procedure DrawTemplate;

implementation
{$R *.dfm}

procedure SaveToJpegFile(FileName : string);
var
   oJPEG : TJPEGImage;
   img, bmp : tbitmap;
   rt : trect;
begin
  bmp := tbitmap.Create;
  try
  bmp.Width:=1920;
  bmp.Height:=1080;
  img := TBitmap.Create;
  try
  img.PixelFormat:=pf24bit;
  img.Width:=trunc(MyRect.Width * Msht);
  img.Height:=trunc(MyRect.Height * Msht);
  rt.Left:=trunc((MyRect.Left - ImgRect.Left) * Msht);
  rt.Right:=rt.Left + img.Width;
  rt.Top:=trunc((MyRect.Top - ImgRect.Top) * Msht);
  rt.Bottom:=rt.Top + img.Height;
  bitblt(img.Canvas.Handle, 0, 0, img.Width, img.Height,bm.Canvas.Handle, rt.Left, rt.Top , SRCCOPY);
  bmp.Canvas.StretchDraw(bmp.Canvas.ClipRect,img);
  oJPEG := TJPEGImage.Create;
  try
    oJPEG.Assign(bmp);
    oJPEG.SaveToFile(extractfilepath(Application.ExeName) + FileName + '.jpeg');
  finally
    oJPEG.Free;
  end
  finally
    img.Free;
  end;
  finally
    bmp.Free;
  end;
end;

function WidthFromHeight(txt : string; hgh : integer) : integer;
begin
  if trim(txt) = '16x9' then result:=trunc(hgh / 9 * 16);
  if trim(txt) = '4x3' then result:=trunc(hgh / 3 * 4);
end;

function HeightFromWidth(txt : string; wdt : integer) : integer;
begin
  if trim(txt) = '16x9' then result:=trunc(wdt / 16 * 9);
  if trim(txt) = '4x3' then result:=trunc(wdt / 4 * 3);
end;

procedure TMyRect.Resize(txt : string; Border : trect);
var mtp, mlf, mrt, mbt, wdt, hgh, mwdt, mhgh : integer;
begin
  //mhgh:=Height;
  mwdt:=Width;
  mhgh := heightfromwidth(txt, mwdt);
  if mhgh < Height then begin
    Height:=mhgh;
    exit;
  end;
  if Top + mhgh > Border.Bottom then begin
    Height:=Border.Bottom - Top;
    mwdt:=widthfromheight(txt, Height);
    Left:=Left + (Width - mwdt) div 2;
    Width := mwdt;
    exit;
  end;
  Height:=mhgh;
end;

Constructor TMyRect.Create;
begin
  inherited;
  Color := $525252;//clOlive;
  PenWidth := 2;
  Left := 0;
  Top := 0;
  Width := 160;
  Height := 90;

  rectlftp.Left := 0;
  rectlftp.Right := 0;
  rectlftp.Top := 0;
  rectlftp.Bottom := 0;

  recttp.Left := 0;
  recttp.Right := 0;
  recttp.Top := 0;
  recttp.Bottom := 0;

  recttprt.Left := 0;
  recttprt.Right := 0;
  recttprt.Top := 0;
  recttprt.Bottom := 0;

  rectrt.Left := 0;
  rectrt.Right := 0;
  rectrt.Top := 0;
  rectrt.Bottom := 0;

  rectrtbt.Left := 0;
  rectrtbt.Right := 0;
  rectrtbt.Top := 0;
  rectrtbt.Bottom := 0;

  rectbt.Left := 0;
  rectbt.Right := 0;
  rectbt.Top := 0;
  rectbt.Bottom := 0;

  rectbtlf.Left := 0;
  rectbtlf.Right := 0;
  rectbtlf.Top := 0;
  rectbtlf.Bottom := 0;

  rectlf.Left := 0;
  rectlf.Right := 0;
  rectlf.Top := 0;
  rectlf.Bottom := 0;

end;

Destructor TMyRect.Destroy;
begin
  FreeMem(@Color);
  FreeMem(@PenWidth);
  FreeMem(@Left);
  FreeMem(@Top);
  FreeMem(@Width);
  FreeMem(@Height);
  FreeMem(@rectlftp);
  FreeMem(@recttp);
  FreeMem(@recttprt);
  FreeMem(@rectrt);
  FreeMem(@rectrtbt);
  FreeMem(@rectbt);
  FreeMem(@rectbtlf);
  FreeMem(@rectlf);
  inherited;
end;

function TMyRect.Rect : TRect;
var mwdt, mhgh  : integer;
begin
  //Result.Top:=Top;
  //Result.Bottom:=Top + Height;
//  mwdt := widthfromheight(txt, Height);
//  if mwdt > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
//    mwdt := (cv.ClipRect.Right-cv.ClipRect.Left);
//    mhgh := heightfromwidth(txt, mwdt);
//  end;
//  if (Left + (Width - mwdt) div 2) < cv.ClipRect.Left
//    then Left := cv.ClipRect.Left else Left := Left + (Width - mwdt) div 2;
//  if (Left + (Width + mwdt) div 2) > cv.ClipRect.Right then Left := cv.ClipRect.Right - mwdt;

//  Width:=mwdt;
//  Height:=mhgh;
  Resize(FGRTemplate.ComboBox1.Text, FGRTemplate.Layer1.Canvas.ClipRect);
  Result.Left:=Left;
  Result.Top:=Top;
  Result.Right:=Result.Left + Width;
  Result.Bottom:=Result.Top + Height;

end;

procedure TMyRect.Draw(cv : tcanvas);
var pw, ph : integer;
begin
  pw := Width div 2;
  ph := Height div 2;

  cv.FillRect(cv.ClipRect);
  cv.Pen.Color := Color;
  cv.Pen.Width := PenWidth;
  cv.Rectangle(MyRect.Rect);

  rectlftp.Left := Left - 2;
  rectlftp.Right := Left + 4;
  rectlftp.Top := Top - 2;
  rectlftp.Bottom := Top + 4;
  cv.Rectangle(rectlftp);

  recttp.Left := Left + pw - 3;
  recttp.Right := Left + pw + 3;
  recttp.Top := Top - 2;
  recttp.Bottom := Top + 4;
  cv.Rectangle(recttp);

  recttprt.Left := Left + Width - 4;
  recttprt.Right := Left + Width + 2;
  recttprt.Top := Top - 2;
  recttprt.Bottom := Top + 4;
  cv.Rectangle(recttprt);

  rectrt.Left := Left + Width - 4;
  rectrt.Right := Left + Width + 2;
  rectrt.Top := Top + ph - 3;
  rectrt.Bottom := Top + ph + 3;
  cv.Rectangle(rectrt);

  rectrtbt.Left := Left + Width - 4;
  rectrtbt.Right := Left + Width + 2;
  rectrtbt.Top := Top + Height - 4;
  rectrtbt.Bottom := Top + Height + 2;
  cv.Rectangle(rectrtbt);

  rectbt.Left := Left + pw - 4;
  rectbt.Right := Left + pw + 2;
  rectbt.Top := Top + Height - 4;
  rectbt.Bottom := Top + Height + 2;
  cv.Rectangle(rectbt);

  rectbtlf.Left := Left - 2;
  rectbtlf.Right := Left + 4;
  rectbtlf.Top := Top + Height - 4;
  rectbtlf.Bottom := Top + Height + 2;
  cv.Rectangle(rectbtlf);

  rectlf.Left := Left - 2;
  rectlf.Right := Left + 4;
  rectlf.Top := Top + ph - 4;
  rectlf.Bottom := Top + ph + 2;
  cv.Rectangle(rectlf);

end;

function PointInRect(Rect : trect; X,Y : integer) : boolean;
begin
  result := false;
  if (X >= Rect.Left) and (X <= Rect.Right) and (Y  <= Rect.Bottom) and (Y >= Rect.Top) then result:=true;
end;

function GetSizeRect(txt : string; wdt, hgh : integer) : tpoint;
begin
  if wdt > hgh then begin
    Result.X:=wdt;
    Result.Y:=heightfromwidth(FGRTemplate.ComboBox1.Text, wdt);
  end else begin
    Result.Y:=hgh;
    Result.X:=widthfromheight(FGRTemplate.ComboBox1.Text, hgh);
  end;
end;

procedure TMyRect.MoveMouse(cv : tcanvas; X,Y : integer);
var  mlf, mtp, mrt, mbt, mwdt, mhgh, dltx, dlty, dltx1, dlty1 : integer;
     pt : tpoint;
begin
    if not Down then begin
      FGRTemplate.Layer1.Cursor:=crDefault;
      if PointInRect(Rect,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeAll;
      if PointInRect(rectlftp,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNWSE;
      if PointInRect(recttp,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNS;
      if PointInRect(recttprt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNESW;
      if PointInRect(rectrt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeWE;
      if PointInRect(rectrtbt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNWSE;
      if PointInRect(rectbt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNS;
      if PointInRect(rectbtlf,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNESW;
      if PointInRect(rectlf,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeWE;
    end else begin
      if X < cv.ClipRect.Left then X := cv.ClipRect.Left;
      if X > cv.ClipRect.Right then X := cv.ClipRect.Right;
      if Y < cv.ClipRect.Top then Y := cv.ClipRect.Top;
      if Y > cv.ClipRect.Bottom then Y := cv.ClipRect.Bottom;
      dltx := X - X0;
      dlty := Y - Y0;

           case Selection of
      rct   : begin
                mlf := Left + dltx;
                mtp := Top + dlty;
                if mlf < cv.ClipRect.Left then mlf := cv.ClipRect.Left;
                if mtp < cv.ClipRect.Top then mtp := cv.ClipRect.Top;
                if mlf + Width > cv.ClipRect.Right then mlf := Left;
                if mtp + Height > cv.ClipRect.Bottom then mtp := Top;
                Left:=mlf;
                Top:=mtp;
              end;
      lftp  : begin
                mrt := Left + Width;
                mbt := Top + Height;
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, mrt - X, mbt - Y);
                mwdt:=pt.X;
                mhgh:=pt.Y;
                Left:=mrt - mwdt;
                Top:=mbt - mhgh;
                Width:=mwdt;
                Height:=mhgh;
              end;
      tp    : begin
                mbt := Top + Height;
                mtp := Y;
                mhgh := mbt - Y;
                mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                if mwdt > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mwdt := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                  mtp:=mbt-mhgh;
                end;
                if (X - mwdt div 2) < cv.ClipRect.Left
                  then mlf := cv.ClipRect.Left else mlf := X - mwdt div 2;
                if (X + mwdt div 2) > cv.ClipRect.Right
                  then mlf := cv.ClipRect.Right - mwdt;
                Left:=mlf;
                Top:=mtp;
                Width:=mwdt;
                Height:=mhgh;
              end;
      tprt  : begin
                mbt:=Top+Height;
                mlf:=Left;
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, X - mlf, mbt - Y);
                mwdt:=pt.X;
                mhgh:=pt.Y;
                Left:=mlf;
                Top:=mbt - mhgh;
                Width:=mwdt;
                Height:=mhgh;
              end;
      rt    : begin
                mlf := Left;
                mwdt := X - Left;
                mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                if mhgh > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mhgh := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                end;
                if (Y - mhgh div 2) < cv.ClipRect.Top
                  then mtp := cv.ClipRect.Top else mtp := Y - mhgh div 2;
                if (Y + mhgh div 2) > cv.ClipRect.Bottom
                  then mtp := cv.ClipRect.Bottom - mhgh;
                Left:=mlf;
                Top:=mtp;
                Width:=mwdt;
                Height:=mhgh;
              end;
      rtbt  : begin
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, X - Left, Y - Top);
                Width:=pt.X;
                Height:=pt.Y;
              end;
      bt    : begin
                mhgh:=Y-Top;
                mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                if mwdt > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mwdt := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                end;
                if (X - mwdt div 2) < cv.ClipRect.Left
                  then mlf := cv.ClipRect.Left else mlf := X - mwdt div 2;
                if (X + mwdt div 2) > cv.ClipRect.Right
                  then mlf := cv.ClipRect.Right - mwdt;
                Left:=mlf;
                Width:=mwdt;
                Height:=mhgh;
              end;
      btlf  : begin
                //mtp:=Top;
                mrt:=Left+Width;
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, mrt - X, Y - Top);
                mwdt:=pt.X;
                mhgh:=pt.Y;
                Left:=mrt - mwdt;
                Width:=mwdt;
                Height:=mhgh;
              end;
      lf    : begin
                mrt:=Left+Width;
                mwdt := mrt - X;
                mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                if mhgh > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mhgh := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                end;
                if (Y - mhgh div 2) < cv.ClipRect.Top
                  then mtp := cv.ClipRect.Top else mtp := Y - mhgh div 2;
                if (Y + mhgh div 2) > cv.ClipRect.Bottom
                  then mtp := cv.ClipRect.Bottom - mhgh;
                Left:=mrt-mwdt;
                Top:=mtp;
                Width:=mwdt;
                Height:=mhgh;
              end;
      rempt : exit;
           end;


      Draw(cv);
      DrawTemplate;

      X0:=X;
      Y0:=Y;
    end;
end;

procedure TMyRect.DownMouse(cv : tcanvas; X,Y : integer);
begin
  Selection:=rempt;
  if PointInRect(Rect,X,Y) then Selection:=rct;
  if PointInRect(rectlftp,X,Y) then Selection:=lftp;
  if PointInRect(recttp,X,Y) then Selection:=tp;
  if PointInRect(recttprt,X,Y) then Selection:=tprt;
  if PointInRect(rectrt,X,Y) then Selection:=rt;
  if PointInRect(rectrtbt,X,Y) then Selection:=rtbt;
  if PointInRect(rectbt,X,Y) then Selection:=bt;
  if PointInRect(rectbtlf,X,Y) then Selection:=btlf;
  if PointInRect(rectlf,X,Y) then Selection:=lf;
  Down:=true;
  X0:=X;
  Y0:=Y;
end;

procedure TMyRect.UpMouse(cv : tcanvas; X,Y : integer);
begin
  Down:=false;
  Selection:=rempt;
end;

procedure DrawTemplate;
var rt : trect;
    img : tbitmap;
begin
  img := tbitmap.Create;
  img.PixelFormat:=pf24bit;

  img.Width:=trunc(MyRect.Width * Msht);
  img.Height:=trunc(MyRect.Height * Msht);
  rt.Left:=trunc((MyRect.Left - ImgRect.Left) * Msht);
  rt.Right:=rt.Left + img.Width;

  rt.Top:=trunc((MyRect.Top - ImgRect.Top) * Msht);
  rt.Bottom:=rt.Top + img.Height;

  bitblt(img.Canvas.Handle, 0, 0, img.Width, img.Height,bm.Canvas.Handle, rt.Left, rt.Top , SRCCOPY);
  FGRTemplate.Image2.Canvas.StretchDraw(FGRTemplate.Image2.Canvas.ClipRect,img);
  img.Destroy;
end;

procedure InitRectFrame(text : string);
var wdth, hght, dlt : integer;
    mnx, mny : integer;
begin
  if text='16x9' then begin
    mnx := 16;
    mny := 9;
  end;

  if text='4x3' then begin
    mnx := 4;
    mny := 3;
  end;

  wdth := ImgRect.Right-ImgRect.Left;
  hght := ImgRect.Bottom - ImgRect.Top;

  if wdth >= hght then begin
     dlt := wdth div mnx * mny;
     if dlt < hght then hght:=dlt else wdth:=hght div mny * mnx;
  end else begin
     dlt := hght div mny * mnx;
     if dlt < wdth then wdth:=dlt else hght:=wdth div mnx * mny;
  end;

end;

Procedure SetSizeFrame(text : string);
var wdth, hght : integer;
begin
    if text='16x9' then begin
      //FGRTemplate.Shape1.Height:=FGRTemplate.Shape1.Width div 16 * 9;
      FGRTemplate.Bevel1.Width:=FGRTemplate.Panel4.Width-10;
      FGRTemplate.Bevel1.Height:=trunc(FGRTemplate.Bevel1.Width / 16 * 9);
      FGRTemplate.Bevel1.Left:=5;
      FGRTemplate.Bevel1.Top:=FGRTemplate.Panel4.Top + ((FGRTemplate.Panel4.Height - FGRTemplate.Bevel1.Height) div 2);
    end;
    if text='4x3' then begin
      //FGRTemplate.Shape1.Height:=FGRTemplate.Shape1.Width div 4 * 3;
      FGRTemplate.Bevel1.Height:=FGRTemplate.Panel4.Height-10;
      FGRTemplate.Bevel1.Width:=trunc(FGRTemplate.Bevel1.Height / 3 * 4);
      FGRTemplate.Bevel1.Top:=5;
      FGRTemplate.Bevel1.Left:=FGRTemplate.Panel4.left + ((FGRTemplate.Panel4.Width - FGRTemplate.Bevel1.Width) div 2);
    end;
    FGRTemplate.Image2.Left:=FGRTemplate.Bevel1.Left+5;
    FGRTemplate.Image2.Width:=FGRTemplate.Bevel1.Width - 10;
    FGRTemplate.Image2.Top:=FGRTemplate.Bevel1.Top+5;
    FGRTemplate.Image2.Height:=FGRTemplate.Bevel1.Height -10;
    FGRTemplate.Image2.Picture.Bitmap.Width:=FGRTemplate.Image2.Width;
    FGRTemplate.Image2.Picture.Bitmap.Height:=FGRTemplate.Image2.Height;
end;

procedure DrawPicture(cv : tcanvas; bmp : TBitmap);
var
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
begin
  //bwdth := bmp.Width;
  //bhght := bmp.Height;
  cv.Brush.Color:=BKGN;
  cv.FillRect(cv.ClipRect);
  wdth := cv.ClipRect.Right - cv.ClipRect.Left;
  hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
  if bmp.Width >= bmp.Height then begin
    Msht:=bmp.Width / wdth;
    if hght * Msht < bmp.Height then Msht := bmp.Height / hght;
  end else begin
    Msht:=bmp.Height / hght;
    if wdth * Msht < bmp.Width then Msht := bmp.Width / wdth;
  end;

  bwdth:=round(bmp.Width / Msht);
  bhght:=round(bmp.Height / Msht);
  imgRect.Left:=cv.ClipRect.Left + ((wdth - bwdth) div 2);
  imgRect.Right:=imgRect.Left + bwdth;
  imgRect.Top:=cv.ClipRect.Top + ((hght - bhght) div 2);
  imgRect.Bottom:=imgRect.Top + bhght;
  cv.StretchDraw(imgRect, bmp);
end;

procedure SetSizeLayer1;
begin
  with FGRTemplate do begin
    Layer1.Left:=Image1.Left;
    Layer1.Width:=Image1.Width;
    Layer1.Top:=Image1.Top;
    Layer1.Height:=Image1.Height;
    Image1.Picture.Bitmap.Width:=Image1.Width;
    Image1.Picture.Bitmap.Height:=Image1.Height;
    Layer1.Picture.Bitmap.Width:=Layer1.Width;
    Layer1.Picture.Bitmap.Height:=Layer1.Height;
    Layer1.Canvas.Brush.Style:=bsClear;
    Layer1.Canvas.Brush.Color:=Layer1.Picture.Bitmap.TransparentColor;
    Layer1.Canvas.FillRect(Layer1.Canvas.ClipRect);
  end;
end;

procedure TFGRTemplate.FormCreate(Sender: TObject);
begin
  FGRTemplate.DoubleBuffered:=true;
  FGRTemplate.Panel1.DoubleBuffered:=true;
  FGRTemplate.Panel2.DoubleBuffered:=true;
  FGRTemplate.Panel3.DoubleBuffered:=true;
  FGRTemplate.Panel4.DoubleBuffered:=true;
  Image1.Parent.DoubleBuffered:=true;
  Image2.Parent.DoubleBuffered:=true;
  Layer1.Parent.DoubleBuffered:=true;
  //Shape1.Parent.DoubleBuffered:=true;
  MyRect:=TMyRect.Create;
  MyRect.Left:=50;
  MyRect.Top:=50;
  MyRect.Width:=320;
  MyRect.Height:=heightfromwidth(ComboBox1.Text, MyRect.Width);
  Image1.Picture.Bitmap.PixelFormat:=pf24bit;

  Image1.Canvas.Brush.Color:=clSilver;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  Layer1.Canvas.Brush.Style:=bsClear;
  //JpegIm := TJpegImage.Create;
  bm := TBitMap.Create;
  bm.PixelFormat := pf24bit;
  SetSizeFrame(ComboBox1.Text);
  Image2.Canvas.Brush.Color:=clSilver;
  Image2.Canvas.FillRect(Image2.Canvas.ClipRect);
  SetSizeLayer1;
  MyRect.Draw(Layer1.Canvas);
end;

procedure TFGRTemplate.FormResize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width:=Image1.Width;
  Image1.Picture.Bitmap.Height:=Image1.Height;
  Image1.Canvas.Brush.Color:=BKGN;
  SetSizeLayer1;
  if bm.Width > 0 then begin
    DrawPicture(Image1.Canvas, bm);
    InitRectFrame(ComboBox1.Text);
    Image1.Canvas.Brush.Style:=bsClear;
    Image1.Canvas.Pen.Width:=2;
    Image1.Canvas.Pen.Color:=clGray;
    DrawTemplate;
  end;
end;

procedure LoadJpegFile(cv : tcanvas; FileName : string);
var
  JpegIm: TJpegImage;
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
begin
  bm.FreeImage;
  JpegIm := TJpegImage.Create;
  JpegIm.LoadFromFile(FileName);
  bm.Assign(JpegIm);
  DrawPicture(cv, bm);
  cv.Brush.Style:=bsClear;
  DrawTemplate;
  JpegIm.Destroy;
end;


procedure TFGRTemplate.SpeedButton1Click(Sender: TObject);
begin
  If opendialog1.Execute then begin
     LoadJpegFile(Image1.Canvas,OpenDialog1.FileName);
  end;
end;

procedure TFGRTemplate.FormDestroy(Sender: TObject);
begin
  bm.Destroy;
end;

procedure TFGRTemplate.ComboBox1Change(Sender: TObject);
begin
  SetSizeFrame(ComboBox1.Text);
  MyRect.Resize(ComboBox1.Text,Layer1.Canvas.ClipRect);
  MyRect.Draw(Layer1.Canvas);
  if bm.Width > 0 then begin
    DrawPicture(Image1.Canvas, bm);
    InitRectFrame(ComboBox1.Text);
    DrawTemplate;
    Layer1.Canvas.Refresh;
  end;
end;


procedure TFGRTemplate.Layer1Click(Sender: TObject);
begin
  MyRect.Draw(Layer1.Canvas);
end;

procedure TFGRTemplate.FormShow(Sender: TObject);
begin
  //MyRect.Draw(Layer1.Canvas);
end;

procedure TFGRTemplate.Layer1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MyRect.UpMouse(Layer1.Canvas, X, Y);
end;

procedure TFGRTemplate.Layer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MyRect.DownMouse(Layer1.Canvas, X, Y);
end;

procedure TFGRTemplate.Layer1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var dltx, dlty : integer;
begin
  label1.Caption:='X=' + inttostr(X) + '  Y=' + inttostr(Y);
  MyRect.MoveMouse(Layer1.Canvas, X,Y);
end;

procedure TFGRTemplate.SpeedButton2Click(Sender: TObject);
begin
  SaveToJpegFile(inttostr(Random(5)));
end;

end.


