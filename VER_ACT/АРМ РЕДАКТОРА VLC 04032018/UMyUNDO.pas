unit UMyUNDO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls;

var
  ListUNDO: tstringlist;

procedure SaveToUNDO;
procedure LoadFromUNDO;
Procedure ClearUndo;

implementation

uses umain, ucommon, ugrtimelines, udrawtimelines, umyfiles;

Procedure ClearUndo;
begin
  DeleteFilesMask(PathTemp, '*.undo');
  ListUNDO.Clear;
end;

Procedure SaveClipToUNDO(ClipName: string);
var
  Stream: TFileStream;
  renm, FileName: string;
  i: integer;
begin
  FileName := PathTemp + '\' + ClipName + '.undo';
  if FileExists(FileName) then
  begin
    renm := ExtractFilePath(FileName) + 'Temp.undo';
    RenameFile(FileName, renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try
    TLParameters.WriteToStream(Stream);
    // TLHeights.WriteToStream(Stream);
    // Stream.WriteBuffer(Form1.GridTimeLines.RowCount, SizeOf(integer));
    // for i:=1 to Form1.GridTimeLines.RowCount-1
    // do (Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).WriteToStream(Stream);
    ZoneNames.WriteToStream(Stream);
    TLZone.WriteToStream(Stream);
  finally
    FreeAndNil(Stream);
  end
end;

function LoadClipFromUNDO(ClipName: string): boolean;
var
  Stream: TFileStream;
  renm, FileName: string;
  i, cnt: integer;
begin
  result := false;
  FileName := PathTemp + '\' + ClipName + '.undo';
  if not FileExists(FileName) then
    exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
    TLParameters.ReadFromStream(Stream);
    // TLHeights.ReadFromStream(Stream);
    // Stream.ReadBuffer(cnt, SizeOf(integer));
    // if cnt < Form1.GridTimeLines.RowCount then begin
    // For i:= Form1.GridTimeLines.RowCount - 1 to cnt-1
    // do Form1.GridTimeLines.Objects[0,i]:=nil;
    // end;
    // Form1.GridTimeLines.RowCount:=cnt;
    // For i:=1 to Form1.GridTimeLines.RowCount-1 do begin
    // if not (Form1.GridTimeLines.Objects[0,i] is TTimelineOptions)
    // then Form1.GridTimeLines.Objects[0,i] := TTimelineOptions.Create;
    // (Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).ReadFromStream(Stream);
    // end;

    ZoneNames.ReadFromStream(Stream);
    TLZone.ReadFromStream(Stream);
    result := true;
  finally
    FreeAndNil(Stream);
  end
end;

procedure SaveToUNDO;
var
  nm: string;
begin
  nm := 'TMP' + createunicumname;
  if ListUNDO.Count > depthundo then
    ListUNDO.Delete(0);
  ListUNDO.Add(nm);
  SaveClipToUNDO(nm);
end;

procedure LoadFromUNDO;
var
  nm, FileName, renm: string;
begin
  if ListUNDO.Count <= 0 then
    exit;
  nm := ListUNDO.Strings[ListUNDO.Count - 1];
  LoadClipFromUNDO(nm);
  ListUNDO.Delete(ListUNDO.Count - 1);
  FileName := PathTemp + '\' + nm + '.undo';
  if FileExists(FileName) then
  begin
    renm := ExtractFilePath(FileName) + 'Temp.undo';
    RenameFile(FileName, renm);
    DeleteFile(renm);
  end;
end;

initialization

ListUNDO := tstringlist.Create;
ListUNDO.Clear;

finalization

ListUNDO.Free;
ListUNDO := nil;

end.
