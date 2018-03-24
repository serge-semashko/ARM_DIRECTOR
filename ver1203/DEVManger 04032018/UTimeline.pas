unit UTimeline;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Buttons, ExtCtrls, StdCtrls, Grids, ImgList, Spin, ucommon,
    umyevents, system.json, uwebget;

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
        MediaColor: tcolor;
        // Значение цвета по умолчанию для события типа медиа
        TextColor: tcolor; // Значение цвета по умолчанию для события типа текст
        CharDuration: integer;
        // Значение длительности одного символа в милисекундах для события типа тектс
        EventDuration: integer;
        Protocol: string; // Название протокола и данные для протокола
        Manager: string; // Номер менеджера управления.
        // Минимальное значение пустого события типа текст.
        procedure Assign(obj: TTimelineOptions);
        procedure Clear;
        // Procedure WriteToStream(F : tStream);
        // Procedure ReadFromStream(F : tStream);
        constructor Create;
        destructor Destroy; override;
    end;
{$INCLUDE ..\helpers\utimeline_hdr.inc}

var
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
    // procedure EditTimeline(ARow : integer);
procedure GridDrawCellTimeline(Grid: tstringgrid; ACol, ARow: integer;
  Rect: Trect; State: TGridDrawState);
Procedure DeleteTimeline(ARow: integer);
// Procedure InitGridTimelines;
function SetTypeTimeline(ps: integer): TTypeTimeline;

implementation

uses UMain, ugrtimelines;

/// ////////////////////////// SSSSSSSSSS JSON
{$INCLUDE ..\helpers\utimeline_body.inc}
/// ////////////////////////// SSSSSSSSSS JSON end

function SetOffset(LenCV, CntElem, LenElem, ZnDel: integer): integer;
begin
    result := (LenCV - CntElem * LenElem - (CntElem - 1) * ZnDel) div 2;
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
        DevEvents[i].SetPhraseText('Device', inttostr(i + 1));
        DevEvents[i].SetPhraseData('Device', i + 1);
    end;
    MediaEvent := tmyevent.Create;
    MediaEvent.Assign(EventMedia);
    MediaEvent.Color := DefaultMediaColor;
    TextEvent := tmyevent.Create;
    TextEvent.Assign(EventText);
    TextEvent.Color := TLParameters.ForeGround;
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
        DevEvents[i].SetPhraseText('Device', inttostr(i + 1));
        DevEvents[i].SetPhraseData('Device', i + 1);
    end;
    MediaEvent.Assign(EventMedia);
    MediaEvent.Color := DefaultMediaColor;
    TextEvent.Assign(EventText);
    TextEvent.Color := TLParameters.ForeGround;
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

function CanDelete(ARow: integer): boolean;
var
    TypeTL: TTypeTimeline;
    i, cnt: integer;
begin
    // result := false;
    // with Form1.GridTimeLines do begin
    // typetl:=(Objects[0,ARow] as ttimelineoptions).TypeTL;
    // cnt:=0;
    // for i:=1 to RowCount-1
    // do if (Objects[0,i] as ttimelineoptions).TypeTL = typetl then cnt:=cnt+1;
    // if cnt > 1 then result:=true;
    // end; //with
end;

Procedure DeleteTimeline(ARow: integer);
var
    i: integer;
    txt, msg: string;
begin
    // if ARow < 1 then exit;
    // if ARow > Form1.GridTimeLines.RowCount-1 then exit;
    //
    // if  not CanDelete(ARow) then begin
    // case (Form1.GridTimeLines.Objects[0,ARow] as ttimelineoptions).TypeTL of
    // tldevice : msg:='Невозможно выполнить данное удаление, '
    // + #10#13 +'так как проект должен содержать хотя бы одну'
    // + #10#13 +'тайм-линию устройств.';
    // tltext   : msg:='Невозможно выполнить данное удаление, '
    // + #10#13 +'так как проект должен содержать хотя бы одну'
    // + #10#13 +'текстовую тайм-линию.';
    // tlmedia  : msg:='Невозможно  выполнить данное удаление, '
    // + #10#13 +'так как проект должен содержать хотя бы одну'
    // + #10#13 +'тайм-линию медиа данных.';
    // end; //case
    // //MyTextMessage('', msg, 1);
    // exit;
    // end;
    // txt := (Form1.GridTimeLines.Objects[0,ARow] as ttimelineoptions).Name;
    // //if not MyTextMessage('Вопрос', 'Вы действительно хотите удалить тайм-линию ''' + txt + '''?', 2) then exit;
    // with Form1.GridTimeLines do begin
    // for i:=ARow to RowCount-2 do begin
    // (Objects[0,i] as ttimelineoptions).Assign(Objects[0,i+1] as ttimelineoptions);
    // end;//for
    // Objects[0,RowCount-1]:=nil;
    // RowCount:=RowCount-1;
    // end;
    // Form1.GridTimeLines.Repaint;
end;

function IDTimelineExists(ID: integer): boolean;
var
    i: integer;
begin
    // result := false;
    // with Form1 do begin
    // for i:=1 to Form1.GridTimeLines.RowCount-1 do begin
    // if  GridTimelines.Objects[0,i] is TTimelineOptions then begin
    // if (GridTimelines.Objects[0,i] as TTimelineOptions).IDTimeline=ID then begin
    // result:=true;
    // exit;
    // end;
    // end;
    // end;
    // end;
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

procedure GridDrawCellTimeline(Grid: tstringgrid; ACol, ARow: integer;
  Rect: Trect; State: TGridDrawState);
Var
    RT, rt1: Trect;
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
                    Grid.Canvas.TextOut(Rect.Left + 10 { deltx } ,
                      Rect.Top + delty, 'Тайм-линии');
                end;
            2:
                begin
                    deltx := (Grid.ColWidths[ACol] - Grid.Canvas.TextWidth
                      ('Кол-во')) div 2;
                    delty := (Grid.RowHeights[ARow] - Grid.Canvas.TextHeight
                      ('Кол-во')) div 2;
                    Grid.Canvas.TextOut(Rect.Left + deltx, Rect.Top + delty,
                      'Кол-во');
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
    RT.Left := Rect.Left + deltx;
    RT.Top := Rect.Top + delty;
    RT.Right := Rect.Right - deltx;
    RT.Bottom := Rect.Bottom - delty;
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
                nm := nm + inttostr((Grid.Objects[0, ARow] as TTimelineOptions)
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
                    if (Grid.Objects[0, ARow] as TTimelineOptions).TypeTL = tldevice
                    then
                        strs := inttostr
                          ((Grid.Objects[0, ARow] as TTimelineOptions)
                          .CountDev);
                    deltx := (Grid.ColWidths[ACol] - Grid.Canvas.TextWidth
                      (strs)) div 2;
                    delty := (Grid.RowHeights[ARow] - Grid.Canvas.TextHeight
                      (strs)) div 2;
                    Grid.Canvas.TextOut(Rect.Left + deltx,
                      Rect.Top + delty, strs);
                end;
            End;
    end;
    // end;
end;

end.
