unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Web.Win.Sockets;

type
  TForm1 = class(TForm)
    TcpServer1: TTcpServer;
    TcpClient1: TTcpClient;
    procedure FormCreate(Sender: TObject);
    procedure TcpServer1Accept(Sender: TObject; ClientSocket: TCustomIpClient);
    procedure TcpSr2accept(Sender: TObject; ClientSocket: TCustomIpClient);
  private
    { Private declarations }
  public
    { Public declarations }
    tcpsr2 : ttcpserver;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 TcpServer1.LocalPort:='9095';
 TcpServer1.Active:= true;
 tcpsr2 := ttcpserver.create(nil);
 TcpSr2.OnAccept := TcpSr2accept;
 TcpSr2.LocalPort:='9096';
 TcpSr2.Active:= true;

end;

procedure TForm1.TcpServer1Accept(Sender: TObject;
  ClientSocket: TCustomIpClient);
begin
  caption := 'accepr';
end;
procedure TForm1.TcpSr2Accept(Sender: TObject;
  ClientSocket: TCustomIpClient);
begin
  caption := 'accepr 2';
end;

end.
