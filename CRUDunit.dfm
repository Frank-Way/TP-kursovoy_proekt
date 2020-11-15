object CRUDform: TCRUDform
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1079#1072#1087#1080#1089#1103#1084#1080
  ClientHeight = 571
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Consolas'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 24
  object Label1: TLabel
    Left = 408
    Top = 392
    Width = 12
    Height = 24
    Visible = False
  end
  object Label2: TLabel
    Left = 408
    Top = 430
    Width = 12
    Height = 24
    Visible = False
  end
  object Label3: TLabel
    Left = 408
    Top = 468
    Width = 12
    Height = 24
    Visible = False
  end
  object Label4: TLabel
    Left = 408
    Top = 482
    Width = 12
    Height = 24
    Visible = False
  end
  object intEdit1: TLabeledEdit
    Left = 32
    Top = 24
    Width = 350
    Height = 32
    EditLabel.Width = 96
    EditLabel.Height = 24
    EditLabel.Caption = 'intEdit1'
    Enabled = False
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 0
    Visible = False
  end
  object stringEdit1: TLabeledEdit
    Left = 32
    Top = 80
    Width = 350
    Height = 32
    EditLabel.Width = 132
    EditLabel.Height = 24
    EditLabel.Caption = 'stringEdit1'
    TabOrder = 1
    Visible = False
    OnKeyPress = stringEdit1KeyPress
  end
  object realEdit1: TLabeledEdit
    Left = 32
    Top = 136
    Width = 350
    Height = 32
    EditLabel.Width = 108
    EditLabel.Height = 24
    EditLabel.Caption = 'realEdit1'
    TabOrder = 2
    Visible = False
    OnKeyPress = realEdit1KeyPress
  end
  object intEdit2: TLabeledEdit
    Left = 32
    Top = 192
    Width = 350
    Height = 32
    EditLabel.Width = 96
    EditLabel.Height = 24
    EditLabel.Caption = 'intEdit2'
    TabOrder = 3
    Visible = False
    OnKeyPress = intEdit2KeyPress
  end
  object stringEdit2: TLabeledEdit
    Left = 32
    Top = 248
    Width = 350
    Height = 32
    EditLabel.Width = 132
    EditLabel.Height = 24
    EditLabel.Caption = 'stringEdit2'
    TabOrder = 4
    Visible = False
  end
  object ComboBox1: TComboBox
    Left = 32
    Top = 405
    Width = 350
    Height = 32
    TabOrder = 5
    Visible = False
    OnKeyPress = intEdit2KeyPress
  end
  object ComboBox2: TComboBox
    Left = 32
    Top = 430
    Width = 350
    Height = 32
    TabOrder = 6
    Visible = False
    OnKeyPress = intEdit2KeyPress
  end
  object ComboBox3: TComboBox
    Left = 32
    Top = 468
    Width = 350
    Height = 32
    TabOrder = 7
    Visible = False
    OnKeyPress = intEdit2KeyPress
  end
  object DateTimePicker1: TDateTimePicker
    Left = 400
    Top = 465
    Width = 186
    Height = 32
    Date = 44129.000000000000000000
    Time = 0.880971377315290700
    TabOrder = 8
    Visible = False
  end
  object Button1: TButton
    Left = 32
    Top = 523
    Width = 200
    Height = 40
    TabOrder = 9
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 238
    Top = 523
    Width = 200
    Height = 40
    TabOrder = 10
    Visible = False
    OnClick = Button2Click
  end
  object intEdit3: TLabeledEdit
    Left = 32
    Top = 306
    Width = 350
    Height = 32
    EditLabel.Width = 96
    EditLabel.Height = 24
    EditLabel.Caption = 'intEdit3'
    TabOrder = 11
    Visible = False
    OnKeyPress = intEdit2KeyPress
  end
  object realEdit2: TLabeledEdit
    Left = 32
    Top = 367
    Width = 350
    Height = 32
    EditLabel.Width = 108
    EditLabel.Height = 24
    EditLabel.Caption = 'realEdit2'
    TabOrder = 12
    Visible = False
    OnKeyPress = realEdit1KeyPress
  end
end
