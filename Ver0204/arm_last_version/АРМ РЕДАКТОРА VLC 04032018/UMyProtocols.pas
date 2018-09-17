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
    cmselect : boolean;
    ComPort: String;
    rt1: trect;
    rtsp: trect;
    spselect : boolean;
    Speed: string;
    LSpeed: string;
    rt2: trect;
    rtbt: trect;
    btselect : boolean;
    Bits: string;
    LBits: string;
    rt3: trect;
    rtpr: trect;
    prselect : boolean;
    Parity: string;
    LParity: string;
    rt4: trect;
    rtst: trect;
    stselect : boolean;
    Stop: string;
    LStop: string;
    rt5: trect;
    rtfl: trect;
    flselect : boolean;
    Flow: string;
    LFlow: string;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure draw(dib: tfastdib; Top, HgRw: integer);
    procedure MouseMove(cv: tcanvas; X, Y: integer);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    constructor create;
    destructor destroy;
  end;

  TPortIP = class
    rt1: trect;
    rtip: trect;
    ipselect : boolean;
    IPAdress: String;
    rt2: trect;
    rtpr: trect;
    prselect : boolean;
    IPPort: String;
    rt3: trect;
    rtlg: trect;
    Login: String;
    lgselect : boolean;
    rt4: trect;
    rtps: trect;
    psselect : boolean;
    Password: String;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure draw(dib: tfastdib; Top, HgRw: integer);
    procedure MouseMove(cv: tcanvas; X, Y: integer);
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
    dmselect : boolean;
    devicemanager : string;
    ldevicemanager : string;
    rt2: trect;
    rtsts : trect;
    Status : string;
    port422: TPort422;
    portip: TPortIP;
    function GetString: string;
    procedure GetListString(lst: tstrings);
    procedure SetString(stri: string);
    procedure SetStringPr(stri: string);
    procedure draw(cv: tcanvas; HghtRw: integer);
    procedure unselect;
    procedure MouseMove(cv: tcanvas; X, Y: integer);
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
    txtselect : boolean;
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
    procedure unselect;
    procedure MouseMove(cv: tcanvas; X, Y: integer);
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
    procedure unselect;
    procedure MouseMove(cv: tcanvas; X, Y: integer);
    function ClickMouse(cv: tcanvas; X, Y: integer): integer;
    procedure clear;
    constructor create;
    destructor destroy;
  end;

  TOneProtocol = class
    rt4: trect;
    Protocol: string;
    rtp: trect;
    pselect : boolean;
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
    dselect : boolean;
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
    vselect : boolean;
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
    tdselect : boolean;
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
    function ClickMouse(cv: tcanvas; X, Y, HghtRw: integer): integer;
    procedure unselect;
    procedure MouseMove(cv: tcanvas; X, Y: integer);
    procedure LoadFromFile(FileName, TypeProtocols: string);
    procedure SaveToFile(FileName, TypeProtocols: string);
    procedure drawimgempty(cv: tcanvas);
    procedure DrawEmpty(cv : tcanvas; HghtRw : integer);
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

procedure TListTypeDevices.drawimgempty(cv: tcanvas);
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
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
    tmp := nil;
  end
end;

procedure TListTypeDevices.DrawEmpty(cv : tcanvas; HghtRw : integer);
var
  tmp: tfastdib;
  i, wdth, hght, ps: integer;
  clr: tcolor;
  intclr: longint;
  rt, rt1, rttd : trect;
  s, ss: string;
  tdselect : boolean;
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
    tdselect := true;
    if tdselect
      then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
      else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
    tmp.Rectangle(rttd.Left,rttd.Top,rttd.Right,rttd.Bottom);
    tmp.DrawText('Тип оборудования:', rt1, DT_VCENTER or DT_SINGLELINE);
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle, cv.ClipRect.Left, cv.ClipRect.Top,
      cv.ClipRect.Right, cv.ClipRect.Bottom, 0, 0);
    cv.Refresh;
  finally
    tmp.Free;
    tmp := nil;
  end
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

procedure TListTypeDevices.unselect;
begin
  if index = -1 then exit;//index := 0;
  with TypeDevices[index] do
  begin
    tdselect := false;
    if index = -1 then index := 0;
    with Vendors[index] do
    begin
      vselect := false;
      if index = -1 then index := 0;
      with FirmDevices[index] do
      begin
        dselect := false;
        if index = -1 then index := 0;
        with ListProtocols[index] do
        begin
          pselect := false;
        end;
      end;
    end;
  end;
end;

