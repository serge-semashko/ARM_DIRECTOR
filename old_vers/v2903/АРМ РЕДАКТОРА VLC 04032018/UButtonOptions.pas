unit UButtonOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, utimeline, umyevents, Grids;

type
  TFButtonOptions = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    lbNumber: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Bevel2: TBevel;
    ColorDialog1: TColorDialog;
    Panel2: TPanel;
    Panel3: TPanel;
    Image2: TImage;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
    Panel5: TPanel;
    Panel6: TPanel;
    Label4: TLabel;
    cbFontName: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Panel7: TPanel;
    CheckBox1: TCheckBox;
    Label7: TLabel;
    cbMainFont: TComboBox;
    cbSubFont: TComboBox;
    Label8: TLabel;
    ColorBox1: TColorBox;
    Panel8: TPanel;
    Bevel1: TBevel;
    Label9: TLabel;
    Edit1: TEdit;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure Image1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbFontNameMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure cbFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Edit1Change(Sender: TObject);
    procedure cbFontNameChange(Sender: TObject);
    procedure cbMainFontChange(Sender: TObject);
    procedure cbSubFontChange(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    StringGridDoubleClick: boolean;
    procedure LoadStringGrid;
  public
    { Public declarations }
    TypeEvent: Integer;
  end;

var
  FButtonOptions: TFButtonOptions;
  WorkEvent: TMyEvent;
  myRect: TRect;

function EditButtonsOptions(nom: Integer; obj: TTimelineOptions): boolean;

implementation

uses umain, ucommon, uimgbuttons, ugrtimelines, udrawtimelines, ugrid, umyfiles,
  uinitforms;

{$R *.dfm}

procedure SwitchObjects(TL: TTypetimeline);
begin
  try
    with FButtonOptions do
    begin
      Case TL of
        tldevice:
          begin
            Edit1.Visible := true;
            Label1.Caption := 'Номер устройства';
            Label9.Visible := true;
            lbNumber.Visible := true;
            StringGrid1.Visible := true;
            CheckBox1.Visible := true;
            Bevel1.Visible := true;
            Label3.Visible := true;
            Label5.Visible := true;
            SpeedButton3.Visible := true;
            cbMainFont.Enabled := true;
            cbSubFont.Enabled := true;
            ColorBox1.Enabled := true;
            WriteLog('ButtonOptions', 'UButtonOptions.SwitchObjects tldevice');
          end;
        tltext:
          begin
            Edit1.Visible := false;
            Label1.Caption := 'Текстовое событие';
            Label9.Visible := false;
            lbNumber.Visible := false;
            StringGrid1.Visible := false;
            CheckBox1.Visible := false;
            Bevel1.Visible := false;
            Label3.Visible := false;
            Label5.Visible := false;
            SpeedButton3.Visible := false;
            cbMainFont.Enabled := false;
            ColorBox1.Enabled := false;
            WriteLog('ButtonOptions', 'UButtonOptions.SwitchObjects tltext');
          end;
        tlmedia:
          begin
            Edit1.Visible := false;
            Label1.Caption := 'Медиа событие';
            Label9.Visible := false;
            lbNumber.Visible := false;
            StringGrid1.Visible := false;
            CheckBox1.Visible := false;
            Bevel1.Visible := false;
            Label3.Visible := false;
            Label5.Visible := false;
            SpeedButton3.Visible := false;
            cbMainFont.Enabled := false;
            ColorBox1.Enabled := true;
            WriteLog('ButtonOptions', 'UButtonOptions.SwitchObjects tlmedia');
          end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'UButtonOptions.SwitchObjects | ' + E.Message);
  end;
end;

procedure TFButtonOptions.LoadStringGrid;
var
  i, WDTH, HGHT, DLT: Integer;
