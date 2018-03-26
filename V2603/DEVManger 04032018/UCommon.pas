unit UCommon;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, JPEG, Math,
    PasLibVlcUnit,
    System.JSON, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend,
    Utils,
    StrUtils;

Type
    TGridPlayer = (grClips, grPlaylist, grDefault);
    TSinchronization = (chltc, chsystem, chnone1);
    TTypeTimeline = (tldevice, tltext, tlmedia, tlnone);

    TEventReplay = record
        Number: integer;
        SafeZone: boolean;
        Image: String;
    end;

    TListParam = record
        Name: String;
        Text: String;
    end;

    TRangeParam = record
        Text: string;
        Min: integer;
        Max: integer;
    end;

    TRectJSON = record helper for TRect
        Function SaveToJSONStr: string;
        Function SaveToJSONObject: tjsonObject;
        Function LoadFromJSONObject(JSON: tjsonObject): boolean;
        Function LoadFromJSONstr(JSONstr: string): boolean;
    End;

    PCompartido = ^TCompartido;

    TCompartido = record
        Manejador1: Cardinal;
        Manejador2: Cardinal;
        Numero: integer;
        Shift: Double;
        State: boolean;
        Cadena: String[20];
    end;

Const
    HintSendBytes =
      'В режиме байтовой передачи данные представляются в шестнадцатиричной форме.'
      + #13#10 + 'Один байт два сивола например А5';
    HintSendChars =
      'В режиме символьной передачи данные представляются в кодировке ANSI';

Var
    // Параметры синхронизации
    MyShift: Double = 0; // Смещение LTC относительно системного времени
    TCExists: boolean = false;
    MyShiftOld: Double = 0;
    // Старое смещение LTC относительно системного времени
    MyShiftDelta: Double = 0;
    MySinhro: TSinchronization = chsystem; // Тип синхронизации
    MyStartPlay: longint = -1;
    // Время старта клипа, при chnone не используется, -1 время не установлено.
    MyStartReady: boolean = false;
    // True - готовность к старту, false - старт осуществлен.
    MyRemainTime: longint = -1; // время оставшееся до запуска

    // Основные параметры программы
    SerialNumber: string = 'DM000001';
    ManagerNumber: integer = 0;
    Port422Name: string = '';
    Port422Number: integer = 0;
    Port422Speed: string = '38400';
    Port422Bits: string = '8';
    Port422Parity: string = 'нечет';
    Port422Stop: string = '1';
    Port422Flow: string = 'нет';
    IPAdress: string = '192.168.000.010';
    IPPort: string = '9009';
    IPLogin: string = '';
    IPPassword: string = '';
    //jsonware_url: string = 'http://localhost:9090/';
    // 'http://localhost:9090/GET_TLEDITOR';
    Port422Init: boolean = false;
    IPPortInit: boolean = false;
    Port422select: boolean = true;
    // если true -  управление RSPort, false активен IPport
    PortRSStoped: boolean = true; // RS port остановлен

    ListComports: tstrings;

    AutoStart: boolean = false;
    MakeLogging: boolean = true;
    AppPath, AppName: string;
    PathLog: string;
    // SynchDelay : integer = 2;

    ProgrammColor: tcolor = $494747;
    ProgrammFontColor: tcolor = clWhite;
    ProgrammFontName: tfontname = 'Arial';
    ProgrammFontSize: integer = 10;
    ProgrammEditColor: tcolor = clWhite;
    ProgrammEditFontColor: tcolor = clBlack;
    ProgrammEditFontName: tfontname = 'Arial';
    ProgrammEditFontSize: integer = 10;
    MTFontSize: integer = 17;

    // Основные параметры Тайм-линий
    TLBackGround: tcolor = $211F1F;
    TLZoneNamesColor: tcolor = $505050;
    TLZoneFontColorSelect: tcolor = $057522;
    TLZoneNamesFontSize: integer = 14;
    TLZoneNamesFontColor: tcolor = clWhite;
    TLZoneNamesFontName: tfontname = 'Arial';
    TLZoneNamesFontBold: boolean = false;
    TLZoneNamesFontItalic: boolean = false;
    TLZoneNamesFontUnderline: boolean = false;
    TLZoneEditFontBold: boolean = false;
    TLZoneEditFontItalic: boolean = false;
    TLZoneEditFontUnderline: boolean = false;
    TLMaxDevice: integer = 6;
    TLMaxText: integer = 5;
    TLMaxMedia: integer = 1;
    TLMaxCount: integer = 16;
    DefaultMediaColor: tcolor = $00D8A520;
    DefaultTextColor: tcolor = $00ACEAE1;
    // Layer2FontColor : tcolor = $202020;
    // Layer2FontSize : integer = 8;
    StatusColor: array [0 .. 4] of tcolor = (
        clRed,
        clGreen,
        clBlue,
        clYellow,
        clSilver
    );
    isZoneEditor: boolean = false;
    TLMaxFrameSize: integer = 10;
    TLPreroll: longint = 250;
    TLPostroll: longint = 3000;
    TLFlashDuration: integer = 5;
    // TLFontColor : tcolor = clWhite;

    INFOTypeDevice: string = '';
    INFOVendor: string = '';
    INFODevice: string = '';
    INFOProt: string = '';
    INFOName1: string = '';
    INFOText1: string = '';
    INFOName2: string = '';
    INFOText2: string = '';
    INFOName3: string = '';
    INFOText3: string = '';

    StrProtocol : string = '';
    NumberTimeline: Integer = -1;
    CountWaitReplay : integer = 0;
    MaxCountReplay : integer = 10;

function UserExists(User, Pass: string): boolean;
function TwoDigit(dig: integer): string;
procedure LoadBMPFromRes(cv: tcanvas; rect: TRect; width, height: integer;
  Name: string);
