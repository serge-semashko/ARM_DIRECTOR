  TTLParametersJson = Class helper for TTLParameters
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

  TTLScalerJson = Class helper for TTLScaler
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

  TTLTimelineJSON = Class helper for TTLTimeline
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

  TTLEditorJSON = Class helper for TTLEditor
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

  TTLZoneJSON = Class helper for TTLZone
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;
