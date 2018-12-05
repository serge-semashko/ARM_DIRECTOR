unit uwebserv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPServer, IdCustomHTTPServer, IdHTTPServer,ulkjson;


type
  THTTPSRVForm = class(TForm)
    HTTPSRV: TIdHTTPServer;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    varname: TLabeledEdit;
    VarVal: TLabeledEdit;
    BitBtn2: TBitBtn;
    ObjNum: TComboBox;
    Timer1: TTimer;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure HTTPSRVConnect(AThread: TIdPeerThread);
    procedure HTTPSRVDisconnect(AThread: TIdPeerThread);
    procedure HTTPSRVCreateSession(ASender: TIdPeerThread;
      var VHTTPSession: TIdHTTPSession);
    procedure HTTPSRVInvalidSession(Thread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;
      var VContinueProcessing: Boolean; const AInvalidSessionID: String);
    procedure HTTPSRVSessionEnd(Sender: TIdHTTPSession);
    procedure HTTPSRVSessionStart(Sender: TIdHTTPSession);
    procedure HTTPSRVCreatePostStream(ASender: TIdPeerThread;
      var VPostStream: TStream);
    procedure HTTPSRVCommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure HTTPSRVExecute(AThread: TIdPeerThread);
    procedure HTTPSRVCommandOther(Thread: TIdPeerThread; const asCommand,
      asData, asVersion: String);
    procedure HTTPSRVAfterCommandHandler(ASender: TIdTCPServer;
      AThread: TIdPeerThread);
    procedure HTTPSRVBeforeCommandHandler(ASender: TIdTCPServer;
      const AData: String; AThread: TIdPeerThread);
    procedure HTTPSRVListenException(AThread: TIdListenerThread;
      AException: Exception);
    procedure HTTPSRVNoCommandHandler(ASender: TIdTCPServer;
      const AData: String; AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
  end;
//Function setVariable(ObjName,VarName:widestring;value:string);
var
  HTTPSRVForm: THTTPSRVForm;
  jsonobj0:tlkjsonobject;
  jsonobj1 :tlkjsonobject;
  jsonobj2 :tlkjsonobject;
  jsonobj3 :tlkjsonobject;
  subobj:tlkjsonobject;
Function addVariable(objnum:integer;VarName,VarValue:string):integer;
implementation

{$R *.dfm}
Function addVariable(objnum:integer;VarName,VarValue:string):integer;
var
 jsonobj :tlkJsonObject;
begin
  case objnum of
     0:jsonobj:=jsonobj0;
     1:jsonobj:=jsonobj1;
     2:jsonobj:=jsonobj2;
     3:jsonobj:=jsonobj3;
   end;
  jsonobj.Add(varname,varValue);
//  HTTPSRVForm.memo2.Lines.Clear;
//  HTTPSRVForm.memo2.Lines.add(tlkjson.GenerateText(jsonobj));
  tlkjson.GenerateText(jsonobj);
  subobj.Free;
end;

procedure THTTPSRVForm.HTTPSRVConnect(AThread: TIdPeerThread);
begin
// memo1.Lines.Add('connect');
end;

procedure THTTPSRVForm.HTTPSRVDisconnect(AThread: TIdPeerThread);
begin
// memo1.Lines.Add('disconnect');

end;

procedure THTTPSRVForm.HTTPSRVCreateSession(ASender: TIdPeerThread;
  var VHTTPSession: TIdHTTPSession);
begin
// memo1.Lines.Add('create session');

end;

procedure THTTPSRVForm.HTTPSRVInvalidSession(Thread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;
  var VContinueProcessing: Boolean; const AInvalidSessionID: String);
begin
// memo1.Lines.Add('invalid session');

end;

procedure THTTPSRVForm.HTTPSRVSessionEnd(Sender: TIdHTTPSession);
begin
// memo1.Lines.Add('session end');

end;

procedure THTTPSRVForm.HTTPSRVSessionStart(Sender: TIdHTTPSession);
begin
// memo1.Lines.Add('session start');

end;

procedure THTTPSRVForm.HTTPSRVCreatePostStream(ASender: TIdPeerThread;
  var VPostStream: TStream);
begin
//if vpoststream=nil then memo1.Lines.Add('Create post stream stream:nil')
// else memo1.Lines.Add('Create post stream stream:'+IntToStr(VPostStream.Size));

end;

procedure THTTPSRVForm.HTTPSRVCommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  var
  cmd1,resp:string;

begin
cmd1:=trim(arequestinfo.document);
// memo1.Lines.Add('command get:command '+arequestinfo.Command+' document '+arequestinfo.Document+
//  '  params='+ arequestinfo.Params.GetText );
  if arequestinfo.document='/objnum=1' then
    resp:='objnum=1 '+ tlkjson.GenerateText(jsonobj1)
  else if arequestinfo.document='/objnum=2' then
    resp:='objnum=2 '+tlkjson.GenerateText(jsonobj2)
  else  if arequestinfo.document='/objnum=3' then
    resp:='objnum=3 '+tlkjson.GenerateText(jsonobj3)
  else  resp:='objnum=0 '+tlkjson.GenerateText(jsonobj0);
 aResponseInfo.ContentStream:=tmemorystream.create;
 aResponseInfo.ContentStream.Write(resp[1],length(resp));

end;

procedure THTTPSRVForm.HTTPSRVExecute(AThread: TIdPeerThread);
begin
// memo1.Lines.Add('execute');

end;

procedure THTTPSRVForm.HTTPSRVCommandOther(Thread: TIdPeerThread;
  const asCommand, asData, asVersion: String);
begin
// memo1.Lines.Add('command other:'+ascommand+' '+asdata+' '+asversion);

end;

procedure THTTPSRVForm.HTTPSRVAfterCommandHandler(ASender: TIdTCPServer;
  AThread: TIdPeerThread);
begin
// memo1.Lines.Add('after command handler');

end;

procedure THTTPSRVForm.HTTPSRVBeforeCommandHandler(ASender: TIdTCPServer;
  const AData: String; AThread: TIdPeerThread);
begin
// memo1.Lines.Add('before command handler Adata:'+adata);

end;

procedure THTTPSRVForm.HTTPSRVListenException(AThread: TIdListenerThread;
  AException: Exception);
begin
// memo1.Lines.Add('listen exeption');

end;

procedure THTTPSRVForm.HTTPSRVNoCommandHandler(ASender: TIdTCPServer;
  const AData: String; AThread: TIdPeerThread);
begin
// memo1.Lines.Add('No command handler Adata:'+adata);

end;

procedure THTTPSRVForm.FormCreate(Sender: TObject);
var
 ff:tfilestream;
 str1 : string;
 objFileName:string;
 strlist : tstringlist;
begin
 httpsrv.DefaultPort:=9090;
 httpsrv.Active:=true;
(*
  ObjFileName := application.ExeName+'.jdata';
  if fileexists(ObjFileName) then  begin
    strlist:=tstringlist.Create;
    strlist.LoadFromFile(ObjFileName);
    str1:=strlist.Text;
    jsonobj := TlkJSON.ParseText(str1) as TlkJSONobject;
  end else *)


end;

procedure THTTPSRVForm.BitBtn2Click(Sender: TObject);
var
 jsonobj :tlkJsonObject;
begin
  assert(Varname.Text<>'','Variable name must be defined');
  case objnum.ItemIndex of
     0:jsonobj:=jsonobj0;
     1:jsonobj:=jsonobj1;
     2:jsonobj:=jsonobj2;
     3:jsonobj:=jsonobj3;
   end;
  jsonobj.Add(varname.Text,varval.text);
  memo2.Lines.Clear;
  memo2.Lines.add(tlkjson.GenerateText(jsonobj0));
  memo2.Lines.add(tlkjson.GenerateText(jsonobj1));
  memo2.Lines.add(tlkjson.GenerateText(jsonobj2));
  memo2.Lines.add(tlkjson.GenerateText(jsonobj3));

(*
  if jsonobj.Field[Objname.Text] = nil
    then begin
       jsonobj.Add(Objname.Text,subobj);
     end else begin
       jsonobj.Field[Objname.Text].Value:=subobj;
     end;
*)
(*
  memo2.Lines.Clear;
  memo2.Lines.add(tlkjson.GenerateText(jsonobj));
  subobj.Free;
*)
end;

procedure THTTPSRVForm.BitBtn3Click(Sender: TObject);
var
 jsonobj :tlkJsonObject;
// subobj:tlkjsonbase;
 stype:  TlkJSONtypes;
begin
  case objnum.ItemIndex of
     0:jsonobj:=jsonobj0;
     1:jsonobj:=jsonobj1;
     2:jsonobj:=jsonobj2;
     3:jsonobj:=jsonobj3;
   end;
  assert(Varname.Text<>'','Variable name must be defined');
//  subobj:= jsonobj.Field[Objname.Text];
(*
      if jsonobj.Field[objname.text] is TlkJSONnumber then caption:=('type: xs is number!');
      if jsonobj.Field[objname.text] is TlkJSONstring then caption:=('type: xs is string!');
      if jsonobj.Field[objname.text] is TlkJSONboolean then caption:=('type: xs is boolean!');
      if jsonobj.Field[objname.text] is TlkJSONnull then caption:=('type: xs is null!');
      if jsonobj.Field[objname.text] is TlkJSONlist then caption:=('type: xs is list!');
      if jsonobj.Field[objname.text] is TlkJSONobject then begin
        caption:=('type: xs is object!');
      end;
*)
(*
  if subobj = nil
   then varval.Text := 'Отсутствует объект'
   else begin
      stype:=subobj.SelfType;
      if subobj.IndexOfName(varname.Text) <0
        then varval.Text := 'Отсутствует переменная'
        else varval.Text:=tlkjson.GenerateText(subobj.Field[varname.Text]);
   end;

  subobj.Free;
*)
end;
procedure THTTPSRVForm.Timer1Timer(Sender: TObject);
begin
  memo2.Lines.Clear;
  memo2.Lines.add(tlkjson.GenerateText(jsonobj0));
  memo2.Lines.add(tlkjson.GenerateText(jsonobj1));
  memo2.Lines.add(tlkjson.GenerateText(jsonobj2));
  memo2.Lines.add(tlkjson.GenerateText(jsonobj3));
  //THTTPSRVForm
end;

initialization
   jsonobj0:=tlkjsonobject.Create;
   jsonobj1 :=tlkjsonobject.Create;
   jsonobj2 :=tlkjsonobject.Create;
   jsonobj3 :=tlkjsonobject.Create;

end.