function SmoothColor(color: tcolor; step: integer): tcolor;
Function DefineFontSizeW(cv: tcanvas; width: integer; txt: string): integer;
Function DefineFontSizeH(cv: tcanvas; height: integer): integer;
function MyDoubleToSTime(db: Double): string;
function MyDoubleToFrame(db: Double): longint;
function FramesToStr(frm: longint): string;
function FramesToShortStr(frm: longint): string;
function SecondToStr(frm: longint): string;
function SecondToShortStr(frm: longint): string;
function FramesToDouble(frm: longint): Double;
function FramesToTime(frm: longint): tdatetime;
function TimeToFrames(dt: tdatetime): longint;
function TimeToTimeCodeStr(dt: tdatetime): string;
function StrTimeCodeToFrames(tc: string): longint;
function createunicumname: string;
procedure LoadJpegFile(bmp: tbitmap; FileName: string);
procedure MyTextRect(var cv: tcanvas; const rect: TRect; Text: string);
procedure TemplateToScreen(crpos: TEventReplay);
function MyDateTimeToStr(tm: tdatetime): string;
function TimeCodeDelta: Double;
function TColorToTfcolor(color: tcolor): TFColor;
procedure Delay(const AMilliseconds: Cardinal);
procedure initrect(rt: TRect);
function chartohex(ch: char): byte;
function StrToByte(stri: string): byte;
function DataToBuffIn(strd: string): integer;
procedure WriteLog(FileName: string; log: widestring);
procedure GetListParam(SrcStr: string; lst: tstrings);
function GetProtocolsParam(SrcStr, Name: string): string;
function GetProtocolsParamEx(SrcStr: string; Number: integer): TListParam;
function GetProtocolsParamIn(SrcStr: string; Number: integer): TListParam;
procedure GetProtocolsList(SrcStr, Name: string; List: tstrings);
function GetProtocolsStr(SrcStr, Name: string): string;
function GetRangeParams(Text: string): TRangeParam;
function GetIndexStr(Text: string): TListParam;
function GetParamData(TypeData: string; data: integer): string;
procedure ReadCommandField(stri: string; lst: tstrings);
function PhraseParam(stri: string): TListParam;
procedure SeparationString(SrcStr: string; lst: tstrings);
procedure SeparationChar(SrcStr: ansistring; ch: ansichar; lst: tstrings);
function MyStrToInt(stri: string): integer;
function hexchartoint(Hexchar: ansichar): integer;
function myhextoint(stri: string): integer;
function GetDigit(value, posdig: string): string;
// function GetCommandValue(evnt : TMyEvent; Source, Param, Phrase, TypePhrase, Index : string) : string;

implementation

uses mainunit, utimeline, udrawtimelines, ugrtimelines, ComPortUnit,
    umyprotocols, uwebget;
{ TRectJSON }

function TRectJSON.LoadFromJSONObject(JSON: tjsonObject): boolean;
begin
    Top := getVariableFromJson(JSON, 'Top', Top);
    Bottom := getVariableFromJson(JSON, 'Bottom', Bottom);
    left := getVariableFromJson(JSON, 'Left', left);
    Right := getVariableFromJson(JSON, 'Right', Right);

end;

function TRectJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
    JSON: tjsonObject;
begin
    JSON := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
      as tjsonObject;
    result := true;
    if JSON = nil then
    begin
        result := false;
    end
    else
        LoadFromJSONObject(JSON);
end;

function TRectJSON.SaveToJSONObject: tjsonObject;
var
    JSON: tjsonObject;
begin
    JSON := tjsonObject.Create;
    addVariableToJson(JSON, 'Top', Top);
    addVariableToJson(JSON, 'Bottom', Bottom);
    addVariableToJson(JSON, 'Left', left);
    addVariableToJson(JSON, 'Right', Right);
    result := JSON;
end;

function TRectJSON.SaveToJSONStr: string;
begin
    result := SaveToJSONObject.ToString;
end;
/// // SSSSSSSSSSSSSSSSSSSSSSSSSSSSS end



function hexchartoint(Hexchar: ansichar): integer;
begin
    case Hexchar of
        '0':
            result := 0;
        '1':
            result := 1;
        '2':
            result := 2;
        '3':
            result := 3;
        '4':
            result := 4;
        '5':
            result := 5;
        '6':
            result := 6;
        '7':
            result := 7;
        '8':
            result := 8;
        '9':
            result := 9;
        'a', 'A':
            result := 10;
        'b', 'B':
            result := 11;
        'c', 'C':
            result := 12;
        'd', 'D':
            result := 13;
        'e', 'E':
            result := 14;
        'f', 'F':
            result := 15;
    end;
end;

function myhextoint(stri: string): integer;
var
    i, res, vl, mng: integer;
    s: string;
begin
    s := trim(stri);
    for i := 1 to length(s) do
    begin
        if not(s[i] in ['0' .. '9', 'a', 'A', 'b', 'B', 'c', 'C', 'd', 'D', 'e',
          'E', 'f', 'F']) then
        begin
            result := -1;
            exit;
        end;
    end;
    res := 0;
    mng := 1;
    for i := length(s) downto 1 do
    begin
        res := res + chartohex(s[i]) * mng;
        mng := mng * 16;
    end;
    result := res;
end;

function GetDigit(value, posdig: string): string;
var
    s, sv, strd: string;
    i, isv: integer;
begin
    if trim(value) = '' then
    begin
        result := '0';
        exit;
    end;
    isv := MyStrToInt(value);
    if isv = -1 then
    begin
        result := '0';
        exit;
    end;
    strd := '0000000000';
    sv := trim(value);
    isv := 10;
    for i := length(sv) downto 1 do
    begin
        strd[isv] := sv[i];
        isv := isv - 1;
    end;

    s := ansilowercase(trim(posdig));
    if s = 'thousands' then
        result := strd[7]
    else if s = 'hundres' then
        result := strd[8]
    else if s = 'tens' then
        result := strd[9]
    else if s = 'ones' then
        result := strd[10];
