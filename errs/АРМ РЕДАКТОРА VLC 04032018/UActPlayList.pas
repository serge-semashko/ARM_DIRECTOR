unit UActPlayList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, System.json, uwebget;

procedure LoadClipsToActPlayList(PLName: string);
procedure LoadClipsToPlayList;
Procedure LoadClipsToPlayer;
procedure LoadPredClipToPlayer;
procedure LoadNextClipToPlayer;
Procedure LoadFileToPlayer(FileName: string);
procedure CheckedActivePlayList;
procedure SetButtonsPredNext;
function ClipExists(Grid: tstringgrid; ClipID: string): boolean;
function FindClipinGrid(Grid: tstringgrid; ClipID: string): integer;
procedure GridActvePLToPanel(ARow: integer);
procedure LoadDefaultClipToPlayer;
procedure SavePlayListFromGridToFile(FName: string);

implementation

uses umain, ucommon, ugrid, uimportfiles, ugrtimelines, utimeline,
  udrawtimelines,
  uairdraw, umyfiles, UIMGButtons, umymessage, umyundo, uplaylists,
  umytexttable;

procedure GridActvePLToPanel(ARow: integer);
var
  i: integer;
  dur: longint;
  txt: string;
begin
  try
    WriteLog('MAIN', 'UActPlayList.GridActvePLToPanel ARow=' + inttostr(ARow));
    if Not(Form1.GridActPlayList.Objects[0, ARow] is TGridRows) then
      exit;
    with (Form1.GridActPlayList.Objects[0, ARow] as TGridRows).MyCells[3] do
    begin
      if ARow >= 1 then
      begin
        pntlplist.SetText('ClipName', trim(ReadPhrase('Clip')));
        pntlplist.SetText('SongName', trim(ReadPhrase('Song')));
        pntlplist.SetText('SingerName', trim(ReadPhrase('Singer')));
        pntlplist.SetText('CommentText', trim(ReadPhrase('Comment')));
        pntlplist.SetText('FileName', trim(ReadPhrase('File')));
        pntlplist.SetText('NTK', trim(ReadPhrase('NTK')));
        pntlplist.SetText('DurMedia', trim(ReadPhrase('Duration')));
        pntlplist.SetText('DurPlay', trim(ReadPhrase('Dur')));
        pntlplist.SetText('StartTime', trim(ReadPhrase('StartTime')));
        pntlplist.SetText('TypeMedia', trim(ReadPhrase('MediaType')));
      end
      else
      begin
        pntlplist.SetText('ClipName', '');
        pntlplist.SetText('SongName', '');
        pntlplist.SetText('SingerName', '');
        pntlplist.SetText('CommentText', '');
        pntlplist.SetText('FileName', '');
        pntlplist.SetText('NTK', '');
        pntlplist.SetText('DurMedia', '');
        pntlplist.SetText('DurPlay', '');
        pntlplist.SetText('StartTime', '');
        pntlplist.SetText('TypeMedia', '');
      end;
      dur := 0;
      for i := 1 to Form1.GridActPlayList.RowCount - 1 do
      begin
        txt := trim((Form1.GridActPlayList.Objects[0, i] as TGridRows)
          .MyCells[3].ReadPhrase('Dur'));
        if txt <> '' then
          dur := dur + StrTimeCodeToFrames(txt);
      end;
      pntlapls.SetText('TotalDur', FramesToStr(dur));
      pntlapls.Draw(Form1.imgpldata.Canvas);
      Form1.imgpldata.Repaint;
      // Form1.lbplfulldur.Caption := FramesToStr(dur);
    end;
    pntlplist.Draw(Form1.imgpnplist.Canvas);
    Form1.imgpnplist.Repaint;
  except
    on E: Exception do
      WriteLog('MAIN', 'UActPlayList.GridActvePLToPanel ARow=' + inttostr(ARow)
        + ' | ' + E.Message);
  end;
end;

procedure SetButtonsPredNext;
begin
  if Form1.MySynhro.Checked then
    exit;

  if GridPlayerRow = 1 then
    Form1.sbPredClip.Enabled := false
  else
    Form1.sbPredClip.Enabled := true;
  if GridPlayer = grPlayList then
  begin
    Form1.sbProject.Font.Style := Form1.sbProject.Font.Style -
      [fsBold, fsUnderline];
    Form1.sbClips.Font.Style := Form1.sbClips.Font.Style -
      [fsBold, fsUnderline];
    Form1.sbPlayList.Font.Style := Form1.sbPlayList.Font.Style +
      [fsBold, fsUnderline];
    Form1.sbPlayList.Repaint;
    if GridPlayerRow = Form1.GridActPlayList.RowCount - 1 then
      Form1.sbNextClip.Enabled := false
    else
      Form1.sbNextClip.Enabled := true;
    WriteLog('MAIN', 'UActPlayList.GridActvePLToPanel PlayList GridPlayerRow=' +
      inttostr(GridPlayerRow));
  end
  else
  begin
    Form1.sbProject.Font.Style := Form1.sbProject.Font.Style -
      [fsBold, fsUnderline];
    Form1.sbClips.Font.Style := Form1.sbClips.Font.Style +
      [fsBold, fsUnderline];
    Form1.sbPlayList.Font.Style := Form1.sbPlayList.Font.Style -
      [fsBold, fsUnderline];
    Form1.sbClips.Repaint;
    if GridPlayerRow = Form1.GridClips.RowCount - 1 then
      Form1.sbNextClip.Enabled := false
    else
      Form1.sbNextClip.Enabled := true;
    WriteLog('MAIN', 'UActPlayList.GridActvePLToPanel Clips GridPlayerRow=' +
      inttostr(GridPlayerRow));
  end;
