object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1076#1072#1095#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 167
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 14
  object Shape1: TShape
    Left = 376
    Top = 35
    Width = 23
    Height = 19
  end
  object SpeedButton2: TSpeedButton
    Left = 152
    Top = 60
    Width = 103
    Height = 22
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    Flat = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 0
    Top = 88
    Width = 402
    Height = 79
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 257
  end
  object Label2: TLabel
    Left = 80
    Top = 11
    Width = 59
    Height = 14
    Caption = #1055#1077#1088#1077#1076#1072#1095#1072':'
  end
  object SpeedButton1: TSpeedButton
    Left = 376
    Top = 35
    Width = 22
    Height = 19
    Caption = #1061
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton3: TSpeedButton
    Left = 312
    Top = 60
    Width = 58
    Height = 22
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 32
    Top = 60
    Width = 57
    Height = 22
    OnClick = SpeedButton4Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 35
    Width = 369
    Height = 20
    Ctl3D = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object RadioButton1: TRadioButton
    Left = 161
    Top = 11
    Width = 65
    Height = 17
    Caption = #1041#1072#1081#1090#1099
    Checked = True
    TabOrder = 1
    TabStop = True
    StyleElements = []
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 240
    Top = 11
    Width = 76
    Height = 17
    Caption = #1057#1080#1084#1074#1086#1083#1099
    TabOrder = 2
    StyleElements = []
    OnClick = RadioButton2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 32
    Top = 16
  end
end
