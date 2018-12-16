object frShiftTL: TfrShiftTL
  Left = 670
  Top = 292
  BorderStyle = bsDialog
  Caption = #1057#1076#1074#1080#1075' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1081
  ClientHeight = 165
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 58
    Width = 393
    Height = 30
    AutoSize = False
    Caption = 'Label1'
    Layout = tlCenter
    StyleElements = []
  end
  object Label2: TLabel
    Left = 320
    Top = 25
    Width = 89
    Height = 30
    AutoSize = False
    Caption = #1050#1072#1076#1088#1086#1074
    Layout = tlCenter
    StyleElements = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 124
    Width = 437
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object SpeedButton1: TSpeedButton
      Left = 220
      Top = 5
      Width = 178
      Height = 30
      Caption = #1057#1076#1074#1080#1085#1091#1090#1100
      Flat = True
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 38
      Top = 5
      Width = 180
      Height = 30
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      StyleElements = []
      OnClick = SpeedButton2Click
    end
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 96
    Width = 393
    Height = 17
    Caption = #1057#1076#1074#1080#1085#1091#1090#1100' '#1074#1089#1077' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080' '#1085#1072' '#1079#1072#1076#1072#1085#1085#1099#1081' '#1080#1085#1090#1077#1088#1074#1072#1083
    TabOrder = 1
    StyleElements = []
  end
  object SpinEdit1: TSpinEdit
    Left = 24
    Top = 25
    Width = 285
    Height = 30
    AutoSize = False
    Ctl3D = False
    MaxValue = 0
    MinValue = 0
    ParentCtl3D = False
    TabOrder = 2
    Value = 0
    OnChange = SpinEdit1Change
  end
end
