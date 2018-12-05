program webredis;
{$M 163840,16000000}
uses
  Forms,
  ipcthrd,
  mainsrv in 'mainsrv.pas' {HTTPSRVForm},
  System.Types,
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF MSWINDOWS}
  {$IFDEF POSIX}
  Posix.Dlfcn,
  {$ENDIF POSIX}
  {$IFDEF PC_MAPPED_EXCEPTIONS}
  System.Internal.Unwinder,
  {$ENDIF PC_MAPPED_EXCEPTIONS}
  {$IFDEF MACOS}
  Macapi.Mach,
  {$ENDIF MACOS}
  System.SysConst,
  dialogs,
  Web.Win.Sockets in '..\helpers\Web.Win.Sockets.pas',
  uwebredis_common in '..\helpers\uwebredis_common.pas',
  ZLibEx in 'ZLibEx.pas',
  ZLibExApi in 'ZLibExApi.pas',
  ZLibExGZ in 'ZLibExGZ.pas';

// http in 'http.pas';

{$R *.res}

function UniqueApp :Boolean;
Var HM :THandle;
begin
  HM:=CreateMutex(nil, False, PChar(Application.Title));
  Result:=GetLastError<>ERROR_ALREADY_EXISTS;
end;

begin
  if not UniqueApp then
  begin
       showmessage('Приложение уже работает');
       exit;
  end;

  Application.Initialize;
  Application.CreateForm(THTTPSRVForm, HTTPSRVForm);
  Application.Run;

end.
