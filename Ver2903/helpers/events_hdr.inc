  TMyEventJSON = Class helper for TMyEvent
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(JSON: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

  TMyPhraseJSON = Class helper for TMyPhrase
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(JSON: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

  TMyPhrasesJSON = Class helper for TMyPhrases
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(JSON: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

  TRectJSON = record helper for TRect
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(JSON: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;
