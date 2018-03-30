unit UHotKeys;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend,
  ufrhotkeys;

type
  TCellKey = class
    Rect: TRect;
    MainColor: TColor;
    Busycolor: TColor;
    Selectcolor: TColor;
    FontColor: TColor;
    Busy: boolean;
    Select: boolean;
    Notuse: boolean;
    MSelect: boolean;
    MName: string;
    DName: string;
    mkey: byte;
    dkey: byte;
    wordwrap: word;
    // function    GetKey(numstate : boolean) : byte;
    procedure Draw(dib: tfastdib; SelBusy: boolean);
    Constructor Create(Name1, Name2: string; Key1, Key2: byte; Rt: TRect;
      flags: word);
    destructor Destroy;
  end;

  TMainKeyboard = class
    KCtrl: boolean;
    KShift: boolean;
    KAlt: boolean;
    KKey: byte;
    UKCtrl: boolean;
    UKShift: boolean;
    UKAlt: boolean;
    UKKey: byte;
    UKPos: integer;
    Background: TColor;
    Count: integer;
    Keys: array of TCellKey;
    SCount: integer;
    SKeys: array of TCellKey;
    procedure init(Width, Height: integer);
    procedure Draw(cv: tcanvas);
    procedure SetKeySelected(SKeys: string);

    procedure AddStatus(Name1: string; Key1: byte; Rt: TRect; flags: word);
    procedure Add(Name1: string; Key1: byte; Rt: TRect; flags: word); overload;
    procedure Add(Name1, Name2: string; Key1, Key2: byte; Rt: TRect;
      flags: word); overload;
    procedure SetBusy(Nm: string; Value: boolean); overload;
    procedure SetBusy(Kl: byte; Value: boolean); overload;
    procedure SetSelect(Nm: string; Value: boolean); overload;
    procedure SetSelect(Kl: byte; Value: boolean); overload;
    procedure ClearKey(Nm: string); overload;
    procedure ClearKey(Kl: byte); overload;
    procedure ClearBusy;
    procedure ClearSelect;
    procedure ClearAll;
    procedure ClearSelectWithoutControl;
    function GetKeySelection(Name: string): boolean; overload;
    function GetKeySelection(Key: byte): boolean; overload;
    function GetKeyBusy(Name: string): boolean; overload;
    function GetKeyBusy(Key: byte): boolean; overload;
    function GetControlValue: word;
    function KeySelect(Name: string): boolean; overload;
    function KeySelect(Key: byte): boolean; overload;
    function MoveMouse(cv: tcanvas; X, Y: integer): byte;
    function ClickMouse(cv: tcanvas; X, Y: integer): byte;
    procedure SetBusyHotKeys(mode: byte; lst: TMyListHotKeys);
    constructor Create;
    destructor Destroy;
  end;

  TNUMKeyboard = class
    KCtrl: boolean;
    KShift: boolean;
    KAlt: boolean;
    KKey: byte;
    UKCtrl: boolean;
    UKShift: boolean;
    UKAlt: boolean;
    UKKey: byte;
    UKPos: integer;
    MyShift: boolean;
    Background: TColor;
    NumRect: TRect;
    // NumState : boolean;
    Count: integer;
    Keys: array of TCellKey;
    procedure init(Width, Height: integer);
    procedure DrawNumLight(dib: tfastdib);
    procedure Draw(cv: tcanvas);
    procedure SetKeySelected(SKeys: string);
    procedure Add(Name1: string; Key1: byte; Rt: TRect; flags: word); overload;
    procedure Add(Name1, Name2: string; Key1, Key2: byte; Rt: TRect;
      flags: word); overload;
    procedure SetBusy(Nm: string; Value: boolean); overload;
    procedure SetBusy(Kl: byte; Value: boolean); overload;
    procedure SetSelect(Nm: string; Value: boolean); overload;
    procedure SetSelect(Kl: byte; Value: boolean); overload;
    procedure ClearKey(Nm: string); overload;
    procedure ClearKey(Kl: byte); overload;
    procedure ClearBusy;
    procedure ClearSelect;
    procedure ClearAll;
    procedure ClearSelectWithoutControl;
    function GetKeySelection(Name: string): boolean; overload;
    function GetKeySelection(Key: byte): boolean; overload;
    function GetKeyBusy(Name: string): boolean; overload;
    function GetKeyBusy(Key: byte): boolean; overload;
    function GetControlValue: word;
    function KeySelect(Name: string): boolean; overload;
    function KeySelect(Key: byte): boolean; overload;
    function MoveMouse(cv: tcanvas; X, Y: integer): byte;
    function ClickMouse(cv: tcanvas; X, Y: integer): byte;
    procedure SetBusyHotKeys(mode: byte; lst: TMyListHotKeys);
    procedure SwapKeys;
    constructor Create;
    destructor Destroy;
  end;

var
  MyArray: array of tpoint;
  mainkeyboard: TMainKeyboard;
  numkeyboard: TNUMKeyboard;

procedure SetLampState(Key: integer; Value: boolean);

implementation

uses umain, ucommon;

procedure SetLampState(Key: integer; Value: boolean);
var
  KeyState: TKeyboardState;
  abKeyState: array [0 .. 255] of byte;
begin
  // GetKeyboardState(( Addr( abKeyState[ 0 ] ) );
  // abKeyState[ VK_NUMLOCK ] := abKeyState[ VK_NUMLOCK ] or $01;
  // SetKeyboardState( Addr( abKeyState[ 0 ] ) );

  // Var
  // KeyState:  TKeyboardState;
  // begin
  GetKeyboardState(KeyState);
  if (KeyState[VK_NUMLOCK] = 0) then
    KeyState[VK_NUMLOCK] := 1
  else
    KeyState[VK_NUMLOCK] := 0;
  SetKeyboardState(KeyState);
  // end;

  // GetKeyboardState(KeyState);
  // KeyState[Key]:=Integer(Value);
  // SetKeyboardState(KeyState);
  // SetState(VK_NUMLOCK,True); // Включение Num Lock
  // SetState(VK_SCROLL,False); // Включение Scroll Lock
  // SetState(VK_CAPITAL,False); // Включение Caps Lock