end;

function MyStrToInt(stri: string): integer;
var
    i: integer;
    s: string;
begin
    result := -1;
    s := trim(stri);
    if s='' then exit;
    for i := 1 to length(s) do
    begin
        if not(s[i] in ['0' .. '9']) then
        begin
            exit;
        end;
    end;
    result := strtoint(s);
end;

procedure SeparationString(SrcStr: string; lst: tstrings);
var
    i, cnt: integer;
    stmp: string;
begin
    lst.Clear;
    stmp := '';
    cnt := 0;
    for i := 1 to length(SrcStr) do
    begin
        case SrcStr[i] of
            '.':
                begin
                    if cnt = 0 then
                    begin
                        if trim(stmp) <> '' then
                            lst.Add(stmp);
                        stmp := '';
                    end
                    else
                        stmp := stmp + SrcStr[i];
                end;
            '[':
                begin
                    if cnt = 0 then
                    begin
                        if trim(stmp) <> '' then
                            lst.Add(stmp);
                        stmp := '[';
                    end
                    else
                        stmp := stmp + SrcStr[i];
                    cnt := cnt + 1;
                end;
            ']':
                begin
                    stmp := stmp + SrcStr[i];
                    if cnt = 1 then
                    begin
                        // stmp:=stmp+srcstr[i];
                        if trim(stmp) <> '' then
                            lst.Add(stmp);
                        stmp := '';
                        cnt := 0;
                    end
                    else if cnt > 0 then
                        cnt := cnt - 1;
                end;
        else
            begin
                stmp := stmp + SrcStr[i];
            end;
        end;
    end;
    if trim(stmp) <> '' then
        lst.Add(stmp);
end;

procedure SeparationChar(SrcStr: ansistring; ch: ansichar; lst: tstrings);
var
    i, cnt: integer;
    stmp: string;
begin
    lst.Clear;
    stmp := '';
    cnt := 0;
    for i := 1 to length(SrcStr) do
    begin
        if SrcStr[i] = ch then
        begin
            if trim(stmp) <> '' then
                lst.Add(stmp);
            stmp := '';
        end
        else
            stmp := stmp + SrcStr[i];
    end;
    if trim(stmp) <> '' then
        lst.Add(stmp);
end;

procedure ReadCommandField(stri: string; lst: tstrings);
var
    i: integer;
    sstr, stmp, ss: string;
    pss, pse, psa, psb: integer;
begin
    lst.Clear;
    sstr := trim(stri);
    pss := posex('.', sstr, 1);
    psa := posex('[', sstr, 1);
    while pss <> 0 do
    begin
        if psa <> 0 then
        begin
            if pss < psa then
            begin
                ss := copy(sstr, 1, pss - 1);
                lst.Add(ss);
                sstr := copy(sstr, pss + 1, length(sstr));
            end
            else
            begin
                pse := posex(']', sstr, psa);
                ss := copy(sstr, 1, psa - 1);
                lst.Add(ss);
                if pse = 0 then
                begin
                    ss := copy(sstr, psa, length(sstr));
                    lst.Add(ss);
                    exit;
                end
                else
                begin;
                    ss := copy(sstr, psa, pse - psa + 1);
                    lst.Add(ss);
                    sstr := copy(sstr, pse + 1, length(sstr));
                end;
            end;
        end
        else
        begin
            ss := copy(sstr, 1, pss - 1);
            lst.Add(ss);
            sstr := copy(sstr, pss + 1, length(sstr));
        end;
        pss := posex('.', sstr, 1);
        psa := posex('[', sstr, 1);
    end;
    sstr := copy(sstr, 1, length(sstr));
    if trim(sstr) <> '' then
        lst.Add(sstr);
end;

function PhraseParam(stri: string): TListParam;
var
    pss, pse: integer;
    s: string;
begin
    s := trim(stri);
    result.Name := s;
    result.Text := '';
    pss := posex('(', s, 1);
    pse := posex(')', s, pss);
    if pss <> 0 then
    begin
        result.Name := copy(s, 1, pss - 1);
        if pse <> 0 then
            result.Text := copy(s, pss + 1, pse - pss - 1)
        else
            result.Text := copy(s, pss + 1, length(s));
    end;
end;

function GetParamData(TypeData: string; data: integer): string;
var
    stmp: string;
    bt: byte;
begin
    result := '';
    bt := data;
    stmp := StringReplace(TypeData, '.', '', [rfReplaceAll, rfIgnoreCase]);
    stmp := ansilowercase(trim(stmp));

    if stmp = 'byte' then
        result := inttohex(bt)
    else if stmp = 'hbyte' then
        result := inttohex(bt and $F0)
    else if stmp = 'lbyte' then
        result := inttohex(bt and $0F)
    else if stmp = 'bit0' then
        result := inttohex(bt and $01)
    else if stmp = 'bit1' then
        result := inttohex(bt and $02)
    else if stmp = 'bit2' then
        result := inttohex(bt and $04)
    else if stmp = 'bit3' then
        result := inttohex(bt and $08)
    else if stmp = 'bit4' then
        result := inttohex(bt and $10)
    else if stmp = 'bit5' then
        result := inttohex(bt and $20)
    else if stmp = 'bit6' then
        result := inttohex(bt and $40)
    else if stmp = 'bit7' then
        result := inttohex(bt and $80)
end;

procedure GetListParam(SrcStr: string; lst: tstrings);
var
    ssrc, sstr, stmp, ssc, ss1, ss2: string;
    i, pss, pse, ps1, ps2: integer;
