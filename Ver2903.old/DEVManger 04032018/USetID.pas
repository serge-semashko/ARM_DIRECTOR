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
    Label5: TLabel;
    Edit3: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrSetID.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 46 then Key := 0;
end;

procedure TFrSetID.Edit2KeyPress(Sender: TObject; var Key: Char);
var
  s: string;
  i, p1, p2, p3: Integer;
begin
   if not(Key in ['0' .. '9', #8]) then begin
     Key := #0;
     exit;
   end;
   s := Edit2.Text;
   p2 := Edit2.SelStart;
   Case Key of
     #8:
       begin
         if Edit2.SelLength = 0 then
         begin
           if (p2 <> 4) and (p2 <> 8) and (p2 <> 12) then
           begin
             s[p2] := '0';
             Edit2.Text := s;
             Key := #0;
             if p2 > 0 then
               Edit2.SelStart := p2 - 1;
           end
           else
           begin
             s[p2] := '.';
             Edit2.Text := s;
             Key := #0;
             if p2 > 0 then
               Edit2.SelStart := p2 - 1;
           end;
         end
         else
         begin
           for i := p2 + 1 to p2 + Edit2.SelLength do
           begin
             if (i <> 4) and (i <> 8) and (i <> 12) then
               s[i] := '0';
           end;
           Edit2.SelLength := 0;
           Edit2.Text := s;
           if (p2 = 3) or (p2 = 7) or (p2 = 12) then
             Edit2.SelStart := p2 + 1;
           if p2 > 0 then
             Key := s[p2 - 1];
         end;
       end;
     '0' .. '9':
       begin
         if (p2 = 3) or (p2 = 7) or (p2 = 11) then
           p2 := p2 + 1;
         if (p2 <> 3) and (p2 <> 7) and (p2 <> 11) then
         begin
           if p2 < 15 then
             p2 := p2 + 1
           else
             p2 := 16;
           // case p2 of
           // 1 : if strtoint(Key)>2 then Key:='2';
           // 2 : if s[1]='2' then if strtoint(Key)>3 then Key:='3';
           // 4 : if strtoint(Key)>5 then Key:='5';
           // 7 : if strtoint(Key)>5 then Key:='5';
           // 10: if strtoint(Key)>2 then Key:='2';
           // 11: if s[10]='2' then if strtoint(Key)>4 then Key:='4';
           // end;
           s[p2] := Key;
           Edit2.Text := s;
           Key := #0;
           if p2 <= 15 then
           begin
             if (p2 = 3) or (p2 = 7) or (p2 = 11) then
               Edit2.SelStart := p2 + 1
             else
               Edit2.SelStart := p2;
           end;
         end;
       end;
   End;
end;

procedure TFrSetID.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFrSetID.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not (key  in [#8,'0'..'9']) then key:=#0;
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
  Edit3.Color := ProgrammEditColor;
  Edit3.Font.Name := ProgrammEditFontName;
  Edit3.Font.Size := ProgrammEditFontSize;
  Edit3.Font.Color := ProgrammEditFontColor;
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
  //Edit2.Text := jsonware_url;
end;

procedure TFrSetID.FormShow(Sender: TObject);
begin
  if trim(server_addr)='' then server_addr:='127.0.0.1';

  Edit2.Text:='';//WideIPAdress(server_addr);
  Edit3.Text:='';//server_port;
  label1.Visible := NotServer;
  Edit2.Visible := NotServer;
  label5.Visible := NotServer;
  Edit3.Visible := NotServer;
  if Edit2.Visible then begin
    Label2.Caption:='Управляющий сервер не обнаружен.' + #13#10 + 'Проверьте запущен' +
                    ' ли он или укажите правильный' + #13#10 + 'IP Адрес и IP Порт.';
    Disconnect_redis;
  end;
  SpeedButton1Click(nil);
end;

procedure TFrSetID.SpeedButton1Click(Sender: TObject);
var str1, str2 : string;
begin
  if trim(Edit1.Text)='' then exit;
  ManagerNumber:=strtoint(Edit1.Text);

  LoadAProtocolFromFile(AppPath + 'BProtocol' + inttostr(ManagerNumber) + '.txt');
  if Edit2.Text='' then begin
    ReadIniFile(AppPath + AppName + inttostr(ManagerNumber) + '.ini');
    Edit2.Text:=WideIPAdress(server_addr);
    Edit3.Text:=server_port;
  end;

  server_addr := shortipadress(Edit2.Text);
  server_port := trim(Edit3.Text);
  if ProgOptions = nil then ProgOptions := TProgOptions.create;
  ProgOptions.LoadData;

  str1 := 'DEVMAN[' + inttostr(ManagerNumber) +']';
  str2:=GetJsonStrFromServer(str1);
  if server_once_connected then begin
    if Edit2.Visible then //jsonware_url := Edit2.Text;
    label1.Visible := false;
    Edit2.Visible := false;
    label5.Visible := false;
    Edit3.Visible := false;
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
                    ' ли он или укажите правильный' + #13#10 + 'IP Адрес и IP Порт.';
    Disconnect_redis;
    label1.Visible := true;
    Edit2.Visible := true;
    label5.Visible := true;
    Edit3.Visible := true;
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
