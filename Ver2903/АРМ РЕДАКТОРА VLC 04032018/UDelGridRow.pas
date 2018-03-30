unit UDelGridRow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, UGrid,
  ucommon;

type
  TTypeDeletion = (delone, delall, delins, delstart, delend, delnone);
  TTypeDelTask = (tschoise, tslabel, tsdate, tslist, tsend);

  TFDelGridRow = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    pnChoiseDel: TPanel;
    SpeedButton2: TSpeedButton;
    RadioGroup1: TRadioGroup;
    pnLabel: TPanel;
    Label1: TLabel;
    pnDate: TPanel;
    DateTimePicker1: TDateTimePicker;
    Label2: TLabel;
    pnList: TPanel;
    RichEdit1: TRichEdit;
    Label3: TLabel;
    Bevel1: TBevel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnDateResize(Sender: TObject);
  private
    { Private declarations }
    // LstGridProjects : array[0..3] of string = ('Удалить выбранный проект','Удалить выделенные пректы'
    // ,'Удалить проекты дата создания которых меньше заданной'
    // ,'Удалить проекты дата окончания которых меньше заданной');
    ListDelTasks: array [0 .. 15] of TTypeDeletion;
    procedure initlistchoises(typegrid: ttypegrid);
    procedure ShowPanels;

  public
    { Public declarations }
    procedure SetFormParam;
  end;

var
  FDelGridRow: TFDelGridRow;
  CurrTask: TTypeDelTask;
  CurrDeletion: TTypeDeletion;
  CurrTypeGrid: ttypegrid = empty;
  TempResult: integer;

function GridDeleteRow1(typegrid: ttypegrid): integer;

implementation

uses umain;

{$R *.dfm}

function GridSelection(typegrid: ttypegrid; ARow: integer): string;
begin

end;

procedure TFDelGridRow.SetFormParam;
// Установка параметров формы цвет фона, текста
var
  i: integer;
  s: string;
begin
  FDelGridRow.Color := FormsColor;
  FDelGridRow.Font.Color := FormsFontColor;
  FDelGridRow.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    FDelGridRow.Font.Name := FormsFontName;
  // Panel1
  Panel1.Color := FormsColor;
  Panel1.Font.Color := FormsFontColor;
  Panel1.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    Panel1.Font.Name := FormsFontName;
  // SpeedButton1;
  SpeedButton1.Font.Color := FormsFontColor;
  SpeedButton1.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    SpeedButton1.Font.Name := FormsFontName;
  // SpeedButton2;
  SpeedButton2.Font.Color := FormsFontColor;
  SpeedButton2.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    SpeedButton2.Font.Name := FormsFontName;
  // pnChoiseDel
  pnChoiseDel.Color := FormsColor;
  pnChoiseDel.Font.Color := FormsFontColor;
  pnChoiseDel.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    pnChoiseDel.Font.Name := FormsFontName;
  // RadioGroup1
  RadioGroup1.Color := FormsColor;
  RadioGroup1.Font.Color := FormsFontColor;
  RadioGroup1.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    RadioGroup1.Font.Name := FormsFontName;
  // pnDate
  pnDate.Color := FormsColor;
  pnDate.Font.Color := FormsFontColor;
  pnDate.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    pnDate.Font.Name := FormsFontName;
  // DateTimePicker1
  DateTimePicker1.Color := clWindow; // FormsColor;
  DateTimePicker1.Font.Color := FormsFontColor;
  DateTimePicker1.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    DateTimePicker1.Font.Name := FormsFontName;
  // Label2
  Label2.Color := FormsColor;
  Label2.Font.Color := FormsFontColor;
  Label2.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    Label2.Font.Name := FormsFontName;
  // pnLabel
  pnLabel.Color := FormsColor;
  pnLabel.Font.Color := FormsFontColor;
  pnLabel.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    pnLabel.Font.Name := FormsFontName;
  // Label1
  Label1.Color := FormsColor;
  Label1.Font.Color := FormsFontColor;
  Label1.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    Label1.Font.Name := FormsFontName;
  // pnList
  pnList.Color := FormsColor;
  pnList.Font.Color := FormsFontColor;
  pnList.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    pnList.Font.Name := FormsFontName;
  // Label3
  Label3.Color := FormsColor;
  Label3.Font.Color := FormsFontColor;
  Label3.Font.Size := FormsFontSize;
  if trim(FormsFontName) <> '' then
    Label3.Font.Name := FormsFontName;
  // RichEdit1
  RichEdit1.Color := FormsColor;
  RichEdit1.Font.Color := FormsFontColor;
  RichEdit1.Font.Size := FormSSmallFont;
  if trim(FormsFontName) <> '' then
    RichEdit1.Font.Name := FormsFontName;
end;

procedure TFDelGridRow.initlistchoises(typegrid: ttypegrid);
// Установка списка альтернатив удаления записий для каждой таблицы
var
  i: integer;
