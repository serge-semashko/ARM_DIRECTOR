unit UNumberManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls;

type
  TfrNumberManager = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetNewNumber;
  end;

var
  frNumberManager : TfrNumberManager;


implementation

{$R *.dfm}

procedure tfrNumberManager.SetNewNumber;
begin
  Show;
end;

end.
