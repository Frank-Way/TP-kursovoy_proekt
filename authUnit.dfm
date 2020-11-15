object authForm: TauthForm
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 461
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Consolas'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 24
  object titleLabel: TLabel
    Left = 104
    Top = 24
    Width = 288
    Height = 48
    Caption = #1044#1083#1103' '#1087#1088#1086#1076#1086#1083#1078#1077#1085#1080#1103' '#1074#1074#1077#1076#1080#1090#1077'       '#1083#1086#1075#1080#1085' '#1080' '#1087#1072#1088#1086#1083#1100
    WordWrap = True
  end
  object confirmBtn: TButton
    Left = 26
    Top = 312
    Width = 150
    Height = 50
    Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100
    TabOrder = 0
    OnClick = confirmBtnClick
  end
  object cancelBtn: TButton
    Left = 296
    Top = 312
    Width = 150
    Height = 50
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = cancelBtnClick
  end
  object loginEdit: TLabeledEdit
    Left = 104
    Top = 132
    Width = 288
    Height = 32
    EditLabel.Width = 60
    EditLabel.Height = 24
    EditLabel.Caption = #1051#1086#1075#1080#1085
    TabOrder = 2
  end
  object passwordEdit: TLabeledEdit
    Left = 104
    Top = 232
    Width = 288
    Height = 32
    EditLabel.Width = 72
    EditLabel.Height = 24
    EditLabel.Caption = #1055#1072#1088#1086#1083#1100
    PasswordChar = '*'
    TabOrder = 3
  end
end
