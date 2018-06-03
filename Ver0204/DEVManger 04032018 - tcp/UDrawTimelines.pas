unit UDrawTimelines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline;

Type

  TTLZone = (znscaler, znedit, zntimelines, znreview, znnone);

  TTLButton = (btplusH,btminusH,btplusW,btminusW,btprocent,btlock,btstatus,bttimeline,btreview,btnone);

  TTLNResult = record
    Zone : TTLZone;
    ID : integer;
    Position : integer;
    Button : TTLButton;
  end;

   TZoneScaler = Class(TObject)
     public
       Rect : Trect;
       OffsetText : integer;
       Text : string;
       Color : tcolor;
       FontColor : tcolor;
       FontSize : integer;
       FontName : tfontname;
       FontBold : boolean;
       FontItalic : boolean;
       FontUnderline : boolean;
       plusH : trect;
       plusHSelect : boolean;
       plusHLock : boolean;
       minusH : trect;
       minusHSelect : boolean;
       minusHLock : boolean;
       plusW : trect;
       plusWSelect : boolean;
       plusWLock : boolean;
       minusW : trect;
       minusWSelect : boolean;
       minusWLock : boolean;
       procent : trect;
       procentSelect : boolean;
     Constructor Create;
     Destructor Destroy; override;
   end;

  TTimeLineName = Class(TObject)
    public
      Rect : trect;
      IDTimeline : longint;
      Selection : boolean;
      Editing : boolean;
      OffsetTextX : integer;
      Color : tcolor;
      FontColor : tcolor;
      FontColorSelect : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontBold : boolean;
      FontItalic : boolean;
      FontUnderline : boolean;
      imgRect : trect;
      BlockRect : trect;
      StatusRect : trect;

    Constructor Create;
    Destructor Destroy; override;
  end;

  TNamesTL = Class(TObject)
    public
      Rect : trect;
      Interval : integer;
      HeightTL : integer;
      Color : tcolor;
      FontColor : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontBold : boolean;
      FontItalic : boolean;
      FontUnderline : boolean;
      Count : integer;
      Names : array of TTimelineName;
    Function Init( Grid : tstringgrid; erase : boolean) : integer;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TZoneEditTL = Class(TObject)
    public
      Rect : trect;
      IDTimeline : integer;
      OffsetTextX : integer;
      OffsetTextY : integer;
      Color : tcolor;
      FontColor : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontBold : boolean;
      FontItalic : boolean;
      FontUnderline : boolean;
      imgRect : trect;
      BlockRect : trect;
      BlockSelect : boolean;
      StatusRect : trect;
      StatusSelect : boolean;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TZoneReview = Class(TObject)
    public
      Rect : trect;
      ImgRect : Trect;
      Selection : boolean;
      Color : tcolor;
      FontColor : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontBold : boolean;
      FontItalic : boolean;
      FontUnderline : boolean;
      startview : integer;
      stopview : integer;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLHeights = Class(TObject)
    public
      MaxHeight : integer;
      MinHeightTL : integer;
      Step : integer;
      Scaler : integer;
      IntervalEdit : integer;
      Edit : integer;
      IntervalTL : integer;
      Timelines : integer;
      Review : integer;
      HeightTL : integer;
      Interval : integer;
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLNames = Class(TObject)
    public
      BackGround : tcolor;
      Color : tcolor;
      Scaler : TZoneScaler;
      Edit : TZoneEditTL;
      NamesTL : TNamesTL;
      Review : TZoneReview;
    Constructor Create;
    Destructor Destroy; override;
  end;

Var HScale,HEditTL,HTimelines,HView,HDelt : integer;
    ZoneNames : TTLNames;
    //ZoneTimelines : array[0..18] of trect;
    CountTL : Integer;
    Scal  : TZoneScaler;
    EditTL : TZoneEditTL;
    NamesTL : TNamesTL;
    TLHeights : TTLHeights;

    ZoneReview : TZoneReview;
    ZoneNamesLeft, ZoneNamesRight : integer;
    TLBitmap : integer;

