unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, PasLibVlcUnit, PasLibVlcPlayerUnit;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuFileOpen: TMenuItem;
    MenuFileQuit: TMenuItem;
    OpenDialog: TOpenDialog;
    PasLibVlcPlayer: TPasLibVlcPlayer;
    procedure MenuFileQuitClick(Sender: TObject);
    procedure MenuFileOpenClick(Sender: TObject);
    procedure PasLibVlcPlayerMediaPlayerMediaChanged(Sender: TObject;
      mrl: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.MenuFileQuitClick(Sender: TObject);
begin
  Close();
end;

procedure TMainForm.MenuFileOpenClick(Sender: TObject);
var
  logo_file_1 : string;
  logo_file_2 : string;
begin
  if OpenDialog.Execute() then
  begin
    PasLibVlcPlayer.Play(OpenDialog.FileName);

    logo_file_1 := ExtractFilePath(Application.ExeName) + 'logo1.png';
    logo_file_2 := ExtractFilePath(Application.ExeName) + 'logo2.png';
    if (FileExists(logo_file_1) and FileExists(logo_file_2)) then
    begin
      PasLibVlcPlayer.LogoShowFiles([logo_file_1, logo_file_2], libvlc_position_top);
    end;
    PasLibVlcPlayer.MarqueeShowText('marquee test %H:%M:%S', libvlc_position_bottom);
  end;
end;

procedure TMainForm.PasLibVlcPlayerMediaPlayerMediaChanged(Sender: TObject;
  mrl: String);
begin
  Caption := mrl;
end;

end.
