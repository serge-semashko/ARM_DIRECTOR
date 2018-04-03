object frHotKeys: TfrHotKeys
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1087#1080#1089#1082#1072' '#1075#1086#1088#1103#1095#1080#1093' '#1082#1083#1072#1074#1080#1096
  ClientHeight = 562
  ClientWidth = 983
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 983
    Height = 31
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object Label6: TLabel
      Left = 187
      Top = 7
      Width = 120
      Height = 16
      Caption = #1054#1073#1098#1077#1082#1090' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103':'
    end
    object SpeedButton1: TSpeedButton
      Left = 1
      Top = 0
      Width = 30
      Height = 30
      Hint = #1057#1095#1080#1090#1072#1090#1100' '#1089#1087#1080#1089#1086#1082'  '#1080#1079' '#1092#1072#1081#1083#1072
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 35
      Top = 0
      Width = 30
      Height = 30
      Hint = #1047#1072#1087#1080#1089#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1074' '#1092#1072#1081#1083
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
        00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
        00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
        00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
        0003737FFFFFFFFF7F7330099999999900333777777777777733}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object Label8: TLabel
      Left = 637
      Top = 7
      Width = 96
      Height = 16
      Caption = #1042#1072#1088#1080#1072#1085#1090' '#1089#1087#1080#1089#1082#1072':'
    end
    object ComboBox1: TComboBox
      Left = 739
      Top = 3
      Width = 225
      Height = 22
      BevelInner = bvSpace
      BevelKind = bkSoft
      Style = csOwnerDrawFixed
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      OnChange = ComboBox1Change
    end
    object ComboBox2: TComboBox
      Left = 311
      Top = 3
      Width = 303
      Height = 22
      BevelInner = bvSpace
      BevelKind = bkSoft
      Style = csOwnerDrawFixed
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      StyleElements = []
      OnChange = ComboBox2Change
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 241
    Width = 983
    Height = 295
    Align = alBottom
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Panel4: TPanel
      Left = 738
      Top = 60
      Width = 244
      Height = 216
      Align = alRight
      Caption = 'Panel4'
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object Image2: TImage
        Left = 1
        Top = 1
        Width = 242
        Height = 214
        Align = alClient
        OnMouseMove = Image2MouseMove
        OnMouseUp = Image2MouseUp
        ExplicitLeft = 5
        ExplicitTop = 3
      end
    end
    object Panel5: TPanel
      Left = 1
      Top = 60
      Width = 737
      Height = 216
      Align = alClient
      Caption = 'Panel5'
      ShowCaption = False
      TabOrder = 1
      StyleElements = []
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 735
        Height = 214
        Align = alClient
        OnMouseMove = Image1MouseMove
        OnMouseUp = Image1MouseUp
        ExplicitLeft = -3
        ExplicitTop = 3
        ExplicitWidth = 725
      end
    end
    object Panel7: TPanel
      Left = 1
      Top = 1
      Width = 981
      Height = 59
      Align = alTop
      Caption = 'Panel7'
      ShowCaption = False
      TabOrder = 2
      StyleElements = []
      object Label1: TLabel
        Left = 28
        Top = 23
        Width = 238
        Height = 16
        Align = alCustom
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1054#1089#1085'. '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1072':   '#1058#1077#1082#1091#1097#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ='
      end
      object LbOsnCurr: TLabel
        Left = 269
        Top = 23
        Width = 172
        Height = 16
        AutoSize = False
        Caption = 'LbOsnCurr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 158
        Top = 40
        Width = 108
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1053#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ='
      end
      object lbOsnNew: TLabel
        Left = 269
        Top = 40
        Width = 172
        Height = 22
        AutoSize = False
        Caption = 'lbOsnNew'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 452
        Top = 23
        Width = 239
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1044#1086#1087'. '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1072':   '#1058#1077#1082#1091#1097#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ='
      end
      object Label2: TLabel
        Left = 583
        Top = 40
        Width = 108
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1053#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ='
      end
      object LbDopCurr: TLabel
        Left = 696
        Top = 23
        Width = 166
        Height = 16
        AutoSize = False
        Caption = 'LbDopCurr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LbDopNew: TLabel
        Left = 696
        Top = 40
        Width = 166
        Height = 16
        AutoSize = False
        Caption = 'LbDopNew'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 3
        Top = 2
        Width = 128
        Height = 16
        Caption = #1042#1099#1073#1088#1072#1085#1085#1086#1077' '#1076#1077#1081#1089#1090#1074#1080#1077':'
      end
      object LbAction: TLabel
        Left = 137
        Top = 2
        Width = 725
        Height = 16
        AutoSize = False
        Caption = 'LbAction'
      end
      object Bevel1: TBevel
        Left = 1
        Top = 17
        Width = 863
        Height = 6
        Shape = bsBottomLine
      end
      object Bevel2: TBevel
        Left = 443
        Top = 23
        Width = 6
        Height = 36
        Shape = bsLeftLine
      end
      object Bevel3: TBevel
        Left = 868
        Top = 0
        Width = 6
        Height = 59
        Shape = bsLeftLine
      end
      object SpeedButton6: TSpeedButton
        Left = 870
        Top = -1
        Width = 110
        Height = 59
        Caption = #1047#1072#1084#1077#1085#1080#1090#1100
        Flat = True
        OnClick = SpeedButton6Click
      end
    end
    object Panel8: TPanel
      Left = 1
      Top = 276
      Width = 981
      Height = 18
      Align = alBottom
      Caption = 'Panel8'
      ShowCaption = False
      TabOrder = 3
      StyleElements = []
      object Label7: TLabel
        Left = 1
        Top = 1
        Width = 979
        Height = 16
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'Label7'
        ExplicitTop = 16
        ExplicitWidth = 1001
        ExplicitHeight = 7
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 31
    Width = 983
    Height = 210
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 2
    StyleElements = []
    object StringGrid1: TStringGrid
      Left = 1
      Top = 1
      Width = 981
      Height = 208
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = False
      DefaultRowHeight = 22
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentCtl3D = False
      ScrollBars = ssNone
      TabOrder = 0
      OnDrawCell = StringGrid1DrawCell
      OnSelectCell = StringGrid1SelectCell
      OnTopLeftChanged = StringGrid1TopLeftChanged
      ColWidths = (
        64
        64
        64
        64
        64)
      RowHeights = (
        22
        22
        22
        22
        22)
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 536
    Width = 983
    Height = 26
    Align = alBottom
    Caption = 'Panel6'
    ShowCaption = False
    TabOrder = 3
    StyleElements = []
    object SpeedButton4: TSpeedButton
      Left = 718
      Top = 0
      Width = 120
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 844
      Top = 0
      Width = 120
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      OnClick = SpeedButton5Click
    end
    object SpeedButton7: TSpeedButton
      Left = 2
      Top = 0
      Width = 120
      Height = 25
      Caption = #1053#1072#1095'. '#1091#1089#1090#1072#1085#1086#1074#1082#1080
      Flat = True
      OnClick = SpeedButton7Click
    end
    object SpeedButton8: TSpeedButton
      Left = 121
      Top = 0
      Width = 121
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      Flat = True
      OnClick = SpeedButton8Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 520
    Top = 71
  end
  object SaveDialog1: TSaveDialog
    Left = 584
    Top = 87
  end
end
