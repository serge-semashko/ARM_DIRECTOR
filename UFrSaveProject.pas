unit UFrSaveProject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TFrSaveProject = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrSaveProject: TFrSaveProject;

implementation

uses uinitforms;

{$R *.dfm}

procedure TFrSaveProject.FormCreate(Sender: TObject);
begin
  InitFrSaveProject;
end;

end.
