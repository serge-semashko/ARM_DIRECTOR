unit UPlayLists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, CheckLst, Grids;

type
  TMyListBoxObject = class(TObject)
  public
    ClipID: String;
    StartTime: String;
    Constructor Create;
    Destructor Destroy;
  end;

  TFPlayLists = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    edNamePL: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    mmCommentPL: TMemo;
    Label3: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PlayListName: string;
  end;

var
  FPlayLists: TFPlayLists;

Procedure EditPlayList(ARow: integer);
Procedure PlaylistToPanel(ARow: integer);
Procedure SetPlaylistBlocking(ARow: integer);
Procedure ReadListClips;
Procedure LoadClipsFromPlayLists(PLName: string);
function findclipposition(Grid: tstringgrid; ClipID: string): integer;

implementation

uses umain, ucommon, uinitforms, ugrid, uactplaylist, umyfiles, umytexttable;

{$R *.dfm}

constructor TMyListBoxObject.Create;
begin
  inherited;
  ClipID := '';
  StartTime := '';
end;

destructor TMyListBoxObject.Destroy;
begin
  FreeMem(@ClipID);
  FreeMem(@StartTime);
  inherited;
end;

Procedure SetPlaylistBlocking(ARow: integer);
begin
  try
    WriteLog('MAIN', 'Uplaylists.SetPlaylistBlocking ARow=' + inttostr(ARow));
    With Form1.GridLists do
    begin
      Form1.Image1.Canvas.FillRect(Form1.Image1.Canvas.ClipRect);
      if objects[0, ARow] is TGridRows then
        if (objects[0, ARow] as TGridRows).MyCells[0].Mark then
          LoadBMPFromRes(Form1.Image1.Canvas, Form1.Image1.Canvas.ClipRect, 20,
            20, 'UnLock')
        else
          LoadBMPFromRes(Form1.Image1.Canvas, Form1.Image1.Canvas.ClipRect, 20,
            20, 'Lock');
      Form1.Image1.Repaint;
    End;
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.SetPlaylistBlocking ARow=' + inttostr(ARow) +
        ' | ' + E.Message);
  end;
end;

Procedure PlaylistToPanel(ARow: integer);
var
  plnm: string;
  i, j: integer;
begin
  try
    WriteLog('MAIN', 'Uplaylists.PlaylistToPanel ARow=' + inttostr(ARow));
    with Form1, Form1.GridLists do
    begin
      ListBox1.Clear;
      for i := 1 to GridLists.RowCount - 1 do
      begin
        plnm := (GridLists.objects[0, i] as TGridRows).MyCells[3]
          .ReadPhrase('Name');
        ListBox1.Items.Add(plnm);
        j := ListBox1.Items.Count - 1;
        if not(ListBox1.Items.objects[j] is TMyListBoxObject) then
          ListBox1.Items.objects[j] := TMyListBoxObject.Create;
        (ListBox1.Items.objects[j] as TMyListBoxObject).ClipID :=
          (GridLists.objects[0, i] as TGridRows).MyCells[3].ReadPhrase('Note');
        WriteLog('MAIN', 'Uplaylists.PlaylistToPanel Name=' + plnm + '  ClipID='
          + (ListBox1.Items.objects[j] as TMyListBoxObject).ClipID);
      end;
      ListBox1.ItemIndex := ARow - 1;
      pntlapls.SetText('CommentText', (objects[0, ARow] as TGridRows)
        .MyCells[3].ReadPhrase('Comment'));
      pntlapls.Draw(imgpldata.Canvas);
      imgpldata.Repaint;
      // lbPLComment.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Comment');
    end; // with
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.PlaylistToPanel ARow=' + inttostr(ARow) +
        ' | ' + E.Message);
  end;
end;

procedure TFPlayLists.FormCreate(Sender: TObject);
begin
  InitPlaylists;
end;

Procedure ReadListClips;
var
  i, ps: integer;
  clpid, txt: string;
