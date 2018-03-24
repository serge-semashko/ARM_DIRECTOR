(*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Any non-GPL usage of this software or parts of this software is strictly
 * forbidden.
 *
 * The "appropriate copyright message" mentioned in section 2c of the GPLv2
 * must read: "Code from FAAD2 is copyright (c) Nero AG, www.nero.com"
 *
 * Commercial non-GPL licensing of this software is possible.
 * please contact robert@prog.olsztyn.pl
 *
 * http://prog.olsztyn.pl/paslibvlc/
 *
 *)

{$I ..\..\source\compiler.inc}

program DemoVideoCallBacks;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows, SysUtils, Graphics,
  PasLibVlcUnit in '..\..\source\PasLibVlcUnit.pas';

type
  PCtx = ^TCtx;
  TCtx = record
    buff        : Pointer;
    buff_a32    : Pointer;
    video_w     : LongWord;
    video_w_a32 : LongWord;
    video_h     : LongWord;
    video_h_a32 : LongWord;
    bmpi        : Graphics.TBitmap;
    bmpc        : Cardinal;
  end;

const
  DEMO_FILE = '..\..\_testFiles\Maximize.mp4';

var
  p_li : libvlc_instance_t_ptr;
  p_md : libvlc_media_t_ptr;
  p_mi : libvlc_media_player_t_ptr;

  ctx : TCtx;

function libvlc_video_lock_cb(ptr : Pointer; var planes : Pointer) : Pointer; cdecl;
begin
  with PCtx(ptr)^ do
  begin
    planes := buff_a32;
    Result := buff_a32;
  end;
end;

procedure libvlc_video_unlock_cb(ptr : Pointer; picture : Pointer; planes : Pointer); cdecl;
begin
end;

procedure libvlc_video_display_cb_RV32(ptr : Pointer; picture : Pointer); cdecl;
var
  y   : Integer;
  src : PByte;
  len : Integer;
  stp : Integer;
  fileNumb : ShortString;
  fileName : ShortString;
begin
  with PCtx(ptr)^ do
  begin
    src := buff_a32;
    len := video_w * 4;
    stp := video_w_a32 * 4;
    for y := 0 to video_h - 1 do
    begin
      Move(src^, bmpi.ScanLine[y]^, len);
      Inc(src, stp);
    end;

    Inc(bmpc);
    Str(bmpc, fileNumb);

    fileName := Copy('000000', 1, 6 - Length(fileNumb)) + fileNumb + '.bmp';
    WriteLn(fileName);

    bmpi.SaveToFile(fileName);
  end;  
end;

function libvlc_video_format_cb(var ptr : Pointer; chroma : PAnsiChar; var width : LongWord; var height : LongWord; var pitches : TVCBPitches; var lines : TVCBLines) : LongWord; cdecl;
var
  idx : Integer;
begin

  chroma^ := AnsiChar('R'); Inc(chroma);
  chroma^ := AnsiChar('V'); Inc(chroma);
  chroma^ := AnsiChar('3'); Inc(chroma);
  chroma^ := AnsiChar('2');
  
  with PCtx(ptr)^ do
  begin
    video_w := width;
    video_h := height;
    (*
     * Furthermore, we recommend that pitches and lines be multiple of 32
     * to not break assumption that might be made by various optimizations
     * in the video decoders, video filters and/or video converters.
     *)
    video_w_a32 := (((width  + 31) shr 5) shl 5);
    video_h_a32 := (((height + 31) shr 5) shl 5);
    ReAllocMem(buff, video_w_a32 * video_h_a32 * 4 + 32);
    buff_a32 := Pointer(((NativeInt(buff) + 31) shr 5) shl 5);
    bmpi.SetSize(width, height);

    for idx := 0 to VOUT_MAX_PLANES - 1 do
    begin
      pitches[idx] := video_w_a32 * 4;
      lines[idx]   := video_h_a32;
    end;
  end;

  Result := 1;
end;

procedure libvlc_video_cleanup_cb(ptr : Pointer); cdecl;
var
  ctx : PCtx;
begin
  ctx := PCtx(ptr);
  with ctx^ do
  begin
    if (buff <> NIL) then
    begin
      FreeMem(buff);
    end;
    bmpi.Free;
  end;
end;

begin

  try

    FillChar(ctx, sizeof(ctx), 0);

    with ctx do
    begin
      video_w := 320;
      video_h := 240;
      bmpi := Graphics.TBitmap.Create;
      bmpi.PixelFormat := pf32bit;
      bmpi.SetSize(video_w, video_h);
    end;

    libvlc_dynamic_dll_init();

    if (libvlc_dynamic_dll_error <> '') then
    begin
      raise Exception.Create(libvlc_dynamic_dll_error);
    end;

    with TArgcArgs.Create([
      libvlc_dynamic_dll_path,
      '--intf=dummy',
      '--ignore-config',
      '--quiet',
      '--no-video-title-show',
      '--no-video-on-top'
      // '--vout=vdummy',
      // '--aout=adummy'
    ]) do
    begin
      p_li := libvlc_new(ARGC, ARGS);
      Free;
    end;

    p_md := libvlc_media_new_path(p_li, PAnsiChar(UTF8Encode(DEMO_FILE)));
    libvlc_media_parse(p_md);
  
    p_mi := libvlc_media_player_new_from_media(p_md);

    libvlc_video_set_callbacks(p_mi, libvlc_video_lock_cb, libvlc_video_unlock_cb, libvlc_video_display_cb_RV32, @ctx);

    // use this for set video size to your needs
  //  libvlc_video_set_format(p_mi, 'RV32', ctx.video_w, ctx.video_h, ctx.video_w * 4);

    // use this for handle change video size etc.
    libvlc_video_set_format_callbacks(p_mi, libvlc_video_format_cb, libvlc_video_cleanup_cb);

    libvlc_media_player_play(p_mi);
  
    while (libvlc_media_player_get_state(p_mi) <> libvlc_Ended) do
    begin
      Sleep(50);
    end;

    libvlc_media_release(p_md);
    libvlc_media_player_release(p_mi);
    libvlc_release(p_li);

  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;

  ReadLn;
end.
