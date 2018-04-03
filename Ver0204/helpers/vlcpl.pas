unit vlcpl;

interface

uses PasLibVlcUnit, windows, classes, sysutils, forms,vcl.dialogs,winapi.mmsystem;
const
  histstate : array[0..7] of ansistring =
  ('libvlc_NothingSpecial', // 0,
  'ibvlc_Opening',        // 1,
  'ibvlc_Buffering',      // 2,
  'ibvlc_Playing',        // 3,
  'ibvlc_Paused',         // 4,
  'ibvlc_Stopped',        // 5,
  'ibvlc_Ended',          // 6,
  'ibvlc_Error');           // 7
  // );

type
  TvlcPl = class
  private
    pEventManager: libvlc_event_manager_t_ptr;
  public
    tracks : ansistring;
    status: string;
    error: string;
    width: longword;
    Height: longword;
    Aspect: string;
    MediaFilename: widestring;
    Duration: int64;
    Time_position : int64;
    Last_time : int64;
    prev_time : int64;
    count_Lasttime : int64;
    timeof_lasttime : dword;
    p_li: libvlc_instance_t_ptr;
    p_mi: libvlc_media_player_t_ptr;
    mean_count : int64;
    winhandle: hwnd;
    VideoCodec : string;
    AudioCodec : string;
    Constructor Create;
    Function Init(whandle: hwnd): string;
    Function Stop: Integer;
    Function SetTime(Time: int64): Integer;
    Function Release: Integer;
    Function Play: Integer;
    Function Load(fileName: WideString): string;
    Function Pause: Integer;
    Function Time: int64;
    Function Rate: single;
    Function SetRate(Rate: single): Integer;
    Function PlayerReady: boolean;
    Function vlc_waitForState(vlc_state:libvlc_state_t):boolean;
  end;
  procedure EventCallBack(p_event : libvlc_event_t_ptr; data:  Pointer); cdecl;
  var
  vlc_status :  string;
  old_time : int64 = 0;
  old_pos : double = 0;
implementation
uses umain, umyfiles;

//Procedure WriteLog(Logname,LogData:ansiString);overload;
//var
//  ff:TFileStream;
//  logstr : ansistring;
//begin
//  logname := extractfilepath(Application.ExeName) + '\Log\';//'g:\home\log.txt';
//  if not fileexists(logname) then ForceDirectories(logname);
//  logname := logname + 'vlcpl.log';
//  logstr := logData+#13#10;
//  try
//    If FileExists(LogName)
//       then ff := TFileStream.create(LogName,fmOpenWrite or  fmShareDenyNone)
//       else ff := TFileStream.create(LogName,fmCreate or  fmShareDenyNone);
//    ff.seek(0,soFromEnd);
//    ff.write(Logstr[1],length(logstr));
//    ff.free;
//  except
//  end;
//end;

//Procedure WriteLog(LogData:ansiString);overload;
//var
//  ff:TFileStream;
//  logname,logstr : ansistring;
//
//begin
//  logname := extractfilepath(Application.ExeName) + '\Log\';//'g:\home\log.txt';
//  if not fileexists(logname) then ForceDirectories(logname);
//  logname := logname + 'vlcpl.log';
//  logstr := logData+#13#10;
//  try
//    If FileExists(LogName)
//       then ff := TFileStream.create(LogName,fmOpenWrite or  fmShareDenyNone)
//       else ff := TFileStream.create(LogName,fmCreate or  fmShareDenyNone);
//    ff.seek(0,soFromEnd);
//    ff.write(Logstr[1],length(logstr));
//    ff.free;
//  except
//  end;
//end;

procedure EventCallBack(p_event : libvlc_event_t_ptr; data:  Pointer);
var
  str: string;
  Parr1 :dword;
  Parr2 :dword;
  diffpos : double;
  p1 : pointer;
