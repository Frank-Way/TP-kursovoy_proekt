object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = #1059#1095#1105#1090' '#1074#1082#1083#1072#1076#1086#1074
  ClientHeight = 681
  ClientWidth = 1264
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Consolas'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 24
  object Label1: TLabel
    Left = 24
    Top = 27
    Width = 156
    Height = 24
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083
  end
  object fileBox: TComboBox
    Left = 208
    Top = 24
    Width = 345
    Height = 32
    Style = csDropDownList
    TabOrder = 0
    OnChange = fileBoxChange
    Items.Strings = (
      #1054#1090#1076#1077#1083#1077#1085#1080#1103
      #1044#1086#1083#1078#1085#1086#1089#1090#1080
      #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      #1042#1080#1076#1099' '#1074#1082#1083#1072#1076#1086#1074
      #1042#1082#1083#1072#1076#1099
      #1050#1083#1080#1077#1085#1090#1099': '#1092#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      #1050#1083#1080#1077#1085#1090#1099': '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072)
  end
  object StrGrd: TStringGrid
    Left = 24
    Top = 88
    Width = 320
    Height = 569
    FixedColor = clBtnShadow
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goFixedColClick, goFixedRowClick]
    ScrollBars = ssVertical
    TabOrder = 1
    Visible = False
    OnFixedCellClick = StrGrdFixedCellClick
  end
  object MainMenu1: TMainMenu
    Left = 672
    Top = 8
    object File1: TMenuItem
      Caption = #1060#1072#1081#1083
      object Create1: TMenuItem
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        OnClick = Create1Click
      end
      object Read1: TMenuItem
        Caption = #1055#1088#1086#1089#1084#1086#1090#1088#1077#1090#1100
        OnClick = Read1Click
      end
      object Update1: TMenuItem
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        OnClick = Update1Click
      end
      object Delete1: TMenuItem
        Caption = #1059#1076#1072#1083#1080#1090#1100
        OnClick = Delete1Click
      end
    end
    object Consult1: TMenuItem
      Caption = #1055#1086#1076#1086#1073#1088#1072#1090#1100' '#1074#1080#1076' '#1074#1082#1083#1072#1076#1072
      OnClick = Consult1Click
    end
    object Exit1: TMenuItem
      Caption = #1042#1099#1081#1090#1080
      OnClick = Exit1Click
    end
  end
end
