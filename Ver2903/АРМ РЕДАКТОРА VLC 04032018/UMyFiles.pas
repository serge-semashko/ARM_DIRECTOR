unit UMyFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer, MMSystem;

// Procedure SaveGridToFile(FileName : string; Grid : tstringgrid);
// function LoadGridFromFile(FileName : string; Grid : tstringgrid) : boolean;
procedure DeleteFilesMask(Dir: AnsiString; Mask: string);

procedure WriteBufferStr(F: tStream; astr: widestring);

procedure ReadBufferStr(F: tStream; out astr: string); overload;

procedure ReadBufferStr(F: tStream; out astr: tfontname); overload;

procedure ReadBufferStr(F: tStream; out astr: widestring); overload;

function LoadClipEditingFromFile(ClipName: string): boolean;

procedure SaveClipEditingToFile(ClipName: string);

function KillDir(Directory: string): boolean;

function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): boolean;

function FullDirectoryCopy(SourceDir, TargetDir: string;
  StopIfNotAllCopied, OverWriteFiles: boolean): boolean;

procedure SetTaskOnDelete(prj: string);

procedure ExecTaskOnDelete;
// Procedure LoadGridTimelinesFromFile(FileName : string; grid : tstringgrid);

procedure WriteLog(FileName: string; log: widestring);

procedure SaveProjectToFile(FileName: string);

procedure ReadProjectFromFile(FileName: string);

implementation

uses
  umain, ucommon, ugrid, utimeline, UGRTimelines, udrawtimelines,
  umytexttemplate, uimagetemplate, uinitforms, ufrsaveproject, umymessage,
  umytexttable;

procedure ExecTaskOnDelete;
var
  lst: tstrings;
  i: integer;
  s: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete');
    if FileExists(AppPath + DirProjects + '\List.tsk') then
    begin
      lst := tstringlist.Create;
      lst.Clear;
      try
        lst.LoadFromFile(AppPath + DirProjects + '\List.tsk');
        for i := lst.Count - 1 downto 0 do
        begin
          s := AppPath + DirProjects + '\' + trim(lst.Strings[i]);
          if DirectoryExists(s) then
          begin
            if KillDir(s) then
            begin
              lst.Delete(i);
              WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete KillDir ' + s);
            end;
          end
          else
          begin
            lst.Delete(i);
          end;
        end;
        if lst.Count <= 0 then
        begin
          SysUtils.DeleteFile(AppPath + DirProjects + '\List.tsk');
          WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete - Все задачи выполнены');
        end
        else
        begin
          lst.SaveToFile(AppPath + DirProjects + '\List.tsk');
          WriteLog('MAIN',
            'UMyFiles.ExecTaskOnDelete - Не все задачи выполнены');
        end;
      finally
        lst.Free;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete | ' + E.Message);
  end;
end;

procedure SetTaskOnDelete(prj: string);
var
  lst: tstrings;
begin
  try
    WriteLog('MAIN', 'UMyFiles.SetTaskOnDelete Task=' + prj);
    lst := tstringlist.Create;
    lst.Clear;
    try
      if FileExists(AppPath + DirProjects + '\List.tsk') then
        lst.LoadFromFile(AppPath + DirProjects + '\List.tsk');
      if trim(prj) <> '' then
        lst.Add(trim(prj));
      DeleteFile(AppPath + DirProjects + '\List.tsk');
      lst.SaveToFile(AppPath + DirProjects + '\List.tsk');
    finally
      lst.Free;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.SetTaskOnDelete Task=' + prj + ' | ' +
        E.Message);
  end;
end;

function FullDirectoryCopy(SourceDir, TargetDir: string;
  StopIfNotAllCopied, OverWriteFiles: boolean): boolean;
var
  SR: TSearchRec;
  i: integer;
