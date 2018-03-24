unit UPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, PasLibVlcUnit, vlcpl,uwebget;

type

  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TMouseActivate = (maDefault, maActivate, maActivateAndEat, maNoActivate,
    maNoActivateAndEat);
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TPlayerMode = (Stop, Play, Paused);

var
  // Переменные для VLC Начало ++++++++++++++++++++++++++++++++++++++++++++++++++++

  // VLCPause : boolean = true;
  VLCDuration: int64;

  // Переменные для VLC Окончание++++++++++++++++++++++++++++++++++++++++++++++++++

  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // hr: HRESULT = 1;                                    //задаем начальное значение ложь
  pCurrent, pDuration, pStart: Double;
  // Текужее положение и длительность фильма
  OldParamPosition: longint = -1; // Старая позиция курсораэ
  VLCMode: TPlayerMode; // режим воспроизведения
  Rate: Double; // нормальная скорость воспроизведения
  FullScreen: boolean = false; // индикатор перехода в полноэкранный режим
  i: integer = 0; // счетчик загруженных файлов
  FileName: string; // имя файла
  xn, yn: integer; // для хранения координат мыши
  mouse: tmouse; // координаты мыши

  PNX: integer;
  PNDOWN: boolean;
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure ClearVLCPlayer;
function LoadVLCPlayer(FileName: string; out mediadata: string): integer;
// function GraphErrorToStr(err : integer) : string;
procedure Player(FileName: string);
procedure MediaSetPosition(Position: longint; replay: boolean;
  logplace: string);
procedure MediaPlay;
procedure MediaPause;
procedure MediaStop;
procedure MediaSlow(dlt: integer);
procedure MediaFast(mng: integer);

implementation

uses umain, ucommon, ugrtimelines, umyfiles;

procedure ClearVLCPlayer;
begin
  VLCPlayer.Release;
end;

function LoadVLCPlayer(FileName: string; out mediadata: string): integer;
var
  sv, sa: string;
begin
  result := 0;
  VLCMode := Paused;
  if (VLCPlayer.p_li <> NIL) then
  begin
    VLCPlayer.Load(PwideChar(UTF8Encode(FileName)));
    VLCMode := Paused;
    // s:= inttostr(vlcplayer.width) + ':' + inttostr(vlcplayer.Height);
  end
  else
  begin
    VLCPlayer.Create;
    if VLCPlayer.Init(Form1.pnMovie.Handle) <> '' then
      MessageDlg(VLCPlayer.error, mtError, [mbOK], 0)
    else
    begin
      VLCPlayer.Load(PwideChar(UTF8Encode(FileName)));
      VLCMode := Paused;
      // s:= inttostr(vlcplayer.width) + ':' + inttostr(vlcplayer.Height);
    end;
  end;
  // VLCPause:= true;
  // vlcplayer.Pause;
  sv := VLCPlayer.VideoCodec;
  if trim(sv) <> '' then
    sv := ' v: ' + trim(sv);
  sa := VLCPlayer.AudioCodec;
  if trim(sa) <> '' then
    sa := ' a: ' + trim(sa);

  mediadata := inttostr(VLCPlayer.Width) + ':' + inttostr(VLCPlayer.Height)
    + sv + sa;
  VLCPlayer.tracks := '';
  MediaPause;
end;

procedure Player(FileName: string);
// процедура проигрывания файла
var
  Err: integer;
  mediadata: string;
begin
  if libvlc_media_player_get_state(VLCPlayer.p_mi) <> libvlc_Playing then
  begin
    if not FileExists(FileName) then
    begin
      ShowMessage('Файл не существует');
      exit;
    end;
    // освобождаем канал воспроизведения
    Err := LoadVLCPlayer(FileName, mediadata);
    If Err <> 0 then
    begin
      // Showmessage(GraphErrorToStr(err));
      exit;
    end;
  end;
  // Отображаем первый кадр
  Rate := 1; // pMediaPosition.get_Rate(Rate);
  // pMediaControl.Stop;
  // mode:=stop;
  // pMediaControl.Pause;
  // vlcplayer.Pause;
  VLCMode := Paused;
