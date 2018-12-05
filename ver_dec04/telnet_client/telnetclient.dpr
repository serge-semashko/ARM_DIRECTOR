program telnetclient;

uses
  Forms,
  main in 'main.pas' {mainform},
  Web.Win.Sockets in 'Web.Win.Sockets.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmainform, mainform);
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
