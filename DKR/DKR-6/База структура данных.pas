program CircularLinkedList;

const
  MAX_SIZE = 100; 
type
  TData = integer;          
  TNode = record            
    data: TData;
    next: integer;          
  end;

var
  nodes: array[1..MAX_SIZE] of TNode;  
  head: integer;                        
  freeHead: integer;                     
// список свободных узлов
procedure InitFreeList;
var
  i: integer;
begin
  for i := 1 to MAX_SIZE - 1 do
  nodes[i].next := i + 1;
  nodes[MAX_SIZE].next := 0;   
  freeHead := 1;
  head := 0;                    
end;

// получаем новый узел
function GetNode: integer;
var
  idx: integer;
begin
  if freeHead = 0 then
    GetNode := 0
  else
  begin
    idx := freeHead;
    freeHead := nodes[freeHead].next;
    GetNode := idx;
  end;
end;

// возвращаем узел в список свободных
procedure FreeNode(idx: integer);
begin
  nodes[idx].next := freeHead;
  freeHead := idx;
end;

// пустой ли список
function IsEmpty: boolean;
begin
  IsEmpty := (head = 0);
end;

// Добавление элемента в начало списка 
procedure AddToBeginning(val: TData);
var
  newIdx, lastIdx: integer;
begin
  newIdx := GetNode;
  if newIdx = 0 then
  begin
    writeln('Ошибка: нет свободной памяти!');
    exit;
  end;
  nodes[newIdx].data := val;

  if IsEmpty then
  begin
    // пустой список 
    nodes[newIdx].next := newIdx;
    head := newIdx;
  end
  else
  begin
    // поиск последнего узла
    lastIdx := head;
    while nodes[lastIdx].next <> head do
      lastIdx := nodes[lastIdx].next;
    // новый элемент в начало
    nodes[newIdx].next := head;
    nodes[lastIdx].next := newIdx;
    head := newIdx;
  end;
end;

// добавляем элемент в конец
procedure AddToEnd(val: TData);
var
  newIdx, lastIdx: integer;
begin
  newIdx := GetNode;
  if newIdx = 0 then
  begin
    writeln('Ошибка: нет свободной памяти!');
    exit;
  end;
  nodes[newIdx].data := val;

  if IsEmpty then
  begin
    nodes[newIdx].next := newIdx;
    head := newIdx;
  end
  else
  begin
    lastIdx := head;
    while nodes[lastIdx].next <> head do
      lastIdx := nodes[lastIdx].next;
    nodes[lastIdx].next := newIdx;
    nodes[newIdx].next := head;
  end;
end;

// Поиск элемента по значению. 
function Find(val: TData): integer;
var
  cur: integer;
begin
  if IsEmpty then
  begin
    Find := 0;
    exit;
  end;
  cur := head;
  repeat
    if nodes[cur].data = val then
    begin
      Find := cur;
      exit;
    end;
    cur := nodes[cur].next;
  until cur = head;
  Find := 0;
end;

// удаление первого вхождения 
procedure DeleteByValue(val: TData);
var
  cur, prev: integer;
begin
  if IsEmpty then
  begin
    writeln('Список пуст, удаление невозможно');
    exit;
  end;

  // поиск удаляемого элемента и предыдущего 
  prev := head;
  while nodes[prev].next <> head do
    prev := nodes[prev].next;  
  cur := head;

  repeat
    if nodes[cur].data = val then
    begin
      if cur = head then
      begin
        if nodes[cur].next = head then
        begin
          head := 0;
        end
        else
        begin
          head := nodes[cur].next;
          nodes[prev].next := head;
        end;
      end
      else
      begin
        nodes[prev].next := nodes[cur].next;
      end;
      FreeNode(cur);
      writeln('Элемент ', val, ' удалён');
      exit;
    end;
    prev := cur;
    cur := nodes[cur].next;
  until cur = head;

  writeln('Элемент ', val, ' не найден');
end;

// выводим список
procedure PrintList;
var
  cur: integer;
  count: integer;
begin
  if IsEmpty then
  begin
    writeln('Список пуст');
    exit;
  end;

  writeln('Содержимое списка (в формате [индекс: данные] -> ... ) :');
  cur := head;
  count := 0;
  repeat
    write('[', cur, ':', nodes[cur].data, ']');
    cur := nodes[cur].next;
    if cur <> head then
      write(' -> ')
    else
      writeln(' -> (возврат к голове [', head, '])');
    inc(count);
    if count > MAX_SIZE then  
    begin
      writeln('Ошибка: обнаружено зацикливание!');
      break;
    end;
  until cur = head;
end;


procedure ClearList;
var
  cur, nextIdx: integer;
begin
  if IsEmpty then exit;
  cur := head;
  repeat
    nextIdx := nodes[cur].next;
    FreeNode(cur);
    cur := nextIdx;
  until cur = head;
  head := 0;
  writeln('Список очищен');
end;

procedure Menu;
var
  choice: integer;
  val: TData;
  idx: integer;
begin
  repeat
    writeln('1. Добавить элемент в начало');
    writeln('2. Добавить элемент в конец');
    writeln('3. Удалить элемент по значению');
    writeln('4. Найти элемент по значению');
    writeln('5. Вывести список');
    writeln('6. Очистить список');
    writeln('0. Выход');
    write('Ваш выбор: ');
    readln(choice);

    case choice of
      1: begin
           write('Введите значение: ');
           readln(val);
           AddToBeginning(val);
         end;
      2: begin
           write('Введите значение: ');
           readln(val);
           AddToEnd(val);
         end;
      3: begin
           if IsEmpty then
             writeln('Список пуст')
           else
           begin
             write('Введите значение для удаления: ');
             readln(val);
             DeleteByValue(val);
           end;
         end;
      4: begin
           if IsEmpty then
             writeln('Список пуст')
           else
           begin
             write('Введите значение для поиска: ');
             readln(val);
             idx := Find(val);
             if idx = 0 then
               writeln('Элемент не найден')
             else
               writeln('Элемент найден в узле с индексом ', idx);
           end;
         end;
      5: PrintList;
      6: ClearList;
      0: writeln('Выход');
    else
      writeln('Неверный пункт меню, повторите');
    end;
  until choice = 0;
end;

begin
  InitFreeList;
  Menu;
end.