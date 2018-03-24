unit UTimeline;

// орплопрп
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Grids, ImgList, UIMGButtons, Spin,
  ucommon,
  umyevents, System.json;

type
  // TTypeTimeline = (tldevice, tltext, tlmedia);

  TTimelineOptions = Class(TObject)
  public
    TypeTL: TTypeTimeline; // Тип тайм-линии
    NumberBmp: integer; // Номер рисунка для заданного типа
    Name: string; // Название тайм-линии
    UserLock: string; // Имя пользователя заблокировавшего тайм-линию
    IDTimeline: longint; // Уникальный номер тайм-линии
    CountDev: integer; // Количество устройств
    DevEvents: array [0 .. 31] of tmyevent;
    // Значения для описания "типа события устройства" по умолчанию
    MediaEvent: tmyevent;
    // Значения для описания "типа события медиа" по умолчанию
    TextEvent: tmyevent;
    // Значения для описания "типа события текст" по умолчанию
    MediaColor: tcolor; // Значение цвета по умолчанию для события типа медиа
    TextColor: tcolor; // Значение цвета по умолчанию для события типа текст
    CharDuration: integer;
    // Значение длительности одного символа в милисекундах для события типа тектс
    EventDuration: integer; // Минимальное значение пустого события типа текст.
    Protocol: string; // Название протокола и данные для протокола
    Manager: string; // Номер менеджера управления.
    procedure Assign(obj: TTimelineOptions);
    procedure Clear;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    constructor Create;
    destructor Destroy; override;
  end;
  /// // SSSSSSSSSS JSON

  TTimelineOptionsJSON = Class helper for TTimelineOptions
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;
  /// // SSSSSSSSSS JSON end

  TFEditTimeline = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    pnDevice: TPanel;
    pnMedia: TPanel;
    pnText: TPanel;
    Edit1: TEdit;
    Label2: TLabel;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    pnDelete: TPanel;
    Label4: TLabel;
    Bevel1: TBevel;
    Image2: TImage;
    Edit2: TEdit;
    SpeedButton3: TSpeedButton;
    Label7: TLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit2: TSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit3: TEdit;
    SpinEdit3: TSpinEdit;
    Label13: TLabel;
    Bevel2: TBevel;
    Image3: TImage;
    ColorDialog1: TColorDialog;
    SpeedButton6: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Bevel3: TBevel;
    Image4: TImage;
    sbTextEvent: TSpeedButton;
    SpeedButton7: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure sbTextEventClick(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
    Procedure DrawIcons(ttl: TTypeTimeline; Selection: integer);
    function SelectIcons(X, Y: integer): integer;
  public
    { Public declarations }
  end;

var
  FEditTimeline: TFEditTimeline;
  OPTTimeline: TTimelineOptions;
  IconsLocation: array [1 .. 10] of Trect;
  DefaultColors: array [0 .. 31] of tcolor = (
    $0000CF5B,
    $00D8A520,
    $00D877D0,
    $002A7169,
    $00AA2669,
    $00AA26D5,
    $002FADD5,
    $0023C987,
    $004288A8,
    $001D7487,
    $00FA00FF,
    $00FFFF00,
    $0084C75C,
    $00288613,
    $0089819F,
    $00A8B19F,
    $00BAE2BF,
    $00ACEAE1,
    $009B9913,
    $00B89CD6,
    $0028D1E9,
    $009DC4D9,
    $009DC4F7,
    $001862BC,
    $0020788F,
    $000AACFF,
    $007E9FCD,
    $007E8398,
    $00D1ADB8,
    $00E3D4D2,
    $006EEBBB,
    $005D801F
  );
procedure EditTimeline(ARow: integer);
procedure GridDrawCellTimeline(Grid: tstringgrid; ACol, ARow: integer;
  Rect: Trect; State: TGridDrawState);
Procedure DeleteTimeline(ARow: integer);
procedure InitBTNSDEVICE(cv: tcanvas; obj: TObject; BTNSDEVICE: TBTNSPanel);
Procedure InitGridTimelines;
function SetTypeTimeline(ps: integer): TTypeTimeline;

implementation

uses UMain, UButtonOptions, uinitforms, umymessage, ugrtimelines, umyfiles,
  ufrprotocols,uwebget;

{$R *.dfm}

/// ////////////////////////// SSSSSSSSSS JSON
function TTimelineOptionsJSON.LoadFromJSONObject(json: tjsonObject): boolean;
var
  i1: integer;
  tmpjson: tjsonObject;
begin
  try
    TypeTL := GetVariableFromJson(json, 'TypeTL', TypeTL);
    NumberBmp := GetVariableFromJson(json, 'NumberBmp', NumberBmp);
    name := GetVariableFromJson(json, 'Name', Name);
    UserLock := GetVariableFromJson(json, 'UserLock', UserLock);
    IDTimeline := GetVariableFromJson(json, 'IDTimeline', IDTimeline);
    CountDev := GetVariableFromJson(json, 'CountDev', CountDev);
    for i1 := 0 to high(DevEvents) do
    begin
      tmpjson := tjsonObject(json.getvalue('DevEvents' + IntToStr(i1)));
      DevEvents[i1].LoadFromJSONObject(tmpjson);
    end;
    MediaEvent.LoadFromJSONObject(tjsonObject(json.getvalue('MediaEvent')));
    TextEvent.LoadFromJSONObject(tjsonObject(json.getvalue('TextEvent')));
    MediaColor := GetVariableFromJson(json, 'MediaColor', MediaColor);
    TextColor := GetVariableFromJson(json, 'TextColor', TextColor);
    CharDuration := GetVariableFromJson(json, 'CharDuration', CharDuration);
    EventDuration := GetVariableFromJson(json, 'EventDuration', EventDuration);
    // Protocol : string;                                 //Название протокола и данные для протокола
    Protocol := GetVariableFromJson(json, 'Protocol', Protocol);
    // Manager  : string;                                 //Номер менеджера управления.
    Manager := GetVariableFromJson(json, 'Manager', Manager);

  except
    on E: Exception do
  end;

end;

function TTimelineOptionsJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonObject;
begin
  json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
    as tjsonObject;
  result := true;
  if json = nil then
  begin
    result := false;
  end
  else
    LoadFromJSONObject(json);

end;

function TTimelineOptionsJSON.SaveToJSONObject: tjsonObject;
var
  str1: string;
  js1, json: tjsonObject;
  i1, i2: integer;
  jsondata: string;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)

