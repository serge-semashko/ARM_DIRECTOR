unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, uwaiting, JPEG,
  Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend,
  PasLibVlcUnit,
  vlcpl, ustartwindow, ufrhotkeys, System.JSON, StrUtils;

Type
  TGridPlayer = (grClips, grPlaylist, grDefault);
  TSinchronization = (chltc, chsystem, chnone1);
  TTypeTimeline = (tldevice, tltext, tlmedia, tlnone);

  TEventReplay = record
    Number: integer;
    SafeZone: boolean;
    Image: String;
  end;

  PCompartido = ^TCompartido;

  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero: integer;
    Shift: Double;
    State: boolean;
    Cadena: String[20];
  end;

  TListParam = record
    Name: String;
    Text: String;
    VarText: String;
  end;

Const
  DirProjects = 'Projects';
  DirFiles = 'Clips';
  DirTemplates = '\Templates';
  DirClips = '\Clips';
  DirPlayLists = '\PlayLists';
  DirTemp = '\Temp';
  DirLog = '\Log';
  DirKeylayouts = '\Keylayouts';
  Alphabet =
    '0123456789абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz';

Var

  // Временно используемые параметрв для отладки программы
  // IDTL : longint = 0;     // Для формирования IDTimeline
  IDCLIPS: longint = 0; // Для формирования IDClips
  IDPROJ: longint = 0; // Для формирования IDProj
  IDPLst: longint = 0; // Для формирования IDLst
  IDTXTTmp: longint = 0; // Для формирования IDTXTTmp
  IDGRTmp: longint = 0; // Для формирования IDGRTmp
  IDEvents: longint = 0; // Для формирование IDEvents
  szFontEvents1, szFontEvents2: integer;
  dbld1, dbld2: Double; // Измерение времени выполнения модулей
  DrawTimeineInProgress: boolean = false; // Процесс рисования тайм линий
  LoadImageInProgress: boolean = false;

  FWait: TFWaiting;
  FStart: TFrStartWindow;
  // Параметры синхронизации
  MyShift: Double = 0; // Смещение LTC относительно системного времени
  TCExists: boolean = false;
  MyShiftOld: Double = 0; // Старое смещение LTC относительно системного времени
  MyShiftDelta: Double = 0;
  MySinhro: TSinchronization = chsystem; // Тип синхронизации
  MyStartPlay: longint = -1;
  // Время старта клипа, при chnone не используется, -1 время не установлено.
  MyStartReady: boolean = false;
  // True - готовность к старту, false - старт осуществлен.
  MyRemainTime: longint = -1; // время оставшееся до запуска

  // Основные параметры программы
  MainWindowStayOnTop: boolean = false;
  MainWindowMove: boolean = true;
  MainWindowSize: boolean = true;
  IsProjectChanges: boolean = false;
  MakeLogging: boolean = true;
  StepCoding: integer = 5;
  StepMouseWheel: integer = 10;
  SpeedMultiple: Double = 1;
  DepthUNDO: integer = 20;
  AppPath, AppName: string;
  DefaultClipDuration: longint = 10500;
  SynchDelay: integer = 2;
  InputWithoutUsers: boolean = true;
  FileNameProject: string = '';
  ListEditedProjects: tstrings;
  ListVisibleWindows: tstrings;
  PredClipID: string = '';

  WorkDirGRTemplate: string = '';
  WorkDirTextTemplate: string = '';
  WorkDirClips: string = '';
  WorkDirSubtitors: string = '';
  WorkDirKeyLayouts: string = '';

  PathFiles: string;
  PathProject: string;
  PathClips: string;
  PathPlayLists: string;
  PathTemp: string;
  PathTemplates: string;
  PathLog: string;
  PathKeyLayouts: string;

  ProjectNumber: string;
  CurrentImageTemplate: string = '@#@';

  RowDownGridProject: integer = -1;
  RowDownGridLists: integer = -1;
  RowDownGridClips: integer = -1;
  RowDownGridImgTemplate: integer = -1;
  RowDownGridActPlayList: integer = -1;

  DeltaDateDelete: integer = 10;
  CurrentMode: boolean = false;
  MainGrid: TTypeGrid = projects;
  SecondaryGrid: TTypeGrid = empty;
  ProgrammColor: tcolor = $494747;
  ProgrammCommentColor: tcolor = clYellow;
  ProgrammFontColor: tcolor = clWhite;
  OldProgrammFontColor: tcolor = clWhite;
  ProgrammFontName: tfontname = 'Arial';
  ProgrammFontSize: integer = 10;
  ProgrammEditColor: tcolor = clWhite;
  ProgrammEditFontColor: tcolor = clBlack;
  ProgrammEditFontName: tfontname = 'Arial';
  ProgrammEditFontSize: integer = 14;
  ProgrammBtnFontSize: integer = 10;
  ProgrammHintBtnFontName: tfontname = 'Arial';
  ProgrammHintBTNSFontColor: tcolor = clBlack;
  ProgrammHintBTNSFontSize: integer = 9;

  CurrentUser: string = '';
  bmpTimeline: TBitmap;
  bmpEvents: TBitmap;
  bmpAirDevices: TBitmap;
  // Image24 : TFastDIB;

  GridPlayer: TGridPlayer = grPlaylist;
  GridPlayerRow: integer = -1;
  UpdateGridTemplate: boolean = true;

  TextRichSelect: boolean = false;

  // Основные параметры вспомогательных форм
  FormsColor: tcolor = clBackground;
  FormsFontColor: tcolor = clWhite;
  FormsFontSize: integer = 10;
  FormsSmallFont: integer = 8;
  FormsFontName: tfontname = 'Arial';
  FormsEditColor: tcolor = clWindow;
  FormsEditFontColor: tcolor = clBlack;
  FormsEditFontSize: integer = 10;
  FormsEditFontName: tfontname = 'Arial';

  // Основные параметры гридов
  GridBackGround: tcolor = clBlack;
  GridColorPen: tcolor = clWhite;
  // GridMainFontColor : tcolor = clWhite;
  GridColorRow1: tcolor = $211F1F;
  GridColorRow2: tcolor = $211F1F; // $201E1E;
  GridColorSelection: tcolor = $212020;
  PhraseErrorColor: tcolor = clRed;
  PhrasePlayColor: tcolor = clLime;

  GridTitleFontName: tfontname = 'Arial';
  GridTitleFontColor: tcolor = clWhite;
  GridTitleFontSize: integer = 14;
  GridTitleFontBold: boolean = true;
  GridTitleFontItalic: boolean = false;
  GridTitleFontUnderline: boolean = false;
  GridFontName: tfontname = 'Arial';
  GridFontColor: tcolor = clWhite;
  GridFontSize: integer = 11;
  GridFontBold: boolean = false;
  GridFontItalic: boolean = false;
  GridFontUnderline: boolean = false;
  GridSubFontName: tfontname = 'Arial';
  GridSubFontColor: tcolor = clWhite;
  GridSubFontSize: integer = 9;
  GridSubFontBold: boolean = false;
  GridSubFontItalic: boolean = false;
  GridSubFontUnderline: boolean = false;
  ProjectHeightTitle: integer = 30;
  ProjectHeightRow: integer = 47;
  ProjectRowsTop: integer = 1;
  ProjectRowsHeight: integer = 21;
  ProjectRowsInterval: integer = 4;
  PLHeightTitle: integer = 0;
  PLHeightRow: integer = 47;
  PLRowsTop: integer = 1;
  PLRowsHeight: integer = 21;
  PLRowsInterval: integer = 4;
  ClipsHeightTitle: integer = 30;
  ClipsHeightRow: integer = 46;
  ClipsRowsTop: integer = 2;
  ClipsRowsHeight: integer = 20;
  ClipsRowsInterval: integer = 4;
  ListTxtHeightTitle: integer = 0;
  ListTxtHeightRow: integer = 35;
  ListTxtRowsTop: integer = 5;
  ListTxtRowsHeight: integer = 20;
  ListGRHeightTitle: integer = 0;
  ListGRHeightRow: integer = 80;
  ListGRRowsTop: integer = 8;
  ListGRRowsHeight: integer = 30;
  ListGRRowsInterval: integer = 8;
  MyCellColorTrue: tcolor = clLime;
  MyCellColorFalse: tcolor = clGray;
  MyCellColorSelect: tcolor = clRed;

  MouseInLayer2: boolean = false;
  DblClickClips: boolean;
  DblClickProject: boolean;
  DblClickLists: boolean;
  DblClickImgTemplate: boolean = false;
  DblClickGridGRTemplate: boolean = false;

  GridGrTemplateSelect: boolean = true;
  RowGridGrTemplateSelect: integer = -1;

  // Основные параметры Тайм-линий
  TLBackGround: tcolor = $211F1F;
  TLZoneNamesColor: tcolor = $505050;
  TLZoneFontColorSelect: tcolor = $057522;
  TLZoneNamesFontSize: integer = 14;
  TLZoneNamesFontColor: tcolor = clWhite;
  TLZoneNamesFontName: tfontname = 'Arial';
  TLZoneNamesFontBold: boolean = false;
  TLZoneNamesFontItalic: boolean = false;
  TLZoneNamesFontUnderline: boolean = false;
  TLZoneEditFontBold: boolean = false;
  TLZoneEditFontItalic: boolean = false;
  TLZoneEditFontUnderline: boolean = false;
  TLMaxDevice: integer = 6;
  TLMaxText: integer = 5;
  TLMaxMedia: integer = 1;
  TLMaxCount: integer = 16;
  DefaultMediaColor: tcolor = $00D8A520;
  DefaultTextColor: tcolor = $00ACEAE1;
  // Layer2FontColor : tcolor = $202020;
  Layer2FontSize: integer = 8;
  StatusColor: array [0 .. 4] of tcolor = (
    clRed,
    clGreen,
    clBlue,
    clYellow,
    clSilver
  );
  isZoneEditor: boolean = false;
  TLMaxFrameSize: integer = 10;
  TLPreroll: longint = 250;
  TLPostroll: longint = 3000;
  TLFlashDuration: integer = 5;
  // TLFontColor : tcolor = clWhite;

  // Основные параметры кнопок
  ProgBTNSFontName: tfontname = 'Arial';
  ProgBTNSFontColor: tcolor = clWhite;
  ProgBTNSFontSize: integer = 10;
  HintBTNSFontName: tfontname = 'Arial';
  HintBTNSFontColor: tcolor = clBlack;
  HintBTNSFontSize: integer = 9;
  // Параметры окна эфира
  RowsEvents: integer = 7;
  AirBackGround: tcolor = $211F1F;
  AirForeGround: tcolor = $211F1F;
  AirColorTimeLine: tcolor = $211F1F;
  DevBackGround: tcolor = $211F1F;
  TimeForeGround: tcolor = $211F1F;
  TimeSecondColor: tcolor = $211F1F;
  AirFontComment: tcolor = clYellow;
  StartColorCursor: tcolor = clGreen;
  EndColorCursor: tcolor = clBlue;


  // AirZoneNamesColor : tcolor = $505050;

  // Основные параметры печати
  PrintSpaceLeft: Real = 5;
  PrintSpaceTop: Real = 5;
  PrintSpaceRight: Real = 5;
  PrintSpaceBottom: Real = 5;
  PrintHeadLineTop: Real = 5;
  PrintHeadLineBottom: Real = 5;
  PrintCol1: string = 'Кадр';
  PrintCol2: string = 'Начало';
  PrintCol3: string = 'Хронометраж';
  PrintCol4: string = 'Камера';
  PrintCol5: string = 'Текст';
  PrintCol61: string = 'Комментарий';
  PrintCol62: string = 'Текст песни';
  PrintDeviceName: string = 'Камера';

  PrintEventShift: integer = 30;

  // Основные параметры списка горячих клавиш
  KEYFontName: tfontname;
  KEYColorNew: tcolor = clLime;
  WorkHotKeys: TMyListHotKeys;
  NAMEKeyLayout: string;

  // Размеры щрифтов для таблиц панелей
  MTFontSize: integer = 15;
  MTFontSizeS: integer = 16;
  MTFontSizeB: integer = 18;

  DefaultTransition : string = 'Cut';
  DefTransDuration  : longint = 25;
  DefTransSet       : integer = 0;

  // Procedure SetMainGridPanel(TypeGrid : TTypeGrid);
function UserExists(User, Pass: string): boolean;
function SetMainGridPanel(TypeGrid: TTypeGrid): boolean;
function TwoDigit(dig: integer): string;
// procedure SetSecondaryGrid(TypeGrid : TTypeGrid);
procedure LoadBMPFromRes(cv: tcanvas; rect: trect; width, height: integer;
  Name: string);
function SmoothColor(color: tcolor; step: integer): tcolor;
Function DefineFontSizeW(cv: tcanvas; width: integer; txt: string): integer;
Function DefineFontSizeH(cv: tcanvas; height: integer): integer;
function MyDoubleToSTime(db: Double): string;
function MyDoubleToFrame(db: Double): longint;
function FramesToStr(frm: longint): string;
function FramesToShortStr(frm: longint): string;
function SecondToStr(frm: longint): string;
function SecondToShortStr(frm: longint): string;
function FramesToDouble(frm: longint): Double;
function FramesToTime(frm: longint): tdatetime;
function TimeToFrames(dt: tdatetime): longint;
function MyTimeToStr: string;
function TimeToTimeCodeStr(dt: tdatetime): string;
function StrTimeCodeToFrames(tc: string): longint;
function createunicumname: string;
procedure CreateDirectories1;
procedure UpdateProjectPathes(NewProject: string);
procedure initnewproject;
procedure loadoldproject;
procedure LoadJpegFile(bmp: TBitmap; FileName: string);
Procedure PlayClipFromActPlaylist;
Procedure PlayClipFromClipsList;
procedure ControlPlayer;
procedure InsertEventToEditTimeline(nom: integer);
procedure MyTextRect(var cv: tcanvas; const rect: trect; Text: string);
procedure TemplateToScreen(crpos: TEventReplay);
function EraseClipInWinPrepare(ClipID: string): boolean;
procedure UpdateClipDataInWinPrepare(Grid: tstringgrid; Posi: integer;
  ClipID: string);
function SetInGridClipPosition(Grid: tstringgrid; ClipID: string): integer;
procedure ControlPlayerFastSlow(command: integer);
Procedure SetPanelTypeTL(TypeTL: TTypeTimeline; APos: integer);
procedure SetClipTimeParameters;
function MyDateTimeToStr(tm: tdatetime): string;
Procedure CheckedClipsInList;
Procedure ReloadClipInList(Grid: tstringgrid; ARow: integer);
procedure SetStatusClipInPlayer(ClipID: string);
Procedure ControlPlayerTransmition(command: integer);
procedure ControlButtonsPrepare(command: integer);
procedure SwitcherVideoPanels(command: integer);
procedure ButtonsControlClipsPanel(command: integer);
procedure ButtonsControlPlayList(command: integer);
procedure ButtonsControlMedia(command: integer);
procedure ButtonsControlProjects(command: integer);
procedure ButtonControlLists(command: integer);
procedure ButtonPlaylLists(command: integer);
function TimeCodeDelta: Double;
procedure SetTypeTimeCode;
procedure LoadImage(FileName: string; Image: TImage);
procedure LoadBitmap(FileName: string; bmp: TBitmap; width, height: integer;
  ClearColor: tcolor);
procedure ReadEditedProjects;
procedure WriteEditedProjects(CProj: string);
procedure EnableProgram;
procedure SaveClipFromPanelPrepare;
procedure updateImageTemplateGrids;
procedure ClearClipsStatusPlay;
procedure Delay(const AMilliseconds: Cardinal);
Function GetHotKeysCommand(Key: Word; Shift: TShiftState): Word;
function FindNextClipTime(Grid: tstringgrid; dtime: tdatetime): integer;
function FindNextClipTime1(Grid: tstringgrid; dtime: tdatetime): integer;
function FindPredClipTime(Grid: tstringgrid; dtime: tdatetime): integer;
function SynchroLoadClip(Grid: tstringgrid): boolean;
procedure SortGridStartTime(Grid: tstringgrid; Direction: boolean);
function TColorToTfcolor(color: tcolor): TFColor;
procedure readlistvisiblewindows(handle: hwnd);
function WindowInVisibleList(Name: string): boolean;
// procedure GetProtocolsList(SrcStr, Name : widestring; var List : tstrings); overload;
procedure GetProtocolsList(SrcStr, Name: string; List: tstrings); // overload;
function GetProtocolsStr(SrcStr, Name: string): string;
function GetProtocolsParam(SrcStr, Name: string): string;
function GetProtocolsParamEx(SrcStr: string; Number: integer): TListParam;
procedure GetListParam(SrcStr: string; lst: tstrings);

// ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
// ========================  Helpers для классов. Сохранения в JSON и загрузка ==
// ==============================================================================
Procedure LoadProject(mode : boolean);
Procedure PutGridTimeLinesToServer(GridTimeLines: tstringgrid);
Procedure PutTimeLinesToServer;
// ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
// ========================  Helpers для классов. Сохранения в JSON и загрузка ==
// ==============================================================================

implementation

uses umain, uproject, uinitforms, umyfiles, utimeline, udrawtimelines,
  ugrtimelines,
  uplaylists, uactplaylist, uplayer, uimportfiles, ulock, umyundo, uimgbuttons,
  ushifttl, UShortNum, UEvSwapBuffer, UMyMessage, uairdraw, UMyMediaSwitcher,
  UGridSort, UImageTemplate, UTextTemplate, umyprint, umediacopy,
  UMyTextTemplate, uwebget,
  umymenu, ufrlisterrors, umytexttable;

// ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
// ========================  Helpers для классов. Сохранения в JSON и загрузка ==
// ==============================================================================
Procedure LoadProject(mode : boolean);
begin
  LoadProject_active := mode;
  if LoadProject_active  then exit;
  PutGridTimeLinesToServer(form1.GridTimeLines);

