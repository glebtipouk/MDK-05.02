Program GD7;
  function GCD(a, b: integer): integer;
  begin
    // Рекурсивная триада:
    // 1. Параметризация: a, b (числа, для которых ищем НОД)
    // 2. База рекурсии: b = 0 (тогда НОД = a)
    // 3. Декомпозиция: НОД(a, b) = НОД(b, a mod b)
    if b = 0 then
      Result := a
    else
      Result := GCD(b, a mod b);
  end;
  begin
  var num1 := 3430;
  var num2 := 1365;
  PrintLn($'НОД({num1}, {num2}) = {GCD(num1, num2)}');
end.