begin
  json := tjsonObject.Create;
  try
    addVariableToJson(json, 'TypeTL', TypeTL);
    addVariableToJson(json, 'TypeTL', TypeTL);
    addVariableToJson(json, 'NumberBmp', NumberBmp);
    addVariableToJson(json, 'Name', Name);
    addVariableToJson(json, 'UserLock', UserLock);
    addVariableToJson(json, 'IDTimeline', IDTimeline);
    addVariableToJson(json, 'CountDev', CountDev);
    for i1 := 0 to high(DevEvents) do
      json.AddPair('DevEvents' + IntToStr(i1), DevEvents[i1].SaveToJSONObject);
    json.AddPair('MediaEvent', MediaEvent.SaveToJSONObject);
    json.AddPair('TextEvent', TextEvent.SaveToJSONObject);
    addVariableToJson(json, 'MediaColor', MediaColor);
    addVariableToJson(json, 'TextColor', TextColor);
    addVariableToJson(json, 'CharDuration', CharDuration);
    addVariableToJson(json, 'EventDuration', EventDuration);
    // Protocol : string;                                 //Название протокола и данные для протокола
    addVariableToJson(json, 'Protocol', Protocol);

    // Manager  : string;                                 //Номер менеджера управления.
    addVariableToJson(json, 'Manager', Manager);

  except
    on E: Exception do
  end;
  result := json;
end;

function TTimelineOptionsJSON.SaveToJSONStr: string;
var
  jsontmp: tjsonObject;
  JSONstr: string;
begin
  jsontmp := SaveToJSONObject;
  JSONstr := jsontmp.ToJSON;
  result := JSONstr;
end;

/// ////////////////////////// SSSSSSSSSS JSON end

Procedure TFEditTimeline.DrawIcons(ttl: TTypeTimeline; Selection: integer);
var
  i, clx, nx, deltx, delty, wx, hy: integer;
  nm: string;
  rt: Trect;
begin
  Image2.Canvas.FillRect(Image2.Canvas.ClipRect);
  Case ttl of
    tldevice:
      nm := 'Tools';
    tltext:
      nm := 'Text';
    tlmedia:
      nm := 'Media';
  end;
  clx := Image2.Width div 10;
  if clx < 24 then
  begin
    deltx := 2;
    wx := clx - 4;
  end
  else
  begin
    wx := 20;
    deltx := (clx - 20) div 2;
  end;
  delty := (Image2.Height - wx) div 2;
  nx := 0;
  for i := 1 to 10 do
  begin
    IconsLocation[i].Left := nx + deltx;
    IconsLocation[i].Right := IconsLocation[i].Left + wx;
    nx := IconsLocation[i].Right + deltx;
    IconsLocation[i].Top := delty;
    IconsLocation[i].Bottom := IconsLocation[i].Top + wx;
  end;

  for i := 1 to 10 do
  begin
    // nm + inttostr(i);
    if i = Selection then
    begin
      rt.Left := IconsLocation[i].Left - deltx;
      rt.Right := IconsLocation[i].Right + deltx;
      rt.Top := IconsLocation[i].Top - delty;
      rt.Bottom := IconsLocation[i].Bottom + delty;
      Image2.Canvas.Rectangle(rt);
    end;
    LoadBMPFromRes(Image2.Canvas, IconsLocation[i], wx, wx, nm + IntToStr(i));
  end;
end;

