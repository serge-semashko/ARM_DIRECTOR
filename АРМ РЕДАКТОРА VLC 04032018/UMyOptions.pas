unit UMyOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Math,
  FastDIB,
  FastFX, FastSize, FastFiles, FConvert, FastBlend, Vcl.StdCtrls;

type
  TMyTypeOption = (tomInteger, tomFloat, tomString, tomBoolean, tomColor,
    tomFontName);

  TOneOption = class
    Name: string;
    rtname: trect;
    Value: String;
    rtval: trect;
    TypeData: TMyTypeOption;
    Variants: tstrings;
    procedure Draw(dib: tfastdib);
    constructor Create(SName, SValue: string; TypeD: TMyTypeOption;
      Left, Top, Width, Height: integer);
    destructor destroy;
  end;

  TGroupOptions = class
    Count: integer;
    Options: array of TOneOption;
    function adddata(SName, SValue: string; TypeD: TMyTypeOption;
      Left, Top, Width, Height: integer): integer;
    procedure setdata(SName: string; SValue: string); overload;
    procedure setdata(Posi: integer; SValue: string); overload;
    function getdata(SName: string): string; overload;
    function getdata(Posi: integer): string; overload;
    procedure AddVariant(Name: string; Variant: string); overload;
    procedure AddVariant(Posi: integer; Variant: string); overload;
    procedure ClearVariants(Name: string); overload;
    procedure ClearVariants(Posi: integer); overload;
    procedure setborder(Posi, Left, Width: integer);
    procedure Draw(cv: tcanvas);
    function MouseClick(cv: tcanvas; X, Y: integer): integer;
    procedure clear;
    constructor Create;
    destructor destroy;
  end;

  TListOptions = class
    Count: integer;
    Groups: array of TGroupOptions;
    procedure clear;
    function Add: integer;
    procedure LoadData;
    procedure SaveData;
    constructor Create;
    destructor destroy;
  end;

  TOnePartition = class
    Text: string;
    Select: boolean;
    Rect: trect;
    constructor Create(Txt: string; RT: trect);
    destructor destroy;
  end;

  TListPartitions = class
    RowHeight: integer;
    Count: integer;
    List: array of TOnePartition;
    procedure clear;
    procedure Add(Text: string);
    procedure init;
    function index: integer;
    procedure Draw(cv: tcanvas);
    procedure MouseMove(cv: tcanvas; X, Y: integer);
    function MouseClick(cv: tcanvas; X, Y: integer): integer;
    constructor Create;
    destructor destroy;
  end;

  TFrMyOptions = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    imgPartitions: TImage;
    imgOptions: TImage;
    imgButtons: TImage;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ColorDialog1: TColorDialog;
    procedure Panel1Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgPartitionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure imgButtonsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure imgButtonsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure imgOptionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure imgPartitionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    TypeEditor: TMyTypeOption;
    IndexPartition: integer;
    IndexOption: integer;
  public
    { Public declarations }
  end;

var
  FrMyOptions: TFrMyOptions;
  ListPartitions: TListPartitions;
  ListOptions: TListOptions;
procedure SetOptions;

implementation

uses umain, ucommon, uinitforms, uimgbuttons, umytexttable, ugrid,
  ubuttonoptions,
  uimagetemplate;

{$R *.dfm}

procedure SetOptions;
var
  indx: integer;
begin
  FrMyOptions.Edit1.Visible := false;
  FrMyOptions.ComboBox1.Visible := false;
  indx := ListPartitions.index;
  if indx = -1 then
  begin
    ListPartitions.List[0].Select := true;
    indx := 0;
  end;
  ListOptions.LoadData;
  ListPartitions.Draw(FrMyOptions.imgPartitions.Canvas);
  FrMyOptions.imgPartitions.Repaint;
  ListOptions.Groups[indx].Draw(FrMyOptions.imgOptions.Canvas);
  FrMyOptions.imgOptions.Repaint;
  FrMyOptions.ShowModal;
  if FrMyOptions.ModalResult = mrOk then
  begin
    FrMyOptions.Edit1.Visible := false;
    FrMyOptions.ComboBox1.Visible := false;
  end;
end;

constructor TListOptions.Create;
begin
  Count := 0;
end;

destructor TListOptions.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@Groups);
end;

procedure TListOptions.clear;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
  begin
    Groups[Count - 1].FreeInstance;
    Count := Count - 1;
    SetLength(Groups, Count);
  end;
  Count := 0;
end;

function TListOptions.Add: integer;
begin
  Count := Count + 1;
  SetLength(Groups, Count);
  Groups[Count - 1] := TGroupOptions.Create;
  result := Count - 1;
end;

constructor TOnePartition.Create(Txt: string; RT: trect);
begin
  Text := Txt;
  Select := false;
  Rect.Left := RT.Left;
  Rect.Right := RT.Right;
  Rect.Top := RT.Top;
  Rect.Bottom := RT.Bottom;
end;

destructor TOnePartition.destroy;
begin
  freemem(@Text);
  freemem(@Select);
  freemem(@Rect);
end;

constructor TListPartitions.Create;
begin
  RowHeight := 22;
  Count := 0;
end;

destructor TListPartitions.destroy;
begin
  freemem(@RowHeight);
  clear;
  freemem(@Count);
  freemem(@List);
end;

procedure TListPartitions.init;
begin
  clear;
  Add('Общие параметры');
  Add('Основное окно программы');
  Add('Дополнительные окна');
  Add('Цвета таблиц');
  Add('Шрифты таблиц');
  Add('Размеры таблиц');
  Add('Область тайм-линий');
  Add('Параметры событий');
  Add('Окно эфир ');
  Add('Печать');
end;

function TListPartitions.index: integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to Count - 1 do
  begin
    if List[i].Select then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure TListPartitions.clear;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
  begin
    List[Count - 1].FreeInstance;
    Count := Count - 1;
    SetLength(List, Count);
  end;
  Count := 0;
end;

procedure TListPartitions.Add(Text: string);
var
  RT: trect;
begin
  Count := Count + 1;
  SetLength(List, Count);
  RT.Left := 10;
  RT.Right := 100;
  RT.Top := 30 + (Count - 1) * RowHeight;
  RT.Bottom := RT.Top + RowHeight;
  List[Count - 1] := TOnePartition.Create(Text, RT);
end;

procedure TListOptions.LoadData;
var
  ARow, ps, i, j: integer;
  strdt: string;
  clr: tcolor;
  ch: Char;
