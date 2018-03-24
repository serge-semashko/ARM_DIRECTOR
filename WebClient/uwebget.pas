unit uwebget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,strutils, httpsend,system.win.crtl;


var
  PortNum : integer = 9091;
 chbuf : array[0..100000] of char;
  tmpjSon : ansistring;
  Jevent, JDev, jAirsecond : TStringList;
  Jmain : ansistring;
  jsonresult : ansistring;
Function GetJsonStrFromWeb(url : ansistring): ansistring;


implementation

Function GetJsonStrFromWeb(url : ansistring): ansistring;
var
 http : thttpsend;
 jsonstr : ansistring;
 strlist : tstringlist;
 httpstr : ansistring;
 i : integer;
 str1 : ansistring;
 mstr : tmemorystream;
 ff : tfilestream;
begin
    result := '';
    strlist := tstringlist.create;
    httpgettext(url,strlist);
    strlist.savetofile('g:\home\gettext.js');
    http := THTTPSend.Create;
    HTTP.HTTPMethod('GET', url);
    mstr := HTTP.Document;
    fillchar(chbuf[0],50000,0);
    memcpy(@chbuf[0],mstr.memory,mstr.size);
    ff := tfilestream.create('g:\home\memstr1.js',fmcreate);
    ff.write(mstr.memory^,mstr.size);
    ff.free;
    result := chbuf;
    i := 1;
end;
end.
