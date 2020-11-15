{Модуль с глобальными объектами: типы, переменные, процедуры и функции.}

unit globalObjects;

interface

uses
  IniFiles, // модуль для работы с INI-файлами
  System.Classes, // модуль с системными классами (TStrings, TFileStream и др.)
  Vcl.StdCtrls, // модуль с классом TComboBox
  Vcl.Grids, // модуль с классом TStringGrid
  SysUtils; // модуль с системными функциями (StrToFloat и тд).

const
  DefaultDirectoryName = 'files';  //имя папки с файлами по умолчанию

procedure FilterEdit(var Key: char; TypeOfOperation: char);
function CryptString(s: string; key: byte): string;
procedure reIndex(fileType: Byte);
function findIndex(fileType: byte; key: longword): boolean;
function findRecord(fileType: byte; key: longword): boolean;
procedure readRecord(fileType:Byte; pos: longword);
//function isStrInTStrings(str: ShortString; tStr: TStrings): boolean;
procedure file2Box(fileType: Byte; var CmbBx: TComboBox);
function loadNewID(fileType: Byte): LongWord;
procedure sortStrGrd(var StrGrd: TStringGrid; reverse: Boolean; col: Byte; dataType: Char);
function findIndexStr(fileType: byte; key: ShortString): boolean;
function findRecordStr(fileType: byte; key: ShortString): boolean;

type
  TPrivatePerson = record
  {физическое лицо}
    ID: Longword; // порядковый номер
    name: String[64]; // фио
    passport: String[10]; // паспорт
    phone: String[11]; // номер телефона
    adress: String[64]; // адрес
  end;
  TLegalPerson = record
  {юридическое лицо}
    ID: Longword; // порядковый номер
    name: String[64]; // название
    OGRN: String[13]; // ОГРН
    phone: String[11]; // контактный телефон
    adress: String[64]; // адрес
  end;
  TPosition = record
  {должность}
    ID: Word; // порядковый номер
    name: String[32]; // название
    salary: Real; // оклад
  end;
  TOffice = record
  {отделение}
    ID: Longword; // порядковый номер
    adress: String[86]; // адрес
  end;
  TEmployee = record
  {сотрудник}
    ID: Longword; // порядковый номер
    name: String[64]; // фио
    passport: String[10]; // паспорт
    office: Longword; // отделение, где работает сотрудник
    position: Word; // занимаемая должность
  end;
  TDeposite = record
  {вклад}
    ID: Longword; // порядковый номер
    client: Longword; // ID клиента
    typeOfDeposite: Word; // ID вида вклада
    employee: Longword;  // ID сотрудника
    openDate: TDate; // дата открытия вклада
    period: Byte; // срок вклада
    amount: Real; // внесённая сумма
  end;
  TTypeOfDeposite = record
  {Вид вклада}
    ID: Word; // порядковый номер
    name: String[32]; // название
    rate: Real; // процентная ставка
    minAmount: Real; // минимальная сумма
    minPeriod: Byte; // минимальный срок
  end;
  TIndex = record
  {индекс с целым числом}
    key: Longword; // ID
    ordNum: Longword; // порядковый номер в файле
  end;
  TIndexStr = record
  {индекс со строкой}
    key: String[13]; // паспорт или ОГРН
    ordNum: LongWord; // порядковый номер в файле
  end;

