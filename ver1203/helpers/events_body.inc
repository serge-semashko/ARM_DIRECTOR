
function TMyEventJSON.LoadFromJSONObject(JSON: tjsonObject): boolean;
var
  i1: integer;
  tmpjson: tjsonObject;
begin
  try
    // IDEvent : longint;
    IDEvent := GetVariableFromJson(JSON, 'IDEvent', IDEvent);
    // Color : TColor;
    Color := GetVariableFromJson(JSON, 'Color', Color);
    // FontColor : TColor;
    FontColor := GetVariableFromJson(JSON, 'FontColor', FontColor);
    // FontSize : integer;
    FontSize := GetVariableFromJson(JSON, 'FontSize', FontSize);
    // FontSizeSub : integer;
    FontSizeSub := GetVariableFromJson(JSON, 'FontSizeSub', FontSizeSub);
    // FontName : tfontname;
    FontName := GetVariableFromJson(JSON, 'FontName', FontName);
    // SafeZone : integer;
    SafeZone := GetVariableFromJson(JSON, 'SafeZone', SafeZone);
    // Editing : boolean;
    Editing := GetVariableFromJson(JSON, 'Editing', Editing);
    // Select : boolean;
    Select := GetVariableFromJson(JSON, 'Select', Select);
    // Start : longint;
    Start := GetVariableFromJson(JSON, 'Start', Start);
    // Finish: longint;
    Finish := GetVariableFromJson(JSON, 'Finish', Finish);
    // Count : integer;
    Count := GetVariableFromJson(JSON, 'Count', Count);
    SetLength(Rows, 0);
    SetLength(Rows, Count);
    for i1 := 0 to Count - 1 do
    begin
      tmpjson := tjsonObject(JSON.GetValue('Rows' + IntToStr(i1)));
      assert(tmpjson <> nil, 'TMyEvents нет значения  ' + 'Rows' +
        IntToStr(i1));
      if tmpjson = nil then
        break;
      Rows[i1] := TMyPhrases.Create;
      Rows[i1].LoadFromJSONObject(tmpjson);
    end;
  except
    on E: Exception do
  end;

end;

function TMyEventJSON.LoadFromJSONstr(JSONstr: string): boolean;
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

function TMyEventJSON.SaveToJSONObject: tjsonObject;
var
  str1: string;
  js1, JSON: tjsonObject;
  i1, i2: integer;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)
begin
  JSON := tjsonObject.Create;
  try
    // jsonstr : string;
    // IDEvent : longint;
    addVariableToJson(JSON, 'IDEvent', IDEvent);
    // Color : TColor;
    addVariableToJson(JSON, 'Color', Color);
    // FontColor : TColor;
    addVariableToJson(JSON, 'FontColor', FontColor);
    // FontSize : integer;
    addVariableToJson(JSON, 'FontSize', FontSize);
    // FontSizeSub : integer;
    addVariableToJson(JSON, 'FontSizeSub', FontSizeSub);
    // FontName : tfontname;
    addVariableToJson(JSON, 'FontName', FontName);
    // SafeZone : integer;
    addVariableToJson(JSON, 'SafeZone', SafeZone);
    // Editing : boolean;
    addVariableToJson(JSON, 'Editing', Editing);
    // Select : boolean;
    addVariableToJson(JSON, 'Select', Select);
    // Start : longint;
    addVariableToJson(JSON, 'Start', Start);
    // Finish: longint;
    addVariableToJson(JSON, 'Finish', Finish);
    // Count : integer;
    addVariableToJson(JSON, 'Count', Count);
    // Rows : array of TMyPhrases;
    for i1 := Low(Rows) to High(Rows) do
    begin
      JSON.AddPair('Rows' + IntToStr(i1), Rows[i1].SaveToJSONObject)
    end;
  except
    on E: Exception do
  end;
  result := JSON;
  str1 := JSON.ToString;
end;

function TMyEventJSON.SaveToJSONStr: string;

var
  jsontmp: tjsonObject;
  JSONstr: string;
begin
  jsontmp := SaveToJSONObject;
  JSONstr := jsontmp.ToString;
  result := JSONstr;
end;

{ TMyPhraseJSON }