end;

// function TColorToTfcolor(Color : TColor) : TFColor;
// Преобразование TColor в RGB
// var Clr : longint;
// begin
// Clr:=ColorToRGB(Color);
// Result.r:=Clr;
// Result.g:=Clr shr 8;
// Result.b:=Clr shr 16;
// end;

// function SmoothColor(color : tcolor; step : integer) : tcolor;
// var cColor: Longint;
// r, g, b: Byte;
// zn : integer;
// rm, gm, bm : Byte;
// begin
// cColor := ColorToRGB(Color);
// r := cColor;
// g := cColor shr 8;
// b := cColor shr 16;
//
// if (r >= g) and (r >= b) then begin
// if (r + step) <= 255 then begin
// r := r + step;
// g := g + step;
// b := b + step;
// end else begin
// if r-step > 0 then r:=r-step else r:=0;
// if g-step > 0 then g:=g-step else g:=0;
// if b-step > 0 then b:=b-step else b:=0;
// end;
// result:=RGB(r,g,b);
// exit;
// end;
//
// if (g >= r) and (g >= b) then begin
// if (g + step) <= 255 then begin
// r := r + step;
// g := g + step;
// b := b + step;
// end else begin
// if r-step > 0 then r:=r-step else r:=0;
// if g-step > 0 then g:=g-step else g:=0;
// if b-step > 0 then b:=b-step else b:=0;
// end;
// result:=RGB(r,g,b);
// exit;
// end;
//
// if (b >= r) and (b >= g) then begin
// if (b + step) <= 255 then begin
// r := r + step;
// g := g + step;
// b := b + step;
// end else begin
// if r-step > 0 then r:=r-step else r:=0;
// if g-step > 0 then g:=g-step else g:=0;
// if b-step > 0 then b:=b-step else b:=0;
// end;
// result:=RGB(r,g,b);
// exit;
// end;
//
// end;

constructor TMainKeyboard.Create;
begin
  KCtrl := false;
  KShift := false;
  KAlt := false;
  KKey := $FF;
  UKCtrl := false;
  UKShift := false;
  UKAlt := false;
  UKKey := $FF;
  UKPos := -1;
  Background := clSilver;
  Count := 0;
  SCount := 0;
end;

destructor TMainKeyboard.Destroy;
var
  i: integer;
begin
  freemem(@KCtrl);
  freemem(@KShift);
  freemem(@KAlt);
  freemem(@KKey);
  freemem(@UKCtrl);
  freemem(@UKShift);
  freemem(@UKAlt);
  freemem(@UKKey);
  freemem(@UKPos);
  freemem(@Background);
  for i := Count - 1 downto 0 do
  begin
    Keys[Count - 1].FreeInstance;
    Count := Count - 1;
    Setlength(Keys, Count);
  end;
  freemem(@Count);
  freemem(@Keys);
  for i := SCount - 1 downto 0 do
  begin
    SKeys[SCount - 1].FreeInstance;
    SCount := SCount - 1;
    Setlength(SKeys, SCount);
  end;
  freemem(@SCount);
  freemem(@SKeys);
end;

procedure TMainKeyboard.AddStatus(Name1: string; Key1: byte; Rt: TRect;
  flags: word);
begin
  SCount := SCount + 1;
  Setlength(SKeys, SCount);
  SKeys[SCount - 1] := TCellKey.Create(Name1, Name1, Key1, Key1, Rt, flags);
end;

procedure TMainKeyboard.Add(Name1: string; Key1: byte; Rt: TRect; flags: word);
begin
  Count := Count + 1;
  Setlength(Keys, Count);
  Keys[Count - 1] := TCellKey.Create(Name1, Name1, Key1, Key1, Rt, flags);
end;

procedure TMainKeyboard.Add(Name1, Name2: string; Key1, Key2: byte; Rt: TRect;
  flags: word);
begin
  Count := Count + 1;
  Setlength(Keys, Count);
  Keys[Count - 1] := TCellKey.Create(Name1, Name2, Key1, Key2, Rt, flags);
end;

procedure TMainKeyboard.init(Width, Height: integer);
var
  dlt, intx, inty, wcell, hcell, drwidth, drheight, endstr: integer;
  Rt, rts: TRect;
