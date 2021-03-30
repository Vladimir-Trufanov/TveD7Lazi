// LAZARUS[DELPHI7], WIN10\XP                                 *** AtUni.pas ***

// ****************************************************************************
// * TLaziPrown [1200]                      Найти позицию вхождения подстроки *
// *                                            слева направо и справа налево *
// ****************************************************************************

//                                   Авторы: Хайрутдинов Дмитрий, Труфанов В.Е.
//                                   Дата создания:                  19.04.2004
// Copyright © 2004 TVE              Посл.изменение:                 28.01.2017

// Синтаксис
//
//   function
//     At(cSubStrSeek:string; cFromStr:string; nNumber:integer=1): integer;
//
//   function
//     RAt(cSubStrSeek:string; cFromStr:string; nNumber:integer=1):integer;
//
// Параметры
//
//   cSubStrSeek - искомая подстрока,
//   cFromStr - исходная строка,
//   nNumber - номер вхождения

// Возвращаемое значение содержит позицию заданного по номеру вхождения
//   подстроки. В случае, если подстрока не найдена, возвращается 0.

unit AtUni;

interface

function At(cSubStrSeek:string; cFromStr:string; nNumber:integer=1):integer;
function RAt(cSubStrSeek:string; cFromStr:string; nNumber:integer=1):integer;

implementation

// ****************************************************************************
// *   Найти позицию заданного (по умолчанию - первого) вхождения подстроки   *
// *    слева направо. В случае, если подстрока не найдена, возвращается 0.   *
// ****************************************************************************

function At(cSubStrSeek:string; cFromStr:string; nNumber:integer):integer;
var
  tmp: string;  // исходная строка
  n: integer;   // номер вхождения
  p: integer;   // позиция текущего вхождения
begin
  if nNumber<1 then begin
    Result := 0;
    exit;
  end;
  tmp := cFromStr;
  n := 1;
  p := pos(cSubStrSeek, tmp);  // Первое вхождение подстроки
  Result := p;
  // Пока нашлось очередное вхождение и это не нужный нам номер
  while (p <> 0) and (n <> nNumber) do  begin
    // Удаляем все до 2-го найденного вхождения,
    // чтобы в строке "1231231" нашлось 2 подстроки "1231".
    tmp := copy(tmp, p + 1, length(tmp) - p);
    {Если вместо предыдущей строки поставить следующую,
    будет удалена вся подстрока и найдется только 1 подстрока "1231".
    tmp := copy(tmp, p + length(cSubStrSeek),
      length(tmp) + 1 - p - length(cSubStrSeek));}
    p := pos(cSubStrSeek, tmp);  // Позиция следующего вхождения
    inc(n);
    if p > 0 then  // Если есть следующее вхождение
      // Добавим позицию очередного вхождения
      Result := Result + p;  // Если используется 1-й вариант удаления
                             // найденной подстроки (только до 2-го ее символа)
      {Если используется 2-й вариант (вся найденная подстрка)
      Result := Result + p + length(cSubStrSeek) - 1;}
  end;
  // Если последнего необходимого вхождения не было, результат равен 0
  if p = 0 then
    Result := 0;
end;

// ****************************************************************************
// *   Найти позицию заданного (по умолчанию - первого) вхождения подстроки   *
// *    справа налево. В случае, если подстрока не найдена, возвращается 0.   *
// ****************************************************************************

function RAt(cSubStrSeek:string; cFromStr:string; nNumber:integer): integer;
var
  From, Sub: string;  // Исходная и искомая строки
  c: char;  // Временный символ
  i: word;  // счетчик символа в строке
  l: word;  // Длина строки
begin
  From := cFromStr;
  Sub := cSubStrSeek;
  // Перевернем строки
  l := length(Sub);
  i := l div 2;
  while i > 0 do begin
    c := Sub[i];
    Sub[i] := Sub[l + 1 - i];
    Sub[l + 1 - i] := c;
    dec(i);
  end;
  l := length(From);
  i := l div 2;
  while i > 0 do begin
    c := From[i];
    From[i] := From[l + 1 - i];
    From[l + 1 - i] := c;
    dec(i);
  end;
  // Находим позицию для перевернутых строк
  Result := At(Sub, From, nNumber);
  if Result <> 0 then  // Если была подстрока в перевернутой строке,
    Result := l + 2 - Result - length(Sub);  // получаем ее номер в исходной
end;

end.

// ************************************************************** AtUni.pas ***