begin
 if p_event=nil then exit;
  str := '';

  case p_event.event_type of
    libvlc_MediaPlayerPlaying: str := 'stat Playing';
    libvlc_MediaPlayerPaused: str := 'stat Paused';
    libvlc_MediaPlayerStopped: str := 'stat Stopped';
    libvlc_MediaPlayerOpening: str := 'stat Opening';
    libvlc_MediaPlayerEncounteredError: str := 'stat Encountered Error';
    libvlc_MediaParsedChanged : begin
       str :='stat Parsed';
    end;
    libvlc_MediaFreed :begin
       str := 'stat freed';
    end;
    libvlc_MediaStateChanged:begin
       str := 'stat StateChanged:';
    end;

    libvlc_mediaplayertimechanged:begin
       TvlcPl(data).last_time := p_event.media_player_time_changed.new_time;
       TvlcPl(data).timeof_lasttime := timegetTime();
//       str := 'timeChanged:';
    end;
  end;
   if str <>''  then  VLCPlayer.status :=str;
   if str <>''  then  writelog('VLCPL',str);

end;
Constructor TvlcPl.Create;

begin
  writelog('VLCPL','vlcCreate');
  inherited Create;
  Aspect := '';
  p_mi := nil;
  p_li := nil;
  error := '';
end;

Function TvlcPl.Init;
begin
  writelog('VLCPL','vlcInit');
  winhandle := whandle;
  libvlc_dynamic_dll_init();

  if (libvlc_dynamic_dll_error <> '') then
  begin
    showmessage('Ќевозможно загрузит VLC проигрыватель:'+libvlc_dynamic_dll_error);
    error := libvlc_dynamic_dll_error;
    result := error;
    exit;
  end;

  with TArgcArgs.Create([libvlc_dynamic_dll_path, '--intf=dummy',
    '--ignore-config', '--quiet', '--no-video-title-show','--high-priority',
    '--no-video-on-top']) do
  begin
    p_li := libvlc_new(ARGC, ARGS);
    if (libvlc_dynamic_dll_error <> '') then
    begin
      error := libvlc_dynamic_dll_error;
      result := error;
      exit;
    end;
    Free;
  end;
  p_mi := NIL;
  result := '';
end;

function TvlcPl.Load(fileName: WideString): string;
var
  p_md: libvlc_media_t_ptr;
  histstate: string;
  i1: Integer;
  TD: libvlc_track_description_t_ptr;
  vlc_state: libvlc_state_t;
  tname : ansistring;
  pEventManager: libvlc_event_manager_t_ptr;
  ptracks: libvlc_media_track_info_t_ptr;
//  tracks : array[0..3] of libvlc_media_track_info_t;
  lw : longword;
  track_count : integer;
Function CodecName(lw : longword):string;
begin
    result := char(lw and $000000FF)+
                char((lw and $0000FF00) shr 8)+
                char((lw and $00ff0000) shr 16)+
                char((lw and $ff000000) shr 24);
end;
begin
//  new(ptracks);
  writelog('VLCPL','Load');

  if (p_mi <> NIL) then
  begin
    libvlc_media_player_stop(p_mi);
    libvlc_media_player_release(p_mi);
    p_mi := NIL;
  end;

  // p_md := libvlc_media_new_path(p_li, PAnsiChar(UTF8Encode(fileName)));
  MediaFileName :=fileName;
  p_md := libvlc_media_new_path(p_li, PAnsiChar(fileName));
  if (p_md <> NIL) then
  begin
    p_mi := libvlc_media_player_new_from_media(p_md);
    if (p_mi <> NIL) then
    begin
      libvlc_video_set_key_input(p_mi, 0);
      libvlc_video_set_mouse_input(p_mi, 0);
      libvlc_media_player_set_display_window(p_mi, winhandle);


    end;
  end;
  libvlc_media_player_play(p_mi);

  histstate := '';
  // libvlc_state_t = (
  // libvlc_NothingSpecial, // 0,
  // libvlc_Opening,        // 1,
  // libvlc_Buffering,      // 2,
  // libvlc_Playing,        // 3,
  // libvlc_Paused,         // 4,
  // libvlc_Stopped,        // 5,
  // libvlc_Ended,          // 6,
  // libvlc_Error           // 7
  // );

  vlc_state := libvlc_media_player_get_state(p_mi);
  while (libvlc_media_player_get_state(p_mi) <> libvlc_Playing) do
  begin
    sleep(1);
    application.processmessages;
    vlc_state := libvlc_media_player_get_state(p_mi);
  end;
  libvlc_media_parse(p_md);
  track_count :=libvlc_media_get_tracks_info(p_md, ptracks);
