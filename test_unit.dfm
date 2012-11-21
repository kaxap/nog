object Form1: TForm1
  Left = 192
  Top = 124
  Width = 1142
  Height = 656
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Chromium1: TChromium
    Left = 16
    Top = 16
    Width = 1033
    Height = 409
    DefaultUrl = 'I:\src\nog\template2\phrase.html'
    TabOrder = 0
    OnConsoleMessage = Chromium1ConsoleMessage
    Options = [coWebSecurityDisabled]
  end
  object RichEdit1: TRichEdit
    Left = 16
    Top = 440
    Width = 1041
    Height = 161
    TabOrder = 1
  end
end
