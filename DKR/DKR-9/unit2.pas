unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton; // Кнопка "Сохранить"
    ComboBox1: TComboBox; // Оценка
    Edit1: TEdit; // ФИО
    Edit2: TEdit; // Группа
    Edit3: TEdit; // Предмет
    Edit4: TEdit; // Дата
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

uses Unit1; // Подключаем Unit1, чтобы видеть файл и режим работы

{$R *.lfm}

{ Кнопка Сохранить }
procedure TForm2.Button1Click(Sender: TObject);
var
  NewRecord: TStudentRecord;
  IsFileOpened: Boolean;
begin
  // Проверяем заполнение ключевых полей
  if (Edit1.Text = '') or (Edit2.Text = '') then
  begin
    ShowMessage('Пожалуйста, заполните ФИО и Группу!');
    Exit;
  end;

  // Собираем данные из полей формы
  NewRecord.FIO := Edit1.Text;
  NewRecord.GroupNum := Edit2.Text;
  NewRecord.Subject := Edit3.Text;
  NewRecord.Grade := ComboBox1.Text;
  NewRecord.DatePass := Edit4.Text;

  IsFileOpened := False;
  try
    AssignFile(StudentFile, CurrentFileName);
    Reset(StudentFile);
    IsFileOpened := True;

    if IsEditMode then
    begin
      // Режим редактирования: перезаписываем строго выбранную строку
      Seek(StudentFile, EditIndex - 1);
    end
    else
    begin
      // Режим добавления: уходим в самый конец файла
      Seek(StudentFile, FileSize(StudentFile));
    end;

    // Записываем данные в файл
    Write(StudentFile, NewRecord);

    // Закрываем файл
    CloseFile(StudentFile);
    IsFileOpened := False;

    // Обновляем таблицу на главной форме и закрываем окно
    Form1.UpdateGrid;
    ModalResult := mrOk;

  except
    on E: Exception do
    begin
      if IsFileOpened then
      begin
        try CloseFile(StudentFile); except end;
      end;
      ShowMessage('Ошибка при сохранении в файл! Причина: ' + E.Message);
    end;
  end;
end;

end.