begin
    lst.Clear;
    pss := 1;
    pse := posex('|', SrcStr, pss);
    while pse <> 0 do
    begin
        stmp := copy(SrcStr, pss, pse - pss);
        stmp := StringReplace(stmp, '|', '', [rfReplaceAll, rfIgnoreCase]);
        if trim(stmp) <> '' then
        begin
            ps1 := posex('[', stmp, 1);
            ps2 := posex(']', stmp, ps1);
            if (ps1 <> 0) and (ps2 <> 0) then
            begin
                ssc := copy(stmp, 1, ps1 - 1);
                ss1 := copy(stmp, ps1 + 1, ps2 - ps1 - 1);
                ps1 := posex('..', ss1, 1);
                if ps1 <> 0 then
                begin
                    ss2 := copy(ss1, ps1 + 2, length(ss1));
                    ss1 := copy(ss1, 1, ps1 - 1);
                    for i := strtoint(ss1) to strtoint(ss2) do
                        lst.Add(ssc + inttostr(i));
                end
                else
                    lst.Add(stmp);
            end
            else
                lst.Add(stmp);
        end;
        pss := pse + 1;
        pse := posex('|', SrcStr, pss);
    end;
    stmp := copy(SrcStr, pss, length(SrcStr));
    stmp := StringReplace(stmp, '|', '', [rfReplaceAll, rfIgnoreCase]);
    if trim(stmp) <> '' then
    begin
        ps1 := posex('[', stmp, 1);
        ps2 := posex(']', stmp, ps1);
        if (ps1 <> 0) and (ps2 <> 0) then
        begin
            ssc := copy(stmp, 1, ps1 - 1);
            ss1 := copy(stmp, ps1 + 1, ps2 - ps1 - 1);
            ps1 := posex('..', ss1, 1);
            if ps1 <> 0 then
            begin
                ss2 := copy(ss1, ps1 + 2, length(ss1));
                ss1 := copy(ss1, 1, ps1 - 1);
                for i := strtoint(ss1) to strtoint(ss2) do
                    lst.Add(ssc + inttostr(i));
            end
            else
                lst.Add(stmp);
        end
        else
            lst.Add(stmp);
    end;
end;

function GetProtocolsParam(SrcStr, Name: string): string;
var
    ssrc, sstr, stmp: string;
    pss, pse: integer;
begin
    result := '';
    ssrc := ansilowercase(SrcStr);
    sstr := '<' + ansilowercase(trim(Name)) + '=';
    pss := posex(sstr, ssrc, 1);
    pse := posex('>', ssrc, pss);
    if (pss = 0) or (pse = 0) then
        exit;
    stmp := copy(SrcStr, pss, pse - pss);
    stmp := StringReplace(stmp, sstr, '', [rfReplaceAll, rfIgnoreCase]);
    result := StringReplace(stmp, '>', '', [rfReplaceAll, rfIgnoreCase]);
end;

function GetRangeParams(Text: string): TRangeParam;
var
    smin, smax, stxt, stmp: string;
    pss, pse: integer;
begin
    try
        result.Text := '';
        result.Min := -1;
        result.Max := -1;
        pss := posex('[', Text, 1);
        pse := posex(']', Text, pss);
        if (pss = 0) or (pse = 0) then
            exit;
        stxt := copy(Text, 1, pss - 1);
        stmp := copy(Text, pss + 1, pse - pss - 1);
        pss := posex('..', stmp, 1);
        if pss = 0 then
            exit;
        result.Text := stxt;
        smin := copy(stmp, 1, pss - 1);
        smax := copy(stmp, pss + 2, length(stmp));
        result.Min := strtoint(smin);
        result.Max := strtoint(smax);
    except
        result.Text := '';
        result.Min := -1;
        result.Max := -1;
        exit;
    end;
end;

function GetIndexStr(Text: string): TListParam;
var
    smin, smax, stxt, stmp: string;
    pss, pse: integer;
begin
    try
        result.Text := '';
        result.Name := '';
        pss := posex('[', Text, 1);
        pse := posex(']', Text, pss);
        if (pss = 0) or (pse = 0) then
            exit;
        result.Name := copy(Text, 1, pss - 1);
        result.Text := copy(Text, pss + 1, pse - pss - 1);
    except
        result.Text := '';
        result.Name := '';
        exit;
    end;
end;

function GetProtocolsParamIn(SrcStr: string; Number: integer): TListParam;
var
    ssrc, sstr, stmp, snam, stxt, svtxt: string;
    pss, pse: integer;
begin
    result.Name := '';
    result.Text := '';

    ssrc := ansilowercase(SrcStr);
    sstr := '<' + inttostr(Number) + ':';
    pss := posex(sstr, ssrc, 1) + length(sstr);
    pse := posex('>', ssrc, pss);
    if (pss = 0) or (pse = 0) then
        exit;
    stmp := copy(SrcStr, pss, pse - pss);
    pse := posex('=', stmp, 1);
    result.Name := copy(stmp, 1, pse - 1);
    stmp := copy(stmp, pse + 1, length(stmp));
    pse := posex('|', stmp, 1);
    if pse = 0 then
        result.Text := copy(stmp, 1, length(stmp))
    else
        result.Text := copy(stmp, 1, pse - 1);
end;

function GetProtocolsParamEx(SrcStr: string; Number: integer): TListParam;
var
    ssrc, sstr, stmp, snam, stxt, svtxt: string;
    pss, pse: integer;
begin
    result.Name := '';
    result.Text := '';

    ssrc := ansilowercase(SrcStr);
    sstr := '<' + inttostr(Number) + ':';
    pss := posex(sstr, ssrc, 1) + length(sstr);
    pse := posex('>', ssrc, pss);
    if (pss = 0) or (pse = 0) then
        exit;
    stmp := copy(SrcStr, pss, pse - pss);
    pse := posex('=', stmp, 1);
    result.Name := copy(stmp, 1, pse - 1);
    result.Text := copy(stmp, pse + 1, length(stmp));
end;

procedure GetProtocolsList(SrcStr, Name: string; List: tstrings); // overload;
var
    slst, ssrc, sstr, estr, stmp: string;
    pss, pse: integer;
