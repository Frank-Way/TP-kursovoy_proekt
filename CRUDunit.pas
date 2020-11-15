unit CRUDunit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, System.UITypes,
  globalObjects;

type
  TCRUDform = class(TForm)
    intEdit1: TLabeledEdit;
    stringEdit1: TLabeledEdit;
    realEdit1: TLabeledEdit;
    intEdit2: TLabeledEdit;
    stringEdit2: TLabeledEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    intEdit3: TLabeledEdit;
    realEdit2: TLabeledEdit;
    procedure formatForm();
    function getRecord(): Boolean;
    procedure setRecord();
    procedure fillForm();
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure stringEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure intEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure realEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure loadBindings();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CRUDform: TCRUDform;
  fileType: byte;
  operationType: Char;

implementation

uses
  mainUnit;

{$R *.dfm}

procedure TCRUDform.loadBindings();
begin
  case fileType  of
    2: begin
      file2Box(0, ComboBox1);
      file2Box(1, ComboBox2);
    end;
    4:begin
      file2Box(3, ComboBox1);
      file2Box(5, ComboBox2);
      file2Box(6, ComboBox2);
      file2Box(2, ComboBox3);
    end;
  end;
end;

procedure TCRUDform.setRecord();
begin
  case fileType of
    0:begin
      intEdit1.Text := IntToStr(aOffice.ID);
      stringEdit2.Text := aOffice.adress;
    end;
    1:begin
      intEdit1.Text := IntToStr(aPosition.ID);
      stringEdit1.Text := aPosition.name;
      realEdit1.Text := FloatToStr(aPosition.salary);
    end;
    2:begin
      intEdit1.Text := IntToStr(aEmployee.ID);
      stringEdit1.Text := aEmployee.name;
      intEdit2.Text := aEmployee.passport;
      ComboBox1.Text := IntToStr(aEmployee.office);
      ComboBox2.Text := IntToStr(aEmployee.position);
    end;
    4:begin
      intEdit1.Text := IntToStr(aDeposite.ID);
      ComboBox1.Text := IntToStr(aDeposite.typeOfDeposite);
      realEdit1.Text := FloatToStr(aDeposite.amount);
      intEdit2.Text := IntToStr(aDeposite.period);
      ComboBox2.Text := IntToStr(aDeposite.client);
      ComboBox3.Text := IntToStr(aDeposite.employee);
      DateTimePicker1.Date := aDeposite.openDate;
    end;
    3:begin
      intEdit1.Text := IntToStr(aTypeOfDeposite.ID);
      stringEdit1.Text := aTypeOfDeposite.name;
      realEdit1.Text := FloatToStr(aTypeOfDeposite.rate);
      realEdit2.Text := FloatToStr(aTypeOfDeposite.minAmount);
      intEdit2.Text := IntToStr(aTypeOfDeposite.minPeriod);
    end;
    5:begin
      intEdit1.Text := IntToStr(aPrivatePerson.ID);
      stringEdit1.Text := aPrivatePerson.name;
      intEdit2.Text := aPrivatePerson.passport;
      intEdit3.Text := aPrivatePerson.phone;
      stringEdit2.Text := aPrivatePerson.adress;
    end;
    6:begin
      intEdit1.Text := IntToStr(aLegalPerson.ID);
      stringEdit1.Text := aLegalPerson.name;
      intEdit2.Text := aLegalPerson.OGRN;
      intEdit3.Text := aLegalPerson.phone;
      stringEdit2.Text := aLegalPerson.adress;
    end;
  end;
end;

procedure TCRUDform.fillForm();
var
  id: longword;
  id1, id2: longword;
begin
  loadBindings();
  if operationType = 'c' then
  begin
    if (fileType <> 5) and (fileType <> 6) then
      id := loadNewID(fileType)
    else
    begin
      id1 := loadNewID(5);
      id2 := loadNewID(6);
      if id1 > id2 then
        id := id1
      else
        id := id2;
    end;
    intEdit1.Text := IntToStr(id);
  end
  else
    setRecord();
end;

