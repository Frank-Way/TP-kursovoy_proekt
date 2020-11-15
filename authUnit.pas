{Форма для авторизации проверяет введённые логин и пароль. "Правильные" данные
хранятся в зашифрованном виде в INI-файле. Если введённые значения совпадают
с "правильными", то открывается основная форма. Если это первый запуск
приложения (отслеживается через INI-файл), то пользователю предлагается выбрать
директорию, где будут храниться файлы.}

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
  mainUnit, // основная форма
  IniFiles, // модуль для работы с INI-файлами
  globalObjects; // глобальные объекты

{$R *.dfm}



procedure TauthForm.cancelBtnClick(Sender: TObject);
{Закрытие формы закрывает всё приложение}
begin
  Application.Terminate;
end;

procedure TauthForm.confirmBtnClick(Sender: TObject);
{Кнопка "Подтвердить" проверяет ввод и, если он верный, открывает основную
форму}
var
  {Логины и пароли, соответственно, для администратора и рядового пользователя}
  adminLogin, adminPassword, userLogin, userPassword: ShortString;
  key: byte; // ключ для дешифрования логинов/паролей
begin
  {ключ считывается из INI-файла}
  key := IniFile.ReadInteger('Logins And Passwords','key',0);
  {оттуда же считываются "правильные" логины и пароли}
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
    admin := True;  // авторизировался Администратор
  {Если авторизировался администратор или пользователь}
  if admin or ((loginEdit.Text = UserLogin) and
               (passwordEdit.Text = UserPassword)) then
  begin
    Application.CreateForm(TmainForm, mainForm);
    authForm.Free;
  end
  else
    ShowMessage('Неверный логин и/или пароль');
end;

procedure TauthForm.FormShow(Sender: TObject);
{При отображении формы создаётся объект для INI-файла}
begin
  loginEdit.SetFocus;
  IniFile := TIniFile.Create('settings\config.ini');
end;

end.
