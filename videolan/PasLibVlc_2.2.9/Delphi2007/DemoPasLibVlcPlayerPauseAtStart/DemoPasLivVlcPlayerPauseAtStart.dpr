program DemoPasLivVlcPlayerPauseAtStart;

uses
  Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  PasLibVlcUnit in '..\..\source\PasLibVlcUnit.pas',
  PasLibVlcPlayerUnit in '..\..\source\PasLibVlcPlayerUnit.pas',
  PasLibVlcClassUnit in '..\..\source\PasLibVlcClassUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF DELPHI2007_UP}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