end;

Procedure PutGridTimeLinesToServer(GridTimeLines: tstringgrid);
var
  i: integer;
  str1: ansistring;
  str2: ansistring;
  TLO: TTimeLineOptions;
  TlTimeline :TTlTimeline;
  sl : tstringlist;
  tle : ansistring;
begin
  if LoadProject_active then exit;

     sl := TStringList.Create;
  for I := 1 to GridTimeLines.RowCount - 1 do
  begin
     tlo := TTimelineOptions(GridTimeLines.Objects[0,i]);
     if tlo = nil  then continue;
     str1:=TLO.SaveToJSONStr;
     PutJsonStrToServer('TLO['+IntToStr(i)+']',str1);
     str2 := GetJsonStrFromServer('TLO['+IntToStr(i)+']');
//     if str1 <> str2  then
//        showmessage('!error retrieve '+'TLO['+IntToStr(i)+']');
  end;
     str1:=TLParameters.SaveToJSONStr;
     PutJsonStrToServer('TLP',str1);
     str2 := GetJsonStrFromServer('TLP');
//     if str1 <> str2  then
//        showmessage('!error retrieve '+'TLineparameters');
//sssscheck
    PutJsonStrToServer('TLEDITOR', TLZone.TLEditor.SaveToJSONstr);

//     str1:=TLEditor.SaveToJSONStr;
//     PutJsonStrToServer('TLEDITOR',str1);
//     str2 := GetJsonStrFromServer('TLEDITOR');
//     if str1 <> str2  then
//        showmessage('!error retrieve '+'TLineparameters');

  for I := 0 to tlzone.count-1 do
  begin
     TlTimeline := TTlTimeline(tlzone.timelines[i]);
     if TlTimeline = nil  then continue;
     str1:=TlTimeline.SaveToJSONStr;
     PutJsonStrToServer('TLT['+IntToStr(i)+']',str1);
     str2 := GetJsonStrFromServer('TLT['+IntToStr(i)+']');
     if str1 <> str2  then
//        showmessage('!error retrieve '+'TLT['+IntToStr(i)+']');
  end;

end;

Procedure PutTimeLinesToServer;
var
  i: integer;
  str1: ansistring;
  str2: ansistring;
  TLO: TTimeLineOptions;
  TlTimeline :TTlTimeline;
  sl : tstringlist;
  tle : ansistring;
begin
  if LoadProject_active then exit;

//     sl := TStringList.Create;
//  for I := 0 to GridTimeLines.RowCount - 1 do
//  begin
//     tlo := TTimelineOptions(GridTimeLines.Objects[0,i]);
//     if tlo = nil  then continue;
//     str1:=TLO.SaveToJSONStr;
//     PutJsonStrToServer('TLO['+IntToStr(i)+']',str1);
//     str2 := GetJsonStrFromServer('TLO['+IntToStr(i)+']');
////     if str1 <> str2  then
////        showmessage('!error retrieve '+'TLO['+IntToStr(i)+']');
//  end;
     str1:=TLParameters.SaveToJSONStr;
     PutJsonStrToServer('TLP',str1);
     str2 := GetJsonStrFromServer('TLP');
//     if str1 <> str2  then
//        showmessage('!error retrieve '+'TLineparameters');
//sssscheck
    PutJsonStrToServer('TLEDITOR', TLZone.TLEditor.SaveToJSONstr);

//     str1:=TLEditor.SaveToJSONStr;
//     PutJsonStrToServer('TLEDITOR',str1);
//     str2 := GetJsonStrFromServer('TLEDITOR');
//     if str1 <> str2  then
//        showmessage('!error retrieve '+'TLineparameters');

  for I := 0 to tlzone.count-1 do
  begin
     TlTimeline := TTlTimeline(tlzone.timelines[i]);
     if TlTimeline = nil  then continue;
     str1:=TlTimeline.SaveToJSONStr;
     PutJsonStrToServer('TLT['+IntToStr(i)+']',str1);
     str2 := GetJsonStrFromServer('TLT['+IntToStr(i)+']');
     if str1 <> str2  then
//        showmessage('!error retrieve '+'TLT['+IntToStr(i)+']');
  end;

end;


// ===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
// ========================  END Helpers для классов. Сохранения в JSON и загрузка ==
// ==============================================================================



// procedure GetProtocolsList(SrcStr, Name : widestring; var List : tstrings); overload;
// var slst,ssrc, sstr, estr, stmp : string;
// pss, pse : integer;
// begin
// List.Clear;
// ssrc := lowercase(srcstr);
// sstr := '<' + lowercase(trim(Name))+'=';
// estr := '>';
// pss := pos(sstr,ssrc);
// stmp := copy(ssrc,pss,length(ssrc));
// pse := pos(estr,stmp);
// while (pss<>0) or (pse<>0) do begin
// slst:=Copy(stmp,1,pse);
// slst := StringReplace(slst,sstr,'',[rfReplaceAll, rfIgnoreCase]);
// slst := StringReplace(slst,estr,'',[rfReplaceAll, rfIgnoreCase]);
// if trim(slst)<>'' then List.Add(slst);
// pss := pos(sstr,ssrc);
// stmp := copy(ssrc,pss,length(ssrc));
// pse := pos(estr,stmp);
// end;
// end;

procedure GetListParam(SrcStr: string; lst: tstrings);
var
  ssrc, sstr, stmp, ssc, ss1, ss2: string;
  I, pss, pse, ps1, ps2: integer;
begin
  lst.Clear;
  pss := 1;
  pse := posex('|', SrcStr, pss);
  while pse <> 0 do
  begin
    stmp := copy(SrcStr, pss, pse - pss);
    stmp := StringReplace(stmp, '|', '', [rfReplaceAll, rfIgnoreCase]);
    if trim(stmp) <> '' then
    begin
      ps1 := posex('[', stmp, 1);
      ps2 := posex(']', stmp, ps1);
      if (ps1 <> 0) and (ps2 <> 0) then
      begin
        ssc := copy(stmp, 1, ps1 - 1);
        ss1 := copy(stmp, ps1 + 1, ps2 - ps1 - 1);
        ps1 := posex('..', ss1, 1);
        if ps1 <> 0 then
        begin
          ss2 := copy(ss1, ps1 + 2, length(ss1));
          ss1 := copy(ss1, 1, ps1 - 1);
          for I := strtoint(ss1) to strtoint(ss2) do
            lst.Add(ssc + inttostr(I));
        end
        else
          lst.Add(stmp);
      end
      else
        lst.Add(stmp);
    end;
    pss := pse + 1;
    pse := posex('|', SrcStr, pss);
  end;
  stmp := copy(SrcStr, pss, length(SrcStr));
  stmp := StringReplace(stmp, '|', '', [rfReplaceAll, rfIgnoreCase]);
  if trim(stmp) <> '' then
  begin
    ps1 := posex('[', stmp, 1);
    ps2 := posex(']', stmp, ps1);
    if (ps1 <> 0) and (ps2 <> 0) then
    begin
      ssc := copy(stmp, 1, ps1 - 1);
      ss1 := copy(stmp, ps1 + 1, ps2 - ps1 - 1);
      ps1 := posex('..', ss1, 1);
      if ps1 <> 0 then
      begin
        ss2 := copy(ss1, ps1 + 2, length(ss1));
        ss1 := copy(ss1, 1, ps1 - 1);
        for I := strtoint(ss1) to strtoint(ss2) do
          lst.Add(ssc + inttostr(I));
      end
      else
        lst.Add(stmp);
    end
    else
      lst.Add(stmp);
  end;
end;

function GetProtocolsParam(SrcStr, Name: string): string;
var
  ssrc, sstr, stmp: string;
  pss, pse: integer;
begin
  result := '';
  ssrc := ansilowercase(SrcStr);
  sstr := '<' + ansilowercase(trim(Name)) + '=';
  pss := posex(sstr, ssrc, 1);
  pse := posex('>', ssrc, pss);
  if (pss = 0) or (pse = 0) then
    exit;
  stmp := copy(SrcStr, pss, pse - pss);
  stmp := StringReplace(stmp, sstr, '', [rfReplaceAll, rfIgnoreCase]);
  result := StringReplace(stmp, '>', '', [rfReplaceAll, rfIgnoreCase]);
end;

function GetProtocolsParamEx(SrcStr: string; Number: integer): TListParam;
var
  ssrc, sstr, stmp, snam, stxt, svtxt: string;
  pss, pse: integer;
begin
  result.Name := '';
  result.Text := '';
  result.VarText := '';

  ssrc := ansilowercase(SrcStr);
  sstr := '<' + inttostr(Number) + ':';
  pss := posex(sstr, ssrc, 1) + length(sstr);
  pse := posex('>', ssrc, pss);
  if (pss = 0) or (pse = 0) then
    exit;
  stmp := copy(SrcStr, pss, pse - pss);
  pse := posex('=', stmp, 1);
  result.Name := copy(stmp, 1, pse - 1);
  stmp := copy(stmp, pse + 1, length(stmp));

  pse := posex('|', stmp, 1);
  result.Text := copy(stmp, 1, pse - 1);
  result.VarText := copy(stmp, pse + 1, length(stmp));
  // stmp := StringReplace(stmp,sstr,'',[rfReplaceAll, rfIgnoreCase]);
  // result := StringReplace(stmp,'>','',[rfReplaceAll, rfIgnoreCase]);
end;

procedure GetProtocolsList(SrcStr, Name: string; List: tstrings); // overload;
var
  slst, ssrc, sstr, estr, stmp: string;
  pss, pse: integer;
begin
  List.Clear;
  ssrc := ansilowercase(SrcStr);
  sstr := '<' + ansilowercase(trim(Name));
  estr := '>';
  pss := posex(sstr, ssrc, 1);
  // stmp := copy(ssrc,pss,length(ssrc));
  pse := posex(estr, ssrc, pss);
  while (pss <> 0) and (pse <> 0) do
  begin
    slst := copy(SrcStr, pss, pse - pss);
    slst := StringReplace(slst, sstr, '', [rfReplaceAll, rfIgnoreCase]);
    slst := StringReplace(slst, estr, '', [rfReplaceAll, rfIgnoreCase]);
    if trim(slst) <> '' then
      List.Add(slst);
    pss := posex(sstr, ssrc, pse);
    pse := pos(estr, ssrc, pss);
    // stmp := copy(ssrc,pss,pse);
  end;
end;

function GetProtocolsStr(SrcStr, Name: string): string;
var
  ssrc, sstr, estr, stmp: string;
  pss, pse: integer;
begin
  result := '';
  ssrc := ansilowercase(SrcStr);
  sstr := '<' + ansilowercase(trim(Name));
  estr := '</' + ansilowercase(trim(Name));
  pss := posex(sstr, ssrc, 1);
  pse := posex(estr, ssrc, pss);
  pse := posex('>', ssrc, pse);
  if (pss = 0) or (pse = 0) then
    exit;
  result := copy(SrcStr, pss, pse - pss + 1);
  // pse:=PosEx(estr,stmp,pss);
  // if pse=0 then result:=stmp else result:=copy(stmp,1,pse-1);
end;

procedure readlistvisiblewindows(handle: hwnd);
var
  wnd: hwnd;
  buff: array [0 .. 127] of char;
begin
  ListVisibleWindows.Clear;
  wnd := GetWindow(handle, gw_hwndfirst);
  while wnd <> 0 do
  begin // Не показываем:
    if (wnd <> Application.handle) // Собственное окно
      and IsWindowVisible(wnd) // Невидимые окна
      and (GetWindow(wnd, gw_owner) <> 0) // показываем только Дочерние окна
      and (GetWindowText(wnd, buff, SizeOf(buff)) <> 0) then
    begin
      GetWindowText(wnd, buff, SizeOf(buff));
      // if StrPas(buff) = 'Печать' then
      // SetForegroundWindow(wnd);
      ListVisibleWindows.Add(StrPas(buff));
    end;
    wnd := GetWindow(wnd, gw_hwndnext);
  end;
  // ListBox1.ItemIndex := 0;
end;

function WindowInVisibleList(Name: string): boolean;
var
  I: integer;
begin
  result := false;
  for I := 0 to ListVisibleWindows.Count - 1 do
  begin
    if lowercase(trim(ListVisibleWindows.Strings[I])) = lowercase(trim(Name))
    then
    begin
      result := true;
      exit;
    end;
  end;
end;

function TColorToTfcolor(color: tcolor): TFColor;
// Преобразование TColor в RGB
var
  Clr: longint;
begin
  Clr := ColorToRGB(color);
  result.r := Clr;
  result.g := Clr shr 8;
  result.b := Clr shr 16;
end;

function cutstring(Text: string; len: integer): string;
begin
  result := Text;
  if length(Text) > len then
    result := copy(Text, 1, len - 3) + '...';
end;

procedure ProbingStartTime(Grid: tstringgrid);
var
  I, j: integer;
  stime, scmp, clp, sdur, scdr, clp1: string;
  stm, ctm, dur, cdr: longint;
begin
  ListErrors.Clear;
  for I := 1 to Grid.RowCount - 1 do
  begin
    stime := trim((Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime'));
    clp := cutstring(trim((Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('Clip')), 50);
    if stime = '' then
    begin
      ListErrors.Add('Отстутствует время старта:   [' + inttostr(I) +
        '] ' + clp);
    end
    else
    begin
      sdur := trim((Grid.Objects[0, I] as TGridRows).MyCells[3]
        .ReadPhrase('Dur'));
      stm := StrTimeCodeToFrames(stime);
      dur := StrTimeCodeToFrames(sdur);
      for j := I + 1 to Grid.RowCount - 1 do
      begin
        scmp := trim((Grid.Objects[0, j] as TGridRows).MyCells[3]
          .ReadPhrase('StartTime'));
        if scmp <> '' then
        begin
          scdr := trim((Grid.Objects[0, j] as TGridRows).MyCells[3]
            .ReadPhrase('Dur'));
          clp1 := cutstring(trim((Grid.Objects[0, j] as TGridRows).MyCells[3]
            .ReadPhrase('Clip')), 50);
          ctm := StrTimeCodeToFrames(scmp);
          cdr := StrTimeCodeToFrames(scdr);
          if ((ctm >= stm) and (ctm <= stm + dur)) or
            ((ctm + cdr >= stm) and (ctm + cdr <= stm + dur)) or
            ((stm >= ctm) and (stm <= ctm + cdr)) or
            ((stm + dur >= ctm) and (stm + dur <= ctm + dur)) then
          begin
            ListErrors.Add('Пересечение времен:           [' + inttostr(I) +
              '] ' + clp + '    -    [' + inttostr(j) + '] ' + clp1);
          end;
        end;
      end;
    end;
  end;
  if ListErrors.Count = 0 then
  begin
    MyTextMessage('Сообщение', 'Всем клипам присвоенно время старта.', 1);
  end
  else
  begin
    ShowListErrors;
  end;
end;

function findmintime(Grid: tstringgrid; ARow: integer): integer;
var
  I: integer;
  dlt, tm: longint;
  stime: string;
begin
  result := -1;
  dlt := -1;
  for I := ARow to Grid.RowCount - 1 do
  begin
    stime := (Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) = '' then
      tm := StrTimeCodeToFrames('24:00:00:00')
    else
      tm := StrTimeCodeToFrames(stime);
    if dlt = -1 then
    begin
      dlt := tm;
      result := I;
    end
    else
    begin
      if tm < dlt then
      begin
        dlt := tm;
        result := I;
      end;
    end;
  end;
end;

function findmaxtime(Grid: tstringgrid; ARow: integer): integer;
var
  I: integer;
  dlt, tm: longint;
  stime: string;
begin
  result := -1;
  dlt := -1;
  for I := ARow to Grid.RowCount - 1 do
  begin
    stime := (Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) = '' then
      tm := StrTimeCodeToFrames('24:00:00:00')
    else
      tm := StrTimeCodeToFrames(stime);
    if dlt = -1 then
    begin
      dlt := tm;
      result := I;
    end
    else
    begin
      if tm > dlt then
      begin
        dlt := tm;
        result := I;
      end;
    end;
  end;
end;

procedure SortGridStartTime(Grid: tstringgrid; Direction: boolean);
var
  I, j, k: integer;
  f1, f2, rw: longint;
  stime: string;
  temp: TGridRows;
begin
  temp := TGridRows.Create;
  try
    if Direction then
    begin
      for I := 1 to Grid.RowCount - 1 do
      begin
        rw := findmintime(Grid, I);
        if rw = -1 then
          exit;
        temp.Assign(Grid.Objects[0, rw] as TGridRows);
        (Grid.Objects[0, rw] as TGridRows)
          .Assign(Grid.Objects[0, I] as TGridRows);
        (Grid.Objects[0, I] as TGridRows).Assign(temp);
      end;
    end
    else
    begin
      for I := 1 to Grid.RowCount - 1 do
      begin
        rw := findmaxtime(Grid, I);
        if rw = -1 then
          exit;
        temp.Assign(Grid.Objects[0, rw] as TGridRows);
        (Grid.Objects[0, rw] as TGridRows)
          .Assign(Grid.Objects[0, I] as TGridRows);
        (Grid.Objects[0, I] as TGridRows).Assign(temp);
      end;
    end;
    Grid.Repaint;
  finally
    temp.FreeInstance;
  end;
end;

function FindPredClipTime(Grid: tstringgrid; dtime: tdatetime): integer;
var
  I, ps: integer;
  // dlt : longint;
  clid, stime, send, stm: string;
  dtnow, dtt, dlt, dtend: tdatetime;
  // btp : boolean;
begin
  dtnow := dtime - TimeCodeDelta;

  result := -1;
  // btp := false;
  dlt := -1;
  ps := -1;
  for I := 1 to Grid.RowCount - 1 do
  begin
    stime := (Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) = '' then
      continue;
    send := (Grid.Objects[0, I] as TGridRows).MyCells[3].ReadPhrase('Duration');
    dtt := trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime));
    dtend := FramesToTime(StrTimeCodeToFrames(send));
    if (dtt <= dtnow) and (dtt + dtend >= dtnow) then
    begin
      if dlt = -1 then
      begin
        dlt := dtnow - dtt;
        ps := I;
      end
      else
      begin
        if dlt > dtnow - dtt then
        begin
          dlt := dtnow - dtt;
          ps := I;
        end;
      end;
      // btp:=true
    end;
  end;
  if ps > 0 then
  begin
    stime := (Grid.Objects[0, ps] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) <> '' then
      dtnow := trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime));
  end;
  dlt := -1;
  for I := 1 to Grid.RowCount - 1 do
  begin
    if I = ps then
      continue;

    stime := (Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) = '' then
      continue;
    dtt := trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime));
    // send := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Dur');
    // dtend := FramesToTime(StrTimeCodeToFrames(send));
    // dtend := dtt + dtend;
    if dtt < dtnow then
    begin
      if dlt = -1 then
      begin
        dlt := dtnow - dtt;
        result := I;
      end
      else
      begin
        if dlt > dtnow - dtt then
        begin
          dlt := dtnow - dtt;
          result := I;
        end;
      end;
    end;
  end;
