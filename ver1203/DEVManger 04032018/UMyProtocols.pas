unit UMyProtocols;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
    Vcl.StdCtrls,
    utimeline, Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend,
    StrUtils, umyevents;

type
    TMyIndex = class
        Source: string; // main, param,optvalue,optname
        Param: string; //
        Phrase: string;
        TypePhrase: string;
        Index: TMyIndex;
        function GetStr(evpos: integer): string;
        procedure Assign(TMI: TMyIndex);
        constructor create(srcstr: string); overload;
        constructor create; overload;
        destructor destroy;
    end;

    TOneField = class
        TypeField: string;
        // byte, hbyte, lbyte, bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7
        TypeData: string; // main, param, phrase, value, optvalue, optname
        VarData: string; // hundres, tens, ones
        Param: string; // Имя параметра или шестндцатиричное значение
        Phrase: string; // Имя фразы в событии
        TypePhrase: string; // Название поля фразы, где храняться данные
        Index: TMyIndex;
        function GetValue(evpos: integer): string;
        Constructor create;
        destructor destroy;
    end;

    // hbyte.dec.nextevnt.tens.Duration(Data)
    TOneByte = class
        Count: integer;
        Fields: array of TOneField;
        function Add: integer;
        function GetValue(evpos: integer): string;
        // procedure SetString(stri : string);
        procedure clear;
        procedure Assign(TOB: TOneByte);
        constructor create;
        destructor destroy;
    end;

    TOneCommand = class
        Name: string;
        Count: integer;
        Bytes: array of TOneByte;
        Command: string;
        // function GetString : string;
        // procedure GetListString(lst : tstrings);
        function Add: integer;
        procedure SetString(stri: string; TypeData: string);
        procedure Assign(TOC: TOneCommand);
        function GetValue(evpos: integer; TypeData: string): string;
        function GetCommand(evpos : integer): string;
        procedure clear;
        constructor create;
        destructor destroy;
    end;

    TVarCase = class
        CaseName: string;
        List: tstrings;
        // function GetString : string;
        // procedure GetListString(lst : tstrings);
        // procedure SetString(stri : string);
        function Add(Name: string): integer;
        procedure Assign(TVC: TVarCase);
        procedure clear;
        constructor create(NCase: string);
        destructor destroy;
    end;

    TCommands = class
        CMDType: integer; // 0-List, 1-Case
        Condition: TMyIndex;
        Count: integer;
        CaseItems: array of TVarCase;
        // function Add(Name : string) : integer;
        procedure Assign(TC: TCommands);
        procedure clear;
        procedure SetString(stri, SName: string);
        procedure GetListCommands(evpos : integer; lst: tstrings);
        constructor create;
        destructor destroy;
    end;

    TCommandTemplates = class
        TypeData: string;
        BeforeStr: string;
        AfterStr: string;
        StartCommand: string;
        FinishCommand: string;
        CMDCount: integer;
        CommandsList: array of TOneCommand;
        CMDPaused: TCommands;
        CMDStart: TCommands;
        CMDTransition: TCommands;
        CMDFinish: TCommands;
        // procedure GetListString(lst : tstrings);
        Procedure SetCMDString(stri: string);
        Procedure clear;
        function AddCMD(Name: string): integer;
        procedure Assign(TCT: TCommandTemplates);
        function GetCommand(cmd: string; evpos : integer): string;
        procedure GetCMDPaused(evpos : integer; lst: tstrings);
        procedure GetCMDStart(evpos : integer; lst: tstrings);
        procedure GetCMDTransition(evpos : integer; lst: tstrings);
        procedure GetCMDFinish(evpos : integer; lst: tstrings);
        procedure SetString(stri: string);
        constructor create;
        destructor destroy;
    end;

    TOneStringTable = class
        Name: string;
        Text: string;
        procedure Assign(TST: TOneStringTable);
        constructor create(SName, SText: string);
        destructor destroy;
    end;

    TListParams = class
        Name: string;
        Count: integer;
        List: array of TOneStringTable;
        function GetString: string;
        procedure GetListString(lst: tstrings);
        procedure SetString(stri: string);
        procedure Assign(TLP: TListParams);
        procedure clear;
        constructor create;
        destructor destroy;
    end;

    TInputProtocol = class
        Count: integer;
        List: array of TOneStringTable;
        // function GetString : string;
        // procedure GetListString(lst : tstrings);
        procedure SetString(stri, lstname: string);
        function GetValue(SName: string): string;
        procedure Assign(TIP: TInputProtocol);
        procedure clear;
        constructor create;
        destructor destroy;
    end;

    TProtocolParams = class
        Count: integer;
        Params: array of TListParams;
        function GetString: string;
        procedure GetListString(lst: tstrings);
        procedure SetString(stri: string);
        function Add(SName: string): integer;
        function GetValue(PName, SName: string): string;
        procedure Assign(TPP: TProtocolParams);
        procedure clear;
        constructor create;
        destructor destroy;
    end;

    TOneProtocol = class
        Protocol: string;
        Main: TInputProtocol;
        Options: TInputProtocol;
        CMDTemplates: TCommandTemplates;
        ProtocolMain: TProtocolParams;
        ProtocolAdd: TProtocolParams;
        // function GetString : string;
        procedure GetListString(lst: tstrings);
        procedure SetString(stri: string);
        procedure AssignPart(TOPR: TOneProtocol);
        procedure Assign(TOPR: TOneProtocol);
        constructor create;
        destructor destroy;
    end;

    TFirmDevice = class
        Index: integer;
        Device: string;
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
        Index: integer;
        Vendor: string;
        Count: integer;
        FirmDevices: array of TFirmDevice;
        function Add(Name: string): integer;
        function IndexOf(Name: string): integer;
        function GetString: string;
        procedure GetListString(lst: tstrings);
        procedure SetString(stri: string);
        procedure clear;
        constructor create;
        destructor destroy;
    end;

    TTypeDevice = class
        Index: integer;
        TypeDevice: string;
        Count: integer;
        Vendors: Array of TVendors;
        function Add(SName: string): integer;
        function IndexOf(Name: string): integer;
        function GetString: string;
        procedure GetListString(lst: tstrings);
        procedure SetString(srcstr: string);
        procedure clear;
        constructor create;
        destructor destroy;
    end;

    TListTypeDevices = class
        Index: integer;
        Count: integer;
        TypeDevices: array of TTypeDevice;
        function Add(Name: string): integer;
        function IndexOf(Name: string): integer;
        function GetString: string;
        procedure GetListString(lst: tstrings);
        procedure SetString(srcstr: string);
        procedure LoadFromFile(FileName, TypeDevices: string);
        procedure SaveToFile(FileName, TypeDevices: string);
        procedure clear;
        procedure GetProtocol(TypeDevice, Vendor, Device, Prot: string;
          Protocol: TOneProtocol);
        constructor create;
        destructor destroy;
    end;

Procedure LoadProtocol(FileName, TypeTL, TypeDevice, Vendor, Device,
  Protocol: string);

Var
    ListTypeDevices: TListTypeDevices;
    MyProtocol: TOneProtocol;
    ListCommands: tstrings;

implementation

uses umain, ucommon, UGRTimelines;

Procedure LoadProtocol(FileName, TypeTL, TypeDevice, Vendor, Device,
  Protocol: string);
begin
    try
        if ListTypeDevices=nil then begin
          ListTypeDevices := TListTypeDevices.create;
          ListTypeDevices.LoadFromFile(FileName, TypeTL);
        end;
        ListTypeDevices.GetProtocol(TypeDevice, Vendor, Device, Protocol,
          MyProtocol);
    finally
        ListTypeDevices.FreeInstance;
        ListTypeDevices := nil
    end;
end;

function GetCommandValue(evpos: integer; Source, Param, Phrase, TypePhrase,
  Index: string): string;