begin
  try
    WriteLog('MAIN', 'UMyFiles.FullDirectoryCopy SDir=' + SourceDir + ' TDir=' +
      TargetDir);
    Result := False;
    SourceDir := IncludeTrailingBackslash(SourceDir);
    TargetDir := IncludeTrailingBackslash(TargetDir);
    if not DirectoryExists(SourceDir) then
      Exit;
    if not ForceDirectories(TargetDir) then
      Exit;

    i := FindFirst(SourceDir + '*', faAnyFile, SR);
    try
      while i = 0 do
      begin
        if (SR.Name <> '') and (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          if SR.Attr = faDirectory then
          begin
            Result := FullDirectoryCopy(SourceDir + SR.Name,
              TargetDir + SR.Name, StopIfNotAllCopied, OverWriteFiles)
          end
          else
          begin
            if not(not OverWriteFiles and FileExists(TargetDir + SR.Name)) then
            begin
              Result := CopyFile(Pchar(SourceDir + SR.Name),
                Pchar(TargetDir + SR.Name), False);
              if Result then
                WriteLog('MAIN', 'UMyFiles.FullDirectoryCopy File SFile=' +
                  SourceDir + SR.Name + ' TFile=' + TargetDir + SR.Name);
            end
            else
            begin
              Result := True;
            end;
          end;
          if not Result and StopIfNotAllCopied then
            Exit;
        end;
        i := FindNext(SR);
      end;
    finally
      SysUtils.FindClose(SR);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.FullDirectoryCopy SDir=' + SourceDir + ' TDir='
        + TargetDir + ' | ' + E.Message);
  end;
end;

function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): boolean;
var
  i: integer;
  SRec: TSearchRec;
  FN: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.FullRemoveDir Dir=' + Dir);
    Result := False;
    if not DirectoryExists(Dir) then
      Exit;
    Result := True;
    // Удаляем слеш и задаем маску все файлы в директории
    Dir := IncludeTrailingBackslash(Dir);
    i := FindFirst(Dir + '*', faAnyFile, SRec);
    try
      while i = 0 do
      begin
        // Получаем полный путь к файлу или директории
        FN := Dir + SRec.Name;
        // если это директория
        if SRec.Attr = faDirectory then
        begin
          // рекурсивный вызов этой же функции с ключом удаления корня
          if (SRec.Name <> '') and (SRec.Name <> '.') and (SRec.Name <> '..')
          then
          begin
            if DeleteAllFilesAndFolders then
              FileSetAttr(FN, faArchive);
            Result := FullRemoveDir(FN, DeleteAllFilesAndFolders,
              StopIfNotAllDeleted, True);
            if not Result and StopIfNotAllDeleted then
              Exit;
          end;
        end
        else
        begin
          if DeleteAllFilesAndFolders then
            FileSetAttr(FN, faArchive);
          Result := SysUtils.DeleteFile(FN);
          if Result then
            WriteLog('MAIN', 'UMyFiles.FullRemoveDir Delete File: ' + FN);
          if not Result and StopIfNotAllDeleted then
            Exit;
        end;
        // берем следующий файл или директорию
        i := FindNext(SRec);
      end;
    finally
      SysUtils.FindClose(SRec);
    end;
    if not Result then
      Exit;
    if RemoveRoot then
    begin // если необходимо удалить корень удаляем
      if not RemoveDir(Dir) then
        Result := False
      else
        WriteLog('MAIN', 'UMyFiles.FullRemoveDir Delete Dir: ' + Dir);;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.FullRemoveDir Dir=' + Dir + ' | ' + E.Message);
  end;
end;

procedure DeleteFilesMask(Dir: AnsiString; Mask: string);
var
  SR: SysUtils.TSearchRec;
