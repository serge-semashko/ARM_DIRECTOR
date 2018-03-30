unit UShortNum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrShortNum = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frShortNum: TfrShortNum;

procedure SetShortNumber;

implementation

uses umain, ucommon, ugrtimelines, uinitforms;

{$R *.dfm}

procedure SetShortNumber;
var
  i, ps: integer;
  txt: string;
begin
  if TLZone.TLEditor.TypeTL <> tldevice then
    exit;
  with frShortNum do
  begin
    ShowModal;
    if ModalResult = mrOk then
    begin
      if CheckBox1.Checked then
        txt := trim(Edit1.Text)
      else
        txt := '';
      ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
      for i := 0 to TLZone.TLEditor.Count - 1 do
      begin
        TLZone.TLEditor.Events[i].SetPhraseText('ShortNum',
          txt + inttostr(i + 1));
        TLZone.TLEditor.Events[i].SetPhraseData('ShortNum', i + 1);
      end;
      for i := 0 to TLZone.Timelines[ps].Count - 1 do
      begin
        TLZone.Timelines[ps].Events[i].SetPhraseText('ShortNum',
          txt + inttostr(i + 1));
        TLZone.Timelines[ps].Events[i].SetPhraseData('ShortNum', i + 1);
      end;
    end;
  end;
end;

procedure TfrShortNum.CheckBox1Click(Sender: TObject);
begin
  If CheckBox1.Checked then
    Edit1.Visible := true
  else
    Edit1.Visible := false;
end;

procedure TfrShortNum.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrShortNum.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrShortNum.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      ModalResult := mrOk;
    #27:
      ModalResult := mrCancel;
  end;
end;

procedure TfrShortNum.FormCreate(Sender: TObject);
begin
  InitFrShortNum;
end;

end.