var
  {Глобальные переменные для хранения текущих значений записей}
  aPrivatePerson: TPrivatePerson;
  aLegalPerson: TLegalPerson;
  aPosition: TPosition;
  aOffice: TOffice;
  aEmployee: TEmployee;
  aDeposite: TDeposite;
  aTypeOfDeposite: TTypeOfDeposite;
  {Глобальные индексы}
  aIndex:TIndex;
  aIndexStr: TIndexStr;
  {Имена файлов}
  fileNameOffices, fileNamePositions, fileNameEmployees,
  fileNameTypesOfDeposites, fileNameDeposites, fileNamePrivatePersons,
  fileNameLegalPersons: ShortString;
  {Имена файлов индексов с целыми числами}
  fileNameIndexOffices, fileNameIndexPositions, fileNameIndexEmployees,
  fileNameIndexTypesOfDeposites, fileNameIndexDeposites,
  fileNameIndexPrivatePersons, fileNameIndexLegalPersons: ShortString;
  {Имена файлов с индексами со строками}
  fileNameIndexStrEmployees, fileNameIndexStrPrivatePersons,
  fileNameIndexStrLegalPersons: ShortString;

  admin: Boolean; // администратор ли авторизировался
  IniFile: TIniFile; // INI-файл

  {Имена файлов объединяются в массивы для выполнения однотипных операций}
  fileNameArr: array [0..6] of ShortString;
  fileNameIndexArr: array [0..6] of ShortString;
  fileNameIndexStrArr: array [0..6] of ShortString;
  {Массив указателей на переменные используется для выполнения однотипных
  операций}
  pArr: array [0..6] of Pointer = (@aOffice, @aPosition, @aEmployee,
  @aTypeOfDeposite, @aDeposite, @aPrivatePerson, @aLegalPerson);
  {Массив размеров переменных используется в операциях записи/чтения из файлов}
  sizeArr: array [0..6] of Word = (SizeOf(TOffice), SizeOf(TPosition),
  SizeOf(TEmployee), SizeOf(TTypeOfDeposite), SizeOf(TDeposite),
  SizeOf(TPrivatePerson), SizeOf(TLegalPerson));
  {Размеры индексов также используются при чтении/записи в файлы}
  sizeIndex: Byte = SizeOf(TIndex);
  sizeIndexStr: Byte = sizeOf(TIndexStr);
implementation

function findRecordStr(fileType: byte; key: ShortString): boolean;
{Функция ищет в файле указанного типа (fileType) запись по строковому полю
(паспорт/ОГРН) key. Если найдено, то возвращает ИСТИНА, иначе возвращает ЛОЖЬ.}
begin
  findRecordStr := false;
  {Поиск осуществляется в файле с индексами}
  if findIndexStr(fileType, key) then
  begin
    findRecordStr := true;
    {Вывод записей при просмотре/изменении/удалении на специальной форме
    производится по порядковому номеру из aIndex, поэтому здесь переопределяется
    его значение}
    aIndex.ordNum := aIndexStr.ordNum;
    readRecord(fileType, aIndexStr.ordNum); // чтение найденной записи из файла
  end;
end;

function findIndexStr(fileType: byte; key: ShortString): boolean;
{Функция ищет индекс со строкой key (паспорт/ОГРН) указанной сущности (fileType).
Если находит, возвращает ИСТИНА, иначе возвращает ЛОЖЬ. Метод поиска - бинарный.}
var
  stream: TFileStream; // файловый поток
  low, // нижняя граница поиска
  high, // верхняя граница поиска
  mid: LongWord; // середина интервала поиска
begin
  findIndexStr := false;
  {Открывается файл с индексами со строками}
  stream := TFileStream.Create(fileNameIndexStrArr[fileType], fmOpenRead);
  if stream.Size > 0 then  // файл не пуст
  begin
    {Сначала интервал поиска - весь файл}
    low := 0;
    high := (stream.Size div sizeIndexStr) - 1;
    while low <= high do
    begin
      mid := (low + high) div 2;
      {Считывается запись на позиции mid}
      stream.Seek(mid*sizeIndexStr, soFromBeginning);
      stream.ReadBuffer(aIndexStr, sizeIndexStr);
      if aIndexStr.key > key then
        high := mid - 1 // нижняя граница поиска "опускается"
      else
        if aIndexStr.key < key then
          low := mid + 1 // верхняя граница "поднимается"
        else
        begin
          {Поиск успешен}
          findIndexStr := true;
          break;
        end;
    end;
  end;
  stream.Free;
end;

