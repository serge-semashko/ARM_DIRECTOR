unit UMyProtocols;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls,
  utimeline, Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend;

type

  TPort422 = class
    rt0: trect;
    rtcm: trect;
    ComPort: String;
    rt1: trect;
    rtsp: trect;
    Speed: string;
    LSpeed: string;
    rt2: trect;
    rtbt: trect;
    Bits: string;
    LBits: string;
    rt3: trect;
    rtpr: trect;
    Parity: string;
    LParity: string;
    rt4: trect;
    rtst: trect;
    Stop: string;
    LStop: string;
    rt5: trect;
    rtfl: trect;
    Flow: string;
    LFlow: string;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure draw(dib: tfastdib; Top, HgRw: integer);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    constructor create;
    destructor destroy;
  end;

  TPortIP = class
    rt1: trect;
    rtip: trect;
    IPAdress: String;
    rt2: trect;
    rtpr: trect;
    IPPort: String;
    rt3: trect;
    rtlg: trect;
    Login: String;
    rt4: trect;
    rtps: trect;
    Password: String;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure draw(dib: tfastdib; Top, HgRw: integer);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    constructor create;
    destructor destroy;
  end;

  TMyPort = class
    exist422: boolean;
    existip: boolean;
    select422: boolean;
    rt422: trect;
    rtip: trect;
    rt1: trect;
    rtdm: trect;
    devicemanager: string;
    port422: TPort422;
    portip: TPortIP;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure draw(cv: tcanvas; HghtRw: integer);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    constructor create;
    destructor destroy;
  end;

  TOneStringTable = class
    Name: string;
    rtnm: trect;
    Text: string;
    VarText: string;
    rttxt: trect;
    constructor create(SName, SText, SVText: string);
    destructor destroy;
  end;

  TProtocolMain = class
    Count: integer;
    List: array of TOneStringTable;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure draw(cv: tcanvas; HgRw: integer);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    procedure clear;
    constructor create;
    destructor destroy;
  end;

  TProtocolAdd = class
    title: string;
    rttl: trect;
    Count: integer;
    List: array of TOneStringTable;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure draw(cv: tcanvas; HgRw: integer);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    procedure clear;
    constructor create;
    destructor destroy;
  end;

  TOneProtocol = class
    rt4: trect;
    Protocol: string;
    rtp: trect;
    Ports: TMyPort;
    ProtocolMain: TProtocolMain;
    ProtocolAdd: TProtocolAdd;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    constructor create;
    destructor destroy;
  end;

  TFirmDevice = class
    index: integer;
    rt3: trect;
    Device: string;
    rtd: trect;
    Count: integer;
    ListProtocols: array of TOneProtocol;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    function Add(Name: string): integer;
    function IndexOf(Name: string): integer;
    procedure clear;
    constructor create;
    destructor destroy;
  end;

  TVendors = class
    index: integer;
    rt2: trect;
    Vendor: string;
    rtv: trect;
    Count: integer;
    FirmDevices: array of TFirmDevice;
    function Add(Name: string): integer;
    function IndexOf(Name: string): integer;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    // procedure Draw(cv : tcanvas; hghtrw : integer);
    // function ClickMouse(cv : tcanvas; X, Y : integer) : integer;
    procedure clear;
    constructor create;
    destructor destroy;
  end;

  TTypeDevice = class
    index: integer;
    rt1: trect;
    TypeDevice: string;
    rttd: trect;
    Count: integer;
    Vendors: Array of TVendors;
    function Add(SName: string): integer;
    function IndexOf(Name: string): integer;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(SrcStr: string);
    procedure draw(cv: tcanvas; HghtRw: integer);
    // function ClickMouse(cv : tcanvas; X, Y : integer) : integer;
    procedure clear;
    constructor create;
    destructor destroy;
  end;

  TListTypeDevices = class
    index: integer;
    Count: integer;
    TypeDevices: array of TTypeDevice;
    function Add(Name: string): integer;
    function IndexOf(Name: string): integer;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(SrcStr: string);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    // function MouseMouse(cv : tcanvas; X, Y : integer) : integer;
    procedure LoadFromFile(FileName, TypeProtocols: string);
    procedure SaveToFile(FileName, TypeProtocols: string);
    procedure clear;
    constructor create;
    destructor destroy;
  end;

implementation

uses umain, ucommon;

function SetSpace(Count: integer): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to Count - 1 do
    result := result + ' ';
end;

procedure initrect(rt: trect);
begin
  rt.Left := 0;
  rt.Right := 0;
  rt.Top := 0;
  rt.Bottom := 0;
end;

constructor TListTypeDevices.create;
begin
  Index := -1;
  Count := 0;
end;

procedure TListTypeDevices.clear;
var
  i: integer;
begin
  Index := -1;
  for i := Count - 1 downto 0 do
  begin
    TypeDevices[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(TypeDevices, Count);
  end;
  Count := 0;
end;

destructor TListTypeDevices.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@Count);
  freemem(@TypeDevices);
end;

function TListTypeDevices.Add(Name: string): integer;
begin
  Count := Count + 1;
  setlength(TypeDevices, Count);
  TypeDevices[Count - 1] := TTypeDevice.create;
  TypeDevices[Count - 1].TypeDevice := Name;
  initrect(TypeDevices[Count - 1].rt1);
  initrect(TypeDevices[Count - 1].rttd);
  result := Count - 1;
end;

