object consultForm: TconsultForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1076#1073#1086#1088' '#1074#1080#1076#1072' '#1074#1082#1083#1072#1076#1072
  ClientHeight = 391
  ClientWidth = 1034
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Consolas'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 24
  object amountEdit: TLabeledEdit
    Left = 8
    Top = 32
    Width = 201
    Height = 32
    EditLabel.Width = 132
    EditLabel.Height = 24
    EditLabel.Caption = #1057#1091#1084#1084#1072', '#1088#1091#1073'.'
    TabOrder = 0
    OnKeyPress = amountEditKeyPress
  end
  object periodEdit: TLabeledEdit
    Left = 296
    Top = 32
    Width = 105
    Height = 32
    EditLabel.Width = 120
    EditLabel.Height = 24
    EditLabel.Caption = #1057#1088#1086#1082', '#1084#1077#1089'.'
    TabOrder = 1
    OnKeyPress = periodEditKeyPress
  end
  object Button1: TButton
    Left = 480
    Top = 28
    Width = 130
    Height = 40
    Caption = #1055#1086#1076#1086#1073#1088#1072#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 80
    Width = 320
    Height = 303
    TabOrder = 3
    Visible = False
  end
end
