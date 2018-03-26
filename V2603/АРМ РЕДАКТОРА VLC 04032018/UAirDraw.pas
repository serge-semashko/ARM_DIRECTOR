unit UAirDraw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer, MMSystem, strutils;

Type

  TRectDevice = Class(TObject)
  public
    Number: integer;
    JsonData: string;
    Value: longint;
    Curr: boolean;
    next: boolean;
    Text: String;
    Color: tcolor;
    Rect: Trect;
    procedure Draw(cv: tcanvas);
    Procedure SaveToJson;
    Constructor Create;
    Destructor Destroy;
  end;

  TAirDevices = Class(TObject)
  public
    BackGround: tcolor;
    Rect: Trect;
    Count: integer;
    Devices: array of TRectDevice;
    function AddDevice(Color: tcolor): integer;
    // procedure SetValues;
    procedure Init(cv: tcanvas; grpos: integer);
    procedure Draw(cv: tcanvas);
    procedure Clear;
    Constructor Create;
    Destructor Destroy;
  end;

  TAirOneEvent = Class(TObject)
  public
    BackGround: tcolor;
    JsonData: string;
    ForeGround: tcolor;
    ColorTimeline: tcolor;
    ColorEvent: tcolor;
    Number: integer;
    Text: string;
    Dev: integer;
    Start: longint;
    Finish: longint;
    Duration: longint;
    Interval: integer;
    Mix: longint;
    Rect: Trect;
    ROrder: Trect;
    RNumber: Trect;
    RSecond: Trect;
    REvent: Trect;
    procedure AssignEvent(ps: integer; Curr: boolean);
    procedure Clear;
    function Init(cv: tcanvas; tp, hgh, intrv, sz1, sz2, sz3,
      sz0: integer): integer;
    procedure Draw(cv: tcanvas; ps: integer);
    Procedure DrawText(cv: tcanvas);
    Procedure SaveToJson;
    Procedure LoadFromJson(jsonstr: string);
    Procedure SendHTTPOneEvent(nom: integer);
    Constructor Create;
    Destructor Destroy;
  end;

  TAirSecond = Class(TObject)
  public
    BackGround: tcolor;
    ForeGround: tcolor;
    Color: tcolor;
    Start: longint;
    Finish: longint;
    Duration: longint;
    Mix: longint;
    Rect: Trect;
    RTC: Trect;
    RSecond: Trect;
    procedure AssignEvent(ps: integer; Curr: boolean);
    function Init(cv: tcanvas; tp, hgh, sz0: integer): integer;
    procedure Draw(cv: tcanvas);
    procedure DrawSeconds(cv: tcanvas);
    Constructor Create;
    Destructor Destroy;
    procedure SendHttp;
  end;

  TAirEvents = Class(TObject)
  public
    BackGround: tcolor;
    ForeGround: tcolor;
    Interval: integer;
    CurrEvent: TAirOneEvent;
    CurrTime: TAirSecond;
    Count: integer;
    Events: array of TAirOneEvent;
    procedure Clear;
    function AddEvent: integer;
    procedure Init(cv: tcanvas);
    procedure Draw(cv: tcanvas);
    procedure DrawTimeCode(cv: tcanvas; tc: longint);
    Constructor Create;
    Destructor Destroy;
  end;

  TPanelAir = Class(TObject)
  public
    AirEvents: TAirEvents;
    AirDevices: TAirDevices;
    ExportInProgress: boolean;
    procedure SetValues;
    procedure SetValues_40mc;
    procedure SendHTTPDevice;
    procedure SendHTTPEvents;
    procedure Draw(cv1, cv2: tcanvas; grpos: integer);
    Constructor Create;
    Destructor Destroy;
  end;

var
  MyPanelAir: TPanelAir;

implementation

uses umain, ucommon, ugrtimelines, utimeline, udrawtimelines, uwebserv,uwebget,
  umyfiles, system.json;

Function GetDeviceValueS(nom: integer): longint;
var
  delzn, mainzn, addzn: longint;
begin
  with form1 do
  begin
    delzn := TLZone.TLEditor.Events[nom].Start - TLParameters.Position;
    mainzn := trunc(delzn / 25);
    addzn := mainzn * 25;
    if (delzn - addzn) > 0 then
      result := mainzn + 1
    else
      result := mainzn;
  end;
end;

Function GetDeviceValueF(nom: integer): longint;
var
  delzn, mainzn, addzn: longint;
begin
  with form1 do
  begin
    delzn := TLZone.TLEditor.Events[nom].Finish - TLParameters.Position;
    mainzn := trunc(delzn / 25);
    addzn := mainzn * 25;
    if (delzn - addzn) > 0 then
      result := mainzn + 1
    else
      result := mainzn;
  end;
end;

Function GetEventValue(strt, fnsh: longint): longint;
var
  delzn, mainzn, addzn: longint;
begin
  with form1 do
  begin
    delzn := fnsh - strt;
    mainzn := trunc(delzn / 25);
    addzn := mainzn * 25;
    if (delzn - addzn) > 0 then
      result := mainzn + 1
    else
      result := mainzn;
  end;
end;

// ==============================================================================
// =========== Класс TAirOneEvent рисуем одно событие ===========================
// ==============================================================================
Function CTHTML(clr: tcolor): string;
var
  r, g, b: integer;
begin
  r := getrvalue(clr);
  g := getgvalue(clr);
  b := getbvalue(clr);
  result := Format('#%.2x%.2x%.2x', [r, g, b]);
end;

Constructor TAirOneEvent.Create;
begin
  inherited;
  BackGround := AirBackGround; // ProgrammColor;
  if AirBackGround = AirForeGround then
  begin
    ForeGround := SmoothColor(AirBackGround, 16);
    ColorTimeline := SmoothColor(AirBackGround, 48);
  end
  else
  begin
    ForeGround := AirForeGround;
    ColorTimeline := AirColorTimeline;
  end;
  // ForeGround := SmoothColor(AirBackGround, 16);//SmoothColor(ProgrammColor, 16);
  // ColorTimeline := SmoothColor(AirBackGround, 48);//SmoothColor(ProgrammColor, 48);
  ColorEvent := ForeGround;
  Number := -1;
  Text := '';
  Dev := -1;
  Start := -1;
  Finish := -1;
  Duration := -1;
  Interval := -1;
  Mix := 0;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  ROrder.Left := 0;
  ROrder.Right := 0;
  ROrder.Top := 0;
  ROrder.Bottom := 0;
  RNumber.Left := 0;
  RNumber.Right := 0;
  RNumber.Top := 0;
  RNumber.Bottom := 0;
  RSecond.Left := 0;
  RSecond.Right := 0;
  RSecond.Top := 0;
  RSecond.Bottom := 0;
  REvent.Left := 0;
  REvent.Right := 0;
  REvent.Top := 0;
  REvent.Bottom := 0;
end;

destructor TAirOneEvent.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@ForeGround);
  FreeMem(@ColorTimeline);
  FreeMem(@ColorEvent);
  FreeMem(@Number);
  FreeMem(@Text);
  FreeMem(@Dev);
  FreeMem(@Start);
  FreeMem(@Finish);
  FreeMem(@Duration);
  FreeMem(@Interval);
  FreeMem(@Mix);
  FreeMem(@Rect);
  FreeMem(@ROrder);
  FreeMem(@RNumber);
  FreeMem(@RSecond);
  FreeMem(@REvent);
  inherited;
