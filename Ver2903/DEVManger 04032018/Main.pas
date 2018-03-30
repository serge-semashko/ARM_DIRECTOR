unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ComCtrls, StdCtrls, Buttons, DirectShow9, ActiveX;

type

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TMouseActivate = (maDefault, maActivate, maActivateAndEat, maNoActivate, maNoActivateAndEat);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TPlayerMode = (Stop, Play, Paused); // режим воспроизведения
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Timer1: TTimer;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Splitter1: TSplitter;
    Timer2: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    ListBox2: TListBox;
    TrackBar1: TTrackBar;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    SpeedButton6: TSpeedButton;
    Panel4: TPanel;
    N1: TMenuItem;
    N3: TMenuItem;
    Panel5: TPanel;
    procedure Initializ;
    procedure Player;
    procedure AddPlayList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1Resize(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox2MouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure ListBox2Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Panel5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    
  private
  { Private declarations }
  //процедура обработки сообщений от клавиатуры
  Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  hr: HRESULT = 1; //задаем начальное значение ложь
  pCurrent, pDuration: Double;// Текужее положение и длительность фильма
  Mode: TPlayerMode; // режим воспроизведения
  Rate: Double;// нормальная скорость воспроизведения
  FullScreen: boolean = false; //индикатор перехода в полноэкранный режим
  i: integer = 0;// счетчик загруженных файлов
  FileName: string;//имя файла
  xn, yn : integer; //для хранения координат мыши
  mouse: tmouse; //координаты мыши

  //интерфейсы для построения и управления графом
  pGraphBuilder        : IGraphBuilder         = nil; //сам граф
  pMediaControl        : IMediaControl         = nil; //управление графом
  pMediaEvent          : IMediaEvent           = nil; //обработчик событий
  pVideoWindow         : IVideoWindow          = nil; //задает окно для вывода
  pMediaPosition       : IMediaPosition        = nil; //позиция проигрывания
  pBasicAudio          : IBasicAudio           = nil; //управление звуком


  PNX : INTEGER;
  PNDOWN : BOOLEAN;

implementation

{$R *.dfm}

procedure TForm1.Initializ;
//процедура построения графа
begin
//освобождаем подключенные интерфейсы
  if Assigned(pMediaPosition) then pMediaPosition := nil;
  if Assigned(pBasicAudio) then pBasicAudio  := nil;
  if Assigned(pVideoWindow) then pVideoWindow := nil;
  if Assigned(pMediaEvent) then pMediaEvent := nil;
  if Assigned(pMediaControl) then pMediaControl := nil;
  if Assigned(pGraphBuilder) then pGraphBuilder := nil;
//получаем интерфейс построения графа
  hr := CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, pGraphBuilder);
  if hr<>0 then begin
    ShowMessage('Не удается создать граф');
    exit;
  end;
//получаем интерфейс управления
  hr := pGraphBuilder.QueryInterface(IID_IMediaControl, pMediaControl);
  if hr<>0 then begin
    ShowMessage('Не удается получить интерфейс IMediaControl');
    exit;
  end;
//получаем интерфейс событий
   hr := pGraphBuilder.QueryInterface(IID_IMediaEvent, pMediaEvent);
   if hr<>0 then begin
    ShowMessage('Не удается получить интерфейс событий');
    exit;
  end;
//получаем интерфейс управления окном вывода видео
  hr := pGraphBuilder.QueryInterface(IID_IVideoWindow, pVideoWindow);
  if hr<>0 then begin
    ShowMessage('Не удается получить IVideoWindow');
    exit;
  end;
//получаем интерфейс управления звуком
   hr := pGraphBuilder.QueryInterface(IBasicAudio, pBasicAudio);
  if hr<>0 then begin
    ShowMessage('Не удается получить аудио интерфейс');
    exit;
  end;
//получаем интерфейс  управления позицией проигрывания
  hr := pGraphBuilder.QueryInterface(IID_IMediaPosition, pMediaPosition);
   if hr<>0 then begin
    ShowMessage('Не удается получить интерфейс управления позицией');
    exit;
  end;
//загружаем файл для проигрывания
  hr := pGraphBuilder.RenderFile(StringToOleStr(PChar(filename)), '');
  if hr<>0 then begin
    ShowMessage('Не удается прорендерить файл');
    exit;
  end;

