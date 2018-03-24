unit DAS_Const;

interface
uses controls,classes,windows,inifiles,stdctrls,comctrls,extctrls,sysutils,
     forms,grids,spin, TeEngine, Series, TeeProcs,Graphics,jpeg,adodb,mmsystem;
Const
  MaxPointsInChart = 400;
  ChColors :array [0..8] of tcolor =(clFuchsia,clGreen,clBlack,clOlive,clRed,clBlue,clPurple,clMaroon,clNavy);
Type
  TAMPData = packed record
    ADCReady      : array [0..300] of double;
    OldAMP        : array [0..100]  of double;
  end;
  TLNRData = packed record
    ADCReady      : array [0..300] of double;
    ADCHFReady     : array [0..300] of double;
    DACready      : array [0..100]  of double;
  end;

  TGeneralData = packed record

  end;
  TPuncher = packed record
    OutgoingPocketdepth : Integer;
    IngoingPocketdepth  : Integer;
    OutgoingPocketOOR   : Boolean;
    IngoingPocketOOR    : Boolean;
    Length              : double;
  end;
  TvacuumPoint = packed record
    name       : array [0..7] of char;
    val        :double;
  end;
  TVacuumdata = packed record
    BPDV                :array[0..3,0..7] of double;
  end;
  TProfiledata = packed record
    Attachvariant : integer;
    Units         : array [0..36] of array [0..10] of char;
    Mults         : array [0..36] of double;
    ABSMults      : array [0..36] of double;
    Channels      : array [0..36] of double;
    RawChannels   : array [0..36] of double;
    Titls         : array [0..36] of array [0..100] of char;
  end;
  TMagnetData = packed record
    NMR      : double;
    Current  : double;
    NMRIND   : byte;
  end;
  TBeamOutData = packed record
    PowerIND       :INT64;
    WaterIND       :Int64;
    TemperatureIND :Int64;
    BM1            :Double;
    BM2            :double;
    Q1             :double;
    Q2             :Double;
    KM             :double;
    Faraday1       :Double;
    Faraday2       :Double;
    Lamels10       :array[0..9] of double;
    Currents       :Array[0..3] of double;
   end;
  THFData    = packed record
    Trimmer1      :double;
    Trimmer2      :double;
    Phase         :double;
    Voltage1      :Double;
    PWRFall1      :double;
    PWRReflected1 :double;
    Voltage2      :Double;
    PWRFall2      :double;
    PWRReflected2 :double;
    Phasometer    :double;
  end;
  TDASRecord = packed record
    SnapTime    :double;
    Puncher     :Tpuncher;
    VacuumData  :TVacuumData;
    ProfileData :tProfiledata;
    MagnetData  :TMagnetData;
    BeamOutData :TbeamOutData;
    HFData      :THFData;
  end;
function decodepassword(psw : string) : string;
function encodepassword(psw : string) : string;
procedure WriteprofileToDB(dbname:string;q1:tadoquery;msTime:int64;ChamberSumm,Summx,SummY,SummC,CurBuncher,napBuncher:double;channels:array of double;startXScan,CountXScan,StartyScan,CountYScan:integer;ara1,ara2:double);
procedure WriteOLDAMPToDB(dbname:string;q1:tadoquery;fk12:double;channels:array of double;chCount,lamelStart,LamelCount:integer);
Function GPIBError(iberr :integer) :string;
  Function   OpenPort(comport:string):thandle;overload;
  Function   OpenPort(comport,baud:string):thandle;overload;
  procedure  SetAxisMax(Axis: tchartAxis; ser:tchartseries);
  Procedure  SaveComponents(Component:TComponent);
  Procedure  RestoreComponents(Component:TComponent);
  Function   readDasdata:boolean;
  Function   WriteDasData:Boolean;
  Function   WriteBoostData:Boolean;
  Function   WriteLNRData:Boolean;

  Function   SpinByName(component:tcomponent;name:string):TSpinEdit;
  Procedure  WriteLog(LogName,LogData:ansiString);overload;
  Procedure  WriteLog(LogData:ansiString);overload;
  Procedure  WriteTimeLog(LogName,LogData:ansiString);overload;
  Procedure  WriteTimeLog(LogData:ansiString);overload;
  Procedure  WriteProtocol(LogData:ansiString);
  Function   ChangeChar(const str:string;SrcChar,DstChar:Char):String;
  Function   ConvertFloat(str:string;var Newval:double):boolean;
  Function   ElapshedTime:double;
  Function   ExecCommand485(rs:thandle;CMD:string):string;
  Procedure  SaveToJPG(bitmap:tbitmap;afile :string);
  Procedure  WriteToFile(Logname,LogData:String);
  Function   HexToInt(str:string;var Val:int64):boolean;
  pROCEDURE  MySleep(dl:integer);
  Function   readAMPData : boolean;