end;

procedure TAirOneEvent.SaveToJson;
var
  json: tjsonobject;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)
  function getVariableFromJson(varName: string; varvalue: string): boolean;
  var
    tmpjson: tjsonvalue;
  begin
    tmpjson := json.GetValue(varName);
    if (tmpjson <> nil) then
    begin

    end;

  end;
// Procedure addVariableToJson(varName: string; varvalue: string);
// var
// teststr: ansistring;
// list: TStringList;
// numElement: integer;
// utf8val: string;
// tmpjson: tjsonvalue;
// retval: string;
// begin
// utf8val := stringOf(tencoding.UTF8.GetBytes(varvalue));
// varvalue := varvalue;
// json.AddPair(varName, varvalue);
// tmpjson := json.GetValue(varName);
// tmpjson := json.GetValue(varName + ' ');
// end;

begin
  json := tjsonobject.Create;
  try
    addVariableToJson(json, 'BackGround', CTHTML(ColorToRgb(BackGround)));
    addVariableToJson(json, 'ForeGround', CTHTML(ColorToRgb(ForeGround)));
    addVariableToJson(json, 'Interval', inttostr(Interval));
    addVariableToJson(json, 'fsize', inttostr(TLParameters.FrameSize));
    addVariableToJson(json, 'sf5',
      CTHTML(ColorToRgb(SmoothColor(ForeGround, 5))));
    addVariableToJson(json, 'sb5', CTHTML(SmoothColor(BackGround, 5)));
    addVariableToJson(json, 'sct25',
      CTHTML(ColorToRgb(SmoothColor(ColorTimeline, 25))));
    addVariableToJson(json, 'sct56',
      CTHTML(ColorToRgb(SmoothColor(ColorTimeline, 56))));

    addVariableToJson(json, 'eTop', inttostr(REvent.Top));
    addVariableToJson(json, 'eLeft', inttostr(REvent.Left));
    addVariableToJson(json, 'eRight', inttostr(REvent.Right));
    addVariableToJson(json, 'eBottom', inttostr(REvent.Bottom));

    addVariableToJson(json, 'nTop', inttostr(RNumber.Top));
    addVariableToJson(json, 'nLeft', inttostr(RNumber.Left));
    addVariableToJson(json, 'nRight', inttostr(RNumber.Right));
    addVariableToJson(json, 'nBottom', inttostr(RNumber.Bottom));

    addVariableToJson(json, 'oTop', inttostr(ROrder.Top));
    addVariableToJson(json, 'oLeft', inttostr(ROrder.Left));
    addVariableToJson(json, 'oRight', inttostr(ROrder.Right));
    addVariableToJson(json, 'oBottom', inttostr(ROrder.Bottom));

    addVariableToJson(json, 'sTop', inttostr(RSecond.Top));
    addVariableToJson(json, 'sLeft', inttostr(RSecond.Left));
    addVariableToJson(json, 'sRight', inttostr(RSecond.Right));
    addVariableToJson(json, 'sBottom', inttostr(RSecond.Bottom));

    addVariableToJson(json, 'ColorTimeline', CTHTML(ColorToRgb(ColorTimeline)));
    addVariableToJson(json, 'ColorEvent', CTHTML(ColorToRgb(ColorEvent)));
    addVariableToJson(json, 'Number', inttostr(Number));
    addVariableToJson(json, 'Dev', inttostr(Dev));
    addVariableToJson(json, 'Start', inttostr(Start));
    addVariableToJson(json, 'Finish', inttostr(Finish));
    addVariableToJson(json, 'Duration', inttostr(Duration));
    addVariableToJson(json, 'Mix', inttostr(Mix));
    addVariableToJson(json, 'Text', Text);
    addVariableToJson(json, 'Top', inttostr(Rect.Top));
    addVariableToJson(json, 'Left', inttostr(Rect.Left));
    addVariableToJson(json, 'Right', inttostr(Rect.Right));
    addVariableToJson(json, 'Bottom', inttostr(Rect.Bottom));
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirOneEvent.SendHTTPOneEvent | ' + E.Message);
  end;
  JsonData := json.ToString;
  json.free;

end;

procedure TAirOneEvent.SendHTTPOneEvent(nom: integer);
begin

  try
    SaveToJson;
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'BackGround',
      CTHTML(ColorToRgb(BackGround)));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'ForeGround',
      CTHTML(ColorToRgb(ForeGround)));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Interval', inttostr(Interval));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'fsize',
      inttostr(TLParameters.FrameSize));

    // ROrder : TRect;
    // (*HTTP*) addVariable(1,'Event', inttostr(nom),'',inttostr());
    // RNumber : TRect;
    // (*HTTP*) addVariable(1,'Event', inttostr(nom),'',inttostr());
    // RSecond : Trect;
    // (*HTTP*) addVariable(1,'Event', inttostr(nom),'',inttostr());
    // REvent : TRect;
    // (*HTTP*) addVariable(1,'Event', inttostr(nom),'',inttostr());
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sf5',
      CTHTML(ColorToRgb(SmoothColor(ForeGround, 5))));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sb5',
      CTHTML(SmoothColor(BackGround, 5)));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sct25',
      CTHTML(ColorToRgb(SmoothColor(ColorTimeline, 25))));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sct56',
      CTHTML(ColorToRgb(SmoothColor(ColorTimeline, 56))));

    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'eTop', inttostr(REvent.Top));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'eLeft', inttostr(REvent.Left));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'eRight', inttostr(REvent.Right));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'eBottom', inttostr(REvent.Bottom));

    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'nTop', inttostr(RNumber.Top));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'nLeft', inttostr(RNumber.Left));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'nRight', inttostr(RNumber.Right));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'nBottom', inttostr(RNumber.Bottom));

    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'oTop', inttostr(ROrder.Top));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'oLeft', inttostr(ROrder.Left));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'oRight', inttostr(ROrder.Right));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'oBottom', inttostr(ROrder.Bottom));

    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sTop', inttostr(RSecond.Top));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sLeft', inttostr(RSecond.Left));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sRight', inttostr(RSecond.Right));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'sBottom', inttostr(RSecond.Bottom));

    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'ColorTimeline',
      CTHTML(ColorToRgb(ColorTimeline)));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'ColorEvent',
      CTHTML(ColorToRgb(ColorEvent)));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Number', inttostr(Number));
    (* HTTP *) addVariable(1, 'Event', inttostr(nom), 'Dev', inttostr(Dev));
    (* HTTP *) addVariable(1, 'Event', inttostr(nom), 'Start', inttostr(Start));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Finish', inttostr(Finish));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Duration', inttostr(Duration));
    (* HTTP *) addVariable(1, 'Event', inttostr(nom), 'Mix', inttostr(Mix));
    (* HTTP *) addVariable(1, 'Event', inttostr(nom), 'Text', Text);
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Top', inttostr(Rect.Top));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Left', inttostr(Rect.Left));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Right', inttostr(Rect.Right));
    (* HTTP *)
    addVariable(1, 'Event', inttostr(nom), 'Bottom', inttostr(Rect.Bottom));
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirOneEvent.SendHTTPOneEvent | ' + E.Message);
  end;
end;

function TAirOneEvent.Init(cv: tcanvas; tp, hgh, intrv, sz1, sz2, sz3,
  sz0: integer): integer;
