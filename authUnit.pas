{����� ��� ����������� ��������� �������� ����� � ������. "����������" ������
�������� � ������������� ���� � INI-�����. ���� �������� �������� ���������
� "�����������", �� ����������� �������� �����. ���� ��� ������ ������
���������� (������������� ����� INI-����), �� ������������ ������������ �������
����������, ��� ����� ��������� �����.}

unit authUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TauthForm = class(TForm)
    confirmBtn: TButton;
    cancelBtn: TButton;
    titleLabel: TLabel;
    loginEdit: TLabeledEdit;
    passwordEdit: TLabeledEdit;
    procedure cancelBtnClick(Sender: TObject);
    procedure confirmBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  authForm: TauthForm;

implementation

uses
  mainUnit, // �������� �����
  IniFiles, // ������ ��� ������ � INI-�������
  globalObjects; // ���������� �������

{$R *.dfm}



procedure TauthForm.cancelBtnClick(Sender: TObject);
{�������� ����� ��������� �� ����������}
begin
  Application.Terminate;
end;

procedure TauthForm.confirmBtnClick(Sender: TObject);
{������ "�����������" ��������� ���� �, ���� �� ������, ��������� ��������
�����}
var
  {������ � ������, ��������������, ��� �������������� � �������� ������������}
  adminLogin, adminPassword, userLogin, userPassword: ShortString;
  key: byte; // ���� ��� ������������ �������/�������
begin
  {���� ����������� �� INI-�����}
  key := IniFile.ReadInteger('Logins And Passwords','key',0);
  {������ �� ����������� "����������" ������ � ������}
  adminLogin := CryptString(IniFile.ReadString('Logins And Passwords',
    'adminLogin','None'), key);
  adminPassword := CryptString(IniFile.ReadString('Logins And Passwords',
    'adminPassword','None'), key);
  userLogin := CryptString(IniFile.ReadString('Logins And Passwords',
    'userLogin','None'), key);
  userPassword := CryptString(IniFile.ReadString('Logins And Passwords',
    'userPassword','None'), key);
  if (loginEdit.Text = AdminLogin) and (passwordEdit.Text = AdminPassword)
  then
    admin := True;  // ��������������� �������������
  {���� ��������������� ������������� ��� ������������}
  if admin or ((loginEdit.Text = UserLogin) and
               (passwordEdit.Text = UserPassword)) then
  begin
    Application.CreateForm(TmainForm, mainForm);
    authForm.Free;
  end
  else
    ShowMessage('�������� ����� �/��� ������');
end;

procedure TauthForm.FormShow(Sender: TObject);
{��� ����������� ����� �������� ������ ��� INI-�����}
begin
  loginEdit.SetFocus;
  IniFile := TIniFile.Create('settings\config.ini');
end;

end.