begin
{$I-}
  try
    WriteLog('MAIN', 'UMyFiles.DeleteFilesMask Dir=' + Dir + ' Mask=' + Mask);
    if (Dir <> '') and (Dir[length(Dir)] = '\') then
      Delete(Dir, length(Dir), 1);
    if FindFirst(Dir + '\' + Mask, faDirectory + faHidden + faSysFile +
      faReadonly + faArchive, SR) = 0 then
      repeat
        if (SR.Name = '.') or (SR.Name = '..') then
          continue;
        if (SR.Attr and faDirectory <> faDirectory) then
        begin
          // if AnsiLowerCase(ExtractFileExt(sr.Name)) = '.tmp' then begin
          FileSetReadOnly(Dir + '\' + SR.Name, False);
          DeleteFile(Dir + '\' + SR.Name);
          WriteLog('MAIN', 'UMyFiles.DeleteFilesMask Dir=' + Dir + ' Mask=' +
            Mask + ' | Delete File:' + SR.Name);
          // end
        end;
      until FindNext(SR) <> 0;
    FindClose(SR);
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.DeleteFilesMask Dir=' + Dir + ' Mask=' + Mask +
        ' | ' + E.Message);
  end;
end;

function KillDir(Directory: string): boolean;
var
  SR: SysUtils.TSearchRec;
  Dir: AnsiString;
begin
{$I-}
  try
    WriteLog('MAIN', 'UMyFiles.KillDir Dir=' + Dir);
    Dir := PAnsiChar(Directory);
    if (Dir <> '') and (Dir[length(Dir)] = '\') then
      Delete(Dir, length(Dir), 1);

    if FindFirst(Dir + '\*.*', faDirectory + faHidden + faSysFile + faReadonly +
      faArchive, SR) = 0 then
      repeat
        if (SR.Name = '.') or (SR.Name = '..') then
          continue;
        if (SR.Attr and faDirectory <> faDirectory) then
        begin
          FileSetReadOnly(Dir + '\' + SR.Name, False);
          DeleteFile(Dir + '\' + SR.Name);
          WriteLog('MAIN', 'UMyFiles.KillDir Dir=' + Dir + ' | Delete File:'
            + SR.Name);
        end
        else
        begin
          KillDir(Dir + '\' + SR.Name);
        end;
      until FindNext(SR) <> 0;

    FindClose(SR);
    RemoveDir(Dir); // Удалит пустой каталог
    WriteLog('MAIN', 'UMyFiles.KillDir Delete Dir=' + Dir);
    KillDir := (FileGetAttr(Dir) = -1);
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.KillDir Dir=' + Dir + ' | ' + E.Message);
  end;
end;

procedure WriteBufferStr(F: tStream; astr: widestring);
var
  Len: longint;
begin
  Len := length(astr);
  F.WriteBuffer(Len, SizeOf(Len));
  if Len > 0 then
    F.WriteBuffer(astr[1], length(astr) * SizeOf(astr[1]));
end;

procedure ReadBufferStr(F: tStream; out astr: string); overload;
var
  Len: longint;
  ws: widestring;
begin
  F.ReadBuffer(Len, SizeOf(Len));
  Setlength(ws, Len);
  if Len > 0 then
    F.ReadBuffer(ws[1], length(ws) * SizeOf(ws[1]));
  astr := ws;
end;

procedure ReadBufferStr(F: tStream; out astr: tfontname); overload;
var
  Len: longint;
  ws: widestring;
begin
  F.ReadBuffer(Len, SizeOf(Len));
  Setlength(ws, Len);
  if Len > 0 then
    F.ReadBuffer(ws[1], length(ws) * SizeOf(ws[1]));
  astr := ws;
end;

procedure ReadBufferStr(F: tStream; out astr: widestring); overload;
var
  Len: longint;
  ws: widestring;
begin
  F.ReadBuffer(Len, SizeOf(Len));
  Setlength(ws, Len);
  if Len > 0 then
    F.ReadBuffer(ws[1], length(ws) * SizeOf(ws[1]));
  astr := ws;
end;

procedure WriteLog(FileName: string; log: widestring);
var
  F: TextFile;
  txt, FN: string;
  Day, Month, Year: Word;
begin
  if not MakeLogging then
    Exit;
  try
    DecodeDate(now, Year, Month, Day);
    PathLog := extractfilepath(application.ExeName) + 'Log';
    if not DirectoryExists(PathLog) then
      ForceDirectories(PathLog);
    FN := PathLog + '\' + trim(FileName) + TwoDigit(Day) + TwoDigit(Month) +
      inttostr(Year) + '.log';
    AssignFile(F, FN);
    try
      if FileExists(FN) then
        Append(F)
      else
        Rewrite(F);
      DateTimeToString(txt, 'dd.mm.yyyy hh:mm:ss:ms', now);
      Writeln(F, txt + ' |' + ProjectNumber + '| ' + log);
    except
    end;
  finally
    CloseFile(F);
  end
end;

procedure SaveClipEditingToFile(ClipName: string);
var
  Stream: TFileStream;
  renm, FileName: string;
  i: integer;
begin
  try
    WriteLog('MAIN', 'UMyFiles.SaveClipEditingToFile Start ClipName=' +
      ClipName);
    FileName := PathClips + '\' + ClipName + '.Clip';
    if FileExists(FileName) then
    begin
      renm := extractfilepath(FileName) + 'Temp.Clip';
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
      WriteLog('MAIN', 'UMyFiles.SaveClipEditingToFile Finish ClipName=' +
        ClipName);
    end
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.SaveClipEditingToFile ClipName=' + ClipName +
        ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

function LoadClipEditingFromFile(ClipName: string): boolean;
var
  Stream: TFileStream;
  renm, FileName: string;
  i, cnt: integer;
begin
  try
    WriteLog('MAIN', 'UMyFiles.LoadClipEditingFromFile Start ClipName=' +
      ClipName);
    Result := False;
    FileName := PathClips + '\' + ClipName + '.Clip';
    if not FileExists(FileName) then
      Exit;
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
      Result := True;
    finally
      FreeAndNil(Stream);
      WriteLog('MAIN', 'UMyFiles.LoadClipEditingFromFile Finish ClipName=' +
        ClipName);
    end
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.LoadClipEditingFromFile ClipName=' + ClipName +
        ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

// Procedure SaveGridToFile(FileName : string; Grid : tstringgrid);
// var Stream : TFileStream;
// i, j, rw, ph : integer;
// sz, ps : longint;
// renm : string;
// begin
// try
// WriteLog('MAIN', 'UMyFiles.SaveGridToFile Start FileName=' + FileName + ' Grid=' + Grid.Name);
// if trim(ExtractFileName(FileName))='' then exit;
// if FileExists(FileName) then begin
// renm := ExtractFilePath(FileName) + 'Temp.prjl';
// RenameFile(FileName,renm);
// DeleteFile(renm);
// end;
// Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
// try
// Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));
// for i:=0 to grid.RowCount-1 do (grid.Objects[0,i] as TGridRows).WriteToStream(Stream);
// finally
// FreeAndNil(Stream);
// WriteLog('MAIN', 'UMyFiles.SaveGridToFile Finish FileName=' + FileName + ' Grid=' + Grid.Name);
// end;
// except
// on E: Exception do begin
// WriteLog('MAIN', 'UMyFiles.SaveGridToFile FileName=' + FileName + ' Grid=' + Grid.Name + ' | ' + E.Message);
// FreeAndNil(Stream);
// end else FreeAndNil(Stream);
// end;
// end;

procedure SaveGridToStream(Stream: TFileStream; Grid: tstringgrid);
var
  i, j, rw, ph: integer;
  sz, ps: longint;
  renm: string;
begin
  Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));
  for i := 0 to Grid.RowCount - 1 do
    (Grid.Objects[0, i] as TGridRows).WriteToStream(Stream);
end;

// function LoadGridFromFile(FileName : string; Grid : tstringgrid) : boolean;
// var Stream : TFileStream;
// i, j, rw, ph, pp, cnt, cnt1, cnt2 : integer;
// sz, ps : longint;
// renm : string;
// tc : TTypeCell;
// begin
// try
// WriteLog('MAIN', 'UMyFiles.LoadGridFromFile Start FileName=' + FileName + ' Grid=' + Grid.Name);
// result:=false;
// if not FileExists(FileName) then exit;
// Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
// try
// Stream.ReadBuffer(cnt, SizeOf(integer));
// for i:=0 to grid.RowCount-1 do grid.Objects[0,i]:=nil;
// grid.RowCount:=cnt;
// for i:=0 to grid.RowCount-1 do begin
// if not (grid.Objects[0,i] is TGridRows) then grid.Objects[0,i] := TGridRows.Create;
// (grid.Objects[0,i] as TGridRows).ReadFromStream(Stream);
// (grid.Objects[0,i] as TGridRows).SetDefaultFonts;
// end;
// finally
// FreeAndNil(Stream);
// WriteLog('MAIN', 'UMyFiles.LoadGridFromFile Finish FileName=' + FileName + ' Grid=' + Grid.Name);
// end;
// result:=true;
// except
// on E: Exception do begin
// WriteLog('MAIN', 'UMyFiles.LoadGridFromFile FileName=' + FileName + ' Grid=' + Grid.Name + ' | ' + E.Message);
// FreeAndNil(Stream);
// end else FreeAndNil(Stream);
// end;
// end;

function LoadGridFromStream(Stream: TFileStream; Grid: tstringgrid): boolean;
var
  i, j, rw, ph, pp, cnt, cnt1, cnt2: integer;
  sz, ps: longint;
  renm: string;
  tc: TTypeCell;
begin
  // try
  WriteLog('MAIN', 'UMyFiles.LoadGridFromStream Start Grid=' + Grid.Name);
  Result := False;
  Stream.ReadBuffer(cnt, SizeOf(integer));
  for i := 0 to Grid.RowCount - 1 do
    Grid.Objects[0, i] := nil;
  Grid.RowCount := cnt;
  for i := 0 to Grid.RowCount - 1 do
  begin
    if not(Grid.Objects[0, i] is TGridRows) then
      Grid.Objects[0, i] := TGridRows.Create;
    (Grid.Objects[0, i] as TGridRows).ReadFromStream(Stream);
    (Grid.Objects[0, i] as TGridRows).SetDefaultFonts;
  end;
  Result := True;
end;

procedure SaveGridTimelinesToStream(Stream: TFileStream; Grid: tstringgrid);
var
  i: integer;
begin
  Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));
  for i := 1 to Grid.RowCount - 1 do
    (Grid.Objects[0, i] as TTimelineOptions).WriteToStream(Stream);
  WriteLog('MAIN', 'UMyFiles.SaveGridTimelinesToStream Finish Grid=' +
    Grid.Name);
end;

procedure LoadGridTimelinesFromStream(Stream: TFileStream; Grid: tstringgrid);
var
  i, cnt: integer;
begin
  Stream.ReadBuffer(cnt, SizeOf(integer));
  for i := 1 to Grid.RowCount - 1 do
    Grid.Objects[0, i] := nil;
  Grid.RowCount := cnt;
  for i := 1 to Grid.RowCount - 1 do
  begin
    Grid.Objects[0, i] := TTimelineOptions.Create;
    (Grid.Objects[0, i] as TTimelineOptions).ReadFromStream(Stream);
  end;
end;

procedure WriteFileToStream(Stream: TFileStream; FileName: string);
var
  TempStream: TFileStream;
  ps, sz: int64;
begin
  if not FileExists(FileName) then
    WriteBufferStr(Stream, '@#None#@')
  else
  begin
    try
      WriteBufferStr(Stream, extractfilename(FileName));
      TempStream := TFileStream.Create(FileName, fmOpenReadWrite or
        fmShareDenyNone);
      sz := TempStream.Size;
      Stream.WriteBuffer(sz, SizeOf(sz));
      ps := Stream.Position;
      Stream.CopyFrom(TempStream, TempStream.Size);
      ps := Stream.Position;
    finally
      FreeAndNil(TempStream);
    end;
  end;
end;

procedure ReadFileFromStream(Stream: TFileStream; DirName: string);
var
  TempStream: TFileStream;
  ps, sz: int64;
  renm, FileName: string;
begin
  if not DirectoryExists(DirName) then
    ForceDirectories(DirName);

  ReadBufferStr(Stream, FileName);
  if trim(FileName) = '@#None#@' then
    Exit;
  FileName := DirName + '\' + trim(FileName);
  if FileExists(FileName) then
  begin
    renm := extractfilepath(FileName) + 'Temp.tprj';
    RenameFile(FileName, renm);
    DeleteFile(renm);
  end;

  TempStream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try
    Stream.ReadBuffer(sz, SizeOf(sz));
    ps := Stream.Position;
    TempStream.CopyFrom(Stream, sz);
    ps := Stream.Position;
  finally
    FreeAndNil(TempStream);
  end;
end;

procedure SaveProjectToFile(FileName: string);
var
  Stream, Temp: TFileStream;
  renm, stemp, nm: string;
  i, itemp, rw: integer;
  ps: int64;
  lst: tstrings;
  SR: TSearchRec;
  cnt: Word;
begin
  try
    try
      WriteLog('MAIN', 'UMyFiles.SaveProjectToFile Start FileName=' + FileName);
      if FileExists(FileName) then
      begin
        renm := extractfilepath(FileName) + 'Temp.tprj';
        RenameFile(FileName, renm);
        DeleteFile(renm);
      end;

      Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
      frSaveProject.Show;
      frSaveProject.Label1.Caption := 'Сохранение параметров проекта';
      frSaveProject.Label2.Caption := 'Сохранение проекта' + #13#10 +
        extractfilename(FileNameProject);
      frSaveProject.ProgressBar1.Position := 0;
      Delay(50);
      // Записываем параметры проекта
      WriteBufferStr(Stream, ProjectNumber);
      stemp := pntlproj.GetText('ProjectName'); // Form1.lbProjectName.Caption;
      WriteBufferStr(Stream, stemp);
      stemp := pntlproj.GetText('CommentText');
      // stemp:=Form1.lbpComment.Caption;
      WriteBufferStr(Stream, stemp);
      stemp := pntlproj.GetText('DateStart');
      // stemp:=Form1.lbDateStart.Caption;
      WriteBufferStr(Stream, stemp);
      stemp := pntlproj.GetText('DateEnd'); // stemp:=Form1.lbDateEnd.Caption;
      WriteBufferStr(Stream, stemp);
      frSaveProject.Label1.Caption := 'Сохранение таблицы плей-листов';
      frSaveProject.ProgressBar1.Position := 5;
      Delay(50);
      // Записываем содержимое таблицы Список плей-листов
      SaveGridToStream(Stream, Form1.GridLists);
      if Form1.GridLists.RowCount < 0 then
        Form1.GridLists.RowCount := 0;
      ps := Stream.Position;
      Stream.WriteBuffer(Form1.GridLists.RowCount, SizeOf(integer));
      ps := Stream.Position;
      if Form1.GridLists.RowCount > 0 then
      begin
        for i := 1 to Form1.GridLists.RowCount - 1 do
        begin
          nm := '\' + (Form1.GridLists.Objects[0, i] as TGridRows).MyCells[3]
            .ReadPhrase('Note');
          renm := PathPlayLists + nm;
          WriteFileToStream(Stream, renm);
        end;
      end;
      frSaveProject.Label1.Caption := 'Сохранение таблицы клипов';
      frSaveProject.ProgressBar1.Position := 15;
      Delay(50);
      // Записываем содержимое таблицы клипов
      SaveGridToStream(Stream, Form1.GridClips);
      if Form1.GridClips.RowCount < 0 then
        Form1.GridClips.RowCount := 0;
      Stream.WriteBuffer(Form1.GridClips.RowCount, SizeOf(integer));
      if Form1.GridClips.RowCount > 0 then
      begin
        for i := 1 to Form1.GridClips.RowCount - 1 do
        begin
          nm := '\' + (Form1.GridClips.Objects[0, i] as TGridRows).MyCells[3]
            .ReadPhrase('ClipID') + '.clip';
          renm := PathClips + nm;
          WriteFileToStream(Stream, renm);
        end;
      end;
      frSaveProject.Label1.Caption := 'Сохранение настроек тайм-линий';
      frSaveProject.ProgressBar1.Position := 55;
      Delay(50);
      // Записываем таблицу тайм-линий
      SaveGridTimelinesToStream(Stream, Form1.GridTimeLines);
      frSaveProject.Label1.Caption := 'Сохранение текстовых шаблонов';
      frSaveProject.ProgressBar1.Position := 65;
      Delay(50);
      // Записываем текстовые шаблоны
      SaveTextTemplateToStream(Stream);
      frSaveProject.Label1.Caption := 'Сохранение графических шаблонов';
      frSaveProject.ProgressBar1.Position := 85;
      Delay(50);
      // Записываем графические шаблоны
      SaveGridToStream(Stream, FGRTemplate.GridImgTemplate);
      if FGRTemplate.GridImgTemplate.RowCount < 0 then
        FGRTemplate.GridImgTemplate.RowCount := 0;
      Stream.WriteBuffer(FGRTemplate.GridImgTemplate.RowCount, SizeOf(integer));
      if FGRTemplate.GridImgTemplate.RowCount > 0 then
      begin
        for rw := 0 to FGRTemplate.GridImgTemplate.RowCount - 1 do
        begin
          if FGRTemplate.GridImgTemplate.Objects[0, rw] is TGridRows then
          begin
            for i := 0 to FGRTemplate.GridImgTemplate.ColCount - 1 do
            begin
              if (FGRTemplate.GridImgTemplate.Objects[0, rw] as TGridRows)
                .MyCells[i].CellType = tsImage then
              begin
                nm := (FGRTemplate.GridImgTemplate.Objects[0, rw] as TGridRows)
                  .MyCells[i].ReadPhrase('File');
                renm := pathtemplates + '\' + nm;
                WriteFileToStream(Stream, renm);
              end;
            end;
          end;
        end;
      end;

      frSaveProject.Label1.Caption := 'Сохранение списка горячих клавиш';
      frSaveProject.ProgressBar1.Position := 92;
      Delay(50);
      // Записываем Список горячих клавиш
      WorkHotKeys.WriteToStream(Stream);
      lst := tstringlist.Create;
      lst.Clear;
      try
        // =====================
        i := SysUtils.FindFirst(PathKeyLayouts + '\' + '*.klns', faAnyFile, SR);
        try
          while i = 0 do
          begin
            if (SR.Name <> '') and (SR.Name <> '.') and (SR.Name <> '..') then
            begin
              if SR.Attr <> faDirectory then
              begin
                nm := extractfilename(SR.Name);
                lst.Add(nm);
              end;
            end;
            i := SysUtils.FindNext(SR);
          end;
        finally
          SysUtils.FindClose(SR);
        end;
        // ======================
        cnt := lst.Count;
        Stream.WriteBuffer(cnt, SizeOf(Word));
        if lst.Count > 0 then
        begin
          for i := 0 to lst.Count - 1 do
          begin
            renm := PathKeyLayouts + '\' + lst.Strings[i];
            WriteFileToStream(Stream, renm);
          end;
        end;
      finally
        lst.Free;
      end;
      //
      frSaveProject.Label1.Caption := 'Сохранение закончено';
      frSaveProject.ProgressBar1.Position := 100;
      Delay(200);
      frSaveProject.Close;
      WriteLog('MAIN', 'UMyFiles.SaveProjectToFile Finish FileName=' +
        FileName);
    finally
      FreeAndNil(Stream);
    end;
  except
    FreeAndNil(Stream);
    frSaveProject.Close;
    MyTextMessage('Сообщение', 'Ошибка сохранения проекта ' + FileName, 1);
  end;
end;

procedure ReadProjectFromFile(FileName: string);
var
  Stream, Temp: TFileStream;
  renm, stemp, nm: string;
  i, j, itemp, cnt, hghtgr: integer;
  ps: int64;
  cntw: Word;
begin
  try
    try
      WriteLog('MAIN', 'UMyFiles.ReadProjectFromFile Start FileName=' +
        FileName);
      if not FileExists(FileName) then
      begin
        MessageDlg('Файл ' + FileName + ' не найден.', mtInformation,
          [mbOk], 0, mbOk);
        Exit;
      end;

      Stream := TFileStream.Create(FileName, fmOpenReadWrite or
        fmShareDenyNone);
      frSaveProject.Show;
      // Записываем параметры проекта
      frSaveProject.Label1.Caption := 'Загружаем параметры проекта';
      frSaveProject.Label2.Caption := 'Загрузка проекта' + #13#10 +
        extractfilename(FileNameProject);
      frSaveProject.ProgressBar1.Position := 0;
      Delay(50);
      ReadBufferStr(Stream, ProjectNumber);
      stemp := '';
      ReadBufferStr(Stream, stemp);
      pntlproj.SetText('ProjectName', stemp);
      // Form1.lbProjectName.Caption:=stemp;
      stemp := '';
      ReadBufferStr(Stream, stemp);
      pntlproj.SetText('CommentText', stemp);
      // Form1.lbpComment.Caption:=stemp;
      stemp := '';
      ReadBufferStr(Stream, stemp);
      pntlproj.SetText('DateStart', stemp); // Form1.lbDateStart.Caption:=stemp;
      stemp := '';
      ReadBufferStr(Stream, stemp);
      pntlproj.SetText('DateEnd', stemp); // Form1.lbDateEnd.Caption:=stemp;
      pntlproj.SetText('FileName', extractfilename(FileName)); //
      frSaveProject.Label1.Caption := 'Загружаем таблицу плей-листов';
      frSaveProject.ProgressBar1.Position := 5;
      Delay(50);
      // Считываем содержимое таблицы Список плей-листов
      LoadGridFromStream(Stream, Form1.GridLists);
      ps := Stream.Position;
      Stream.ReadBuffer(cnt, SizeOf(integer));
      ps := Stream.Position;
      if cnt > 0 then
      begin
        for i := 1 to cnt - 1 do
          ReadFileFromStream(Stream, PathPlayLists);
      end;
      frSaveProject.Label1.Caption := 'Загружаем таблицу клипов';
      frSaveProject.ProgressBar1.Position := 15;
      Delay(50);
      // Считываем содержимое таблицы клипов
      LoadGridFromStream(Stream, Form1.GridClips);
      Stream.ReadBuffer(cnt, SizeOf(integer));
      if cnt > 0 then
        for i := 1 to cnt - 1 do
          ReadFileFromStream(Stream, PathClips);
      frSaveProject.Label1.Caption := 'Загружаем настройки тайм-линий';
      frSaveProject.ProgressBar1.Position := 55;
      Delay(50);
      // Считываем таблицу тайм-линий
      LoadGridTimelinesFromStream(Stream, Form1.GridTimeLines);
      frSaveProject.Label1.Caption := 'Загружаем текстовые шаблоны';
      frSaveProject.ProgressBar1.Position := 65;
      hghtgr := 0;
      for j := 0 to Form1.GridTimeLines.RowCount - 1 do
        hghtgr := hghtgr + Form1.GridTimeLines.RowHeights[j];
      Form1.GridTimeLines.Height := hghtgr;
      Form1.GridTimeLines.Repaint;
      Delay(50);
      // ssssjson
      PutGridTimeLinesToServer(Form1.GridTimeLines);
      // Считываем текстовые шаблоны
      LoadTextTemplateFromStream(Stream);
      frSaveProject.Label1.Caption := 'Загружаем графические шаблоны';
      frSaveProject.ProgressBar1.Position := 85;
      Delay(50);
      // Считываем графические шаблоны
      LoadGridFromStream(Stream, FGRTemplate.GridImgTemplate);
      Stream.ReadBuffer(cnt, SizeOf(integer));
      if cnt > 0 then
        for i := 0 to cnt - 1 do
          ReadFileFromStream(Stream, pathtemplates);
      updateImageTemplateGrids;

      frSaveProject.Label1.Caption := 'Загружаем список горячих клавиш';
      frSaveProject.ProgressBar1.Position := 92;
      Delay(50);
      // Записываем Список горячих клавиш
      WorkHotKeys.ReadFromStream(Stream);
      Stream.ReadBuffer(cntw, SizeOf(Word));
      if cntw > 0 then
      begin
        for i := 0 to cntw - 1 do
        begin
          ReadFileFromStream(Stream, PathKeyLayouts);
        end;
      end;

      frSaveProject.Label1.Caption := 'Загрузка закончена';
      frSaveProject.ProgressBar1.Position := 100;
      Delay(200);
      frSaveProject.Close;

      WriteLog('MAIN', 'UMyFiles.ReadProjectFromFile Finish FileName=' +
        FileName);
    finally
      FreeAndNil(Stream);
      pntlproj.Draw(Form1.imgpntlproj.Canvas);
      Form1.imgpntlproj.Repaint;
    end;
  except
    FreeAndNil(Stream);
    frSaveProject.Close;
    pntlproj.Draw(Form1.imgpntlproj.Canvas);
    Form1.imgpntlproj.Repaint;
    MyTextMessage('Сообщение', 'Ошибка при восстановлении проекта ' +
      FileName, 1);
  end;
end;

end.
