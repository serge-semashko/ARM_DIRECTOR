unit UGRTimelines;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline,
    ucommon,
    umyevents, OpenGL, system.json, uwebget;

Type

    TEditingArea = (edNone, edStart, edCenter, edFinish);

    TTLParameters = Class(TObject)
    public
        BackGround: tcolor; // Фоновый цвет
        ForeGround: tcolor; // Цвет пустых тайм-линий
        MaxFrameSize: integer; // Максимальный размер кадра в пиксилях
        FrameSize: integer; // Текущий размер кадра
        Start: longint; // Позиция курсора начала воспроизведения (кадры)
        Finish: longint; // Позиция курсора конца воспроизведения (кадры)
        // NTK    : longint;           //Начальный тайм код (кадры)
        ZeroPoint: longint; // Нулевая точка отсчета начальный тайм-код (кадры)
        MyCursor: longint;
        // Положение курсора относительно начала экрана (пиксили)
        ScreenStart: longint; // Относительная позиция начала экрана (пиксили)
        ScreenEnd: longint; // Относительная позиция конца экрана (пиксли)
        Preroll: longint; // Начальный буффер (кадры)
        Postroll: longint; // Конечный буффер (кадры)
        Duration: longint; // Общая длителность клипа (кадры)
        EndPoint: longint; // Положение конца клипа Preroll+Duration (кадры)
        lrTransperent0: tcolor; // Цвет прозрачности для слоя 0
        lrTransperent1: tcolor; // Цвет прозрачности для слоя 1
        lrTransperent2: tcolor; // Цвет прозрачности для слоя 2
        Position: longint; // Tекущая позиция клипа (кадры)
        ScreenStartFrame: longint; // Абсолютная позиция начала экрана (кадры)
        ScreenEndFrame: longint; // Абсолютная позиция конца экрана (кадры)
        StopPosition: longint; // Позиция остановки клип (кадры)
        Scaler: real; // Отношение ширины Bitmap к ширине экрана
        vlcmode: TPlayerMode;
        TLTimeCode: string;
        command: string;
        procedure InitParameters;
        procedure UpdateParameters;
        procedure SetScreenBoanders;
        Procedure WriteToStream(F: tStream);
        Procedure ReadFromStream(F: tStream);
        Constructor Create;
        Destructor Destroy; override;
    end;

    TTLScaler = Class(TObject)
    public
        PenColor: tcolor;
        FontColor: tcolor;
        FontSize: integer;
        FontName: tfontname;
        Rect: TRect;
        procedure DrawScaler(cv: tcanvas);
        // Procedure WriteToStream(F : tStream);
        // Procedure ReadFromStream(F : tStream);
        procedure UpdateData;
        Constructor Create;
        Destructor Destroy; override;
    end;

    TTLTimeline = Class(TObject)
    public
        IDTimeline: longint;
        TypeTL: TTypeTimeline;
        Block: boolean;
        Status: integer;
        Rect: TRect;
        Count: integer;
        Events: Array of TMyEvent;

        function AddEvent(Position: longint; psgrd, psclr: integer): integer;
        function FindEventID(IdEvent: longint): integer;
        function FindEvent(Position: longint): integer;
        procedure Delete(Position: longint);
        procedure DeleteID(IdEvent: longint);
        procedure Clear;
        procedure Assign(ListEvents: TTLTimeline);
        // Procedure DrawDeviceTimeline(cv : tcanvas; EPos : integer);
        // Procedure DrawTextTimeline(cv : tcanvas; EPos : integer);
        // Procedure DrawMediaTimeline(cv : tcanvas; Color : tcolor; EPos : integer);
        // procedure DrawTimeline(cv : tcanvas; NomTl : integer; EPos : integer);
        // Procedure WriteToStream(F : tStream);
        // Procedure ReadFromStream(F : tStream);
        // procedure UpdateData;
        Constructor Create;
        Destructor Destroy; override;
    end;

    TTLEditor = Class(TObject)
    public
        Index: integer;
        isZoneEditor: boolean;
        DoubleClick: boolean;
        IDTimeline: longint;
        Block: boolean;
        Status: integer;
        TypeTL: TTypeTimeline;
        Rect: TRect;
        Count: integer;
        Events: Array of TMyEvent;
        function AddEvent(Position: longint; psgrd, psclr: integer): integer;
        function InsertDevice(Position: longint): integer;
        function InsertText(Position: longint): integer;
        function InsertMarker(Position: longint): integer;
        procedure Clear;
        procedure DeleteEvent(Position: longint);
        procedure Assign(ttl: TTLTimeline; Indx: integer);
        procedure ReturnEvents(ttl: TTLTimeline);
        // procedure DrawEditorDevice(cv : tcanvas; EPos : integer);
        // procedure UpdateScreenDevice(cv : tcanvas);
        // procedure DrawEditorDeviceEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
        // procedure UpdateScreenText(cv : tcanvas);
        // procedure DrawEditorTextEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
        // procedure DrawEditorMediaEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
        // procedure DrawEditorText(cv : tcanvas; EPos : integer);
        // procedure DrawEditorMedia(cv : tcanvas; EPos : integer);
        // procedure DrawEditor(cv : tcanvas; EPos : integer);
        // procedure UpdateScreen(cv : tcanvas);
        // procedure MouseClick(cv : tcanvas; X,Y : integer);
        // procedure MouseMove(cv : tcanvas; X,Y : integer);
        // procedure UpdateEventData(ev : TMyEvent);
        function FindEventPos(evframe: longint): integer;
        function FirstScreenEvent: integer;
        Function LastScreenEvent: integer;
        function CurrentEvents: TEventReplay;
        procedure AllSelectFalse;
        procedure EventsSelectFalse;
        // Procedure WriteToStream(F : tStream);
        // Procedure SaveToFile(FileName : string);
        // Procedure ReadFromStream(F : tStream);
        // procedure LoadFromFile(FileName : string);
        Constructor Create;
        Destructor Destroy; override;
    end;

    TTLZone = Class(TObject)
    private
        Countbuffer: integer;
        TLBuffer: array of TTLTimeline;
        // DownTimeline : boolean;
        // DownEditor : boolean;
        // DownScaler : boolean;
        XDown: integer;
        CRStart: tcolor;
        CRStartDown: boolean;
        CREnd: tcolor;
        CREndDown: boolean;
    public
        XViewer: integer;
        DownViewer: boolean;
        DownTimeline: boolean;
        DownEditor: boolean;
        DownScaler: boolean;
        TLScaler: TTLScaler;
        TLEditor: TTLEditor;
        Count: integer;
        Timelines: array of TTLTimeline;
        // Procedure DrawLayer1;
        procedure ClearBuffer;
        procedure WriteToBuffer;
        function FindInBuffer(ID: longint): integer;
        // Procedure DownZoneTimeLines(cv : tcanvas; Button: TMouseButton; Shift: TShiftState;  X, Y : integer);
        // Procedure MoveMouseTimeline(cv : tcanvas; Shift: TShiftState; X, Y : integer);
        // Procedure UPZoneTimeline(cv : tcanvas; Button: TMouseButton; Shift: TShiftState; X, Y : integer);
        Procedure AddTimeline(ID: longint);
        function FindTimeline(ID: longint): integer;
        Procedure InitTimelines(bmp: tbitmap);
        procedure ClearTimeline;
        // Procedure DrawLayer2(cv : tcanvas);
        // Procedure DrawBitmap(bmp : Tbitmap);
        // function PlusHoriz : integer;
        // function MinusHoriz : integer;
        // Procedure DrawTimelines(cv : tcanvas; bmp: tbitmap);
        // Procedure DrawFlash(nomevent : integer);
        // procedure DrawCursorStart(cv : tcanvas);
        // function MouseInStartCursor(cv : tcanvas; X,Y : integer) : boolean;
        // function MouseInEndCursor(cv : tcanvas; X,Y : integer) : boolean;
        // procedure DrawCursorEnd(cv : tcanvas);
        Procedure SetEditingEventDevice;
        Procedure SetEditingEventText;
        Procedure SetEditingEventMedia;
        // Procedure WriteToStream(F : tStream);
        // Procedure ReadFromStream(F : tStream);
        // procedure ClearZone;
        procedure UpdateCursor;
        Constructor Create;
        Destructor Destroy; override;
    end;
    // SSSS Save To JSON
{$INCLUDE ../helpers/ugrtimelines_hdr.inc}
    // SSSS Save To JSON end

