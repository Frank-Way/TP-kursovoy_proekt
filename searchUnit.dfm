object searchForm: TsearchForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1080#1089#1082' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086#1081' '#1079#1072#1087#1080#1089#1080
  ClientHeight = 217
  ClientWidth = 713
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Consolas'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 24
  object fieldRBGroup: TRadioGroup
    Left = 8
    Top = 8
    Width = 305
    Height = 105
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1083#1077' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
    Items.Strings = (
      'ID')
    TabOrder = 0
    OnClick = fieldRBGroupClick
  end
  object inputEdit: TLabeledEdit
    Left = 319
    Top = 48
    Width = 362
    Height = 32
    EditLabel.Width = 108
    EditLabel.Height = 24
    EditLabel.Caption = 'ID '#1079#1072#1087#1080#1089#1080
    TabOrder = 1
    OnKeyPress = inputEditKeyPress
  end
  object searchBtn: TButton
    Left = 423
    Top = 128
    Width = 170
    Height = 41
    Caption = #1053#1072#1081#1090#1080
    TabOrder = 2
    OnClick = searchBtnClick
  end
end
