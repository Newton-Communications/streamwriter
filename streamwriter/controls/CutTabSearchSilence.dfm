object frmCutTabSearchSilence: TfrmCutTabSearchSilence
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Silence settings'
  ClientHeight = 122
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000000000000000000000000000000000000000004646
    466F3E3E3EFF171717FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006969
    69FFC9C9C9FF959595FF161616FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006969
    69FFDEDEDEFF313131FF454545FF151515FFFFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00434343FF818181FF353535FF3E3E3EFF151515FFFFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00474747FF838383FF373737FF3F3F3FFF151515FFFFFFFF00FFFF
    FF00FFFFFF0000AFEF45FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00585858FF848484FF373737FF3F3F3FFF151515FFFFFF
    FF0000B3F13C00B1F1B7FFFFFF0000AFEF0600AFEF48FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF004E4E4EFF676767FF373737FF404040FF1616
    16FF00B5F19300B3F1FC00B3F13900B1F1CF00AFF169FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004E4E4EFF676767FF383838FF4242
    42FF4D4D4DFF4BCCF5FF19BDF2FF0DB7F2FF00B1F11EFFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF0019BFF31E13BDF3B14F4F4FFF676767FF8C8C
    8CFFA9A9A9FF4197B4FF77D9F8FF00B5F1FC00B5F1CC00B3F17FFFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001BC1F31517BFF3B74C4C4CFFCACA
    CAFFF7F7F7FFD3D3D3FF4BA1BFFF74D9F8FF00B5F1F300B5F138FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001FC1F57E51CFF6FF4FA5
    C2FFF8F8F8FFFEFEFEFF5AB0CDFF6AD6F7FF00B7F1D500B7F11FFFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF002DC5F5182BC3F5BD25C1F5FF4ECEF7FF83DD
    F8FF4EA4C2FF5BB1CFFF68BFDCFF41CAF6FF08BCF1FF00B9F197FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0029C3F57E5AD0
    F7FF6DD7F8FF7DDCF8FF4BCDF6FF11BDF3F60DBBF30CFFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF002FC5F5D22BC3
    F5B727C1F5B450CEF7FF1FC1F57519BFF3F015BDF35AFFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0033C5F51E33C5F56CFFFF
    FF002DC5F54B2BC3F5CFFFFFFF0021C1F5211DC1F366FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF0031C5F5092FC5F566FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009FFF
    00000FFF000007FF000083FF0000C1FF0000E0DF0000F0170000F8070000F803
    0000FC030000FE030000F8010000FF070000FE170000FFDF0000FFFF0000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label14: TLabel
    Left = 92
    Top = 28
    Width = 36
    Height = 13
    Caption = '(1-100)'
  end
  object Label12: TLabel
    Left = 8
    Top = 52
    Width = 31
    Height = 13
    Caption = 'lasting'
  end
  object Label13: TLabel
    Left = 132
    Top = 52
    Width = 59
    Height = 13
    Caption = 'ms (min. 20)'
  end
  object Label10: TLabel
    Left = 8
    Top = 8
    Width = 188
    Height = 13
    Caption = 'Silence is defined by volume lower than:'
  end
  object txtSilenceLevel: TEdit
    Left = 8
    Top = 24
    Width = 81
    Height = 21
    MaxLength = 3
    NumbersOnly = True
    TabOrder = 0
  end
  object txtSilenceLength: TEdit
    Left = 48
    Top = 48
    Width = 81
    Height = 21
    MaxLength = 4
    NumbersOnly = True
    TabOrder = 1
  end
  object pnlNav: TPanel
    Left = 0
    Top = 78
    Width = 253
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 4
    Padding.Top = 4
    Padding.Right = 4
    Padding.Bottom = 4
    TabOrder = 2
    object Bevel2: TBevel
      Left = 4
      Top = 4
      Width = 245
      Height = 5
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = -7
      ExplicitWidth = 396
    end
    object btnOK: TBitBtn
      Left = 152
      Top = 9
      Width = 97
      Height = 31
      Align = alRight
      Caption = '&OK'
      Default = True
      DoubleBuffered = False
      Layout = blGlyphRight
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
end
