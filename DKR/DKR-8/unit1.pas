unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnCalculate: TButton;
    BtnClear: TButton;
    BtnInfo: TButton;
    EdtPrincipal: TEdit;
    EdtRate: TEdit;
    EdtDays: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LblResult: TLabel;
    MemDetails: TMemo;
    RgType: TRadioGroup;
    procedure BtnCalculateClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnInfoClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.BtnCalculateClick(Sender: TObject);
var
  Principal, AnnualRate, DailyRate, CurrentAmount, InterestEarned, TotalInterest: Double;
  Days, I: Integer;
begin
  MemDetails.Clear;
  LblResult.Caption := 'Результат: ';

  if not TryStrToFloat(EdtPrincipal.Text, Principal) or (Principal <= 0) then
  begin
    ShowMessage('Ошибка: Введите корректную начальную сумму.');
    Exit;
  end;

  if not TryStrToFloat(EdtRate.Text, AnnualRate) or (AnnualRate < 0) then
  begin
    ShowMessage('Ошибка: Введите корректную годовую ставку.');
    Exit;
  end;

  if not TryStrToInt(EdtDays.Text, Days) or (Days <= 0) then
  begin
    ShowMessage('Ошибка: Введите корректное количество дней.');
    Exit;
  end;

  DailyRate := (AnnualRate / 100) / 365;

  MemDetails.Lines.Add('==================================================');
  MemDetails.Lines.Add('       ПОЯСНИТЕЛЬНАЯ ИНФОРМАЦИЯ ПО РАСЧЕТАМ       ');
  MemDetails.Lines.Add('==================================================');
  MemDetails.Lines.Add(Format('Начальная сумма: %.2f руб.', [Principal]));
  MemDetails.Lines.Add(Format('Годовая ставка: %.2f%%', [AnnualRate]));
  MemDetails.Lines.Add(Format('Срок начисления: %d дн.', [Days]));
  MemDetails.Lines.Add('--------------------------------------------------');

  CurrentAmount := Principal;
  TotalInterest := 0;

  if RgType.ItemIndex = 0 then
  begin
    MemDetails.Lines.Add('Режим: ПРОСТЫЕ ПРОЦЕНТЫ');
    MemDetails.Lines.Add('');
    for I := 1 to Days do
    begin
      InterestEarned := Principal * DailyRate;
      TotalInterest := TotalInterest + InterestEarned;
      CurrentAmount := Principal + TotalInterest;
      MemDetails.Lines.Add(Format('День %d: Начислено = %.2f руб. | Баланс = %.2f руб.',
        [I, InterestEarned, CurrentAmount]));
    end;
  end
  else
  begin
    MemDetails.Lines.Add('Режим: СЛОЖНЫЕ ПРОЦЕНТЫ');
    MemDetails.Lines.Add('');
    for I := 1 to Days do
    begin
      InterestEarned := CurrentAmount * DailyRate;
      TotalInterest := TotalInterest + InterestEarned;
      CurrentAmount := CurrentAmount + InterestEarned;
      MemDetails.Lines.Add(Format('День %d: Начислено = %.2f руб. | Баланс = %.2f руб.',
        [I, InterestEarned, CurrentAmount]));
    end;
  end;

  MemDetails.Lines.Add('--------------------------------------------------');
  MemDetails.Lines.Add(Format('Вложено: %.2f руб.', [Principal]));
  MemDetails.Lines.Add(Format('Конечная сумма: %.2f руб.', [CurrentAmount]));

  LblResult.Caption := Format('Результат: %.2f руб.', [CurrentAmount]);
end;

procedure TForm1.BtnClearClick(Sender: TObject);
begin
  EdtPrincipal.Clear;
  EdtRate.Clear;
  EdtDays.Clear;
  MemDetails.Clear;
  LblResult.Caption := 'Результат: ';
end;

procedure TForm1.BtnInfoClick(Sender: TObject);
begin
  MemDetails.Clear;
  MemDetails.Lines.Add('Калькулятор процентов');
  MemDetails.Lines.Add('');
  MemDetails.Lines.Add('Простые проценты:');
  MemDetails.Lines.Add('A = P * (1 + r * t)');
  MemDetails.Lines.Add('где:');
  MemDetails.Lines.Add('A - итоговая сумма');
  MemDetails.Lines.Add('P - основная сумма');
  MemDetails.Lines.Add('r - процентная ставка (в десятичной форме)');
  MemDetails.Lines.Add('t - время в годах (дни/365)');
  MemDetails.Lines.Add('');
  MemDetails.Lines.Add('Сложные проценты:');
  MemDetails.Lines.Add('A = P * (1 + r)^t');
  MemDetails.Lines.Add('(обозначения те же)');
  MemDetails.Lines.Add('');
  MemDetails.Lines.Add('Вводите время в днях, система автоматически переведет в годы.');
end;

end.
end;

end.