begin
  try
    WriteLog('ButtonOptions', 'TFButtonOptions.LoadStringGrid');
    with Form1 do
    begin
      GridClear(StringGrid1, RowGridListGR);
      StringGrid1.RowCount := 0; // GridGRTemplate
      for i := 0 to GridGRTemplate.RowCount - 1 do
      begin
        GridAddRow(StringGrid1, RowGridListGR);
        (StringGrid1.Objects[0, StringGrid1.RowCount - 1] as TGridRows)
          .Assign((GridGRTemplate.Objects[0, i] as TGridRows));
      end;
    end;
    application.ProcessMessages;
    GridImageReload(StringGrid1);
    StringGrid1.Repaint;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'TFButtonOptions.LoadStringGrid | ' +
        E.Message);
  end;
end;

procedure DrawEvent(TypeEvent: Integer);
var
  i, j, tpp, lft: Integer;
  rt: TRect;
begin
  try
    WriteLog('ButtonOptions', 'UButtonOptions.DrawEvent TypeEvent=' +
      inttostr(TypeEvent));
    FButtonOptions.Image2.Canvas.Brush.Style := bsSolid;
    FButtonOptions.Image2.Canvas.Brush.Color := TLParameters.ForeGround;
    FButtonOptions.Image2.Canvas.FillRect
      (FButtonOptions.Image2.Canvas.ClipRect);

    case TypeEvent of
      0:
        TLZone.TLEditor.DrawEditorDeviceEvent(WorkEvent,
          FButtonOptions.Image2.Canvas, myRect, false);
      1:
        TLZone.TLEditor.DrawEditorTextEvent(WorkEvent,
          FButtonOptions.Image2.Canvas, myRect, false);
      2:
        begin
          FButtonOptions.Image2.Canvas.Brush.Color := WorkEvent.Color;
          rt.Top := myRect.Top;
          rt.Bottom := myRect.Bottom;
          rt.Left := FButtonOptions.Image2.Canvas.ClipRect.Left;
          rt.Right := FButtonOptions.Image2.Canvas.ClipRect.Right;
          FButtonOptions.Image2.Canvas.FillRect(rt);
          TLZone.TLEditor.DrawEditorMediaEvent(WorkEvent,
            FButtonOptions.Image2.Canvas, myRect, false);
        end;
    end;

    tpp := myRect.Top;
    lft := WorkEvent.Start * TLParameters.FrameSize;
    FButtonOptions.Image2.Canvas.Brush.Style := bsClear;
    FButtonOptions.Image2.Canvas.Pen.Color := SmoothColor(WorkEvent.Color, 48);
    FButtonOptions.Image2.Canvas.Pen.Style := psDot;
    for i := 0 to WorkEvent.Count - 1 do
    begin
      for j := 0 to WorkEvent.Rows[i].Count - 1 do
      begin
        rt.Top := tpp + WorkEvent.Rows[i].Phrases[j].Rect.Top;
        rt.Bottom := tpp + WorkEvent.Rows[i].Phrases[j].Rect.Bottom;
        rt.Left := lft + WorkEvent.Rows[i].Phrases[j].Rect.Left;
        rt.Right := lft + WorkEvent.Rows[i].Phrases[j].Rect.Right;
        if rt.Right > WorkEvent.Finish * TLParameters.FrameSize then
          rt.Right := WorkEvent.Finish * TLParameters.FrameSize;
        FButtonOptions.Image2.Canvas.Rectangle(rt);
      end;
    end;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'UButtonOptions.DrawEvent | ' + E.Message);
  end;
end;

Procedure SetDeviceEvent(nom: Integer; obj: TTimelineOptions);
var
  i, Index: Integer;
  txt, grtmpl: string;
