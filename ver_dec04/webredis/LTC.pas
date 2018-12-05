unit ltc;
Type
  TSinchronization = (chltc, chsystem, chnone1);
  
  PCompartido = ^TCompartido;

  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero: integer;
    Shift: Double;
    State: boolean;
    Cadena: String[20];
  end;  

  TForm1 = class(TForm)
    
      //Переменные и процедуры Form1

  private
    { Private declarations }
    
    FicheroM: THandle;
    procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    
  public
    { Public declarations }
    Compartido: PCompartido;
  end;

Var 
  MyShift: Double = 0; // Смещение LTC относительно системного времени
  TCExists: boolean = false; 
  MyShiftOld: Double = 0; // Старое смещение LTC относительно системного времени
  MyShiftDelta: Double = 0;
  MySinhro: TSinchronization = chsystem;


procedure TForm1.Reciviendo(var Msg: TMessage);
begin
  try
    // label1.Caption:=compartido^.Cadena;
    MyShiftOld := MyShift;
    MyShift := Compartido^.Shift;
    Compartido^.Cadena := '';
    WriteLog('MAIN', 'Message:Reciviendo');
  except
    on E: Exception do
      WriteLog('MAIN', 'Message:Reciviendo | ' + E.Message);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // ++++++++++++++++++++++++++++++++++++++++++
    { Посмотрим, существует ли файл }
    FicheroM := OpenFileMapping(FILE_MAP_ALL_ACCESS, FALSE, 'MiFichero');
    { Если нет, то ошибка }
    if FicheroM = 0 then
      FicheroM := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
        SizeOf(TCompartido), 'MiFichero');
    // если создается файл, заполним его нулями
    if FicheroM = 0 then
      raise Exception.Create('Не удалось создать файл' +
        '/Ошибка при создании файла');
    Compartido := MapViewOfFile(FicheroM, FILE_MAP_WRITE, 0, 0, 0);
    Compartido^.Manejador2 := Handle;
    Compartido^.Cadena := 'request';
    // ++++++++++++++++++++++++++++++++++++++++++

end;


procedure TMyThread.DoWork;

   .......
  
   if (not Form1.Compartido^.State) and (MySinhro = chltc) then
     Form1.lbCTLTimeCode.Caption := '*' +
     MyDateTimeToStr(now - TimeCodeDelta)
   else
     Form1.lbCTLTimeCode.Caption :=
           '' + MyDateTimeToStr(now - TimeCodeDelta);
     PutJsonStrToServer('CTC',Form1.lbCTLTimeCode.SaveToJSONStr);
     TLParameters.TLTimeCode :=Form1.lbCTLTimeCode.Caption;
   
   .......

end;


//Опрос по таймеру

function TimeCodeDelta: Double;
begin
  result := 0;
  if MySinhro = chltc then
    result := MyShift;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  hh, mm, ss, ms: Word;
  dt, tm: Double;
  Step: real;
begin
  try
    MyShift := Compartido^.Shift;
    TCExists := Compartido^.State;
    if not PanelPrepare.Visible then
    begin
      LBTimeCode1.Visible := true;
      if (not Compartido^.State) and (MySinhro = chltc) then
        LBTimeCode1.Caption := '*' + MyDateTimeToStr(now - TimeCodeDelta)
      else
        LBTimeCode1.Caption := '' + MyDateTimeToStr(now - TimeCodeDelta);
            PutJsonStrToServer('CTC',lbTimeCode1.SaveToJSONStr);
      TLParameters.TLTimeCode :=Form1.lbCTLTimeCode.Caption;

    end
    else
      LBTimeCode1.Visible := FALSE;
    if TLParameters.vlcmode <> play then
    begin
      if (not Compartido^.State) and (MySinhro = chltc) then
        lbCTLTimeCode.Caption := '*' + MyDateTimeToStr(now - TimeCodeDelta)
      else
        lbCTLTimeCode.Caption := '' + MyDateTimeToStr(now - TimeCodeDelta);
            PutJsonStrToServer('CTC',lbCTLTimeCode.SaveToJSONStr);
      TLParameters.TLTimeCode :=Form1.lbCTLTimeCode.Caption;
    end;
    Form1.Compartido^.Cadena := 'request';
  except
    on E: Exception do
      WriteLog('MAIN', 'TForm1.Timer1Timer | ' + E.Message);
  end;
end;