end;

function FindNextClipTime1(Grid: tstringgrid; dtime: tdatetime): integer;
var
  I, ps: integer;
  // dlt : longint;
  clid, stime, send, stm: string;
  dtnow, dtt, dlt, dtend: ttime;
  // btp : boolean;
begin

  dtnow := (dtime - trunc(dtime)) - TimeCodeDelta;
  result := -1;
  // btp := false;
  dlt := -1;
  ps := -1;
  for I := 1 to Grid.RowCount - 1 do
  begin
    stime := (Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) = '' then
      continue;
    send := (Grid.Objects[0, I] as TGridRows).MyCells[3].ReadPhrase('Duration');
    dtt := FramesToTime(StrTimeCodeToFrames(stime));
    dtend := FramesToTime(StrTimeCodeToFrames(send));
    if (dtt <= dtnow) and (dtt + dtend >= dtnow) then
    begin
      if dlt = -1 then
      begin
        dlt := dtnow - dtt;
        ps := I;
      end
      else
      begin
        if dlt > dtnow - dtt then
        begin
          dlt := dtnow - dtt;
          ps := I;
        end;
      end;
      // btp:=true
    end;
  end;
  if ps > 0 then
  begin
    stime := (Grid.Objects[0, ps] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) <> '' then
    begin
      dtt := FramesToTime(StrTimeCodeToFrames(stime));
      send := (Grid.Objects[0, ps] as TGridRows).MyCells[3].ReadPhrase('Dur');
      dtend := FramesToTime(StrTimeCodeToFrames(send));
      dtnow := dtt + dtend;
    end;
  end;
  dlt := -1;
  for I := 0 to Grid.RowCount - 1 do
  begin
    stime := (Grid.Objects[0, I] as TGridRows).MyCells[3]
      .ReadPhrase('StartTime');
    if trim(stime) = '' then
      continue;
    dtt := FramesToTime(StrTimeCodeToFrames(stime));
    send := (Grid.Objects[0, I] as TGridRows).MyCells[3].ReadPhrase('Dur');
    dtend := FramesToTime(StrTimeCodeToFrames(send));
    dtend := dtt + dtend;
    if dtend > dtnow then
    begin
      if dlt = -1 then
      begin
        dlt := dtend - dtnow;
        result := I;
      end
      else
      begin
        if dlt < dtnow - dtend then
        begin
          dlt := dtend - dtnow;
          result := I;
        end;
      end;
    end;
  end;
end;

function FindNextClipTime(Grid: tstringgrid; dtime: tdatetime): integer;
var
  I, ps: integer;
  // dlt : longint;
  stime, send: string;
  dtnow, dtt, dlt, dtend: tdatetime;
begin
  dtnow := dtime - TimeCodeDelta;
  result := -1;
  dlt := -1;
  for I := 0 to Grid.RowCount - 1 do
  begin
    if Grid.Objects[0, I] is TGridRows then
    begin
      stime := (Grid.Objects[0, I] as TGridRows).MyCells[3]
        .ReadPhrase('StartTime');
      if trim(stime) = '' then
        continue;

      send := (Grid.Objects[0, I] as TGridRows).MyCells[3].ReadPhrase('Dur');
      if trim(send) = '' then
        dtend := 0
      else
        dtend := FramesToTime(StrTimeCodeToFrames(send));

      if trim(stime) <> '' then
      begin
        dtt := trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime));
        dtend := dtt + dtend;
        if dtend < dtnow then
          continue;
        if (dtt <= dtnow) and (dtnow < dtend) then
        begin
          result := I;
          exit;
        end;
        if dtt > dtnow then
        begin
          if dlt = -1 then
          begin
            dlt := dtt - dtnow;
            result := I;
          end
          else
          begin
            if (dtt - dtnow) < dlt then
            begin
              dlt := dtt - dtnow;
              result := I;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function sourceclipsstr: string;
begin
  if GridPlayer = grClips then
  begin
    result := 'Список клипов';
  end
  else
  begin;
    if form1.listbox1.ItemIndex = -1 then
      form1.lbusesclpidlst.Caption := 'Плей-лист: '
    else
      form1.lbusesclpidlst.Caption := 'Плей-лист: ' +
        trim(form1.listbox1.Items.Strings[form1.listbox1.ItemIndex]);
  end;
end;

function SynchroLoadClip(Grid: tstringgrid): boolean;
var
  rw: integer;
  ClipID, stime, send: string;
  dtnext, dtend, dtnow: tdatetime;
  nowfrm, strfrm, endfrm: longint;
begin
  if GridPlayer = grDefault then
  begin
    // MyTextMessage('Сообщение','Не выбран источник клипов.' + #13#10
    // + 'Клипы будут выбираться из списка клипов.' ,1);
    GridPlayer := grPlaylist;
    // appllc
  end;
  if TLParameters.vlcmode = play then
    exit;
  dtnow := now;
  // if lowercase(trim(Form1.lbActiveClipID.Caption))<>'' then begin
  // nowfrm := TimeToFrames(dtnow);
  // strfrm := StrTimeCodeToFrames(Form1.lbTypeTC.Caption);
  // endfrm := strfrm + TLParameters.Finish-TLParameters.Preroll;
  // if (nowfrm>=strfrm) and (nowfrm<=endfrm)
  // then TLParameters.Position:=TLParameters.Preroll + endfrm - nowfrm;
  // MediaPlay;
  // end;
  rw := FindNextClipTime(Grid, dtnow);
  if rw = -1 then
    exit;
  ClipID := (Grid.Objects[0, rw] as TGridRows).MyCells[3].ReadPhrase('ClipID');

  if lowercase(trim(ClipID)) <> lowercase(trim(form1.lbActiveClipID.Caption))
  then
  begin
    if form1.MySynhro.Checked then
    begin
      GridPlayerRow := rw;
      GridPlayer := grPlaylist;
      LoadClipsToPlayer;
    end;
  end;

  // =======================
  stime := (Grid.Objects[0, rw] as TGridRows).MyCells[3]
    .ReadPhrase('StartTime');
  send := (Grid.Objects[0, rw] as TGridRows).MyCells[3].ReadPhrase('Duration');
  if trim(send) = '' then
    dtend := 0
  else
    dtend := FramesToTime(StrTimeCodeToFrames(send));
  dtnext := trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime)) + dtend;
  // =========================

  rw := FindNextClipTime1(Grid, dtnext);
  form1.lbusesclpidlst.Caption := sourceclipsstr;
  if rw = -1 then
    exit
  else
  begin
    form1.lbusesclpidlst.Caption := form1.lbusesclpidlst.Caption + ' (' +
      trim((Grid.Objects[0, rw] as TGridRows).MyCells[3]
      .ReadPhrase('Clip')) + ')';
  end;
end;

Function GetHotKeysCommand(Key: Word; Shift: TShiftState): Word;
var
  s, serr1, serr2: string;
  res: Word;
  key1: byte;
begin
  // if not (frHotKeys.ActiveControl=stringgrid1) then begin
  result := $FFFF;
  res := 0;
  if ssCtrl in Shift then
    res := res or $0100;
  if ssShift in Shift then
    res := res or $0200;
  if ssAlt in Shift then
    res := res or $0400;
  key1 := Key;
  if not((key1 = 16) or (key1 = 17) or (key1 = 18)) then
    result := res + key1;
end;

procedure Delay(const AMilliseconds: Cardinal);
var
  SaveTickCount: Cardinal;
begin
  SaveTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
  until GetTickCount - SaveTickCount > AMilliseconds;
end;

procedure updateImageTemplateGrids;
var
  I: integer;
begin
  with form1, FGRTemplate do
  begin
    GridClear(GridGRTemplate, RowGridListGR);
    GridGRTemplate.RowCount := 0;
    for I := 0 to GridImgTemplate.RowCount - 1 do
    begin
      GridAddRow(GridGRTemplate, RowGridListGR);
      (GridGRTemplate.Objects[0, GridGRTemplate.RowCount - 1] as TGridRows)
        .Assign((GridImgTemplate.Objects[0, I] as TGridRows));
    end;
  end;
end;

procedure SaveClipFromPanelPrepare;
var
  I, oldcount: integer;
  clpid: string;
begin
  with form1 do
  begin
    if trim(lbActiveClipID.Caption) <> '' then
      SaveClipEditingToFile(trim(lbActiveClipID.Caption))
    else
    begin
      if PanelPrepare.Visible then
      begin
        for I := 0 to TLZone.Count - 1 do
        begin
          if TLZone.Timelines[I].Count > 0 then
          begin
            if MyTextMessage('Вопрос',
              'Сохранить редактируемые данные в списке клипов?', 2) then
            begin
              FImportFiles.edTotalDur.Text :=
                trim(FramesToStr(DefaultClipDuration));
              FImportFiles.edNTK.Text :=
                trim(FramesToStr(TLParameters.Start - TLParameters.Preroll));
              FImportFiles.EdDur.Text :=
                trim(FramesToStr(TLParameters.Finish - TLParameters.Start));
              FImportFiles.ExternalValue := true;
              oldcount := form1.GridClips.RowCount;
              EditClip(-100);
              if oldcount < form1.GridClips.RowCount then
              begin
                clpid := (form1.GridClips.Objects[0, form1.GridClips.RowCount -
                  1] as TGridRows).MyCells[3].ReadPhrase('ClipID');
                lbActiveClipID.Caption := clpid;
                SaveClipEditingToFile(trim(clpid));
              end;
            end;
            break;
          end;
        end;
      end;
    end;
  end;
end;

procedure EnableProgram;
begin
  form1.sbMainMenu.Enabled := true;
  form1.sbProject.Enabled := true;
  form1.sbClips.Enabled := true;
  form1.sbPlayList.Enabled := true;
  form1.sbPredClip.Enabled := true;
  form1.sbNextClip.Enabled := true;
  form1.Label2.Enabled := true;
  form1.lbMode.Enabled := true;
  form1.GridLists.Enabled := true;
  form1.GridTimeLines.Enabled := true;
  form1.imgButtonsProject.Enabled := true;
  form1.imgButtonsControlProj.Enabled := true;
  form1.imgBlockProjects.Enabled := true;
  form1.ImgButtonsPL.Enabled := true;
end;

procedure ReadEditedProjects;
var
  fl: string;
  I: integer;
begin
  fl := AppPath + 'EditedProjects.eprj';
  if fileexists(fl) then
  begin
    ListEditedProjects.Clear;
    ListEditedProjects.LoadFromFile(fl);
    for I := ListEditedProjects.Count - 1 downto 0 do
      if not fileexists(ListEditedProjects.Strings[I]) then
        ListEditedProjects.Delete(I);
    if MenuListFiles = nil then
      MenuListFiles := TMyMenu.Create
    else
      MenuListFiles.Clear;
    for I := 0 to ListEditedProjects.Count - 1 do
      MenuListFiles.Add(extractfilename(ListEditedProjects.Strings[I]), I);
    // Form1.ListBox2.ItemIndex:=-1;
    MenuListFiles.offset := 0;
    MenuListFiles.rowheight := 20;
    form1.ImgListFiles.height := MenuListFiles.Count * MenuListFiles.rowheight;
    form1.ImgListFiles.width := 265;
    form1.ImgListFiles.Picture.Bitmap.height := form1.ImgListFiles.height;
    form1.ImgListFiles.Picture.Bitmap.width := form1.ImgListFiles.width;
    form1.ImgListFiles.Repaint;
    MenuListFiles.Draw(form1.ImgListFiles.Canvas);
  end;
end;

procedure WriteEditedProjects(CProj: string);
var
  fl, renm: string;
  I: integer;
begin
  fl := AppPath + 'EditedProjects.eprj';
  for I := ListEditedProjects.Count - 1 downto 0 do
    if lowercase(trim(ListEditedProjects.Strings[I])) = lowercase(trim(CProj))
    then
      ListEditedProjects.Delete(I);
  ListEditedProjects.Insert(0, CProj);
  if ListEditedProjects.Count > 10 then
    for I := ListEditedProjects.Count - 1 downto 10 do
      ListEditedProjects.Delete(I);
  if fileexists(fl) then
  begin
    renm := AppPath + '\Temp.eprj';
    RenameFile(fl, renm);
    DeleteFile(renm);
  end;
  ListEditedProjects.SaveToFile(fl);
end;

procedure LoadImage(FileName: string; Image: TImage);
var
  ext: string;
  Tmp, Tmp1: TFastDIB;
  tfClr: TFColor;
  Clr: longint;
begin
  Tmp := TFastDIB.Create;
  if fileexists(FileName) then
  begin
    ext := lowercase(ExtractFileExt(FileName));
    if ext = '.bmp' then
      Tmp.LoadFromFile(FileName)
    else if (ext = '.jpg') or (ext = '.jpeg') then
      LoadJPGFile(Tmp, FileName, true);
  end
  else
  begin
    Tmp.SetSize(Image.width, Image.height, 32);
    Clr := ColorToRGB(SmoothColor(ProgrammColor, 24));
    // r := Color; g := Color shr 8; b := Color shr 16
    tfClr.r := Clr;
    tfClr.g := Clr shr 8;
    tfClr.b := Clr shr 16;
    Tmp.Clear(tfClr);
    Tmp.SetFont('Tahoma', 50);
  end;

  Tmp1 := TFastDIB.Create;
  Tmp1.SetSize(Image.width, Image.height, Tmp.Bpp);
  if Tmp1.Bpp = 8 then
  begin
    Tmp1.Colors^ := Tmp.Colors^;
    Tmp1.UpdateColors;
  end;

  Bilinear(Tmp, Tmp1);
  Tmp1.FreeHandle := false;
  Image.Picture.Bitmap.handle := Tmp1.handle;
  Tmp1.Free;

  Tmp.Free;
end;

procedure LoadBitmap(FileName: string; bmp: TBitmap; width, height: integer;
  ClearColor: tcolor);
var
  ext: string;
  Tmp, Tmp1: TFastDIB;
  tfClr: TFColor;
  Clr: longint;
begin
  Tmp := TFastDIB.Create;
  if fileexists(FileName) then
  begin
    ext := lowercase(ExtractFileExt(FileName));
    if ext = '.bmp' then
      Tmp.LoadFromFile(FileName)
    else if (ext = '.jpg') or (ext = '.jpeg') then
      LoadJPGFile(Tmp, FileName, true);
  end
  else
  begin
    Tmp.SetSize(width, height, 32);
    Clr := ColorToRGB(ClearColor);
    // r := Color; g := Color shr 8; b := Color shr 16
    tfClr.r := Clr;
    tfClr.g := Clr shr 8;
    tfClr.b := Clr shr 16;
    Tmp.Clear(tfClr);
    // Tmp.SetFont('Tahoma',50);
  end;

  Tmp1 := TFastDIB.Create;
  Tmp1.SetSize(width, height, Tmp.Bpp);
  if Tmp1.Bpp = 8 then
  begin
    Tmp1.Colors^ := Tmp.Colors^;
    Tmp1.UpdateColors;
  end;

  Bilinear(Tmp, Tmp1);
  Tmp1.FreeHandle := false;
  bmp.handle := Tmp1.handle;
  Tmp1.Free;

  Tmp.Free;
end;

procedure SetTypeTimeCode;
var
  txt: string;
begin
  txt := '';
  if (MyStartPlay <> -1) then
    txt := 'Старт в (' + trim(FramesToStr(MyStartPlay)) + ')';
  if (MyRemainTime <> -1) and form1.MySynhro.Checked { MyStartReady } then
    txt := 'До старта (' + trim(FramesToShortStr(MyRemainTime)) + ')';

  form1.lbTypeTC.Caption := txt;
  // if txt<>'' then begin
  // Form1.lbTypeTC.Caption := txt;
  // end else begin
  // Form1.lbTypeTC.Caption := '';
  // end;

  // MyShift      : double = 0; //Смещение LTC относительно системного времени
  // MyShiftOld   : double = 0; //Старое смещение LTC относительно системного времени
  // MyShiftDelta : double = 0;
  // MySinhro     : TSinchronization = chnone; //Тип синхронизации
  // MyStartPlay  : longint = -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
  // MyStartReady : boolean = false; // True - готовность к старту, false - старт осуществлен.
end;

function TimeCodeDelta: Double;
begin
  result := 0;
  if MySinhro = chltc then
    result := MyShift;
end;

function UserExists(User, Pass: string): boolean;
begin
  result := false;
  if (User = 'Demo') and (Pass = 'Demo') then
    result := true;
end;