//располагаем окошко с видео на панель
   pVideoWindow.Put_Owner(Panel1.Handle);//Устанавливаем "владельца" окна, в нашем случае Panel1
   pVideoWindow.Put_WindowStyle(WS_CHILD OR WS_CLIPSIBLINGS);//Стиль окна
   pVideoWindow.put_MessageDrain(Panel1.Handle);//указываем что Panel1 будет получать сообщения видео окна
   pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom); //размеры
end;


procedure TForm1.Player;
//процедура проигрывания файла
begin
if mode<>paused then begin
//проверяем существует ли файл загружаемый из PlayList
//если файл не существует, то выходим
if not FileExists(FileName) then begin ShowMessage('Файл не существует');exit;end;
//освобождаем канал воспроизведения
Initializ;
end;
//Запускаем процедуру проигрывания
pMediaControl.Run;
//получаем скорость врспроизведения
pMediaPosition.get_Rate(Rate);
//присваеваем заголовку формы имя проигрываемого файла
Form1.Caption:=ExtractFileName(FileName);
//Устанавливаем режим воспроизведения PlayMode - play
mode:=play;
end;


Procedure  TForm1.WMKeyDown(Var Msg:TWMKeyDown);
//выход из полноэкранного режима по кнопке ESC
begin
  if Msg.CharCode=VK_ESCAPE then
  begin
      pVideoWindow.HideCursor(False); //показываем курсор
      //показываем плейлист, сплиттер, панель управления GroupBox
      Form1.ListBox2.Visible:=True;
      Form1.Splitter1.Visible:=True;
      Form1.CheckBox1.Checked:=True;
      Form1.GroupBox1.Visible:=True;
      //устанавливаем исходные параметры окна
      Form1.BorderStyle:=bsSizeable;
      Form1.windowState:= wsNormal;
      Form1.FormStyle:=fsNormal;
      //задаем размеры окна вывода
      pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom);
      FullScreen:=False;
end;
  inherited;
end;

//процедура зугрузки файлов в плейлист
procedure TForm1.AddPlayList;
var
 j: Integer;
begin
OpenDialog1.Options:=[ofHideReadOnly,ofAllowMultiSelect,ofEnableSizing];
OpenDialog1.Title  := 'Открытие файлов';
//фильтр для файлов
OpenDialog1.Filter := 'Файлы мультимедиа |*.mp3;*.wma;*.wav;*.vob;*.avi;*.mpg;*.mp4;*.mov;*.mpeg;*.flv;*.wmv;*.qt;|Все файлы|*.*';
//проверяем если PlayList не пустой то запоминаем номер текущей записи
//иначе устанавливаем номер записи 0 (первая позиция в PlayList)
if listbox2.Count<>0 then i:=ListBox2.ItemIndex else i:=0;
//Диалог открытия файла
if not OpenDialog1.Execute then exit;
  Begin
   For j:=0 to OpenDialog1.Files.Count -1 do
    Begin
      ListBox2.Items.Add(ExtractFileName(OpenDialog1.Files.Strings[j]));
      ListBox1.Items.Add(OpenDialog1.Files.Strings[j]);
    End;
  End;
     //запоминаем имя файла текущей записи в плейлисте
     Filename:=ListBox1.Items.Strings[i];
     //Выделяем эту запись в PlayList
     ListBox1.ItemIndex:=i;
     ListBox2.ItemIndex:=i;
end;


procedure TForm1.CheckBox1Click(Sender: TObject);
//показываем или скрываем плейлист
begin
if Form1.CheckBox1.Checked=True then
                                      begin
                                         Form1.ListBox2.Visible:=True;
                                         Form1.Splitter1.Visible:=True;
                                      end
                                else  begin
                                         Form1.ListBox2.Visible:=False;
                                         Form1.Splitter1.Visible:=False;
                                      end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CoInitialize(nil);// инициализировать OLE
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  CoUninitialize;// деинициализировать OLE
end;


procedure TForm1.ListBox2Click(Sender: TObject);
begin
//устанавливаем одинаковую позицию в плейлистах при выборе
i:=ListBox2.Itemindex;
ListBox1.Itemindex:=i;
end;

procedure TForm1.ListBox2DblClick(Sender: TObject);
begin
//выбираем файл из плейлиста при двойном клике для воспроизведения
 i:=ListBox2.Itemindex;
 ListBox1.Itemindex:=i;
 Filename:=ListBox1.Items.Strings[i];
 mode:=stop;
 //вызываем процедуру проигрывания файла
 player;
end;

