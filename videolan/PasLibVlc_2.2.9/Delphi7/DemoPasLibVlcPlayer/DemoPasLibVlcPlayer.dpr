{$I ..\..\source\compiler.inc}
program DemoPasLibVlcPlayer;

uses
  Forms,
  PasLibVlcUnit in '..\..\source\PasLibVlcUnit.pas',
  PasLibVlcClassUnit in '..\..\source\PasLibVlcClassUnit.pas',
  PasLibVlcPlayerUnit in '..\..\source.vcl\PasLibVlcPlayerUnit.pas',
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  FullScreenFormUnit in 'FullScreenFormUnit.pas' {FullScreenForm},
  SetEqualizerPresetFormUnit in 'SetEqualizerPresetFormUnit.pas' {SetEqualizerPresetForm},
  SelectOutputDeviceFormUnit in 'SelectOutputDeviceFormUnit.pas' {SelectOutputDeviceForm},
  VideoAdjustFormUnit in 'VideoAdjustFormUnit.pas' {VideoAdjustForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PasLibVlcPlayerDemo';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSetEqualizerPresetForm, SetEqualizerPresetForm);
  Application.CreateForm(TSelectOutputDeviceForm, SelectOutputDeviceForm);
  Application.CreateForm(TVideoAdjustForm, VideoAdjustForm);
  Application.Run;
end.