Var
    TLZone: TTLZone;
    TLParameters: TTLParameters;
    TLP_server: TTLParameters;

    EditingEvent: integer = -1;
    EditingArea: TEditingArea;
    EditingStart: longint;
    EditingFinish: longint;
    LastSelection: longint = -1;

    MyTLEdit: TTLEditor;

implementation

uses umain, udrawtimelines, USetEventData;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// процедуры и функции для отрисовки зоны курсоров
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLParametrs отвечает за параметры отрисовки зоны тайм-линий
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLParameters.Create;
begin
    inherited;
    BackGround := TLBackGround;;
    ForeGround := SmoothColor(TLZoneNamesColor, 16);
    MaxFrameSize := 10;
    FrameSize := 5;
    Start := 0;
    Finish := 0;
    MyCursor := 100;
    ScreenStart := 0;
    ScreenEnd := 0;
    Preroll := 250;
    Postroll := 3000;
    Duration := 0;
    lrTransperent0 := clWhite;
    lrTransperent1 := clWhite;
    lrTransperent2 := clWhite;
    Position := 257;
    ScreenStartFrame := 0;
    ScreenEndFrame := 0;
    ZeroPoint := 0;
    StopPosition := 0;
    EndPoint := Preroll + Duration;
    Scaler := 1;
end;

Destructor TTLParameters.Destroy;
begin
    FreeMem(@BackGround);
    FreeMem(@ForeGround);
    FreeMem(@MaxFrameSize);
    FreeMem(@FrameSize);
    FreeMem(@Start);
    FreeMem(@Finish);
    FreeMem(@MyCursor);
    FreeMem(@ScreenStart);
    FreeMem(@ScreenEnd);
    FreeMem(@Preroll);
    FreeMem(@Postroll);
    FreeMem(@Duration);
    FreeMem(@lrTransperent0);
    FreeMem(@lrTransperent1);
    FreeMem(@lrTransperent2);
    FreeMem(@Position);
    FreeMem(@Scaler);
    FreeMem(@StopPosition);
    FreeMem(@ScreenStartFrame);
    FreeMem(@ScreenEndFrame);
    FreeMem(@ZeroPoint);
    FreeMem(@EndPoint);
    inherited;
end;

procedure TTLParameters.SetScreenBoanders;
begin
    TLParameters.ScreenStart := TLParameters.Position * TLParameters.FrameSize -
      TLParameters.MyCursor;
    // TLParameters.ScreenEnd := TLParameters.ScreenStart + Form1.imgTimelines.Width;
    TLParameters.ScreenStartFrame :=
      Round(TLParameters.ScreenStart / TLParameters.FrameSize);
    TLParameters.ScreenEndFrame :=
      Round(TLParameters.ScreenEnd / TLParameters.FrameSize);

end;

procedure TTLParameters.InitParameters;
begin
    try
        BackGround := TLBackGround;;
        ForeGround := SmoothColor(TLZoneNamesColor, 16);
        MaxFrameSize := TLMaxFrameSize;
        // Preroll := TLPreroll;
        // Postroll := TLPostroll;
        ZeroPoint := Preroll;
        EndPoint := Preroll + Duration;
        if Start = 0 then
            Start := ZeroPoint;
        if Finish = 0 then
            Finish := EndPoint;
        Position := Start;
        SetScreenBoanders;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLParameters.InitParameters');
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLParameters.InitParameters | ' + E.Message);
    end;
end;

procedure TTLParameters.UpdateParameters;
begin
    try
        BackGround := TLBackGround;;
        ForeGround := SmoothColor(TLZoneNamesColor, 16);
        MaxFrameSize := TLMaxFrameSize;
        // Preroll := TLPreroll;
        // Postroll := TLPostroll;
        EndPoint := Preroll + Duration;
        if Start < Preroll then
            Start := Preroll;
        if ZeroPoint < Preroll then
            ZeroPoint := Preroll;
        SetScreenBoanders;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLParameters.UpdateParameters');
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLParameters.UpdateParameters | ' + E.Message);
    end;
end;

Procedure TTLParameters.WriteToStream(F: tStream);
begin
    try
        F.WriteBuffer(BackGround, SizeOf(BackGround));
        F.WriteBuffer(ForeGround, SizeOf(ForeGround));
        F.WriteBuffer(FrameSize, SizeOf(FrameSize));
        F.WriteBuffer(Start, SizeOf(Start));
        F.WriteBuffer(Finish, SizeOf(Finish));
        F.WriteBuffer(ZeroPoint, SizeOf(ZeroPoint));
        F.WriteBuffer(MyCursor, SizeOf(MyCursor));
        F.WriteBuffer(ScreenStart, SizeOf(ScreenStart));
        F.WriteBuffer(ScreenEnd, SizeOf(ScreenEnd));
        F.WriteBuffer(Duration, SizeOf(Duration));
        F.WriteBuffer(EndPoint, SizeOf(EndPoint));
        F.WriteBuffer(Position, SizeOf(Position));
        F.WriteBuffer(ScreenStartFrame, SizeOf(ScreenStartFrame));
        F.WriteBuffer(ScreenEndFrame, SizeOf(ScreenEndFrame));
        F.WriteBuffer(StopPosition, SizeOf(StopPosition));
        F.WriteBuffer(Scaler, SizeOf(Scaler));
        F.WriteBuffer(Preroll, SizeOf(Preroll));
        F.WriteBuffer(Postroll, SizeOf(Postroll));
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLParameters.WriteToStream | ' + E.Message);
    end;
end;

Procedure TTLParameters.ReadFromStream(F: tStream);
var
    mr: longint;
begin
    try
        F.ReadBuffer(BackGround, SizeOf(BackGround));
        F.ReadBuffer(ForeGround, SizeOf(ForeGround));
        F.ReadBuffer(FrameSize, SizeOf(FrameSize));
        F.ReadBuffer(Start, SizeOf(Start));
        F.ReadBuffer(Finish, SizeOf(Finish));
        F.ReadBuffer(ZeroPoint, SizeOf(ZeroPoint));
        F.ReadBuffer(mr, SizeOf(mr));
        // F.ReadBuffer(MyCursor, SizeOf(MyCursor));
        F.ReadBuffer(ScreenStart, SizeOf(ScreenStart));
        F.ReadBuffer(ScreenEnd, SizeOf(ScreenEnd));
        F.ReadBuffer(Duration, SizeOf(Duration));
        F.ReadBuffer(EndPoint, SizeOf(EndPoint));
        F.ReadBuffer(Position, SizeOf(Position));
        F.ReadBuffer(ScreenStartFrame, SizeOf(ScreenStartFrame));
        F.ReadBuffer(ScreenEndFrame, SizeOf(ScreenEndFrame));
        F.ReadBuffer(StopPosition, SizeOf(StopPosition));
        F.ReadBuffer(Scaler, SizeOf(Scaler));
        F.ReadBuffer(Preroll, SizeOf(Preroll));
        F.ReadBuffer(Postroll, SizeOf(Postroll));
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLParameters.ReadFromStream | ' + E.Message);
    end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLTimeline отвечает за отрисовку области шкалы времени
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLTimeline.Create;
begin
    inherited;
    IDTimeline := -1;
    Block := false;
    Status := 4;
    TypeTL := tldevice;
    Rect.Left := 0;
    Rect.Right := 0;
    Rect.Top := 0;
    Rect.Bottom := 0;
    Count := 0;
end;

Destructor TTLTimeline.Destroy;
begin
    FreeMem(@IDTimeline);
    FreeMem(@Block);
    FreeMem(@Status);
    FreeMem(@TypeTL);
    FreeMem(@Rect);
    FreeMem(@Count);
    FreeMem(@Events);
    inherited;
end;

function TTLTimeline.AddEvent(Position: longint; psgrd, psclr: integer)
  : integer;