//процедура вызова PopupMenu при нажатии правой кнопкой мыши на плейлисте (ListBox)
procedure TForm1.ListBox2MouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
var
point : TPoint;
begin
  if (Button = mbRight) then
  // нажата правая мышь
  begin
    point.X := X;
    point.Y := Y;
    i := ListBox2.ItemAtPos(point, true);
    // выделяем строку
    ListBox1.ItemIndex:=i;
    ListBox2.ItemIndex:=i;
      if i >= 0 then
    // если щелкнули по полям списка
    begin
    // поднимаем меню
     PopupMenu1.Popup(ListBox2.ClientOrigin.X + X, ListBox2.ClientOrigin.Y + Y);
    end;
end;
end;

//процедура удаления записей в плейлисте
procedure TForm1.N1Click(Sender: TObject);
begin
//очистка плейлиста
ListBox1.Clear;
ListBox2.Clear;
end;

procedure TForm1.N2Click(Sender: TObject);
//удаление записи
begin
ListBox1.DeleteSelected;
ListBox2.DeleteSelected;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
//вызываем процедуру загрузки плейлиста
  AddPlayList;
end;

//Процедура перехода в полноэкранный режим и обратно
procedure TForm1.Panel1DblClick(Sender: TObject);
var
Rct: TRect;
begin
if hr <> 0 then exit; //если файл не загружен выходим
pVideoWindow.HideCursor(False); //показываем курсор
if FullScreen=False then begin
//скрываем плейлист, сплиттер и панель управления
Form1.ListBox2.Visible:=False;
Form1.Splitter1.Visible:=false;
Form1.GroupBox1.Visible:=false;
//устанавливаем параметры формы
Form1.BorderStyle:=bsNone; //без бордюра
Form1.FormStyle :=fsstayOnTop; //поверх окон
Form1.windowState:= wsMaximized;// на весь экран
//устанавливаем вывод видео на всю ширину экрана
pVideoWindow.SetWindowPosition(0,0,screen.Width,screen.Height);
FullScreen:=True;
end
else begin
// восстанавливаем значения при выходе из полноэкранного режима
if form1.CheckBox1.Checked=true then  Form1.ListBox2.Visible:=True;
Form1.GroupBox1.Visible:=True;
Form1.Splitter1.Visible:=True;
Form1.BorderStyle:=bsSizeable;
Form1.windowState:= wsNormal;
Form1.FormStyle:=fsNormal;
pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom);
FullScreen:=False;
end;
end;

//процедура показывания плейлиста и панели управления при наведении на них мыши
procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//выходим если режим не полноэкранный
if FullScreen<>True then Exit;
//скрываем плейлист если курсор мыши с него уходит
if (mouse.CursorPos.X<panel1.Width) and (ListBox2.Visible=True) then
begin
Form1.ListBox2.Visible:=False;
Form1.Splitter1.Visible:=False;
end;
//показываем плейлист при наведении на его положение мыши, если он был включен
if (mouse.CursorPos.X>=panel1.Width-ListBox2.Width) and (ListBox2.Visible=False) then
begin
if form1.CheckBox1.Checked=true then
  begin
    Form1.ListBox2.Visible:=True;
    Form1.Splitter1.Visible:=True;
  end;
end;

//аналогично с панелью упралением проигрыванием
if (mouse.CursorPos.Y<panel1.Height) and (groupbox1.Visible=True) then
begin
groupbox1.Visible:=false;
end;

if (mouse.CursorPos.Y>=panel1.Height-groupbox1.Height) and (groupbox1.Visible=False) then
begin
groupbox1.Visible:=True;
end;
end;

//Процедура изменения размеов окна проигрывания при изменении размеров панели
procedure TForm1.Panel1Resize(Sender: TObject);
begin
 if mode=play then
 begin
 pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom);
end;
end;

//процедура изменения позиции проигрывания при изменении позиции ProgressBar (перемотка)
procedure TForm1.ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p: real;
begin
if hr = 0 then  begin
  if ssleft in shift then //если нажата левая кнопка мыши
  begin
    p:=ProgressBar1.Max/ProgressBar1.Width;
    ProgressBar1.Position:=round(x*p);
    pMediaControl.Stop;
    pMediaPosition.put_CurrentPosition(ProgressBar1.Position);
    pMediaControl.Run;
    mode:=play;
  end;
end;
end;

//процедура воспроизведения
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  //Проверяем если воспроизведение уже идет то устанавливаем
  //нормальную скорость воспроизведения и выходим
  if mode=play then begin pMediaPosition.put_Rate(Rate);exit;end ;
  Player;
end;

