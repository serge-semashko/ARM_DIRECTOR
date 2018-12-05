unit UEvSwapBuffer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, UCommon, UMyEvents;

Type

  TEvSwapBuffer = Class(TObject)
  public
    TypeTL: TTypeTimeline;
    Count: integer;
    Events: array of TMyEvent;
    procedure Clear;
    procedure AddInBuffer(evnt: TMyEvent);
    procedure Cut;
    procedure Copy;
    procedure Paste;
    Constructor Create;
    Destructor Destroy;
  end;

var
  evswapbuffer: TEvSwapBuffer;

implementation

uses umain, ugrtimelines, ugrid, umyfiles;

Constructor TEvSwapBuffer.Create;
begin
  TypeTL := tlnone;
  Count := 0;
end;

Destructor TEvSwapBuffer.Destroy;
begin
  FreeMem(@TypeTL);
  Clear;
  FreeMem(@Count);
  FreeMem(@Events);
end;

Procedure TEvSwapBuffer.Clear;
var
  i: integer;
begin
  For i := Count - 1 downto 0 do
    Events[i].FreeInstance;
  Count := 0;
  SetLength(Events, Count);
end;

Procedure TEvSwapBuffer.AddInBuffer(evnt: TMyEvent);
begin
  Count := Count + 1;
  SetLength(Events, Count);
  Events[Count - 1] := TMyEvent.Create;
  Events[Count - 1].Assign(evnt);
end;

Procedure TEvSwapBuffer.Cut;
var
  i, ps: integer;
  bl: boolean;
  crpos: teventreplay;
begin
  try
    bl := false;
    TypeTL := TLZone.TLEditor.TypeTL;
    Clear;
    for i := 0 to TLZone.TLEditor.Count - 1 do
    begin
      if TLZone.TLEditor.Events[i].Select then
      begin
        AddInBuffer(TLZone.TLEditor.Events[i]);
        bl := true;
      end;
    end;
    if bl then
    begin
      for i := TLZone.TLEditor.Count - 1 downto 0 do
        if TLZone.TLEditor.Events[i].Select then
          TLZone.TLEditor.DeleteEvent(i);
      ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
      TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
      TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
      TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
      TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmpTimeline);
      exit;
    end;
    crpos := TLZone.TLEditor.CurrentEvents;
    if crpos.Number <> -1 then
    begin
      AddInBuffer(TLZone.TLEditor.Events[crpos.Number]);
      TLZone.TLEditor.DeleteEvent(crpos.Number);
    end;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
    TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
    TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
    TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmpTimeline);

    if form1.PanelPrepare.Visible then
    begin
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1 then
        MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
          'TEvSwapBuffer.Cut');
      TemplateToScreen(crpos);
      if form1.pnImageScreen.Visible then
        form1.Image3.Repaint;
    end;
    if makelogging then
      WriteLog('MAIN', 'UEvSwapBuffer.TEvSwapBuffer.Cut');
  except
    on E: Exception do
      WriteLog('MAIN', 'UEvSwapBuffer.TEvSwapBuffer.Cut | ' + E.Message);
  end;
end;

Procedure TEvSwapBuffer.Copy;
var
  i, ps: integer;
  bl: boolean;
  crpos: teventreplay;
begin
  try
    bl := false;
    Clear;
    TypeTL := TLZone.TLEditor.TypeTL;
    for i := 0 to TLZone.TLEditor.Count - 1 do
    begin
      if TLZone.TLEditor.Events[i].Select then
      begin
        AddInBuffer(TLZone.TLEditor.Events[i]);
        bl := true;
      end;
    end;
    if bl then
      exit;
    crpos := TLZone.TLEditor.CurrentEvents;
    if crpos.Number <> -1 then
      AddInBuffer(TLZone.TLEditor.Events[crpos.Number]);
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
    TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
    TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
    TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmpTimeline);

    if form1.PanelPrepare.Visible then
    begin
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1 then
        MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
          'TEvSwapBuffer.Copy');
      TemplateToScreen(crpos);
      if form1.pnImageScreen.Visible then
        form1.Image3.Repaint;
    end;
    if makelogging then
      WriteLog('MAIN', 'UEvSwapBuffer.TEvSwapBuffer.Copy');
  except
    on E: Exception do
      WriteLog('MAIN', 'UEvSwapBuffer.TEvSwapBuffer.Copy | ' + E.Message);
  end;
end;

procedure TEvSwapBuffer.Paste;
var
  i, j, ps, nmdev: integer;
  crpos: teventreplay;
  nstr, nend, dur, dltps: longint;
begin
  try
    if Count <= 0 then
      exit;
    if TLZone.TLEditor.TypeTL <> TypeTL then
      exit;
    crpos := TLZone.TLEditor.CurrentEvents;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    dltps := Events[0].Start - TLParameters.Position;
    for i := 0 to Count - 1 do
    begin
      nmdev := Events[i].ReadPhraseData('Device');
      nstr := Events[i].Start - dltps;
      dur := Events[i].Finish - Events[i].Start;
      Events[i].Select := false;
      j := TLZone.TLEditor.AddEvent(nstr, ps + 1, nmdev);
      nstr := TLZone.TLEditor.Events[j].Start;
      nend := TLZone.TLEditor.Events[j].Finish;
      TLZone.TLEditor.Events[j].Assign(Events[i]);
      TLZone.TLEditor.Events[j].Start := nstr;
      if TypeTL = tltext then
        TLZone.TLEditor.Events[j].Finish := nstr + dur
      else
        TLZone.TLEditor.Events[j].Finish := nend;
    end;
    TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
    TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
    TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
    TLZone.DrawTimelines(form1.imgTimelines.Canvas, bmpTimeline);

    if form1.PanelPrepare.Visible then
    begin
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1 then
        MarkRowPhraseInGrid(form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
          'TEvSwapBuffer.Paste');
      TemplateToScreen(crpos);
      if form1.pnImageScreen.Visible then
        form1.Image3.Repaint;
    end;
    if makelogging then
      WriteLog('MAIN', 'UEvSwapBuffer.TEvSwapBuffer.Paste');
  except
    on E: Exception do
      WriteLog('MAIN', 'UEvSwapBuffer.TEvSwapBuffer.Paste | ' + E.Message);
  end;
end;

initialization

evswapbuffer := TEvSwapBuffer.Create;

finalization

evswapbuffer.FreeInstance;

end.
