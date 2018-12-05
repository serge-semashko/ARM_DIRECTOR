object mainform: Tmainform
  Left = -741
  Top = 37
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1089#1074#1103#1079#1080
  ClientHeight = 562
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object mmo1: TMemo
    Left = 0
    Top = 153
    Width = 862
    Height = 409
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 862
    Height = 153
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 512
      Top = 24
      Width = 145
      Height = 22
      Caption = 'Ping'
    end
    object btn1: TButton
      Left = 7
      Top = 23
      Width = 129
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btn1Click
    end
    object edt1: TEdit
      Left = 152
      Top = 113
      Width = 208
      Height = 24
      TabOrder = 1
      Text = '1001'
    end
    object btn3: TButton
      Left = 7
      Top = 110
      Width = 129
      Height = 31
      Caption = 'Send'
      TabOrder = 2
      OnClick = btn3Click
    end
    object PortED: TLabeledEdit
      Left = 382
      Top = 23
      Width = 91
      Height = 24
      EditLabel.Width = 38
      EditLabel.Height = 16
      EditLabel.Caption = 'PORT'
      TabOrder = 3
      Text = '23'
    end
    object AddrEd: TLabeledEdit
      Left = 152
      Top = 23
      Width = 208
      Height = 24
      EditLabel.Width = 66
      EditLabel.Height = 16
      EditLabel.Caption = 'ADDRESS'
      TabOrder = 4
      Text = '127.0.0.1'
    end
    object Button1: TButton
      Left = 7
      Top = 47
      Width = 129
      Height = 25
      Caption = 'disConnect'
      TabOrder = 5
      OnClick = Button1Click
    end
  end
end
