unit USetProcent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrSetProcent = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frSetProcent: TfrSetProcent;
  MyResult: integer;

function SetProcent(X, Y, z: integer): string;

implementation

uses umain, ucommon, ugrtimelines, uinitforms;

{$R *.dfm}

function SetProcent(X, Y, z: integer): string;
var
  len, vid, scr, opr: longint;
begin
  len := TLParameters.Preroll + TLParameters.Finish; // +TLparameters.Postroll;
  vid := TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame;
  scr := vid * TLParameters.FrameSize;
  opr := len div 100;
  frSetProcent.ListBox1.Items.Strings[0] := FormatFloat('0.0', scr / opr) + '%';
  frSetProcent.ListBox1.Items.Strings[1] :=
    FormatFloat('0.0', (scr / 2) / opr) + '%';
  frSetProcent.ListBox1.Items.Strings[2] :=
    FormatFloat('0.0', (scr / 3) / opr) + '%';
  frSetProcent.ListBox1.Items.Strings[3] :=
    FormatFloat('0.0', (scr / 4) / opr) + '%';
  frSetProcent.ListBox1.Items.Strings[4] :=
    FormatFloat('0.0', (scr / 5) / opr) + '%';
  frSetProcent.ListBox1.Items.Strings[5] :=
    FormatFloat('0.0', (scr / 7) / opr) + '%';
  frSetProcent.ListBox1.Items.Strings[6] :=
    FormatFloat('0.0', (scr / 10) / opr) + '%';

  frSetProcent.Top := Y;
  frSetProcent.Left := X;
  case TLParameters.FrameSize of
    1:
      frSetProcent.ListBox1.ItemIndex := 0;
    2:
      frSetProcent.ListBox1.ItemIndex := 1;
    3:
      frSetProcent.ListBox1.ItemIndex := 2;
    4:
      frSetProcent.ListBox1.ItemIndex := 3;
    5:
      frSetProcent.ListBox1.ItemIndex := 4;
    7:
      frSetProcent.ListBox1.ItemIndex := 5;
  else
    frSetProcent.ListBox1.ItemIndex := 6;
  end;
  frSetProcent.ShowModal;
  if frSetProcent.ModalResult = mrOk then
  begin
    result := frSetProcent.ListBox1.Items.Strings
      [frSetProcent.ListBox1.ItemIndex];
  end;
end;

procedure TfrSetProcent.FormCreate(Sender: TObject);
begin
  initFrSetProcent;
end;

procedure TfrSetProcent.ListBox1Click(Sender: TObject);
var
  i: integer;
begin
  For i := 0 to ListBox1.Items.Count - 1 do
  begin
    if ListBox1.Selected[i] then
    begin
      Case i of
        0:
          TLParameters.FrameSize := 1;
        1:
          TLParameters.FrameSize := 2;
        2:
          TLParameters.FrameSize := 3;
        3:
          TLParameters.FrameSize := 4;
        4:
          TLParameters.FrameSize := 5;
        5:
          TLParameters.FrameSize := 7;
        6:
          TLParameters.FrameSize := 10;
      End;
      break;
    end
  end;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  Case Key of
    #13:
      ListBox1Click(nil);
    #27:
      ModalResult := mrCancel;
  End;
end;

end.
