  TTimelineOptionsJSON = Class helper for TTimelineOptions
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;
