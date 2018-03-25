program DEVManager;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {fmMain},
  ComPortUnit in 'ComPortUnit.pas',
  RusErrorStr in 'RusErrorStr.pas',
  UPortOptions in 'UPortOptions.pas' {frOptions},
  UMyChars in 'UMyChars.pas' {Form3},
  UMySetTC in 'UMySetTC.pas' {FrSetTC},
  UMyInitFile in 'UMyInitFile.pas',
  UCommon in 'UCommon.pas',
  UMyInfo in 'UMyInfo.pas',
  UMyProtocols in 'UMyProtocols.pas',
  UGRTimelines in 'UGRTimelines.pas',
  UMyEvents in 'UMyEvents.pas',
  UTimeline in 'UTimeline.pas',
  uwebget in '..\helpers\uwebget.pas',
  Web.Win.Sockets in '..\helpers\Web.Win.Sockets.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfrOptions, frOptions);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TFrSetTC, FrSetTC);
  Application.Run;
end.
