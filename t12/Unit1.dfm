object Form1: TForm1
  Left = -741
  Top = 37
  Caption = 'Form1'
  ClientHeight = 852
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object mmo1: TMemo
    Left = 0
    Top = 153
    Width = 698
    Height = 699
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 698
    Height = 153
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object btn1: TButton
      Left = 10
      Top = 20
      Width = 129
      Height = 30
      Caption = 'Listen'
      TabOrder = 0
      OnClick = btn1Click
    end
    object grp1: TGroupBox
      Left = 148
      Top = 49
      Width = 218
      Height = 51
      Caption = #1040#1082#1090#1080#1074
      TabOrder = 1
      object rbClient: TRadioButton
        Left = 10
        Top = 20
        Width = 100
        Height = 21
        Caption = #1050#1083#1080#1077#1085#1090
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rbServer: TRadioButton
        Left = 108
        Top = 20
        Width = 80
        Height = 21
        Caption = #1057#1077#1088#1074#1077#1088
        TabOrder = 1
      end
    end
    object edt1: TEdit
      Left = 148
      Top = 20
      Width = 208
      Height = 24
      TabOrder = 2
      Text = '1001'
    end
    object btn4: TButton
      Left = 217
      Top = 108
      Width = 129
      Height = 31
      Caption = 'SendBuf'
      TabOrder = 3
      OnClick = btn4Click
    end
    object btn3: TButton
      Left = 59
      Top = 108
      Width = 129
      Height = 31
      Caption = 'Send'
      TabOrder = 4
      OnClick = btn3Click
    end
    object btn2: TButton
      Left = 10
      Top = 59
      Width = 129
      Height = 31
      Caption = 'Connect'
      TabOrder = 5
      OnClick = btn2Click
    end
  end
  object TcpServer1: TTcpServer
    Left = 392
    Top = 16
  end
  object TcpClient1: TTcpClient
    Left = 432
    Top = 88
  end
end
