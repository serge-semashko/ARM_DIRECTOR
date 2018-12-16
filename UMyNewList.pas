unit UMyNewList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrNewList = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frNewList: TfrNewList;

procedure EditMyListTemplate(nom: integer);

implementation

uses umytexttemplate, uinitforms;

{$R *.dfm}

procedure EditMyListTemplate(nom: integer);
var
  lstnm, lblnm, lbxnm: string;
  i, ncmp, nl: integer;
begin
  frNewList.Memo1.Clear;
  if nom = -1 then
  begin
    frNewList.Edit1.Text := '';
  end
  else
  begin
    lbxnm := frMyTextTemplate.Components[nom].Name;
    nl := frMyTextTemplate.myfindcomponent('lb' + trim(lbxnm));
    frNewList.Edit1.Text := (frMyTextTemplate.Components[nl] as TLabel).Caption;
    for i := 0 to (frMyTextTemplate.Components[nom] as tlistbox).Count - 1 do
    begin
      frNewList.Memo1.Lines.Add((frMyTextTemplate.Components[nom] as tlistbox)
        .Items.Strings[i]);
    end;
  end;
  frNewList.ShowModal;
  if frNewList.ModalResult = mrOk then
  begin
    if nom = -1 then
    begin
      lbxnm := frMyTextTemplate.MyListCreate;
      ncmp := frMyTextTemplate.myfindcomponent(trim(lbxnm));
      nl := frMyTextTemplate.myfindcomponent('lb' + trim(lbxnm));
      frMyTextTemplate.ComboBox1.Items.Add(frNewList.Edit1.Text)
    end
    else
    begin
      ncmp := nom;
    end;
    (frMyTextTemplate.Components[nl] as TLabel).Caption := frNewList.Edit1.Text;
    (frMyTextTemplate.Components[ncmp] as tlistbox).Clear;
    for i := 0 to frNewList.Memo1.Lines.Count - 1 do
    begin
      if trim(frNewList.Memo1.Lines.Strings[i]) <> '' then
        (frMyTextTemplate.Components[ncmp] as tlistbox)
          .Items.Add(frNewList.Memo1.Lines.Strings[i]);
    end;
  end;
end;

procedure TfrNewList.SpeedButton5Click(Sender: TObject);
begin
  if trim(Edit1.Text) = '' then
  begin
    ActiveControl := Edit1;
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrNewList.SpeedButton4Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TfrNewList.SpeedButton3Click(Sender: TObject);
var
  lst: tstrings;
  i: integer;
begin
  lst := tstringlist.Create;
  lst.Clear;
  try
    if OpenDialog1.Execute then
    begin
      lst.LoadFromFile(OpenDialog1.FileName);
      for i := 0 to lst.Count - 1 do
      begin
        if trim(lst.Strings[i]) <> '' then
          Memo1.Lines.Add(lst.Strings[i]);
      end;
    end;
  finally
    lst.Free;
  end;
end;

procedure TfrNewList.SpeedButton6Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrNewList.FormCreate(Sender: TObject);
begin
  InitfrNewList;
end;

end.