function timeGetMinPeriod(): DWORD;
function timeGetMaxPeriod(): Cardinal;
//  Procedure  FillVacuumGrid(vg:qcomctrls.Tlistview);overload;

//  Function   Parce(n:integer;str:string;def array])
var
  Vacuum                   : array[0..100] of tvacuumPoint;
  vacname                  : string = 'Vacuum.dat';
  lnrname                  : string = 'LNRdata.dat';
  AMPDatA                  : tAMPData;
  LNRDatA                  : tLNRData;
  charbuf                  : array[0..100] of char;
  compname                 : string;
  Titls                    : array [0..35] of string;
  DasProcess               : boolean  = false;
  VacuumAlarmSound         : boolean=false;
  DasTime                  : Integer = -1;
  CONNSTRing               : STRING='';
  DASData                  : TDasRecord;
  Boosts             : array [0..17] of byte;
  CF                       : TIniFile;
  ConfigFilename           : string;
  DataFileName             : string='';
  LNRDataFileName          : string='';
  AmpDataFileName          : string='';
  BoostDataFileName        : string='';
  DataDirName              : string;
  VacuumDataFileName       : string;
  CyclotrolJournalFileName : string;
  FfDas                    : TFileStream;
  LogFileName              : string;
  BeamLogFileName          : string;
  ResetFilmCounter         : boolean = false;
  GlobalLengthCounter      : Integer = 0 ;
  dcb                      : TDcB;
  Writen,nread             : dword;
  stat                     : TComStat;
  commErrors               : dword;
  CommErrorMessage         : string;
  Comm485                  : THandle;
  Comm3_485                : THandle;
  BPDV_485                 : THandle = 0;
  buf                      : array [0..20000] of char;
  PrevMTime :dword;
  CurMTime :dword;
  PrevTime :double;
  CurTime :double;

implementation
 uses types;

var
 str1           : tStringlist;
 StElapshedTime :Double=-1;
Function readAMPData:boolean;
var
 ffdata   : tfilestream;
 fname:string;
begin
     fname:=AMPDataFileName;
     if fileexists(fname) then  ffdata:= tFileStream.create(fname,fmOpenread+fmSharedenyNone)
                          else  exit;
     ffdata.read(AmpData,sizeof(ampdata));
     ffdata.Free;
end;

pROCEDURE  MySleep(dl:integer);
var
  sttime:double;
begin
 sttime:=now;
 while(Now-sttime)*24.0*3600.0*1000.0<dl do begin
   sleep(1);application.ProcessMessages;
 end;
end;

Function   HexToInt(str:string;var Val:int64):boolean;
var
  i:integer;
  char1 :char;
begin
  result:=false;
  val:=0;
  for i:=1 to length(str) do begin
    char1:=upcase(str[i]);
    case  char1 of
       '0'..'9'  :   val:=val*16+ ord(char1)-48;
       'A'..'F'  :   val:=val*16+ ord(char1)-55;
    else exit;
    end;
  end;
  result:=true;
end;

procedure SetAxisMax;
var
 MaxVal : Double;
 i1     : integer;
begin
  maxVal := 0;
  for i1:=0 to  ser.Count-1 do if maxval <= ser.YValue[i1] then MaxVal:=ser.YValue[i1];
  if Axis.Maximum < MaxVal*1.5 then Axis.Maximum:=MaxVal*1.5;
end;
  Procedure  SaveToJPG(bitmap:tbitmap;afile :string);
  var
   JpegIM : TJpegImage;
begin
  BitBlt(bitmap.Handle, 0, 0, bitmap.Width, bitmap.Height,
  GetDC(0), 0, 0, SRCCOPY);
  JpegIm := TJpegImage.Create;
  JpegIm.Assign(bitmap);
  JpegIm.CompressionQuality := 20;
  JpegIm.Compress;
  JpegIm.SaveToFile(afile);
  JpegIm.Destroy;
