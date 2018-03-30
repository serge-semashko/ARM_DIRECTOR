unit UAirUtil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids;

Procedure SetSizeAirPanels;

implementation
uses umain;

Procedure SetSizeAirPanels;
begin
  //Form1.pnAir1:=
  Form1.Panel25.Height:=Form1.Panel17.Height;
end;

end.
 
