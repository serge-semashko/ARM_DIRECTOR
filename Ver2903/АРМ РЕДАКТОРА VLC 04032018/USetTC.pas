unit USetTC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TfrSetTC = class(TForm)
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Bevel1: TBevel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frSetTC: TfrSetTC;
  InTC: string;

function SetTimeCode(TC: string): string;

implementation

uses umain, ucommon, uinitforms, ugrid;

{$R *.dfm}

function SetTimeCode(TC: string): string;
begin
  result := TC;
  InTC := TC;
  if trim(TC) <> '' then
    frSetTC.Edit1.Text := TC
  else
    frSetTC.Edit1.Text := '00:00:00:00';
  frSetTC.ActiveControl := frSetTC.Edit1;
  frSetTC.ShowModal;
  if frSetTC.ModalResult = mrOk then
    result := frSetTC.Edit1.Text;
end;

procedure TfrSetTC.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  s: string;
  i, p1, p2, p3: integer;
begin
  if not(Key in ['0' .. '9', #8]) then
  begin
    Key := #0;
    exit;
  end;
  s := Edit1.Text;
  p2 := Edit1.SelStart;
  Case Key of
    #8:
      begin
        if Edit1.SelLength = 0 then
        begin
          if (p2 <> 3) and (p2 <> 6) and (p2 <> 9) then
          begin
            s[p2] := '0';
            Edit1.Text := s;
            Key := #0;
            if p2 > 0 then
              Edit1.SelStart := p2 - 1;
          end
          else
          begin
            s[p2] := ':';
            Edit1.Text := s;
            Key := #0;
            if p2 > 0 then
              Edit1.SelStart := p2 - 1;
          end;
        end
        else
        begin
          for i := p2 + 1 to p2 + Edit1.SelLength do
          begin
            if (i <> 3) and (i <> 6) and (i <> 9) then
              s[i] := '0';
          end;
          Edit1.SelLength := 0;
          Edit1.Text := s;
          if (p2 = 2) or (p2 = 5) or (p2 = 8) then
            Edit1.SelStart := p2 + 1;
          if p2 > 0 then
            Key := s[p2 - 1];
        end;
      end;
    '0' .. '9':
      begin
        if (p2 = 2) or (p2 = 5) or (p2 = 8) then
          p2 := p2 + 1;
        if (p2 <> 2) and (p2 <> 5) and (p2 <> 8) then
        begin
          if p2 < 11 then
            p2 := p2 + 1
          else
            p2 := 12;
          case p2 of
            1:
              if strtoint(Key) > 2 then
                Key := '2';
            2:
              if s[1] = '2' then
                if strtoint(Key) > 3 then
                  Key := '3';
            4:
              if strtoint(Key) > 5 then
                Key := '5';
            7:
              if strtoint(Key) > 5 then
                Key := '5';
            10:
              if strtoint(Key) > 2 then
                Key := '2';
            11:
              if s[10] = '2' then
                if strtoint(Key) > 4 then
                  Key := '4';
          end;
          s[p2] := Key;
          Edit1.Text := s;
          Key := #0;
          if p2 <= 11 then
          begin
            if (p2 = 2) or (p2 = 5) or (p2 = 8) then
              Edit1.SelStart := p2 + 1
            else
              Edit1.SelStart := p2;
          end;
        end;
      end;
  End;
end;

procedure TfrSetTC.Edit1Change(Sender: TObject);
var
  s: string;
begin
  s := trim(Edit1.Text);
  if length(s) > 11 then
    s := copy(s, 1, 11);
  Edit1.Text := s;
end;

procedure TfrSetTC.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 46 then
    Key := 0;
end;

procedure TfrSetTC.FormCreate(Sender: TObject);
begin
  InitfrTimeCode;
end;

procedure TfrSetTC.SpeedButton2Click(Sender: TObject);
begin
  Edit1.Text := InTC;
  ModalResult := mrCancel;
end;

procedure TfrSetTC.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrSetTC.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt In Shift) and ((Key = ord('a')) or (Key = ord('A')) or
    (Key = ord('ô')) or (Key = ord('Ô'))) then
  begin
    Edit1.SelStart := 0;
    Edit1.SelLength := length(Edit1.Text);
  end;
  case Key of
    13:
      ModalResult := mrOk;
    27:
      begin
        Edit1.Text := InTC;
        ModalResult := mrCancel;
      end;
  end;
end;

procedure TfrSetTC.SpeedButton3Click(Sender: TObject);
begin
  frSetTC.Edit1.Text := '';
  ModalResult := mrOk;
end;

procedure TfrSetTC.SpeedButton4Click(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to Form1.GridClips.RowCount - 1 do
  begin
    (Form1.GridClips.Objects[0, i] as TGridRows).MyCells[3].updatephrase
      ('StartTime', '');

  end;
  Edit1.Text := '';
  ModalResult := mrOk;
end;

end.