begin
  try
    WriteLog('ButtonOptions', 'UButtonOptions.SetDeviceEvent Number=' +
      inttostr(nom));
    FButtonOptions.StringGrid1.Visible := true;
    FButtonOptions.LoadStringGrid;

    WorkEvent.Assign(obj.DevEvents[nom]);
    WorkEvent.Start := 5;
    WorkEvent.Finish := FButtonOptions.Image2.Width div TLParameters.
      FrameSize - 5;

    FButtonOptions.cbFontName.ItemIndex :=
      FButtonOptions.cbFontName.Items.IndexOf(Trim(WorkEvent.FontName));
    Index := FButtonOptions.cbMainFont.Items.IndexOf
      (inttostr(WorkEvent.FontSize));
    if index = -1 then
      FButtonOptions.cbMainFont.Text := inttostr(WorkEvent.FontSize)
    else
      FButtonOptions.cbMainFont.ItemIndex := index;
    Index := FButtonOptions.cbSubFont.Items.IndexOf
      (inttostr(WorkEvent.FontSizeSub));
    if index = -1 then
      FButtonOptions.cbSubFont.Text := inttostr(WorkEvent.FontSizeSub)
    else
      FButtonOptions.cbSubFont.ItemIndex := index;
    txt := WorkEvent.ReadPhraseCommand('Text');
    if Trim(txt) = '' then
    begin
      FButtonOptions.Label3.Caption := 'Не установлен';
      For i := 0 to FButtonOptions.StringGrid1.RowCount - 1 do
        if FButtonOptions.StringGrid1.Objects[0, i] is TGridRows then
          (FButtonOptions.StringGrid1.Objects[0, i] as TGridRows).MyCells[0]
            .Mark := false;
    end
    else
    begin
      FButtonOptions.Label3.Caption := txt;
      For i := 0 to FButtonOptions.StringGrid1.RowCount - 1 do
      begin
        if FButtonOptions.StringGrid1.Objects[0, i] is TGridRows then
        begin
          (FButtonOptions.StringGrid1.Objects[0, i] as TGridRows).MyCells[0]
            .ColorTrue := clRed;
          grtmpl := (FButtonOptions.StringGrid1.Objects[0, i] as TGridRows)
            .MyCells[(FButtonOptions.StringGrid1.Objects[0, i] as TGridRows)
            .Count - 1].ReadPhrase('File');
          if Trim(lowercase(grtmpl)) = Trim(lowercase(txt)) then
          begin
            (FButtonOptions.StringGrid1.Objects[0, i] as TGridRows)
              .MyCells[0].Mark := true;
            FButtonOptions.StringGrid1.Row := i;
          end
          else
            (FButtonOptions.StringGrid1.Objects[0, i] as TGridRows)
              .MyCells[0].Mark := false;
        end;
      end;
    end;
    FButtonOptions.ColorBox1.Selected := WorkEvent.FontColor;
    FButtonOptions.lbNumber.Caption :=
      inttostr(WorkEvent.ReadPhraseData('Device'));
    FButtonOptions.Edit1.Text := WorkEvent.ReadPhraseText('Device');

    myRect.Left := 0;
    myRect.Right := FButtonOptions.Image2.Width;
    myRect.Top := (FButtonOptions.Image2.Height - 110) div 2;
    myRect.Bottom := myRect.Top + 110;

    DrawEvent(FButtonOptions.TypeEvent);

    FButtonOptions.lbNumber.Caption := inttostr(nom + 1);

    FButtonOptions.Image1.Canvas.Brush.Style := bsSolid;
    FButtonOptions.Image1.Canvas.Brush.Color := obj.DevEvents[nom].Color;
    FButtonOptions.Image1.Canvas.FillRect
      (FButtonOptions.Image1.Canvas.ClipRect);
    FButtonOptions.Image1.Canvas.Font.Color := FormsFontColor;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'UButtonOptions.SetDeviceEvent | ' + E.Message);
  end;
end;

Procedure SetTextEvent(nom: Integer; obj: TTimelineOptions);
var
  i, Index: Integer;
  txt, grtmpl: string;