begin
    Count := Count + 1;
    setlength(Events, Count);
    Events[Count - 1] := TMyEvent.Create;
    // Events[Count-1].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevColors[psclr];
    // Events[Count-1]:=(Form1.GridTimeLines.Objects[0,psgrid] as TTimelineOptions).DevColors[psclr];
    Events[Count - 1].Start := Position;
    Result := Count - 1;
end;

function TTLTimeline.FindEventID(IdEvent: longint): integer;
var
    i: integer;
begin
    try
        Result := -1;
        for i := 0 to Count - 1 do
        begin
            if Events[i].IdEvent = IdEvent then
            begin
                Result := i;
                exit;
            end;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLTimeline.FindEventID | ' + E.Message);
    end;
end;

function TTLTimeline.FindEvent(Position: longint): integer;
var
    i: integer;
begin
    try
        Result := -1;
        for i := 0 to Count - 1 do
        begin
            if (Events[i].Start >= Position) and (Position < Events[i].Finish)
            then
            begin
                Result := i;
                exit;
            end;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLTimeline.FindEvent | ' + E.Message);
    end;
end;

procedure TTLTimeline.DeleteID(IdEvent: longint);
var
    i, ps: integer;
begin
    try
        ps := FindEventID(IdEvent);
        if ps = -1 then
            exit;
        if ps = Count - 1 then
        begin
            Events[ps].FreeInstance;
            Count := Count - 1;
            setlength(Events, Count);
            exit;
        end;
        for i := ps to Count - 2 do
            Events[i].Assign(Events[i + 1]);
        Events[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Events, Count);
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLTimeline.DeleteID | ' + E.Message);
    end;
end;

procedure TTLTimeline.Delete(Position: longint);
var
    i, ps: integer;
begin
    try
        ps := FindEvent(Position);
        if ps = -1 then
            exit;
        if ps = Count - 1 then
        begin
            Events[ps].FreeInstance;
            Count := Count - 1;
            setlength(Events, Count);
            exit;
        end;
        for i := ps to Count - 2 do
            Events[i].Assign(Events[i + 1]);
        Events[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Events, Count);
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLTimeline.Delete | ' + E.Message);
    end;
end;

procedure TTLTimeline.Clear;
var
    i: integer;
begin
    try
        For i := Count - 1 downto 0 do
        begin
            Events[i].Clear;
            Events[i].FreeInstance;
        end;
        Count := 0;
        setlength(Events, Count);
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLTimeline.Clear | ' + E.Message);
    end;
end;

procedure TTLTimeline.Assign(ListEvents: TTLTimeline);
var
    i: integer;
begin
    try
        IDTimeline := ListEvents.IDTimeline;
        Block := ListEvents.Block;
        Status := ListEvents.Status;
        TypeTL := ListEvents.TypeTL;
        Clear;
        for i := 0 to ListEvents.Count - 1 do
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            Events[Count - 1].Assign(ListEvents.Events[i]);
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLTimeline.Assign | ' + E.Message);
    end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLEditor отвечает за отрисовку области редактирование тайм-линий
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLEditor.Create;
begin
    inherited;
    Index := 0;
    isZoneEditor := false;
    DoubleClick := false;
    IDTimeline := -1;
    Block := false;
    Status := 4;
    TypeTL := tldevice;
    Rect.Left := 0;
    Rect.Right := 0;
    Rect.Top := 0;
    Rect.Bottom := 0;
    Count := 0;
end;

Destructor TTLEditor.Destroy;
begin
    FreeMem(@Index);
    FreeMem(@isZoneEditor);
    FreeMem(@DoubleClick);
    FreeMem(@IDTimeline);
    FreeMem(@Block);
    FreeMem(@Status);
    FreeMem(@TypeTL);
    FreeMem(@Rect);
    FreeMem(@Count);
    FreeMem(@Events);
    inherited;
end;

Procedure TTLEditor.Clear;
var
    i: integer;
begin
    try
        For i := Count - 1 downto 0 do
        begin
            Events[i].Clear;
            Events[i].FreeInstance;
        end;
        Count := 0;
        setlength(Events, Count);
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.Clear | ' + E.Message);
    end;
end;

Procedure TTLEditor.DeleteEvent(Position: longint);
var
    i: integer;
    Start: longint;
    Finish: longint;
begin
    try
        Start := Events[Position].Start;
        Finish := Events[Position].Finish;
        For i := Position to Count - 2 do
        begin
            Events[i].Assign(Events[i + 1]);
        end;
        Events[Count - 1].Clear;
        Events[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Events, Count);
        if Count = 0 then
            exit;
        if Position = 0 then
            exit;
        if (TypeTL = tlText) or (TypeTL = tlmedia) then
            exit;
        Events[Position].Start := Start;
        if (Position >= Count - 1) then
        begin
            Events[Count - 1].Finish := TLParameters.Finish;
            exit;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.DeleteEvent | ' + E.Message);
    end;
end;

Procedure TTLEditor.Assign(ttl: TTLTimeline; Indx: integer);
var
    i: integer;
begin
    try
        IDTimeline := ttl.IDTimeline;
        Block := ttl.Block;
        Status := ttl.Status;
        TypeTL := ttl.TypeTL;
        Index := Indx;
        Clear;
        for i := 0 to ttl.Count - 1 do
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            Events[Count - 1].Assign(ttl.Events[i]);
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.Assign | ' + E.Message);
    end;
end;

procedure TTLEditor.ReturnEvents(ttl: TTLTimeline);
var
    i: integer;
begin
    try
        ttl.Clear;
        for i := 0 to Count - 1 do
        begin
            ttl.Count := ttl.Count + 1;
            setlength(ttl.Events, ttl.Count);
            ttl.Events[ttl.Count - 1] := TMyEvent.Create;
            ttl.Events[ttl.Count - 1].Assign(Events[i]);
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.ReturnEvents | ' + E.Message);
    end;
end;

function TTLEditor.InsertDevice(Position: longint): integer;
var
    i, rw: integer;
begin
    try
        if Count = 0 then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            Events[Count - 1].Assign(EventDevice);
            Events[Count - 1].Start := Position;
            Events[Count - 1].Finish := TLParameters.Finish;
            // .Preroll+TLParameters.Duration+TLParameters.Postroll;
            Events[Count - 1].Select := false;
            Result := 0;
            exit;
        end;

        if Position < Events[0].Start then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            for i := Count - 1 downto 1 do
                Events[i].Assign(Events[i - 1]);
            // Events[Count-1].Assign(Events[0]);
            Events[0].Assign(EventDevice);
            Events[0].Start := Position;
            Events[0].Finish := Events[1].Start;
            Events[Count - 1].Select := false;
            Result := 0;
            exit;
        end;

        for i := 0 to Count - 1 do
        begin
            Events[i].Select := false;
            if Position = Events[i].Start then
            begin
                Result := i;
                if i = Count - 1 then
                    Events[i].Finish := TLParameters.Finish;
                exit;
            end;
        end;
        rw := -1;
        for i := 0 to Count - 1 do
        begin
            Events[i].Select := false;
            if (Position > Events[i].Start) and (Position < Events[i].Finish)
            then
            begin
                rw := i;
                break;
            end;
        end;
        if rw = -1 then
            rw := Count - 1;
        Count := Count + 1;
        setlength(Events, Count);
        Events[Count - 1] := TMyEvent.Create;
        for i := Count - 1 downto rw + 1 do
            Events[i].Assign(Events[i - 1]);
        Events[rw].Finish := Position;
        Events[rw + 1].Start := Position;
        Events[Count - 1].Finish := TLParameters.Finish;
        Events[Count - 1].Select := false;
        Result := rw + 1;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.InsertDevice | ' + E.Message);
    end;
end;

function TTLEditor.InsertMarker(Position: longint): integer;
var
    i, rw: integer;