begin
    List.Clear;
    ssrc := ansilowercase(SrcStr);
    sstr := '<' + ansilowercase(trim(Name));
    estr := '>';
    pss := posex(sstr, ssrc, 1);
    // stmp := copy(ssrc,pss,length(ssrc));
    pse := posex(estr, ssrc, pss);
    while (pss <> 0) and (pse <> 0) do
    begin
        slst := copy(SrcStr, pss, pse - pss);
        slst := StringReplace(slst, sstr, '', [rfReplaceAll, rfIgnoreCase]);
        slst := StringReplace(slst, estr, '', [rfReplaceAll, rfIgnoreCase]);
        if trim(slst) <> '' then
            List.Add(slst);
        pss := posex(sstr, ssrc, pse);
        pse := pos(estr, ssrc, pss);
        // stmp := copy(ssrc,pss,pse);
    end;
end;

function GetProtocolsStr(SrcStr, Name: string): string;
var
    ssrc, sstr, estr, stmp: string;
    pss, pse: integer;
begin
    result := '';
    ssrc := ansilowercase(SrcStr);
    sstr := '<' + ansilowercase(trim(Name));
    estr := '</' + ansilowercase(trim(Name));
    pss := posex(sstr, ssrc, 1);
    pse := posex(estr, ssrc, pss);
    pse := posex('>', ssrc, pse);
    if (pss = 0) or (pse = 0) then
        exit;
    result := copy(SrcStr, pss, pse - pss + 1);
    // pse:=PosEx(estr,stmp,pss);
    // if pse=0 then result:=stmp else result:=copy(stmp,1,pse-1);
end;

procedure WriteLog(FileName: string; log: widestring);
var
    F: TextFile;
    txt, FN: string;
    Day, Month, Year: Word;
Begin
    if trim(FileName)='' then exit;

    if not MakeLogging then
        exit;
    try
      try
        DecodeDate(now, Year, Month, Day);
        PathLog := extractfilepath(application.ExeName) + 'Log';
        if not DirectoryExists(PathLog) then
            ForceDirectories(PathLog);
        FN := PathLog + '\' + trim(FileName)+ '_' + inttostr(ManagerNumber)+ '_' + TwoDigit(Day) + TwoDigit(Month) +
          inttostr(Year) + '.log';
        AssignFile(F, FN);
        if FileExists(FN) then
            Append(F)
        else
            Rewrite(F);
        DateTimeToString(txt, 'dd.mm.yyyy hh:mm:ss:ms', now);
        Writeln(F, txt + ' |' + log);
      finally
        CloseFile(F);
      end
    except
      CloseFile(F);
    end;
End;

function chartohex(ch: char): byte;
begin
    case ch of
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
            result := strtoint(ch);
        'a', 'A':
            result := 10;
        'b', 'B':
            result := 11;
        'c', 'C':
            result := 12;
        'd', 'D':
            result := 13;
        'e', 'E':
            result := 14;
        'f', 'F':
            result := 15;
    end;
end;

function StrToByte(stri: string): byte;
var
    ch1, ch2: char;
begin
    ch2 := stri[1];
    ch1 := stri[2];
    result := chartohex(ch2) * 16 + chartohex(ch1);
end;

function DataToBuffIn(strd: string): integer;
var
    stri, shex: string;
    i, j: integer;
    bt: byte;
begin
    stri := trim(strd);
    if (length(stri) div 2) <> 0 then
        stri := stri + '0';
    i := 1;
    j := 0;
    while i < length(stri) do
    begin
        shex := stri[i] + stri[i + 1];
        bt := StrToByte(shex);
        InBuff[j] := ansichar(chr(bt));
        i := i + 2;
        j := j + 1;
    end;
    result := j
end;

procedure initrect(rt: TRect);
begin
    rt.left := 0;
    rt.Right := 0;
    rt.Top := 0;
    rt.Bottom := 0;
end;

function TColorToTfcolor(color: tcolor): TFColor;
// Преобразование TColor в RGB
var
    Clr: longint;
begin
    Clr := ColorToRGB(color);
    result.r := Clr;
    result.g := Clr shr 8;
    result.b := Clr shr 16;
end;

function cutstring(Text: string; len: integer): string;
begin
    result := Text;
    if length(Text) > len then
        result := copy(Text, 1, len - 3) + '...';
end;

procedure Delay(const AMilliseconds: Cardinal);
var
    SaveTickCount: Cardinal;
begin
    SaveTickCount := GetTickCount;
    repeat
        application.ProcessMessages;
    until GetTickCount - SaveTickCount > AMilliseconds;
end;

function TimeCodeDelta: Double;
begin
    result := 0;
    if MySinhro = chltc then
        result := MyShift;
end;

function UserExists(User, Pass: string): boolean;
begin
    result := false;
    if (User = 'Demo') and (Pass = 'Demo') then
        result := true;
end;

function CalcTextExtent(DCHandle: integer; Text: string): TSize;
var
    CharFSize: TABCFloat;
begin
    try
        result.cx := 0;
        result.cy := 0;
        if Text = '' then
            exit;
        GetTextExtentPoint32(DCHandle, PChar(Text), length(Text), result);
        GetCharABCWidthsFloat(DCHandle, Ord(Text[length(Text)]),
          Ord(Text[length(Text)]), CharFSize);
        if CharFSize.abcfC < 0 then
            result.cx := result.cx + Trunc(Abs(CharFSize.abcfC));
    except
        // on E: Exception do WriteLog('MAIN', 'UCommon.CalcTextExtent Text=' + Text + ' | ' + E.Message);
    end;
end;

function CalcTextWidth(DCHandle: integer; Text: string): integer;
begin
    try
        result := CalcTextExtent(DCHandle, Text).cx;
    except
        // on E: Exception do WriteLog('MAIN', 'UCommon.CalcTextWidth Text=' + Text + ' | ' + E.Message);
    end;