begin
  try
    WriteLog('ButtonOptions', 'UButtonOptions.SetTextEvent Number=' +
      inttostr(nom));
    FButtonOptions.StringGrid1.Visible := false;

    WorkEvent.Assign(obj.TextEvent);
    WorkEvent.Start := 5;
    WorkEvent.Finish := FButtonOptions.Image2.Width div TLParameters.
      FrameSize - 5;
    WorkEvent.SetRectAreas(obj.TypeTL);

    FButtonOptions.cbFontName.ItemIndex :=
      FButtonOptions.cbFontName.Items.IndexOf(Trim(WorkEvent.FontName));

    Index := FButtonOptions.cbSubFont.Items.IndexOf
      (inttostr(WorkEvent.FontSizeSub));
    if index = -1 then
      FButtonOptions.cbSubFont.Text := inttostr(WorkEvent.FontSizeSub)
    else
      FButtonOptions.cbSubFont.ItemIndex := index;

    txt := WorkEvent.ReadPhraseText('Color');
    if Trim(txt) = '' then
    begin
      WorkEvent.SetPhraseText('Color', 'White');
      WorkEvent.SetPhraseData('Color', clWhite);
    end;
    FButtonOptions.ColorBox1.Selected := WorkEvent.ReadPhraseData('Color');

    myRect.Left := 0;
    myRect.Right := FButtonOptions.Image2.Width;
    myRect.Top := (FButtonOptions.Image2.Height - 110) div 2;
    myRect.Bottom := myRect.Top + 110;

    DrawEvent(FButtonOptions.TypeEvent);

    FButtonOptions.Image1.Canvas.Brush.Style := bsSolid;
    FButtonOptions.Image1.Canvas.Brush.Color := obj.TextColor;
    FButtonOptions.Image1.Canvas.FillRect
      (FButtonOptions.Image1.Canvas.ClipRect);
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'UButtonOptions.SetTextEvent | ' + E.Message);
  end;
end;

Procedure SetMediaEvent(nom: Integer; obj: TTimelineOptions);
var
  i, Index: Integer;
  txt, grtmpl: string;
begin
  try
    WriteLog('ButtonOptions', 'UButtonOptions.SetMediaEvent Number=' +
      inttostr(nom));
    FButtonOptions.StringGrid1.Visible := false;

    WorkEvent.Assign(obj.MediaEvent);
    WorkEvent.Start := 50;
    WorkEvent.Finish := FButtonOptions.Image2.Width div TLParameters.
      FrameSize - 10;
    WorkEvent.SetRectAreas(obj.TypeTL);

    FButtonOptions.cbFontName.ItemIndex :=
      FButtonOptions.cbFontName.Items.IndexOf(Trim(WorkEvent.FontName));

    Index := FButtonOptions.cbSubFont.Items.IndexOf
      (inttostr(WorkEvent.FontSizeSub));
    if index = -1 then
      FButtonOptions.cbSubFont.Text := inttostr(WorkEvent.FontSizeSub)
    else
      FButtonOptions.cbSubFont.ItemIndex := index;

    txt := WorkEvent.ReadPhraseText('Color');
    if Trim(txt) = '' then
    begin
      WorkEvent.SetPhraseText('Color', 'White');
      WorkEvent.SetPhraseData('Color', clWhite);
    end;
    FButtonOptions.ColorBox1.Selected := WorkEvent.ReadPhraseData('Color');

    myRect.Left := 0;
    myRect.Right := FButtonOptions.Image2.Width;
    myRect.Top := (FButtonOptions.Image2.Height - 110) div 2;
    myRect.Bottom := myRect.Top + 110;

    DrawEvent(FButtonOptions.TypeEvent);

    FButtonOptions.Image1.Canvas.Brush.Style := bsSolid;
    FButtonOptions.Image1.Canvas.Brush.Color := obj.MediaColor;
    FButtonOptions.Image1.Canvas.FillRect
      (FButtonOptions.Image1.Canvas.ClipRect);
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'UButtonOptions.SetMediaEvent | ' + E.Message);
  end;
end;

