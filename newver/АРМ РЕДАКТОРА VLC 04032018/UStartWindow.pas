unit UStartWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons;

type
  TFrStartWindow = class(TForm)
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure StartWindow;
  end;

var
  FrStartWindow: TFrStartWindow;

implementation
uses umain;

{$R *.dfm}

procedure TFrStartWindow.StartWindow;
begin
  FrStartWindow.Show;
//  if FrStartWindow.ModalResult=mrOk then begin
//  end;
end;

procedure TFrStartWindow.SpeedButton1Click(Sender: TObject);
begin
  Form1.Close;
end;

end.
