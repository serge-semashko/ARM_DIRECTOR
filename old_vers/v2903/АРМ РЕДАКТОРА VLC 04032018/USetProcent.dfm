object frSetProcent: TfrSetProcent
  Left = 517
  Top = 234
  BorderStyle = bsNone
  BorderWidth = 2
  ClientHeight = 181
  ClientWidth = 112
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  StyleElements = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 112
    Height = 181
    Style = lbOwnerDrawFixed
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 25
    Items.Strings = (
      '         100%'
      '          50%'
      '          33%'
      '          25%'
      '          20%'
      '          14%'
      '          10%')
    ParentFont = False
    TabOrder = 0
    StyleElements = []
    OnClick = ListBox1Click
    OnKeyPress = ListBox1KeyPress
  end
end
