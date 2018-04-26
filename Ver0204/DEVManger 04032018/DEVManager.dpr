program DEVManager;
{$M 163840,16000000}
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
  USetID in 'USetID.pas' {FrSetID},
  Web.Win.Sockets in '..\helpers\Web.Win.Sockets.pas',
  uwebredis_common in '..\helpers\uwebredis_common.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfrOptions, frOptions);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TFrSetID, FrSetID);
  Application.Run;
end.
