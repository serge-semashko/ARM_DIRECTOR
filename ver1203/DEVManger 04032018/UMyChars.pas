unit UMyChars;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
    Vcl.ExtCtrls, Vcl.Menus;

type
    TForm3 = class(TForm)
        SpeedButton2: TSpeedButton;
        Edit1: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        RadioButton1: TRadioButton;
        RadioButton2: TRadioButton;
        SpeedButton1: TSpeedButton;
        Shape1: TShape;
        SpeedButton3: TSpeedButton;
        SpeedButton4: TSpeedButton;
        OpenDialog1: TOpenDialog;
        procedure Edit1KeyPress(Sender: TObject; var Key: Char);
        procedure FormCreate(Sender: TObject);
        procedure SpeedButton2Click(Sender: TObject);
        procedure RadioButton1Click(Sender: TObject);
        procedure RadioButton2Click(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure SpeedButton3Click(Sender: TObject);
        procedure SpeedButton4Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    Form3: TForm3;
    InBuffCount: integer = 0;

procedure SetAProtocolData(Stri: string);
procedure LoadAProtocolFromFile(FileName: string);
procedure SaveAProtocolToFile(FileName, sprotocol: string);

implementation

uses mainunit, ucommon, comportunit, umyinitfile, umyprotocols, UPortOptions;

{$R *.dfm}

procedure TForm3.Edit1KeyPress(Sender: TObject; var Key: Char);
var
    s: string;
begin
    if RadioButton1.Checked then
    begin
        case Key of
            'ô', 'Ô', 'a':
                Key := 'A';
            'è', 'È', 'b':
                Key := 'B';
            'ñ', 'Ñ', 'c':
                Key := 'C';
            'â', 'Â', 'd':
                Key := 'D';
            'ó', 'Ó', 'e':
                Key := 'E';
            'à', 'À', 'f':
                Key := 'F';
        end;
        if Not(Key in [#8, '0', '1' .. '9', 'a', 'A', 'b', 'B', 'c', 'C', 'd',
          'D', 'e', 'E', 'f', 'F']) then
        begin
            Key := #0;
        end;
    end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
    i: integer;
    myLabel: TLabel;
begin
    Form3.Color := ProgrammColor;
    Form3.Font.Name := ProgrammFontName;
    Form3.Font.Size := ProgrammFontSize;
    Form3.Font.Color := ProgrammFontColor;

    Edit1.Color := ProgrammEditColor;
    Edit1.Font.Name := ProgrammEditFontName;
    Edit1.Font.Size := ProgrammEditFontSize;
    Edit1.Font.Color := ProgrammEditFontColor;

    // for i := 0 to Form3.ComponentCount - 1 do
    // if (Form3.Components[i] is TRadioButton) and
    // (Form3.Components[i].Tag <> 1) then
    // begin
    // myLabel := TLabel.Create(Form3.Components[i]);
    // myLabel.Parent := Form3.Components[i] as TRadioButton;
    // myLabel.Font := (Form3.Components[i] as TRadioButton).Font;
    // myLabel.Caption := (Form3.Components[i] as TRadioButton).Caption;
    // myLabel.Left := myLabel.Left + 25;
    // myLabel.Transparent := False;
    // myLabel.Left := 8;
    // myLabel.Top := 0;
    // fmmain.Components[i].Tag := 1;
    // end;

    RadioButton1.Color := ProgrammColor;
    RadioButton1.Font.Name := ProgrammFontName;
    RadioButton1.Font.Size := ProgrammFontSize;
    RadioButton1.Font.Color := ProgrammFontColor;

    RadioButton2.Color := ProgrammColor;
    RadioButton2.Font.Name := ProgrammFontName;
    RadioButton2.Font.Size := ProgrammFontSize;
    RadioButton2.Font.Color := ProgrammFontColor;

    SpeedButton1.Font.Name := ProgrammFontName;
    SpeedButton1.Font.Size := ProgrammFontSize;
    SpeedButton1.Font.Color := ProgrammFontColor;

    SpeedButton2.Font.Name := ProgrammFontName;
    SpeedButton2.Font.Size := ProgrammFontSize;
    SpeedButton2.Font.Color := ProgrammFontColor;

    Shape1.Brush.Color := ProgrammColor;
    Shape1.Pen.Color := ProgrammFontColor;
    Shape1.Top := Edit1.Top;
    Shape1.Left := Edit1.Left + Edit1.Width + 1;;
    Shape1.Height := Edit1.Height;
    Shape1.Width := Edit1.Height;
    SpeedButton1.Top := Shape1.Top;
    SpeedButton1.Left := Shape1.Left;
    SpeedButton1.Height := Shape1.Height;
    SpeedButton1.Width := Shape1.Width;

    Edit1.Text := '';
    if RadioButton1.Checked then
        Label1.Caption := HintSendBytes
    else
        Label1.Caption := HintSendChars;
end;

procedure TForm3.RadioButton1Click(Sender: TObject);
begin
    if RadioButton1.Checked then
        Label1.Caption := HintSendBytes
    else
        Label1.Caption := HintSendChars;
    Edit1.Text := '';
    ActiveControl := Edit1;
end;

procedure TForm3.RadioButton2Click(Sender: TObject);
begin
    if RadioButton2.Checked then
        Label1.Caption := HintSendChars
    else
        Label1.Caption := HintSendBytes;
    Edit1.Text := '';
    ActiveControl := Edit1;
end;

procedure TForm3.SpeedButton1Click(Sender: TObject);
begin
    Edit1.Text := '';
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
    // Edit1Change(nil);
    if RadioButton1.Checked then
        WriteBuffToPort(DataToBuffIn(Trim(Edit1.Text)))
    else
        WriteStrToPort(Edit1.Text);
end;

procedure TForm3.SpeedButton3Click(Sender: TObject);
begin
    LoadProtocol('AListProtocols.txt', 'TLDevices', INFOTypeDevice, INFOVendor,
      INFODevice, INFOProt);
end;

procedure SetAProtocolData(Stri: string);
var
    lst: tstrings;
    ss, sp: string;
    i, cnt: integer;
begin
    INFOTypeDevice := GetProtocolsParam(Stri, 'TypeDevices');
    INFOVendor := GetProtocolsParam(Stri, 'Firms');
    INFODevice := GetProtocolsParam(Stri, 'Device');
    INFOProt := GetProtocolsParam(Stri, 'Protocol');
    ss := GetProtocolsParam(Stri, 'PortSelect');
    if ansilowercase(Trim(ss)) = 'ipadress' then
        Port422select := false
    else
        Port422select := true;

    ss := GetProtocolsStr(Stri, 'Ports');
    sp := GetProtocolsStr(Stri, 'PortIP');
    if Trim(sp) <> '' then
    begin
        IPAdress := GetProtocolsParam(sp, 'IPAdress');
        IPPort := GetProtocolsParam(sp, 'IPPort');
        IPLogin := GetProtocolsParam(sp, 'Login');
        IPPassword := GetProtocolsParam(sp, 'Password');
    end;
    sp := GetProtocolsStr(ss, 'Port422');
    if Trim(sp) <> '' then
    begin
        // Port422Name := GetProtocolsParam(sp, 'IPAdress');
        // Port422Number := GetProtocolsParam(sp, 'IPAdress');
        Port422Speed := GetProtocolsParam(sp, 'Speed');
        Port422Bits := GetProtocolsParam(sp, 'Bits');
        Port422Parity := GetProtocolsParam(sp, 'Parity');
        Port422Stop := GetProtocolsParam(sp, 'Stop');
        Port422Flow := GetProtocolsParam(sp, 'Flow');
    end;

    ss := GetProtocolsStr(Stri, 'MainOptions');
    MyProtocol.Main.clear;
    MyProtocol.Main.SetString(ss, 'MainOptions');
    if MyProtocol.Main.Count > 3 then
        cnt := 3
    else
        cnt := MyProtocol.Main.Count;
    INFOName1 := '';
    INFOText1 := '';
    INFOName2 := '';
    INFOText2 := '';
    INFOName3 := '';
    INFOText3 := '';
    if cnt = 1 then
    begin
        INFOName1 := MyProtocol.Main.List[0].Name;
        INFOText1 := MyProtocol.Main.List[0].Text;
    end
    else if cnt = 2 then
    begin
        INFOName1 := MyProtocol.Main.List[0].Name;
        INFOText1 := MyProtocol.Main.List[0].Text;
        INFOName2 := MyProtocol.Main.List[1].Name;
        INFOText2 := MyProtocol.Main.List[1].Text;
    end
    else if cnt > 2 then
    begin;
        INFOName1 := MyProtocol.Main.List[0].Name;
        INFOText1 := MyProtocol.Main.List[0].Text;
        INFOName2 := MyProtocol.Main.List[1].Name;
        INFOText2 := MyProtocol.Main.List[1].Text;
        INFOName3 := MyProtocol.Main.List[2].Name;
        INFOText3 := MyProtocol.Main.List[2].Text;
    end;
    ss := GetProtocolsStr(Stri, 'AddOptions');
    MyProtocol.Options.clear;
    MyProtocol.Options.SetString(ss, 'AddOptions');
    if ProgOptions=nil then begin
      ProgOptions := TProgOptions.create;
      ProgOptions.clear;
    end;
    ProgOptions.LoadData;

end;

procedure LoadAProtocolFromFile(FileName: string);
var
    i, j: integer;
    Stri: string;
    lst: tstrings;
begin
    if not FileExists(FileName) then
        exit;
    lst := tstringlist.create;
    lst.clear;
    try
        lst.LoadFromFile(FileName);
        Stri := '';
        for i := 0 to lst.Count - 1 do
            Stri := Stri + lst.Strings[i];
        SetAProtocolData(Stri);
<<<<<<< HEAD
        StrProtocol := Stri;
=======
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    finally
        lst.free;
    end;
end;

procedure SaveAProtocolToFile(FileName, sprotocol: string);
var F: TextFile;
    i, j: integer;
    Stri: string;
    lst: tstrings;
begin
  try
      try
        AssignFile(F, FileName);
        Rewrite(F);
        Write(F, sprotocol);
      finally
        CloseFile(F);
      end
    except
      CloseFile(F);
    end;
end;

procedure TForm3.SpeedButton4Click(Sender: TObject);
var
    lst: tstrings;
    ss, sp, Stri: string;
    i, cnt: integer;
begin
    if not OpenDialog1.Execute then
        exit;
    LoadAProtocolFromFile(OpenDialog1.FileName);
end;

end.
