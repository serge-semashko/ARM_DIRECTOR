unit UMDIProjects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Buttons;

type
  TForm2 = class(TForm)
    PanelProject: TPanel;
    Panel6: TPanel;
    Splitter1: TSplitter;
    Panel10: TPanel;
    Panel11: TPanel;
    sbListPlayLists: TSpeedButton;
    sbListGraphTemplates: TSpeedButton;
    sbListTextTemplates: TSpeedButton;
    Bevel4: TBevel;
    Bevel5: TBevel;
    GridLists: TStringGrid;
    Panel5: TPanel;
    GridProjects: TStringGrid;
    Panel2: TPanel;
    imgButtonsProject: TImage;
    imgBlockProjects: TImage;
    lbProjectName: TLabel;
    lbDateEnd: TLabel;
    lbDateStart: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbEditor: TLabel;
    lbpComment: TLabel;
    imgButtonsControlProj: TImage;
    GridTimeLines: TStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