end;

procedure TemplateToScreen(crpos: TEventReplay);
begin

end;

procedure MyTextRect(var cv: tcanvas; const rect: TRect; Text: string);
var
    LR: TLogFont;
    FHOld, FHNew: HFONT;
    wdth, fntsz, sz, sz1, szc, sz2, szm: integer;
    size: TSize;
    pr: integer;
    s, s1, s2: string;
    bmp: tbitmap;
begin
    if length(Text) <= 0 then
        exit;
    bmp := tbitmap.Create;
    try
        try
            bmp.width := rect.Right - rect.left;
            bmp.height := rect.Bottom - rect.Top;
            bmp.Canvas.Brush.Style := bsSolid;
            bmp.Canvas.CopyRect(bmp.Canvas.ClipRect, cv, rect);
            bmp.Canvas.Font.Assign(cv.Font);
            wdth := rect.Right - rect.left;
            GetObject(bmp.Canvas.Font.Handle, SizeOf(LR), Addr(LR));
            LR.lfHeight := rect.Bottom - rect.Top;

            szm := (wdth - length(Text)) div length(Text);
            LR.lfWidth := szm;
            FHNew := CreateFontIndirect(LR);
            FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
            szc := bmp.Canvas.TextWidth(Text);
            FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
            DeleteObject(FHNew);

            if szc <= wdth then
            begin
                for sz := szm to 50 do
                begin
                    LR.lfWidth := sz;
                    FHNew := CreateFontIndirect(LR);
                    FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
                    szc := bmp.Canvas.TextWidth(Text);
                    FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
                    DeleteObject(FHNew);
                    if szc > wdth then
                    begin
                        LR.lfWidth := sz - 1;
                        FHNew := CreateFontIndirect(LR);
                        FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
                        szc := bmp.Canvas.TextWidth(Text);
                        break;
                    end;
                end;
            end
            else
            begin
                for sz := szm downto 1 do
                begin
                    LR.lfWidth := sz;
                    FHNew := CreateFontIndirect(LR);
                    FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
                    szc := bmp.Canvas.TextWidth(Text);
                    if szc <= wdth then
                        break
                    else
                    begin
                        FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
                        DeleteObject(FHNew);
                    end;
                end;
            end;

            sz2 := wdth - szc;
            s1 := copy(Text, 1, length(Text) - sz2);
            s2 := copy(Text, length(Text) - sz2 + 1, sz2);
            bmp.Canvas.Brush.Style := bsClear;
            bmp.Canvas.TextOut(0, 0, s1);
            szc := bmp.Canvas.TextWidth(s1);
            SetTextCharacterExtra(bmp.Canvas.Handle, 1);
            bmp.Canvas.TextOut(szc, 0, s2);
            bitblt(cv.Handle, rect.left, rect.Top, rect.Right - rect.left,
              rect.Bottom - rect.Top, bmp.Canvas.Handle, 0, 0, SRCCOPY);
            SetTextCharacterExtra(bmp.Canvas.Handle, 0);
            FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
            DeleteObject(FHNew);
        finally
            bmp.Free;
            bmp := nil;
        end;
    except
        on E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.MyTextRect : Text=' + Text + ' | ' + E.Message);
            FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
            DeleteObject(FHNew);
            bmp.Free;
            bmp := nil;
        end
        else
        begin
            FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
            DeleteObject(FHNew);
            bmp.Free;
            bmp := nil;
        end;
    end;
end;

procedure LoadJpegFile(bmp: tbitmap; FileName: string);
var
    JpegIm: TJpegImage;
    wdth, hght, bwdth, bhght: integer;
    dlt: real;
begin
    try
        // WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName);
        JpegIm := TJpegImage.Create;
        try
            JpegIm.LoadFromFile(FileName);
            bmp.Assign(JpegIm);
        finally
            JpegIm.Free;
        end;
    except
        // on E: Exception do WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName + ' | ' + E.Message);
    end;
end;

function createunicumname: string;
var
    YY, MN, DD: Word;
    HH, MM, ss, MS: Word;
begin
    try
        DecodeDate(now, YY, MN, DD);
        DecodeTime(now, HH, MM, ss, MS);
        result := inttostr(YY) + inttostr(MN) + inttostr(DD) + inttostr(HH) +
          inttostr(MM) + inttostr(ss) + inttostr(MS);
        // WriteLog('MAIN', 'UCommon.createunicumname Result=' + result);
    except
        // On E : Exception do  WriteLog('MAIN', 'UCommon.createunicumname | ' + E.Message);
    end;
end;

procedure LoadBMPFromRes(cv: tcanvas; rect: TRect; width, height: integer;
  Name: string);
var
    bmp: tbitmap;
    wdth, hght, deltx, delty: integer;
    rt: TRect;
begin
    try
        if trim(name) = '' then
            exit;
        bmp := tbitmap.Create;
        bmp.LoadFromResourceName(HInstance, name);
        bmp.Transparent := true;
        rt.left := rect.left;
        rt.Right := rect.Right;
        rt.Top := rect.Top;
        rt.Bottom := rect.Bottom;
        wdth := rect.Right - rect.left;
        hght := rect.Bottom - rect.Top;
        if wdth > width then
        begin
            deltx := (wdth - width) div 2;
            rt.left := rect.left + deltx;
            rt.Right := rect.Right - deltx;
        end;
        if hght > height then
        begin
            delty := (hght - height) div 2;
            rt.Top := rect.Top + delty;
            rt.Bottom := rect.Bottom - delty;
        end;
        cv.StretchDraw(rt, bmp);
        bmp.Free;
    except
        // On E : Exception do  WriteLog('MAIN', 'UCommon.LoadBMPFromRes Name=' + Name + ' | ' + E.Message);
    end;
end;

