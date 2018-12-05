unit UMyLTC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Vcl.ExtCtrls, Grids,uwebget;

type
  TfrLTC = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit1: TEdit;
    Label2: TLabel;
    SpeedButton3: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frLTC: TfrLTC;

procedure SetLTC(tp: integer);
function findclipingrid(grid: tstringgrid; clpid: string): integer;

implementation

uses umain, ucommon, uinitforms, umymessage, ugrid, uplayer, ugrtimelines;

{$R *.dfm}

function TextTimeCodeOK(txt: string): boolean;
var
  hh, mm, ss, ms: string;
  ihh, imm, iss, ims: integer;
begin
  result := false;
  if length(txt) < 11 then
    exit;
  if (txt[3] <> ':') and (txt[6] <> ':') and (txt[9] <> ':') then
    exit;
  if not(txt[1] in ['0' .. '9']) then
    exit;
  if not(txt[2] in ['0' .. '9']) then
    exit;
  hh := txt[1] + txt[2];
  ihh := strtoint(hh);
  if (ihh < 0) or (ihh > 23) then
    exit;

  if not(txt[4] in ['0' .. '9']) then
    exit;
  if not(txt[5] in ['0' .. '9']) then
    exit;
  mm := txt[4] + txt[5];
  imm := strtoint(mm);
  if (imm < 0) or (imm > 59) then
    exit;

  if not(txt[7] in ['0' .. '9']) then
    exit;
  if not(txt[8] in ['0' .. '9']) then
    exit;
  ss := txt[7] + txt[8];
  iss := strtoint(ss);
  if (iss < 0) or (iss > 59) then
    exit;

  if not(txt[10] in ['0' .. '9']) then
    exit;
  if not(txt[11] in ['0' .. '9']) then
    exit;
  ms := txt[10] + txt[11];
  ims := strtoint(ms);
  if (ims < 0) or (ims > 24) then
    exit;

  result := true;
end;

procedure SetLTC(tp: integer);
var
  ps: integer;
  txt: string;
  dtc: double;
  ftm, fen: longint;
begin
  if tp = 1 then
  begin
    frLTC.Panel2.Visible := false;
    frLTC.Panel1.Visible := true;
    frLTC.SpeedButton1.Visible := false;
    frLTC.SpeedButton3.Visible := false;
  end
  else
  begin
    if trim(Form1.lbActiveClipID.Caption) = '' then
      exit;
    frLTC.Panel2.Visible := true;
    frLTC.Panel1.Visible := false;
    frLTC.SpeedButton1.Visible := true;
    frLTC.SpeedButton3.Visible := true;
  end;
  // MyStartReady:=false;
  // Form1.MySynhro.Checked := false;
  if (frLTC.RadioButton1.Checked = false) and
    (frLTC.RadioButton2.Checked = false) then
    frLTC.RadioButton1.Checked := true;
  if MySinhro = chltc then
    frLTC.RadioButton2.Checked := true
  else
    frLTC.RadioButton1.Checked := true;;

  if MyStartPlay = -1 then
    frLTC.Edit1.Text := '00:00:00:00'
  else
    frLTC.Edit1.Text := trim(FramesToStr(MyStartPlay));
  frLTC.Edit1.SelStart;
  frLTC.Edit1.SelLength := length(frLTC.Edit1.Text);
  frLTC.ShowModal;
  if tp <> 1 then
    frLTC.ActiveControl := frLTC.Edit1;
  if frLTC.ModalResult = mrOk then
  begin
    if tp = 1 then
    begin
      if frLTC.RadioButton1.Checked then
      begin
        MySinhro := chsystem;
        Form1.lbSynchRegim.Caption := 'Системное время';
      end;
      if frLTC.RadioButton2.Checked then
      begin
        MySinhro := chltc;
        Form1.compartido^.Cadena := 'request';
        Form1.lbSynchRegim.Caption := 'Внешний тайм-код [LTC]';
      end;
    end
    else
    begin
      ps := findclipingrid(Form1.GridClips, trim(Form1.lbActiveClipID.Caption));
      if ps >= 1 then
        (Form1.GridClips.Objects[0, ps] as tgridrows).MyCells[3].UpdatePhrase
          ('StartTime', trim(frLTC.Edit1.Text));
      ps := findclipingrid(Form1.GridActPlayList,
        trim(Form1.lbActiveClipID.Caption));
      if ps >= 1 then
        (Form1.GridActPlayList.Objects[0, ps] as tgridrows).MyCells[3]
          .UpdatePhrase('StartTime', trim(frLTC.Edit1.Text));
      MyStartPlay := StrTimeCodeToFrames(frLTC.Edit1.Text);
      // -----------------------------------
      if Form1.MySynhro.Checked and MyTimer.Enable then
      begin
        dtc := now - TimeCodeDelta;
        ftm := TimeToFrames(dtc);
        fen := MyStartPlay + (TLParameters.Finish - TLParameters.Start);
        if ftm >= fen then
          Form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor, 72);
        MediaStop;
        if ftm < fen then
        begin
          if ftm < MyStartPlay then begin
            TLParameters.Position := TLParameters.Start;
          end
          else
            TLParameters.Position := TLParameters.Start + ftm - MyStartPlay;
          PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
          MediaSetPosition(TLParameters.Position, false, 'SetLTC');
          TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmptimeline);
          MediaPlay;
        end;
      end;
      // -----------------------------------
    end;
    // MyStartReady := true;
    // Form1.MySynhro.Checked := true;
  end;