begin
  Interval := intrv;

  Rect.Top := tp;
  Rect.Bottom := tp + hgh;
  Rect.Left := cv.ClipRect.Left;
  Rect.Right := cv.ClipRect.Right;

  ROrder.Top := Rect.Top;
  ROrder.Bottom := Rect.Bottom;
  ROrder.Left := cv.ClipRect.Left;
  ROrder.Right := sz1 - 5;

  RNumber.Top := Rect.Top;
  RNumber.Bottom := Rect.Bottom;
  RNumber.Left := sz1;
  RNumber.Right := sz2;

  RSecond.Top := Rect.Top;
  RSecond.Bottom := Rect.Bottom;
  RSecond.Left := sz3;
  RSecond.Right := sz0;

  REvent.Top := Rect.Top;
  REvent.Bottom := Rect.Bottom;
  REvent.Left := sz0;
  REvent.Right := cv.ClipRect.Right;
  result := tp + hgh;
end;

procedure TAirOneEvent.LoadFromJson(jsonstr: string);
begin

end;

procedure TAirOneEvent.Draw(cv: tcanvas; ps: integer);
var
  rt: Trect;
  stp, str, dlt: longint;
  s: string;
  clb: tcolor;
  hgh: integer;
  brcl, pncl, fncl: tcolor;
  brst: tbrushstyle;
  fnnm: tfontname;
  fnsz, pnwd: integer;
begin
  try
    brcl := cv.Brush.Color;
    pncl := cv.Pen.Color;
    brst := cv.Brush.Style;
    pnwd := cv.Pen.Width;
    fnsz := cv.Font.Size;
    fncl := cv.Font.Color;
    fnnm := cv.Font.Name;

    cv.Brush.Color := ForeGround;
    cv.FillRect(Rect);
    cv.Brush.Color := SmoothColor(ForeGround, 5);
    cv.FillRect(REvent);
    cv.Brush.Color := ColorTimeline;
    cv.Brush.Style := bsSolid;
    cv.Pen.Color := ColorTimeline;
    if Start < 0 then
      Start := 0;
    rt.Left := REvent.Left + Start * TLParameters.FrameSize;;
    rt.Top := REvent.Top;
    rt.Right := REvent.Left + Finish * TLParameters.FrameSize;
    rt.Bottom := REvent.Bottom;
    if Duration > 0 then
      cv.Rectangle(rt);

    // Mix:=50;//Warm*****************

    if Number >= 0 then
    begin
      if Mix > 0 then
      begin
        if Mix > Duration then
          Mix := Duration;
        clb := cv.Brush.Color;
        if ps <> -1 then
        begin
          cv.Brush.Color := SmoothColor(BackGround, 5);
          cv.Polygon([Point(rt.Left, rt.Top), Point(rt.Left, rt.Bottom),
            Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top)]);
          hgh := rt.Bottom - rt.Top + Interval;
          if ps = 0 then
          begin
            cv.Brush.Color := SmoothColor(ColorTimeline, 25);
            cv.Polygon([Point(rt.Left, rt.Top - Interval),
              Point(rt.Left, rt.Top - hgh),
              Point(rt.Left + Mix * TLParameters.FrameSize,
              rt.Top - Interval)]);
          end
          else
          begin
            cv.Brush.Color := SmoothColor(ColorTimeline, 25);
            cv.Polygon([Point(rt.Left, rt.Top - Interval),
              Point(rt.Left, rt.Top - hgh),
              Point(rt.Left + Mix * TLParameters.FrameSize,
              rt.Top - Interval)]);
          end;
        end
        else
        begin
          cv.Brush.Color := SmoothColor(ColorTimeline, 56);
          if Start = 0 then
          begin
            str := Duration - Mix;
            if Finish > str then
            begin
              dlt := (Finish - str) * TLParameters.FrameSize;
              stp := trunc
                (dlt * ((rt.Bottom - rt.Top) / (Mix * TLParameters.FrameSize)));
              cv.Polygon([Point(rt.Left, rt.Bottom - stp),
                Point(rt.Left, rt.Bottom), Point(rt.Left + dlt, rt.Bottom)]);
            end;
          end
          else
          begin
            cv.Polygon([Point(rt.Left, rt.Top), Point(rt.Left, rt.Bottom),
              Point(rt.Left + Mix * TLParameters.FrameSize, rt.Bottom)]);
          end;
        end;
        cv.Brush.Color := clb;
      end;

      cv.Brush.Style := bsClear;
      cv.Font.Color := ProgrammFontColor;
      cv.Font.Name := ProgrammFontName;

      s := SecondToShortStr(GetEventValue(Start, Finish));
      // Round((Finish - Start) / 25));
      // cv.Font.Size:=40;
      // cv.Font.Size:=DefineFontSizeW(cv,RSecond.Right-RSecond.Left,'0:00');
      cv.TextOut(RSecond.Left, RSecond.Top + (RSecond.Bottom - RSecond.Top -
        cv.TextHeight('0')) div 2, s);

      s := inttostr(Number + 1 + PrintEventShift);
      cv.TextOut(ROrder.Right - cv.TextWidth(s) - 2,
        ROrder.Top + (ROrder.Bottom - ROrder.Top - cv.TextHeight('0'))
        div 2, s);

      cv.Brush.Style := bsSolid;
      cv.Brush.Color := ColorEvent;
      cv.Rectangle(RNumber);
      if Dev >= 0 then
        s := inttostr(Dev)
      else
        s := '';
      cv.TextOut(RNumber.Left + (RNumber.Right - RNumber.Left - cv.TextWidth(s))
        div 2, RNumber.Top + (RNumber.Bottom - RNumber.Top - cv.TextHeight('0'))
        div 2, s);
    end;

    cv.Brush.Color := brcl;
    cv.Pen.Color := pncl;
    cv.Brush.Style := brst;
    cv.Pen.Width := pnwd;
    cv.Font.Size := fnsz;
    cv.Font.Color := fncl;
    cv.Font.Name := fnnm;
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirOneEvent.Draw | ' + E.Message);
  end;
end;

procedure TAirOneEvent.DrawText(cv: tcanvas);
var
  fncl: tcolor;
  brst: tbrushstyle;
  fnnm: tfontname;
  fnsz: integer;
  txt: string;
begin
  try
    brst := cv.Brush.Style;
    fnsz := cv.Font.Size;
    fncl := cv.Font.Color;
    fnnm := cv.Font.Name;
    if Number >= 0 then
    begin
      cv.Brush.Style := bsClear;
      txt := trim(Text);
      cv.Font.Color := ProgrammFontColor;
      if txt <> '' then
        if txt[1] = '#' then
          cv.Font.Color := AirFontComment; // ProgrammCommentColor;
      cv.Font.Name := ProgrammFontName;
      // cv.Font.Size:=DefineFontSizeH(cv,REvent.Bottom-REvent.Top - trunc((REvent.Bottom-REvent.Top) / 6));
      // Warning*****************
      cv.TextOut(REvent.Left + 15, REvent.Top + (REvent.Bottom - REvent.Top -
        cv.TextHeight('0')) div 2, Text);
    end;
    cv.Brush.Style := brst;
    cv.Font.Size := fnsz;
    cv.Font.Color := fncl;
    cv.Font.Name := fnnm;
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirOneEvent.DrawText | ' + E.Message);
  end;
end;

procedure TAirOneEvent.Clear;
begin
  ColorEvent := ForeGround;
  Number := -1;
  Text := '';
  Dev := -1;
  Start := -1;
  Finish := -1;
  Duration := -1;
  Mix := 0;
