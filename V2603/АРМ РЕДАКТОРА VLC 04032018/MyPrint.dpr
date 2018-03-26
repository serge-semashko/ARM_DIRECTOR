program MyPrint;

uses
  Forms,
  UMyPrint in 'Печать\UMyPrint.pas' {frMyPrint},
  MyData in 'Печать\MyData.pas',
  UPageSetup in 'Печать\UPageSetup.pas' {FPage};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrMyPrint, frMyPrint);
  Application.CreateForm(TFPage, FPage);
  Application.Run;
end.
