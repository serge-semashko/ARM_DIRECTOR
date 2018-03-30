object FDelGridRow: TFDelGridRow
  Left = 444
  Top = 195
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1059#1076#1072#1083#1080#1090#1100
  ClientHeight = 210
  ClientWidth = 549
  Color = clBackground
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
    Top = 169
    Width = 549
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clBackground
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object SpeedButton1: TSpeedButton
      Left = 400
      Top = 4
      Width = 140
      Height = 32
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
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
      Left = 256
      Top = 4
      Width = 140
      Height = 32
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
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
  end
  object pnChoiseDel: TPanel
    Left = 288
    Top = 104
    Width = 257
    Height = 59
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object RadioGroup1: TRadioGroup
      Left = 0
      Top = 0
      Width = 257
      Height = 59
      Align = alClient
      Color = clBackground
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Items.Strings = (
        #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1088#1086#1077#1082#1090
        #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1099
        #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1077#1082#1090#1099' '#1076#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1082#1086#1090#1086#1088#1099#1093' '#1084#1077#1085#1100#1096#1077' '#1079#1072#1076#1072#1085#1085#1086#1081
        #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1077#1082#1090#1099' '#1076#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1082#1086#1090#1086#1088#1099#1093' '#1084#1077#1085#1100#1096#1077' '#1079#1072#1076#1072#1085#1085#1086#1081' ')
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
    end
  end
  object pnDate: TPanel
    Left = 136
    Top = 16
    Width = 401
    Height = 145
    ShowCaption = False
    TabOrder = 2
    StyleElements = []
    OnResize = pnDateResize
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 102
      Height = 143
      Align = alLeft
      Alignment = taRightJustify
      Caption = #1042#1099#1073#1080#1088#1077#1090#1077' '#1076#1072#1090#1091':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
      ExplicitLeft = 7
      ExplicitHeight = 16
    end
    object DateTimePicker1: TDateTimePicker
      Left = 224
      Top = 72
      Width = 177
      Height = 24
      BevelInner = bvNone
      BevelOuter = bvNone
      BevelKind = bkTile
      CalColors.TextColor = clBlack
      Date = 42597.500822303240000000
      Time = 42597.500822303240000000
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      StyleElements = []
    end
  end
  object pnLabel: TPanel
    Left = -28
    Top = 131
    Width = 361
    Height = 97
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 3
    StyleElements = []
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 41
      Height = 16
      Align = alClient
      Alignment = taCenter
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
  end
  object pnList: TPanel
    Left = 16
    Top = 48
    Width = 281
    Height = 121
    BevelOuter = bvNone
    Caption = 'pnList'
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 4
    StyleElements = []
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 281
      Height = 31
      Align = alTop
      AutoSize = False
      Caption = '   '#1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077' c'#1083#1077#1076#1091#1102#1097#1080#1077' '#1079#1072#1087#1080#1089#1080' '#1085#1077' '#1073#1091#1076#1091#1090' '#1091#1076#1072#1083#1077#1085#1099':'
      Color = clBackground
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object Bevel1: TBevel
      Left = 0
      Top = 31
      Width = 281
      Height = 2
      Align = alTop
      Shape = bsBottomLine
      Style = bsRaised
    end
    object RichEdit1: TRichEdit
      Left = 0
      Top = 33
      Width = 281
      Height = 88
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBackground
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'RichEdit1')
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      Zoom = 100
    end
  end
end
