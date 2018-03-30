unit MyData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, JPEG;

Type
  TSizeBitmap = record
    PixWidth : longint;
    PixHeight : longint;
    DMMWidth : longint;
    DMMHeight : longint;
  end;

  PBMPELEMENT = ^TBMPELEMENT;
  TBMPELEMENT = record
    Bitmap : tbitmap;
    Width  : longint;
    Height : longint;
    Select : boolean;
  end;

Var
  pbmp : pbmpelement;
  pbitmap : pointer;
  jpg : tjpegimage;
  listbitmap : tlist;
  worklist   : tlist;
  PrinterPageSize : TSizeBitmap;
  WorkBitmapSize  : TSizeBitmap;
  WorkBitmap : TBitmap;

  procedure ADDBitmapToList(bmp : tbitmap);
  function BmpGetDivider(bmpwdth, bmphght, cellwdth, cellhght : integer) : TPoint;
  function selectmaxbmp : tpoint;
  Procedure DrawLPIBitmap(dst, src1, src2 : tbitmap; steplpi : integer);

implementation
uses umyfiles;

procedure ADDBitmapToList(bmp : tbitmap);
begin
  try
  new(pbmp);
  pbmp^.Bitmap:=tbitmap.Create;
  pbmp^.Bitmap.Assign(bmp);
  pbmp^.Width:=bmp.Width;
  pbmp^.Height:=bmp.Height;
  listbitmap.Add(pbmp);
  WriteLog('MAIN', 'UMyFiles.ADDBitmapToList');
  except
    on E: Exception do WriteLog('MAIN', 'UMyFiles.ADDBitmapToList | ' + E.Message);
  end;
end;

function selectmaxbmp : tpoint;
var i, posmax, szw, szh : integer;
begin
  try
  result.X:=0;
  result.Y:=0;
  if listbitmap.Count <=0 then exit;
  posmax:=0;
  szw:=0;
  szh:=0;
  for i := 0 to listbitmap.Count - 1 do begin
    pbmp:=listbitmap[i];
    if (pbmp^.Width >= szw)  then begin
      if (pbmp^.Height > szh) then begin
        szh:=pbmp^.Height;
        posmax:=i;
      end;
    end;
  end;
  pbmp:=listbitmap[posmax];
  result.X:=pbmp^.Width;
  result.Y:=pbmp^.Height;
  WriteLog('MAIN', 'UMyFiles.selectmaxbmp Width=' + inttostr(result.X) + ' Height=' + inttostr(result.Y));
  except
    on E: Exception do WriteLog('MAIN', 'UMyFiles.selectmaxbmp Width=' + inttostr(result.X) + ' Height=' + inttostr(result.Y) + ' | ' + E.Message);
  end;
end;

function BmpGetDivider(bmpwdth, bmphght, cellwdth, cellhght : integer) : TPoint;
var dlt, wdlt, hdlt : real;
    tmpw, tmph : integer;
begin
  try
  wdlt := bmpwdth / cellwdth;
  hdlt := bmphght / cellhght;

  //if wdlt > hdlt then result:=Wdlt else result:=Hdlt;

  if cellwdth>cellhght then begin
    if wdlt > hdlt then dlt:=Wdlt else dlt:=Hdlt;
  end else begin
    if wdlt > hdlt then dlt:=Hdlt else dlt:=Wdlt;
  end;

  tmpw := trunc(bmpwdth / dlt);
  tmph := trunc(bmphght / dlt);

  if tmpw > cellwdth then begin
    result.X:=cellwdth;
    result.Y:=trunc(bmphght / wdlt);
    WriteLog('MAIN', 'UMyFiles.BmpGetDivider-1 Width=' + inttostr(result.X) + ' Height=' + inttostr(result.Y));
    exit;
  end;

  if tmph > cellhght then begin
    result.X:=trunc(bmpwdth / hdlt);
    result.Y:=cellhght;
    WriteLog('MAIN', 'UMyFiles.BmpGetDivider-2 Width=' + inttostr(result.X) + ' Height=' + inttostr(result.Y));
    exit;
  end;

  result.X:=tmpw;
  result.Y:=tmph;
  WriteLog('MAIN', 'UMyFiles.BmpGetDivider-3 Width=' + inttostr(result.X) + ' Height=' + inttostr(result.Y));
  except
    on E: Exception do WriteLog('MAIN', 'UMyFiles.BmpGetDivider Width=' + inttostr(result.X) + ' Height=' + inttostr(result.Y) + ' | ' + E.Message);
  end;
