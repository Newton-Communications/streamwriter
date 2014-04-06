object frmConfigureEncoder: TfrmConfigureEncoder
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configure encoder'
  ClientHeight = 137
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    000001002000000000000000000000000000000000000000000000000000FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006D6D6D63585858BF5151
    51BF52525263007D21EB037B1EFF00791504FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF006F6F6F296A6A6A0E7A7A7A02818181EABDBDBDFFB2B2
    B2FF5B5B5BEA01832BEB43A15FFF037921D400791906FFFFFF00FFFFFF00FFFF
    FF00FFFFFF008181819B6F6F6FFD646464E776767619229751FF1C914AFF168F
    44FF108B3BFF3A9F5EFF80C196FF46A362FF097724ED00791907FFFFFF00FFFF
    FF00A4A4A47BBCBCBCFFDEDEDEFFA6A6A6FF838383F4299B5BFF90CAA9FF8DC8
    A5FF8AC6A1FF88C59EFF6AB685FF82C297FF48A566FF077925EA00791B09FFFF
    FF00ABABAB7DA6A6A6FED5D5D5FFC5C5C5FFCBCBCBFF319F63FF94CDADFF6FBA
    8EFF6BB889FF66B685FF61B380FF67B582FF83C298FF3CA05CFF007F25F9FFFF
    FF00FFFFFF00ACACAC85C5C5C5FFC1C1C1FFC5C5C5FF37A36BFF96CEB0FF94CD
    ADFF91CBAAFF90CBA8FF74BC90FF8AC7A1FF46A568FF078735FB01832D01A3A3
    A3CD8F8F8FE3A0A0A0EECFCFCFFFC6C6C6FFCCCCCCFF3DA56FFF37A36DFC33A1
    67FC309D62FE55AF7CFF91CBAAFF4FAB74FF188E45FF585858E3535353CDBFBF
    BFFDE2E2E2FFD2D2D2FFC6C6C6FFCDCDCDFFB1B1B1FF93939344FFFFFF00FFFF
    FF00959595443AA068FF5AB381FF289857FFC0C0C0FFD2D2D2FF616161FDC4C4
    C4FDE9E9E9FFD6D6D6FFC9C9C9FFCECECEFFA5A5A5FF84848444FFFFFF00FFFF
    FF009A9A9A4440A470FF319F65FFBABABAFFC6C6C6FFDDDDDDFF6B6B6BFDC8C8
    C8CDC4C4C4E3C0C0C0EED8D8D8FFCDCDCDFFBCBCBCFF828282C6777777447E7E
    7E448F8F8FC6C3C3C3FFC2C2C2FFCDCDCDFF8C8C8CEE878787E3838383CDFFFF
    FF00FFFFFF00C5C5C585D4D4D4FFCCCCCCFFC9C9C9FFBABABAFF9C9C9CFFA1A1
    A1FFC2C2C2FFC6C6C6FFC1C1C1FFB7B7B7FF89898985FFFFFF00FFFFFF00FFFF
    FF00CACACA7DC4C4C4FEDCDCDCFFD4D4D4FFD9D9D9FFDBDBDBFFD6D6D6FFD4D4
    D4FFD9D9D9FFD2D2D2FFCBCBCBFFC8C8C8FF797979FE7171717DFFFFFF00FFFF
    FF00D0D0D07BDCDCDCFFEDEDEDFFDBDBDBFFC2C2C2F4BEBEBEFED6D6D6FFD4D4
    D4FFB0B0B0FEACACACF4CBCBCBFFE7E7E7FFB7B7B7FF8B8B8B7BFFFFFF00FFFF
    FF00FFFFFF00D1D1D19BCECECEFDCACACAE7C6C6C619C2C2C2E7DEDEDEFFDDDD
    DDFFB2B2B2E7B1B1B119ACACACE7A7A7A7FDA3A3A39BFFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00D1D1D129CECECE0ECBCBCB02C7C7C7EAE5E5E5FFE4E4
    E4FFACACACEAB6B6B602B2B2B20EADADAD29FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CBCBCB63C7C7C7BFC4C4
    C4BFBFBFBF63FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FE4F
    0000FC070000C4030000C0010000C0000000C00100000000000003C0000003C0
    000001800000C0030000C0030000C0030000C4230000FC3F0000FE7F0000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object optCBR: TRadioButton
    Left = 8
    Top = 4
    Width = 197
    Height = 21
    Caption = 'Use constant bitrate'
    TabOrder = 0
    OnClick = optCBRClick
  end
  object optVBR: TRadioButton
    Left = 8
    Top = 52
    Width = 197
    Height = 21
    Caption = 'Use variable bitrate'
    TabOrder = 1
    OnClick = optVBRClick
  end
  object lstCBR: TComboBox
    Left = 24
    Top = 28
    Width = 185
    Height = 21
    Style = csDropDownList
    TabOrder = 2
  end
  object lstVBR: TComboBox
    Left = 24
    Top = 76
    Width = 185
    Height = 21
    Style = csDropDownList
    TabOrder = 3
  end
  object pnlNav: TPanel
    Left = 0
    Top = 97
    Width = 213
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 4
    Padding.Top = 4
    Padding.Right = 4
    Padding.Bottom = 4
    TabOrder = 4
    ExplicitTop = 114
    object Bevel2: TBevel
      Left = 4
      Top = 4
      Width = 205
      Height = 5
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = -7
      ExplicitWidth = 396
    end
    object btnOK: TBitBtn
      Left = 112
      Top = 9
      Width = 97
      Height = 27
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
