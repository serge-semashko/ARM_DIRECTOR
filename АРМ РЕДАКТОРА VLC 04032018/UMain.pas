unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer, MMSystem, OpenGL, UCommon,
  PasLibVlcUnit, vlcpl, system.json,uwebget;

Const

  WM_DRAWTimeline = WM_APP + 9876;
  WM_TRANSFER = WM_USER + 1;

type
  // PCompartido =^TCompartido;
  // TCompartido = record
  // Manejador1: Cardinal;
  // Manejador2: Cardinal;
  // Numero    : Integer;
  // Shift     : Double;
  // Cadena    : String[20];
  // end;

  TMyThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure DoWork;
    procedure Execute; override;
  end;

  TForm1 = class(TForm)
    PanelControl: TPanel;
    PanelControlBtns: TPanel;
    PanelControlMode: TPanel;
    PanelControlClip: TPanel;
    PanelProject: TPanel;
    PanelClips: TPanel;
    PanelPlayList: TPanel;
    lbMode: TLabel;
    sbProject: TSpeedButton;
    sbClips: TSpeedButton;
    sbPlayList: TSpeedButton;
    Panel6: TPanel;
    Panel10: TPanel;
    sbPredClip: TSpeedButton;
    Bevel1: TBevel;
    sbNextClip: TSpeedButton;
    Panel11: TPanel;
    GridLists: TStringGrid;
    PanelPrepare: TPanel;
    PanelAir: TPanel;
    Label2: TLabel;
    Panel12: TPanel;
    GridClips: TStringGrid;
    Bevel2: TBevel;
    Bevel3: TBevel;
    imgButtonsProject: TImage;
    GridTimeLines: TStringGrid;
    imgButtonsControlProj: TImage;
    imgBlockProjects: TImage;
    Panel1: TPanel;
    GridActPlayList: TStringGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    pnPrepareCTL: TPanel;
    pnMovie: TPanel;
    pnTypeMovie: TPanel;
    pnPrepareSong: TPanel;
    imgCTLPrepare1: TImage;
    imgTypeMovie: TImage;
    PnDevTL: TPanel;
    PnTextTL: TPanel;
    pnMediaTL: TPanel;
    imgDeviceTL: TImage;
    RichEdit1: TRichEdit;
    imgTextTL: TImage;
    imgMediaTL: TImage;
    imgTLNames: TImage;
    imgTimelines: TImage;
    imgSongLock: TImage;
    imgCTLBottomL: TImage;
    imgpnlbtnspl: TImage;
    imgpnlbtnsclips: TImage;
    ApplicationEvents1: TApplicationEvents;
    Panel2: TPanel;
    Bevel6: TBevel;
    ImgDevices: TImage;
    imgEvents: TImage;
    lbPlayList1: TLabel;
    Image1: TImage;
    Image2: TImage;
    OpenDialog1: TOpenDialog;
    Panel7: TPanel;
    lbCTLTimeCode: TLabel;
    imgCtlBottomR: TImage;
    Timer1: TTimer;
    imgLayer1: TImage;
    imgLayer2: TImage;
    // lbPLName: TLabel;
    Panel8: TPanel;
    Panel9: TPanel;
    lbPlayerFile: TLabel;
    OpenDialog2: TOpenDialog;
    ImgLayer0: TImage;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    GridGRTemplate: TStringGrid;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel16: TPanel;
    Label1: TLabel;
    pnImageScreen: TPanel;
    Image3: TImage;
    lbActiveClipID: TLabel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Label13: TLabel;
    Label16: TLabel;
    lbMediaNTK: TLabel;
    lbMediaDuration: TLabel;
    lbMediaKTK: TLabel;
    lbMediaTotalDur: TLabel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    lbMediaCurTK: TLabel;
    spDeleteTemplate: TSpeedButton;
    Timer2: TTimer;
    Label7: TLabel;
    InputPanel: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label8: TLabel;
    Label14: TLabel;
    SpeedButton1: TSpeedButton;
    lbTypeTC: TLabel;
    Panel23: TPanel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Label15: TLabel;
    Panel24: TPanel;
    ImgButtonsPL: TImage;
    Panel25: TPanel;
    Panel26: TPanel;
    sbSinhronization: TSpeedButton;
    lbusesclpidlst: TLabel;
    Bevel5: TBevel;
    Bevel13: TBevel;
    LBTimeCode1: TLabel;
    MySynhro: TCheckBox;
    Bevel14: TBevel;
    Bevel15: TBevel;
    lbSynchRegim: TLabel;
    Bevel16: TBevel;
    Bevel18: TBevel;
    Bevel17: TBevel;
    SpeedButton2: TSpeedButton;
    Panel27: TPanel;
    ListBox1: TListBox;
    ImgMainMenu: TImage;
    Bevel19: TBevel;
    sbMainMenu: TSpeedButton;
    pnMainMenu: TPanel;
    PanelStartWindow: TPanel;
    Label21: TLabel;
    Label26: TLabel;
    Image4: TImage;
    SaveDialog1: TSaveDialog;
    ImgListFiles: TImage;
    ImgStartWinBtn: TImage;
    pnAPlFindSTR: TPanel;
    pnAPlFindTime: TPanel;
    pnClpFindStr: TPanel;
    pnClpFindTime: TPanel;
    imgClpFindStr: TImage;
    imgClpFindTime: TImage;
    imgAPlFindStr: TImage;
    imgAPlFindTime: TImage;
    pnTempMenu: TPanel;
    imgTempMenu: TImage;
    pnProjBlocking: TPanel;
    imgpntlproj: TImage;
    Panel5: TPanel;
    imgPnClips: TImage;
    Panel28: TPanel;
    imgDataPrep: TImage;
    ImgPnPList: TImage;
    ImgPLData: TImage;
    imgPLTlCurr: TImage;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    procedure GridListsMouseUpPlaylists(X, Y: Integer);
    // procedure GridListsMouseUpTextTemplates(X, Y: Integer);
    // procedure GridListsMouseUpGRTemplates(X, Y: Integer);
    // procedure AddPlayList;
    procedure sbProjectClick(Sender: TObject);
    procedure sbClipsClick(Sender: TObject);
    procedure sbPlayListClick(Sender: TObject);
    procedure lbModeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure GridProjectsDblClick(Sender: TObject);
    procedure GridListsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridListsDblClick(Sender: TObject);
    procedure GridListsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgButtonsProjectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridProjectsTopLeftChanged(Sender: TObject);
    procedure GridTimeLinesDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure imgButtonsControlProj1MouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridTimeLinesDblClick(Sender: TObject);
    procedure pnMovieResize(Sender: TObject);
    procedure imgButtonsControlProj1MouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure imgButtonsProjectMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgCTLPrepare1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCTLPrepare1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgTLNamesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgpnlbtnsplMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgpnlbtnsplMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgpnlbtnsclipsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgpnlbtnsclipsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgDeviceTLMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgDeviceTLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTLNamesMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure imgMediaTLMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgMediaTLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridListsTopLeftChanged(Sender: TObject);
    procedure imgCTLBottomLMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgCTLBottomLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCtlBottomRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCtlBottomRMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GridClipsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridClipsDblClick(Sender: TObject);
    procedure GridClipsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GridClipsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridActPlayListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sbPredClipClick(Sender: TObject);
    procedure sbNextClipClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure imgLayer2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgLayer2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgLayer2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridClipsTopLeftChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridActPlayListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgTextTLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTextTLMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure GridGRTemplateDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridGRTemplateMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgLayer2DblClick(Sender: TObject);
    procedure GridProjectsRowMoved(Sender: TObject;
      FromIndex, ToIndex: Integer);
    procedure GridProjectsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridListsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridClipsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridActPlayListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTypeMovieMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgTypeMovieMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridGRTemplateDblClick(Sender: TObject);
    procedure spDeleteTemplateClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RichEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ImgButtonsPLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonsPLMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbSinhronizationClick(Sender: TObject);
    procedure GridTimeLinesTopLeftChanged(Sender: TObject);
    procedure ImgDevicesMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure MySynhroClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure sbMainMenuClick(Sender: TObject);
    procedure ImgMainMenuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgMainMenuMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbProjectMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbClipsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbPlayListMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbMainMenuMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton5Click(Sender: TObject);
    procedure ImgListFilesMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ImgListFilesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgStartWinBtnMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ImgStartWinBtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelStartWindowMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgClpFindStrMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgClpFindStrMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgClpFindTimeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgClpFindTimeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgAPlFindStrMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgAPlFindStrMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgAPlFindTimeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgAPlFindTimeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgTempMenuMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgTempMenuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridClipsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GridActPlayListMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PanelControlClipMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbPredClipMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbNextClipMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure pnMovieMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure lbClipNameMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgEventsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgPLTlCurrMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgPLTlCurrMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridTimeLinesMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgpntlprojMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure GridListsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);

  private
    { Private declarations }
    // Compartido : PCompartido;
    FicheroM: THandle;
    procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    // Обработчик сообщения WM_HOTKEY
    procedure WMHotKey(var Mess: TWMHotKey); message WM_HOTKEY;
    // Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
    procedure WMDRAWTimeline(var Msg: TMessage); Message WM_DRAWTimeline;
    procedure WMEraseBackGround(var Msg: TMessage); Message WM_EraseBkgnd;
    procedure WM_GETMINMAXINFO(var Msg: TWMGETMINMAXINFO);
      message WM_GETMINMAXINFO;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
    Compartido: PCompartido;
  end;
  TlabelJSON = Class helper for TLabel
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

var
  Form1: TForm1;
  // VLC переменные начало
  VLCPlayer: tvlcpl;
  // VLC переменные окончание

  MyTimer: THRTimer;
  MyThread: TMyThread;
  PredDt, CurrDt, pStart1: Double;
  OldTCPosition: longint = -1;
  OldTCTime: Double = -1;
  mmResult: Integer;
  OldList1Index: Integer = -1;
  // strgrrect : TGridRect;

procedure SetMediaButtons;
procedure StartMyTimer;
procedure StopMyTimer;
Function ReadMyTimer: Double;
procedure WaitingStart(wrd: string);
procedure WaitingStop;

implementation

uses UInitForms, UGrid, UProject, UIMGButtons, UDelGridRow, UTimeline,
  UDrawTimelines, uimportfiles, uactplaylist, ugrtimelines, uwaiting, umyevents,
  uplaylists, UMyFiles, UTextTemplate, UMyMessage, UImageTemplate, uAirDraw,
  USubtitrs, USetTemplate, ugridsort, uwebserv, ulkjson, uMyMediaSwitcher,
  ushifttl, ushortnum, umyinifile, uevswapbuffer, uLock, umyundo, UlistUsers,
  umyltc, usettc, UMyTextTemplate, umymenu, UStartWindow, ufrhotkeys,
  UMyOptions,
  UMyTextTable, ufrsaveproject;

{$R *.dfm}
{$R bmpres2.res}

procedure TForm1.Reciviendo(var Msg: TMessage);
begin
  try
    // label1.Caption:=compartido^.Cadena;
    MyShiftOld := MyShift;
    MyShift := Compartido^.Shift;
    Compartido^.Cadena := '';
    WriteLog('MAIN', 'Message:Reciviendo');
  except
    on E: Exception do
      WriteLog('MAIN', 'Message:Reciviendo | ' + E.Message);
  end;
end;

procedure TForm1.WM_GETMINMAXINFO(var Msg: TWMGETMINMAXINFO);
begin
  try
    if mainwindowsize then
      exit;

    with Msg.minmaxinfo^ do
    begin
      ptmaxposition.X := BorderWidth;
      ptmaxposition.Y := BorderWidth;

      ptmaxsize.X := Screen.Width;
      ptmaxsize.Y := Screen.Height;

      ptMinTrackSize.X := Screen.Width;
      ptMinTrackSize.Y := Screen.Height;
      ptMaxTrackSize.X := Screen.Width;
      ptMaxTrackSize.Y := Screen.Height;
    end;
    if imgTypeMovie <> nil then
      imgTypeMovie.Repaint;
    WriteLog('MAIN', 'Message:WM_GETMINMAXINFO');
  except
    on E: Exception do
      WriteLog('MAIN', 'Message:WM_GETMINMAXINFO | ' + E.Message);
  end;
end;

procedure TForm1.WMSysCommand(var Msg: TWMSysCommand);
begin
  try
    if ((Msg.CmdType and $FFF0) = SC_MOVE) then
    begin
      if not mainwindowmove then
      begin
        Msg.Result := 0;
        exit;
      end;
    end;
    WriteLog('MAIN', 'Message:WMSysCommand');
    inherited;
  except
    on E: Exception do
      WriteLog('MAIN', 'Message:WMSysCommand | ' + E.Message);
  end;
end;

// ==============================================================================
// ====         Процедуры работы с точным таймером         ======================
// ==============================================================================

procedure TForm1.WMDRAWTimeline(var Msg: TMessage);
begin
  try
    WriteLog('MAIN', 'Message:WMDRAWTimeline');
    if Msg.WParamLo <> 0 then
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
        CurrentImageTemplate, 'Message:WMDRAWTimeline-1')
    else
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
        'Message:WMDRAWTimeline-2');
    // Form1.GridGRTemplate.Refresh;
    // MyPanelAir.SetValues;
    // MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, msg.WParam);
    // application.ProcessMessages;
    // if bmptimeline.Canvas.LockCount =0 then TLZone.DrawBitmap(bmptimeline);
    // if Form1.imgtimelines.Canvas.LockCount<>0 then exit;
    // TLZone.DrawBitmap(bmptimeline);
    // TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
    // if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
  except
    on E: Exception do
      WriteLog('MAIN', 'Message:WMDRAWTimeline | ' + E.Message);
  end;
end;

procedure TForm1.WMEraseBackGround(var Msg: TMessage);
begin
  try
    if vlcmode = play then
      InvalidateRect(Form1.imgTimelines.Canvas.Handle, NIL, FALSE);
    WriteLog('MAIN', 'Message:WMEraseBackGround');
  except
    on E: Exception do
      WriteLog('MAIN', 'Message:WMEraseBackGround | ' + E.Message);
  end;
end;

procedure TimeCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); stdcall;
begin
  try
    FWait.Position := FWait.Position + 1;
    FWait.Draw;
    WriteLog('MAIN', 'Main.TimeCallBack');
  except
    on E: Exception do
      WriteLog('MAIN', 'Main.TimeCallBack | ' + E.Message);
  end;
end;

procedure WaitingStart(wrd: string);
begin
  try
    FWait.Position := 0;
    FWait.Draw;
    FWait.Repaint;
    FWait.Show;
    application.ProcessMessages;
    MyTimer.Waiting := true;
    WriteLog('MAIN', 'Main.WaitingStart');
  except
    on E: Exception do
      WriteLog('MAIN', 'Main.WaitingStart | ' + E.Message);
  end;
end;

procedure WaitingStop;
begin
  try
    MyTimer.Waiting := FALSE;
    FWait.Close;
    WriteLog('MAIN', 'Main.WaitingStop');
  except
    on E: Exception do
      WriteLog('MAIN', 'Main.WaitingStop | ' + E.Message);
  end;
end;

procedure TMyThread.Execute;
begin
  try // MyThread.Priority:=tpTimeCritical;
    { Если Вы хотите, чтобы процедура DoWork выполнялась лишь один раз - удалите цикл while }
    while not Terminated do
    begin
      if vlcmode <> play then
        sleep(1);
      Synchronize(DoWork);
    end;
    WriteLog('MAIN', 'TMyThread.Execute');
  except
    on E: Exception do
      WriteLog('MAIN', 'TMyThread.Execute | ' + E.Message);
  end;
end;

procedure TMyThread.DoWork;
var
  curpos, delttm, mycpos1, mycpos2, myrate: longint;
  dbpr, dbcr, dps: Double;
  db0, db1, db2, db3: Int64; // double;
  crpos: TEventReplay;
  CurrTemplate, txt: string;
  dtt, dt, dts, dte, dtc: Double;
  fcr, ftm, fst, fen: longint;
  msd: Double;
  CTC: string;
