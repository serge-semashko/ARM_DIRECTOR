unit UProject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid;

Type
  TFNewProject = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Memo1: TMemo;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNewProject: TFNewProject;

function CreateProject(mode: integer): boolean;
function OpenProject: boolean;
procedure SaveProjectAs;
procedure SaveProject;

implementation

uses umain, ucommon, uinitforms, umymessage, umyfiles, ugrtimelines, uplaylists,
  umytexttable, uactplaylist;

{$R *.dfm}

function OpenProject: boolean;
var
  i, ps: integer;
begin
  result := false;
  with Form1 do
  begin
    if IsProjectChanges then
    begin
      if MyTextMessage('Вопрос', 'Сохранить текущий проект ' + FileNameProject +
        '?', 2) then
        SaveProject;
    end;
    opendialog1.InitialDir := PathProject;
    opendialog1.FileName := FileNameProject;
    opendialog1.Filter := 'Файлы проета (*.proj)|*.PROJ|Все файлы (*.*)|*.*';
    opendialog1.FilterIndex := 0;
    if not opendialog1.Execute then
      exit;
    result := true;
    FileNameProject := opendialog1.FileName;
    ReadProjectFromFile(opendialog1.FileName);
    savedialog1.FileName := FileNameProject;
    TLZone.ClearZone;
    Form1.lbActiveClipID.Caption := '';
    Label2Click(nil);
    SetMainGridPanel(projects);
    IsProjectChanges := false;
    ClearClipsStatusPlay;
    ListBox1.Clear;
    for i := 1 to GridLists.RowCount - 1 do
    begin
      ListBox1.Items.Add((GridLists.Objects[0, i] as TGridRows).MyCells[3]
        .ReadPhrase('Name'));
      ps := ListBox1.Items.Count - 1;
      if not(ListBox1.Items.Objects[ps] is TMyListBoxObject) then
        ListBox1.Items.Objects[ps] := TMyListBoxObject.Create;
      (ListBox1.Items.Objects[ps] as TMyListBoxObject).ClipId :=
        (GridLists.Objects[0, i] as TGridRows).MyCells[3].ReadPhrase('Note');
    end;
    ps := UGrid.findgridselection(Form1.GridLists, 2);
    if ps > 0 then
    begin
      ListBox1.ItemIndex := ps - 1;
      ListBox1Click(nil);
    end;
  end;
end;

procedure SaveProjectAs;
var
  nm, ext: string;
begin
  SaveClipFromPanelPrepare;
  with Form1 do
  begin
    savedialog1.InitialDir := PathProject;
    savedialog1.FileName := FileNameProject;
    savedialog1.Filter := 'Файлы проета (*.proj)|*.PROJ|Все файлы (*.*)|*.*';
    savedialog1.FilterIndex := 0;
    if not savedialog1.Execute then
      exit;
    nm := savedialog1.FileName;
    ext := extractfileext(nm);
    if trim(ext) = '' then
      nm := nm + '.proj';
    SaveProjectToFile(nm);
    WriteEditedProjects(nm);
    FileNameProject := nm;
    pntlproj.SetText('FileName', extractfilename(nm));
    pntlproj.Draw(imgpntlproj.Canvas);
    imgpntlproj.Repaint;
    IsProjectChanges := false;
  end;
end;

procedure SaveProject;
begin
  if trim(FileNameProject) <> '' then
  begin
    SaveClipFromPanelPrepare;
    SaveProjectToFile(FileNameProject);
    IsProjectChanges := false;
    WriteEditedProjects(FileNameProject);
  end
  else
    SaveProjectAs;
end;

function CreateProject(mode: integer): boolean;
var
  i, setpos, ps: integer;
  dt, nm: string;
begin
  // if IsProjectChanges then begin
  // if MyTextMessage('Вопрос', 'Сохранить текущий проект?',2) then SaveProject;
  // end;
  result := false;
  if mode < 0 then
  begin
    if IsProjectChanges then
    begin
      if MyTextMessage('Вопрос', 'Сохранить текущий проект?', 2) then
      begin
        if trim(FileNameProject) = '' then
          SaveProjectAs
        else
          SaveProject;
      end;
    end;
    FNewProject.Edit1.Text := '';
    FNewProject.Memo1.Text := '';
    FNewProject.DateTimePicker1.DateTime := now + DeltaDateDelete;
  end
  else
  begin
    FNewProject.Edit1.Text := pntlproj.GetText('ProjectName');
    // Form1.lbProjectName.Caption;
    FNewProject.Memo1.Text := pntlproj.GetText('CommentText');
    // Form1.lbpComment.Caption;
    if trim(pntlproj.GetText('DateEnd')) = '' then
      FNewProject.DateTimePicker1.DateTime := now + DeltaDateDelete
    else
      FNewProject.DateTimePicker1.DateTime :=
        strtodate(pntlproj.GetText('DateEnd'));
  end;

  FNewProject.ActiveControl := FNewProject.Edit1;
  FNewProject.ShowModal;

  if FNewProject.ModalResult = mrOk then
  begin
    result := true;
    if mode < 0 then
    begin
      SetMainGridPanel(projects);
      FileNameProject := '';
      pntlproj.SetText('FileName', '');
      ProjectNumber := createunicumname;
      GridClear(Form1.GridLists, RowGridListPL);
      GridClear(Form1.GridActPlayList, RowGridClips);
      GridClear(Form1.GridClips, RowGridClips);
      Form1.Label2.Caption := '';
      LoadDefaultClipToPlayer;
      TLZone.ClearZone;
    end;
    pntlproj.SetText('ProjectName', trim(FNewProject.Edit1.Text));
    pntlproj.SetText('CommentText', FNewProject.Memo1.Text);
    pntlproj.SetText('DateStart', datetostr(now));
    pntlproj.SetText('DateEnd', datetostr(FNewProject.DateTimePicker1.Date));
    pntlproj.Draw(Form1.imgpntlproj.Canvas);
    Form1.imgpntlproj.Repaint;
    IsProjectChanges := true;
  end;
end;

procedure TFNewProject.SpeedButton1Click(Sender: TObject);
begin
  if trim(FNewProject.Edit1.Text) <> '' then
    FNewProject.ModalResult := mrOk
  else
    ActiveControl := Edit1;
end;

procedure TFNewProject.SpeedButton2Click(Sender: TObject);
begin
  FNewProject.ModalResult := mrCancel;
end;

procedure TFNewProject.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    if ActiveControl = Memo1 then
      exit;
    SpeedButton1Click(nil);
  end;
  if Key = 27 then
    ModalResult := mrCancel;
end;

procedure TFNewProject.FormCreate(Sender: TObject);
begin
  InitNewProject;
end;

end.