begin
    try

        if Count = 0 then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            Events[Count - 1].Assign(EventMedia);
            Events[Count - 1].Start := Position;
            Events[Count - 1].Select := false;
            Result := 0;
            exit;
        end;

        if Position < Events[0].Start then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            for i := Count - 1 downto 1 do
                Events[i].Assign(Events[i - 1]);
            Events[0].Assign(EventMedia);
            Events[0].Start := Position;
            Events[Count - 1].Select := false;
            // Events[0].Finish:=Events[1].Start;
            Result := 0;
            exit;
        end;

        if (Position >= Events[Count - 1].Start) then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            Events[Count - 1].Assign(EventMedia);
            Events[Count - 1].Start := Position;
            Events[Count - 1].Select := false;
            Result := Count - 1;
            exit;
        end;

        rw := -1;
        for i := 0 to Count - 2 do
        begin
            if ((Position >= Events[i].Start) and (Position < Events[i].Finish))
              or ((Position >= Events[i].Finish) and
              (Position < Events[i + 1].Start)) then
            begin
                rw := i + 1;
                break;
            end;
        end;

        Count := Count + 1;
        setlength(Events, Count);
        Events[Count - 1] := TMyEvent.Create;
        if rw = -1 then
            rw := Count - 1;
        for i := Count - 1 downto rw do
            Events[i].Assign(Events[i - 1]);
        Events[rw].Assign(EventMedia);
        Events[rw].Start := Position;
        Events[Count - 1].Select := false;
        Result := rw;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.InsertMarker | ' + E.Message);
    end;
end;

function TTLEditor.InsertText(Position: longint): integer;
var
    i, rw: integer;
begin
    try

        if Count = 0 then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            Events[Count - 1].Assign(EventText);
            Events[Count - 1].Start := Position;
            Events[Count - 1].Select := false;
            Result := 0;
            exit;
        end;

        if Position < Events[0].Start then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            for i := Count - 1 downto 1 do
                Events[i].Assign(Events[i - 1]);
            Events[0].Assign(EventText);
            Events[0].Start := Position;
            Events[Count - 1].Select := false;
            // Events[0].Finish:=Events[1].Start;
            Result := 0;
            exit;
        end;

        if (Position > Events[Count - 1].Start) or
          (Position > Events[Count - 1].Finish) then
        begin
            Count := Count + 1;
            setlength(Events, Count);
            Events[Count - 1] := TMyEvent.Create;
            Events[Count - 1].Assign(EventText);
            Events[Count - 1].Start := Position;
            Events[Count - 1].Select := false;
            Result := Count - 1;
            exit;
        end;

        rw := -1;
        for i := 0 to Count - 2 do
        begin
            Events[i].Select := false;
            Events[i + 1].Select := false;
            if ((Position >= Events[i].Start) and (Position < Events[i].Finish))
              or ((Position >= Events[i].Finish) and
              (Position < Events[i + 1].Start)) then
            begin
                rw := i + 1;
                break;
            end;
        end;

        Count := Count + 1;
        setlength(Events, Count);
        Events[Count - 1] := TMyEvent.Create;
        if rw = -1 then
            rw := Count - 1;
        for i := Count - 1 downto rw do
            Events[i].Assign(Events[i - 1]);
        Events[rw].Assign(EventText);
        Events[rw].Start := Position;
        Events[rw].Select := false;
        Events[Count - 1].Select := false;
        Result := rw;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.InsertText | ' + E.Message);
    end;
end;

function TTLEditor.AddEvent(Position: longint; psgrd, psclr: integer): integer;
var
    ARow: integer;
    frm: longint;
begin
    try
        // AllSelectFalse;
        case TypeTL of
            tldevice:
                begin
                    ARow := InsertDevice(Position);
                    // Events[ARow].SetEvents((Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevEvents[psclr]);
                    Result := ARow;
                    AllSelectFalse;
                end;
            tlText:
                begin
                    ARow := InsertText(Position);
                    // Events[ARow].SetEvents((Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).TextEvent);
                    // Events[ARow].SetPhraseText('Text',Trim(Form1.RichEdit1.Text));
                    // if Trim(Form1.RichEdit1.Text)='' then begin
                    // Events[ARow].Finish:=Events[ARow].Start + (Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).EventDuration;
                    // end else begin
                    // frm:=trunc(length(Trim(Form1.RichEdit1.Text)) * (Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).CharDuration / 40);
                    // Events[ARow].Finish:=Events[ARow].Start + frm;
                    // end;
                    Result := ARow;
                end;
            tlmedia:
                begin
                    ARow := InsertMarker(Position);
                    Events[ARow].Finish := Events[ARow].Start + Events[ARow]
                      .SafeZone + 50;
                    // Events[ARow].SetEvents((Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).MediaEvent);
                    Result := ARow;
                end;
        end; // case
        // AllSelectFalse;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.AddEvent | ' + E.Message);
    end;
end;

function TTLEditor.FindEventPos(evframe: longint): integer;
var
    i: integer;
begin
    Result := -1;
    for i := 0 to Count - 1 do
    begin
        if (evframe >= Events[i].Start) and (evframe <= Events[i].Finish) then
        begin
            Result := i;
            exit;
        end;
    end;
end;

function TTLEditor.FirstScreenEvent: integer;
var
    i: integer;
begin

    Result := 0;
    if Count <= 0 then
        exit;
    if (TLParameters.ScreenStartFrame <= Events[0].Finish) then
        exit;
    for i := 0 to Count - 2 do
    begin
        if (TLParameters.ScreenStartFrame >= Events[i].Finish) and
          (TLParameters.ScreenStartFrame <= Events[i + 1].Start) then
        begin
            Result := i;
            exit;
        end;
    end;
end;

function TTLEditor.LastScreenEvent: integer;
var
    i: integer;
begin
    if Count <= 0 then
    begin
        Result := 0;
        exit;
    end;
    Result := Count - 1;
    for i := 0 to Count - 2 do
    begin
        if (TLParameters.ScreenEndFrame >= Events[i].Start) and
          (TLParameters.ScreenEndFrame <= Events[i + 1].Start) then
        begin
            Result := i;
            exit;
        end;
    end;
end;

procedure TTLEditor.AllSelectFalse;
var
    ev, i, j: integer;
begin
    for ev := 0 to Count - 1 do
        for i := 0 to Events[ev].Count - 1 do
            for j := 0 to Events[ev].Rows[i].Count - 1 do
                Events[ev].Rows[i].Phrases[j].Select := false;
end;

procedure TTLEditor.EventsSelectFalse;
var
    ev, i, j: integer;
begin
    for ev := 0 to Count - 1 do
        Events[ev].Select := false;
end;

function TTLEditor.CurrentEvents: TEventReplay;
var
    i: integer;
begin
    try
        Result.Number := -1;
        Result.SafeZone := false;
        Result.Image := '';
        for i := 0 to Count - 1 do
        begin
            if Events[i].Start > TLParameters.Position then
                exit;
            if Events[i].Finish < TLParameters.Position then
                continue;
            if (Events[i].Start <= TLParameters.Position) and
              (Events[i].Finish > TLParameters.Position) then
            begin
                Result.Number := i;
                if (Events[i].Start <= TLParameters.Position) and
                  (Events[i].Start + TLFlashDuration > TLParameters.Position)
                then
                    Result.SafeZone := true;
                Result.Image := Events[i].ReadPhraseCommand('Text');
                exit;
            end;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLEditor.CurrentEvents | ' + E.Message);
    end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLScaler отвечает за отрисовку области шкалы времени
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLScaler.Create;
begin
    inherited;
    PenColor := SmoothColor(TLParameters.ForeGround, 64);;
    FontColor := ProgrammFontColor;
    FontSize := 8;
    FontName := ProgrammFontName;
    Rect.Left := 0;
    Rect.Right := 0;
    Rect.Top := 0;
    Rect.Bottom := 0;
end;

procedure TTLScaler.UpdateData;
begin
    PenColor := SmoothColor(TLParameters.ForeGround, 64);;
    FontColor := ProgrammFontColor;
    FontSize := 8;
    FontName := ProgrammFontName;
end;

Destructor TTLScaler.Destroy;
begin
    FreeMem(@PenColor);
    FreeMem(@FontColor);
    FreeMem(@FontSize);
    FreeMem(@FontName);
    FreeMem(@Rect);
    inherited;