begin
  try
    WriteLog('MAIN', 'Uplaylists.ReadListClips');
    with Form1.GridClips do
    begin
      FPlayLists.ListBox1.Clear;
      for i := 1 to RowCount - 1 do
      begin
        txt := (Form1.GridClips.objects[0, i] as TGridRows).MyCells[3]
          .ReadPhrase('Clip');
        FPlayLists.ListBox1.Items.Add('    ' + txt);
        ps := FPlayLists.ListBox1.Items.Count - 1;
        if not(FPlayLists.ListBox1.Items.objects[ps] is TMyListBoxObject) then
          FPlayLists.ListBox1.Items.objects[ps] := TMyListBoxObject.Create;
        (FPlayLists.ListBox1.Items.objects[ps] as TMyListBoxObject).ClipID :=
          (Form1.GridClips.objects[0, i] as TGridRows).MyCells[3]
          .ReadPhrase('ClipID');
        WriteLog('MAIN', 'Uplaylists.ReadListClips Clip=' + txt + '  ClipID=' +
          (FPlayLists.ListBox1.Items.objects[ps] as TMyListBoxObject).ClipID);
      end; // for
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.ReadListClips | ' + E.Message);
  end;
end;

function findclipposition(Grid: tstringgrid; ClipID: string): integer;
var
  i: integer;
begin
  try
    WriteLog('MAIN', 'Start Uplaylists.findclipposition Grid=' + Grid.Name +
      ' ClipID=' + ClipID);
    result := -1;
    for i := 1 to Grid.RowCount - 1 do
    begin
      if trim((Grid.objects[0, i] as TGridRows).MyCells[3].ReadPhrase('ClipID'))
        = trim(ClipID) then
      begin
        result := i;
        WriteLog('MAIN', 'Finish Uplaylists.findclipposition ClipID=' + ClipID +
          ' Position=' + inttostr(i));
        exit;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.findclipposition Grid=' + Grid.Name +
        '  ClipID=' + ClipID + ' | ' + E.Message);
  end;
end;

procedure WriteClipsToPlayLists;
var
  Stream: TFileStream;
  i, j, ps, cnt: integer;
  renm, FileName, ClipID, StartTime: string;
  lst: tstrings;
begin
  try
    WriteLog('MAIN', 'Uplaylists.WriteClipsToPlayLists');
    with FPlayLists do
    begin
      FileName := PathPlayLists + '\' + FPlayLists.PlayListName;
      if FileExists(FileName) then
      begin
        renm := PathPlayLists + '\' + 'Temp.prjl';
        RenameFile(FileName, renm);
        DeleteFile(renm);
      end;
      lst := tstringlist.Create;
      lst.Clear;
      try
        for i := ListBox2.Items.Count - 1 downto 0 do
          if trim(ListBox2.Items.Strings[i]) = '' then
            ListBox2.Items.Delete(i);
        for i := 0 to ListBox2.Items.Count - 1 do
        begin
          ClipID := trim
            ((ListBox2.Items.objects[i] as TMyListBoxObject).ClipID);
          StartTime := trim((ListBox2.Items.objects[i] as TMyListBoxObject)
            .StartTime);
          if ClipID <> '' then
            lst.Add(ClipID + '|' + StartTime);
        end;
        lst.SaveToFile(FileName);
      finally
        lst.Free;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.WriteClipsToPlayLists | ' + E.Message);
  end;
end;

Procedure LoadClipsFromPlayLists(PLName: string);
var
  Stream: TFileStream;
  i, cnt, ps, psi, plid: integer;
  renm, FileName: string;
  tc: TTypeCell;
  clp, clpid, clid, sttm: string;
  lst: tstrings;
