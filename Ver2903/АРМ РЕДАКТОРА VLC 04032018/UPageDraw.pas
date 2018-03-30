unit UPageDraw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, printers, upagesetup,
  UMyEvents;

Type
  TTypeMaket = (tmScreen, tmPrinter);

  TMaketOptions = Class
  public
    Width: integer;
    Height: integer;
    Left: integer;
    Right: integer;
    Top: integer;
    Bottom: integer;
    mmHorz: integer;
    mmVert: integer;
    RowHeight: integer;
    X1: integer;
    X2: integer;
    X3: integer;
    X4: integer;
    X5: integer;
    LowBorder: integer;
    procedure SetOptions(tm: TTypeMaket; Prn: TPageParameters);
    Constructor Create;
    Destructor Destroy;
  end;

  TPrintRowEvent = class
    Shot: integer;
    Start: longint;
    Finish: longint;
    Duration: longint;
    Device: integer;
    Text: string;
    Comment: string;
    Lyrics: string;
    procedure Assign(tpre: TPrintRowEvent);
    Constructor Create;
    Destructor Destroy;
  end;

  TPrintListEvents = class
    Count: integer;
    Rows: array of TPrintRowEvent;
    procedure Clear;
    function AddDevice(tlnom, evnom, shps: integer): integer;
    function AddLyrics(tlnom, evnom: integer): integer;
    function FindEvent(tc: longint): integer;
    procedure LoadData(tldev, tltxt: integer; whatload: boolean);
    Constructor Create;
    Destructor Destroy;
  end;

Var
  MaketOptions: TMaketOptions;
  PrintListEvents: TPrintListEvents;

implementation

uses ugrtimelines;

procedure TPrintListEvents.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Rows[i].FreeInstance;
  Count := 0;
  Setlength(Rows, Count);
end;

Constructor TPrintListEvents.Create;
begin
  Count := 0;
end;

Destructor TPrintListEvents.Destroy;
begin
  Clear;
  FreeMem(@Rows);
  FreeMem(@Count);
end;

function TPrintListEvents.AddDevice(tlnom, evnom, shps: integer): integer;
begin
  Count := Count + 1;
  Setlength(Rows, Count);
  Rows[Count - 1] := TPrintRowEvent.Create;
  Rows[Count - 1].Shot := shps;
  if shps = 1 then
  begin
    if TLZone.Timelines[tlnom].Events[evnom].Start < TLParameters.Start then
      Rows[Count - 1].Start := TLParameters.Start - TLParameters.Preroll
    else
      Rows[Count - 1].Start := TLZone.Timelines[tlnom].Events[evnom].Start -
        TLParameters.Preroll;
  end
  else
    Rows[Count - 1].Start := TLZone.Timelines[tlnom].Events[evnom].Start -
      TLParameters.Preroll;
  if TLZone.Timelines[tlnom].Events[evnom].Finish > TLParameters.Finish then
    Rows[Count - 1].Finish := TLParameters.Finish - TLParameters.Preroll
  else
    Rows[Count - 1].Finish := TLZone.Timelines[tlnom].Events[evnom].Finish -
      TLParameters.Preroll;
  Rows[Count - 1].Duration := Rows[Count - 1].Finish - Rows[Count - 1].Start;
  Rows[Count - 1].Device := TLZone.Timelines[tlnom].Events[evnom].ReadPhraseData
    ('Device');
  Rows[Count - 1].Text := TLZone.Timelines[tlnom].Events[evnom]
    .ReadPhraseText('Text');
  Rows[Count - 1].Comment := TLZone.Timelines[tlnom].Events[evnom]
    .ReadPhraseText('Comment');
  result := Count - 1;
end;

function TPrintListEvents.FindEvent(tc: longint): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if (tc >= Rows[i].Start) and (tc <= Rows[i].Finish) then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TPrintListEvents.AddLyrics(tlnom, evnom: integer): integer;
var
  strt, fnsh, dur, dur1: longint;
  txt, txt1, txt2: string;
  i, ps, ps1, ps2, wch, cch: integer;
  lml, lmr: boolean;