// procedure SetStatusClipInPlayer(ClipID : string);
// var i, ps : integer;
// clpid, txt : string;
// clr : tcolor;
// begin
// try
// WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID);
// ps := Uplaylists.findclipposition(Form1.GridClips, ClipID);
// clr := (Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].ReadPhraseColor('Clip');
// if clr <> PhraseErrorColor then begin
// clpid := trim((Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
// if clpid=trim(ClipID)
// then (Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhrasePlayColor)
// else (Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].SetPhraseColor('Clip', GridFontColor);
// end;
// CheckedActivePlayList;
// except
// on E: Exception do WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID + ' | ' + E.Message);
// end;
// end;

procedure ClearClipsStatusPlay;
var
  I: integer;
  clpid, txt: string;
  Clr: tcolor;
begin
  try
    WriteLog('MAIN', 'UCommon.ClearClipsStatusPlay');
    for I := 1 to form1.GridClips.RowCount - 1 do
      if form1.GridClips.Objects[0, I] is TGridRows then
        (form1.GridClips.Objects[0, I] as TGridRows).MyCells[2].Mark := true;
    CheckedActivePlayList;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.ClearClipsStatusPlay | ' + E.Message);
  end;
end;

procedure SetStatusClipInPlayer(ClipID: string);
var
  I: integer;
  clpid, txt: string;
  Clr: tcolor;
  frerr: boolean;
begin
  try
    WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID);
    for I := 1 to form1.GridClips.RowCount - 1 do
    begin
      if form1.GridClips.Objects[0, I] is TGridRows then
      begin
        Clr := (form1.GridClips.Objects[0, I] as TGridRows).MyCells[3]
          .ReadPhraseColor('Clip');
        frerr := false;
        if Clr = PhraseErrorColor then
          frerr := true;
        clpid := trim((form1.GridClips.Objects[0, I] as TGridRows).MyCells[3]
          .ReadPhrase('ClipID'));
        if clpid = trim(ClipID) then
        begin
          if not frerr then
            (form1.GridClips.Objects[0, I] as TGridRows).MyCells[3]
              .SetPhraseColor('Clip', PhrasePlayColor);
          (form1.GridClips.Objects[0, I] as TGridRows).MyCells[2].Mark := false;
        end
        else
        begin
          if not frerr then
            (form1.GridClips.Objects[0, I] as TGridRows).MyCells[3]
              .SetPhraseColor('Clip', GridFontColor);
          (form1.GridClips.Objects[0, I] as TGridRows).MyCells[2].Mark := true;
        end;
      end;
    end;
    CheckedActivePlayList;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID + ' | '
        + E.Message);
  end;
end;

Procedure CheckedClipsInList;
var
  I: integer;
  pth, txt: string;
begin
  try
    with form1 do
    begin
      WriteLog('MAIN', 'UCommon.CheckedClipsInList Start GridClips');
      for I := 1 to GridClips.RowCount - 1 do
      begin
        if GridClips.Objects[0, I] is TGridRows then
        begin
          txt := (GridClips.Objects[0, I] as TGridRows).MyCells[3]
            .ReadPhrase('File');

          if trim(txt) <> '' then
          begin
            if not fileexists(txt) then
            begin
              (GridClips.Objects[0, I] as TGridRows).MyCells[3].SetPhraseColor
                ('Clip', PhraseErrorColor);
              WriteLog('MAIN', 'UCommon.CheckedClipsInList-1 GridClips File=' +
                txt + 'Не существует');
            end
            else
              WriteLog('MAIN', 'UCommon.CheckedClipsInList GridClips File=' +
                txt + 'Найден');
          end
          else
          begin
            (GridClips.Objects[0, I] as TGridRows).MyCells[3].SetPhraseColor
              ('Clip', PhraseErrorColor);
            WriteLog('MAIN', 'UCommon.CheckedClipsInList-2 GridClips File=' +
              txt + 'Не существует');
          end;
        end;
      end;
      WriteLog('MAIN', 'UCommon.CheckedClipsInList Finish GridClips');
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.CheckedClipsInList GridLists  | ' + E.Message);
  end;
end;

Procedure ReloadClipInList(Grid: tstringgrid; ARow: integer);
var
  txt: string;
  err: integer;
  dur: int64;
  mediadata: string;
begin
  try
    WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name + ' ARow' +
      inttostr(ARow));
    if Grid.Objects[0, ARow] is TGridRows then
    begin
      // txt := (Grid.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('File');
      // Form1.opendialog1.FileName:=txt;
      if form1.OpenDialog1.Execute then
      begin
        if trim(form1.OpenDialog1.FileName) <> '' then
        begin
          err := LoadVLCPlayer(form1.OpenDialog1.FileName, mediadata);
          if err <> 0 then
          begin
            ShowMessage
              ('Невозможно прочитать параметры выбранного медиафайла.');
            (Grid.Objects[0, ARow] as TGridRows).MyCells[3].SetPhraseColor
              ('Clip', clRed);
            (Grid.Objects[0, ARow] as TGridRows).MyCells[3].UpdatePhrase('File',
              'Медиа-данные отсутствуют');
            WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name +
              ' ARow' + inttostr(ARow) + ' File=' +
              trim(form1.OpenDialog1.FileName) + ' Медиа-данные отсутствуют');
            exit;
          end;
          (Grid.Objects[0, ARow] as TGridRows).MyCells[3].SetPhraseColor('Clip',
            GridFontColor);
          txt := CopyMediaFile(form1.OpenDialog1.FileName, PathFiles);
          (Grid.Objects[0, ARow] as TGridRows).MyCells[3].UpdatePhrase('File',
            trim(txt));
          // pMediaPosition.get_Duration(dur);
          dur := vlcplayer.Duration div 40;
          (Grid.Objects[0, ARow] as TGridRows).MyCells[3].UpdatePhrase
            ('Duration', FramesToStr(dur));
          (Grid.Objects[0, ARow] as TGridRows).MyCells[3].UpdatePhrase
            ('MediaType', mediadata);
          WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name +
            ' ARow' + inttostr(ARow) + ' File=' +
            trim(form1.OpenDialog1.FileName) + ' Загружен');
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name + ' ARow' +
        inttostr(ARow) + ' | ' + E.Message);
  end;
end;

procedure SetClipTimeParameters;
begin
  try
    form1.lbMediaKTK.Caption :=
      FramesToStr(TLParameters.Finish - TLParameters.ZeroPoint);
    form1.lbMediaNTK.Caption :=
      FramesToStr(TLParameters.Start - TLParameters.ZeroPoint);
    form1.lbMediaDuration.Caption := FramesToStr(TLParameters.Duration);
    form1.lbMediaCurTK.Caption :=
      FramesToStr(TLParameters.Position - TLParameters.ZeroPoint);
    form1.lbMediaTotalDur.Caption :=
      FramesToStr(TLParameters.Finish - TLParameters.Start);
    form1.lbMediaKTK.Repaint;
    form1.lbMediaNTK.Repaint;
    form1.lbMediaDuration.Repaint;
    form1.lbMediaCurTK.Repaint;
    form1.lbMediaTotalDur.Repaint;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.ReloadClipInList SetClipTimeParameters | ' +
        E.Message);
  end;
end;

Procedure SetPanelTypeTL(TypeTL: TTypeTimeline; APos: integer);
begin
  try
    case TypeTL of
      tldevice:
        begin
          form1.pnDevTL.Visible := true;
          form1.PnTextTL.Visible := false;
          form1.pnMediaTL.Visible := false;
          btnspanel1.Rows[0].Btns[3].Visible := true;
          btnspanel1.Rows[0].Btns[4].Visible := true;
          btnsdevicepr.BackGround := ProgrammColor;
          InitBTNSDEVICE(form1.imgDeviceTL.Canvas,
            (form1.GridTimeLines.Objects[0, APos] as TTimeLineOptions),
            btnsdevicepr);
          WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tldevice Apos=' +
            inttostr(APos));
        end;
      tltext:
        begin
          form1.pnDevTL.Visible := false;
          form1.PnTextTL.Visible := true;
          form1.pnMediaTL.Visible := false;
          btnspanel1.Rows[0].Btns[3].Visible := false;
          btnspanel1.Rows[0].Btns[4].Visible := true;
          form1.imgTextTL.width := form1.pnPrepareCTL.width;
          form1.imgTextTL.Picture.Bitmap.width := form1.imgTextTL.width;
          btnstexttl.Draw(form1.imgTextTL.Canvas);
          WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tltext Apos=' +
            inttostr(APos));
        end;
      tlmedia:
        begin
          form1.pnDevTL.Visible := false;
          form1.PnTextTL.Visible := false;
          form1.pnMediaTL.Visible := true;
          btnspanel1.Rows[0].Btns[3].Visible := false;
          btnspanel1.Rows[0].Btns[4].Visible := false;
          form1.imgMediaTL.Picture.Bitmap.width := form1.imgMediaTL.width;
          form1.imgMediaTL.Picture.Bitmap.height := form1.imgMediaTL.height;
          btnsmediatl.Top := form1.imgMediaTL.height div 2 - 35;
          btnsmediatl.Draw(form1.imgMediaTL.Canvas);
          WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tlmedia Apos=' +
            inttostr(APos));
        end;
    end; // case
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.SetPanelTypeTL Apos=' + inttostr(APos) + ' | ' +
        E.Message);
  end;
end;

function SetInGridClipPosition(Grid: tstringgrid; ClipID: string): integer;
begin
  try
    WriteLog('MAIN', 'UCommon.SetInGridClipPosition Start Grid=' + Grid.Name +
      ' ClipID=' + ClipID);
    result := FindClipInGrid(Grid, ClipID);
    // if result = -1 then EraseClipInWinPrepare('')
    // else begin
    if result >= 0 then
    begin
      GridPlayerRow := result;
      Grid.Row := result;
      UpdateClipDataInWinPrepare(Grid, result, ClipID);
    end;
    // end;
    WriteLog('MAIN', 'UCommon.SetInGridClipPosition Finish Grid=' + Grid.Name +
      ' ClipID=' + ClipID);
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.SetInGridClipPosition Grid=' + Grid.Name +
        ' ClipID=' + ClipID + ' | ' + E.Message);
  end;
end;

procedure UpdateClipDataInWinPrepare(Grid: tstringgrid; Posi: integer;
  ClipID: string);
begin
  try
    WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Start Grid=' +
      Grid.Name + ' ClipID=' + ClipID + ' Position=' + inttostr(Posi));
    if (trim(ClipID) = trim(form1.lbActiveClipID.Caption)) then
    begin
      GridPlayerRow := Posi;
      WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Grid=' + Grid.Name +
        ' ClipID=' + ClipID + ' GridPlayerRow=' + inttostr(Posi));
      // Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
      pntlprep.SetText('Nom', inttostr(GridPlayerRow));
      form1.lbActiveClipID.Caption :=
        (Grid.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('ClipID');
      form1.Label2.Caption := (Grid.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Clip');
      // Form1.lbClipName.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
      pntlprep.SetText('ClipName', (Grid.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Clip'));
      // Form1.lbSongName.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
      pntlprep.SetText('SongName', (Grid.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Song'));
      // Form1.lbSongSinger.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
      pntlprep.SetText('SingerName',
        (Grid.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('Singer'));
      form1.lbPlayerFile.Caption :=
        (Grid.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('File');
      pntlprep.Draw(form1.imgdataprep.Canvas);
      form1.imgdataprep.Repaint;
      SetButtonsPredNext;
    end;
    WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Finish Grid=' +
      Grid.Name + ' ClipID=' + ClipID + ' Position=' + inttostr(Posi));
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Finish Grid=' +
        Grid.Name + ' ClipID=' + ClipID + ' Position=' + inttostr(Posi) + ' | '
        + E.Message);
  end;
end;

function EraseClipInWinPrepare(ClipID: string): boolean;
var
  I, j: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Start ClipID=' + ClipID);
    result := false;
    if (trim(ClipID) = trim(form1.lbActiveClipID.Caption)) or (trim(ClipID) = '')
    then
    begin
      WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Erase ClipID=' + ClipID);
      TLZone.ClearZone;
      form1.lbActiveClipID.Caption := '';
      form1.Label2.Caption := '';
      TLParameters.Start := TLParameters.Preroll;
      TLParameters.Duration := 0;
      TLParameters.Finish := TLParameters.Start + TLParameters.Duration;
      TLParameters.ZeroPoint := TLParameters.Start;
      TLParameters.Position := TLParameters.Start;
      PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
      TLParameters.EndPoint := TLParameters.Start + TLParameters.Duration;
      form1.lbMediaNTK.Caption :=
        FramesToStr(TLParameters.Start - TLParameters.Preroll);
      form1.lbMediaDuration.Caption :=
        FramesToStr(TLParameters.Finish - TLParameters.Start);
      form1.lbMediaKTK.Caption :=
        FramesToStr(TLParameters.Finish - TLParameters.Preroll);
      form1.lbMediaTotalDur.Caption := FramesToStr(TLParameters.Duration);
      form1.lbMediaCurTK.Caption :=
        FramesToStr(TLParameters.Start - TLParameters.Preroll);
      pntlprep.SetText('Nom', '');
      pntlprep.SetText('ClipName', '');
      pntlprep.SetText('SongName', '');
      pntlprep.SetText('SingerName', '');

      // Form1.lbNomClips.Caption:='';
      // Form1.lbClipName.Caption:='';
      // Form1.lbSongName.Caption:='';
      // Form1.lbSongSinger.Caption:='';
      form1.lbPlayerFile.Caption := '';
      MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', '',
        'EraseClipInWinPrepare');
      form1.Image3.Picture.Bitmap := nil;
      form1.Image3.Canvas.FillRect(form1.Image3.Canvas.ClipRect);
      form1.imgtimelines.Canvas.FillRect(form1.imgtimelines.Canvas.ClipRect);
      bmpTimeline.Canvas.FillRect(bmpTimeline.Canvas.ClipRect);
      ClearVLCPlayer;
      TLZone.ClearZone;
      TLZone.DrawBitmap(bmpTimeline);
      TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
      form1.imgtimelines.Repaint;
      if form1.Image3.Visible then
        form1.Image3.Repaint;
      ClearUNDO;
      SetStatusClipInPlayer('!!@@##$$%%^^&&**');
      pntlprep.Draw(form1.imgdataprep.Canvas);
      form1.imgdataprep.Repaint;
    end;
    WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Finish ClipID=' + ClipID);
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare ClipID=' + ClipID + ' | '
        + E.Message);
  end;
end;

Procedure SetPathProject(IDProject: string);
begin
  PathProject := AppPath + DirProjects + '\' + IDProject;
  // PathEvents:=PathProject + '\' + DirEvents;
  PathTemp := PathProject + '\' + DirTemp;
  PathTemplates := PathProject + '\' + DirTemplates;
  WriteLog('MAIN', 'UCommon.SetPathProject IDProject=' + IDProject);
end;

function CalcTextExtent(DCHandle: integer; Text: string): TSize;
var
  CharFSize: TABCFloat;
begin
  try
    result.cx := 0;
    result.cy := 0;
    if Text = '' then
      exit;
    GetTextExtentPoint32(DCHandle, PChar(Text), length(Text), result);
    GetCharABCWidthsFloat(DCHandle, Ord(Text[length(Text)]),
      Ord(Text[length(Text)]), CharFSize);
    if CharFSize.abcfC < 0 then
      result.cx := result.cx + trunc(Abs(CharFSize.abcfC));
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.CalcTextExtent Text=' + Text + ' | ' +
        E.Message);
  end;
end;

function CalcTextWidth(DCHandle: integer; Text: string): integer;
begin
  try
    result := CalcTextExtent(DCHandle, Text).cx;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.CalcTextWidth Text=' + Text + ' | ' +
        E.Message);
  end;
end;

procedure TemplateToScreen(crpos: TEventReplay);
begin
  try
    // WriteLog('MAIN', 'UCommon.TemplateToScreen CurrentEvents : Number=' + inttostr(crpos.Number) + ' Image=' +crpos.Image);
    if crpos.Number <> -1 then
    begin
      // MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'TemplateToScreen');
      if form1.pnImageScreen.Visible then
      begin
        if trim(CurrentImageTemplate) <> trim(crpos.Image) then
        begin
          if trim(crpos.Image) = '' then
          begin
            // Form1.Image3.Picture.Bitmap.FreeImage;
            // Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
            // Form1.Image3.Canvas.Brush.Style := bsSolid;
            // Form1.Image3.Width:=Form1.pnImageScreen.Width;
            // Form1.Image3.Height:=Form1.pnImageScreen.Height;
            // Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
            // Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
            // Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
            // Form1.Image3.repaint;
            LoadImage(PathTemplates + '\', form1.Image3);
            WriteLog('MAIN', 'UCommon.TemplateToScreen-1 Clear');
            // application.ProcessMessages;
          end
          else
          begin
            if fileexists(PathTemplates + '\' + trim(crpos.Image)) then
            begin
              // if Form1.Image3.Picture.Graphic is TJPEGImage then begin
              // TJPEGImage(Form1.Image3.Picture.Graphic).DIBNeeded;
              // end;
              if LoadImageInProgress then
                exit;
              try
                LoadImageInProgress := true;
                LoadImage(PathTemplates + '\' + trim(crpos.Image),
                  form1.Image3);
                // Form1.Image3.Picture.LoadFromFile(PathTemplates + '\' + trim(crpos.Image));
                CurrentImageTemplate := crpos.Image;
              finally
              end;
              LoadImageInProgress := false;
              WriteLog('MAIN', 'UCommon.TemplateToScreen-3 : Number=' +
                inttostr(crpos.Number) + ' Image=' + crpos.Image);
              exit;
            end;
          end;
          CurrentImageTemplate := crpos.Image;
        end;
      end;
    end
    else
    begin
      if form1.pnImageScreen.Visible then
      begin
        // Form1.Image3.Picture.Bitmap.FreeImage;
        // Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
        // Form1.Image3.Canvas.Brush.Style := bsSolid;
        // Form1.Image3.Width:=Form1.pnImageScreen.Width;
        // Form1.Image3.Height:=Form1.pnImageScreen.Height;
        // Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
        // Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
        // Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
        // Form1.Image3.repaint;
        WriteLog('MAIN', 'UCommon.TemplateToScreen-2 Clear');
        CurrentImageTemplate := '#@@#';
        // application.ProcessMessages;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.TemplateToScreen CurrentEvents : Number=' +
        inttostr(crpos.Number) + ' Image=' + crpos.Image + ' | ' + E.Message);
  end;
end;

procedure MyTextRect(var cv: tcanvas; const rect: trect; Text: string);
var
  LR: TLogFont;
  FHOld, FHNew: HFONT;
  wdth, fntsz, sz, sz1, szc, sz2, szm: integer;
  size: TSize;
  pr: integer;
  s, s1, s2: string;
  bmp: TBitmap;
begin
  if length(Text) <= 0 then
    exit;
  bmp := TBitmap.Create;
  try
    try
      bmp.width := rect.Right - rect.Left;
      bmp.height := rect.Bottom - rect.Top;
      bmp.Canvas.Brush.Style := bsSolid;
      bmp.Canvas.CopyRect(bmp.Canvas.ClipRect, cv, rect);
      bmp.Canvas.Font.Assign(cv.Font);
      wdth := rect.Right - rect.Left;
      GetObject(bmp.Canvas.Font.handle, SizeOf(LR), Addr(LR));
      LR.lfHeight := rect.Bottom - rect.Top;

      szm := (wdth - length(Text)) div length(Text);
      LR.lfWidth := szm;
      FHNew := CreateFontIndirect(LR);
      FHOld := SelectObject(bmp.Canvas.handle, FHNew);
      szc := bmp.Canvas.TextWidth(Text);
      FHNew := SelectObject(bmp.Canvas.handle, FHOld);
      DeleteObject(FHNew);

      if szc <= wdth then
      begin
        for sz := szm to 50 do
        begin
          LR.lfWidth := sz;
          FHNew := CreateFontIndirect(LR);
          FHOld := SelectObject(bmp.Canvas.handle, FHNew);
          szc := bmp.Canvas.TextWidth(Text);
          FHNew := SelectObject(bmp.Canvas.handle, FHOld);
          DeleteObject(FHNew);
          if szc > wdth then
          begin
            LR.lfWidth := sz - 1;
            FHNew := CreateFontIndirect(LR);
            FHOld := SelectObject(bmp.Canvas.handle, FHNew);
            szc := bmp.Canvas.TextWidth(Text);
            break;
          end;
        end;
      end
      else
      begin
        for sz := szm downto 1 do
        begin
          LR.lfWidth := sz;
          FHNew := CreateFontIndirect(LR);
          FHOld := SelectObject(bmp.Canvas.handle, FHNew);
          szc := bmp.Canvas.TextWidth(Text);
          if szc <= wdth then
            break
          else
          begin
            FHNew := SelectObject(bmp.Canvas.handle, FHOld);
            DeleteObject(FHNew);
          end;
        end;
      end;

      sz2 := wdth - szc;
      s1 := copy(Text, 1, length(Text) - sz2);
      s2 := copy(Text, length(Text) - sz2 + 1, sz2);
      bmp.Canvas.Brush.Style := bsClear;
      bmp.Canvas.TextOut(0, 0, s1);
      szc := bmp.Canvas.TextWidth(s1);
      SetTextCharacterExtra(bmp.Canvas.handle, 1);
      bmp.Canvas.TextOut(szc, 0, s2);
      bitblt(cv.handle, rect.Left, rect.Top, rect.Right - rect.Left,
        rect.Bottom - rect.Top, bmp.Canvas.handle, 0, 0, SRCCOPY);
      SetTextCharacterExtra(bmp.Canvas.handle, 0);
      FHNew := SelectObject(bmp.Canvas.handle, FHOld);
      DeleteObject(FHNew);
    finally
      bmp.Free;
      bmp := nil;
    end;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyTextRect : Text=' + Text + ' | ' + E.Message);
      FHNew := SelectObject(bmp.Canvas.handle, FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp := nil;
    end
    else
    begin
      FHNew := SelectObject(bmp.Canvas.handle, FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp := nil;
    end;
  end;
end;

procedure InsertEventToEditTimeline(nom: integer);
var
  ps: integer;
begin
//ssscheck
  LoadProject_active := true;
  try
    WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline Number=' +
      inttostr(nom));
    frLock.Hide;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then
            begin
                LoadProject(false);
                exit;
            end;
    case TLZone.TLEditor.TypeTL of
      tldevice:
        begin
          if nom > (form1.GridTimeLines.Objects[0, ps + 1] as TTimeLineOptions)
            .CountDev - 1 then
            begin
                LoadProject(false);
                exit;
            end;
          if ps <> -1 then
          begin
            TLZone.TLEditor.AddEvent(TLParameters.Position, ps + 1, nom);
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            // if mode=play then exit;
            // TLZone.DrawBitmap(bmptimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            WriteLog('MAIN',
              'UCommon.InsertEventToEditTimeline TypeTL=tlDevice Number=' +
              inttostr(nom));
            // ssssjson
                LoadProject(false);

            if TLParameters.vlcmode = play then
            begin
                LoadProject(false);
                exit;
            end;
            // TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
          end;
        end;
      tltext:
        begin
          if ps <> -1 then
          begin
            if TLParameters.Position < TLParameters.Preroll then
            begin
              LoadProject(false);
                  exit;
            end;
            if TLParameters.Position >= TLParameters.EndPoint then
            begin
                LoadProject(false);
                exit;
            end;
            TLZone.TLEditor.AddEvent(TLParameters.Position, ps + 1, nom);
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            // if mode=play then exit;
            // TLZone.DrawBitmap(bmptimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            WriteLog('MAIN',
              'UCommon.InsertEventToEditTimeline TypeTL=tlText Number=' +
              inttostr(nom));
            // ssssjson
                LoadProject(false);

            if TLParameters.vlcmode = play then
            begin
                LoadProject(false);
                exit;
            end;
          end;

        end;
      tlmedia:
        begin
          if ps <> -1 then
          begin
            if TLParameters.Position <= TLParameters.Preroll then
            begin
              LoadProject(false);
                  exit;
            end;
            if TLParameters.Position >= TLParameters.EndPoint then
            begin
                LoadProject(false);
                exit;
            end;
            TLZone.TLEditor.AddEvent(TLParameters.Position, ps + 1, nom);
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            // if mode=play then exit;
            // TLZone.DrawBitmap(bmptimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            WriteLog('MAIN',
              'UCommon.InsertEventToEditTimeline TypeTL=tlMedia Number=' +
              inttostr(nom));
            // ssssjson
              LoadProject(false);

            if TLParameters.vlcmode = play then
            begin
                LoadProject(false);
                exit;
            end;
          end;
        end;
    end;
    TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
  except
    on E: Exception do
       begin
             WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline Number=' +
                     inttostr(nom) + ' | ' + E.Message);
            LoadProject(false);
       end;
    end;
    LoadProject(false);