procedure TListTypeDevices.MouseMove(cv: tcanvas; X, Y: integer);
begin
//  if index = -1 then index := 0;
//  with TypeDevices[index] do
//  begin
//    tdselect := false;
//    if index = -1 then index := 0;
//    with Vendors[index] do
//    begin
//      vselect := false;
//      if index = -1 then index := 0;
//      with FirmDevices[index] do
//      begin
//        dselect := false;
//        if index = -1 then index := 0;
//        with ListProtocols[index] do
//        begin
//          pselect := false;
//        end;
//      end;
//    end;
//  end;
  unselect;

  if index = -1 then begin
    //tdselect := true;
    exit;
  end;

  with TypeDevices[index] do
  begin
    if (Y > rttd.Top) and (Y < rttd.Bottom) then
    begin
      tdselect := true;
      exit;
    end;
    if index = -1 then
      index := 0;
    with Vendors[index] do
    begin
      if (Y > rtv.Top) and (Y < rtv.Bottom) then
      begin
        vselect := true;
        exit;
      end;
      if index = -1 then
        index := 0;
      with FirmDevices[index] do
      begin
        if (Y > rtd.Top) and (Y < rtd.Bottom) then
        begin
          dselect := true;
          exit;
        end;
        if index = -1 then
          index := 0;
        with ListProtocols[index] do
        begin
          if (Y > rtp.Top) and (Y < rtp.Bottom) then
          begin
            pselect := true;
            exit;
          end;
        end;
      end;
    end;
  end;
end;

function TListTypeDevices.ClickMouse(cv: tcanvas; X, Y, HghtRw: integer): integer;
var wdth, hght, ps : integer;
    rt : trect;
begin
  result := -1;
  if index = -1 then begin
    wdth := cv.ClipRect.Right - cv.ClipRect.Left;
    hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
    ps := (wdth - 10) div 2;
    rt.Left := ps + 10;
    rt.Top := 5;
    rt.Right := wdth - 5;
    rt.Bottom := 5 + HghtRw;
    if (X > rt.Left) and (X < rt.Right) and (Y > rt.Top) and (Y < rt.Bottom)
    then begin
      result := 0;
    end;
    exit;
    //index := 0;
  end;

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
      if not FileExists(FName) then
        exit;
      buff.LoadFromFile(FName);
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
  dselect := false;
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
  freemem(@dselect);
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
  tdselect := false;
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
  freemem(@tdselect);
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
    if tdselect
      then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
      else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
    tmp.Rectangle(rttd.Left,rttd.Top,rttd.Right,rttd.Bottom);
    tmp.DrawText('Тип оборудования:', rt1, DT_VCENTER or DT_SINGLELINE);
    if Index = -1 then exit;

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
    if Vendors[index].vselect
      then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
      else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
    tmp.Rectangle(Vendors[index].rtv.Left,Vendors[index].rtv.Top,
                  Vendors[index].rtv.Right,Vendors[index].rtv.Bottom);
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
      if FirmDevices[index].dselect
        then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
        else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
      tmp.Rectangle(FirmDevices[index].rtd.Left,FirmDevices[index].rtd.Top,
                    FirmDevices[index].rtd.Right,FirmDevices[index].rtd.Bottom);
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
        if ListProtocols[index].pselect
          then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
          else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
        tmp.Rectangle(ListProtocols[index].rtp.Left,ListProtocols[index].rtp.Top,
                    ListProtocols[index].rtp.Right,ListProtocols[index].rtp.Bottom);
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
  ldevicemanager := '0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16';
  initrect(rt2);
  initrect(rtsts);
  status := '';
  port422 := TPort422.create;
  portip := TPortIP.create;
  dmselect := false;
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
  freemem(@ldevicemanager);
  freemem(@rt2);
  freemem(@rtsts);
  freemem(@status);
  freemem(@port422);
  freemem(@portip);
  freemem(@dmselect);
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

procedure TMyPort.SetStringPr(stri: string);
var
  sports: string;
