unit vlcpl;

interface

uses PasLibVlcUnit, windows, classes, sysutils, forms,vcl.dialogs;

type
  TvlcPl = class
  public
    error: string;
    width: longword;
    Height: longword;
    Aspect: string;
    MediaFilename: widestring;
    Duration: int64;
    p_li: libvlc_instance_t_ptr;
    p_mi: libvlc_media_player_t_ptr;
    winhandle: hwnd;
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

  end;

implementation

Constructor TvlcPl.Create;
begin
  inherited Create;
  Aspect := '';
  p_mi := nil;
  p_li := nil;
  error := '';
end;

Function TvlcPl.Init;
begin
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
    '--ignore-config', '--quiet', '--no-video-title-show',
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
begin

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
    libvlc_media_release(p_md);
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
  result := histstate;
  if length(histstate) > 255 then
    exit;
  Duration := libvlc_media_player_get_length(p_mi);
  libvlc_video_get_size(p_mi, 0, width, Height);
  Aspect := libvlc_video_get_aspect_ratio(p_mi) + '/ ' +
    libvlc_video_get_crop_geometry(p_mi) + '/' +
    IntToStr(libvlc_video_get_track_count(p_mi));
  TD := libvlc_video_get_track_description(p_mi);
  if td <> nil then Aspect := Aspect + '/' + UTF8decode(TD.psz_name);

  libvlc_media_player_pause(p_mi);
end;

function TvlcPl.Pause: Integer;
begin
  libvlc_media_player_pause(p_mi);
end;

function TvlcPl.Play: Integer;
begin
  libvlc_media_player_play(p_mi);
end;

function TvlcPl.PlayerReady: boolean;
begin
 result := p_mi <> nil;
end;

function TvlcPl.Time: int64;
begin
  // Duration:=libvlc_media_player_get_length(p_mi);
  result := libvlc_media_player_get_time(p_mi);
end;

function TvlcPl.Rate: single;
begin
  result := libvlc_media_player_get_rate(p_mi);

end;

function TvlcPl.Release: Integer;
begin
  if (p_mi <> NIL) then
  begin
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
  if (p_mi <> NIL) then
  begin
    libvlc_media_player_stop(p_mi);
    libvlc_media_player_release(p_mi);
    p_mi := NIL;
  end;
end;

end.