begin
  try
    // Если ни одного клипа не загруженно в окно подготовки выходим из данного модуля
    // if trim(form1.lbActiveClipID.Caption)='' then exit;
    // Анализируем состояние системы на предмет запуска по времени.
    // Если установлена синхронизация по времени, ожидаем время запуска.
    if Form1.MySynhro.Checked and (not MyTimer.Enable) then
    begin
      SynchroLoadClip(Form1.GridActPlayList);
      // if mode<>play then Form1.lbCTLTimeCode.Caption:=MyDateTimeToStr(now-TimeCodeDelta);
      application.ProcessMessages;
      dtc := now - TimeCodeDelta;
      ftm := TimeToFrames(dtc);
      fen := MyStartPlay + (TLParameters.Finish - TLParameters.Start);

      if ftm >= fen then
        Form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor, 72);

      if (MyStartPlay <> -1) and (ftm < MyStartPlay - 125) { and MyStartReady }
      then
        Form1.lbTypeTC.Font.Color := ProgrammFontColor;
      if (MyStartPlay <> -1) and (ftm > MyStartPlay - 125) and
        (ftm < MyStartPlay) { and MyStartReady } then
      begin
        Form1.lbTypeTC.Font.Color := clLime;
        MyRemainTime := MyStartPlay - ftm;
        TLParameters.Position := TLParameters.Start;
        PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
        TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
        // WriteLog('Synchro', '2) Старт TLParameters.Position=' + inttostr(TLParameters.Position)
        // + ' Время до запуска MyRemainTime=' + inttostr(MyRemainTime));
        if Form1.PanelAir.Visible then
        begin
          MyPanelAir.AirEvents.Draw(Form1.imgEvents.Canvas);
          MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
          MyPanelAir.AirEvents.DrawTimeCode(Form1.imgEvents.Canvas,
            TLParameters.Position - TLParameters.ZeroPoint);
        end
        else
        begin
          if not Form1.PanelPrepare.Visible then
            CurrentMode := FALSE;
          Form1.lbModeClick(nil);
        end;
        application.ProcessMessages;
        MediaSetPosition(TLParameters.Position, FALSE, 'TMyThread.DoWork-1');
        // 1
        // WriteLog('Synchro', '200) MediaPosition ------------------222222222');
      end;
      if (MyStartPlay <= ftm) and (vlcmode <> play) and (MyStartPlay <> -1)
      { and MyStartReady } then
      begin
        Form1.lbTypeTC.Font.Color := ProgrammFontColor;
        MyRemainTime := -1;
        MyShiftOld := MyShift;
        // MyStartReady := false;
        // Form1.MySynhro.Checked := false;
        MediaStop;
        // WriteLog('Synchro', '4) MediaStop');
        // WriteLog('Synchro', '4) последний фрейм fen=' + inttostr(fen)
        // + ' , фрейм текущего времени ftm=' + inttostr(ftm)
        // + ' , время старта MyStartPlay=' + inttostr(MyStartPlay));
        application.ProcessMessages;
        if ftm < fen then
        begin
          TLParameters.Position := TLParameters.Start + ftm - MyStartPlay;
          PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
          // WriteLog('Synchro', '5) ftm < fen');
          MediaSetPosition(TLParameters.Position, FALSE, 'TMyThread.DoWork-2');
          // 2
          // WriteLog('Synchro', '201) MediaPosition ------------------333333333');
          if not fileexists(Form1.lbPlayerFile.Caption) then
          begin
            Rate := 1;
            pStart := FramesToDouble(TLParameters.Position);
          end;
          MediaPlay;
          // WriteLog('Synchro', '6) MediaPlay=' + inttostr(TLParameters.Position)
          // + ' Время до запуска MyRemainTime=' + inttostr(MyRemainTime));
        end;
        SetMediaButtons;
        // mystartplay:=-1;
      end;
    end
    else
    begin
      Form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor, 72);
      // application.ProcessMessages;
      // SetMediaButtons;
    end;
    // application.ProcessMessages;
    if Form1.MySynhro.Checked and MyTimer.Enable then
    begin
      // WriteLog('Synchro', '7) =======================START==========================');
      MyShiftDelta := MyShift - MyShiftOld;
      if MyShiftDelta < 0 then
        msd := -1 * MyShiftDelta
      else
        msd := MyShiftDelta;

      MyShiftOld := MyShift;

      if (MyShiftDelta <> 0) and MakeLogging then
      begin
        // WriteLog('Synchro', '7) (MyShiftDelta<>0) and MakeLogging = TRUE');
        if MySinhro = chltc then
        begin
          // WriteLog('MAIN', 'TMyThread.DoWork Изменение Тайм-код LTC | Системное время =' +
          // TimeToTimeCodeStr(now) + ' Смещение=' + TimeToTimeCodeStr(MyShift));
          // WriteLog('Synchro', '7) MySinhro=chltc - TRUE');
        end
        else
        begin
          // WriteLog('MAIN', 'TMyThread.DoWork Изменение системного времени | Системное время =' +
          // TimeToTimeCodeStr(now));
          // WriteLog('Synchro', '7) MySinhro=chltc - FALSE');
        end;
      end;
      if (TimeToFrames(msd) >= SynchDelay) and (vlcmode = play) then
      begin
        // if (MyShiftDelta<>0) and (mode=play) then begin
        dtc := now - TimeCodeDelta;
        ftm := TimeToFrames(dtc);
        fen := MyStartPlay + (TLParameters.Finish - TLParameters.Start);
        if ftm >= fen then
        begin
          Form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor, 72);
          TLParameters.Position := TLParameters.Finish;
          PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

          TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
          // MyStartPlay := -1;
        end;
        MediaStop;

        // WriteLog('Synchro', '8) MEDIASTOP (TimeToFrames(msd)>=SynchDelay) and (vlcmode=play) = TRUE'
        // + ' последний фрейм fen=' + inttostr(fen)
        // + ' , фрейм текущего времени ftm=' + inttostr(ftm)
        // + ' , время старта MyStartPlay=' + inttostr(MyStartPlay));

        if ftm < fen then
        begin
          // WriteLog('Synchro', '8) ftm < fen - TRUE');
          if ftm < MyStartPlay then
          begin
            TLParameters.Position := TLParameters.Start;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

            // WriteLog('Synchro', '8) ftm < MyStartPlay - TRUE  TLParameters.Position=' + inttostr(TLParameters.Position));
          end
          else
          begin
            TLParameters.Position := TLParameters.Start + ftm - MyStartPlay;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

            // WriteLog('Synchro', '8) ftm < MyStartPlay - FALSE  TLParameters.Position=' + inttostr(TLParameters.Position));
          end;

          MediaSetPosition(TLParameters.Position, FALSE, 'TMyThread.DoWork-3');
          // 3
          // WriteLog('Synchro', '203) MediaSetPosition ---------------------1111111');
          TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
          // if makelogging then WriteLog('TC', '------------> (MyShiftDelta<>0) and (mode=play)');
          MediaPlay;
          // WriteLog('Synchro', '8) MediaPlay');
        end;
      end;
      // WriteLog('Synchro', '7) =======================END==========================');
    end;
    // Включаем или выключаем отображение времени запуска
    SetTypeTimeCode;

    // Если запуск воспроизведения выполнен то отображаем движение тайм-линий.
    If MyTimer.Enable then
    begin
      dbld1 := MyTimer.ReadTimer; // ========
      CurrDt := MyTimer.ReadTimer - PredDt;
      mycpos1 := TLParameters.Position;
      // WriteLog('TCPlayer', '1) DrawTimelines Position=' + inttostr(TLParameters.Position));
      if (not fileexists(Form1.lbPlayerFile.Caption)) or (VLCPlayer.p_mi = nil)
      then
      begin
        TLParameters.Position :=
          MyDoubleToFrame(pStart + MyTimer.ReadTimer * Rate);
        PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

        // WriteLog('TCPlayer', '2) DrawTimelines Position=' + inttostr(TLParameters.Position));
        PredDt := CurrDt;
        // WriteLog('Synchro', '100)');
        if vlcmode = paused then
          exit;
        // WriteLog('Synchro', '101)');
      end
      else
      begin
        db2 := VLCPlayer.Duration;
        if libvlc_media_player_get_state(VLCPlayer.p_mi) <> libvlc_Ended then
          db1 := VLCPlayer.Time
        else
          db1 := VLCPlayer.Duration + 1;
        db3 := (TLParameters.Finish - TLParameters.Preroll) * 40;
        // if vlcplayer.p_li = nil then
        // begin
        // db1:=vlcplayer.Time;
        // end;
        if MyDoubleToFrame(pStart1) * 40 > db2 then
        begin
          Rate := libvlc_media_player_get_rate(VLCPlayer.p_mi);
          // WriteLog('TCPlayer', '.++++++++++++1) Rate=' + floattostr(Rate));
          db0 := MyDoubleToFrame(pStart1 + CurrDt * Rate) * 40;
          // WriteLog('Synchro', '.      102) DBO=' + floattostr(db0)+ ' 1) Rate=' + floattostr(Rate));
        end
        else
        begin
          if db1 < db2 then
          begin
            db0 := db1;
            PredDt := MyTimer.ReadTimer;
            // WriteLog('Synchro','.      103) DBO=' + floattostr(db0));
          end
          else
          begin
            Rate := libvlc_media_player_get_rate(VLCPlayer.p_mi);
            db0 := db2 + MyDoubleToFrame((MyTimer.ReadTimer - PredDt) * Rate) *
              40; // SpeedMultiple;
            // WriteLog('TCPlayer', '.++++++++++++2) Rate=' + floattostr(Rate));
            // WriteLog('Synchro', '.      104) DBO=' + floattostr(db0)+ ' 2) Rate=' + floattostr(Rate));
          end;
        end;
        if db0 > db3 then
          db0 := db3;
        Rate := libvlc_media_player_get_rate(VLCPlayer.p_mi);
        // WriteLog('Synchro', '      105) DBO=' + floattostr(db0)+ ' 3) Rate=' + floattostr(Rate));
        mycpos2 := TLParameters.Preroll + (db0 div 40);
        if vlcmode = play then
        begin
          if mycpos2 < mycpos1 then
            mycpos2 := mycpos1;
          myrate := Round(Rate);
          if myrate = 0 then
            myrate := 1;

          if mycpos2 > mycpos1 + myrate then
            mycpos2 := mycpos1 + myrate;
        end;
        TLParameters.Position := mycpos2;
        PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

        // TLParameters.Preroll + (db0 div 40);
        // WriteLog('Synchro', '106)      DBO=' + floattostr(db0));
        // WriteLog('Synchro', '106) DrawTimelines Position=' + inttostr(TLParameters.Position));
      end;

      // if makelogging then WriteLog('TC', 'TimeCode=' + MyTimeToStr);

      // if OLDTCPosition<TLParameters.Position then begin
      // if (db0-OldTCTime > 0.02) then begin
      crpos := TLZone.TLEditor.CurrentEvents;

      // if makelogging then WriteLog('TC', 'CurrentEvents=' + MyTimeToStr);

      curpos := TLParameters.Position - TLParameters.ZeroPoint;
      // Form1.lbCTLTimeCode.Caption:=MyDateTimeToStr(Now);
      // Form1.lbCTLTimeCode.Caption:=MyDateTimeToStr(now-TimeCodeDelta);
      if (not Form1.Compartido^.State) and (MySinhro = chltc) then
        Form1.lbCTLTimeCode.Caption := '*' +
          MyDateTimeToStr(now - TimeCodeDelta)
      else
        Form1.lbCTLTimeCode.Caption :=
          '' + MyDateTimeToStr(now - TimeCodeDelta);
      PutJsonStrToServer('CTC',Form1.lbCTLTimeCode.SaveToJSONStr);
      SetClipTimeParameters;
      // application.ProcessMessages;
      // WriteLog('Synchro', '107) DrawTimelines Position=' + inttostr(TLParameters.Position));

      MyPanelAir.SetValues;
      // if makelogging then WriteLog('TC', 'SetValues=' + MyTimeToStr);

      // if makelogging then WriteLog('TC', 'application.ProcessMessages1 start=' + MyTimeToStr + '============================================');
      // if makelogging then WriteLog('MAIN', 'application.ProcessMessages1 start=' + MyTimeToStr + '============================================');
      // application.ProcessMessages;
      // if makelogging then WriteLog('MAIN', 'application.ProcessMessages1 finish=' + MyTimeToStr + '============================================');
      // if makelogging then WriteLog('TC', 'application.ProcessMessages1 finish=' + MyTimeToStr + '============================================');
      // +++++++++++++++++++
      if not Form1.PanelAir.Visible then
      begin
        if Trim(CurrentImageTemplate) <> Trim(crpos.Image) then
        begin
          // if crpos.Number <> -1
          // then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'TMyThread.DoWork-1')
          // else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '', 'TMyThread.DoWork-2');
          TemplateToScreen(crpos);
          CurrentImageTemplate := Trim(crpos.Image);
          if crpos.Number <> -1 then
            PostMessage(Form1.Handle, WM_DRAWTimeline, 1, 1)
          else
            PostMessage(Form1.Handle, WM_DRAWTimeline, 0, 0);
        end;
      end;

      // if makelogging then WriteLog('TC', 'MarkRowPhraseInGrid=' + MyTimeToStr);

      if crpos.SafeZone then
      begin
        if vlcmode = play then
          TLZone.DrawFlash(crpos.Number);
      end
      else
      begin
        Form1.ImgLayer0.Canvas.FillRect(Form1.ImgLayer0.Canvas.ClipRect);
      end;
      // dbld2 := MyTimer.ReadTimer;//========
      // if makelogging then WriteLog('TC', 'DrawFlash=' + MyTimeToStr);
      // if OLDTCPosition<>TLParameters.Position then begin

      // dbld1 := MyTimer.ReadTimer; //=======
      // WriteLog('Synchro', '     108) DrawTimelines Position=' + inttostr(TLParameters.Position));
      if OldParamPosition <> TLParameters.Position then
        TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
      OldParamPosition := TLParameters.Position;
      // if makelogging then WriteLog('TC', '----------' + floattostr(db0-OldTCTime) + '------------------' + Framestostr(TLParameters.Position) + '------------------> 2');
      // dbld2 := MyTimer.ReadTimer;//========
      // if makelogging then WriteLog('TC', 'DrawTimelines=' + MyTimeToStr);
      // OLDTCPosition:=TLParameters.Position;
      // end;
      if Form1.PanelAir.Visible then
      begin
        // MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
        if MyDoubleToFrame(db0) mod 1 = 0 then
        begin
          // dbld1 := MyTimer.ReadTimer; //=======
          MyPanelAir.AirEvents.Draw(Form1.imgEvents.Canvas);
          MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
          // dbld2 := MyTimer.ReadTimer;//========
          // if makelogging then WriteLog('TC', 'MyPanelAir=' + MyTimeToStr);
        end;
        MyPanelAir.AirEvents.DrawTimeCode(Form1.imgEvents.Canvas,
          TLParameters.Position - TLParameters.ZeroPoint);
          PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
      end;

      // OldTCTime:=db0;
      // OLDTCPosition:=TLParameters.Position;
      // end;
      // OLDTCPosition:=TLParameters.Position;
      application.ProcessMessages;
      // dbld2 := MyTimer.ReadTimer;//========
      // if makelogging then WriteLog('TC', '===============================Итого: '  + MyTimeToStr);

      if not fileexists(Form1.lbPlayerFile.Caption) then
      begin
        if TLParameters.Position >= TLParameters.Finish then
        begin
          TLParameters.Position := TLParameters.Finish;
          PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
          MediaPause;
          SetMediaButtons;
          Form1.lbTypeTC.Caption := '';
          // WriteLog('Synchro', '109) последний фрейм fen=' + inttostr(fen)
          // + ' , фрейм текущего времени ftm=' + inttostr(ftm)
          // + ' , время старта MyStartPlay=' + inttostr(MyStartPlay));
          MyStartPlay := -1;
          // MyStartReady:=false;
          // Form1.MySynhro.Checked := false;
          TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
          exit;
        end;
      end
      else
      begin
        if (db0 >= db3) or (db0 < 0) then
        begin
          // TLParameters.Position := TLparameters.Finish;
          MediaPause;
          SetMediaButtons;
          Form1.lbTypeTC.Caption := '';
          // WriteLog('Synchro', '110) последний фрейм fen=' + inttostr(fen)
          // + ' , фрейм текущего времени ftm=' + inttostr(ftm)
          // + ' , время старта MyStartPlay=' + inttostr(MyStartPlay));

          // WriteLog('TCPlayer', '7) DrawTimelines Position=' + inttostr(TLParameters.Position));
          MyStartPlay := -1;
          TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
          // MyStartReady:=false;
          // Form1.MySynhro.Checked := false;
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TMyThread.DoWork | ' + E.Message);
  end;
end;

procedure StartMyTimer;
var
  dur: Double;
begin
  try
    PredDt := 0;
    // MyTimer.StartTimer;
    // PredDt:=MyTimer.ReadTimer;
    if fileexists(Form1.lbPlayerFile.Caption) then
    begin
      // pMediaPosition.get_CurrentPosition(pStart);
      pStart := VLCPlayer.Time;
      // pMediaPosition.get_Duration(dur);
      dur := VLCPlayer.Duration div 40;
    end
    else
    begin
      pStart := FramesToDouble(TLParameters.Position);
      // dur := FramesToDouble(TLParameters.Duration);
      dur := TLParameters.Duration;
    end;
    pStart1 := 0;
    // if FramesToDouble(TLParameters.Position - TLParameters.Preroll) > dur
    if TLParameters.Position - TLParameters.Preroll > dur then
      pStart1 := FramesToDouble(TLParameters.Position - TLParameters.Preroll);
    // OlDTCPosition:=-1;

    MyTimer.StartTimer;
    PredDt := MyTimer.ReadTimer;
    if MakeLogging then
      WriteLog('MAIN', 'UMain.StartMyTimer Duration=' + TimeToTimeCodeStr(dur) +
        ' Start=' + TimeToTimeCodeStr(pStart) + ' Start1=' +
        TimeToTimeCodeStr(pStart1));
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.StartMyTimer | ' + E.Message);
  end;
end;

procedure StopMyTimer;
begin
  MyTimer.StopTimer;
  if MakeLogging then
    WriteLog('MAIN', 'UMain.StopMyTimer');
end;

Function ReadMyTimer: Double;
begin
  Result := MyTimer.ReadTimer;
end;

// ==============================================================================

// Procedure  TForm1.WMKeyDown(Var Msg:TWMKeyDown);
// выход из полноэкранного режима по кнопке ESC
// begin
// try
// WriteLog('MAIN', 'Message.WMKeyDown');
// if Msg.CharCode=VK_ESCAPE then
// begin
// pVideoWindow.SetWindowPosition(0,0,pnMovie.ClientRect.Right,pnMovie.ClientRect.Bottom);
// FullScreen:=False;
// end;
// inherited;
// except
// on E: Exception do WriteLog('MAIN', 'Message.WMKeyDown | ' + E.Message);
// end;
// end;

procedure TForm1.WMHotKey(var Mess: TWMHotKey);
var
  hk, uns, res: Integer;
  s: string;
begin
  try
    WriteLog('MAIN', 'Message.WMHotKey');
    hk := Mess.HotKey;
    uns := Mess.Unused;
    res := Mess.Result;
    s := inttostr(res);
    inherited;
    // ShowMessage('Нажата горячая клавиша CTRL+F12');
  except
    on E: Exception do
      WriteLog('MAIN', 'Message.WMHotKey | ' + E.Message);
  end;
end;

procedure TForm1.sbProjectClick(Sender: TObject);
begin
  WriteLog('MAIN', 'TForm1.sbProjectClick');
  SetMainGridPanel(projects);
end;

procedure TForm1.sbProjectMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
end;

procedure TForm1.sbClipsClick(Sender: TObject);
begin
  WriteLog('MAIN', 'TForm1.sbClipsClick');
  SetMainGridPanel(clips);
end;

procedure TForm1.sbClipsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
end;

procedure TForm1.sbPlayListClick(Sender: TObject);
var
  i, ps, j: Integer;
begin
  try
    WriteLog('MAIN', 'TForm1.sbPlayListClick Start');
    ListBox1.Clear;
    for i := 1 to GridLists.RowCount - 1 do
    begin
      ListBox1.Items.Add((GridLists.Objects[0, i] as TGridRows).MyCells[3]
        .ReadPhrase('Name'));
      j := ListBox1.Items.Count - 1;
      if not(ListBox1.Items.Objects[j] is TMyListBoxObject) then
        ListBox1.Items.Objects[j] := TMyListBoxObject.Create;
      (ListBox1.Items.Objects[j] as TMyListBoxObject).ClipId :=
        (GridLists.Objects[0, i] as TGridRows).MyCells[3].ReadPhrase('Note');
    end;
    ps := findgridselection(GridLists, 2);
    if ps <> -1 then
      ListBox1.ItemIndex := ps - 1;

    if Trim(lbActiveClipID.Caption) <> '' then
      SaveClipEditingToFile(Trim(lbActiveClipID.Caption));
    ListBox1Click(nil);

    if not SetMainGridPanel(actplaylist) then
      exit;
    // if secondarygrid<>playlists then exit;
    if ps <> -1 then
    begin

      // (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark
      // := Not (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark;
      SetPlaylistBlocking(ps);
      Image1.Repaint;
      WriteLog('MAIN', 'TForm1.sbPlayListClick Finish');
    end;
    GridActvePLToPanel(GridActPlayList.Row);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.sbPlayListClick | ' + E.Message);
  end;
end;

procedure TForm1.sbPlayListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
end;

procedure TForm1.lbClipNameMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
end;

procedure TForm1.lbModeClick(Sender: TObject);
begin
  WriteLog('MAIN', 'TForm1.lbModeClick');
  if Trim(ProjectNumber) = '' then
  begin
    MyTextMessage('Предупреждение',
      'Для начала работы необходимо выбрать/создать проект.', 1);
    exit;
  end;
  CurrentMode := not CurrentMode;
  // UpdatePanelPrepare;
  // UpdatePanelAir;
  if CurrentMode then
  begin
    lbMode.Caption := 'Эфир';
    lbMode.Font.Color := clRed;
  end
  else
  begin
    lbMode.Caption := 'Подготовка';
    lbMode.Font.Color := ProgrammFontColor;
    CurrentImageTemplate := '@#@4445';
  end;
  Label2Click(nil);
  Form1.Repaint;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  FLName: string;
  i, j: Integer;
