program webredis;

uses
  Forms,
  uwebserv in 'uwebserv.pas' {HTTPSRVForm};
//  http in 'http.pas';

{$R *.res}

begin
//ddddd
  Application.Initialize;
  Application.CreateForm(THTTPSRVForm, HTTPSRVForm);
  Application.Run;
end.
