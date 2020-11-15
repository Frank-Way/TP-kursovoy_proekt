{Форма для подбора наиболее предпочтительного вида вклада для клиента. На форме
выводятся все подходящие виды вкладов с вычисленными доходами по ним в
зависимости от введённых суммы и срока вклада.}

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
  mainUnit, // основная форма
  globalObjects, // глобальные объекты
  math; // модуль с математическими формулами

procedure TconsultForm.amountEditKeyPress(Sender: TObject; var Key: Char);
{В поле "Сумма" можно вводить только цифры и десятичный разделитель}
begin
  FilterEdit(Key, 'r');
end;

procedure TconsultForm.Button1Click(Sender: TObject);
{Клик по кнопке "Подобрать" считывает введённые данные и выводит подходящие
виды вкладов с вычисленным доходом.}
var
  stream: TFileStream; // файловый поток
  amount, // введённая сумма
  d: real; // доход
  period, //введённый срок
  i: byte; // итератор
begin
  amount := StrToFloat(amountEdit.Text);
  if StrToInt(periodEdit.Text) <= 255 then // срок не может быть больше 255 мес.
  begin
    period := StrToInt(periodEdit.Text);
    with StringGrid1 do
    begin
      {Форматирование StringGrid'а}
      Visible := true;
      Width := 0;
      ColCount := 6;
      RowCount := 1;
      Cells[0,0] := 'Название вклада';
      ColWidths[0] := 220;
      Cells[1,0] := 'Ставка, %';
      ColWidths[1] := 170;
      Cells[2,0] := 'Мин. сумма, руб.';
      ColWidths[2] := 220;
      Cells[3,0] := 'Мин. срок, мес.';
      ColWidths[3] := 210;
      Cells[4,0] := 'Итог, руб.';
      ColWidths[4] := 200;
      Cells[5,0] := 'Доход, руб.';
      ColWidths[5] := 200;
      for i := 0 to ColCount-1 do
        Width := Width + ColWidths[i];
      Width := Width + 30;
      {открывается файл с видами вкладов}
      stream := TFileStream.Create(fileNameArr[3], fmOpenRead);
      if stream.Size > 0 then // файл не пуст
      begin
        while stream.Position <> stream.Size do // не конец файла
        begin
          stream.ReadBuffer(pArr[3]^, sizeArr[3]); // считывается очередной вид
          {Если введённые значения удовлетворяют условиям считанного вида вклада}
          if (amount >= aTypeOfDeposite.minAmount) and
             (period >= aTypeOfDeposite.minPeriod) then
          begin
            {Запись выводится на форму}
            RowCount := RowCount + 1;
            Cells[0, RowCount - 1] := aTypeOfDeposite.name;
            Cells[1, RowCount - 1] := Format('%2g', [aTypeOfDeposite.rate]);
            Cells[2, RowCount - 1] := Format('%2g', [aTypeOfDeposite.minAmount]);
            Cells[3, RowCount - 1] := IntToStr(aTypeOfDeposite.minPeriod);
            d := amount; // исходная сумма, затем будет вычислена конечная сумма
            for i := 1 to period do
              {каждый месяц сумма увеличивается на процентную ставку}
              d := d + d * aTypeOfDeposite.rate/1200;
            Cells[4, RowCount - 1] := Format('%m', [d]);
            Cells[5, RowCount - 1] := Format('%m',[d - amount]);
          end;
        end;
        if RowCount = 1 then
          ShowMessage('Не удалось подобрать вклад');
      end
      else
        ShowMessage('Файл с видами вкладов пуст');
      stream.Free;
    end;
  end
  else
    ShowMessage('Максимальный срок - 255 месяцев');
end;

procedure TconsultForm.FormClose(Sender: TObject; var Action: TCloseAction);
{Закрытие формы возвращает основную форму}
begin
  mainForm.Visible := true;
  consultForm.Free;
end;

procedure TconsultForm.periodEditKeyPress(Sender: TObject; var Key: Char);
{В поле "срок" можно вводить только цифры}
begin
  FilterEdit(Key, 'n');
end;

end.
