unit UTextTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Buttons, ExtCtrls;

type
  TFTextTemplate = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel2: TPanel;
    SpeedButton3: TSpeedButton;
    Edit1: TEdit;
    CheckListBox1: TCheckListBox;
    OpenDialog1: TOpenDialog;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    Regim: boolean;
    SelString: string;
    CRow: integer;
    CCount: integer;
    Checked: boolean;
  public
    { Public declarations }
  end;

var
  FTextTemplate: TFTextTemplate;

function TextTemplate(ARow: integer; rg: boolean; st: string): string;

implementation

uses umain, ucommon, ugrid, uinitforms;

{$R *.dfm}

procedure TFTextTemplate.SpeedButton3Click(Sender: TObject);
var
  i, cnt: integer;
begin
  if Regim then
    exit;
  cnt := 0;
  OpenDialog1.InitialDir := WorkDirTextTemplate;
  if not OpenDialog1.Execute then
    exit;
  WorkDirTextTemplate := IncludeTrailingBackslash
    (extractfilepath(OpenDialog1.FileName));
  CheckListBox1.Items.LoadFromFile(OpenDialog1.FileName);
  For i := CheckListBox1.Count - 1 downto 0 do
  begin
    if trim(CheckListBox1.Items[i]) = '' then
      CheckListBox1.Items.Delete(i)
    else
    begin
      CheckListBox1.Items[i] := trim(CheckListBox1.Items[i]);
      CheckListBox1.Checked[i] := true;
      cnt := cnt + 1;
    end;
  end;
  if cnt > 0 then
  begin
    Checked := false;
    SpeedButton4.Caption := 'Снять выделение';
  end
  else
  begin
    Checked := true;
    SpeedButton4.Caption := 'Выделить всё';
  end;
end;

function TextTemplate(ARow: integer; rg: boolean; st: string): string;
var
  i, ps: integer;
begin
  if WorkDirTextTemplate <> '' then
    FTextTemplate.OpenDialog1.InitialDir := WorkDirTextTemplate;
  FTextTemplate.Regim := rg;
  FTextTemplate.SelString := '';
  FTextTemplate.CRow := ARow;
  FTextTemplate.CCount := 0;
  FTextTemplate.Checked := false;

  Result := '';
  if rg then
  begin
    FTextTemplate.Edit1.Text := st;
    FTextTemplate.Panel2.Enabled := true;
    FTextTemplate.CheckListBox1.Enabled := true;
    FTextTemplate.CheckListBox1.Color := FormsEditColor;
    FTextTemplate.SpeedButton3.Visible := false;
    FTextTemplate.SpeedButton4.Visible := false;
    FTextTemplate.SpeedButton5.Visible := false;
  end
  else
  begin
    FTextTemplate.CheckListBox1.Items.Clear;
    if ARow = -1 then
    begin
      FTextTemplate.Edit1.Text := '';
      FTextTemplate.Panel2.Enabled := true;
      FTextTemplate.CheckListBox1.Enabled := true;
      FTextTemplate.CheckListBox1.Color := FormsEditColor;
      FTextTemplate.SpeedButton3.Visible := true;
      FTextTemplate.SpeedButton4.Visible := true;
      FTextTemplate.SpeedButton5.Visible := true;
    end
    else
    begin
      FTextTemplate.Edit1.Text :=
        (Form1.GridLists.Objects[0, ARow] as TGridRows).MyCells[1]
        .ReadPhrase('Template');
      FTextTemplate.Panel2.Enabled := false;
      FTextTemplate.CheckListBox1.Enabled := false;
      FTextTemplate.CheckListBox1.Color := FormsColor;
      FTextTemplate.SpeedButton3.Visible := false;
      FTextTemplate.SpeedButton4.Visible := false;
      FTextTemplate.SpeedButton5.Visible := false;
    end;
  end;
  FTextTemplate.ShowModal;
  if FTextTemplate.ModalResult = mrOk then
  begin
    if rg then
    begin
      Result := FTextTemplate.SelString;
    end
    else
    begin
      if ARow = -1 then
      begin
        if FTextTemplate.CCount > 0 then
        begin
          for i := 0 to FTextTemplate.CheckListBox1.Count - 1 do
          begin
            if FTextTemplate.CheckListBox1.Checked[i] then
            begin
              ps := GridAddRow(Form1.GridLists, RowGridListTxt);
              IDTXTTmp := IDTXTTmp + 1;
              (Form1.GridLists.Objects[0, ps] as TGridRows).ID := IDTXTTmp;
              (Form1.GridLists.Objects[0, ps] as TGridRows).MyCells[1]
                .UpdatePhrase('Template', FTextTemplate.CheckListBox1.Items[i]);
            end
          end;
          exit;
        end;
        if trim(FTextTemplate.Edit1.Text) <> '' then
        begin
          ps := GridAddRow(Form1.GridLists, RowGridListTxt);
          IDTXTTmp := IDTXTTmp + 1;
          (Form1.GridLists.Objects[0, ps] as TGridRows).ID := IDTXTTmp;
          (Form1.GridLists.Objects[0, ps] as TGridRows).MyCells[1]
            .UpdatePhrase('Template', FTextTemplate.Edit1.Text)
        end
      end
      else
      begin
        (Form1.GridLists.Objects[0, ARow] as TGridRows).MyCells[1]
          .UpdatePhrase('Template', FTextTemplate.Edit1.Text);
      end;
    end;
  end;