function TwoDigit(dig: integer): string;
begin
    try
        if (dig >= 0) and (dig <= 9) then
            result := '0' + inttostr(dig)
        else
            result := inttostr(dig);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.TwoDigit | ' + E.Message);
            result := '00';
        end
        else
            result := '00';
    end;
end;

function FramesToDouble(frm: longint): Double;
var
    HH, MM, ss, FF, dlt: longint;
begin
    try
        dlt := frm div 25;
        FF := frm mod 25;
        HH := dlt div 3600;
        MM := dlt mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        result := (HH * 3600 + MM * 60 + ss) + (FF * 40 / 1000);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.FramesToDouble | ' + E.Message);
            result := 0;
        end
        else
            result := 0;
    end;
end;

function FramesToTime(frm: longint): tdatetime;
var
    HH, MM, ss, FF, dlt: longint;
begin
    try
        dlt := frm div 25;
        FF := frm mod 25;
        HH := dlt div 3600;
        MM := dlt mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        result := encodetime(HH, MM, ss, FF * 40);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.FramesToTime | ' + E.Message);
            result := 0;
        end
        else
            result := 0;
    end;
end;

function TimeToFrames(dt: tdatetime): longint;
var
    HH, MM, ss, MS: Word;
begin
    try
        DecodeTime(dt, HH, MM, ss, MS);
        result := (HH * 3600 + MM * 60 + ss) * 25 + Trunc(MS / 40);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.TimeToFrames | ' + E.Message);
            result := 0;
        end
        else
            result := 0;
    end;
end;

function TimeToTimeCodeStr(dt: tdatetime): string;
var
    HH, MM, ss, MS: Word;
begin
    try
        DecodeTime(dt, HH, MM, ss, MS);
        result := TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(ss) + ':' +
          TwoDigit(Trunc(MS / 40));
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.TimeToTimeCodeStr | ' + E.Message);
            result := '00:00:00:00';
        end
        else
            result := '00:00:00:00';
    end;
end;

// function MyTimeToStr : string;
// var HH,MM,SS,ms : word;
// dbl : double;
// begin
// try
// DecodeTime(dt,hh,mm,ss,ms);
// dbl := RoundTo(dt * 1000,-3);
// dbld2 := MyTimer.ReadTimer;
// result := FloatToStr(RoundTo((dbld2 - dbld1) * 1000, -3)) + 'ms';
// dbld1:=dbld2;
// result := FloatToStr(dt);
// TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + inttostr(ms);
// except
// On E : Exception do begin
// //WriteLog('MAIN', 'UCommon.MyTimeToStr | ' + E.Message);
// Result:='00:00:00:000';
// end else Result:='00:00:00:000';
// end;
// end;

function StrTimeCodeToFrames(tc: string): longint;
var
    HH, MM, ss, MS: Word;
    s: string;
begin
    try
        s := trim(tc);
        s := StringReplace(s, 'Старт в (', '', [rfReplaceAll, rfIgnoreCase]);
        s := StringReplace(s, ')', '', [rfReplaceAll, rfIgnoreCase]);
        HH := strtoint(s[1] + s[2]);
        MM := strtoint(s[4] + s[5]);
        ss := strtoint(s[7] + s[8]);
        MS := strtoint(s[10] + s[11]);
        result := (HH * 3600 + MM * 60 + ss) * 25 + MS;
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.StrTimeCodeToFrames TC=' + tc + ' | ' + E.Message);
            result := 0;
        end
        else
            result := 0;
    end;
end;

function FramesToStr(frm: longint): string;
var
    ZN, HH, MM, ss, FF, dlt: longint;
    znak: char;
begin
    try
        ZN := frm;
        znak := #32;
        if frm < 0 then
        begin
            znak := '-';
            ZN := -1 * ZN;
        end;
        dlt := ZN div 25;
        FF := ZN mod 25;
        HH := dlt div 3600;
        MM := dlt mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        result := trim(znak + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' +
          TwoDigit(ss) + ':' + TwoDigit(FF));
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.FramesToStr | ' + E.Message);
            result := '00:00:00:00';
        end
        else
            result := '00:00:00:00';
    end;
end;

function FramesToShortStr(frm: longint): string;
var
    HH, MM, ss, FF, dlt, fr: longint;
    st: string;
begin
    try
        if frm < 0 then
        begin
            st := '-';
            fr := -1 * frm;
        end
        else
        begin
            st := '';
            fr := frm;
        end;
        dlt := fr div 25;
        FF := fr mod 25;
        HH := dlt div 3600;
        MM := dlt mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        if HH <> 0 then
        begin
            result := st + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' +
              TwoDigit(ss) + ':' + TwoDigit(FF);
            exit;
        end;
        if MM <> 0 then
        begin
            result := st + TwoDigit(MM) + ':' + TwoDigit(ss) + ':' +
              TwoDigit(FF);
            exit;
        end;
        result := st + TwoDigit(ss) + ':' + TwoDigit(FF);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.FramesToShortStr | ' + E.Message);
            result := '00:00';
        end
        else
            result := '00:00';
    end;
end;

function SecondToStr(frm: longint): string;
var
    HH, MM, ss, FF, dlt, fr: longint;
    st: string;
begin
    try
        if frm < 0 then
        begin
            st := '-';
            fr := -1 * frm;
        end
        else
        begin
            st := '';
            fr := frm;
        end;
        HH := fr div 3600;
        MM := fr mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        if HH <> 0 then
        begin
            result := st + inttostr(HH) + ':' + TwoDigit(MM) + ':' +
              TwoDigit(ss);
            exit;
        end;
        result := st + inttostr(MM) + ':' + TwoDigit(ss);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.SecondToStr | ' + E.Message);
            result := '00:00';
        end
        else
            result := '00:00';
    end;
end;

function SecondToShortStr(frm: longint): string;
var
    HH, MM, ss, FF, dlt, fr: longint;
    st: string;