end;

Procedure PlayClipFromActPlaylist;
begin
  try
    form1.sbPlayList.Font.Style := form1.sbPlayList.Font.Style + [fsUnderline];
    // MyTimer.Waiting:=true;
    GridPlayer := grPlaylist;
    GridPlayerRow := form1.GridActPlayList.Row;
    PredClipID := (form1.GridActPlayList.Objects[0, form1.GridActPlayList.Row]
      as TGridRows).MyCells[3].ReadPhrase('ClipID');
    // form1.lbActiveClipID.Caption := (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    WriteLog('MAIN', 'UCommon.PlayClipFromActPlaylist ClipID=' +
      form1.lbActiveClipID.Caption);
    LoadClipsToPlayer;
    // MyTimer.Waiting:=false;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.PlayClipFromActPlaylist | ' + E.Message);
  end;
end;

Procedure PlayClipFromClipsList;
begin
  try
    form1.sbClips.Font.Style := form1.sbClips.Font.Style + [fsUnderline];
    // MyTimer.Waiting:=true;
    GridPlayer := grClips;
    GridPlayerRow := form1.GridClips.Row;
    PredClipID := (form1.GridClips.Objects[0, form1.GridClips.Row] as TGridRows)
      .MyCells[3].ReadPhrase('ClipID');
    WriteLog('MAIN', 'UCommon.PlayClipFromClipsList PredClipID=' + PredClipID);
    LoadClipsToPlayer;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.PlayClipFromClipsList | ' + E.Message);
  end;
  // MyTimer.Waiting:=false;
end;

procedure ControlPlayer;
begin
  // pMediaPosition.get_Rate(Rate);
  // mode := play;
  // StartMyTimer;
  try
    WriteLog('MAIN', 'UCommon.ControlPlayer Start');
    if TLParameters.vlcmode = paused then
    begin
      Rate := 1;
      WriteLog('MAIN', 'UCommon.ControlPlayer mode=paused');
      if fileexists(form1.lbPlayerFile.Caption) then
        Rate := 1; // pMediaPosition.put_Rate(Rate);
      pStart := FramesToDouble(TLParameters.Position);
      MediaPlay;
    end
    else
    begin
      WriteLog('MAIN', 'UCommon.ControlPlayer mode<>paused');
      form1.MySynhro.Checked := false;
      if fileexists(form1.lbPlayerFile.Caption) then
        Rate := 1; // pMediaPosition.get_Rate(Rate);
      if Rate <> 1 then
      begin
        Rate := 1;
        if not fileexists(form1.lbPlayerFile.Caption) then
        begin
          pStart := FramesToDouble(TLParameters.Position);
          Application.ProcessMessages;
        end;
        if fileexists(form1.lbPlayerFile.Caption) then
          Rate := 1; // pMediaPosition.put_Rate(Rate);
      end
      else
      begin
        MediaPause;
        Application.ProcessMessages;
        DrawTimeineInProgress := false;
      end;
    end;
    form1.imgLayer0.Canvas.FillRect(form1.imgLayer1.Canvas.ClipRect);
    form1.imgLayer0.Repaint;
    SetMediaButtons;
    WriteLog('MAIN', 'UCommon.ControlPlayer Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.ControlPlayer | ' + E.Message);
  end;
end;

procedure LoadJpegFile(bmp: TBitmap; FileName: string);
var
  JpegIm: TJpegImage;
  wdth, hght, bwdth, bhght: integer;
  dlt: Real;
begin
  try
    WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName);
    JpegIm := TJpegImage.Create;
    try
      JpegIm.LoadFromFile(FileName);
      bmp.Assign(JpegIm);
    finally
      JpegIm.Free;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName + ' | ' +
        E.Message);
  end;
end;

procedure loadoldproject;
var
  ps, pp: integer;
  nm: string;
begin
  try
    WriteLog('MAIN', 'UCommon.loadoldproject Start');
    initnewproject;
    SecondaryGrid := playlists;
    SecondaryGrid := playlists;
    // LoadGridFromFile(PathTemp + '\ImageTemplates.lst', form1.GridGRTemplate);

    Application.ProcessMessages;
    GridImageReload(form1.GridGRTemplate);
    UpdateGridTemplate := true;
    // LoadGridFromFile(PathTemp + '\Clips.lst', form1.GridClips);
    CheckedClipsInList;
    // pp := findgridselection(form1.gridlists, 2);
    // if pp > 0 then begin
    // nm := (form1.gridlists.Objects[0,pp] as tgridrows).MyCells[3].ReadPhrase('Note');
    // PlaylistToPanel(pp);
    // LoadGridFromFile(PathPlayLists+ '\' + nm, form1.GridActPlayList);
    // CheckedClipsInList(form1.GridActPlayList);
    // Form1.lbClipActPL.Caption := (form1.gridlists.Objects[0,pp] as tgridrows).MyCells[3].ReadPhrase('Name');
    // end;
    // end;
    form1.GridLists.Repaint;
    form1.GridTimeLines.Repaint;
    form1.GridClips.Repaint;
    form1.GridActPlayList.Repaint;
    WriteLog('MAIN', 'UCommon.loadoldproject Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.loadoldproject | ' + E.Message);
  end;
end;

procedure initnewproject;
var
  I: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.initnewproject Start');
    with form1 do
    begin
      if trim(Label2.Caption) <> '' then
      begin
        SaveClipEditingToFile(trim(Label2.Caption));
        Label2.Caption := '';
        TLZone.TLEditor.Clear;
        for I := 0 to TLZone.Count - 1 do
          TLZone.Timelines[I].Clear;
        ClearVLCPlayer;
      end;
      pntlproj.SetText('ProjectName', '');
      ProjectNumber := '';
      pntlproj.SetText('CommentText', '');
      pntlproj.SetText('FileName', '');
      pntlproj.SetText('DateStart', '');
      pntlproj.SetText('DateEnd', '');
      // if FileExists(pathlists + '\Timelines.lst')
      // then LoadGridTimelinesFromFile(pathlists + '\Timelines.lst', Form1.GridTimeLines)
      // else
      InitGridTimelines;
      // ZoneNames.Update;
      InitPanelPrepare(true);
      GridClear(GridClips, RowGridClips);
      GridClear(GridActPlayList, RowGridClips);
      // ClearPanelActPlayList;
      ClearClipsPanel;
      GridClear(GridLists, RowGridListPL);

      GridLists.Repaint;
      GridClips.Repaint;
      GridActPlayList.Repaint;
      GridTimeLines.Repaint;
      WriteLog('MAIN', 'UCommon.initnewproject Finish');
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.initnewproject | ' + E.Message);
  end;
end;

procedure UpdateProjectPathes(NewProject: string);
begin
  try
    WriteLog('MAIN', 'UCommon.UpdateProjectPathes NewProject=' + NewProject);
    PathProject := AppPath + DirProjects;
    // PathLists := PathProject + DirLists;
    PathClips := PathProject + DirClips;
    PathTemplates := PathProject + DirTemplates;
    PathPlayLists := PathProject + DirPlayLists;
    PathTemp := PathProject + DirTemp;
    PathLog := PathProject + DirLog;
    PathKeyLayouts := PathProject + DirKeylayouts;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.UpdateProjectPathes NewProject=' + NewProject +
        ' | ' + E.Message);
  end;
end;

procedure CreateDirectories1;
var
  I: integer;
  ext: string;
begin
  try
    WriteLog('MAIN', 'UCommon.CreateDirectories');
    AppPath := extractfilepath(Application.ExeName);
    AppName := extractfilename(Application.ExeName);
    ext := ExtractFileExt(Application.ExeName);
    AppName := copy(AppName, 1, length(AppName) - length(ext));

    PathFiles := AppPath + DirFiles;
    if not DirectoryExists(PathFiles) then
      ForceDirectories(PathFiles);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathFiles=' + PathFiles);
    PathProject := AppPath + DirProjects;
    if not DirectoryExists(PathProject) then
      ForceDirectories(PathProject);
    WriteLog('MAIN', 'UCommon.CreateDirectories DirProject=' + PathProject);
    // PathLists := PathProject + DirLists;
    // if not DirectoryExists(PathLists) then ForceDirectories(PathLists);
    // WriteLog('MAIN', 'UCommon.CreateDirectories PathLists=' + PathLists);
    PathClips := PathProject + DirClips;
    if not DirectoryExists(PathClips) then
      ForceDirectories(PathClips);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathClips=' + PathClips);
    PathTemplates := PathProject + DirTemplates;
    if not DirectoryExists(PathTemplates) then
      ForceDirectories(PathTemplates);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathTemplates=' +
      PathTemplates);
    PathPlayLists := PathProject + DirPlayLists;
    if not DirectoryExists(PathPlayLists) then
      ForceDirectories(PathPlayLists);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathPlayLists=' +
      PathPlayLists);
    PathTemp := PathProject + DirTemp;
    if not DirectoryExists(PathTemp) then
      ForceDirectories(PathTemp);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathTemp=' + PathTemp);
    // 'Keylayouts'
    PathKeyLayouts := PathProject + DirKeylayouts;
    if not DirectoryExists(PathKeyLayouts) then
      ForceDirectories(PathKeyLayouts);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathTemp=' + PathKeyLayouts);

    if MakeLogging then
    begin
      PathLog := AppPath + DirLog;
      if not DirectoryExists(PathLog) then
        ForceDirectories(PathLog);
      WriteLog('MAIN', 'UCommon.CreateDirectories PathLog=' + PathLog);
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.CreateDirectories | ' + E.Message);
  end;
end;

function createunicumname: string;
var
  YY, MN, DD: Word;
  HH, MM, SS, MS: Word;
begin
  try
    DecodeDate(now, YY, MN, DD);
    DecodeTime(now, HH, MM, SS, MS);
    result := inttostr(YY) + inttostr(MN) + inttostr(DD) + inttostr(HH) +
      inttostr(MM) + inttostr(SS) + inttostr(MS);
    WriteLog('MAIN', 'UCommon.createunicumname Result=' + result);
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.createunicumname | ' + E.Message);
  end;
end;

procedure LoadBMPFromRes(cv: tcanvas; rect: trect; width, height: integer;
  Name: string);
var
  bmp: TBitmap;
  wdth, hght, deltx, delty: integer;
  rt: trect;
begin
  try
    if trim(name) = '' then
      exit;
    bmp := TBitmap.Create;
    bmp.LoadFromResourceName(HInstance, name);
    bmp.Transparent := true;
    rt.Left := rect.Left;
    rt.Right := rect.Right;
    rt.Top := rect.Top;
    rt.Bottom := rect.Bottom;
    wdth := rect.Right - rect.Left;
    hght := rect.Bottom - rect.Top;
    if wdth > width then
    begin
      deltx := (wdth - width) div 2;
      rt.Left := rect.Left + deltx;
      rt.Right := rect.Right - deltx;
    end;
    if hght > height then
    begin
      delty := (hght - height) div 2;
      rt.Top := rect.Top + delty;
      rt.Bottom := rect.Bottom - delty;
    end;
    cv.StretchDraw(rt, bmp);
    bmp.Free;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.LoadBMPFromRes Name=' + Name + ' | ' +
        E.Message);
  end;
