unit UHRTimer;

interface

uses Windows;

type

  THRTimer = class(TObject)
    constructor Create;
    function StartTimer: Boolean;
    function ReadTimer: Double;
    procedure StopTimer;
  private
    StartTime: Double;
    ClockRate: Double;
  public
    Waiting: Boolean;
    Exists: Boolean;
    Enable: Boolean;
  end;

  { --------------------------Реализация----------------------------------- }

implementation

{ ------------------Create-------------------------John Mertus----Мар 97- }

constructor THRTimer.Create;

{ Получаем точное системное время и сохраняем его для дальнейшего }
{ использования. }
{ }
{ *********************************************************************** }
var

  QW: Int64;

begin

  inherited Create;
  Exists := QueryPerformanceFrequency(QW);
  ClockRate := QW;
end;

{ ------------------StartTimer---------------------John Mertus----Мар 97- }

function THRTimer.StartTimer: Boolean;

{ Получаем точное системное время и сохраняем его для дальнейшего }
{ использования. }
{ }
{ *********************************************************************** }
var

  SW: Int64;

begin

  Result := QueryPerformanceCounter(SW);
  StartTime := SW; // .QuadPart;
  Enable := True;
end;

{ -------------------ReadTimer---------------------John Mertus----Мар 97--- }

function THRTimer.ReadTimer: Double;

{ Получаем точное системное время и сохраняем его для дальнейшего }
{ использования. }
{ }
{ *********************************************************************** }
var

  ET: Int64;

begin

  QueryPerformanceCounter(ET);
  Result := (ET - StartTime) / ClockRate;
end;

procedure THRTimer.StopTimer;
begin
  Enable := False;
end;

end.
