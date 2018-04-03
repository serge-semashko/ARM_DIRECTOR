unit UDCB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
(*
DWORD DCBlength; // sizeof(DCB)
DWORD BaudRate; // current baud rate
DWORD fBinary:1; // binary mode, no EOF check
DWORD fParity:1; // enable parity checking
DWORD fOutxCtsFlow:1; // CTS output flow control
DWORD fOutxDsrFlow:1; // DSR output flow control
DWORD fDtrControl:2; // DTR flow control type
DWORD fDsrSensitivity:1; // DSR sensitivity
DWORD fTXContinueOnXoff:1; // XOFF continues Tx
DWORD fOutX:1; // XON/XOFF out flow control
DWORD fInX:1; // XON/XOFF in flow control
DWORD fErrorChar:1; // enable error replacement
DWORD fNull:1; // enable null stripping
DWORD fRtsControl:2; // RTS flow control
DWORD fAbortOnError:1; // abort reads/writes on error
DWORD fDummy2:17; // reserved
WORD wReserved; // not currently used
WORD XonLim; // transmit XON threshold
WORD XoffLim; // transmit XOFF threshold
BYTE ByteSize; // number of bits/byte, 4-8
BYTE Parity; // 0-4=no,odd,even,mark,space
BYTE StopBits; // 0,1,2 = 1, 1.5, 2
char XonChar; // Tx and Rx XON character
char XoffChar; // Tx and Rx XOFF character
char ErrorChar; // error replacement character
char EofChar; // end of input character
char EvtChar; // received event character
WORD wReserved1; // reserved; do not use
*)

end.
