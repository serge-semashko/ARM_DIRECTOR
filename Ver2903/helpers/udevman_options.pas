unit UDevMan_Options;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, Utils,
    StrUtils, System.json, Vcl.Buttons, uwebget;

type
    TOneOption = class
        Name: string;
        RTN: trect;
        Text: string;
        VarText: string;
        RTT: trect;
        EditType: integer;
        select: boolean;
        constructor create(SName, SText, SVarText: string);
        destructor destroy;
    end;

    TDevManager = class
        dev_desc: string;
        Count: integer;
        Options: array of TOneOption;
        constructor create;
        destructor destroy;
        procedure clear;
    end;

    // sss helpers
    TDevManagerJson = class helper for TDevManager
    public
        function SaveToJSONStr: string;
        function SaveToJSONObject: tjsonObject;
        function LoadFromJSONObject(json: tjsonObject): boolean;
        function LoadFromJSONstr(JSONstr: string): boolean;
    end;

    TOneOptionJson = class helper for TOneOption
    public
        function SaveToJSONStr: string;
        function SaveToJSONObject: tjsonObject;
        function LoadFromJSONObject(json: tjsonObject): boolean;
        function LoadFromJSONstr(JSONstr: string): boolean;
    end;
    var
      DevManagers : array [0..16] of TDevManager;
      DevManagers_changed : array [0..16] of Boolean;
      DevManagers_old : array [0..16] of string;
implementation


constructor TDevManager.create;
begin
    Count := 0;
    dev_desc := 'test';
end;

procedure TDevManager.clear;
var
    i: integer;
begin
    for i := Count - 1 downto 0 do begin
        Options[Count - 1].FreeInstance;
        Count := Count - 1;
        setlength(Options, Count);
    end;
    Count := 0;
end;

destructor TDevManager.destroy;
begin
    clear;
    freemem(@Count);
    freemem(@Options);
end;
constructor TOneOption.create(SName, SText, SVarText: string);
begin
    Name := SName;
    Text := SText;
    VarText := SVarText;
    EditType := -1;
    select := false;
end;

destructor TOneOption.destroy;
begin
end;

{ TDevManagersJson }

function TDevManagerJson.LoadFromJSONObject(json: tjsonObject): boolean;
var
    i1: integer;
    tmpjson: tjsonObject;
begin
    // description : string;
    dev_desc := getVariableFromJson(json, 'description', dev_desc);
    // Count: integer;
    Count := getVariableFromJson(json, 'Count', Count);
    // Options: array of TOneOption;
    setlength(Options, 0);
    setlength(Options, Count);
    for i1 := 0 to Count - 1 do begin
        tmpjson := tjsonObject(json.GetValue('Options' + inttostr(i1)));
        assert(tmpjson <> nil, 'Options нет для ' + inttostr(i1));
        if tmpjson = nil then
            break;
        Options[i1] := TOneOption.create('', '', '');
        Options[i1].LoadFromJSONObject(tmpjson);
    end;

end;

function TDevManagerJson.LoadFromJSONstr(JSONstr: string): boolean;
var
    json: tjsonObject;
begin
    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0) as tjsonObject;
    result := true;
    if json = nil then begin
        result := false;
    end
    else
        LoadFromJSONObject(json);
end;

function TDevManagerJson.SaveToJSONObject: tjsonObject;
var
    str1: string;
    js1, json: tjsonObject;
    i1, i2: integer;
    jsondata: string;
    (*
      ** сохранение всех переменных в строку JSONDATA в формате JSON
    *)

begin
    json := tjsonObject.create;
    try
        str1 := dev_desc;
        addVariableToJson(json, 'dev_desc', dev_desc);
        // Count: integer;
        addVariableToJson(json, 'Count', Count);
        // Options: array of TOneOption;
        for i1 := 0 to Count - 1 do
            json.AddPair('Options' + inttostr(i1), Options[i1].SaveToJSONObject);
    except
        on E: Exception do


    end;
    result := json;
end;

function TDevManagerJson.SaveToJSONStr: string;
var
    jsontmp: tjsonObject;
    JSONstr: string;
begin
    jsontmp := SaveToJSONObject;
    JSONstr := jsontmp.ToJSON;
    result := JSONstr;
    jsontmp.Free;
end;

{ TOneOptionJson }

function TOneOptionJson.LoadFromJSONObject(json: tjsonObject): boolean;
begin
    // Name: string;
    Name := getVariableFromJson(json, 'Name', Name);
    // RTN: trect;
    // Text: string;
    Text := getVariableFromJson(json, 'Text', Text);
    // VarText: string;
    VarText := getVariableFromJson(json, 'VarText', VarText);
    // RTT: trect;
    // EditType: integer;
    EditType := getVariableFromJson(json, 'EditType', EditType);
    // select: boolean;
    select := getVariableFromJson(json, 'select', select);

end;

function TOneOptionJson.LoadFromJSONstr(JSONstr: string): boolean;
var
    json: tjsonObject;
begin
    json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0) as tjsonObject;
    result := true;
    if json = nil then begin
        result := false;
    end
    else
        LoadFromJSONObject(json);
end;

function TOneOptionJson.SaveToJSONObject: tjsonObject;
var
    str1: string;
    js1, json: tjsonObject;
    i1, i2: integer;
    jsondata: string;
    (*
      ** сохранение всех переменных в строку JSONDATA в формате JSON
    *)

begin
    json := tjsonObject.create;
    try
        // Name: string;
        addVariableToJson(json, 'Name', Name);

        // RTN: trect;
        // Text: string;
        addVariableToJson(json, 'Text', Text);

        // VarText: string;
        addVariableToJson(json, '', VarText);

        // RTT: trect;
        // EditType: integer;
        addVariableToJson(json, 'EditType', EditType);

        // select: boolean;
        addVariableToJson(json, 'select', select);

    except
        on E: Exception do


    end;
    result := json;
end;

function TOneOptionJson.SaveToJSONStr: string;
var
    jsontmp: tjsonObject;
    JSONstr: string;
begin
    jsontmp := SaveToJSONObject;
    JSONstr := jsontmp.ToJSON;
    result := JSONstr;
    jsontmp.Free;
end;
Procedure UpdateManagerList;
var
   i : integer;
   str1, str2 : string;
begin
    for i := low(DevManagers) to high(DevManagers) do
    begin
        str2 := GetJsonStrFromServer('DEVMAN[' + inttostr(i + 1) + ']');
        if DevManagers_old[i] <> str2 then
        begin
            DevManagers_changed[i] := true;
            DevManagers_old[i] := str2;
            if Length(str2) < 30 then
            begin
                DevManagers[i] := nil;
                continue;
            end;
            if DevManagers[i] = nil then
                DevManagers[i] := TDevManager.Create;
            if not DevManagers[i].LoadFromJSONstr(str2) then
                DevManagers[i] := nil;
        end;

    end;

end;
 var
    i1 : integer;
initialization
 for i1 := 0 to 16 do begin
     DevManagers[i1] := nil;
     DevManagers_changed[i1] := true;
     DevManagers_old[i1] := '';
 end;
end.
