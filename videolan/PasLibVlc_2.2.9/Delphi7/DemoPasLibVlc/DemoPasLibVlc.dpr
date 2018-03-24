{$I ..\..\source\compiler.inc}
program DemoPasLibVlc;

{%File 'Robert Jêdrzejczyk'}

uses
  Forms,
  PasLibVlcUnit in '..\..\source\PasLibVlcUnit.pas',
  PasLibVlcClassUnit in '..\..\source\PasLibVlcClassUnit.pas',
  PasLibVlcPlayerUnit in '..\..\source.vcl\PasLibVlcPlayerUnit.pas',
  MainFormUnit in 'MainFormUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PasLibVlcDemo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
