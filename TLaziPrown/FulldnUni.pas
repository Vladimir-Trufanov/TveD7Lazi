// LAZARUS [DELPHI7], WIN10\XP                            *** FullDnUni.pas ***

// ****************************************************************************
// * TLaziPrown [1300]       Преобразовать целое положительное число в строку *
// *      с заданным числом символов, дополненное слева символом-заполнителем *
// * (по умолчанию  двузначное число, дополненное пробелом при необходимости) *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  26.03.2003
// Copyright © 2003 TVE                              Посл.изменение: 26.01.2006

// Синтаксис
//
//   function FullDn(nNumber:Integer;
//     nLength:Integer=2; cFill:Char=' '):String; safecall;
//
// Параметры
//
//   nNumber - число, представленное для преобразования
//   nLength - количество символов, возвращаемой строки
//   cFill - символ-заполнитель

// Возвращаемое значение содержит nLength "звездочек", если число превосходит
//   в строковом представлении заданное число символов

unit FulldnUni;

interface

uses Math,SysUtils,Windows;

function
FullDn(nNumber:Integer; nLength:Integer=2; cFill:Char='0'):String; safecall;

implementation

function
FullDn(nNumber:Integer; nLength:Integer=2; cFill:Char='0'):String; safecall;
var
  cBuffer: String;
begin
  // Если число превышает заданный формат, то возвращаем "звездочки"
  if nNumber>(IntPower(10,nLength)-1) then begin
    FullDn:=StringOfChar('*',nLength);
  end

  else begin
    cBuffer:=StringOfChar(cFill,nLength);
    cBuffer:=cBuffer+IntToStr(nNumber);
    FullDn:=copy(cBuffer,Length(cBuffer)-nLength+1,nLength);
  end;
end;
end.

// ********************************************************** FullDnUni.pas ***
