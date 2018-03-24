unit main;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus,
  PasLibVlcUnit,vlcpl;

type
  TMainForm = class(TForm)
    OpenDialog: TOpenDialog;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuFileOpen: TMenuItem;
    MenuFileQuit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MenuFileOpenClick(Sender: TObject);
    procedure MenuFileQuitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    p_li : libvlc_instance_t_ptr;
    p_mi : libvlc_media_player_t_ptr;
    procedure PlayerInit();
    procedure PlayerPlay(fileName: WideString);
    procedure PlayerStop();
    procedure PlayerDestroy();
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Player :tvlcpl;
implementation

{$R *.dfm}
procedure TMainForm.PlayerInit();
begin
  if player.Init(self.Handle) <>0 then begin
    MessageDlg(Player.error, mtError, [mbOK], 0);
    exit;
  end;
end;

procedure TMainForm.PlayerPlay(fileName: WideString);
begin
  PlayerStop();
  player.Play(PAnsiChar(UTF8Encode(fileName)));
end;

procedure TMainForm.PlayerStop();
begin
 player.Stop;
end;

procedure TMainForm.PlayerDestroy();
begin
  player.release;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Player.Release;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Player:=TVlcPl.Create;
  PlayerInit();
end;

procedure TMainForm.MenuFileOpenClick(Sender: TObject);
begin
  if (player.p_li <> NIL) then
  begin
    if OpenDialog.Execute() then
    begin
      PlayerPlay(OpenDialog.FileName);
    end;
  end;
end;

procedure TMainForm.MenuFileQuitClick(Sender: TObject);
begin
  Close();
end;

end.