procedure sortStrGrd(var StrGrd: TStringGrid; reverse: Boolean; col: Byte; dataType: Char);
{Процедура сортирует полученный StrGrd по столбцу col, в котором содержится
данные, определяемые dataType(f - число с плавающей точкой, 'i' - целое число,
's' - строка, 'd' - дата). Если reverse ИСТИНА, то StrGrd сортируется в обратном
порядке. Сортировка осуществляется челночным методом. Сортировка никак не
затрагивает сами файлы, изменения нигде не сохраняются.}
var
  str: ShortString; // строка для временного хранения значения при обмене
  i, j, k: LongWord; // итераторы
  {переменные для хранения сравниваемых значений}
  float1, float2: Real;
  int1, int2: LongWord;
  str1, str2: ShortString;
  date1, date2: TDate;
  swapRecs: boolean; // нужно ли менять местами строки StringGrid'а
begin
  for j := 1 to StrGrd.RowCount - 2 do
    for i := j downto 1 do
    begin
      case dataType of
        {Определение, нужно ли менять строки местами, в зависимости от типа данных}
        'f':begin
          float1 := StrToFloat(StrGrd.Cells[col, i]);
          float2 := StrToFloat(StrGrd.Cells[col, i+1]);
          if (float1>float2) and (not reverse) then
            swapRecs := true
          else if (float1<float2) and reverse then
            swapRecs := true
          else
            swapRecs := false;
        end;
        'i':begin
          int1 := StrToInt(StrGrd.Cells[col, i]);
          int2 := StrToInt(StrGrd.Cells[col, i+1]);
          if (int1>int2) and (not reverse) then
            swapRecs := true
          else if (int1<int2) and reverse then
            swapRecs := true
          else
            swapRecs := false;
        end;
        's':begin
          str1 := StrGrd.Cells[col, i];
          str2 := StrGrd.Cells[col, i+1];
          if (str1>str2) and (not reverse) then
            swapRecs := true
          else if (str1<str2) and reverse then
            swapRecs := true
          else
            swapRecs := false;
        end;
        'd':begin
          date1 := StrToDate(StrGrd.Cells[col, i]);
          date2 := StrToDate(StrGrd.Cells[col, i+1]);
          if (date1>date2) and (not reverse) then
            swapRecs := true
          else if (date1<date2) and reverse then
            swapRecs := true
          else
            swapRecs := false;
        end;
      end;
      if swapRecs then // строки нужно поменять местами
      begin
        for k := 0 to StrGrd.ColCount-1 do // цикл по столбцам
        begin
          // обмен с использованием временной третьей переменной str
          str := StrGrd.Cells[k, i+1];
          StrGrd.Cells[k, i+1] := StrGrd.Cells[k, i];
          StrGrd.Cells[k, i] := str;
        end;
      end;
      if not swapRecs then
      {Если обменов не было, то выход из цикла по i}
        break;
    end;
end;

function loadNewID(fileType: Byte): LongWord;
{Функция загружает новый ID для указанной сущности (fileType). Если файл с
индексами с ID не пустой, то функция считывает последний индекс и возвращает ID
последней записи, увеличенный на единицу. Таким образом, ID для одной сущности в
системе не могут повторяться.}
var
  stream: TFileStream; // файловый поток
begin
  {Открывается файл с индексами с ID}
  stream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenRead);
  if stream.Size = 0 then // если файл пуст
    loadNewID := 1
  else
  begin
    {Считывается последняя запись}
    stream.Seek(-sizeIndex, soFromEnd);
    stream.ReadBuffer(aIndex, sizeIndex);
    loadNewID := aIndex.key + 1;
  end;
  stream.Free
end;

procedure file2Box(fileType: Byte; var CmbBx: TComboBox);
{Процедура загружает значения всех ID указанной сущности (fileType) в элемент
типа TComboBox}
var
  stream: TFileStream; // файловый поток
begin
  {Открывается файл с индексами}
  stream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenRead);
  while stream.Position <> stream.Size do // пока не конец файла
  begin
    {Все индексы считываются и добавляются в ComboBox}
    stream.ReadBuffer(aIndex, sizeIndex);
    CmbBx.Items.Add(IntToStr(aIndex.key));
  end;
  stream.Free;
end;

