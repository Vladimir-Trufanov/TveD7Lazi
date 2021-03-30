// LAZARUS, WIN10\XP                                   *** Code12to8Uni.pas ***

// ****************************************************************************
// *      Преобразовать 12-разрядное представление текста к 10-чным кодам     *
// ****************************************************************************

// Автор: Труфанов В.Е.                              Дата создания:  18.10.2017
// Copyright © 2017 tve                              Посл.изменение: 28.10.2017

unit Code12to10Uni;

{$mode objfpc}{$H+}

interface

uses
  Classes,Dialogs,SysUtils,LazitoolsOutfit,math,
  FileReaderClass,ErrEventClass;

type
  TCode12to10 = class
  private
    // Хранители свойств класса
    FViewCode: Integer;    // Способ представления кодов сжатого текста
    // Внутренние переменные класса
    Chetny: Boolean;       // True - четный код
    ChetVerh: Integer;     // Старшие 4-разряда четного символа
    // Сменить чётность
    procedure SmenityChet;
    // Выбрать код из потока сжатого файла визуализированного 12-разрядном вида
    function TakeCode12View(oReader:TFileReader): String;
    // Выбрать код из потока сжатого файла в 12-разрядном основном виде
    function TakeCode12(oReader:TFileReader): String;
    // Выбрать код из потока заархивированного файла
    function TakeCode(oReader:TFileReader): String;
  protected
  public
    // Создать объект
    constructor Create(ViewCode:Integer=vicInteger);
    // Преобразовать 12-разрядное представление текста к 10-чным кодам
    function Take(oReader:TFileReader): String;
  published
  end;

implementation

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TCode12to10.Create(ViewCode:Integer=vicInteger);
begin
  FViewCode:=ViewCode;
  // Ждём первый (нечетный) код
  Chetny:=False;
end;

// ****************************************************************************
// *                             Сменить четность                             *
// ****************************************************************************
procedure TCode12to10.SmenityChet;
begin
  Chetny:=not Chetny;
end;

// ****************************************************************************
// * Выбрать код из потока сжатого файла визуализированного 12-разрядном вида *
// ****************************************************************************
function  TCode12to10.TakeCode12View(oReader:TFileReader): String;
var
  nPoint: Integer;
  cReadChar: Char;       // Символ из входного потока
  c12Code: String;       // Визуализированный 12-разрядный код
  nVerh: Integer;        // Старшие разряды десятичного представления
  nNiz: Integer;         // Младшие разряды десятичного представления
  cVerh: String;         // Строка старших разрядов десятичного представления
  cNiz: String;          // Строка младших разрядов десятичного представления
begin
  Result:=IntToStr(fwEOC);
  // Выбираем из входного потока визуализированный 12-разрядный код
  c12Code:='';
  while True do begin
    // Считываем очередной символ
    oReader.ReadChar(cReadChar);
    // Если символ пустой, то отмечаем завершение входного потока
    if ord(cReadChar)=0 then begin
      c12Code:=IntToStr(fwEOC);
      break;
    end
    // По точке завершаем набор кода
    else if ord(cReadChar)=ord('.') then break;
    // Набираем код
    c12Code:=c12Code+cReadChar;
  end;
  // Преобразуем к визуализированному десятичному значению
  // если нечетный код по порядку
  if not Chetny then begin
    nPoint:=AnsiPos('[',c12Code);
    if nPoint=0 then Result:=IntToStr(fwEOC)
    else begin
      cNiz:=Copy(c12Code,0,nPoint-1);
      cVerh:=Copy(c12Code,nPoint+1,MaxInt);
      nPoint:=AnsiPos(']',cVerh);
      if nPoint=0 then Result:=IntToStr(fwEOC)
      else begin
        cVerh:=Copy(cVerh,0,nPoint-1);
        nNiz:=StrToInt(cNiz);
        nVerh:=StrToInt(cVerh);
        Result:=IntToStr(nVerh*256+nNiz);
      end;
    end;
  end
  // Преобразуем к визуализированному десятичному значению
  // если четный код по порядку
  else begin
    nPoint:=AnsiPos('[',c12Code);
    if nPoint=0 then Result:=IntToStr(fwEOC)
    else begin
      cVerh:=Copy(c12Code,nPoint+1,MaxInt);
      nPoint:=AnsiPos(']',cVerh);
      if nPoint=0 then Result:=IntToStr(fwEOC)
      else begin
        cNiz:=Copy(cVerh,nPoint+1,MaxInt);
        cVerh:=Copy(cVerh,0,nPoint-1);
        nNiz:=StrToInt(cNiz);
        nVerh:=StrToInt(cVerh);
        Result:=IntToStr(nVerh*256+nNiz);
      end;
    end;
  end;
  SmenityChet;
end;

// ****************************************************************************
// *     Выбрать код из потока сжатого файла в 12-разрядном основном виде     *
// ****************************************************************************
function  TCode12to10.TakeCode12(oReader:TFileReader): String;
var
  nPoint: Integer;
  cReadChar: Char;       // Символ из входного потока
  chr1,chr2,chr3: Char;  // Считываемые коды из входного потока
  NechVerh: Integer;     // Старшие 4-разряда нечетного символа
begin
  Result:=IntToStr(fwEOC);
  // Считываем очередной символ
  oReader.ReadChar(cReadChar);
  // Если символ пустой, то отмечаем завершение входного потока
  if ord(cReadChar)<>0 then begin
    // Преобразуем нечетный код
    if not Chetny then begin
      chr1:=cReadChar;
      oReader.ReadChar(cReadChar);
      //Showmessage('2 в нечетном ='+IntToStr(ord(cReadChar)));

      if ord(cReadChar)<>0 then begin
        chr2:=cReadChar;
        nPoint:=ord(chr2)-1;
        NechVerh:=Floor(Double(nPoint)/16);
        ChetVerh:=nPoint mod 16;
        // Showmessage('nPoint='+IntToStr(nPoint)+' NechVerh='+IntToStr(NechVerh)+' ChetVerh='+IntToStr(ChetVerh));
        chr3:=chr(0);
        Result:=IntToStr(NechVerh*256+ord(chr1));
      end;
    end
    // Преобразуем четный код
    else begin
      chr3:=cReadChar;
      // Showmessage('chr1='+IntToStr(ord(chr1))+' chr2='+IntToStr(ord(chr2))+' chr3='+IntToStr(ord(chr3)));
      Result:=IntToStr(ChetVerh*256+ord(chr3));
    end;
    SmenityChet;
  end;
end;

// ****************************************************************************
// *                 Выбрать код из потока заархивированного файла            *
// ****************************************************************************
function TCode12to10.TakeCode(oReader:TFileReader): String;
var
  cReadChar: Char; // Символ из входного потока
begin
  Result:='';
  while True do begin
    // Считываем очередной символ
    oReader.ReadChar(cReadChar);
    // Если символ пустой, то отмечаем завершение входного потока
    if ord(cReadChar)=0 then begin
      Result:=IntToStr(fwEOC);
      break;
    end
    // По точке завершаем набор кода
    else if ord(cReadChar)=ord('.') then break;
    // Набираем код
    Result:=Result+cReadChar;
  end;
end;

// ****************************************************************************
// *      Преобразовать 12-разрядное представление текста к 10-чным кодам     *
// ****************************************************************************
function TCode12to10.Take(oReader:TFileReader): String;
begin
  if FViewCode=vicInteger then Result:=TakeCode(oReader)
  else if FViewCode=vicSimple then Result:=TakeCode12View(oReader)
  else Result:=TakeCode12(oReader)
end;

end.