end;

procedure TAirOneEvent.AssignEvent(ps: integer; Curr: boolean);
var
  comment: string;
begin
  try
    ColorEvent := TLZone.TLEditor.Events[ps].Color;
    Number := ps;
    Text := '';
    Start := TLZone.TLEditor.Events[ps].Start - TLParameters.Position;
    Finish := TLZone.TLEditor.Events[ps].Finish - TLParameters.Position;
    Duration := TLZone.TLEditor.Events[ps].Finish - TLZone.TLEditor.Events
      [ps].Start;
    Mix := TLZone.TLEditor.Events[ps].ReadPhraseData('Duration');
    comment := trim(TLZone.TLEditor.Events[ps].ReadPhraseText('Comment'));
    Text := TLZone.TLEditor.Events[ps].ReadPhraseText('Text');
    if comment <> '' then
      if comment[1] = '#' then
        Text := comment;
    if TLZone.TLEditor.TypeTL = tldevice then
    begin
      Dev := TLZone.TLEditor.Events[ps].ReadPhraseData('Device');
      // WARMING**************
      Mix := TLZone.TLEditor.Events[ps].ReadPhraseData('Duration');
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirOneEvent.AssignEvent | ' + E.Message);
  end;
end;

// ==============================================================================
// =========== Класс TAirSecond рисуем одно событие ===========================
// ==============================================================================

Constructor TAirSecond.Create;
begin
  inherited;
  BackGround := AirBackGround; // ProgrammColor;
  if AirBackGround = TimeForeGround then
    ForeGround := SmoothColor(AirBackGround, 12)
  else
    ForeGround := TimeForeGround;
  // ForeGround := SmoothColor(AirBackGround, 12);//SmoothColor(ProgrammColor, 12);
  Color := clWhite;
  Start := -1;
  Finish := -1;
  Duration := -1;
  Mix := 0;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  RTC.Left := 0;
  RTC.Right := 0;
  RTC.Top := 0;
  RTC.Bottom := 0;
  RSecond.Left := 0;
  RSecond.Right := 0;
  RSecond.Top := 0;
  RSecond.Bottom := 0;
end;

destructor TAirSecond.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@ForeGround);
  FreeMem(@Color);
  FreeMem(@Start);
  FreeMem(@Finish);
  FreeMem(@Duration);
  FreeMem(@Mix);
  FreeMem(@Rect);
  FreeMem(@RTC);
  FreeMem(@RSecond);
  inherited;
end;

function TAirSecond.Init(cv: tcanvas; tp, hgh, sz0: integer): integer;
begin
  Rect.Top := tp;
  Rect.Bottom := tp + hgh;
  Rect.Left := cv.ClipRect.Left;
  Rect.Right := cv.ClipRect.Right;

  RTC.Top := tp;
  RTC.Bottom := tp + hgh;
  RTC.Left := cv.ClipRect.Left;
  RTC.Right := sz0;

  RSecond.Top := tp;
  RSecond.Bottom := tp + hgh;
  RSecond.Left := sz0;
  RSecond.Right := cv.ClipRect.Right;
  result := tp + hgh;
end;

procedure TAirSecond.Draw(cv: tcanvas);
var
  rt: Trect;
  stp, str, dlt: longint;
  clb: tcolor;
  brcl, pncl, fncl: tcolor;
  brst: tbrushstyle;
  fnnm: tfontname;
  fnsz, pnwd: integer;
begin
  try
    brcl := cv.Brush.Color;
    pncl := cv.Pen.Color;
    brst := cv.Brush.Style;
    pnwd := cv.Pen.Width;
    fnsz := cv.Font.Size;
    fncl := cv.Font.Color;
    fnnm := cv.Font.Name;

    cv.Brush.Color := TimeForeGround;
    cv.FillRect(Rect);
    cv.Brush.Color := Color;
    cv.Brush.Style := bsSolid;
    cv.Pen.Color := Color;
    rt.Top := RSecond.Top;
    rt.Bottom := RSecond.Bottom;

    if Start < 0 then
      Start := 0;
    rt.Left := RSecond.Left + Start * TLParameters.FrameSize;;
    rt.Right := RSecond.Left + Finish * TLParameters.FrameSize;

    if Duration > 0 then
      cv.Rectangle(rt);

    // Mix:=50; //Warm*****************

    if Mix > 0 then
    begin
      cv.Brush.Color := SmoothColor(Color, 56);
      cv.Pen.Color := SmoothColor(Color, 56);
      if Mix > Duration then
        Mix := Duration;
      if Start = 0 then
      begin
        str := Duration - Mix;
        if Finish > str then
        begin
          dlt := (Finish - str) * TLParameters.FrameSize;
          stp := trunc(dlt * ((rt.Bottom - rt.Top) /
            (Mix * TLParameters.FrameSize)));
          cv.Polygon([Point(rt.Left, rt.Top + stp), Point(rt.Left, rt.Top),
            Point(rt.Left + dlt, rt.Top)]);
        end;
      end
      else
      begin
        cv.Polygon([Point(rt.Left, rt.Bottom), Point(rt.Left, rt.Top),
          Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top)]);
      end;
    end;

    cv.Brush.Color := brcl;
    cv.Pen.Color := pncl;
    cv.Brush.Style := brst;
    cv.Pen.Width := pnwd;
    cv.Font.Size := fnsz;
    cv.Font.Color := fncl;
    cv.Font.Name := fnnm;
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirSecond.Draw | ' + E.Message);
  end;
end;

procedure TAirSecond.DrawSeconds(cv: tcanvas);
var
  rt: Trect;
  stp, str, dlt: longint;
  clp: tcolor;
  pnw: integer;
begin
  try
    clp := cv.Pen.Color;
    pnw := cv.Pen.Width;
    stp := 25 * TLParameters.FrameSize;
    str := RSecond.Left + stp;
    cv.Pen.Color := TimeSecondColor;
    while str < RSecond.Right do
    begin
      cv.MoveTo(str, RSecond.Top);
      cv.LineTo(str, RSecond.Bottom);
      str := str + stp;
    end;
    cv.Pen.Width := pnw;
    cv.Pen.Color := clp;
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirSecond.DrawSeconds | ' + E.Message);
  end;
end;

procedure TAirSecond.AssignEvent(ps: integer; Curr: boolean);
begin
  Start := TLZone.TLEditor.Events[ps].Start - TLParameters.Position;
  Finish := TLZone.TLEditor.Events[ps].Finish - TLParameters.Position;
  Duration := TLZone.TLEditor.Events[ps].Finish - TLZone.TLEditor.Events
    [ps].Start;
  if TLZone.TLEditor.TypeTL = tldevice then
    Mix := TLZone.TLEditor.Events[ps].ReadPhraseData('Duration');
end;

// ==============================================================================
// =========== Класс TAirEvents список событий ==================================
// ==============================================================================

Constructor TAirEvents.Create;
begin
  inherited;
  BackGround := AirBackGround; // ProgrammColor;
  if AirBackGround = AirForeGround then
    ForeGround := SmoothColor(AirBackGround, 12)
  else
    ForeGround := AirForeGround;
  // ForeGround := SmoothColor(AirBackGround, 12);
  Interval := 2;
  CurrEvent := TAirOneEvent.Create;
  CurrTime := TAirSecond.Create;
  Count := 0;
