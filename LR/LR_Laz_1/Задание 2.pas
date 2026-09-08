Program GD2;
  procedure Reverse(n: integer);
  begin
    // Рекурсивная триада:
    // 1. Параметризация: n (оставшаяся часть числа)
    // 2. База рекурсии: n div 10 = 0 (осталась одна цифра)
    // 3. Декомпозиция: вывести последнюю цифру (n mod 10), вызвать Reverse(n div 10)
    Print(n mod 10);
    if (n div 10) <> 0 then
      Reverse(n div 10);
  end;
  
  begin
  Reverse(3078);
end.
