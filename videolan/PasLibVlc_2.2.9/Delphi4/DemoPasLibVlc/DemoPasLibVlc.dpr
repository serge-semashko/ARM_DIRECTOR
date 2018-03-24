{$I ..\..\source\compiler.inc}

program DemoPasLibVlc;

uses
  Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  PasLibVlcUnit in '..\..\source\PasLibVlcUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DemoPasLibVlc';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
