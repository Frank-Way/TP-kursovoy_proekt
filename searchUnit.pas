{Форма для поиска записей по ID или паспорту/ОГРН}

unit searchUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TsearchForm = class(TForm)
    fieldRBGroup: TRadioGroup;
    inputEdit: TLabeledEdit;
    searchBtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure inputEditKeyPress(Sender: TObject; var Key: Char);
    procedure fieldRBGroupClick(Sender: TObject);
    procedure searchBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  searchForm: TsearchForm;

implementation

{$R *.dfm}

uses
  mainUnit, // основная форма
  globalObjects, // глобальные объекты
  CRUDUnit; // форма модифицирования записей

procedure TsearchForm.FormClose(Sender: TObject; var Action: TCloseAction);
{Закрытие формы возвращает основную форму}
begin
  mainForm.Visible := true;
  searchForm.Free;
end;

procedure TsearchForm.FormShow(Sender: TObject);
{При отображении формы она форматируется нужным образом в зависимости от
выбранного файла и операции}
var
  inv: String; // префикс для отображения названия операции в заголовке формы
begin
  {При отображении выбирается первый элемент RadioGroup(ID), и элемент затем
  скрывается}
  fieldRBGroup.ItemIndex := 0;
  fieldRBGroup.Visible := false;
  case operationType of
    'r': inv := 'Просмотр';
    'u': inv := 'Изменение';
    'd': inv := 'Удаление';
  end;
  searchForm.Caption := inv + ' записи в файле';
  {Добавление второго элемента в RadioGroup}
  case fileType of
    2,5:begin
      fieldRBGroup.Visible := true;
      fieldRBGroup.Items.Add('Паспорт');
    end;
    6:begin
      fieldRBGroup.Visible := true;
      fieldRBGroup.Items.Add('ОГРН');
    end;
  end;
end;

procedure TsearchForm.inputEditKeyPress(Sender: TObject; var Key: Char);
{В inputEdit можно вводить только цифры}
begin
  FilterEdit(Key, 'n');
end;

procedure TsearchForm.searchBtnClick(Sender: TObject);
{Кнопка "Найти" ищет запись по введёному значению и, если был выбор, то по
выбранному полюы}
var
  num: LongWord; // ID
  str: ShortString; // паспорт или ОГРН
  flag, // правильно ли введны значения
  recordFound: Boolean; // найдена ли запись
begin
  flag := true;
  case fileType of
    {Если нужно найти сотрудника/физлицо по паспорту, то длина - 10 символов}
    2,5: if (fieldRBGroup.ItemIndex = 1) and (Length(inputEdit.Text) <> 10) then
      flag := false;
    {Если нужно найти организацию по ОГРН, то длина - 13 символов}
    6: if (fieldRBGroup.ItemIndex = 1) and (Length(inputEdit.Text) <> 13) then
      flag := false;
  end;
  if inputEdit.Text = '' then
    flag := false;
  if flag then // ввод "прошёл проверки"
  begin
    case fieldRBGroup.ItemIndex of
      0:begin // поиск по ID (число)
        num := StrToInt(inputEdit.Text);
        recordFound := findRecord(fileType, num);
      end;
      1:begin // поиск по паспорту/ОГРН (строка)
        str := inputEdit.Text;
        recordFound := findRecordStr(fileType, str)
      end;
    end;
    if recordFound then
    begin
      Application.CreateForm(TCRUDform, CRUDform);
      searchForm.Free;
    end
    else
      ShowMessage('Запись не найдена');
  end
  else
    ShowMessage('Не верно введено значение');
end;

procedure TsearchForm.fieldRBGroupClick(Sender: TObject);
{Клик по RadioGroup изменяет подпись к полю для ввода}
begin
  case fieldRBGroup.ItemIndex of
    0:inputEdit.EditLabel.Caption := 'ID записи';
    1:case fileType of
      2,5:inputEdit.EditLabel.Caption := 'Паспорт человека';
      6:inputEdit.EditLabel.Caption := 'ОГРН организации';
    end;
  end;
end;

end.