begin
  for i := 0 to 15 do
    FDelGridRow.ListDelTasks[i] := delnone;
  RadioGroup1.Items.Clear;
  case typegrid of
    projects:
      begin
        RadioGroup1.Items.Add('Удалить выбранный проект');
        FDelGridRow.ListDelTasks[0] := delone;
        RadioGroup1.Items.Add('Удалить все выделенные проекты');
        FDelGridRow.ListDelTasks[1] := delins;
        RadioGroup1.Items.Add
          ('Удалить проекты время создания которых меньше указанного');
        FDelGridRow.ListDelTasks[2] := delstart;
        RadioGroup1.Items.Add
          ('Удалить проекты время окончания которых меньше указанного');
        FDelGridRow.ListDelTasks[3] := delend;
        RadioGroup1.Items.Add('Очистить список проектов');
        FDelGridRow.ListDelTasks[4] := delall;
      end;
    playlists:
      begin
        RadioGroup1.Items.Add('Удалить выбранный плей-лист');
        FDelGridRow.ListDelTasks[0] := delone;
        RadioGroup1.Items.Add('Удалить все выделенные плей-листы');
        FDelGridRow.ListDelTasks[1] := delins;
        RadioGroup1.Items.Add('Очистить список плей-листов');
        FDelGridRow.ListDelTasks[2] := delall;
      end;
    clips:
      begin
        RadioGroup1.Items.Add('Удалить выбранный клип');
        FDelGridRow.ListDelTasks[0] := delone;
        RadioGroup1.Items.Add('Удалить все выделенные клипы');
        FDelGridRow.ListDelTasks[1] := delins;
        RadioGroup1.Items.Add
          ('Удалить клипы время создания которых меньше указанного');
        FDelGridRow.ListDelTasks[2] := delstart;
        RadioGroup1.Items.Add
          ('Удалить клипы время окончания которых меньше указанного');
        FDelGridRow.ListDelTasks[3] := delend;
        RadioGroup1.Items.Add('Очистить список клипов');
        FDelGridRow.ListDelTasks[4] := delall;
      end;
    actplaylist:
      begin
        RadioGroup1.Items.Add('Удалить выбранный клип');
        FDelGridRow.ListDelTasks[0] := delone;
        RadioGroup1.Items.Add('Удалить все выделенные клипы');
        FDelGridRow.ListDelTasks[1] := delins;
        RadioGroup1.Items.Add('Очистить плей-лист');
        FDelGridRow.ListDelTasks[4] := delall;
      end;
    grtemplate:
      begin
        RadioGroup1.Items.Add('Удалить выбранный графический шаблон');
        FDelGridRow.ListDelTasks[0] := delone;
        RadioGroup1.Items.Add('Удалить все выделенные графические шаблоны');
        FDelGridRow.ListDelTasks[1] := delins;
        RadioGroup1.Items.Add('Очистить список графических шаблонов');
        FDelGridRow.ListDelTasks[2] := delall;
      end;
  end;
end;

procedure TFDelGridRow.ShowPanels;
// выбор отображения панелей
begin
  case CurrTask of
    tschoise:
      begin
        pnChoiseDel.Visible := true;
        pnDate.Visible := false;
        pnLabel.Visible := false;
        pnList.Visible := false;
      end;
    tslabel:
      begin
        pnChoiseDel.Visible := false;
        pnDate.Visible := false;
        pnLabel.Visible := true;
        pnList.Visible := false;
      end;
    tsdate:
      begin
        pnChoiseDel.Visible := false;
        pnDate.Visible := true;
        pnLabel.Visible := false;
        pnList.Visible := false;
      end;
    tslist:
      begin
        pnChoiseDel.Visible := false;
        pnDate.Visible := false;
        pnLabel.Visible := false;
        pnList.Visible := true;
      end;
    tsend:
      begin
        FDelGridRow.ModalResult := mrCancel
      end;
  end;
end;

function GridDeleteRow1(typegrid: ttypegrid): integer;
begin
  Result := -1;

  CurrTypeGrid := typegrid;
  CurrDeletion := delnone;

  CurrTask := tschoise;
  FDelGridRow.ShowPanels;
  FDelGridRow.initlistchoises(typegrid);

  // FDelGridRow.pnChoiseDel.Align:=alClient;
  FDelGridRow.ShowModal;
  If FDelGridRow.ModalResult = mrOk then
  begin
    CurrTypeGrid := empty;
  end;
end;

function SelectTypeDeletion(typegrid: ttypegrid): TTypeDeletion;
// Выбор альтернативы удаления записи из таблицы
begin
  Result := delnone;
  case typegrid of
    projects:
      begin
        case FDelGridRow.RadioGroup1.ItemIndex of
          0:
            Result := delone;
          1:
            Result := delins;
          2:
            Result := delstart;
          3:
            Result := delend;
          4:
            Result := delall;
        end;
      end;
    playlists:
      begin
        case FDelGridRow.RadioGroup1.ItemIndex of
          0:
            Result := delone;
          1:
            Result := delins;
          2:
            Result := delall;
        end;
      end;
    clips:
      begin
        case FDelGridRow.RadioGroup1.ItemIndex of
          0:
            Result := delone;
          1:
            Result := delins;
          2:
            Result := delstart;
          3:
            Result := delend;
          4:
            Result := delall;
        end;
      end;
    actplaylist:
      begin
        case FDelGridRow.RadioGroup1.ItemIndex of
          0:
            Result := delone;
          1:
            Result := delins;
          2:
            Result := delall;
        end;
      end;
    grtemplate:
      begin
        case FDelGridRow.RadioGroup1.ItemIndex of
          0:
            Result := delone;
          1:
            Result := delins;
          2:
            Result := delall;
        end;
      end;
  end;
