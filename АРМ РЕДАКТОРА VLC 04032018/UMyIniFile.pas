unit UMyIniFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles;

procedure WriteMyIniFile;
procedure ReadMyIniFile;

implementation

uses umain, ucommon, ugrid, utimeline, umyfiles;

procedure WriteMyIniFile;
var
  ini: tinifile;
  txt: string;
  i: integer;
  ch: char;
begin
  try
    ini := tinifile.Create(AppPath + AppName + '.ini');
    WriteLog('MAIN', 'Начало записи IniFile: ' + AppPath + AppName + '.ini');
    try
      // ini.WriteInteger('PROJECTS','HeihtGrid',Form1.Panel5.Height);
      // Временно используемые параметрв для отладки программы
      // ini.WriteInteger('ID','IDTL',IDTL);
      ini.WriteInteger('ID', 'IDCLIPS', IDCLIPS);
      ini.WriteInteger('ID', 'IDPROJ', IDPROJ);
      ini.WriteInteger('ID', 'IDPLst', IDPLst);
      ini.WriteInteger('ID', 'IDTXTTmp', IDTXTTmp);
      ini.WriteInteger('ID', 'IDGRTmp', IDGRTmp);
      ini.WriteInteger('ID', 'IDEvents', IDEvents);

      // Параметры синхронизации программы
      ini.WriteFloat('SYNH', 'Shift', MyShift);
      case MySinhro of
        chltc:
          ini.WriteInteger('SINH', 'Type', 0);
        chsystem:
          ini.WriteInteger('SINH', 'Type', 1);
        // chnone   : ini.WriteInteger('SINH','Type',2);
      end;

      // Общие настройки программы
      ini.WriteInteger('MAIN', 'RowsEvents', RowsEvents);
      ini.WriteString('MAIN', 'WorkDirGRTemplate', WorkDirGRTemplate);
      ini.WriteString('MAIN', 'WorkDirTextTemplate', WorkDirTextTemplate);
      ini.WriteString('MAIN', 'WorkDirClips', WorkDirClips);
      ini.WriteString('MAIN', 'WorkDirSubtitors', WorkDirSubtitors);
      ini.WriteInteger('MAIN', 'DeltaDateDelete', DeltaDateDelete);
      // ini.WriteBool('MAIN','CurrentMode',CurrentMode);
      ini.WriteInteger('MAIN', 'MainGrid', ord(MainGrid));
      ini.WriteInteger('MAIN', 'ProgrammColor', ProgrammColor);
      ini.WriteInteger('MAIN', 'ProgrammCommentColor', ProgrammCommentColor);
      ini.WriteInteger('MAIN', 'ProgrammFontColor', ProgrammFontColor);
      ini.WriteString('MAIN', 'ProgrammFontName', ProgrammFontName);
      ini.WriteInteger('MAIN', 'ProgrammFontSize', ProgrammFontSize);
      ini.WriteInteger('MAIN', 'ProgrammEditColor', ProgrammEditColor);
      ini.WriteInteger('MAIN', 'ProgrammEditFontColor', ProgrammEditFontColor);
      ini.WriteString('MAIN', 'ProgrammEditFontName', ProgrammEditFontName);
      ini.WriteInteger('MAIN', 'ProgrammEditFontSize', ProgrammEditFontSize);
      ini.WriteInteger('MAIN', 'ProgrammBtnFontSize', ProgrammBtnFontSize);
      ini.WriteString('MAIN', 'ProgrammHintBtnFontName',
        ProgrammHintBtnFontName);
      ini.WriteInteger('MAIN', 'ProgrammHintBTNSFontColor',
        ProgrammHintBTNSFontColor);
      ini.WriteInteger('MAIN', 'ProgrammHintBTNSFontSize',
        ProgrammHintBTNSFontSize);

      ini.WriteInteger('MAIN', 'StepMouseWheel', StepMouseWheel);
      ini.WriteBool('MAIN', 'MainWindowStayOnTop', MainWindowStayOnTop);
      ini.WriteBool('MAIN', 'MainWindowMove', MainWindowMove);
      ini.WriteBool('MAIN', 'MainWindowSize', MainWindowSize);
      ini.WriteBool('MAIN', 'MakeLogging', MakeLogging);
      ini.WriteInteger('MAIN', 'SynchDelay', SynchDelay);
      ini.WriteBool('MAIN', 'InputWithoutUsers', InputWithoutUsers);

      // Основные параметры вспомогательных форм
      ini.WriteInteger('FORMS', 'FormsColor', FormsColor);
      ini.WriteInteger('FORMS', 'FormsFontColor', FormsFontColor);
      ini.WriteInteger('FORMS', 'FormsFontSize', FormsFontSize);
      ini.WriteInteger('FORMS', 'FormsSmallFont', FormsSmallFont);
      ini.WriteString('FORMS', 'FormsFontName', FormsFontName);
      ini.WriteInteger('FORMS', 'FormsEditColor', FormsEditColor);
      ini.WriteInteger('FORMS', 'FormsEditFontColor', FormsEditFontColor);
      ini.WriteInteger('FORMS', 'FormsEditFontSize', FormsEditFontSize);
      ini.WriteString('FORMS', 'FormsEditFontName', FormsEditFontName);

      // Основные параметры гридов
      ini.WriteInteger('GRIDS', 'GridBackGround', GridBackGround);
      ini.WriteInteger('GRIDS', 'GridColorPen', GridColorPen);
      // ini.WriteInteger('GRIDS','GridMainFontColor',GridFontColor);
      ini.WriteInteger('GRIDS', 'GridColorRow1', GridColorRow1);
      ini.WriteInteger('GRIDS', 'GridColorRow2', GridColorRow2);
      ini.WriteInteger('GRIDS', 'GridColorSelection', GridColorSelection);
      ini.WriteInteger('GRIDS', 'RowGridGrTemplateSelect',
        RowGridGrTemplateSelect);
      ini.WriteString('GRIDS', 'GridTitleFontName', GridTitleFontName);
      ini.WriteInteger('GRIDS', 'GridTitleFontColor', GridTitleFontColor);
      ini.WriteInteger('GRIDS', 'GridTitleFontSize', GridTitleFontSize);
      ini.WriteBool('GRIDS', 'GridTitleFontBold', GridTitleFontBold);
      ini.WriteBool('GRIDS', 'GridTitleFontItalic', GridTitleFontItalic);
      ini.WriteBool('GRIDS', 'GridTitleFontUnderline', GridTitleFontUnderline);
      ini.WriteString('GRIDS', 'GridFontName', GridFontName);
      ini.WriteInteger('GRIDS', 'GridFontColor', GridFontColor);
      ini.WriteInteger('GRIDS', 'GridFontSize', GridFontSize);
      ini.WriteBool('GRIDS', 'GridFontBold', GridFontBold);
      ini.WriteBool('GRIDS', 'GridFontItalic', GridFontItalic);
      ini.WriteBool('GRIDS', 'GridFontUnderline', GridFontUnderline);
      ini.WriteString('GRIDS', 'GridSubFontName', GridSubFontName);
      ini.WriteInteger('GRIDS', 'GridSubFontColor', GridSubFontColor);
      ini.WriteInteger('GRIDS', 'GridSubFontSize', GridSubFontSize);
      ini.WriteBool('GRIDS', 'GridSubFontBold', GridSubFontBold);
      ini.WriteBool('GRIDS', 'GridSubFontItalic', GridSubFontItalic);
      ini.WriteBool('GRIDS', 'GridSubFontUnderline', GridSubFontUnderline);
      ini.WriteInteger('GRIDS', 'ProjectHeightTitle', ProjectHeightTitle);
      ini.WriteInteger('GRIDS', 'ProjectHeightRow', ProjectHeightRow);
      ini.WriteInteger('GRIDS', 'ProjectRowsTop', ProjectRowsTop);
      ini.WriteInteger('GRIDS', 'ProjectRowsHeight', ProjectRowsHeight);
      ini.WriteInteger('GRIDS', 'ProjectRowsInterval', ProjectRowsInterval);
      ini.WriteInteger('GRIDS', 'PLHeightTitle', PLHeightTitle);
      ini.WriteInteger('GRIDS', 'PLHeightRow', PLHeightRow);
      ini.WriteInteger('GRIDS', 'PLRowsTop', PLRowsTop);
      ini.WriteInteger('GRIDS', 'PLRowsHeight', PLRowsHeight);
      ini.WriteInteger('GRIDS', 'PLRowsInterval', PLRowsInterval);
      ini.WriteInteger('GRIDS', 'ClipsHeightTitle', ClipsHeightTitle);
      ini.WriteInteger('GRIDS', 'ClipsHeightRow', ClipsHeightRow);
      ini.WriteInteger('GRIDS', 'ClipsRowsTop', ClipsRowsTop);
      ini.WriteInteger('GRIDS', 'ClipsRowsHeight', ClipsRowsHeight);
      ini.WriteInteger('GRIDS', 'ClipsRowsInterval', ClipsRowsInterval);
      ini.WriteInteger('GRIDS', 'ListTxtHeightTitle', ListTxtHeightTitle);
      ini.WriteInteger('GRIDS', 'ListTxtHeightRow', ListTxtHeightRow);
      ini.WriteInteger('GRIDS', 'ListTxtRowsTop', ListTxtRowsTop);
      ini.WriteInteger('GRIDS', 'ListTxtRowsHeight', ListTxtRowsHeight);
      ini.WriteInteger('GRIDS', 'ListGRHeightTitle', ListGRHeightTitle);
      ini.WriteInteger('GRIDS', 'ListGRHeightRow', ListGRHeightRow);
      ini.WriteInteger('GRIDS', 'ListGRRowsTop', ListGRRowsTop);
      ini.WriteInteger('GRIDS', 'ListGRRowsHeight', ListGRRowsHeight);
      ini.WriteInteger('GRIDS', 'ListGRRowsInterval', ListGRRowsInterval);
      ini.WriteInteger('GRIDS', 'PhraseErrorColor', PhraseErrorColor);
      ini.WriteInteger('GRIDS', 'PhrasePlayColor', PhrasePlayColor);

      ini.WriteInteger('GRIDS', 'MyCellColorTrue', MyCellColorTrue);
      ini.WriteInteger('GRIDS', 'MyCellColorFalse', MyCellColorFalse);
      ini.WriteInteger('GRIDS', 'MyCellColorSelect', MyCellColorSelect);

      // Основные параметры Тайм-линий
      ini.WriteInteger('TLS', 'TLBackGround', TLBackGround);
      ini.WriteInteger('TLS', 'TLZoneNamesColor', TLZoneNamesColor);
      ini.WriteInteger('TLS', 'TLZoneNamesFontSize', TLZoneNamesFontSize);
      ini.WriteInteger('TLS', 'TLZoneNamesFontColor', TLZoneNamesFontColor);
      ini.WriteInteger('TLS', 'TLZoneFontColorSelect', TLZoneFontColorSelect);
      ini.WriteString('TLS', 'TLZoneNamesFontName', TLZoneNamesFontName);
      ini.WriteInteger('TLS', 'TLMaxDevice', TLMaxDevice);
      ini.WriteInteger('TLS', 'TLMaxText', TLMaxText);
      ini.WriteInteger('TLS', 'TLMaxMedia', TLMaxMedia);
      ini.WriteInteger('TLS', 'TLMaxCount', TLMaxCount);
      ini.WriteInteger('TLS', 'AirBackGround', AirBackGround);
      ini.WriteInteger('TLS', 'AirForeGround', AirForeGround);
      ini.WriteInteger('TLS', 'AirColorTimeLine', AirColorTimeLine);
      ini.WriteInteger('TLS', 'DevBackGround', DevBackGround);
      ini.WriteInteger('TLS', 'TimeForeGround', TimeForeGround);
      ini.WriteInteger('TLS', 'TimeSecondColor', TimeSecondColor);
      ini.WriteInteger('TLS', 'AirFontComment', AirFontComment);
      ini.WriteInteger('TLS', 'DefaultMediaColor', DefaultMediaColor);
      ini.WriteInteger('TLS', 'DefaultTextColor', DefaultTextColor);

      ini.WriteInteger('TLS', 'StartColorCursor', StartColorCursor);
      ini.WriteInteger('TLS', 'EndColorCursor', EndColorCursor);

      // ini.WriteInteger('TLS','Layer2FontColor',Layer2FontColor);
      // ini.WriteInteger('TLS','Layer2FontSize',Layer2FontSize);
      ini.WriteInteger('TLS', 'StatusColor0', StatusColor[0]);
      ini.WriteInteger('TLS', 'StatusColor1', StatusColor[1]);
      ini.WriteInteger('TLS', 'StatusColor2', StatusColor[2]);
      ini.WriteInteger('TLS', 'StatusColor3', StatusColor[3]);
      ini.WriteInteger('TLS', 'StatusColor4', StatusColor[4]);
      ini.WriteInteger('TLS', 'TLMaxFrameSize', TLMaxFrameSize);
      ini.WriteInteger('TLS', 'TLPreroll', TLPreroll);
      ini.WriteInteger('TLS', 'TLPostroll', TLPostroll);
      ini.WriteInteger('TLS', 'TLFlashDuration', TLFlashDuration);
      // ini.WriteInteger('TLS','TLFontColor',TLFontColor);

      // Основные параметры кнопок
      ini.WriteString('BUTTONS', 'ProgBTNSFontName', ProgBTNSFontName);
      ini.WriteInteger('BUTTONS', 'ProgBTNSFontColor', ProgBTNSFontColor);
      ini.WriteInteger('BUTTONS', 'ProgBTNSFontSize', ProgBTNSFontSize);
      ini.WriteString('BUTTONS', 'HintBTNSFontName', HintBTNSFontName);
      ini.WriteInteger('BUTTONS', 'HintBTNSFontColor', HintBTNSFontColor);
      ini.WriteInteger('BUTTONS', 'HintBTNSFontSize', HintBTNSFontSize);

      // Цвета по умолчанию для событий
      For i := 0 to 31 do
        ini.WriteInteger('DefaultColors', 'Dev' + inttostr(i + 1),
          DefaultColors[i]);
      ini.WriteInteger('DefaultColors', 'DefaultMediaColor', DefaultMediaColor);
      ini.WriteInteger('DefaultColors', 'DefaultTextColor', DefaultTextColor);

      // Параметры принтера
      ch := formatsettings.DecimalSeparator;
      formatsettings.DecimalSeparator := '.';
      ini.WriteFloat('PRINT', 'PrintSpaceLeft', PrintSpaceLeft);
      ini.WriteFloat('PRINT', 'PrintSpaceRight', PrintSpaceRight);
      ini.WriteFloat('PRINT', 'PrintSpaceTop', PrintSpaceTop);
      ini.WriteFloat('PRINT', 'PrintSpaceBottom', PrintSpaceBottom);
      ini.WriteFloat('PRINT', 'PrintHeadLineTop', PrintHeadLineTop);
      ini.WriteFloat('PRINT', 'PrintHeadLineBottom', PrintHeadLineBottom);
      formatsettings.DecimalSeparator := ch;
      ini.WriteString('PRINT', 'PrintCol1', PrintCol1);
      ini.WriteString('PRINT', 'PrintCol2', PrintCol2);
      ini.WriteString('PRINT', 'PrintCol3', PrintCol3);
      ini.WriteString('PRINT', 'PrintCol4', PrintCol4);
      ini.WriteString('PRINT', 'PrintCol5', PrintCol5);
      ini.WriteString('PRINT', 'PrintCol61', PrintCol61);
      ini.WriteString('PRINT', 'PrintCol62', PrintCol62);
      ini.WriteString('PRINT', 'PrintDeviceName', PrintDeviceName);

      // Размеры щрифтов для таблиц панелей
      ini.WriteInteger('TABLE', 'MTFontSize', MTFontSize);
      ini.WriteInteger('TABLE', 'MTFontSizeS', MTFontSizeS);
      ini.WriteInteger('TABLE', 'MTFontSizeB', MTFontSizeB);

    finally
      ini.Free;
    end;
    WriteLog('MAIN', 'Окончание записи IniFile: ' + AppPath + AppName + '.ini');
  except
    on E: Exception do
      WriteLog('MAIN', 'WriteMyIniFile(' + AppPath + AppName + '.ini) | ' +
        E.Message);
  end;