end;

function TwoDigit(dig: integer): string;
begin
  try
    if (dig >= 0) and (dig <= 9) then
      result := '0' + inttostr(dig)
    else
      result := inttostr(dig);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.TwoDigit | ' + E.Message);
      result := '00';
    end
    else
      result := '00';
  end;
end;

function FramesToDouble(frm: longint): Double;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := frm div 25;
    FF := frm mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := (HH * 3600 + MM * 60 + SS) + (FF * 40 / 1000);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToDouble | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function FramesToTime(frm: longint): tdatetime;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := frm div 25;
    FF := frm mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := encodetime(HH, MM, SS, FF * 40);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToTime | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function TimeToFrames(dt: tdatetime): longint;
var
  HH, MM, SS, MS: Word;
begin
  try
    DecodeTime(dt, HH, MM, SS, MS);
    result := (HH * 3600 + MM * 60 + SS) * 25 + trunc(MS / 40);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.TimeToFrames | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function TimeToTimeCodeStr(dt: tdatetime): string;
var
  HH, MM, SS, MS: Word;
begin
  try
    DecodeTime(dt, HH, MM, SS, MS);
    result := TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' +
      TwoDigit(trunc(MS / 40));
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.TimeToTimeCodeStr | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

function MyTimeToStr: string;
var
  HH, MM, SS, MS: Word;
  dbl: Double;
begin
  try
    // DecodeTime(dt,hh,mm,ss,ms);
    // dbl := RoundTo(dt * 1000,-3);
    dbld2 := MyTimer.ReadTimer;
    result := FloatToStr(RoundTo((dbld2 - dbld1) * 1000, -3)) + 'ms';
    // dbld1:=dbld2;
    // result := FloatToStr(dt);
    // TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + inttostr(ms);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyTimeToStr | ' + E.Message);
      result := '00:00:00:000';
    end
    else
      result := '00:00:00:000';
  end;
end;

function StrTimeCodeToFrames(tc: string): longint;
var
  HH, MM, SS, MS: Word;
  s: string;
begin
  try
    s := trim(tc);
    s := StringReplace(s, 'Старт в (', '', [rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s, ')', '', [rfReplaceAll, rfIgnoreCase]);
    HH := strtoint(s[1] + s[2]);
    MM := strtoint(s[4] + s[5]);
    SS := strtoint(s[7] + s[8]);
    MS := strtoint(s[10] + s[11]);
    result := (HH * 3600 + MM * 60 + SS) * 25 + MS;
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.StrTimeCodeToFrames TC=' + tc + ' | ' +
        E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function FramesToStr(frm: longint): string;
var
  ZN, HH, MM, SS, FF, dlt: longint;
  znak: char;
begin
  try
    ZN := frm;
    znak := #32;
    if frm < 0 then
    begin
      znak := '-';
      ZN := -1 * ZN;
    end;
    dlt := ZN div 25;
    FF := ZN mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := znak + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
      ':' + TwoDigit(FF);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToStr | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

function FramesToShortStr(frm: longint): string;
var
  HH, MM, SS, FF, dlt, fr: longint;
  st: string;
begin
  try
    if frm < 0 then
    begin
      st := '-';
      fr := -1 * frm;
    end
    else
    begin
      st := '';
      fr := frm;
    end;
    dlt := fr div 25;
    FF := fr mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    if HH <> 0 then
    begin
      result := st + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
        ':' + TwoDigit(FF);
      exit;
    end;
    if MM <> 0 then
    begin
      result := st + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' + TwoDigit(FF);
      exit;
    end;
    result := st + TwoDigit(SS) + ':' + TwoDigit(FF);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToShortStr | ' + E.Message);
      result := '00:00';
    end
    else
      result := '00:00';
  end;
end;

function SecondToStr(frm: longint): string;
var
  HH, MM, SS, FF, dlt, fr: longint;
  st: string;
begin
  try
    if frm < 0 then
    begin
      st := '-';
      fr := -1 * frm;
    end
    else
    begin
      st := '';
      fr := frm;
    end;
    HH := fr div 3600;
    MM := fr mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    if HH <> 0 then
    begin
      result := st + inttostr(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS);
      exit;
    end;
    result := st + inttostr(MM) + ':' + TwoDigit(SS);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.SecondToStr | ' + E.Message);
      result := '00:00';
    end
    else
      result := '00:00';
  end;
end;

function SecondToShortStr(frm: longint): string;
var
  HH, MM, SS, FF, dlt, fr: longint;
  st: string;
begin
  try
    if frm < 0 then
    begin
      st := '-';
      fr := -1 * frm;
    end
    else
    begin
      st := '';
      fr := frm;
    end;
    HH := fr div 3600;
    MM := fr mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    if HH <> 0 then
    begin
      result := st + inttostr(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS);
      exit;
    end;
    if MM <> 0 then
    begin
      result := st + inttostr(MM) + ':' + TwoDigit(SS);
      exit;
    end;
    result := st + ':' + TwoDigit(SS);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.SecondToShortStr | ' + E.Message);
      result := '00:00';
    end
    else
      result := '00:00';
  end;
end;

function MyDoubleToSTime(db: Double): string;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := trunc(db);
    FF := trunc((db - dlt) * 1000 / 40);
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' +
      TwoDigit(FF);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyDoubleToSTime | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

function MyDoubleToFrame(db: Double): longint;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := trunc(db);
    FF := trunc((db - dlt) * 1000 / 40);
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := (HH * 3600 + MM * 60 + SS) * 25 + FF;
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyDoubleToFrame | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function MyDateTimeToStr(tm: tdatetime): string;
var
  Hour, Min, Sec, MSec: Word;
begin
  try
    DecodeTime(tm, Hour, Min, Sec, MSec);
    result := TwoDigit(Hour) + ':' + TwoDigit(Min) + ':' + TwoDigit(Sec) + ':' +
      TwoDigit(trunc(MSec / 40));
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyDateTimeToStr | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

Function DefineFontSizeW(cv: tcanvas; width: integer; txt: string): integer;
var
  fntsz, sz: integer;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    try
      result := 0;
      if bmp.Canvas.Font.size = 0 then
        bmp.Canvas.Font.size := 40;
      fntsz := cv.Font.size;
      For sz := fntsz downto 5 do
      begin
        bmp.Canvas.Font.size := sz;
        if bmp.Canvas.TextWidth(txt) < width - 4 then
          break;
      end;
      result := sz;
      // cv.Font.Size:=fntsz;
    finally
      bmp.Free;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.DefineFontSizeW | ' + E.Message);
  end;
end;

Function DefineFontSizeH(cv: tcanvas; height: integer): integer;
var
  fntsz, sz: integer;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    try
      result := 0;
      // fntsz:=cv.Font.Size;
      // cv.Font.Size:=40;
      For sz := 40 downto 5 do
      begin
        bmp.Canvas.Font.size := sz;
        if bmp.Canvas.TextHeight('0') < height - 2 then
          break;
      end;
      result := sz;
      // cv.Font.Size:=fntsz;
    finally
      bmp.Free;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.DefineFontSizeH | ' + E.Message);
  end;
end;

function SmoothColor(color: tcolor; step: integer): tcolor;
var
  cColor: longint;
  r, g, b: byte;
  ZN: integer;
  rm, gm, bm: byte;
begin
  try
    cColor := ColorToRGB(color);
    r := cColor;
    g := cColor shr 8;
    b := cColor shr 16;

    if (r >= g) and (r >= b) then
    begin
      if (r + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      result := RGB(r, g, b);
      exit;
    end;

    if (g >= r) and (g >= b) then
    begin
      if (g + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      result := RGB(r, g, b);
      exit;
    end;

    if (b >= r) and (b >= g) then
    begin
      if (b + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      result := RGB(r, g, b);
      exit;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.SmoothColor | ' + E.Message);
  end;
end;

function SetMainGridPanel(TypeGrid: TTypeGrid): boolean;
var
  I, APos, oldcount: integer;
  clpid: string;
begin
  try
    WriteLog('MAIN', 'UCommon.SetMainGridPanel Start');
    result := true;
    // if (vlcmode=play) and (GridPlayer<>grPlayList) and (TypeGrid=actplaylist) then begin
    // result:= false;
    // exit;
    // end;
    if (trim(form1.lbActiveClipID.Caption) = '') and form1.PanelPrepare.Visible
    then
    begin
      for I := 0 to TLZone.Count - 1 do
      begin
        if TLZone.Timelines[I].Count > 0 then
        begin
          if MyTextMessage('Вопрос',
            'Сохранить редактируемые данные в списке клипов?', 2) then
          begin
            FImportFiles.edTotalDur.Text :=
              trim(FramesToStr(DefaultClipDuration));
            FImportFiles.edNTK.Text :=
              trim(FramesToStr(TLParameters.Start - TLParameters.Preroll));
            FImportFiles.EdDur.Text :=
              trim(FramesToStr(TLParameters.Finish - TLParameters.Start));
            FImportFiles.ExternalValue := true;
            oldcount := form1.GridClips.RowCount;
            EditClip(-100);
            WriteLog('MAIN',
              'UCommon.SetMainGridPanel - Сохранение пустого клипа');
            if (oldcount < form1.GridClips.RowCount) or
              (form1.GridClips.RowCount = 2) then
            begin
              clpid := (form1.GridClips.Objects[0, form1.GridClips.RowCount - 1]
                as TGridRows).MyCells[3].ReadPhrase('ClipID');
              SaveClipEditingToFile(trim(clpid));
              form1.GridClips.Row := form1.GridClips.RowCount - 1;
              GridPlayer := grClips;
              GridPlayerRow := form1.GridClips.RowCount - 1;
              LoadClipsToPlayer;
            end;
          end;
          break;
        end;
      end;
    end;
    MainGrid := TypeGrid;
    With form1 do
    begin
      PanelPrepare.Visible := false;
      PanelAir.Visible := false;
      case MainGrid of
        projects:
          begin
            PanelProject.Visible := true;
            PanelClips.Visible := false;
            PanelPlayList.Visible := false;
            sbProject.Font.Style := sbProject.Font.Style +
              [fsBold, fsUnderline];
            sbClips.Font.Style := sbClips.Font.Style - [fsBold, fsUnderline];
            sbPlayList.Font.Style := sbPlayList.Font.Style -
              [fsBold, fsUnderline];
            // SetSecondaryGrid(SecondaryGrid);
            // CheckedClipsInList(GridClips);
            // GridTimeLines.Top:= Bevel8.Top + 15;
            // GridTimeLines.Height:=imgButtonsControlProj.Top - Bevel8.Top - 25;
            // ActiveControl := GridProjects;
            WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=projects');
          end;
        clips:
          begin
            if trim(ProjectNumber) = '' then
            begin
              MyTextMessage('Предупреждение',
                'Для начала работы необходимо выбрать/создать проект.', 1);
              exit;
            end;
            GridPlayer := grClips;
            PanelProject.Visible := false;
            PanelClips.Visible := true;
            PanelPlayList.Visible := false;
            lbusesclpidlst.Caption := 'Список клипов';
            sbProject.Font.Style := sbProject.Font.Style -
              [fsBold, fsUnderline];
            sbClips.Font.Style := sbClips.Font.Style + [fsBold, fsUnderline];
            sbPlayList.Font.Style := sbPlayList.Font.Style -
              [fsBold, fsUnderline];
            ActiveControl := GridClips;
            if trim(form1.lbActiveClipID.Caption) <> '' then
            begin
              GridPlayer := grClips;
              APos := SetInGridClipPosition(GridClips,
                form1.lbActiveClipID.Caption);
              GridPlayerRow := APos;
              if APos <> -1 then
                GridClipsToPanel(GridClips.Row);
            end
            else
            begin
              GridPlayerRow := -1;
              // if GridClips.Row > 0 then begin
              // if trim(PredClipID) <> '' then begin
              // GridPlayer:=grClips;
              // SetInGridClipPosition(GridClips, PredClipID);
              // if APos <> -1 then begin
              // GridClipsToPanel(GridClips.Row);
              // Form1.lbActiveClipID.Caption := PredClipID;
              // PlayClipFromClipsList;
              // end;
              // end;
              // if GridClips.Objects[0,GridClips.Row] is TGridRows then begin
              // GridClipsToPanel(GridClips.Row);
              // end;
              // end;
            end;
            CheckedClipsInList;
            WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=clips');
          end;
        actplaylist:
          begin
            if trim(ProjectNumber) = '' then
            begin
              MyTextMessage('Предупреждение',
                'Для начала работы необходимо выбрать/создать проект.', 1);
              exit;
            end;
            GridPlayer := grPlaylist;
            PanelProject.Visible := false;
            PanelClips.Visible := false;
            PanelPlayList.Visible := true;
            sbProject.Font.Style := sbProject.Font.Style -
              [fsBold, fsUnderline];
            sbClips.Font.Style := sbClips.Font.Style - [fsBold, fsUnderline];
            sbPlayList.Font.Style := sbPlayList.Font.Style +
              [fsBold, fsUnderline];
            if listbox1.ItemIndex = -1 then
              lbusesclpidlst.Caption := 'Плей-лист: '
            else
              lbusesclpidlst.Caption := 'Плей-лист: ' +
                trim(listbox1.Items.Strings[listbox1.ItemIndex]);
            if trim(form1.lbActiveClipID.Caption) <> '' then
            begin
              GridPlayer := grPlaylist;
              GridPlayerRow := SetInGridClipPosition(GridActPlayList,
                form1.lbActiveClipID.Caption);
            end
            else
              GridPlayerRow := -1;
            ActiveControl := GridActPlayList;
            WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=actplaylist');
          end;
      end;
      CheckedClipsInList;
      CheckedActivePlayList;
      WriteLog('MAIN', 'UCommon.SetMainGridPanel Finish');
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.SetMainGridPanel | ' + E.Message);
  end;
end;

procedure ButtonControlLists(command: integer);
var
  s: string;
  I, res, ps, cnt: integer;
  nm: string;
  id: longint;
  cntmrk, cntdel, hghtgr: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonControlLists Command=' + inttostr(command));

    with form1 do
    begin
      case command of
        0:
          begin
            EditTimeline(-1);
          end;
        1:
          begin
            if PanelPrepare.Visible then
            begin
              for I := 1 to GridTimeLines.RowCount - 1 do
              begin
                if (GridTimeLines.Objects[0, I] as TTimeLineOptions)
                  .IDTimeline = ZoneNames.Edit.IDTimeline then
                begin
                  GridTimeLines.Row := I;
                  break;
                end;
              end;
            end;
            id := (GridTimeLines.Objects[0, GridTimeLines.Selection.Top]
              as TTimeLineOptions).IDTimeline;
            DeleteTimeline(GridTimeLines.Selection.Top);
            if id = ZoneNames.Edit.IDTimeline then
            begin
              ZoneNames.Edit.IDTimeline :=
                (form1.GridTimeLines.Objects[0, 1] as TTimeLineOptions)
                .IDTimeline;
              ps := TLZone.FindTimeline(ZoneNames.Edit.IDTimeline);
              if ps <> -1 then
                TLZone.TLEditor.Assign(TLZone.Timelines[ps], ps);
              TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
              ZoneNames.Draw(form1.imgTLNames.Canvas,
                form1.GridTimeLines, true);
              MyPanelAir.AirDevices.Init(form1.ImgDevices.Canvas, 1);
              MyPanelAir.SetValues;
            end;
          end;
        2:
          begin
            if (GridTimeLines.Selection.Top < 1) or
              (GridTimeLines.Selection.Top >= GridTimeLines.RowCount) then
              exit;
            PutGridTimeLinesToServer(Form1.GridTimeLines); //ssssssjson
            EditTimeline(GridTimeLines.Selection.Top);
          end;
      end; // case
      hghtgr := 0;
      for I := 0 to GridTimeLines.RowCount - 1 do
        hghtgr := hghtgr + GridTimeLines.RowHeights[I];
      GridTimeLines.height := hghtgr;
      GridTimeLines.Repaint;
      if PanelPrepare.Visible then
        UpdatePanelPrepare;
      PutGridTimeLinesToServer(Form1.GridTimeLines);       //ssssssjson
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonControlLists Command=' + inttostr(command)
        + ' | ' + E.Message);
  end;
end;

procedure ButtonPlaylLists(command: integer);
var
  s: string;
  I, res, ps, cnt: integer;
  nm: string;
  id: longint;
  cntmrk, cntdel: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonPlaylLists Command=' + inttostr(command));
    with form1 do
    begin
      case command of
        0:
          begin
            // ps := findgridselection(form1.gridprojects, 2);
            // if ps=-1 then exit;
            EditPlaylist(-1);
            // SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
            GridLists.Repaint;
            CheckedActivePlayList;

          end;
        1:
          begin
            ps := findgridselection(GridLists, 2);
            cntmrk := CountGridMarkedRows(GridLists, 1, 1);
            if cntmrk <> 0 then
            begin
              if Not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить все выделенные плей-листы?', 2)
              then
                exit;
              if ps > 0 then
              begin
                if (GridLists.Objects[0, ps] as TGridRows).MyCells[1].Mark and
                  (not(GridLists.Objects[0, ps] as TGridRows).MyCells[0].Mark)
                then
                begin
                  if MyTextMessage('Вопрос',
                    'Вы действительно хотите удалить активный плей-лист?', 2)
                  then
                  begin
                    (GridLists.Objects[0, ps] as TGridRows).MyCells[2]
                      .Mark := false;
                    // lbPlaylist.Caption:='';
                    pntlapls.SetText('CommentText', '');
                    // lbPLComment.Caption:='';
                    pntlapls.Draw(imgpldata.Canvas);
                    imgpldata.Repaint;
                    // lbPLCreate.Caption:='';
                    // lbPLEnd.Caption:='';
                    GridClear(GridActPlayList, RowGridClips);
                  end;
                end;
              end;
              cntdel := 0;
              for I := GridLists.RowCount - 1 downto 1 do
              begin
                if (GridLists.Objects[0, I] as TGridRows).MyCells[1].Mark and
                  (Not(GridLists.Objects[0, I] as TGridRows).MyCells[0].Mark)
                then
                begin
                  nm := (GridLists.Objects[0, I] as TGridRows).MyCells[3]
                    .ReadPhrase('Note');
                  cntdel := cntdel + 1;
                  nm := PathPlayLists + '\PL' + trim(nm) + '.plst';
                  if fileexists(nm) then
                    DeleteFile(nm);
                  MyGridDeleteRow(GridLists, I, RowGridListPL);
                  // SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                end;
              end;
              MyTextMessage('Сообщение', 'Выделено плей-листов ' +
                inttostr(cntmrk) + ', удалено ' + inttostr(cntdel) + '.', 1);
              // SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
            end
            else
            begin
              // ps := findgridselection(gridlists, 2);
              if ps = GridLists.Row then
              begin
                if (GridLists.Objects[0, GridLists.Row] as TGridRows)
                  .MyCells[0].Mark then
                begin
                  MyTextMessage('Сообщение',
                    'Плей-лист защищен от удаления', 1);
                  exit;
                end;
                if MyTextMessage('Вопрос',
                  'Вы действительно хотите удалить активный плей-лист?', 2) then
                begin
                  nm := (GridLists.Objects[0, GridLists.Row] as TGridRows)
                    .MyCells[3].ReadPhrase('Note');
                  nm := PathPlayLists + '\PL' + trim(nm) + '.plst';
                  if fileexists(nm) then
                    DeleteFile(nm);
                  MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                  // SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                  // lbPlaylist.Caption:='';
                  // lbPLComment.Caption:='';
                  pntlapls.SetText('CommentText', '');
                  pntlapls.Draw(imgpldata.Canvas);
                  imgpldata.Repaint;
                  // lbPLCreate.Caption:='';
                  // lbPLEnd.Caption:='';
                  GridClear(GridActPlayList, RowGridClips);
                end;
              end
              else
              begin
                if MyTextMessage('Вопрос',
                  'Вы действительно хотите удалить плей-лист?', 2) then
                begin
                  nm := (GridLists.Objects[0, GridLists.Row] as TGridRows)
                    .MyCells[3].ReadPhrase('Note');
                  nm := PathPlayLists + '\PL' + trim(nm) + '.plst';
                  if fileexists(nm) then
                    DeleteFile(nm);
                  MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                  // SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                end;
              end;
              if (GridLists.RowCount = 2) and (GridLists.Row = 1) and
                ((GridLists.Objects[0, GridLists.Row] as TGridRows).id <= 0)
              then
              begin
                GridClear(GridActPlayList, RowGridClips);
              end;
            end; // if1
            GridLists.Repaint;
          end;
        2:
          begin
            case SecondaryGrid of
              playlists:
                begin
                  // SortMyListClear;
                  // SortMyList[0].Name:='Плей-листы';
                  // SortMyList[0].Field:='Name';
                  // SortMyList[0].TypeData:=tstext;
                  mysortlist.Clear;
                  mysortlist.Add('Плей-листы', 'Name', tstext, 0);
                  GridSort(GridLists, 1, 3);
                end;

            end;
            GridLists.Repaint;

          end;
      end; // case
      // DrawPanelButtons(imgButtonsControlProj.Canvas, IMGPanelProjectControl,-1);
      // GridTimelines.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonPlaylLists Command=' + inttostr(command) +
        ' | ' + E.Message);
  end;
end;

procedure ButtonsControlProjects(command: integer);
var
  I, ps, setpos: integer;
  cntmrk, cntdel: integer;
  s, fp, msg, cmnt, edt: string;
  SDir, TDir: string;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlProjects Command=' +
      inttostr(command));
    with form1 do
    begin
      case command of
        2:
          CreateProject(-1);
        3:
          OpenProject;
        4:
          SaveProject;
        5:
          SaveProjectAs;
        0:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            MyTextTemplateOptions;
          end;
        1:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            EditImageTamplate;
          end;
        6:
          CreateProject(1);
        7:
          form1.Close;
      end;
      // GridProjects.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlProjects Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlMedia(command: integer);
var
  I, oldcount, ps, res: integer;
  crpos: TEventReplay;
  clpid: string;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlMedia Command=' +
      inttostr(command));
    With form1 do
    begin
      // if trim(Label2.Caption)='' then exit;
      ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
      if TLZone.Timelines[ps].Block then
      begin
        frLock.ShowModal;
        exit;
      end;
      SaveToUNDO;

      case command of
        0:
          if (trim(form1.lbActiveClipID.Caption) = '') and form1.PanelPrepare.Visible
          then
          begin
            for I := 0 to TLZone.Count - 1 do
            begin
              if TLZone.Timelines[I].Count > 0 then
              begin
                if MyTextMessage('Вопрос',
                  'Сохранить редактируемые данные в списке клипов?', 2) then
                begin
                  FImportFiles.edTotalDur.Text :=
                    trim(FramesToStr(DefaultClipDuration));
                  FImportFiles.edNTK.Text :=
                    trim(FramesToStr(TLParameters.Start -
                    TLParameters.Preroll));
                  FImportFiles.EdDur.Text :=
                    trim(FramesToStr(TLParameters.Finish - TLParameters.Start));
                  FImportFiles.ExternalValue := true;
                  oldcount := form1.GridClips.RowCount;
                  EditClip(-100);
                  if oldcount < form1.GridClips.RowCount then
                  begin
                    clpid := (form1.GridClips.Objects[0,
                      form1.GridClips.RowCount - 1] as TGridRows).MyCells[3]
                      .ReadPhrase('ClipID');
                    SaveClipEditingToFile(trim(clpid));
                    form1.GridClips.Row := form1.GridClips.RowCount - 1;
                    GridPlayer := grClips;
                    GridPlayerRow := form1.GridClips.RowCount - 1;
                    CheckedActivePlayList;
                    LoadClipsToPlayer;
                  end;
                end;
                break;
              end;
            end;
          end
          else
          begin
            ps := FindClipInGrid(form1.GridClips, form1.lbActiveClipID.Caption);
            ReloadClipInList(form1.GridClips, ps);
            CheckedActivePlayList;
            LoadClipsToPlayer;
          end;
        1:
          begin
            TLParameters.ZeroPoint := TLParameters.Position;
            TLParameters.Start := TLParameters.ZeroPoint;
            TLZone.TLScaler.DrawScaler(bmpTimeline.Canvas);
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
          end;
        2:
          TLParameters.Start := TLParameters.Position;
        3:
          TLParameters.Finish := TLParameters.Position;
        4:
          InsertEventToEditTimeline(-1);
        5:
          begin
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
            begin
              TLZone.TLEditor.DeleteEvent(crpos.Number);
              ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
              // TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame)
              TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
              TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            end;
          end;
      end;
      TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
      TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlMedia Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlPlayList(command: integer);