end;
Function OpenPort(comport:string):thandle;
var
  InSTR           : string;
  i1              : Integer;
begin

 if 0 = 0 then begin

     result := CreateFile(pchar('\\.\'+comport),
                       GENERIC_READ or GENERIC_WRITE, {access attributes}
                       0,                             {no sharing}
                       nil,                           {no security}
                       OPEN_EXISTING,                 {creation action}
                       FILE_ATTRIBUTE_NORMAL,          {attributes}
                       0);                            {no template}
     if result=INVALID_HANDLE_VALUE then   exit
     else begin
       if not SetupComm(result,4000, 4000) then RaiseLastwin32error;
      // If not EscapeCommFunction(result,5) then RaiseLastwin32error;
       If not EscapeCommFunction(result,CLRRTS) then RaiseLastwin32error;
       fillchar( dcb, sizeof(dcb), 0);
       dcb.DCBlength := sizeof(dcb);
       if not BuildCommDCB('baud=9600 parity=N data=8 stop=1 dtr=on', dcb) then RaiseLastwin32error;
                          // dcb.Flags := 17;
       if not SetCommState(result, DCB) then RaiseLastwin32error;
       if not PurgeComm(result, PURGE_TXCLEAR or PURGE_RXCLEAR) then RaiseLastwin32error;
     end;
 end;
end;
Function OpenPort(comport,baud:string):thandle;
var
  InSTR           : string;
  i1              : Integer;
  dcbparm:shortstring;
begin

 if 0 = 0 then begin

     result := CreateFile(pchar('\\.\'+comport),
                       GENERIC_READ or GENERIC_WRITE, {access attributes}
                       0,                             {no sharing}
                       nil,                           {no security}
                       OPEN_EXISTING,                 {creation action}
                       FILE_ATTRIBUTE_NORMAL,          {attributes}
                       0);                            {no template}
     if result=INVALID_HANDLE_VALUE then   exit
     else begin
       if not SetupComm(result,4000, 4000) then RaiseLastwin32error;
      // If not EscapeCommFunction(result,5) then RaiseLastwin32error;
       If not EscapeCommFunction(result,CLRRTS) then RaiseLastwin32error;
       fillchar( dcb, sizeof(dcb), 0);
       dcb.DCBlength := sizeof(dcb);
       dcbparm:='baud='+baud+' parity=N data=8 stop=1 dtr=on';
                          // dcb.Flags := 17;
       if not SetCommState(result, DCB) then RaiseLastwin32error;
       if not PurgeComm(result, PURGE_TXCLEAR or PURGE_RXCLEAR) then RaiseLastwin32error;
     end;
 end;
end;

Function   ExecCommand485(rs:thandle;CMD:string):string;
 var
   InStr   : string;
   i1      : Integer;
   Writen,nread             : dword;
   stat                     : TComStat;
   commErrors               : dword;
   buf             : array [0..1000] of char;
begin
     InStr:=cmd+#13;
     if not writefile(RS,InStr[1],Length(InSTR),writen,nil) then RaiseLastwin32error;
     for i1 := 0 to 10 do
     begin
       sleep(10);
       application.processmessages;
       if not ClearCommError(RS,commErrors,@stat)
                       then RaiseLastwin32error;
       If stat.cbInQue>=72 Then Break;
     end;
     if  CommErrors<>0 then
       begin
         Case CommErrors of
          CE_BREAK	:CommErrorMessage:='The hardware detected a break condition.';
          CE_DNS	:CommErrorMessage:='Windows 95 only: A parallel device is not selected.';
          CE_FRAME	:CommErrorMessage:='The hardware detected a framing error.';
          CE_IOE	:CommErrorMessage:='An I/O error occurred during communications with the device.';
          CE_MODE	:CommErrorMessage:='The requested mode is not supported, or the hFile parameter is invalid. If this value is specified, it is the only valid error.';
          CE_OOP	:CommErrorMessage:='Windows 95 only: A parallel device signaled that it is out of paper.';
          CE_OVERRUN	:CommErrorMessage:='A character-buffer overrun has occurred. The next character is lost.';
          CE_PTO	:CommErrorMessage:='Windows 95 only: A time-out occurred on a parallel device.';
          CE_RXOVER	:CommErrorMessage:='An input buffer overflow has occurred. There is either no room in the input buffer, or a character was received after the end-of-file (EOF) character.';
          CE_RXPARITY	:CommErrorMessage:='The hardware detected a parity error.';
          CE_TXFULL	:CommErrorMessage:='The application tried to transmit a character, but the output buffer was full.';
         end;
         WriteTimeLog(LogFileName+'.dbg','Error> 485 '+CommErrorMessage+#13);
         PurgeComm(RS, PURGE_TXCLEAR or PURGE_RXCLEAR);
       end
     else
     if stat.cbInQue>=1 then
     begin
       sleep(20);
       fillchar(buf,200,0);
       if stat.cbInQue>200 then stat.cbInQue:=200;
       readfile(rs,buf,stat.cbInQue,nread,nil);
       Result := buf;
       result:=system.copy(result,1,length(result)-1);
     end else result:='';
 end;

 Function ElapshedTime:double;
 begin
   If StElapshedTime<0 Then StElapshedTime:=now;
   result:=(Now-StElapshedTime)*24*3600;
   StElapshedTime:=Now;
 end;



  Function  ConvertFloat(str:string;var Newval:double):boolean;
  var
    i1  :Integer;
    res :Integer;
  begin
     for i1:=1 to length(str) do if str[i1]=',' then str[i1]:='.';
     val(str,newval,res);
     result:=res=0;
  end;

Procedure WriteLog(Logname,LogData:ansiString);
var
  ff:TFileStream;
begin
  try
    If FileExists(LogName)
       then ff := TFileStream.create(LogName,fmOpenWrite or  fmShareDenyNone)
       else ff := TFileStream.create(LogName,fmCreate or  fmShareDenyNone);
    ff.seek(0,soFromEnd);
    ff.write(LogData[1],length(logData));
    ff.free;
  except
  end;
end;

Procedure WriteToFile(Logname,LogData:String);
var
  ff:TFileStream;
begin

  try
    If FileExists(LogName)
       then ff := TFileStream.create(LogName,fmOpenWrite or  fmShareDenyNone)
       else ff := TFileStream.create(LogName,fmCreate or  fmShareDenyNone);
    ff.write(LogData[1],length(logData));
    ff.free;
  except
  end;
end;
Procedure WriteLog(LogData:ansiString);
var
  ff:TFileStream;
  log1:ansistring;
  tname :string;
begin
  try
    tname:=formatdatetime('yyyy-mm-dd',now)+'.txt';
    If FileExists(tName)
       then ff := TFileStream.create(tName,fmOpenWrite or  fmShareDenyNone)
       else ff := TFileStream.create(tName,fmCreate or  fmShareDenyNone);
    ff.seek(0,soFromEnd);
    log1:=Logdata;
    ff.write(Log1[1],length(log1));
    ff.free;
  except
  end;
end;
Procedure WriteProtocol(LogData:ansiString);
var
  ff:TFileStream;
  log1:string;
  tname :string;
begin
exit;
  try
    tname:='Protocol '+formatdatetime('yyyy-mm-dd',now)+'.dat';
    If FileExists(tName)
       then ff := TFileStream.create(tName,fmOpenWrite or  fmShareDenyNone)
       else ff := TFileStream.create(tName,fmCreate or  fmShareDenyNone);
    ff.seek(0,soFromEnd);
    log1:=FormatdateTime('DD/MM/YYYY HH:NN:SS ',now)+format('%.8d ',[TimegetTime()-prevMTime]) + LogData+#10;
    ff.write(Log1[1],length(log1));
    ff.free;
  except
  end;
end;
Procedure WriteTimeLog(LogData:ansiString);
begin

  WriteLog(FormatdateTime('DD/MM/YYYY HH:NN:SS',now)+' '+LogData+#10);
end;


Procedure WriteTimeLog(Logname,LogData:ansiString);
begin
  WriteLog(LogName,FormatdateTime(#10+'DD/MM/YYYY HH:NN:SS',now)+' '+LogData+#10);
end;

Function   ChangeChar(const str:string;SrcChar,DstChar:Char):String;
 var
   i1:Integer;
begin
   result:=Str;
   for i1:=1 to length(result) do if Result[i1]=SrcChar then Result[i1]:=DstChar;
end;

 Procedure  ReloadVacuumSeries(series:TLineSeries);
var
 ff                   :TFileStream;
 buff                 :array[0..2000] of char;
 RecLen               :Integer;
 ParAddr              :Integer;
 Res                  :Extended;
 r1                   :string;
 OldShortFormat       :String;
 TimeMark             :Double;
begin
 ff:=nil;
 if not FileExists(VacuumDataFilename) then exit;
 try
   ff:=TFileStream.Create(VacuumDataFilename,fmOpenRead  or fmShareDenyNone);
   fillchar(buff,2000,#0);
   ff.Read(buff,1000);
   RecLen:=pos(#13,string(buff));
   if RecLen>0 then begin
     if buff[reclen]=#10 then Inc(RecLen);
     ParAddr:=22+12*Series.Tag;
     ff.Seek(0,soFrombeginning);
     Series.Clear;
     while ff.Position<ff.Size-RecLen do begin
        ff.Read(buff,reclen);
        buff[20]:=#0;
        r1:=pchar(@buff[0]);
        TimeMark:=StrToDateTime(r1);
        buff[paraddr+12]:=#0;
        r1:=pchar(@buff[paraddr]);
        res:=0;
        series.Addxy(TimeMark,res,'',clteecolor);
     end;
   end;
 finally
   if ff<>nil then ff.Free;
 end;
end;
Function ReadDasData;
begin
  Result:=false;
  if not FileExists(DataFileName) then exit;
  if fileage(DataFileName)=DasTime then exit;
  try
    ffDas:=TFileStream.Create(DataFileName,fmOpenRead or fmShareDenyNone);
    ffdas.read(DasData,sizeof(DasData));
    ffDas.Free;
    result:=true;
  finally
  end;
end;
Function WriteDasData:Boolean;
begin
 try
  If FileExists(DataFileName) then ffDas:=TFileStream.Create(DataFileName,fmOpenWrite or fmShareDenyNone)
                              else ffDas:=TFileStream.create(DataFileName,fmCreate or fmShareDenyNone);
  ffdas.seek(0,soFrombeginning);
  ffdas.Write(DasData,sizeof(DasData));
  ffDas.Free;
 finally
 end;
end;
Function WriteBoostData:Boolean;
var
 ffdas : tfilestream;
begin
 try
  If FileExists(BoostDataFileName) then ffDas:=TFileStream.Create(BoostDataFileName,fmOpenWrite or fmShareDenyNone)
                              else ffDas:=TFileStream.create(BoostDataFileName,fmCreate or fmShareDenyNone);
  ffdas.seek(0,soFrombeginning);
  ffdas.Write(Boosts,sizeof(Boosts));
  ffDas.Free;
 finally
 end;
end;
Function WriteLNRData:Boolean;
var
 fflnr:tfilestream;
begin
 try
  If FileExists(LNRDataFileName) then ffLNR:=TFileStream.Create(LNRDataFileName,fmOpenWrite or fmShareDenyNone)
                                 else ffLNR:=TFileStream.create(LNRDataFileName,fmCreate or fmShareDenyNone);
  fflnr.seek(0,soFrombeginning);
  ffLNR.Write(LNRData,sizeof(LNRData));
  ffLNR.Free;
 finally
 end;
end;
Function SpinByname;
var
 i1,i2,i3 :Integer;
 SCon     :TComponent;
begin
  Result:=nil;
  for i1:=0 to Component.ComponentCount-1 do
    begin
      scon:=TComponent(Component.Components[i1]);
      if scon is tspinedit    then begin
         if ansilowercase(tspinedit(scon).name)<>ansilowercase(name) then continue;
         result:=tspinedit(scon);
         exit;
      end;
      if scon is tpanel       then SpinByName(scon,name);
      if scon is tPageControl then SpinByName(scon,name);
      if scon is tTabSheet    then SpinByName(scon,name);
    end;
end;

Procedure RestoreComponents;
var
 cl,i1,i2,i3 :Integer;
 SCon     :TComponent;
 Clr      :tColor;
begin
  for i1:=0 to Component.ComponentCount-1 do
    begin
      scon:=TComponent(Component.Components[i1]);
      if scon is tTrackBar        then tTrackBar(scon).Position:=cf.ReadInteger('Components',scon.Name,0);
      if scon is tedit        then tedit(scon).text:=cf.ReadString('Components',scon.Name,'');
      if scon is TLabelededit        then TLabelededit(scon).text:=cf.ReadString('Components',scon.Name,'');
      if scon is tspinedit    then tspinedit(scon).value:=cf.ReadInteger('Components',scon.Name,0);
      if scon is tCheckBox
              then begin
                      tCheckBox(scon).checked:=cf.Readbool('Components',scon.Name,true);
                      clr:=cf.ReadInteger('Components_color',scon.Name,clWhite);
                      cl:=cf.ReadInteger('Components_color',scon.Name,clWhite);
                      tCheckBox(scon).Font.Color:=clr;
              end;
      if scon is tcombobox    then begin
                                   tComboBox(scon).itemindex:=tComboBox(scon).items.IndexOf(cf.Readstring('Components',scon.Name,''));
                                   if tComboBox(scon).itemindex<0 then begin
                                      tComboBox(scon).Text:='';
                                   end;
                              end;
      if scon is tpanel       then RestoreComponents(scon);
      if scon is tPageControl then RestoreComponents(scon);
      if scon is tTabSheet    then RestoreComponents(scon);
      if scon is tRadioGroup  then TRadioGroup(scon).ItemIndex:=cf.ReadInteger('Components',scon.Name,0);

    end;
end;
Procedure SaveComponents;
var
 i1,i2,i3 :Integer;
 SCon     :TComponent;
begin
  for i1:=0 to Component.ComponentCount-1 do
    begin
      scon:=TComponent(Component.Components[i1]);
      if scon.name='' then continue;
      if scon is tTrackBar        then
           cf.WriteInteger('Components',scon.Name,tTrackBar(scon).position);
      if scon is tedit        then
           cf.WriteString('Components',scon.Name,tedit(scon).text);
      if scon is TLabelededit        then
           cf.WriteString('Components',scon.Name,TLabelededit(scon).text);
      if scon is tcombobox        then
           cf.WriteString('Components',scon.Name,tcombobox(scon).text);
      if scon is tedit        then
           cf.WriteString('Components',scon.Name,tedit(scon).text);
      if scon is tCheckBox        then
           cf.Writebool  ('Components',scon.Name,tCheckBox(scon).checked);
      if scon is tspinedit    then
           cf.WriteInteger('Components',scon.Name,tspinedit(scon).value);
      if scon is tRadioGroup  then
           cf.WriteInteger('Components',scon.Name,tradioGroup(scon).ItemIndex);
      if scon is tpanel       then
           SaveComponents(scon);
      if scon is tPageControl then
           SaveComponents(scon);
      if scon is tTabSheet    then
           SaveComponents(scon);
    end;
end;
Function GPIBError(iberr :integer) :string;
begin
      case iberr of
        0 : result := 'EDVR System error';
        1 : result := 'ECIC Function requires GPIB board to be CIC';
        2 : result := 'ENOL Write function detected no Listeners';
        3 : result := 'EADR Interface board not addressed correctly';
        4 : result := 'EARG Invalid argument to function call';
        5 : result := 'ESAC Function requires GPIB board to be SAC';
        6 : result := 'EABO I/O operation aborted';
        7 : result := 'ENEB Non-existent interface board';
        10: result := 'EOIP I/O operation started before previous operation completed';
        11: result := 'ECAP No capability for intended operation';
        12: result := 'EFSO File system operation error';
        14: result := 'EBUS Command error during device call';
        15: result := 'ESTB Serial poll status byte lost';
        16: result := 'ESRQ SRQ remains asserted';
        20: result := 'ETAB The return buffer is full.';
        23: result := 'EHDL The input handle is invalid';
      end;
end;
function timeGetMinPeriod(): DWORD;
var  time: TTimeCaps;
begin
  timeGetDevCaps(Addr(time), SizeOf(time));
  timeGetMinPeriod := time.wPeriodMin;
end;
function timeGetMaxPeriod(): Cardinal;
var time: TTimeCaps;
begin
  timeGetDevCaps(Addr(time), SizeOf(time));
  timeGetMaxPeriod := time.wPeriodMax;
end;

function decodepassword(psw : string) : string;
var i, k : integer;
    s : string;
begin
  s:='';
  for i:=1 to length(psw) do begin
    if i > 21 then k:=i mod 21 else k:=i;
    s:=s + chr(ord(psw[i])+k);
  end;
  result:=s;
end;

function encodepassword(psw : string) : string;
var i, k : integer;
    s : string;
begin
  s:='';
  for i:=1 to length(psw) do begin
    if i > 21 then k:=i mod 21 else k:=i;
    s:=s + chr(ord(psw[i])-k);
  end;
  result:=s;
end;
procedure WriteprofileToDB(dbname:string;q1:tadoquery;msTime:int64;ChamberSumm,Summx,SummY,SummC,CurBuncher,napBuncher:double;channels:array of double;startXScan,CountXScan,StartyScan,CountYScan:integer;ara1,ara2:double);
var
  sql:string;
  i1,i2 :integer;
begin
  sql:='insert '+dbname+' (msTime,ChamberSumm,summX,SummY,SummCTRL,ctrl,nap,ara1,ara2,';
  for i1:=1 to CountxScan do  sql:=sql+'x'+IntToStr(i1)+',';
  for i1:=1 to CountYScan do  begin
     sql:=sql+'y'+InTToStr(i1)+','
  end;
  sql[length(sql)]:=')';

  sql:=sql+ ' values(';
  sql:=sql+format('%d',[mstime])+', ';
  sql:=sql+format('%.4f',[ChamberSumm])+', ';
  sql:=sql+format('%.4f',[summx])+', ';
  sql:=sql+format('%.4f',[summY])+', ';
  sql:=sql+format('%.4f',[summC])+', ';
  sql:=sql+format('%.4f',[curbuncher])+', ';
  sql:=sql+format('%.4f',[napbuncher])+', ';
  sql:=sql+format('%.4f',[ara1])+', ';
  sql:=sql+format('%.4f',[ara2])+', ';
  for i1:=1 to CountxScan do  sql:=sql+format('%.4f',[channels[startxscan+i1]])+', ';
  for i1:=1 to CountYScan do  sql:=sql+format('%.4f',[channels[startYscan+i1]])+', ';
  sql[length(sql)-1]:=')';

  if q1.active then q1.close;
  q1.SQL.Clear;
  q1.SQL.Add(sql);
  q1.ExecSQL;


end;
procedure WriteOldAMPToDB;
var
  sql:string;
  i1,i2 :integer;
begin
  sql:='insert '+dbname+' (fk12,';
  for i1:=1 to chCount  do  sql:=sql+'CH'+IntToStr(i1)+',';
  for i1:=1 to lamelCount do  begin
     sql:=sql+'L'+InTToStr(i1)+','
  end;
  sql[length(sql)]:=')';

  sql:=sql+ ' values(';
  sql:=sql+format('%.4f',[fk12])+', ';
  for i1:=0 to chCount-1 do  sql:=sql+format('%e',[channels[i1]])+', ';
  for i1:=0 to LamelCount-1 do sql:=sql+format('%e',[channels[lamelStart-1+i1]])+', ';
  sql[length(sql)-1]:=')';

  if q1.active then q1.close;
  q1.SQL.Clear;
  q1.SQL.Add(sql);
  q1.ExecSQL;


end;

  var
    s1,s2 :string;
    r1               : dword;
Initialization
  r1:=80;
  getcomputername(@charbuf,r1);
  compname:=charbuf;
  s1:=extractfilepath(application.exename);
  s1:=s1+'\log\';
  CreateDirectory(pchar(s1),nil);
  DataFileName :=s1+FormatDateTime('dat_DD_MMMM_YYYY HH_NN_SS',now);
  ConfigFileName:=s1+'websrv.ini';
  LogFileName :=s1+FormatDateTime('DD_MMMM_YYYY HH_NN_SS',now);
  CF:=TIniFile.create(ConfigFileName);
  cf.WriteString('General','Start',FormatDateTime('DD DDDD MMMM YYYY HH:NN:SS',now));
  str1:=tStringList.create;
  writetimelog('Начало работы программы'+#10);

finalization
 writetimelog('Завершение работы программы'+#10);

end.
