Program GD8;
  procedure PrintFibonacci(first, second, count: integer);
  begin
    // Рекурсивная триада:
    // 1. Параметризация: first (предыдущее число), second (текущее число), count (сколько осталось вывести)
    // 2. База рекурсии: count <= 0 (вывели достаточно чисел)
    // 3. Декомпозиция: вывести next = first+second, вызвать PrintFibonacci(second, next, count-1)
    if count > 0 then
    begin
      var next := first + second;
      Print(next, ' ');
      PrintFibonacci(second, next, count - 1);
    end;
  end;
  begin
  Print('Первые 10 чисел Фибоначчи: ');
  PrintFibonacci(0, 1, 10);
end.
