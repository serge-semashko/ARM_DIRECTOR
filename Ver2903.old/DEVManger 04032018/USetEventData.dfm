object frSetEventData: TfrSetEventData
  Left = 551
  Top = 390
  BorderStyle = bsDialog
  ClientHeight = 133
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 358
    Top = 94
    Width = 162
    Height = 27
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Flat = True
    StyleElements = []
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 196
    Top = 94
    Width = 162
    Height = 27
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Flat = True
    StyleElements = []
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 7
    Top = 0
    Width = 514
    Height = 40
    Align = alCustom
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Layout = tlBottom
    StyleElements = []
  end
  object Label2: TLabel
    Left = 7
    Top = 78
    Width = 182
    Height = 40
    AutoSize = False
    Caption = 'Label2'
    StyleElements = []
  end
  object Edit1: TEdit
    Left = 7
    Top = 49
    Width = 312
    Height = 27
    AutoSize = False
    BevelInner = bvNone
    BevelKind = bkTile
    BevelOuter = bvNone
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = 'Edit1'
    StyleElements = []
  end
  object ComboBox1: TComboBox
    Left = 254
    Top = 49
    Width = 267
    Height = 28
    BevelInner = bvNone
    BevelOuter = bvNone
    Style = csDropDownList
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    StyleElements = []
  end
  object SpinEdit1: TSpinEdit
    Left = 104
    Top = 46
    Width = 98
    Height = 19
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Value = 0
    OnChange = SpinEdit1Change
  end
  object CheckBox1: TCheckBox
    Left = 7
    Top = 98
    Width = 156
    Height = 13
    Caption = 'CheckBox1'
    TabOrder = 3
    Visible = False
    StyleElements = []
  end
end