end;

procedure LoadPredClipToPlayer;
var
  txt: string;
begin
  if GridPlayerRow > 1 then
    GridPlayerRow := GridPlayerRow - 1;
  WriteLog('MAIN', 'UActPlayList.LoadPredClipToPlayer Start GridPlayerRow=' +
    inttostr(GridPlayerRow));
  SetButtonsPredNext;
  MediaStop;
  TLParameters.vlcmode := paused;
  PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

  LoadClipsToPlayer;
  SetMediaButtons;
  WriteLog('MAIN', 'UActPlayList.LoadPredClipToPlayer Finish GridPlayerRow=' +
    inttostr(GridPlayerRow));
end;

function FindNextStartTime(Grid: tstringgrid): integer;
var
  Tm, delt, tmclp: longint;
  i: integer;
  time, tmstr: string;
begin
  try
    WriteLog('MAIN', 'UActPlayList.FindNextStartTime Start Grid=' + Grid.Name);
    result := -1;
    delt := -1;
    if not Form1.MySynhro.Checked then
      exit;
    if MySinhro = chltc then
      time := MyDateTimeToStr(now - TimeCodeDelta)
    else
      time := MyDateTimeToStr(now);
    for i := 1 to Grid.RowCount - 1 do
    begin
      tmstr := trim((Grid.Objects[0, i] as TGridRows).MyCells[3]
        .ReadPhrase('StartTime'));
      if tmstr <> '' then
      begin
        tmclp := StrTimeCodeToFrames(tmstr);
        Tm := StrTimeCodeToFrames(time);
        if Tm = tmclp then
        begin
          WriteLog('MAIN', 'UActPlayList.FindNextStartTime Finish Grid=' +
            Grid.Name + ' Position' + inttostr(i) + ' CurrTime=' + time +
            ' FindTime=' + tmstr);
          result := i;
          exit;
        end;
        if Tm < tmclp then
        begin
          if delt = -1 then
          begin
            delt := tmclp - Tm;
            result := i;
            WriteLog('MAIN', 'UActPlayList.FindNextStartTime Grid=' + Grid.Name
              + ' Position' + inttostr(i) + ' CurrTime=' + time +
              ' FindTime=' + tmstr);
          end
          else
          begin
            if (tmclp - Tm) < delt then
            begin
              delt := tmclp - Tm;
              result := i;
              WriteLog('MAIN', 'UActPlayList.FindNextStartTime Grid=' +
                Grid.Name + ' Position' + inttostr(i) + ' CurrTime=' + time +
                ' FindTime=' + tmstr);
            end;
          end;
        end;
      end;
    end;
    WriteLog('MAIN', 'UActPlayList.FindNextStartTime Finish Grid=' + Grid.Name +
      ' Position' + inttostr(i) + ' CurrTime=' + time + ' FindTime=' + tmstr);
  except
    on E: Exception do
      WriteLog('MAIN', 'UActPlayList.FindNextStartTime Grid=' + Grid.Name +
        ' | ' + E.Message);
  end;
end;

procedure LoadNextClipToPlayer;
var
  cnt, ps: integer;
  txt: string;
  Reg: boolean;
begin
  WriteLog('MAIN', 'UActPlayList.LoadNextClipToPlayer Start');
  Reg := true;
  if GridPlayer = grPlayList then
  begin
    if not Form1.MySynhro.Checked then
    begin
      cnt := Form1.GridActPlayList.RowCount;
      GridPlayerRow := FindClipinGrid(Form1.GridActPlayList,
        Form1.lbActiveClipID.Caption);
    end
    else
    begin
      ps := FindNextStartTime(Form1.GridActPlayList);
      if ps <> -1 then
      begin
        GridPlayerRow := ps;
        Reg := false;
      end
      else
      begin
        cnt := Form1.GridActPlayList.RowCount;
        GridPlayerRow := FindClipinGrid(Form1.GridActPlayList,
          Form1.lbActiveClipID.Caption);
      end;
    end;
    WriteLog('MAIN', 'UActPlayList.LoadNextClipToPlayer PlayList GridPlayerRow='
      + inttostr(GridPlayerRow));
  end
  else
  begin
    if not Form1.MySynhro.Checked then
    begin
      cnt := Form1.GridClips.RowCount;
      GridPlayerRow := FindClipinGrid(Form1.GridClips,
        Form1.lbActiveClipID.Caption);
    end
    else
    begin
      ps := FindNextStartTime(Form1.GridClips);
      if ps <> -1 then
      begin
        GridPlayerRow := ps;
        Reg := false;
      end
      else
      begin
        cnt := Form1.GridClips.RowCount;
        GridPlayerRow := FindClipinGrid(Form1.GridClips,
          Form1.lbActiveClipID.Caption);
      end;
    end;
    WriteLog('MAIN', 'UActPlayList.LoadNextClipToPlayer Clips GridPlayerRow=' +
      inttostr(GridPlayerRow));
  end;
  if Reg then
  begin
    if GridPlayerRow < cnt - 1 then
      GridPlayerRow := GridPlayerRow + 1;
    WriteLog('MAIN', 'UActPlayList.LoadNextClipToPlayer-reg GridPlayerRow=' +
      inttostr(GridPlayerRow));
    SetButtonsPredNext;
  end;
  MediaStop;
  TLParameters.vlcmode := paused;
  PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

  LoadClipsToPlayer;
  SetMediaButtons;
  WriteLog('MAIN', 'UActPlayList.LoadNextClipToPlayer Finish GridPlayerRow=' +
    inttostr(GridPlayerRow));
end;

