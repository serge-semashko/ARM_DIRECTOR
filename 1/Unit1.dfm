object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 293
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object TcpServer1: TTcpServer
    OnAccept = TcpServer1Accept
    Left = 112
    Top = 112
  end
  object TcpClient1: TTcpClient
    Left = 184
    Top = 120
  end
end
