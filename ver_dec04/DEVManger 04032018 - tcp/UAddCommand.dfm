object FrAddCommand: TFrAddCommand
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1072#1085#1076#1091
  ClientHeight = 410
  ClientWidth = 325
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 120
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 340
    Width = 325
    Height = 70
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object Panel4: TPanel
      Left = 71
      Top = 1
      Width = 253
      Height = 68
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel4'
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object Label1: TLabel
        Left = 28
        Top = 6
        Width = 76
        Height = 13
        Caption = #1042#1088#1077#1084#1103' '#1089#1090#1072#1088#1090#1072': '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object BitBtn1: TBitBtn
        Left = 13
        Top = 33
        Width = 77
        Height = 25
        Caption = #1047#1072#1084#1077#1085#1080#1090#1100
        Default = True
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 0
      end
      object BitBtn2: TBitBtn
        Left = 171
        Top = 33
        Width = 77
        Height = 25
        ParentCustomHint = False
        Cancel = True
        Caption = #1042#1099#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 1
        OnClick = BitBtn2Click
      end
      object Edit1: TEdit
        Left = 134
        Top = 3
        Width = 89
        Height = 24
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '00:00:00:00'
        OnKeyDown = Edit1KeyDown
        OnKeyPress = Edit1KeyPress
        OnKeyUp = Edit1KeyUp
      end
      object BitBtn3: TBitBtn
        Left = 92
        Top = 33
        Width = 77
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 3
        OnClick = BitBtn3Click
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 325
    Height = 25
    Align = alTop
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Label2: TLabel
      Left = 7
      Top = 5
      Width = 3
      Height = 13
    end
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 24
      Height = 23
      Align = alLeft
      Center = True
      Picture.Data = {
        07544269746D6170F6000000424DF60000000000000076000000280000001000
        000010000000010004000000000080000000120B0000120B0000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FF0FFFFFFFFFFFFFF000FFFFFFFFFFFFF0000FFFFFFFFFFFFF0000FFFFFF
        FFFFFFF000000000FFFFFFFF0000888000FFFFFF0088FFF880FFFFFF08FFFFFF
        880FFFF088FFFFFFF880FFF08FFFFFFFFF80FFF088FFFFFFF880FFFF08FFFFFF
        880FFFFF008FFFF8800FFFFFF008888800FFFFFFFF0000000FFFFFFFFFFFFFFF
        FFFF}
      Transparent = True
    end
    object Edit2: TEdit
      Left = 25
      Top = 1
      Width = 299
      Height = 23
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitHeight = 24
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 25
    Width = 325
    Height = 315
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 2
    StyleElements = []
    object ListBox1: TListBox
      Left = 1
      Top = 1
      Width = 323
      Height = 313
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
    end
  end
end
