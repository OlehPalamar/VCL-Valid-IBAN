object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 246
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 523
    Height = 246
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1043#1077#1085#1077#1088#1072#1094#1110#1103' IBAN'
      object Label1: TLabel
        Left = 18
        Top = 16
        Width = 55
        Height = 13
        Caption = #1050#1086#1076' '#1082#1088#1072#1111#1085#1080
      end
      object Label5: TLabel
        Left = 18
        Top = 65
        Width = 28
        Height = 13
        Caption = #1052#1060#1054':'
      end
      object Label8: TLabel
        Left = 86
        Top = 65
        Width = 46
        Height = 13
        Caption = #1056#1072#1093#1091#1085#1086#1082':'
      end
      object Label9: TLabel
        Left = 18
        Top = 121
        Width = 137
        Height = 13
        Caption = #1055#1086#1074#1085#1080#1081' '#1077#1083#1077#1082#1090#1088#1086#1085#1085#1080#1081' IBAN:'
      end
      object Label10: TLabel
        Left = 18
        Top = 169
        Width = 84
        Height = 13
        Caption = 'IBAN '#1076#1083#1103' '#1076#1088#1091#1082#1091':'
      end
      object edtCountryCode: TEdit
        Left = 18
        Top = 35
        Width = 199
        Height = 21
        TabOrder = 0
        Text = 'UA'
      end
      object btnGenerateIBAN: TButton
        Left = 278
        Top = 79
        Width = 129
        Height = 25
        Caption = #1043#1077#1085#1077#1088#1091#1074#1072#1090#1080' IBAN'
        TabOrder = 1
        OnClick = btnGenerateIBANClick
      end
      object edtMFO: TEdit
        Left = 18
        Top = 81
        Width = 62
        Height = 21
        TabOrder = 2
        Text = '351005'
      end
      object edtAccount: TEdit
        Left = 86
        Top = 81
        Width = 186
        Height = 21
        TabOrder = 3
        Text = '26205806902935'
      end
      object edtIBANFullElect: TEdit
        Left = 18
        Top = 137
        Width = 295
        Height = 21
        TabOrder = 4
      end
      object edtIBANFullPrint: TEdit
        Left = 18
        Top = 185
        Width = 295
        Height = 21
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1077#1088#1077#1074#1110#1088#1082#1072' IBAN'
      ImageIndex = 1
      object Label4: TLabel
        Left = 27
        Top = 32
        Width = 28
        Height = 13
        Caption = 'IBAN:'
      end
      object btnValidate: TButton
        Left = 27
        Top = 87
        Width = 110
        Height = 25
        Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080' IBAN'
        TabOrder = 0
        OnClick = btnValidateClick
      end
      object edtIBAN_valid: TEdit
        Left = 27
        Top = 53
        Width = 295
        Height = 21
        TabOrder = 1
        Text = 'UA863510050000026205806902935'
      end
    end
  end
end