begin
  try
    WriteLog('MAIN', ' Start Uplaylists.LoadClipsFromPlayLists Name=' + PLName);
    with FPlayLists do
    begin
      FileName := PathPlayLists + '\' + FPlayLists.PlayListName;
      if not FileExists(FileName) then
        exit;
      lst := tstringlist.Create;
      lst.Clear;
      try
        lst.LoadFromFile(FileName);
        ListBox2.Items.Clear;
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
          psi := findclipposition(Form1.GridClips, clid);
          if psi > 0 then
          begin
            clp := (Form1.GridClips.objects[0, psi] as TGridRows).MyCells[3]
              .ReadPhrase('Clip');
            clpid := (Form1.GridClips.objects[0, psi] as TGridRows)
              .MyCells[3].ReadPhrase('ClipId');
            ListBox2.Items.Add(clp);
            ps := ListBox2.Items.Count - 1;
            if not(ListBox2.Items.objects[ps] is TMyListBoxObject) then
              ListBox2.Items.objects[ps] := TMyListBoxObject.Create;
            (ListBox2.Items.objects[ps] as TMyListBoxObject).ClipID := clpid;
            (ListBox2.Items.objects[ps] as TMyListBoxObject).StartTime := sttm;
          end;
          WriteLog('MAIN', 'Uplaylists.LoadClipsFromPlayLists Clip=' + clp +
            ' ClipID=' + clpid);
        end;
        isprojectchanges := true;

        if FileExists(FileName) then
        begin
          renm := PathPlayLists + '\' + 'Temp.prjl';
          RenameFile(FileName, renm);
          DeleteFile(renm);
        end;
        lst.SaveToFile(FileName);

      finally
        lst.Free;
      end;
      WriteLog('MAIN', ' Finish Uplaylists.LoadClipsFromPlayLists Name='
        + PLName);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.LoadClipsFromPlayLists Name=' + PLName +
        ' | ' + E.Message);
  end;
end;

Procedure EditPlayList(ARow: integer);
var
  i, setpos: integer;
  dt: string;
begin
  try
    WriteLog('MAIN', 'Uplaylists.EditPlayList Start ARow=' + inttostr(ARow));
    ReadListClips;
    FPlayLists.ListBox2.Clear;
    if ARow = -1 then
    begin
      FPlayLists.edNamePL.Text := '';
      FPlayLists.mmCommentPL.Clear;
      FPlayLists.PlayListName := '';
    end
    else
    begin
      FPlayLists.edNamePL.Text :=
        (Form1.GridLists.objects[0, ARow] as TGridRows).MyCells[3]
        .ReadPhrase('Name');
      FPlayLists.mmCommentPL.Text :=
        (Form1.GridLists.objects[0, ARow] as TGridRows).MyCells[3]
        .ReadPhrase('Comment');
      FPlayLists.PlayListName := (Form1.GridLists.objects[0, ARow] as TGridRows)
        .MyCells[3].ReadPhrase('Note');
      if trim(FPlayLists.PlayListName) <> '' then
        LoadClipsFromPlayLists(FPlayLists.PlayListName);
    end;

    FPlayLists.ActiveControl := FPlayLists.edNamePL;
    FPlayLists.ShowModal;

    if FPlayLists.ModalResult = mrOk then
    begin
      if ARow = -1 then
      begin
        setpos := GridAddRow(Form1.GridLists, RowGridListPL);

        (Form1.GridLists.objects[0, setpos] as TGridRows).MyCells[0]
          .Mark := false;
        (Form1.GridLists.objects[0, setpos] as TGridRows).MyCells[1]
          .Mark := false;
        (Form1.GridLists.objects[0, setpos] as TGridRows).MyCells[3]
          .UpdatePhrase('Name', FPlayLists.edNamePL.Text);
        (Form1.GridLists.objects[0, setpos] as TGridRows).MyCells[3]
          .UpdatePhrase('Comment', FPlayLists.mmCommentPL.Text);

        for i := 0 to Form1.GridLists.RowCount - 1 do
          (Form1.GridLists.objects[0, i] as TGridRows).MyCells[2].Mark := false;

        (Form1.GridLists.objects[0, setpos] as TGridRows).MyCells[2]
          .Mark := true;
        IDPLst := IDPLst + 1;
        (Form1.GridLists.objects[0, setpos] as TGridRows).ID := IDPLst;
        FPlayLists.PlayListName := 'PL' + createunicumname + '.plst';
        (Form1.GridLists.objects[0, setpos] as TGridRows).MyCells[3]
          .UpdatePhrase('Note', FPlayLists.PlayListName);
        Form1.GridLists.Row := setpos;
      end
      else
      begin
        setpos := ARow;
        (Form1.GridLists.objects[0, ARow] as TGridRows).MyCells[3]
          .UpdatePhrase('Name', FPlayLists.edNamePL.Text);
        (Form1.GridLists.objects[0, ARow] as TGridRows).MyCells[3]
          .UpdatePhrase('Comment', FPlayLists.mmCommentPL.Text);
        dt := (Form1.GridLists.objects[0, ARow] as TGridRows).MyCells[3]
          .ReadPhrase('Note');
        if trim(dt) = '' then
        begin
          FPlayLists.PlayListName := 'PL' + createunicumname + '.plst';
          (Form1.GridLists.objects[0, ARow] as TGridRows).MyCells[3]
            .UpdatePhrase('Note', FPlayLists.PlayListName);
        end
        else
          FPlayLists.PlayListName := dt;
      end;
      WriteClipsToPlayLists;
      SetPlaylistBlocking(setpos);
      WriteLog('MAIN', 'Uplaylists.EditPlayList Finish ARow=' + inttostr(ARow));
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.EditPlayList ARow=' + inttostr(ARow) + ' | '
        + E.Message);
  end;