begin
  lml := false;
  lmr := false;

  if Count <= 0 then
    exit;

  if (TLZone.Timelines[tlnom].Events[evnom].Finish <= TLParameters.Start) then
    exit;
  if (TLZone.Timelines[tlnom].Events[evnom].Start > TLParameters.Finish) then
    exit;

  strt := TLZone.Timelines[tlnom].Events[evnom].Start - TLParameters.Preroll;
  fnsh := TLZone.Timelines[tlnom].Events[evnom].Finish - TLParameters.Preroll;

  ps1 := FindEvent(strt);
  ps2 := FindEvent(fnsh);

  dur := fnsh - strt;
  txt := TLZone.Timelines[tlnom].Events[evnom].ReadPhraseText('Text');
  wch := trunc(dur / length(txt));

  ps1 := FindEvent(strt);
  ps2 := FindEvent(fnsh);

  if (ps1 = -1) and (ps2 = -1) then
  begin
    if Rows[0].Start >= fnsh then
      exit;
    if fnsh >= Rows[Count - 1].Finish then
    begin
      dur1 := Rows[0].Start - strt;
      cch := trunc(dur1 / wch);
      txt := copy(txt, cch + 1, length(txt));
      dur := dur - dur1;
      wch := trunc(dur / length(txt));
      dur1 := fnsh - Rows[Count - 1].Finish;
      cch := length(txt) - trunc(dur1 / wch);
      txt := copy(txt, cch + 1, length(txt));
      dur := dur - dur1;
    end;
    ps1 := 0;
    ps2 := Count - 1;
  end;

  if (ps1 = -1) and (ps2 >= 0) then
    ps1 := 0;

  if (ps1 >= 0) and (ps2 = -1) then
    ps2 := Count - 1;

  // if (TLZone.Timelines[tlnom].Events[ps1].Start < TLParameters.Start) then begin
  // dur1 := Rows[ps1].Finish - strt;
  // cch  := trunc(dur1 / wch);
  // txt  := copy(txt,cch+1, length(txt));
  // lml := true;
  // end;

  // if (TLZone.Timelines[tlnom].Events[ps2].Start < TLParameters.Finish) then begin
  // dur1 := Rows[ps1].Finish - strt;
  // cch  := trunc(dur1 / wch);
  // txt := copy(txt,1,cch);
  // lmr := true;
  // end;

  if ps1 = ps2 then
  begin
    Rows[ps1].Lyrics := Rows[ps1].Lyrics + ' ' + txt;
    exit;
  end;

  if ps1 < ps2 then
  begin
    i := ps1;
    while i < ps2 do
    begin
      dur1 := Rows[i].Finish - strt;
      cch := trunc(dur1 / wch);
      txt1 := copy(txt, 1, cch);
      txt := copy(txt, cch + 1, length(txt));
      if i = ps1 then
        Rows[i].Lyrics := Trim(Rows[i].Lyrics + ' ' + txt1 + '..')
      else
        Rows[i].Lyrics := Trim(Rows[i].Lyrics + ' ..' + txt1 + '..');
      i := i + 1;
      strt := Rows[i].Start;
    end;
    Rows[ps2].Lyrics := Trim(Rows[ps2].Lyrics + ' ..' + txt);
  end;
end;

procedure TPrintListEvents.LoadData(tldev, tltxt: integer; whatload: boolean);
// whatload 0 - Text+Comment; 1 - Text+Lyrics;
var
  i, ps, dlt: integer;
  strt: longint;
begin
  Clear;
  for i := 0 to TLZone.Timelines[tldev].Count - 1 do
  begin
    if TLZone.Timelines[tldev].Events[i].Finish <= TLParameters.Start then
      continue;
    if (TLZone.Timelines[tldev].Events[i].Start <= TLParameters.Start) and
      (TLZone.Timelines[tldev].Events[i].Finish > TLParameters.Start) then
    begin
      dlt := i;
      AddDevice(tldev, i, i - dlt + 1);
      continue;
    end;
    if TLZone.Timelines[tldev].Events[i].Start < TLParameters.Finish then
      AddDevice(tldev, i, i - dlt + 1)
    else
      break;
  end;
  if whatload then
  begin
    for i := 0 to TLZone.Timelines[tltxt].Count - 1 do
      if TLZone.Timelines[tltxt].Events[i].Start < TLParameters.Finish then
        AddLyrics(tltxt, i);
  end;
  if Count = 0 then
    exit;
  for i := 0 to Count - 1 do
    Rows[i].Start := Rows[i].Start - Rows[0].Start;
