unit mainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.Menus;

type
  TmainForm = class(TForm)
    fileBox: TComboBox;
    Label1: TLabel;
    StrGrd: TStringGrid;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Create1: TMenuItem;
    Read1: TMenuItem;
    Update1: TMenuItem;
    Delete1: TMenuItem;
    Exit1: TMenuItem;
    Consult1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fileBoxChange(Sender: TObject);
    procedure formatStrGrd();
    procedure fillStrGrd();
    procedure Exit1Click(Sender: TObject);
    procedure Create1Click(Sender: TObject);
    procedure Read1Click(Sender: TObject);
    procedure Update1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure openCRUDform(operation: Char);
    procedure Consult1Click(Sender: TObject);
    procedure StrGrdFixedCellClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;
  sorted: array [0..6] of boolean;

implementation

uses
  CRUDunit, globalObjects, consultUnit, FileCtrl, searchUnit;

{$R *.dfm}

procedure TmainForm.fillStrGrd();
var
  stream: TFileStream;
  i: Byte;
begin
  with StrGrd do
  begin
    stream := TFileStream.Create(fileNameIndexArr[fileBox.ItemIndex], fmOpenRead);
    if stream.Size > 0 then
    begin
      while stream.Position <> stream.Size do
      begin
        RowCount := RowCount + 1;
        stream.ReadBuffer(aIndex, sizeIndex);
        readRecord(fileBox.ItemIndex, aIndex.ordNum);
        case fileBox.ItemIndex of
          0:begin
            Cells[0,RowCount - 1] := IntToStr(aOffice.ID);
            Cells[1,RowCount - 1] := aOffice.adress;
          end;
          1:begin
            Cells[0,RowCount - 1] := IntToStr(aPosition.ID);
            Cells[1,RowCount - 1] := aPosition.name;
            Cells[2,RowCount - 1] := Format('%2g', [aPosition.salary]);
          end;
          2:begin
            Cells[0,RowCount - 1] := IntToStr(aEmployee.ID);
            Cells[1,RowCount - 1] := aEmployee.name;
            Cells[2,RowCount - 1] := aEmployee.passport;
            Cells[3,RowCount - 1] := IntToStr(aEmployee.office);
            Cells[4,RowCount - 1] := IntToStr(aEmployee.position);
          end;
          3:begin
            Cells[0,RowCount - 1] := IntToStr(aTypeOfDeposite.ID);
            Cells[1,RowCount - 1] := aTypeOfDeposite.name;
            Cells[2,RowCount - 1] := Format('%2g', [aTypeOfDeposite.rate]);
            Cells[3,RowCount - 1] := Format('%2g', [aTypeOfDeposite.minAmount]);
            Cells[4,RowCount - 1] := IntToStr(aTypeOfDeposite.minPeriod);
          end;
          4:begin
            Cells[0,RowCount - 1] := IntToStr(aDeposite.ID);
            Cells[4,RowCount - 1] := IntToStr(aDeposite.client);
            Cells[1,RowCount - 1] := IntToStr(aDeposite.typeOfDeposite);
            Cells[5,RowCount - 1] := IntToStr(aDeposite.employee);
            Cells[6,RowCount - 1] := DateToStr(aDeposite.openDate);
            Cells[3,RowCount - 1] := IntToStr(aDeposite.period);
            Cells[2,RowCount - 1] := Format('%2g', [aDeposite.amount]);
          end;
          5:begin
            Cells[0,RowCount - 1] := IntToStr(aPrivatePerson.ID);
            Cells[1,RowCount - 1] := aPrivatePerson.name;
            Cells[2,RowCount - 1] := aPrivatePerson.passport;
            Cells[3,RowCount - 1] := aPrivatePerson.phone;
            Cells[4,RowCount - 1] := aPrivatePerson.adress;
          end;
          6:begin
            Cells[0,RowCount - 1] := IntToStr(aLegalPerson.ID);
            Cells[1,RowCount - 1] := aLegalPerson.name;
            Cells[2,RowCount - 1] := aLegalPerson.OGRN;
            Cells[3,RowCount - 1] := aLegalPerson.phone;
            Cells[4,RowCount - 1] := aLegalPerson.adress;
          end;
        end;
      end;
      FixedRows := 1;
      for i := 0 to 6 do
        sorted[i] := false;
    end;
    stream.Free;
  end;
