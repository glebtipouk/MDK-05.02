unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, Grids;

type
  // Структура записи для студента
  TStudentRecord = record
    FIO: string[100];
    GroupNum: string[20];
    Subject: string[50];
    Grade: string[20];
    DatePass: string[20];
  end;

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem18: TMenuItem; // Оставляем, чтобы Lazarus не ругался
    MenuItem2: TMenuItem;  // Файл
    MenuItem3: TMenuItem;  // Запись
    MenuItem4: TMenuItem;  // Сортировка
    MenuItem5: TMenuItem;  // Найти
    MenuItem6: TMenuItem;  // Очистить
    MenuItem7: TMenuItem;  // Создать
    MenuItem8: TMenuItem;  // Открыть файл
    MenuItem9: TMenuItem;  // Сохранить
    MenuItem10: TMenuItem; // Сохранить как
    MenuItem11: TMenuItem; // Выход
    MenuItem12: TMenuItem; // Пункт меню для Редактирования
    MenuItem13: TMenuItem; // Пункт меню для Добавления
    MenuItem14: TMenuItem; // Удалить запись
    MenuItem15: TMenuItem; // по возрастанию
    MenuItem16: TMenuItem; // по убыванию
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StringGrid1: TStringGrid;

    procedure MenuItem5Click(Sender: TObject);  // Найти
    procedure MenuItem6Click(Sender: TObject);  // Очистить
    procedure MenuItem7Click(Sender: TObject);  // Создать
    procedure MenuItem8Click(Sender: TObject);  // Открыть файл
    procedure MenuItem9Click(Sender: TObject);  // Сохранить
    procedure MenuItem10Click(Sender: TObject); // Сохранить как
    procedure MenuItem11Click(Sender: TObject); // Выход из программы
    procedure MenuItem12Click(Sender: TObject); // Редактировать запись (MenuItem12)
    procedure MenuItem13Click(Sender: TObject); // Добавить запись (MenuItem13)
    procedure MenuItem14Click(Sender: TObject); // Удалить запись
    procedure MenuItem15Click(Sender: TObject); // Сортировка по возр.
    procedure MenuItem16Click(Sender: TObject); // Сортировка по убыв.
  private

  public
    procedure UpdateGrid;
    procedure SaveGridToFile; // Метод для сохранения таблицы обратно в файл
    procedure SortGrid(ColNum: Integer; Ascending: Boolean);
  end;

var
  Form1: TForm1;
  StudentFile: file of TStudentRecord;
  CurrentFileName: string;
  IsEditMode: Boolean;
  EditIndex: Integer;

implementation

uses Unit2; // Подключаем форму ввода данных (Form2)

{$R *.lfm}

{ Обновление таблицы из файла }
procedure TForm1.UpdateGrid;
var
  Student: TStudentRecord;
  RowIndex: Integer;
begin
  StringGrid1.RowCount := 1;

  if (CurrentFileName = '') or (not FileExists(CurrentFileName)) then Exit;

  AssignFile(StudentFile, CurrentFileName);
  try
    Reset(StudentFile);
    RowIndex := 1;
    while not EOF(StudentFile) do
    begin
      Read(StudentFile, Student);
      StringGrid1.RowCount := RowIndex + 1;

      StringGrid1.Cells[0, RowIndex] := IntToStr(RowIndex);
      StringGrid1.Cells[1, RowIndex] := Student.FIO;
      StringGrid1.Cells[2, RowIndex] := Student.GroupNum;
      StringGrid1.Cells[3, RowIndex] := Student.Subject;
      StringGrid1.Cells[4, RowIndex] := Student.Grade;
      StringGrid1.Cells[5, RowIndex] := Student.DatePass;

      Inc(RowIndex);
    end;
  finally
    CloseFile(StudentFile); // Железно закрываем файл после чтения
  end;
end;

{ Сохранение текущего состояния StringGrid обратно в файл }
procedure TForm1.SaveGridToFile;
var
  Student: TStudentRecord;
  i: Integer;
