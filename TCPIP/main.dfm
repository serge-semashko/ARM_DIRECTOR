object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 428
  ClientWidth = 826
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 826
    Height = 113
    Align = alTop
    Caption = 'Ping'
    TabOrder = 0
    object btnsendbtn: TSpeedButton
      Left = 1
      Top = 0
      Width = 81
      Height = 41
      Caption = 'TCP send'
      OnClick = btnsendbtnClick
    end
    object SpeedButton1: TSpeedButton
      Left = 0
      Top = 47
      Width = 81
      Height = 49
      Caption = 'Ping'
      OnClick = SpeedButton1Click
    end
    object URLEd: TLabeledEdit
      Left = 161
      Top = 17
      Width = 528
      Height = 24
      EditLabel.Width = 22
      EditLabel.Height = 16
      EditLabel.Caption = 'URL'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object sended: TLabeledEdit
      Left = 161
      Top = 45
      Width = 634
      Height = 24
      EditLabel.Width = 50
      EditLabel.Height = 16
      EditLabel.Caption = 'Sendtext'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object portspn: TSpinEdit
      Left = 712
      Top = 17
      Width = 84
      Height = 26
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 80
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 113
    Width = 826
    Height = 315
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
end