end;

Procedure TTLScaler.DrawScaler(cv: tcanvas);
var
    i, j, cntb, cntp, dur, step, ps, tp, zero, befor, post: longint;
begin
    try

        with TLParameters do
        begin
            dur := (Preroll + Duration + Postroll) * FrameSize;
            zero := ZeroPoint * FrameSize;
            post := dur - zero;
            step := 25 * FrameSize;

            cntb := zero div FrameSize;
            cntp := post div FrameSize;

            cv.Brush.Color := ForeGround;
            // cv.FillRect(Rect);
            cv.Pen.Color := PenColor;
            cv.Font.Color := FontColor;
            cv.Font.Size := FontSize;
            cv.Font.Name := FontName;
            cv.FillRect(Rect);
            ps := zero;

            cv.MoveTo(ps, 0);
            cv.LineTo(ps, TLHeights.Scaler);
            cv.TextOut(ps + 2, 0, '0:00');
            tp := TLHeights.Scaler div 2;
            ps := ps - FrameSize;
            For i := 1 to cntb do
            begin
                if (i mod 25) = 0 then
                begin
                    cv.MoveTo(ps, 0);
                    cv.LineTo(ps, TLHeights.Scaler);
                    cv.TextOut(ps + 2, 0, '-' + secondtostr(i div 25));
                end
                else
                begin
                    cv.MoveTo(ps, tp);
                    cv.LineTo(ps, TLHeights.Scaler);
                end;
                ps := ps - FrameSize;
            End;
            ps := zero + FrameSize;;
            for i := 1 to cntp do
            begin
                if (i mod 25) = 0 then
                begin
                    cv.MoveTo(ps, 0);
                    cv.LineTo(ps, TLHeights.Scaler);
                    cv.TextOut(ps + 2, 0, secondtostr(i div 25));
                end
                else
                begin
                    if FrameSize > 1 then
                    begin
                        cv.MoveTo(ps, tp);
                        cv.LineTo(ps, TLHeights.Scaler);
                    end;
                end;
                ps := ps + FrameSize;
            end;
        end; // with
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLScaler.DrawScaler | ' + E.Message);
    end;
end;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Класс TTLZone отвечает за всю область тайм-линий
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLZone.Create;
begin
    inherited;
    Countbuffer := 0;
    DownViewer := false;
    DownTimeline := false;
    DownEditor := false;
    DownScaler := false;
    XDown := -1;
    XViewer := -1;
    // CRStart := StartColorCursor;
    // CREnd := EndColorCursor;
    CRStartDown := false;
    CREndDown := false;
    Count := 0;
    TLScaler := TTLScaler.Create;
    TLEditor := TTLEditor.Create;
end;

procedure TTLZone.UpdateCursor;
begin
    // CRStart := StartColorCursor;
    // CREnd := EndColorCursor;
end;

Destructor TTLZone.Destroy;
begin
    FreeMem(@Countbuffer);
    FreeMem(@TLBuffer);
    FreeMem(@DownViewer);
    FreeMem(@DownTimeline);
    FreeMem(@DownEditor);
    FreeMem(@DownScaler);
    FreeMem(@XDown);
    FreeMem(@XViewer);
    FreeMem(@CRStart);
    FreeMem(@CREnd);
    FreeMem(@CRStartDown);
    FreeMem(@CREndDown);
    FreeMem(@Count);
    TLScaler.Free;
    TLEditor.Free;
    FreeMem(@Timelines);
    inherited;
end;

Procedure TTLZone.ClearBuffer;
var
    i: integer;
begin
    try
        For i := Countbuffer - 1 downto 0 do
        begin
            TLBuffer[i].Clear;
            TLBuffer[i].FreeInstance;
        end;
        Countbuffer := 0;
        setlength(TLBuffer, Countbuffer);
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearBuffer');
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearBuffer | ' + E.Message);
    end;
end;

Procedure TTLZone.WriteToBuffer;
var
    i, j: integer;
begin
    try
        ClearBuffer;
        For i := 0 to Count - 1 do
        begin
            Countbuffer := Countbuffer + 1;
            setlength(TLBuffer, Countbuffer);
            TLBuffer[Countbuffer - 1] := TTLTimeline.Create;
            TLBuffer[Countbuffer - 1].Assign(Timelines[i]);
        end;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.WriteToBuffer');
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.WriteToBuffer | ' + E.Message);
    end;
end;

function TTLZone.FindInBuffer(ID: longint): integer;
var
    i: integer;
begin
    try
        Result := -1;
        for i := 0 to Countbuffer - 1 do
        begin
            if TLBuffer[i].IDTimeline = ID then
            begin
                Result := i;
                // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.FindInBuffer IDTimeline=' + inttostr(ID) + ' Result=' + inttostr(Result));
                exit;
            end;
        end;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.FindInBuffer IDTimeline=' + inttostr(ID) + ' Result=' + inttostr(Result));
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.FindInBuffer | ' + E.Message);
    end;
end;

Procedure TTLZone.SetEditingEventDevice;
var
    i, sev, fev, cnt: integer;
    Start, Finish, sfzn: longint;
    direction: boolean;
begin
    try
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventDevice');
        if EditingFinish = EditingStart then
        begin
            TLEditor.DeleteEvent(EditingEvent);
            exit;
        end;

        if EditingFinish > EditingStart then
        begin

            Start := Round((TLParameters.ScreenStart + EditingStart) /
              TLParameters.FrameSize);
            Finish := TLEditor.Events[EditingEvent].Finish;

            if EditingEvent = 0 then
            begin
                TLEditor.Events[0].Start := Start;
                exit;
            end;

            sev := TLEditor.FindEventPos(Start);

            if sev = -1 then
            begin
                // TLEditor.Events[EditingEvent].Start:=start;
                For i := EditingEvent - 1 downto 0 do
                    TLEditor.DeleteEvent(i);
                TLEditor.Events[0].Start := Start;
                exit;
            end;

            if EditingEvent > 0 then
            begin
                if TLEditor.Events[sev].Finish = TLEditor.Events[EditingEvent].Finish
                then
                begin
                    TLEditor.Events[EditingEvent].Start := Start;
                    TLEditor.Events[EditingEvent - 1].Finish := Start;
                    exit;
                end
                else
                begin
                    // sev := TLEditor.FindEventPos(start);
                    TLEditor.Events[EditingEvent].Start := Start;
                    For i := EditingEvent - 1 downto sev + 1 do
                        TLEditor.DeleteEvent(i);
                    TLEditor.Events[sev + 1].Start := Start;
                    TLEditor.Events[sev].Finish := Start;
                    exit;
                end;
            end;

        end;

        if EditingFinish < EditingStart then
        begin
            Finish := Round((TLParameters.ScreenStart + EditingStart) /
              TLParameters.FrameSize);
            Start := TLEditor.Events[EditingEvent].Finish;
            sev := TLEditor.FindEventPos(Finish);
            if sev = -1 then
            begin
                if TLEditor.Count > 1 then
                begin
                    For i := TLEditor.Count - 1 downto EditingEvent + 1 do
                        TLEditor.DeleteEvent(i);
                    TLEditor.Events[EditingEvent].Start := Start;
                    TLEditor.Events[EditingEvent].Finish := TLParameters.Finish;
                end
                else
                    TLEditor.DeleteEvent(TLEditor.Count - 1);
                exit;
            end;
            if sev = EditingEvent + 1 then
            begin
                TLEditor.Events[EditingEvent].Start := Start;
                TLEditor.Events[EditingEvent].Finish := Finish;
                TLEditor.Events[EditingEvent + 1].Start := Finish;
            end;
            if sev - EditingEvent > 1 then
            begin
                For i := sev - 1 downto EditingEvent + 1 do
                    TLEditor.DeleteEvent(i);
                TLEditor.Events[EditingEvent].Start := Start;
                TLEditor.Events[EditingEvent].Finish := Finish;
                TLEditor.Events[EditingEvent + 1].Start := Finish;
            end;
        end;

        EditingEvent := -1;
        EditingArea := edNone;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventDevice | ' + E.Message);
    end;
end;

