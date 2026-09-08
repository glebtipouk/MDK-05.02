Program GD6;
  procedure LoopFor(i, n: integer);
  begin
    // Рекурсивная триада:
    // 1. Параметризация: i (текущий шаг), n (всего шагов)
    // 2. База рекурсии: i > n (шаги закончились)
    // 3. Декомпозиция: выполнить действие для i, вызвать LoopFor(i+1, n)
    if i <= n then
    begin
      PrintLn($'Привет, шаг {i}');
      LoopFor(i + 1, n);
    end;
  end;
  begin
  LoopFor(1, 10);
end.
