unit UBlock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrBlock = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frBlock: TfrBlock;

implementation
uses umain, ucommon;

{$R *.dfm}

procedure TfrBlock.FormCreate(Sender: TObject);
begin
  Canvas
end;

end.
