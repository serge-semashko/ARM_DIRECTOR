unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin,tcpip,pingsend;

type
  TForm1 = class(TForm)
    btnsendbtn: TSpeedButton;
    pnl1: TPanel;
    Memo1: TMemo;
    URLEd: TLabeledEdit;
    sended: TLabeledEdit;
    portspn: TSpinEdit;
    SpeedButton1: TSpeedButton;
    procedure btnsendbtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
 tcpcon: Ttcpsend;
 ping :TPINGSend;
implementation

{$R *.dfm}

procedure TForm1.btnsendbtnClick(Sender: TObject);
var
  answer :string;
begin
 tcpcon := TtcpSend.Create;
 tcpcon.TargetHost := urled.Text;
 tcpcon.TargetPort := portspn.Text;
 tcpcon.Connect;
 tcpcon.Timeout := 1;
  if tcpcon.Sock.GetErrorDescEx <>'' then begin
   memo1.Lines.add('Error connect:'+tcpcon.Sock.GetErrorDescEx);
   exit
 end;

 tcpcon.Send(sended.text+#13#10);
 if tcpcon.Sock.GetErrorDescEx <>'' then begin
   memo1.Lines.add('Error send:'+tcpcon.Sock.GetErrorDescEx);
   exit
 end;
   answer := tcpcon.RecvString;
 if tcpcon.Sock.GetErrorDescEx <>'' then begin
   memo1.Lines.add('Error receive:'+tcpcon.Sock.GetErrorDescEx);
   exit
 end;
   memo1.Lines.add(answer);

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 ping := TPINGSend.Create;
 ping.Ping(URLEd.text);
 Memo1.Lines.Add(ping.ReplyFrom+' Time = '+IntToStr(ping.PingTime)+' ms');
 Memo1.Lines.Add(ping.ReplyErrorDesc);

end;

end.