end;

procedure TfrLTC.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrLTC.SpeedButton2Click(Sender: TObject);
begin
  if TextTimeCodeOK(Edit1.Text) then
    ModalResult := mrOk
  else
  begin
    // fMyMessage.ModalResult:=mrNone;
    MyTextMessage('Предупреждение', 'Не правильно задан тайм-код,' + #10#13 +
      'формат должен быть HH:MM:SS:FF' + #10#13 +
      'HH:(0..23), MM:(0..59), SS:(0..59), FF:(0..24)', 1);
    ActiveControl := Edit1;
  end;
end;

procedure TfrLTC.SpeedButton3Click(Sender: TObject);
begin
  MyStartPlay := -1;
  Form1.lbTypeTC.Caption := '';
  ModalResult := mrCancel;
end;

procedure TfrLTC.FormCreate(Sender: TObject);
begin
  InitFrLTC;
end;

procedure TfrLTC.Edit1KeyPress(Sender: TObject; var Key: Char);
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

function findclipingrid(grid: tstringgrid; clpid: string): integer;
var
  i: integer;
  txt: string;
begin
  result := -1;
  with Form1 do
  begin
    for i := 1 to grid.RowCount - 1 do
    begin
      txt := trim((grid.Objects[0, i] as tgridrows).MyCells[3]
        .ReadPhrase('ClipId'));
      if txt = trim(clpid) then
      begin
        result := i;
        exit;
      end;
    end;
  end;
end;

procedure TfrLTC.RadioButton1Click(Sender: TObject);
var
  ps: integer;
  txt: string;
begin
  if trim(Form1.lbActiveClipID.Caption) <> '' then
  begin
    ps := findclipingrid(Form1.GridClips, Form1.lbActiveClipID.Caption);
    txt := trim((Form1.GridClips.Objects[0, ps] as tgridrows).MyCells[3]
      .ReadPhrase('StartTime'));
    if txt = '' then
      Edit1.Text := TimeToTimeCodeStr(now)
    else
      Edit1.Text := txt;
  end;
end;

procedure TfrLTC.RadioButton2Click(Sender: TObject);
var
  ps: integer;
  txt: string;
begin
  if trim(Form1.lbActiveClipID.Caption) <> '' then
  begin
    ps := findclipingrid(Form1.GridClips, Form1.lbActiveClipID.Caption);
    txt := trim((Form1.GridClips.Objects[0, ps] as tgridrows).MyCells[3]
      .ReadPhrase('StartTime'));
    if txt = '' then
      Edit1.Text := TimeToTimeCodeStr(now - MyShift)
    else
      Edit1.Text := txt;
  end;
end;

procedure TfrLTC.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssAlt In Shift) and ((Key = ord('a')) or (Key = ord('A')) or
    (Key = ord('ф')) or (Key = ord('Ф'))) then
  begin
    Edit1.SelStart := 0;
    Edit1.SelLength := length(Edit1.Text);
  end;
  if Key = 27 then
    ModalResult := mrCancel;
  if Key = 13 then
  begin
    SpeedButton2Click(nil);
    Key := 0;
  end;
end;

procedure TfrLTC.Edit1Change(Sender: TObject);
var
  s: string;
begin
  s := trim(Edit1.Text);
  if length(s) > 11 then
    s := copy(s, 1, 11);
  Edit1.Text := s;
end;

procedure TfrLTC.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 46 then
    Key := 0;
end;

end.
