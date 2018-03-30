object frNewList: TfrNewList
  Left = 531
  Top = 217
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1087#1080#1089#1082#1072
  ClientHeight = 395
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 355
    Width = 386
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object SpeedButton3: TSpeedButton
      Left = 13
      Top = 7
      Width = 90
      Height = 25
      Caption = #1048#1084#1087#1086#1088#1090
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 104
      Top = 7
      Width = 90
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 283
      Top = 7
      Width = 90
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton5Click
    end
    object SpeedButton6: TSpeedButton
      Left = 194
      Top = 7
      Width = 90
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton6Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 386
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Label1: TLabel
      Left = 10
      Top = 7
      Width = 117
      Height = 16
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1087#1080#1089#1082#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
    end
    object Edit1: TEdit
      Left = 145
      Top = 5
      Width = 229
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'Edit1'
      StyleElements = []
    end
  end
  object Memo1: TMemo
    Left = 10
    Top = 30
    Width = 364
    Height = 325
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    StyleElements = []
  end
  object OpenDialog1: TOpenDialog
    Left = 320
    Top = 72
  end
end