end;

procedure TFPlayLists.SpeedButton2Click(Sender: TObject);
begin
  WriteLog('MAIN', 'TFPlayLists.SpeedButton2Click ModalResult:=mrCancel');
  ModalResult := mrCancel;
end;

procedure TFPlayLists.SpeedButton1Click(Sender: TObject);
begin
  if trim(edNamePL.Text) <> '' then
  begin
    WriteLog('MAIN', 'TFPlayLists.SpeedButton1Click ModalResult:=mrOk');
    ModalResult := mrOk;
  end
  else
  begin
    WriteLog('MAIN', 'TFPlayLists.SpeedButton1Click ActiveControl:=edNamePL');
    ActiveControl := edNamePL;
  end;
end;

procedure TFPlayLists.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    WriteLog('MAIN', 'TFPlayLists.FormKeyUp key=13');
    if ActiveControl = mmCommentPL then
      exit;
    WriteLog('MAIN', 'TFPlayLists.FormKeyUp SpeedButton1Click');
    SpeedButton1Click(nil);
  end;
end;

procedure TFPlayLists.SpeedButton3Click(Sender: TObject);
var
  i: integer;
begin
  WriteLog('MAIN', 'TFPlayLists.SpeedButton3Click ListBox2.DeleteSelected');
  ListBox2.DeleteSelected;
end;

function ClipExists(ClipID: String): boolean;
var
  i: integer;
begin
  try
    WriteLog('MAIN', 'Uplaylists.ClipExists ClipID=' + ClipID);
    with FPlayLists do
    begin
      result := false;
      for i := 0 to ListBox2.Items.Count - 1 do
      begin
        if ListBox2.Items.objects[i] is TMyListBoxObject then
        begin
          if (ListBox2.Items.objects[i] as TMyListBoxObject).ClipID = ClipID
          then
          begin
            WriteLog('MAIN', 'Uplaylists.ClipExists ClipID=' + ClipID +
              ' Position=' + inttostr(i));
            result := true;
            exit;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'Uplaylists.ClipExists ClipID=' + ClipID + ' | ' +
        E.Message);
  end;
end;

procedure TFPlayLists.SpeedButton5Click(Sender: TObject);
var
  i, ps: integer;
  clp: string;
begin
  try
    WriteLog('MAIN', 'TFPlayLists.SpeedButton5Click');
    for i := ListBox2.Items.Count - 1 downto 0 do
      if trim(ListBox2.Items.Strings[i]) = '' then
        ListBox2.Items.Delete(i);

    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      if ListBox1.Selected[i] then
      begin
        if ListBox1.Items.objects[i] is TMyListBoxObject then
        begin
          if not ClipExists((ListBox1.Items.objects[i] as TMyListBoxObject)
            .ClipID) then
          begin
            clp := trim(ListBox1.Items.Strings[i]);
            ListBox2.Items.Add(clp);
            ps := ListBox2.Items.Count - 1;
            if not(ListBox2.Items.objects[ps] is TMyListBoxObject) then
              ListBox2.Items.objects[ps] := TMyListBoxObject.Create;
            (ListBox2.Items.objects[ps] as TMyListBoxObject).ClipID :=
              (ListBox1.Items.objects[i] as TMyListBoxObject).ClipID;
            WriteLog('MAIN', 'TFPlayLists.SpeedButton5Click Clip=' + clp +
              ' ClipID=' + (ListBox2.Items.objects[ps]
              as TMyListBoxObject).ClipID);
          end;
        end;
      end;
      ListBox1.Selected[i] := false;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'TFPlayLists.SpeedButton5Click | ' + E.Message);
  end;
end;

end.