end;

// ==============================================================================

// процедура изменения позиции проигрывания при изменении позиции ProgressBar (перемотка)
procedure MediaSetPosition(Position: longint; replay: boolean;
  logplace: string);
var
  ps, dur: int64;
  pdRate: Double;
  vlc_state: libvlc_state_t;
  mediadata: string;
begin
  try
    // WriteLog('Synchro', '3) MediaSetPosition=' + inttostr(Position));
    // vlc_state := libvlc_media_player_get_state(VLCPlayer.p_li);
    if trim(Form1.lbPlayerFile.Caption) = '' then
      exit;

    if libvlc_media_player_get_state(VLCPlayer.p_mi) = libvlc_Ended then
    begin
      if FileExists(Form1.lbPlayerFile.Caption) then
      begin
        // WriteLog('Synchro', '3) MediaSetPosition loadfile ' + Form1.lbPlayerFile.Caption);
        LoadVLCPlayer(Form1.lbPlayerFile.Caption, mediadata)
      end
      else
        exit;
    end;
    ps := Position - TLParameters.Preroll;
    // WriteLog('Synchro', '3) Position - TLParameters.Preroll=' + inttostr(ps));
    if ps < 0 then
      exit;
    VLCPlayer.SetTime(ps * 40);
    // WriteLog('MAIN', 'UPlayer.MediaSetPosition (' + logplace + ') Position=' + FramesToStr(Position) + '|');
  except
  end;
end;

// процедура воспроизведения
procedure MediaPlay;
var
  dtc, ps: Double;
  ps1, dlt, tc, fen: longint;
  vs, vlc_state: libvlc_state_t;
  dur, pst: int64;
begin
  // vlc_state:=libvlc_media_player_get_state(vlcplayer.p_mi);
  if VLCPlayer.p_mi <> nil then
  begin
    if libvlc_media_player_get_state(VLCPlayer.p_mi) = libvlc_Paused then
    begin
      if not Form1.MySynhro.Checked then
      begin
        dtc := now - TimeCodeDelta;
        MyStartPlay := TimeToFrames(dtc);
        Form1.lbTypeTC.Caption := MyDateTimeToStr(dtc);
      end;
      VLCMode := Play;
      VLCPlayer.Play;
      StartMyTimer;
      exit;
    end;
  end;

  dtc := now - TimeCodeDelta;
  tc := TimeToFrames(dtc);
  fen := TLParameters.Finish - TLParameters.Start;
  if MyStartPlay + fen < tc then
    MyStartPlay := -1;
  if tc < MyStartPlay then
    MyStartPlay := -1;
  if MyStartPlay = -1 then
  begin
    MyStartPlay := TimeToFrames(dtc);
    Form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor, 72);
    Form1.lbTypeTC.Caption := 'Старт в (' +
      trim(FramesToStr(MyStartPlay)) + ')';
  end;
  dlt := tc - MyStartPlay;

  if FileExists(Form1.lbPlayerFile.Caption) then
  begin
    if Form1.MySynhro.Checked then
    begin
      if (dlt > 0) and (dlt < TLParameters.Finish - TLParameters.Start) then
      begin
        ps1 := TLParameters.Start - TLParameters.Preroll + dlt;
        VLCPlayer.SetTime(ps1 * 40);
      end;
    end;
  end
  else
  begin
    if Form1.MySynhro.Checked then
    begin
      if (dlt > 0) and (dlt <= TLParameters.Finish - TLParameters.Start) then
      begin
        TLParameters.Position := TLParameters.Start + dlt;
        PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
      end;
    end;
  end;
  VLCMode := Play;
  if VLCPlayer.p_mi <> nil then
    VLCPlayer.Play;
  WriteLog('MAIN', 'UPlayer.MediaPlay mode=play| Текущее время=' +
    FramesToStr(tc) + '  Время старта=' + FramesToStr(MyStartPlay) +
    '  Время окончания=' + FramesToStr(fen));
  StartMyTimer; // ###### Warming