function TMyPhraseJSON.LoadFromJSONObject(JSON: tjsonObject): boolean;
begin
  Name := GetVariableFromJson(JSON, 'Name', Name);
  // Name     : string;
  Text := GetVariableFromJson(JSON, 'Text', Text);
  // Text     : string;
  Data := GetVariableFromJson(JSON, 'Data', Data);
  // Data     : longint;
  Data := GetVariableFromJson(JSON, 'Data', Data);
  // Command  : widestring;
  Command := GetVariableFromJson(JSON, 'Command', Command);
  // Tag      : integer;
  Tag := GetVariableFromJson(JSON, 'Tag', Tag);
  // Rect     : TRect;
  Rect.LoadFromJSONObject(tjsonObject(JSON.GetValue('Rect')));
  // Select   : boolean;
  Select := GetVariableFromJson(JSON, 'Select', Select);
  // WorkData : string;
  WorkData := GetVariableFromJson(JSON, 'WorkData', WorkData);
  // ListName : string;
  ListName := GetVariableFromJson(JSON, 'ListName', ListName);
  // Maxlength: integer;
  Maxlength := GetVariableFromJson(JSON, 'Maxlength', Maxlength);
  // Visible  : boolean;
  Visible := GetVariableFromJson(JSON, 'Visible', Visible);
end;

function TMyPhraseJSON.LoadFromJSONstr(JSONstr: string): boolean;
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

function TMyPhraseJSON.SaveToJSONObject: tjsonObject;
var
  JSON: tjsonObject;
begin
  JSON := tjsonObject.Create;
  addVariableToJson(JSON, 'Name', Name);
  // Name     : string;
  addVariableToJson(JSON, 'Text', Text);
  // Text     : string;
  addVariableToJson(JSON, 'Data', Data);
  // Data     : longint;
  addVariableToJson(JSON, 'Data', Data);
  // Command  : widestring;
  addVariableToJson(JSON, 'Command', Command);
  // Tag      : integer;
  addVariableToJson(JSON, 'Tag', Tag);
  // Rect     : TRect;
  JSON.AddPair('Rect', Rect.SaveToJSONObject);
  // Select   : boolean;
  addVariableToJson(JSON, 'Select', Select);
  // WorkData : string;
  addVariableToJson(JSON, 'WorkData', WorkData);
  // ListName : string;
  addVariableToJson(JSON, 'ListName', ListName);
  // Maxlength: integer;
  addVariableToJson(JSON, 'Maxlength', Maxlength);
  // Visible  : boolean;
  addVariableToJson(JSON, 'Visible', Visible);
  result := JSON;
end;

function TMyPhraseJSON.SaveToJSONStr: string;
begin
  result := SaveToJSONObject.ToString;
end;

{ TMyPhrasesJSON }

function TMyPhrasesJSON.LoadFromJSONObject(JSON: tjsonObject): boolean;
var
  tmpjson: tjsonObject;
  i1: integer;
begin
  Top := GetVariableFromJson(JSON, 'Top', Top);
  // Top : integer;
  Bottom := GetVariableFromJson(JSON, 'Bottom', Bottom);
  // Bottom : integer;
  Count := GetVariableFromJson(JSON, 'Count', Count);
  // Count : integer;
  SetLength(Phrases, 0);
  SetLength(Phrases, Count);
  for i1 := 0 to Count - 1 do
  begin

    tmpjson := tjsonObject(JSON.GetValue('Phrases' + IntToStr(i1)));
    assert(tmpjson <> nil, 'TMyPhrasesJSON нет фразы для ' + 'Phrases' +
      IntToStr(i1));
    if tmpjson = nil then
      break;
    Phrases[i1] := TMyPhrase.Create;
    Phrases[i1].LoadFromJSONObject(tmpjson);
  end;

end;

function TMyPhrasesJSON.LoadFromJSONstr(JSONstr: string): boolean;
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

function TMyPhrasesJSON.SaveToJSONObject: tjsonObject;
var
  JSON: tjsonObject;
  i1: integer;
begin
  JSON := tjsonObject.Create;
  addVariableToJson(JSON, 'Top', Top);
  // Top : integer;
  addVariableToJson(JSON, 'Bottom', Bottom);
  // Bottom : integer;
  addVariableToJson(JSON, 'Count', Count);
  // Count : integer;
  for i1 := Low(Phrases) to High(Phrases) do
  begin
    JSON.AddPair('Phrases' + IntToStr(i1), Phrases[i1].SaveToJSONObject)
  end;
  result := JSON;

end;

function TMyPhrasesJSON.SaveToJSONStr: string;
begin
  result := SaveToJSONObject.ToString;
end;

{ TMyWventJSON }

{ TRectJSON }

function TRectJSON.LoadFromJSONObject(JSON: tjsonObject): boolean;
begin
  Top := GetVariableFromJson(JSON, 'Top', Top);
  Bottom := GetVariableFromJson(JSON, 'Bottom', Bottom);
  left := GetVariableFromJson(JSON, 'Left', left);
  Right := GetVariableFromJson(JSON, 'Right', Right);

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