begin
    try
        if frm < 0 then
        begin
            st := '-';
            fr := -1 * frm;
        end
        else
        begin
            st := '';
            fr := frm;
        end;
        HH := fr div 3600;
        MM := fr mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        if HH <> 0 then
        begin
            result := st + inttostr(HH) + ':' + TwoDigit(MM) + ':' +
              TwoDigit(ss);
            exit;
        end;
        if MM <> 0 then
        begin
            result := st + inttostr(MM) + ':' + TwoDigit(ss);
            exit;
        end;
        result := st + ':' + TwoDigit(ss);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.SecondToShortStr | ' + E.Message);
            result := '00:00';
        end
        else
            result := '00:00';
    end;
end;

function MyDoubleToSTime(db: Double): string;
var
    HH, MM, ss, FF, dlt: longint;
begin
    try
        dlt := Trunc(db);
        FF := Trunc((db - dlt) * 1000 / 40);
        HH := dlt div 3600;
        MM := dlt mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        result := TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(ss) + ':' +
          TwoDigit(FF);
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.MyDoubleToSTime | ' + E.Message);
            result := '00:00:00:00';
        end
        else
            result := '00:00:00:00';
    end;
end;

function MyDoubleToFrame(db: Double): longint;
var
    HH, MM, ss, FF, dlt: longint;
begin
    try
        dlt := Trunc(db);
        FF := Trunc((db - dlt) * 1000 / 40);
        HH := dlt div 3600;
        MM := dlt mod 3600;
        ss := MM mod 60;
        MM := MM div 60;
        result := (HH * 3600 + MM * 60 + ss) * 25 + FF;
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.MyDoubleToFrame | ' + E.Message);
            result := 0;
        end
        else
            result := 0;
    end;
end;

function MyDateTimeToStr(tm: tdatetime): string;
var
    Hour, Min, Sec, MSec: Word;
begin
    try
        DecodeTime(tm, Hour, Min, Sec, MSec);
        result := TwoDigit(Hour) + ':' + TwoDigit(Min) + ':' + TwoDigit(Sec) +
          ':' + TwoDigit(Trunc(MSec / 40));
    except
        On E: Exception do
        begin
            // WriteLog('MAIN', 'UCommon.MyDateTimeToStr | ' + E.Message);
            result := '00:00:00:00';
        end
        else
            result := '00:00:00:00';
    end;
end;

Function DefineFontSizeW(cv: tcanvas; width: integer; txt: string): integer;
var
    fntsz, sz: integer;
    bmp: tbitmap;
begin
    try
        bmp := tbitmap.Create;
        try
            result := 0;
            if bmp.Canvas.Font.size = 0 then
                bmp.Canvas.Font.size := 40;
            fntsz := cv.Font.size;
            For sz := fntsz downto 5 do
            begin
                bmp.Canvas.Font.size := sz;
                if bmp.Canvas.TextWidth(txt) < width - 4 then
                    break;
            end;
            result := sz;
            // cv.Font.Size:=fntsz;
        finally
            bmp.Free;
        end;
    except
        // On E : Exception do WriteLog('MAIN', 'UCommon.DefineFontSizeW | ' + E.Message);
    end;
end;

Function DefineFontSizeH(cv: tcanvas; height: integer): integer;
var
    fntsz, sz: integer;
    bmp: tbitmap;
begin
    try
        bmp := tbitmap.Create;
        try
            result := 0;
            // fntsz:=cv.Font.Size;
            // cv.Font.Size:=40;
            For sz := 40 downto 5 do
            begin
                bmp.Canvas.Font.size := sz;
                if bmp.Canvas.TextHeight('0') < height - 2 then
                    break;
            end;
            result := sz;
            // cv.Font.Size:=fntsz;
        finally
            bmp.Free;
        end;
    except
        // On E : Exception do WriteLog('MAIN', 'UCommon.DefineFontSizeH | ' + E.Message);
    end;
end;

function SmoothColor(color: tcolor; step: integer): tcolor;
var
    cColor: longint;
    r, g, b: byte;
    ZN: integer;
    rm, gm, bm: byte;
begin
    try
        cColor := ColorToRGB(color);
        r := cColor and $FF;
        g := (cColor shr 8) and $FF;
        b := (cColor shr 16) and $FF;

        if (r >= g) and (r >= b) then
        begin
            if (r + step) <= 255 then
            begin
                r := r + step;
                g := g + step;
                b := b + step;
            end
            else
            begin
                if r - step > 0 then
                    r := r - step
                else
                    r := 0;
                if g - step > 0 then
                    g := g - step
                else
                    g := 0;
                if b - step > 0 then
                    b := b - step
                else
                    b := 0;
            end;
            result := RGB(r, g, b);
            exit;
        end;

        if (g >= r) and (g >= b) then
        begin
            if (g + step) <= 255 then
            begin
                r := r + step;
                g := g + step;
                b := b + step;
            end
            else
            begin
                if r - step > 0 then
                    r := r - step
                else
                    r := 0;
                if g - step > 0 then
                    g := g - step
                else
                    g := 0;
                if b - step > 0 then
                    b := b - step
                else
                    b := 0;
            end;
            result := RGB(r, g, b);
            exit;
        end;

        if (b >= r) and (b >= g) then
        begin
            if (b + step) <= 255 then
            begin
                r := r + step;
                g := g + step;
                b := b + step;
            end
            else
            begin
                if r - step > 0 then
                    r := r - step
                else
                    r := 0;
                if g - step > 0 then
                    g := g - step
                else
                    g := 0;
                if b - step > 0 then
                    b := b - step
                else
                    b := 0;
            end;
            result := RGB(r, g, b);
            exit;
        end;
    except
        // On E : Exception do WriteLog('MAIN', 'UCommon.SmoothColor | ' + E.Message);
    end;
end;

initialization

ListComports := TStringList.Create;
ListComports.Clear;

finalization

ListComports.Free;
ListComports := nil;

end.
