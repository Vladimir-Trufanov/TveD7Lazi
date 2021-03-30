// Lazarus, WIN-10\XP                                   *** СompressUni.pas ***

// ****************************************************************************
// * LempeZiw:       Считать текстовый файл и вернуть архивированный файл LZW *
// ****************************************************************************

// Автор: Труфанов В.Е.                              Дата создания:  08.10.2017
// Copyright © 2017 tve                              Посл.изменение: 11.10.2017

unit CompressUni;

{$mode objfpc}{$H+}

interface

uses
  Classes,SysUtils,Dialogs;

 function MakeCompress(const Origin,Compressed:String;
   var Dict:TStringList; const ViewCode:Integer): Byte;

implementation

uses
  Code10to12Uni,ConvertUni,DictionaryUni,
  FileReaderClass,FileWriterClass,LazitoolsOutfit;

// ****************************************************************************
// *        Считать текстовый файл и вернуть архивированный файл LZW          *
// ****************************************************************************

// Origin: String;        // Спецификация оригинального файла (путь+имя)
// Compressed: String;    // Спецификация сжатого файла (путь+имя)
// Dict: TStringList;     // Словарь

function MakeCompress(const Origin,Compressed:String;
  var Dict:TStringList; const ViewCode:Integer): Byte;
var
  oReader: TFileReader;  // Объект побайтового чтения из файла через буфер
  oWriter: TFileWriter;  // Объект побайтовой записи строк в файл
  o10to12v: TCode10to12; // Преобразователь 10-тичных кодов к 12-теричным
  cReadChar: Char;       // Символ из входного потока
  cStr: String;          // Строка для кодирования и вывода
  cCode: String;         // Визуализированный код, например "272."
  NewCode: Integer;      // Код для нового элемента словаря
  c: String;
begin
  Result:=0;
  o10to12v:=TCode10to12.Create(ViewCode);
  // Инициируем словарь и готовим очередной новый код
  Dict:=TStringList.Create;
  NewCode:=IniCompressDict(Dict);
  // Готовим объект побайтового чтения из файла
  oReader:=TFileReader.Create;
  oReader.Path:='';
  oReader.FileName:=Origin;
  // Готовим объект для записи в файл
  oWriter:=TFileWriter.Create;
  oWriter.Path:='';
  oWriter.FileName:=Compressed;

  {СТРОКА = первый символ из входного потока
  WHILE входной поток не пуст DO
    СИМВОЛ = очередной символ из входного потока
    IF СТРОКА+СИМВОЛ в таблице строк THEN
      СТРОКА = СТРОКА+СИМВОЛ
    ELSE
      вывести в выходной поток код для СТРОКА
      добавить в таблицу строк СТРОКА+СИМВОЛ
      СТРОКА = СИМВОЛ
    END of IF
  END of WHILE
  вывести в выходной поток код для СТРОКА}

  // СТРОКА = первый символ из входного потока
  oReader.ReadChar(cReadChar);
  cStr:=cReadChar;
  // WHILE входной поток не пуст DO
  while ord(cReadChar)<>0 do begin
    // СИМВОЛ = очередной символ из входного потока
    if oReader.ReadChar(cReadChar)<>0 then break;
    // IF СТРОКА+СИМВОЛ в таблице строк THEN СТРОКА = СТРОКА+СИМВОЛ
    c:=Dict.Values[MakeCodes(cStr+cReadChar)];
    if c>'' then cStr:=cStr+cReadChar
    // ELSE
    //   вывести в выходной поток код для СТРОКА
    //   добавить в таблицу строк СТРОКА+СИМВОЛ
    //   СТРОКА = СИМВОЛ
    // END of IF
    else begin
      // Выводим код для строки
      c:=Dict.Values[MakeCodes(cStr)];
      //ShowMessage(CP1251ToUTF8('cStr='+c+'='+GetCode10(c)));
      oWriter.Write(o10to12v.Make(GetCode10(c)));
      // Добавляем СТРОКА+СИМВОЛ в справочник
      AddaDiCompress(cStr+cReadChar,NewCode,Dict);
      // Задаем новый код, но чтобы не был нулевой по модулю 256
      // для того чтобы младшие 8 нулевых бит не получались для записи
      NewCode:=GenNewCode(NewCode);
      // Переопределяем строку
      cStr:=cReadChar;
    end;
  end;
  // вывести в выходной поток код для СТРОКА (последний код)
  c:=Dict.Values[MakeCodes(cStr)];
  //ShowMessage(CP1251ToUTF8('cStr='+c+'='+GetCode10(c)));
  oWriter.Write(o10to12v.Make(GetCode10(c)));
  // Принудительно выталкиваем старшую часть нечетного кода для Make12
  if ViewCode=vic12 then begin
    cStr:=o10to12v.Make12(IntToStr(fwEOC));
    if cStr<>'' then oWriter.Write(cStr);
  end;
  // Дописываем последний буфер в файл,
  // отдельно посылая признак завершения кодов
  oWriter.Write(IntToStr(fwEOC));
end;

end.

// ******************************************************** СompressUni.pas ***