begin
  sports := GetProtocolsStr(stri, 'Port422');
  if trim(sports) <> '' then
  begin
    port422.SetString(sports);
    exist422 := true;
  //end
  //else
  //begin
  //  exist422 := false;
  end;

  sports := GetProtocolsStr(stri, 'PortIP');
  if trim(sports) <> '' then
  begin
    portip.SetString(sports);
    existip := true;
  //end
  //else
  //begin
  //  existip := false;
  end;

  if (not exist422) and existip then
    select422 := false
  else if (not existip) and exist422 then
    select422 := true;
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

    rt1.Left := 5;
    rt1.Right := ps - 10;
    rt1.Top := Top;// + HghtRw + 5;
    rt1.Bottom := rt1.Top + HghtRw;
    rtdm.Left := ps - 5;
    rtdm.Right := wdth - 5;
    rtdm.Top := rt1.Top;
    rtdm.Bottom := rt1.Bottom;
    if dmselect
      then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
      else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
    tmp.Rectangle(rtdm.Left,rtdm.Top,rtdm.Right,rtdm.Bottom);
    tmp.DrawText('Номер:', rt1, DT_VCENTER or DT_SINGLELINE);
    //tmp.DrawText('123456789', rtdm, DT_VCENTER or DT_SINGLELINE);
    tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);

    rt2.Left := 5;
    rt2.Right := ps - 10;
    rt2.Top := rtdm.Bottom + 5;
    rt2.Bottom := rt2.Top + HghtRw;
    rtsts.Left := ps - 5;
    rtsts.Right := wdth - 5;
    rtsts.Top := rt2.Top;
    rtsts.Bottom := rt2.Bottom;

    tmp.DrawText('Статус:', rt2, DT_VCENTER or DT_SINGLELINE);
    tmp.DrawText(Status, rtsts, DT_VCENTER or DT_SINGLELINE);

    Top := rtsts.Bottom + 5;

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
      tmp.SetPen(ps_solid,1,colortorgb(FormsFontColor));
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
      tmp.DrawText('RS422/232', Rect(rt422.Left + HghtRw - 5, rt422.Top,
        rt422.Right, rt422.Bottom), DT_VCENTER or DT_SINGLELINE);

      // tmp.Rectangle(rtip.Left, rtip.Top+4, rtip.Left+HghtRw-8,rtip.Bottom-4);
      tmp.DrawText('IP Адрес', Rect(rtip.Left + HghtRw - 5, rtip.Top,
        rtip.Right, rtip.Bottom), DT_VCENTER or DT_SINGLELINE);


      if select422 then
        port422.draw(tmp, rtip.Bottom + 5, HghtRw)
      else
        portip.draw(tmp, rtip.Bottom + 5, HghtRw);
    end
    else if (not exist422) and existip then
    begin
      Top := 5;
      ps := (wdth - 10) div 2;

      rt1.Left := 5;
      rt1.Right := ps - 10;
      rt1.Top := Top;// + HghtRw + 5;
      rt1.Bottom := rt1.Top + HghtRw;
      rtdm.Left := ps - 5;
      rtdm.Right := wdth - 5;
      rtdm.Top := rt1.Top;
      rtdm.Bottom := rt1.Bottom;
      if dmselect
        then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
        else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
      tmp.Rectangle(rtdm.Left,rtdm.Top,rtdm.Right,rtdm.Bottom);
      tmp.DrawText('Номер:', rt1, DT_VCENTER or DT_SINGLELINE);
      //tmp.DrawText('123456789', rtdm, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);

      rt2.Left := 5;
      rt2.Right := ps - 10;
      rt2.Top := rtdm.Bottom + 5;
      rt2.Bottom := rt2.Top + HghtRw;
      rtsts.Left := ps - 5;
      rtsts.Right := wdth - 5;
      rtsts.Top := rt2.Top;
      rtsts.Bottom := rt2.Bottom;

      tmp.DrawText('Статус:', rt2, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(Status, rtsts, DT_VCENTER or DT_SINGLELINE);

      Top := rtsts.Bottom + 5;
      portip.draw(tmp, Top, HghtRw);
    end
    else if (not existip) and exist422 then
    begin
      Top := 5;
      ps := (wdth - 10) div 2;

      rt1.Left := 5;
      rt1.Right := ps - 10;
      rt1.Top := Top;// + HghtRw + 5;
      rt1.Bottom := rt1.Top + HghtRw;
      rtdm.Left := ps - 5;
      rtdm.Right := wdth - 5;
      rtdm.Top := rt1.Top;
      rtdm.Bottom := rt1.Bottom;
      if dmselect
        then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
        else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
      tmp.Rectangle(rtdm.Left,rtdm.Top,rtdm.Right,rtdm.Bottom);
      tmp.DrawText('Номер:', rt1, DT_VCENTER or DT_SINGLELINE);
      //tmp.DrawText('123456789', rtdm, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);

      rt2.Left := 5;
      rt2.Right := ps - 10;
      rt2.Top := rtdm.Bottom + 5;
      rt2.Bottom := rt2.Top + HghtRw;
      rtsts.Left := ps - 5;
      rtsts.Right := wdth - 5;
      rtsts.Top := rt2.Top;
      rtsts.Bottom := rt2.Bottom;

      tmp.DrawText('Статус:', rt2, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(Status, rtsts, DT_VCENTER or DT_SINGLELINE);

      Top := rtsts.Bottom + 5;
      port422.draw(tmp, Top, HghtRw);
    end
    else if (not exist422) and (not existip) then
    begin
      tmp.SetTextColor(colortorgb(smoothcolor(FormsFontColor, 32)));

      Top := 5;
      ps := (wdth - 10) div 2;

      rt1.Left := 5;
      rt1.Right := ps - 10;
      rt1.Top := Top;// + HghtRw + 5;
      rt1.Bottom := rt1.Top + HghtRw;
      rtdm.Left := ps - 5;
      rtdm.Right := wdth - 5;
      rtdm.Top := rt1.Top;
      rtdm.Bottom := rt1.Bottom;
      if dmselect
        then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
        else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
      tmp.Rectangle(rtdm.Left,rtdm.Top,rtdm.Right,rtdm.Bottom);
      tmp.DrawText('Номер:', rt1, DT_VCENTER or DT_SINGLELINE);
      //tmp.DrawText('123456789', rtdm, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(devicemanager, rtdm, DT_VCENTER or DT_SINGLELINE);

      rt2.Left := 5;
      rt2.Right := ps - 10;
      rt2.Top := rtdm.Bottom + 5;
      rt2.Bottom := rt2.Top + HghtRw;
      rtsts.Left := ps - 5;
      rtsts.Right := wdth - 5;
      rtsts.Top := rt2.Top;
      rtsts.Bottom := rt2.Bottom;

      tmp.DrawText('Статус:', rt2, DT_VCENTER or DT_SINGLELINE);
      tmp.DrawText(Status, rtsts, DT_VCENTER or DT_SINGLELINE);

      Top := rtsts.Bottom + 5;
      if select422 then
        port422.draw(tmp, Top, HghtRw)
      else
        portip.draw(tmp, Top, HghtRw);
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

procedure TMyPort.unselect;
begin
  dmselect := false;
  port422.cmselect := false;
  port422.spselect := false;
  port422.btselect := false;
  port422.prselect := false;
  port422.stselect := false;
  port422.flselect := false;
  portip.ipselect := false;
  portip.prselect := false;
  portip.lgselect := false;
  portip.psselect := false;
end;

procedure TMyPort.MouseMove(cv: tcanvas; X, Y: integer);
begin
  //dmselect := false;
  //port422.cmselect := false;
  //port422.spselect := false;
  //port422.btselect := false;
  //port422.prselect := false;
  //port422.stselect := false;
  //port422.flselect := false;
  //portip.ipselect := false;
  //portip.prselect := false;
  //portip.lgselect := false;
  //portip.psselect := false;
  unselect;
  if (Y > rtdm.Top) and (Y < rtdm.Bottom) then
  begin
    dmselect := true;
    exit
  end;
  if select422 then
    port422.MouseMove(cv, X, Y)
  else
    portip.MouseMove(cv, X, Y);
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
  ipselect := false;
  prselect := false;
  lgselect := false;
  psselect := false;
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
  freemem(@ipselect);
  freemem(@prselect);
  freemem(@lgselect);
  freemem(@psselect);
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
  if ipselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtip.Left,rtip.Top,rtip.Right,rtip.Bottom);
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
  if prselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtpr.Left,rtpr.Top,rtpr.Right,rtpr.Bottom);
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
  if lgselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtlg.Left,rtlg.Top,rtlg.Right,rtlg.Bottom);
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
  if psselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtps.Left,rtps.Top,rtps.Right,rtps.Bottom);
  dib.DrawText('Пароль:', rt4, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Password, rtps, DT_VCENTER or DT_SINGLELINE);
