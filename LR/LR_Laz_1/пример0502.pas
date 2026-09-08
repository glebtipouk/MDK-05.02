uses GraphABC;

const
  INITIAL_DEPTH = 3;     // Начальная глубина рекурсии
  STEP = 5;              // Шаг перемещения окна
  WINDOW_SIZE = 700;     // Размер окна
  SNOWFLAKE_SIZE = 250;  // Размер снежинки

var
  depth: integer;        // Текущая глубина рекурсии
  snowflakeSize: integer; // Текущий размер снежинки

// Рекурсивная процедура рисования кривой Коха
procedure Koch(x1, y1, x2, y2: real; level: integer);
var
  x3, y3, x4, y4, x5, y5: real;
begin
  if level = 0 then
  begin
    Line(round(x1), round(y1), round(x2), round(y2));
  end
  else
  begin
    // Вычисляем точки для сегмента
    x3 := x1 + (x2 - x1) / 3;
    y3 := y1 + (y2 - y1) / 3;
    
    x4 := x2 - (x2 - x1) / 3;
    y4 := y2 - (y2 - y1) / 3;
    
    // Вычисляем вершину треугольника
    x5 := (x3 + x4) / 2 - (y4 - y3) * sqrt(3) / 2;
    y5 := (y3 + y4) / 2 + (x4 - x3) * sqrt(3) / 2;
    
    // Рекурсивно рисуем 4 сегмента
    Koch(x1, y1, x3, y3, level - 1);
    Koch(x3, y3, x5, y5, level - 1);
    Koch(x5, y5, x4, y4, level - 1);
    Koch(x4, y4, x2, y2, level - 1);
  end;
end;

// Процедура рисования всей снежинки
procedure DrawSnowflake;
var
  x0, y0: integer;
  angle: real;
  x1, y1, x2, y2: real;
  i: integer;
begin
  // Очищаем окно
  ClearWindow;
  
  // Центр снежинки
  x0 := Window.Width div 2;
  y0 := Window.Height div 2;
  
  // Рисуем 3 стороны снежинки
  for i := 0 to 2 do
  begin
    angle := i * 2 * Pi / 3 - Pi/2; // Поворачиваем, чтобы снежинка была симметричной
    
    // Координаты начала и конца стороны
    x1 := x0 + snowflakeSize * cos(angle);
    y1 := y0 + snowflakeSize * sin(angle);
    x2 := x0 + snowflakeSize * cos(angle + 2*Pi/3);
    y2 := y0 + snowflakeSize * sin(angle + 2*Pi/3);
    
    // Рисуем кривую Коха для этой стороны
    Koch(x1, y1, x2, y2, depth);
  end;
  
  // Выводим информацию
  SetFontColor(clBlue);
  SetFontSize(10);
  TextOut(10, 10, 'Снежинка Коха');
  TextOut(10, 30, 'Глубина рекурсии: ' + depth.ToString());
  TextOut(10, 50, 'Размер: ' + snowflakeSize.ToString());
  TextOut(10, 70, 'Управление:');
  TextOut(10, 90, '←↑↓→ - перемещение окна');
  TextOut(10, 110, '+/- - глубина рекурсии');
  TextOut(10, 130, 'PageUp/Down - размер');
  TextOut(10, 150, 'R - сброс позиции');
  TextOut(10, 170, 'C - цвет');
  TextOut(10, 190, 'ESC - выход');
end;

// Обработка нажатия клавиш
procedure KeyDown(Key: integer);
begin
  case Key of
    
    
    // Увеличение глубины
    VK_Left:
    begin
      if depth < 15 then  // Ограничиваем максимальную глубину
      begin
        depth := depth + 1;
        DrawSnowflake;
      end;
    end;
    
    // Уменьшение глубины
    VK_Right:
    begin
      if depth > 0 then   // Ограничиваем минимальную глубину
      begin
        depth := depth - 1;
        DrawSnowflake;
      end;
    end;
    
    // Увеличение размера
    VK_U: // PageDown
    begin
      if snowflakeSize > 50 then
      begin
        snowflakeSize := snowflakeSize + 20;
        DrawSnowflake;
      end;
    end;
    
    // Уменьшение размера
    VK_Y: // PageDown
    begin
      if snowflakeSize > 50 then
      begin
        snowflakeSize := snowflakeSize - 20;
        DrawSnowflake;
      end;
    end;
    
    VK_Escape: Window.Close; // Выход
    
    // Сброс позиции окна
    VK_R:
    begin
      Window.Left := (ScreenWidth - Window.Width) div 2;
      Window.Top := (ScreenHeight - Window.Height) div 2;
      DrawSnowflake;
    end;
    
    // Изменение цвета
    VK_C:
    begin
      SetPenColor(RGB(Random(256), Random(256), Random(256)));
      DrawSnowflake;
    end;
    
    // Сброс к начальным значениям
    VK_D:
    begin
      depth := INITIAL_DEPTH;
      snowflakeSize := SNOWFLAKE_SIZE;
      SetPenColor(clBlue);
      DrawSnowflake;
    end;
  end;
end;


// Обработка перемещения окна
procedure WindowMove;
begin
  DrawSnowflake;
end;

// Обработка изменения размера окна
procedure Resize;
begin
  DrawSnowflake;
end;

begin
  // Настройка окна
  SetWindowSize(WINDOW_SIZE, WINDOW_SIZE);
  Window.Title := 'Снежинка Коха - Управление: стрелки, +/-, PageUp/Down, R, C, D, ESC';
  Window.IsFixedSize := true; // Фиксируем размер окна
  
  // Центрируем окно
  Window.Left := (ScreenWidth - Window.Width) div 2;
  Window.Top := (ScreenHeight - Window.Height) div 2;
  
  // Инициализация переменных
  depth := INITIAL_DEPTH;
  snowflakeSize := SNOWFLAKE_SIZE;
  
  // Настройка пера
  SetPenColor(clBlue);
  SetPenWidth(2);
  SetBrushColor(clTransparent);
  
  // Рисуем начальную снежинку
  DrawSnowflake;
  
  // Привязка обработчиков событий
  OnKeyDown := KeyDown;
  OnResize := Resize;
end.