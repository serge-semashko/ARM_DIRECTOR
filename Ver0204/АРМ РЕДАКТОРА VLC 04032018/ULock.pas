unit ULock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfrLock = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frLock: TfrLock;

implementation

uses umain, ucommon;

{$R *.dfm}

procedure TfrLock.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  ModalResult := mrOk;
end;

procedure TfrLock.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

end.
