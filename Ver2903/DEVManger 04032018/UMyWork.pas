unit UMyWork;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.StdCtrls;

type
  TFrMyWork = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Timer2: TTimer;
    PopupMenu1: TPopupMenu;
    PopDelete: TMenuItem;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    N1: TMenuItem;
    Timer1: TTimer;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton6: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SpeedButton7: TSpeedButton;
    sbLoop: TSpeedButton;
    SpeedButton9: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    TimeStart : TTime;
    CurrPosition : integer;
  end;

var
  FrMyWork: TFrMyWork;

function MyTimeToStr(dt : TTime) : string;

implementation
uses uaddcommand, ucommon, umysettc, mainunit, ComPortUnit, umychars, umyinitfile;

{$R *.dfm}



function twochar(zn : word) : string;
var s : string;
begin
  s:=inttostr(zn);
  if length(s)=1 then result:='0'+s else result:=s;
end;

function MyTimeToStr(dt : TTime) : string;
var hh,mm,ss,ms : word;
begin
  decodetime(dt,hh,mm,ss,ms);
  result:=twochar(hh) + ':' + twochar(mm) + ':' + twochar(ss) + ':' + twochar(ms div 40);
end;

procedure TFrMyWork.SpeedButton1Click(Sender: TObject);
begin
//  if Not CommThreadExists then begin
//    MessageDlg('COM-порт не инициализирован.', mtInformation, [mbOk], 0, mbOk);
//    exit;
//  end;
  SpeedButton1.Enabled:=false;
  SpeedButton2.Enabled:=true;
  SpeedButton3.Enabled:=false;
  SetTC;
  CurrPosition:=1;
  Label2.Caption:=MyTimeToStr(TimeStart);
  Timer2.Enabled:=true;
end;

procedure TFrMyWork.SpeedButton2Click(Sender: TObject);
Var i : integer;
begin
  Timer2.Enabled:=false;
  SpeedButton1.Enabled:=true;
  SpeedButton2.Enabled:=false;
  SpeedButton3.Enabled:=true;
  for i:=1 to StringGrid1.RowCount-1 do begin
    StringGrid1.Cells[0,i]:=inttostr(i);
    if trim(StringGrid1.Cells[1,i])<>''
      then StringGrid1.Cells[1,i]:=MyTimeToStr(MyStrToTime(StringGrid1.Cells[1,i])-TimeStart);
  end;
  stringgrid1.Repaint;
end;

procedure TFrMyWork.SpeedButton3Click(Sender: TObject);
begin
  AddCommand(-1);
end;

procedure TFrMyWork.SpeedButton4Click(Sender: TObject);
var ext : string;
begin
  savedialog1.FileName:=extractfilename(CommandFile);
  if not savedialog1.Execute then exit;
  //WorkGridToFile(savedialog1.FileName);
  CommandFile:=savedialog1.FileName;
  ext:=extractfileext(CommandFile);
  if trim(ext)='' then CommandFile:=CommandFile+'.comn';
end;

procedure TFrMyWork.SpeedButton5Click(Sender: TObject);
begin
  opendialog1.FileName:=extractfilename(CommandFile);
  if not opendialog1.Execute then exit;
  CommandFile:=opendialog1.FileName;
end;

procedure TFrMyWork.StringGrid1DblClick(Sender: TObject);
begin
  if (Stringgrid1.Row>0) and (Stringgrid1.Row<Stringgrid1.RowCount) then begin
    AddCommand(Stringgrid1.Row);
  end;
end;

procedure TFrMyWork.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var ps : integer;
    color : tcolor;
begin
  if ARow=0 then exit;
  ps:=pos('+',Stringgrid1.Cells[0,ARow]);
  if ARow=Stringgrid1.Row
  then color:=clAqua else if ps>0 then color:=clBtnFace else color:=clWindow;
  StringGrid1.Canvas.Brush.Color:=color;
  StringGrid1.Canvas.FillRect(Rect);
  StringGrid1.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,Stringgrid1.Cells[ACol,ARow]);
end;

procedure TFrMyWork.StringGrid1TopLeftChanged(Sender: TObject);
begin
  StringGrid1.LeftCol:=1;
end;

procedure TFrMyWork.Timer1Timer(Sender: TObject);
begin
  Label1.Caption:=MyTimeToStr(now);
end;

procedure TFrMyWork.Timer2Timer(Sender: TObject);
var i, j, cnt, ps : integer;
    dtt, dts, dtn : ttime;
begin
  //Label1.Caption:=MyTimeToStr(now);
  //application.ProcessMessages;
  dtt:=now;
  if CurrPosition=StringGrid1.RowCount-1 then begin
    ps:=pos('+', StringGrid1.Cells[0,CurrPosition]);
    if ps>0 then begin
      if sbLoop.Down then begin
        dtn:=Now;
        Stringgrid1.Row:=1;
        CurrPosition:=1;
        for i:=1 to StringGrid1.RowCount-1 do begin
          StringGrid1.Cells[0,i]:=inttostr(i);
          if trim(StringGrid1.Cells[1,i])<>''
            then StringGrid1.Cells[1,i]:=MyTimeToStr(dtn + MyStrToTime(StringGrid1.Cells[1,i])-TimeStart);
        end;
        TimeStart:=dtn;
      end else begin
        SpeedButton2.Click;
        StringGrid1.Row:=1;
        exit;
      end;
    end;
  end;
  for i:=CurrPosition to StringGrid1.RowCount-1 do begin
    dtt:=MyStrToTime(MyTimeToStr(now));
    dts:=MyStrToTime(StringGrid1.Cells[1,i]);
    if (dts>=dtt) then begin
      CurrPosition:=i;
      StringGrid1.Row:=i;
      stringgrid1.Repaint;
      exit
    end else begin
      cnt:=DataToBuffIn(trim(StringGrid1.Cells[3,i]));
      WriteBuffToPort(cnt);
      StringGrid1.Cells[0,i]:=StringGrid1.Cells[0,i] + '+';
      CurrPosition:=i;
      Application.ProcessMessages;
    end;
  end;
end;

end.