implementation

uses umain, ucommon, ugrtimelines, uplayer;

//Класс TTLNames отвечает за работу с зоной имен тайм-линий

Constructor TTLNames.Create;
begin
  inherited;
  BackGround := TLBackGround;
  Color      := TLZoneNamesColor;
  Scaler     := TZoneScaler.Create;
  Edit       := TZoneEditTL.Create;
  NamesTL    := TNamesTL.Create;
  Review     := TZoneReview.Create;
end;

Destructor TTLNames.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@Color);
  Scaler.Free;
  Edit.Free;
  NamesTL.Free;
  Review.Free;
  inherited;
end;

Constructor TTLHeights.Create;
begin
  inherited;
  MinHeightTL := 25;
  Step :=2;
  Scaler :=MinHeightTL;
  IntervalEdit:=20;
  HeightTL := MinHeightTL+10;
  Edit := HeightTL * 3;
  Review := HeightTL + 10;
  Interval := trunc(HeightTL / 10);
  IF Interval < 4 then Interval := 4;
  IntervalTL := 3 * interval;
  Timelines := (HeightTL + Interval) * 3 - Interval;
  MaxHeight := 22*MinHeightTL + 16*Interval + IntervalEdit + IntervalTL;
end;

Destructor TTLHeights.Destroy;
begin
  FreeMem(@MaxHeight);
  FreeMem(@MinHeightTL);
  FreeMem(@Step);
  FreeMem(@IntervalEdit);
  FreeMem(@IntervalTL);
  FreeMem(@Scaler);
  FreeMem(@Edit);
  FreeMem(@Timelines);
  FreeMem(@Review);
  FreeMem(@HeightTL);
  FreeMem(@Interval);
  inherited Destroy;
end;


Constructor TZoneReview.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 60;
  ImgRect.Left := 0;
  ImgRect.Right := 0;
  ImgRect.Top := 0;
  ImgRect.Bottom := 60;
  Selection := false;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
  startview := 0;
  stopview := 0;
end;

Destructor TZoneReview.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@ImgRect);
  FreeMem(@Selection);
  FreeMem(@startview);
  FreeMem(@stopview);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  inherited Destroy;
end;


Constructor TNamesTL.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 60;
  Interval := 3;
  HeightTL := 25;
  Count :=0;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
end;

Destructor TNamesTL.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@Interval);
  FreeMem(@HeightTL);
  FreeMem(@Count);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@Names);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  inherited Destroy;
end;

function TNamesTL.Init( Grid : tstringgrid; erase : boolean) : integer;
var i, APos, Hght : integer;
begin
  Result := 0;
  //Clear;
//  For i:=1 to Grid.RowCount-1 do begin
//    if Grid.Objects[0,i] is TTimelineOptions
//      then APos:=Add(Grid.Objects[0,i] as TTimelineOptions);

//    Result := Result + HeightTL + Interval;
//  end;
  Result := Result - Interval;
  //if MakeLogging then WriteLog('MAIN', 'UDrawTimelines.TNamesTL.Init Result=' + inttostr(Result));
end;


Constructor TTimeLineName.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  IDTimeline := 0;
  Selection := false;
  Editing := false;
  OffsetTextX := 20;
  Color := clGray;
  FontColor := TLZoneNamesFontColor;
  FontColorSelect := TLZoneFontColorSelect;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
  imgRect.Left := 0;
  imgRect.Right := 0;
  imgRect.Top := 0;
  imgRect.Bottom := 0;
  BlockRect.Left := 0;
  BlockRect.Right := 0;
  BlockRect.Top := 0;
  BlockRect.Bottom := 0;
  StatusRect.Left := 0;
  StatusRect.Right := 0;
  StatusRect.Top := 0;
  StatusRect.Bottom := 0;