begin
  try
    WriteLog('MAIN', 'TForm1.ListBox1Click');
    if ListBox1.ItemIndex < 0 then
    begin
      APLCurr.Text := '';
      APLCurr.Draw(imgPLTlCurr.Canvas);
      imgPLTlCurr.Repaint;
      // lbCurrActPL.Caption:='';
      GridClear(Form1.GridActPlayList, RowGridClips);
      WriteLog('MAIN', 'TForm1.ListBox1Click ListBox1.ItemIndex<0');
      exit
    end;

    if MySynhro.Checked and (OldList1Index <> ListBox1.ItemIndex) then
    begin
      MyTextMessage('Предупреждение',
        'Внимание режим синхронизации будет отключен.', 1);
      MySynhro.Checked := FALSE;
    end;

    if not(ListBox1.Items.Objects[ListBox1.ItemIndex] is TMyListBoxObject) then
      exit;
    FLName := (ListBox1.Items.Objects[ListBox1.ItemIndex]
      as TMyListBoxObject).ClipId;

    for j := 1 to GridLists.RowCount - 1 do
      (GridLists.Objects[0, j] as TGridRows).MyCells[2].Mark := FALSE;
    (GridLists.Objects[0, ListBox1.ItemIndex + 1] as TGridRows).MyCells[2]
      .Mark := true;
    pntlapls.SetText('CommentText',
      (GridLists.Objects[0, ListBox1.ItemIndex + 1] as TGridRows).MyCells[3]
      .ReadPhrase('Comment'));
    pntlapls.Draw(ImgPLData.Canvas);
    ImgPLData.Repaint;
    // lbplcomment.Caption := (GridLists.Objects[0,listbox1.ItemIndex+1] as TGridRows).MyCells[3].ReadPhrase('Comment');

    if fileexists(PathPlayLists + '\' + FLName) then
      LoadClipsToActPlayList(PathPlayLists + '\' + FLName);

    GridActvePLToPanel(GridActPlayList.Row);
    if PanelPlayList.Visible then
      ActiveControl := GridActPlayList;

    if i <> -1 then
      pntlclips.SetText('APlayList', ListBox1.Items.Strings[ListBox1.ItemIndex])
      // Form1.lbClipActPL.Caption := ListBox1.Items.Strings[listbox1.ItemIndex]
    else
      pntlclips.SetText('APlayList', ''); // Form1.lbClipActPL.Caption := '';

    pntlclips.Draw(Form1.imgPnClips.Canvas);
    Form1.imgPnClips.Repaint;

    GridActPlayList.Repaint;

    // lbcurractpl.Caption := listbox1.Items.Strings[listbox1.ItemIndex];
    APLCurr.Text := ListBox1.Items.Strings[ListBox1.ItemIndex];
    APLCurr.Draw(imgPLTlCurr.Canvas);
    imgPLTlCurr.Repaint;

    lbusesclpidlst.Caption := 'Плей-лист: ' + ListBox1.Items.Strings
      [ListBox1.ItemIndex];

    ListBox1.Visible := FALSE;
    OldList1Index := ListBox1.ItemIndex;
    WriteLog('MAIN', 'TForm1.ListBox1Click ' + lbusesclpidlst.Caption);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.ListBox1Click | ' + E.Message);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Step, i, ps: Integer;
  ext, nm: string;
  vlc_state: libvlc_state_t;
  dt: Double;
  enddt: tdatetime;
begin
  Try
    WriteLog('MAIN', 'Form1.Create Start');
    WriteLog('MAIN', '');
    WriteLog('MAIN',
      '*****************************************************************************************');
    WriteLog('MAIN',
      '*************************               ЗАПУСК ПРОГРАММЫ             *************************');
    WriteLog('MAIN', '*************************            Время старта: ' +
      TimeToTimeCodeStr(now) + '             *************************');
    WriteLog('MAIN',
      '*****************************************************************************************');

    // dt:=trunc(now);
    // enddt := dt+35;
    // if dt>=43190 then begin
    // MessageDlg('Exiting the Delphi application.', mtInformation,
    // [mbOk], 0, mbOk);

    // MessageDlg('Срок действия тестовой версии завершён.'
    // +#13#10+'Обратитесь к разработчику или поставщику.'
    // +#13#10+'сайт разработчика www.mvsgroup.tv', mtInformation, [mbOK], 0, mbOk);
    // Application.Terminate;
    // exit;
    // end;

    CreateDirectories1;

    bmpEvents := TBitmap.Create;
    bmpAirDevices := TBitmap.Create;
    // ++++++++++++++++++++++++++++++++++++++++++
    { Посмотрим, существует ли файл }
    FicheroM := OpenFileMapping(FILE_MAP_ALL_ACCESS, FALSE, 'MiFichero');
    { Если нет, то ошибка }
    if FicheroM = 0 then
      FicheroM := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
        SizeOf(TCompartido), 'MiFichero');
    // если создается файл, заполним его нулями
    if FicheroM = 0 then
      raise Exception.Create('Не удалось создать файл' +
        '/Ошибка при создании файла');
    Compartido := MapViewOfFile(FicheroM, FILE_MAP_WRITE, 0, 0, 0);
    Compartido^.Manejador2 := Handle;
    Compartido^.Cadena := 'request';
    // ++++++++++++++++++++++++++++++++++++++++++
    Timer1.Enabled := true;

    ReadMyIniFile;
    ReadEditedProjects;

    if MainWindowStayOnTop then
    begin
      Form1.FormStyle := fsStayOnTop;
      Form1.WindowState := wsNormal;
    end
    else
    begin
      Form1.FormStyle := fsNormal;
      Form1.WindowState := wsMaximized;
    end;

    if MenuListFiles = nil then
      MenuListFiles := TMyMenu.Create;
    CreateMainMenu;
    pnMainMenu.Visible := FALSE;
    pnMainMenu.Left := Form1.BorderWidth;
    pnMainMenu.Top := PanelControlBtns.Top + PanelControlBtns.Height;

    TempMenu := TMyMenu.Create;

    DrawMenuBitmap(sbMainMenu);
    ExecTaskOnDelete;
    InputInSystem;
    // RegisterHotKey(Handle, Ord('1'),0, Ord('1'));
    // RegisterHotKey(Handle, 2001 ,MOD_ALT,vk_F12);
    FWait := TFWaiting.Create(nil);

    CreateInputPopUpMenu;

    InitInputInSystem;
    InitMyStartWindow;
    InitMainForm;
    InitPanelControl;
    InitPanelClips(true);
    InitPanelPlayList(true);
    InitPanelProject(true);
    InitPanelPrepare(true);
    InitPanelAir;

    self.imgTimelines.Parent.DoubleBuffered := true;
    self.ImgLayer0.Parent.DoubleBuffered := true;
    self.imgLayer1.Parent.DoubleBuffered := true;
    self.imgLayer2.Parent.DoubleBuffered := true;
    self.imgTLNames.Parent.DoubleBuffered := true;
    Form1.Repaint;
    bmptimeline := TBitmap.Create;
    bmptimeline.PixelFormat := pf32bit;

    MyTimer := THRTimer.Create;
    MyThread := TMyThread.Create(FALSE);
    MyThread.Priority := tpTimeCritical; // tpHighest;

    // then Label15.Caption:= 'Список плей-листов проекта (' + (GridProjects.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Project') + ')'
    // else Label15.Caption:= 'Список плей-листов проекта';
    SecondaryGrid := playlists;
    InputPopUpMenu.Draw(Form1.Image4.Canvas);
    btnstartpnl.Draw(ImgStartWinBtn.Canvas);
    MenuListFiles.Draw(Form1.ImgListFiles.Canvas);
    if inputwithoutusers then
      InputPanel.Visible := FALSE
    else
      InputPanel.Visible := true;
    if not InputPanel.Visible then
      MyStartWindow;

    loadoldproject;
    // MyStartPlay:= -1;
    // MyStartReady := false;
    Form1.MySynhro.Checked := FALSE;
    UpdatePanelAir;
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    WriteLog('MAIN', 'Form1.Create Finish');
    VLCPlayer := tvlcpl.Create;
    if VLCPlayer.Init(pnMovie.Handle) <> '' then
    begin
      MessageDlg(VLCPlayer.error, mtError, [mbOK], 0);
      // exit;
    end;
    // VLCPlayer.Init(Form1.pnMovie.Handle);

  except
    on E: Exception do
      WriteLog('MAIN', 'Form1.Create | ' + E.Message);
  End;
end;

procedure TForm1.Label2Click(Sender: TObject);
var
  hght, tp: Integer;
  strs: string;
  crpos: TEventReplay;
begin
  try
    WriteLog('MAIN', 'TForm1.Label2Click Start');
    if Trim(ProjectNumber) = '' then
    begin
      MyTextMessage('Предупреждение',
        'Для начала работы необходимо выбрать/создать проект.', 1);
      exit;
    end;
    // Сохраняем текущий плей-лист
    if ListBox1.ItemIndex <> -1 then
      SavePlayListFromGridToFile
        ((ListBox1.Items.Objects[ListBox1.ItemIndex]
        as TMyListBoxObject).ClipId);
    // Закрываем панели проектов, клипов, и плей-листа
    if Trim(lbActiveClipID.Caption) = '' then
      LoadDefaultClipToPlayer;
    PanelProject.Visible := FALSE;
    PanelClips.Visible := FALSE;
    PanelPlayList.Visible := FALSE;
    sbProject.Font.Style := sbProject.Font.Style - [fsBold, fsUnderline];
    sbClips.Font.Style := sbClips.Font.Style - [fsBold]; // ,fsUnderline
    sbPlayList.Font.Style := sbPlayList.Font.Style - [fsBold]; // ,fsUnderline
    // В зависимости от заданного режима открываем панели подготовки и эфира
    if CurrentMode then
    begin
      PanelPrepare.Visible := true; // false;
      PanelAir.Visible := true;
    end
    else
    begin
      PanelAir.Visible := FALSE;
      PanelPrepare.Visible := true;
    end;
    // Обнавляем панель подготовки
    UpdatePanelPrepare;
    // Если панель подготовки видна, то проверяем нужно ли отображать графический шаблон и выводим его на экран.
    if PanelPrepare.Visible then
    begin
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1 then
        MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
          'Label2Click');
      TemplateToScreen(crpos);
      if pnImageScreen.Visible then
        Image3.Repaint;
    end;
    // Если клип не воспроизводится, то перерисовываем тайм-линии в памяти, иначе если режим эфира отриосвываем события.
    if vlcmode <> play then
      TLZone.DrawBitmap(bmptimeline)
    else
    begin
      if Form1.PanelAir.Visible then
      begin
        MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,
          TLZone.TLEditor.Index);
        MyPanelAir.SetValues;
        MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.imgEvents.Canvas,
          TLZone.TLEditor.Index);
      end;
      // TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
    end;
    // Выводим диапазон отображения тайм-линий на экран, перерисовываем курсор
    TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
    TLZone.DrawLayer2(imgLayer2.Canvas);
    // InvalidateRect(form1.imgLayer2.Canvas.Handle, NIL, FALSE ) ;
    // Переопределяем высотв отбражения тайм-линий и перериовываем названия тайм-линий
    TLHeights.Height;
    ZoneNames.Draw(imgTLNames.Canvas, GridTimeLines, true);
    // Задаем принудительную перерисовку зон имен тайм-линий и тайм-линий.
    imgTLNames.Repaint;
    imgTimelines.Repaint;
    WriteLog('MAIN', 'TForm1.Label2Click Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.Label2Click | ' + E.Message);
  end;
end;

procedure TForm1.Label2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
end;

procedure TForm1.GridProjectsDblClick(Sender: TObject);
begin
  if Trim(ProjectNumber) = '' then
  begin
    MyTextMessage('Предупреждение',
      'Для начала работы необходимо выбрать/создать проект.', 1);
    exit;
  end;
  DblClickProject := true;
end;

procedure TForm1.GridListsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  // GridDrawCell(GridLists, SecondaryGrid, ACol, ARow, Rect, State);
  GridDrawMyCell(GridLists, ACol, ARow, Rect);
end;

procedure TForm1.GridListsDblClick(Sender: TObject);
begin
  if Trim(ProjectNumber) = '' then
  begin
    MyTextMessage('Предупреждение',
      'Для начала работы необходимо выбрать/создать проект.', 1);
    exit;
  end;
  DblClickLists := true;
end;

procedure TForm1.GridListsMouseUpPlaylists(X, Y: Integer);
var
  i, lft, rgt, cl, cnt, ps: Integer;
  clpid: string;
begin
  try
    WriteLog('MAIN', 'TForm1.GridListsMouseUpPlaylists');
    i := GridColX(GridLists, X);
    if (GridLists.RowCount = 2) and (GridLists.Row = 1) and
      ((GridLists.Objects[0, 1] as TGridRows).ID = -1) then
      exit;
    if GridLists.Objects[0, GridLists.Row] is TGridRows then
    begin
      if i = 3 then
      begin
        // =========================================
        if (RowDownGridLists <> GridLists.Row) and (RowDownGridLists > 0) and
          (GridLists.Row > 0) then
        begin
          TempGridRow.Clear;
          TempGridRow.Assign
            ((GridLists.Objects[0, RowDownGridLists] as TGridRows));
          if GridLists.Row < RowDownGridLists then
          begin
            for cnt := RowDownGridLists downto GridLists.Row + 1 do
            begin
              (GridLists.Objects[0, cnt] as TGridRows)
                .Assign((GridLists.Objects[0, cnt - 1] as TGridRows));
            end;
          end
          else
          begin
            for cnt := RowDownGridLists to GridLists.Row - 1 do
            begin
              (GridLists.Objects[0, cnt] as TGridRows)
                .Assign((GridLists.Objects[0, cnt + 1] as TGridRows));
            end;
          end;
          (GridLists.Objects[0, GridLists.Row] as TGridRows)
            .Assign(TempGridRow);
          GridLists.Repaint;
        end;
        RowDownGridLists := -1;
        // =========================================
        if DblClickLists then
        begin
          if GridLists.Row > 0 then
          begin
            if (GridLists.Objects[0, GridLists.Row] is TGridRows) then
            begin
              if (GridLists.Objects[0, GridLists.Row] as TGridRows).ID = 0 then
                EditPlayList(-1)
              else
                EditPlayList(GridLists.Row);
            end;
          end;
        end;
        DblClickLists := FALSE;
        GridLists.Repaint;
        exit;
      end;
      if (GridLists.Objects[0, GridLists.Row] as TGridRows).ID <= 0 then
        exit;
      case i of
        0, 1:
          (GridLists.Objects[0, GridLists.Row] as TGridRows).MyCells[i].Mark :=
            not(GridLists.Objects[0, GridLists.Row] as TGridRows)
            .MyCells[i].Mark;
        2:
          begin
            for i := 1 to GridLists.RowCount - 1 do
              (GridLists.Objects[0, i] as TGridRows).MyCells[2].Mark := FALSE;
            (GridLists.Objects[0, GridLists.Row] as TGridRows).MyCells[2]
              .Mark := true;
            ps := ListBox1.ItemIndex;
            if ps <> -1 then
            begin
              if (ListBox1.Items.Objects[ps] is TMyListBoxObject) then
              begin
                clpid := Trim
                  ((ListBox1.Items.Objects[ps] as TMyListBoxObject).ClipId);
                // if clpid<>'' then SaveGridToFile(clpid,GridActPlayList);
              end;
            end;
            ListBox1.Clear;
            for i := 1 to GridLists.RowCount - 1 do
            begin
              ListBox1.Items.Add((GridLists.Objects[0, i] as TGridRows)
                .MyCells[3].ReadPhrase('Name'));
              ps := ListBox1.Items.Count - 1;
              if not(ListBox1.Items.Objects[ps] is TMyListBoxObject) then
                ListBox1.Items.Objects[ps] := TMyListBoxObject.Create;
              (ListBox1.Items.Objects[ps] as TMyListBoxObject).ClipId :=
                (GridLists.Objects[0, i] as TGridRows).MyCells[3]
                .ReadPhrase('Note');
            end;
            ps := GridLists.Row; //
            if ps <> -1 then
            begin
              ListBox1.ItemIndex := ps - 1;
              // ListBox1Click(nil)
              // cbPlayListsChange(nil);
              // cbPlayLists.ItemIndex:=ps-1;
              // //PlaylistToPanel(GridLists.Row);
              // if FileExists(PathPlayLists + '\' + (cbPlayLists.Items.Objects[ps-1] as TMyListBoxObject).ClipId) then begin
              // LoadGridFromFile(PathPlayLists + '\' + Form1.lbPLName.Caption, GridActPlayList);
              // CheckedActivePlayList;
              // end;
            end
            else
              GridClear(GridActPlayList, RowGridClips);
            if DblClickLists then
            begin
              DblClickLists := FALSE;
              sbPlayListClick(nil);
            end;
          end;
      end; // case
    end; // if
    GridLists.Repaint;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridListsMouseUpPlaylists | ' + E.Message);
  end;
end;

procedure TForm1.GridListsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  try
    if Trim(ProjectNumber) = '' then
    begin
      MyTextMessage('Предупреждение',
        'Для начала работы необходимо выбрать/создать проект.', 1);
      exit;
    end;
    GridListsMouseUpPlaylists(X, Y);
    IsProjectChanges := true;
    // SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridListsMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgButtonsProjectMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  if Button <> mbLeft then
    exit;
  i := pnlprojects.ClickButton(imgButtonsProject.Canvas, X, Y);
  ButtonsControlProjects(i);
  IsProjectChanges := true;
end;

procedure TForm1.GridProjectsTopLeftChanged(Sender: TObject);
begin
  // GridProjects.LeftCol:=0;
end;

procedure TForm1.GridTimeLinesDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  try
    GridDrawCellTimeline(GridTimeLines, ACol, ARow, Rect, State);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridTimeLinesDrawCell ACol=' + inttostr(ACol) +
        ' ARow=' + inttostr(ARow) + ' | ' + E.Message);
  end;
end;

procedure TForm1.GridTimeLinesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.GridTimeLinesTopLeftChanged(Sender: TObject);
var
  clrw: Integer;
begin
  clrw := GridTimeLines.Height div GridTimeLines.DefaultRowHeight;
  if (GridTimeLines.DefaultRowHeight * GridTimeLines.RowCount) < GridTimeLines.Height
  then
    GridTimeLines.TopRow := 1;

end;

procedure TForm1.imgButtonsControlProj1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  s: string;
  i, res, ps, cnt: Integer;
  nm: string;
  ID: longint;
  cntmrk, cntdel: Integer;
begin
  try
    if Trim(ProjectNumber) = '' then
    begin
      MyTextMessage('Предупреждение',
        'Для начала работы необходимо выбрать/создать проект.', 1);
      exit;
    end;
    if Button <> mbLeft then
      exit;
    res := pnlprojcntl.ClickButton(imgButtonsControlProj.Canvas, X, Y);
    ButtonControlLists(res);
    // ssssjson
          PutGridTimeLinesToServer(Form1.GridTimeLines);

    IsProjectChanges := true;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.imgButtonsControlProj1MouseUp X=' + inttostr(X) +
        ' Y=' + inttostr(Y) + ' | ' + E.Message);
  end;
end;

procedure TForm1.GridTimeLinesDblClick(Sender: TObject);
begin
  if Trim(ProjectNumber) = '' then
  begin
    MyTextMessage('Предупреждение',
      'Для начала работы необходимо выбрать/создать проект.', 1);
    exit;
  end;
  EditTimeline(GridTimeLines.Selection.Top);
  GridTimeLines.Repaint;
  IsProjectChanges := true;
end;

procedure TForm1.pnMovieMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
end;

procedure TForm1.pnMovieResize(Sender: TObject);
begin
  if not fileexists(Form1.lbPlayerFile.Caption) then
    exit;
  pnMovie.Width := (pnMovie.Height div 9) * 16;
  if vlcmode = play then
  begin
    // pVideoWindow.SetWindowPosition(0,0,pnMovie.ClientRect.Right,pnMovie.ClientRect.Bottom);
  end;
end;

procedure TForm1.imgButtonsControlProj1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  pos: Integer;
begin
  pnlprojcntl.MouseMove(imgButtonsControlProj.Canvas, X, Y);

end;

procedure TForm1.imgButtonsProjectMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  pos: Integer;
begin
  pnlprojects.MouseMove(imgButtonsProject.Canvas, X, Y);

end;

procedure TForm1.imgCTLPrepare1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, j, res, ps: Integer;
  crpos: TEventReplay;
  tmpos: longint;
  bl: Boolean;