end;

procedure TmainForm.formatStrGrd();
var
  i: Byte;
begin
  with StrGrd do begin
    Visible := true;
    RowCount := 1;
    Width := 0;
    case fileBox.ItemIndex of
      0: begin // Отделения
        ColCount := 2;
        Cells[0,0] := 'ID';
        ColWidths[0] := 150;
        Cells[1,0] := 'Адрес';
        ColWidths[1] := 500;
      end;
      1: begin // Должности
        ColCount := 3;
        Cells[0,0] := 'ID';
        ColWidths[0] := 150;
        Cells[1,0] := 'Название';
        ColWidths[1] := 350;
        Cells[2,0] := 'Оклад, руб.';
        ColWidths[2] := 250;
      end;
      2: begin // Сотрудники
        ColCount := 5;
        Cells[0,0] := 'ID';
        ColWidths[0] := 150;
        Cells[1,0] := 'ФИО';
        ColWidths[1] := 350;
        Cells[2,0] := 'Паспорт';
        ColWidths[2] := 200;
        Cells[4,0] := 'Должность';
        ColWidths[4] := 300;
        Cells[3,0] := 'Отделение';
        ColWidths[3] := 150;
      end;
      3: begin // Виды вкладов
        ColCount := 5;
        Cells[0,0] := 'ID';
        ColWidths[0] := 150;
        Cells[1,0] := 'Название';
        ColWidths[1] := 350;
        Cells[2,0] := 'Ставка, %';
        ColWidths[2] := 150;
        Cells[3,0] := 'Мин. сумма, руб.';
        ColWidths[3] := 300;
        Cells[4,0] := 'Мин. срок, мес.';
        ColWidths[4] := 300;
      end;
      4: begin // Вклады
        ColCount := 7;
        Cells[0,0] := 'ID';
        ColWidths[0] := 150;
        Cells[1,0] := 'Вид вклада';
        ColWidths[1] := 200;
        Cells[2,0] := 'Внесено, руб.';
        ColWidths[2] := 250;
        Cells[3,0] := 'Срок, мес.';
        ColWidths[3] := 200;
        Cells[4,0] := 'Клиент';
        ColWidths[4] := 200;
        Cells[5,0] := 'Сотрудник';
        ColWidths[5] := 200;
        Cells[6,0] := 'Дата открытия';
        ColWidths[6] := 300;
      end;
      5: begin // Физические лица
        ColCount := 5;
        Cells[0,0] := 'ID';
        ColWidths[0] := 150;
        Cells[1,0] := 'ФИО';
        ColWidths[1] := 350;
        Cells[2,0] := 'Паспорт';
        ColWidths[2] := 200;
        Cells[3,0] := 'Номер телефона';
        ColWidths[3] := 300;
        Cells[4,0] := 'Адрес';
        ColWidths[4] := 500;
      end;
      6: begin // Юридические лица
        ColCount := 5;
        Cells[0,0] := 'ID';
        ColWidths[0] := 150;
        Cells[1,0] := 'Название';
        ColWidths[1] := 350;
        Cells[2,0] := 'ОГРН';
        ColWidths[2] := 200;
        Cells[3,0] := 'Номер телефона';
        ColWidths[3] := 300;
        Cells[4,0] := 'Адрес';
        ColWidths[4] := 500;
      end;
    end;
    for i := 0 to ColCount-1 do
      Width := Width + ColWidths[i];
    Width := Width + 30;
  end;
end;

procedure TmainForm.Consult1Click(Sender: TObject);
begin
  Application.CreateForm(TconsultForm, consultForm);
  consultForm.Visible := true;
  mainForm.Visible := false;
end;