function EditButtonsOptions(nom: Integer; obj: TTimelineOptions): boolean;
begin
  try
    WriteLog('MAIN', 'UButtonOptions.EditButtonsOptions Start Number=' +
      inttostr(nom));
    WriteLog('ButtonOptions', 'UButtonOptions.EditButtonsOptions Start Number='
      + inttostr(nom));

    result := false;
    FButtonOptions.TypeEvent := ord(obj.TypeTL);
    SwitchObjects(obj.TypeTL);
    case obj.TypeTL of
      tldevice:
        SetDeviceEvent(nom, obj);
      tltext:
        SetTextEvent(nom, obj);
      tlmedia:
        SetMediaEvent(nom, obj);
    end;

    FButtonOptions.ShowModal;
    if FButtonOptions.ModalResult = mrOk then
    begin

      case obj.TypeTL of
        tldevice:
          obj.DevEvents[nom].Assign(WorkEvent);
        tltext:
          begin
            obj.TextEvent.Assign(WorkEvent);
            obj.TextColor := WorkEvent.Color;
          end;
        tlmedia:
          begin
            obj.MediaEvent.Assign(WorkEvent);
            obj.MediaColor := WorkEvent.Color;
          end;
      end;
      result := true;
    end;

    WriteLog('ButtonOptions', 'UButtonOptions.EditButtonsOptions Finish Number='
      + inttostr(nom));
    WriteLog('MAIN', 'UButtonOptions.EditButtonsOptions Finish Number=' +
      inttostr(nom));
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'UButtonOptions.EditButtonsOptions | ' +
        E.Message);
  end;
end;

procedure TFButtonOptions.Image1Click(Sender: TObject);
var
  deltx, delty: Integer;
begin
  ColorDialog1.Color := Image1.Canvas.Brush.Color;
  if ColorDialog1.Execute then
  begin
    Image1.Canvas.Brush.Color := ColorDialog1.Color;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    WorkEvent.Color := ColorDialog1.Color;
    DrawEvent(FButtonOptions.TypeEvent);
  end;
end;

procedure TFButtonOptions.SpeedButton1Click(Sender: TObject);
begin
  FButtonOptions.ModalResult := mrOk;
end;

procedure TFButtonOptions.SpeedButton2Click(Sender: TObject);
begin
  FButtonOptions.ModalResult := mrCancel;
end;

procedure TFButtonOptions.FormCreate(Sender: TObject);
begin
  StringGridDoubleClick := false;
  cbFontName.Items.Assign(Screen.Fonts);
  InitFrButtonOptions;
  initgrid(StringGrid1, RowGridListGR, Panel3.Width);
end;

procedure TFButtonOptions.StringGrid1DrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(StringGrid1, ACol, ARow, Rect);
end;

procedure TFButtonOptions.Image2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  i, rw, ph, tpp, Top, btm, l1, r1, lft: Integer;
begin
  try
    lft := WorkEvent.Start * TLParameters.FrameSize;
    for i := 0 to WorkEvent.Count - 1 do
    begin
      for ph := 0 to WorkEvent.Rows[i].Count - 1 do
      begin
        Top := myRect.Top + WorkEvent.Rows[i].Phrases[ph].Rect.Top;
        btm := myRect.Top + WorkEvent.Rows[i].Phrases[ph].Rect.Bottom;
        l1 := lft + WorkEvent.Rows[i].Phrases[ph].Rect.Left;
        r1 := lft + WorkEvent.Rows[i].Phrases[ph].Rect.Right;
        if (X >= l1) and (X <= r1) and (Y >= Top) and (Y <= btm) then
        begin
          WorkEvent.Rows[i].Phrases[ph].Select := true;
        end;
      end;
    end;
    // TLZone.TLEditor.DrawEditorDeviceEvent(WorkEvent, FButtonOptions.Image2.Canvas, MyRect, false);
    DrawEvent(FButtonOptions.TypeEvent);
    WorkEvent.EventSelectFalse;
    Image2.Repaint;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'TFButtonOptions.Image2MouseMove | ' +
        E.Message);
  end;
