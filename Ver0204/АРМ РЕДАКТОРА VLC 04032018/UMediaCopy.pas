unit UMediaCopy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Gauges, ComCtrls, UImportFiles, vlcpl,
  PasLibVlcUnit;

type
  TfrMediaCopy = class(TForm)
    Gauge1: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpeedButton1: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    NeedCopy: boolean;

  public
    { Public declarations }
    Multifiles: boolean;
    MyResult: boolean;
    StrResult: string;
  end;

function CopyMediaFile(FileName_From, DirName_To: string): string;
function CopyMediaFiles(Lst: tstrings; DirName_To: string;
  mmMistakes: tmemo): boolean;
// function CopyOneMedia(FileFrom, DirTo : string);
procedure AllClipsReset;

var
  frMediaCopy: TfrMediaCopy;
  listfiles, listmistakes: tstrings;

implementation

uses umain, ucommon, uinitforms, umymessage, ugrid, uplayer, uactplaylist,
  uwaiting,
  UHRTimer, umyfiles;

{$R *.dfm}

function GetFileSize(FileName: String): Longint;
var
  FS: TFileStream;
begin
  try
    FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  except
    Result := -1;
  end;
  if Result <> -1 then
    Result := FS.Size;
  FS.Free;
end;

Procedure CopyMediaOneFile(FileName_From, FileName_To: string);
Const
  BufSize = 10000;
Var
  FSize: Longint;
  RByte: Longint; // Сколько читать байт
  N, X, Y: Longint;
  Source, Target: TFileStream;
  FileHandle: Integer;
  FileHandle1: Integer;
  Buffer: array [0 .. 9999] of byte;
  T: TDateTime;
Begin

  FSize := GetFileSize(FileName_From);

  T := Now;
  frMediaCopy.Gauge1.Progress := 0;
  frMediaCopy.Gauge1.MaxValue := FSize;

  try
    Source := TFileStream.Create(FileName_From, fmOpenRead or fmShareDenyNone);
    try
      Target := TFileStream.Create(FileName_To, fmCreate or fmShareDenyNone);
      try

        While FSize <> 0 Do
        Begin
          If FSize >= BufSize Then
            RByte := BufSize
          Else
            RByte := FSize;

          FSize := FSize - RByte;

          Source.ReadBuffer(Buffer, RByte);

          frMediaCopy.Gauge1.Progress := frMediaCopy.Gauge1.MaxValue - FSize;
          frMediaCopy.Label6.Caption := 'Прошло времени: ' + TimeToStr(Now - T);
          Application.ProcessMessages;

          Target.WriteBuffer(Buffer, RByte);
        End;

      finally
        FreeAndNil(Source);
      end;
    finally
      FreeAndNil(Target);
    end;
    frMediaCopy.ModalResult := mrOk;
  except
    FreeAndNil(Source);
    FreeAndNil(Target);
    frMediaCopy.ModalResult := mrOk;
  end;
End;

function CopyOneMedia(FileFrom, DirTo: string): string;
var
  fnm, nm, ext: string;
  i: Integer;
  MyFileName: string;
begin
  with frMediaCopy do
  begin
    frMediaCopy.SpeedButton1.Enabled := true;
    frMediaCopy.SpeedButton2.Enabled := true;
    MyFileName := DirTo + Label8.Caption;
    fnm := extractfilename(FileFrom);
    ext := ExtractFileExt(fnm);
    nm := Copy(fnm, 1, Length(fnm) - Length(ext));
    if FileExists(MyFileName) then
    begin
      If MyTextMessage('Вопрос', 'Файл ' + fnm + ' уже существует.' + #10#13 +
        'Скопировать с другим именем [Да], отказаться от копирования [Нет].', 2)
      then
      begin
        i := 0;
        repeat
          i := i + 1;
          MyFileName := DirTo + nm + '_' + inttostr(i) + ext;
        until Not FileExists(MyFileName);
        CopyMediaOneFile(FileFrom, MyFileName);
      end;
    end
    else
    begin
      CopyMediaOneFile(FileFrom, MyFileName);
    end;
    Result := MyFileName;
  end;
end;

function CopyMediaFiles(Lst: tstrings; DirName_To: string;
  mmMistakes: tmemo): boolean;
var
  FSize: Longint;
  err, i, ei, rw: Integer;
  mfne, fne, fn, ext, txt: string;
  Duration: Double;