end;

procedure TPortIP.MouseMove(cv: tcanvas; X, Y: integer);
begin
  ipselect := false;
  prselect := false;
  lgselect := false;
  psselect := false;
  if (Y > rtip.Top) and (Y < rtip.Bottom)
  then begin
    ipselect := true;
    exit
  end;
  if (Y > rtpr.Top) and (Y < rtpr.Bottom)
  then begin
    prselect := true;
    exit
  end;
  if (Y > rtlg.Top) and (Y < rtlg.Bottom)
  then begin
    lgselect := true;
    exit
  end;
  if (Y > rtps.Top) and (Y < rtps.Bottom)
  then begin
    psselect := true;
    exit
  end;
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
  cmselect := false;
  spselect := false;
  btselect := false;
  prselect := false;
  stselect := false;
  flselect := false;
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
  freemem(@cmselect);
  freemem(@spselect);
  freemem(@btselect);
  freemem(@prselect);
  freemem(@stselect);
  freemem(@flselect);
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

  if cmselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtcm.Left,rtcm.Top,rtcm.Right,rtcm.Bottom);
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
  if spselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtsp.Left,rtsp.Top,rtsp.Right,rtsp.Bottom);
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
  if btselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtbt.Left,rtbt.Top,rtbt.Right,rtbt.Bottom);
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
  if prselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtpr.Left,rtpr.Top,rtpr.Right,rtpr.Bottom);
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
  if stselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtst.Left,rtst.Top,rtst.Right,rtst.Bottom);
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
  if flselect
    then dib.SetPen(ps_dot,1,colortorgb(FormsFontColor))
    else dib.SetPen(ps_solid,1,colortorgb(FormsColor));
  dib.Rectangle(rtfl.Left,rtfl.Top,rtfl.Right,rtfl.Bottom);
  dib.DrawText('Упр. потоком:', rt5, DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Flow, rtfl, DT_VCENTER or DT_SINGLELINE);
