program webredis;

uses
  Forms,
  ipcthrd,
<<<<<<< HEAD
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
  Web.Win.Sockets in '..\helpers\Web.Win.Sockets.pas';
=======
  mainsrv in 'mainsrv.pas' {HTTPSRVForm} ,
  System.Types,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  Posix.Dlfcn, Posix.Fcntl, Posix.SysStat, Posix.SysTime, Posix.SysTypes,
  Posix.Locale,
{$ENDIF POSIX}
{$IFDEF PC_MAPPED_EXCEPTIONS}
  System.Internal.Unwinder,
{$ENDIF PC_MAPPED_EXCEPTIONS}
{$IFDEF MACOS}
  Macapi.Mach, Macapi.CoreServices, Macapi.CoreFoundation,
{$ENDIF MACOS}
  System.SysConst,
  dialogs;
>>>>>>> 567489eb579fa25cb906471546da671d36020444

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