begin
  frMediaCopy.SpeedButton1.Enabled := true;
  frMediaCopy.SpeedButton2.Enabled := true;
  frMediaCopy.Multifiles := true;
  Result := false;
  frMediaCopy.Gauge1.Progress := 0;
  listfiles := tstringlist.Create;
  try
    listfiles.Clear;
    for i := 0 to Lst.Count - 1 do
      listfiles.Add(Lst.Strings[i]);
    listmistakes := tstringlist.Create;
    try
      listmistakes.Clear;

      if Lst.Count < 0 then
        exit;
      frMediaCopy.Label4.Caption := extractfilepath(Lst.Strings[0]);
      frMediaCopy.Label8.Caption := 'Импортируется ' + inttostr(Lst.Count) +
        ' файлов.';
      frMediaCopy.Label5.Caption := trim(DirName_To) + '\';
      frMediaCopy.Label6.Caption := 'Прошло времени: ' + TimeToStr(0);
      frMediaCopy.Label1.Caption := '';
      frMediaCopy.ShowModal;
      if frMediaCopy.ModalResult = mrOk then
      begin
        mmMistakes.Lines.Clear;
        for i := 0 to listmistakes.Count - 1 do
          mmMistakes.Lines.Add(listmistakes.Strings[i]);
        Result := frMediaCopy.MyResult;
      end;
    finally
      listfiles.Free;
    end;
  finally
    listmistakes.Free;
  end;
end;

function CopyMediaFile(FileName_From, DirName_To: string): string;
var
  txt: string;
  FSize: Longint;
begin
  frMediaCopy.Multifiles := false;
  Result := FileName_From;
  frMediaCopy.Gauge1.Progress := 0;
  frMediaCopy.Label4.Caption := extractfilepath(FileName_From);
  frMediaCopy.Label8.Caption := extractfilename(FileName_From);
  frMediaCopy.Label5.Caption := trim(DirName_To) + '\';
  frMediaCopy.Label6.Caption := 'Прошло времени: ' + TimeToStr(0);
  FSize := GetFileSize(FileName_From);
  frMediaCopy.Label1.Caption := 'Размер файла ' + inttostr(FSize) + ' Байт';
  frMediaCopy.ShowModal;
  if frMediaCopy.ModalResult = mrOk then
    Result := frMediaCopy.StrResult;
  // CopyOneMedia(FileName_From, frMediaCopy.Label5.Caption);
end;

procedure TfrMediaCopy.SpeedButton1Click(Sender: TObject);
var
  FSize: Longint;
  err, i, ei, rw: Integer;
  mfne, fne, fn, ext, txt: string;
  Duration: int64;
  mediadata: string;
begin
  try
    if Multifiles then
    begin
      SpeedButton1.Enabled := false;
      NeedCopy := true;
      MyResult := true;
      listmistakes.Clear;
      AllClipsReset;
      // ++++++++++++++++++++++++++++++++++
      ei := 0;
      for i := 0 to listfiles.Count - 1 do
      begin
        mfne := listfiles.Strings[i];
        fne := extractfilename(listfiles.Strings[i]);
        frMediaCopy.Label8.Caption := fne;
        ext := ExtractFileExt(listfiles.Strings[i]);
        fn := Copy(fne, 1, Length(fne) - Length(ext));
        // vlcplayer.Stop;
        frMediaCopy.Label1.Caption := 'Импорт файла: ' + fne;
        err := LoadVLCPlayer(listfiles.Strings[i], mediadata);
        Application.ProcessMessages;
        if err = 0 then
        begin
          mfne := CopyOneMedia(listfiles.Strings[i],
            frMediaCopy.Label5.Caption);
          // pMediaPosition.get_Duration(Duration);
          Duration := vlcplayer.Duration div 40;
          rw := GridAddRow(Form1.GridClips, RowGridClips);
          IDCLIPS := IDCLIPS + 1;
          (Form1.GridClips.Objects[0, rw] as TGridRows).ID := IDCLIPS;
          (Form1.GridClips.Objects[0, rw] as TGridRows).MyCells[1].Mark := true;
          with (Form1.GridClips.Objects[0, rw] as TGridRows).MyCells[3] do
          begin
            UpdatePhrase('File', mfne);
            UpdatePhrase('Clip', fn + '_' + inttostr(IDCLIPS));
            UpdatePhrase('Song', fn);
            UpdatePhrase('Comment', '');
            UpdatePhrase('Singer', '');
            UpdatePhrase('Duration', FramesToStr(Duration));
            UpdatePhrase('NTK', '00:00:00:00');
            UpdatePhrase('Dur', FramesToStr(Duration));
            UpdatePhrase('StartTime', '');
            UpdatePhrase('MediaType', mediadata);
            txt := createunicumname;
            UpdatePhrase('ClipID', txt);
          end;
          listmistakes.Add('     ' + inttostr(i) + ')    Медиа-файл ' + fne +
            ' - Импортирован.');
        end
        else
        begin
          ei := ei + 1;
          listmistakes.Add('     ' + inttostr(i) + ')    Медиа-файл ' + fne +
            ' - Невозможно прочитать.');
          frMediaCopy.Label1.Caption := 'Медиа-файл невозможно прочитать.';
        end; // if
        if vlcplayer.p_mi <> nil then
        begin
          vlcplayer.Stop;
          while not vlcplayer.vlc_waitForState(libvlc_Stopped) do
            Application.ProcessMessages;
        end;
      end; // for
      // vlcplayer.Stop;
      if ei > 0 then
      begin
        listmistakes.Add('');
        listmistakes.Add('     Импортировалось медиа-файлов: ' +
          inttostr(Form1.OpenDialog1.Files.Count));
        listmistakes.Add('     Импортировано: ' +
          inttostr(Form1.OpenDialog1.Files.Count - ei));
        listmistakes.Add('     Не удалось импортировать: ' + inttostr(ei));
        MyResult := true;
      end
      else
      begin
        Form1.GridClips.Row := rw;
        GridClipsToPanel(rw);
      end;
      SpeedButton1.Enabled := true;
      // ++++++++++++++++++++++++++++++++++
    end
    else
      StrResult := CopyOneMedia(frMediaCopy.Label4.Caption +
        frMediaCopy.Label8.Caption, frMediaCopy.Label5.Caption);
    ModalResult := mrOk;
  except
    SpeedButton1.Enabled := true;
  end;