end;

procedure TPort422.MouseMove(cv: tcanvas; X, Y: integer);
begin
  cmselect := false;
  spselect := false;
  btselect := false;
  prselect := false;
  stselect := false;
  flselect := false;
  if (Y > rtcm.Top) and (Y < rtcm.Bottom) then
  begin
    cmselect := true;
    exit
  end;
  if (Y > rtsp.Top) and (Y < rtsp.Bottom) then
  begin
    spselect := true;
    exit
  end;
  if (Y > rtbt.Top) and (Y < rtbt.Bottom) then
  begin
    btselect := true;
    exit
  end;
  if (Y > rtpr.Top) and (Y < rtpr.Bottom) then
  begin
    prselect := true;
    exit
  end;
  if (Y > rtst.Top) and (Y < rtst.Bottom) then
  begin
    stselect := true;
    exit
  end;
  if (Y > rtfl.Top) and (Y < rtfl.Bottom) then
  begin
    flselect := true;
    exit
  end;
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
  pselect:=false;
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
  freemem(@pselect);
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
  vselect := false;
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
  freemem(@vselect);
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
  txtselect := false;
end;

destructor TOneStringTable.destroy;
begin
  freemem(@Name);
  freemem(@rtnm);
  freemem(@Text);
  freemem(@rttxt);
  freemem(@VarText);
  freemem(@txtselect);
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
      if List[i].txtselect
        then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
        else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
      tmp.Rectangle(List[i].rttxt.Left,List[i].rttxt.Top,
                    List[i].rttxt.Right,List[i].rttxt.Bottom);
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

procedure TProtocolMain.unselect;
var i: integer;
begin
  for i := 0 to Count - 1 do List[i].txtselect := false;
end;

procedure TProtocolMain.MouseMove(cv: tcanvas; X, Y: integer);
var i: integer;
begin
  //for i := 0 to Count - 1 do List[i].txtselect := false;
  unselect;
  for i := 0 to Count - 1 do  begin
    if (Y > List[i].rttxt.Top) and (Y < List[i].rttxt.Bottom) then
    begin
      List[i].txtselect := true;
      exit;
    end;
  end;
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
      if List[i].txtselect
        then tmp.SetPen(ps_dot,1,colortorgb(FormsFontColor))
        else tmp.SetPen(ps_solid,1,colortorgb(FormsColor));
      tmp.Rectangle(List[i].rttxt.Left,List[i].rttxt.Top,
                    List[i].rttxt.Right,List[i].rttxt.Bottom);

      tmp.DrawText(inttostr(i+1), rt, DT_VCENTER or DT_SINGLELINE);
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

procedure TProtocolAdd.unselect;
var i: integer;
begin
  for i := 0 to Count - 1 do List[i].txtselect := false;
end;

procedure TProtocolAdd.MouseMove(cv: tcanvas; X, Y: integer);
var i: integer;
begin
  for i := 0 to Count - 1 do List[i].txtselect := false;
  for i := 0 to Count - 1 do begin
    if (X > List[i].rttxt.Left) and (X < List[i].rttxt.Right) and
      (Y > List[i].rttxt.Top) and (Y < List[i].rttxt.Bottom) then
    begin
      List[i].txtselect := true;
      exit;
    end;
  end;
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
