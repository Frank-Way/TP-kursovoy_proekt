{������ � ����������� ���������: ����, ����������, ��������� � �������.}

unit globalObjects;

interface

uses
  IniFiles, // ������ ��� ������ � INI-�������
  System.Classes, // ������ � ���������� �������� (TStrings, TFileStream � ��.)
  Vcl.StdCtrls, // ������ � ������� TComboBox
  Vcl.Grids, // ������ � ������� TStringGrid
  SysUtils; // ������ � ���������� ��������� (StrToFloat � ��).

const
  DefaultDirectoryName = 'files';  //��� ����� � ������� �� ���������

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
  {���������� ����}
    ID: Longword; // ���������� �����
    name: String[64]; // ���
    passport: String[10]; // �������
    phone: String[11]; // ����� ��������
    adress: String[64]; // �����
  end;
  TLegalPerson = record
  {����������� ����}
    ID: Longword; // ���������� �����
    name: String[64]; // ��������
    OGRN: String[13]; // ����
    phone: String[11]; // ���������� �������
    adress: String[64]; // �����
  end;
  TPosition = record
  {���������}
    ID: Word; // ���������� �����
    name: String[32]; // ��������
    salary: Real; // �����
  end;
  TOffice = record
  {���������}
    ID: Longword; // ���������� �����
    adress: String[86]; // �����
  end;
  TEmployee = record
  {���������}
    ID: Longword; // ���������� �����
    name: String[64]; // ���
    passport: String[10]; // �������
    office: Longword; // ���������, ��� �������� ���������
    position: Word; // ���������� ���������
  end;
  TDeposite = record
  {�����}
    ID: Longword; // ���������� �����
    client: Longword; // ID �������
    typeOfDeposite: Word; // ID ���� ������
    employee: Longword;  // ID ����������
    openDate: TDate; // ���� �������� ������
    period: Byte; // ���� ������
    amount: Real; // �������� �����
  end;
  TTypeOfDeposite = record
  {��� ������}
    ID: Word; // ���������� �����
    name: String[32]; // ��������
    rate: Real; // ���������� ������
    minAmount: Real; // ����������� �����
    minPeriod: Byte; // ����������� ����
  end;
  TIndex = record
  {������ � ����� ������}
    key: Longword; // ID
    ordNum: Longword; // ���������� ����� � �����
  end;
  TIndexStr = record
  {������ �� �������}
    key: String[13]; // ������� ��� ����
    ordNum: LongWord; // ���������� ����� � �����
  end;

var
  {���������� ���������� ��� �������� ������� �������� �������}
  aPrivatePerson: TPrivatePerson;
  aLegalPerson: TLegalPerson;
  aPosition: TPosition;
  aOffice: TOffice;
  aEmployee: TEmployee;
  aDeposite: TDeposite;
  aTypeOfDeposite: TTypeOfDeposite;
  {���������� �������}
  aIndex:TIndex;
  aIndexStr: TIndexStr;
  {����� ������}
  fileNameOffices, fileNamePositions, fileNameEmployees,
  fileNameTypesOfDeposites, fileNameDeposites, fileNamePrivatePersons,
  fileNameLegalPersons: ShortString;
  {����� ������ �������� � ������ �������}
  fileNameIndexOffices, fileNameIndexPositions, fileNameIndexEmployees,
  fileNameIndexTypesOfDeposites, fileNameIndexDeposites,
  fileNameIndexPrivatePersons, fileNameIndexLegalPersons: ShortString;
  {����� ������ � ��������� �� ��������}
  fileNameIndexStrEmployees, fileNameIndexStrPrivatePersons,
  fileNameIndexStrLegalPersons: ShortString;

  admin: Boolean; // ������������� �� ���������������
  IniFile: TIniFile; // INI-����

  {����� ������ ������������ � ������� ��� ���������� ���������� ��������}
  fileNameArr: array [0..6] of ShortString;
  fileNameIndexArr: array [0..6] of ShortString;
  fileNameIndexStrArr: array [0..6] of ShortString;
  {������ ���������� �� ���������� ������������ ��� ���������� ����������
  ��������}
  pArr: array [0..6] of Pointer = (@aOffice, @aPosition, @aEmployee,
  @aTypeOfDeposite, @aDeposite, @aPrivatePerson, @aLegalPerson);
  {������ �������� ���������� ������������ � ��������� ������/������ �� ������}
  sizeArr: array [0..6] of Word = (SizeOf(TOffice), SizeOf(TPosition),
  SizeOf(TEmployee), SizeOf(TTypeOfDeposite), SizeOf(TDeposite),
  SizeOf(TPrivatePerson), SizeOf(TLegalPerson));
  {������� �������� ����� ������������ ��� ������/������ � �����}
  sizeIndex: Byte = SizeOf(TIndex);
  sizeIndexStr: Byte = sizeOf(TIndexStr);