Procedure TTLZone.SetEditingEventText;
var
    evnt: TMyEvent;
    ps: longint;
    nm: integer;
begin
    try
        evnt := TMyEvent.Create;
        try
            ps := Round((TLParameters.ScreenStart + EditingStart) /
              TLParameters.FrameSize);
            TLEditor.Events[EditingEvent].Start := ps;
            TLEditor.Events[EditingEvent].Finish :=
              Round((TLParameters.ScreenStart + EditingFinish) /
              TLParameters.FrameSize);
            evnt.Assign(TLEditor.Events[EditingEvent]);
            TLEditor.DeleteEvent(EditingEvent);
            nm := TLEditor.InsertText(ps);
            TLEditor.Events[nm].Assign(evnt);
            // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventText');
        finally
            evnt.FreeInstance;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventText | ' + E.Message);
    end;
end;

Procedure TTLZone.SetEditingEventMedia;
var
    evnt: TMyEvent;
    ps: longint;
    nm: integer;
begin
    try
        evnt := TMyEvent.Create;
        try
            ps := Round((TLParameters.ScreenStart + EditingStart) /
              TLParameters.FrameSize);
            TLEditor.Events[EditingEvent].Start := ps;
            TLEditor.Events[EditingEvent].Finish := ps + TLEditor.Events
              [EditingEvent].SafeZone + 5;
            evnt.Assign(TLEditor.Events[EditingEvent]);
            TLEditor.DeleteEvent(EditingEvent);
            nm := TLEditor.InsertMarker(ps);
            TLEditor.Events[nm].Assign(evnt);
            // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventMedia');
        finally
            evnt.FreeInstance;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.SetEditingEventMedia | ' + E.Message);
    end;
end;

Procedure TTLZone.AddTimeline(ID: longint);
begin
    try
        Count := Count + 1;
        setlength(Timelines, Count);
        Timelines[Count - 1] := TTLTimeline.Create;
        Timelines[Count - 1].IDTimeline := ID;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.AddTimeline IDTimeline=' + inttostr(ID) + ' Position=' + inttostr(Count-1));
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.AddTimeline | ' + E.Message);
    end;
end;

function TTLZone.FindTimeline(ID: longint): integer;
var
    i: integer;
begin
    try
        Result := -1;
        for i := 0 to Count - 1 do
        begin
            If Timelines[i].IDTimeline = ID then
            begin
                Result := i;
                // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.FindTimeline IDTimeline=' + inttostr(ID) + ' Result=' + inttostr(Result));
                exit;
            end;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.FindTimeline | ' + E.Message);
    end;
end;

procedure TTLZone.ClearTimeline;
var
    i: integer;
begin
    try
        For i := Count - 1 downto 0 do
        begin
            Timelines[i].Clear;
            Timelines[i].FreeInstance;
        end;
        setlength(Timelines, 0);
        Count := 0;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearTimeline');
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.ClearTimeline | ' + E.Message);
    end;
end;

Procedure TTLZone.InitTimelines(bmp: tbitmap);
var
    i, hgh, ps, cnt: integer;

Begin
    try
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.InitTimelines Start');
        TLScaler.Rect.Left := 0;
        TLScaler.Rect.Right := bmp.Width;
        TLScaler.Rect.Top := 0;
        TLScaler.Rect.Bottom := TLHeights.Scaler;

        TLEditor.Rect.Left := 0;
        TLEditor.Rect.Right := bmp.Width;
        TLEditor.Rect.Top := TLHeights.Scaler + TLHeights.IntervalEdit;
        TLEditor.Rect.Bottom := TLHeights.Scaler + TLHeights.IntervalEdit +
          TLHeights.Edit;

        hgh := TLHeights.Scaler + TLHeights.IntervalEdit + TLHeights.Edit +
          TLHeights.IntervalTL;

        WriteToBuffer;
        ClearTimeline;

        // For i:=1 to Form1.GridTimeLines.RowCount-1 do begin
        // if Form1.GridTimeLines.Objects[0,i] is TTimelineOptions then begin
        // //ps:=FindTimeline((Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).IDTimeline);
        // AddTimeline((Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).IDTimeline);
        // Timelines[Count-1].Rect.Left:=0;
        // Timelines[Count-1].Rect.Right:=bmp.Width;
        // Timelines[Count-1].Rect.Top:=hgh;
        // hgh:=hgh + TLHeights.HeightTL;
        // Timelines[Count-1].Rect.Bottom:=hgh;
        // Timelines[Count-1].TypeTL:=(Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).TypeTL;
        // hgh:=hgh + TLHeights.Interval;
        // ps:=FindInBuffer(Timelines[Count-1].IDTimeline);
        // if ps<>-1 then Timelines[Count-1].Assign(TLBuffer[ps]);
        // end;
        // end;
        ClearBuffer;
        // if makelogging then WriteLog('MAIN', 'UGRTimelines.TTLZone.InitTimelines Finish');
    except
        // on E: Exception do WriteLog('MAIN', 'UGRTimelines.TTLZone.InitTimelines | ' + E.Message);
    end;
End;

// SSSS JSON HELPERS
{ INCLUDE ../helpers/ugrtimelines_body.inc }
function TTLParametersJson.LoadFromJSONObject(json: tjsonObject): boolean;
var
    i1: integer;
    tmpjson: tjsonObject;
begin
    // BackGround : tcolor;        //Фоновый цвет
    BackGround := getVariableFromJson(json, 'BackGround', BackGround);

    // ForeGround : tcolor;        //Цвет пустых тайм-линий
    ForeGround := getVariableFromJson(json, 'ForeGround', ForeGround);

    // MaxFrameSize : integer;     //Максимальный размер кадра в пиксилях
    MaxFrameSize := getVariableFromJson(json, 'MaxFrameSize', MaxFrameSize);

    // FrameSize : integer;        //Текущий размер кадра
    FrameSize := getVariableFromJson(json, 'FrameSize', FrameSize);

    // Start  : longint;           //Позиция курсора начала воспроизведения (кадры)
    Start := getVariableFromJson(json, 'Start', Start);

    // Finish : longint;           //Позиция курсора конца воспроизведения (кадры)
    Finish := getVariableFromJson(json, 'Finish', Finish);

    // //NTK    : longint;           //Начальный тайм код (кадры)
    // ZeroPoint : longint;        //Нулевая точка отсчета начальный тайм-код (кадры)
    ZeroPoint := getVariableFromJson(json, 'ZeroPoint', ZeroPoint);

    // vlcmode
    vlcmode := getVariableFromJson(json, 'vlcMode', vlcmode);

    // MyCursor : longint;         //Положение курсора относительно начала экрана (пиксили)
    MyCursor := getVariableFromJson(json, 'MyCursor', MyCursor);

    // ScreenStart : longint;      //Относительная позиция начала экрана (пиксили)
    ScreenStart := getVariableFromJson(json, 'ScreenStart', ScreenStart);
    // ScreenEnd   : longint;      //Относительная позиция конца экрана (пиксли)
    ScreenEnd := getVariableFromJson(json, 'ScreenEnd', ScreenEnd);
    // Preroll   : longint;        //Начальный буффер (кадры)
    Preroll := getVariableFromJson(json, 'Preroll', Preroll);
    // Postroll  : longint;        //Конечный буффер (кадры)
    Postroll := getVariableFromJson(json, 'Postroll', Postroll);
    // Duration  : longint;        //Общая длителность клипа (кадры)
    Duration := getVariableFromJson(json, 'Duration', Duration);
    // EndPoint  : longint;        //Положение конца клипа Preroll+Duration (кадры)
    EndPoint := getVariableFromJson(json, 'EndPoint', EndPoint);
    // lrTransperent0 : tcolor;    //Цвет прозрачности для слоя 0
    lrTransperent0 := getVariableFromJson(json, 'lrTransperent0',
      lrTransperent0);
    // lrTransperent1 : tcolor;    //Цвет прозрачности для слоя 1
    lrTransperent1 := getVariableFromJson(json, 'lrTransperent1',
      lrTransperent1);
    // lrTransperent2 : tcolor;    //Цвет прозрачности для слоя 2
    lrTransperent2 := getVariableFromJson(json, 'lrTransperent2',
      lrTransperent2);
    // Position : longint;         //Tекущая позиция клипа (кадры)
    Position := getVariableFromJson(json, 'Position', Position);
    // ScreenStartFrame : longint; //Абсолютная позиция начала экрана (кадры)
    ScreenStartFrame := getVariableFromJson(json, 'ScreenStartFrame',
      ScreenStartFrame);
    // ScreenEndFrame : longint;   //Абсолютная позиция конца экрана (кадры)
    ScreenEndFrame := getVariableFromJson(json, 'ScreenEndFrame',
      ScreenEndFrame);
    // StopPosition : longint;     //Позиция остановки клип (кадры)
    StopPosition := getVariableFromJson(json, 'StopPosition', StopPosition);
    // Scaler : real;              //Отношение ширины Bitmap к ширине экрана
    Scaler := getVariableFromJson(json, 'Scaler', Scaler);

