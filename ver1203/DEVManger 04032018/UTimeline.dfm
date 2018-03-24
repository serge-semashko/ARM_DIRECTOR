object FEditTimeline: TFEditTimeline
  Left = 266
  Top = 235
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'FEditTimeline'
  ClientHeight = 338
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    StyleElements = []
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 123
      Height = 16
      Caption = #1058#1080#1087' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
    end
    object SpeedButton6: TSpeedButton
      Left = 390
      Top = 10
      Width = 209
      Height = 24
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
      Flat = True
      StyleElements = []
    end
    object ComboBox1: TComboBox
      Left = 143
      Top = 9
      Width = 125
      Height = 24
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Style = csDropDownList
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      OnChange = ComboBox1Change
      Items.Strings = (
        #1059#1089#1090#1088#1086#1081#1089#1090#1074#1072
        #1058#1077#1082#1089#1090
        #1052#1077#1076#1080#1072)
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 293
    Width = 628
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    StyleElements = []
    object SpeedButton1: TSpeedButton
      Left = 472
      Top = 8
      Width = 150
      Height = 30
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 315
      Top = 8
      Width = 150
      Height = 30
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton2Click
    end
    object Image2: TImage
      Left = 16
      Top = 12
      Width = 257
      Height = 30
      OnMouseUp = Image2MouseUp
    end
    object Label7: TLabel
      Left = 16
      Top = -2
      Width = 195
      Height = 13
      Caption = #1057#1080#1084#1074#1086#1083#1100#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080':'
      StyleElements = []
    end
  end
  object pnDevice: TPanel
    Left = 436
    Top = 56
    Width = 561
    Height = 233
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    StyleElements = []
    object Label2: TLabel
      Left = 5
      Top = 53
      Width = 69
      Height = 16
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
    end
    object Image1: TImage
      Left = 264
      Top = 0
      Width = 297
      Height = 233
      Align = alRight
      OnMouseUp = Image1MouseUp
    end
    object Label3: TLabel
      Left = 5
      Top = 84
      Width = 152
      Height = 16
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091#1089#1090#1088#1086#1081#1089#1090#1074':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
    end
    object Bevel1: TBevel
      Left = 0
      Top = 197
      Width = 257
      Height = 33
      Shape = bsFrame
      Style = bsRaised
    end
    object SpeedButton3: TSpeedButton
      Left = 55
      Top = 202
      Width = 65
      Height = 22
      Caption = '+ T'#1077#1082#1089#1090
      Flat = True
      StyleElements = []
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 122
      Top = 202
      Width = 65
      Height = 22
      Caption = '- '#1058#1077#1082#1089#1090
      Flat = True
      StyleElements = []
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 189
      Top = 202
      Width = 65
      Height = 22
      Caption = #1053#1086#1084#1077#1088#1072
      Flat = True
      StyleElements = []
      OnClick = SpeedButton5Click
    end
    object Edit1: TEdit
      Left = 99
      Top = 52
      Width = 162
      Height = 22
      BevelInner = bvNone
      BevelOuter = bvRaised
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = 'Edit1'
      StyleElements = []
    end
    object SpinEdit1: TSpinEdit
      Left = 199
      Top = 82
      Width = 60
      Height = 26
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 32
      MinValue = 1
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Value = 1
      OnChange = SpinEdit1Change
    end
    object Edit2: TEdit
      Left = 5
      Top = 204
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      StyleElements = []
    end
  end
  object pnDelete: TPanel
    Left = 296
    Top = 120
    Width = 329
    Height = 81
    BevelOuter = bvNone
    Caption = 'pnDelete'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    StyleElements = []
    object Label4: TLabel
      Left = 0
      Top = 0
      Width = 48
      Height = 16
      Align = alClient
      Alignment = taCenter
      Caption = 'Label4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
  end
  object pnText: TPanel
    Left = 13
    Top = 46
    Width = 493
    Height = 221
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    StyleElements = []
    object Label8: TLabel
      Left = 16
      Top = 73
      Width = 196
      Height = 13
      Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1089#1086#1073#1099#1090#1080#1103': '
      StyleElements = []
    end
    object Label9: TLabel
      Left = 16
      Top = 138
      Width = 71
      Height = 13
      Caption = #1062#1074#1077#1090' '#1089#1086#1073#1099#1090#1080#1103
      StyleElements = []
    end
    object Label10: TLabel
      Left = 357
      Top = 73
      Width = 36
      Height = 13
      Caption = #1082#1072#1076#1088#1086#1074
      StyleElements = []
    end
    object Label11: TLabel
      Left = 16
      Top = 106
      Width = 211
      Height = 13
      Caption = #1059#1089#1088#1077#1076#1085#1105#1085#1085#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1086#1076#1085#1086#1081' '#1073#1091#1082#1074#1099':'
      StyleElements = []
    end
    object Label12: TLabel
      Left = 16
      Top = 41
      Width = 53
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      StyleElements = []
    end
    object Label13: TLabel
      Left = 358
      Top = 106
      Width = 26
      Height = 13
      Caption = #1084#1089#1077#1082
      StyleElements = []
    end
    object Bevel2: TBevel
      Left = 280
      Top = 136
      Width = 73
      Height = 24
      Shape = bsFrame
    end
    object Image3: TImage
      Left = 282
      Top = 137
      Width = 67
      Height = 21
      OnClick = Image3Click
    end
    object sbTextEvent: TSpeedButton
      Left = 19
      Top = 174
      Width = 261
      Height = 24
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1089#1086#1073#1099#1090#1080#1103
      Flat = True
      StyleElements = []
    end
    object SpinEdit2: TSpinEdit
      Left = 280
      Top = 72
      Width = 73
      Height = 22
      MaxValue = 600
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object Edit3: TEdit
      Left = 280
      Top = 39
      Width = 247
      Height = 19
      TabOrder = 0
      Text = #1058#1077#1082#1089#1090
      StyleElements = []
    end
    object SpinEdit3: TSpinEdit
      Left = 280
      Top = 104
      Width = 73
      Height = 22
      Increment = 10
      MaxValue = 1000
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object pnMedia: TPanel
    Left = 333
    Top = 46
    Width = 501
    Height = 221
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    StyleElements = []
    object Label5: TLabel
      Left = 16
      Top = 65
      Width = 53
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077';'
      StyleElements = []
    end
    object Label6: TLabel
      Left = 16
      Top = 98
      Width = 89
      Height = 13
      Caption = #1062#1074#1077#1090' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080':'
      StyleElements = []
    end
    object Bevel3: TBevel
      Left = 197
      Top = 93
      Width = 77
      Height = 21
      Shape = bsFrame
    end
    object Image4: TImage
      Left = 202
      Top = 98
      Width = 59
      Height = 13
      OnClick = Image4Click
    end
    object SpeedButton7: TSpeedButton
      Left = 20
      Top = 124
      Width = 221
      Height = 25
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1089#1086#1073#1099#1090#1080#1103
      Flat = True
      StyleElements = []
    end
    object Edit4: TEdit
      Left = 196
      Top = 63
      Width = 300
      Height = 19
      TabOrder = 0
      Text = 'Media'
      StyleElements = []
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 392
    Top = 8
  end
end
