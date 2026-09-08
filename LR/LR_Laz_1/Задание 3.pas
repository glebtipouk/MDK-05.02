Program GD3;
  function Factorial(a: integer): integer;
  begin
    // Рекурсивная триада:
    // 1. Параметризация: a (число, для которого считаем факториал)
    // 2. База рекурсии: a <= 1 (факториал 1 и 0 равен 1)
    // 3. Декомпозиция: a! = a * (a-1)!
    if a <= 1 then
      Result := 1
    else
      Result := a * Factorial(a - 1);
  end;
  begin
  var x := ReadInteger('Введите число:');
  Print(Factorial(x));
end.
