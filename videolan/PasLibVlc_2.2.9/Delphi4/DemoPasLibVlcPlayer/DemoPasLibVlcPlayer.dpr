{$I ..\..\source\compiler.inc}

program DemoPasLibVlcPlayer;

uses
  Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  PasLibVlcUnit in '..\..\source\PasLibVlcUnit.pas',
  PasLibVlcClassUnit in '..\..\source\PasLibVlcClassUnit.pas',
  PasLibVlcPlayerUnit in '..\..\source.vcl\PasLibVlcPlayerUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