function TFEditTimeline.SelectIcons(X, Y: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 1 to 10 do
  begin
    if (X >= IconsLocation[i].Left) and (X <= IconsLocation[i].Right) and
      (Y >= IconsLocation[i].Top) and (Y <= IconsLocation[i].Bottom) then
    begin
      result := i;
      DrawIcons((OPTTimeline as TTimelineOptions).TypeTL, i);
      (OPTTimeline as TTimelineOptions).NumberBmp := i;
      exit;
    end;
  end;
end;

function SetOffset(LenCV, CntElem, LenElem, ZnDel: integer): integer;
begin
  result := (LenCV - CntElem * LenElem - (CntElem - 1) * ZnDel) div 2;
end;

procedure InitBTNSDEVICE(cv: tcanvas; obj: TObject; BTNSDEVICE: TBTNSPanel);
var
  i, j, cntbtns, cntx, cnty, cntend, szbtns, hghtbtn, ARow, abtn: integer;
begin
  BTNSDEVICE.Clear;
  cv.Brush.Color := BTNSDEVICE.BackGround;
  cv.FillRect(cv.ClipRect);
  BTNSDEVICE.Top := 10;
  BTNSDEVICE.Bottom := 10;
  BTNSDEVICE.Left := 5;
  BTNSDEVICE.Right := 5;
  if FormsFontName <> '' then
    cv.Font.Name := FormsFontName;
  if obj = nil then
    exit;
  if not(obj is TTimelineOptions) then
    exit;

  cntbtns := (obj as TTimelineOptions).CountDev;

  szbtns := 0;
  for i := 0 to cntbtns - 1 do
    if cv.TextWidth((obj as TTimelineOptions).DevEvents[i].ReadPhraseText
      ('Device')) > szbtns then
      szbtns := cv.TextWidth((obj as TTimelineOptions).DevEvents[i]
        .ReadPhraseText('Device'));
  szbtns := szbtns + 20;
  if szbtns < 50 then
    szbtns := 50;
  cntx := (cv.ClipRect.Right - cv.ClipRect.Left - 15) div (szbtns + 5);
  cnty := cntbtns div cntx;

  for i := 0 to cnty - 1 do
  begin
    ARow := BTNSDEVICE.AddRow;
    for j := 0 to cntx - 1 do
    begin
      abtn := ARow * cntx + j;
      BTNSDEVICE.Rows[ARow].AddButton((obj as TTimelineOptions).DevEvents[abtn]
        .ReadPhraseText('Device'), imnone);
    end;
  end;

  cntend := cntbtns mod cntx;
  if cntend <> 0 then
  begin
    ARow := BTNSDEVICE.AddRow;
    for i := 0 to cntend - 1 do
    begin
      abtn := ARow * cntx + i;
      BTNSDEVICE.Rows[ARow].AddButton((obj as TTimelineOptions).DevEvents[abtn]
        .ReadPhraseText('Device'), imnone);
    end;
  end;

  if BTNSDEVICE.Count <> 0 then
  begin
    hghtbtn := (cv.ClipRect.Bottom - cv.ClipRect.Top - BTNSDEVICE.Top -
      BTNSDEVICE.Bottom - BTNSDEVICE.Interval * (BTNSDEVICE.Count - 1))
      div BTNSDEVICE.Count;
    if hghtbtn > 30 then
      hghtbtn := 30;
  end
  else
    hghtbtn := 30;

  BTNSDEVICE.HeightRow := hghtbtn;
  BTNSDEVICE.Top := SetOffset(cv.ClipRect.Bottom - cv.ClipRect.Top,
    BTNSDEVICE.Count, hghtbtn, BTNSDEVICE.Interval);
  for i := 0 to BTNSDEVICE.Count - 1 do
  begin
    BTNSDEVICE.Rows[i].AutoSize := false;
    for j := 0 to BTNSDEVICE.Rows[i].Count - 1 do
    begin
      BTNSDEVICE.Rows[i].Btns[j].Color := (obj as TTimelineOptions)
        .DevEvents[i * cntx + j].Color;
      BTNSDEVICE.Rows[i].Btns[j].Font.Size := FormsFontSize + 2;
      BTNSDEVICE.Rows[i].Btns[j].Font.Color := FormsFontColor;
      BTNSDEVICE.Rows[i].Btns[j].Width := szbtns;
      BTNSDEVICE.Rows[i].Btns[j].Visible := true;
      BTNSDEVICE.Rows[i].Btns[j].Enable := true;
    end;
  end;

  BTNSDEVICE.Draw(cv);
end;

constructor TTimelineOptions.Create;
var
  i: integer;
begin
  inherited;
  TypeTL := tldevice;
  CountDev := 16;
  IDTimeline := 0;
  NumberBmp := 1;
  Name := 'Устройства';
  MediaColor := DefaultMediaColor;
  TextColor := TLParameters.ForeGround;
  CharDuration := 100;
  EventDuration := 25;
  for i := 0 to 31 do
  begin
    DevEvents[i] := tmyevent.Create;
    DevEvents[i].Assign(EventDevice);
    DevEvents[i].Color := DefaultColors[i];
    DevEvents[i].SetPhraseText('Device', IntToStr(i + 1));
    DevEvents[i].SetPhraseData('Device', i + 1);
  end;
  MediaEvent := tmyevent.Create;
  MediaEvent.Assign(EventMedia);
  MediaEvent.Color := DefaultMediaColor;
  TextEvent := tmyevent.Create;
  TextEvent.Assign(EventText);
  TextEvent.Color := TLParameters.ForeGround;
  Protocol := '';
  Manager := '';
end;

destructor TTimelineOptions.Destroy;
var
  i: integer;
begin
  FreeMem(@TypeTL);
  FreeMem(@CountDev);
  FreeMem(@IDTimeline);
  FreeMem(@NumberBmp);
  FreeMem(@Name);
  FreeMem(@UserLock);
  FreeMem(@MediaColor);
  FreeMem(@TextColor);
  FreeMem(@CharDuration);
  FreeMem(@EventDuration);
  FreeMem(@Protocol);
  FreeMem(@Manager);
  MediaEvent.Free;
  TextEvent.Free;
  for i := 31 to 0 do
    DevEvents[i].Free;
  FreeMem(@DevEvents);
  inherited Destroy;
end;

Procedure TTimelineOptions.Clear;
var
  i: integer;
begin
  TypeTL := tldevice;
  CountDev := 16;
  NumberBmp := 1;
  Name := '';
  UserLock := '';
  MediaColor := DefaultMediaColor;
  TextColor := DefaultTextColor;
  CharDuration := 100;
  EventDuration := 25;
  for i := 0 to 31 do
  begin
    DevEvents[i].Assign(EventDevice);
    DevEvents[i].Color := DefaultColors[i];
    DevEvents[i].SetPhraseText('Device', IntToStr(i + 1));
    DevEvents[i].SetPhraseData('Device', i + 1);
  end;
  MediaEvent.Assign(EventMedia);
  MediaEvent.Color := DefaultMediaColor;
  TextEvent.Assign(EventText);
  TextEvent.Color := TLParameters.ForeGround;
  Protocol := '';
  Manager := '';
end;

procedure TTimelineOptions.Assign(obj: TTimelineOptions);
var
  i: integer;
begin
  TypeTL := obj.TypeTL;
  CountDev := obj.CountDev;
  NumberBmp := obj.NumberBmp;
  Name := obj.Name;
  IDTimeline := obj.IDTimeline;
  MediaColor := obj.MediaColor;
  TextColor := obj.TextColor;
  CharDuration := obj.CharDuration;
  EventDuration := obj.EventDuration;
  for i := 0 to 31 do
  begin
    DevEvents[i].Assign(obj.DevEvents[i]);
  end;
  MediaEvent.Assign(obj.MediaEvent);
  TextEvent.Assign(obj.TextEvent);
  Protocol := obj.Protocol;
  Manager := obj.Manager;
end;

Procedure TTimelineOptions.WriteToStream(F: tStream);
var
  i: longint;
begin
  if TypeTL = tldevice then
    i := 0;
  if TypeTL = tltext then
    i := 1;
  if TypeTL = tlmedia then
    i := 2;
  F.WriteBuffer(i, SizeOf(i));
  F.WriteBuffer(NumberBmp, SizeOf(NumberBmp));
  WriteBufferStr(F, Name);
  WriteBufferStr(F, UserLock);
  F.WriteBuffer(IDTimeline, SizeOf(IDTimeline));
  F.WriteBuffer(CountDev, SizeOf(CountDev));
  F.WriteBuffer(MediaColor, SizeOf(MediaColor));
  F.WriteBuffer(TextColor, SizeOf(TextColor));
  F.WriteBuffer(CharDuration, SizeOf(CharDuration));
  F.WriteBuffer(EventDuration, SizeOf(EventDuration));
  F.WriteBuffer(CountDev, SizeOf(CountDev));
  MediaEvent.WriteToStream(F);
  TextEvent.WriteToStream(F);
  For i := 0 to 31 do
    DevEvents[i].WriteToStream(F);
  WriteBufferStr(F, Protocol);
  WriteBufferStr(F, Manager);
end;

function SetTypeTimeline(ps: integer): TTypeTimeline;
begin
  case ps of
    ord(tldevice):
      result := tldevice;
    ord(tltext):
      result := tltext;
    ord(tlmedia):
      result := tlmedia;
  end;
end;

Procedure TTimelineOptions.ReadFromStream(F: tStream);
var
  i: integer;
begin
  F.ReadBuffer(i, SizeOf(i));
  TypeTL := SetTypeTimeline(i);
  F.ReadBuffer(NumberBmp, SizeOf(NumberBmp));
  ReadBufferStr(F, Name);
  ReadBufferStr(F, UserLock);
  F.ReadBuffer(IDTimeline, SizeOf(IDTimeline));
  F.ReadBuffer(CountDev, SizeOf(CountDev));
  F.ReadBuffer(MediaColor, SizeOf(MediaColor));
  F.ReadBuffer(TextColor, SizeOf(TextColor));
  F.ReadBuffer(CharDuration, SizeOf(CharDuration));
  F.ReadBuffer(EventDuration, SizeOf(EventDuration));
  F.ReadBuffer(CountDev, SizeOf(CountDev));
  MediaEvent.ReadFromStream(F);
  TextEvent.ReadFromStream(F);
  For i := 0 to 31 do
    DevEvents[i].ReadFromStream(F);
  ReadBufferStr(F, Protocol);
  ReadBufferStr(F, Manager);
end;

function CanDelete(ARow: integer): boolean;
var
  TypeTL: TTypeTimeline;
  i, cnt: integer;
begin
  result := false;
  with Form1.GridTimeLines do
  begin
    TypeTL := (Objects[0, ARow] as TTimelineOptions).TypeTL;
    cnt := 0;
    for i := 1 to RowCount - 1 do
      if (Objects[0, i] as TTimelineOptions).TypeTL = TypeTL then
        cnt := cnt + 1;
    if cnt > 1 then
      result := true;
  end; // with
end;

Procedure DeleteTimeline(ARow: integer);
var
  i: integer;
  txt, msg: string;
begin
  if ARow < 1 then
    exit;
  if ARow > Form1.GridTimeLines.RowCount - 1 then
    exit;

  if not CanDelete(ARow) then
  begin
    case (Form1.GridTimeLines.Objects[0, ARow] as TTimelineOptions).TypeTL of
      tldevice:
        msg := 'Невозможно выполнить данное удаление, ' + #10#13 +
          'так как проект должен содержать хотя бы одну' + #10#13 +
          'тайм-линию устройств.';
      tltext:
        msg := 'Невозможно выполнить данное удаление, ' + #10#13 +
          'так как проект должен содержать хотя бы одну' + #10#13 +
          'текстовую тайм-линию.';
      tlmedia:
        msg := 'Невозможно  выполнить данное удаление, ' + #10#13 +
          'так как проект должен содержать хотя бы одну' + #10#13 +
          'тайм-линию медиа данных.';
    end; // case
    MyTextMessage('', msg, 1);
    exit;
  end;
  txt := (Form1.GridTimeLines.Objects[0, ARow] as TTimelineOptions).Name;
  if not MyTextMessage('Вопрос', 'Вы действительно хотите удалить тайм-линию '''
    + txt + '''?', 2) then
    exit;
  with Form1.GridTimeLines do
  begin
    for i := ARow to RowCount - 2 do
    begin
      (Objects[0, i] as TTimelineOptions)
        .Assign(Objects[0, i + 1] as TTimelineOptions);
    end; // for
    Objects[0, RowCount - 1] := nil;
    RowCount := RowCount - 1;
  end;
  Form1.GridTimeLines.Repaint;
end;

function IDTimelineExists(ID: integer): boolean;
var
  i: integer;
begin
  result := false;
  with Form1 do
  begin
    for i := 1 to Form1.GridTimeLines.RowCount - 1 do
    begin
      if GridTimeLines.Objects[0, i] is TTimelineOptions then
      begin
        if (GridTimeLines.Objects[0, i] as TTimelineOptions).IDTimeline = ID
        then
        begin
          result := true;
          exit;
        end;
      end;
    end;
  end;
end;

function AddIDTimeline(TypeTL: TTypeTimeline): integer;
var
  i: integer;
begin
  result := 0;
  case TypeTL of
    tldevice:
      begin
        For i := 1 to TLMaxDevice + 1 do
        begin
          if not IDTimelineExists(i) then
          begin
            result := i;
            exit;
          end;
        end;
      end;
    tltext:
      begin
        For i := 20 to 20 + TLMaxText - 1 do
        begin
          if not IDTimelineExists(i) then
          begin
            result := i;
            exit;
          end;
        end;
      end;
    tlmedia:
      begin
        For i := 40 to 40 + TLMaxMedia do
        begin
          if not IDTimelineExists(i) then
          begin
            result := i;
            exit;
          end;
        end;
      end;
  end;
end;

function CountTypeTLTimeline(TypeTL: TTypeTimeline): integer;
var
  i: integer;
begin
  result := 0;
  With Form1.GridTimeLines do
  begin
    for i := 1 to RowCount - 1 do
      if Objects[0, i] is TTimelineOptions then
        if (Objects[0, i] as TTimelineOptions).TypeTL = TypeTL then
          result := result + 1;
  End;
end;

function SetIDTimeline(pos: integer; TypeTL: TTypeTimeline): integer;
var
  i: integer;
begin
  result := 0;
  case TypeTL of
    tldevice:
      result := CountTypeTLTimeline(tldevice);
    tltext:
      result := 20 + CountTypeTLTimeline(tltext);
    tlmedia:
      result := 40 + CountTypeTLTimeline(tltext);
  end;
end;

function HowMuchTimelines(ttl: TTypeTimeline): integer;
var
  i: integer;
begin
  with Form1.GridTimeLines do
  begin
    result := 0;
    for i := 1 to RowCount - 1 do
      if Objects[0, i] is TTimelineOptions then
        if (Objects[0, i] as TTimelineOptions).TypeTL = ttl then
          result := result + 1;
  end;
end;

function FindPositionTimeline: integer;
var
  ps: integer;
begin
  result := -1;
  case OPTTimeline.TypeTL of
    tldevice:
      result := HowMuchTimelines(tldevice) + 1;
    tltext:
      result := HowMuchTimelines(tldevice) + HowMuchTimelines(tltext) + 1;
    tlmedia:
      result := HowMuchTimelines(tldevice) + HowMuchTimelines(tltext) +
        HowMuchTimelines(tlmedia) + 1;
  end;
end;

procedure SetValuesTimeline;
begin
  case (OPTTimeline as TTimelineOptions).TypeTL of
    tldevice:
      begin
        OPTTimeline.Name := FEditTimeline.Edit1.Text;
        OPTTimeline.CountDev := FEditTimeline.SpinEdit1.Value;
      end;
    tltext:
      begin
        OPTTimeline.Name := FEditTimeline.Edit3.Text;
        OPTTimeline.EventDuration := FEditTimeline.SpinEdit2.Value;
        OPTTimeline.CharDuration := FEditTimeline.SpinEdit3.Value;
        OPTTimeline.TextColor := FEditTimeline.Image3.Canvas.Brush.Color;
      end;
    tlmedia:
      begin
        OPTTimeline.Name := FEditTimeline.Edit4.Text;
        OPTTimeline.MediaColor := FEditTimeline.Image4.Canvas.Brush.Color;
      end;
  end;
end;

function CheckedQuantityTimelines: boolean;
begin
  result := true;
  case OPTTimeline.TypeTL of
    tldevice:
      if HowMuchTimelines(tldevice) + 1 > TLMaxDevice then
      begin
        MyTextMessage('', 'Максимальное количество тайм-линий устройств ' +
          ' в данной версии программы не должно быть больше ' +
          IntToStr(TLMaxDevice) + '.', 1);
        result := false;
      end;
    tltext:
      if HowMuchTimelines(tltext) + 1 > TLMaxText then
      begin
        MyTextMessage('', 'Максимальное количество текстовых тайм-линий ' +
          ' в данной версии программы не должно быть больше ' +
          IntToStr(TLMaxText) + '.', 1);
        result := false;
      end;
    tlmedia:
      if HowMuchTimelines(tlmedia) + 1 > TLMaxMedia then
      begin
        MyTextMessage('', 'Максимальное количество медиа тайм-линий ' +
          ' в данной версии программы не должно быть больше ' +
          IntToStr(TLMaxMedia) + '.', 1);
        result := false;
      end;
  end;
end;

procedure EditTimeline(ARow: integer);
var
  i, cellpos: integer;
begin
  FEditTimeline.Panel1.Visible := true;;
  FEditTimeline.Label1.Visible := true;
  FEditTimeline.Label1.Caption := 'Тип тайм-линии:';
  FEditTimeline.SpeedButton1.Caption := 'Сохранить';
  FEditTimeline.Image2.Visible := true;
  FEditTimeline.Label7.Visible := true;
  if ARow <> -1 then
  begin
    OPTTimeline.Assign(Form1.GridTimeLines.Objects[0, ARow]
      as TTimelineOptions);
    FEditTimeline.Caption := 'Редактирование тайм-линии.';
    FEditTimeline.ComboBox1.Visible := false;
  end
  else
  begin
    OPTTimeline.Clear;
    FEditTimeline.Caption := 'Новая тайм-линия.';
    FEditTimeline.ComboBox1.Visible := true;
    FEditTimeline.Edit1.Text := '';
    FEditTimeline.Edit3.Text := '';
    FEditTimeline.Edit4.Text := '';
  end;

  FEditTimeline.SpinEdit1.Value := OPTTimeline.CountDev;
  FEditTimeline.DrawIcons((OPTTimeline as TTimelineOptions).TypeTL,
    (OPTTimeline as TTimelineOptions).NumberBmp);
  case (OPTTimeline as TTimelineOptions).TypeTL of
    tldevice:
      begin
        FEditTimeline.pnDevice.Visible := true;
        FEditTimeline.pnText.Visible := false;
        FEditTimeline.pnMedia.Visible := false;
        FEditTimeline.pnDelete.Visible := false;
        FEditTimeline.ComboBox1.ItemIndex := 0;
        FEditTimeline.Edit1.Text := OPTTimeline.Name;
        If ARow <> -1 then
          FEditTimeline.Label1.Caption := 'Тип тайм-линии: Устройства';

      end;
    tltext:
      begin
        FEditTimeline.pnDevice.Visible := false;
        FEditTimeline.pnText.Visible := true;
        FEditTimeline.pnMedia.Visible := false;
        FEditTimeline.pnDelete.Visible := false;
        FEditTimeline.ComboBox1.ItemIndex := 1;
        FEditTimeline.Edit3.Text := OPTTimeline.Name;
        // FEditTimeline.SpinEdit2.Value:=OPTTimeline.EventDuration;
        // FEditTimeline.SpinEdit3.Value:=OPTTimeline.CharDuration;
        // FEditTimeline.Image3.Canvas.Brush.Color:=OPTTimeline.TextColor;
        If ARow <> -1 then
          FEditTimeline.Label1.Caption := 'Тип тайм-линии: Текст';
      end;
    tlmedia:
      begin
        FEditTimeline.pnDevice.Visible := false;
        FEditTimeline.pnText.Visible := false;
        FEditTimeline.pnMedia.Visible := true;
        FEditTimeline.pnDelete.Visible := false;
        FEditTimeline.ComboBox1.ItemIndex := 2;
        FEditTimeline.Edit4.Text := OPTTimeline.Name;
        // FEditTimeline.Image4.Canvas.Brush.Color:=OPTTimeline.MediaColor;
        If ARow <> -1 then
          FEditTimeline.Label1.Caption := 'Тип тайм-линии: Media';
      end;
  else
    exit;
  end;
  FEditTimeline.SpinEdit2.Value := OPTTimeline.EventDuration;
  FEditTimeline.SpinEdit3.Value := OPTTimeline.CharDuration;
  FEditTimeline.Image3.Canvas.Brush.Color := OPTTimeline.TextColor;
  FEditTimeline.Image4.Canvas.Brush.Color := OPTTimeline.MediaColor;
  FEditTimeline.Image3.Canvas.FillRect(FEditTimeline.Image3.Canvas.ClipRect);
  FEditTimeline.Image4.Canvas.FillRect(FEditTimeline.Image4.Canvas.ClipRect);

  FEditTimeline.ShowModal;
  If FEditTimeline.ModalResult = mrOk then
  begin
    SetValuesTimeline;
    if ARow = -1 then
    begin
      if not CheckedQuantityTimelines then
        exit;
      cellpos := FindPositionTimeline;
      Form1.GridTimeLines.RowCount := Form1.GridTimeLines.RowCount + 1;
      if not(Form1.GridTimeLines.Objects[0, Form1.GridTimeLines.RowCount - 1]
        is TTimelineOptions) then
        Form1.GridTimeLines.Objects[0, Form1.GridTimeLines.RowCount - 1] :=
          TTimelineOptions.Create;
      for i := Form1.GridTimeLines.RowCount - 1 downto cellpos do
      begin
        (Form1.GridTimeLines.Objects[0, i] as TTimelineOptions)
          .Assign((Form1.GridTimeLines.Objects[0, i - 1] as TTimelineOptions));
      end;

      (Form1.GridTimeLines.Objects[0, cellpos] as TTimelineOptions)
        .Assign(OPTTimeline);
      Form1.GridTimeLines.Row := cellpos;
      // IDTL:=SetIDTimeline;

      (Form1.GridTimeLines.Objects[0, cellpos] as TTimelineOptions).IDTimeline
        := AddIDTimeline((Form1.GridTimeLines.Objects[0,
        cellpos] as TTimelineOptions).TypeTL);

    end
    else
    begin
      // SetValuesTimeline;
      (Form1.GridTimeLines.Objects[0, ARow] as TTimelineOptions)
        .Assign(OPTTimeline);
    end;
  end;
end;

procedure TFEditTimeline.SpeedButton2Click(Sender: TObject);
begin
  FEditTimeline.ModalResult := mrCancel;
  // if colordialog1.Execute then;
end;

procedure GridDrawCellTimeline(Grid: tstringgrid; ACol, ARow: integer;
  Rect: Trect; State: TGridDrawState);
Var
  rt, rt1: Trect;
  strs, nm, txt: string;
  deltx, delty, TypeTL: integer;
  oldfontsize: integer;
  oldfontcolor: tcolor;
begin
  rt1.Left := Rect.Left - 5;
  rt1.Right := Rect.Right + 5;
  rt1.Top := Rect.Top;
  rt1.Bottom := Rect.Bottom;
  Grid.Canvas.FillRect(rt1);
  if ARow = 0 then
  begin
    Grid.Canvas.Font.Style := Grid.Canvas.Font.Style + [fsBold];
    case ACol of
      1:
        begin
          deltx := (Grid.ColWidths[ACol] - Grid.Canvas.TextWidth
            ('Тайм-линии')) div 2;
          delty := (Grid.RowHeights[ARow] - Grid.Canvas.TextHeight
            ('Тайм-линии')) div 2;
          Grid.Canvas.TextOut(Rect.Left + 10 { deltx } , Rect.Top + delty,
            'Тайм-линии');
        end;
      2:
        begin
          deltx := (Grid.ColWidths[ACol] - Grid.Canvas.TextWidth
            ('Кол-во')) div 2;
          delty := (Grid.RowHeights[ARow] - Grid.Canvas.TextHeight
            ('Кол-во')) div 2;
          Grid.Canvas.TextOut(Rect.Left + deltx, Rect.Top + delty, 'Кол-во');
        end;
    end; // case
    exit;
  end;
  if ARow = Grid.Selection.Top then
  begin
    Grid.Canvas.Brush.Color := ProgrammColor;
    Grid.Canvas.Pen.Color := $AAAAAA;
    Grid.Canvas.Pen.Width := 1;
    Grid.Canvas.Pen.Style := psClear;
    Grid.Canvas.FillRect(rt1);
  end;
  Grid.Canvas.Brush.Color := ProgrammColor;
  Grid.Canvas.Pen.Color := $AAAAAA;
  Grid.Canvas.Pen.Width := 1;
  deltx := (Grid.ColWidths[ACol] - 25) div 2;
  delty := (Grid.RowHeights[ARow] - 25) div 2;
  rt.Left := Rect.Left + deltx;
  rt.Top := Rect.Top + delty;
  rt.Right := Rect.Right - deltx;
  rt.Bottom := Rect.Bottom - delty;
  Case ACol of
    0:
      Begin
        Case (Grid.Objects[0, ARow] as TTimelineOptions).TypeTL of
          tldevice:
            nm := 'Tools';
          tltext:
            nm := 'Text';
          tlmedia:
            nm := 'Media';
        end; // case
        nm := nm + IntToStr((Grid.Objects[0, ARow] as TTimelineOptions)
          .NumberBmp);
        LoadBMPFromRes(Grid.Canvas, Rect, 25, 25, nm);
      End;
    1:
      Begin
        if (Grid.Objects[0, ARow] is TTimelineOptions) then
        begin
          // deltx:= (grid.ColWidths[ACol] - grid.Canvas.TextWidth((Grid.Objects[0,ARow] as TTimelineOptions).Name)) div 2;
          delty := (Grid.RowHeights[ARow] - Grid.Canvas.TextHeight
            ((Grid.Objects[0, ARow] as TTimelineOptions).Name)) div 2;
          // txt := (Grid.Objects[0,ARow] as TTimelineOptions).Name + '(' + inttostr((Grid.Objects[0,ARow] as TTimelineOptions).IDTimeline) +')';
          // grid.Canvas.TextOut(Rect.Left + 10,Rect.Top + delty,txt);
          Grid.Canvas.TextOut(Rect.Left + 10, Rect.Top + delty,
            (Grid.Objects[0, ARow] as TTimelineOptions).Name);
        end;
      End;
    2:
      Begin
        if (Grid.Objects[0, ARow] is TTimelineOptions) then
        begin
          strs := '';
          if (Grid.Objects[0, ARow] as TTimelineOptions).TypeTL = tldevice then
            strs := IntToStr((Grid.Objects[0, ARow] as TTimelineOptions)
              .CountDev);
          deltx := (Grid.ColWidths[ACol] - Grid.Canvas.TextWidth(strs)) div 2;
          delty := (Grid.RowHeights[ARow] - Grid.Canvas.TextHeight(strs)) div 2;
          Grid.Canvas.TextOut(Rect.Left + deltx, Rect.Top + delty, strs);
        end;
      End;
  end;
  // end;
end;

procedure TFEditTimeline.FormCreate(Sender: TObject);
var
  rt: Trect;
begin
  InitEditTimeline;
end;

procedure TFEditTimeline.SpinEdit1Change(Sender: TObject);
begin
  if OPTTimeline = nil then
    exit;
  if not(OPTTimeline is TTimelineOptions) then
    exit;
  if SpinEdit1.Text = '' then
    exit;
  if SpinEdit1.Text = '-' then
    exit;
  if SpinEdit1.Text = '+' then
    exit;
  if SpinEdit1.Value < 1 then
    SpinEdit1.Value := 1;
  if SpinEdit1.Value > 32 then
    SpinEdit1.Value := 32;
  (OPTTimeline as TTimelineOptions).CountDev := SpinEdit1.Value;
  BTNSDEVICE.BackGround := FormsColor;
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.SpeedButton1Click(Sender: TObject);
begin
  case OPTTimeline.TypeTL of
    tldevice:
      if trim(Edit1.Text) <> '' then
        ModalResult := mrOk
      else
        ActiveControl := Edit1;
    tltext:
      if trim(Edit3.Text) <> '' then
        ModalResult := mrOk
      else
        ActiveControl := Edit3;
    tlmedia:
      if trim(Edit4.Text) <> '' then
        ModalResult := mrOk
      else
        ActiveControl := Edit4;
  end;
end;

procedure TFEditTimeline.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  zn: integer;
begin
  if Button <> mbLeft then
    exit;
  zn := BTNSDEVICE.ClickButton(Image1.Canvas, X, Y);
  case zn of
    0 .. 31:
      begin
        EditButtonsOptions(zn, OPTTimeline);
        InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
      end;
  end;
end;

procedure TFEditTimeline.ComboBox1Change(Sender: TObject);
begin
  Case ComboBox1.ItemIndex of
    0:
      begin
        FEditTimeline.pnDevice.Visible := true;
        FEditTimeline.pnText.Visible := false;
        FEditTimeline.pnMedia.Visible := false;
        FEditTimeline.pnDelete.Visible := false;
        (OPTTimeline as TTimelineOptions).TypeTL := tldevice;
        DrawIcons(tldevice, 1);
      end;
    1:
      begin
        FEditTimeline.pnDevice.Visible := false;
        FEditTimeline.pnText.Visible := true;
        FEditTimeline.pnMedia.Visible := false;
        FEditTimeline.pnDelete.Visible := false;
        (OPTTimeline as TTimelineOptions).TypeTL := tltext;
        DrawIcons(tltext, 1);
      end;
    2:
      begin
        FEditTimeline.pnDevice.Visible := false;
        FEditTimeline.pnText.Visible := false;
        FEditTimeline.pnMedia.Visible := true;
        FEditTimeline.pnDelete.Visible := false;
        (OPTTimeline as TTimelineOptions).TypeTL := tlmedia;
        DrawIcons(tlmedia, 1);
      end;
  End;
end;

procedure TFEditTimeline.SpeedButton3Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to 31 do
    OPTTimeline.DevEvents[i].SetPhraseText('Device',
      trim(Edit2.Text) + OPTTimeline.DevEvents[i].ReadPhraseText('Device'));
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.SpeedButton5Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to 31 do
    OPTTimeline.DevEvents[i].SetPhraseText('Device', IntToStr(i + 1));
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.SpeedButton4Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  for i := 0 to 31 do
  begin
    s := OPTTimeline.DevEvents[i].ReadPhraseText('Device');
    OPTTimeline.DevEvents[i].SetPhraseText('Device',
      StringReplace(s, Edit2.Text, '', [rfReplaceAll, rfIgnoreCase]));
  end;
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button <> mbLeft then
    exit;
  SelectIcons(X, Y);
end;

procedure TFEditTimeline.Image3Click(Sender: TObject);
begin
  ColorDialog1.Color := Image3.Canvas.Brush.Color;
  if ColorDialog1.Execute then
  begin
    Image3.Canvas.Brush.Color := ColorDialog1.Color;
    Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  end;
end;

procedure TFEditTimeline.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  pos: integer;
begin
  BTNSDEVICE.MouseMove(Image1.Canvas, X, Y);
end;

Procedure InitGridTimelines;
var
  i, hghtgr: integer;
begin
  with Form1 do
  begin
    GridTimeLines.RowCount := 4;
    // GridTimeLines.Height:=GridTimelines.DefaultRowHeight * (TLMaxDevice + TLMaxText + TLMaxMedia+1) + 20;
    // GridTimeLines.Top:=Panel2.ClientRect.Bottom - imgButtonsProject.Height - Bevel9.Height
    // - imgButtonsControlProj.Height - GridTimeLines.Height - 40;

    GridTimeLines.Top := Bevel8.Top + 15;
    GridTimeLines.Height := imgButtonsControlProj.Top - Bevel8.Top - 25;

    if not(GridTimeLines.Objects[0, 1] is TTimelineOptions) then
      GridTimeLines.Objects[0, 1] := TTimelineOptions.Create;
    (GridTimeLines.Objects[0, 1] as TTimelineOptions).TypeTL := tldevice;
    (GridTimeLines.Objects[0, 1] as TTimelineOptions).Name := 'Камеры';
    (GridTimeLines.Objects[0, 1] as TTimelineOptions).CountDev := 32;
    // IDTL:=IDTL + 1;
    (GridTimeLines.Objects[0, 1] as TTimelineOptions).IDTimeline :=
      SetIDTimeline(1, tldevice);

    if not(GridTimeLines.Objects[0, 2] is TTimelineOptions) then
      GridTimeLines.Objects[0, 2] := TTimelineOptions.Create;
    (GridTimeLines.Objects[0, 2] as TTimelineOptions).TypeTL := tltext;
    (GridTimeLines.Objects[0, 2] as TTimelineOptions).Name := 'Текст песни';
    // IDTL:=IDTL + 1;
    (GridTimeLines.Objects[0, 2] as TTimelineOptions).IDTimeline :=
      SetIDTimeline(2, tltext);

    if not(GridTimeLines.Objects[0, 3] is TTimelineOptions) then
      GridTimeLines.Objects[0, 3] := TTimelineOptions.Create;
    (GridTimeLines.Objects[0, 3] as TTimelineOptions).TypeTL := tlmedia;
    (GridTimeLines.Objects[0, 3] as TTimelineOptions).Name := 'Media';
    // IDTL:=IDTL + 1;
    (GridTimeLines.Objects[0, 3] as TTimelineOptions).IDTimeline :=
      SetIDTimeline(3, tlmedia);

    GridTimeLines.ColWidths[1] := 180;
    GridTimeLines.ColWidths[2] := GridTimeLines.Width - GridTimeLines.ColWidths
      [0] - GridTimeLines.ColWidths[1];

    hghtgr := 0;
    for i := 0 to GridTimeLines.RowCount - 1 do
      hghtgr := hghtgr + GridTimeLines.RowHeights[i];
    GridTimeLines.Height := hghtgr;
  end;
end;

procedure TFEditTimeline.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    SpeedButton1Click(nil);
  if Key = 27 then
    ModalResult := mrCancel;
end;

procedure TFEditTimeline.SpeedButton6Click(Sender: TObject);
begin
  // MyTextMessage('','Не обнаруженно ни одного модуля управления устройствами.'
  // + #13#10 +'Настройка оборудования не доступна',1);
  if OPTTimeline.TypeTL = tldevice then
    SetProtocol(OPTTimeline)
  else
    MyTextMessage('Сообщение',
      'Отсутсвуют протоколы поддерживающие данный тип тайм-линий.', 1);
end;

procedure TFEditTimeline.Image4Click(Sender: TObject);
begin
  ColorDialog1.Color := Image4.Canvas.Brush.Color;
  if ColorDialog1.Execute then
  begin
    Image4.Canvas.Brush.Color := ColorDialog1.Color;
    Image4.Canvas.FillRect(Image4.Canvas.ClipRect);
  end;
end;

procedure TFEditTimeline.sbTextEventClick(Sender: TObject);
begin
  if EditButtonsOptions(-1, OPTTimeline) then
  begin
    Image3.Canvas.Brush.Color := OPTTimeline.TextEvent.Color;
    Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  end;
end;

procedure TFEditTimeline.SpeedButton7Click(Sender: TObject);
begin
  if EditButtonsOptions(-1, OPTTimeline) then
  begin
    Image4.Canvas.Brush.Color := OPTTimeline.MediaEvent.Color;
    Image4.Canvas.FillRect(Image3.Canvas.ClipRect);
  end;
end;

end.