procedure TmainForm.Create1Click(Sender: TObject);
begin
  openCRUDform('c');
end;

procedure TmainForm.Delete1Click(Sender: TObject);
begin
  openCRUDform('d');
end;

procedure TmainForm.Exit1Click(Sender: TObject);
begin
  Application.Terminate
end;

procedure TmainForm.fileBoxChange(Sender: TObject);
begin
  formatStrGrd();
  fillStrGrd();
end;

procedure TmainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate
end;

procedure TmainForm.FormCreate(Sender: TObject);
var
  result: Word;
  dir: String;
begin
//если первый запуск приложения
  if IniFile.ReadBool('FilePaths', 'FirstLaunch', False) then
  begin
  //задаём директорию по умолчанию
    dir := DefaultDirectoryName;
    result := MessageDlg(
      'Желаете ли Вы выбрать самостоятельно директорию для файлов?',
      mtConfirmation, [mbYes, mbNo], 0);
    //если пользователь желает выбрать директорию вручную
    if result = mrYes then
    begin
      {Если в появившемся диалоговом окне пользователь успешно выберет
      директорию, то её имя будет в переменной dir.}
      while not SelectDirectory('','C:\', dir) do
        ShowMessage('Каталог не выбран');
      ShowMessage('Успешно выбран каталог ' + dir);
    end
    else
      //есди пользователь не захочет вручную выбрать директори.
      if result = mrNo then
      begin
        if not DirectoryExists(DefaultDirectoryName) then
          MkDir(DefaultDirectoryName);
        ShowMessage('Выбран каталог по умолчанию');
      end
      //если нажат "крестик", приложение закроется
      else
        Application.Terminate;
    //формируем имена файлов в соответствии с директорией
    fileNamePrivatePersons := dir + '\f_pp';
    fileNameLegalPersons := dir + '\f_lp';
    fileNamePositions := dir + '\f_p';
    fileNameOffices := dir + '\f_o';
    fileNameEmployees := dir + '\f_e';
    fileNameDeposites := dir + '\f_d';
    fileNameTypesOfDeposites := dir + '\f_dt';

    fileNameIndexPrivatePersons := dir + '\fi_pp';
    fileNameIndexLegalPersons := dir + '\fi_lp';
    fileNameIndexPositions := dir + '\fi_p';
    fileNameIndexOffices := dir + '\fi_o';
    fileNameIndexEmployees := dir + '\fi_e';
    fileNameIndexDeposites := dir + '\fi_d';
    fileNameIndexTypesOfDeposites := dir + '\fi_dt';

    fileNameIndexStrEmployees := dir + '\fis_e';
    fileNameIndexStrPrivatePersons := dir + '\fis_pp';
    fileNameIndexStrLegalPersons := dir + '\fis_lp';

    //записываем имена в ini-файл
    IniFile.WriteString('FilePaths', 'fileNamePrivatePersons',
                         fileNamePrivatePersons);
    IniFile.WriteString('FilePaths', 'fileNameLegalPersons',
                         fileNameLegalPersons);
    IniFile.WriteString('FilePaths', 'fileNamePositions',
                         fileNamePositions);
    IniFile.WriteString('FilePaths', 'fileNameOffices',
                         fileNameOffices);
    IniFile.WriteString('FilePaths', 'fileNameEmployees',
                         fileNameEmployees);
    IniFile.WriteString('FilePaths', 'fileNameDeposites',
                         fileNameDeposites);
    IniFile.WriteString('FilePaths', 'fileNameTypesOfDeposites',
                         fileNameTypesOfDeposites);

    IniFile.WriteString('FilePaths', 'fileNameIndexPrivatePersons',
                         fileNameIndexPrivatePersons);
    IniFile.WriteString('FilePaths', 'fileNameIndexLegalPersons',
                          fileNameIndexLegalPersons);
    IniFile.WriteString('FilePaths', 'fileNameIndexPositions',
                          fileNameIndexPositions);
    IniFile.WriteString('FilePaths', 'fileNameIndexOffices',
                          fileNameIndexOffices);
    IniFile.WriteString('FilePaths', 'fileNameIndexEmployees',
                          fileNameIndexEmployees);
    IniFile.WriteString('FilePaths', 'fileNameIndexDeposites',
                          fileNameIndexDeposites);
    IniFile.WriteString('FilePaths', 'fileNameIndexTypesOfDeposites',
                          fileNameIndexTypesOfDeposites);

    IniFile.WriteString('FilePaths', 'fileNameIndexStrEmployees',
                          fileNameIndexStrEmployees);
    IniFile.WriteString('FilePaths', 'fileNameIndexStrPrivatePersons',
                          fileNameIndexStrPrivatePersons);
    IniFile.WriteString('FilePaths', 'fileNameIndexStrLegalPersons',
                          fileNameIndexStrLegalPersons);
    {Первый запуск прошёл, директории определены, поэтому в ini-файл пишем
    FirstLaunch=False.}
    IniFile.WriteBool('FilePaths', 'FirstLaunch', False);
  end
  //если запуск не первый
  else
  begin
    //считываем имена файлов из ini-файла
    fileNamePrivatePersons := IniFile.ReadString('FilePaths',
                                   'fileNamePrivatePersons','');
    fileNameLegalPersons := IniFile.ReadString('FilePaths',
                                   'fileNameLegalPersons','');
    fileNamePositions := IniFile.ReadString('FilePaths',
                                   'fileNamePositions','');
    fileNameOffices := IniFile.ReadString('FilePaths',
                                   'fileNameOffices','');
    fileNameEmployees := IniFile.ReadString('FilePaths',
                                   'fileNameEmployees','');
    fileNameDeposites := IniFile.ReadString('FilePaths',
                                   'fileNameDeposites','');
    fileNameTypesOfDeposites := IniFile.ReadString('FilePaths',
                                   'fileNameTypesOfDeposites','');

    fileNameIndexPrivatePersons := IniFile.ReadString('FilePaths',
                                   'fileNameIndexPrivatePersons','');
    fileNameIndexLegalPersons := IniFile.ReadString('FilePaths',
                                   'fileNameIndexLegalPersons','');
    fileNameIndexPositions := IniFile.ReadString('FilePaths',
                                   'fileNameIndexPositions','');
    fileNameIndexOffices := IniFile.ReadString('FilePaths',
                                   'fileNameIndexOffices','');
    fileNameIndexEmployees := IniFile.ReadString('FilePaths',
                                   'fileNameIndexEmployees','');
    fileNameIndexDeposites := IniFile.ReadString('FilePaths',
                                   'fileNameIndexDeposites','');
    fileNameIndexTypesOfDeposites := IniFile.ReadString('FilePaths',
                                   'fileNameIndexTypesOfDeposites','');

    fileNameIndexStrEmployees := IniFile.ReadString('FilePaths',
                                   'fileNameIndexStrEmployees','');
    fileNameIndexStrPrivatePersons := IniFile.ReadString('FilePaths',
                                   'fileNameIndexStrPrivatePersons','');
    fileNameIndexStrLegalPersons := IniFile.ReadString('FilePaths',
                                   'fileNameIndexStrLegalPersons','');
  end;
  if not fileExists(fileNamePrivatePersons) then
    FileClose(FileCreate(fileNamePrivatePersons));
  if not fileExists(fileNameLegalPersons) then
    FileClose(FileCreate(fileNameLegalPersons));
  if not fileExists(fileNamePositions) then
    FileClose(FileCreate(fileNamePositions));
  if not fileExists(fileNameOffices) then
    FileClose(FileCreate(fileNameOffices));
  if not fileExists(fileNameEmployees) then
    FileClose(FileCreate(fileNameEmployees));
  if not fileExists(fileNameDeposites) then
    FileClose(FileCreate(fileNameDeposites));
  if not fileExists(fileNameTypesOfDeposites) then
    FileClose(FileCreate(fileNameTypesOfDeposites));
  if not fileExists(fileNameIndexPrivatePersons) then
    FileClose(FileCreate(fileNameIndexPrivatePersons));
  if not fileExists(fileNameIndexLegalPersons) then
    FileClose(FileCreate(fileNameIndexLegalPersons));
  if not fileExists(fileNameIndexPositions) then
    FileClose(FileCreate(fileNameIndexPositions));
  if not fileExists(fileNameIndexOffices) then
    FileClose(FileCreate(fileNameIndexOffices));
  if not fileExists(fileNameIndexEmployees) then
    FileClose(FileCreate(fileNameIndexEmployees));
  if not fileExists(fileNameIndexDeposites) then
    FileClose(FileCreate(fileNameIndexDeposites));
  if not fileExists(fileNameIndexTypesOfDeposites) then
    FileClose(FileCreate(fileNameIndexTypesOfDeposites));
  if not fileExists(fileNameIndexStrEmployees) then
    FileClose(FileCreate(fileNameIndexStrEmployees));
  if not fileExists(fileNameIndexStrPrivatePersons) then
    FileClose(FileCreate(fileNameIndexStrPrivatePersons));
  if not fileExists(fileNameIndexStrLegalPersons) then
    FileClose(FileCreate(fileNameIndexStrLegalPersons));

  fileNameArr[0] := fileNameOffices;
  fileNameArr[1] := fileNamePositions;
  fileNameArr[2] := fileNameEmployees;
  fileNameArr[3] := fileNameTypesOfDeposites;
  fileNameArr[4] := fileNameDeposites;
  fileNameArr[5] := fileNamePrivatePersons;
  fileNameArr[6] := fileNameLegalPersons;

  fileNameIndexArr[0] := fileNameIndexOffices;
  fileNameIndexArr[1] := fileNameIndexPositions;
  fileNameIndexArr[2] := fileNameIndexEmployees;
  fileNameIndexArr[3] := fileNameIndexTypesOfDeposites;
  fileNameIndexArr[4] := fileNameIndexDeposites;
  fileNameIndexArr[5] := fileNameIndexPrivatePersons;
  fileNameIndexArr[6] := fileNameIndexLegalPersons;

  fileNameIndexStrArr[2] := fileNameIndexStrEmployees;
  fileNameIndexStrArr[5] := fileNameIndexStrPrivatePersons;
  fileNameIndexStrArr[6] := fileNameIndexStrLegalPersons;
end;

procedure TmainForm.Read1Click(Sender: TObject);
begin
  openCRUDform('r');
end;

procedure TmainForm.StrGrdFixedCellClick(Sender: TObject; ACol, ARow: Integer);
var
  reverse: boolean;
  dataType: Char;
begin
  if sorted[ACol] then
  begin
    reverse := true;
    sorted[ACol] := false;
  end
  else
  begin
    reverse := false;
    sorted[ACol] := true;
  end;
  case ACol of
    0:dataType := 'i';
    1:
      if fileBox.ItemIndex = 4 then
        dataType := 'i'
      else
        dataType := 's';
    2:
      case fileBox.ItemIndex of
        1,3,4:dataType := 'f';
        2,5,6:dataType := 's';
      end;
    3,4:
      case fileBox.ItemIndex of
        2,4:dataType := 'i';
        3: dataType := 'f';
        5,6:dataType := 's';
      end;
    5:dataType := 'i';
    6:dataType := 'd';
  end;
  sortStrGrd(StrGrd, reverse, ACol, dataType);
end;

procedure TmainForm.Update1Click(Sender: TObject);
begin
  openCRUDform('u');
end;

procedure TmainForm.openCRUDform(operation: Char);
begin
  if fileBox.ItemIndex > -1 then
  begin
    fileType := fileBox.ItemIndex;
    operationType := operation;
    if operation = 'c' then
      Application.CreateForm(TCRUDform, CRUDform)
    else
      Application.CreateForm(TsearchForm, searchForm);
    mainForm.Visible := false
  end
  else
    ShowMessage('Выберите файл');
end;

end.