//function isStrInTStrings(str: ShortString; tStr: TStrings): boolean;
//{Функция проверяет наличие str в tStr. Если есть, то возвращает ИСТИНА, иначе
//возвращает ЛОЖЬ}
//var
//  i: LongWord; // итератор
//begin
//  isStrInTStrings := false;
//  for i := 0 to tStr.Count do // перебор элементов tStr
//    if str = tStr.Strings[i] then // если есть совпадение
//    begin
//      isStrInTStrings := true;
//      break; // значение найдено, искать больше не надо
//    end;
//end;

procedure readRecord(fileType:Byte; pos: longword);
{Процедура считывает запись из файла fileType с позиции pos}
var
  stream: TFileStream; // файловый поток
begin
  {Открывается файл}
  stream := TFileStream.Create(fileNameArr[fileType], fmOpenRead);
  {Позиционирование на нужную запись}
  stream.Seek(pos*sizeArr[fileType], soFromBeginning);
  stream.ReadBuffer(pArr[fileType]^, sizeArr[fileType]); // чтение записи
  stream.Free;
end;

function findRecord(fileType: byte; key: longword): boolean;
{Функция ищет запись в файле fileType с ID, равным key. Суть аналогична функции
findIndexStr, только ищет индексы с целыми числами (ID)}
begin
  findRecord := false;
  if findIndex(fileType, key) then
  begin
    findRecord := true;
    readRecord(fileType, aIndex.ordNum);
  end;
end;

function findIndex(fileType: byte; key: longword): boolean;
{Функция ищет индекс. Аналогична функции findIndexStr, только работает с
индексами с целыми числами. Метод поиска - бинарный.}
var
  stream: TFileStream;
  low, high, mid: Longint;
begin
  findIndex := false;
  stream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenRead);
  if stream.Size > 0 then
  begin
    low := 0;
    high := (stream.Size div sizeIndex) - 1;
    while low <= high do
    begin
      mid := (low + high) div 2;
      stream.Seek(mid*sizeIndex, soFromBeginning);
      stream.ReadBuffer(aIndex, sizeIndex);
      if aIndex.key > key then
        high := mid - 1
      else
        if aIndex.key < key then
          low := mid + 1
        else
        begin
          findIndex := true;
          break;
        end;
    end;
  end;
  stream.Free;
end;

procedure reIndex(fileType: Byte);
{Процедура производит переиндексацию для указанного файла fileType. Для этого
сначала последовательно считываются записи из файла, в файл с индексами
заносятся соответствующие индексы (ключ и порядковый номер). После этого
файл с индексами сортируется. Метод сортировки - челночный. Переиндексируются
как ID, так и строковые поля паспорт/ОГРН (если они есть в указанном файле)}
var
  fileStream, indexStream, indexStrStream: TFileStream;
  ind1, ind2: TIndex; // индексы с числами (ID)
  indStr1, indStr2: TIndexStr; // индексы со строками (паспорт/ОГРН)
  i, j, k: longword; // счётчики
  flag, // были ли обмены при сортировке
  reindexStr: boolean; // нужно ли переиндексировать