end;

procedure TFDelGridRow.SpeedButton2Click(Sender: TObject);
begin
  FDelGridRow.ModalResult := mrCancel;
end;

// function TestGridSelection(TypeGrid : TTypeGrid) : integer;
// begin
// result:=
// end;

{ function TestGridData(TypeGrid : TTypeGrid) : integer;
  var i : integer;
  s : string;
  begin
  FDelGridRow.RichEdit1.Lines.Clear;
  case TypeGrid of
  projects : begin
  with Form1.GridProjects do begin
  For i:=1 to RowCount-1 do begin
  if Objects[1,i] is TCellsState then begin  //if1
  if (Objects[1,i] as TCellsState).Mark then begin //if2

  if Objects[0,i] is TCellsState then begin  //if3
  if (Objects[0,i] as TCellsState).Mark then begin //if4
  if Objects[3,i] is TCellsText then s:=(Objects[3,i] as TCellsText).Rows[1].Phrase[1].Text;
  FDelGridRow.RichEdit1.Lines.Add('  Строка ' + inttostr(i) + '   Проект: ' + s + ' - защищен от удаления.');
  end; //if4
  end; //if3

  end; //if2
  end; //if1
  end; //For
  end; //width
  end;
  end;
  end; }

procedure TFDelGridRow.SpeedButton1Click(Sender: TObject);
var
  res: integer;
begin
  Label1.Caption := '';
  case CurrTask of
    tschoise:
      begin
        case SelectTypeDeletion(CurrTypeGrid) of
          delone:
            begin
              // if TestGridData(CurrTypeGrid);
              // tempresult := isGridSelection(CurrTypeGrid);
              if res <> -1 then
              begin
                // Label1.Caption:='Удалить ' + ReadGridMainText(CurrTypeGrid, tempresult) + '?';
              end
              else
              begin
                Label1.Caption := 'Ни одна строка не выбрана.';
              end;
              CurrTask := tslabel;
              FDelGridRow.ShowPanels;
            end;
          delins:
            begin
              // TestGridData(CurrTypeGrid);
              CurrTask := tslabel;
              // Label1.Caption:=
              FDelGridRow.ShowPanels;
            end;
          delstart:
            begin
              // TestGridData(CurrTypeGrid);
              CurrTask := tsdate;
              FDelGridRow.ShowPanels;
            end;
          delend:
            begin
              // TestGridData(CurrTypeGrid);
              CurrTask := tsdate;
              FDelGridRow.ShowPanels;
            end;
          delall:
            begin
              // TestGridData(CurrTypeGrid);
              CurrTask := tslabel;
              FDelGridRow.ShowPanels;
            end;
        else
          FDelGridRow.ModalResult := mrOk;
        end;
      end;
    tslabel:
      begin
        case SelectTypeDeletion(CurrTypeGrid) of
          delone:
            begin
              // if isGridRowBlocking(CurrTypeGrid, tempresult)
              // then begin
              // RichEdit1.Clear;
              // RichEdit1.Lines.Add('Строка ' + inttostr(tempresult) + '  ' + ReadGridMainText(CurrTypeGrid, tempresult) + ' - защищена от удаления.');
              // CurrTask := tslist;
              // end else begin
              // //GridRowDelete(CurrTypeGrid, res);
              // FDelGridRow.ModalResult:=mrOk
              // end;
            end;
        else
          CurrTask := tsend;
        end;
        // CurrTask := tslist;
        FDelGridRow.ShowPanels;
        CurrTask := tsend;
      end;
    tsdate:
      begin
        CurrTask := tslabel;
        FDelGridRow.ShowPanels;
      end;
    tslist:
      begin

        // CurrTask := tsend;
      end;
    tsend:
      FDelGridRow.ModalResult := mrOk;
  end;
end;

procedure TFDelGridRow.FormCreate(Sender: TObject);
begin
  FDelGridRow.SetFormParam;
  pnLabel.Align := alClient;
  pnDate.Align := alClient;
  pnChoiseDel.Align := alClient;
  pnList.Align := alClient;
end;

procedure TFDelGridRow.pnDateResize(Sender: TObject);
begin
  Label2.Width := FDelGridRow.Width div 2 - 5;
  DateTimePicker1.Left := (FDelGridRow.Width div 2) + 2;
  DateTimePicker1.Top := (pnDate.Height - DateTimePicker1.Height) div 2 + 1;
end;

end.