begin
  clear;
  ARow := Add; // 0
  Groups[ARow].clear;
  ps := 20;
  if InputWithoutUsers then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Вход без пароля', strdt, tomBoolean, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  if MakeLogging then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Включить логирование', strdt, tomBoolean, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Глубина буффера UNDO', inttostr(DepthUNDO), tomInteger,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Отклонение сигнала синхронизации (msec)',
    inttostr(SynchDelay), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Время жизни проекта по умолчанию (дней)',
    inttostr(DeltaDateDelete), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Смещение номера события', inttostr(PrintEventShift),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Шаг перемещения колеса мыши (кадры)',
    inttostr(StepMouseWheel), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  // PrintEventShift      : integer = 30;
  // Основные параметры программы
  // MainWindowStayOnTop : boolean = false;
  // MainWindowMove : boolean = true;
  // MainWindowSize : boolean = true;


  // WorkDirGRTemplate : string ='';
  // WorkDirTextTemplate  : string ='';
  // WorkDirClips  : string ='';
  // WorkDirSubtitors  : string ='';
  // WorkDirKeyLayouts : string = '';

  ARow := Add; // 1
  Groups[ARow].clear;
  ps := 20;
  Groups[ARow].adddata('Цвет окна программы', inttostr(ProgrammColor), tomColor,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя шрифта', ProgrammFontName, tomFontName, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер шрифта', inttostr(ProgrammFontSize), tomInteger,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Высота шрифта меню и информации', inttostr(MTFontSize),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта', inttostr(ProgrammFontColor), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет поля редактирования', inttostr(ProgrammEditColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя шрифта поля редактирования', ProgrammEditFontName,
    tomFontName, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер шрифта поля редактирования',
    inttostr(ProgrammEditFontSize), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта поля редактирования',
    inttostr(ProgrammEditFontColor), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  // ProgrammCommentColor : tcolor = clYellow;
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер шрифта кнопки', inttostr(ProgrammBtnFontSize),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя шрифта информации о кнопке',
    ProgrammHintBtnFontName, tomFontName, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта информации о кнопке',
    inttostr(ProgrammHintBTNSFontColor), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер шрифта подсказки о кнопке',
    inttostr(ProgrammHintBTNSFontSize), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));

  // Основные параметры вспомогательных форм
  ARow := Add; // 2
  Groups[ARow].clear;
  ps := 20;
  Groups[ARow].adddata('Цвет формы', inttostr(FormsColor), tomColor, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя шрифта', FormsFontName, tomFontName, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер шрифта', inttostr(FormsFontSize), tomInteger, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер вспомоготельного шрифта',
    inttostr(FormsSmallFont), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта', inttostr(FormsFontColor), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет поля редактирования', inttostr(FormsEditColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя шрифта поля редактирования', FormsEditFontName,
    tomFontName, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер шрифта поля редактирования',
    inttostr(FormsEditFontSize), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта поля редактирования',
    inttostr(FormsEditFontColor), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);

  // Основные цвета таблиц

  ARow := Add; // 3
  Groups[ARow].clear;
  ps := 20;
  Groups[ARow].adddata('Цвет фона таблицы', inttostr(GridBackGround), tomColor,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Цвет линий таблицы',IntToStr(GridColorPen),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Цвет основного шрифта',IntToStr(GridMainFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет четных строк таблицы', inttostr(GridColorRow1),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет нечетных строк таблицы', inttostr(GridColorRow2),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет выбранной строки таблицы',
    inttostr(GridColorSelection), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта предупреждения', inttostr(PhraseErrorColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта загруженного клипа',
    inttostr(PhrasePlayColor), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет выбранного элемента ячейки',
    inttostr(MyCellColorTrue), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет не выбранного элемента ячейки',
    inttostr(MyCellColorFalse), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет элемента выбранного шаблона',
    inttostr(MyCellColorSelect), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);

  // Шрифты таблиц
  ARow := Add; // 4
  Groups[ARow].clear;

  ps := 20;
  Groups[ARow].adddata('Имя шрифта заголовка', GridTitleFontName, tomFontName,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта заголовка', inttostr(GridTitleFontColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер шрифта заголовка', inttostr(GridTitleFontSize),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  for i := 8 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridTitleFontBold then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Толстый шрифт заголовка', strdt, tomBoolean, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridTitleFontItalic then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Наклонный шрифт заголовка', strdt, tomBoolean, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridTitleFontUnderline then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Подчеркнутый шрифт заголовка', strdt, tomBoolean, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя основного шрифта', GridFontName, tomFontName, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет основного шрифта', inttostr(GridFontColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер основного шрифта', inttostr(GridFontSize),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  for i := 7 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridFontBold then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Толстый основной шрифт', strdt, tomBoolean, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridFontItalic then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Наклонный основной шрифт', strdt, tomBoolean, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridFontUnderline then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Подчеркнутый основной шрифт', strdt, tomBoolean, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  //
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя дополнительного шрифта', GridSubFontName,
    tomFontName, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет дополнительного шрифта',
    inttostr(GridSubFontColor), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер дополнительного шрифта',
    inttostr(GridSubFontSize), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  for i := 6 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridSubFontBold then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Толстый дополнительный шрифт', strdt, tomBoolean, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridSubFontItalic then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Наклонный дополнительный шрифт', strdt, tomBoolean, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');
  ps := ps + FrMyOptions.ComboBox1.Height;
  if GridSubFontUnderline then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Подчеркнутый дополнительный шрифт', strdt, tomBoolean,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  // размеры таблиц
  ARow := Add; // 5
  Groups[ARow].clear;

  ps := 20;
  // Groups[ARow].adddata('Плей-листы высота заголовка',IntToStr(ProjectHeightTitle),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Плей-листы высота ячейки',IntToStr(ProjectHeightRow),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Плей-листы отступ сверху 1-ой строки',IntToStr(ProjectRowsTop),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Плей-листы высота строки',IntToStr(ProjectRowsHeight),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Плей-листы интервал между строками',IntToStr(ProjectRowsInterval),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);

  // ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список плей-листов высота заголовка',
    inttostr(PLHeightTitle), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список плей-листов высота ячейки',
    inttostr(PLHeightRow), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список плей-листов отступ сверху 1-ой строки',
    inttostr(PLRowsTop), tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список плей-листов высота строки',
    inttostr(PLRowsHeight), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список плей-листов интервал между строками',
    inttostr(PLRowsInterval), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список клипов высота заголовка',
    inttostr(ClipsHeightTitle), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список клипов высота ячейки', inttostr(ClipsHeightRow),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список клипов отступ сверху 1-ой строки',
    inttostr(ClipsRowsTop), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список клипов высота строки', inttostr(ClipsRowsHeight),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Список клипов интервал между строками',
    inttostr(ClipsRowsInterval), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);

  //
  // GridGrTemplateSelect : boolean = true;
  // RowGridGrTemplateSelect : integer = -1;
  //
  // Основные параметры Тайм-линий
  ARow := Add; // 6
  Groups[ARow].clear;

  ps := 20;
  Groups[ARow].adddata('Цвет заднего фона', inttostr(TLBackGround), tomColor,
    10, ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет переднего фона', inttostr(TLZoneNamesColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Имя основного шрифта', TLZoneNamesFontName, tomFontName,
    10, ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет основного шрифта', inttostr(TLZoneNamesFontColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта под курсором',
    inttostr(TLZoneFontColorSelect), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Размер основного шрифта', inttostr(TLZoneNamesFontSize),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  for i := 7 to 32 do
    Groups[ARow].AddVariant(Groups[ARow].Count - 1, inttostr(i));

  ps := ps + FrMyOptions.ComboBox1.Height;
  if TLZoneNamesFontBold then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Толстый основной шрифт', strdt, tomBoolean, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  ps := ps + FrMyOptions.ComboBox1.Height;
  if TLZoneNamesFontItalic then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Наклонный основной шрифт', strdt, tomBoolean, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  ps := ps + FrMyOptions.ComboBox1.Height;
  if TLZoneNamesFontUnderline then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Подчеркнутый основной шрифт', strdt, tomBoolean, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  ps := ps + FrMyOptions.ComboBox1.Height;
  if TLZoneEditFontBold then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Толстый шрифт редакт. тайм-линия', strdt, tomBoolean,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  ps := ps + FrMyOptions.ComboBox1.Height;
  if TLZoneEditFontItalic then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Наклонный шрифт редакт. тайм-линия', strdt, tomBoolean,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  ps := ps + FrMyOptions.ComboBox1.Height;
  if TLZoneEditFontUnderline then
    strdt := 'Да'
  else
    strdt := 'Нет';
  Groups[ARow].adddata('Подчеркнутый шрифт редакт. тайм-линия', strdt,
    tomBoolean, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Да');
  Groups[ARow].AddVariant(Groups[ARow].Count - 1, 'Нет');

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет статуса 1', inttostr(StatusColor[0]), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет статуса 2', inttostr(StatusColor[1]), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет статуса 3', inttostr(StatusColor[2]), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет статуса 4', inttostr(StatusColor[3]), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет статуса 5', inttostr(StatusColor[4]), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Максим. кол-во тайм-линий', inttostr(TLMaxCount),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Макс. кол-во тайм-линий устройств',
    inttostr(TLMaxDevice), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Макс. кол-во текстовых тайм-линий', inttostr(TLMaxText),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Макс. кол-во медиа тайм-линий', inttostr(TLMaxMedia),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);

  ARow := Add; // 7
  Groups[ARow].clear;

  ps := 20;
  Groups[ARow].adddata('Хронометраж пустого клипа (кадры)',
    inttostr(DefaultClipDuration), tomInteger, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Кол-во кадров до события', inttostr(TLPreroll),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Кол-во кадров после события', inttostr(TLPostroll),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Кол-во кадров вспышки', inttostr(TLFlashDuration),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет курсора НТК', inttostr(StartColorCursor), tomColor,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет курсора КТК', inttostr(EndColorCursor), tomColor,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Цвет шрифта шкалы времени',IntToStr(TLFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ARow := Add; // 8
  Groups[ARow].clear;

  ps := 20;
  Groups[ARow].adddata('Количество отображаемых событий', inttostr(RowsEvents),
    tomInteger, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет заднего фона зоны событий',
    inttostr(AirBackGround), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет перднего фона зоны событий',
    inttostr(AirForeGround), tomColor, 10, ps, 300,
    FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет события', inttostr(AirColorTimeline), tomColor, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);

  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет фона зоны устройств', inttostr(DevBackGround),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет линии тайм-кода', inttostr(TimeForeGround),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет секундных отсчетов', inttostr(TimeSecondColor),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Цвет шрифта комментария', inttostr(AirFontComment),
    tomColor, 10, ps, 300, FrMyOptions.ComboBox1.Height);

  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Цвет шрифта время события',IntToStr(Layer2FontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  // ps:=ps + FrMyOptions.ComboBox1.Height;
  // Groups[ARow].adddata('Размер шрифта время события',IntToStr(Layer2FontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  // for i:=7 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));


  // DefaultMediaColor : tcolor = $00d8a520;
  // DefaultTextColor : tcolor = $00aceae1;

  // //Основные параметры кнопок
  // ProgBTNSFontName : tfontname = 'Arial';
  // ProgBTNSFontColor : tcolor = clWhite;
  // ProgBTNSFontSize : Integer = 10;
  // HintBTNSFontName : tfontname = 'Arial';
  // HintBTNSFontColor : tcolor = clBlack;
  // HintBTNSFontSize : Integer = 9;

  // Основные параметры печати
  ARow := Add; // 9
  Groups[ARow].clear;
  ps := 20;
  ch := formatsettings.DecimalSeparator;
  formatsettings.DecimalSeparator := '.';
  Groups[ARow].adddata('Левое поле', FloatToStr(PrintSpaceLeft), tomFloat, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Верхнее поле', FloatToStr(PrintSpaceTop), tomFloat, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Правое поле', FloatToStr(PrintSpaceRight), tomFloat, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Нижнее поле', FloatToStr(PrintSpaceBottom), tomFloat,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Верхний колонтитул', FloatToStr(PrintHeadLineTop),
    tomFloat, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Нижний колонтитул', FloatToStr(PrintHeadLineBottom),
    tomFloat, 10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Название первого столбца', PrintCol1, tomString, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Название второго столбца', PrintCol2, tomString, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Название третьего столбца', PrintCol3, tomString, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Название четвертого столбца', PrintCol4, tomString, 10,
    ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Название пятого столбца', PrintCol5, tomString, 10, ps,
    300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Название шестого столбца вар.1', PrintCol61, tomString,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Название шестого столбца вар.2', PrintCol62, tomString,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  ps := ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('Поле название устройства', PrintDeviceName, tomString,
    10, ps, 300, FrMyOptions.ComboBox1.Height);
  formatsettings.DecimalSeparator := ch;


  //
  // //Основные параметры списка горячих клавиш
  // KEYFontName    : tfontname;
  // KEYColorNew    : tcolor = clLime;
  /// /  WorkHotKeys    : TMyListHotKeys;
  /// NAMEKeyLayout  : string;
  //

end;

procedure TListOptions.SaveData;
var
  s: string;
  APos: integer;
  i, j, k, n: integer;
  ch: Char;
begin
  APos := 0;
  if trim(Groups[APos].getdata('Вход без пароля')) = 'Да' then
    InputWithoutUsers := true
  else
    InputWithoutUsers := false;

  if trim(Groups[APos].getdata('Включить логирование')) = 'Да' then
    MakeLogging := true
  else
    MakeLogging := false;

  s := trim(Groups[APos].getdata('Глубина буффера UNDO'));
  if s = '' then
    DepthUNDO := 10
  else
    DepthUNDO := strtoint(s);

  s := trim(Groups[APos].getdata('Отклонение сигнала синхронизации (msec)'));
  if s = '' then
    SynchDelay := 0
  else
    SynchDelay := strtoint(s);

  s := trim(Groups[APos].getdata('Время жизни проекта по умолчанию (дней)'));
  if s = '' then
    DeltaDateDelete := 0
  else
    DeltaDateDelete := strtoint(s);

  s := trim(Groups[APos].getdata('Смещение номера события'));
  if s = '' then
    PrintEventShift := 0
  else
    PrintEventShift := strtoint(s);

  s := trim(Groups[APos].getdata('Шаг перемещения колеса мыши (кадры)'));
  if s = '' then
    StepMouseWheel := StepMouseWheel
  else
    StepMouseWheel := strtoint(s);

  // ==============================================================================

  APos := 1;
  s := trim(Groups[APos].getdata('Цвет окна программы'));
  if s = '' then
    ProgrammColor := ProgrammColor
  else
    ProgrammColor := strtoint(s);

  s := trim(Groups[APos].getdata('Имя шрифта'));
  if s = '' then
    ProgrammFontName := ProgrammFontName
  else
    ProgrammFontName := s;

  s := trim(Groups[APos].getdata('Размер шрифта'));
  if s = '' then
    ProgrammFontSize := ProgrammFontSize
  else
    ProgrammFontSize := strtoint(s);

  s := trim(Groups[APos].getdata('Высота шрифта меню и информации'));
  if s = '' then
    MTFontSize := MTFontSize
  else
    MTFontSize := strtoint(s);
  MTFontSizeS := MTFontSize + 1;
  MTFontSizeB := MTFontSize + 3;

  s := trim(Groups[APos].getdata('Цвет шрифта'));
  if s = '' then
    ProgrammFontColor := ProgrammFontColor
  else
    ProgrammFontColor := strtoint(s);

  s := trim(Groups[APos].getdata('Цвет поля редактирования'));
  if s = '' then
    ProgrammEditColor := ProgrammEditColor
  else
    ProgrammEditColor := strtoint(s);

  s := trim(Groups[APos].getdata('Имя шрифта поля редактирования'));
  if s = '' then
    ProgrammEditFontName := ProgrammEditFontName
  else
    ProgrammEditFontName := s;

  s := trim(Groups[APos].getdata('Размер шрифта поля редактирования'));
  if s = '' then
    ProgrammEditFontSize := ProgrammEditFontSize
  else
    ProgrammEditFontSize := strtoint(s);

  s := trim(Groups[APos].getdata('Цвет шрифта поля редактирования'));
  if s = '' then
    ProgrammEditFontColor := ProgrammEditFontColor
  else
    ProgrammEditFontColor := strtoint(s);

  s := trim(Groups[APos].getdata('Размер шрифта кнопки'));
  if s = '' then
    ProgrammBtnFontSize := ProgrammBtnFontSize
  else
    ProgrammBtnFontSize := strtoint(s);

  s := trim(Groups[APos].getdata('Имя шрифта информации о кнопке'));
  if s = '' then
    ProgrammHintBtnFontName := ProgrammHintBtnFontName
  else
    ProgrammHintBtnFontName := s;

  s := trim(Groups[APos].getdata('Цвет шрифта информации о кнопке'));
  if s = '' then
    ProgrammHintBTNSFontColor := ProgrammHintBTNSFontColor
  else
    ProgrammHintBTNSFontColor := strtoint(s);

  s := trim(Groups[APos].getdata('Размер шрифта подсказки о кнопке'));
  if s = '' then
    ProgrammHintBTNSFontSize := ProgrammHintBTNSFontSize
  else
    ProgrammHintBTNSFontSize := strtoint(s);

  // ==============================================================================

  APos := 2;
  s := trim(Groups[APos].getdata('Цвет формы'));
  if s = '' then
    FormsColor := FormsColor
  else
    FormsColor := strtoint(s);

  s := trim(Groups[APos].getdata('Имя шрифта'));
  if s = '' then
    FormsFontName := FormsFontName
  else
    FormsFontName := s;

  s := trim(Groups[APos].getdata('Размер шрифта'));
  if s = '' then
    FormsFontSize := FormsFontSize
  else
    FormsFontSize := strtoint(s);

  s := trim(Groups[APos].getdata('Размер вспомоготельного шрифта'));
  if s = '' then
    FormsSmallFont := FormsSmallFont
  else
    FormsSmallFont := strtoint(s);

  s := trim(Groups[APos].getdata('Цвет шрифта'));
  if s = '' then
    FormsFontColor := FormsFontColor
  else
    FormsFontColor := strtoint(s);

  s := trim(Groups[APos].getdata('Цвет поля редактирования'));
  if s = '' then
    FormsEditColor := FormsEditColor
  else
    FormsEditColor := strtoint(s);

  s := trim(Groups[APos].getdata('Имя шрифта поля редактирования'));
  if s = '' then
    FormsEditFontName := FormsEditFontName
  else
    FormsEditFontName := s;

  s := trim(Groups[APos].getdata('Размер шрифта поля редактирования'));
  if s = '' then
    FormsEditFontSize := FormsEditFontSize
  else
    FormsEditFontSize := strtoint(s);

  s := trim(Groups[APos].getdata('Цвет шрифта поля редактирования'));
  if s = '' then
    FormsEditFontColor := FormsEditFontColor
  else
    FormsEditFontColor := strtoint(s);
  // ==============================================================================
  APos := 3;

  s := trim(Groups[APos].getdata('Цвет фона таблицы'));
  if s = '' then
    GridBackGround := GridBackGround
  else
    GridBackGround := strtoint(s);
  // s:=trim(Groups[APos].getdata('Цвет линий таблицы'));
  // if s='' then GridColorPen:=GridColorPen else GridColorPen:=strtoint(s);
  // s:=trim(Groups[APos].getdata('Цвет основного шрифта'));
  // if s='' then GridMainFontColor:=GridMainFontColor else GridMainFontColor:=strtoint(s);
  s := trim(Groups[APos].getdata('Цвет четных строк таблицы'));
  if s = '' then
    GridColorRow1 := GridColorRow1
  else
    GridColorRow1 := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет нечетных строк таблицы'));
  if s = '' then
    GridColorRow2 := GridColorRow2
  else
    GridColorRow2 := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет выбранной строки таблицы'));
  if s = '' then
    GridColorSelection := GridColorSelection
  else
    GridColorSelection := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет шрифта предупреждения'));
  if s = '' then
    PhraseErrorColor := PhraseErrorColor
  else
    PhraseErrorColor := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет шрифта загруженного клипа'));
  if s = '' then
    PhrasePlayColor := PhrasePlayColor
  else
    PhrasePlayColor := strtoint(s);

  s := trim(Groups[APos].getdata('Цвет выбранного элемента ячейки'));
  if s = '' then
    MyCellColorTrue := MyCellColorTrue
  else
    MyCellColorTrue := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет не выбранного элемента ячейки'));
  if s = '' then
    MyCellColorFalse := MyCellColorFalse
  else
    MyCellColorFalse := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет элемента выбранного шаблона'));
  if s = '' then
    MyCellColorSelect := MyCellColorSelect
  else
    MyCellColorSelect := strtoint(s);

  // ==============================================================================
  APos := 4;
  s := trim(Groups[APos].getdata('Имя шрифта заголовка'));
  if s = '' then
    GridTitleFontName := GridTitleFontName
  else
    GridTitleFontName := s;
  s := trim(Groups[APos].getdata('Цвет шрифта заголовка'));
  if s = '' then
    GridTitleFontColor := GridTitleFontColor
  else
    GridTitleFontColor := strtoint(s);
  s := trim(Groups[APos].getdata('Размер шрифта заголовка'));
  if s = '' then
    GridTitleFontSize := GridTitleFontSize
  else
    GridTitleFontSize := strtoint(s);
  if trim(Groups[APos].getdata('Толстый шрифт заголовка')) = 'Да' then
    GridTitleFontBold := true
  else
    GridTitleFontBold := false;
  if trim(Groups[APos].getdata('Наклонный шрифт заголовка')) = 'Да' then
    GridTitleFontItalic := true
  else
    GridTitleFontItalic := false;
  if trim(Groups[APos].getdata('Подчеркнутый шрифт заголовка')) = 'Да' then
    GridTitleFontUnderline := true
  else
    GridTitleFontUnderline := false;

  s := trim(Groups[APos].getdata('Имя основного шрифта'));
  if s = '' then
    GridFontName := GridFontName
  else
    GridFontName := s;
  s := trim(Groups[APos].getdata('Цвет основного шрифта'));
  if s = '' then
    GridFontColor := GridFontColor
  else
    GridFontColor := strtoint(s);
  s := trim(Groups[APos].getdata('Размер основного шрифта'));
  if s = '' then
    GridFontSize := GridFontSize
  else
    GridFontSize := strtoint(s);
  if trim(Groups[APos].getdata('Толстый основной шрифт')) = 'Да' then
    GridFontBold := true
  else
    GridFontBold := false;
  if trim(Groups[APos].getdata('Наклонный основной шрифт')) = 'Да' then
    GridFontItalic := true
  else
    GridFontItalic := false;
  if trim(Groups[APos].getdata('Подчеркнутый основной шрифт')) = 'Да' then
    GridFontUnderline := true
  else
    GridFontUnderline := false;

  s := trim(Groups[APos].getdata('Имя дополнительного шрифта'));
  if s = '' then
    GridSubFontName := GridSubFontName
  else
    GridSubFontName := s;
  s := trim(Groups[APos].getdata('Цвет дополнительного шрифта'));
  if s = '' then
    GridSubFontColor := GridSubFontColor
  else
    GridSubFontColor := strtoint(s);
  s := trim(Groups[APos].getdata('Размер дополнительного шрифта'));
  if s = '' then
    GridSubFontSize := GridSubFontSize
  else
    GridSubFontSize := strtoint(s);
  if trim(Groups[APos].getdata('Толстый дополнительный шрифт')) = 'Да' then
    GridSubFontBold := true
  else
    GridSubFontBold := false;
  if trim(Groups[APos].getdata('Наклонный дополнительный шрифт')) = 'Да' then
    GridSubFontItalic := true
  else
    GridSubFontItalic := false;
  if trim(Groups[APos].getdata('Подчеркнутый дополнительный шрифт')) = 'Да' then
    GridSubFontUnderline := true
  else
    GridSubFontUnderline := false;

  // ==============================================================================
  APos := 5;

  // s:=trim(Groups[APos].getdata('Плей-листы высота заголовка'));
  // if s='' then ProjectHeightTitle:=ProjectHeightTitle else ProjectHeightTitle:=strtoint(s);
  // s:=trim(Groups[APos].getdata('Плей-листы высота ячейки'));
  // if s='' then ProjectHeightRow:=ProjectHeightRow else ProjectHeightRow:=strtoint(s);
  // s:=trim(Groups[APos].getdata('Плей-листы отступ сверху 1-ой строки'));
  // if s='' then ProjectRowsTop:=ProjectRowsTop else ProjectRowsTop:=strtoint(s);
  // s:=trim(Groups[APos].getdata('Плей-листы высота строки'));
  // if s='' then ProjectRowsHeight:=ProjectRowsHeight else ProjectRowsHeight:=strtoint(s);
  // s:=trim(Groups[APos].getdata('Плей-листы интервал между строками'));
  // if s='' then ProjectRowsInterval:=ProjectRowsInterval else ProjectRowsInterval:=strtoint(s);

  s := trim(Groups[APos].getdata('Список плей-листов высота заголовка'));
  if s = '' then
    PLHeightTitle := PLHeightTitle
  else
    PLHeightTitle := strtoint(s);
  s := trim(Groups[APos].getdata('Список плей-листов высота ячейки'));
  if s = '' then
    PLHeightRow := PLHeightRow
  else
    PLHeightRow := strtoint(s);
  s := trim(Groups[APos].getdata
    ('Список плей-листов отступ сверху 1-ой строки'));
  if s = '' then
    PLRowsTop := PLRowsTop
  else
    PLRowsTop := strtoint(s);
  s := trim(Groups[APos].getdata('Список плей-листов высота строки'));
  if s = '' then
    PLRowsHeight := PLRowsHeight
  else
    PLRowsHeight := strtoint(s);
  s := trim(Groups[APos].getdata('Список плей-листов интервал между строками'));
  if s = '' then
    PLRowsInterval := PLRowsInterval
  else
    PLRowsInterval := strtoint(s);

  s := trim(Groups[APos].getdata('Список клипов высота заголовка'));
  if s = '' then
    ClipsHeightTitle := ClipsHeightTitle
  else
    ClipsHeightTitle := strtoint(s);
  s := trim(Groups[APos].getdata('Список клипов высота ячейки'));
  if s = '' then
    ClipsHeightRow := ClipsHeightRow
  else
    ClipsHeightRow := strtoint(s);
  s := trim(Groups[APos].getdata('Список клипов отступ сверху 1-ой строки'));
  if s = '' then
    ClipsRowsTop := ClipsRowsTop
  else
    ClipsRowsTop := strtoint(s);
  s := trim(Groups[APos].getdata('Список клипов высота строки'));
  if s = '' then
    ClipsRowsHeight := ClipsRowsHeight
  else
    ClipsRowsHeight := strtoint(s);
  s := trim(Groups[APos].getdata('Список клипов интервал между строками'));
  if s = '' then
    ClipsRowsInterval := ClipsRowsInterval
  else
    ClipsRowsInterval := strtoint(s);

  // ==============================================================================
  APos := 6;
  s := trim(Groups[APos].getdata('Цвет заднего фона'));
  if s = '' then
    TLBackGround := TLBackGround
  else
    TLBackGround := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет переднего фона'));
  if s = '' then
    TLZoneNamesColor := TLZoneNamesColor
  else
    TLZoneNamesColor := strtoint(s);
  s := trim(Groups[APos].getdata('Имя основного шрифта'));
  if s = '' then
    TLZoneNamesFontName := TLZoneNamesFontName
  else
    TLZoneNamesFontName := s;
  s := trim(Groups[APos].getdata('Цвет основного шрифта'));
  if s = '' then
    TLZoneNamesFontColor := TLZoneNamesFontColor
  else
    TLZoneNamesFontColor := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет шрифта под курсором'));
  if s = '' then
    TLZoneFontColorSelect := TLZoneFontColorSelect
  else
    TLZoneFontColorSelect := strtoint(s);
  s := trim(Groups[APos].getdata('Размер основного шрифта'));
  if s = '' then
    TLZoneNamesFontSize := TLZoneNamesFontSize
  else
    TLZoneNamesFontSize := strtoint(s);

  if trim(Groups[APos].getdata('Толстый основной шрифт')) = 'Да' then
    TLZoneNamesFontBold := true
  else
    TLZoneNamesFontBold := false;
  if trim(Groups[APos].getdata('Наклонный основной шрифт')) = 'Да' then
    TLZoneNamesFontItalic := true
  else
    TLZoneNamesFontItalic := false;
  if trim(Groups[APos].getdata('Подчеркнутый основной шрифт')) = 'Да' then
    TLZoneNamesFontUnderline := true
  else
    TLZoneNamesFontUnderline := false;

  if trim(Groups[APos].getdata('Толстый шрифт редакт. тайм-линия')) = 'Да' then
    TLZoneEditFontBold := true
  else
    TLZoneEditFontBold := false;
  if trim(Groups[APos].getdata('Наклонный шрифт редакт. тайм-линия')) = 'Да'
  then
    TLZoneEditFontItalic := true
  else
    TLZoneEditFontItalic := false;
  if trim(Groups[APos].getdata('Подчеркнутый шрифт редакт. тайм-линия')) = 'Да'
  then
    TLZoneEditFontUnderline := true
  else
    TLZoneEditFontUnderline := false;

  s := trim(Groups[APos].getdata('Цвет статуса 1'));
  if s = '' then
    StatusColor[0] := StatusColor[0]
  else
    StatusColor[0] := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет статуса 2'));
  if s = '' then
    StatusColor[1] := StatusColor[1]
  else
    StatusColor[1] := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет статуса 3'));
  if s = '' then
    StatusColor[2] := StatusColor[2]
  else
    StatusColor[2] := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет статуса 4'));
  if s = '' then
    StatusColor[3] := StatusColor[3]
  else
    StatusColor[3] := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет статуса 5'));
  if s = '' then
    StatusColor[4] := StatusColor[4]
  else
    StatusColor[4] := strtoint(s);

  s := trim(Groups[APos].getdata('Максим. кол-во тайм-линий'));
  if s = '' then
    TLMaxCount := TLMaxCount
  else
    TLMaxCount := strtoint(s);
  s := trim(Groups[APos].getdata('Макс. кол-во тайм-линий устройств'));
  if s = '' then
    TLMaxDevice := TLMaxDevice
  else
    TLMaxDevice := strtoint(s);
  s := trim(Groups[APos].getdata('Макс. кол-во текстовых тайм-линий'));
  if s = '' then
    TLMaxText := TLMaxText
  else
    TLMaxText := strtoint(s);
  s := trim(Groups[APos].getdata('Макс. кол-во медиа тайм-линий'));
  if s = '' then
    TLMaxMedia := TLMaxMedia
  else
    TLMaxMedia := strtoint(s);


  // s:=trim(Groups[APos].getdata('Цвет шрифта время события'));
  // if s='' then Layer2FontColor:=Layer2FontColor else Layer2FontColor:=strtoint(s);
  // s:=trim(Groups[APos].getdata('Размер шрифта время события'));
  // if s='' then Layer2FontSize:=Layer2FontSize else Layer2FontSize:=strtoint(s);

  // ==============================================================================
  APos := 7;

  s := trim(Groups[APos].getdata('Хронометраж пустого клипа (кадры)'));
  if s = '' then
    DefaultClipDuration := 10250
  else
    DefaultClipDuration := strtoint(s);
  s := trim(Groups[APos].getdata('Кол-во кадров до события'));
  if s = '' then
    TLPreroll := TLPreroll
  else
    TLPreroll := strtoint(s);
  s := trim(Groups[APos].getdata('Кол-во кадров после события'));
  if s = '' then
    TLPostroll := TLPostroll
  else
    TLPostroll := strtoint(s);
  s := trim(Groups[APos].getdata('Кол-во кадров вспышки'));
  if s = '' then
    TLFlashDuration := TLFlashDuration
  else
    TLFlashDuration := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет курсора НТК'));
  if s = '' then
    StartColorCursor := StartColorCursor
  else
    StartColorCursor := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет курсора КТК'));
  if s = '' then
    EndColorCursor := EndColorCursor
  else
    EndColorCursor := strtoint(s);
  // s:=trim(Groups[APos].getdata('Цвет шрифта шкалы времени'));
  // if s='' then TLFontColor:=TLFontColor else TLFontColor:=strtoint(s);

  // ==============================================================================
  APos := 8;

  s := trim(Groups[APos].getdata('Количество отображаемых событий'));
  if s = '' then
    RowsEvents := RowsEvents
  else
    RowsEvents := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет заднего фона зоны событий'));
  if s = '' then
    AirBackGround := AirBackGround
  else
    AirBackGround := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет перднего фона зоны событий'));
  if s = '' then
    AirForeGround := AirForeGround
  else
    AirForeGround := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет события'));
  if s = '' then
    AirColorTimeline := AirColorTimeline
  else
    AirColorTimeline := strtoint(s);

  s := trim(Groups[APos].getdata('Цвет фона зоны устройств'));
  if s = '' then
    DevBackGround := DevBackGround
  else
    DevBackGround := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет линии тайм-кода'));
  if s = '' then
    TimeForeGround := TimeForeGround
  else
    TimeForeGround := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет секундных отсчетов'));
  if s = '' then
    TimeSecondColor := TimeSecondColor
  else
    TimeSecondColor := strtoint(s);
  s := trim(Groups[APos].getdata('Цвет шрифта комментария'));
  if s = '' then
    AirFontComment := AirFontComment
  else
    AirFontComment := strtoint(s);

  // ==============================================================================
  APos := 9;
  ch := formatsettings.DecimalSeparator;
  formatsettings.DecimalSeparator := '.';
  s := trim(Groups[APos].getdata('Левое поле'));
  if s = '' then
    PrintSpaceLeft := PrintSpaceLeft
  else
    PrintSpaceLeft := strtofloat(s);

  s := trim(Groups[APos].getdata('Верхнее поле'));
  if s = '' then
    PrintSpaceTop := PrintSpaceTop
  else
    PrintSpaceTop := strtofloat(s);

  s := trim(Groups[APos].getdata('Правое поле'));
  if s = '' then
    PrintSpaceRight := PrintSpaceRight
  else
    PrintSpaceRight := strtofloat(s);

  s := trim(Groups[APos].getdata('Нижнее поле'));
  if s = '' then
    PrintSpaceBottom := PrintSpaceBottom
  else
    PrintSpaceBottom := strtofloat(s);

  s := trim(Groups[APos].getdata('Верхний колонтитул'));
  if s = '' then
    PrintHeadLineTop := PrintHeadLineTop
  else
    PrintHeadLineTop := strtofloat(s);

  s := trim(Groups[APos].getdata('Нижний колонтитул'));
  if s = '' then
    PrintHeadLineBottom := PrintHeadLineBottom
  else
    PrintHeadLineBottom := strtofloat(s);
  formatsettings.DecimalSeparator := ch;
  PrintCol1 := trim(Groups[APos].getdata('Название первого столбца'));
  PrintCol2 := trim(Groups[APos].getdata('Название второго столбца'));
  PrintCol3 := trim(Groups[APos].getdata('Название третьего столбца'));
  PrintCol4 := trim(Groups[APos].getdata('Название четвертого столбца'));
  PrintCol5 := trim(Groups[APos].getdata('Название пятого столбца'));
  PrintCol61 := trim(Groups[APos].getdata('Название шестого столбца вар.1'));
  PrintCol62 := trim(Groups[APos].getdata('Название шестого столбца вар.2'));
  PrintDeviceName := trim(Groups[APos].getdata('Поле название устройства'));
  // ==============================================================================
  RowGridClips.SetDefaultFonts;
  RowGridClips.HeightTitle := ClipsHeightTitle;
  RowGridClips.HeightRow := ClipsHeightRow;
  for j := 0 to RowGridClips.Count - 1 do
  begin
    for k := 0 to RowGridClips.MyCells[j].Count - 1 do
    begin
      RowGridClips.MyCells[j].Rows[k].Top := PLRowsTop + k *
        (PLRowsHeight + PLRowsInterval);
      RowGridClips.MyCells[j].Rows[k].Height := PLRowsHeight;
      for n := 0 to RowGridClips.MyCells[j].Rows[k].Count - 1 do
      begin
        RowGridClips.MyCells[j].Rows[k].Phrases[n].Top := RowGridClips.MyCells
          [j].Rows[k].Top;
        RowGridClips.MyCells[j].Rows[k].Phrases[n].Height :=
          RowGridClips.MyCells[j].Rows[k].Height;
      end;
    end;
  end;

  RowGridListPL.SetDefaultFonts;
  RowGridListPL.HeightTitle := PLHeightTitle;
  RowGridListPL.HeightRow := PLHeightRow;
  for j := 0 to RowGridListPL.Count - 1 do
  begin
    for k := 0 to RowGridListPL.MyCells[j].Count - 1 do
    begin
      RowGridListPL.MyCells[j].Rows[k].Top := PLRowsTop + k *
        (PLRowsHeight + PLRowsInterval);
      RowGridListPL.MyCells[j].Rows[k].Height := PLRowsHeight;
      for n := 0 to RowGridClips.MyCells[j].Rows[k].Count - 1 do
      begin
        RowGridClips.MyCells[j].Rows[k].Phrases[n].Top := RowGridClips.MyCells
          [j].Rows[k].Top;
        RowGridClips.MyCells[j].Rows[k].Phrases[n].Height :=
          RowGridClips.MyCells[j].Rows[k].Height;
      end;
    end;
  end;

  RowGridListTxt.SetDefaultFonts;
  RowGridListGR.SetDefaultFonts;
  TempGridRow.SetDefaultFonts;

  for i := 0 to Form1.GridLists.RowCount - 1 do
  begin
    (Form1.GridLists.Objects[0, i] as tgridrows).SetDefaultFonts;
    (Form1.GridLists.Objects[0, i] as tgridrows).HeightTitle := PLHeightTitle;
    (Form1.GridLists.Objects[0, i] as tgridrows).HeightRow := PLHeightRow;
    with (Form1.GridLists.Objects[0, i] as tgridrows) do
    begin
      for j := 0 to Count - 1 do
      begin
        for k := 0 to MyCells[j].Count - 1 do
        begin
          MyCells[j].Rows[k].Top := PLRowsTop + k *
            (PLRowsHeight + PLRowsInterval);
          MyCells[j].Rows[k].Height := PLRowsHeight;
          for n := 0 to MyCells[j].Rows[k].Count - 1 do
          begin
            MyCells[j].Rows[k].Phrases[n].Top := MyCells[j].Rows[k].Top;
            MyCells[j].Rows[k].Phrases[n].Height := MyCells[j].Rows[k].Height;
          end;
        end;
      end;
    end;
  end;

  for i := 0 to Form1.GridClips.RowCount - 1 do
  begin
    (Form1.GridClips.Objects[0, i] as tgridrows).SetDefaultFonts;
    (Form1.GridClips.Objects[0, i] as tgridrows).HeightTitle :=
      ClipsHeightTitle;
    (Form1.GridClips.Objects[0, i] as tgridrows).HeightRow := ClipsHeightRow;
    with (Form1.GridClips.Objects[0, i] as tgridrows) do
    begin
      for j := 0 to Count - 1 do
      begin
        for k := 0 to MyCells[j].Count - 1 do
        begin
          MyCells[j].Rows[k].Top := ClipsRowsTop + k *
            (ClipsRowsHeight + ClipsRowsInterval);
          MyCells[j].Rows[k].Height := ClipsRowsHeight;
          for n := 0 to MyCells[j].Rows[k].Count - 1 do
          begin
            MyCells[j].Rows[k].Phrases[n].Top := MyCells[j].Rows[k].Top;
            MyCells[j].Rows[k].Phrases[n].Height := MyCells[j].Rows[k].Height;
          end;
        end;
      end;
    end;
  end;

  for i := 0 to Form1.GridActPlayList.RowCount - 1 do
  begin
    (Form1.GridActPlayList.Objects[0, i] as tgridrows).SetDefaultFonts;
    (Form1.GridActPlayList.Objects[0, i] as tgridrows).HeightTitle :=
      ClipsHeightTitle;
    (Form1.GridActPlayList.Objects[0, i] as tgridrows).HeightRow :=
      ClipsHeightRow;
    with (Form1.GridActPlayList.Objects[0, i] as tgridrows) do
    begin
      for j := 0 to Count - 1 do
      begin
        for k := 0 to MyCells[j].Count - 1 do
        begin
          MyCells[j].Rows[k].Top := ClipsRowsTop + k *
            (ClipsRowsHeight + ClipsRowsInterval);
          MyCells[j].Rows[k].Height := ClipsRowsHeight;
          for n := 0 to MyCells[j].Rows[k].Count - 1 do
          begin
            MyCells[j].Rows[k].Phrases[n].Top := MyCells[j].Rows[k].Top;
            MyCells[j].Rows[k].Phrases[n].Height := MyCells[j].Rows[k].Height;
          end;
        end;
      end;
    end;
  end;

  for i := 0 to Form1.GridGRTemplate.RowCount - 1 do
    (Form1.GridGRTemplate.Objects[0, i] as tgridrows).SetDefaultFonts;
  for i := 0 to FButtonOptions.Stringgrid1.RowCount - 1 do
    (FButtonOptions.Stringgrid1.Objects[0, i] as tgridrows).SetDefaultFonts;
  for i := 0 to FGRTemplate.GridImgTemplate.RowCount - 1 do
    (FGRTemplate.GridImgTemplate.Objects[0, i] as tgridrows).SetDefaultFonts;

  Form1.GridLists.Repaint;
  Form1.GridClips.Repaint;
  Form1.GridActPlayList.Repaint;
  Form1.GridGRTemplate.Repaint;
  FButtonOptions.Stringgrid1.Repaint;
  FGRTemplate.GridImgTemplate.Repaint;

  // ==============================================================================
  // pntlproj.Rows[0].Columns[0].FontSize:=MTFontSizeB;
  // pntlproj.Rows[0].Columns[1].FontSize:=MTFontSizeB;
  // pntlproj.Rows[1].Columns[0].FontSize:=MTFontSize;
  // pntlproj.Rows[1].Columns[1].FontSize:=MTFontSize-1;
  // pntlproj.Rows[2].Columns[0].FontSize:=MTFontSize;
  // pntlproj.Rows[2].Columns[1].FontSize:=MTFontSize-1;
  // pntlproj.Rows[3].Columns[0].FontSize:=MTFontSize;
  // pntlproj.Rows[3].Columns[1].FontSize:=MTFontSize;
  // pntlproj.Rows[4].Columns[0].FontSize:=MTFontSize;
  // pntlproj.Rows[4].Columns[1].FontSize:=MTFontSize;
  // pntlproj.Rows[5].Columns[0].FontSize:=MTFontSize;
  // pntlproj.Rows[5].Columns[1].FontSize:=MTFontSize;
  // ============================================================================
  // pntlclips.Rows[0].Columns[0].FontSize:=MTFontSizeB;
  // pntlclips.Rows[0].Columns[1].FontSize:=MTFontSizeS;
  // pntlclips.Rows[1].Columns[0].FontSize:=MTFontSizeS;
  // pntlclips.Rows[1].Columns[1].FontSize:=MTFontSizeS;
  // pntlclips.Rows[2].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[2].Columns[1].FontSize:=MTFontSize;
  // pntlclips.Rows[3].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[3].Columns[1].FontSize:=MTFontSize-1;
  // pntlclips.Rows[4].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[4].Columns[1].FontSize:=MTFontSize-1;
  // pntlclips.Rows[5].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[5].Columns[1].FontSize:=MTFontSize;
  // pntlclips.Rows[6].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[6].Columns[1].FontSize:=MTFontSize;
  // pntlclips.Rows[7].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[7].Columns[1].FontSize:=MTFontSize;
  // pntlclips.Rows[8].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[8].Columns[1].FontSize:=MTFontSize;
  // pntlclips.Rows[9].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[9].Columns[1].FontSize:=MTFontSize;
  // pntlclips.Rows[10].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[10].Columns[1].FontSize:=MTFontSize;
  // pntlclips.Rows[11].Columns[0].FontSize:=MTFontSize;
  // pntlclips.Rows[11].Columns[1].FontSize:=MTFontSize;
  // ============================================================================
  // pntlprep.Rows[0].Columns[0].FontSize:=MTFontSizeB;
  // pntlprep.Rows[0].Columns[1].FontSize:=MTFontSizeB;
  // pntlprep.Rows[0].Columns[2].FontSize:=MTFontSizeS;
  // pntlprep.Rows[1].Columns[0].FontSize:=MTFontSizeS;
  // pntlprep.Rows[1].Columns[1].FontSize:=MTFontSizeS;
  // pntlprep.Rows[2].Columns[0].FontSize:=MTFontSize;
  // pntlprep.Rows[2].Columns[1].FontSize:=MTFontSize;
  // ============================================================================
  // pntlplist.Rows[0].Columns[0].FontSize:=MTFontSizeB;
  // pntlplist.Rows[0].Columns[1].FontSize:=MTFontSizeS;
  // pntlplist.Rows[1].Columns[0].FontSize:=MTFontSizeS;
  // pntlplist.Rows[1].Columns[1].FontSize:=MTFontSizeS;
  // pntlplist.Rows[2].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[2].Columns[1].FontSize:=MTFontSize;
  // pntlplist.Rows[3].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[3].Columns[1].FontSize:=MTFontSize-1;
  // pntlplist.Rows[4].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[4].Columns[1].FontSize:=MTFontSize;
  // pntlplist.Rows[5].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[5].Columns[1].FontSize:=MTFontSize;
  // pntlplist.Rows[6].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[6].Columns[1].FontSize:=MTFontSize;
  // pntlplist.Rows[7].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[7].Columns[1].FontSize:=MTFontSize;
  // pntlplist.Rows[8].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[8].Columns[1].FontSize:=MTFontSize;
  // pntlplist.Rows[9].Columns[0].FontSize:=MTFontSize;
  // pntlplist.Rows[9].Columns[1].FontSize:=MTFontSize;
  // =============================================================================
  // pntlapls.Rows[0].Columns[0].FontSize:=MTFontSize;
  // pntlapls.Rows[0].Columns[1].FontSize:=MTFontSize;
  // pntlapls.Rows[1].Columns[0].FontSize:=MTFontSize;
  // pntlapls.Rows[1].Columns[1].FontSize:=MTFontSize;
  // ==============================================================================
  // InputInSystem;
  InitMainForm;
  // InitPanelPrepare;
  // InitPanelAir;

  pnlprojects.BackGround := ProgrammColor;
  pnlprojcntl.BackGround := ProgrammColor;
  pnlplaylsts.BackGround := ProgrammColor;

  InitPanelProject(false);
  InitPanelControl;
  InitPanelClips(false);
  InitPanelPlayList(false);
  InitPanelPrepare(false);
  // UpdatePanelPrepare;
  // UpdatePanelAir;
  InitPanelAir;

  InitNewProject;
  InitPlaylists;
  InitTextTemplates;
  InitMyMessage;
  InitEditTimeline;
  InitImageTemplate(false);
  InitImportFiles;
  InitFrSetTemplate;
  InitFrSetEventData;
  InitFrButtonOptions;
  InitFrSortGrid;
  InitFrShiftTL;
  InitFrShortNum;
  InitFrMediaCopy;
  InitfrMyPrint;
  InitFPageSetup;
  InitFrLTC;
  InitfrTimeCode;
  InitfrMyTextTemplate;
  InitfrNewList;
  // MyStartWindow;
  // InitMyStartWindow;
  // InitInputInSystem;
  InitFrSaveProject;
  InitfrHotKeys;
  InitFrListErrors;
  InitFrMyOptions;
  initFrSetProcent;
  InitFrProtocols;

end;

procedure TListPartitions.Draw(cv: tcanvas);
var
  tmp: tfastdib;
  // rt: trect;
  i, wdth, hght, rowhght: integer;
begin
  // init(cv);
  tmp := tfastdib.Create;
  try
    wdth := cv.ClipRect.Right - cv.ClipRect.Left;
    hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
    tmp.SetSize(wdth, hght, 32);
    tmp.clear(TColorToTfcolor(FormsColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetPen(ps_Solid, 1, colortorgb(FormsFontColor));
    tmp.SetTextColor(colortorgb(FormsFontColor));
    tmp.SetFont(FormsFontName, MTFontSize);
    for i := 0 to Count - 1 do
    begin
      List[i].Rect.Right := wdth - 10;
      if List[i].Select then
        tmp.SetBrush(bs_solid, 0, SmoothColor(colortorgb(FormsColor), 64))
      else
        tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
      tmp.FillRect(List[i].Rect);
      tmp.DrawText(inttostr(i + 1), Rect(List[i].Rect.Left, List[i].Rect.Top,
        List[i].Rect.Left + 25, List[i].Rect.Bottom), DT_CENTER);
      tmp.DrawText(trim(List[i].Text), Rect(List[i].Rect.Left + 30,
        List[i].Rect.Top, List[i].Rect.Right, List[i].Rect.Bottom), DT_LEFT);
    end;
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
    tmp := nil;
  end;
end;

procedure TListPartitions.MouseMove(cv: tcanvas; X, Y: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if (X > List[i].Rect.Left + 1) and (X < List[i].Rect.Right - 1) and
      (Y > List[i].Rect.Top + 1) and (Y < List[i].Rect.Bottom - 1) then
    begin
      // List[i].select:=true;
      // exit;
    end;
  end;
end;

function TListPartitions.MouseClick(cv: tcanvas; X, Y: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    List[i].Select := false;
  for i := 0 to Count - 1 do
  begin
    if (X > List[i].Rect.Left + 1) and (X < List[i].Rect.Right - 1) and
      (Y > List[i].Rect.Top + 1) and (Y < List[i].Rect.Bottom - 1) then
    begin
      List[i].Select := true;
      result := i;
      exit;
    end;
  end;
end;

constructor TGroupOptions.Create;
begin
  Count := 0;
end;

destructor TGroupOptions.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@Options);
end;

procedure TGroupOptions.setdata(SName: string; SValue: String);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if lowercase(trim(Options[i].Name)) = lowercase(trim(SName)) then
    begin
      Options[i].Value := SValue;
      exit;
    end;
  end;
end;

procedure TGroupOptions.setdata(Posi: integer; SValue: string);
begin
  Options[Posi].Value := SValue;
end;

function TGroupOptions.getdata(SName: string): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to Count - 1 do
  begin
    if lowercase(trim(Options[i].Name)) = lowercase(trim(SName)) then
    begin
      result := Options[i].Value;
      exit;
    end;
  end;
end;

function TGroupOptions.getdata(Posi: integer): string;
begin
  result := Options[Posi].Value;
end;

procedure TGroupOptions.clear;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
  begin
    Options[Count - 1].Variants.clear;
    Options[Count - 1].Variants.Free;
    Options[Count - 1].FreeInstance;
    Count := Count - 1;
    SetLength(Options, Count);
  end;
  Count := 0;
end;

function TGroupOptions.adddata(SName, SValue: string; TypeD: TMyTypeOption;
  Left, Top, Width, Height: integer): integer;
begin
  Count := Count + 1;
  SetLength(Options, Count);
  Options[Count - 1] := TOneOption.Create(SName, SValue, TypeD, Left, Top,
    Width, Height);
  result := Count - 1;
end;

procedure TGroupOptions.AddVariant(Name: String; Variant: string);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if lowercase(trim(Options[i].Name)) = lowercase(trim(Name)) then
    begin
      Options[i].Variants.Add(Variant);
      exit;
    end;
  end;
end;

procedure TGroupOptions.AddVariant(Posi: integer; Variant: string);
begin
  Options[Posi].Variants.Add(Variant);
end;

procedure TGroupOptions.ClearVariants(Name: string);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if lowercase(trim(Options[i].Name)) = lowercase(trim(Name)) then
    begin
      Options[i].Variants.clear;
      exit;
    end;
  end;
end;

procedure TGroupOptions.ClearVariants(Posi: integer);
begin
  Options[Posi].Variants.clear;
end;

procedure TGroupOptions.setborder(Posi, Left, Width: integer);
begin
  Options[Posi].rtname.Left := Left;
  Options[Posi].rtname.Right := Left + (Width div 7) * 5;
  Options[Posi].rtval.Left := Options[Posi].rtname.Right + 5;
  Options[Posi].rtval.Right := Left + Width;
end;

procedure TGroupOptions.Draw(cv: tcanvas);
var
  tmp: tfastdib;
  i, wdth, hght, rowhght: integer;
  clr: tcolor;
  intclr: longint;
  RT: trect;
begin
  tmp := tfastdib.Create;
  try
    wdth := cv.ClipRect.Right - cv.ClipRect.Left;
    hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
    tmp.SetSize(wdth, hght, 32);
    tmp.clear(TColorToTfcolor(FormsColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetPen(ps_Solid, 1, colortorgb(FormsFontColor));
    tmp.SetTextColor(colortorgb(FormsFontColor));
    tmp.SetFont(FormsFontName, MTFontSize);
    for i := 0 to Count - 1 do
    begin
      setborder(i, 10, wdth - 20);
      tmp.DrawText(Options[i].Name, Options[i].rtname, DT_VCENTER or
        DT_SINGLELINE);
      if Options[i].TypeData <> tomColor then
      begin
        tmp.DrawText(Options[i].Value, Options[i].rtval, DT_VCENTER or
          DT_SINGLELINE);
      end
      else
      begin
        if trim(Options[i].Value) = '' then
          clr := FormsColor
        else
          clr := strtoint(Options[i].Value);
        tmp.SetBrush(bs_solid, 0, colortorgb(clr));
        RT.Left := Options[i].rtval.Left;
        RT.Right := Options[i].rtval.Right;
        RT.Top := Options[i].rtval.Top + 1;
        RT.Bottom := Options[i].rtval.Bottom - 1;

        tmp.FillRect(RT);
        tmp.Rectangle(RT.Left, RT.Top, RT.Right, RT.Bottom);
        tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
      end;
    end;
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
    tmp := nil;
  end
end;

function TGroupOptions.MouseClick(cv: tcanvas; X, Y: integer): integer;
var
  i: integer;
  clr: tcolor;
begin
  result := -1;
  // for i:=0 to Count-1 do List[i].select:=false;
  for i := 0 to Count - 1 do
  begin
    if (X > Options[i].rtval.Left + 1) and (X < Options[i].rtval.Right - 1) and
      (Y > Options[i].rtval.Top + 1) and (Y < Options[i].rtval.Bottom - 1) then
    begin
      if Options[i].TypeData <> tomColor then
      begin
        if (Options[i].Variants.Count > 0) or (Options[i].TypeData = tomFontName)
        then
        begin
          FrMyOptions.ComboBox1.Left := Options[i].rtval.Left + 1;
          FrMyOptions.ComboBox1.Top := Options[i].rtval.Top + 1;
          FrMyOptions.ComboBox1.Width := Options[i].rtval.Right - Options[i]
            .rtval.Left;
          FrMyOptions.ComboBox1.clear;
          if Options[i].TypeData = tomFontName then
          begin
            FrMyOptions.ComboBox1.Items.Assign(Screen.Fonts);
          end
          else
          begin
            FrMyOptions.ComboBox1.Items.Assign(Options[i].Variants);
          end;
          FrMyOptions.ComboBox1.ItemIndex := FrMyOptions.ComboBox1.Items.IndexOf
            (trim(Options[i].Value));
          FrMyOptions.ComboBox1.Visible := true;
          FrMyOptions.Edit1.Visible := false;
        end
        else
        begin
          FrMyOptions.Edit1.Left := Options[i].rtval.Left + 1;
          FrMyOptions.Edit1.Top := Options[i].rtval.Top + 1;
          FrMyOptions.Edit1.Width := Options[i].rtval.Right - Options[i]
            .rtval.Left;
          FrMyOptions.Edit1.Text := trim(Options[i].Value);
          FrMyOptions.ComboBox1.Visible := false;
          FrMyOptions.Edit1.Visible := true;
        end;
      end
      else
      begin
        FrMyOptions.ComboBox1.Visible := false;
        FrMyOptions.Edit1.Visible := false;
        if trim(Options[i].Value) = '' then
          clr := FormsColor
        else
          clr := strtoint(Options[i].Value);
        FrMyOptions.ColorDialog1.Color := clr;
        if Not FrMyOptions.ColorDialog1.Execute then
          exit;
        Options[i].Value := inttostr(FrMyOptions.ColorDialog1.Color);

      end;
      result := i;
      exit;
    end;
  end;
end;

constructor TOneOption.Create(SName, SValue: string; TypeD: TMyTypeOption;
  Left, Top, Width, Height: integer);
begin
  Name := SName;
  Value := SValue;
  TypeData := TypeD;
  Variants := tstringlist.Create;
  Variants.clear;
  rtname.Left := Left;
  rtname.Top := Top;
  rtname.Bottom := Top + Height;
  rtname.Right := Left + (Width div 7) * 5;
  rtval.Left := rtname.Right;
  rtval.Right := Left + Width;
  rtval.Top := Top;
  rtval.Bottom := Top + Height;
end;

destructor TOneOption.destroy;
begin
  freemem(@Name);
  freemem(@Value);
  freemem(@rtname);
  freemem(@rtval);
  freemem(@TypeData);
  Variants.clear;
  Variants.Free;
  freemem(@Variants);
end;

procedure TOneOption.Draw(dib: tfastdib);
begin
  dib.SetTextColor(colortorgb(FormsFontColor));
  dib.SetFont(FormsFontName, MTFontSize);
  dib.DrawText(Name, rtname, DT_LEFT);
  dib.DrawText(Value, Rect(rtval.Left + 5, rtval.Top, rtval.Right,
    rtval.Bottom), DT_LEFT);
end;

procedure TFrMyOptions.ComboBox1Change(Sender: TObject);
begin
  if (IndexPartition <> -1) and (IndexOption <> -1) then
  begin
    if ComboBox1.Visible then
      ListOptions.Groups[IndexPartition].Options[IndexOption].Value :=
        ComboBox1.Items.Strings[ComboBox1.ItemIndex];
  end;
end;

procedure TFrMyOptions.Edit1Change(Sender: TObject);
begin
  if (IndexPartition <> -1) and (IndexOption <> -1) then
  begin
    if Edit1.Visible then
    begin
      if trim(Edit1.Text) = '' then
        if TypeEditor <> tomString then
          Edit1.Text := '0';
      ListOptions.Groups[IndexPartition].Options[IndexOption].Value :=
        Edit1.Text;
    end;
  end;

end;

procedure TFrMyOptions.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 0 then

end;

procedure TFrMyOptions.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  ps: integer;
  ch: Char;
begin
  ch := formatsettings.DecimalSeparator;
  formatsettings.DecimalSeparator := '.';
  if Key = 'ю' then
    Key := '.';

  case TypeEditor of
    tomInteger:
      begin
        if not(Key in [#8, '0', '1' .. '9']) then
          Key := #0;
        exit;
        formatsettings.DecimalSeparator := ch;
      end;
    tomFloat:
      begin
        ps := pos(',', trim(Edit1.Text));
        if ps <> 0 then
        begin
          if not(Key in [#8, '0', '1' .. '9']) then
            Key := #0;
        end
        else if not(Key in [#8, '.', '0', '1' .. '9']) then
          Key := #0;
        formatsettings.DecimalSeparator := ch;
        exit;
      end;
  end;
  formatsettings.DecimalSeparator := ch;
end;

procedure TFrMyOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Edit1.Visible := false;
  ComboBox1.Visible := false;
end;

procedure TFrMyOptions.FormCreate(Sender: TObject);
begin
  InitFrMyOptions;
  btnpnloptions.Draw(imgButtons.Canvas);
end;

procedure TFrMyOptions.imgButtonsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  btnpnloptions.MouseMove(imgButtons.Canvas, X, Y);
  btnpnloptions.Draw(imgButtons.Canvas);
  imgButtons.Repaint;
end;

procedure TFrMyOptions.imgButtonsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  res: integer;
begin
  res := btnpnloptions.ClickButton(imgButtons.Canvas, X, Y);
  btnpnloptions.Draw(imgButtons.Canvas);
  imgButtons.Repaint;
  case res of
    0:
      ModalResult := mrOk;
    1:
      begin
        ListOptions.SaveData;
        ModalResult := mrOk;
      end;
  end;
end;

procedure TFrMyOptions.imgOptionsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  res, indx: integer;
begin
  if IndexPartition = -1 then
    exit;
  Edit1.Visible := false;
  // IndexPartition  := ListPartitions.Index;
  IndexOption := ListOptions.Groups[IndexPartition].MouseClick
    (imgOptions.Canvas, X, Y);
  if IndexOption <> -1 then
  begin
    TypeEditor := ListOptions.Groups[IndexPartition].Options
      [IndexOption].TypeData;
  end;
  ListOptions.Groups[IndexPartition].Draw(imgOptions.Canvas);
  imgOptions.Repaint;
end;

procedure TFrMyOptions.imgPartitionsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  Edit1.Visible := false;
  ComboBox1.Visible := false;
end;

procedure TFrMyOptions.imgPartitionsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  res: integer;
begin
  IndexPartition := ListPartitions.MouseClick(imgPartitions.Canvas, X, Y);
  ListPartitions.Draw(imgPartitions.Canvas);
  imgPartitions.Repaint;
  if IndexPartition <> -1 then
    ListOptions.Groups[IndexPartition].Draw(FrMyOptions.imgOptions.Canvas);
  FrMyOptions.imgOptions.Repaint;
end;

procedure TFrMyOptions.Panel1Resize(Sender: TObject);
begin
  imgPartitions.Picture.Bitmap.Width := imgPartitions.Width;
  imgPartitions.Picture.Bitmap.Height := imgPartitions.Height;
  ListPartitions.Draw(imgPartitions.Canvas);
  imgPartitions.Repaint;
end;

initialization

ListPartitions := TListPartitions.Create;
ListPartitions.init;
ListPartitions.List[0].Select := true;

ListOptions := TListOptions.Create;
ListOptions.clear;

finalization

ListPartitions.FreeInstance;
ListPartitions := nil;

ListOptions.FreeInstance;
ListOptions := nil;

end.
