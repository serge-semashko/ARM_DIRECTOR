function TTimelineOptionsJSON.LoadFromJSONObject(json: tjsonObject): boolean;
var
  i1: integer;
  tmpjson: tjsonObject;
begin
  try
    TypeTL := GetVariableFromJson(json, 'TypeTL', TypeTL);
    Manager := GetVariableFromJson(json, 'Manager', Manager);
    NumberBmp := GetVariableFromJson(json, 'NumberBmp', NumberBmp);
    name := GetVariableFromJson(json, 'Name', Name);
    UserLock := GetVariableFromJson(json, 'UserLock', UserLock);
    IDTimeline := GetVariableFromJson(json, 'IDTimeline', IDTimeline);
    MediaEvent.LoadFromJSONObject(tjsonObject(json.getvalue('MediaEvent')));
    TextEvent.LoadFromJSONObject(tjsonObject(json.getvalue('TextEvent')));
    MediaColor := GetVariableFromJson(json, 'MediaColor', MediaColor);
    TextColor := GetVariableFromJson(json, 'TextColor', TextColor);
    CharDuration := GetVariableFromJson(json, 'CharDuration', CharDuration);
    EventDuration := GetVariableFromJson(json, 'EventDuration', EventDuration);
    // Protocol : string;                                 //Название протокола и данные для протокола
    Protocol := GetVariableFromJson(json, 'Protocol', Protocol);
    // Manager  : string;                                 //Номер менеджера управления.

    CountDev := GetVariableFromJson(json, 'CountDev', CountDev);
    for i1 := 0 to high(DevEvents) do
    begin
      tmpjson := tjsonObject(json.getvalue('DevEvents' + IntToStr(i1)));
      DevEvents[i1].LoadFromJSONObject(tmpjson);
    end;

  except
    on E: Exception do
  end;

end;

function TTimelineOptionsJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonObject;
begin
  json := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
    as tjsonObject;
  result := true;
    if JSON = nil then
    begin
      result := false;
    end
    else begin
      LoadFromJSONObject(JSON);
      json.free;
    end;
end;

function TTimelineOptionsJSON.SaveToJSONObject: tjsonObject;
var
  str1: string;
  js1, json: tjsonObject;
  i1, i2: integer;
  jsondata: string;
  jsarr : tjsonarray;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)

begin
  jsarr := tjsonarray.create;
  json := tjsonObject.Create;
  try
      // Manager  : string;                                 //Номер менеджера управления.
    addVariableToJson(json, 'Manager', Manager);
    addVariableToJson(json, 'CountDev', CountDev);
    // Protocol : string;                                 //Название протокола и данные для протокола
    addVariableToJson(json, 'Protocol', Protocol);
    addVariableToJson(json, 'TypeTL', TypeTL);

    addVariableToJson(json, 'NumberBmp', NumberBmp);
    addVariableToJson(json, 'Name', Name);
    addVariableToJson(json, 'UserLock', UserLock);
    addVariableToJson(json, 'IDTimeline', IDTimeline);

    for i1 := 0 to high(DevEvents) do begin
      json.AddPair('DevEvents' + IntToStr(i1), DevEvents[i1].SaveToJSONObject);
      jsarr.add(DevEvents[i1].SaveToJSONObject);
    end;
    json.AddPair('DevEvents', jsarr);
    json.AddPair('MediaEvent', MediaEvent.SaveToJSONObject);
    json.AddPair('TextEvent', TextEvent.SaveToJSONObject);
    addVariableToJson(json, 'MediaColor', MediaColor);
    addVariableToJson(json, 'TextColor', TextColor);
    addVariableToJson(json, 'CharDuration', CharDuration);
    addVariableToJson(json, 'EventDuration', EventDuration);


  except
    on E: Exception do
  end;
  result := json;
end;



function TTimelineOptionsJSON.SaveToJSONStr: string;
var
  jsontmp: tjsonObject;
  JSONstr: string;
begin
  jsontmp := SaveToJSONObject;
//  JSONstr := jsontmp.ToJSON;
  JSONstr := jsontmp.tostring;
  result := JSONstr;
end;