implementation

function findRecordStr(fileType: byte; key: ShortString): boolean;
{������� ���� � ����� ���������� ���� (fileType) ������ �� ���������� ����
(�������/����) key. ���� �������, �� ���������� ������, ����� ���������� ����.}
begin
  findRecordStr := false;
  {����� �������������� � ����� � ���������}
  if findIndexStr(fileType, key) then
  begin
    findRecordStr := true;
    {����� ������� ��� ���������/���������/�������� �� ����������� �����
    ������������ �� ����������� ������ �� aIndex, ������� ����� ����������������
    ��� ��������}
    aIndex.ordNum := aIndexStr.ordNum;
    readRecord(fileType, aIndexStr.ordNum); // ������ ��������� ������ �� �����
  end;
end;

function findIndexStr(fileType: byte; key: ShortString): boolean;
{������� ���� ������ �� ������� key (�������/����) ��������� �������� (fileType).
���� �������, ���������� ������, ����� ���������� ����. ����� ������ - ��������.}
var
  stream: TFileStream; // �������� �����
  low, // ������ ������� ������
  high, // ������� ������� ������
  mid: LongWord; // �������� ��������� ������
begin
  findIndexStr := false;
  {����������� ���� � ��������� �� ��������}
  stream := TFileStream.Create(fileNameIndexStrArr[fileType], fmOpenRead);
  if stream.Size > 0 then  // ���� �� ����
  begin
    {������� �������� ������ - ���� ����}
    low := 0;
    high := (stream.Size div sizeIndexStr) - 1;
    while low <= high do
    begin
      mid := (low + high) div 2;
      {����������� ������ �� ������� mid}
      stream.Seek(mid*sizeIndexStr, soFromBeginning);
      stream.ReadBuffer(aIndexStr, sizeIndexStr);
      if aIndexStr.key > key then
        high := mid - 1 // ������ ������� ������ "����������"
      else
        if aIndexStr.key < key then
          low := mid + 1 // ������� ������� "�����������"
        else
        begin
          {����� �������}
          findIndexStr := true;
          break;
        end;
    end;
  end;
  stream.Free;
end;

procedure sortStrGrd(var StrGrd: TStringGrid; reverse: Boolean; col: Byte; dataType: Char);
{��������� ��������� ���������� StrGrd �� ������� col, � ������� ����������
������, ������������ dataType(f - ����� � ��������� ������, 'i' - ����� �����,
's' - ������, 'd' - ����). ���� reverse ������, �� StrGrd ����������� � ��������
�������. ���������� �������������� ��������� �������. ���������� ����� ��
����������� ���� �����, ��������� ����� �� �����������.}
var
  str: ShortString; // ������ ��� ���������� �������� �������� ��� ������
  i, j, k: LongWord; // ���������
  {���������� ��� �������� ������������ ��������}
  float1, float2: Real;
  int1, int2: LongWord;
  str1, str2: ShortString;
  date1, date2: TDate;
  swapRecs: boolean; // ����� �� ������ ������� ������ StringGrid'�
begin
  for j := 1 to StrGrd.RowCount - 2 do
    for i := j downto 1 do
    begin
      case dataType of
        {�����������, ����� �� ������ ������ �������, � ����������� �� ���� ������}
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
      if swapRecs then // ������ ����� �������� �������
      begin
        for k := 0 to StrGrd.ColCount-1 do // ���� �� ��������
        begin
          // ����� � �������������� ��������� ������� ���������� str
          str := StrGrd.Cells[k, i+1];
          StrGrd.Cells[k, i+1] := StrGrd.Cells[k, i];
          StrGrd.Cells[k, i] := str;
        end;
      end;
      if not swapRecs then
      {���� ������� �� ����, �� ����� �� ����� �� i}
        break;
    end;
end;

function loadNewID(fileType: Byte): LongWord;
{������� ��������� ����� ID ��� ��������� �������� (fileType). ���� ���� �
��������� � ID �� ������, �� ������� ��������� ��������� ������ � ���������� ID
��������� ������, ����������� �� �������. ����� �������, ID ��� ����� �������� �
������� �� ����� �����������.}
var
  stream: TFileStream; // �������� �����
begin
  {����������� ���� � ��������� � ID}
  stream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenRead);
  if stream.Size = 0 then // ���� ���� ����
    loadNewID := 1
  else
  begin
    {����������� ��������� ������}
    stream.Seek(-sizeIndex, soFromEnd);
    stream.ReadBuffer(aIndex, sizeIndex);
    loadNewID := aIndex.key + 1;
  end;
  stream.Free
end;

procedure file2Box(fileType: Byte; var CmbBx: TComboBox);
{��������� ��������� �������� ���� ID ��������� �������� (fileType) � �������
���� TComboBox}
var
  stream: TFileStream; // �������� �����
begin
  {����������� ���� � ���������}
  stream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenRead);
  while stream.Position <> stream.Size do // ���� �� ����� �����
  begin
    {��� ������� ����������� � ����������� � ComboBox}
    stream.ReadBuffer(aIndex, sizeIndex);
    CmbBx.Items.Add(IntToStr(aIndex.key));
  end;
  stream.Free;
end;

//function isStrInTStrings(str: ShortString; tStr: TStrings): boolean;
//{������� ��������� ������� str � tStr. ���� ����, �� ���������� ������, �����
//���������� ����}
//var
//  i: LongWord; // ��������
//begin
//  isStrInTStrings := false;
//  for i := 0 to tStr.Count do // ������� ��������� tStr
//    if str = tStr.Strings[i] then // ���� ���� ����������
//    begin
//      isStrInTStrings := true;
//      break; // �������� �������, ������ ������ �� ����
//    end;
//end;

procedure readRecord(fileType:Byte; pos: longword);
{��������� ��������� ������ �� ����� fileType � ������� pos}
var
  stream: TFileStream; // �������� �����
begin
  {����������� ����}
  stream := TFileStream.Create(fileNameArr[fileType], fmOpenRead);
  {���������������� �� ������ ������}
  stream.Seek(pos*sizeArr[fileType], soFromBeginning);
  stream.ReadBuffer(pArr[fileType]^, sizeArr[fileType]); // ������ ������
  stream.Free;
end;

function findRecord(fileType: byte; key: longword): boolean;
{������� ���� ������ � ����� fileType � ID, ������ key. ���� ���������� �������
findIndexStr, ������ ���� ������� � ������ ������� (ID)}
begin
  findRecord := false;
  if findIndex(fileType, key) then
  begin
    findRecord := true;
    readRecord(fileType, aIndex.ordNum);
  end;
end;

function findIndex(fileType: byte; key: longword): boolean;
{������� ���� ������. ���������� ������� findIndexStr, ������ �������� �
��������� � ������ �������. ����� ������ - ��������.}
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
{��������� ���������� �������������� ��� ���������� ����� fileType. ��� �����
������� ��������������� ����������� ������ �� �����, � ���� � ���������
��������� ��������������� ������� (���� � ���������� �����). ����� �����
���� � ��������� �����������. ����� ���������� - ���������. �����������������
��� ID, ��� � ��������� ���� �������/���� (���� ��� ���� � ��������� �����)}
var
  fileStream, indexStream, indexStrStream: TFileStream;
  ind1, ind2: TIndex; // ������� � ������� (ID)
  indStr1, indStr2: TIndexStr; // ������� �� �������� (�������/����)
  i, j, k: longword; // ��������
  flag, // ���� �� ������ ��� ����������
  reindexStr: boolean; // ����� �� �����������������
begin
  {��������, ����� �� ����������������� ����� � ���������� ������}
  if (fileType = 2) or (fileType = 5) or (fileType = 6) then
    reindexStr := true
  else
    reindexStr := false;
  {����������� ����� � �������� � ��������� ID}
  fileStream := TFileStream.Create(fileNameArr[fileType], fmOpenRead);
  indexStream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenWrite);
  indexStream.Size := 0; // ���� � ��������� ���������
  if reindexStr then // ���� ����� ����������������� ����� � ���������� ������
  begin // �������� ���������� �������� � �������
    indexStrStream := TFileStream.Create(fileNameIndexStrArr[fileType], fmOpenWrite);
    indexStrStream.Size := 0;
  end;
  k := 0; // ���������� ����� ������ � �����
  while fileStream.Position <> fileStream.Size do // ���� �� ����� �����
  begin
    fileStream.ReadBuffer(pArr[fileType]^, sizeArr[fileType]); // ������ ������
    case fileType  of
      {� ����������� �� ����� ����������� ���� �������}
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
    aIndex.ordNum := k; // ���������� ����� ������������ � �������
    indexStream.WriteBuffer(aIndex, sizeIndex); // ������ ������������
    if reindexStr then
    begin
      aIndexStr.ordNum := k;
      indexStrStream.WriteBuffer(aIndexStr, sizeIndexStr);
    end;
    k := k + 1;
  end;
  indexStream.Free;
  fileStream.Free;
  {���������� ����� � ��������� � ID}
  indexStream := TFileStream.Create(fileNameIndexArr[fileType], fmOpenReadWrite);
  if indexStream.Size > sizeIndex then // ���� � ����� ������ ������ �������
    for j := 0 to ((indexStream.Size div sizeIndex) - 2) do
      for i := j downto 0 do
      begin
        flag := False;
        indexStream.Seek(i*sizeIndex, soFromBeginning);
        {������ i-�� � (i+1)-�� ��������}
        indexStream.ReadBuffer(ind1, sizeIndex);
        indexStream.ReadBuffer(ind2, sizeIndex);
        if ind1.key > ind2.key then
        begin // �����
          flag := true;
          indexStream.Seek(i*sizeIndex, soFromBeginning);
          indexStream.WriteBuffer(ind2, sizeIndex);
          indexStream.WriteBuffer(ind1, sizeIndex);
        end;
        if not flag then //������� �� ����
          break; // ����� �� ����� �� i
      end;
  indexStream.Free;
  if reindexStr then // ���� ���� ����������������� ������� � ��������� �����
  begin // ���������� ����������� ����������
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
{������� ������� ������ � ������������ � ������. ��� ������������ ����������
��������������� �������� � ��� �� ������.}
  var
    i: word;
  begin
    for i := 1 to length(s) do
      s[i] := chr(ord(s[i]) xor key);
    CryptString := s;
  end;

procedure FilterEdit(var Key: char; TypeOfOperation: char);
{���������� ����� ��� �����. TypeOfOperation: s-���������, n-�����, r-����� �
�������}
  var
    cond: Boolean; // ������������� �� �������� ������ ��������� ��������
  begin
    case TypeOfOperation of
    's':  //���� � Edit ����� ������ ������ ��������
      begin
        cond := (Key in [' ', #8]) or ((ord(Key) >= 1040) and (ord(Key) <= 1103));
      end;
    'n':  //���� � Edit ����� ������ ������ �����
      begin
        cond := Key in ['0'..'9', #8];
      end;
    'r':  //���� � Edit ����� ������ ������ ����� � ���������� �����������
      begin
        cond := Key in ['0'..'9', #8, ','];
      end;
    end;
    if not cond then
      Key := #0;
  end;

end.