function TListTypeDevices.IndexOf(Name: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if ansilowercase(trim(TypeDevices[i].TypeDevice)) = ansilowercase(trim(Name))
    then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TListTypeDevices.GetString: string;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    result := SetSpace(2) + '<TypeDevices=' + trim(TypeDevices[i].TypeDevice) +
      '>' + #13#10;
    result := result + TypeDevices[i].GetString;
    result := result + SetSpace(2) + '</TypeDevices=' +
      trim(TypeDevices[i].TypeDevice) + '>' + #13#10;
  end;
end;

procedure TListTypeDevices.GetListString(lst: tstrings);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    lst.Add(SetSpace(2) + '<TypeDevices=' +
      trim(TypeDevices[i].TypeDevice) + '>');
    TypeDevices[i].GetListString(lst);
    lst.Add(SetSpace(2) + '</TypeDevices=' +
      trim(TypeDevices[i].TypeDevice) + '>');
  end;
end;

procedure TListTypeDevices.SetString(SrcStr: string);
var
  i, rw: integer;
  sprotocols: string;
  lst: tstrings;
begin
  lst := tstringlist.create;
  try
    lst.clear;
    GetProtocolsList(SrcStr, 'TypeDevices=', lst);
    clear;
    for i := 0 to lst.Count - 1 do
    begin
      rw := Add(trim(lst.Strings[i]));
      sprotocols := GetProtocolsStr(SrcStr,
        'TypeDevices=' + trim(lst.Strings[i]));
      TypeDevices[rw].SetString(sprotocols);
    end;
  finally
    lst.Free;
  end;
end;

function TListTypeDevices.ClickMouse(cv: tcanvas; X, Y: integer): integer;
begin
  result := -1;
  if index = -1 then
    index := 0;

  with TypeDevices[index] do
  begin
    if (X > rttd.Left) and (X < rttd.Right) and (Y > rttd.Top) and
      (Y < rttd.Bottom) then
    begin
      result := 0;
      exit;
    end;
    if index = -1 then
      index := 0;
    with Vendors[index] do
    begin
      if (X > rtv.Left) and (X < rtv.Right) and (Y > rtv.Top) and
        (Y < rtv.Bottom) then
      begin
        result := 1;
        exit;
      end;
      if index = -1 then
        index := 0;
      with FirmDevices[index] do
      begin
        if (X > rtd.Left) and (X < rtd.Right) and (Y > rtd.Top) and
          (Y < rtd.Bottom) then
        begin
          result := 2;
          exit;
        end;
        if index = -1 then
          index := 0;
        with ListProtocols[index] do
        begin
          if (X > rtp.Left) and (X < rtp.Right) and (Y > rtp.Top) and
            (Y < rtp.Bottom) then
          begin
            result := 3;
            exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TListTypeDevices.LoadFromFile(FileName, TypeProtocols: string);
var
  i, cnt: integer;
  FName: string;
  ss: string;
  buff: tstrings;
begin
  try
    ss := '';
    buff := tstringlist.create;
    buff.clear;
    try
      FName := extractfilepath(application.ExeName) + FileName;
      if not FileExists(FileName) then
        exit;
      buff.LoadFromFile(FileName);
      for i := 0 to buff.Count - 1 do
        ss := ss + trim(buff.Strings[i]);
      ss := GetProtocolsStr(ss, TypeProtocols);
      SetString(ss)
    finally
      buff.Free;
    end;
  except
    buff.Free;
  end;
end;

procedure TListTypeDevices.SaveToFile(FileName, TypeProtocols: string);
var
  buff: tstrings;
  FName, renm: string;
  ss, ssd, stxt, smedia, sdev: string;
  i: integer;
begin
  try
    FName := extractfilepath(application.ExeName) + FileName;
    buff := tstringlist.create;
    buff.clear;
    stxt := '';
    smedia := '';
    sdev := '';
    try
      if FileExists(FName) then
      begin
        buff.LoadFromFile(FName);
        for i := 0 to buff.Count - 1 do
          ss := ss + trim(buff.Strings[i]);
        sdev := GetProtocolsStr(ss, 'TLDevices');
        stxt := GetProtocolsStr(ss, 'TLText');
        smedia := GetProtocolsStr(ss, 'TLMedia');
        renm := extractfilepath(FName) + 'Temp.tmp';
        RenameFile(FName, renm);
        DeleteFile(renm);
      end;
      buff.clear;
      buff.Add('<' + TypeProtocols + '>');
      GetListString(buff);
      buff.Add('</' + TypeProtocols + '>');
      if ansilowercase(TypeProtocols) = 'tldevices' then
        buff.Text := buff.Text + stxt + smedia
      else if ansilowercase(TypeProtocols) = 'tltext' then
        buff.Text := sdev + buff.Text + smedia
      else if ansilowercase(TypeProtocols) = 'tlmedia' then
        buff.Text := sdev + stxt + buff.Text;
      buff.SaveToFile(FName);
    finally
      buff.Free;
    end;
  except
    buff.Free;
  end;
end;

constructor TFirmDevice.create;
begin
  initrect(rt3);
  initrect(rtd);
  index := -1;
  Device := '';
  Count := 0;
end;

procedure TFirmDevice.clear;
var
  i: integer;
begin
  // Device := '';
  index := -1;
  for i := Count - 1 downto 0 do
  begin
    ListProtocols[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(ListProtocols, Count);
  end;
  Count := 0;
end;

destructor TFirmDevice.destroy;
begin
  freemem(@Index);
  freemem(@rt3);
  freemem(@Device);
  freemem(@rtd);
  clear;
  freemem(@Count);
  freemem(@ListProtocols);
end;

function TFirmDevice.Add(Name: string): integer;
begin
  // Device := Name;
  Count := Count + 1;
  setlength(ListProtocols, Count);
  ListProtocols[Count - 1] := TOneProtocol.create;
  ListProtocols[Count - 1].Protocol := Name;
  result := Count - 1;
end;

function TFirmDevice.IndexOf(Name: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if ansilowercase(trim(ListProtocols[i].Protocol)) = ansilowercase(trim(Name))
    then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TFirmDevice.GetString: string;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    result := SetSpace(8) + '<Protocol=' + ListProtocols[i].Protocol +
      '>' + #13#10;
    result := result + ListProtocols[i].GetString;
    result := SetSpace(8) + '</Protocol=' + ListProtocols[i].Protocol + '>';
  end;
end;

procedure TFirmDevice.GetListString(lst: tstrings);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    lst.Add(SetSpace(8) + '<Protocol=' + ListProtocols[i].Protocol + '>');
    ListProtocols[i].GetListString(lst);
    lst.Add(SetSpace(8) + '</Protocol=' + ListProtocols[i].Protocol + '>');
  end;
end;

procedure TFirmDevice.SetString(stri: string);
var
  i, rw: integer;
  sprotocols: string;
  lst: tstrings;
begin
  lst := tstringlist.create;
  try
    lst.clear;
    GetProtocolsList(stri, 'Protocol=', lst);
    clear;
    if lst.Count > 0 then
    begin
      for i := 0 to lst.Count - 1 do
      begin
        rw := Add(trim(lst.Strings[i]));
        sprotocols := GetProtocolsStr(stri, 'Protocol=' + trim(lst.Strings[i]));
        ListProtocols[rw].SetString(sprotocols);
      end;
    end;
  finally
    lst.Free;
  end;
end;

constructor TTypeDevice.create;
begin
  index := -1;
  TypeDevice := '';
  initrect(rt1);
  initrect(rttd);
  Count := 0;
end;

procedure TTypeDevice.clear;
var
  i: integer;
begin
  // TypeDevice := '';
  index := -1;
  for i := Count - 1 downto 0 do
  begin
    Vendors[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(Vendors, Count);
  end;
  Count := 0;
end;

destructor TTypeDevice.destroy;
begin
  freemem(@Index);
  freemem(@TypeDevice);
  freemem(@rt1);
  freemem(@rttd);
  clear;
  freemem(@Count);
  freemem(@Vendors);
end;

procedure TTypeDevice.draw(cv: tcanvas; HghtRw: integer);
var
  tmp: tfastdib;
  i, wdth, hght, ps: integer;
  clr: tcolor;
  intclr: longint;
  rt: trect;
  s, ss: string;
begin
  tmp := tfastdib.create;
  try
    wdth := cv.ClipRect.Right - cv.ClipRect.Left;
    hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
    ps := (wdth - 10) div 2;
    tmp.SetSize(wdth, hght, 32);
    tmp.clear(TColorToTfcolor(FormsColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetPen(ps_Solid, 1, colortorgb(FormsFontColor));
    tmp.SetTextColor(colortorgb(FormsFontColor));
    tmp.SetFont(FormsFontName, MTFontSize);
    rt1.Left := 5;
    rt1.Top := 5;
    rt1.Right := rt1.Left + ps;
    rt1.Bottom := rt1.Top + HghtRw;
    rttd.Left := rt1.Right + 5;
    rttd.Top := rt1.Top;
    rttd.Right := wdth - 5;
    rttd.Bottom := rt1.Bottom;
    tmp.DrawText('Тип оборудования:', rt1, DT_VCENTER or DT_SINGLELINE);
    tmp.DrawText(TypeDevice, rttd, DT_VCENTER or DT_SINGLELINE);

    if index = -1 then
      index := 0;

    Vendors[index].rt2.Left := rt1.Left;
    Vendors[index].rt2.Top := rt1.Bottom;
    Vendors[index].rt2.Right := rt1.Left + ps;
    Vendors[index].rt2.Bottom := Vendors[index].rt2.Top + HghtRw;
    Vendors[index].rtv.Left := rt1.Right + 5;
    Vendors[index].rtv.Top := Vendors[index].rt2.Top;
    Vendors[index].rtv.Right := wdth - 5;
    Vendors[index].rtv.Bottom := Vendors[index].rt2.Bottom;
    tmp.DrawText('Производитель:', Vendors[index].rt2, DT_VCENTER or
      DT_SINGLELINE);
    tmp.DrawText(Vendors[index].Vendor, Vendors[index].rtv,
      DT_VCENTER or DT_SINGLELINE);

    if Vendors[index].index = -1 then
      Vendors[index].index := -0;

    with Vendors[index] do
    begin
      FirmDevices[index].rt3.Left := rt1.Left;
      FirmDevices[index].rt3.Top := rt2.Bottom;
      FirmDevices[index].rt3.Right := rt1.Left + ps;
      FirmDevices[index].rt3.Bottom := FirmDevices[index].rt3.Top + HghtRw;
      FirmDevices[index].rtd.Left := rt1.Right + 5;
      FirmDevices[index].rtd.Top := FirmDevices[index].rt3.Top;
      FirmDevices[index].rtd.Right := wdth - 5;
      FirmDevices[index].rtd.Bottom := FirmDevices[index].rt3.Bottom;
      tmp.DrawText('Устройство:', FirmDevices[index].rt3,
        DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(FirmDevices[index].Device, FirmDevices[index].rtd,
        DT_VCENTER or DT_SINGLELINE);

      if FirmDevices[index].index = -1 then
        FirmDevices[index].index := -0;

      with FirmDevices[index] do
      begin
        ListProtocols[index].rt4.Left := rt1.Left;
        ListProtocols[index].rt4.Top := rt3.Bottom;
        ListProtocols[index].rt4.Right := rt1.Left + ps;
        ListProtocols[index].rt4.Bottom := ListProtocols[index].rt4.Top
          + HghtRw;
        ListProtocols[index].rtp.Left := rt1.Right + 5;
        ListProtocols[index].rtp.Top := ListProtocols[index].rt4.Top;
        ListProtocols[index].rtp.Right := wdth - 5;
        ListProtocols[index].rtp.Bottom := ListProtocols[index].rt4.Bottom;
        tmp.DrawText('Протокол:', ListProtocols[index].rt4,
          DT_VCENTER or DT_SINGLELINE);
        tmp.DrawText(ListProtocols[index].Protocol, ListProtocols[index].rtp,
          DT_VCENTER or DT_SINGLELINE);
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

function TTypeDevice.Add(SName: string): integer;
begin
  // TypeDevice := SName;
  Count := Count + 1;
  setlength(Vendors, Count);
  Vendors[Count - 1] := TVendors.create;
  Vendors[Count - 1].Vendor := SName;
  result := Count - 1;
end;

function TTypeDevice.IndexOf(Name: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if ansilowercase(trim(Vendors[i].Vendor)) = ansilowercase(trim(Name)) then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TTypeDevice.GetString: string;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    result := SetSpace(4) + '<Firms=' + trim(Vendors[i].Vendor) + '>' + #13#10;
    result := result + Vendors[i].GetString;
    result := result + SetSpace(4) + '</Firms=' + trim(Vendors[i].Vendor) +
      '>' + #13#10;
  end;
end;

procedure TTypeDevice.GetListString(lst: tstrings);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    lst.Add(SetSpace(4) + '<Firms=' + trim(Vendors[i].Vendor) + '>');
    Vendors[i].GetListString(lst);
    lst.Add(SetSpace(4) + '</Firms=' + trim(Vendors[i].Vendor) + '>');
  end;
end;

procedure TTypeDevice.SetString(SrcStr: string);
var
  i, rw: integer;
  sprotocols: string;
  lst: tstrings;
begin
  lst := tstringlist.create;
  try
    lst.clear;
    GetProtocolsList(SrcStr, 'Firms=', lst);
    clear;
    if lst.Count > 0 then
    begin
      for i := 0 to lst.Count - 1 do
      begin
        rw := Add(trim(lst.Strings[i]));
        sprotocols := GetProtocolsStr(SrcStr, 'Firms=' + trim(lst.Strings[i]));
        Vendors[rw].SetString(sprotocols);
      end;
    end;
  finally
    lst.Free;
  end;
end;

constructor TMyPort.create;
begin
  exist422 := true;
  existip := true;
  select422 := true;
  initrect(rt422);
  initrect(rtip);
  initrect(rt1);
  initrect(rtdm);
  devicemanager := '';
  port422 := TPort422.create;
  portip := TPortIP.create;
end;

destructor TMyPort.destroy;
begin
  freemem(@exist422);
  freemem(@existip);
  freemem(@select422);
  freemem(@rt422);
  freemem(@rtip);
  freemem(@rt1);
  freemem(@rtdm);
  freemem(@devicemanager);
  freemem(@port422);
  freemem(@portip);
end;

function TMyPort.GetString: string;
begin
  result := '<Ports>';
  if exist422 then
    result := result + port422.GetString;
  if existip then
    result := result + portip.GetString;
  result := result + '</Ports>'
end;

procedure TMyPort.GetListString(lst: tstrings);
begin
  lst.Add(SetSpace(10) + '<Ports>');
  if exist422 then
    port422.GetListString(lst);
  if existip then
    portip.GetListString(lst);
  lst.Add(SetSpace(10) + '</Ports>');
end;

procedure TMyPort.SetString(stri: string);
var
  sports: string;
begin
  sports := GetProtocolsStr(stri, 'Port422');
  // sports := StringReplace(sports,'<Port422>','',[rfReplaceAll, rfIgnoreCase]);
  // sports := StringReplace(sports,'</Port422>','',[rfReplaceAll, rfIgnoreCase]);

  if trim(sports) <> '' then
  begin
    port422.SetString(sports);
    exist422 := true;
  end
  else
  begin
    exist422 := false;
  end;

  sports := GetProtocolsStr(stri, 'PortIP');
  // sports := StringReplace(sports,'<PortIP>','',[rfReplaceAll, rfIgnoreCase]);
  // sports := StringReplace(sports,'</PortIP>','',[rfReplaceAll, rfIgnoreCase]);

  if trim(sports) <> '' then
  begin
    portip.SetString(sports);
    existip := true;
  end
  else
  begin
    existip := false;
  end;

  if (not exist422) and existip then
    select422 := false
  else if (not existip) and exist422 then
    select422 := true;
end;

procedure TMyPort.draw(cv: tcanvas; HghtRw: integer);
var
  tmp: tfastdib;
  i, wdth, hght, ps, Top: integer;
  clr: tcolor;
  intclr: longint;
  rt: trect;
begin
  tmp := tfastdib.create;
  try
    wdth := cv.ClipRect.Right - cv.ClipRect.Left;
    hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
    ps := (wdth - 10) div 2;
    tmp.SetSize(wdth, hght, 32);
    tmp.clear(TColorToTfcolor(FormsColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetPen(ps_Solid, 1, colortorgb(FormsFontColor));
    tmp.SetTextColor(colortorgb(FormsFontColor));
    tmp.SetFont(FormsFontName, MTFontSize);

    Top := 5;
    ps := (wdth - 10) div 2;

    if exist422 and existip then
    begin
      rt422.Left := 5;
      rt422.Right := ps - 5;
      rt422.Top := Top;
      rt422.Bottom := rt422.Top + HghtRw;
      rtip.Left := ps + 5;
      rtip.Right := wdth - 5;
      rtip.Top := Top;
      rtip.Bottom := rt422.Top + HghtRw;
      tmp.Rectangle(rt422.Left, rt422.Top + 4, rt422.Left + HghtRw - 8,
        rt422.Bottom - 4);
      tmp.Rectangle(rtip.Left, rtip.Top + 4, rtip.Left + HghtRw - 8,
        rtip.Bottom - 4);
      if select422 then
      begin
        tmp.DrawText('X', Rect(rt422.Left, rt422.Top + 4,
          rt422.Left + HghtRw - 8, rt422.Bottom - 4),
          DT_CENTER or DT_SINGLELINE);
        tmp.DrawText('  ', Rect(rtip.Left, rtip.Top + 4, rtip.Left + HghtRw - 8,
          rtip.Bottom - 4), DT_CENTER or DT_SINGLELINE);
      end
      else
      begin
        tmp.DrawText('  ', Rect(rt422.Left, rt422.Top + 4,
          rt422.Left + HghtRw - 8, rt422.Bottom - 4),
          DT_CENTER or DT_SINGLELINE);
        tmp.DrawText('X', Rect(rtip.Left, rtip.Top + 4, rtip.Left + HghtRw - 8,
          rtip.Bottom - 4), DT_CENTER or DT_SINGLELINE);
      end;
      // tmp.Rectangle(rt422.Left, rt422.Top+4, rt422.Left+HghtRw-8,rt422.Bottom-4);
      tmp.DrawText('COM Порт', Rect(rt422.Left + HghtRw - 5, rt422.Top,
        rt422.Right, rt422.Bottom), DT_VCENTER or DT_SINGLELINE);

      // tmp.Rectangle(rtip.Left, rtip.Top+4, rtip.Left+HghtRw-8,rtip.Bottom-4);
      tmp.DrawText('IP Адрес', Rect(rtip.Left + HghtRw - 5, rtip.Top,
        rtip.Right, rtip.Bottom), DT_VCENTER or DT_SINGLELINE);

      rt1.Left := 5;
      rt1.Right := ps - 10;
      rt1.Top := Top + HghtRw + 5;
      rt1.Bottom := rt1.Top + HghtRw;
      rtdm.Left := ps - 5;
      rtdm.Right := wdth - 5;
      rtdm.Top := rt1.Top;
      rtdm.Bottom := rt1.Bottom;
      tmp.DrawText('Модуль упр.:', rt1, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);
      if select422 then
        port422.draw(tmp, rt1.Bottom, HghtRw)
      else
        portip.draw(tmp, rt1.Bottom, HghtRw);
    end
    else if (not exist422) and existip then
    begin
      Top := Top + HghtRw;
      rt1.Left := 5;
      rt1.Right := ps - 10;
      rt1.Top := Top + 5;
      rt1.Bottom := rt1.Top + HghtRw;
      rtdm.Left := ps - 5;
      rtdm.Right := wdth - 5;
      rtdm.Top := rt1.Top;
      rtdm.Bottom := rt1.Bottom;
      tmp.DrawText('Модуль упр.:', rt1, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);
      portip.draw(tmp, rt1.Bottom, HghtRw);
    end
    else if (not existip) and exist422 then
    begin
      Top := Top + HghtRw;
      rt1.Left := 5;
      rt1.Right := ps - 10;
      rt1.Top := Top; // +hghtrw + 5;
      rt1.Bottom := rt1.Top + HghtRw;
      rtdm.Left := ps - 5;
      rtdm.Right := wdth - 5;
      rtdm.Top := rt1.Top;
      rtdm.Bottom := rt1.Bottom;
      tmp.DrawText('Модуль упр.:', rt1, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);
      port422.draw(tmp, rt1.Bottom, HghtRw);
    end
    else if (not exist422) and (not existip) then
    begin
      tmp.SetTextColor(colortorgb(smoothcolor(FormsFontColor, 32)));
      Top := Top + HghtRw;
      rt1.Left := 5;
      rt1.Right := ps - 10;
      rt1.Top := Top; // +hghtrw + 5;
      rt1.Bottom := rt1.Top + HghtRw;
      rtdm.Left := ps - 5;
      rtdm.Right := wdth - 5;
      rtdm.Top := rt1.Top;
      rtdm.Bottom := rt1.Bottom;
      tmp.DrawText('Модуль упр.:', rt1, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);
      if select422 then
        port422.draw(tmp, rt1.Bottom, HghtRw)
      else
        portip.draw(tmp, rt1.Bottom, HghtRw);
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

function TMyPort.ClickMouse(cv: tcanvas; X, Y: integer): integer;
begin
  result := -1;
  if exist422 and existip then
  begin
    if (X > rt422.Left) and (X < rt422.Right) and (Y > rt422.Top) and
      (Y < rt422.Bottom) then
    begin
      result := 0;
      exit
    end;
    if (X > rtip.Left) and (X < rtip.Right) and (Y > rtip.Top) and
      (Y < rtip.Bottom) then
    begin
      result := 1;
      exit
    end;
  end;
  if (X > rtdm.Left) and (X < rtdm.Right) and (Y > rtdm.Top) and
    (Y < rtdm.Bottom) then
  begin
    result := 2;
    exit
  end;
  if select422 then
    result := port422.ClickMouse(cv, X, Y)
  else
    result := portip.ClickMouse(cv, X, Y);
end;

constructor TPortIP.create;
begin
  initrect(rt1);
  initrect(rtip);
  IPAdress := '';
  initrect(rt2);
  initrect(rtpr);
  IPPort := '';
  initrect(rt3);
  initrect(rtlg);
  Login := '';
  initrect(rt4);
  initrect(rtps);
  Password := '';
end;

destructor TPortIP.destroy;
begin
  freemem(@rt1);
  freemem(@rtip);
  freemem(@IPAdress);
  freemem(@rt2);
  freemem(@rtpr);
  freemem(@IPPort);
  freemem(@rt3);
  freemem(@rtlg);
  freemem(@Login);
  freemem(@rt4);
  freemem(@rtps);
  freemem(@Password);
end;

function TPortIP.GetString: string;
begin
  result := '<PortIP>';
  result := result + '<IPAdress=' + IPAdress + '>';
  result := result + '<IPPort=' + IPPort + '>';
  result := result + '<Login=' + Login + '>';
  result := result + '<Password=' + Password + '>';
  result := result + '</PortIP>';
end;

procedure TPortIP.GetListString(lst: tstrings);
begin
  lst.Add(SetSpace(12) + '<PortIP>');
  lst.Add(SetSpace(14) + '<IPAdress=' + IPAdress + '>');
  lst.Add(SetSpace(14) + '<IPPort=' + IPPort + '>');
  lst.Add(SetSpace(14) + '<Login=' + Login + '>');
  lst.Add(SetSpace(14) + '<Password=' + Password + '>');
  lst.Add(SetSpace(12) + '</PortIP>');
end;

procedure TPortIP.SetString(stri: string);
var
  sport: string;
begin
  sport := GetProtocolsStr(stri, 'PortIP');
  IPAdress := GetProtocolsParam(sport, 'IPAdress');
  IPPort := GetProtocolsParam(sport, 'IPPort');
  Login := GetProtocolsParam(sport, 'Login');
  Password := GetProtocolsParam(sport, 'Password');
end;

procedure TPortIP.draw(dib: tfastdib; Top, HgRw: integer);
var
  ps: integer;
begin
  ps := (dib.Width - 10) div 2;
  rt1.Left := 5;
  rt1.Right := ps - 10;
  rt1.Top := Top;
  rt1.Bottom := rt1.Top + HgRw;
  rtip.Left := ps - 5;
  rtip.Right := dib.Width - 5;
  rtip.Top := rt1.Top;
  rtip.Bottom := rt1.Bottom;
  dib.DrawText('IP Адрес:', rt1, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(IPAdress, rtip, DT_VCENTER or DT_SINGLELINE);
  rt2.Left := 5;
  rt2.Right := ps - 10;
  rt2.Top := rt1.Bottom;
  rt2.Bottom := rt2.Top + HgRw;
  rtpr.Left := ps - 5;
  rtpr.Right := dib.Width - 5;
  rtpr.Top := rt2.Top;
  rtpr.Bottom := rt2.Bottom;
  dib.DrawText('Порт:', rt2, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(IPPort, rtpr, DT_VCENTER or DT_SINGLELINE);
  rt3.Left := 5;
  rt3.Right := ps - 10;
  rt3.Top := rt2.Bottom;
  rt3.Bottom := rt3.Top + HgRw;
  rtlg.Left := ps - 5;
  rtlg.Right := dib.Width - 5;
  rtlg.Top := rt3.Top;
  rtlg.Bottom := rt3.Bottom;
  dib.DrawText('Логин:', rt3, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Login, rtlg, DT_VCENTER or DT_SINGLELINE);
  rt4.Left := 5;
  rt4.Right := ps - 10;
  rt4.Top := rt3.Bottom;
  rt4.Bottom := rt4.Top + HgRw;
  rtps.Left := ps - 5;
  rtps.Right := dib.Width - 5;
  rtps.Top := rt4.Top;
  rtps.Bottom := rt4.Bottom;
  dib.DrawText('Пароль:', rt4, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Password, rtps, DT_VCENTER or DT_SINGLELINE);
end;

function TPortIP.ClickMouse(cv: tcanvas; X, Y: integer): integer;
begin
  result := -1;
  if (X > rtip.Left) and (X < rtip.Right) and (Y > rtip.Top) and
    (Y < rtip.Bottom) then
  begin
    result := 20;
    exit
  end;
  if (X > rtpr.Left) and (X < rtpr.Right) and (Y > rtpr.Top) and
    (Y < rtpr.Bottom) then
  begin
    result := 21;
    exit
  end;
  if (X > rtlg.Left) and (X < rtlg.Right) and (Y > rtlg.Top) and
    (Y < rtlg.Bottom) then
  begin
    result := 22;
    exit
  end;
  if (X > rtps.Left) and (X < rtps.Right) and (Y > rtps.Top) and
    (Y < rtps.Bottom) then
  begin
    result := 23;
    exit
  end;
end;

constructor TPort422.create;
begin
  initrect(rt1);
  initrect(rtsp);
  Speed := '';
  LSpeed := '1200|1800|2400|4800|7200|9600|14400|19200|38400|57600|115200';
  initrect(rt2);
  initrect(rtbt);
  Bits := '';
  LBits := '4|5|6|7|8';
  initrect(rt3);
  initrect(rtpr);
  Parity := '';
  LParity := 'чет|нечет|нет|маркер|пробел';
  initrect(rt4);
  initrect(rtst);
  Stop := '';
  LStop := '1|1,5|2';
  initrect(rt5);
  initrect(rtfl);
  Flow := '';
  LFlow := 'XOn/XOff|Аппаратный|Нет';
end;

destructor TPort422.destroy;
begin
  freemem(@rt1);
  freemem(@rtsp);
  freemem(@Speed);
  freemem(@LSpeed);
  freemem(@rt2);
  freemem(@rtbt);
  freemem(@Bits);
  freemem(@LBits);
  freemem(@rt3);
  freemem(@rtpr);
  freemem(@Parity);
  freemem(@LParity);
  freemem(@rt4);
  freemem(@rtst);
  freemem(@Stop);
  freemem(@LStop);
  freemem(@rt5);
  freemem(@rtfl);
  freemem(@Flow);
  freemem(@LFlow);
end;

procedure TPort422.draw(dib: tfastdib; Top, HgRw: integer);
var
  ps: integer;
begin
  ps := (dib.Width - 10) div 2;
  rt0.Left := 5;
  rt0.Right := ps - 10;
  rt0.Top := Top;
  rt0.Bottom := rt0.Top + HgRw;
  rtcm.Left := ps - 5;
  rtcm.Right := dib.Width - 5;
  rtcm.Top := rt0.Top;
  rtcm.Bottom := rt0.Bottom;
  dib.DrawText('COM Порт:', rt0, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(ComPort, rtcm, DT_VCENTER or DT_SINGLELINE);

  rt1.Left := 5;
  rt1.Right := ps - 10;
  rt1.Top := rt0.Bottom;
  rt1.Bottom := rt1.Top + HgRw;
  rtsp.Left := ps - 5;
  rtsp.Right := dib.Width - 5;
  rtsp.Top := rt1.Top;
  rtsp.Bottom := rt1.Bottom;
  dib.DrawText('Скорость:', rt1, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Speed, rtsp, DT_VCENTER or DT_SINGLELINE);
  rt2.Left := 5;
  rt2.Right := ps - 10;
  rt2.Top := rt1.Bottom;
  rt2.Bottom := rt2.Top + HgRw;
  rtbt.Left := ps - 5;
  rtbt.Right := dib.Width - 5;
  rtbt.Top := rt2.Top;
  rtbt.Bottom := rt2.Bottom;
  dib.DrawText('Кол-во бит:', rt2, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Bits, rtbt, DT_VCENTER or DT_SINGLELINE);
  rt3.Left := 5;
  rt3.Right := ps - 10;
  rt3.Top := rt2.Bottom;
  rt3.Bottom := rt3.Top + HgRw;
  rtpr.Left := ps - 5;
  rtpr.Right := dib.Width - 5;
  rtpr.Top := rt3.Top;
  rtpr.Bottom := rt3.Bottom;
  dib.DrawText('Четность:', rt3, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Parity, rtpr, DT_VCENTER or DT_SINGLELINE);
  rt4.Left := 5;
  rt4.Right := ps - 10;
  rt4.Top := rt3.Bottom;
  rt4.Bottom := rt4.Top + HgRw;
  rtst.Left := ps - 5;
  rtst.Right := dib.Width - 5;
  rtst.Top := rt4.Top;
  rtst.Bottom := rt4.Bottom;
  dib.DrawText('Стоп бит:', rt4, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Stop, rtst, DT_VCENTER or DT_SINGLELINE);
  rt5.Left := 5;
  rt5.Right := ps - 10;
  rt5.Top := rt4.Bottom;
  rt5.Bottom := rt5.Top + HgRw;
  rtfl.Left := ps - 5;
  rtfl.Right := dib.Width - 5;
  rtfl.Top := rt5.Top;
  rtfl.Bottom := rt5.Bottom;
  dib.DrawText('Упр. потоком:', rt5, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Flow, rtfl, DT_VCENTER or DT_SINGLELINE);
end;

function TPort422.ClickMouse(cv: tcanvas; X, Y: integer): integer;
begin
  result := -1;
  if (X > rtsp.Left) and (X < rtsp.Right) and (Y > rtsp.Top) and
    (Y < rtsp.Bottom) then
  begin
    result := 10;
    exit
  end;
  if (X > rtbt.Left) and (X < rtbt.Right) and (Y > rtbt.Top) and
    (Y < rtbt.Bottom) then
  begin
    result := 11;
    exit
  end;
  if (X > rtpr.Left) and (X < rtpr.Right) and (Y > rtpr.Top) and
    (Y < rtpr.Bottom) then
  begin
    result := 12;
    exit
  end;
  if (X > rtst.Left) and (X < rtst.Right) and (Y > rtst.Top) and
    (Y < rtst.Bottom) then
  begin
    result := 13;
    exit
  end;
  if (X > rtfl.Left) and (X < rtfl.Right) and (Y > rtfl.Top) and
    (Y < rtfl.Bottom) then
  begin
    result := 14;
    exit
  end;
end;

function TPort422.GetString: string;
begin
  result := '<Port422>';
  result := result + '<Speed=' + Speed + '>';
  result := result + '<Bits=' + Bits + '>';
  result := result + '<Parity=' + Parity + '>';
  result := result + '<Stop=' + Stop + '>';
  result := result + '<Flow=' + Flow + '>';
  result := result + '</Port422>';
end;

procedure TPort422.GetListString(lst: tstrings);
begin
  lst.Add(SetSpace(12) + '<Port422>');
  lst.Add(SetSpace(14) + '<Speed=' + Speed + '>');
  lst.Add(SetSpace(14) + '<Bits=' + Bits + '>');
  lst.Add(SetSpace(14) + '<Parity=' + Parity + '>');
  lst.Add(SetSpace(14) + '<Stop=' + Stop + '>');
  lst.Add(SetSpace(14) + '<Flow=' + Flow + '>');
  lst.Add(SetSpace(12) + '</Port422>');
end;

procedure TPort422.SetString(stri: string);
var
  sport: string;
begin
  sport := GetProtocolsStr(stri, 'Port422');
  Speed := GetProtocolsParam(sport, 'Speed');
  Bits := GetProtocolsParam(sport, 'Bits');
  Parity := GetProtocolsParam(sport, 'Parity');
  Stop := GetProtocolsParam(sport, 'Stop');
  Flow := GetProtocolsParam(sport, 'Flow');
end;

constructor TOneProtocol.create;
begin
  initrect(rt4);
  Protocol := '';
  initrect(rtp);
  Ports := TMyPort.create;
  ProtocolMain := TProtocolMain.create;
  ProtocolAdd := TProtocolAdd.create;
end;

destructor TOneProtocol.destroy;
begin
  freemem(@rt4);
  freemem(@Protocol);
  freemem(@rtp);
  ProtocolMain.clear;
  ProtocolAdd.clear;
  freemem(@Ports);
  freemem(@ProtocolMain);
  freemem(@ProtocolAdd);
End;

function TOneProtocol.GetString: string;
begin
  result := Ports.GetString + ProtocolMain.GetString + ProtocolAdd.GetString;
end;

procedure TOneProtocol.GetListString(lst: tstrings);
begin
  Ports.GetListString(lst);
  ProtocolMain.GetListString(lst);
  ProtocolAdd.GetListString(lst);
end;

procedure TOneProtocol.SetString(stri: string);
begin
  Ports.SetString(stri);
  ProtocolMain.SetString(stri);
  ProtocolAdd.SetString(stri);
end;

constructor TVendors.create;
begin
  index := -1;
  initrect(rt2);
  Vendor := '';
  initrect(rtv);
  Count := 0;
end;

procedure TVendors.clear;
var
  i: integer;
begin
  // Vendor := '';
  index := -1;
  for i := Count - 1 downto 0 do
  begin
    FirmDevices[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(FirmDevices, Count);
  end;
  Count := 0;
end;

destructor TVendors.destroy;
begin
  freemem(@index);
  freemem(@rt2);
  freemem(@Vendor);
  freemem(@rtv);
  // Ports.FreeInstance;
  clear;
  freemem(@Count);
  freemem(@FirmDevices);
end;

function TVendors.Add(Name: string): integer;
begin
  // Vendor := Name;
  Count := Count + 1;
  setlength(FirmDevices, Count);
  FirmDevices[Count - 1] := TFirmDevice.create;
  FirmDevices[Count - 1].Device := Name;
  result := Count - 1;
end;

function TVendors.IndexOf(Name: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if ansilowercase(trim(FirmDevices[i].Device)) = ansilowercase(trim(Name))
    then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TVendors.GetString: string;
var
  i: integer;
begin
  if trim(FirmDevices[0].Device) = '' then
  begin
    result := FirmDevices[0].GetString;
  end
  else
  begin
    for i := 0 to Count - 1 do
    begin
      result := SetSpace(6) + '<Device=' + trim(FirmDevices[i].Device) +
        '>' + #13#10;
      result := result + FirmDevices[i].GetString;
      result := SetSpace(6) + '</Device=' + trim(FirmDevices[i].Device) +
        '>' + #13#10;
    end;
  end;
end;

procedure TVendors.GetListString(lst: tstrings);
var
  i: integer;
begin
  if trim(FirmDevices[0].Device) = '' then
  begin
    FirmDevices[0].GetListString(lst);
  end
  else
  begin
    for i := 0 to Count - 1 do
    begin
      lst.Add(SetSpace(6) + '<Device=' + trim(FirmDevices[i].Device) + '>');
      FirmDevices[i].GetListString(lst);
      lst.Add(SetSpace(6) + '</Device=' + trim(FirmDevices[i].Device) + '>');
    end;
  end;
end;

procedure TVendors.SetString(stri: string);
var
  i, rw: integer;
  sprotocols: string;
  lst: tstrings;
begin
  lst := tstringlist.create;
  try
    lst.clear;
    GetProtocolsList(stri, 'Device=', lst);
    clear;
    if lst.Count > 0 then
    begin
      for i := 0 to lst.Count - 1 do
      begin
        rw := Add(trim(lst.Strings[i]));
        sprotocols := GetProtocolsStr(stri, 'Device=' + trim(lst.Strings[i]));
        FirmDevices[rw].SetString(sprotocols);
      end;
    end
    else
    begin
      rw := Add('');
      // sprotocols := GetProtocolsStr(stri, 'Protocol='+trim(lst.Strings[i]));
      FirmDevices[rw].SetString(stri);
    end;
  finally
    lst.Free;
  end;
  // svens := GetProtocolsStr(stri, 'Vendors');
  // TypeDevice := GetProtocolsParam(svens, 'TypeDevice');
  // Vendor := GetProtocolsParam(svens, 'Vendor');
  // Device := GetProtocolsParam(svens, 'Device');
  // Protocol := GetProtocolsParam(svens, 'Protocol');
end;

constructor TOneStringTable.create(SName, SText, SVText: string);
begin
  Name := SName;
  rtnm.Left := 0;
  rtnm.Top := 0;
  rtnm.Right := 0;
  rtnm.Bottom := 0;
  Text := SText;
  rttxt.Left := 0;
  rttxt.Top := 0;
  rttxt.Right := 0;
  rttxt.Bottom := 0;
  VarText := SVText;
end;

destructor TOneStringTable.destroy;
begin
  freemem(@Name);
  freemem(@rtnm);
  freemem(@Text);
  freemem(@rttxt);
  freemem(@VarText);
end;

constructor TProtocolMain.create;
begin
  Count := 0;
end;

procedure TProtocolMain.clear;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
  begin
    List[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(List, Count);
  end;
  Count := 0;
end;

destructor TProtocolMain.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@List);
end;

function TProtocolMain.GetString: string;
var
  i: integer;
begin
  result := '<MainOptions>';
  result := result + '<Count=' + inttostr(Count) + '>';
  for i := 0 to Count - 1 do
  begin
    result := result + '<' + inttostr(i + 1) + ':' + trim(List[i].Name) + '=' +
      trim(List[i].Text) + '|' + trim(List[i].VarText) + '>';
  end;
  result := result + '</MainOptions>';
end;

procedure TProtocolMain.GetListString(lst: tstrings);
var
  i: integer;
begin
  lst.Add(SetSpace(10) + '<MainOptions>');
  lst.Add(SetSpace(12) + '<Count=' + inttostr(Count) + '>');
  for i := 0 to Count - 1 do
  begin
    lst.Add(SetSpace(12) + '<' + inttostr(i + 1) + ':' + trim(List[i].Name) +
      '=' + trim(List[i].Text) + '|' + trim(List[i].VarText) + '>');
  end;
  lst.Add(SetSpace(10) + '</MainOptions>');
end;

procedure TProtocolMain.SetString(stri: string);
var
  sparam, scount: string;
  i, cnt: integer;
  res: TListParam;
begin
  clear;
  Count := 0;
  sparam := GetProtocolsStr(stri, 'MainOptions');
  scount := GetProtocolsParam(sparam, 'Count');
  if trim(scount) <> '' then
  begin
    cnt := strtoint(scount);
    for i := 0 to cnt - 1 do
    begin
      res := GetProtocolsParamEx(sparam, i + 1);
      Count := Count + 1;
      setlength(List, Count);
      List[Count - 1] := TOneStringTable.create(res.Name, res.Text,
        res.VarText);
    end;
  end;
end;

procedure TProtocolMain.draw(cv: tcanvas; HgRw: integer);
var
  tmp: tfastdib;
  i, wdth, hght, ps, Top: integer;
  clr: tcolor;
  intclr: longint;
  rt: trect;
begin
  tmp := tfastdib.create;
  try
    wdth := cv.ClipRect.Right - cv.ClipRect.Left;
    hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
    ps := (wdth - 10) div 2;
    tmp.SetSize(wdth, hght, 32);
    tmp.clear(TColorToTfcolor(FormsColor));
    tmp.SetBrush(bs_solid, 0, colortorgb(FormsColor));
    tmp.FillRect(Rect(0, 0, tmp.Width, tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetPen(ps_Solid, 1, colortorgb(FormsFontColor));
    tmp.SetTextColor(colortorgb(FormsFontColor));
    tmp.SetFont(FormsFontName, MTFontSize);
    Top := 5;
    for i := 0 to Count - 1 do
    begin
      List[i].rtnm.Left := 5;
      List[i].rtnm.Top := Top;
      List[i].rtnm.Right := List[i].rtnm.Left + ps;
      List[i].rtnm.Bottom := List[i].rtnm.Top + HgRw;
      List[i].rttxt.Left := List[i].rtnm.Right + 5;
      List[i].rttxt.Top := List[i].rtnm.Top;
      List[i].rttxt.Right := wdth - 5;
      List[i].rttxt.Bottom := List[i].rtnm.Bottom;
      tmp.DrawText(List[i].Name, List[i].rtnm, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(List[i].Text, List[i].rttxt, DT_VCENTER or DT_SINGLELINE);
      Top := List[i].rtnm.Bottom;
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

function TProtocolMain.ClickMouse(cv: tcanvas; X, Y: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if (X > List[i].rttxt.Left) and (X < List[i].rttxt.Right) and
      (Y > List[i].rttxt.Top) and (Y < List[i].rttxt.Bottom) then
    begin
      result := i;
      exit;
    end;
  end;
end;

constructor TProtocolAdd.create;
begin
  title := '';
  initrect(rttl);
  Count := 0;
end;

procedure TProtocolAdd.clear;
var
  i: integer;
begin
  title := '';
  for i := Count - 1 downto 0 do
  begin
    List[Count - 1].FreeInstance;
    Count := Count - 1;
    setlength(List, Count);
  end;
  Count := 0;
end;

destructor TProtocolAdd.destroy;
begin
  freemem(@title);
  freemem(@rttl);
  clear;
  freemem(@Count);
  freemem(@List);
end;

function TProtocolAdd.GetString: string;
var
  i: integer;
begin
  result := '<AddOptions>';
  result := result + '<Title=' + trim(title) + '>';
  result := result + '<Count=' + inttostr(Count) + '>';
  for i := 0 to Count - 1 do
  begin
    result := result + '<' + inttostr(i + 1) + ':' + trim(List[i].Name) + '=' +
      trim(List[i].Text) + '|' + trim(List[i].VarText) + '>';
  end;
  result := result + '</AddOptions>';
end;

procedure TProtocolAdd.GetListString(lst: tstrings);
var
  i: integer;
begin
  lst.Add(SetSpace(10) + '<AddOptions>');
  lst.Add(SetSpace(12) + '<Title=' + trim(title) + '>');
  lst.Add(SetSpace(12) + '<Count=' + inttostr(Count) + '>');
  for i := 0 to Count - 1 do
  begin
    lst.Add(SetSpace(12) + '<' + inttostr(i + 1) + ':' + trim(List[i].Name) +
      '=' + trim(List[i].Text) + '|' + trim(List[i].VarText) + '>');
  end;
  lst.Add(SetSpace(10) + '</AddOptions>');
end;

procedure TProtocolAdd.SetString(stri: string);
var
  sparam, scount: string;
  i, cnt: integer;
  res: TListParam;
begin
  clear;
  Count := 0;
  sparam := GetProtocolsStr(stri, 'AddOptions');
  title := GetProtocolsParam(sparam, 'Title');
  scount := GetProtocolsParam(sparam, 'Count');
  if trim(scount) <> '' then
  begin
    cnt := strtoint(scount);
    for i := 0 to cnt - 1 do
    begin
      res := GetProtocolsParamEx(sparam, i + 1);
      Count := Count + 1;
      setlength(List, Count);
      List[Count - 1] := TOneStringTable.create(res.Name, res.Text,
        res.VarText);
    end;
  end;
end;

procedure TProtocolAdd.draw(cv: tcanvas; HgRw: integer);
var
  tmp: tfastdib;
  i, wdth, hght, ps, Top, crw, ccl, j, wdcl, rw, cl, w1, w2: integer;
  clr: tcolor;
  intclr: longint;
  rt: trect;
begin
  tmp := tfastdib.create;
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
    rttl.Left := 5;
    rttl.Right := wdth - 5;
    rttl.Top := 5;
    rttl.Bottom := rttl.Top + HgRw;
    tmp.DrawText(title, rttl, DT_CENTER or DT_SINGLELINE);
    Top := rttl.Bottom + 5;
    crw := trunc(hght / HgRw) - 2;
    if crw = 0 then
      crw := 1;
    ccl := 32 div crw;
    if (32 mod crw) > 0 then
      ccl := ccl + 1;
    wdcl := trunc((wdth - 10) / ccl);
    ps := (wdcl - HgRw) div 5;
    w1 := ps * 3;
    w2 := ps * 2 - 5;

    j := 0;
    for i := 0 to Count - 1 do
    begin
      rw := i mod crw;
      cl := i div crw;
      rt.Left := 5 + cl * wdcl;
      rt.Right := rt.Left + HgRw;
      rt.Top := Top + rw * HgRw;
      rt.Bottom := rt.Top + HgRw;
      // List[i].rtnm.Left:=rt.Right;
      // List[i].rtnm.Top:=rt.Top;
      // List[i].rtnm.Right:=List[i].rtnm.Left+w1;
      // List[i].rtnm.Bottom:=rt.Bottom;
      List[i].rttxt.Left := rt.Right + 15; // List[i].rtnm.Right+5;
      List[i].rttxt.Top := rt.Top;
      List[i].rttxt.Right := List[i].rttxt.Left + wdcl - HgRw - 20;
      List[i].rttxt.Bottom := rt.Bottom;
      tmp.DrawText(inttostr(i), rt, DT_VCENTER or DT_SINGLELINE);
      tmp.SetFontEx(FormsFontName, trunc(w1 / length(List[i].Name)), MTFontSize,
        1, false, false, false);
      tmp.DrawText(List[i].Name, List[i].rtnm, DT_VCENTER or DT_SINGLELINE);
      tmp.SetFont(FormsFontName, MTFontSize);
      tmp.DrawText(List[i].Text, List[i].rttxt, DT_VCENTER or DT_SINGLELINE);
      // top := List[i].rtnm.Bottom;
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

function TProtocolAdd.ClickMouse(cv: tcanvas; X, Y: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
  begin
    if (X > List[i].rttxt.Left) and (X < List[i].rttxt.Right) and
      (Y > List[i].rttxt.Top) and (Y < List[i].rttxt.Bottom) then
    begin
      result := i;
      exit;
    end;
  end;
end;

end.