Procedure LoadDefaultClipToPlayer;
var
  fn, stc, snch: string;
  i, err, APos, postl: integer;
  dur: int64;
  clpid, nmfl: string;
  crpos: teventreplay;
  s1, s2, s3, rch: string;
  defdur: longint;
begin
  try
    // ѕровер€ем загружен ли клип в панель подготовки, если да провер€ем от куда загружен клип из плей-листа или списка клипов
    //
    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer Start');

    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer - ќчистка пам€ти');

    if trim(Form1.lbActiveClipID.Caption) <> '' then
      exit;
    Form1.lbusesclpidlst.Caption := '';
    for i := 0 to TLZone.Count - 1 do
      if TLZone.Timelines[i].Count > 0 then
        exit;
    // GridPlayer:=grDefault;

    // Form1.Label2Click(nil);

    ClearUndo;
    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer-ќчистка UNDO');
    // MyStartPlay  := -1;    // ¬рем€ старта клипа, при chnone не используетс€, -1 врем€ не установлено.
    // MyStartReady := false; // True - готовность к старту, false - старт осуществлен.
    // Form1.MySynhro.Checked := false;
    MyRemainTime := -1; // врем€ оставшеес€ до запуска

    // Form1.lbNomClips.Caption:='...';
    pntlprep.SetText('Nom', '');
    Form1.Label2.Caption := '';
    // (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    // Form1.lbClipName.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    pntlprep.SetText('ClipName', '');
    // Form1.lbSongName.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
    pntlprep.SetText('SongName', '');
    // Form1.lbSongSinger.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
    pntlprep.SetText('SingerName', '');
    Form1.lbPlayerFile.Caption := '';
    // (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    Form1.lbTypeTC.Caption := '';
    // Trim((Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('StartTime'));
    defdur := DefaultClipDuration;

    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer | ' +
      Form1.lbusesclpidlst.Caption + ' | File: ' + fn + ' | Clip: ' +
      Form1.Label2.Caption + ' | ClipID=' + Form1.lbActiveClipID.Caption +
      ' | Start=' + Form1.lbTypeTC.Caption + ' | Duration=' +
      FramesToStr(defdur));

    // if Form1.MySynhro.Checked then begin
    if Form1.lbTypeTC.Caption <> '' then
    begin
      MyStartPlay := StrTimeCodeToFrames(Form1.lbTypeTC.Caption);
      MyStartReady := true;
      Form1.MySynhro.Checked := true;
    end
    else
      MyStartPlay := -1;
    // MyStartReady := true;
    // end;
    if Form1.MySynhro.Checked then
      rch := 'true'
    else
      rch := 'false';

    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer MyStartPlay=' +
      FramesToStr(MyStartPlay) + ' Synchro=' + rch);

    SwitcherVideoPanels(1);
    // dur:=FramesToDouble(defdur);
    dur := defdur;
    TLParameters.vlcmode := paused;
    PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

    if not LoadClipEditingFromFile('defaultclip') then
    begin
      TLZone.ClearZone;
      // EraseClipInWinPrepare('')
      TLParameters.ZeroPoint := TLParameters.Preroll;
      TLParameters.Position := TLParameters.ZeroPoint;
      PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
      TLParameters.StopPosition := TLParameters.Position;
      TLParameters.Start := TLParameters.Preroll;
      TLParameters.Duration := dur;
      TLParameters.Finish := TLParameters.Preroll + TLParameters.Duration;
    end;

    // s1:=inttostr((Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline);
    // s2:=inttostr(ZoneNames.Edit.IDTimeline);
    // s3:=inttostr(TLZone.TLEditor.IDTimeline);

    TLParameters.Duration := dur;
    TLParameters.UpdateParameters;

    TLParameters.Position := TLParameters.Start;
    PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
    MediaSetPosition(TLParameters.Position, false, 'LoadDefaultClipToPlayer');
    mediapause;
    // mediaplay;
    // mediapause;
    // TLParameters.Position := TLParameters.Start;
    PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
    // MediaSetPosition(TLParameters.Position, false);
    // mediapause;

    SetClipTimeParameters;
    if TLParameters.Finish = 0 then
      TLParameters.Finish := TLParameters.Preroll + TLParameters.Duration;
    if TLParameters.Finish > (TLParameters.Preroll + TLParameters.Duration +
      TLParameters.Postroll) then
      TLParameters.Finish := TLParameters.Preroll + TLParameters.Duration;
    // Form1.lbMediaDuration.Caption:=framestostr(TLParameters.Finish - TLParameters.Start);
    // TLParameters.Position:=TLParameters.Start;
    // MediaSetPosition(TLParameters.Position, false);
    case TLZone.TLEditor.TypeTL of
      tldevice:
        begin
          Form1.pnDevTL.Visible := true;
          Form1.PnTextTL.Visible := false;
          Form1.pnMediaTL.Visible := false;
          APos := EditTL.GridPosition(Form1.GridTimeLines,
            TLZone.TLEditor.IDTimeline);
          btnsdevicepr.BackGround := ProgrammColor;
          if APos <> -1 then
            InitBTNSDEVICE(Form1.imgDeviceTL.Canvas,
              (Form1.GridTimeLines.Objects[0, APos] as TTimelineOptions),
              btnsdevicepr);
          WriteLog('MAIN',
            'UActPlayList.LoadDefaultClipToPlayer TypeTL=tlDevise');
        end;
      tltext:
        begin
          Form1.pnDevTL.Visible := false;
          Form1.PnTextTL.Visible := true;
          Form1.pnMediaTL.Visible := false;
          Form1.imgTextTL.Width := Form1.pnPrepareCTL.Width;
          Form1.imgTextTL.Picture.Bitmap.Width := Form1.imgTextTL.Width;
          btnstexttl.Draw(Form1.imgTextTL.Canvas);
          WriteLog('MAIN',
            'UActPlayList.LoadDefaultClipToPlayer TypeTL=tlText');
        end;
      tlmedia:
        begin
          Form1.pnDevTL.Visible := false;
          Form1.PnTextTL.Visible := false;
          Form1.pnMediaTL.Visible := true;
          Form1.imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
          Form1.imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
          btnsmediatl.Top := Form1.imgMediaTL.Height div 2 - 35;
          btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
          WriteLog('MAIN',
            'UActPlayList.LoadDefaultClipToPlayer TypeTL=tlMedia');
        end;
    end; // case

    Form1.imgTLNames.Height := TLHeights.Height;
    Form1.imgTimelines.Height := TLHeights.Height;
    Form1.imgTLNames.Picture.Bitmap.Height := Form1.imgTLNames.Height;
    Form1.imgTimelines.Picture.Bitmap.Height := Form1.imgTimelines.Height;
    Form1.Panel4.Height := TLHeights.Height + Form1.Panel7.Height;

    postl := ZoneNames.Edit.GridPosition(Form1.GridTimeLines,
      ZoneNames.Edit.IDTimeline);
    TLZone.TLEditor.Index := postl;
    if postl = -1 then
    begin
      ZoneNames.Edit.IDTimeline :=
        (Form1.GridTimeLines.Objects[0, 1] as TTimelineOptions).IDTimeline;
      postl := TLZone.FindTimeline(ZoneNames.Edit.IDTimeline);
      if postl <> -1 then
        TLZone.TLEditor.Assign(TLZone.Timelines[0], 1);
      TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
    end;
    WriteLog('MAIN',
      'UActPlayList.LoadDefaultClipToPlayer ZoneNames.Edit.IDTimeline=' +
      inttostr(ZoneNames.Edit.IDTimeline) + ' Position=' + inttostr(postl));

    ZoneNames.ColorUpdate;
    ZoneNames.Draw(Form1.imgTLNames.Canvas, Form1.GridTimeLines, true);
    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer ZoneNames.Draw');

    TLZone.DrawBitmap(bmptimeline);
    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer TLZone.DrawBitmap');
    TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
    WriteLog('MAIN',
      'UActPlayList.LoadDefaultClipToPlayer TLZone.DrawTimelines');

    crpos := TLZone.TLEditor.CurrentEvents;
    WriteLog('MAIN',
      'UActPlayList.LoadDefaultClipToPlayer CurrentEvents : Number=' +
      inttostr(crpos.Number) + ' Image=' + crpos.Image);
    if crpos.Number <> -1 then
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
        'LoadDefaultClipToPlayer-1')
    else
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
        'LoadDefaultClipToPlayer-2');
    TemplateToScreen(crpos);
    WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer TemplateToScreen');

    Form1.imgTLNames.Repaint;
    Form1.imgTimelines.Repaint;
    // if TLZone.TLEditor.Index=0 then TLZone.TLEditor.Index:=1;

    // postl := ZoneNames.Edit.GridPosition(form1.GridTimeLines,ZoneNames.Edit.IDTimeline);

    MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas, TLZone.TLEditor.Index);
    WriteLog('MAIN',
      'UActPlayList.LoadDefaultClipToPlayer MyPanelAir.AirDevices.Init TLZone.TLEditor.Index='
      + inttostr(TLZone.TLEditor.Index));
    MyPanelAir.SetValues;
    WriteLog('MAIN',
      'UActPlayList.LoadDefaultClipToPlayer MyPanelAir.SetValues');
    if Form1.PanelAir.Visible then
    begin
      MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
        TLZone.TLEditor.Index);
      WriteLog('MAIN',
        'UActPlayList.LoadDefaultClipToPlayer MyPanelAir.Draw TLZone.TLEditor.Index='
        + inttostr(TLZone.TLEditor.Index));
    end;
    // MyTimer.Enable := false;
    Form1.ImgLayer0.Canvas.FillRect(Form1.ImgLayer0.Canvas.ClipRect);
    WriteLog('MAIN',
      'UActPlayList.LoadDefaultClipToPlayer ѕустой клип загружен.');