//  lw :=tracks[0].i_codec;
  VideoCodec := '';
  audioCodec := '';
  for i1:= 1 to  track_count do begin
    lw :=ptracks.i_codec;
     case  ptracks.i_type  of
        libvlc_track_unknown : tracks := tracks+IntToStr(i1)+' track unknown; ';
        libvlc_track_audio   : begin
                                    tracks := tracks+IntToStr(i1)+' audio '+codecName(lw)+'; ';
                                    audioCodec:=codecName(lw);
                               end;
        libvlc_track_video   : begin
                                    tracks := tracks+IntToStr(i1)+' video '+codecName(lw)+'; ';
                                    videoCodec:=codecName(lw);
                               end;
        libvlc_track_text    : tracks := tracks+IntToStr(i1)+' text '+codecName(lw)+'; ';
     end;
    inc(ptracks);
  end;


  Last_Time := 0;
  timeof_lasttime := timeGetTime();
  Duration := libvlc_media_player_get_length(p_mi);
  libvlc_video_get_size(p_mi, 0, width, Height);
  Aspect := libvlc_video_get_aspect_ratio(p_mi) + '/ ' +
    libvlc_video_get_crop_geometry(p_mi) + '/' +
    IntToStr(libvlc_video_get_track_count(p_mi));
  TD := libvlc_video_get_track_description(p_mi);
  if td <> nil then Aspect := Aspect + '/' + UTF8decode(TD.psz_name);
  libvlc_media_player_pause(p_mi);
  while (libvlc_media_player_get_state(p_mi) <> libvlc_Paused) do
  begin
    sleep(1);
    application.processmessages;
    vlc_state := libvlc_media_player_get_state(p_mi);
  end;
   pEventManager := libvlc_media_player_event_manager(p_mi);
  // register event
  libvlc_event_attach(pEventManager, libvlc_MediaPlayerPlaying, @EventCallBack, self);
  libvlc_event_attach(pEventManager, libvlc_MediaPlayerTimeChanged, @EventCallBack, self);

  libvlc_event_attach(pEventManager, libvlc_MediaPlayerPaused, @EventCallBack, self);
  libvlc_event_attach(pEventManager, libvlc_MediaPlayerStopped, @EventCallBack, self);
  libvlc_event_attach(pEventManager, libvlc_MediaPlayerOpening, @EventCallBack, self);
  libvlc_event_attach(pEventManager, libvlc_MediaPlayerEncounteredError, @EventCallBack, self);
  libvlc_event_attach(pEventManager, libvlc_MediaParsedChanged, @EventCallBack, self);
  libvlc_event_attach(pEventManager, libvlc_MediaFreed, @EventCallBack, self);
  libvlc_event_attach(pEventManager, libvlc_MediaStateChanged, @EventCallBack, self);


  // it

end;

function TvlcPl.Pause: Integer;
var
 vlc_state :libvlc_state_t;
begin
  writelog('VLCPL','vlcPause');
  vlc_state := libvlc_media_player_get_state(p_mi);
 if  vlc_state = libvlc_Paused then exit;
 if vlc_state = libvlc_Playing then
     libvlc_media_player_pause(p_mi);
 vlc_waitForState(libvlc_Paused);
  vlc_state := libvlc_media_player_get_state(p_mi);

end;

function TvlcPl.Play: Integer;
var
 vlc_state :libvlc_state_t;
