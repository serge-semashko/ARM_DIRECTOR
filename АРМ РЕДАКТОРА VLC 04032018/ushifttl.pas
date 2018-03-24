unit ushifttl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, ExtCtrls;

type
  TfrShiftTL = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    CheckBox1: TCheckBox;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frShiftTL: TfrShiftTL;

procedure ShiftTimelines;

implementation

uses umain, ucommon, uinitforms, ugrtimelines;

{$R *.dfm}

procedure ShiftTimelines;
var
  i, j, ps: integer;
begin
  With frShiftTL do
  begin
    SpinEdit1.Value := 0;
    Label1.Caption := FramesToShortStr(SpinEdit1.Value);
    ShowModal;
    if ModalResult = mrOk then
    begin
      if CheckBox1.Checked then
      begin
        for i := 0 to TLZone.TLEditor.Count - 1 do
        begin
          TLZone.TLEditor.Events[i].Start := TLZone.TLEditor.Events[i].Start +
            SpinEdit1.Value;
          TLZone.TLEditor.Events[i].Finish := TLZone.TLEditor.Events[i].Finish +
            SpinEdit1.Value;
        end;
        for i := 0 to TLZone.Count - 1 do
        begin
          for j := 0 to TLZone.Timelines[i].Count - 1 do
          begin
            TLZone.Timelines[i].Events[j].Start := TLZone.Timelines[i].Events[j]
              .Start + SpinEdit1.Value;
            TLZone.Timelines[i].Events[j].Finish := TLZone.Timelines[i].Events
              [j].Finish + SpinEdit1.Value;
          end;
        end;
      end;
      ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
      for i := 0 to TLZone.TLEditor.Count - 1 do
      begin
        TLZone.TLEditor.Events[i].Start := TLZone.TLEditor.Events[i].Start +
          SpinEdit1.Value;
        TLZone.TLEditor.Events[i].Finish := TLZone.TLEditor.Events[i].Finish +
          SpinEdit1.Value;
      end;
      for i := 0 to TLZone.Timelines[ps].Count - 1 do
      begin
        TLZone.Timelines[ps].Events[i].Start := TLZone.Timelines[ps].Events[i]
          .Start + SpinEdit1.Value;
        TLZone.Timelines[ps].Events[i].Finish := TLZone.Timelines[ps].Events[i]
          .Finish + SpinEdit1.Value;
      end;
    end;
  end;
end;

procedure TfrShiftTL.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrShiftTL.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrShiftTL.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Text = '' then
    exit;
  if SpinEdit1.Text = '-' then
    exit;
  if SpinEdit1.Text = '+' then
    exit;
  Label1.Caption := FramesToShortStr(SpinEdit1.Value);
end;

procedure TfrShiftTL.FormCreate(Sender: TObject);
begin
  InitFrShiftTL;
end;

procedure TfrShiftTL.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      ModalResult := mrOk;
    #27:
      ModalResult := mrCancel;
  end;
end;

end.