end;

Destructor TTimeLineName.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@IDTimeline);
  FreeMem(@Selection);
  FreeMem(@Editing);
  FreeMem(@OffsetTextX);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontColorSelect);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  FreeMem(@imgRect);
  FreeMem(@BlockRect);
  FreeMem(@StatusRect);
  inherited Destroy;
end;

//=================== Зона редактируемуего тайм-лайна ZoneEditTL

Constructor TZoneEditTL.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  IDTimeline := 1;
  OffsetTextX := 20;
  OffsetTextY := 5;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneEditFontBold;
  FontItalic := TLZoneEditFontItalic;
  FontUnderline := TLZoneEditFontUnderline;
  imgRect.Left := 0;
  imgRect.Right := 0;
  imgRect.Top := 0;
  imgRect.Bottom := 0;
  BlockRect.Left := 0;
  BlockRect.Right := 0;
  BlockRect.Top := 0;
  BlockRect.Bottom := 0;
  BlockSelect := false;
  StatusRect.Left := 0;
  StatusRect.Right := 0;
  StatusRect.Top := 0;
  StatusRect.Bottom := 0;
  StatusSelect := false;
end;


Destructor TZoneEditTL.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@IDTimeline);
  FreeMem(@OffsetTextX);
  FreeMem(@OffsetTextY);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  FreeMem(@imgRect);
  FreeMem(@BlockRect);
  FreeMem(@BlockSelect);
  FreeMem(@StatusRect);
  FreeMem(@StatusSelect);
  inherited Destroy;
end;

Constructor TZoneScaler.Create;
begin
  inherited;
  plusHSelect :=false;
  minusHSelect := false;
  plusWSelect := false;
  minusWSelect := false;
  plusHLock :=false;
  minusHLock := false;
  plusWLock := false;
  minusWLock := false;
  procentSelect := false;
  Rect.Left:=0;
  Rect.Right:=0;
  Rect.Top:=0;
  Rect.Bottom:=30;
  OffsetText := 22;
  Text := 'Масштаб';
  PlusH.Left:=0;
  PlusH.Right:=0;
  PlusH.Top:=0;
  PlusH.Bottom:=30;
  MinusH.Left:=0;
  MinusH.Right:=0;
  MinusH.Top:=0;
  MinusH.Bottom:=30;
  PlusW.Left:=0;
  PlusW.Right:=0;
  PlusW.Top:=0;
  PlusW.Bottom:=30;
  MinusW.Left:=0;
  MinusW.Right:=0;
  MinusW.Top:=0;
  MinusW.Bottom:=30;
  procent.Left:=0;
  procent.Right:=0;
  procent.Top:=0;
  procent.Bottom:=30;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  FontBold := TLZoneNamesFontBold;
  FontItalic := TLZoneNamesFontItalic;
  FontUnderline := TLZoneNamesFontUnderline;
end;

destructor TZoneScaler.Destroy;
begin
  FreeMem(@plusHSelect);
  FreeMem(@minusHSelect);
  FreeMem(@plusWSelect);
  FreeMem(@minusWSelect);
  FreeMem(@plusHLock);
  FreeMem(@minusHLock);
  FreeMem(@plusWLock);
  FreeMem(@minusWLock);
  FreeMem(@procentSelect);
  FreeMem(@Rect);
  FreeMem(@OffsetText);
  FreeMem(@Text);
  FreeMem(@PlusH);
  FreeMem(@MinusH);
  FreeMem(@PlusW);
  FreeMem(@MinusW);
  FreeMem(@procent);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontBold);
  FreeMem(@FontItalic);
  FreeMem(@FontUnderline);
  inherited Destroy;
end;

Initialization

ZoneNames := TTLNames.Create;
TLHeights := TTLHeights.Create;

finalization

ZoneNames.FreeInstance;
ZoneNames := nil;
TLHeights.FreeInstance;
TLHeights := nil;

end.
