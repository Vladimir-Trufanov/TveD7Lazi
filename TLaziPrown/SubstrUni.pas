// LAZARUS [DELPHI7], WIN10\XP                            *** SubStrUni.pas ***

// ****************************************************************************
// * Td7Prown [1400]                    Выделить подстроку из заданной строки *
// ****************************************************************************

//                                   Авторы: Хайрутдинов Дмитрий, Труфанов В.Е.
//                                   Дата создания:                  20.04.2004
// Copyright © 2004 TVE              Посл.изменение:                 26.08.2017

// Синтаксис
//
// function SubStr(cFromStr:string; nPoint:integer; nWidth:integer=0):string;
//
// Параметры
//
//   cFromStr - исходная строка,
//   nPoint - позиция начала подстроки,
//   nWidth - длина подстроки.

unit SubstrUni;

interface

function SubStr(cFromStr: string; nPoint: integer; nWidth: integer = 0): string;

implementation

function SubStr(cFromStr: string; nPoint: integer; nWidth: integer): string;
begin
  if (nPoint < 1) or (nWidth < 0) then begin
    Result := '';
    exit;
  end;
  if nWidth > 0 then  // Если задана длина подстроки
    Result := copy(cFromStr, nPoint, nWidth)
  else  // Все до конца строки
    Result := copy(cFromStr, nPoint, length(cFromStr) + 1 - nPoint);
end;

end.

// ********************************************************** SubStrUni.pas ***