end;

function TTLParametersJson.LoadFromJSONstr(JSONstr: string): boolean;
var
    json: tjsonObject;
begin
    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
      as tjsonObject;
    Result := true;
    if json = nil then
    begin
        Result := false;
    end
    else
        LoadFromJSONObject(json);

end;

function TTLParametersJson.SaveToJSONObject: tjsonObject;
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
        // BackGround : tcolor;        //Фоновый цвет
        addVariableToJson(json, 'BackGround', BackGround);
        // ForeGround : tcolor;        //Цвет пустых тайм-линий
        addVariableToJson(json, 'ForeGround', ForeGround);
        // MaxFrameSize : integer;     //Максимальный размер кадра в пиксилях
        addVariableToJson(json, 'MaxFrameSize', MaxFrameSize);
        // FrameSize : integer;        //Текущий размер кадра
        addVariableToJson(json, 'FrameSize', FrameSize);
        // Start  : longint;           //Позиция курсора начала воспроизведения (кадры)
        addVariableToJson(json, 'Start', Start);
        // Finish : longint;           //Позиция курсора конца воспроизведения (кадры)
        addVariableToJson(json, 'Finish', Finish);
        // //NTK    : longint;           //Начальный тайм код (кадры)
        // ZeroPoint : longint;        //Нулевая точка отсчета начальный тайм-код (кадры)
        addVariableToJson(json, 'ZeroPoint', ZeroPoint);
        // vlcMode
        addVariableToJson(json, 'vlcMode', vlcmode);
        // MyCursor : longint;         //Положение курсора относительно начала экрана (пиксили)
        addVariableToJson(json, 'MyCursor', MyCursor);
        // ScreenStart : longint;      //Относительная позиция начала экрана (пиксили)
        addVariableToJson(json, 'ScreenStart', ScreenStart);
        // ScreenEnd   : longint;      //Относительная позиция конца экрана (пиксли)
        addVariableToJson(json, 'ScreenEnd', ScreenEnd);
        // Preroll   : longint;        //Начальный буффер (кадры)
        addVariableToJson(json, 'Preroll', Preroll);
        // Postroll  : longint;        //Конечный буффер (кадры)
        addVariableToJson(json, 'Postroll', Postroll);
        // Duration  : longint;        //Общая длителность клипа (кадры)
        addVariableToJson(json, 'Duration', Duration);
        // EndPoint  : longint;        //Положение конца клипа Preroll+Duration (кадры)
        addVariableToJson(json, 'EndPoint', EndPoint);
        // lrTransperent0 : tcolor;    //Цвет прозрачности для слоя 0
        addVariableToJson(json, 'lrTransperent0', lrTransperent0);
        // lrTransperent1 : tcolor;    //Цвет прозрачности для слоя 1
        addVariableToJson(json, 'lrTransperent1', lrTransperent1);
        // lrTransperent2 : tcolor;    //Цвет прозрачности для слоя 2
        addVariableToJson(json, 'lrTransperent2', lrTransperent2);
        // Position : longint;         //Tекущая позиция клипа (кадры)
        addVariableToJson(json, 'Position', Position);
        // ScreenStartFrame : longint; //Абсолютная позиция начала экрана (кадры)
        addVariableToJson(json, 'ScreenStartFrame', ScreenStartFrame);
        // ScreenEndFrame : longint;   //Абсолютная позиция конца экрана (кадры)
        addVariableToJson(json, 'ScreenEndFrame', ScreenEndFrame);
        // StopPosition : longint;     //Позиция остановки клип (кадры)
        addVariableToJson(json, 'StopPosition', StopPosition);
        // Scaler : real;              //Отношение ширины Bitmap к ширине экрана
        addVariableToJson(json, 'Scaler', Scaler);
    except
        on E: Exception do
    end;
    Result := json;

end;

function TTLParametersJson.SaveToJSONStr: string;
var
    jsontmp: tjsonObject;
    JSONstr: string;
begin
    jsontmp := SaveToJSONObject;
    JSONstr := jsontmp.ToJSON;
    Result := JSONstr;
end;

{ TTLScalerJson }

function TTLScalerJson.LoadFromJSONObject(json: tjsonObject): boolean;
var
    i1: integer;
    tmpjson: tjsonObject;
begin
    // PenColor : tcolor;
    PenColor := getVariableFromJson(json, 'PenColor', PenColor);
    // FontColor : tcolor;
    FontColor := getVariableFromJson(json, 'FontColor', FontColor);

    // FontSize : integer;
    FontSize := getVariableFromJson(json, 'FontSize', FontSize);
    // FontName : tfontname;
    FontName := getVariableFromJson(json, 'FontName', FontName);
    // Rect   : TRect;
    Rect.LoadFromJSONObject(tjsonObject(json.getvalue('Rect')));
end;

function TTLScalerJson.LoadFromJSONstr(JSONstr: string): boolean;
var
    json: tjsonObject;
begin
    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
      as tjsonObject;
    Result := true;
    if json = nil then
    begin
        Result := false;
    end
    else
        LoadFromJSONObject(json);

end;

function TTLScalerJson.SaveToJSONObject: tjsonObject;
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
    Result := json;
    // PenColor : tcolor;
    addVariableToJson(json, 'PenColor', PenColor);

    // FontColor : tcolor;
    addVariableToJson(json, 'FontColor', FontColor);
    // FontSize : integer;
    addVariableToJson(json, 'FontSize', FontSize);

    // FontName : tfontname;
    addVariableToJson(json, 'FontName', FontName);

    // Rect   : TRect;
    json.AddPair('Rect', Rect.SaveToJSONObject);

end;

function TTLScalerJson.SaveToJSONStr: string;
var
    jsontmp: tjsonObject;
    JSONstr: string;
begin
    jsontmp := SaveToJSONObject;
    JSONstr := jsontmp.ToJSON;
    Result := JSONstr;
end;

{ TTLTimelineJSON }

function TTLTimelineJSON.LoadFromJSONObject(json: tjsonObject): boolean;
var
    i1: integer;
    tmpjson: tjsonObject;
begin
    // IDTimeline : longint;
    IDTimeline := getVariableFromJson(json, 'IDTimeline', IDTimeline);
    // TypeTL :  TTypeTimeline;
    TypeTL := getVariableFromJson(json, 'TypeTL', TypeTL);
    // Block : boolean;
    Block := getVariableFromJson(json, 'Block', Block);
    // Status : integer;
    Status := getVariableFromJson(json, 'Status', Status);
    // Rect : TRect;
    Rect.LoadFromJSONObject(tjsonObject(json.getvalue('Rect')));
    // Count : integer;
    Count := getVariableFromJson(json, 'Count', Count);
    // Events : Array of TMyEvent;
    setlength(Events, 0);
    setlength(Events, Count);
    for i1 := 0 to Count - 1 do
    begin
        tmpjson := tjsonObject(json.getvalue('Events' + inttostr(i1)));
        assert(tmpjson <> nil, 'Events нет для ' + inttostr(i1));
        if tmpjson = nil then
            break;
        Events[i1] := TMyEvent.Create;
        Events[i1].LoadFromJSONObject(tmpjson);
    end;
end;

function TTLTimelineJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
    json: tjsonObject;
begin
    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
      as tjsonObject;
    Result := true;
    if json = nil then
    begin
        Result := false;
    end
    else
        LoadFromJSONObject(json);

end;

function TTLTimelineJSON.SaveToJSONObject: tjsonObject;
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
    Result := json;

    // IDTimeline : longint;
    addVariableToJson(json, 'IDTimeline', IDTimeline);

    // TypeTL :  TTypeTimeline;
    addVariableToJson(json, 'TypeTL', TypeTL);

    // Block : boolean;
    addVariableToJson(json, 'Block', Block);

    // Status : integer;
    addVariableToJson(json, 'Status', Status);

    // Rect : TRect;
    json.AddPair('Rect', Rect.SaveToJSONObject);
    // Count : integer;
    addVariableToJson(json, 'Count', Count);

    // Events : Array of TMyEvent;
    for i1 := 0 to Count - 1 do
        json.AddPair('Events' + inttostr(i1), Events[i1].SaveToJSONObject);

end;

function TTLTimelineJSON.SaveToJSONStr: string;
var
    jsontmp: tjsonObject;
    JSONstr: string;
begin
    jsontmp := SaveToJSONObject;
    JSONstr := jsontmp.ToJSON;
    Result := JSONstr;
end;

{ TTLEditorJSON }

function TTLEditorJSON.LoadFromJSONObject(json: tjsonObject): boolean;
var
    i1: integer;
    tmpjson: tjsonObject;
begin
    // Index   : integer;
    Index := getVariableFromJson(json, 'Index', Index);
    // isZoneEditor : boolean;
    isZoneEditor := getVariableFromJson(json, 'isZoneEditor', isZoneEditor);
    // DoubleClick : boolean;
    DoubleClick := getVariableFromJson(json, 'DoubleClick', DoubleClick);
    // IDTimeline : longint;
    IDTimeline := getVariableFromJson(json, 'IDTimeline', IDTimeline);
    // Block : boolean;
    Block := getVariableFromJson(json, 'Block', Block);
    // Status : integer;
    Status := getVariableFromJson(json, 'Status', Status);
    // TypeTL :  TTypeTimeline;
    TypeTL := getVariableFromJson(json, 'TypeTL', TypeTL);
    // Rect       : TRect;
    Rect.LoadFromJSONObject(tjsonObject(json.getvalue('Rect')));
    // Count : integer;
    Count := getVariableFromJson(json, 'Count', Count);
    // Events : Array of TMyEvent;
    setlength(Events, 0);
    setlength(Events, Count);
    for i1 := 0 to Count - 1 do
    begin
        tmpjson := tjsonObject(json.getvalue('Events' + inttostr(i1)));
        assert(tmpjson <> nil, 'Events нет для ' + inttostr(i1));
        if tmpjson = nil then
            break;
        Events[i1] := TMyEvent.Create;
        Events[i1].LoadFromJSONObject(tmpjson);
    end;

end;

function TTLEditorJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
    json: tjsonObject;
begin
    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
      as tjsonObject;
    Result := true;
    if json = nil then
    begin
        Result := false;
    end
    else
        LoadFromJSONObject(json);

end;

function TTLEditorJSON.SaveToJSONObject: tjsonObject;
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
    Result := json;

    // Index   : integer;
    addVariableToJson(json, 'Index', Index);

    // isZoneEditor : boolean;
    addVariableToJson(json, 'isZoneEditor', isZoneEditor);

    // DoubleClick : boolean;
    addVariableToJson(json, 'DoubleClick', DoubleClick);

    // IDTimeline : longint;
    addVariableToJson(json, 'IDTimeline', IDTimeline);

    // Block : boolean;
    addVariableToJson(json, 'Block', Block);

    // Status : integer;
    addVariableToJson(json, '', Status);

    // TypeTL :  TTypeTimeline;
    addVariableToJson(json, 'TypeTL', TypeTL);

    // Rect       : TRect;

    json.AddPair('Rect', Rect.SaveToJSONObject);
    // Count : integer;
    addVariableToJson(json, 'Count', Count);

    // Events : Array of TMyEvent;
    for i1 := 0 to Count - 1 do
        json.AddPair('Events' + inttostr(i1), Events[i1].SaveToJSONObject);

end;

function TTLEditorJSON.SaveToJSONStr: string;
var
    jsontmp: tjsonObject;
    JSONstr: string;
begin
    jsontmp := SaveToJSONObject;
    JSONstr := jsontmp.ToJSON;
    Result := JSONstr;
end;

{ TTLZoneJSON }

function TTLZoneJSON.LoadFromJSONObject(json: tjsonObject): boolean;
var
    i1: integer;
    tmpjson: tjsonObject;
begin
    // XViewer : integer;
    XViewer := getVariableFromJson(json, 'XViewer', XViewer);
    // DownViewer : boolean;
    DownViewer := getVariableFromJson(json, 'DownViewer', DownViewer);
    // DownTimeline : boolean;
    DownTimeline := getVariableFromJson(json, 'DownTimeline', DownTimeline);
    // DownEditor : boolean;
    DownEditor := getVariableFromJson(json, 'DownEditor', DownEditor);
    // DownScaler : boolean;
    DownScaler := getVariableFromJson(json, 'DownScaler', DownScaler);
    // TLScaler : TTLScaler;
    TLScaler.LoadFromJSONObject(tjsonObject(json.getvalue('TLScaler')));
    // TLEditor : TTLEditor;
    TLEditor.LoadFromJSONObject(tjsonObject(json.getvalue('TLEditor')));
    // Count : integer;
    Count := getVariableFromJson(json, 'Count', Count);
    // Timelines : array of TTLTimeline;
    setlength(Timelines, 0);
    setlength(Timelines, Count);
    for i1 := 0 to Count - 1 do
    begin
        tmpjson := tjsonObject(json.getvalue('Timelines' + inttostr(i1)));
        assert(tmpjson <> nil, 'Timelines нет для ' + inttostr(i1));
        if tmpjson = nil then
            break;
        Timelines[i1] := TTLTimeline.Create;
        Timelines[i1].LoadFromJSONObject(tmpjson);
    end;

end;

function TTLZoneJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
    json: tjsonObject;
begin
    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
      as tjsonObject;
    Result := true;
    if json = nil then
    begin
        Result := false;
    end
    else
        LoadFromJSONObject(json);

end;

function TTLZoneJSON.SaveToJSONObject: tjsonObject;
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
    Result := json;

    // XViewer : integer;
    addVariableToJson(json, 'XViewer', XViewer);

    // DownViewer : boolean;
    addVariableToJson(json, 'DownViewer', DownViewer);

    // DownTimeline : boolean;
    addVariableToJson(json, 'DownTimeline', DownTimeline);

    // DownEditor : boolean;
    addVariableToJson(json, '', DownEditor);

    // DownScaler : boolean;
    addVariableToJson(json, 'DownScaler', DownScaler);

    // TLScaler : TTLScaler;
    json.AddPair('TLScaler', TLScaler.SaveToJSONObject);

    // TLEditor : TTLEditor;
    json.AddPair('TLEditor', TLEditor.SaveToJSONObject);

    // Count : integer;
    addVariableToJson(json, 'Count', Count);

    // Timelines : array of TTLTimeline;
    for i1 := 0 to Count - 1 do
        json.AddPair('Timelines' + inttostr(i1),
          Timelines[i1].SaveToJSONObject);

end;

function TTLZoneJSON.SaveToJSONStr: string;
var
    jsontmp: tjsonObject;
    JSONstr: string;
begin
    jsontmp := SaveToJSONObject;
    JSONstr := jsontmp.ToJSON;
    Result := JSONstr;
end;
// SSSS JSON HELPERS

initialization

TLParameters := TTLParameters.Create;
TLP_server := TTLParameters.Create;
TLZone := TTLZone.Create;

MyTLEdit := TTLEditor.Create;

finalization

TLParameters.FreeInstance;
TLParameters := nil;
TLZone.FreeInstance;
TLZone := nil;

MyTLEdit.FreeInstance;
MyTLEdit := nil;

end.