//wdlt := bmpwdth / cellwdth;
//hdlt := bmphght / cellhght;

//if wdlt > hdlt then result:=Wdlt else result:=Hdlt;

//  if bmpwdth > bmphght then begin
//    dlt:=bmpwdth / cellwdth;
//    if trunc(dlt*cellhght) > bmphght
//      then result:=bmphght / cellhght
//      else result:=dlt;
//  end else begin
//    dlt:=bmphght / cellhght;
//    if trunc(dlt*cellwdth)>bmpwdth
//      then result:=bmpwdth / cellwdth
//      else result:=dlt;
//  end;
end;


procedure JPEGtoBMP(const FileName: TFileName);
var
  jpeg: TJPEGImage;
  bmp:  TBitmap;
begin
  try
  WriteLog('MAIN', 'UMyFiles.JPEGtoBMP In FileName=' + FileName);
  jpeg := TJPEGImage.Create;
  try
    jpeg.CompressionQuality := 100; {Default Value}
    jpeg.LoadFromFile(FileName);
    bmp := TBitmap.Create;
    try
      bmp.Assign(jpeg);
      bmp.SaveTofile(ChangeFileExt(FileName, '.bmp'));
      WriteLog('MAIN', 'UMyFiles.JPEGtoBMP Out FileName=' + ChangeFileExt(FileName, '.bmp'));
    finally
      bmp.Free
    end;
  finally
    jpeg.Free
  end;
  except
    on E: Exception do WriteLog('MAIN', 'UMyFiles.JPEGtoBMP FileName=' + FileName + ' | ' + E.Message);
  end;
end;


Procedure DrawLPIBitmap(dst, src1, src2 : tbitmap; steplpi : integer);
var i : integer;
    R : TRect;
    bmp1, bmp2 : tbitmap;
begin
  try
  WriteLog('MAIN', 'UMyFiles.DrawLPIBitmap | ');
  R.Left:=0;
  R.Right:=R.Left + steplpi;
  R.Top:=0;
  R.Bottom:=dst.Height;
  i:=1;
  bmp1:=tbitmap.Create;
  bmp1.Width:=dst.Width;
  bmp1.Height:=dst.Height;
  try
    bmp1.Canvas.CopyRect(bmp1.Canvas.ClipRect,src1.Canvas,src1.Canvas.ClipRect);
    bmp2:=tbitmap.Create;
    bmp2.Width:=dst.Width;
    bmp2.Height:=dst.Height;
    try
      bmp2.Canvas.CopyRect(bmp2.Canvas.ClipRect,src2.Canvas,src2.Canvas.ClipRect);
      while R.Right < dst.Width do begin
        R.Left:=R.Right+1;
        R.Right:=R.Left + steplpi;
        if (i mod 2 <> 0)
        then dst.Canvas.CopyRect(R,src1.Canvas,R)
        else dst.Canvas.CopyRect(R,src2.Canvas,R);
        i:=i+1;
      end;
    finally
      bmp2.Free;
    end;
  finally
    bmp1.Free;
  end;
  except
    on E: Exception do WriteLog('MAIN', 'UMyFiles.DrawLPIBitmap | ' + E.Message);
  end;
end;

initialization

  listbitmap:=tlist.Create;
  listbitmap.Clear;
  worklist:=tlist.Create;
  worklist.Clear;
  workbitmap:=tbitmap.Create;

finalization

  listbitmap.Free;
  worklist.Free;
  workbitmap.Free;
end.