//    PutJsonStrToServer('TLEDITOR', TLZone.TLEditor.SaveToJSONstr);
    PutTimeLinesToServer;
    SetMediaButtons;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UActPlayList.LoadDefaultClipToPlayer | ' + E.Message);
      Form1.FormStyle := fsNormal;
    end;
    else
      Form1.FormStyle := fsNormal;
  end;
end;

Procedure LoadClipsToPlayer;
var
  fn, stc, snch: string;
  err, APos, postl: integer;
  dur: int64;
  clpid, nmfl: string;
  crpos: teventreplay;
  s1, s2, s3, rch: string;
  defdur: longint;
  mediadata: string;
begin
  try
    // ѕровер€ем загружен ли клип в панель подготовки, если да провер€ем от куда загружен клип из плей-листа или списка клипов
    //

    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer Start');

    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer - ќчистка пам€ти');

    if trim(Form1.lbActiveClipID.Caption) <> '' then
    begin
      SaveClipEditingToFile(trim(Form1.lbActiveClipID.Caption));
      if GridPlayer = grPlayList then
      begin
        if Not(Form1.GridActPlayList.Objects[0, GridPlayerRow] is TGridRows)
        then
          exit;
        clpid := (Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
          .MyCells[3].ReadPhrase('ClipID');
        WriteLog('MAIN',
          'UActPlayList.LoadClipsToPlayer PlayList GridPlayerRow=' +
          inttostr(GridPlayerRow) + ' ClipID=' + clpid);
      end
      else
      begin
        if Not(Form1.GridClips.Objects[0, GridPlayerRow] is TGridRows) then
          exit;
        clpid := (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows)
          .MyCells[3].ReadPhrase('ClipID');
        WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer Clips GridPlayerRow=' +
          inttostr(GridPlayerRow) + ' ClipID=' + clpid);
      end;
      if trim(Form1.lbActiveClipID.Caption) <> trim(clpid) then
        SaveClipEditingToFile(trim(Form1.lbActiveClipID.Caption));
      // ******Warning
    end;

    // Form1.label7.Caption:=clpid; //******Warning

    Form1.Label2Click(nil);
    SetButtonsPredNext;

    if GridPlayerRow <= 0 then
      exit;

    ClearUndo;
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer ClearUndo');
    // MyStartPlay  := -1;    // ¬рем€ старта клипа, при chnone не используетс€, -1 врем€ не установлено.
    // MyStartReady := false; // True - готовность к старту, false - старт осуществлен.
    // Form1.MySynhro.Checked := false;
    MyRemainTime := -1; // врем€ оставшеес€ до запуска

    if GridPlayer = grPlayList then
    begin
      if Not(Form1.GridActPlayList.Objects[0, GridPlayerRow] is TGridRows) then
        exit;
      Form1.lbusesclpidlst.Caption := 'ѕлей-лист: ' +
        Form1.ListBox1.Items.Strings[Form1.ListBox1.ItemIndex];
      fn := (Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('File');
      // Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
      pntlprep.SetText('Nom', inttostr(GridPlayerRow));
      Form1.lbActiveClipID.Caption :=
        (Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('ClipID');
      Form1.Label2.Caption := (Form1.GridActPlayList.Objects[0, GridPlayerRow]
        as TGridRows).MyCells[3].ReadPhrase('Clip');
      // Form1.lbClipName.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
      pntlprep.SetText('ClipName', (Form1.GridActPlayList.Objects[0,
        GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip'));
      // Form1.lbSongName.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
      pntlprep.SetText('SongName', (Form1.GridActPlayList.Objects[0,
        GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song'));
      // Form1.lbSongSinger.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
      pntlprep.SetText('SingerName',
        (Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Singer'));
      Form1.lbPlayerFile.Caption :=
        (Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('File');
      Form1.lbTypeTC.Caption :=
        trim((Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('StartTime'));
      defdur := StrTimeCodeToFrames
        ((Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Duration'));
    end
    else
    begin
      if Not(Form1.GridClips.Objects[0, GridPlayerRow] is TGridRows) then
        exit;
      Form1.lbusesclpidlst.Caption := '—писок клипов';
      fn := (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('File');
      // Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
      pntlprep.SetText('Nom', inttostr(GridPlayerRow));
      Form1.lbActiveClipID.Caption :=
        (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('ClipID');
      Form1.Label2.Caption :=
        (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('Clip');
      // Form1.lbClipName.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
      pntlprep.SetText('ClipName',
        (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('Clip'));
      // Form1.lbSongName.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
      pntlprep.SetText('SongName',
        (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('Song'));
      // Form1.lbSongSinger.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
      pntlprep.SetText('SingerName',
        (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('Singer'));
      Form1.lbPlayerFile.Caption :=
        (Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('File');
      Form1.lbTypeTC.Caption :=
        trim((Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('StartTime'));
      defdur := StrTimeCodeToFrames
        ((Form1.GridClips.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('Duration'));
    end;

    pntlprep.Draw(Form1.imgdataprep.Canvas);
    Form1.imgdataprep.Repaint;

    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer | ' +
      Form1.lbusesclpidlst.Caption + ' | File: ' + fn + ' | Clip: ' +
      Form1.Label2.Caption + ' | ClipID=' + Form1.lbActiveClipID.Caption +
      ' | Start=' + Form1.lbTypeTC.Caption + ' | Duration=' +
      FramesToStr(defdur));

    // if Form1.MySynhro.Checked then begin
    if Form1.lbTypeTC.Caption <> '' then
    begin
      MyStartPlay := StrTimeCodeToFrames(Form1.lbTypeTC.Caption);
      MyStartReady := true;
      // Form1.MySynhro.Checked := true;
    end
    else
      MyStartPlay := -1;

    if Form1.MySynhro.Checked then
      rch := 'true'
    else
      rch := 'false';

    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer MyStartPlay=' +
      FramesToStr(MyStartPlay) + ' Synchro=' + rch);
    // end;
    // Form1.label7.Caption:=Form1.lbActiveClipID.Caption;

    SetStatusClipInPlayer(Form1.lbActiveClipID.Caption);
    WriteLog('MAIN',
      'UActPlayList.LoadClipsToPlayer SetStatusClipInPlayer ActiveClipID=' +
      Form1.lbActiveClipID.Caption);

    if FileExists(fn) then
    begin
      WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer FileExists Name=' + fn);
      SwitcherVideoPanels(0);
      err := LoadVLCPlayer(fn, mediadata);
      // If Err<>0 then begin
      // Showmessage(GraphErrorToStr(err));
      // WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer Load FileName=' + fn + ' Error:' + GraphErrorToStr(err));
      // exit;
      // end;
      // pMediaPosition.get_Duration(dur);
      dur := vlcplayer.Duration div 40;
      // VLCPlayerWindow(Form1.pnMovie);
      // pMediaControl.Pause;
      // vlcplayer.Pause;
      // TLParameters.vlcmode:=Paused;
      // pMediaPosition.get_Rate(Rate);
      Rate := 1;
      WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer FileLoads Name=' + fn);
    end
    else
    begin
      // vlcplayer.Free;
      // vlcplayer.Create;
      // vlcplayer.Init(Form1.pnMovie.Handle);
      vlcplayer.Stop;
      SwitcherVideoPanels(1);
      dur := defdur;
      WriteLog('MAIN',
        'UActPlayList.LoadClipsToPlayer Not FileExists Name=' + fn);
    end;

    // MediaPause;
    // if VLCPlayer.p_mi <> nil then vlcplayer.Pause;
    // TLParameters.vlcmode:=paused;

    if not LoadClipEditingFromFile(trim(Form1.lbActiveClipID.Caption)) then
    begin
      TLZone.ClearZone;
      // EraseClipInWinPrepare('')
      TLParameters.ZeroPoint := TLParameters.Preroll;
      TLParameters.Position := TLParameters.ZeroPoint;
      PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
      TLParameters.StopPosition := TLParameters.Position;
      TLParameters.Start := TLParameters.Preroll;
      TLParameters.Duration := dur;
      TLParameters.Finish := TLParameters.Preroll + TLParameters.Duration;
    end;

    // s1:=inttostr((Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline);
    // s2:=inttostr(ZoneNames.Edit.IDTimeline);
    // s3:=inttostr(TLZone.TLEditor.IDTimeline);

    TLParameters.Duration := dur;
    TLParameters.UpdateParameters;

    TLParameters.Position := TLParameters.Start;
    PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
    MediaSetPosition(TLParameters.Position, false, 'LoadClipsToPlayer');
    mediapause;
    // mediaplay;
    // mediapause;
    // TLParameters.Position := TLParameters.Start;
    // MediaSetPosition(TLParameters.Position, false);
    // mediapause;

    SetClipTimeParameters;
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer SetClipTimeParameters');

    if TLParameters.Finish = 0 then
      TLParameters.Finish := TLParameters.Preroll + TLParameters.Duration;
    if TLParameters.Finish > (TLParameters.Preroll + TLParameters.Duration +
      TLParameters.Postroll) then
      TLParameters.Finish := TLParameters.Preroll + TLParameters.Duration;
    // Form1.lbMediaDuration.Caption:=framestostr(TLParameters.Finish - TLParameters.Start);
    // TLParameters.Position:=TLParameters.Start;
    // MediaSetPosition(TLParameters.Position, false);
    case TLZone.TLEditor.TypeTL of
      tldevice:
        begin
          Form1.pnDevTL.Visible := true;
          Form1.PnTextTL.Visible := false;
          Form1.pnMediaTL.Visible := false;
          APos := EditTL.GridPosition(Form1.GridTimeLines,
            TLZone.TLEditor.IDTimeline);
          btnsdevicepr.BackGround := ProgrammColor;
          if APos <> -1 then
            InitBTNSDEVICE(Form1.imgDeviceTL.Canvas,
              (Form1.GridTimeLines.Objects[0, APos] as TTimelineOptions),
              btnsdevicepr);
          WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer TypeTL=tlDevice');
        end;
      tltext:
        begin
          Form1.pnDevTL.Visible := false;
          Form1.PnTextTL.Visible := true;
          Form1.pnMediaTL.Visible := false;
          Form1.imgTextTL.Width := Form1.pnPrepareCTL.Width;
          Form1.imgTextTL.Picture.Bitmap.Width := Form1.imgTextTL.Width;
          btnstexttl.Draw(Form1.imgTextTL.Canvas);
          WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer TypeTL=tlText');
        end;
      tlmedia:
        begin
          Form1.pnDevTL.Visible := false;
          Form1.PnTextTL.Visible := false;
          Form1.pnMediaTL.Visible := true;
          Form1.imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
          Form1.imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
          btnsmediatl.Top := Form1.imgMediaTL.Height div 2 - 35;
          btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
          WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer TypeTL=tlMedia');
        end;
    end; // case

    Form1.imgTLNames.Height := TLHeights.Height;
    Form1.imgTimelines.Height := TLHeights.Height;
    Form1.imgTLNames.Picture.Bitmap.Height := Form1.imgTLNames.Height;
    Form1.imgTimelines.Picture.Bitmap.Height := Form1.imgTimelines.Height;
    Form1.Panel4.Height := TLHeights.Height + Form1.Panel7.Height;

    postl := ZoneNames.Edit.GridPosition(Form1.GridTimeLines,
      ZoneNames.Edit.IDTimeline);
    TLZone.TLEditor.Index := postl;
    if postl = -1 then
    begin
      ZoneNames.Edit.IDTimeline :=
        (Form1.GridTimeLines.Objects[0, 1] as TTimelineOptions).IDTimeline;
      postl := TLZone.FindTimeline(ZoneNames.Edit.IDTimeline);
      if postl <> -1 then
        TLZone.TLEditor.Assign(TLZone.Timelines[0], 1);
      TLZone.TLEditor.DrawEditor(bmptimeline.Canvas, 0);
    end;
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer ZoneNames.Edit.IDTimeline='
      + inttostr(ZoneNames.Edit.IDTimeline) + ' Position=' + inttostr(postl));

    ZoneNames.ColorUpdate;
    ZoneNames.Draw(Form1.imgTLNames.Canvas, Form1.GridTimeLines, true);
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer ZoneNames.Draw');

    TLZone.DrawBitmap(bmptimeline);
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer TLZone.DrawBitmap');
    TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer TLZone.DrawTimelines');
    // MyStartPlay  := -1;    // ¬рем€ старта клипа, при chnone не используетс€, -1 врем€ не установлено.
    // MyStartReady := false; // True - готовность к старту, false - старт осуществлен.
    // MyRemainTime := -1;  //врем€ оставшеес€ до запуска

    crpos := TLZone.TLEditor.CurrentEvents;
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer CurrentEvents : Number=' +
      inttostr(crpos.Number) + ' Image=' + crpos.Image);
    if crpos.Number <> -1 then
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
        'LoadClipsToPlayer-1')
    else
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
        'LoadClipsToPlayer-2');
    TemplateToScreen(crpos);
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer TemplateToScreen');

    Form1.imgTLNames.Repaint;
    Form1.imgTimelines.Repaint;
    // if TLZone.TLEditor.Index=0 then TLZone.TLEditor.Index:=1;

    // postl := ZoneNames.Edit.GridPosition(form1.GridTimeLines,ZoneNames.Edit.IDTimeline);

    MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas, TLZone.TLEditor.Index);
    WriteLog('MAIN',
      'UActPlayList.LoadClipsToPlayer MyPanelAir.AirDevices.Init TLZone.TLEditor.Index='
      + inttostr(TLZone.TLEditor.Index));
    MyPanelAir.SetValues;
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer MyPanelAir.SetValues');
    if Form1.PanelAir.Visible then
    begin
      MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
        TLZone.TLEditor.Index);
      WriteLog('MAIN',
        'UActPlayList.LoadClipsToPlayer MyPanelAir.Draw TLZone.TLEditor.Index='
        + inttostr(TLZone.TLEditor.Index));
    end;
    // MyTimer.Enable := false;
    Form1.ImgLayer0.Canvas.FillRect(Form1.ImgLayer0.Canvas.ClipRect);
    WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer  лип загружен');
    // MediaPause;
    //PutJsonStrToServer('TLEDITOR', TLZone.TLEditor.SaveToJSONstr);
    PutTimeLinesToServer;
    SetMediaButtons;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UActPlayList.LoadClipsToPlayer | ' + E.Message);
      Form1.FormStyle := fsNormal;
    end;
    else
      Form1.FormStyle := fsNormal;
  end;
end;

Procedure LoadFileToPlayer(FileName: string);
var
  fn: string;
  err: integer;
  dur: int64;
  mediadata: string;
begin
  SetButtonsPredNext;

  if not FileExists(FileName) then
  begin
    Showmessage('Ќе найден медиа файл : ' + fn);
    exit;
  end;

  err := LoadVLCPlayer(FileName, mediadata);
  // If Err<>0 then begin
  // Showmessage(GraphErrorToStr(err));
  // exit;
  // end;
  dur := vlcplayer.Duration div 40;
  vlcplayer.Pause;
  // Rate:=vlcplayer.Time;
  TLParameters.vlcmode := paused;
  PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);

  TLParameters.Duration := dur;
  // TLParameters.NTK:=0; //###### Warming
  TLParameters.InitParameters;
  TLParameters.Position := TLParameters.ZeroPoint;
  PutJsonStrToServer('TLP',TLParameters.SaveToJSONStr);
  TLParameters.StopPosition := TLParameters.Position;

  TLZone.DrawBitmap(bmptimeline);
  TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
end;

procedure LoadClipsToPlayList;
var
  i, cnt, rw, ttl: integer;
begin
  With Form1 do
  begin
    cnt := 0;
    ttl := 0;
    For i := 1 to GridClips.RowCount - 1 do
    begin
      if GridClips.Objects[0, i] is TGridRows then
      begin
        if (GridClips.Objects[0, i] as TGridRows).ID <> 0 then
        begin
          if (GridClips.Objects[0, i] as TGridRows).MyCells[1].Mark then
          begin
            ttl := ttl + 1;
            if not ClipExists(GridActPlayList,
              (GridClips.Objects[0, i] as TGridRows).MyCells[3]
              .ReadPhrase('ClipID')) then
            begin
              cnt := cnt + 1;
              rw := GridAddRow(GridActPlayList, RowGridClips);
              (GridActPlayList.Objects[0, rw] as TGridRows)
                .Assign((GridClips.Objects[0, i] as TGridRows));
              (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[0]
                .Used := false;
              (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[1]
                .Mark := false;
              (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[3]
                .UpdatePhrase('StartTime', '');
              (GridClips.Objects[0, i] as TGridRows).MyCells[1].Mark := false;
            end;
          end; // if3
        end; // if2
      end; // if1
    end; // for
    if cnt = 0 then
      MyTextMessage('—ообщение', '¬ плей-лист не загружен ни один клип.', 1)
    else
      MyTextMessage('—ообщение', '¬ыделено клипов ' + inttostr(ttl) +
        ' загруженно в плей-лист ' + inttostr(cnt) + '.', 1);
  end; // width
end;

procedure LoadClipsToActPlayList(PLName: string);
var
  i, cnt, rw, ttl, ps, plid: integer;
  lst: tstrings;
  clid, sttm: string;
begin
  With Form1 do
  begin
    GridClear(Form1.GridActPlayList, RowGridClips);
    cnt := GridActPlayList.RowCount;
    GridActPlayList.RowCount := 2;
    if not FileExists(PLName) then
    begin
      for i := 1 to GridActPlayList.RowCount - 1 do
      begin
        if GridActPlayList.Objects[0, rw] is TGridRows then
          (GridActPlayList.Objects[0, rw] as TGridRows).Clear;
      end;
      GridActPlayList.Repaint;
      exit;
    end;
    lst := tstringlist.Create;
    lst.Clear;
    try
      lst.LoadFromFile(PLName);
      rw := 1;
      for i := 0 to lst.Count - 1 do
      begin
        clid := trim(lst.Strings[i]);
        plid := pos('|', clid);
        if plid <= 0 then
        begin
          sttm := '';
        end
        else
        begin
          sttm := Copy(clid, plid + 1, length(clid));
          clid := Copy(clid, 1, plid - 1);
        end;
        ps := findclipposition(Form1.GridClips, clid);
        if ps > 0 then
        begin
          // rw:=rw+1;
          GridActPlayList.RowCount := rw + 1;
          if not(GridActPlayList.Objects[0, rw] is TGridRows) then
            GridActPlayList.Objects[0, rw] := TGridRows.Create;
          (GridActPlayList.Objects[0, rw] as TGridRows)
            .Assign((GridClips.Objects[0, ps] as TGridRows));
          (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[0].Used
            := false;
          (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[1].Mark
            := false;
          (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[3]
            .UpdatePhrase('StartTime', sttm);
          sttm := (GridActPlayList.Objects[0, rw] as TGridRows).MyCells[3]
            .ReadPhrase('StartTime');
          rw := rw + 1;
        end;
      end;
    finally
      lst.Free;
    end;
  end; // width
end;

procedure SavePlayListFromGridToFile(FName: string);
var
  i: integer;
  ClipID, starttime, renm, FileName: string;
  lst: tstrings;
begin
  with Form1 do
  begin
    if trim(FName) = '' then
      exit;

    // FiLeName := (ListBox1.Items.Objects[listbox1.ItemIndex] as TMyListBoxObject).ClipId;
    FileName := PathPlayLists + '\' + trim(FName);
    if FileExists(FileName) then
    begin
      renm := PathPlayLists + '\' + 'Temp.prjl';
      RenameFile(FileName, renm);
      DeleteFile(renm);
    end;
    lst := tstringlist.Create;
    lst.Clear;
    try
      for i := 1 to GridActPlayList.RowCount - 1 do
      begin
        if (GridActPlayList.Objects[0, i] is TGridRows) then
        begin
          ClipID := (GridActPlayList.Objects[0, i] as TGridRows).MyCells[3]
            .ReadPhrase('ClipID');
          starttime := (GridActPlayList.Objects[0, i] as TGridRows)
            .MyCells[3].ReadPhrase('StartTime');
          lst.Add(ClipID + '|' + starttime);
        end;
      end;
      lst.SaveToFile(FileName);
    finally
      lst.Free;
    end;
  end;
end;

function ClipExists(Grid: tstringgrid; ClipID: string): boolean;
var
  i: integer;
  txt: string;
begin
  result := false;
  with Form1 do
  begin
    for i := 1 to Grid.RowCount - 1 do
    begin
      txt := (Grid.Objects[0, i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
      if trim(ClipID) = trim(txt) then
      begin
        result := true;
        exit;
      end;
    end;
  end;
end;

function FindClipinGrid(Grid: tstringgrid; ClipID: string): integer;
var
  i: integer;
  txt: string;
begin
  result := -1;
  with Form1 do
  begin
    for i := 1 to Grid.RowCount - 1 do
    begin
      txt := (Grid.Objects[0, i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
      if trim(ClipID) = trim(txt) then
      begin
        result := i;
        exit;
      end;
    end;
  end;
end;

procedure UpdateClipData(APos: integer; ClipID: string);
var
  i: integer;
  txt: string;
begin
  with Form1 do
  begin
    for i := 1 to GridClips.RowCount - 1 do
    begin
      txt := (GridClips.Objects[0, i] as TGridRows).MyCells[3]
        .ReadPhrase('ClipID');
      if trim(ClipID) = trim(txt) then
      begin
        (GridActPlayList.Objects[0, APos] as TGridRows)
          .Assign((GridClips.Objects[0, i] as TGridRows));
        exit;
      end;
    end;
  end;
end;

procedure CheckedActivePlayList;
var
  i, ps: integer;
  txt, starttime: string;
begin
  with Form1 do
  begin
    for i := GridActPlayList.RowCount - 1 downto 1 do
    begin
      if GridActPlayList.Objects[0, i] is TGridRows then
      begin
        txt := trim((GridActPlayList.Objects[0, i] as TGridRows).MyCells[3]
          .ReadPhrase('ClipID'));
        starttime := trim((GridActPlayList.Objects[0, i] as TGridRows)
          .MyCells[3].ReadPhrase('StartTime'));
        ps := uplaylists.findclipposition(GridClips, txt);
        if ps > 0 then
        begin
          (GridActPlayList.Objects[0, i] as TGridRows)
            .Assign((GridClips.Objects[0, ps] as TGridRows));
          (GridActPlayList.Objects[0, i] as TGridRows).MyCells[3].UpdatePhrase
            ('StartTime', starttime);
          (GridClips.Objects[0, ps] as TGridRows).MyCells[3].UpdatePhrase
            ('StartTime', starttime);
        end
        else
          MyGridDeleteRow(GridActPlayList, i, RowGridClips);
      end;
    end;
    // for i:=1 to GridActPlayList.RowCount-1 do begin
    // if GridActPlayList.Objects[0,i] is TGridRows then begin
    // txt := (GridActPlayList.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    // UpdateClipData(i, txt);
    // (GridActPlayList.Objects[0,i] as TGridRows).MyCells[0].Used:=false;
    // end;
    // end;
    if ListBox1.ItemIndex <> -1 then
      SavePlayListFromGridToFile
        ((ListBox1.Items.Objects[ListBox1.ItemIndex]
        as TMyListBoxObject).ClipID);
    // txt := (ListBox1.Items.Objects[ListBox1.ItemIndex] as TMyListBoxObject).ClipId;
    // //SaveGridToFile(PathPlayLists + '\' + trim(txt),GridActPlayList);
    // end;
  end;
end;

end.
