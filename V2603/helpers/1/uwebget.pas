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
Function BeginJson():boolean;
Function SaveJson():boolean;
Function GetJsonStrFromWeb(url : ansistring): ansistring;
Function addVariable (ObjNum : integer; varname, VarValue : string) : integer; overload;
Function addVariable (ObjNum : integer; arrName, Elementid, varname, VarValue : string) : integer; overload;



implementation
Function BeginJson():boolean;
begin

end;
Function SaveJson():boolean;
begin

end;

Function addVariable (ObjNum : integer; varname, VarValue : string) : integer; overload;
begin
end;
Function addVariable (ObjNum : integer; arrName, Elementid, varname, VarValue : string) : integer; overload;
begin

end;

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

    //strlist.savetofile('g:\home\gettext.js');
    result := system.copy(strlist.text,2,length(strlist.text)-2);
    while ( result[length(result)] <> '}') and  (length(result) > 0) do system.delete(result,length(result),1);

end;
end.
