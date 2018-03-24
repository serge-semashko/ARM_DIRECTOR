unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, PasLibVlcPlayerUnit;

type
  TMainForm = class(TForm)
    mrlEdit: TEdit;
    player: TPasLibVlcPlayer;
    playButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure playerMediaPlayerTimeChanged(Sender: TObject;
      time: Int64);
    procedure playButtonClick(Sender: TObject);
  private
    needStop : Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  needStop := TRUE;
  mrlEdit.Text := '..'+PathDelim+'..'+PathDelim+'_testFiles'+PathDelim+'test.ts';
  player.Play(mrlEdit.Text);
end;

procedure TMainForm.playButtonClick(Sender: TObject);
begin
  player.Resume();
end;

procedure TMainForm.playerMediaPlayerTimeChanged(Sender: TObject;
  time: Int64);
begin
  if (needStop) and (time > 100) then
  begin
    needStop := FALSE;
    player.Pause();
  end;
end;

end.
