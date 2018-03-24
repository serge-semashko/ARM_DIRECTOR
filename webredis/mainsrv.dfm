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
    Height = 99
    Align = alTop
    TabOrder = 0
    OnClick = Panel1Click
    object SpeedButton1: TSpeedButton
      Left = 16
      Top = 16
      Width = 33
      Height = 33
      OnClick = SpeedButton1Click
    end
    object URLED: TEdit
      Left = 8
      Top = 64
      Width = 625
      Height = 24
      TabOrder = 0
      Text = 'http://nucloweb.jinr.ru/kgu/Cache/get_data.php?callback=?'
    end
    object BitBtn1: TBitBtn
      Left = 792
      Top = 24
      Width = 75
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 1
      OnClick = Panel1Click
    end
    object txt1: TStaticText
      Left = 160
      Top = 8
      Width = 529
      Height = 35
      AutoSize = False
      BevelKind = bkSoft
      Caption = 'txt1'
      TabOrder = 2
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 99
    Width = 1081
    Height = 91
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
    Top = 190
    Width = 1081
    Height = 499
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = SpeedButton1Click
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
end
