{����� ��� ������� �������� ����������������� ���� ������ ��� �������. �� �����
��������� ��� ���������� ���� ������� � ������������ �������� �� ��� �
����������� �� �������� ����� � ����� ������.}

unit consultUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids;

type
  TconsultForm = class(TForm)
    amountEdit: TLabeledEdit;
    periodEdit: TLabeledEdit;
    Button1: TButton;
    StringGrid1: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure amountEditKeyPress(Sender: TObject; var Key: Char);
    procedure periodEditKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  consultForm: TconsultForm;

implementation

{$R *.dfm}

uses
  mainUnit, // �������� �����
  globalObjects, // ���������� �������
  math; // ������ � ��������������� ���������

procedure TconsultForm.amountEditKeyPress(Sender: TObject; var Key: Char);
{� ���� "�����" ����� ������� ������ ����� � ���������� �����������}
begin
  FilterEdit(Key, 'r');
end;

procedure TconsultForm.Button1Click(Sender: TObject);
{���� �� ������ "���������" ��������� �������� ������ � ������� ����������
���� ������� � ����������� �������.}
var
  stream: TFileStream; // �������� �����
  amount, // �������� �����
  d: real; // �����
  period, //�������� ����
  i: byte; // ��������
begin
  amount := StrToFloat(amountEdit.Text);
  if StrToInt(periodEdit.Text) <= 255 then // ���� �� ����� ���� ������ 255 ���.
  begin
    period := StrToInt(periodEdit.Text);
    with StringGrid1 do
    begin
      {�������������� StringGrid'�}
      Visible := true;
      Width := 0;
      ColCount := 6;
      RowCount := 1;
      Cells[0,0] := '�������� ������';
      ColWidths[0] := 220;
      Cells[1,0] := '������, %';
      ColWidths[1] := 170;
      Cells[2,0] := '���. �����, ���.';
      ColWidths[2] := 220;
      Cells[3,0] := '���. ����, ���.';
      ColWidths[3] := 210;
      Cells[4,0] := '����, ���.';
      ColWidths[4] := 200;
      Cells[5,0] := '�����, ���.';
      ColWidths[5] := 200;
      for i := 0 to ColCount-1 do
        Width := Width + ColWidths[i];
      Width := Width + 30;
      {����������� ���� � ������ �������}
      stream := TFileStream.Create(fileNameArr[3], fmOpenRead);
      if stream.Size > 0 then // ���� �� ����
      begin
        while stream.Position <> stream.Size do // �� ����� �����
        begin
          stream.ReadBuffer(pArr[3]^, sizeArr[3]); // ����������� ��������� ���
          {���� �������� �������� ������������� �������� ���������� ���� ������}
          if (amount >= aTypeOfDeposite.minAmount) and
             (period >= aTypeOfDeposite.minPeriod) then
          begin
            {������ ��������� �� �����}
            RowCount := RowCount + 1;
            Cells[0, RowCount - 1] := aTypeOfDeposite.name;
            Cells[1, RowCount - 1] := Format('%2g', [aTypeOfDeposite.rate]);
            Cells[2, RowCount - 1] := Format('%2g', [aTypeOfDeposite.minAmount]);
            Cells[3, RowCount - 1] := IntToStr(aTypeOfDeposite.minPeriod);
            d := amount; // �������� �����, ����� ����� ��������� �������� �����
            for i := 1 to period do
              {������ ����� ����� ������������� �� ���������� ������}
              d := d + d * aTypeOfDeposite.rate/1200;
            Cells[4, RowCount - 1] := Format('%m', [d]);
            Cells[5, RowCount - 1] := Format('%m',[d - amount]);
          end;
        end;
        if RowCount = 1 then
          ShowMessage('�� ������� ��������� �����');
      end
      else
        ShowMessage('���� � ������ ������� ����');
      stream.Free;
    end;
  end
  else
    ShowMessage('������������ ���� - 255 �������');
end;

procedure TconsultForm.FormClose(Sender: TObject; var Action: TCloseAction);
{�������� ����� ���������� �������� �����}
begin
  mainForm.Visible := true;
  consultForm.Free;
end;

procedure TconsultForm.periodEditKeyPress(Sender: TObject; var Key: Char);
{� ���� "����" ����� ������� ������ �����}
begin
  FilterEdit(Key, 'n');
end;

end.