var
  I, j, res: integer;
  ps, cntmrk, cntdel: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlPlayList Command=' +
      inttostr(command));
    with form1 do
    begin
      case command of
        0:
          begin
            EditPlaylist(-1);
            GridLists.Repaint;
            listbox1.Clear;
            for I := 1 to GridLists.RowCount - 1 do
            begin
              listbox1.Items.Add((GridLists.Objects[0, I] as TGridRows)
                .MyCells[3].ReadPhrase('Name'));
              j := listbox1.Items.Count - 1;
              if not(listbox1.Items.Objects[j] is TMyListBoxObject) then
                listbox1.Items.Objects[j] := TMyListBoxObject.Create;
              (listbox1.Items.Objects[j] as TMyListBoxObject).ClipID :=
                (GridLists.Objects[0, I] as TGridRows).MyCells[3]
                .ReadPhrase('Note');
            end;
            ps := findgridselection(GridLists, 2);
            if ps <> -1 then
              listbox1.ItemIndex := ps - 1;
            ListBox1Click(nil);
          end;
        1:
          begin
            if listbox1.ItemIndex = -1 then
              exit;
            EditPlaylist(listbox1.ItemIndex + 1);
            GridLists.Repaint;
            ps := listbox1.ItemIndex;
            listbox1.Items.Strings[listbox1.ItemIndex] :=
              (GridLists.Objects[0, listbox1.ItemIndex + 1] as TGridRows)
              .MyCells[3].ReadPhrase('Name');
            listbox1.ItemIndex := ps;
            ListBox1Click(nil);
          end;
        5:
          begin
            // +++++++++++++++++++++++++
            cntmrk := CountGridMarkedRows(GridActPlayList, 1, 1);
            if cntmrk <> 0 then
            begin
              if Not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить все выделенные клипы?', 2) then
                exit;
              cntdel := 0;
              For I := GridActPlayList.RowCount - 1 downto 1 do
              begin
                if (GridActPlayList.Objects[0, I] as TGridRows).MyCells[1]
                  .Mark and (not(GridActPlayList.Objects[0, I] as TGridRows)
                  .MyCells[0].Mark) then
                begin
                  cntdel := cntdel + 1;
                  EraseClipInWinPrepare
                    ((GridActPlayList.Objects[0, I] as TGridRows).MyCells[3]
                    .ReadPhrase('ClipID'));
                  MyGridDeleteRow(GridActPlayList, I, RowGridClips);
                end;
              end;
              GridActPlayList.Repaint;
              MyTextMessage('Сообщение', 'Выделено клипов ' + inttostr(cntmrk) +
                ', удалено ' + inttostr(cntdel) + '.', 1);
            end
            else
            begin
              if (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
                .MyCells[0].Mark then
              begin
                MyTextMessage('Сообщение', 'Клип защищен от удаления.', 1);
                exit;
              end;
              if MyTextMessage('Вопрос',
                'Вы действительно хотите удалить выбранный клип?', 2) then
              begin
                EraseClipInWinPrepare
                  ((GridActPlayList.Objects[0, GridActPlayList.Row]
                  as TGridRows).MyCells[3].ReadPhrase('ClipID'));
                MyGridDeleteRow(GridActPlayList, GridActPlayList.Row,
                  RowGridClips);
              end;
            end;
            // +++++++++++++++++++++++++
            // SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
            if listbox1.ItemIndex <> -1 then
            begin
              CheckedActivePlayList;
            end;
          end;
        2:
          begin
            if MySynhro.Checked then
            begin
              if MyTextMessage('Предупреждение',
                'Установлен режим синхронизации по времени.' + #13#10 +
                'В случае продолжения режим синхронизации будет отменен.' +
                #13#10 + #13#10 + 'Продолжить?', 2) then
              begin
                MySynhro.Checked := false;
                if (GridClips.Objects[0, GridClips.Row] is TGridRows) then
                  PlayClipFromActPlaylist;
              end;
            end
            else if (GridClips.Objects[0, GridClips.Row] is TGridRows) then
              PlayClipFromActPlaylist;
            // PlayClipFromActPlaylist;
          end;
        3:
          begin
            mysortlist.Clear;
            mysortlist.Add('Название клипов', 'Clip', tstext, 0);
            mysortlist.Add('Название песен', 'Song', tstext, 0);
            mysortlist.Add('Исполнители', 'Singer', tstext, 0);
            mysortlist.Add('Время старта', 'StartTime', tsdate, 1);
            mysortlist.Add('Хр-ж медиа', 'Duration', tstime, 0);
            mysortlist.Add('Хр-ж воспр.', 'Dur', tstime, 0);
            mysortlist.Draw(frSortGrid.Image3.Canvas);
            GridSort(GridActPlayList, 1, 3);
          end;
        4:
          begin
            ProbingStartTime(GridActPlayList);
          end;
      end; // case
      GridActPlayList.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlPlayList Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlClipsPanel(command: integer);
var
  I, res: integer;
  nm, txt: string;
  ps, cntmrk, cntdel: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlClipsPanel Command=' +
      inttostr(command));
    with form1 do
    begin
      pnlbtnsclips.Enable := false;
      case command of
        0:
          begin
            EditClip(-1);
            CheckedActivePlayList;
          end;
        1:
          begin
            EditClip(-100);
            CheckedActivePlayList;
          end;
        5:
          begin
            // +++++++++++++++++++++++++
            cntmrk := CountGridMarkedRows(GridClips, 1, 1);
            if cntmrk <> 0 then
            begin
              if Not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить все выделенные клипы?', 2) then
                exit;
              cntdel := 0;
              For I := GridClips.RowCount - 1 downto 1 do
              begin
                if (GridClips.Objects[0, I] as TGridRows).MyCells[1].Mark and
                  (not(GridClips.Objects[0, I] as TGridRows).MyCells[0].Mark)
                then
                begin
                  cntdel := cntdel + 1;
                  nm := PathClips + '\' + nm + '.clip';
                  if fileexists(nm) then
                    DeleteFile(nm);
                  EraseClipInWinPrepare((GridClips.Objects[0, I] as TGridRows)
                    .MyCells[3].ReadPhrase('ClipID'));
                  MyGridDeleteRow(GridClips, I, RowGridClips);
                end;
              end;
              if (GridClips.RowCount = 2) and (GridClips.Row = 1) and
                ((GridClips.Objects[0, GridClips.Row] as TGridRows).id <= 0)
              then
                ClearClipsPanel;
              GridClips.Repaint;
              MyTextMessage('Сообщение', 'Выделено клипов ' + inttostr(cntmrk) +
                ', удалено ' + inttostr(cntdel) + '.', 1);
            end
            else
            begin
              if (GridClips.Objects[0, GridClips.Row] as TGridRows).MyCells[0].Mark
              then
              begin
                MyTextMessage('Сообщение', 'Клип защищен от удаления.', 1);
                exit;
              end;
              if MyTextMessage('Вопрос',
                'Вы действительно хотите удалить выбранный клип?', 2) then
              begin
                nm := PathClips + '\' + nm + '.clip';
                if fileexists(nm) then
                  DeleteFile(nm);
                EraseClipInWinPrepare
                  ((GridClips.Objects[0, GridClips.Row] as TGridRows)
                  .MyCells[3].ReadPhrase('ClipID'));
                MyGridDeleteRow(GridClips, GridClips.Row, RowGridClips);
                if (GridClips.RowCount = 2) and (GridClips.Row = 1) and
                  ((GridClips.Objects[0, GridClips.Row] as TGridRows).id <= 0)
                then
                  ClearClipsPanel;
              end;
            end;
            // +++++++++++++++++++++++++
            // SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
            if listbox1.ItemIndex <> -1 then
            begin
              CheckedActivePlayList;
              // SaveGridToFile(PathPlayLists + '\' + trim(lbPLName.Caption),GridActPlayList);
            end;
          end;
        2:
          begin
            if MySynhro.Checked then
            begin
              if MyTextMessage('Предупреждение',
                'Установлен режим синхронизации по времени.' + #13#10 +
                'В случае продолжения режим синхронизации будет отменен.' +
                #13#10 + #13#10 + 'Продолжить?', 2) then
              begin
                MySynhro.Checked := false;
                if (GridClips.Objects[0, GridClips.Row] is TGridRows) then
                  PlayClipFromClipsList;
              end;
            end
            else if (GridClips.Objects[0, GridClips.Row] is TGridRows) then
              PlayClipFromClipsList; // PlayClipFromClipsList;
          end;
        3:
          begin
            mysortlist.Clear;
            mysortlist.Add('Название клипов', 'Clip', tstext, 0);
            mysortlist.Add('Название песен', 'Song', tstext, 0);
            mysortlist.Add('Исполнители', 'Singer', tstext, 0);
            mysortlist.Add('Время старта', 'StartTime', tsdate, 1);
            mysortlist.Add('Хр-ж медиа', 'Duration', tstime, 0);
            mysortlist.Add('Хр-ж воспр.', 'Dur', tstime, 0);
            mysortlist.Draw(frSortGrid.Image3.Canvas);
            GridSort(GridClips, 1, 3);
          end;
        4:
          begin
            // ps:=FindNextClipTime(Form1.GridClips);
            // ps := findgridselection(gridlist, 2);
            if listbox1.ItemIndex = -1 then
            begin
              MyTextMessage('Сообщение', 'Не выбран активный плей-лист.', 1);
              exit;
            end;
            LoadClipsToPlayList;
            SetMainGridPanel(actplaylist);
            if listbox1.ItemIndex <> -1 then
            begin
              txt := (listbox1.Items.Objects[listbox1.ItemIndex]
                as TMyListBoxObject).ClipID;
              // SaveGridToFile(PathPlayLists + '\' + txt, GridActPlayList);
            end;
          end;
      end; // case
      pnlbtnsclips.Enable := true;
      GridClips.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlClipsPanel Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure SwitcherVideoPanels(command: integer);
var
  crpos: TEventReplay;
begin
  try
    WriteLog('MAIN', 'UCommon.SwitcherVideoPanels Command=' +
      inttostr(command));
    with form1 do
    begin
      case command of
        0:
          begin
            pnImageScreen.Visible := false;
            MyMediaSwitcher.Select := 0;
          end;
        1:
          begin
            pnImageScreen.Left := pnMovie.Left;
            pnImageScreen.Top := pnMovie.Top;
            pnImageScreen.width := pnMovie.width;
            pnImageScreen.height := pnMovie.height;
            pnImageScreen.Visible := true;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'SwitcherVideoPanels-1')
            else
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', '',
                'SwitcherVideoPanels-2');
            CurrentImageTemplate := 'SS@@##';
            TemplateToScreen(crpos);
            MyMediaSwitcher.Select := 1;
          end;
      end;
      MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
      imgTypeMovie.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.SwitcherVideoPanels Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ControlButtonsPrepare(command: integer);
