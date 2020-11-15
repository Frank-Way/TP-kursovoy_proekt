{����� ��� ������ ������� �� ID ��� ��������/����}

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
  mainUnit, // �������� �����
  globalObjects, // ���������� �������
  CRUDUnit; // ����� ��������������� �������

procedure TsearchForm.FormClose(Sender: TObject; var Action: TCloseAction);
{�������� ����� ���������� �������� �����}
begin
  mainForm.Visible := true;
  searchForm.Free;
end;

procedure TsearchForm.FormShow(Sender: TObject);
{��� ����������� ����� ��� ������������� ������ ������� � ����������� ��
���������� ����� � ��������}
var
  inv: String; // ������� ��� ����������� �������� �������� � ��������� �����
begin
  {��� ����������� ���������� ������ ������� RadioGroup(ID), � ������� �����
  ����������}
  fieldRBGroup.ItemIndex := 0;
  fieldRBGroup.Visible := false;
  case operationType of
    'r': inv := '��������';
    'u': inv := '���������';
    'd': inv := '��������';
  end;
  searchForm.Caption := inv + ' ������ � �����';
  {���������� ������� �������� � RadioGroup}
  case fileType of
    2,5:begin
      fieldRBGroup.Visible := true;
      fieldRBGroup.Items.Add('�������');
    end;
    6:begin
      fieldRBGroup.Visible := true;
      fieldRBGroup.Items.Add('����');
    end;
  end;
end;

procedure TsearchForm.inputEditKeyPress(Sender: TObject; var Key: Char);
{� inputEdit ����� ������� ������ �����}
begin
  FilterEdit(Key, 'n');
end;

procedure TsearchForm.searchBtnClick(Sender: TObject);
{������ "�����" ���� ������ �� �������� �������� �, ���� ��� �����, �� ��
���������� �����}
var
  num: LongWord; // ID
  str: ShortString; // ������� ��� ����
  flag, // ��������� �� ������ ��������
  recordFound: Boolean; // ������� �� ������
begin
  flag := true;
  case fileType of
    {���� ����� ����� ����������/������� �� ��������, �� ����� - 10 ��������}
    2,5: if (fieldRBGroup.ItemIndex = 1) and (Length(inputEdit.Text) <> 10) then
      flag := false;
    {���� ����� ����� ����������� �� ����, �� ����� - 13 ��������}
    6: if (fieldRBGroup.ItemIndex = 1) and (Length(inputEdit.Text) <> 13) then
      flag := false;
  end;
  if inputEdit.Text = '' then
    flag := false;
  if flag then // ���� "������ ��������"
  begin
    case fieldRBGroup.ItemIndex of
      0:begin // ����� �� ID (�����)
        num := StrToInt(inputEdit.Text);
        recordFound := findRecord(fileType, num);
      end;
      1:begin // ����� �� ��������/���� (������)
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
      ShowMessage('������ �� �������');
  end
  else
    ShowMessage('�� ����� ������� ��������');
end;

procedure TsearchForm.fieldRBGroupClick(Sender: TObject);
{���� �� RadioGroup �������� ������� � ���� ��� �����}
begin
  case fieldRBGroup.ItemIndex of
    0:inputEdit.EditLabel.Caption := 'ID ������';
    1:case fileType of
      2,5:inputEdit.EditLabel.Caption := '������� ��������';
      6:inputEdit.EditLabel.Caption := '���� �����������';
    end;
  end;
end;

end.
