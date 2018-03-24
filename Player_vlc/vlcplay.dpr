{$I compiler.inc}
program VlcPlay;

uses
  Forms,
  PasLibVlcUnit in 'PasLibVlcUnit.pas',
  PasLibVlcClassUnit in 'PasLibVlcClassUnit.pas',
  main in 'main.pas' {MainForm} ,
  vlcpl in 'vlcpl.pas';

{$R *.res}

begin
{$IFDEF DELPHI2007_UP}
  ReportMemoryLeaksOnShutdown := TRUE;
{$ENDIF}
  Application.Initialize;
{$IFDEF DELPHI2007_UP}
  Application.MainFormOnTaskbar := TRUE;
{$ENDIF}
  Application.Title := 'PasLibVlcDemo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.
