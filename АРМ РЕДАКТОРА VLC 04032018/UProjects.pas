unit UProjects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids;

procedure SetGridProjects;
Function DefineCellSelect(X,Y : integer) : tpoint;

implementation
uses umain, ucommon, ugrid;

procedure SetGridProjectsObjects(ARow : integer);
begin
  with Form1.gridprojects do begin
    if Objects[0,ARow]=nil then  Objects[0,ARow]:=TCellsState.Create;
    if Objects[1,ARow]=nil then  Objects[1,ARow]:=TCellsState.Create;
    if Objects[2,ARow]=nil then  Objects[2,ARow]:=TCellsState.Create;
    if Objects[3,ARow]=nil then  Objects[3,ARow]:=TCellsText.Create;
    if Objects[4,ARow]=nil then  Objects[4,ARow]:=TCellsText.Create;
    if Objects[5,ARow]=nil then  Objects[5,ARow]:=TCellsText.Create;
  end;
end;




procedure SetGridProjects;
var i, j : integer;
    s : string;
begin
  with Form1.gridprojects do begin
    //if (GetWindowlong(Handle, GWL_STYLE) and WS_VSCROLL) <> 0 then
    //begin
    //  i := GetSystemMetrics(SM_CXVSCROLL);
    //  j := GetSystemMetrics(SM_CYVSCROLL);
    //end;
    //s:=inttostr(i);
    //s:=s;
    //Color:=ProgrammColor;
    ColCount:=6;
    ColWidths[0]:=DefaultRowHeight;
    ColWidths[1]:=DefaultRowHeight;
    ColWidths[2]:=DefaultRowHeight;
    ColWidths[3]:=Width-3*DefaultRowHeight-256;//ColWidths[4]-ColWidths[5];
    ColWidths[4]:=120;
    ColWidths[5]:=120;

    if RowCount > 0
      then For i:=0 to RowCount - 1 do SetGridProjectsObjects(i);
    for i:=1 to RowCount - 1 do begin
      (Objects[3,i] as TCellsText).Row1.Phrase1.Text:='Проект № ' + inttostr(i);
      (Objects[3,i] as TCellsText).Row1.Phrase1.Left:=25;
      (Objects[3,i] as TCellsText).Row1.Phrase1.Top:=(RowHeights[i] - canvas.TextHeight('0')) div 2;
      (Objects[3,i] as TCellsText).Row1.Phrase2.Text:=inttostr(25);
      (Objects[3,i] as TCellsText).Row1.Phrase2.Left:=200;
      (Objects[3,i] as TCellsText).Row1.Phrase2.FontSize:=7;
      (Objects[3,i] as TCellsText).Row1.Phrase2.FontColor:=clRed;
      (Objects[3,i] as TCellsText).Row1.Phrase2.Top:=(RowHeights[i] - canvas.TextHeight('0')) div 2 + 4;
      s:=DateToStr(Now);
      (Objects[4,i] as TCellsText).Row1.Phrase1.Text:=s;
      (Objects[4,i] as TCellsText).Row1.Phrase1.Left:=(ColWidths[4] - Canvas.TextWidth('00.00.0000')) div 2;
    end;
  end;
end;

Function DefineCellSelect(X,Y : integer) : tpoint;
Var i, strt : integer;
begin
  result.X:=-1;
  result.Y:=-1;
  with Form1.gridprojects do begin
    strt:=GridLineWidth;
    for i:=0 to ColCount-1 do begin
      if (X > strt) and (X < strt + ColWidths[i]) then result.X:=i;
      strt := strt + ColWidths[i] + GridLineWidth;
    end;
    strt:=GridLineWidth;
    for i:=0 to RowCount-1 do begin
      if (Y > strt) and (Y < strt + RowHeights[i]) then result.Y:=i;
      strt := strt + RowHeights[i] + GridLineWidth;
    end;
  end;
end;



end.