var
  I, j, res, ps: integer;
  crpos: TEventReplay;
  tmpos: longint;
  bl: boolean;
  olddir, oldfilter, sext: string;
begin
  try
    WriteLog('MAIN', 'UCommon.ControlButtonsPrepare Command=' +
      inttostr(command));
    with form1 do
    begin
      case command of
        0:
          begin
            tmpos := TLParameters.Position;
            crpos := TLZone.TLEditor.CurrentEvents;
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            case TLZone.TLEditor.TypeTL of
              tldevice:
                begin
                  if crpos.Number = -1 then
                    exit;
                  if crpos.Number = 0 then
                  begin
                    TLZone.TLEditor.Events[crpos.Number].Start := tmpos;
                    TLZone.Timelines[ps].Events[crpos.Number].Start := tmpos;
                  end
                  else
                  begin
                    TLZone.TLEditor.Events[crpos.Number].Start := tmpos;
                    TLZone.Timelines[ps].Events[crpos.Number].Start := tmpos;
                    TLZone.TLEditor.Events[crpos.Number - 1].Finish := tmpos;
                    TLZone.Timelines[ps].Events[crpos.Number - 1]
                      .Finish := tmpos;
                  end;
                end;
              tltext:
                begin
                  if crpos.Number <> -1 then
                  begin
                    if (TLZone.TLEditor.Events[crpos.Number].Start = tmpos) and
                      (crpos.Number > 0) then
                    begin
                      TLZone.TLEditor.Events[crpos.Number - 1].Finish := tmpos;
                      TLZone.Timelines[ps].Events[crpos.Number - 1]
                        .Finish := tmpos;
                    end
                    else
                    begin
                      TLZone.TLEditor.Events[crpos.Number].Start := tmpos;
                      TLZone.Timelines[ps].Events[crpos.Number].Start := tmpos;
                    end;
                  end
                  else
                  begin
                    if TLParameters.Position > TLZone.TLEditor.Events
                      [TLZone.TLEditor.Count - 1].Finish then
                    begin
                      TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1]
                        .Finish := tmpos;
                      TLZone.Timelines[ps].Events[TLZone.TLEditor.Count - 1]
                        .Finish := tmpos;
                    end
                    else
                    begin
                      for I := 0 to TLZone.TLEditor.Count - 2 do
                      begin
                        if (TLZone.TLEditor.Events[I].Finish <=
                          TLParameters.Position) and
                          (TLZone.TLEditor.Events[I + 1].Start >
                          TLParameters.Position) then
                        begin
                          TLZone.TLEditor.Events[I].Finish := tmpos;
                          TLZone.Timelines[ps].Events[I].Finish := tmpos;
                        end;
                      end;
                    end;
                  end;;
                end;
              tlmedia:
                exit;
            end;
            // TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,0);
            TLZone.TLEditor.UpdateScreen(bmpTimeline.Canvas);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        1:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;

            crpos := TLZone.TLEditor.CurrentEvents;
            if (TLParameters.Position < TLZone.TLEditor.Events[0].Start) then
              crpos.Number := 0;

            case TLZone.TLEditor.TypeTL of
              tldevice:
                if crpos.Number = 0 then
                begin
                  if TLParameters.Position < TLZone.TLEditor.Events[0].Start
                  then
                  begin
                    TLZone.TLEditor.Events[0].Start := TLParameters.Position;
                    TLZone.Timelines[ps].Events[0].Start :=
                      TLParameters.Position;
                  end;
                end
                else
                begin
                  if crpos.Number < TLZone.TLEditor.Count - 1 then
                  begin
                    if TLZone.TLEditor.Events[crpos.Number]
                      .Start = TLParameters.Position then
                      exit;
                    if crpos.Number = 0 then
                    begin
                      TLZone.TLEditor.Events[crpos.Number].Start :=
                        TLParameters.Position;
                      TLZone.Timelines[ps].Events[crpos.Number].Start :=
                        TLParameters.Position;
                    end
                    else
                    begin
                      TLZone.TLEditor.Events[crpos.Number + 1].Start :=
                        TLParameters.Position;
                      TLZone.Timelines[ps].Events[crpos.Number + 1].Start :=
                        TLParameters.Position;
                      TLZone.TLEditor.Events[crpos.Number].Finish :=
                        TLParameters.Position;
                      TLZone.Timelines[ps].Events[crpos.Number].Finish :=
                        TLParameters.Position;
                    end;
                  end;
                end;
              tltext, tlmedia:
                if crpos.Number = 0 then
                begin
                  if (TLParameters.Position < TLZone.TLEditor.Events[0].Start)
                  then
                  begin
                    TLZone.TLEditor.Events[0].Start := TLParameters.Position;
                    TLZone.Timelines[ps].Events[0].Start :=
                      TLParameters.Position;
                  end
                  else
                  begin
                    TLZone.TLEditor.Events[0].Finish := TLParameters.Position;
                    TLZone.Timelines[ps].Events[0].Finish :=
                      TLParameters.Position;
                  end;
                end
                else
                begin
                  if crpos.Number = TLZone.TLEditor.Count - 1 then
                  begin
                    TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Finish :=
                      TLParameters.Position;
                    TLZone.Timelines[ps].Events[TLZone.TLEditor.Count - 1]
                      .Finish := TLParameters.Position;
                  end
                  else
                  begin
                    for I := 0 to TLZone.TLEditor.Count - 2 do
                    begin
                      if (TLZone.TLEditor.Events[I].Finish <=
                        TLParameters.Position) and
                        (TLZone.TLEditor.Events[I + 1].Start >
                        TLParameters.Position) then
                      begin
                        TLZone.TLEditor.Events[I + 1].Start :=
                          TLParameters.Position;
                        TLZone.Timelines[ps].Events[I + 1].Start :=
                          TLParameters.Position;
                        break;
                      end
                      else
                      begin
                        if (TLZone.TLEditor.Events[I].Finish >
                          TLParameters.Position) and
                          (TLZone.TLEditor.Events[I].Start <
                          TLParameters.Position) then
                        begin
                          TLZone.TLEditor.Events[I].Finish :=
                            TLParameters.Position;
                          TLZone.Timelines[ps].Events[I].Finish :=
                            TLParameters.Position;
                          break;
                        end;
                      end;;
                    end;
                  end;
                end;
            end;

            TLZone.TLEditor.UpdateScreen(bmpTimeline.Canvas);
            for I := 0 to TLZone.Count - 1 do
              TLZone.Timelines[I].DrawTimeline(bmpTimeline.Canvas, I, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        2:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            ShiftTimelines;
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
            for I := 0 to TLZone.Count - 1 do
              TLZone.Timelines[I].DrawTimeline(bmpTimeline.Canvas, I, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        3:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            SetShortNumber;
            // ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        4:
          begin
            PrintTimelines;
          end;
        5:
          begin
            olddir := SaveDialog1.InitialDir;
            oldfilter := SaveDialog1.Filter;
            SaveDialog1.InitialDir := PathTemp + '\';
            SaveDialog1.Filter := 'Файл событий тайм линии (*.evtl)|*.EVTL';
            SaveDialog1.FileName := PathTemp + '\tledit.evtl';
            SaveDialog1.FilterIndex := 0;
            if SaveDialog1.Execute then
            begin
              sext := ExtractFileExt(SaveDialog1.FileName);
              if trim(sext) = '' then
                SaveDialog1.FileName := SaveDialog1.FileName + '*.evtl';
              TLZone.TLEditor.SaveToFile(SaveDialog1.FileName);
            end;
            SaveDialog1.Filter := olddir;
            SaveDialog1.InitialDir := oldfilter;
          end;
        6:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            evswapbuffer.Cut;
          end;
        7:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            evswapbuffer.copy;
          end;
        8:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            evswapbuffer.Paste;
          end;
        9:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            bl := false;
            for I := 0 to TLZone.TLEditor.Count - 1 do
              if TLZone.TLEditor.Events[I].Select then
                bl := true;
            if bl then
            begin
              If not MyTextMessage('Вопрос',
                'Удалить выделенные значения, без возможности востановления?', 2)
              then
                exit;
              for I := TLZone.TLEditor.Count - 1 downto 0 do
                if TLZone.TLEditor.Events[I].Select then
                  TLZone.TLEditor.DeleteEvent(I);
            end
            else
            begin
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number = -1 then
                exit;
              If not MyTextMessage('Вопрос',
                'Удалить текущее значение, без возможности востановления?', 2)
              then
                exit;
              TLZone.TLEditor.DeleteEvent(crpos.Number);
            end;
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            if TLZone.TLEditor.TypeTL = tldevice then
            begin
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlButtonsPrepare-8');
              TemplateToScreen(crpos);
              if pnImageScreen.Visible then
                Image3.Repaint;
            end;
          end;
        10:
          begin
            LoadFromUNDO;
            ps := ZoneNames.Edit.GridPosition(form1.GridTimeLines,
              ZoneNames.Edit.IDTimeline);
            SetPanelTypeTL((form1.GridTimeLines.Objects[0,
              ps] as TTimeLineOptions).TypeTL, ps);
            ZoneNames.Draw(imgTLNames.Canvas, form1.GridTimeLines, true);
            TLZone.DrawBitmap(bmpTimeline);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            if (TLParameters.vlcmode <> play) then
            begin
              MediaSetPosition(TLParameters.Position, false,
                'UCommon.ControlButtonsPrepare');
              MediaPause;
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlButtonsPrepare 9-1')
              else
                MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', '',
                  'ControlButtonsPrepare 9-2');
              TemplateToScreen(crpos);
            end;
          end;
        11:
          begin
            olddir := OpenDialog1.InitialDir;
            oldfilter := OpenDialog1.Filter;
            OpenDialog1.InitialDir := PathTemp;
            OpenDialog1.Filter := 'Файл событий тайм линии (*.evtl)|*.EVTL';
            OpenDialog1.FilterIndex := 0;
            if OpenDialog1.Execute then
            begin
              TLZone.TLEditor.LoadFromFile(TLZone.TLEditor.TypeTL,
                OpenDialog1.FileName);
              TLZone.DrawBitmap(bmpTimeline);
              TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
              form1.imgtimelines.Repaint;
              ps := FindClipInGrid(GridClips, trim(lbActiveClipID.Caption));
              (GridClips.Objects[0, ps] as TGridRows).MyCells[3].UpdatePhrase
                ('Dur', FramesToStr(TLParameters.Finish -
                TLParameters.Preroll));
              CheckedActivePlayList;
              SaveClipEditingToFile(trim(lbActiveClipID.Caption));
            end;
            OpenDialog1.Filter := olddir;
            OpenDialog1.InitialDir := oldfilter;
          end;
      end;
    end;
    // ssssjson
          PutGridTimeLinesToServer(Form1.GridTimeLines);

  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ControlButtonsPrepare Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

Procedure ControlPlayerTransmition(command: integer);
var
  I, res: integer;
  crpos: TEventReplay;
  Posi: longint;
begin
  try
    WriteLog('MAIN', 'UCommon.ControlPlayerTransmition Command=' +
      inttostr(command));
    with form1 do
    begin
      case command of
        0:
          begin
            SaveToUNDO;
            TLParameters.Position := TLParameters.Start;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            // TLParameters.ZeroPoint;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerTransmition-1');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-0');
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
        1:
          begin
            SaveToUNDO;
            Posi := -1;
            if TLZone.TLEditor.Count <= 0 then
              exit;
            if TLParameters.Position < TLZone.TLEditor.Events[0].Start then
              exit;
            if TLParameters.Position > TLZone.TLEditor.Events
              [TLZone.TLEditor.Count - 1].Start then
            begin
              TLParameters.Position := TLZone.TLEditor.Events
                [TLZone.TLEditor.Count - 1].Start;
                PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlPlayerTransmition-1');
              TemplateToScreen(crpos);
              if pnImageScreen.Visible then
                Image3.Repaint;
              MediaSetPosition(TLParameters.Position, false,
                'UCommon.ControlPlayerTransmition-1.1'); // 1
              TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
              MediaPause;
              SetClipTimeParameters;
              MyPanelAir.SetValues;
              if form1.PanelAir.Visible then
              begin
                MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                  TLZone.TLEditor.Index);
                form1.ImgDevices.Repaint;
                form1.ImgEvents.Repaint;
              end;
              exit;
            end;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number = -1 then
            begin
              for I := 0 to TLZone.TLEditor.Count - 2 do
              begin
                if (TLParameters.Position >= TLZone.TLEditor.Events[I].Finish)
                  and (TLParameters.Position <= TLZone.TLEditor.Events[I + 1]
                  .Start) then
                begin
                  Posi := I;
                  break;
                end;
              end;
            end
            else if crpos.Number = 0 then
              Posi := 0
            else
              Posi := crpos.Number - 1;
            TLParameters.Position := TLZone.TLEditor.Events[Posi].Start;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            crpos := TLZone.TLEditor.CurrentEvents;
            MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
              'ControlPlayerTransmition 1-1');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-1.2'); // 2
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
        2:
          begin
            SaveToUNDO;
            Posi := -1;
            if TLZone.TLEditor.Count <= 0 then
              exit;
            if TLParameters.Position >= TLZone.TLEditor.Events
              [TLZone.TLEditor.Count - 1].Start then
              exit;
            if TLParameters.Position < TLZone.TLEditor.Events[0].Start then
            begin
              TLParameters.Position := TLZone.TLEditor.Events[0].Start;
              PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlPlayerTransmition-2');
              TemplateToScreen(crpos);
              if pnImageScreen.Visible then
                Image3.Repaint;
              MediaSetPosition(TLParameters.Position, false,
                'UCommon.ControlPlayerTransmition-2.1'); // 1
              TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
              MediaPause;
              SetClipTimeParameters;
              MyPanelAir.SetValues;
              if form1.PanelAir.Visible then
              begin
                MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                  TLZone.TLEditor.Index);
                form1.ImgDevices.Repaint;
                form1.ImgEvents.Repaint;
              end;
              exit;
            end;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number = -1 then
            begin
              for I := 0 to TLZone.TLEditor.Count - 2 do
              begin
                if (TLParameters.Position >= TLZone.TLEditor.Events[I].Finish)
                  and (TLParameters.Position <= TLZone.TLEditor.Events[I + 1]
                  .Start) then
                begin
                  Posi := I + 1;
                  break;
                end;
              end;
            end
            else
              Posi := crpos.Number + 1;
            TLParameters.Position := TLZone.TLEditor.Events[Posi].Start;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            crpos := TLZone.TLEditor.CurrentEvents;
            MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
              'ControlPlayerTransmition 2-2');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-2.2'); // 2
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
        3:
          begin
            SaveToUNDO;
            TLParameters.Position := TLParameters.Finish;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            // TLParameters.ZeroPoint;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerTransmition-3');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-3');
            // TLZone.TLEditor.UpdateScreen(imgtimelines.Canvas);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
      end; // case
      TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
      form1.imgLayer1.Repaint;
    end; // with
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ControlPlayerTransmition Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ControlPlayerFastSlow(command: integer);
var
  crpos: TEventReplay;
  rightlimit: longint;
begin
  try
    WriteLog('MAIN', 'UCommon.ControlPlayerFastSlow Command=' +
      inttostr(command));
    case command of
      0:
        begin
          if TLParameters.vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple / 4;
            MediaSlow(4);
          end
          else
          begin
            if TLParameters.Position <= TLParameters.Preroll then
            begin
              TLParameters.Position := TLParameters.Preroll;
              PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
              TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
              form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position - StepMouseWheel;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-0');
            TemplateToScreen(crpos);
            if form1.pnImageScreen.Visible then
              form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-0');
            TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
        end;
      1:
        begin
          if TLParameters.vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple / 2;
            MediaSlow(2);
          end
          else
          begin
            if TLParameters.Position <= TLParameters.Preroll then
            begin
              TLParameters.Position := TLParameters.Preroll;
              PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
              TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
              form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position - 1;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-1');
            TemplateToScreen(crpos);
            if form1.pnImageScreen.Visible then
              form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-1');
            TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
        end;
      2:
        begin
          if TLParameters.vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple * 2;
            MediaFast(2);
          end
          else
          begin
            rightlimit := TLParameters.Preroll + TLParameters.Duration +
              TLParameters.Postroll -
              (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame) +
              TLParameters.MyCursor div TLParameters.FrameSize;
            if TLParameters.Position > rightlimit then
            begin
              TLParameters.Position := rightlimit;
              PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
              TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
              form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position + 1;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-2');
            TemplateToScreen(crpos);
            if form1.pnImageScreen.Visible then
              form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-2');
            TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
        end;
      3:
        begin
          if TLParameters.vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple * 4;
            MediaFast(4);
          end
          else
          begin
            rightlimit := TLParameters.Preroll + TLParameters.Duration +
              TLParameters.Postroll -
              (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame) +
              TLParameters.MyCursor div TLParameters.FrameSize;
            if TLParameters.Position > rightlimit then
            begin
              TLParameters.Position := rightlimit;
              PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
              TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
              form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position + StepMouseWheel;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-3');
            TemplateToScreen(crpos);
            if form1.pnImageScreen.Visible then
              form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-3');
            TLZone.DrawTimelines(form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(form1.ImgDevices.Canvas, form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              form1.ImgDevices.Repaint;
              form1.ImgEvents.Repaint;
            end;
          end;
        end;
    end; // case
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ControlPlayerFastSlow Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;


initialization

ListEditedProjects := TStringList.Create;
ListEditedProjects.Clear;

ListVisibleWindows := TStringList.Create;
ListVisibleWindows.Clear;

WorkHotKeys := TMyListHotKeys.Create('Default');
WorkHotKeys.SetDefault;

finalization

ListEditedProjects.Free;
ListVisibleWindows.Free;
WorkHotKeys.Free;

end.