function TCRUDform.getRecord(): Boolean;
begin
  getRecord := false;
  aIndex.key := StrToInt(intEdit1.Text);
  case fileType of
    0:begin
      aOffice.ID := StrToInt(intEdit1.Text);
      if stringEdit2.Text <> '' then
      begin
        getRecord := true;
        aOffice.adress := stringEdit2.Text;
      end;
    end;
    1:begin
      aPosition.ID := StrToInt(intEdit1.Text);
      if (stringEdit1.Text <> '') and (realEdit1.Text <> '') then
      begin
        getRecord := true;
        aPosition.name := stringEdit1.Text;
        aPosition.salary := StrToFloat(realEdit1.Text);
      end;
    end;
    2:begin
      aEmployee.ID := StrToInt(intEdit1.Text);
      if (stringEdit1.Text <> '') and (intEdit2.Text <> '')
          and (ComboBox1.Text <> '') and (ComboBox2.Text <> '') then
      begin
        getRecord := true;
        aEmployee.name := stringEdit1.Text;
        if (Length(intEdit2.Text) = 10) then
          aEmployee.passport := intEdit2.Text
        else
        begin
          ShowMessage('Паспорт содержит 10 цифр');
          getRecord := false;
        end;
        aEmployee.office := StrToInt(ComboBox1.Text);
        aEmployee.position := StrToInt(ComboBox2.Text);

        if not findIndex(0, StrToInt(ComboBox1.Text)) then
        begin
          ShowMessage('Нет такого отделения');
          getRecord := false;
        end;
        if not findIndex(1, StrToInt(ComboBox2.Text)) then
        begin
          ShowMessage('Нет такой должности');
          getRecord := false;
        end;
      end;
    end;
    3:begin
      aTypeOfDeposite.ID := StrToInt(intEdit1.Text);
      if (stringEdit1.Text <> '') and (realEdit1.Text <> '')
          and (realEdit2.Text <> '') and (intEdit2.Text <> '') then
      begin
        getRecord := true;
        aTypeOfDeposite.name := stringEdit1.Text;
        if StrToFloat(realEdit1.Text) <= 100 then
          aTypeOfDeposite.rate := StrToFloat(realEdit1.Text)
        else
        begin
          ShowMessage('Процентная ставка не может быть больше 100%');
          getRecord := false;
        end;
        aTypeOfDeposite.minAmount := StrToFloat(realEdit2.Text);
        aTypeOfDeposite.minPeriod := StrToInt(intEdit2.Text);
      end;
    end;
    4:begin
       aDeposite.ID := StrToInt(intEdit1.Text);
      if (intEdit2.Text <> '') and (realEdit1.Text <> '')
          and (ComboBox1.Text <> '') and (ComboBox2.Text <> '')
          and (ComboBox3.Text <> '') then
      begin
        getRecord := true;
        aDeposite.client := StrToInt(ComboBox2.Text);
        aDeposite.typeOfDeposite := StrToInt(ComboBox1.Text);
        aDeposite.employee := StrToInt(ComboBox3.Text);
        aDeposite.openDate := DateTimePicker1.Date;
        aDeposite.period := StrToInt(intEdit2.Text);
        aDeposite.amount := StrToFloat(realEdit1.Text);

        if not (findIndex(5, StrToInt(ComboBox2.Text)) or
                findIndex(6, StrToInt(ComboBox2.Text))) then
        begin
          ShowMessage('Нет такого клиента');
          getRecord := false;
        end;
        if not findIndex(3, StrToInt(ComboBox1.Text)) then
        begin
          ShowMessage('Нет такого типа вкладов');
          getRecord := false;
        end
        else
        begin
          findRecord(3, aDeposite.typeOfDeposite);
          if aDeposite.period < aTypeOfDeposite.minPeriod then
          begin
            ShowMessage('Мнимальный срок - '+IntToStr(aTypeOfDeposite.minPeriod)+
                         'мес.');
            getRecord := false;
          end;
          if aDeposite.amount < aTypeOfDeposite.minAmount then
          begin
            ShowMessage('Мнимальная сумма - '+FloatToStr(aTypeOfDeposite.minAmount)+'руб.');
            getRecord := false;
          end;
        end;
        if not findIndex(2, StrToInt(ComboBox3.Text)) then
        begin
          ShowMessage('Нет такого сотрудника');
          getRecord := false;
        end;
      end;
    end;
    5:begin
      aPrivatePerson.ID := StrToInt(intEdit1.Text);
      if (stringEdit1.Text <> '') and (intEdit2.Text <> '')
          and (intEdit3.Text <> '') and (stringEdit2.Text <> '') then
      begin
        getRecord := true;
        aPrivatePerson.name := stringEdit1.Text;
        if Length(intEdit2.Text) = 10 then
          aPrivatePerson.passport := intEdit2.Text
        else
        begin
          ShowMessage('Паспорт содержит 10 цифр');
          getRecord := false;
        end;
        aPrivatePerson.phone := intEdit3.Text;
        aPrivatePerson.adress := stringEdit2.Text;
      end;
    end;
    6:begin
      aLegalPerson.ID := StrToInt(intEdit1.Text);
      if (stringEdit1.Text <> '') and (intEdit3.Text <> '')
          and (intEdit2.Text <> '') and (stringEdit2.Text <> '') then
      begin
        getRecord := true;
        aLegalPerson.name := stringEdit1.Text;
        if Length(intEdit2.Text) = 13 then
          aLegalPerson.OGRN := intEdit2.Text
        else
        begin
          ShowMessage('ОГРН содержит 13 цифр');
          getRecord := false;
        end;
        aLegalPerson.phone := intEdit3.Text;
        aLegalPerson.adress := stringEdit2.Text;
      end;
    end;
  end;