end;

destructor TAirEvents.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@ForeGround);
  FreeMem(@Interval);
  FreeMem(@CurrEvent);
  FreeMem(@CurrTime);
  FreeMem(@Count);
  FreeMem(@Events);
  inherited;
end;

function TAirEvents.AddEvent: integer;
begin
  Count := Count + 1;
  Setlength(Events, Count);
  Events[Count - 1] := TAirOneEvent.Create;
  result := Count - 1;
end;

procedure TAirEvents.Clear;
var
  i: integer;
begin
  CurrEvent.Clear;
  CurrTime.Start := -1;
  CurrTime.Finish := -1;
  for i := Count - 1 downto 0 do
    Events[i].FreeInstance;
  Count := 0;
  Setlength(Events, Count);
end;

procedure TAirEvents.Init(cv: tcanvas);
var
  sz0, sz1, sz2, sz3, szd, hgh, ps, i: integer;
begin
  sz0 := form1.imgTLNames.Width + TLParameters.MyCursor;
  szd := sz0 div 4 - 5;
  sz3 := sz0 - szd;
  sz2 := sz3 - 5;
  sz1 := sz2 - szd;
  hgh := trunc(((cv.ClipRect.Bottom - cv.ClipRect.Top) - Interval * (Count + 1))
    div (Count + 2));

  ps := CurrEvent.Init(cv, cv.ClipRect.Top, hgh, Interval, sz1, sz2, sz3, sz0);
  ps := ps + Interval;
  ps := CurrTime.Init(cv, ps, hgh, sz0);
  ps := ps + Interval;
  Clear;
  Application.ProcessMessages;
  for i := 0 to RowsEvents - 1 do
  begin
    AddEvent;
    ps := Events[Count - 1].Init(cv, ps, hgh, Interval, sz1, sz2, sz3, sz0);
    ps := ps + Interval;
  end;
end;

procedure TAirEvents.Draw(cv: tcanvas);
var
  i, fs1, fs2: integer;
begin
  try
    if bmpEvents = nil then
      exit;
    if Count < 0 then
      exit;
    bmpEvents.Width := cv.ClipRect.Right - cv.ClipRect.Left;
    bmpEvents.Height := cv.ClipRect.Bottom - cv.ClipRect.Top;
    bmpEvents.Canvas.Brush.Color := BackGround;
    bmpEvents.Canvas.FillRect(bmpEvents.Canvas.ClipRect);

    cv.Font.Name := ProgrammFontName;
    szFontEvents1 := DefineFontSizeH(bmpEvents.Canvas, Events[0].REvent.Bottom -
      Events[0].REvent.Top - trunc((Events[0].REvent.Bottom -
      Events[0].REvent.Top) / 6));

    bmpEvents.Canvas.Font.Size := 40;
    szFontEvents2 := DefineFontSizeW(bmpEvents.Canvas, Events[0].RSecond.Right -
      Events[0].RSecond.Left, '0:00') - 1;

    bmpEvents.Canvas.Font.Size := szFontEvents2;
    CurrEvent.Draw(bmpEvents.Canvas, -1);
    bmpEvents.Canvas.Font.Size := szFontEvents1;
    CurrEvent.DrawText(bmpEvents.Canvas);
    CurrTime.Draw(bmpEvents.Canvas);
    bmpEvents.Canvas.Font.Size := szFontEvents2;
    for i := 0 to Count - 1 do
      Events[i].Draw(bmpEvents.Canvas, i);
    bmpEvents.Canvas.Font.Size := szFontEvents1;
    for i := 0 to Count - 1 do
      Events[i].DrawText(bmpEvents.Canvas);
    bmpEvents.Canvas.Font.Size := szFontEvents2;
    CurrTime.DrawSeconds(bmpEvents.Canvas);
    cv.CopyRect(cv.ClipRect, bmpEvents.Canvas, bmpEvents.Canvas.ClipRect);
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirEvents.Draw | ' + E.Message);
  end;
end;

procedure TAirEvents.DrawTimeCode(cv: tcanvas; tc: longint);
var
  i: integer;
  clb, clf: tcolor;
  fnm: tfontname;
  fsz: integer;
  bst: tbrushstyle;
  s: string;
begin
  try
    clb := cv.Brush.Color;
    clf := cv.Font.Color;
    fnm := cv.Font.Name;
    fsz := cv.Font.Size;
    bst := cv.Brush.Style;
    cv.Brush.Color := TimeForeGround;
    cv.Font.Color := ProgrammFontColor;
    cv.Font.Name := ProgrammFontName;
    // cv.Font.Size:=40;
    cv.Font.Size := szFontEvents2;
    // cv.Font.Size:=DefineFontSizeH(cv,CurrTime.RTC.Bottom - CurrTime.RTC.Top);
    s := FramesToShortStr(tc);
    cv.TextOut(CurrTime.RTC.Right - cv.TextWidth('00:00:00:00'),
      CurrTime.RTC.Top + (CurrTime.RTC.Bottom - CurrTime.RTC.Top -
      cv.TextHeight('0')) div 2, s);
    cv.Brush.Color := clb;
    cv.Font.Color := clf;
    cv.Font.Name := fnm;
    cv.Font.Size := fsz;
    cv.Brush.Style := bst;
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirEvents.DrawTimeCode | ' + E.Message);
  end;
end;

// ==============================================================================
// =========== Класс TRECTDevice рисуем номера устройств ========================
// ==============================================================================

Constructor TRectDevice.Create;
begin
  Number := 0;
  Value := -1;
  Text := '';
  Curr := false;
  next := false;
  Color := ProgrammFontColor;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
end;

Destructor TRectDevice.Destroy;
begin
  FreeMem(@Number);
  FreeMem(@Value);
  FreeMem(@Curr);
  FreeMem(@next);
  FreeMem(@Text);
  FreeMem(@Color);
  FreeMem(@Rect);
end;

procedure TRectDevice.SaveToJson;
var
  json: tjsonobject;
begin

  // Curr: boolean;
  // next: boolean;
  // Text: String;
  // Color: tcolor;
  // Rect: Trect;
  json := tjsonobject.Create;
  try
    addVariableToJson(json, 'Number', inttostr(Number));
    addVariableToJson(json, 'Value', inttostr(Value));
    addVariableToJson(json, 'Curr', booltostr(Curr));
    addVariableToJson(json, 'next', booltostr(next));
    addVariableToJson(json, 'Text', Text);
    addVariableToJson(json, 'Color', CTHTML(Color));
    addVariableToJson(json, 'rTop', inttostr(Rect.Top));
    addVariableToJson(json, 'rLeft', inttostr(Rect.Left));
    addVariableToJson(json, 'rRight', inttostr(Rect.Right));
    addVariableToJson(json, 'rBottom', inttostr(Rect.Bottom));
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirOneEvent.SendHTTPOneEvent | ' + E.Message);
  end;
  JsonData := json.ToString;
  json.free;
end;

procedure TRectDevice.Draw(cv: tcanvas);
var
  clb, clp: tcolor;
  bst: tbrushstyle;
  pnw, fns: integer;
  px, py: integer;
  fnm: tfontname;
