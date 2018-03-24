object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 549
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 448
    Height = 549
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 448
    Top = 0
    Width = 185
    Height = 549
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 16
      Top = 16
      Width = 121
      Height = 65
      OnClick = SpeedButton1Click
    end
  end
end
