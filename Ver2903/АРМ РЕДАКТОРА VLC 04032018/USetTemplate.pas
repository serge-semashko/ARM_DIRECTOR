unit USetTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Buttons, utimeline;

type
  TFrSetTemplate = class(TForm)
    Panel2: TPanel;
    GridMyLists: TStringGrid;
    Edit1: TEdit;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    CheckBox1: TCheckBox;
    Panel1: TPanel;
    procedure GridMyListsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure GridMyListsDblClick(Sender: TObject);
    procedure GridMyListsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    DblClickMyLists: boolean;
    Procedure SetGrids;
  public
    { Public declarations }
  end;

var
  FrSetTemplate: TFrSetTemplate;

function SetTextTemplate(text: string; comnt: boolean): string;

implementation

uses umain, ucommon, ugrid, umyfiles, uinitforms;

{$R *.dfm}

Procedure TFrSetTemplate.SetGrids;
var
  HGHT, DLT: Integer;
begin
  initgrid(GridMyLists, RowGridListTxt, GridMyLists.Width);
  HGHT := Panel1.Height + GridMyLists.Height;
  DLT := HGHT mod (GridMyLists.Objects[0, 0] as TGridRows).HeightRow;
  Panel1.Height := DLT;
  GridMyLists.Height := HGHT - DLT;
  GridMyLists.Enabled := True;
  // if FileExists(PathTemp + '\TextTemplates.lst')
  // then LoadGridFromFile(PathTemp + '\TextTemplates.lst', GridMyLists)
  // else if FileExists(PathLists + '\TextTemplates.lst')
  // then LoadGridFromFile(PathLists + '\TextTemplates.lst', GridMyLists)
  // else GridMyLists.Enabled:=false;
end;

function SetTextTemplate(text: string; comnt: boolean): string;
begin

  FrSetTemplate.DblClickMyLists := false;
  FrSetTemplate.CheckBox1.Checked := false;
  FrSetTemplate.CheckBox1.Visible := comnt;
  if comnt then
    FrSetTemplate.Caption := 'Текстовые шаблоны (Комментарий)'
  else
    FrSetTemplate.Caption := 'Текстовые шаблоны (Основной текст)';
  FrSetTemplate.SetGrids;
  result := text;
  FrSetTemplate.Edit1.text := text;

  FrSetTemplate.ShowModal;

  if FrSetTemplate.ModalResult = mrOk then
  begin
    if FrSetTemplate.CheckBox1.Checked then
      result := '#' + FrSetTemplate.Edit1.text
    else
      result := FrSetTemplate.Edit1.text;
  end;
end;

procedure TFrSetTemplate.GridMyListsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(GridMyLists, ACol, ARow, Rect);
end;

procedure TFrSetTemplate.FormCreate(Sender: TObject);
begin
  initfrSetTemplate;
end;

procedure TFrSetTemplate.SpeedButton4Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrSetTemplate.SpeedButton3Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrSetTemplate.SpeedButton1Click(Sender: TObject);
begin
  Edit1.text := '';
end;

procedure TFrSetTemplate.GridMyListsDblClick(Sender: TObject);
begin
  DblClickMyLists := True;
end;

procedure TFrSetTemplate.GridMyListsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, rw: Integer;
begin
  rw := GridClickRow(GridMyLists, Y);
  for i := 0 to GridMyLists.RowCount - 1 do
    (GridMyLists.Objects[0, i] as TGridRows).MyCells[0].Mark := false;
  Edit1.text := (GridMyLists.Objects[0, rw] as TGridRows).MyCells[1]
    .ReadPhrase('Template');
  (GridMyLists.Objects[0, rw] as TGridRows).MyCells[0].Mark := True;
  if DblClickMyLists then
  begin
    if rw > 0 then
      if (GridMyLists.Objects[0, rw] is TGridRows) then
        ModalResult := mrOk;
    DblClickMyLists := false;
  end;
  GridMyLists.Repaint;
end;

procedure TFrSetTemplate.FormKeyPress(Sender: TObject; var Key: Char);
var
  ch: Char;
begin
  case Key of
    #13:
      ModalResult := mrOk;
    #27:
      ModalResult := mrOk;
  end;
end;

end.