begin
  dlt := 100;
  hcell := (Height - 30) div 6;
  wcell := (Width - dlt - 24) div 19;
  if wcell > hcell then
    wcell := hcell
  else
    hcell := wcell;
  drwidth := wcell * 19 + 24;
  drheight := hcell * 6 + 10;
  intx := (Width - drwidth - dlt) div 2;
  inty := (Height - drheight) div 2;
  rts.Left := 20;
  rts.Right := rts.Left + trunc(1.75 * wcell);
  // первая строка
  Rt.Top := inty;
  Rt.Bottom := Rt.Top + hcell;
  Rt.Left := dlt + intx;
  Rt.Right := Rt.Left + wcell;
  Add('Esc', 27, Rt, 0);
  Rt.Left := Rt.Right + wcell;
  Rt.Right := Rt.Left + wcell;
  Add('F1', 112, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F2', 113, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F3', 114, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F4', 115, Rt, 0);
  Rt.Left := Rt.Right + wcell div 2 + 5;
  Rt.Right := Rt.Left + wcell;
  Add('F5', 116, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F6', 117, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F7', 118, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F8', 119, Rt, 0);
  Rt.Left := Rt.Right + wcell div 2 + 5;
  Rt.Right := Rt.Left + wcell;
  Add('F9', 120, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F10', 121, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F11', 122, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  endstr := Rt.Right;
  Add('F12', 123, Rt, 0);

  Rt.Right := dlt + intx + drwidth;
  Rt.Left := Rt.Right - wcell;
  Add('Pause Break', 255, Rt, 3);
  Keys[Count - 1].Notuse := true;
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Scroll Caps', 255, Rt, 2);
  Keys[Count - 1].Notuse := true;
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Print Screen', 255, Rt, 2);
  Keys[Count - 1].Notuse := true;

  // вторая строка
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  rts.Top := Rt.Top;
  rts.Bottom := Rt.Bottom;
  AddStatus('Свободна', 0, rts, 3);
  Rt.Left := dlt + intx;
  Rt.Right := Rt.Left + wcell;
  Add('~', 192, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('1', 49, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('2', 50, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('3', 51, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('4', 52, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('5', 53, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('6', 54, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('7', 55, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('8', 56, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('9', 57, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('0', 48, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('MINUS', 189, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('PLUS', 187, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := endstr; // rt.Left+2*wcell;
  Add('Backspace', 8, Rt, 1);

  Rt.Right := dlt + intx + drwidth;
  Rt.Left := Rt.Right - wcell;
  Add('Page Up', 33, Rt, 3);
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Home', 36, Rt, 3);
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Insert', 45, Rt, 2);

  // третья строка
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  rts.Top := Rt.Top;
  rts.Bottom := Rt.Bottom;
  AddStatus('Занята', 0, rts, 3);
  SKeys[SCount - 1].Busy := true;
  Rt.Left := dlt + intx;
  Rt.Right := Rt.Left + trunc(1.5 * wcell);
  Add('Tab', 9, Rt, 0);
  Keys[Count - 1].Notuse := true;
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('Q', 81, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('W', 87, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('E', 69, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('R', 82, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('T', 84, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('Y', 89, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('U', 85, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('I', 73, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('O', 79, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('P', 80, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('[', 219, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add(']', 221, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := endstr; // rt.Left+trunc(1.5*wcell);
  Add('\', 220, Rt, 0);

  Rt.Right := dlt + intx + drwidth;
  Rt.Left := Rt.Right - wcell;
  Add('Page Down', 35, Rt, 3);
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('End', 35, Rt, 3);
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Delete', 46, Rt, 2);

  // четвертая строка
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  rts.Top := Rt.Top;
  rts.Bottom := Rt.Bottom;
  AddStatus('Выбрана', 0, rts, 3);
  SKeys[SCount - 1].Select := true;
  Rt.Left := dlt + intx;
  Rt.Right := Rt.Left + trunc(1.7 * wcell);
  Add('Caps Lock', 20, Rt, 1);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('A', 65, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('S', 83, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('D', 68, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('F', 70, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('G', 71, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('H', 72, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('J', 74, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('K', 75, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('L', 76, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add(';', 186, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('''', 222, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := endstr; // rt.Left+trunc(2.35*wcell);
  Add('Enter', 13, Rt, 0);

  // пятая строка
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  rts.Top := Rt.Top;
  rts.Bottom := Rt.Bottom;
  AddStatus('Не используется', 0, rts, 2);
  SKeys[SCount - 1].Notuse := true;
  Rt.Left := dlt + intx;
  Rt.Right := Rt.Left + trunc(2.1 * wcell);
  Add('Shift', 16, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('Z', 90, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('X', 88, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('C', 67, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('V', 86, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('B', 66, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('N', 78, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('M', 77, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('<', 188, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('>', 190, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('?', 191, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := endstr; // rt.Left+3*wcell;
  Add('Shift', 16, Rt, 0);

  Rt.Right := dlt + intx + drwidth - wcell - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Up', 38, Rt, 0);

  // Шестая строка
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  Rt.Left := dlt + intx;
  Rt.Right := Rt.Left + 2 * wcell;
  Add('Ctrl', 17, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('Win Left', 91, Rt, 1);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + 2 * wcell;
  Add('Alt', 18, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + trunc(5.4 * wcell);
  Add('Space', 32, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + 2 * wcell;
  Add('Alt', 18, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('Win Right', 93, Rt, 1);
  Rt.Left := Rt.Right + 2;
  Rt.Right := endstr; // rt.Left+2*wcell;
  Add('Ctrl', 17, Rt, 0);

  Rt.Right := dlt + intx + drwidth;
  Rt.Left := Rt.Right - wcell;
  Add('Right', 39, Rt, 3);
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Down', 40, Rt, 3);
  Rt.Right := Rt.Left - 2;
  Rt.Left := Rt.Right - wcell;
  Add('Left', 37, Rt, 0);
end;

procedure TMainKeyboard.SetBusy(Nm: string; Value: boolean);
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm)) = lowercase(trim(s)) then
      Keys[i].Busy := Value;
  end;
end;

procedure TMainKeyboard.SetBusy(Kl: byte; Value: boolean);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Kl = Keys[i].mkey then
      Keys[i].Busy := Value;
  end;
end;

procedure TMainKeyboard.SetSelect(Nm: string; Value: boolean);
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm)) = lowercase(trim(s)) then
      Keys[i].Select := Value;
  end;
end;

procedure TMainKeyboard.SetSelect(Kl: byte; Value: boolean);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Kl = Keys[i].mkey then
      Keys[i].Select := Value;
  end;
end;

procedure TMainKeyboard.ClearKey(Nm: string);
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm)) = lowercase(trim(s)) then
    begin
      Keys[i].Busy := false;
      Keys[i].Select := false;
    end;
  end;
end;

procedure TMainKeyboard.ClearKey(Kl: byte);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Kl = Keys[i].mkey then
    begin
      Keys[i].Busy := false;
      Keys[i].Select := false;
    end;
  end;
end;

procedure TMainKeyboard.ClearBusy;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Keys[i].Busy := false;
end;

procedure TMainKeyboard.ClearSelect;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Keys[i].Select := false;
end;

procedure TMainKeyboard.ClearAll;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    Keys[i].Busy := false;
    Keys[i].Select := false;
  end;
end;

procedure TMainKeyboard.ClearSelectWithoutControl;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if not(Keys[i].mkey in [16, 17, 18]) then
      Keys[i].Select := false;
end;

function TMainKeyboard.GetKeySelection(Name: string): boolean;
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name)) = lowercase(trim(s)) then
    begin
      result := Keys[i].Select;
      exit;
    end;
  end;
end;

function TMainKeyboard.GetKeySelection(Key: byte): boolean;
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    if Key = Keys[i].mkey then
    begin
      result := Keys[i].Select;
      exit;
    end;
  end;
end;

function TMainKeyboard.GetKeyBusy(Name: string): boolean;
var
  i: integer;
  s: string;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name)) = lowercase(trim(s)) then
    begin
      result := Keys[i].Busy;
      exit;
    end;
  end;
end;

function TMainKeyboard.GetKeyBusy(Key: byte): boolean;
var
  i: integer;
  s: string;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    if Key = Keys[i].mkey then
    begin
      result := Keys[i].Busy;
      exit;
    end;
  end;
end;

function TMainKeyboard.GetControlValue: word;
var
  i: integer;
begin
  result := 0;
  if GetKeySelection('CTRL') then
    result := result or $0100;
  if GetKeySelection('SHIFT') then
    result := result or $0200;
  if GetKeySelection('ALT') then
    result := result or $0400;
end;

function TMainKeyboard.KeySelect(Name: string): boolean;
var
  i: integer;
  s: string;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name)) = lowercase(trim(s)) then
    begin
      if Keys[i].Select then
        result := false;
      exit;
    end;
  end;
end;

function TMainKeyboard.KeySelect(Key: byte): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    if Key = Keys[i].mkey then
    begin
      if Keys[i].Select then
        result := false;
      exit;
    end;
  end;
end;

function TMainKeyboard.MoveMouse(cv: tcanvas; X, Y: integer): byte;
var
  i: integer;
begin
  result := 255;
  for i := 0 to Count - 1 do
  begin
    if (X > Keys[i].Rect.Left + 5) and (X < Keys[i].Rect.Right - 5) and
      (Y > Keys[i].Rect.Top + 5) and (Y < Keys[i].Rect.Bottom - 5) then
    begin
      if (not Keys[i].Notuse) or (not Keys[i].Busy) then
      begin
        Keys[i].MSelect := true;
        result := Keys[i].mkey;
      end;
    end
    else
      Keys[i].MSelect := false;
  end;
  // Draw(cv);
end;

function TMainKeyboard.ClickMouse(cv: tcanvas; X, Y: integer): byte;
var
  i: integer;
  bl: boolean;
begin
  result := 255;
  for i := 0 to Count - 1 do
  begin
    if (X > Keys[i].Rect.Left) and (X < Keys[i].Rect.Right) and
      (Y > Keys[i].Rect.Top) and (Y < Keys[i].Rect.Bottom) then
    begin
      if Keys[i].Busy then
        ClearSelectWithoutControl;
      if (not Keys[i].Notuse) and (not Keys[i].Busy) then
      begin
        bl := Keys[i].Select;
        ClearSelectWithoutControl;
        Keys[i].Select := not bl; // Keys[i].Select;
        if Keys[i].mkey in [16, 17, 18] then
          SetSelect(Keys[i].MName, Keys[i].Select);
        if Keys[i].Select then
          result := Keys[i].mkey;
      end;
    end;
    Keys[i].MSelect := false;
  end;
  // Draw(cv);
end;

procedure TMainKeyboard.SetBusyHotKeys(mode: byte; lst: TMyListHotKeys);
var
  i, j: integer;
  ctrl, cmd: word;
begin
  ctrl := GetControlValue;
  for i := 0 to Count - 1 do
    Keys[i].Busy := false;
  for i := 0 to Count - 1 do
  begin
    if not(Keys[i].mkey in [16, 17, 18]) then
    begin
      cmd := ctrl + Keys[i].mkey;
      if mode = 0 then
      begin
        if lst.CommandExists(cmd) then
          Keys[i].Busy := true; // else Keys[i].Busy:=false;
      end
      else
      begin
        if lst.CommandExists(0, cmd) then
          Keys[i].Busy := true; // else Keys[i].Busy:=false;
        if lst.CommandExists(mode, cmd) then
          Keys[i].Busy := true; // else Keys[i].Busy:=false;
      end;
    end;
    application.ProcessMessages;
  end;
end;

procedure TMainKeyboard.Draw(cv: tcanvas);
var
  tmp: tfastdib;
  i: integer;
  Rt: TRect;
begin
  tmp := tfastdib.Create;
  try
    tmp.SetSize(cv.ClipRect.Right - cv.ClipRect.Left,
      cv.ClipRect.Bottom - cv.ClipRect.Top, 32);
    tmp.Clear(TColorToTfcolor(Background));
    tmp.SetBrush(bs_solid, 0, colortorgb(Background));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    UKKey := $FF;
    for i := 0 to Count - 1 do
    begin
      if lowercase(trim(Keys[i].MName)) = 'ctrl' then
        UKCtrl := Keys[i].Select
      else if lowercase(trim(Keys[i].MName)) = 'shift' then
        UKShift := Keys[i].Select
      else if lowercase(trim(Keys[i].MName)) = 'alt' then
        UKAlt := Keys[i].Select;
      if (UKCtrl = KCtrl) and (UKShift = KShift) and (UKAlt = KAlt) and
        (Keys[i].mkey = KKey) and (KKey <> $FF) then
        Keys[i].Draw(tmp, true)
      else
        Keys[i].Draw(tmp, false);
      application.ProcessMessages;
    end;
    for i := 0 to SCount - 1 do
      SKeys[i].Draw(tmp, false);

    Rt.Left := 5;
    Rt.Top := 5;
    Rt.Right := 80;
    Rt.Bottom := 55;
    tmp.SetTextColor(colortorgb(clBlack));
    tmp.SetFont(KEYFontName, 12);
    tmp.DrawText('Основная клавиатура', Rt, DT_LEFT or DT_WORDBREAK);
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
  end;
end;

procedure TMainKeyboard.SetKeySelected(SKeys: string);
var
  ps: integer;
  s: string;
begin
  try
    s := uppercase(trim(SKeys));
    if s = '' then
    begin
      KCtrl := false;
      KShift := false;
      KAlt := false;
      KKey := $FF;
      exit;
    end;
    ps := pos('CTRL', s);
    if ps <> 0 then
      KCtrl := true
    else
      KCtrl := false;
    ps := pos('SHIFT', s);
    if ps <> 0 then
      KShift := true
    else
      KShift := false;
    ps := pos('ALT', s);
    if ps <> 0 then
      KAlt := true
    else
      KAlt := false;
    s := stringreplace(s, 'ctrl', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, 'shift', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, 'alt', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, '+', '', [rfReplaceAll, rfIgnoreCase]);
    if trim(s) <> '' then
    begin
      ClearSelect;
      SetSelect('ctrl', KCtrl);
      SetSelect('shift', KShift);
      SetSelect('alt', KAlt);
      KKey := NameToKey(s);
      SetSelect(s, true);
    end;
  except
  end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TCellKey.Create(Name1, Name2: string; Key1, Key2: byte; Rt: TRect;
  flags: word);
begin
  Rect.Left := Rt.Left;
  Rect.Top := Rt.Top;
  Rect.Right := Rt.Right;
  Rect.Bottom := Rt.Bottom;
  MainColor := clBlack;
  Busycolor := clRed;
  Selectcolor := clGreen;
  FontColor := clWhite;
  Busy := false;
  Select := false;
  MName := Name1;
  DName := Name2;
  mkey := Key1;
  dkey := Key2;
  Notuse := false;
  MSelect := false;
  wordwrap := flags;
end;

destructor TCellKey.Destroy;
begin
  freemem(@Rect.Left);
  freemem(@Rect.Top);
  freemem(@Rect.Right);
  freemem(@Rect.Bottom);
  freemem(@MainColor);
  freemem(@Busycolor);
  freemem(@Selectcolor);
  freemem(@FontColor);
  freemem(@Busy);
  freemem(@Select);
  freemem(@MName);
  freemem(@mkey);
  freemem(@DName);
  freemem(@dkey);
  freemem(@Notuse);
  freemem(@MSelect);
  freemem(@wordwrap);
end;

procedure TCellKey.Draw(dib: tfastdib; SelBusy: boolean);
var
  ps, len, fnwdt, fnhgt: integer;
  Rt: TRect;
  s1, s2: string;
begin

  if Notuse then
    dib.SetBrush(bs_solid, 0, colortorgb(SmoothColor(MainColor, 100)))
  else if Busy then
  begin
    if SelBusy then
      dib.SetBrush(bs_solid, 0, colortorgb(SmoothColor(Selectcolor, 96)))
    else
      dib.SetBrush(bs_solid, 0, colortorgb(Busycolor));
  end
  else if Select then
    dib.SetBrush(bs_solid, 0, colortorgb(Selectcolor))
  else
    dib.SetBrush(bs_solid, 0, colortorgb(MainColor));
  dib.SetPen(ps_solid, 2, colortorgb(MainColor));
  dib.FillRect(Rect);
  if MSelect then
  begin
    dib.SetPen(ps_solid, 3, colortorgb(SmoothColor(MainColor, 164)));
  end
  else
  begin
    dib.SetPen(ps_solid, 2, colortorgb(MainColor));
  end;
  dib.Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
  if trim(MName) = '' then
    len := 1
  else
    len := length(trim(MName));
  if (Rect.Bottom - Rect.Top) >= 2 * (Rect.Right - Rect.Left) then
  begin
    fnwdt := (Rect.Right - Rect.Left - 4) div len;
    fnhgt := (Rect.Right - Rect.Left) div 2 - 2;
  end
  else
  begin
    fnwdt := (Rect.Right - Rect.Left - 4) div len;
    fnhgt := (Rect.Bottom - Rect.Top) div 2 - 2;
  end;

  // dib.SetFontEx(KeyFontName,fnwdt,fnhgt,1,false,false,false);
  // dib.SetTextColor(colortorgb(FontColor));

  if (wordwrap = 0) or (wordwrap = 1) then
  begin
    dib.SetFont(KEYFontName, fnhgt);
    dib.SetTextColor(colortorgb(FontColor));
  end
  else
  begin
    s2 := trim(MName);
    ps := pos(' ', s2);
    if ps <> 0 then
    begin
      s1 := trim(copy(s2, 1, ps - 1));
      s2 := trim(copy(s2, ps + 1, length(s2)));
      if length(s1) > length(s2) then
        len := length(s1)
      else
        len := length(s2);
    end
    else
      len := length(s2);
    if wordwrap = 2 then
      fnwdt := (Rect.Right - Rect.Left - 6) div len
    else
      fnwdt := (Rect.Right - Rect.Left - 10) div (len + 1);
    dib.SetFontEx(KEYFontName, fnwdt, fnhgt, 1, false, false, false);
  end;

  Rt.Left := Rect.Left + 2;
  Rt.Top := Rect.Top + 2;
  Rt.Right := Rect.Right - 2;
  Rt.Bottom := Rect.Bottom - 2;
  s1 := MName;
  if lowercase(trim(s1)) = 'minus' then
    s1 := '-';
  if lowercase(trim(s1)) = 'plus' then
    s1 := '+';
  if lowercase(trim(s1)) = 'numpadminus' then
    s1 := '-';
  if lowercase(trim(s1)) = 'numpadplus' then
    s1 := '+';
  if lowercase(trim(s1)) = 'numpadmult' then
    s1 := '*';
  if lowercase(trim(s1)) = 'numpaddiv' then
    s1 := '/';
  if lowercase(trim(s1)) = 'numpadpoint' then
    s1 := '.';
  if lowercase(trim(s1)) = 'numpad0' then
    s1 := '0';
  if lowercase(trim(s1)) = 'numpad1' then
    s1 := '1';
  if lowercase(trim(s1)) = 'numpad2' then
    s1 := '2';
  if lowercase(trim(s1)) = 'numpad3' then
    s1 := '3';
  if lowercase(trim(s1)) = 'numpad4' then
    s1 := '4';
  if lowercase(trim(s1)) = 'numpad5' then
    s1 := '5';
  if lowercase(trim(s1)) = 'numpad6' then
    s1 := '6';
  if lowercase(trim(s1)) = 'numpad7' then
    s1 := '7';
  if lowercase(trim(s1)) = 'numpad8' then
    s1 := '8';
  if lowercase(trim(s1)) = 'numpad9' then
    s1 := '9';
  if lowercase(trim(s1)) = '\' then
    s1 := '|';
  if wordwrap = 0 then
    dib.DrawText(trim(s1), Rt, DT_CENTER)
  else
    dib.DrawText(trim(s1), Rt, DT_CENTER or DT_WORDBREAK);
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// function decodecommand(s : string) : tpoint;
// var ps : integer;
// s1, s2 : string;
// begin
// ps := pos('=',s);
// s1 := copy(s,1,ps-1);
// s2 := copy(s,ps+1,length(s));
// result.X:=strtoint(s1);
// result.Y:=strtoint(s2);
// end;

// procedure LoadCommandKeys(FN : string);
// var i : integer;
// lst : tstrings;
// begin
// if not FileExists(FN) then exit;
//
// lst := tstringlist.Create;
// lst.Clear;
// try
// lst.LoadFromFile(FN);
// Setlength(MyArray,lst.Count);
// for i:=0 to lst.Count-1 do begin
// MyArray[i]:=DecodeCommand(lst.Strings[i]);
// end;
// finally
// lst.Free;
// end;
// end;

// function selectcommand(cmd : word; mp : array of tpoint) : integer;
// var i : integer;
// begin
// result:=-1;
// for i:=0 to High(mp)-1 do begin
// if mp[i].Y=cmd then begin
// result := mp[i].X;
// exit;
// end;
// end;
// end;

// fn := extractfilepath(Application.ExeName) + 'ListKeys.keys';
// Memo1.Lines.SaveToFile(fn);

// fn := extractfilepath(Application.ExeName) + 'ListKeys.keys';
// if Fileexists(fn) then LoadCommandKeys(fn);

// if trim(Edit2.Text)='' then Edit2.Text:='0';
// key := strtoint(Edit2.Text);
// if (key and $0100)<>0 then s:='CTRL';
// if (key and $0200)<>0 then s:=addplus(s) + 'SHIFT';
// if (key and $0400)<>0 then s:=addplus(s) + 'ALT';
// bt:=key and $00FF;
// s:=addplus(s) + chr(bt);
// Label15.Caption:=s;

constructor TNUMKeyboard.Create;
begin
  KCtrl := false;
  KShift := false;
  KAlt := false;
  KKey := $FF;
  UKCtrl := false;
  UKShift := false;
  UKAlt := false;
  UKKey := $FF;
  UKPos := -1;
  Background := clSilver;
  Count := 0;
  NumRect.Left := 0;
  NumRect.Top := 0;
  NumRect.Right := 0;
  NumRect.Bottom := 0;
  MyShift := false;
end;

destructor TNUMKeyboard.Destroy;
var
  i: integer;
begin
  freemem(@KCtrl);
  freemem(@KShift);
  freemem(@KAlt);
  freemem(@KKey);
  freemem(@UKCtrl);
  freemem(@UKShift);
  freemem(@UKAlt);
  freemem(@UKKey);
  freemem(@UKPos);
  freemem(@Background);
  freemem(@NumRect);
  for i := Count - 1 downto 0 do
  begin
    Keys[Count - 1].FreeInstance;
    Count := Count - 1;
    Setlength(Keys, Count);
  end;
  freemem(@Count);
  freemem(@Keys);
  freemem(@MyShift);
end;

procedure TNUMKeyboard.Add(Name1: string; Key1: byte; Rt: TRect; flags: word);
begin
  Count := Count + 1;
  Setlength(Keys, Count);
  Keys[Count - 1] := TCellKey.Create(Name1, Name1, Key1, Key1, Rt, flags);
end;

procedure TNUMKeyboard.Add(Name1, Name2: string; Key1, Key2: byte; Rt: TRect;
  flags: word);
begin
  Count := Count + 1;
  Setlength(Keys, Count);
  Keys[Count - 1] := TCellKey.Create(Name1, Name2, Key1, Key2, Rt, flags);
end;

procedure TNUMKeyboard.init(Width, Height: integer);
var
  dlt, intx, inty, wcell, hcell, drwidth, drheight, endstr: integer;
  Rt, rts: TRect;
begin
  // dlt:=100;

  hcell := (Height - 30) div 6;
  wcell := (Width - 24) div 6;
  if wcell > hcell then
    wcell := hcell
  else
    hcell := wcell;
  drwidth := wcell * 6 + 10;
  drheight := hcell * 6 + 10;
  intx := (Width - drwidth) div 2;
  inty := (Height - drheight) div 2;
  NumRect.Left := intx + 2 * wcell + 4;
  NumRect.Right := NumRect.Left + trunc(3 * wcell);
  NumRect.Top := inty;
  NumRect.Bottom := NumRect.Top + hcell;
  // первая строка
  // rt.Left:=intx;
  // rt.Right:=rt.Left+trunc(1.7*wcell);
  Rt.Top := NumRect.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  // Add('Shift',16,rt,0);
  Rt.Left := NumRect.Left;
  Rt.Right := Rt.Left + wcell;
  Add('Num', 144, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPADDIV', 111, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPADMULT', 106, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPADMINUS', 109, Rt, 0);

  // вторая строка
  Rt.Left := intx;
  Rt.Right := Rt.Left + trunc(1.7 * wcell);
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  Add('Shift', 16, Rt, 0);
  Rt.Left := NumRect.Left;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD7', 'Home', 103, 36, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD8', 'UP', 104, 38, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD9', 'Page Up', 105, 33, Rt, 1);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  rts.Left := Rt.Left;
  rts.Top := Rt.Top;
  rts.Right := Rt.Right;
  rts.Bottom := Rt.Top + 2 * hcell + 2;
  Add('NUMPADPLUS', 107, rts, 0);
  // третья строка
  Rt.Left := intx;
  Rt.Right := Rt.Left + trunc(1.7 * wcell);
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  Add('Ctrl', 17, Rt, 0);
  Rt.Left := NumRect.Left;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD4', 'Left', 100, 37, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD5', '', 101, 255, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD6', 'Right', 102, 39, Rt, 0);

  // четвертая строка
  Rt.Left := intx;
  Rt.Right := Rt.Left + trunc(1.7 * wcell);
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  Add('Alt', 18, Rt, 0);
  // rt.Top := rt.Bottom+2;
  // rt.Bottom := rt.Top+hcell;
  Rt.Left := NumRect.Left;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD1', 'End', 97, 35, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD2', 'Down', 98, 40, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPAD3', 'Page Down', 99, 34, Rt, 1);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  rts.Left := Rt.Left;
  rts.Top := Rt.Top;
  rts.Right := Rt.Right;
  rts.Bottom := Rt.Top + 2 * hcell + 2;
  Add('Enter', 13, rts, 0);

  // пятая строка
  Rt.Top := Rt.Bottom + 2;
  Rt.Bottom := Rt.Top + hcell;
  Rt.Left := NumRect.Left;
  Rt.Right := Rt.Left + 2 * wcell + 2;
  Add('NUMPAD0', 'Insert', 96, 45, Rt, 0);
  Rt.Left := Rt.Right + 2;
  Rt.Right := Rt.Left + wcell;
  Add('NUMPADPOINT', 'Delete', 110, 46, Rt, 2);
end;

procedure TNUMKeyboard.SetBusy(Nm: string; Value: boolean);
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm)) = lowercase(trim(s)) then
      Keys[i].Busy := Value;
  end;
end;

procedure TNUMKeyboard.SetBusy(Kl: byte; Value: boolean);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Kl = Keys[i].mkey then
      Keys[i].Busy := Value;
  end;
end;

procedure TNUMKeyboard.SetSelect(Nm: string; Value: boolean);
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm)) = lowercase(trim(s)) then
      Keys[i].Select := Value;
  end;
end;

procedure TNUMKeyboard.SetSelect(Kl: byte; Value: boolean);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Kl = Keys[i].mkey then
      Keys[i].Select := Value;
  end;
end;

procedure TNUMKeyboard.ClearKey(Nm: string);
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm)) = lowercase(trim(s)) then
    begin
      Keys[i].Busy := false;
      Keys[i].Select := false;
    end;
  end;
end;

procedure TNUMKeyboard.ClearKey(Kl: byte);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Kl = Keys[i].mkey then
    begin
      Keys[i].Busy := false;
      Keys[i].Select := false;
    end;
  end;
end;

procedure TNUMKeyboard.ClearBusy;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if lowercase(trim(Keys[i].MName)) <> 'num' then
      Keys[i].Busy := false;
end;

procedure TNUMKeyboard.ClearSelect;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if lowercase(trim(Keys[i].MName)) <> 'num' then
      Keys[i].Select := false;
  end;
end;

procedure TNUMKeyboard.ClearAll;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if lowercase(trim(Keys[i].MName)) <> 'num' then
    begin
      Keys[i].Busy := false;
      Keys[i].Select := false;
    end;
  end;
end;

procedure TNUMKeyboard.ClearSelectWithoutControl;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if not(Keys[i].mkey in [16, 17, 18]) then
    begin
      if lowercase(trim(Keys[i].MName)) <> 'num' then
        Keys[i].Select := false;
    end;
  end;
end;

function TNUMKeyboard.GetKeySelection(Name: string): boolean;
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name)) = lowercase(trim(s)) then
    begin
      result := Keys[i].Select;
      exit;
    end;
  end;
end;

function TNUMKeyboard.GetKeySelection(Key: byte): boolean;
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    if Key = Keys[i].mkey then
    begin
      result := Keys[i].Select;
      exit;
    end;
  end;
end;

function TNUMKeyboard.GetKeyBusy(Name: string): boolean;
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name)) = lowercase(trim(s)) then
    begin
      result := Keys[i].Busy;
      exit;
    end;
  end;
end;

function TNUMKeyboard.GetKeyBusy(Key: byte): boolean;
var
  i: integer;
  s: string;
begin
  for i := 0 to Count - 1 do
  begin
    if Key = Keys[i].mkey then
    begin
      result := Keys[i].Busy;
      exit;
    end;
  end;
end;

function TNUMKeyboard.GetControlValue: word;
var
  i: integer;
begin
  result := 0;
  if GetKeySelection('CTRL') then
    result := result or $0100;
  if GetKeySelection('SHIFT') then
    result := result or $0200;
  if GetKeySelection('ALT') then
    result := result or $0400;
end;

function TNUMKeyboard.KeySelect(Name: string): boolean;
var
  i: integer;
  s: string;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    s := stringreplace(Keys[i].MName, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name)) = lowercase(trim(s)) then
    begin
      if Keys[i].Select then
        result := false;
      exit;
    end;
  end;
end;

function TNUMKeyboard.KeySelect(Key: byte): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    if Key = Keys[i].mkey then
    begin
      if Keys[i].Select then
        result := false;
      exit;
    end;
  end;
end;

function TNUMKeyboard.MoveMouse(cv: tcanvas; X, Y: integer): byte;
var
  i: integer;
begin
  result := 255;
  for i := 0 to Count - 1 do
  begin
    if (X > Keys[i].Rect.Left) and (X < Keys[i].Rect.Right) and
      (Y > Keys[i].Rect.Top) and (Y < Keys[i].Rect.Bottom) then
    begin
      if (not Keys[i].Notuse) or (not Keys[i].Busy) then
      begin
        Keys[i].MSelect := true;
        result := Keys[i].mkey;
      end;
    end
    else
      Keys[i].MSelect := false;
  end;
  // Draw(cv);
end;

function TNUMKeyboard.ClickMouse(cv: tcanvas; X, Y: integer): byte;
var
  i: integer;
  bl: boolean;
begin
  result := 255;
  for i := 0 to Count - 1 do
  begin
    if (X > Keys[i].Rect.Left) and (X < Keys[i].Rect.Right) and
      (Y > Keys[i].Rect.Top) and (Y < Keys[i].Rect.Bottom) then
    begin
      if Keys[i].Busy then
        ClearSelectWithoutControl;
      if (not Keys[i].Notuse) and (not Keys[i].Busy) then
      begin
        bl := Keys[i].Select;
        ClearSelectWithoutControl;
        Keys[i].Select := not bl;
        if Keys[i].mkey in [16, 17, 18] then
          SetSelect(Keys[i].MName, Keys[i].Select);
        if Keys[i].Select then
          result := Keys[i].mkey;
      end;
    end;
    Keys[i].MSelect := false;
  end;
  // Draw(cv);
end;

procedure TNUMKeyboard.SwapKeys;
var
  i: integer;
  bt: byte;
  s: string;
  need: boolean;
begin
  need := false;

  if GetKeyState(VK_NUMLOCK) = 1 then
  begin
    numkeyboard.SetSelect('NUM', true);
    if GetKeySelection(16) then
    begin
      if Keys[6].mkey > 80 then
        need := true;
    end
    else if (Keys[6].mkey < 80) then
      need := true;
  end
  else
  begin
    numkeyboard.SetSelect('NUM', false);
    if Keys[6].mkey > 80 then
      need := true;
  end;

  if need then
  begin
    for i := 0 to Count - 1 do
    begin
      bt := Keys[i].mkey;
      Keys[i].mkey := Keys[i].dkey;
      Keys[i].dkey := bt;
      s := Keys[i].MName;
      Keys[i].MName := Keys[i].DName;
      Keys[i].DName := s;
    end;
  end;
end;

procedure TNUMKeyboard.SetBusyHotKeys(mode: byte; lst: TMyListHotKeys);
var
  i, j: integer;
  ctrl, cmd: word;
begin
  ctrl := GetControlValue;
  for i := 0 to Count - 1 do
    Keys[i].Busy := false;
  for i := 0 to Count - 1 do
  begin
    if not(Keys[i].mkey in [16, 17, 18]) then
    begin
      cmd := ctrl + Keys[i].mkey;
      if mode = 0 then
      begin
        if lst.CommandExists(cmd) then
          Keys[i].Busy := true; // else Keys[i].Busy:=false;
      end
      else
      begin
        if lst.CommandExists(0, cmd) then
          Keys[i].Busy := true; // else Keys[i].Busy:=false;
        if lst.CommandExists(mode, cmd) then
          Keys[i].Busy := true; // else Keys[i].Busy:=false;
      end;
    end;
    application.ProcessMessages;
  end;
end;

procedure TNUMKeyboard.DrawNumLight(dib: tfastdib);
var
  rtp, rtl, rtn: TRect;
  ww, hh, psw, psh: integer;
begin
  ww := (NumRect.Right - NumRect.Left) div 2;
  hh := (NumRect.Bottom - NumRect.Top) div 2;
  rtp.Left := NumRect.Left + (ww - hh) div 2;
  rtp.Right := rtp.Left + hh;
  rtp.Top := NumRect.Top;
  rtp.Bottom := rtp.Top + hh;
  rtl.Left := rtp.Right + 2;
  rtl.Right := NumRect.Right;
  rtl.Top := rtp.Top;
  rtl.Bottom := rtp.Bottom;
  rtn.Left := NumRect.Left;
  rtn.Right := rtn.Left + ww;
  rtn.Top := rtp.Bottom;
  rtn.Bottom := NumRect.Bottom;
  dib.SetFont(KEYFontName, hh - 2);
  dib.DrawText('Num Lock', rtn, DT_CENTER);
  if GetKeyState(VK_NUMLOCK) = 1 then
  begin
    dib.SetBrush(bs_solid, 0, colortorgb(clLime));
    // dib.DrawText('On', rtl, DT_Left);
    // Label11.Caption := 'On'
  end
  else
  begin
    dib.SetBrush(bs_solid, 0, colortorgb(SmoothColor(clBlack, 100)));
    // dib.DrawText('Off', rtl, DT_Left);
    // Label11.Caption := 'Off';
  end;
  dib.Ellipse(rtp.Left, rtp.Top, rtp.Right, rtp.Bottom);
end;

procedure TNUMKeyboard.Draw(cv: tcanvas);
var
  tmp: tfastdib;
  i: integer;
  Rt: TRect;
begin
  tmp := tfastdib.Create;
  try
    tmp.SetSize(cv.ClipRect.Right - cv.ClipRect.Left,
      cv.ClipRect.Bottom - cv.ClipRect.Top, 32);
    tmp.Clear(TColorToTfcolor(Background));
    tmp.SetBrush(bs_solid, 0, colortorgb(Background));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    for i := 0 to Count - 1 do
    begin
      if lowercase(trim(Keys[i].MName)) = 'ctrl' then
        UKCtrl := Keys[i].Select
      else if lowercase(trim(Keys[i].MName)) = 'shift' then
        UKShift := Keys[i].Select
      else if lowercase(trim(Keys[i].MName)) = 'alt' then
        UKAlt := Keys[i].Select;
      if (UKCtrl = KCtrl) and (UKShift = KShift) and (UKAlt = KAlt) and
        (Keys[i].mkey = KKey) and (KKey <> $FF) then
        Keys[i].Draw(tmp, true)
      else
        Keys[i].Draw(tmp, false);
      application.ProcessMessages;
      // Keys[i].Draw(tmp,false);
      // application.ProcessMessages;
    end;
    Rt.Left := 5;
    Rt.Top := 5;
    Rt.Right := 80;
    Rt.Bottom := 55;
    tmp.SetTextColor(colortorgb(clBlack));
    tmp.SetFont(KEYFontName, 12);
    tmp.DrawText('Дополнительная клавиатура', Rt, DT_LEFT or DT_WORDBREAK);
    DrawNumLight(tmp);
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
  end;
end;

procedure TNUMKeyboard.SetKeySelected(SKeys: string);
var
  ps: integer;
  s: string;
begin
  try
    s := uppercase(trim(SKeys));
    if s = '' then
    begin
      KCtrl := false;
      KShift := false;
      KAlt := false;
      KKey := $FF;
      exit;
    end;
    ps := pos('CTRL', s);
    if ps <> 0 then
      KCtrl := true
    else
      KCtrl := false;
    ps := pos('SHIFT', s);
    if ps <> 0 then
      KShift := true
    else
      KShift := false;
    ps := pos('ALT', s);
    if ps <> 0 then
      KAlt := true
    else
      KAlt := false;
    s := stringreplace(s, 'ctrl', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, 'shift', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, 'alt', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, ' ', '', [rfReplaceAll, rfIgnoreCase]);
    s := stringreplace(s, '+', '', [rfReplaceAll, rfIgnoreCase]);
    if trim(s) <> '' then
    begin
      ClearSelect;
      SetSelect('ctrl', KCtrl);
      SetSelect('shift', KShift);
      SetSelect('alt', KAlt);
      KKey := NameToKey(s);
      SetSelect(s, true);
    end;
  except
  end;
end;

end.
