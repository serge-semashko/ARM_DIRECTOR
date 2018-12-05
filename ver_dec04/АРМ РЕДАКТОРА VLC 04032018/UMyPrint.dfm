object frMyPrint: TfrMyPrint
  Left = 332
  Top = 159
  BorderStyle = bsDialog
  Caption = #1055#1077#1095#1072#1090#1100
  ClientHeight = 734
  ClientWidth = 989
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 17
  object Panel2: TPanel
    Left = 489
    Top = 0
    Width = 500
    Height = 734
    Align = alClient
    BevelOuter = bvNone
    Color = clSilver
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object Panel1: TPanel
      Left = 48
      Top = 43
      Width = 425
      Height = 619
      BevelOuter = bvNone
      Caption = 'Panel1'
      Color = clGray
      ShowCaption = False
      TabOrder = 0
      StyleElements = [seFont, seClient]
    end
    object Panel3: TPanel
      Left = 38
      Top = 31
      Width = 427
      Height = 621
      BevelOuter = bvNone
      Color = clWhite
      ShowCaption = False
      TabOrder = 1
      StyleElements = [seFont, seClient]
      object Image3: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 621
        Align = alClient
        Proportional = True
        Stretch = True
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 693
      Width = 500
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 2
      StyleElements = [seFont, seClient]
      object Label7: TLabel
        Left = 120
        Top = 10
        Width = 132
        Height = 17
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1083#1080#1089#1090#1086#1074':'
        StyleElements = []
      end
      object Label8: TLabel
        Left = 280
        Top = 10
        Width = 49
        Height = 17
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        StyleElements = []
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 489
    Height = 734
    Align = alLeft
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Bevel2: TBevel
      Left = 21
      Top = 13
      Width = 117
      Height = 85
    end
    object SpeedButton2: TSpeedButton
      Left = 12
      Top = 188
      Width = 469
      Height = 30
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1077#1095#1072#1090#1080
      Flat = True
      StyleElements = []
      OnClick = SpeedButton2Click
    end
    object SpeedButton1: TSpeedButton
      Left = 22
      Top = 14
      Width = 115
      Height = 83
      Caption = #1055#1077#1095#1072#1090#1100
      Flat = True
      Glyph.Data = {
        A2070000424DA207000000000000360000002800000019000000190000000100
        1800000000006C07000000000000000000000000000000000000C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C30000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000C3C3C3C3C3C300C3C3
        C3C3C3C300000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000C3C3C3C3C3C300C3C3C3C3C3C3000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000000000C3C3C3C3C3C300C3C3C3C3C3C3000000FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000C3C3C3C3C3
        C300C3C3C3C3C3C3000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000C3C3C3C3C3C300C3C3C3C3C3C3000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF000000000000C3C3C3C3C3C300C3C3C3000000
        000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000
        0000C3C3C300C3C3C3000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000000000C3C3C300C3C3C3000000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000C3C3C300C3C3
        C3000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FFFFFFFFFFFFFF
        000000000000C3C3C300C3C3C3000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF000000000000C3C3C300C3C3C3000000FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C3C3C3C3C3
        C300C3C3C3000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3000000FFFFFFFFFFFFFFFFFF0000000000000000000000
        00000000000000FFFFFFFFFFFFFFFFFF000000C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3000000FFFFFFFFFFFFFFFFFF000000000000000000000000000000000000FF
        FFFFFFFFFFFFFFFF000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000FFFFFFFF
        FFFFFFFFFF000000000000000000000000000000000000FFFFFFFFFFFFFFFFFF
        000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C300}
      Layout = blGlyphTop
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 264
      Top = 16
      Width = 46
      Height = 17
      Caption = #1055#1077#1095#1072#1090#1100
      StyleElements = []
    end
    object Bevel1: TBevel
      Left = 152
      Top = 40
      Width = 321
      Height = 17
      Shape = bsTopLine
      Style = bsRaised
    end
    object Label2: TLabel
      Left = 168
      Top = 63
      Width = 40
      Height = 17
      Caption = #1050#1086#1087#1080#1080
      StyleElements = []
    end
    object SpinEdit1: TSpinEdit
      Left = 224
      Top = 61
      Width = 89
      Height = 27
      Ctl3D = False
      MaxValue = 100
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 0
      Value = 1
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 248
      Width = 473
      Height = 449
      Caption = #1044#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080':'
      TabOrder = 1
      StyleElements = []
      object Label3: TLabel
        Left = 8
        Top = 42
        Width = 154
        Height = 17
        Caption = #1058#1072#1081#1084'-'#1083#1080#1085#1080#1103' '#1091#1089#1090#1088#1086#1081#1089#1090#1074':'
        StyleElements = []
      end
      object Label4: TLabel
        Left = 8
        Top = 102
        Width = 114
        Height = 17
        Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1076#1083#1103':'
        StyleElements = []
      end
      object Label5: TLabel
        Left = 8
        Top = 164
        Width = 137
        Height = 17
        Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1085#1072' '#1087#1077#1095#1072#1090#1100':'
        StyleElements = []
      end
      object Label6: TLabel
        Left = 8
        Top = 230
        Width = 151
        Height = 17
        Caption = #1058#1077#1082#1089#1090#1086#1074#1072#1103' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1103':'
        StyleElements = []
      end
      object cbTexts: TComboBox
        Left = 10
        Top = 252
        Width = 454
        Height = 25
        BevelKind = bkFlat
        Style = csDropDownList
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        StyleElements = []
        OnChange = cbTextsChange
      end
      object cbDevices: TComboBox
        Left = 10
        Top = 61
        Width = 454
        Height = 25
        BevelKind = bkFlat
        Style = csDropDownList
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        StyleElements = []
        OnChange = cbDevicesChange
      end
      object cbTypePrint: TComboBox
        Left = 10
        Top = 122
        Width = 454
        Height = 25
        BevelKind = bkFlat
        Style = csDropDownList
        Ctl3D = False
        ItemIndex = 0
        ParentCtl3D = False
        TabOrder = 2
        Text = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1084#1099#1093' '#1091#1089#1090#1088#1086#1081#1089#1090#1074
        StyleElements = []
        OnChange = cbTypePrintChange
        Items.Strings = (
          #1048#1089#1087#1086#1083#1100#1079#1091#1077#1084#1099#1093' '#1091#1089#1090#1088#1086#1081#1089#1090#1074
          #1042#1089#1077#1093' '#1091#1089#1090#1088#1086#1081#1089#1090#1074
          #1059#1089#1090#1088#1086#1081#1089#1090#1074#1072' 1'
          #1059#1089#1090#1088#1086#1081#1089#1090#1074#1072' 2'
          #1059#1089#1090#1088#1086#1081#1089#1090#1074#1072' 3'
          #1059#1089#1090#1088#1086#1081#1089#1090#1074#1072' 4'
          #1059#1089#1090#1088#1086#1081#1089#1090#1074#1072' 5')
      end
      object cbDataPrint: TComboBox
        Left = 10
        Top = 184
        Width = 454
        Height = 25
        BevelKind = bkFlat
        Style = csDropDownList
        Ctl3D = False
        ItemIndex = 0
        ParentCtl3D = False
        TabOrder = 3
        Text = #1058#1077#1082#1089#1090' '#1080' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        StyleElements = []
        OnChange = cbDataPrintChange
        Items.Strings = (
          #1058#1077#1082#1089#1090' '#1080' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
          #1058#1077#1082#1089#1090' '#1080' '#1076#1072#1085#1085#1099#1077' '#1090#1077#1082#1089#1090#1086#1074#1086#1081' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080)
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 109
    Width = 474
    Height = 67
    Caption = #1055#1088#1080#1085#1090#1077#1088': '
    TabOrder = 2
    StyleElements = []
    object ComboBox1: TComboBox
      Left = 10
      Top = 25
      Width = 454
      Height = 25
      BevelKind = bkFlat
      Style = csDropDownList
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      StyleElements = []
      OnChange = ComboBox1Change
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofEnableSizing]
    Left = 424
    Top = 16
  end
end
