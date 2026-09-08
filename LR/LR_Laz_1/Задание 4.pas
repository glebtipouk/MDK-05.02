Program GD4;
  function SumTo(n: integer): integer;
  begin
    // Рекурсивная триада:
    // 1. Параметризация: n (верхняя граница суммы)
    // 2. База рекурсии: n <= 1 (сумма от 1 до 1 равна 1)
    // 3. Декомпозиция: SumTo(n) = n + SumTo(n-1)
    if n <= 1 then
      Result := n
    else
      Result := n + SumTo(n - 1);
  end;
  begin
  var n := ReadInteger('Введите n:');
  Print(SumTo(n));
end.
