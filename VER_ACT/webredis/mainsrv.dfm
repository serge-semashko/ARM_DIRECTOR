object HTTPSRVForm: THTTPSRVForm
  Left = 327
  Top = 19
  Caption = 'WEB srv'
  ClientHeight = 689
  ClientWidth = 1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1081
    Height = 104
    Align = alTop
    TabOrder = 0
    OnClick = Panel1Click
    object URLED: TEdit
      Left = 8
      Top = 51
      Width = 625
      Height = 24
      TabOrder = 0
      Text = 'http://127.0.0.1:9090'
    end
    object BitBtn1: TBitBtn
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 1
      OnClick = Panel1Click
    end
    object txt1: TStaticText
      Left = 160
      Top = 8
      Width = 417
      Height = 21
      AutoSize = False
      BevelKind = bkSoft
      Caption = 'txt1'
      TabOrder = 2
    end
    object txt2: TStaticText
      Left = 159
      Top = 32
      Width = 528
      Height = 20
      AutoSize = False
      Caption = 'txt2'
      TabOrder = 3
    end
    object webreqtxt: TStaticText
      Left = 640
      Top = 64
      Width = 61
      Height = 20
      Caption = 'webreqtxt'
      TabOrder = 4
    end
    object mmo1: TMemo
      Left = 721
      Top = 0
      Width = 360
      Height = 97
      Alignment = taCenter
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -7
      Font.Name = 'Small Fonts'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object ext_tct: TCheckBox
      Left = 12
      Top = 80
      Width = 137
      Height = 17
      Caption = #1042#1085#1077#1096#1085#1080#1081' '#1090#1072#1081#1084#1082#1086#1076
      TabOrder = 6
      OnClick = ext_tctClick
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 104
    Width = 1081
    Height = 158
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 262
    Width = 1081
    Height = 427
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 368
    Top = 128
  end
  object PopupMenu2: TPopupMenu
    Left = 552
    Top = 24
    object Restore1: TMenuItem
      Caption = 'Restore'
      OnClick = Restore1Click
    end
    object Minimize1: TMenuItem
      Caption = 'Minimize'
      OnClick = Minimize1Click
    end
    object quit1: TMenuItem
      Caption = 'quit'
      OnClick = quit1Click
    end
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 432
    Top = 128
  end
end