end;

procedure TFButtonOptions.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, rw, ph, tpp, Top, btm, l1, r1, lft: Integer;
begin
  try
    lft := WorkEvent.Start * TLParameters.FrameSize;
    for i := 0 to WorkEvent.Count - 1 do
    begin
      for ph := 0 to WorkEvent.Rows[i].Count - 1 do
      begin
        Top := myRect.Top + WorkEvent.Rows[i].Phrases[ph].Rect.Top;
        btm := myRect.Top + WorkEvent.Rows[i].Phrases[ph].Rect.Bottom;
        l1 := lft + WorkEvent.Rows[i].Phrases[ph].Rect.Left;
        r1 := lft + WorkEvent.Rows[i].Phrases[ph].Rect.Right;
        if (X >= l1) and (X <= r1) and (Y >= Top) and (Y <= btm) then
        begin
          WorkEvent.Rows[i].Phrases[ph].Select := true;
          TLZone.TLEditor.UpdateEventData(WorkEvent);
          Break;
        end;
      end;
    end;
    DrawEvent(FButtonOptions.TypeEvent);
    WorkEvent.EventSelectFalse;
    Image2.Repaint;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'TFButtonOptions.Image2MouseUp | ' + E.Message);
  end;
end;

procedure TFButtonOptions.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, rw, ph, tpp, Top, btm, l1, r1, lft: Integer;
begin
  try
    lft := WorkEvent.Start * TLParameters.FrameSize;
    for i := 0 to WorkEvent.Count - 1 do
    begin
      for ph := 0 to WorkEvent.Rows[i].Count - 1 do
      begin
        Top := myRect.Top + WorkEvent.Rows[i].Phrases[ph].Rect.Top;
        btm := myRect.Top + WorkEvent.Rows[i].Phrases[ph].Rect.Bottom;
        l1 := lft + WorkEvent.Rows[i].Phrases[ph].Rect.Left;
        r1 := lft + WorkEvent.Rows[i].Phrases[ph].Rect.Right;
        if (X >= l1) and (X <= r1) and (Y >= Top) and (Y <= btm) then
        begin
          WorkEvent.Rows[i].Phrases[ph].Select := true;
          // if WorkEvent.Rows[i].Phrases[ph].Select then TLZone.TLEditor.UpdateEventData(WorkEvent);
          // exit;
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'TFButtonOptions.Image2MouseDown | ' +
        E.Message);
  end;
end;

procedure TFButtonOptions.cbFontNameMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if Index = -1 then
    Exit;
  with cbFontName.Canvas do
  begin
    Font.Name := cbFontName.Items[Index];
    Font.Size := 0;
    Height := TextHeight('Wg') + 2;
  end;
end;

procedure TFButtonOptions.cbFontNameDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if Index = -1 then
    Exit;
  with cbFontName.Canvas do
  begin
    FillRect(Rect);
    Font.Name := cbFontName.Items[Index];
    Font.Size := 0;
    TextOut(Rect.Left, Rect.Top, cbFontName.Items[Index]);
  end;
end;

procedure TFButtonOptions.Edit1Change(Sender: TObject);
begin
  if Trim(Edit1.Text) = '' then
    WorkEvent.SetPhraseText('Device',
      inttostr(WorkEvent.ReadPhraseData('Device')))
  else
    WorkEvent.SetPhraseText('Device', Trim(Edit1.Text));
  DrawEvent(FButtonOptions.TypeEvent);
  WorkEvent.EventSelectFalse;
  Image2.Repaint;
end;

procedure TFButtonOptions.cbFontNameChange(Sender: TObject);
begin
  if Trim(cbFontName.Text) <> '' then
  begin
    WorkEvent.FontName := cbFontName.Text;
    DrawEvent(FButtonOptions.TypeEvent);
    WorkEvent.EventSelectFalse;
    Image2.Repaint;
  end;