begin
  try
    clb := cv.Brush.Color;
    clp := cv.Pen.Color;
    bst := cv.Brush.Style;
    pnw := cv.Pen.Width;
    fnm := cv.Font.Name;
    fns := cv.Font.Size;

    cv.Pen.Width := 4;
    cv.Pen.Color := Color;
    cv.Brush.Style := bsSolid;
    cv.Brush.Color := DevBackGround; // ProgrammColor;
    cv.Font.Color := ProgrammFontColor;
    cv.Font.Name := ProgrammFontName;
    if Curr then
      cv.Brush.Color := clRed
    else if next then
      cv.Brush.Color := clGreen
    else
      cv.Brush.Color := DevBackGround; // ProgrammColor;

    cv.Rectangle(Rect);
    cv.Brush.Color := Color;
    cv.Font.Size := 7;
    cv.Rectangle(Rect.Left, Rect.Top, Rect.Left + cv.TextWidth('00'),
      Rect.Top + cv.TextHeight('0') - 2);
    cv.TextOut(Rect.Left + (cv.TextWidth('00') - cv.TextWidth(inttostr(Number)))
      div 2, Rect.Top - 2, inttostr(Number));

    if Curr then
      cv.Brush.Color := clRed
    else if next then
      cv.Brush.Color := clGreen
    else
      cv.Brush.Color := DevBackGround; // ProgrammColor;
    // cv.Font.Size:=40;
    // cv.Font.Size:=DefineFontSizeW(cv, Rect.Right - Rect.Left -20, '000');
    cv.Font.Size := fns;
    px := Rect.Left + (Rect.Right - Rect.Left -
      cv.TextWidth(inttostr(Value))) div 2;
    py := Rect.Top + (Rect.Bottom - Rect.Top - cv.TextHeight('0')) div 2;
    if Value <> -1 then
      cv.TextOut(px, py, inttostr(Value));

    cv.Font.Size := fns;
    cv.Font.Name := fnm;
    cv.Pen.Width := pnw;
    cv.Brush.Style := bst;
    cv.Brush.Color := clb;
    cv.Pen.Color := clp;
  except
    on E: Exception do
      WriteLog('MAIN', 'TRectDevice.Draw | ' + E.Message);
  end;
end;

// ==============================================================================
// =========== Класс TAirDevice рисуем номера устройств =========================
// ==============================================================================

Constructor TAirDevices.Create;
begin
  inherited;
  BackGround := DevBackGround; // ProgrammColor;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
end;

Destructor TAirDevices.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@Rect);
  inherited;
end;

procedure TAirDevices.Init(cv: tcanvas; grpos: integer);
var
  i, j1, rw, sz, fsz, hgh, px, py: integer;
  ssz, sz1, sz2: integer;
begin
  try
    with form1.GridTimeLines do
    begin
      ssz := form1.imgTLNames.Width + TLParameters.MyCursor;
      sz1 := ssz div 4 - 5;
      sz2 := (form1.ImgDevices.ClientRect.Right - ssz) div 14 - 5;
      if sz1 < sz2 then
        sz := sz1
      else
        sz := sz2;
      Rect.Left := ssz - 2 * sz - 5;
      Rect.Right := form1.PanelAir.Width;
      Rect.Top := form1.ImgDevices.ClientRect.Top;
      Rect.Bottom := form1.ImgDevices.ClientRect.Top + form1.ImgDevices.Height;
      if TLZone.TLEditor.TypeTL <> tldevice then
        exit;
      Clear;
      if Objects[0, grpos] is TTimelineOptions then
      begin
        fsz := DefineFontSizeW(cv, sz - 20, '000');
        cv.Font.Size := fsz;
        hgh := (Rect.Bottom - Rect.Top - 20) div 2;
        // cv.TextHeight('000') + 20;
        if (Objects[0, grpos] as TTimelineOptions).CountDev <= 16 then
        begin
          py := Rect.Top + (Rect.Bottom - Rect.Top - hgh) div 2;
          px := Rect.Left;
          for i := 0 to (Objects[0, grpos] as TTimelineOptions).CountDev - 1 do
          begin
            rw := AddDevice((Objects[0, grpos] as TTimelineOptions)
              .DevEvents[i].Color);
            Devices[rw].Rect.Top := py;
            Devices[rw].Rect.Bottom := py + hgh;
            Devices[rw].Rect.Left := px;
            Devices[rw].Rect.Right := px + sz;
            px := Devices[rw].Rect.Right + 5;
          end;
        end
        else
        begin
          py := Rect.Top + 5; // (Rect.Bottom - Rect.Top - 2 * hgh -10) div 2;
          px := Rect.Left;
          for i := 0 to 15 do
          begin
            rw := AddDevice((Objects[0, grpos] as TTimelineOptions)
              .DevEvents[i].Color);
            Devices[rw].Rect.Top := py;
            Devices[rw].Rect.Bottom := py + hgh;
            Devices[rw].Rect.Left := px;
            Devices[rw].Rect.Right := px + sz;
            px := Devices[rw].Rect.Right + 5;
          end;
          py := py + hgh + 10;
          px := Rect.Left;
          // j1:=(Objects[0,grpos] as TTimelineOptions).CountDev - 16;
          for i := 16 to (Objects[0, grpos] as TTimelineOptions).CountDev - 1 do
          begin
            rw := AddDevice((Objects[0, grpos] as TTimelineOptions)
              .DevEvents[i].Color);
            Devices[rw].Rect.Top := py;
            Devices[rw].Rect.Bottom := py + hgh;
            Devices[rw].Rect.Left := px;
            Devices[rw].Rect.Right := px + sz;
            px := Devices[rw].Rect.Right + 5;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TAIRDevices.Init | ' + E.Message);
  end;
end;

procedure TAirDevices.Draw(cv: tcanvas);
var
  i: integer;
begin
  try
    bmpAirDevices.Width := cv.ClipRect.Right - cv.ClipRect.Left;
    bmpAirDevices.Height := cv.ClipRect.Bottom - cv.ClipRect.Top;
    bmpAirDevices.Canvas.Brush.Color := DevBackGround;
    bmpAirDevices.Canvas.FillRect(bmpAirDevices.Canvas.ClipRect);
    if TLZone.TLEditor.TypeTL <> tldevice then
    begin
      cv.CopyRect(cv.ClipRect, bmpAirDevices.Canvas,
        bmpAirDevices.Canvas.ClipRect);
      exit;
    end;
    bmpAirDevices.Canvas.Font.Size := 40;
    bmpAirDevices.Canvas.Font.Size := DefineFontSizeW(bmpAirDevices.Canvas,
      Devices[0].Rect.Right - Devices[0].Rect.Left - 20, '000');

    // SetValues;
    for i := 0 to Count - 1 do
      Devices[i].Draw(bmpAirDevices.Canvas);
    // bitblt(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top, cv.ClipRect.Right-cv.ClipRect.Left
    // , cv.ClipRect.Bottom-cv.ClipRect.Top, bmpAirDevices.Canvas.Handle, 0, 0, SRCCOPY);
    // cv.Refresh;
    cv.CopyRect(cv.ClipRect, bmpAirDevices.Canvas,
      bmpAirDevices.Canvas.ClipRect);
    // cv.Brush.Color:=BackGround;
    // cv.FillRect(cv.ClipRect);
    // if TLZone.TLEditor.TypeTL<>tldevice then exit;
    // //SetValues;
    // for i:=0 to Count-1 do Devices[i].Draw(cv);
  except
    on E: Exception do
      WriteLog('MAIN', 'TAIRDevices.Draw | ' + E.Message);
  end;
end;