end;

procedure ReadMyIniFile;
var
  ini: tinifile;
  txt: string;
  inpr: integer;
  i, zn: integer;
  ch: char;
begin
  try
    ini := tinifile.Create(AppPath + AppName + '.ini');
    WriteLog('MAIN', 'Начало чтения IniFile: ' + AppPath + AppName + '.ini');
    try
      // Form1.Panel5.Height := ini.ReadInteger('PROJECTS','HeihtGrid',Form1.Panel5.Height);

      // Временно используемые параметрв для отладки программы
      // IDTL := ini.ReadInteger('ID','IDTL',IDTL);
      IDCLIPS := ini.ReadInteger('ID', 'IDCLIPS', IDCLIPS);
      IDPROJ := ini.ReadInteger('ID', 'IDPROJ', IDPROJ);
      IDPLst := ini.ReadInteger('ID', 'IDPLst', IDPLst);
      IDTXTTmp := ini.ReadInteger('ID', 'IDTXTTmp', IDTXTTmp);
      IDGRTmp := ini.ReadInteger('ID', 'IDGRTmp', IDGRTmp);
      IDEvents := ini.ReadInteger('ID', 'IDEvents', IDEvents);

      // Параметры синхронизации программы
      MyShift := ini.ReadFloat('SYNH', 'Shift', MyShift);
      MyShiftOld := MyShift;
      zn := ini.ReadInteger('SINH', 'Type', 2);
      case zn of
        0:
          begin
            MySinhro := chltc;
            Form1.lbSynchRegim.Caption := 'Внешний тайм-код [LTC]';
          end;
        1:
          begin
            MySinhro := chsystem;
            Form1.lbSynchRegim.Caption := 'Системное время';
          end;
        // 2    : begin
        // MySinhro := chnone;
        // Form1.lbSynchRegim.Caption := 'Ручной режим';
        // end;
      end;

      // Общие настройки программы
      RowsEvents := ini.ReadInteger('MAIN', 'RowsEvents', 7);
      WorkDirGRTemplate := ini.ReadString('MAIN', 'WorkDirGRTemplate', '');
      WorkDirTextTemplate := ini.ReadString('MAIN', 'WorkDirTextTemplate', '');
      WorkDirClips := ini.ReadString('MAIN', 'WorkDirClips', '');
      WorkDirSubtitors := ini.ReadString('MAIN', 'WorkDirSubtitors', '');
      DeltaDateDelete := ini.ReadInteger('MAIN', 'DeltaDateDelete', 30);
      // CurrentMode := ini.ReadBool('MAIN','CurrentMode',false);
      zn := ini.ReadInteger('MAIN', 'MainGrid', 0);
      case zn of
        0:
          MainGrid := projects;
        1:
          MainGrid := playlists;
        2:
          MainGrid := clips;
        3:
          MainGrid := actplaylist;
        4:
          MainGrid := grtemplate;
        // 5 : MainGrid := txttemplate;
        6:
          MainGrid := empty;
      end; // case
      // zn := ini.ReadInteger('MAIN','SecondaryGrid',6);
      // case zn of
      // 0 : SecondaryGrid := projects;
      // 1 : SecondaryGrid := playlists;
      // 2 : SecondaryGrid := clips;
      // 3 : SecondaryGrid := actplaylist;
      // 4 : SecondaryGrid := grtemplate;
      // 5 : SecondaryGrid := txttemplate;
      // 6 : SecondaryGrid := empty;
      // end;//case
      ProgrammColor := ini.ReadInteger('MAIN', 'ProgrammColor', ProgrammColor);
      ProgrammCommentColor := ini.ReadInteger('MAIN', 'ProgrammCommentColor',
        ProgrammCommentColor);
      ProgrammFontColor := ini.ReadInteger('MAIN', 'ProgrammFontColor',
        ProgrammFontColor);
      ProgrammFontName := ini.ReadString('MAIN', 'ProgrammFontName',
        ProgrammFontName);
      ProgrammFontSize := ini.ReadInteger('MAIN', 'ProgrammFontSize',
        ProgrammFontSize);
      ProgrammEditColor := ini.ReadInteger('MAIN', 'ProgrammEditColor',
        ProgrammEditColor);
      ProgrammEditFontColor := ini.ReadInteger('MAIN', 'ProgrammEditFontColor',
        ProgrammEditFontColor);
      ProgrammEditFontName := ini.ReadString('MAIN', 'ProgrammEditFontName',
        ProgrammEditFontName);
      ProgrammEditFontSize := ini.ReadInteger('MAIN', 'ProgrammEditFontSize',
        ProgrammEditFontSize);

      ProgrammBtnFontSize := ini.ReadInteger('MAIN', 'ProgrammBtnFontSize',
        ProgrammBtnFontSize);
      ProgrammHintBtnFontName := ini.ReadString('MAIN',
        'ProgrammHintBtnFontName', ProgrammHintBtnFontName);
      ProgrammHintBTNSFontColor := ini.ReadInteger('MAIN',
        'ProgrammHintBTNSFontColor', ProgrammHintBTNSFontColor);
      ProgrammHintBTNSFontSize := ini.ReadInteger('MAIN',
        'ProgrammHintBTNSFontSize', ProgrammHintBTNSFontSize);

      StepMouseWheel := ini.ReadInteger('MAIN', 'StepMouseWheel',
        StepMouseWheel);
      MainWindowStayOnTop := ini.ReadBool('MAIN', 'MainWindowStayOnTop',
        MainWindowStayOnTop);
      MainWindowMove := ini.ReadBool('MAIN', 'MainWindowMove', MainWindowMove);
      MainWindowSize := ini.ReadBool('MAIN', 'MainWindowSize', MainWindowSize);
      MakeLogging := ini.ReadBool('MAIN', 'MakeLogging', MakeLogging);
      SynchDelay := ini.ReadInteger('MAIN', 'SynchDelay', SynchDelay);
      InputWithoutUsers := ini.ReadBool('MAIN', 'InputWithoutUsers',
        InputWithoutUsers);
      // Основные параметры вспомогательных форм
      FormsColor := ini.ReadInteger('FORMS', 'FormsColor', FormsColor);
      FormsFontColor := ini.ReadInteger('FORMS', 'FormsFontColor',
        FormsFontColor);
      FormsFontSize := ini.ReadInteger('FORMS', 'FormsFontSize', FormsFontSize);
      FormsSmallFont := ini.ReadInteger('FORMS', 'FormsSmallFont',
        FormsSmallFont);
      FormsFontName := ini.ReadString('FORMS', 'FormsFontName', FormsFontName);
      FormsEditColor := ini.ReadInteger('FORMS', 'FormsEditColor',
        FormsEditColor);
      FormsEditFontColor := ini.ReadInteger('FORMS', 'FormsEditFontColor',
        FormsEditFontColor);
      FormsEditFontSize := ini.ReadInteger('FORMS', 'FormsEditFontSize',
        FormsEditFontSize);
      FormsEditFontName := ini.ReadString('FORMS', 'FormsEditFontName',
        FormsEditFontName);

      // Основные параметры гридов
      GridBackGround := ini.ReadInteger('GRIDS', 'GridBackGround',
        GridBackGround);
      GridColorPen := ini.ReadInteger('GRIDS', 'GridColorPen', GridColorPen);
      // GridMainFontColor := ini.ReadInteger('GRIDS','GridMainFontColor',GridMainFontColor);
      GridColorRow1 := ini.ReadInteger('GRIDS', 'GridColorRow1', GridColorRow1);
      GridColorRow2 := ini.ReadInteger('GRIDS', 'GridColorRow2', GridColorRow2);
      GridColorSelection := ini.ReadInteger('GRIDS', 'GridColorSelection',
        GridColorSelection);
      RowGridGrTemplateSelect := ini.ReadInteger('GRIDS',
        'RowGridGrTemplateSelect', RowGridGrTemplateSelect);

      GridTitleFontName := ini.ReadString('GRIDS', 'GridTitleFontName',
        GridTitleFontName);
      GridTitleFontColor := ini.ReadInteger('GRIDS', 'GridTitleFontColor',
        GridTitleFontColor);
      GridTitleFontSize := ini.ReadInteger('GRIDS', 'GridTitleFontSize',
        GridTitleFontSize);
      GridTitleFontBold := ini.ReadBool('GRIDS', 'GridTitleFontBold',
        GridTitleFontBold);
      GridTitleFontItalic := ini.ReadBool('GRIDS', 'GridTitleFontItalic',
        GridTitleFontItalic);
      GridTitleFontUnderline := ini.ReadBool('GRIDS', 'GridTitleFontUnderline',
        GridTitleFontUnderline);
      GridFontName := ini.ReadString('GRIDS', 'GridFontName', GridFontName);
      GridFontColor := ini.ReadInteger('GRIDS', 'GridFontColor', GridFontColor);
      GridFontSize := ini.ReadInteger('GRIDS', 'GridFontSize', GridFontSize);
      GridFontBold := ini.ReadBool('GRIDS', 'GridFontBold', GridFontBold);
      GridFontItalic := ini.ReadBool('GRIDS', 'GridFontItalic', GridFontItalic);
      GridFontUnderline := ini.ReadBool('GRIDS', 'GridFontUnderline',
        GridFontUnderline);
      GridSubFontName := ini.ReadString('GRIDS', 'GridSubFontName',
        GridSubFontName);
      GridSubFontColor := ini.ReadInteger('GRIDS', 'GridSubFontColor',
        GridSubFontColor);
      GridSubFontSize := ini.ReadInteger('GRIDS', 'GridSubFontSize',
        GridSubFontSize);
      GridSubFontBold := ini.ReadBool('GRIDS', 'GridSubFontBold',
        GridSubFontBold);
      GridSubFontItalic := ini.ReadBool('GRIDS', 'GridSubFontItalic',
        GridSubFontItalic);
      GridSubFontUnderline := ini.ReadBool('GRIDS', 'GridSubFontUnderline',
        GridSubFontUnderline);
      ProjectHeightTitle := ini.ReadInteger('GRIDS', 'ProjectHeightTitle',
        ProjectHeightTitle);
      ProjectHeightRow := ini.ReadInteger('GRIDS', 'ProjectHeightRow',
        ProjectHeightRow);
      ProjectRowsTop := ini.ReadInteger('GRIDS', 'ProjectRowsTop',
        ProjectRowsTop);
      ProjectRowsHeight := ini.ReadInteger('GRIDS', 'ProjectRowsHeight',
        ProjectRowsHeight);
      ProjectRowsInterval := ini.ReadInteger('GRIDS', 'ProjectRowsInterval',
        ProjectRowsInterval);
      PLHeightTitle := ini.ReadInteger('GRIDS', 'PLHeightTitle', PLHeightTitle);
      PLHeightRow := ini.ReadInteger('GRIDS', 'PLHeightRow', PLHeightRow);
      PLRowsTop := ini.ReadInteger('GRIDS', 'PLRowsTop', PLRowsTop);
      PLRowsHeight := ini.ReadInteger('GRIDS', 'PLRowsHeight', PLRowsHeight);
      PLRowsInterval := ini.ReadInteger('GRIDS', 'PLRowsInterval',
        PLRowsInterval);
      ClipsHeightTitle := ini.ReadInteger('GRIDS', 'ClipsHeightTitle',
        ClipsHeightTitle);
      ClipsHeightRow := ini.ReadInteger('GRIDS', 'ClipsHeightRow',
        ClipsHeightRow);
      ClipsRowsTop := ini.ReadInteger('GRIDS', 'ClipsRowsTop', ClipsRowsTop);
      ClipsRowsHeight := ini.ReadInteger('GRIDS', 'ClipsRowsHeight',
        ClipsRowsHeight);
      ClipsRowsInterval := ini.ReadInteger('GRIDS', 'ClipsRowsInterval',
        ClipsRowsInterval);
      ListTxtHeightTitle := ini.ReadInteger('GRIDS', 'ListTxtHeightTitle',
        ListTxtHeightTitle);
      ListTxtHeightRow := ini.ReadInteger('GRIDS', 'ListTxtHeightRow',
        ListTxtHeightRow);
      ListTxtRowsTop := ini.ReadInteger('GRIDS', 'ListTxtRowsTop',
        ListTxtRowsTop);
      ListTxtRowsHeight := ini.ReadInteger('GRIDS', 'ListTxtRowsHeight',
        ListTxtRowsHeight);
      ListGRHeightTitle := ini.ReadInteger('GRIDS', 'ListGRHeightTitle',
        ListGRHeightTitle);
      ListGRHeightRow := ini.ReadInteger('GRIDS', 'ListGRHeightRow',
        ListGRHeightRow);
      ListGRRowsTop := ini.ReadInteger('GRIDS', 'ListGRRowsTop', ListGRRowsTop);
      ListGRRowsHeight := ini.ReadInteger('GRIDS', 'ListGRRowsHeight',
        ListGRRowsHeight);
      ListGRRowsInterval := ini.ReadInteger('GRIDS', 'ListGRRowsInterval',
        ListGRRowsInterval);
      PhraseErrorColor := ini.ReadInteger('GRIDS', 'PhraseErrorColor',
        PhraseErrorColor);
      PhrasePlayColor := ini.ReadInteger('GRIDS', 'PhrasePlayColor',
        PhrasePlayColor);

      MyCellColorTrue := ini.ReadInteger('GRIDS', 'MyCellColorTrue',
        MyCellColorTrue);
      MyCellColorFalse := ini.ReadInteger('GRIDS', 'MyCellColorFalse',
        MyCellColorFalse);
      MyCellColorSelect := ini.ReadInteger('GRIDS', 'MyCellColorSelect',
        MyCellColorSelect);

      // Основные параметры Тайм-линий
      TLBackGround := ini.ReadInteger('TLS', 'TLBackGround', TLBackGround);
      TLZoneNamesColor := ini.ReadInteger('TLS', 'TLZoneNamesColor',
        TLZoneNamesColor);
      TLZoneNamesFontSize := ini.ReadInteger('TLS', 'TLZoneNamesFontSize',
        TLZoneNamesFontSize);
      TLZoneNamesFontColor := ini.ReadInteger('TLS', 'TLZoneNamesFontColor',
        TLZoneNamesFontColor);
      TLZoneFontColorSelect := ini.ReadInteger('TLS', 'TLZoneFontColorSelect',
        TLZoneFontColorSelect);
      TLZoneNamesFontName := ini.ReadString('TLS', 'TLZoneNamesFontName',
        TLZoneNamesFontName);
      TLMaxDevice := ini.ReadInteger('TLS', 'TLMaxDevice', TLMaxDevice);
      TLMaxText := ini.ReadInteger('TLS', 'TLMaxText', TLMaxText);
      TLMaxMedia := ini.ReadInteger('TLS', 'TLMaxMedia', TLMaxMedia);
      TLMaxCount := ini.ReadInteger('TLS', 'TLMaxCount', TLMaxCount);
      AirBackGround := ini.ReadInteger('TLS', 'AirBackGround', AirBackGround);
      AirForeGround := ini.ReadInteger('TLS', 'AirForeGround', AirForeGround);
      AirColorTimeLine := ini.ReadInteger('TLS', 'AirColorTimeLine',
        AirColorTimeLine);
      DevBackGround := ini.ReadInteger('TLS', 'DevBackGround', DevBackGround);
      TimeForeGround := ini.ReadInteger('TLS', 'TimeForeGround',
        TimeForeGround);
      TimeSecondColor := ini.ReadInteger('TLS', 'TimeSecondColor',
        TimeSecondColor);
      AirFontComment := ini.ReadInteger('TLS', 'AirFontComment',
        AirFontComment);
      DefaultMediaColor := ini.ReadInteger('TLS', 'DefaultMediaColor',
        DefaultMediaColor);
      DefaultTextColor := ini.ReadInteger('TLS', 'DefaultTextColor',
        DefaultTextColor);
      StartColorCursor := ini.ReadInteger('TLS', 'StartColorCursor',
        StartColorCursor);
      EndColorCursor := ini.ReadInteger('TLS', 'EndColorCursor',
        EndColorCursor);
      // Layer2FontColor := ini.ReadInteger('TLS','Layer2FontColor',Layer2FontColor);
      // Layer2FontSize := ini.ReadInteger('TLS','Layer2FontSize',Layer2FontSize);
      StatusColor[0] := ini.ReadInteger('TLS', 'StatusColor0', StatusColor[0]);
      StatusColor[1] := ini.ReadInteger('TLS', 'StatusColor1', StatusColor[1]);
      StatusColor[2] := ini.ReadInteger('TLS', 'StatusColor2', StatusColor[2]);
      StatusColor[3] := ini.ReadInteger('TLS', 'StatusColor3', StatusColor[3]);
      StatusColor[4] := ini.ReadInteger('TLS', 'StatusColor4', StatusColor[4]);
      TLMaxFrameSize := ini.ReadInteger('TLS', 'TLMaxFrameSize',
        TLMaxFrameSize);
      TLPreroll := ini.ReadInteger('TLS', 'TLPreroll', TLPreroll);
      TLPostroll := ini.ReadInteger('TLS', 'TLPostroll', TLPostroll);
      TLFlashDuration := ini.ReadInteger('TLS', 'TLFlashDuration',
        TLFlashDuration);
      // TLFontColor := ini.ReadInteger('TLS','TLFontColor',TLFontColor);
      // Основные параметры кнопок
      ProgBTNSFontName := ini.ReadString('BUTTONS', 'ProgBTNSFontName',
        ProgBTNSFontName);
      ProgBTNSFontColor := ini.ReadInteger('BUTTONS', 'ProgBTNSFontColor',
        ProgBTNSFontColor);
      ProgBTNSFontSize := ini.ReadInteger('BUTTONS', 'ProgBTNSFontSize',
        ProgBTNSFontSize);
      HintBTNSFontName := ini.ReadString('BUTTONS', 'HintBTNSFontName',
        HintBTNSFontName);
      HintBTNSFontColor := ini.ReadInteger('BUTTONS', 'HintBTNSFontColor',
        HintBTNSFontColor);
      HintBTNSFontSize := ini.ReadInteger('BUTTONS', 'HintBTNSFontSize',
        HintBTNSFontSize);

      // Цвета по умолчанию для событий
      For i := 0 to 31 do
        DefaultColors[i] := ini.ReadInteger('DefaultColors',
          'Dev' + inttostr(i + 1), DefaultColors[i]);
      DefaultMediaColor := ini.ReadInteger('DefaultColors', 'DefaultMediaColor',
        DefaultMediaColor);
      DefaultTextColor := ini.ReadInteger('DefaultColors', 'DefaultTextColor',
        DefaultTextColor);

      // Установка шрифтов гридов
      RowGridClips.SetDefaultFonts;
      RowGridProject.SetDefaultFonts;
      RowGridListPL.SetDefaultFonts;
      RowGridListTxt.SetDefaultFonts;
      RowGridListGR.SetDefaultFonts;
      TempGridRow.SetDefaultFonts;

      // Параметры принтера
      ch := formatsettings.DecimalSeparator;
      formatsettings.DecimalSeparator := '.';
      PrintSpaceLeft := ini.ReadFloat('PRINT', 'PrintSpaceLeft',
        PrintSpaceLeft);
      PrintSpaceRight := ini.ReadFloat('PRINT', 'PrintSpaceRight',
        PrintSpaceRight);
      PrintSpaceTop := ini.ReadFloat('PRINT', 'PrintSpaceTop', PrintSpaceTop);
      PrintSpaceBottom := ini.ReadFloat('PRINT', 'PrintSpaceBottom',
        PrintSpaceBottom);
      PrintHeadLineTop := ini.ReadFloat('PRINT', 'PrintHeadLineTop',
        PrintHeadLineTop);
      PrintHeadLineBottom := ini.ReadFloat('PRINT', 'PrintHeadLineBottom',
        PrintHeadLineBottom);
      formatsettings.DecimalSeparator := ch;
      PrintCol1 := ini.ReadString('PRINT', 'PrintCol1', PrintCol1);
      PrintCol2 := ini.ReadString('PRINT', 'PrintCol2', PrintCol2);
      PrintCol3 := ini.ReadString('PRINT', 'PrintCol3', PrintCol3);
      PrintCol4 := ini.ReadString('PRINT', 'PrintCol4', PrintCol4);
      PrintCol5 := ini.ReadString('PRINT', 'PrintCol5', PrintCol5);
      PrintCol61 := ini.ReadString('PRINT', 'PrintCol61', PrintCol61);
      PrintCol62 := ini.ReadString('PRINT', 'PrintCol62', PrintCol62);
      PrintDeviceName := ini.ReadString('PRINT', 'PrintDeviceName',
        PrintDeviceName);

      // Размеры щрифтов для таблиц панелей
      MTFontSize := ini.ReadInteger('TABLE', 'MTFontSize', MTFontSize);
      MTFontSizeS := ini.ReadInteger('TABLE', 'MTFontSizeS', MTFontSizeS);
      MTFontSizeB := ini.ReadInteger('TABLE', 'MTFontSizeB', MTFontSizeB);

      WriteLog('MAIN', 'Окончание чтения IniFile: ' + AppPath + AppName
        + '.ini');

    finally
      ini.Free;
    end;

  except
    on E: Exception do
      WriteLog('MAIN', 'ReadMyIniFile(' + AppPath + AppName + '.ini) | ' +
        E.Message);
  end;
end;

end.