end;

// процедура паузы
procedure MediaPause;
begin
  // Проверяем идет ли воспроизведение
  if VLCPlayer.p_mi <> nil then
  begin
    // if not fileexists(Form1.lbPlayerFile.Caption) then exit;
    if libvlc_media_player_get_state(VLCPlayer.p_mi) = libvlc_Playing then
    begin
      if FileExists(Form1.lbPlayerFile.Caption) then
        VLCPlayer.Pause;
      VLCPlayer.Pause;
      // vlcmode:=paused;//устанавливаем playmode -> пауза
      // WriteLog('MAIN', 'UPlayer.MediaPause mode=paused | Файл : ' + Form1.lbPlayerFile.Caption);
      // StopMyTimer; //###### Warming
    end;
  end;
  // end else begin
  VLCMode := Paused; // устанавливаем playmode -> пауза
  WriteLog('MAIN', 'UPlayer.MediaPause mode=paused | Файл : Пусто');
  StopMyTimer;
  // end else begin
  // end;
end;

// процедура остановки
procedure MediaStop;
begin
  // Проверяем идет ли воспроизведение
  if VLCPlayer.p_mi = nil then
    exit;
  if libvlc_media_player_get_state(VLCPlayer.p_mi) = libvlc_Playing then
  begin
    StopMyTimer;
    if FileExists(Form1.lbPlayerFile.Caption) then
      VLCPlayer.Pause;
    VLCMode := Paused; // Stop;
    WriteLog('MAIN', 'UPlayer.MediaStop mode=stop|');
    // задаем начальное положение проигравания
    // pMediaPosition.put_CurrentPosition(0);
    // TLZone.Position:=TLZone.TLScaler.Preroll + TLZone.TLScaler.Start;
    // TLZone.StopPosition:=TLZone.Position;
    TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmptimeline);
  end;
end;

// процедура замедленного воспроизведения
procedure MediaSlow(dlt: integer);
var
  pdRate: Double;
begin
  if VLCMode = Play then
  begin
    if not FileExists(Form1.lbPlayerFile.Caption) then
    begin
      Rate := Rate / dlt;
      pStart := FramesToDouble(TLParameters.Position);
      application.ProcessMessages;
      exit;
    end;
    // читаем текущую скорость
    // pMediaPosition.get_Rate(pdRate);
    pdRate := libvlc_media_player_get_rate(VLCPlayer.p_mi);
    // уменьшаем ее в dlt раз
    // pMediaPosition.put_Rate(pdRate/dlt);
    libvlc_media_player_set_rate(VLCPlayer.p_mi, pdRate / dlt);
    WriteLog('MAIN', 'UPlayer.MediaSlow Rate=' +
      FloatToStr(pdRate / dlt) + '|');
    application.ProcessMessages;
  end;
end;

// процедура ускоренного воспроизведения
procedure MediaFast(mng: integer);
var
  pdRate: Double;
begin
  if VLCMode = Play then
  begin
    if not FileExists(Form1.lbPlayerFile.Caption) then
    begin
      Rate := Rate * mng;
      pStart := FramesToDouble(TLParameters.Position);
      application.ProcessMessages;
      exit;
    end;
    // читаем текущую скорость
    // pMediaPosition.get_Rate(pdRate);
    pdRate := libvlc_media_player_get_rate(VLCPlayer.p_mi);
    // увеличиваем ее в mng раз
    // pMediaPosition.put_Rate(pdRate*mng);
    libvlc_media_player_set_rate(VLCPlayer.p_mi, pdRate * mng);
    WriteLog('MAIN', 'UPlayer.MediaFast Rate=' +
      FloatToStr(pdRate * mng) + '|');
    application.ProcessMessages;
  end;
end;

end.