procedure TAirDevices.Clear;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    Devices[i].FreeInstance;
  Count := 0;
  Setlength(Devices, Count);
end;

function TAirDevices.AddDevice(Color: tcolor): integer;
begin
  Count := Count + 1;
  Setlength(Devices, Count);
  Devices[Count - 1] := TRectDevice.Create;
  Devices[Count - 1].Color := Color;
  Devices[Count - 1].Number := Count;
  result := Count - 1;
end;

// ==============================================================================
// =========== Класс TPanelAir рисуем номера устройствв =========================
// ==============================================================================

Constructor TPanelAir.Create;
begin
  inherited;
  ExportInProgress := false;;
  AirEvents := TAirEvents.Create;
  AirDevices := TAirDevices.Create;
end;

destructor TPanelAir.Destroy;
begin
  AirEvents.free;
  AirDevices.free;
  Inherited;
end;

// ПРОЦЕДУРА ОТСЛЕЖИВАЕТ СОСТОЯНИЕ ТАЙМ-ЛИНИЙ
// ТЕРБУЕТСЯ ДОРОБОТКА ПРИ ВОСПРОИЗВЕДЕНИИ ДЛЯ УПРАВЛЕНИЯ УСТРОЙСТВАМИ.
procedure TPanelAir.SendHTTPEvents;
var
  i: integer;
begin
  try
    (* HTTP *)
    addVariable(1, 'EventsBackGround',
      CTHTML(ColorToRgb(AirEvents.BackGround)));
    (* HTTP *)
    addVariable(1, 'EventsForeGround',
      CTHTML(ColorToRgb(AirEvents.ForeGround)));
    AirEvents.CurrEvent.SendHTTPOneEvent(0);

    (* HTTP *) addVariable(1, 'EventsCount', inttostr(AirEvents.Count));
    AirEvents.CurrTime.SendHttp;
    for i := 0 to AirEvents.Count - 1 do
      AirEvents.Events[i].SendHTTPOneEvent(i + 1);
  except
    on E: Exception do
      WriteLog('MAIN', 'TPanelAir.SendHTTPEvents | ' + E.Message);
  end;
end;

procedure TPanelAir.SendHTTPDevice;
var
  cnt: integer;
