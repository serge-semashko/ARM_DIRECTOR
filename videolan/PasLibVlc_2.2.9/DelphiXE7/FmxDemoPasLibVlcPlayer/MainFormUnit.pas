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

unit MainFormUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FmxPasLibVlcPlayerUnit, FMX.StdCtrls;

type
  TMainForm = class(TForm)
    FmxPasLibVlcPlayer1: TFmxPasLibVlcPlayer;
    OpenButton: TButton;
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    procedure OpenButtonClick(Sender: TObject);
    procedure FmxPasLibVlcPlayer1MediaPlayerVideoSizeChanged(Sender: TObject;
      width, height, video_w_a32, video_h_a32: Cardinal);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.FmxPasLibVlcPlayer1MediaPlayerVideoSizeChanged(
  Sender: TObject; width, height, video_w_a32, video_h_a32: Cardinal);
begin
  Caption := IntToStr(width) + 'x' + IntToStr(height);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FmxPasLibVlcPlayer1.Stop();
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' - ' + {$IFDEF CPUX64}'64'{$ELSE}'32'{$ENDIF} + ' bit';
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
  if (OpenDialog.Execute) then
  begin
    FmxPasLibVlcPlayer1.Play(OpenDialog.FileName);
  end;
end;

end.
