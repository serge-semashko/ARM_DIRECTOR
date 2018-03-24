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
<<<<<<< HEAD
=======
    object SpeedButton1: TSpeedButton
      Left = 16
      Top = 16
      Width = 33
      Height = 33
      OnClick = SpeedButton1Click
    end
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    object URLED: TEdit
      Left = 8
      Top = 64
      Width = 625
      Height = 24
      TabOrder = 0
<<<<<<< HEAD
      Text = 'http://127.0.0.1:9090'
    end
    object BitBtn1: TBitBtn
      Left = 8
      Top = 8
=======
      Text = 'http://nucloweb.jinr.ru/kgu/Cache/get_data.php?callback=?'
    end
    object BitBtn1: TBitBtn
      Left = 792
      Top = 24
>>>>>>> 567489eb579fa25cb906471546da671d36020444
      Width = 75
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 1
      OnClick = Panel1Click
    end
    object txt1: TStaticText
      Left = 160
      Top = 8
<<<<<<< HEAD
      Width = 449
=======
      Width = 529
>>>>>>> 567489eb579fa25cb906471546da671d36020444
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
<<<<<<< HEAD
    object webreqtxt: TStaticText
      Left = 640
      Top = 64
      Width = 61
      Height = 20
      Caption = 'webreqtxt'
      TabOrder = 4
    end
    object mmo1: TMemo
      Left = 720
      Top = 1
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
=======
>>>>>>> 567489eb579fa25cb906471546da671d36020444
  end
  object Memo2: TMemo
    Left = 0
    Top = 99
    Width = 1081
<<<<<<< HEAD
    Height = 157
=======
    Height = 91
>>>>>>> 567489eb579fa25cb906471546da671d36020444
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
<<<<<<< HEAD
    Top = 256
    Width = 1081
    Height = 433
=======
    Top = 190
    Width = 1081
    Height = 499
>>>>>>> 567489eb579fa25cb906471546da671d36020444
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Timer1: TTimer
<<<<<<< HEAD
    Interval = 300
    OnTimer = Timer1Timer
=======
    Enabled = False
    Interval = 50
    OnTimer = SpeedButton1Click
>>>>>>> 567489eb579fa25cb906471546da671d36020444
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
