unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.OleServer,
  SpeechLib_TLB;

type
  TForm1 = class(TForm)
    SpVoice1: TSpVoice;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
 asa : ansistring;
 voices:ISpeechObjectTokens;
 i: integer;
begin
 voices:=SpVoice1.GetVoices('', '');
 for i:=0 to Voices.Count - 1 do begin
    memo1.lines.Add(Voices.Item(i).GetDescription(0)+' = Name '+
    Voices.Item(i).getAttribute('Name')+' Age '+
    Voices.Item(i).GetAttribute('Age')+' Gender '+
    Voices.Item(i).GetAttribute('Gender')+' Lang '+
    Voices.Item(i).getAttribute('Language')+' Vendor'+
    Voices.Item(i).GetAttribute('Vendor'));
    SpVoice1.Voice := voices.item(i);
    asa := 'єѓур';
    SpVoice1.Speak(pwidechar(edit1.Text),  SVSFlagsAsync);
 end;
end;

end.