begin
  {Проверка, нужно ли переиндексировать файлы с текстовыми полями}
  if (fileType = 2) or (fileType = 5) or (fileType = 6) then
    reindexStr := true
  else
    reindexStr := false;
  {Открываются файлы с записями и индексами ID}
  fileStream := TFileStream.Create(fileNameArr[fileType], fmOpenRead);
  indexStream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenWrite);
  indexStream.Size := 0; // файл с индексами очищается
  if reindexStr then // если нужно переиндексировать файлы с текстовыми полями
  begin // действия аналогичны индексам с числами
    indexStrStream := TFileStream.Create(fileNameIndexStrArr[fileType], fmOpenWrite);
    indexStrStream.Size := 0;
  end;
  k := 0; // порядковой номер записи в файле
  while fileStream.Position <> fileStream.Size do // пока не конец файла
  begin
    fileStream.ReadBuffer(pArr[fileType]^, sizeArr[fileType]); // чтение записи
    case fileType  of
      {В зависимости от файла формируется ключ индекса}
      0:aIndex.key := aOffice.ID;
      1:aIndex.key := aPosition.ID;
      2:begin
        aIndex.key := aEmployee.ID;
        aIndexStr.key := aEmployee.passport;
      end;
      3:aIndex.key := aTypeOfDeposite.ID;
      4:aIndex.key := aDeposite.ID;
      5:begin
        aIndex.key := aPrivatePerson.ID;
        aIndexStr.key := aPrivatePerson.passport;
      end;
      6:begin
        aIndex.key := aLegalPerson.ID;
        aIndexStr.key := aLegalPerson.OGRN;
      end;
    end;
    aIndex.ordNum := k; // порядковый номер запоминается в индекса
    indexStream.WriteBuffer(aIndex, sizeIndex); // индекс запоминается
    if reindexStr then
    begin
      aIndexStr.ordNum := k;
      indexStrStream.WriteBuffer(aIndexStr, sizeIndexStr);
    end;
    k := k + 1;
  end;
  indexStream.Free;
  fileStream.Free;
  {Сортировка файла с индексами с ID}
  indexStream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenReadWrite);
  if indexStream.Size > sizeIndex then // если в файле больше одного индекса
    for j := 0 to ((indexStream.Size div sizeIndex) - 2) do
      for i := j downto 0 do
      begin
        flag := False;
        indexStream.Seek(i*sizeIndex, soFromBeginning);
        {чтение i-го и (i+1)-го индексов}
        indexStream.ReadBuffer(ind1, sizeIndex);
        indexStream.ReadBuffer(ind2, sizeIndex);
        if ind1.key > ind2.key then
        begin // обмен
          flag := true;
          indexStream.Seek(i*sizeIndex, soFromBeginning);
          indexStream.WriteBuffer(ind2, sizeIndex);
          indexStream.WriteBuffer(ind1, sizeIndex);
        end;
        if not flag then //обменов не было
          break; // выход из цикла по i
      end;
  indexStream.Free;
  if reindexStr then // если надо переиндексировать индексы с текстовым полем
  begin // сортировка выполняется аналогично
    indexStrStream.Free;
    indexStrStream := TFileStream.Create(fileNameIndexStrArr[fileType], fmOpenReadWrite);
    if indexStrStream.Size > sizeIndexStr then
      for j := 0 to ((indexStrStream.Size div sizeIndexStr) - 2) do
        for i := j downto 0 do
        begin
          flag := False;
          indexStrStream.Seek(i*sizeIndexStr, soFromBeginning);
          indexStrStream.ReadBuffer(indStr1, sizeIndexStr);
          indexStrStream.ReadBuffer(indStr2, sizeIndexStr);
          if indStr1.key > indStr2.key then
          begin
            flag := true;
            indexStrStream.Seek(i*sizeIndexStr, soFromBeginning);
            indexStrStream.WriteBuffer(indStr2, sizeIndexStr);
            indexStrStream.WriteBuffer(indStr1, sizeIndexStr);
          end;
          if not flag then
            break;
        end;
    indexStrStream.Free;
  end;
end;

function CryptString(s: string; key: byte): string;
{Функция шифрует строку в соответствии с ключём. Для дешифрования необходимо
воспользоваться функцией с тем же ключём.}
  var
    i: word;
  begin
    for i := 1 to length(s) do
      s[i] := chr(ord(s[i]) xor key);
    CryptString := s;
  end;

procedure FilterEdit(var Key: char; TypeOfOperation: char);
{Фильтрация полей для ввода. TypeOfOperation: s-кириллица, n-цифры, r-цифры и
запятая}
  var
    cond: Boolean; // соответствует ли вводимый символ указанной операции
  begin
    case TypeOfOperation of
    's':  //если в Edit можно ввести только кирилицу
      begin
        cond := (Key in [' ', #8]) or ((ord(Key) >= 1040) and (ord(Key) <= 1103));
      end;
    'n':  //если в Edit можно ввести только цифры
      begin
        cond := Key in ['0'..'9', #8];
      end;
    'r':  //если в Edit можно ввести только цифры и десятичный разделитель
      begin
        cond := Key in ['0'..'9', #8, ','];
      end;
    end;
    if not cond then
      Key := #0;
  end;

end.
