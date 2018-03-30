unit USetEventData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, UMyEvents, Spin;

type
  TfrSetEventData = class(TForm)
    Edit1: TEdit;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    DataType: string;
  public
    { Public declarations }
  end;

var
  frSetEventData: TfrSetEventData;

procedure SetEventData(ev: TMyEvent; Name: string);

implementation

uses umain, ucommon, UMyLists, ugrtimelines, utimeline, uinitforms;

{$R *.dfm}

procedure SetEventData(ev: TMyEvent; Name: string);
var
  lsnm, dt, txt: string;
  i, index, ps, lstindx: integer;
  vsbl: boolean;
  data: longint;
begin
  lsnm := trim(lowercase(ev.ReadPhraseListName(Name)));
  dt := trim(lowercase(ev.ReadPhraseType(Name)));
  frSetEventData.DataType := dt;
  frSetEventData.Label1.Caption := Name;
  frSetEventData.Label2.Visible := false;
  if lsnm <> '' then
  begin
    lstindx := ProgrammLists.ReadList(lsnm, frSetEventData.ComboBox1.Items);
    txt := ev.ReadPhraseText(Name);
    Index := frSetEventData.ComboBox1.Items.IndexOf(txt);
    if Index < 0 then
      Index := 0;
    frSetEventData.ComboBox1.ItemIndex := Index;
    frSetEventData.ComboBox1.Visible := true;
    frSetEventData.Edit1.Visible := false;
    frSetEventData.SpinEdit1.Visible := false;
    frSetEventData.ActiveControl := frSetEventData.ComboBox1;
  end
  else
  begin
    if (dt = 'data') or (dt = 'integer') or (dt = 'tag') or
      (dt = 'shorttimecode') or (dt = 'timecode') or (dt = 'device') then
    begin
      frSetEventData.ComboBox1.Visible := false;
      frSetEventData.Edit1.Visible := false;
      frSetEventData.SpinEdit1.Visible := true;
      if (dt = 'data') or (dt = 'integer') then
      begin
        frSetEventData.SpinEdit1.Value := ev.ReadPhraseData(Name);
      end;
      if dt = 'tag' then
      begin
        frSetEventData.SpinEdit1.Value := ev.ReadPhraseTag(Name);
      end;
      if (dt = 'shorttimecode') or (dt = 'timecode') then
      begin
        frSetEventData.Label2.Visible := true;
        frSetEventData.SpinEdit1.Value := ev.ReadPhraseData(Name);
        frSetEventData.Label2.Caption :=
          FramesToShortStr(frSetEventData.SpinEdit1.Value);
      end;
      if dt = 'device' then
      begin
        frSetEventData.SpinEdit1.Value := ev.ReadPhraseData(Name);
      end;
      frSetEventData.ActiveControl := frSetEventData.SpinEdit1;
      frSetEventData.SpinEdit1.SelectAll;
    end
    else
    begin
      frSetEventData.ComboBox1.Visible := false;
      frSetEventData.Edit1.Visible := true;
      frSetEventData.SpinEdit1.Visible := false;
      if dt = 'text' then
        frSetEventData.Edit1.Text := ev.ReadPhraseText(Name);
      if dt = 'command' then
        frSetEventData.Edit1.Text := ev.ReadPhraseCommand(Name);
      frSetEventData.ActiveControl := frSetEventData.Edit1;
    end;
  end;
  frSetEventData.ShowModal;
  if frSetEventData.ModalResult = mrOk then
  begin
    if frSetEventData.Edit1.Visible then
    begin
      if dt = 'text' then
        ev.SetPhraseText(Name, frSetEventData.Edit1.Text);
      if dt = 'command' then
        ev.SetPhraseText(Name, frSetEventData.Edit1.Text);
      exit;
    end;

    if frSetEventData.SpinEdit1.Visible then
    begin
      if dt = 'tag' then
      begin
        ev.SetPhraseTag(Name, frSetEventData.SpinEdit1.Value);
        ev.SetPhraseText(Name, frSetEventData.SpinEdit1.Text);
      end;
      if (dt = 'data') or (dt = 'integer') then
      begin
        ev.SetPhraseData(Name, frSetEventData.SpinEdit1.Value);
        ev.SetPhraseText(Name, frSetEventData.SpinEdit1.Text);
      end;
      if (dt = 'timecode') or (dt = 'shorttimecode') then
      begin
        ev.SetPhraseData(Name, frSetEventData.SpinEdit1.Value);
        ev.SetPhraseText(Name,
          FramesToShortStr(frSetEventData.SpinEdit1.Value));
      end;
      if (dt = 'device') then
      begin
        ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
        if (Form1.GridTimeLines.Objects[0, ps + 1] as TTimelineOptions).CountDev
          < frSetEventData.SpinEdit1.Value then
          exit;
        if frSetEventData.SpinEdit1.Value <= 0 then
          exit;
        txt := (Form1.GridTimeLines.Objects[0, ps + 1] as TTimelineOptions)
          .DevEvents[frSetEventData.SpinEdit1.Value - 1].ReadPhraseText
          ('Device');
        ev.SetPhraseText(Name, (Form1.GridTimeLines.Objects[0,
          ps + 1] as TTimelineOptions).DevEvents[frSetEventData.SpinEdit1.Value
          - 1].ReadPhraseText('Device'));
        ev.Color := (Form1.GridTimeLines.Objects[0, ps + 1] as TTimelineOptions)
          .DevEvents[frSetEventData.SpinEdit1.Value - 1].Color;
        ev.SetPhraseData(Name, frSetEventData.SpinEdit1.Value);
      end;
      exit;
    end;

    if frSetEventData.ComboBox1.Visible then
    begin
      for i := 0 to ProgrammLists.Lists[lstindx].Lists
        [frSetEventData.ComboBox1.ItemIndex].count - 1 do
      begin
        ev.SetDependentField(ProgrammLists.Lists[lstindx].Lists
          [frSetEventData.ComboBox1.ItemIndex].Lists[i]);
        if ProgrammLists.Lists[lstindx].Lists
          [frSetEventData.ComboBox1.ItemIndex].Lists[i].Visible and
          (trim(lowercase(ProgrammLists.Lists[lstindx].Lists
          [frSetEventData.ComboBox1.ItemIndex].Lists[i].TypeObject)) = 'phrase')
        then
          SetEventData(ev, ProgrammLists.Lists[lstindx].Lists
            [frSetEventData.ComboBox1.ItemIndex].Lists[i].Name);
      end;
      ev.SetPhraseText(Name, frSetEventData.ComboBox1.Text);
      exit;
    end;
  end;
end;

procedure TfrSetEventData.FormCreate(Sender: TObject);
begin
  Edit1.Left := 10;
  ComboBox1.Left := 10;
  SpinEdit1.Left := 10;
  Edit1.Width := Width - 20;
  ComboBox1.Width := Width - 20;
  SpinEdit1.Width := Width - 20;
  InitFrSetEventData;
end;

procedure TfrSetEventData.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrSetEventData.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrSetEventData.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Text = '' then
    exit;
  if SpinEdit1.Text = '-' then
    exit;
  if SpinEdit1.Text = '+' then
    exit;
  if (DataType = 'timecode') or (DataType = 'shorttimecode') then
    Label2.Caption := FramesToShortStr(SpinEdit1.Value);
end;

procedure TfrSetEventData.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      ModalResult := mrOk;
    #27:
      ModalResult := mrCancel;
  end;
end;

end.