end;

procedure TCRUDform.intEdit2KeyPress(Sender: TObject; var Key: Char);
begin
  FilterEdit(Key, 'n');
end;

procedure TCRUDform.realEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  FilterEdit(Key, 'r');
end;

procedure TCRUDform.stringEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  FilterEdit(Key, 's');
end;

procedure TCRUDform.Button1Click(Sender: TObject);
var
  stream, stream2: TFileStream;
  flag: Boolean;
  tmp: LongWord;
begin
  flag := true;
  if MessageDlg('Подтвердить?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  begin
    if getRecord() then
    begin
      stream := TFileStream.Create(fileNameArr[fileType], fmOpenReadWrite);
      case operationType of
        'c':begin
          stream.Seek(0, soFromEnd);
        end;
        'u':begin
          findIndex(fileType, aIndex.key);
          stream.Seek(aIndex.ordNum*sizeArr[fileType], soFromBeginning);
        end;
        'd':begin
          case fileType of
            0, 1:begin
              stream2 := TFileStream.Create(fileNameArr[2], fmOpenRead);
              while stream2.Position <> stream2.Size do
              begin
                stream2.ReadBuffer(aEmployee, sizeArr[2]);
                if fileType = 0 then
                  tmp := aEmployee.office
                else if fileType = 1 then
                  tmp := aEmployee.position;
                if aIndex.key = tmp then
                begin
                  flag := false;
                  break;
                end;
              end;
              stream2.Free;
            end;
            3,5,6:begin
              stream2 := TFileStream.Create(fileNameArr[4], fmOpenRead);
              while stream2.Position <> stream2.Size do
              begin
                stream2.ReadBuffer(aDeposite, sizeArr[4]);
                if fileType = 3 then
                  tmp := aDeposite.typeOfDeposite
                else if (fileType = 5) or (fileType = 6) then
                  tmp := aDeposite.client;
                if aIndex.key = tmp then
                begin
                  flag := false;
                  break;
                end;
              end;
              stream2.Free;
            end;
          end;

          findIndex(fileType, aIndex.key);
          stream.Seek(-sizeArr[fileType], soFromEnd);
          stream.ReadBuffer(pArr[fileType]^, sizeArr[fileType]);
          stream.Seek(aIndex.ordNum*sizeArr[fileType], soFromBeginning);
        end;
      end;
      if flag then
        stream.WriteBuffer(pArr[fileType]^, sizeArr[fileType]);
      if (operationType = 'd') and flag then
        stream.Size := stream.Size - sizeArr[fileType];
      stream.Free;

      if ((operationType = 'c') or (operationType = 'd')) and flag then
        reIndex(fileType);

    end
    else
      ShowMessage('Не удалось прочесть данные');
    mainForm.Visible := True;
    CRUDform.Free;
  end;
end;

procedure TCRUDform.Button2Click(Sender: TObject);
  begin
    mainForm.Visible := True;
    CRUDform.Free;
  end;

procedure TCRUDform.formatForm();
begin
  case operationType of
    'r':begin
      CRUDform.Caption := 'Просмотр записи о';
      with Button2 do
      begin
        Visible := true;
        Left := 500;
        Top := 200;
        Caption := 'Вернуться';
      end;
      intEdit2.ReadOnly := true;
      intEdit3.ReadOnly := true;
      realEdit1.ReadOnly := true;
      realEdit2.ReadOnly := true;
      stringEdit1.ReadOnly := true;
      stringEdit2.ReadOnly := true;
      ComboBox1.Style := csSimple;
      ComboBox2.Style := csSimple;
      ComboBox3.Style := csSimple;
      ComboBox1.Enabled := false;
      ComboBox2.Enabled := false;
      ComboBox3.Enabled := false;
      DateTimePicker1.Enabled := false;
    end;
    'c':begin
      CRUDform.Caption := 'Добавление записи о';
      with Button1 do
      begin
        Visible := true;
        Left := 500;
        Top := 200;
        Caption := 'Добавить';
      end;
      with Button2 do
      begin
        Visible := true;
        Left := 500;
        Top := 300;
        Caption := 'Отмена';
      end;
    end;
    'u':begin
      CRUDform.Caption := 'Изменение записи о';
      with Button1 do
      begin
        Visible := true;
        Left := 500;
        Top := 200;
        Caption := 'Изменить';
      end;
      with Button2 do
      begin
        Visible := true;
        Left := 500;
        Top := 300;
        Caption := 'Отмена';
      end;
    end;
    'd':begin
      CRUDform.Caption := 'Удаление записи о';
      with Button1 do
      begin
        Visible := true;
        Left := 500;
        Top := 200;
        Caption := 'Удалить';
      end;
      with Button2 do
      begin
        Visible := true;
        Left := 500;
        Top := 300;
        Caption := 'Отмена';
      end;
      intEdit2.ReadOnly := true;
      intEdit3.ReadOnly := true;
      realEdit1.ReadOnly := true;
      realEdit2.ReadOnly := true;
      stringEdit1.ReadOnly := true;
      stringEdit2.ReadOnly := true;
      ComboBox1.Style := csSimple;
      ComboBox2.Style := csSimple;
      ComboBox3.Style := csSimple;
      ComboBox1.Enabled := false;
      ComboBox2.Enabled := false;
      ComboBox3.Enabled := false;
      DateTimePicker1.Enabled := false;
    end;
  end;
  case fileType of
    0:begin // отделение
      CRUDform.Caption := CRUDform.Caption + 'б отделении';
      CRUDform.Width := 800;
      CRUDform.Height := 400;
      with intEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 100;
        EditLabel.Caption := 'ID отделения';
      end;
      with stringEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 250;
        EditLabel.Caption := 'Адрес отделения';
      end;
    end;
    1:begin // должность
      CRUDform.Caption := CRUDform.Caption + ' должности';
      CRUDform.Width := 800;
      CRUDform.Height := 500;
      with intEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 100;
        EditLabel.Caption := 'ID должности';
        ReadOnly := true;
      end;
      with stringEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 200;
        EditLabel.Caption := 'Название должности';
      end;
      with realEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 300;
        EditLabel.Caption := 'Оклад';
      end;
    end;
    3:begin  // вид вклада
      CRUDform.Caption := CRUDform.Caption + ' виде вклада';
      CRUDform.Width := 800;
      CRUDform.Height := 600;
      with intEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 100;
        EditLabel.Caption := 'ID вид вклада';
        ReadOnly := true;
      end;
      with stringEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 200;
        EditLabel.Caption := 'Название вида вклада';
      end;
      with realEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 300;
        EditLabel.Caption := 'Процентная ставка, %';
      end;
      with realEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 400;
        EditLabel.Caption := 'Минимальная сумма, рубль';
      end;
      with intEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 500;
        EditLabel.Caption := 'Минимальный срок, месяц';
      end;
    end;
    5:begin  //физлицо
      CRUDform.Caption := CRUDform.Caption + ' физическом лице';
      CRUDform.Width := 800;
      CRUDform.Height := 600;
      with intEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 100;
        EditLabel.Caption := 'ID физического лица';
        ReadOnly := true;
      end;
      with stringEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 200;
        EditLabel.Caption := 'ФИО клиента';
      end;
      with intEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 300;
        EditLabel.Caption := 'Паспорт';
      end;
      with intEdit3 do
      begin
        Visible := true;
        Left := 30;
        Top := 400;
        EditLabel.Caption := 'Номер телефона';
      end;
      with stringEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 500;
        EditLabel.Caption := 'Адрес';
      end;
    end;
    6:begin // юрлицо
      CRUDform.Caption := CRUDform.Caption + ' юридическом лице';
      CRUDform.Width := 800;
      CRUDform.Height := 600;
      with intEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 100;
        EditLabel.Caption := 'ID юридического лица';
        ReadOnly := true;
      end;
      with stringEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 200;
        EditLabel.Caption := 'Название организации';
      end;
      with intEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 300;
        EditLabel.Caption := 'ОГРН';
      end;
      with intEdit3 do
      begin
        Visible := true;
        Left := 30;
        Top := 400;
        EditLabel.Caption := 'Номер телефона для связи';
      end;
      with stringEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 500;
        EditLabel.Caption := 'Адрес организации';
      end;
    end;
    2:begin  // сотрудник
      CRUDform.Caption := CRUDform.Caption + ' сотруднике';
      CRUDform.Width := 800;
      CRUDform.Height := 800;
      with intEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 100;
        EditLabel.Caption := 'ID сотрудника';
        ReadOnly := true;
      end;
      with stringEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 200;
        EditLabel.Caption := 'ФИО сотрудника';
      end;
      with intEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 300;
        EditLabel.Caption := 'Паспорт';
      end;
      with Label1 do
      begin
        Visible := true;
        Left := 30;
        Top := 400;
        Caption := 'Отделение';
      end;
      with ComboBox1 do
      begin
        Visible := true;
        Left := 30;
        Top := 430;
      end;
      with Label2 do
      begin
        Visible := true;
        Left := 30;
        Top := 500;
        Caption := 'Должность';
      end;
      with ComboBox2 do
      begin
        Visible := true;
        Left := 30;
        Top := 530;
      end;
    end;
    4:begin  // вклад
      CRUDform.Caption := CRUDform.Caption + ' вкладе';
      CRUDform.Width := 800;
      CRUDform.Height := 800;
      with intEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 50;
        EditLabel.Caption := 'ID вклада';
        ReadOnly := true;
      end;
      with Label1 do
      begin
        Visible := true;
        Left := 30;
        Top := 110;
        Caption := 'Вид вклада';
      end;
      with ComboBox1 do
      begin
        Visible := true;
        Left := 30;
        Top := 140;
      end;
      with realEdit1 do
      begin
        Visible := true;
        Left := 30;
        Top := 250;
        EditLabel.Caption := 'Сумма вклада';
      end;
      with intEdit2 do
      begin
        Visible := true;
        Left := 30;
        Top := 350;
        EditLabel.Caption := 'Срок вклада';
      end;
      with Label2 do
      begin
        Visible := true;
        Left := 30;
        Top := 450;
        Caption := 'Клиент';
      end;
      with ComboBox2 do
      begin
        Visible := true;
        Left := 30;
        Top := 480;
      end;
      with Label3 do
      begin
        Visible := true;
        Left := 30;
        Top := 580;
        Caption := 'Сотрудник';
      end;
      with ComboBox3 do
      begin
        Visible := true;
        Left := 30;
        Top := 610;
      end;
      with Label4 do
      begin
        Visible := true;
        Left := 500;
        Top := 100;
        Caption := 'Дата открытия';
      end;
      with DateTimePicker1 do
      begin
        Visible := true;
        Left := 500;
        Top := 130;
      end;
    end;
  end;
end;

procedure TCRUDform.FormShow(Sender: TObject);
begin
  formatForm();
  fillForm();
end;

end.