end;

procedure TFButtonOptions.cbMainFontChange(Sender: TObject);
begin
  if Trim(cbMainFont.Text) <> '' then
  begin
    WorkEvent.FontSize := strtoint(cbMainFont.Text);
    DrawEvent(FButtonOptions.TypeEvent);
    WorkEvent.EventSelectFalse;
    Image2.Repaint;
  end;
end;

procedure TFButtonOptions.cbSubFontChange(Sender: TObject);
begin
  if Trim(cbSubFont.Text) <> '' then
  begin
    WorkEvent.FontSizeSub := strtoint(cbSubFont.Text);
    DrawEvent(FButtonOptions.TypeEvent);
    WorkEvent.EventSelectFalse;
    Image2.Repaint;
  end;
end;

procedure TFButtonOptions.ColorBox1Change(Sender: TObject);
begin
  WorkEvent.FontColor := ColorBox1.Selected;
  DrawEvent(FButtonOptions.TypeEvent);
  WorkEvent.EventSelectFalse;
  Image2.Repaint;
end;

procedure TFButtonOptions.StringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, j, rw, ps: Integer;
  txt, flnm: string;
begin
  try
    // if (TLzone.TLEditor.TypeTL=tltext) or (TLzone.TLEditor.TypeTL=tlmedia) then exit;
    if not StringGridDoubleClick then
      Exit;
    rw := GridClickRow(StringGrid1, Y);
    if rw = -1 then
      Exit;
    if StringGrid1.Objects[0, rw] is TGridRows then
    begin
      with (StringGrid1.Objects[0, rw] as TGridRows) do
      begin
        for j := 0 to StringGrid1.RowCount - 1 do
          (StringGrid1.Objects[0, j] as TGridRows).MyCells[0].Mark := false;
        MyCells[0].Mark := true;
        MyCells[0].ColorTrue := clRed;
        txt := MyCells[Count - 1].ReadPhrase('Template');
        flnm := MyCells[Count - 1].ReadPhrase('File');
      end;
      if not CheckBox1.Checked then
        WorkEvent.SetPhraseText('Text', txt);
      WorkEvent.SetPhraseCommand('Text', flnm);
      Label3.Caption := flnm;
      StringGrid1.Repaint;
      DrawEvent(FButtonOptions.TypeEvent);
      WorkEvent.EventSelectFalse;
      Image2.Repaint;
    end;
    StringGridDoubleClick := false;
  except
    on E: Exception do
      WriteLog('ButtonOptions', 'TFButtonOptions.StringGrid1MouseUp | ' +
        E.Message);
  end;
end;

procedure TFButtonOptions.StringGrid1DblClick(Sender: TObject);
begin
  StringGridDoubleClick := true;
end;

procedure TFButtonOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      ModalResult := mrOk;
    #27:
      ModalResult := mrCancel;
  end;
end;

procedure TFButtonOptions.SpeedButton4Click(Sender: TObject);
begin
  case TypeEvent of
    0:
      WorkEvent.Color := DefaultColors[WorkEvent.ReadPhraseData('Device') - 1];
    1:
      WorkEvent.Color := TLParameters.ForeGround;
    2:
      WorkEvent.Color := DefaultMediaColor;
  end;
  Image1.Canvas.Brush.Color := WorkEvent.Color;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  DrawEvent(FButtonOptions.TypeEvent);
  Image2.Repaint;
end;

procedure TFButtonOptions.SpeedButton3Click(Sender: TObject);
var
  i: Integer;
begin
  Label3.Caption := 'Не установлен';
  WorkEvent.SetPhraseCommand('Text', '');
  for i := 0 to StringGrid1.RowCount - 1 do
    (StringGrid1.Objects[0, i] as TGridRows).MyCells[0].Mark := false;
  StringGrid1.Repaint;
end;

initialization

WorkEvent := TMyEvent.Create;

finalization

WorkEvent.FreeInstance;

end.