begin

  writelog('VLCPL','vlcPlay');
  vlc_state := libvlc_media_player_get_state(p_mi);
 if  vlc_state = libvlc_Paused then begin
   libvlc_media_player_pause(p_mi);
   vlc_waitForState(libvlc_Playing);
   last_time := libvlc_media_player_get_time(p_mi);
   timeof_lasttime := timeGetTime();
   exit;
 end;
end;

function TvlcPl.PlayerReady: boolean;
begin
 result := p_mi <> nil;
end;

function TvlcPl.Time: int64;
var
 ff : single;
 diff : dword;
begin
//  Duration:=libvlc_media_player_get_length(p_mi);
//  ff := libvlc_media_player_get_position(p_mi);
//  result := trunc(ff*duration);
  result := last_time;
  if  libvlc_media_player_get_state(p_mi) <> libvlc_Playing then exit;
  if result = prev_Time then begin
     inc(count_LastTime);
     diff := timeGetTime - timeof_lasttime;
     result := last_time  + diff;
  end
  else begin
    prev_time :=  result;
    mean_count := Count_LastTime;
    Count_LastTime:= 0;
  end;

end;

function TvlcPl.vlc_waitForState(vlc_state: libvlc_state_t): boolean;
var
 sttime : dword;
 cur_state :libvlc_state_t;
begin
  writelog('VLCPL','vlcWaitForState');
  result := true;
  sttime := timegettime();
  while (libvlc_media_player_get_state(p_mi) <> vlc_state) do
  begin
    sleep(1);
    application.processmessages;
    cur_state := libvlc_media_player_get_state(p_mi);
    if (timegettime-sttime)>1300 then begin
      writelog('VLCPL','vlcWaitForState fail for timelimit');
       result := false;
       exit;
    end;
  end;

end;

function TvlcPl.Rate: single;
begin
  result := libvlc_media_player_get_rate(p_mi);

end;

function TvlcPl.Release: Integer;
begin
  writelog('VLCPL','Release');

  if (p_mi <> NIL) then
  begin
//  pEventManager := libvlc_media_player_event_manager(p_mi);
//  // register event
//  libvlc_event_detach(pEventManager, libvlc_MediaPlayerPlaying, @EventCallBack, self);
//  libvlc_event_detach(pEventManager, libvlc_MediaPlayerTimeChanged, @EventCallBack, self);
//  libvlc_event_detach(pEventManager, libvlc_MediaPlayerpositionChanged, @EventCallBack, self);
//
//  libvlc_event_detach(pEventManager, libvlc_MediaPlayerPaused, @EventCallBack, self);
//  libvlc_event_detach(pEventManager, libvlc_MediaPlayerStopped, @EventCallBack, self);
//  libvlc_event_detach(pEventManager, libvlc_MediaPlayerOpening, @EventCallBack, self);
//  libvlc_event_detach(pEventManager, libvlc_MediaPlayerEncounteredError, @EventCallBack, self);   // it

    libvlc_media_player_stop(p_mi);
    libvlc_media_player_release(p_mi);
    p_mi := NIL;
  end;

  if (p_li <> NIL) then
  begin
    Stop;
    libvlc_release(p_li);
    p_li := NIL;
  end;
  result := 0;
end;

function TvlcPl.SetRate(Rate: single): Integer;
begin
  result := libvlc_media_player_set_rate(p_mi, Rate);
end;

function TvlcPl.SetTime(Time: int64): Integer;
begin
  writelog('VLCPL','SetTime');
  if (libvlc_media_player_get_state(p_mi) = libvlc_Ended) then
  begin
    Load(MediafileName);
  end;

  if time <0  then  time :=0;
  if time > duration  then  time :=duration-10;

  libvlc_media_player_set_time(p_mi, Time);

end;

function TvlcPl.Stop: Integer;
begin
  writelog('VLCPL','Stop');
  if (p_mi <> NIL) then
  begin
    libvlc_media_player_stop(p_mi);
    libvlc_media_player_release(p_mi);
    p_mi := NIL;
  end;
end;

end.