end;

procedure TFTextTemplate.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFTextTemplate.SpeedButton1Click(Sender: TObject);
var
  i, cnt: integer;
begin
  if Regim then
  begin
    if trim(Edit1.Text) <> '' then
    begin
      SelString := Edit1.Text;
      ModalResult := mrOk;
    end
    else
    begin
      if CheckListBox1.ItemIndex <> -1 then
      begin
        SelString := CheckListBox1.Items[CheckListBox1.ItemIndex];
        ModalResult := mrOk;
      end;
    end;
    exit;
  end;
  if CRow = -1 then
  begin
    cnt := 0;
    if CheckListBox1.Count > 0 then
    begin
      for i := 0 to CheckListBox1.Count - 1 do
        if CheckListBox1.Checked[i] then
          CCount := CCount + 1;
      if CCount > 0 then
      begin
        ModalResult := mrOk;
        exit;
      end;
    end;
    if trim(Edit1.Text) <> '' then
    begin
      ModalResult := mrOk;
      exit;
    end;
  end
  else
  begin
    if trim(Edit1.Text) <> '' then
    begin
      ModalResult := mrOk;
      exit;
    end;
  end;
  ActiveControl := Edit1;
end;

procedure TFTextTemplate.CheckListBox1Click(Sender: TObject);
begin
  if Regim then
    exit;
  // CheckListBox1.Checked[CheckListBox1.ItemIndex] := not CheckListBox1.Checked[CheckListBox1.ItemIndex];
end;

procedure TFTextTemplate.SpeedButton5Click(Sender: TObject);
begin
  FTextTemplate.CheckListBox1.Clear;
end;

procedure TFTextTemplate.CheckListBox1DblClick(Sender: TObject);
begin
  if Regim then
  begin
    SelString := CheckListBox1.Items[CheckListBox1.ItemIndex];
    ModalResult := mrOk;
    exit;
  end;
end;

procedure TFTextTemplate.SpeedButton4Click(Sender: TObject);
var
  i: integer;
begin
  if CheckListBox1.Count <= 0 then
    exit;
  for i := 0 to CheckListBox1.Count - 1 do
  begin
    CheckListBox1.Checked[i] := Checked;
  end;
  CheckListBox1.Repaint;
  Checked := not Checked;
  if Checked then
    SpeedButton4.Caption := 'Выделить всё'
  else
    SpeedButton4.Caption := 'Снять выделение';
end;

procedure TFTextTemplate.FormCreate(Sender: TObject);
begin
  FTextTemplate.Checked := false;
  InitTextTemplates;
end;

procedure TFTextTemplate.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    SpeedButton1Click(nil);
    exit;
  end;
  if Key = 27 then
    ModalResult := mrCancel;
end;

end.