begin
  try
    WriteLog('MAIN', 'TForm1.imgCTLPrepare1MouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    res := btnspanel1.ClickButton(imgCTLPrepare1.Canvas, X, Y);
    ControlButtonsPrepare(res);
    IsProjectChanges := true;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.imgCTLPrepare1MouseUp | ' + E.Message);
  end;
end;

procedure TForm1.ImgDevicesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MouseInLayer2 := FALSE;
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.imgCTLPrepare1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnspanel1.MouseMove(imgCTLPrepare1.Canvas, X, Y);
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.imgTLNamesMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: TTLNResult;
  s: string;
begin
  try
    WriteLog('MAIN', 'TForm1.imgTLNamesMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    imgTLNames.Canvas.Lock;
    SaveToUNDO;
    res := ZoneNames.ClickTTLNames(imgTLNames.Canvas,
      Form1.GridTimeLines, X, Y);
    ZoneNames.Draw(imgTLNames.Canvas, Form1.GridTimeLines, FALSE);
    imgTLNames.Canvas.Unlock;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.imgTLNamesMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgpnlbtnsplMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlbtnspl.MouseMove(imgpnlbtnspl.Canvas, X, Y);
end;

procedure TForm1.imgpnlbtnsplMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, res: Integer;
begin
  try
    WriteLog('MAIN', 'TForm1.imgpnlbtnsplMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    res := pnlbtnspl.ClickButton(imgpnlbtnspl.Canvas, X, Y);
    ButtonsControlPlayList(res);
    IsProjectChanges := true;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.imgpnlbtnsplMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgpntlprojMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.ImgStartWinBtnMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnstartpnl.MouseMove(ImgStartWinBtn.Canvas, X, Y);
end;

procedure TForm1.ImgStartWinBtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
begin
  res := btnstartpnl.ClickButton(imgpnlbtnsclips.Canvas, X, Y);
  if res = 0 then
    Form1.Close;
end;

procedure TForm1.imgpnlbtnsclipsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlbtnsclips.MouseMove(imgpnlbtnsclips.Canvas, X, Y);
end;

procedure TForm1.imgpnlbtnsclipsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, res: Integer;
  nm: string;
  ps, cntmrk, cntdel: Integer;
begin
  try
    WriteLog('MAIN', 'TForm1.imgpnlbtnsclipsMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    res := pnlbtnsclips.ClickButton(imgpnlbtnsclips.Canvas, X, Y);
    ButtonsControlClipsPanel(res);
    IsProjectChanges := true;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.imgpnlbtnsclipsMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgDeviceTLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsdevicepr.MouseMove(imgDeviceTL.Canvas, X, Y);
end;

procedure TForm1.imgDeviceTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res, ps: Integer;
  crpos: TEventReplay;
begin
  IsProjectChanges := true;
  try
    WriteLog('MAIN', 'TForm1.imgDeviceTLMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    if Button <> mbLeft then
      exit;
    // if trim(Label2.Caption)='' then exit;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then
    begin
      frLock.ShowModal;
      exit;
    end;
    SaveToUNDO;
    res := btnsdevicepr.ClickButton(imgDeviceTL.Canvas, X, Y);
    if res = -1 then
      exit;
    InsertEventToEditTimeline(res);
    crpos := TLZone.TLEditor.CurrentEvents;
    if crpos.Number <> -1 then
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
        'imgDeviceTLMouseUp-1')
    else
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
        'imgDeviceTLMouseUp-2');
    TemplateToScreen(crpos);
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.imgDeviceTLMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgEventsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.imgTLNamesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MouseInLayer2 := FALSE;
  ZoneNames.MoveMouse(imgTLNames.Canvas, Form1.GridTimeLines, X, Y);
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  rs, res: Integer;
  s: string;
begin
  try
    if Msg.Message = WM_KEYUP then
    begin
      rs := Msg.lParam;
      res := Msg.wParam;
      s := inttostr(res);
    end;
    if Msg.Message = WM_MOUSEWHEEL then
    begin
      if Msg.lParam < 0 then
      begin
        s := inttostr(res);
      end
      else
      begin
        if vlcmode = play then
          exit;
        if MouseInLayer2 then
        begin
          if Msg.wParam > Msg.lParam then
            ControlPlayerFastSlow(3)
          else
            ControlPlayerFastSlow(0);
          TLZone.TLEditor.EventsSelectFalse;
          TLZone.TLEditor.AllSelectFalse;
          TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
          // application.ProcessMessages;
          // Msg.wParam:=0;
          // msg.lParam:=0;
          imgTimelines.Repaint;
        end;
      end
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.ApplicationEvents1Message | ' + E.Message);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // UnregisterHotKey(Handle, Ord('1'));
  // UnregisterHotKey(Handle, 2001);
  // CoUninitialize;// деинициализировать OLE
  bmptimeline.Free;
  bmpEvents.Free;
  bmpAirDevices.Free;
  GridTimeLines.FreeOnRelease;
  if MyMainMenu <> nil then
    MyMainMenu.FreeInstance;
  if TempMenu <> nil then
    TempMenu.FreeInstance;
  if InputPopUpMenu <> nil then
    InputPopUpMenu.FreeInstance;
  if MenuListFiles <> nil then
    MenuListFiles.FreeInstance;
  UnmapViewOfFile(Compartido);
  CloseHandle(FicheroM);
  if ClpText <> nil then
    ClpText.FreeInstance;
  if ClpTime <> nil then
    ClpTime.FreeInstance;
  if APlText <> nil then
    APlText.FreeInstance;
  if APlTime <> nil then
    APlTime.FreeInstance;
end;

procedure TForm1.imgMediaTLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsmediatl.MouseMove(imgMediaTL.Canvas, X, Y);
end;

procedure TForm1.imgMediaTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ps, res: Integer;
  crpos: TEventReplay;
begin
  try
    WriteLog('MAIN', 'TForm1.imgMediaTLMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    res := btnsmediatl.ClickButton(imgMediaTL.Canvas, X, Y);
    ButtonsControlMedia(res);
    // ssssjson
          PutGridTimeLinesToServer(Form1.GridTimeLines);

    IsProjectChanges := true;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.imgMediaTLMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgPLTlCurrMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  APLCurr.MouseMove(imgPLTlCurr.Canvas, X, Y);
  APLCurr.Draw(imgPLTlCurr.Canvas);
  imgPLTlCurr.Repaint;
end;

procedure TForm1.imgPLTlCurrMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res, cnt: Integer;
begin
  try
    res := APLCurr.MouseMove(imgPLTlCurr.Canvas, X, Y);
    APLCurr.Draw(imgPLTlCurr.Canvas);
    imgPLTlCurr.Repaint;
    if (res = 0) or (res = 1) then
    begin
      if ListBox1.Visible then
      begin
        ListBox1.Visible := FALSE;
        WriteLog('MAIN', 'TForm1.imgPLTlCurrMouseUp ListBox1.Visible := false');
        exit;
      end;
      ListBox1.Left := imgPLTlCurr.Left + 5;
      ListBox1.Width := imgPLTlCurr.Width - 10;
      ListBox1.Top := imgPLTlCurr.Top + imgPLTlCurr.Height - 5;

      if ListBox1.Items.Count <= 10 then
      begin
        if ListBox1.Items.Count <= 0 then
          cnt := 1
        else
          cnt := ListBox1.Items.Count;
      end
      else
        cnt := 10;

      ListBox1.Height := cnt * ListBox1.ItemHeight + 10;
      ListBox1.Visible := true;
      WriteLog('MAIN', 'TForm1.imgPLTlCurrMouseUp ListBox1.Visible := true');
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.SpeedButton3Click | ' + E.Message);
  end;
end;

procedure TForm1.GridListsTopLeftChanged(Sender: TObject);
begin
  GridLists.LeftCol := 0;
end;

procedure TForm1.imgClpFindStrMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ClpText.MouseMove(imgClpFindStr.Canvas, X, Y);
  ClpText.Draw(imgClpFindStr.Canvas);
  imgClpFindStr.Repaint;
end;

procedure TForm1.imgClpFindStrMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
  s: ansistring;
begin
  res := ClpText.MouseClick(imgClpFindStr.Canvas, X, Y);
  if res <> -1 then
  begin
    ClpTime.Select := FALSE;
    ClpText.Select := true;
  end;
  case res of
    0:
      begin
        ClpText.direction := not ClpText.direction;
        s := ClpText.Text;
        s := ansilowercase(Trim(s));
        if s = 'клип' then
          SortGridAlphabet(GridClips, 1, 3, 'Clip', ClpText.direction)
        else if s = 'песня' then
          SortGridAlphabet(GridClips, 1, 3, 'Song', ClpText.direction)
        else if s = 'исполнитель' then
          SortGridAlphabet(GridClips, 1, 3, 'Singer', ClpText.direction);
      end;
    1:
      begin
        TempMenu.Clear;
        pnTempMenu.Top := PanelControl.Height + pnClpFindStr.Top +
          pnClpFindStr.Height - (pnAPlFindSTR.Height - 18) div 2;
        TempMenu.rowheight := 22;
        pnTempMenu.Height := TempMenu.rowheight * 3 + 2;
        pnTempMenu.Left := pnClpFindStr.Left;
        pnTempMenu.Width := pnClpFindStr.Width;
        imgTempMenu.Picture.Bitmap.Width := pnTempMenu.Width;
        imgTempMenu.Picture.Bitmap.Height := pnTempMenu.Height;

        TempMenu.Add('Клип', 1);
        TempMenu.Add('Песня', 2);
        TempMenu.Add('Исполнитель', 3);
        // TempMenu.rowheight:=18;
        TempMenu.Draw(imgTempMenu.Canvas);
        imgTempMenu.Repaint;
        pnTempMenu.Visible := true;
      end;
  end;
  ClpTime.Draw(imgClpFindTime.Canvas);
  imgClpFindTime.Repaint;
  ClpText.Draw(imgClpFindStr.Canvas);
  imgClpFindStr.Repaint;
  GridClips.Repaint;
end;

procedure TForm1.imgClpFindTimeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ClpTime.MouseMove(imgClpFindTime.Canvas, X, Y);
  ClpTime.Draw(imgClpFindTime.Canvas);
  imgClpFindTime.Repaint;
end;

procedure TForm1.imgClpFindTimeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
  s: string;
begin
  res := ClpTime.MouseClick(imgClpFindTime.Canvas, X, Y);
  if res <> -1 then
  begin
    ClpTime.Select := true;
    ClpText.Select := FALSE;
  end;
  case res of
    0:
      begin
        ClpTime.direction := not ClpTime.direction;
        s := ClpTime.Text;
        s := ansilowercase(Trim(s));
        if s = 'время старта' then
          SortGridStartTime(GridClips, not ClpTime.direction)
        else if s = 'хр-ж медиа' then
          SortGridTime(GridClips, 1, 3, 'Duration', ClpTime.direction)
        else if s = 'хр-ж воспр.' then
          SortGridTime(GridClips, 1, 3, 'Dur', ClpTime.direction);
      end;
    1:
      begin
        TempMenu.Clear;
        pnTempMenu.Top := PanelControl.Height + pnClpFindTime.Top +
          pnClpFindTime.Height - (pnAPlFindSTR.Height - 18) div 2;
        TempMenu.rowheight := 22;
        pnTempMenu.Height := TempMenu.rowheight * 3 + 2;
        pnTempMenu.Left := pnClpFindTime.Left;
        pnTempMenu.Width := pnClpFindTime.Width;
        imgTempMenu.Picture.Bitmap.Width := pnTempMenu.Width;
        imgTempMenu.Picture.Bitmap.Height := pnTempMenu.Height;

        TempMenu.Add('Время старта', 5);
        TempMenu.Add('Хр-ж медиа', 6);
        TempMenu.Add('Хр-ж воспр.', 7);
        // TempMenu.rowheight:=18;
        TempMenu.Draw(imgTempMenu.Canvas);
        imgTempMenu.Repaint;
        pnTempMenu.Visible := true;
      end;
  end;
  ClpTime.Draw(imgClpFindTime.Canvas);
  imgClpFindTime.Repaint;
  ClpText.Draw(imgClpFindStr.Canvas);
  imgClpFindStr.Repaint;
  GridClips.Repaint;
end;

procedure TForm1.imgCTLBottomLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsctlleft.MouseMove(imgCTLBottomL.Canvas, X, Y);
end;

procedure SetMediaButtons;
var
  i: Integer;
begin
  try
    if (vlcmode = play) then
    begin
      for i := 0 to 3 do
        btnsctlleft.Rows[0].Btns[i].Visible := FALSE;
      btnsctlleft.Rows[0].Btns[5].LoadBMPFromRes(impause);
      btnsctlleft.Rows[0].Btns[5].UpdateColorBitmap(clWhite, ProgrammFontColor);
    end
    else
    begin
      for i := 0 to 3 do
        btnsctlleft.Rows[0].Btns[i].Visible := true;
      btnsctlleft.Rows[0].Btns[5].LoadBMPFromRes(imforward);
      btnsctlleft.Rows[0].Btns[5].UpdateColorBitmap(clWhite, ProgrammFontColor);
    end;
    btnsctlleft.Draw(Form1.imgCTLBottomL.Canvas);
  except
    on E: Exception do
      WriteLog('MAIN', 'UMain.SetMediaButtons | ' + E.Message);
  end;
end;

procedure TForm1.imgCTLBottomLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, res: Integer;
  crpos: TEventReplay;
  posi: longint;
  dur, pst: Int64;
begin
  try
    WriteLog('MAIN', 'TForm1.imgCTLBottomLMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    res := btnsctlleft.ClickButton(imgCTLBottomL.Canvas, X, Y);
    case res of
      0 .. 3:
        begin
          ControlPlayerTransmition(res);
          // if vlcplayer.p_mi<>nil then begin
          // if libvlc_media_player_get_state(vlcplayer.p_mi)=libvlc_Ended then begin
          // dur := vlcplayer.Duration;
          // pst := vlcplayer.Time;
          // if pst<dur then vlcplayer.SetTime(TLParameters.Position*40);
          // vlcplayer.Pause;
          // end;
          // end;
        end;
      5:
        begin
          if vlcmode <> play then
          begin
            // if Not FileExists(lbPlayerFile.Caption) then begin
            // MyTextMessage('Сообщение','Не найден ассоциируемый с клипом файл:' +#10#13
            // + lbPlayerFile.Caption + #10#13 + 'возможно файл был удален с диска.',1);
            // EraseClipInWinPrepare(lbActiveClipID.Caption);
            // mode:=paused;
            // MediaPause;
            // exit;
            // end;
            TLZone.TLEditor.AllSelectFalse;
            TLZone.TLEditor.EventsSelectFalse;
            TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
            // TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
          end;
          // if trim(Form1.lbPlayerFile.Caption)='' then exit;
          if PanelPrepare.Visible then
            ActiveControl := PanelPrepare;
          ControlPlayer;
        end;
    end; // case
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.imgCTLBottomLMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgCtlBottomRMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
  crpos: TEventReplay;
begin
  try
    WriteLog('MAIN', 'TForm1.imgCtlBottomRMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    res := btnsctlright.ClickButton(imgCtlBottomR.Canvas, X, Y);
    ControlPlayerFastSlow(res);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.imgCtlBottomRMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgCtlBottomRMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsctlright.MouseMove(imgCtlBottomR.Canvas, X, Y);
end;

procedure TForm1.GridClipsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  try
    GridDrawMyCell(GridClips, ACol, ARow, Rect);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridClipsDrawCell | ' + E.Message);
  end;
end;

procedure TForm1.GridClipsDblClick(Sender: TObject);
begin
  DblClickClips := true;
end;

procedure TForm1.GridClipsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridClipsToPanel(ARow);
end;

procedure TForm1.GridClipsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, lft, rgt, cl, cnt, rw: Integer;
  txt, clpid: string;
  ps: tpoint;
begin
  IsProjectChanges := true;
  try
    WriteLog('MAIN', 'TForm1.GridClipsMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    i := GridColX(GridClips, X);
    rw := GridClickRow(GridClips, Y);
    if rw = 0 then
      exit;
    if GridClips.Objects[0, GridClips.Row] is TGridRows then
    begin
      if i = 3 then
      begin
        // =========================================
        if (RowDownGridClips <> GridClips.Row) and (RowDownGridClips > 0) and
          (GridClips.Row > 0) then
        begin
          TempGridRow.Clear;
          TempGridRow.Assign
            ((GridClips.Objects[0, RowDownGridClips] as TGridRows));
          if GridClips.Row < RowDownGridClips then
          begin
            for cnt := RowDownGridClips downto GridClips.Row + 1 do
            begin
              (GridClips.Objects[0, cnt] as TGridRows)
                .Assign((GridClips.Objects[0, cnt - 1] as TGridRows));
              UpdateClipDataInWinPrepare(GridClips, cnt,
                (GridClips.Objects[0, cnt] as TGridRows).MyCells[3]
                .ReadPhrase('ClipID'));
            end;
          end
          else
          begin
            for cnt := RowDownGridClips to GridClips.Row - 1 do
            begin
              (GridClips.Objects[0, cnt] as TGridRows)
                .Assign((GridClips.Objects[0, cnt + 1] as TGridRows));
              UpdateClipDataInWinPrepare(GridClips, cnt,
                (GridClips.Objects[0, cnt] as TGridRows).MyCells[3]
                .ReadPhrase('ClipID'));
            end;
          end;
          (GridClips.Objects[0, GridClips.Row] as TGridRows)
            .Assign(TempGridRow);
          UpdateClipDataInWinPrepare(GridClips, GridClips.Row,
            (GridClips.Objects[0, GridClips.Row] as TGridRows).MyCells[3]
            .ReadPhrase('ClipID'));
          GridClips.Repaint;
        end;
        RowDownGridClips := -1;
        // GridClipsToPanel(GridClips.Row);
        // =========================================
        if DblClickClips then
        begin
          if GridClips.Row > 0 then
          begin
            if (GridClips.Objects[0, GridClips.Row] is TGridRows) then
            begin
              if (GridClips.Objects[0, GridClips.Row] as TGridRows).ID = 0 then
                EditClip(-1)
              else
              begin
                EditClip(GridClips.Row);
                UpdateClipDataInWinPrepare(GridClips, GridClips.Row,
                  (GridClips.Objects[0, GridClips.Row] as TGridRows)
                  .MyCells[3].ReadPhrase('ClipID'));
              end;
              // SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
            end;
          end;
        end;
        DblClickClips := FALSE;
        CheckedActivePlayList;
        GridClipsToPanel(GridClips.Row);
        exit;
      end;
      if (GridClips.Objects[0, GridClips.Row] as TGridRows).ID <= 0 then
        exit;
      case i of
        0, 1:
          (GridClips.Objects[0, GridClips.Row] as TGridRows).MyCells[i].Mark :=
            not(GridClips.Objects[0, GridClips.Row] as TGridRows)
            .MyCells[i].Mark;
        2:
          begin
            GridPlayer := grClips;
            if MySynhro.Checked then
            begin
              if MyTextMessage('Предупреждение',
                'Установлен режим синхронизации по времени.' + #13#10 +
                'В случае продолжения режим синхронизации будет отменен.' +
                #13#10 + #13#10 + 'Продолжить?', 2) then
              begin
                GridPlayerRow := GridClips.Row;
                MySynhro.Checked := FALSE;
                if (GridClips.Objects[0, GridClips.Row] is TGridRows) then
                  PlayClipFromClipsList;
              end;
            end
            else
            begin
              GridPlayerRow := GridClips.Row;
              if (GridClips.Objects[0, GridClips.Row] is TGridRows) then
                PlayClipFromClipsList;
            end;
          end;
      end; // case
      PredClipID := (GridClips.Objects[0, GridClips.Row] as TGridRows)
        .MyCells[3].ReadPhrase('ClipID');
      CheckedActivePlayList;
      GridClipsToPanel(GridClips.Row);
    end; // if
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridClipsMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.GridActPlayListDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  try
    GridDrawMyCell(GridActPlayList, ACol, ARow, Rect);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridActPlayListDrawCell | ' + E.Message);
  end;
end;

// end;

procedure TForm1.sbPredClipClick(Sender: TObject);
var
  rw: Integer;
begin
  if Trim(ProjectNumber) = '' then
  begin
    MyTextMessage('Предупреждение',
      'Для начала работы необходимо выбрать/создать проект.', 1);
    exit;
  end;
  if MySynhro.Checked then
  begin
    if MyTextMessage('Предупреждение', 'Установлен режим синхронизации.' +
      #13#10 + 'В случае продолжения установки клипа режим синхранизации будет отменен.'
      + #13#10 + 'Продолжить?', 2) then
    begin
      if Trim(Form1.lbActiveClipID.Caption) = '' then
        exit;
      rw := FindPredClipTime(GridActPlayList, now);
      MySynhro.Checked := FALSE;
      if rw <> -1 then
      begin
        GridPlayerRow := rw;
        LoadClipsToPlayer;
        pnTempMenu.Visible := FALSE;
      end;
    end;
  end
  else
  begin
    if Trim(Form1.lbActiveClipID.Caption) = '' then
      exit;
    LoadPredClipToPlayer;
    pnTempMenu.Visible := FALSE;
  end;
end;

procedure TForm1.sbPredClipMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  s, cl, tm: string;
  rw: Integer;
begin
  if PanelPrepare.Visible then
  begin
    if not pnTempMenu.Visible then
    begin
      pnTempMenu.Top := PanelControl.Height;
      pnTempMenu.Left := pnPrepareCTL.Width + sbPredClip.Left - 200;
      pnTempMenu.Width := sbPredClip.Width + 400;
      pnTempMenu.Height := 30;
      imgTempMenu.Width := pnTempMenu.Width;
      imgTempMenu.Height := pnTempMenu.Height;
      imgTempMenu.Picture.Bitmap.Width := imgTempMenu.Width;
      imgTempMenu.Picture.Bitmap.Height := imgTempMenu.Height;
      s := '';
      if not MySynhro.Checked then
      begin
        if GridPlayer = grPlayList then
        begin
          s := 'Плей-лист: ';
          if GridPlayerRow <= 0 then
            s := s + 'Не выбрано ни одного клипа из списка.';
          if (GridPlayerRow <= GridActPlayList.RowCount - 1) and
            (GridPlayerRow > 1) then
            s := s + (GridActPlayList.Objects[0, GridPlayerRow - 1]
              as TGridRows).MyCells[3].ReadPhrase('Clip');
        end
        else
        begin
          s := 'Список клипов: ';
          if GridPlayerRow <= 0 then
            s := s + 'Не выбрано ни одного клипа из списка.';
          if (GridPlayerRow <= GridClips.RowCount - 1) and (GridPlayerRow > 1)
          then
            s := s + (GridClips.Objects[0, GridPlayerRow - 1] as TGridRows)
              .MyCells[3].ReadPhrase('Clip');
        end;
      end
      else
      begin
        s := 'Плей-лист: ';
        rw := FindPredClipTime(GridActPlayList, now);
        if rw > 0 then
        begin
          cl := (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[3]
            .ReadPhrase('Clip');
          tm := (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[3]
            .ReadPhrase('StartTime');
          s := s + '[' + tm + '] ' + cl;
        end
        else
          s := s + 'Предыдущий клип не обнаружен';
      end;
      TempMenu.Clear;
      TempMenu.Add(s, 100);
      TempMenu.Draw(imgTempMenu.Canvas);
      imgTempMenu.Repaint;
      pnTempMenu.Visible := true;
    end;
  end;
end;

procedure TForm1.sbNextClipClick(Sender: TObject);
var
  rw: Integer;
begin
  if Trim(ProjectNumber) = '' then
  begin
    MyTextMessage('Предупреждение',
      'Для начала работы необходимо выбрать/создать проект.', 1);
    exit;
  end;
  if MySynhro.Checked then
  begin
    if MyTextMessage('Предупреждение', 'Установлен режим синхронизации.' +
      #13#10 + 'В случае продолжения установки клипа режим синхранизации будет отменен.'
      + #13#10 + 'Продолжить?', 2) then
    begin
      if Trim(Form1.lbActiveClipID.Caption) = '' then
        exit;
      rw := FindNextClipTime1(GridActPlayList, now);
      MySynhro.Checked := FALSE;
      if rw <> -1 then
      begin
        GridPlayerRow := rw;
        LoadClipsToPlayer;
        pnTempMenu.Visible := FALSE;
      end;
    end;
  end
  else
  begin
    if Trim(Form1.lbActiveClipID.Caption) = '' then
      exit;
    LoadNextClipToPlayer;
    pnTempMenu.Visible := FALSE;
  end;
end;

procedure TForm1.sbNextClipMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  s, cl, tm: string;
  rw: Integer;
begin
  if PanelPrepare.Visible then
  begin
    if not pnTempMenu.Visible then
    begin
      pnTempMenu.Top := PanelControl.Height;
      pnTempMenu.Left := pnPrepareCTL.Width + sbNextClip.Left - 200;
      pnTempMenu.Width := sbNextClip.Width + 400;
      pnTempMenu.Height := 30;
      imgTempMenu.Width := pnTempMenu.Width;
      imgTempMenu.Height := pnTempMenu.Height;
      imgTempMenu.Picture.Bitmap.Width := imgTempMenu.Width;
      imgTempMenu.Picture.Bitmap.Height := imgTempMenu.Height;
      s := '';
      if not MySynhro.Checked then
      begin
        if GridPlayer = grPlayList then
        begin
          s := 'Плей-лист: ';
          if GridPlayerRow <= 0 then
            s := s + 'Не выбрано ни одного клипа из списка.';
          if (GridPlayerRow <= GridActPlayList.RowCount - 2) and
            (GridPlayerRow > 0) then
            s := s + (GridActPlayList.Objects[0, GridPlayerRow + 1]
              as TGridRows).MyCells[3].ReadPhrase('Clip');
        end
        else
        begin
          s := 'Список клипов: ';
          if GridPlayerRow <= 0 then
            s := s + 'Не выбрано ни одного клипа из списка.';
          if (GridPlayerRow <= GridClips.RowCount - 2) and (GridPlayerRow > 0)
          then
            s := s + (GridClips.Objects[0, GridPlayerRow + 1] as TGridRows)
              .MyCells[3].ReadPhrase('Clip');
        end;
      end
      else
      begin
        s := 'Плей-лист: ';
        rw := FindNextClipTime1(GridActPlayList, now);
        if rw > 0 then
        begin
          cl := (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[3]
            .ReadPhrase('Clip');
          tm := (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[3]
            .ReadPhrase('StartTime');
          s := s + '[' + tm + '] ' + cl;
        end
        else
          s := s + 'Следующий клип не обнаружен';
      end;
      TempMenu.Clear;
      TempMenu.Add(s, 100);
      TempMenu.Draw(imgTempMenu.Canvas);
      imgTempMenu.Repaint;
      pnTempMenu.Visible := true;
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  hh, mm, ss, ms: Word;
  dt, tm: Double;
  Step: real;
begin
  try
    MyShift := Compartido^.Shift;
    TCExists := Compartido^.State;
    if not PanelPrepare.Visible then
    begin
      LBTimeCode1.Visible := true;
      if (not Compartido^.State) and (MySinhro = chltc) then
        LBTimeCode1.Caption := '*' + MyDateTimeToStr(now - TimeCodeDelta)
      else
        LBTimeCode1.Caption := '' + MyDateTimeToStr(now - TimeCodeDelta);
      PutJsonStrToServer('CTC',lbTimeCode1.SaveToJSONStr);

    end
    else
      LBTimeCode1.Visible := FALSE;
    if vlcmode <> play then
    begin
      if (not Compartido^.State) and (MySinhro = chltc) then
        lbCTLTimeCode.Caption := '*' + MyDateTimeToStr(now - TimeCodeDelta)
      else
        lbCTLTimeCode.Caption := '' + MyDateTimeToStr(now - TimeCodeDelta);
      PutJsonStrToServer('CTC',lbCTLTimeCode.SaveToJSONStr);
    end;
    Form1.Compartido^.Cadena := 'request';
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.Timer1Timer | ' + E.Message);
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  wnd: hwnd;
  buff: array [0 .. 127] of char;
begin
  if vlcmode = play then
    exit;
  application.ProcessMessages;
  // ListBox1.clear;
  wnd := GetWindow(Handle, gw_hwndfirst);
  while wnd <> 0 do
  begin // Не показываем:

    if (wnd <> application.Handle) // Собственное окно
      and IsWindowVisible(wnd) // Невидимые окна
      and (GetWindow(wnd, gw_owner) <> 0) // показываем только Дочерние окна
      and (GetWindowText(wnd, buff, SizeOf(buff)) <> 0) then
    begin
      GetWindowText(wnd, buff, SizeOf(buff));
      if not WindowInVisibleList(StrPas(buff)) then
        SetForegroundWindow(wnd);
      application.ProcessMessages;
      ListVisibleWindows.Add(StrPas(buff));
    end;
    wnd := GetWindow(wnd, gw_hwndnext);
  end;
end;

procedure TForm1.imgLayer2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  crpos: TEventReplay;
  rightlimit: longint;
  Step: real;
begin
  try
    try
      if TLParameters.Position < TLParameters.Preroll then
      begin
        TLParameters.Position := TLParameters.Preroll;
        PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
        // TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
        exit;
      end;
      rightlimit := TLParameters.Preroll + TLParameters.Duration +
        TLParameters.Postroll - (TLParameters.ScreenEndFrame -
        TLParameters.ScreenStartFrame) +
        TLParameters.MyCursor div TLParameters.FrameSize;
      if TLParameters.Position > rightlimit then
      begin
        TLParameters.Position := rightlimit;
        PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
        // TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
        exit;
      end;
      if (TLZone.DownTimeline) and (vlcmode <> play) then
      begin
        if not PanelAir.Visible then
        begin
          crpos := TLZone.TLEditor.CurrentEvents;
          if crpos.Number <> -1 then
            MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
              'imgLayer2MouseMove-1')
          else
            MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
              'imgLayer2MouseMove-1');
          TemplateToScreen(crpos);
          Image3.Repaint;
        end;
      end;

      if (TLZone.DownViewer) and (vlcmode <> play) then
      begin
        Step := trunc((TLParameters.Finish - TLParameters.Start) /
          Form1.imgTimelines.Width);
        TLParameters.Position := TLParameters.Position +
          trunc((X - TLZone.XViewer) * Step);
        PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
        TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
        TLZone.XViewer := X;
        SetClipTimeParameters;
        crpos := TLZone.TLEditor.CurrentEvents;
        if crpos.Number <> -1 then
          MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
            'imgLayer2MouseMove');
        TemplateToScreen(crpos);
        if Form1.pnImageScreen.Visible then
          Form1.Image3.Repaint;
        MediaSetPosition(TLParameters.Position, FALSE,
          'TForm1.imgLayer2MouseMove-1'); // 1
        TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
        MediaPause;
        SetClipTimeParameters;
        MyPanelAir.SetValues;
        if Form1.PanelAir.Visible then
        begin
          MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.imgEvents.Canvas,
            TLZone.TLEditor.Index);
          Form1.ImgDevices.Repaint;
          Form1.imgEvents.Repaint;
        end;
        Form1.imgTimelines.Repaint;
        exit;
      end;

      SetClipTimeParameters;

      TLZone.MoveMouseTimeline(imgLayer2.Canvas, Shift, X, Y);

    finally
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.imgLayer2MouseMove | ' + E.Message);
  end;
end;

procedure TForm1.imgLayer2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TLZone.DownZoneTimeLines(imgLayer2.Canvas, Button, Shift, X, Y);
end;

procedure TForm1.imgLayer2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if PanelPrepare.Visible then
    ActiveControl := PanelPrepare;
  TLZone.UPZoneTimeline(imgLayer2.Canvas, Button, Shift, X, Y);

end;

procedure TForm1.ImgListFilesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (X < 5) or (X > (ImgListFiles.Width - 5)) then
    MenuListFiles.SetNotSelet
  else
    MenuListFiles.MouseMove(ImgListFiles.Canvas, X, Y);
  MenuListFiles.Draw(ImgListFiles.Canvas);
  ImgListFiles.Repaint;
end;

procedure TForm1.ImgListFilesMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res, i, ps: Integer;
begin
  res := MenuListFiles.MouseClick(ImgListFiles.Canvas, X, Y);
  MenuListFiles.Draw(ImgListFiles.Canvas);
  ImgListFiles.Repaint;
  if res <> -1 then
  begin
  //SSSLOADPROJECT
    loadproject(true);
    FileNameProject := ListEditedProjects.Strings[res];
    ReadProjectFromFile(ListEditedProjects.Strings[res]);
    SaveDialog1.FileName := FileNameProject;
    PanelStartWindow.Visible := FALSE;
    EnableProgram;
    TLZone.ClearZone;
    Form1.lbActiveClipID.Caption := '';
    Label2Click(nil);
    SetMainGridPanel(projects);
    ClearClipsStatusPlay;
    ListBox1.Clear;
    for i := 1 to GridLists.RowCount - 1 do
    begin
      ListBox1.Items.Add((GridLists.Objects[0, i] as TGridRows).MyCells[3]
        .ReadPhrase('Name'));
      ps := ListBox1.Items.Count - 1;
      if not(ListBox1.Items.Objects[ps] is TMyListBoxObject) then
        ListBox1.Items.Objects[ps] := TMyListBoxObject.Create;
      (ListBox1.Items.Objects[ps] as TMyListBoxObject).ClipId :=
        (GridLists.Objects[0, i] as TGridRows).MyCells[3].ReadPhrase('Note');
    end;
    ps := UGrid.findgridselection(Form1.GridLists, 2);
    if ps > 0 then
    begin
      ListBox1.ItemIndex := ps - 1;
      ListBox1Click(nil);
    end;
    loadproject(false);
  //SSSLOADPROJECT
  end;
end;

procedure TForm1.ImgMainMenuMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if X >= ImgMainMenu.Width - 10 then
  begin
    pnMainMenu.Visible := FALSE;
    exit;
  end;
  if X <= 5 then
  begin
    pnMainMenu.Visible := FALSE;
    exit;
  end;
  if Y >= ImgMainMenu.Height - 10 then
  begin
    pnMainMenu.Visible := FALSE;
    exit;
  end;
  MyMainMenu.MouseMove(ImgMainMenu.Canvas, X, Y);
  MyMainMenu.Draw(ImgMainMenu.Canvas);
  ImgMainMenu.Repaint;
  // CreateMainMenu(imgMainMenu,Y);
end;

procedure TForm1.ImgMainMenuMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
begin
  // pnMainMenu.Visible:=false;
  // res:=ClickMainMenu(Y);
  res := MyMainMenu.MouseClick(ImgMainMenu.Canvas, X, Y);
  MyMainMenu.Draw(ImgMainMenu.Canvas);
  ImgMainMenu.Repaint;
  pnMainMenu.Visible := FALSE;
  case res of
    0:
      ButtonsControlProjects(2);
    1:
      ButtonsControlProjects(3);
    2:
      ButtonsControlProjects(4);
    3:
      ButtonsControlProjects(5);
    4:
      ButtonsControlProjects(0);
    5:
      ButtonsControlProjects(1);
    6:
      ButtonControlLists(0);
    7:
      ButtonControlLists(1);
    8:
      ButtonControlLists(2);
    9:
      EditListHotKeys;
    10:
      Close;
    11:
      SetOptions;
    12:
      ButtonsControlProjects(6);
  end;
  // pnMainMenu.Visible:=false;
end;

procedure TForm1.GridClipsTopLeftChanged(Sender: TObject);
begin
  GridClips.LeftCol := 0;
end;

procedure TForm1.imgAPlFindStrMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  APlText.MouseMove(imgAPlFindStr.Canvas, X, Y);
  APlText.Draw(imgAPlFindStr.Canvas);
  imgAPlFindStr.Repaint;
end;

procedure TForm1.imgAPlFindStrMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
  s: ansistring;
begin
  res := APlText.MouseClick(imgAPlFindStr.Canvas, X, Y);
  if res <> -1 then
  begin
    APlTime.Select := FALSE;
    APlText.Select := true;
  end;
  case res of
    0:
      begin
        APlText.direction := not APlText.direction;
        s := APlText.Text;
        s := ansilowercase(Trim(s));
        if s = 'клип' then
          SortGridAlphabet(GridActPlayList, 1, 3, 'Clip', APlText.direction)
        else if s = 'песня' then
          SortGridAlphabet(GridActPlayList, 1, 3, 'Song', APlText.direction)
        else if s = 'исполнитель' then
          SortGridAlphabet(GridActPlayList, 1, 3, 'Singer', APlText.direction);
      end;
    1:
      begin
        TempMenu.Clear;
        pnTempMenu.Top := PanelControl.Height + pnAPlFindSTR.Top +
          pnAPlFindSTR.Height - (pnAPlFindSTR.Height - 18) div 2;
        TempMenu.rowheight := 22;
        pnTempMenu.Height := TempMenu.rowheight * 3 + 2;
        pnTempMenu.Left := pnAPlFindSTR.Left;
        pnTempMenu.Width := pnAPlFindSTR.Width;
        imgTempMenu.Picture.Bitmap.Width := pnTempMenu.Width;
        imgTempMenu.Picture.Bitmap.Height := pnTempMenu.Height;

        TempMenu.Add('Клип', 10);
        TempMenu.Add('Песня', 11);
        TempMenu.Add('Исполнитель', 12);
        // TempMenu.rowheight:=18;
        TempMenu.Draw(imgTempMenu.Canvas);
        imgTempMenu.Repaint;
        pnTempMenu.Visible := true;
      end;
  end;
  APlTime.Draw(imgAPlFindTime.Canvas);
  imgAPlFindTime.Repaint;
  APlText.Draw(imgAPlFindStr.Canvas);
  imgAPlFindStr.Repaint;
  GridActPlayList.Repaint;
end;

procedure TForm1.imgAPlFindTimeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  res: Integer;
begin
  res := APlTime.MouseMove(imgAPlFindTime.Canvas, X, Y);
  APlTime.Draw(imgAPlFindTime.Canvas);
  imgAPlFindTime.Repaint;
end;

procedure TForm1.imgAPlFindTimeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
  s: ansistring;
begin
  res := APlTime.MouseClick(imgAPlFindTime.Canvas, X, Y);
  if res <> -1 then
  begin
    APlTime.Select := true;
    APlText.Select := FALSE;
    // APlTime.direction:=not APlTime.direction;
  end;
  case res of
    0:
      begin
        APlTime.direction := not APlTime.direction;
        s := APlTime.Text;
        s := ansilowercase(Trim(s));
        if s = 'время старта' then
          SortGridStartTime(GridActPlayList, not APlTime.direction)
        else if s = 'хр-ж медиа' then
          SortGridTime(GridActPlayList, 1, 3, 'Duration', APlTime.direction)
        else if s = 'хр-ж воспр.' then
          SortGridTime(GridActPlayList, 1, 3, 'Dur', APlTime.direction);
      end;
    1:
      begin
        TempMenu.Clear;
        pnTempMenu.Top := PanelControl.Height + pnAPlFindTime.Top +
          pnAPlFindTime.Height - (pnAPlFindSTR.Height - 18) div 2;
        TempMenu.rowheight := 22;
        pnTempMenu.Height := TempMenu.rowheight * 3 + 2;
        pnTempMenu.Left := pnAPlFindTime.Left;
        pnTempMenu.Width := pnAPlFindTime.Width;
        imgTempMenu.Picture.Bitmap.Width := pnTempMenu.Width;
        imgTempMenu.Picture.Bitmap.Height := pnTempMenu.Height;

        TempMenu.Add('Время старта', 15);
        TempMenu.Add('Хр-ж медиа', 16);
        TempMenu.Add('Хр-ж воспр.', 17);
        // TempMenu.rowheight:=18;
        TempMenu.Draw(imgTempMenu.Canvas);
        imgTempMenu.Repaint;
        pnTempMenu.Visible := true;
      end;
  end;
  APlTime.Draw(imgAPlFindTime.Canvas);
  imgAPlFindTime.Repaint;
  APlText.Draw(imgAPlFindStr.Canvas);
  imgAPlFindStr.Repaint;
  GridActPlayList.Repaint;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i, oldcount: Integer;
  clpid: string;
begin
  // if mode=play then
  try
    FrSaveProject.Label1.Caption := '';
    FrSaveProject.Label2.Caption := 'Закрываем все открытые процессы';
    FrSaveProject.ProgressBar1.Position := 0;
    FrSaveProject.Show;
    application.ProcessMessages;
    MySynhro.Checked := FALSE;
    StopMyTimer;
    MediaStop;
    VLCPlayer.Stop;
    while VLCPlayer.PlayerReady do
    begin
      FrSaveProject.ProgressBar1.Position :=
        FrSaveProject.ProgressBar1.Position + 2;
      FrSaveProject.Show;
      application.ProcessMessages;
    end;
    VLCPlayer.Release;
    VLCPlayer.Destroy;
    DeleteFilesMask(PathTemp, '*.*');
    ClearUNDO;
    WriteMyIniFile;
    if IsProjectChanges or (not(Trim(FileNameProject) = '')) then
      if MyTextMessage('Вопрос', 'Сохранить текущий проект ' + FileNameProject +
        '?', 2) then
        SaveProject;
    WriteLog('MAIN', 'TForm1.FormClose');
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.FormClose | ' + E.Message);
  end;
  // application.Terminate;
end;

procedure TForm1.GridActPlayListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, lft, rgt, cl, cnt, rw: Integer;
  txt, clpid: string;
  ps: tpoint;
begin
  IsProjectChanges := true;
  try
    WriteLog('MAIN', 'TForm1.GridActPlayListMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    i := GridColX(GridActPlayList, X);

    rw := GridClickRow(GridActPlayList, Y);
    if rw = 0 then
      exit;

    // ++++++++++++++++++++++++++++++
    if Button = mbRight then
    begin
      if (rw <> -1) and (rw <> 0) then
      begin
        GridActPlayList.Row := GridActPlayList.TopRow + rw - 1;
        frSetTC.Top := (Form1.Height - Form1.ClientHeight - 2 *
          Form1.BevelWidth) + Form1.PanelControl.Height +
          GridActPlayList.RowHeights[0] + (GridActPlayList.Row - 1) *
          GridActPlayList.RowHeights[GridActPlayList.Row] - 5;
        if (frSetTC.Top + frSetTC.Height > Form1.Height) then
          frSetTC.Top := Form1.Height - frSetTC.Height;
        frSetTC.Left := GridActPlayList.Left + X;
        if (frSetTC.Left + frSetTC.Width + 10 > Form1.Width) then
          frSetTC.Left := Form1.Width - frSetTC.Width - 10;
        txt := (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
          .MyCells[3].ReadPhrase('StartTime');
        clpid := (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
          .MyCells[3].ReadPhrase('ClipID');
        txt := Trim(SetTimeCode(txt));
        (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
          .MyCells[3].updatephrase('StartTime', txt);
        if (Trim(lbActiveClipID.Caption) = Trim(clpid)) and (txt <> '') then
        begin
          MyStartPlay := StrTimeCodeToFrames(txt);
          MyStartReady := true;
          // Form1.MySynhro.Checked := true;
        end;
        (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
          .MyCells[3].updatephrase('StartTime', txt);
        ps := (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
          .MyCells[3].PositionName('StartTime');
        (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
          .MyCells[3].Rows[ps.X].Phrases[ps.Y].SubFontColor := clLime;
        (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
          .MyCells[3].updatephrase('TypeTTL', 'Время старта:');
        if ListBox1.ItemIndex <> -1 then
          SavePlayListFromGridToFile
            ((ListBox1.Items.Objects[ListBox1.ItemIndex]
            as TMyListBoxObject).ClipId);
        For i := 1 to GridClips.RowCount - 1 do
        begin
          if Trim((GridClips.Objects[0, i] as TGridRows).MyCells[3]
            .ReadPhrase('ClipID')) = Trim(clpid) then
          begin
            (GridClips.Objects[0, i] as TGridRows).MyCells[3].updatephrase
              ('StartTime', txt);
            break;
          end;
        end;
      end;
      Form1.GridActPlayList.Repaint;
      exit;
    end;
    // ++++++++++++++++++++++++++++++

    if GridActPlayList.Objects[0, GridActPlayList.Row] is TGridRows then
    begin
      if (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows).ID <= 0
      then
        exit;
      case i of
        1:
          (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
            .MyCells[i].Mark :=
            not(GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
            .MyCells[i].Mark;
        2:
          if (GridActPlayList.Objects[0, GridActPlayList.Row] is TGridRows) then
          begin
            GridPlayer := grPlayList;
            if MySynhro.Checked then
            begin
              if MyTextMessage('Предупреждение',
                'Установлен режим синхронизации по времени.' + #13#10 +
                'В случае продолжения режим синхронизации будет отменен.' +
                #13#10 + #13#10 + 'Продолжить?', 2) then
              begin
                MySynhro.Checked := FALSE;
                GridPlayerRow := GridActPlayList.Row;
                if (GridActPlayList.Objects[0, GridActPlayList.Row] is TGridRows)
                then
                  PlayClipFromActPlaylist;
              end;
            end
            else
            begin
              GridPlayerRow := GridActPlayList.Row;
              if (GridActPlayList.Objects[0, GridActPlayList.Row] is TGridRows)
              then
                PlayClipFromActPlaylist;
            end;

            // if (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhraseColor('Clip')=PhraseErrorColor then begin
            // txt := (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('File');
            // if MyTextMessage('Вопрос','Не найден соответсвующий клипу файл' + #10#13 + '''' +
            // txt + '''' + #10#13 + 'перейти в список клипов, чтобы' + #10#13 +
            // 'ассоциировать клип с файлом на диске?',2)
            // then SetMainGridPanel(clips) else exit;
            // end else
            // PlayClipFromActPlaylist;
          end;
        3:
          begin
            if (RowDownGridActPlayList <> GridActPlayList.Row) and
              (RowDownGridActPlayList > 0) and (GridActPlayList.Row > 0) then
            begin
              TempGridRow.Clear;
              TempGridRow.Assign
                ((GridActPlayList.Objects[0, RowDownGridActPlayList]
                as TGridRows));
              if GridActPlayList.Row < RowDownGridActPlayList then
              begin
                for cnt := RowDownGridActPlayList downto GridActPlayList.
                  Row + 1 do
                begin
                  (GridActPlayList.Objects[0, cnt] as TGridRows)
                    .Assign((GridActPlayList.Objects[0, cnt - 1] as TGridRows));
                  UpdateClipDataInWinPrepare(GridActPlayList, cnt,
                    (GridActPlayList.Objects[0, cnt] as TGridRows).MyCells[3]
                    .ReadPhrase('ClipID'));
                end;
              end
              else
              begin
                for cnt := RowDownGridActPlayList to GridActPlayList.Row - 1 do
                begin
                  (GridActPlayList.Objects[0, cnt] as TGridRows)
                    .Assign((GridActPlayList.Objects[0, cnt + 1] as TGridRows));
                  UpdateClipDataInWinPrepare(GridActPlayList, cnt,
                    (GridActPlayList.Objects[0, cnt] as TGridRows).MyCells[3]
                    .ReadPhrase('ClipID'));
                end;
              end;
              (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
                .Assign(TempGridRow);
              UpdateClipDataInWinPrepare(GridActPlayList, GridActPlayList.Row,
                (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
                .MyCells[3].ReadPhrase('ClipID'));
              GridActPlayList.Repaint;
            end;
            if GridActPlayList.Row > 0 then
              GridActvePLToPanel(GridActPlayList.Row);
            RowDownGridActPlayList := -1;
          end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridActPlayListMouseUp | ' + E.Message);
  end;
end;

function ShiftToStr(Shift: TShiftState; Key: Word): string;
begin
  Result := '';
  If (ssAlt In Shift) then
    Result := Result + 'ALT';
  IF (ssCtrl In Shift) then
    if Result <> '' then
      Result := Result + '+CTRL'
    else
      Result := 'CTRL';
  If (ssShift In Shift) then
    if Result <> '' then
      Result := Result + '+SHIFT'
    else
      Result := 'SHIFT';
  if Result <> '' then
    Result := Result + '+' + inttostr(Key)
  else
    Result := inttostr(Key);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i, ps, ARow, cnt, cnt1: Integer;
  crpos: TEventReplay;
  strp, endp: longint;
  txt, txt1, txt2: string;
  RZD, CMD, pcmd: Word;
begin
  try

    IF InputPanel.Visible then
    begin
      if Key = VK_RETURN then
        SpeedButton1Click(nil);
      WriteLog('MAIN', 'TForm1.FormKeyUp InputPanel.Visible Key=' +
        ShiftToStr(Shift, Key));
      exit;
    end;

    if PanelPrepare.Visible or PanelAir.Visible then
      RZD := 4
    else if PanelClips.Visible then
      RZD := 2
    else if PanelProject.Visible then
      RZD := 1
    else if PanelPlayList.Visible then
      RZD := 3;

    pcmd := GetHotKeysCommand(Key, Shift);
    CMD := WorkHotKeys.GetCommand(0, pcmd);

    // Клавиши переключения доступные во всех окнах

    case CMD of
      1:
        begin // 0|1|Открыть панель «Проекты»|SHIFT+Q
          WriteLog('MAIN', 'TForm1.FormKeyUp Form1.Visible Key=' +
            ShiftToStr(Shift, Key));
          if Form1.ActiveControl = RichEdit1 then
            exit;
          SetMainGridPanel(projects); // Shift + Q
          exit;
        end;
      2:
        begin // 0|2|Открыть панель «Клипы»|SHIFT+W
          WriteLog('MAIN', 'TForm1.FormKeyUp Form1.Visible Key=' +
            ShiftToStr(Shift, Key));
          if Form1.ActiveControl = RichEdit1 then
            exit;
          SetMainGridPanel(clips); // Shift + W
          exit;
        end;
      3:
        begin // 0|3|Открыть панель «Активный плей-лист»|SHIFT+E
          WriteLog('MAIN', 'TForm1.FormKeyUp Form1.Visible Key=' +
            ShiftToStr(Shift, Key));
          if Form1.ActiveControl = RichEdit1 then
            exit;
          sbPlayListClick(nil);
          exit; //
        end;
      4:
        begin // 0|4|Открыть панель «Подготовка»|SHIFT+R
          if Form1.ActiveControl = RichEdit1 then
            exit;
          CurrentMode := FALSE; // Shift + R
          lbMode.Caption := 'Подготовка';
          lbMode.Font.Color := ProgrammFontColor;
          CurrentImageTemplate := '@#@4433';
          Label2Click(nil);
          Form1.Repaint;
          WriteLog('MAIN', 'TForm1.FormKeyUp Form1.Visible Key=' +
            ShiftToStr(Shift, Key));
          exit;
        end;
      5:
        begin // 0|5|Открыть панель «Эфир»|SHIFT+T
          if Form1.ActiveControl = RichEdit1 then
            exit;
          CurrentMode := true; // Shift + T
          lbMode.Caption := 'Эфир';
          lbMode.Font.Color := clRed;
          Label2Click(nil);
          Form1.Repaint;
          WriteLog('MAIN', 'TForm1.FormKeyUp Form1.Visible Key=' +
            ShiftToStr(Shift, Key));
          exit;
        end;
    end;

    CMD := WorkHotKeys.GetCommand(RZD, pcmd);
    if CMD = $FFFF then
      exit;
    // Клавиши доступные во окне подготовки
    if PanelPrepare.Visible then
    begin
      WriteLog('MAIN', 'TForm1.FormKeyUp PanelPrepare.Visible Key=' +
        ShiftToStr(Shift, Key));
      if ActiveControl = RichEdit1 then
        exit;
      case CMD of
        29:
          begin // '4|29|Запустить/Остановить воспроизведение клипа|SPACE'
            if ActiveControl = MySynhro then
              ActiveControl := Panel7; // lbSynchRegim;
            try
              // if Rate<>1 then Rate:=1;
              ControlPlayer;
            except
              MyTextMessage('',
                'В плейер не загружен клип для воспроизведения.', 1);
            end;
            exit;
          end;
        30:
          begin // '4|30|На один кадр влево|LEFT'
            if vlcmode <> play then
              ControlPlayerFastSlow(1);
            exit;
          end;
        31:
          begin // '4|31|На один кадр вправо|RIGHT'
            if vlcmode <> play then
              ControlPlayerFastSlow(2);
            exit;
          end;
        32:
          begin // '4|32|В начало предыдущего клипа|SHIFT+LEFT'
            ControlPlayerTransmition(1);
            exit;
          end;
        33:
          begin // '4|33|В начало следующего клипа|SHIFT+RIGHT'
            ControlPlayerTransmition(2);
            exit;
          end;
        34:
          begin // '4|34|На десять кадров влево|CTRL+LEFT'
            if vlcmode <> play then
              ControlPlayerFastSlow(0);
            exit;
          end;
        35:
          begin // '4|35|На десять кадров вправо|CTRL+RIGHT'
            if vlcmode <> play then
              ControlPlayerFastSlow(3);
            exit;
          end;
        36:
          begin // '4|36|Перейти к точке начала воспроизведения|HOME'
            ControlPlayerTransmition(0);
            exit;
          end;
        37:
          begin // '4|37|Перейти в точку окончания воспроизведения|END'
            ControlPlayerTransmition(3);
            exit;
          end;
        38:
          begin // '4|38|Перейти в начало клипа|SHIFT+HOME'
            SaveToUNDO;
            TLParameters.Position := TLParameters.Preroll;
            PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            // TLParameters.ZeroPoint;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, '');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, FALSE,
              'TForm1.FormKeyUp Shift+Home');
            TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.imgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.imgEvents.Repaint;
            end;
            exit;
          end;
        39:
          begin // '4|39|Перейти в конец клипа |SHIFT+END'
            SaveToUNDO;
            TLParameters.Position := TLParameters.Preroll +
              TLParameters.Duration;
              PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'TForm1.FormKeyUp');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, FALSE,
              'TForm1.FormKeyUp Shift+End');
            TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.imgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.imgEvents.Repaint;
            end;
            exit;
          end;
        40:
          begin // '4|40|Отменить предыдущее действие|CTRL+Z'
            ControlButtonsPrepare(10); // Ctrl + Z
            exit;
          end;
        41:
          begin // '4|41|Уменьшить скорость воспроизведения в 2 раза|CTRL+<'
            if vlcmode = play then
              ControlPlayerFastSlow(1);
            exit;
          end;
        42:
          begin // '4|42|Увеличить скорость воспроизведения в 2 раза|CTRL+>'
            if vlcmode = play then
              ControlPlayerFastSlow(2);
            exit;
          end;
        43:
          begin // '4|43|Уменьшить скорость воспроизведения в 4 раза|SHIFT+<'
            if vlcmode = play then
              ControlPlayerFastSlow(0);
            exit;
          end;
        44:
          begin // '4|44|Увеличить скорость воспроизведения в 4 раза|SHIFT+>'
            if vlcmode = play then
              ControlPlayerFastSlow(3);
            exit;
          end;
        45:
          begin // '4|45|Подтянуть границу события находящуюся слева от курсора|C'
            ControlButtonsPrepare(0);
            exit;
          end;
        46:
          begin // '4|46|Подтянуть границу события находящуюся справа от курсора|V'
            ControlButtonsPrepare(1);
            exit;
          end;
        47:
          begin // '4|47|Сдвинуть тайм-линию/линии на заданное количество кадров|CTRL+S'
            ControlButtonsPrepare(2);
            exit;
          end;
        48:
          begin // '4|48|Установить короткие номера событий|CTRL+D'
            ControlButtonsPrepare(3);
            exit;
          end;
        49:
          begin // '4|49|Вырезать событие/события в буфер обмена|CTRL+X'
            ControlButtonsPrepare(6);
            exit;
          end;
        50:
          begin // '4|50|Копировать событие/события в буфер обмена|CTRL+C'
            ControlButtonsPrepare(7);
            exit;
          end;
        51:
          begin // '4|51|Вставить событие/события из буфера обмена|CTRL+V'
            ControlButtonsPrepare(8);
            exit;
          end;
        52:
          begin // '4|52|Удалить событие/события без возможности восстановления|DELETE');
            ControlButtonsPrepare(9);
            exit;
          end;
        320:
          begin // '4|320|Вывести данные на печать|SHIFT+P');
            ControlButtonsPrepare(4);
            exit;
          end;
        321:
          begin // '4|321|Сохранить редактируемую тайм-линию в файл|SHIFT+W');
            ControlButtonsPrepare(5);
            exit;
          end;
        322:
          begin // '4|322|Загрузить данные из файла на редактируемую тайм-линию|SHIFT+R');
            ControlButtonsPrepare(11);
            exit;
          end;
        323:
          begin // '4|324|Проверить времена запуска клипов в текущем плей-листе|CTRL+T');
            if ListBox1.ItemIndex < 0 then
              exit;
            ButtonsControlPlayList(4);
            exit;
          end;
        53:
          begin // '4|53|Загрузить предыдущее событие из списка (клипы, плей-лист)|SHIFT+A'
            if Form1.ActiveControl = RichEdit1 then
              exit;
            sbPredClipClick(nil);
            exit;
          end;
        54:
          begin // '4|54|Загрузить следующее событие из списка (клипы, плей-лист)|SHIFT+S'
            if Form1.ActiveControl = RichEdit1 then
              exit;
            sbNextClipClick(nil);
            exit;
          end;
        55:
          begin // '4|55|Открыть/Закрыть список графических шаблонов|SHIFT+G'
            if Form1.ActiveControl = RichEdit1 then
              exit;
            CheckBox1.Checked := not CheckBox1.Checked;
            CheckBox1Click(nil);
            exit;
          end;
        56:
          begin // '4|56|Открыть панель воспроизведения видео|SHIFT+D'
            if Form1.ActiveControl = RichEdit1 then
              exit;
            MyMediaSwitcher.Select := 0;
            SwitcherVideoPanels(0);
            exit;
          end;
        57:
          begin // '4|57|Открыть панель воспроизведения шаблонов|SHIFT+F'
            if Form1.ActiveControl = RichEdit1 then
              exit;
            MyMediaSwitcher.Select := 1;
            SwitcherVideoPanels(1);
            exit;
          end;
        58:
          begin // '4|58|Установить начальную точку воспроизведения|I'
            if TLParameters.Position < TLParameters.Finish then
            begin
              SaveToUNDO;
              TLParameters.Start := TLParameters.Position;
              TLZone.DrawBitmap(bmptimeline);
              TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
              // TLZone.DrawCursorStart(imgLayer1.Canvas);
              imgTimelines.Repaint;
              imgLayer1.Repaint;
            end;
            exit;
          end;
        59:
          begin // '4|59|Установить конечную точку воспроизведения|O'
            if TLParameters.Position > TLParameters.Start then
            begin
              SaveToUNDO;
              TLParameters.Finish := TLParameters.Position;
              TLZone.DrawBitmap(bmptimeline);
              TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
              // TLZone.DrawCursorEnd(imgLayer1.Canvas);
              imgTimelines.Repaint;
              imgLayer1.Repaint;
            end;
            exit;
          end;
        70:
          begin // '4|70|Установить нулевую точку|CTRL+O');
            if vlcmode <> play then
              ButtonsControlMedia(1);
            exit;
          end;
        71:
          begin // '4|71|Установить время запуска клипа|CTRL+ALT+M');
            if vlcmode <> play then
              SetLTC(2);
            exit;
          end;
        80:
          begin // '4|80|Выделить все события на тайм-линии редактирования|CTRL+ALT+S'
            if vlcmode = play then
              exit;
            if TLZone.TLEditor.Count > 0 then
            begin
              SaveToUNDO;
              for i := 0 to TLZone.TLEditor.Count - 1 do
                TLZone.TLEditor.Events[i].Select := true;
              TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,
                TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
              TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
            end;
            exit;
          end;
        81:
          begin // '4|81|Отменить все выделенные события|CTRL+ALT+D'
            if vlcmode = play then
              exit;
            if TLZone.TLEditor.Count > 0 then
            begin
              SaveToUNDO;
              for i := 0 to TLZone.TLEditor.Count - 1 do
                TLZone.TLEditor.Events[i].Select := FALSE;
              TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,
                TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
              TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
            end;
            exit;
          end;
        101:
          begin // '4|101|Установить событие для устройства 1|1|NUMPAD1'
            SaveToUNDO;
            InsertEventToEditTimeline(0);
            exit;
          end;
        102:
          begin // '4|102|Установить событие для устройства 2|2|NUMPAD2'
            SaveToUNDO;
            InsertEventToEditTimeline(1);
            exit;
          end;
        103:
          begin // '4|103|Установить событие для устройства 3|3|NUMPAD3'
            SaveToUNDO;
            InsertEventToEditTimeline(2);
            exit;
          end;
        104:
          begin // '4|104|Установить событие для устройства 4|4|NUMPAD4'
            SaveToUNDO;
            InsertEventToEditTimeline(3);
            exit;
          end;
        105:
          begin // '4|105|Установить событие для устройства 5|5|NUMPAD5'
            SaveToUNDO;
            InsertEventToEditTimeline(4);
            exit;
          end;
        106:
          begin // '4|106|Установить событие для устройства 6|6|NUMPAD6'
            SaveToUNDO;
            InsertEventToEditTimeline(5);
            exit;
          end;
        107:
          begin // '4|107|Установить событие для устройства 7|7|NUMPAD7'
            SaveToUNDO;
            InsertEventToEditTimeline(6);
            exit;
          end;
        108:
          begin // '4|108|Установить событие для устройства 8|8|NUMPAD8'
            SaveToUNDO;
            InsertEventToEditTimeline(7);
            exit;
          end;
        109:
          begin // '4|109|Установить событие для устройства 9|9|NUMPAD9'
            SaveToUNDO;
            InsertEventToEditTimeline(8);
            exit;
          end;
        110:
          begin // '4|110|Установить событие для устройства 10|0|NUMPAD0'
            SaveToUNDO;
            InsertEventToEditTimeline(9);
            exit;
          end;
        111:
          begin // '4|111|Установить событие для устройств 11|CTRL+1|CTRL+NUMPAD1'
            SaveToUNDO;
            InsertEventToEditTimeline(10);
            exit;
          end;
        112:
          begin // '4|112|Установить событие для устройств 12|CTRL+2|CTRL+NUMPAD2'
            SaveToUNDO;
            InsertEventToEditTimeline(11);
            exit;
          end;
        113:
          begin // '4|113|Установить событие для устройств 13|CTRL+3|CTRL+NUMPAD3'
            SaveToUNDO;
            InsertEventToEditTimeline(12);
            exit;
          end;
        114:
          begin // '4|114|Установить событие для устройств 14|CTRL+4|CTRL+NUMPAD4'
            SaveToUNDO;
            InsertEventToEditTimeline(13);
            exit;
          end;
        115:
          begin // '4|115|Установить событие для устройств 15|CTRL+5|CTRL+NUMPAD5'
            SaveToUNDO;
            InsertEventToEditTimeline(14);
            exit;
          end;
        116:
          begin // '4|116|Установить событие для устройств 16|CTRL+6|CTRL+NUMPAD6'
            SaveToUNDO;
            InsertEventToEditTimeline(15);
            exit;
          end;
        117:
          begin // '4|117|Установить событие для устройств 17|CTRL+7|CTRL+NUMPAD7'
            SaveToUNDO;
            InsertEventToEditTimeline(16);
            exit;
          end;
        118:
          begin // '4|118|Установить событие для устройств 18|CTRL+8|CTRL+NUMPAD8'
            SaveToUNDO;
            InsertEventToEditTimeline(17);
            exit;
          end;
        119:
          begin // '4|119|Установить событие для устройств 19|CTRL+9|CTRL+NUMPAD9'
            SaveToUNDO;
            InsertEventToEditTimeline(18);
            exit;
          end;
        120:
          begin // '4|120|Установить событие для устройств 20|CTRL+0|CTRL+NUMPAD0'
            SaveToUNDO;
            InsertEventToEditTimeline(19);
            exit;
          end;
        121:
          begin // '4|121|Установить событие для устройств 21|SHIFT+1'
            SaveToUNDO;
            InsertEventToEditTimeline(20);
            exit;
          end;
        122:
          begin // '4|122|Установить событие для устройств 22|SHIFT+2'
            SaveToUNDO;
            InsertEventToEditTimeline(21);
            exit;
          end;
        123:
          begin // '4|123|Установить событие для устройств 23|SHIFT+3'
            SaveToUNDO;
            InsertEventToEditTimeline(22);
            exit;
          end;
        124:
          begin // '4|124|Установить событие для устройств 24|SHIFT+4'
            SaveToUNDO;
            InsertEventToEditTimeline(23);
            exit;
          end;
        125:
          begin // '4|125|Установить событие для устройств 25|SHIFT+5'
            SaveToUNDO;
            InsertEventToEditTimeline(24);
            exit;
          end;
        126:
          begin // '4|126|Установить событие для устройств 26|SHIFT+6'
            SaveToUNDO;
            InsertEventToEditTimeline(25);
            exit;
          end;
        127:
          begin // '4|127|Установить событие для устройств 27|SHIFT+7'
            SaveToUNDO;
            InsertEventToEditTimeline(26);
            exit;
          end;
        128:
          begin // '4|128|Установить событие для устройств 28|SHIFT+8'
            SaveToUNDO;
            InsertEventToEditTimeline(27);
            exit;
          end;
        129:
          begin // '4|129|Установить событие для устройств 29|SHIFT+9'
            SaveToUNDO;
            InsertEventToEditTimeline(28);
            exit;
          end;
        130:
          begin // '4|130|Установить событие для устройств 30|SHIFT+0'
            SaveToUNDO;
            InsertEventToEditTimeline(29);
            exit;
          end;
        131:
          begin // '4|131|Установить событие для устройств 31|ALT+1|ALT+NUMPAD1'
            SaveToUNDO;
            InsertEventToEditTimeline(30);
            exit;
          end;
        132:
          begin // '4|132|Установить событие для устройств 32|ALT+2|ALT+NUMPAD2'
            SaveToUNDO;
            InsertEventToEditTimeline(31);
            exit;
          end;
        60:
          begin // '4|60|Текстовая тайм-линия: Разделить событие на части по курсору|ALT+С'
            if PnTextTL.Visible then
            begin
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
              begin
                SaveToUNDO;
                ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
                txt := TLZone.TLEditor.Events[crpos.Number]
                  .ReadPhraseText('Text');
                endp := TLZone.TLEditor.Events[crpos.Number].Finish;
                cnt := trunc((endp - TLZone.TLEditor.Events[crpos.Number].Start)
                  * TLParameters.FrameSize / length(txt));
                cnt1 := trunc((TLParameters.Position - TLZone.TLEditor.Events
                  [crpos.Number].Start) * TLParameters.FrameSize / cnt);
                txt1 := '';
                for i := 1 to cnt1 do
                  txt1 := txt1 + txt[i];
                txt2 := '';
                for i := cnt1 + 1 to length(txt) do
                  txt2 := txt2 + txt[i];
                TLZone.TLEditor.Events[crpos.Number].Finish :=
                  TLParameters.Position;
                ARow := TLZone.TLEditor.AddEvent(TLParameters.Position,
                  ps + 1, 0);
                TLZone.TLEditor.Events[ARow]
                  .Assign(TLZone.TLEditor.Events[crpos.Number]);
                TLZone.TLEditor.Events[crpos.Number].SetPhraseText('Text',
                  Trim(txt1));
                TLZone.TLEditor.Events[ARow].Start := TLParameters.Position;
                TLZone.TLEditor.Events[ARow].Finish := endp;
                TLZone.TLEditor.Events[ARow].SetPhraseText('Text', Trim(txt2));
                TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
                TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
                TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas, ps,
                  TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
                TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
                imgTimelines.Repaint;
              end;
              exit;
            end;
          end;
        // 61  : begin //'4|61|Установить нулевую точку|ALT+Z'
        // if vlcmode<>play then ButtonsControlMedia(1);
        // exit;
        // end;
        62:
          begin // '4|62|Медиа тайм-линия: Установить маркер|CTRL+M'
            if pnMediaTL.Visible then
            begin
              ButtonsControlMedia(4);
              exit;
            end;
          end;
        63:
          begin // '4|63|Медиа тайм-линия: Удалить маркер|ALT+M'
            if pnMediaTL.Visible then
            begin
              ButtonsControlMedia(5);
              exit;
            end;
          end;
        200:
          begin // '4|200|Увеличить размер тайм-линий по вертикали|SHIFT+PLUS|SHIFT+NUMPADPLUS'
            TLHeights.StepPlus;
            // TLHeights.StepMinus;
            TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
            TLZone.DrawBitmap(bmptimeline);
            Form1.imgTimelines.Canvas.Lock;
            Form1.imgTimelines.Canvas.FillRect
              (Form1.imgTimelines.Canvas.ClipRect);
            TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
            InvalidateRect(Form1.imgTimelines.Canvas.Handle, NIL, FALSE);
            Form1.imgTimelines.Canvas.Unlock;
            TLZone.DrawLayer2(Form1.imgLayer2.Canvas);
            exit;
          end;
        201:
          begin // '4|201|Уменьшить размер тайм-линий по вертикали|SHIFT+MINUS|SHIFT+NUMPADMUNUS'
            TLHeights.StepMinus;
            TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
            TLZone.DrawBitmap(bmptimeline);
            Form1.imgTimelines.Canvas.Lock;
            Form1.imgTimelines.Canvas.FillRect
              (Form1.imgTimelines.Canvas.ClipRect);
            TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
            InvalidateRect(Form1.imgTimelines.Canvas.Handle, NIL, FALSE);
            Form1.imgTimelines.Canvas.Unlock;
            TLZone.DrawLayer2(Form1.imgLayer2.Canvas);
            exit;
          end;
        202:
          begin // 4|202|Увеличить масштаб тайм-линий по горизонтали|CTRL+PLUS|CTRL+NUMPADPLUS'
            TLZone.PlusHoriz;
            TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
            TLZone.DrawBitmap(bmptimeline);
            Form1.imgTimelines.Canvas.Lock;
            Form1.imgTimelines.Canvas.FillRect
              (Form1.imgTimelines.Canvas.ClipRect);
            TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
            InvalidateRect(Form1.imgTimelines.Canvas.Handle, NIL, FALSE);
            Form1.imgTimelines.Canvas.Unlock;
            TLZone.DrawLayer2(Form1.imgLayer2.Canvas);
            exit;
          end;
        203:
          begin // 4|203|Уменьшить масштаб тайм-линий по горизонтали|CTRL+MINUS|CTRL+NUMPADMUNUS'
            TLZone.MinusHoriz;
            TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
            TLZone.DrawBitmap(bmptimeline);
            Form1.imgTimelines.Canvas.Lock;
            Form1.imgTimelines.Canvas.FillRect
              (Form1.imgTimelines.Canvas.ClipRect);
            TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
            InvalidateRect(Form1.imgTimelines.Canvas.Handle, NIL, FALSE);
            Form1.imgTimelines.Canvas.Unlock;
            TLZone.DrawLayer2(Form1.imgLayer2.Canvas);
            exit;
          end;
      end;
    end;

    // Кнопки панели Список клипов
    if PanelClips.Visible then
    begin
      WriteLog('MAIN', 'TForm1.FormKeyUp PanelClips.Visible Key=' +
        ShiftToStr(Shift, Key));
      case CMD of
        22:
          begin // '2|22|Импортировать клипы в систему|CTRL+I'
            ButtonsControlClipsPanel(0);
            exit;
          end;
        23:
          begin // '2|23|Удалить клип/клипы из списка|DELETE'
            ButtonsControlClipsPanel(5);
            exit;
          end;
        24:
          begin // '2|24|Загрузить выбранный клип в окно подготовки|CTRL+P'
            ButtonsControlClipsPanel(2);
            exit;
          end;
        25:
          begin // '2|25|Сортировать список клипов|CTRL+S'
            ButtonsControlClipsPanel(3);
            exit;
          end;
        26:
          begin // '2|26|Загрузить клип/клипы в активный плей-лист|CTRL+L'
            ButtonsControlClipsPanel(4);
            exit;
          end;
        72:
          begin // '2|72|Создать новый клип|CTRL+N'
            ButtonsControlClipsPanel(1);
            exit;
          end;
      end;
    end;

    // Кнопки панели Активный плей-лист

    if PanelPlayList.Visible then
    begin
      WriteLog('MAIN', 'TForm1.FormKeyUp PanelPlayList.Visible Key=' +
        ShiftToStr(Shift, Key));
      Case CMD of
        27:
          begin // '3|27|Удалить клип/клипы из система|DELETE'
            ButtonsControlPlayList(5);
            exit;
          end;
        28:
          begin // '3|28|Загрузить выбранный клип в окно подготовки|CTRL+P'
            ButtonsControlPlayList(2);
            exit;
          end;
        73:
          begin // '3|73|Создать новый плей лист|CTRL+N'
            ButtonsControlPlayList(0);
            exit;
          end;
        74:
          begin // '3|74|Редактировать список клипов текущего плей листа|CTRL+R'
            ButtonsControlPlayList(1);
            exit;
          end;
        310:
          begin // '3|310|Сортировать клипы в текущем плей-листе|CTRL+S'
            ButtonsControlPlayList(3);
            exit;
          end;
        311:
          begin // '3|311|Проверить установку времени старта в плей-листе|CTRL+T'
            ButtonsControlPlayList(4);
            exit;
          end;
      End;
    end;

    // Кнопки панели Проектов

    if PanelProject.Visible then
    begin
      WriteLog('MAIN', 'TForm1.FormKeyUp panelproject.Visible Key=' +
        ShiftToStr(Shift, Key));
      case CMD of
        6:
          begin // '1|6|Создать новый проект|SHIFT+N'
            ButtonsControlProjects(2);
            exit;
          end;
        7:
          begin // '1|7|Редактировать выбранный плей-лист|CTRL+R'
            if GridLists.Row > 0 then
              if (GridLists.Objects[0, GridLists.Row] is TGridRows) then
                if (GridLists.Objects[0, GridLists.Row] as TGridRows).ID = 0
                then
                  EditPlayList(-1)
                else
                  EditPlayList(GridLists.Row);
            exit;
          end;
        8:
          begin // '1|8|Открыть проект|CTRL+O'
            if vlcmode <> play then
              ButtonsControlProjects(3);
            exit;
          end;
        9:
          begin // '1|9|Сохранить проект как|SHIFT+ S'
            if vlcmode <> play then
              ButtonsControlProjects(5);
            exit;
          end;
        10:
          begin // '1|10|Блокировать/разблокировать текущий проект|SHIFT+B'
            // imgBlockProjectsClick(nil);
            exit;
          end;
        // 11  : begin //'1|11|Переключение между списками окна проектов|TAB'
        //
        // end;
        12:
          begin // '1|12|Создать новую тайм-линию|CTRL+PLUS'
            ButtonControlLists(0);
            exit;
          end;
        13:
          begin // '1|13|Удалить выбранную тайм-линию|CTRL+MINUS'
            ButtonControlLists(1);
            exit;
          end;
        14:
          begin // '1|14|Редактировать выбранную тайм-линию|CTRL+T'
            GridTimeLinesDblClick(nil);
            exit;
          end;
        15:
          begin // '1|15|Создать новый плей-лист|CTRL+N'
            ButtonPlaylLists(0);
            exit;
          end;
        16:
          begin // '1|16|Удалить плей-лист|CTRL+D'
            ButtonPlaylLists(1);
            exit;
          end;
        17:
          begin // '1|17|Сохранить изменения сделанные в окне проекта|CTRL+S'
            if vlcmode <> play then
              ButtonsControlProjects(4);
            // ButtonControlLists(6);
            exit;
          end;
        18:
          begin // '1|18|Сортировать элементы списка (плей-листы, шаблоны)|ALT+S'
            ButtonPlaylLists(2);
            exit;
          end;
        // 19  : begin //'1|19|Открыть список «Плей-листы»|ALT+P'
        //
        // end;
        20:
          begin // '1|20|Открыть список «Графические шаблоны»|ALT+G'
            EditImageTamplate;
            exit;
          end;
        21:
          begin // '1|21|Открыть список «Текстовые шаблоны»|ALT+T'
            MyTextTemplateOptions;
            exit;
          end;
        300:
          begin
            ButtonsControlProjects(6);
          end;
      end;

      // Управление проектами

      if (ActiveControl = GridLists) and (SecondaryGrid = playlists) then
      begin
        If (not(ssAlt In Shift)) and (not(ssCtrl In Shift)) and
          (not(ssShift In Shift)) and (Key = VK_RETURN) then
        begin
          ps := findgridselection(Form1.GridLists, 2);
          if ps = GridLists.Row then
          begin
            sbPlayListClick(nil);
            exit;
          end;
          for i := 1 to GridLists.RowCount - 1 do
            (GridLists.Objects[0, i] as TGridRows).MyCells[2].Mark := FALSE;
          (GridLists.Objects[0, GridLists.Row] as TGridRows).MyCells[2]
            .Mark := true;
          PlaylistToPanel(GridLists.Row);

          if ListBox1.ItemIndex <> -1 then
          begin
            txt := (ListBox1.Items.Objects[ListBox1.ItemIndex]
              as TMyListBoxObject).ClipId;
            if fileexists(PathPlayLists + '\' + txt) then
            begin
              // LoadGridFromFile(PathPlayLists + '\' + txt, GridActPlayList);
              CheckedActivePlayList;
            end
            else
              GridClear(GridActPlayList, RowGridClips);
          end;

          GridLists.Repaint;
          exit;
        end;
      end;

    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.FormKeyUp Key=' + ShiftToStr(Shift, Key) + ' | '
        + E.Message);
  end;

  // If ((ssCtrl In Shift) And (Key=Ord('t'))) Then //Ctrl+t
  // If ((ssAlt In Shift) And (Key=Ord('t'))) Then //Alt+t
  // If ((ssShift In Shift) And (Key=Ord('t'))) Then //Shift+t
  // If ((ssShift In Shift) And (ssCtrl In Shift) And (Key=Ord('t'))) Then //Ctrl+Shift+t
end;

procedure TForm1.imgTextTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ps, res: Integer;
begin
  // if trim(Label2.Caption)='' then exit;
  try
    WriteLog('MAIN', 'TForm1.imgTextTLMouseUp Start X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then
    begin
      frLock.ShowModal;
      exit;
    end;
    SaveToUNDO;
    TextRichSelect := FALSE;
    ActiveControl := Panel8;
    res := btnstexttl.ClickButton(imgTextTL.Canvas, X, Y);
    case res of
      0:
        begin
          InsertEventToEditTimeline(-1);
          ActiveControl := Panel8;
        end;
      1:
        begin
        end;
      2:
        begin
          LoadSubtitrs;
          TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
          Form1.ImgLayer0.Repaint;
          TLZone.DrawBitmap(bmptimeline);
          TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
          imgTimelines.Repaint;
          Form1.Repaint;
        end;
    end;
    // ssssjson
          PutGridTimeLinesToServer(Form1.GridTimeLines);

    IsProjectChanges := true;
    WriteLog('MAIN', 'TForm1.imgTextTLMouseUp Finish X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.imgTextTLMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgTempMenuMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  TempMenu.MouseMove(imgTempMenu.Canvas, X, Y);
  TempMenu.Draw(imgTempMenu.Canvas);
  imgTempMenu.Repaint;
end;

procedure TForm1.imgTempMenuMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
begin
  res := TempMenu.MouseClick(imgTempMenu.Canvas, X, Y);
  TempMenu.Draw(imgTempMenu.Canvas);
  imgTempMenu.Repaint;
  pnTempMenu.Visible := FALSE;
  case res of
    1:
      begin
        ClpText.Text := 'Клип';
        SortGridAlphabet(GridClips, 1, 3, 'Clip', ClpText.direction);
      end;
    2:
      begin
        ClpText.Text := 'Песня';
        SortGridAlphabet(GridClips, 1, 3, 'Song', ClpText.direction);
      end;
    3:
      begin
        ClpText.Text := 'Исполнитель';
        SortGridAlphabet(GridClips, 1, 3, 'Singer', ClpText.direction);
      end;
    5:
      begin
        ClpTime.Text := 'Время старта';
        SortGridStartTime(GridClips, not ClpTime.direction);
      end;
    6:
      begin
        ClpTime.Text := 'Хр-ж медиа';
        SortGridTime(GridClips, 1, 3, 'Duration', ClpTime.direction);
      end;
    7:
      begin
        ClpTime.Text := 'Хр-ж воспр.';
        SortGridTime(GridClips, 1, 3, 'Dur', ClpTime.direction);
      end;
    10:
      begin
        APlText.Text := 'Клип';
        SortGridAlphabet(GridActPlayList, 1, 3, 'Clip', APlText.direction);
      end;
    11:
      begin
        APlText.Text := 'Песня';
        SortGridAlphabet(GridActPlayList, 1, 3, 'Song', APlText.direction);
      end;
    12:
      begin
        APlText.Text := 'Исполнитель';
        SortGridAlphabet(GridActPlayList, 1, 3, 'Singer', APlText.direction);
      end;
    15:
      begin
        APlTime.Text := 'Время старта';
        SortGridStartTime(GridActPlayList, not APlTime.direction);
      end;
    16:
      begin
        APlTime.Text := 'Хр-ж медиа';
        SortGridTime(GridActPlayList, 1, 3, 'Duration', APlTime.direction);
      end;
    17:
      begin
        APlTime.Text := 'Хр-ж воспр.';
        SortGridTime(GridActPlayList, 1, 3, 'Dur', APlTime.direction);
      end;
  end;
  APlTime.Draw(imgAPlFindTime.Canvas);
  ClpTime.Draw(imgClpFindTime.Canvas);
  APlText.Draw(imgAPlFindStr.Canvas);
  ClpText.Draw(imgClpFindStr.Canvas);
  imgAPlFindTime.Repaint;
  imgClpFindTime.Repaint;
  imgAPlFindStr.Repaint;
  imgClpFindStr.Repaint;
  GridActPlayList.Repaint;
  GridClips.Repaint;
end;

procedure TForm1.imgTextTLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnstexttl.MouseMove(imgTextTL.Canvas, X, Y);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  try
    if CheckBox1.Checked then
    begin
      GridGRTemplate.Visible := true;
      Panel16.Visible := true;
      CheckBox2.Visible := true;
      spDeleteTemplate.Visible := true;
      WriteLog('MAIN', 'TForm1.CheckBox1Click GridGRTemplate.Visible:=true');
    end
    else
    begin
      GridGRTemplate.Visible := FALSE;
      Panel16.Visible := FALSE;
      CheckBox2.Visible := FALSE;
      spDeleteTemplate.Visible := FALSE;
      WriteLog('MAIN', 'TForm1.CheckBox1Click GridGRTemplate.Visible:=false');
    end;
    if PanelPrepare.Visible then
      ActiveControl := Panel7;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.CheckBox1Click | ' + E.Message);
  end;
  // if Sender<>nil then ActiveControl := PanelPrepare;
end;

procedure TForm1.MySynhroClick(Sender: TObject);
var
  rw, ps: Integer;
begin
  if PanelPrepare.Visible then
    ActiveControl := Panel7;
  if MySynhro.Checked then
  begin
    Form1.sbPredClip.Enabled := true;
    Form1.sbNextClip.Enabled := true;
    if vlcmode = play then
      exit;
    if ListBox1.ItemIndex < 0 then
    begin
      MyTextMessage('Сообщение', 'Не выбран ни один из плей-листов.', 1);
      MySynhro.Checked := FALSE;
      SetButtonsPredNext;
      exit;
    end;
    // if trim(lbTypeTC.Caption)<>'' then begin
    // if not MyTextMessage('Сообщение', 'Для клипа задано время старта.' + #13#10
    // + 'Продолжить воспроизведение данного клипа [Нажмите - Да]' + #13#10
    // + 'Загрузить очередной клип из плей-листа [Нажмите - Нет]', 2)  then begin

    GridPlayer := grPlayList; // then  SetMainGridPanel(actplaylist);
    if lbActiveClipID.Caption <> '' then
    begin
      if GridPlayer = grPlayList then
      begin
        rw := FindClipinGrid(GridActPlayList, lbActiveClipID.Caption);
        if rw > 0 then
          lbTypeTC.Caption := (GridActPlayList.Objects[0, rw] as TGridRows)
            .MyCells[3].ReadPhrase('StartTime');
      end
      else
      begin
        rw := FindClipinGrid(GridClips, lbActiveClipID.Caption);
        if rw > 0 then
          lbTypeTC.Caption := (GridClips.Objects[0, rw] as TGridRows)
            .MyCells[3].ReadPhrase('StartTime');
      end;
      if Trim(lbTypeTC.Caption) <> '' then
        MyStartPlay := StrTimeCodeToFrames(lbTypeTC.Caption);
    end;
    // end;
    // end;
  end
  else
  begin
    // MyStartPlay:=-1;
    // lbTypeTC.Caption:='';
    SetButtonsPredNext;
  end;
end;

procedure TForm1.PanelControlClipMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
end;

procedure TForm1.PanelStartWindowMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  InputPopUpMenu.SetNotSelet;
  MenuListFiles.SetNotSelet;
  InputPopUpMenu.Draw(Image4.Canvas);
  MenuListFiles.Draw(ImgListFiles.Canvas);
  Image4.Repaint;
  ImgListFiles.Repaint;
end;

procedure TForm1.GridGRTemplateDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(GridGRTemplate, ACol, ARow, Rect);
end;

procedure TForm1.GridGRTemplateMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, j, rw, ps, evst: Integer;
  bl: Boolean;
  txt, flnm: string;
  crpos: TEventReplay;
begin
  try
    WriteLog('MAIN', 'TForm1.GridGRTemplateMouseUp X=' + inttostr(X) + ' Y=' +
      inttostr(Y));
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then
    begin
      frLock.ShowModal;
      exit;
    end;
    SaveToUNDO;
    if (TLZone.TLEditor.TypeTL = tltext) or (TLZone.TLEditor.TypeTL = tlmedia)
    then
      exit;
    // rw := RowGridGrTemplateSelect;
    crpos := TLZone.TLEditor.CurrentEvents;
    rw := GridClickRow(GridGRTemplate, Y);
    if rw = -1 then
      exit;
    if not DblClickGridGRTemplate then
      exit;
    if GridGRTemplate.Objects[0, rw] is TGridRows then
    begin
      DblClickGridGRTemplate := FALSE;
      with (GridGRTemplate.Objects[0, rw] as TGridRows) do
      begin
        for j := 0 to GridGRTemplate.RowCount - 1 do
          (GridGRTemplate.Objects[0, j] as TGridRows).MyCells[0].Mark := FALSE;
        MyCells[0].Mark := true;
        MyCells[0].ColorTrue := clRed;
        txt := MyCells[Count - 1].ReadPhrase('Template');
        flnm := MyCells[Count - 1].ReadPhrase('File');
      end;
      bl := FALSE;
      if vlcmode <> play then
      begin
        for i := 0 to TLZone.TLEditor.Count - 1 do
        begin
          if TLZone.TLEditor.Events[i].Select then
          begin
            if not CheckBox2.Checked then
              TLZone.TLEditor.Events[i].SetPhraseText('Text', txt);
            TLZone.TLEditor.Events[i].SetPhraseCommand('Text', flnm);
            if i = crpos.Number then
            begin
              crpos := TLZone.TLEditor.CurrentEvents;
              TemplateToScreen(crpos);
            end;
            bl := true;
          end;
        end;
      end;
      if not bl then
      begin
        for i := 0 to TLZone.TLEditor.Count - 1 do
        begin
          if (TLZone.TLEditor.Events[i].Start <= TLParameters.Position) and
            (TLZone.TLEditor.Events[i].Finish > TLParameters.Position) then
          begin
            if not CheckBox2.Checked then
              TLZone.TLEditor.Events[i].SetPhraseText('Text', txt);
            TLZone.TLEditor.Events[i].SetPhraseCommand('Text', flnm);
            if vlcmode <> play then
            begin
              crpos := TLZone.TLEditor.CurrentEvents;
              TemplateToScreen(crpos);
            end;
            break;
          end;
        end;
      end;
    end;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
    evst := TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame);
    // TLzone.TLEditor.DrawEditor(bmptimeline.Canvas,evst);
    TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
    TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas, ps, evst);
    if vlcmode <> play then
      TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
    GridGRTemplate.Repaint;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.GridGRTemplateMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.imgLayer2DblClick(Sender: TObject);
begin
  if TLZone.TLEditor.isZoneEditor then
    TLZone.TLEditor.DoubleClick := true
  else
    TLZone.TLEditor.DoubleClick := FALSE;
end;

procedure TForm1.GridProjectsRowMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
var
  ins, ine: Integer;
  s: string;
begin
  ins := FromIndex;
  ine := ToIndex;
  s := inttostr(ToIndex);
end;

procedure TForm1.GridProjectsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  s: string;
begin
  // RowDownGridProject := GridProjects.Row;
end;

procedure TForm1.GridListsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RowDownGridLists := GridLists.Row;
end;

procedure TForm1.GridListsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.GridClipsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RowDownGridClips := GridClips.Row;
end;

procedure TForm1.GridClipsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.GridActPlayListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RowDownGridActPlayList := GridActPlayList.Row;
end;

procedure TForm1.GridActPlayListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.imgTypeMovieMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MyMediaSwitcher.MouseMove(imgTypeMovie.Canvas, X, Y);
  MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
  imgTypeMovie.Repaint;
end;

procedure TForm1.imgTypeMovieMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
  crpos: TEventReplay;
begin
  try
    WriteLog('MAIN', 'TForm1.imgTypeMovieMouseUp');
    res := MyMediaSwitcher.MouseClick(imgTypeMovie.Canvas, X, Y);
    SwitcherVideoPanels(res);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.imgTypeMovieMouseUp | ' + E.Message);
  end;
end;

procedure TForm1.GridGRTemplateDblClick(Sender: TObject);
begin
  DblClickGridGRTemplate := true;
end;

procedure TForm1.spDeleteTemplateClick(Sender: TObject);
var
  i, ps: Integer;
  bl: Boolean;
  txt, flnm: string;
begin
  try
    WriteLog('MAIN', 'TForm1.spDeleteTemplateClick');
    if (TLZone.TLEditor.TypeTL = tltext) or (TLZone.TLEditor.TypeTL = tlmedia)
    then
      exit;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then
    begin
      frLock.ShowModal;
      exit;
    end;
    SaveToUNDO;
    bl := FALSE;
    if vlcmode <> play then
    begin
      for i := 0 to TLZone.TLEditor.Count - 1 do
      begin
        if TLZone.TLEditor.Events[i].Select then
        begin
          TLZone.TLEditor.Events[i].SetPhraseCommand('Text', '');
          bl := true;
        end;
      end;
    end;
    if not bl then
    begin
      for i := 0 to TLZone.TLEditor.Count - 1 do
      begin
        if (TLZone.TLEditor.Events[i].Start <= TLParameters.Position) and
          (TLZone.TLEditor.Events[i].Finish > TLParameters.Position) then
        begin
          TLZone.TLEditor.Events[i].SetPhraseCommand('Text', '');
          break;
        end;
      end;
    end;
    for i := 1 to GridGRTemplate.RowCount - 1 do
      if GridGRTemplate.Objects[0, i] is TGridRows then
        (GridGRTemplate.Objects[0, i] as TGridRows).MyCells[0].Mark := FALSE;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
    // TLzone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
    TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
    TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas, ps, 0);
    if vlcmode <> play then
      TLZone.DrawTimelines(imgTimelines.Canvas, bmptimeline);
    GridGRTemplate.Repaint;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.spDeleteTemplateClick | ' + E.Message);
  end;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  Form1.Image2.Canvas.FillRect(Form1.Image2.Canvas.ClipRect);
  (GridClips.Objects[0, GridClips.Row] as TGridRows).MyCells[0].Mark :=
    not(GridClips.Objects[0, GridClips.Row] as TGridRows).MyCells[0].Mark;
  if (GridClips.Objects[0, GridClips.Row] as TGridRows).MyCells[0].Mark then
    LoadBMPFromRes(Form1.Image2.Canvas, Form1.Image2.Canvas.ClipRect, 30,
      30, 'Lock')
  else
    LoadBMPFromRes(Form1.Image2.Canvas, Form1.Image2.Canvas.ClipRect, 30, 30,
      'Unlock');
  GridClips.Repaint;
end;

procedure TForm1.Image3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pnTempMenu.Visible then
    pnTempMenu.Visible := FALSE;
  if pnMainMenu.Visible then
    pnMainMenu.Visible := FALSE;
end;

procedure TForm1.Image4MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (X < 5) or (X > (Image4.Width - 10)) then
    InputPopUpMenu.SetNotSelet
  else
    InputPopUpMenu.MouseMove(Image4.Canvas, X, Y);
  InputPopUpMenu.Draw(Image4.Canvas);
  Image4.Repaint;
end;

procedure TForm1.Image4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  res: Integer;
begin
  res := ClickInputPopUpMenu(Image4, Y);
  case res of
    0:
      begin
        LoadProject(true);
        PanelStartWindow.Visible := FALSE;
        if not CreateProject(-1) then
        begin
          MyStartWindow;
          exit;
        end;
        EnableProgram;
        LoadProject(false);

      end;
    1:
      begin
        LoadProject(true);
        PanelStartWindow.Visible := FALSE;
        if not OpenProject then
        begin
          MyStartWindow;
          exit;
        end;
        EnableProgram;
        LoadProject(false);
          //SSSLOADPROJECT

      end;
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ps: Integer;
begin
  if PanelPrepare.Visible then
  begin
    if Trim(Form1.lbActiveClipID.Caption) = '' then
      exit;
    if Key = 32 then
      exit;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then
      frLock.ShowModal;
    // Timer2.Enabled:=true;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
var
  ps: Integer;
  crpos: TEventReplay;
begin
  if InputPanel.Visible then
  begin
    InputPanel.Left := 0;
    InputPanel.Width := Form1.ClientWidth;
    InputPanel.Top := 0;
    InputPanel.Height := Form1.ClientHeight;
  end;

  if PanelPrepare.Visible then
  begin
    UpdatePanelPrepare;
    crpos := TLZone.TLEditor.CurrentEvents;
    MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
      'FormResize');
    CurrentImageTemplate := '@@33@@';
    TemplateToScreen(crpos);
    if pnImageScreen.Visible then
      Image3.Repaint;
    exit;
  end;
  if PanelProject.Visible then
  begin
    imgButtonsControlProj.Picture.Bitmap.Height := imgButtonsControlProj.Height;
    pnlprojcntl.Draw(imgButtonsControlProj.Canvas);
  end;
end;

procedure TForm1.RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TextRichSelect := true;
end;

procedure TForm1.RichEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if (Key = 32) and (not TextRichSelect) then
    begin
      Key := 32;
      WriteLog('MAIN', 'TForm1.RichEdit1KeyUp Key=32');
      exit;
    end;
    if Key = 13 then
    begin
      TextRichSelect := FALSE;
      InsertEventToEditTimeline(-1);
      ActiveControl := Panel8;
      WriteLog('MAIN', 'TForm1.RichEdit1KeyUp Key=13');
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.RichEdit1KeyUp | ' + E.Message);
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  try
    If ListUsers.UserExists(Edit1.Text, Edit2.Text) then
    begin
      CurrentUser := Edit1.Text;
      pntlproj.SetText('UserName', CurrentUser);
      InputPanel.Visible := FALSE;
      MyStartWindow;
      WriteLog('MAIN', 'TForm1.SpeedButton1Click Input=Yes User=' +
        CurrentUser);
    end
    else
      MyTextMessage('Предупреждение',
        'Неправильно заданы имя пользователя и/или пароль.', 1);
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.SpeedButton1Click | ' + E.Message);
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if vlcmode = play then
    exit;
  WriteLog('MAIN', 'TForm1.sbSinhronizationClick SetLTC(2)');
  SetLTC(2);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  // if panel14.Width=panel5.Width then begin
  // Panel14.Width=Panel
  // end else Panel14.Width:=panel5.Width
end;

procedure TForm1.sbMainMenuClick(Sender: TObject);
begin
  pnMainMenu.Visible := true;
end;

procedure TForm1.sbMainMenuMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (X < 5) or ((X < 5) and (Y > sbMainMenu.Height - 5)) or (Y < 3) then
    pnMainMenu.Visible := FALSE
  else
  begin
    if not pnMainMenu.Visible then
    begin
      MyMainMenu.Draw(ImgMainMenu.Canvas);
      if ListBox1.ItemIndex <> -1 then
        SavePlayListFromGridToFile
          ((ListBox1.Items.Objects[ListBox1.ItemIndex]
          as TMyListBoxObject).ClipId);
    end;
    pnMainMenu.Visible := true;
  end;
  // if Y>sbMainMenu.Height-5 then pnMainMenu.Visible:=false else pnMainMenu.Visible:=True;
end;

procedure TForm1.ImgButtonsPLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  try
    if Trim(ProjectNumber) = '' then
    begin
      MyTextMessage('Предупреждение',
        'Для начала работы необходимо выбрать/создать проект.', 1);
      exit;
    end;
    if Button <> mbLeft then
      exit;
    i := pnlplaylsts.ClickButton(ImgButtonsPL.Canvas, X, Y);
    ButtonPlaylLists(i);
    IsProjectChanges := true;
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.ImgButtonsPLMouseUp X=' + inttostr(X) + ' Y=' +
        inttostr(Y) + ' | ' + E.Message);
  end;
end;

procedure TForm1.ImgButtonsPLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlplaylsts.MouseMove(ImgButtonsPL.Canvas, X, Y);
end;

procedure TForm1.sbSinhronizationClick(Sender: TObject);
begin
  if vlcmode = play then
    exit;
  WriteLog('MAIN', 'TForm1.sbSinhronizationClick SetLTC(1)');
  SetLTC(1);
end;

{ TlabelJSON }

function TlabelJSON.LoadFromJSONObject(json: tjsonObject): boolean;
var
  i1: integer;
  tmpjson: tjsonObject;
begin
  try
    caption := GetVariableFromJson(JSON, 'Caption', Caption);
  except
    on E: Exception do
  end;

end;

function TlabelJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  JSON: tjsonObject;
begin
  JSON := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
    as tjsonObject;
  result := true;
  if JSON = nil then
  begin
    result := false;
  end
  else
    LoadFromJSONObject(JSON);
end;

function TlabelJSON.SaveToJSONObject: tjsonObject;
var
  str1: string;
  js1, JSON: tjsonObject;
  i1, i2: integer;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)
begin
  JSON := tjsonObject.Create;
  try
    // jsonstr : string;
    // IDEvent : longint;
    addVariableToJson(JSON, 'Caption', caption);
  except
    on E: Exception do
  end;
  result := JSON;
end;

function TlabelJSON.SaveToJSONStr: string;
var
  jsontmp: tjsonObject;
  JSONstr: string;
begin
  jsontmp := SaveToJSONObject;
  JSONstr := jsontmp.ToString;
  result := JSONstr;
end;


end.