begin
  try
    with AirDevices do
    begin
      for cnt := 0 to Count - 1 do
      begin
        (* HTTP *)
        addVariable(1, 'Dev', inttostr(cnt), 'Number',
          inttostr(Devices[cnt].Number));
        (* HTTP *)
        addVariable(1, 'Dev', inttostr(cnt), 'Value',
          inttostr(Devices[cnt].Value));
        with Devices[cnt] do
        begin
          (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Top', inttostr(Rect.Top));
          (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Left', inttostr(Rect.Left));
          (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Right', inttostr(Rect.Right));
          (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Bottom', inttostr(Rect.Bottom));
        end;
        if Devices[cnt].Curr then (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Curr', 'Yes')
        else (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Curr', 'No');
        if Devices[cnt].next then (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Next', 'Yes')
        else (* HTTP *)
          addVariable(1, 'Dev', inttostr(cnt), 'Next', 'No');
        (* HTTP *)
        addVariable(1, 'Dev', inttostr(cnt), 'Text', Devices[cnt].Text);
        (* HTTP *)
        addVariable(1, 'Dev', inttostr(cnt), 'Color',
          CTHTML(ColorToRgb(Devices[cnt].Color)));
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TPanelAir.SendHTTPDevice | ' + E.Message);
  end;
end;

procedure TPanelAir.SetValues;
begin
  try
    if ExportInProgress then
      exit;
    try
      ExportInProgress := true;
      BeginJson;
      SetValues_40mc;
      SaveJson;
    finally
    end;
    ExportInProgress := false;
  except
    on E: Exception do
      WriteLog('MAIN', 'TPanelAir.SetValues | ' + E.Message);
  end;
end;

procedure TPanelAir.SetValues_40mc;
var
  i, j, ps, st, ie, cie, cnt: integer;
  pred: longint;
  s: string;
begin
  try
    (* HTTP *) addVariable(1, 'Regim', form1.lbMode.Caption);
    (* HTTP *)
    addVariable(1, 'LeftScreenFrame', inttostr(TLParameters.ScreenStartFrame));
    (* HTTP *)
    addVariable(1, 'RightScreenFrame', inttostr(TLParameters.ScreenEndFrame));
    (* HTTP *) addVariable(1, 'ecvH', inttostr(bmpEvents.Height));
    (* HTTP *) addVariable(1, 'ecvW', inttostr(bmpEvents.Width));
    (* HTTP *) addVariable(1, 'dcvH', inttostr(bmpAirDevices.Height));
    (* HTTP *) addVariable(1, 'dcvW', inttostr(bmpAirDevices.Width));
    (* HTTP *) addVariable(1, 'CurrPosition', inttostr(TLParameters.Position));
    (* HTTP *) addVariable(1, 'StartClip', inttostr(TLParameters.Start));
    (* HTTP *) addVariable(1, 'EndClip', inttostr(TLParameters.Finish));
    (* HTTP *) addVariable(1, 'Duration', inttostr(TLParameters.Duration));
    (* HTTP *) addVariable(1, 'Preroll', inttostr(TLParameters.Preroll));
    (* HTTP *) addVariable(1, 'ZeroPoint', inttostr(TLParameters.ZeroPoint));
    (* HTTP *) addVariable(1, 'FrameSize', inttostr(TLParameters.FrameSize));
    (* HTTP *) addVariable(1, 'ClipName', form1.Label2.Caption);
    case TLParameters.vlcmode of
      play: (* HTTP *)
        addVariable(1, 'StatePlayer', 'Play');
      Stop: (* HTTP *)
        addVariable(1, 'StatePlayer', 'Stop');
      Paused: (* HTTP *)
        addVariable(1, 'StatePlayer', 'Pause');
    end;
    with TLZone do
    begin
      // Если тайм-линия Медиа
      if TLEditor.TypeTL = tlmedia then
      begin
        (* HTTP *) addVariable(1, 'TypeTL', 'Media');
        exit;
      end;

      // Если текстовая тайм-линия
      if TLEditor.TypeTL = tltext then
      begin
        (* HTTP *) addVariable(1, 'TypeTL', 'Text');
        AirEvents.CurrEvent.Clear;
        AirEvents.CurrTime.Start := -1;
        AirEvents.CurrTime.Finish := -1;
        AirEvents.CurrTime.Duration := -1;
        For ie := 0 to AirEvents.Count - 1 do
          AirEvents.Events[ie].Clear;
        if TLEditor.Count <= 0 then
          exit;
        if TLParameters.Position > TLEditor.Events[TLEditor.Count - 1].Finish
        then
          exit;
        pred := 0;
        for i := 0 to TLEditor.Count - 1 do
        begin
          if (TLEditor.Events[i].Finish < TLParameters.Position) then
            continue;
          if (TLEditor.Events[i].Start > TLParameters.Finish) then
            exit;
          if (pred < TLParameters.Position) and
            (TLParameters.Position < TLEditor.Events[i].Finish) then
          begin
            AirEvents.CurrEvent.AssignEvent(i, true);
            AirEvents.CurrTime.AssignEvent(i, true);
            For j := i + 1 to TLEditor.Count - 1 do
            begin
              if j - i - 1 >= AirEvents.Count then
                break;
              AirEvents.Events[j - i - 1].AssignEvent(j, false);
            end;
            SendHTTPEvents;
            exit;
          end;
          pred := TLEditor.Events[i].Finish;
        end;
        SendHTTPEvents;
        exit;
      end;

      // Если тайм-линия устройств
      (* HTTP *) addVariable(1, 'TypeTL', 'Device');
      with AirDevices do
      begin
        (* HTTP *) addVariable(1, 'CountDevice', inttostr(Count));
        for j := 0 to Count - 1 do
        begin
          Devices[j].Value := -1;
          Devices[j].Curr := false;
          Devices[j].next := false;
        end;
        if TLEditor.Count <= 0 then
        begin
          SendHTTPDevice;
          SendHTTPEvents;
          exit;
        end;
        if TLParameters.Position < TLEditor.Events[0].Start then
        begin
          ps := TLEditor.Events[0].ReadPhraseData('Device') - 1;
          if AirDevices.Devices[ps].Value = -1 then
          begin
            AirDevices.Devices[ps].next := true;
            AirDevices.Devices[ps].Value := GetDeviceValueS(0);
            // AirDevices.Devices[ps].Value:=Round((TLEditor.Events[0].Start - TLParameters.Position) / 25);
            AirEvents.CurrEvent.AssignEvent(0, true);
            AirEvents.CurrTime.AssignEvent(0, true);
            j := 1;
            for i := 1 to TLEditor.Count - 1 do
            begin
              if (TLEditor.Events[i].Finish < TLParameters.Position) then
                continue;
              if (TLEditor.Events[i].Start > TLParameters.Finish) then
                exit;
              if j <= AirEvents.Count then
                AirEvents.Events[j - 1].AssignEvent(i, false);
              ps := TLEditor.Events[i].ReadPhraseData('Device') - 1;
              // ****Warning
              // if AirDevices.Devices[ps].Value=-1 then AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i].Start - TLParameters.Position) / 25);
              if AirDevices.Devices[ps].Value = -1 then
                AirDevices.Devices[ps].Value := GetDeviceValueS(i);
              j := j + 1;
            end;
          end;
          SendHTTPDevice;
          SendHTTPEvents;
          exit;
        end;
        For i := 0 to TLEditor.Count - 1 do
        begin
          if (TLEditor.Events[i].Finish < TLParameters.Position) then
            continue;
          if (TLEditor.Events[i].Start > TLParameters.Finish) then
            exit;
          if (TLEditor.Events[i].Start <= TLParameters.Position) and
            (TLEditor.Events[i].Finish > TLParameters.Position) then
          begin
            ps := TLEditor.Events[i].ReadPhraseData('Device') - 1;
            // ********Warning
            if AirDevices.Devices[ps].Value = -1 then
            begin
              AirDevices.Devices[ps].Curr := true;
              // AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i].Finish - TLParameters.Position) / 25);
              AirDevices.Devices[ps].Value := GetDeviceValueF(i);
              AirEvents.CurrEvent.AssignEvent(i, true);
              AirEvents.CurrTime.AssignEvent(i, true);
              For ie := 0 to AirEvents.Count - 1 do
                AirEvents.Events[ie].Clear;
              if i + AirEvents.Count < TLEditor.Count then
                cie := AirEvents.Count + 1
              else
                cie := TLEditor.Count - i;
              for ie := i + 1 to i + cie - 1 do
                AirEvents.Events[ie - i - 1].AssignEvent(ie, false);
              st := i;
              if i < TLEditor.Count - 1 then
              begin
                ps := TLEditor.Events[i + 1].ReadPhraseData('Device') - 1;
                // ********Warning
                if AirDevices.Devices[ps].Value = -1 then
                begin
                  AirDevices.Devices[ps].next := true;
                  // AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i+1].Start - TLParameters.Position) / 25);
                  AirDevices.Devices[ps].Value := GetDeviceValueS(i + 1);
                  st := i + 1;
                  break;
                end;
              end;
              break;
            end;
          end;
        end;
        For i := st + 1 to TLEditor.Count - 1 do
        begin
          if (TLEditor.Events[i].Finish < TLParameters.Position) then
            continue;
          if (TLEditor.Events[i].Start > TLParameters.Finish) then
            exit;
          ps := TLEditor.Events[i].ReadPhraseData('Device') - 1;
          // ********Warning
          if ps > AirDevices.Count - 1 then
            break;
          if AirDevices.Devices[ps].Value = -1 then
          begin
            // AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i].Start - TLParameters.Position-1) / 25);
            AirDevices.Devices[ps].Value := GetDeviceValueS(i);
          end;
        end;
        SendHTTPDevice;
        SendHTTPEvents;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TPanelAir.SetValues_40mc | ' + E.Message);
  end;
end;

procedure TPanelAir.Draw(cv1, cv2: tcanvas; grpos: integer);
begin
  try
    AirEvents.Draw(cv2);
    MyPanelAir.AirEvents.DrawTimeCode(cv2, TLParameters.Position -
      TLParameters.ZeroPoint);
    AirDevices.Draw(cv1);
  except
    on E: Exception do
      WriteLog('MAIN', 'TPanelAir.Draw | ' + E.Message);
  end;
end;

procedure TAirSecond.SendHttp;
begin
  try
    // BackGround : TColor;
    // ForeGround : TColor;
    // Color      : TColor;
    // Start      : longint;
    // Finish     : longint;
    // Duration   : longint;
    // Mix        : longint;
    // Rect       : TRect;
    // RTC        : TRect;
    // RSecond    : TRect;

    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'BackGround',
      CTHTML(ColorToRgb(BackGround)));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'sc56',
      CTHTML(ColorToRgb(SmoothColor(ForeGround, 56))));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'ForeGround',
      CTHTML(ColorToRgb(ForeGround)));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Color',
      CTHTML(ColorToRgb(Color)));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Start', inttostr(Start));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Finish', inttostr(Finish));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Duration', inttostr(Duration));
    (* HTTP *) addVariable(1, 'airSecond', inttostr(0), 'Mix', inttostr(Mix));
    (* HTTP *)
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Left', inttostr(Rect.Left));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Top', inttostr(Rect.Top));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Right', inttostr(Rect.Right));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'Bottom', inttostr(Rect.Bottom));

    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'tcLeft', inttostr(RTC.Left));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'tcTop', inttostr(RTC.Top));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'tcRight', inttostr(RTC.Right));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'tcBottom', inttostr(RTC.Bottom));

    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'sLeft', inttostr(RSecond.Left));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'sTop', inttostr(RSecond.Top));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'sRight', inttostr(RSecond.Right));
    (* HTTP *)
    addVariable(1, 'airSecond', inttostr(0), 'sBottom',
      inttostr(RSecond.Bottom));
    (* HTTP *)
    addVariable(1, 'airSecond', '0', 'fsize', inttostr(TLParameters.FrameSize));
    (* HTTP *)
    addVariable(1, 'airSecond', '0', 'timeCode',
      FramesToShortStr(TLParameters.Position - TLParameters.ZeroPoint));
  except
    on E: Exception do
      WriteLog('MAIN', 'TAirSecond.SendHttp | ' + E.Message);
  end;
end;

initialization

MyPanelAir := TPanelAir.Create;

finalization

MyPanelAir.AirEvents.FreeInstance;
MyPanelAir.AirDevices.FreeInstance;
MyPanelAir.FreeInstance;
MyPanelAir := nil;

end.