//процедура паузы
procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 //Проверяем идет ли воспроизведение
 if mode=play then
 begin
   pMediaControl.Pause;
   mode:=paused;//устанавливаем playmode -> пауза
 end;
end;

//процедура остановки
procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
//Проверяем идет ли воспроизведение
 if mode=play then
 begin
   pMediaControl.Stop;
   mode:=Stop;//устанавливаем playmode -> стоп
   //задаем начальное положение проигравания
   pMediaPosition.put_CurrentPosition(0);
 end;
end;

//процедура замедленного воспроизведения
procedure TForm1.SpeedButton4Click(Sender: TObject);
var  pdRate: Double;
begin
if mode=play then
 begin
 //читаем текущую скорость
 pMediaPosition.get_Rate(pdRate);
 //уменьшаем ее в два раза
 pMediaPosition.put_Rate(pdRate/2);
 end;
end;

//процедура ускоренного воспроизведения
procedure TForm1.SpeedButton5Click(Sender: TObject);
var  pdRate: Double;
begin
if mode=play then
 begin
 //читаем текущую скорость
 pMediaPosition.get_Rate(pdRate);
 //увеличиваем ее в два раза
 pMediaPosition.put_Rate(pdRate*2);
 end;
end;


procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
//вызываем процедуру загрузки плейлиста
  AddPlayList;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var
TrackLen, TrackPos: Double;
ValPos: Double;
ValLen: Double;
plVolume:Longint;
db  : integer;
begin
//выводим время
Panel4.Caption:=TimeToStr(SysUtils.Time);
//проверяем режим воспроизведения, если не Play то выходим
if hr <> 0 then Exit;
//время проигрывания фильма
//считываем всю длину фильма в секундах
pMediaPosition.get_Duration(pDuration);
//задаем максимальное положение ProgressBar
ProgressBar1.Max:=round(pDuration);
//считаваем сколько секунд прошло от начала воспроизведения
pMediaPosition.get_CurrentPosition(pCurrent);
//задаем текущее положение ProgressBar
ProgressBar1.Position:=round(pCurrent);
 //воспроизведение следующего фильма
//если время проигрывания равно длине фильма по времени,
if pCurrent=pDuration then
begin
//то выбираем следующую запись из плейлиста
if i<ListBox2.Items.Count-1 then
   begin
    inc(i);
 Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
 ListBox2.ItemIndex:=i;
    mode:=stop;
    player;
   end
//если лист закончился - выходим
   else exit;
end;

//Установка громкости, громкость задается от -10000 до 0
//к сожелению при таком регулировании звук начинает заметно прибавляться только в конце шкалы
//pBasicAudio.put_Volume(TrackBar1.Position*100-10000);

//еще один вариант регулирования громкости. Более плавное регулирование звука
plVolume:= (65535 * TrackBar1.Position) div 100;
//нормируем характеристику уровня громкости
db:= trunc(33.22 * 100 * ln((plVolume+1e-6)/65535)/ln(10));
pBasicAudio.put_Volume(db);


//делаем вычисление времени
TrackLen:=pDuration;
TrackPos:=pCurrent;
//переводим секунды в часы
ValPos:=TrackPos / (24 * 3600);
ValLen:=TrackLen / (24 * 3600);
//Выводим данные о времени на форму в Label1 и Label2
Label2.Caption:=FormatDateTime('hh:mm:ss',ValPos);
Label3.Caption:=FormatDateTime('hh:mm:ss',ValLen);
end;

//процедура скрытия курсора в полноэкранном режиме
procedure TForm1.Timer2Timer(Sender: TObject);
begin
if FullScreen<>True then Exit;
//проверяем положение курсора и если он не отклонился
//от своего положения больше чем на пять точек, то скрываем курсор иначе показываем
if ((xn-5)<=mouse.CursorPos.X) and ((yn-5)<=mouse.CursorPos.Y) and ((xn+5)>=mouse.CursorPos.X) and ((yn+5)>=mouse.CursorPos.Y)then
pVideoWindow.HideCursor(true)  else pVideoWindow.HideCursor(False);
//запоминаем координаты курсора
xn:=mouse.CursorPos.X;
yn:=mouse.CursorPos.Y;
end;

procedure TForm1.Panel5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   PNDOWN := TRUE;
   PNX:=X;
end;

procedure TForm1.Panel5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PNDOWN := false;
end;

procedure TForm1.Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   IF PNDOWN then begin
     if X < PNX then SpeedButton4.OnClick(nil);
     if X > PNX then SpeedButton5.OnClick(nil);
     PNX:=X;
   end;
end;

end.
