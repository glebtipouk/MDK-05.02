Program GD;

procedure Row(n: integer);
begin
  // Рекурсивная триада:
  // 1. Параметризация: n (текущее число для вывода)
  // 2. База рекурсии: n < 1 (когда достигли 0)
  // 3. Декомпозиция: вывести n и вызвать Row(n-1)
  if n >= 1 then
  begin
    Print($'{n} ');
    Row(n - 1);
  end;
end;

begin
  Row(5); // Вызов для примера
end.