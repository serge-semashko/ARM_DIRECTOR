program checktcp;


uses
  Forms,
  main in 'main.pas' {mainform},
  Web.Win.Sockets in 'Web.Win.Sockets.pas',
  tlntsend in 'tlntsend.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