begin
  if CurrentFileName = '' then Exit;

  AssignFile(StudentFile, CurrentFileName);
  try
    Rewrite(StudentFile);
    for i := 1 to StringGrid1.RowCount - 1 do
    begin
      Student.FIO := StringGrid1.Cells[1, i];
      Student.GroupNum := StringGrid1.Cells[2, i];
      Student.Subject := StringGrid1.Cells[3, i];
      Student.Grade := StringGrid1.Cells[4, i];
      Student.DatePass := StringGrid1.Cells[5, i];
      Write(StudentFile, Student);
    end;
  finally
    CloseFile(StudentFile); // Железно закрываем файл после записи
  end;
end;

{ Сортировка таблицы }
procedure TForm1.SortGrid(ColNum: Integer; Ascending: Boolean);
var
  i, j, c: Integer;
  temp: string;
  MustSwap: Boolean;
begin
  if StringGrid1.RowCount <= 2 then Exit;

  for i := 1 to StringGrid1.RowCount - 2 do
    for j := i + 1 to StringGrid1.RowCount - 1 do
    begin
      if Ascending then
        MustSwap := StringGrid1.Cells[ColNum, i] > StringGrid1.Cells[ColNum, j]
      else
        MustSwap := StringGrid1.Cells[ColNum, i] < StringGrid1.Cells[ColNum, j];

      if MustSwap then
      begin
        for c := 0 to StringGrid1.ColCount - 1 do
        begin
          temp := StringGrid1.Cells[c, i];
          StringGrid1.Cells[c, i] := StringGrid1.Cells[c, j];
          StringGrid1.Cells[c, j] := temp;
        end;
      end;
    end;
end;

{ Создать файл }
procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    CurrentFileName := SaveDialog1.FileName;
    try
      AssignFile(StudentFile, CurrentFileName);
      Rewrite(StudentFile);
      CloseFile(StudentFile);
      UpdateGrid;
      ShowMessage('Новый типизированный файл успешно создан!');
    except
      ShowMessage('Не удалось создать файл.');
    end;
  end;
end;

{ Открыть файл }
procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    CurrentFileName := OpenDialog1.FileName;
    UpdateGrid;
  end;
end;

{ Сохранить }
procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  ShowMessage('Все изменения автоматически записываются прямо в файл при нажатии кнопки "Сохранить" на форме ввода!');
end;

{ Сохранить как }
procedure TForm1.MenuItem10Click(Sender: TObject);
var
  OldFile, NewFile: file of TStudentRecord;
  Rec: TStudentRecord;
begin
  if (CurrentFileName <> '') and SaveDialog1.Execute then
  begin
    try
      AssignFile(OldFile, CurrentFileName);
      Reset(OldFile);
      AssignFile(NewFile, SaveDialog1.FileName);
      Rewrite(NewFile);

      try
        while not EOF(OldFile) do
        begin
          Read(OldFile, Rec);
          Write(NewFile, Rec);
        end;
      finally
        CloseFile(OldFile);
        CloseFile(NewFile);
      end;

      CurrentFileName := SaveDialog1.FileName;
      ShowMessage('Файл успешно пересохранен под новым именем!');
    except
      ShowMessage('Ошибка при пересохранении файла!');
    end;
  end;
end;