end;

Constructor TPrintRowEvent.Create;
begin
  Shot := 0;
  Start := 0;
  Finish := 0;
  Duration := 0;
  Device := 0;
  Text := '';
  Comment := '';
  Lyrics := '';
end;

Destructor TPrintRowEvent.Destroy;
begin
  FreeMem(@Shot);
  FreeMem(@Start);
  FreeMem(@Finish);
  FreeMem(@Duration);
  FreeMem(@Device);
  FreeMem(@Text);
  FreeMem(@Comment);
  FreeMem(@Lyrics);
end;

procedure TPrintRowEvent.Assign(tpre: TPrintRowEvent);
begin
  Shot := tpre.Shot;
  Start := tpre.Start;
  Finish := tpre.Finish;
  Duration := tpre.Duration;
  Device := tpre.Device;
  Text := tpre.Text;
  Comment := tpre.Comment;
  Lyrics := tpre.Lyrics;
end;

Constructor TMaketOptions.Create;
begin
  Width := 0;
  Height := 0;
  Left := 0;
  Right := 0;
  Top := 0;
  Bottom := 0;
  mmHorz := 0;
  mmVert := 0;
  RowHeight := 0;
  X1 := 0;
  X2 := 0;
  X3 := 0;
  X4 := 0;
  X5 := 0;
  LowBorder := 0;
end;

Destructor TMaketOptions.Destroy;
begin
  FreeMem(@Width);
  FreeMem(@Height);
  FreeMem(@Left);
  FreeMem(@Right);
  FreeMem(@Top);
  FreeMem(@Bottom);
  FreeMem(@mmHorz);
  FreeMem(@mmVert);
  FreeMem(@RowHeight);
  FreeMem(@X1);
  FreeMem(@X2);
  FreeMem(@X3);
  FreeMem(@X4);
  FreeMem(@X5);
  FreeMem(@LowBorder);
end;

procedure TMaketOptions.SetOptions(tm: TTypeMaket; Prn: TPageParameters);
var
  mmX, mmY: Real;
begin

  if tm = tmScreen then
  begin
    mmX := PrintPageParameters.XScrInMM;
    mmY := PrintPageParameters.YScrInMM;
  end
  else
  begin
    mmX := PrintPageParameters.XPixInMM;
    mmY := PrintPageParameters.YPixInMM;
  end;

  Width := trunc(PrintPageParameters.Width * mmX);
  Height := trunc(PrintPageParameters.Height * mmY);

  if tm = tmScreen then
  begin
    Left := trunc(PrintPageParameters.SpaceLeft * mmX);
    Top := trunc(PrintPageParameters.SpaceTop * mmY);
    Right := trunc(Width - PrintPageParameters.SpaceRight * mmX);
    Bottom := trunc(Height - PrintPageParameters.SpaceBottom * mmY);
  end
  else
  begin
    Left := trunc(PrintPageParameters.SpaceLeft * mmX) +
      PrintPageParameters.PixPrinterOffset.X;
    Top := trunc(PrintPageParameters.SpaceTop * mmY) +
      PrintPageParameters.PixPrinterOffset.Y;
    Right := trunc(Width - PrintPageParameters.SpaceRight * mmX) -
      PrintPageParameters.PixPrinterOffset.X;
    Bottom := trunc(Height - PrintPageParameters.SpaceBottom * mmY) -
      PrintPageParameters.PixPrinterOffset.Y;
  end;

  mmHorz := Round(mmX);
  mmVert := Round(mmY);
  RowHeight := mmVert * 12;

  X1 := Left + 15 * mmHorz;
  X2 := X1 + 20 * mmHorz;;
  X3 := X2 + 20 * mmHorz;;
  X4 := X3 + 15 * mmHorz;
  X5 := X4 + (Right - X4) div 2;

  LowBorder := Bottom - 15 * mmVert;

end;

initialization

MaketOptions := TMaketOptions.Create;
PrintListEvents := TPrintListEvents.Create;

finalization

MaketOptions.FreeInstance;
MaketOptions := nil;
PrintListEvents.FreeInstance;
PrintListEvents := nil;

end.
