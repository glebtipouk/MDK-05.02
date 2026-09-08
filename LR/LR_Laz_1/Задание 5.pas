Program GD5;
  function Power(a, b: integer): integer;
  begin
    // Рекурсивная триада:
    // 1. Параметризация: a (основание), b (показатель степени)
    // 2. База рекурсии: b <= 0 (любое число в степени 0 равно 1)
    // 3. Декомпозиция: a^b = a * a^(b-1)
    if b <= 0 then
      Result := 1
    else
      Result := a * Power(a, b - 1);
  end;
  begin
  var x := ReadInteger('Число?');
  var y := ReadInteger('Степень?');
  Print(Power(x, y));
end.