end;

procedure TfrMediaCopy.SpeedButton2Click(Sender: TObject);
var
  FSize: Longint;
  err, i, ei, rw: Integer;
  mfne, fne, fn, ext, txt: string;
  Duration: int64;
  mediadata: string;
  // vlc_state: libvlc_state_t;
begin
  try
    if Multifiles then
    begin
      SpeedButton2.Enabled := false;
      NeedCopy := false;
      MyResult := true;
      listmistakes.Clear;
      AllClipsReset;
      // ++++++++++++++++++++++++++++++++++
      ei := 0;
      for i := 0 to listfiles.Count - 1 do
      begin
        mfne := listfiles.Strings[i];
        fne := extractfilename(listfiles.Strings[i]);
        frMediaCopy.Label8.Caption := fne;
        ext := ExtractFileExt(listfiles.Strings[i]);
        fn := Copy(fne, 1, Length(fne) - Length(ext));
        frMediaCopy.Label1.Caption := 'Импорт файла: ' + fne;

        err := LoadVLCPlayer(listfiles.Strings[i], mediadata);
        Application.ProcessMessages;
        if err = 0 then
        begin
          // if frMediaCopy.NeedCopy then mfne := CopyOneMedia(listfiles.Strings[i], frMediaCopy.Label5.Caption);
          // pMediaPosition.get_Duration(Duration);
          Duration := vlcplayer.Duration div 40;
          rw := GridAddRow(Form1.GridClips, RowGridClips);
          IDCLIPS := IDCLIPS + 1;
          (Form1.GridClips.Objects[0, rw] as TGridRows).ID := IDCLIPS;
          (Form1.GridClips.Objects[0, rw] as TGridRows).MyCells[1].Mark := true;
          with (Form1.GridClips.Objects[0, rw] as TGridRows).MyCells[3] do
          begin
            UpdatePhrase('File', mfne);
            UpdatePhrase('Clip', fn + '_' + inttostr(IDCLIPS));
            UpdatePhrase('Song', fn);
            UpdatePhrase('Comment', '');
            UpdatePhrase('Singer', '');
            UpdatePhrase('Duration', FramesToStr(Duration));
            UpdatePhrase('NTK', '00:00:00:00');
            UpdatePhrase('Dur', FramesToStr(Duration));
            UpdatePhrase('StartTime', '');
            UpdatePhrase('MediaType', mediadata);
            txt := createunicumname;
            UpdatePhrase('ClipID', txt);
          end;
          listmistakes.Add('     ' + inttostr(i) + ')    Медиа-файл ' + fne +
            ' - Импортирован.');
        end
        else
        begin
          ei := ei + 1;
          listmistakes.Add('     ' + inttostr(i) + ')    Медиа-файл ' + fne +
            ' - Невозможно прочитать.');
          frMediaCopy.Label1.Caption := 'Медиа-файл невозможно прочитать.';
        end; // if
        if vlcplayer.p_mi <> nil then
        begin
          vlcplayer.Stop;
          // while not vlcplayer.vlc_waitForState(libvlc_Stopped) do application.ProcessMessages;
        end;
      end; // for
      // vlcplayer.Stop;
      if ei > 0 then
      begin
        listmistakes.Add('');
        listmistakes.Add('     Импортировалось медиа-файлов: ' +
          inttostr(Form1.OpenDialog1.Files.Count));
        listmistakes.Add('     Импортировано: ' +
          inttostr(Form1.OpenDialog1.Files.Count - ei));
        listmistakes.Add('     Не удалось импортировать: ' + inttostr(ei));
        MyResult := true;
      end
      else
      begin
        Form1.GridClips.Row := rw;
        GridClipsToPanel(rw);
      end;
      SpeedButton2.Enabled := true;
      // ++++++++++++++++++++++++++++++++++
      ModalResult := mrOk;
    end
    else
      ModalResult := mrCancel;
  except
    SpeedButton2.Enabled := true;
  end;
end;

procedure TfrMediaCopy.FormCreate(Sender: TObject);
begin
  InitFrMediaCopy;
end;

procedure AllClipsReset;
var
  i: Integer;
begin
  for i := 1 to Form1.GridClips.RowCount - 1 do
  begin
    if Form1.GridClips.Objects[0, i] is TGridRows then
    begin
      (Form1.GridClips.Objects[0, i] as TGridRows).MyCells[1].Mark := false;
    end;
  end;
end;

end.
