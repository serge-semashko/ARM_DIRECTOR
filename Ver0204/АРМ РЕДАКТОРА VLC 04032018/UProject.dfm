object FNewProject: TFNewProject
  Left = 503
  Top = 217
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1077#1082#1090
  ClientHeight = 188
  ClientWidth = 462
  Color = clBackground
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 1
    Top = 17
    Width = 144
    Height = 16
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = []
  end
  object Label2: TLabel
    Left = 21
    Top = 53
    Width = 124
    Height = 16
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = []
  end
  object Label3: TLabel
    Left = 38
    Top = 89
    Width = 105
    Height = 16
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = []
  end
  object SpeedButton1: TSpeedButton
    Left = 354
    Top = 152
    Width = 105
    Height = 27
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = []
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 245
    Top = 152
    Width = 105
    Height = 29
    Caption = #1054#1090#1084#1077#1085#1072
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = []
    OnClick = SpeedButton2Click
  end
  object Edit1: TEdit
    Left = 145
    Top = 16
    Width = 315
    Height = 24
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    StyleElements = []
  end
  object DateTimePicker1: TDateTimePicker
    Left = 145
    Top = 49
    Width = 315
    Height = 24
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BevelKind = bkFlat
    Date = 42594.480064907410000000
    Time = 42594.480064907410000000
    DateFormat = dfLong
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    StyleElements = []
  end
  object Memo1: TMemo
    Left = 145
    Top = 83
    Width = 315
    Height = 57
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 2
    StyleElements = []
  end
end
