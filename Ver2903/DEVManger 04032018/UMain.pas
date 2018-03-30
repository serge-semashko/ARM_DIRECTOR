unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer,  MMSystem, OpenGL, UCommon;

//Const

//WM_DRAWTimeline = WM_APP + 9876;
//WM_TRANSFER = WM_USER + 1;

type
//  PCompartido =^TCompartido;
//  TCompartido = record
//    Manejador1: Cardinal;
//    Manejador2: Cardinal;
//    Numero    : Integer;
//    Shift     : Double;
//    Cadena    : String[20];
//  end;
//
//  TMyThread = class(TThread)
//   private
//     { Private declarations }
//   protected
//     procedure DoWork;
//     procedure Execute; override;
//   end;

 TFrMain = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    SpeedButton3: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Label4: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);


  private
    { Private declarations }
    //Compartido : PCompartido;
    //FicheroM   : THandle;
    //procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    // Обработчик сообщения WM_HOTKEY
    //procedure WMHotKey(var Mess:TWMHotKey);message WM_HOTKEY;
    //Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
    //procedure WMDRAWTimeline(var msg:TMessage); Message WM_DRAWTimeline;
    //procedure WMEraseBackGround(var msg:TMessage); Message WM_EraseBkgnd;
    //procedure WM_GETMINMAXINFO( var msg : TWMGETMINMAXINFO ); message wm_GetMinMaxInfo;
    //procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
    //Compartido : PCompartido;
  end;

var
  FrMain: TFrMain;

  MyTimer : THRTimer;
  //MyThread : TMyThread;
  PredDt, CurrDt, pStart1 : Double;
  OldTCPosition : longint = -1;
  OldTCTime : double = -1;
  mmResult : Integer;
  OldList1Index : integer = -10;
  //strgrrect : TGridRect;

//  procedure SetMediaButtons;
  procedure StartMyTimer;
  procedure StopMyTimer;
  Function ReadMyTimer : Double;


implementation

uses UTimeline, UDrawTimelines, UGRTimelines, umyevents, uwebget, mainunit;


{$R *.dfm}
//{$R bmpres2.res}

//procedure TFrMain.Reciviendo(var Msg: TMessage);
//begin
//  try
//  //label1.Caption:=compartido^.Cadena;
//  MyShiftOld := MyShift;
//  MyShift := compartido^.Shift;
//  compartido^.Cadena:='';
//  //WriteLog('MAIN', 'Message:Reciviendo');
//  except
////    on E: Exception do WriteLog('MAIN', 'Message:Reciviendo | ' + E.Message);
//  end;
//end;

procedure TFrMain.SpeedButton1Click(Sender: TObject);
begin
//  FmMain.Memo1.Clear;
//  MyTimer.StartTimer;
//  CurrDt:=now;
end;

procedure TFrMain.SpeedButton2Click(Sender: TObject);
begin
  //MyTimer.StopTimer;
end;

procedure TFrMain.SpeedButton3Click(Sender: TObject);
var
 str1 : ansistring;
 url : ansistring;
 slist1 : tstringlist;
begin
  MyTLEdit.Clear;
  str1 := GetJsonStrFromServer('GET_TLEDITOR');
  MyTLEdit.LoadFromJSONstr(str1);
end;

procedure TFrMain.Timer2Timer(Sender: TObject);
begin

end;

//procedure TFrMain.WM_GETMINMAXINFO(var msg: TWMGETMINMAXINFO);
//begin
//  try
//  if mainwindowsize  then exit;
//
//  with msg.minmaxinfo^ do
//  begin
//    ptmaxposition.x := BorderWidth;
//    ptmaxposition.y := BorderWidth;
//
//    ptmaxsize.x := Screen.Width;
//    ptmaxsize.y := Screen.Height;
//
//    ptMinTrackSize.x:=Screen.Width;
//    ptMinTrackSize.y:=Screen.Height;
//    ptMaxTrackSize.x:=Screen.Width;
//    ptMaxTrackSize.y:=Screen.Height;
//  end;
////  if imgTypeMovie<>nil then imgTypeMovie.Repaint;
// // WriteLog('MAIN', 'Message:WM_GETMINMAXINFO');
//  except
////    on E: Exception do WriteLog('MAIN', 'Message:WM_GETMINMAXINFO | ' + E.Message);
//  end;
//end;

//procedure TFrMain.WMSysCommand(var Msg: TWMSysCommand);
//begin
//  try
//  if ((Msg.CmdType and $FFF0) = SC_MOVE) then begin
//    if not mainwindowmove then begin
//      Msg.Result := 0;
//      Exit;
//    end;
//  end;
// // WriteLog('MAIN', 'Message:WMSysCommand');
//  inherited;
//  except
// //   on E: Exception do WriteLog('MAIN', 'Message:WMSysCommand | ' + E.Message);
//  end;
//end;






procedure StartMyTimer;
var dur : double;
begin
  try
  PredDt:=0;
//  if fileexists(Form1.lbPlayerFile.Caption) then begin
//    pStart:=vlcplayer.Time;
//    dur := vlcplayer.Duration div 40;
//  end else begin
//    pStart := FramesToDouble(TLParameters.Position);
//    dur := TLParameters.Duration;
//  end;
  pStart1:=0;
  //if FramesToDouble(TLParameters.Position - TLParameters.Preroll) > dur
  if TLParameters.Position - TLParameters.Preroll > dur
    then pStart1:=FramesToDouble(TLParameters.Position - TLParameters.Preroll);
  //OlDTCPosition:=-1;

  MyTimer.StartTimer;
  PredDt:=MyTimer.ReadTimer;
 // if Makelogging then WriteLog('MAIN', 'UMain.StartMyTimer Duration=' + TimeToTimeCodeStr(dur) + ' Start=' + TimeToTimeCodeStr(pStart)  + ' Start1=' + TimeToTimeCodeStr(pStart1));
  except
 //   on E: Exception do WriteLog('MAIN', 'UMain.StartMyTimer | ' + E.Message);
  end;
end;

procedure StopMyTimer;
begin
  MyTimer.StopTimer;
//  if Makelogging then WriteLog('MAIN', 'UMain.StopMyTimer');
end;

Function ReadMyTimer : Double;
begin
  result := MyTimer.ReadTimer;
end;

end.



