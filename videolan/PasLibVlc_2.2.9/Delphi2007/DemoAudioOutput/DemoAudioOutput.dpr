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

program DemoAudioOutput;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Classes,
  PasLibVlcUnit in '..\..\source\PasLibVlcUnit.pas';

var
  p_li : libvlc_instance_t_ptr;

  vlc_audio_output_list : libvlc_audio_output_t_ptr;
  vlc_audio_output_enum : libvlc_audio_output_t_ptr;

  libvlc_audio_output_device_list : libvlc_audio_output_device_t_ptr;
  libvlc_audio_output_device_enum : libvlc_audio_output_device_t_ptr;
begin
  try
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
      '--no-video-title-show'
    ]) do
    begin
      p_li := libvlc_new(ARGC, ARGS);
      Free;
    end;

    WriteLn('libvlc_audio_output_list_get(p_instance);');
    WriteLn;

    vlc_audio_output_list := libvlc_audio_output_list_get(p_li);
    vlc_audio_output_enum := vlc_audio_output_list;
    while (vlc_audio_output_enum <> NIL) do
    begin
      WriteLn('// ', vlc_audio_output_enum^.psz_description);
      WriteLn('libvlc_audio_output_device_list_get(p_instance, ' + Chr(39), vlc_audio_output_enum^.psz_name, Chr(39) + ');');
      WriteLn;
      libvlc_audio_output_device_list := libvlc_audio_output_device_list_get(p_li, vlc_audio_output_enum^.psz_name);
      libvlc_audio_output_device_enum := libvlc_audio_output_device_list;
      if (libvlc_audio_output_device_enum <> NIL) then
      begin
        while (libvlc_audio_output_device_enum <> NIL) do
        begin
          WriteLn('  name = ', libvlc_audio_output_device_enum^.psz_device);
          WriteLn('  desc = ', libvlc_audio_output_device_enum^.psz_description);
          WriteLn;
          libvlc_audio_output_device_enum := libvlc_audio_output_device_enum^.p_next;
        end;
      end
      else
      begin
        WriteLn('  NOT FOUND');
        WriteLn;
      end;
      libvlc_audio_output_device_list_release(libvlc_audio_output_device_list);
      vlc_audio_output_enum := vlc_audio_output_enum^.p_next;
    end;
    libvlc_audio_output_list_release(vlc_audio_output_list);
    WriteLn;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;

  ReadLn;
end.