var
    sindx, sphr, stph, stmp: string;
    indx: integer;
begin
<<<<<<< HEAD
  try
=======
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    result := '';
    sindx := Index;

    if MyProtocol = nil then
        exit;
    if Source = 'value' then
        result := Param
    else if Source = 'main' then
    begin
        if sindx = '' then
        begin
            stmp := MyProtocol.Main.GetValue(Param);
            result := MyProtocol.ProtocolMain.GetValue(Param, stmp);
        end
        else
        begin
            result := MyProtocol.ProtocolMain.GetValue(Param, sindx);
        end;
    end
    else if Source = 'param' then
    begin
        if sindx <> '' then
        begin
            result := MyProtocol.ProtocolAdd.GetValue(Param, sindx);
        end;
    end
    else if Source = 'tldata' then
    begin
        indx := MyStrToInt(sindx);
<<<<<<< HEAD
        if (indx = -1) or (indx > MyProtocol.Options.Count-1) then
=======
        if indx = -1 then
>>>>>>> 567489eb579fa25cb906471546da671d36020444
            exit;
        if ansilowercase(trim(Param)) = 'name' then
            result := MyProtocol.Options.List[indx].Name
        else if ansilowercase(trim(Param)) = 'value' then
            result := MyProtocol.Options.List[indx - 1].Text;
    end
    else if Source = 'phrase' then
    begin
        if MyTLEdit.Events[evpos] = nil then
        begin
            result := '00';
            exit;
        end;
        stph := ansilowercase(trim(TypePhrase));
        if stph = 'text' then
            result := MyTLEdit.Events[evpos].ReadPhraseText(Phrase)
        else if stph = 'data' then
            result := inttostr(MyTLEdit.Events[evpos].ReadPhraseData(Phrase))
        else if stph = 'command' then
            result := MyTLEdit.Events[evpos].ReadPhraseCommand(Phrase)
        else if stph = 'tag' then
            result := inttostr(MyTLEdit.Events[evpos].ReadPhraseTag(Phrase))
        else if stph = 'type' then
            result := MyTLEdit.Events[evpos].ReadPhraseType(Phrase)
        else if stph = 'listname' then
            result := MyTLEdit.Events[evpos].ReadPhraseListName(Phrase)
    end;
    WriteLog('Translator', 'GetCommandValue: Source=' + Source + ' Param=' +
      Param + ' Phrase=' + Phrase + 'TypePhrase=' + TypePhrase + ' Index' +
      Index + 'Result=' + result);
<<<<<<< HEAD
  except
    WriteLog('Translator', 'Error GetCommandValue: Source=' + Source + ' Param=' +
      Param + ' Phrase=' + Phrase + 'TypePhrase=' + TypePhrase + ' Index' +
      Index + 'Result=' + result);
  end;
=======
>>>>>>> 567489eb579fa25cb906471546da671d36020444
end;

function SetSpace(Count: integer): string;
var
    i: integer;
begin
    result := '';
    for i := 0 to Count - 1 do
        result := result + ' ';
end;

constructor TInputProtocol.create;
begin
    Count := 0;
end;

constructor TOneByte.create;
begin
    Count := 0;
end;

procedure TOneByte.clear;
var
    i: integer;
begin
    for i := Count - 1 downto 0 do
    begin
        Fields[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Fields, Count);
    end;
    Count := 0;
end;

procedure TOneByte.Assign(TOB: TOneByte);
var
    i: integer;
begin
    clear;
    for i := 0 to TOB.Count - 1 do
    begin
        Count := Count + 1;
        setlength(Fields, Count);
        Fields[Count - 1] := TOneField.create;
        Fields[Count - 1].TypeField := TOB.Fields[i].TypeField;
        Fields[Count - 1].TypeData := TOB.Fields[i].TypeData;
        Fields[Count - 1].VarData := TOB.Fields[i].VarData;
        Fields[Count - 1].Param := TOB.Fields[i].Param;
        Fields[Count - 1].Phrase := TOB.Fields[i].Phrase;
        Fields[Count - 1].TypePhrase := TOB.Fields[i].TypePhrase;
        if Fields[Count - 1].Index <> nil then
        begin
            Fields[Count - 1].Index.FreeInstance;
            Fields[Count - 1].Index := nil;
        end;
        if TOB.Fields[i].Index <> nil then
        begin
            Fields[Count - 1].Index := TMyIndex.create;
            Fields[Count - 1].Index.Assign(TOB.Fields[i].Index);
        end;
    end;
end;

destructor TOneByte.destroy;
begin
    clear;
    freemem(@Count);
    freemem(@Fields);
end;

function TOneByte.Add: integer;
begin
    Count := Count + 1;
    setlength(Fields, Count);
    Fields[Count - 1] := TOneField.create;
    result := Count - 1;
end;

function TOneByte.GetValue(evpos: integer): string;
var
    i, res: integer;
    sindx, btstr, svar: string;
    ch: ansichar;
    bt: byte;
begin
    result := '00';

    WriteLog('Translator', 'TOneByte.GetValue Start');

    for i := 0 to Count - 1 do
    begin
        if Fields[i].Index = nil then
            sindx := ''
        else
            sindx := Fields[i].Index.GetStr(evpos);
        btstr := GetCommandValue(evpos, Fields[i].TypeData, Fields[i].Param,
          Fields[i].Phrase, Fields[i].TypePhrase, sindx);

        WriteLog('Translator', 'TOneByte.GetValue Field=' + inttostr(i) +
          ' TypeField=' + Fields[i].TypeField + ' VarData=' +
          Fields[i].VarData);

        if trim(Fields[i].VarData) <> '' then
            btstr := GetDigit(btstr, Fields[i].VarData);
        if trim(btstr) = '' then
            btstr := '00';

        if Fields[i].TypeField = 'byte' then
        begin
            if length(trim(btstr)) = 1 then
                result := '0' + trim(btstr)
            else
                result := btstr;
        end
        else if Fields[i].TypeField = 'hbyte' then
        begin
            result[1] := btstr[length(btstr)];
        end
        else if Fields[i].TypeField = 'lbyte' then
        begin
            result[2] := btstr[length(btstr)];
        end
        else if Fields[i].TypeField = 'bit0' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $01
            else
                bt := bt and $FE;
            result := inttohex(bt);
        end
        else if Fields[i].TypeField = 'bit1' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $02
            else
                bt := bt and $FD;
            result := inttohex(bt);
        end
        else if Fields[i].TypeField = 'bit2' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $04
            else
                bt := bt and $FB;
            result := inttohex(bt);
        end
        else if Fields[i].TypeField = 'bit3' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $08
            else
                bt := bt and $F7;
            result := inttohex(bt);
        end
        else if Fields[i].TypeField = 'bit4' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $10
            else
                bt := bt and $EF;
            result := inttohex(bt);
        end
        else if Fields[i].TypeField = 'bit5' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $20
            else
                bt := bt and $DF;
            result := inttohex(bt);
        end
        else if Fields[i].TypeField = 'bit6' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $40
            else
                bt := bt and $BF;
            result := inttohex(bt);
        end
        else if Fields[i].TypeField = 'bit7' then
        begin
            bt := StrToByte(result);
            res := MyStrToInt(btstr);
            if res > 0 then
                bt := bt or $80
            else
                bt := bt and $7F;
            result := inttohex(bt);
        end;
    end;
    WriteLog('Translator', 'TOneByte.GetValue  Result=' + result);
end;
// procedure TOneByte.SetString(stri : string);

procedure TInputProtocol.clear;
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

procedure TInputProtocol.Assign(TIP: TInputProtocol);
var
    i: integer;
begin
    clear;
    for i := 0 to TIP.Count - 1 do
    begin
        Count := Count + 1;
        setlength(List, Count);
        List[Count - 1] := TOneStringTable.create(TIP.List[i].Name,
          TIP.List[i].Text);
    end;