{ Выход из программы }
procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  if MessageDlg('Выйти из программы?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Close;
end;

{ РЕДАКТИРОВАТЬ ЗАПИСЬ (MenuItem12) }
procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  if CurrentFileName = '' then
  begin
    ShowMessage('Сначала создайте или откройте файл!');
    Exit;
  end;

  EditIndex := StringGrid1.Row;
  if (EditIndex < 1) or (EditIndex >= StringGrid1.RowCount) then
  begin
    ShowMessage('Пожалуйста, выберите запись в таблице для редактирования!');
    Exit;
  end;

  IsEditMode := True; // Включаем режим редактирования

  // Переносим данные из выбранной строки таблицы на форму Form2
  Form2.Edit1.Text := StringGrid1.Cells[1, EditIndex];
  Form2.Edit2.Text := StringGrid1.Cells[2, EditIndex];
  Form2.Edit3.Text := StringGrid1.Cells[3, EditIndex];
  Form2.ComboBox1.Text := StringGrid1.Cells[4, EditIndex];
  Form2.Edit4.Text := StringGrid1.Cells[5, EditIndex];

  Form2.ShowModal;
end;

{ ДОБАВИТЬ ЗАПИСЬ (MenuItem13) }
procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  if CurrentFileName = '' then
  begin
    ShowMessage('Сначала создайте или откройте файл!');
    Exit;
  end;

  IsEditMode := False; // Выключаем режим редактирования (это создание новой записи)

  // Очищаем поля формы ввода для новой записи
  Form2.Edit1.Clear;
  Form2.Edit2.Clear;
  Form2.Edit3.Clear;
  Form2.ComboBox1.Text := '';
  Form2.Edit4.Clear;

  Form2.ShowModal;
end;

{ Удалить запись }
procedure TForm1.MenuItem14Click(Sender: TObject);
var
  TempFile: file of TStudentRecord;
  Rec: TStudentRecord;
  SelRow, i: Integer;
  Success: Boolean;
begin
  if CurrentFileName = '' then Exit;

  SelRow := StringGrid1.Row;
  if (SelRow < 1) or (SelRow >= StringGrid1.RowCount) then
  begin
    ShowMessage('Выберите запись для удаления!');
    Exit;
  end;

  if MessageDlg('Удалить выбранную запись?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Success := False;
    try
      AssignFile(StudentFile, CurrentFileName);
      Reset(StudentFile);
      AssignFile(TempFile, 'temp.dat');
      Rewrite(TempFile);

      try
        i := 1;
        while not EOF(StudentFile) do
        begin
          Read(StudentFile, Rec);
          if i <> SelRow then
            Write(TempFile, Rec);
          Inc(i);
        end;
      finally
        CloseFile(StudentFile);
        CloseFile(TempFile);
      end;

      // Удаляем старый файл и подменяем его временным
      if DeleteFile(CurrentFileName) then
      begin
        if RenameFile('temp.dat', CurrentFileName) then
          Success := True;
      end;

      if Success then
      begin
        UpdateGrid;
        ShowMessage('Запись успешно удалена!');
      end
      else
        ShowMessage('Ошибка обновления файлов при удалении! Проверьте права доступа.');

    except
      ShowMessage('Ошибка при удалении записи!');
    end;
  end;
end;

{ Сортировка по возрастанию }
procedure TForm1.MenuItem15Click(Sender: TObject);
begin
  SortGrid(1, True);       // Сортируем таблицу на экране по ФИО
  SaveGridToFile;          // Сразу перезаписываем файл в новом порядке
  UpdateGrid;              // Обновляем индексы строк в первом столбце
end;

{ Сортировка по убыванию }
procedure TForm1.MenuItem16Click(Sender: TObject);
begin
  SortGrid(1, False);      // Сортируем таблицу на экране по ФИО
  SaveGridToFile;          // Сразу перезаписываем файл в новом порядке
  UpdateGrid;              // Обновляем индексы строк в первом столбце
end;

{ Поиск записи }
procedure TForm1.MenuItem5Click(Sender: TObject);
var
  SearchStr: string;
  i: Integer;
  Found: Boolean;
begin
  SearchStr := InputBox('Поиск', 'Введите ФИО студента:', '');
  if SearchStr = '' then Exit;

  Found := False;
  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    if Pos(AnsiUpperCase(SearchStr), AnsiUpperCase(StringGrid1.Cells[1, i])) > 0 then
    begin
      StringGrid1.Row := i;
      Found := True;
      ShowMessage('Запись найдена и выделена в таблице!');
      Break;
    end;
  end;
  if not Found then ShowMessage('Запись не найдена.');
end;

{ Очистить форму }
procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  StringGrid1.RowCount := 1;
  CurrentFileName := '';
  ShowMessage('Интерфейс программы успешно очищен!');
end;

end.
