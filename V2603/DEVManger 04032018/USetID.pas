unit USetID;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Spin, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFrSetID = class(TForm)
    Edit1: TEdit;
    Shape1: TShape;
    SpeedButton1: TSpeedButton;
    SpinButton1: TSpinButton;
    Label2: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    SpeedButton2: TSpeedButton;
    Edit2: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AppPath : string;
    AppName : string;
    NotServer : boolean;
  end;

var
  FrSetID: TFrSetID;
  isexit : boolean = false;
  Count : integer = 0;
  //AppPath : string;
  //AppName : ;

implementation
uses ucommon, uportoptions, uwebget, umychars, UMyInitFile;

{$R *.dfm}

procedure TFrSetID.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFrSetID.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in [#8,'0'..'9']) then key:=#0;
end;

procedure TFrSetID.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action:=caFree;
end;

procedure TFrSetID.FormCreate(Sender: TObject);
begin
  Color := ProgrammColor;
  Font.Name := ProgrammFontName;
  Font.Size := ProgrammFontSize;
  Font.Color := ProgrammFontColor;

  label4.Color := ProgrammColor;
  label4.Font.Name := ProgrammFontName;
  label4.Font.Size := ProgrammFontSize+4;
  label4.Font.Color := ProgrammFontColor;

  Edit1.Color := ProgrammEditColor;
  Edit1.Font.Name := ProgrammEditFontName;
  Edit1.Font.Size := ProgrammEditFontSize;
  Edit1.Font.Color := ProgrammEditFontColor;
  Edit2.Color := ProgrammEditColor;
  Edit2.Font.Name := ProgrammEditFontName;
  Edit2.Font.Size := ProgrammEditFontSize;
  Edit2.Font.Color := ProgrammEditFontColor;
  Shape1.Brush.Color := ProgrammColor;
  Shape1.Pen.Color := ProgrammFontColor;
  Shape2.Brush.Color := ProgrammColor;
  Shape2.Pen.Color := ProgrammFontColor;
  Shape3.Brush.Color := ProgrammColor;
  Shape3.Pen.Color := ProgrammFontColor;
  SpeedButton1.Font.Name := ProgrammFontName;
  SpeedButton1.Font.Size := ProgrammFontSize;
  SpeedButton1.Font.Color:=ProgrammFontColor;
  SpeedButton2.Font.Name := ProgrammFontName;
  SpeedButton2.Font.Size := ProgrammFontSize;
  SpeedButton2.Font.Color:=ProgrammFontColor;
  label2.Caption := 'Для запуска программного модуля' + #13#10
                    + 'необходимо задать условный номер.';
end;

procedure TFrSetID.FormShow(Sender: TObject);
begin
  label1.Visible := NotServer;
  Edit2.Visible := NotServer;
  if Edit2.Visible
    then Label2.Caption:='Управляющий сервер не обнаружен.' + #13#10
                       + 'Проверьте запущен ли он или укажите правильный URL.';
  SpeedButton1Click(nil);
end;

procedure TFrSetID.SpeedButton1Click(Sender: TObject);
var str1, str2 : string;
begin
  if trim(Edit1.Text)='' then exit;
  ManagerNumber:=strtoint(Edit1.Text);

  LoadAProtocolFromFile(AppPath + 'BProtocol' + inttostr(ManagerNumber) + '.txt');
  ReadIniFile(AppPath + AppName + inttostr(ManagerNumber) + '.ini');
  Edit2.Text := jsonware_url;
  if ProgOptions = nil then ProgOptions := TProgOptions.create;
  ProgOptions.LoadData;

  str1 := 'DEVMAN[' + inttostr(ManagerNumber) +']';
  str2:=GetJsonStrFromServer(str1);
  if server_once_connected then begin
    if Edit2.Visible then jsonware_url := Edit2.Text;
    label1.Visible := false;
    Edit2.Visible := false;
    str2 := ProgOptions.SaveToJSONStr;
    LoadProject_active := false;
    PutJsonStrToServer(str1,'');
    Edit1.Visible := false;
    SpinButton1.Visible:=false;
    label3.Visible := false;
    Label2.Caption:='Опрос работающих модулей управления';
    application.ProcessMessages;
    Count := 0;
    label4.Visible := true;
    label4.Caption := inttostr(Count);
    Timer1.Enabled := true;

    while Count<16 do begin
      label4.Caption := inttostr(Count);
      Application.ProcessMessages;
    end;
    Timer1.Enabled:=false;
    label4.Visible := false;
    Edit1.Visible := true;
    SpinButton1.Visible := true;
    label3.Visible := true;
    str2:=GetJsonStrFromServer(str1);
//    str2:=stringreplace(str2,#$D#$A,'',[rfReplaceAll, rfIgnoreCase]);
//    str2:=stringreplace(str2,chr(40),'',[rfReplaceAll, rfIgnoreCase]);
//    str2:=stringreplace(str2,');','',[rfReplaceAll, rfIgnoreCase]);
    if str2<>'' then begin
      Label2.Caption:='Модуль управления ' + inttostr(ManagerNumber) +
                      ' уже работает.' + #13#10 + 'Введите другой номер.';
      exit;
    end;
  end else begin
    Label2.Caption:='Управляющий сервер не обнаружен.' + #13#10 + 'Проверьте запущен' +
                    ' ли он или укажите правильный URL.';
    label1.Visible := true;
    Edit2.Visible := true;
    exit;
  end;
  Close;
end;

procedure TFrSetID.SpeedButton2Click(Sender: TObject);
begin
  //if trim(Edit1.Text)='' then exit;
  ManagerNumber:=-1;
  Close;
end;

procedure TFrSetID.SpinButton1DownClick(Sender: TObject);
var cn : integer;
begin
  if Trim(Edit1.text)=''
  then Edit1.text:='0'
  else begin
    cn := strtoint(Edit1.Text);
    cn := cn - 1;
    if cn<0 then Edit1.Text:='0' else Edit1.Text:=inttostr(cn);
  end;
end;

procedure TFrSetID.SpinButton1UpClick(Sender: TObject);
var cn : integer;
begin
  if Trim(Edit1.text)=''
  then Edit1.text:='0'
  else begin
    cn := strtoint(Edit1.Text);
    cn := cn + 1;
    Edit1.Text:=inttostr(cn);
  end;
end;

procedure TFrSetID.Timer1Timer(Sender: TObject);
begin
  Count:=Count+1;
  exit;
end;

end.