end;

destructor TInputProtocol.destroy;
begin
    clear;
    freemem(@Count);
    freemem(@List);
end;

procedure TInputProtocol.SetString(stri, lstname: string);
var
    sparam, scount: string;
    i, j, k, cnt, sind: integer;
    res, srng: TListParam;
    rng: TRangeParam;
begin
    clear;
    Count := 0;
    sparam := StringReplace(stri, '<' + trim(lstname) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    sparam := StringReplace(sparam, '</' + trim(lstname) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    // sparam := GetProtocolsStr(stri, 'MainOptions');
    scount := GetProtocolsParam(sparam, 'Count');
    if trim(scount) <> '' then
    begin
        cnt := strtoint(scount);
        for i := 0 to cnt - 1 do
        begin
            res := GetProtocolsParamIn(sparam, i + 1);
            Count := Count + 1;
            setlength(List, Count);
            List[Count - 1] := TOneStringTable.create(res.Name, res.Text);
        end;
    end;
end;

function TInputProtocol.GetValue(SName: string): string;
var
    i: integer;
begin
    result := '';
    for i := 0 to Count - 1 do
    begin
        if ansilowercase(trim(List[i].Name)) = ansilowercase(trim(SName)) then
        begin
            result := List[i].Text;
            exit;
        end;
    end;
end;

constructor TOneCommand.create;
begin
    Name := '';
    Count := 0;
    Command := '';
end;

procedure TOneCommand.clear;
var
    i: integer;
begin
    Command := '';
    // Name := '';
    for i := Count - 1 downto 0 do
    begin
        Bytes[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Bytes, Count);
    end;
    Count := 0;
end;

function TOneCommand.GetValue(evpos: integer; TypeData: string): string;
var
    i: integer;
begin
    result := '';
    if (trim(TypeData) = '0') or (trim(TypeData) = '1') then
        for i := 0 to Count - 1 do
            result := result + Bytes[i].GetValue(evpos)
    else
        result := GetCommand(evpos); // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
end;

function TOneCommand.GetCommand(evpos: integer): string;
var
    i, j: integer;
    Data: TMyIndex;
    cmd, cmds, cmde, ss: string;
    pss, pse: integer;
begin
    result := '';
    try
        ss := Command;
        pss := posex('@#', ss, 1);
        pse := posex('#@', ss, pss);
        while (pss <> 0) or (pse <> 0) do
        begin
            cmd := Copy(ss, pss + 2, pse - 1);
            cmds := Copy(ss, 1, pss - 1);
            cmde := Copy(ss, pse + 2, length(ss));
            if Data <> nil then
            begin
                Data.FreeInstance;
                Data := nil
            end;
            Data := TMyIndex.create(cmd);
            cmd := Data.GetStr(evpos);
            ss := cmds + cmd + cmde;
            pss := posex('@#', ss, 1);
            pse := posex('#@', ss, pss);
        end;
        if Data <> nil then
        begin
            Data.FreeInstance;
            Data := nil
        end;
        result := ss;
    finally
    end;
end;

procedure TOneCommand.Assign(TOC: TOneCommand);
var
    i: integer;
begin
    clear;
    Name := TOC.Name;
    Command := TOC.Command;
    for i := 0 to TOC.Count - 1 do
    begin
        Count := Count + 1;
        setlength(Bytes, Count);
        Bytes[Count - 1] := TOneByte.create;
        Bytes[Count - 1].Assign(TOC.Bytes[i]);
    end;
end;

destructor TOneCommand.destroy;
begin
    freemem(@Name);
    freemem(@Command);
    clear;
    freemem(@Count);
    freemem(@Bytes);
end;

function TOneCommand.Add: integer;
begin
    Count := Count + 1;
    setlength(Bytes, Count);
    Bytes[Count - 1] := TOneByte.create;
    // Bytes[Count-1].:=Name;
    result := Count - 1;
end;

procedure TOneCommand.SetString(stri: string; TypeData: string);
var
    sparam, scount, stxt, stmp, sprm, slnk: string;
    i, j, k, ic, rwbts, rwfld, rwind, cnt, sind: integer;
    res, srng: TListParam;
    rng: TRangeParam;
    lst, alst: tstrings;
    cmd: array [0 .. 4] of string;
begin
    clear;
    Count := 0;
    sparam := StringReplace(stri, '<Command=' + trim(Name) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    sparam := StringReplace(sparam, '</Command=' + trim(Name) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    if trim(TypeData) = '2' then
    begin
        Command := sparam;
        exit;
    end;

    // sparam := GetProtocolsStr(stri, 'MainOptions');
    scount := GetProtocolsParam(sparam, 'Count');
    if trim(scount) <> '' then
    begin
        cnt := strtoint(scount);
        lst := tstringlist.create;
        try
            alst := tstringlist.create;
            try
                for i := 0 to cnt - 1 do
                begin
                    rwbts := Add; // Command
                    stxt := GetProtocolsParam(sparam, inttostr(i));
                    alst.clear;
                    GetListParam(stxt, alst);
                    for j := 0 to alst.Count - 1 do
                    begin
                        rwfld := Bytes[rwbts].Add;
                        lst.clear;
                        // ReadCommandField(alst.Strings[j], lst);
                        SeparationString(alst.Strings[j], lst);
                        for ic := 0 to 4 do
                            cmd[ic] := '';
                        if lst.Count > 5 then
                            sind := 5
                        else
                            sind := lst.Count;
                        for ic := 0 to sind - 1 do
                            cmd[ic] := trim(lst.Strings[ic]);
                        Bytes[rwbts].Fields[rwfld].TypeField :=
                          ansilowercase(cmd[0]);
                        Bytes[rwbts].Fields[rwfld].TypeData :=
                          ansilowercase(cmd[1]);
                        if Bytes[rwbts].Fields[rwfld].TypeData = 'phrase' then
                        begin
                            res := PhraseParam(cmd[2]);
                            Bytes[rwbts].Fields[rwfld].Phrase := res.Name;
                            Bytes[rwbts].Fields[rwfld].TypePhrase := res.Text;
                        end
                        else
                            Bytes[rwbts].Fields[rwfld].Param := trim(cmd[2]);

                        slnk := cmd[3];
                        if slnk <> '' then
                        begin
                            if slnk[1] = '[' then
                            begin
                                slnk := Copy(slnk, 2, length(slnk));
                                if slnk[length(slnk)] = ']' then
                                    slnk := Copy(slnk, 1, length(slnk) - 1);
                                if Bytes[rwbts].Fields[rwfld].Index <> nil then
                                begin
                                    Bytes[rwbts].Fields[rwfld].
                                      Index.FreeInstance;
                                    Bytes[rwbts].Fields[rwfld].Index := nil;
                                end;
                                Bytes[rwbts].Fields[rwfld].Index :=
                                  TMyIndex.create(slnk);
                            end
                            else
                            begin
                                slnk := ansilowercase(slnk);
                                if (slnk = 'thousands') or (slnk = 'hundres') or
                                  (slnk = 'tens') or (slnk = 'ones') then
                                    Bytes[rwbts].Fields[rwfld].VarData := slnk;
                            end;
                        end;

                        if cmd[4] <> '' then
                            Bytes[rwbts].Fields[rwfld].VarData := cmd[4];

                    end;
                end;
            finally
                alst.free;
            end;
        finally
            lst.free;
        end;
    end;
end;

constructor TCommandTemplates.create;
begin
    TypeData := '0';
    BeforeStr := '';
    AfterStr := '';
    StartCommand := '';
    FinishCommand := '';
    CMDCount := 0;
    // CommandsList : array of TOneCommand;
    CMDPaused := TCommands.create;
    CMDStart := TCommands.create;
    CMDTransition := TCommands.create;
    CMDFinish := TCommands.create;
end;

Procedure TCommandTemplates.clear;
var
    i: integer;
begin
    for i := CMDCount - 1 downto 0 do
    begin
        CommandsList[CMDCount - 1].FreeInstance;
        CMDCount := CMDCount - 1;
        setlength(CommandsList, CMDCount);
    end;
    CMDCount := 0;
    CMDPaused.clear;
    CMDStart.clear;
    CMDTransition.clear;
    CMDFinish.clear;
end;

destructor TCommandTemplates.destroy;
begin
    freemem(@TypeData);
    freemem(@BeforeStr);
    freemem(@AfterStr);
    freemem(@StartCommand);
    freemem(@FinishCommand);
    clear;
    freemem(@CMDCount);
    freemem(@CommandsList);
    freemem(@CMDPaused);
    freemem(@CMDStart);
    freemem(@CMDTransition);
    freemem(@CMDFinish);
end;

function TCommandTemplates.AddCMD(Name: string): integer;
begin
    CMDCount := CMDCount + 1;
    setlength(CommandsList, CMDCount);
    CommandsList[CMDCount - 1] := TOneCommand.create;
    CommandsList[CMDCount - 1].Name := Name;
    result := CMDCount - 1;
end;

Procedure TCommandTemplates.SetCMDString(stri: string);
var
    i, rw: integer;
    sprotocols: string;
    lst: tstrings;
begin
    lst := tstringlist.create;
    try
        lst.clear;
        GetProtocolsList(stri, 'Command=', lst);
        clear;
        if lst.Count > 0 then
        begin
            for i := 0 to lst.Count - 1 do
            begin
                rw := AddCMD(trim(lst.Strings[i]));
                CommandsList[rw].Name := trim(lst.Strings[i]);
                sprotocols := GetProtocolsStr(stri,
                  'Command=' + trim(lst.Strings[i]));
                CommandsList[rw].SetString(sprotocols, TypeData);
            end;
        end
        else
        begin
            // rw := Add('');
            // sprotocols := GetProtocolsStr(stri, 'Protocol='+trim(lst.Strings[i]));
            // FirmDevices[rw].SetString(stri);
        end;
    finally
        lst.free;
    end;
end;

procedure TCommandTemplates.SetString(stri: string);
var
    ss: string;
begin
    ss := GetProtocolsStr(stri, 'CommandOptions');
    TypeData := GetProtocolsParam(ss, 'TypeData');
    BeforeStr := GetProtocolsParam(ss, 'BeforeStr');
    AfterStr := GetProtocolsParam(ss, 'AfterStr');
    StartCommand := GetProtocolsParam(ss, 'StartCommand');
    FinishCommand := GetProtocolsParam(ss, 'FinishCommand');
    ss := GetProtocolsStr(stri, 'CommandsList');
    SetCMDString(ss);
    ss := GetProtocolsStr(stri, 'CommandsPaused');
    CMDPaused.SetString(ss, 'CommandsPaused');
    ss := GetProtocolsStr(stri, 'CommandsStart');
    CMDStart.SetString(ss, 'CommandsStart');
    ss := GetProtocolsStr(stri, 'CommandsTransition');
    CMDTransition.SetString(ss, 'CommandsTransition');
    ss := GetProtocolsStr(stri, 'CommandsFinish');
    CMDFinish.SetString(ss, 'CommandsFinish');
end;

function TCommandTemplates.GetCommand(cmd: string; evpos : integer): string;
var
    i: integer;
begin
    WriteLog('Translator',
      'TCommandTemplates.GetCommand  Start Command=' + cmd);
    for i := 0 to CMDCount - 1 do
    begin
        if ansilowercase(trim(CommandsList[i].Name)) = ansilowercase(trim(cmd))
        then
        begin
            result := CommandsList[i].GetValue(evpos, TypeData);
            WriteLog('Translator', 'TCommandTemplates.GetCommand  Command=' +
              cmd + ' Result=' + result);
            exit;
        end;
    end;
    WriteLog('Translator', 'TCommandTemplates.GetCommand  Finish');
end;

procedure TCommandTemplates.GetCMDPaused(evpos : integer; lst: tstrings);
var clst: tstrings;
    i, j : integer;
<<<<<<< HEAD
    cmd, stmp, scmd, sevnt : string;
=======
    stmp, scmd, sevnt : string;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    pss, pse, evnt : integer;
begin
    WriteLog('Translator', 'TCommandTemplates.GetCMDPaused  Start');
    try
        clst := tstringlist.create;
        clst.clear;
        try
            CMDPaused.GetListCommands(evpos, clst);
            lst.clear;
            for i := 0 to clst.Count - 1 do
            begin
              stmp := clst.Strings[i];
              evnt := evpos;
              pss := posex('[',stmp,1);
              if pss<>0 then begin
                scmd := copy(stmp,1,pss-1);
                sevnt := copy(stmp,pss+1,length(stmp));
                pss := posex(']',sevnt,1);
                if pss<>0 then sevnt:=copy(sevnt,1,pss-1);
                pss := posex('+',sevnt,1);
                pse := posex('-',sevnt,1);
                if (pss<>0) then begin
                  stmp := trim(copy(sevnt,pss+1,length(sevnt)));
                  if stmp<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos+strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end else if (pse<>0) then begin
                  stmp := copy(sevnt,pse+1,length(sevnt));
                  if trim(stmp)<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos-strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end;
              end else scmd:=stmp;
              if evnt > MyTLEdit.Count-1 then evnt:=MyTLEdit.Count-1;
<<<<<<< HEAD
              cmd := GetCommand(scmd, evnt);
              if cmd<>'' then begin
                cmd := BeforeStr + GetCommand(scmd, evnt) + AfterStr;
                lst.Add(cmd);
              end;
=======
              lst.Add(GetCommand(scmd, evnt));
>>>>>>> 567489eb579fa25cb906471546da671d36020444
            end;
        finally
            clst.free;
        end;
        WriteLog('Translator', 'TCommandTemplates.GetCMDPaused  Finish');
    except
        WriteLog('Translator', 'TCommandTemplates.GetCMDPaused  Error');
    end;
end;

procedure TCommandTemplates.GetCMDStart(evpos : integer; lst: tstrings);
var clst: tstrings;
    i, j : integer;
<<<<<<< HEAD
    cmd, stmp, scmd, sevnt : string;
=======
    stmp, scmd, sevnt : string;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    pss, pse, evnt : integer;
begin
    WriteLog('Translator', 'TCommandTemplates.GetCMDStart  Start');
    try
        clst := tstringlist.create;
        clst.clear;
        try
            CMDStart.GetListCommands(evpos, clst);
            lst.clear;
            for i := 0 to clst.Count - 1 do
            begin
              stmp := clst.Strings[i];
              evnt := evpos;
              pss := posex('[',stmp,1);
              if pss<>0 then begin
                scmd := copy(stmp,1,pss-1);
                sevnt := copy(stmp,pss+1,length(stmp));
                pss := posex(']',sevnt,1);
                if pss<>0 then sevnt:=copy(sevnt,1,pss-1);
                pss := posex('+',sevnt,1);
                pse := posex('-',sevnt,1);
                if (pss<>0) then begin
                  stmp := trim(copy(sevnt,pss+1,length(sevnt)));
                  if stmp<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos+strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end else if (pse<>0) then begin
                  stmp := copy(sevnt,pse+1,length(sevnt));
                  if trim(stmp)<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos-strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end;
              end else scmd:=stmp;
              if evnt > MyTLEdit.Count-1 then evnt:=MyTLEdit.Count-1;
<<<<<<< HEAD
              cmd := GetCommand(scmd, evnt);
              if cmd<>'' then begin
                cmd := BeforeStr + GetCommand(scmd, evnt) + AfterStr;
                lst.Add(cmd);
              end;
=======
              lst.Add(GetCommand(scmd, evnt));
>>>>>>> 567489eb579fa25cb906471546da671d36020444
            end;
        finally
            clst.free;
        end;
        WriteLog('Translator', 'TCommandTemplates.GetCMDStart  Finish');
    except
        WriteLog('Translator', 'TCommandTemplates.GetCMDStart  Error');
    end;
end;

procedure TCommandTemplates.GetCMDTransition(evpos : integer;  lst: tstrings);
var clst: tstrings;
    i, j : integer;
    stmp, scmd, sevnt : string;
    pss, pse, evnt : integer;
    cmd: string;
begin
    WriteLog('Translator', 'TCommandTemplates.GetCMDTransition  Start');
    try
        clst := tstringlist.create;
        clst.clear;
        try
            CMDTransition.GetListCommands(evpos, clst);
            lst.clear;
            for i := 0 to clst.Count - 1 do
            begin
              stmp := clst.Strings[i];
              evnt := evpos;
              pss := posex('[',stmp,1);
              if pss<>0 then begin
                scmd := copy(stmp,1,pss-1);
                sevnt := copy(stmp,pss+1,length(stmp));
                pss := posex(']',sevnt,1);
                if pss<>0 then sevnt:=copy(sevnt,1,pss-1);
                pss := posex('+',sevnt,1);
                pse := posex('-',sevnt,1);
                if (pss<>0) then begin
                  stmp := trim(copy(sevnt,pss+1,length(sevnt)));
                  if stmp<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos+strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end else if (pse<>0) then begin
                  stmp := copy(sevnt,pse+1,length(sevnt));
                  if trim(stmp)<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos-strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end;
              end else scmd:=stmp;
              //lst.Add(GetCommand(scmd, evnt));
              if evnt > MyTLEdit.Count-1 then evnt:=MyTLEdit.Count-1;
<<<<<<< HEAD
              cmd := GetCommand(scmd, evnt);
              if cmd<>'' then begin
                cmd := BeforeStr + cmd + AfterStr;
                lst.Add(cmd);
              end;
=======
              cmd := BeforeStr + GetCommand(scmd, evnt) + AfterStr;
              lst.Add(cmd);
>>>>>>> 567489eb579fa25cb906471546da671d36020444
            end;
        finally
            clst.free;
        end;
        WriteLog('Translator', 'TCommandTemplates.GetCMDTransition  Finish');
    except
        WriteLog('Translator', 'TCommandTemplates.GetCMDTransition  Error');
    end;
end;

procedure TCommandTemplates.GetCMDFinish(evpos : integer;  lst: tstrings);
var clst: tstrings;
    i, j : integer;
<<<<<<< HEAD
    cmd, stmp, scmd, sevnt : string;
=======
    stmp, scmd, sevnt : string;
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    pss, pse, evnt : integer;
begin
    WriteLog('Translator', 'TCommandTemplates.GetCMDFinish  Start');
    try
        clst := tstringlist.create;
        clst.clear;
        try
            CMDFinish.GetListCommands(evpos, clst);
            lst.clear;
            for i := 0 to clst.Count - 1 do
            begin
              stmp := clst.Strings[i];
              evnt := evpos;
              pss := posex('[',stmp,1);
              if pss<>0 then begin
                scmd := copy(stmp,1,pss-1);
                sevnt := copy(stmp,pss+1,length(stmp));
                pss := posex(']',sevnt,1);
                if pss<>0 then sevnt:=copy(sevnt,1,pss-1);
                pss := posex('+',sevnt,1);
                pse := posex('-',sevnt,1);
                if (pss<>0) then begin
                  stmp := trim(copy(sevnt,pss+1,length(sevnt)));
                  if stmp<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos+strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end else if (pse<>0) then begin
                  stmp := copy(sevnt,pse+1,length(sevnt));
                  if trim(stmp)<>'' then begin
                    sevnt := '';
                    for j:=1 to length(stmp) do begin
                      if stmp[j] in ['0'..'9']
                        then sevnt := sevnt + stmp[j]
                        else break;
                    end;
                    if sevnt<>''
                      then evnt:=evpos-strtoint(sevnt)
                      else evnt:=evpos;
                  end;
                end;
              end else scmd:=stmp;
              if evnt > MyTLEdit.Count-1 then evnt:=MyTLEdit.Count-1;
<<<<<<< HEAD
              cmd := GetCommand(scmd, evnt);
              if cmd<>'' then begin
                cmd := BeforeStr + GetCommand(scmd, evnt) + AfterStr;
                lst.Add(cmd);
              end;
=======
              lst.Add(GetCommand(scmd, evnt));
>>>>>>> 567489eb579fa25cb906471546da671d36020444
            end;
        finally
            clst.free;
        end;
        WriteLog('Translator', 'TCommandTemplates.GetCMDFinish  Finish');
    except
        WriteLog('Translator', 'TCommandTemplates.GetCMDFinish  Error');
    end;
end;

procedure TCommandTemplates.Assign(TCT: TCommandTemplates);
var
    i: integer;
begin
    clear;
    TypeData := TCT.TypeData;
    BeforeStr := TCT.BeforeStr;
    AfterStr := TCT.AfterStr;
    StartCommand := TCT.StartCommand;
    FinishCommand := TCT.FinishCommand;

    for i := 0 to TCT.CMDCount - 1 do
    begin
        CMDCount := CMDCount + 1;
        setlength(CommandsList, CMDCount);
        CommandsList[CMDCount - 1] := TOneCommand.create;
        CommandsList[CMDCount - 1].Assign(TCT.CommandsList[i]);
    end;
    CMDPaused.Assign(TCT.CMDPaused);
    CMDStart.Assign(TCT.CMDStart);
    CMDTransition.Assign(TCT.CMDTransition);
    CMDFinish.Assign(TCT.CMDFinish);
end;

constructor TMyIndex.create(srcstr: string);
var
    i, cnt: integer;
    lst: tstrings;
    cmd: array [0 .. 3] of string;
    res: TListParam;
    ss: string;
begin
    lst := tstringlist.create;
    lst.clear;
    try
        Source := ''; // main, param,optvalue,optname
        Param := ''; //
        Phrase := '';
        TypePhrase := '';
        Index := nil;
        SeparationString(srcstr, lst);
        for i := 0 to 3 do
            cmd[i] := '';
        if lst.Count > 4 then
            cnt := 4
        else
            cnt := lst.Count;
        for i := 0 to lst.Count - 1 do
            cmd[i] := lst.Strings[i];
        Source := ansilowercase(trim(cmd[0]));
        if Source = 'phrase' then
        begin
            res := PhraseParam(cmd[1]);
            Phrase := res.Name;
            TypePhrase := res.Text;
        end
        else
            Param := trim(cmd[1]);
        ss := trim(cmd[2]);
        if ss <> '' then
        begin
            if ss[1] = '[' then
            begin
                ss := Copy(ss, 2, length(ss));
                if ss[length(ss)] = ']' then
                    ss := Copy(ss, 1, length(ss) - 1);
                Index := TMyIndex.create(ss);
            end;
        end;
    finally
        lst.free;
    end;
end;

constructor TMyIndex.create;
begin
    Source := ''; // main, param,optvalue,optname
    Param := ''; //
    Phrase := '';
    TypePhrase := '';
    Index := nil;
end;

procedure TMyIndex.Assign(TMI: TMyIndex);
begin
    Source := TMI.Source; // main, param,optvalue,optname
    Param := TMI.Param; //
    Phrase := TMI.Phrase;
    TypePhrase := TMI.TypePhrase;
    if TMI.Index <> nil then
    begin
        Index := TMyIndex.create;
        Index.Assign(TMI.Index);
    end
    else
        Index := nil;
end;

destructor TMyIndex.destroy;
begin
    freemem(@Source);
    freemem(@Param);
    freemem(@Phrase);
    freemem(@TypePhrase);
    freemem(@Index);
end;

function TMyIndex.GetStr(evpos: integer): string;
var
    sindx, sphr, stph, stmp: string;
    indx: integer;
begin
    result := '';
    if index <> nil then
        sindx := Index.GetStr(evpos)
    else
        sindx := '';
    result := GetCommandValue(evpos, Source, Param, Phrase, TypePhrase, sindx);
    // if MyProtocol=nil then exit;
    // if Source='value' then result:= Param
    // else if Source='main' then begin
    // if sindx='' then begin
    // stmp := MyProtocol.Main.GetValue(Param);
    // result := MyProtocol.ProtocolMain.GetValue(Param,stmp);
    // end else begin
    // result := MyProtocol.ProtocolMain.GetValue(Param,sindx);
    // end;
    // end else if Source='param' then begin
    // if sindx<>'' then begin
    // result := MyProtocol.ProtocolAdd.GetValue(Param,sindx);
    // end;
    // end else if Source='tldata' then begin
    // indx := MyStrToInt(sindx);
    // if indx=-1 then exit;
    // if ansilowercase(trim(param))='name' then result:=MyProtocol.Options.List[indx].Name
    // else if ansilowercase(trim(param))='value' then result:=MyProtocol.Options.List[indx].Text;
    // end else if Source='phrase' then begin
    // if evnt=nil then begin
    // result:='';
    // exit;
    // end;
    // stph := ansilowercase(trim(TypePhrase));
    // if stph='text' then result := evnt.ReadPhraseText(Phrase)
    // else if stph='data' then result := inttostr(evnt.ReadPhraseData(Phrase))
    // else if stph='command' then result := evnt.ReadPhraseCommand(Phrase)
    // else if stph='tag' then result := inttostr(evnt.ReadPhraseTag(Phrase))
    // else if stph='type' then result := evnt.ReadPhraseType(Phrase)
    // else if stph='listname' then result := evnt.ReadPhraseListName(Phrase)
    // end;
end;

Constructor TOneField.create;
begin
    TypeField := '';
    TypeData := '';
    VarData := '';
    Param := '';
    Phrase := '';
    TypePhrase := '';
    Index := nil;
end;

destructor TOneField.destroy;
begin
    freemem(@TypeField);
    freemem(@TypeData);
    freemem(@VarData);
    freemem(@Param);
    freemem(@Phrase);
    freemem(@TypePhrase);
    if Index <> nil then
        index.FreeInstance;
    freemem(@Index);
end;

function TOneField.GetValue(evpos: integer): string;
var
    sindx: string;
begin
    if Index = nil then
        sindx := ''
    else
        sindx := Index.GetStr(evpos);
    result := GetCommandValue(evpos, TypeData, Param, Phrase, TypePhrase, sindx);
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
    result := Count - 1;
end;

function TListTypeDevices.IndexOf(Name: string): integer;
var
    i: integer;
begin
    result := -1;
    for i := 0 to Count - 1 do
    begin
        if ansilowercase(trim(TypeDevices[i].TypeDevice))
          = ansilowercase(trim(Name)) then
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
        result := SetSpace(2) + '<TypeDevices=' +
          trim(TypeDevices[i].TypeDevice) + '>' + #13#10;
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

procedure TListTypeDevices.SetString(srcstr: string);
var
    i, rw: integer;
    sprotocols: string;
    lst: tstrings;
begin
    lst := tstringlist.create;
    try
        lst.clear;
        GetProtocolsList(srcstr, 'TypeDevices=', lst);
        clear;
        for i := 0 to lst.Count - 1 do
        begin
            rw := Add(trim(lst.Strings[i]));
            sprotocols := GetProtocolsStr(srcstr,
              'TypeDevices=' + trim(lst.Strings[i]));
            TypeDevices[rw].SetString(sprotocols);
        end;
    finally
        lst.free;
    end;
end;

procedure TListTypeDevices.GetProtocol(TypeDevice, Vendor, Device, Prot: string;
  Protocol: TOneProtocol);
var
    i, j, n, m: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if ansilowercase(trim(TypeDevices[i].TypeDevice))
      = ansilowercase(trim(TypeDevice)) then
    begin
      for j := 0 to TypeDevices[i].Count - 1 do
      begin
        if ansilowercase(trim(TypeDevices[i].Vendors[j].Vendor))
          = ansilowercase(trim(Vendor)) then
        begin
          with TypeDevices[i].Vendors[j] do
          begin
            for n := 0 to Count - 1 do
            begin
              if ansilowercase(trim(FirmDevices[n].Device))
                = ansilowercase(trim(Device)) then
              begin
                for m := 0 to FirmDevices[n].Count - 1 do
                begin
                  if ansilowercase
                    (trim(FirmDevices[i].ListProtocols[m]
                    .Protocol)) = ansilowercase(trim(Prot))
                  then
                  begin
                    Protocol.AssignPart
                    (FirmDevices[i].ListProtocols[m]);
                    exit;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TListTypeDevices.LoadFromFile(FileName, TypeDevices: string);
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
            ss := GetProtocolsStr(ss, TypeDevices);
            SetString(ss)
        finally
            buff.free;
        end;
    except
        buff.free;
    end;
end;

procedure TListTypeDevices.SaveToFile(FileName, TypeDevices: string);
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
            buff.Add('<' + TypeDevices + '>');
            GetListString(buff);
            buff.Add('</' + TypeDevices + '>');
            if ansilowercase(TypeDevices) = 'tldevices' then
                buff.Text := buff.Text + stxt + smedia
            else if ansilowercase(TypeDevices) = 'tltext' then
                buff.Text := sdev + buff.Text + smedia
            else if ansilowercase(TypeDevices) = 'tlmedia' then
                buff.Text := sdev + stxt + buff.Text;
            buff.SaveToFile(FName);
        finally
            buff.free;
        end;
    except
        buff.free;
    end;
end;

constructor TFirmDevice.create;
begin
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
    freemem(@Device);
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
        if ansilowercase(trim(ListProtocols[i].Protocol))
          = ansilowercase(trim(Name)) then
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
        // result:=result+ListProtocols[i].GetString;
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
                sprotocols := GetProtocolsStr(stri,
                  'Protocol=' + trim(lst.Strings[i]));
                ListProtocols[rw].SetString(sprotocols);
            end;
        end;
    finally
        lst.free;
    end;
end;

constructor TTypeDevice.create;
begin
    index := -1;
    TypeDevice := '';
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
    clear;
    freemem(@Count);
    freemem(@Vendors);
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
        if ansilowercase(trim(Vendors[i].Vendor)) = ansilowercase(trim(Name))
        then
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
        result := SetSpace(4) + '<Firms=' + trim(Vendors[i].Vendor) +
          '>' + #13#10;
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

procedure TTypeDevice.SetString(srcstr: string);
var
    i, rw: integer;
    sprotocols: string;
    lst: tstrings;
begin
    lst := tstringlist.create;
    try
        lst.clear;
        GetProtocolsList(srcstr, 'Firms=', lst);
        clear;
        if lst.Count > 0 then
        begin
            for i := 0 to lst.Count - 1 do
            begin
                rw := Add(trim(lst.Strings[i]));
                sprotocols := GetProtocolsStr(srcstr,
                  'Firms=' + trim(lst.Strings[i]));
                Vendors[rw].SetString(sprotocols);
            end;
        end;
    finally
        lst.free;
    end;
end;

constructor TOneProtocol.create;
begin
    Protocol := '';
    Main := TInputProtocol.create;
    Options := TInputProtocol.create;
    CMDTemplates := TCommandTemplates.create;
    ProtocolMain := TProtocolParams.create;
    ProtocolAdd := TProtocolParams.create;
end;

destructor TOneProtocol.destroy;
begin
    freemem(@Protocol);
    Main.clear;
    Options.clear;
    freemem(@Main);
    freemem(@Options);
    freemem(@CMDTemplates);
    ProtocolMain.clear;
    ProtocolAdd.clear;
    freemem(@ProtocolMain);
    freemem(@ProtocolAdd);
End;

procedure TOneProtocol.GetListString(lst: tstrings);
begin
    ProtocolMain.GetListString(lst);
    ProtocolAdd.GetListString(lst);
end;

procedure TOneProtocol.SetString(stri: string);
var
    ss: string;
begin
    ss := GetProtocolsStr(stri, 'CommandsTemplates');
    CMDTemplates.SetString(ss);
    ss := GetProtocolsStr(stri, 'MainOptions');
    ProtocolMain.SetString(ss);
    ss := GetProtocolsStr(stri, 'AddOptions');
    ProtocolAdd.SetString(ss);
end;

procedure TOneProtocol.AssignPart(TOPR: TOneProtocol);
begin
    Protocol := TOPR.Protocol;
    //CMDTemplates.clear;
    CMDTemplates.Assign(TOPR.CMDTemplates);
    //ProtocolMain.clear;
    ProtocolMain.Assign(TOPR.ProtocolMain);
    //ProtocolAdd.clear;
    ProtocolAdd.Assign(TOPR.ProtocolAdd);
end;

procedure TOneProtocol.Assign(TOPR: TOneProtocol);
begin
    Protocol := TOPR.Protocol;
    CMDTemplates.Assign(TOPR.CMDTemplates);
    Main.Assign(TOPR.Main);
    Options.Assign(TOPR.Options);
    ProtocolMain.Assign(TOPR.ProtocolMain);
    ProtocolAdd.Assign(TOPR.ProtocolAdd);
end;

constructor TCommands.create;
begin
    CMDType := 0; // 0-List, 1-Case
    Condition := TMyIndex.create;
    Count := 0;
end;

procedure TCommands.clear;
begin
    CMDType := 0;
    Condition.Source := '';
    Condition.Param := '';
    Condition.Phrase := '';
    Condition.TypePhrase := '';
    if Condition.Index <> nil then
    begin
        Condition.Index.FreeInstance;
        Condition.Index := nil;
    end;
end;

destructor TCommands.destroy;
begin
    freemem(@CMDType); // 0-List, 1-Case
    Condition.FreeInstance;
    freemem(@Condition);
    clear;
    freemem(@Count);
    freemem(@CaseItems);
end;

procedure TCommands.Assign(TC: TCommands);
var
    i: integer;
begin
    clear;
    CMDType := TC.CMDType;
    if Condition = nil then
        Condition.create;
    Condition.Assign(TC.Condition);
    for i := 0 to TC.Count - 1 do
    begin
        Count := Count + 1;
        setlength(CaseItems, Count);
        CaseItems[Count - 1] := TVarCase.create(TC.CaseItems[i].CaseName);
        CaseItems[Count - 1].Assign(TC.CaseItems[i]);
    end;
end;

procedure TCommands.GetListCommands(evpos : integer; lst: tstrings);
var
    i, j: integer;
    scond, sindx: string;
    //scmd, sevnt : string;
    //pss, pse, offset : integer;
begin
    WriteLog('Translator', 'TCommands.GetListCommands  Start CMDType=' +
      inttostr(CMDType));
    lst.clear;
    if CMDType = 0 then
    begin
        if Count = 0 then
            exit;
        // caseitems[0].List.Clear;
        for i := 0 to CaseItems[0].List.Count - 1 do
        begin

            lst.Add(CaseItems[0].List.Strings[i]);
            WriteLog('Translator', 'TCommands.GetListCommands  AddCommand=' +
              CaseItems[0].List.Strings[i]);
        end;
    end
    else
    begin
        if Condition.Index = nil then
            sindx := ''
        else
            sindx := Condition.Index.GetStr(evpos);
        scond := GetCommandValue(evpos, Condition.Source, Condition.Param,
          Condition.Phrase, Condition.TypePhrase, sindx);
        // scond:='mix';
        WriteLog('Translator', 'TCommands.GetListCommands  Condition=' + scond);
        for i := 0 to Count - 1 do
        begin
            if ansilowercase(trim(CaseItems[i].CaseName))
              = ansilowercase(trim(scond)) then
            begin
                for j := 0 to CaseItems[i].List.Count - 1 do
                begin
                    lst.Add(CaseItems[i].List.Strings[j]);
                    WriteLog('Translator',
                      'TCommands.GetListCommands  AddCommand=' + CaseItems[i]
                      .List.Strings[j]);
                end;
                exit;
            end;
        end;
    end;
    WriteLog('Translator', 'TCommands.GetListCommands  Finish');
end;

procedure TCommands.SetString(stri, SName: string);
var
    sparam, scount, stype, ss, s1, s2: string;
    i, j, k, cnt, sind: integer;
    res, srng: TListParam;
    rng: TRangeParam;
    lst: tstrings;
begin
    clear;
    Count := 0;
    sparam := StringReplace(stri, '<' + trim(SName) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    sparam := StringReplace(sparam, '</' + trim(SName) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    // sparam := GetProtocolsStr(stri, 'MainOptions');
    if trim(sparam) = '' then
        exit;

    stype := trim(GetProtocolsParam(sparam, 'Type'));
    if ansilowercase(stype) = 'list' then
    begin
        CMDType := 0;
        scount := GetProtocolsParam(sparam, 'Count');
        if trim(scount) <> '' then
        begin
            cnt := strtoint(scount);
            Count := Count + 1;
            setlength(CaseItems, Count);
            CaseItems[Count - 1] := TVarCase.create('');
            for i := 0 to cnt - 1 do
            begin
                ss := GetProtocolsParam(sparam, inttostr(i + 1));
                CaseItems[Count - 1].List.Add(ss);
            end;
        end;
    end
    else if ansilowercase(stype) = 'case' then
    begin
        CMDType := 1;
        ss := GetProtocolsParam(sparam, 'Case');
        lst := tstringlist.create;
        try
            lst.clear;
            SeparationChar(ss, '|', lst);
            if Condition <> nil then
            begin
                Condition.FreeInstance;
                Condition := nil;
            end;
            Condition := TMyIndex.create(lst.Strings[0]);
            for i := 1 to lst.Count - 1 do
            begin
                Count := Count + 1;
                setlength(CaseItems, Count);
                CaseItems[Count - 1] := TVarCase.create(trim(lst.Strings[i]));
                ss := GetProtocolsStr(sparam, trim(lst.Strings[i]));
                scount := GetProtocolsParam(ss, 'Count');
                if trim(scount) <> '' then
                begin
                    cnt := strtoint(scount);
                    s1 := GetProtocolsStr(ss, trim(lst.Strings[i]));
                    for j := 0 to cnt - 1 do
                    begin
                        s2 := GetProtocolsParam(ss, inttostr(j + 1));
                        CaseItems[Count - 1].List.Add(s2);
                    end;
                end;
            end;
        finally
            lst.free;
        end;
    end;
end;

constructor TVarCase.create(NCase: string);
begin
    CaseName := NCase;
    if List = nil then
        List := tstringlist.create;
    List.clear;
end;

procedure TVarCase.clear;
begin
    CaseName := '';
    List.clear;
end;

destructor TVarCase.destroy;
begin
    freemem(@CaseName);
    List.free;
    List := nil;
    freemem(@List);
end;

function TVarCase.Add(Name: string): integer;
begin
    List.Add(Name);
end;

procedure TVarCase.Assign(TVC: TVarCase);
begin
    CaseName := TVC.CaseName;
    List.clear;
    List := TVC.List;
end;

constructor TVendors.create;
begin
    index := -1;
    Vendor := '';
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
    freemem(@Vendor);
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
            lst.Add(SetSpace(6) + '<Device=' +
              trim(FirmDevices[i].Device) + '>');
            FirmDevices[i].GetListString(lst);
            lst.Add(SetSpace(6) + '</Device=' +
              trim(FirmDevices[i].Device) + '>');
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
                sprotocols := GetProtocolsStr(stri,
                  'Device=' + trim(lst.Strings[i]));
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
        lst.free;
    end;
end;

constructor TOneStringTable.create(SName, SText: string);
begin
    Name := SName;
    Text := SText;
end;

destructor TOneStringTable.destroy;
begin
    freemem(@Name);
    freemem(@Text);
end;

procedure TOneStringTable.Assign(TST: TOneStringTable);
begin
    Name := TST.Name;
    Text := TST.Text;
end;

constructor TListParams.create;
begin
    Count := 0;
end;

procedure TListParams.clear;
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

procedure TListParams.Assign(TLP: TListParams);
var
    i: integer;
begin
    clear;
    Name := TLP.Name;
    for i := 0 to TLP.Count - 1 do
    begin
        Count := Count + 1;
        setlength(List, Count);
        List[Count - 1] := TOneStringTable.create(TLP.List[i].Name,
          TLP.List[i].Text);
    end;
end;

destructor TListParams.destroy;
begin
    clear;
    freemem(@Count);
    freemem(@List);
end;

function TListParams.GetString: string;
var
    i: integer;
begin
    result := '<MainOptions>';
    result := result + '<Count=' + inttostr(Count) + '>';
    for i := 0 to Count - 1 do
    begin
        result := result + '<' + inttostr(i + 1) + ':' + trim(List[i].Name) +
          '=' + trim(List[i].Text) + '>';
    end;
    result := result + '</MainOptions>';
end;

procedure TListParams.GetListString(lst: tstrings);
var
    i: integer;
begin
    lst.Add(SetSpace(10) + '<MainOptions>');
    lst.Add(SetSpace(12) + '<Count=' + inttostr(Count) + '>');
    for i := 0 to Count - 1 do
    begin
        lst.Add(SetSpace(12) + '<' + inttostr(i + 1) + ':' + trim(List[i].Name)
          + '=' + trim(List[i].Text) + '>');
    end;
    lst.Add(SetSpace(10) + '</MainOptions>');
end;

procedure TListParams.SetString(stri: string);
var
    sparam, scount: string;
    i, j, k, cnt, sind: integer;
    res, srng: TListParam;
    rng: TRangeParam;
begin
    clear;
    Count := 0;
    sparam := StringReplace(stri, '<Param=' + trim(Name) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    sparam := StringReplace(sparam, '</Param=' + trim(Name) + '>', '',
      [rfReplaceAll, rfIgnoreCase]);
    // sparam := GetProtocolsStr(stri, 'MainOptions');
    scount := GetProtocolsParam(sparam, 'Count');
    if trim(scount) <> '' then
    begin
        cnt := strtoint(scount);
        for i := 0 to cnt - 1 do
        begin
            res := GetProtocolsParamEx(sparam, i + 1);
            rng := GetRangeParams(res.Name);
            if rng.Max <> -1 then
            begin
                srng := GetIndexStr(res.Text);
                if trim(srng.Text) = '' then
                    sind := 0
                else
                    sind := strtoint(srng.Text);
                for j := rng.Min to rng.Max do
                begin
                    Count := Count + 1;
                    setlength(List, Count);
                    List[Count - 1] := TOneStringTable.create
                      (trim(rng.Text) + inttostr(j),
                      GetParamData(srng.Name, sind));
                    sind := sind + 1;
                end;
            end
            else
            begin
                Count := Count + 1;
                setlength(List, Count);
                List[Count - 1] := TOneStringTable.create(res.Name, res.Text);
            end;
        end;
    end;
end;

constructor TProtocolParams.create;
begin
    Count := 0;
end;

procedure TProtocolParams.clear;
var
    i: integer;
begin
    for i := Count - 1 downto 0 do
    begin
        Params[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Params, Count);
    end;
    Count := 0;
end;

procedure TProtocolParams.Assign(TPP: TProtocolParams);
var
    i: integer;
begin
    clear;
    for i := 0 to TPP.Count - 1 do
    begin
        Count := Count + 1;
        setlength(Params, Count);
        Params[Count - 1] := TListParams.create;
        Params[Count - 1].Assign(TPP.Params[i]);
    end;
end;

destructor TProtocolParams.destroy;
begin
    clear;
    freemem(@Count);
    freemem(@Params);
end;

function TProtocolParams.Add(SName: string): integer;
begin
    Count := Count + 1;
    setlength(Params, Count);
    Params[Count - 1] := TListParams.create;
    Params[Count - 1].Name := SName;
    result := Count - 1;
end;

function TProtocolParams.GetValue(PName, SName: string): string;
var
    i, j: integer;
begin
    result := '';
    for i := 0 to Count - 1 do
    begin
        if ansilowercase(trim(Params[i].Name)) = ansilowercase(trim(PName)) then
        begin
            for j := 0 to Params[i].Count - 1 do
            begin
                if ansilowercase(trim(Params[i].List[j].Name))
                  = ansilowercase(trim(SName)) then
                begin
                    result := Params[i].List[j].Text;
                    exit;
                end;
            end;
        end;
    end;
end;

function TProtocolParams.GetString: string;
var
    i: integer;
begin
    result := '<AddOptions>';
    result := result + '<Count=' + inttostr(Count) + '>';
    // for i:=0 to Count-1 do begin
    // result := result + '<'+inttostr(i+1)+':'+trim(Params[i].Name)+'='
    // +trim(Params[i].Text)+'>';
    // end;
    result := result + '</AddOptions>';
end;

procedure TProtocolParams.GetListString(lst: tstrings);
var
    i: integer;
begin
    // lst.Add(setspace(10) + '<AddOptions>');
    // lst.Add(setspace(12) + '<Count='+inttostr(Count)+'>');
    // for i:=0 to Count-1 do begin
    // lst.Add(setspace(12) + '<'+inttostr(i+1)+':'+trim(Params[i].Name)+'='
    // +trim(Params[i].Text)+'>');
    // end;
    // lst.Add(setspace(10) + '</AddOptions>');
end;

// procedure TProtocolParams.SetString(stri : string);
// var sparam, scount : string;
// i, cnt : integer;
// res : TListParam;
// begin
// clear;
// Count:=0;
// sparam := GetProtocolsStr(stri, 'AddOptions');
// scount := GetProtocolsParam(sparam, 'Count');
// if trim(scount)<>'' then begin
// cnt:=strtoint(scount);
// for i:=0 to cnt-1 do begin
// res := GetProtocolsParamEx(sparam, i+1);
// Count:=Count+1;
// setlength(Params,Count);
// Params[Count-1] := TOneStringTable.create(res.Name, res.Text);
// end;
// end;
// end;

procedure TProtocolParams.SetString(stri: string);
var
    i, rw: integer;
    sprotocols: string;
    lst: tstrings;
begin
    lst := tstringlist.create;
    try
        lst.clear;
        GetProtocolsList(stri, 'Param=', lst);
        clear;
        if lst.Count > 0 then
        begin
            for i := 0 to lst.Count - 1 do
            begin
                rw := Add(trim(lst.Strings[i]));
                sprotocols := GetProtocolsStr(stri,
                  'Param=' + trim(lst.Strings[i]));

                Params[rw].SetString(sprotocols);
            end;
        end;
    finally
        lst.free;
    end;
end;

initialization

MyProtocol := TOneProtocol.create;
ListCommands := tstringlist.create;
ListCommands.clear;

finalization

MyProtocol.FreeInstance;
MyProtocol := nil;
ListCommands.free;
ListCommands := nil;

end.
