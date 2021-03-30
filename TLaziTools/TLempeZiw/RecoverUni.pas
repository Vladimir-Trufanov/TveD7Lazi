// Lazarus, WIN-10\XP                                   *** RecoverUni.pas ***

// ****************************************************************************
// * LempeZiw:                Считать и распаковать заархивированный файл LZW *
// ****************************************************************************

// Автор: Труфанов В.Е.                              Дата создания:  16.10.2017
// Copyright © 2017 tve                              Посл.изменение: 16.10.2017

unit RecoverUni;

{$mode objfpc}{$H+}

interface

uses
  Classes,Dialogs,SysUtils,
  FileReaderClass,FileWriterClass,DictionaryUni,LazitoolsOutfit;

// Считать и распаковать заархивированный файл LZW
function MakeRecover(const Compressed,Recovered:String;
  var Dict:TStringList; const ViewCode:Integer): Byte;

implementation

uses
  code12to10uni;

// ****************************************************************************
// *                Считать и распаковать заархивированный файл LZW           *
// ****************************************************************************

// Compressed: String;   // Спецификация сжатого файла (путь+имя)
// Recovered: String;    // Спецификация восстановленного файла (путь+имя)
// Dict: TStringList;    // Словарь

function MakeRecover(const Compressed,Recovered:String;
  var Dict:TStringList; const ViewCode:Integer): Byte;
var
  oReader: TFileReader;  // Объект побайтового чтения из файла через буфер
  oWriter: TFileWriter;  // Объект побайтовой записи строк в файл
  NewCode: Integer;      // Код для нового элемента словаря
  cCodeOld:String;       // Текст старого кода
  cCodeNew:String;       // Текст нового кода
  Str: String;           // Строка, взятая по коду из справочника и на выход
  Symb: Char;            // Символы, извлекаемые из строки
  cc: String;            // Поле+значение для показа и для занесения в справочник
  n: Integer;
  o12to10v: TCode12to10;
begin
  Result:=0;
  o12to10v:=TCode12to10.Create(ViewCode);
  // Инициируем словарь и готовим очередной новый код
  Dict:=TStringList.Create;
  NewCode:=IniRecoverDict(Dict);
  // Готовим объект побайтового чтения из файла
  oReader:=TFileReader.Create;
  oReader.Path:='';
  oReader.FileName:=Compressed;
  // Готовим объект для записи в файл
  oWriter:=TFileWriter.Create;
  oWriter.Path:='';
  oWriter.FileName:=Recovered;
  {
  читать СТАРЫЙ_КОД
  вывести СТАРЫЙ_КОД
  СИМВОЛ = СТАРЫЙ_КОД
  WHILE входной поток не пуст DO
    читать НОВЫЙ_КОД
    IF NOT в таблице перевода НОВЫЙ_КОД THEN
      СТРОКА = перевести СТАРЫЙ_КОД
      СТРОКА = СТРОКА+СИМВОЛ
    ELSE
      СТРОКА = перевести НОВЫЙ_КОД
    END of IF
    вывести СТРОКУ
    СИМВОЛ = первый символ СТРОКИ
    добавить в таблицу перевода СТАРЫЙ_КОД+СИМВОЛ
    СТАРЫЙ_КОД = НОВЫЙ_КОД
  END of WHILE
  }
  // "читать СТАРЫЙ_КОД"
  cCodeOld:=o12to10v.Take(oReader);
  //ShowMessage('cCodeOld='+cCodeOld);
  // "вывести СТАРЫЙ_КОД"
  Str:=GetRecoverDict(cCodeOld,Dict);
  oWriter.Write(Str);
  // Showmessage('Выводим: '+Str);
  // "СИМВОЛ = СТАРЫЙ_КОД"
  Symb:=chr(StrToInt(cCodeOld));
  // "WHILE входной поток не пуст DO"
  cCodeNew:=cCodeOld;
  while cCodeNew<>IntToStr(fwEOC) do begin
    //Showmessage('***'+cCodeNew+'***'+IntToStr(fwEOC)+'***');
    // "читать НОВЫЙ_КОД"
    cCodeNew:=o12to10v.Take(oReader);
    //ShowMessage('cCodeNew='+cCodeNew);
    if cCodeNew=IntToStr(fwEOC) then break;
    // "IF NOT в таблице перевода НОВЫЙ_КОД THEN"
    if Dict.Values[cCodeNew] = '' then begin
      //Showmessage('Нет нового кода '+cCodeNew);
      // "СТРОКА = перевести СТАРЫЙ_КОД"
      Str:=GetRecoverDict(cCodeOld,Dict);
      // "СТРОКА = СТРОКА+СИМВОЛ"
      Str:=Str+Symb;
      //Showmessage('СТРОКА+СИМВОЛ: '+Str);
    end
    else begin
      //Showmessage('Есть новый '+cCodeNew);
      // "СТРОКА = перевести НОВЫЙ_КОД"
      Str:=GetRecoverDict(cCodeNew,Dict);
    end;
    // "вывести СТРОКУ"
    oWriter.Write(Str);
    // Showmessage('Выводим: '+Str);
    // "СИМВОЛ = первый символ СТРОКИ"
    n:=Ord(Str[1]); Symb:=Char(n);
    // "добавить в таблицу перевода СТАРЫЙ_КОД+СИМВОЛ"
    cc:=IntToStr(NewCode)+'='+GetRecoverDict(cCodeOld,Dict)+Symb;
    AddaDiRecover(cc,Dict);
    // Задаем новый код, но чтобы не был нулевой по модулю 256
    // для того чтобы младшие 8 нулевых бит не получались для записи
    NewCode:=GenNewCode(NewCode);
    // "СТАРЫЙ_КОД = НОВЫЙ_КОД"
    cCodeOld:=cCodeNew;
  end;
  // Дописываем последний буфер в файл
  oWriter.Write(IntToStr(fwEOC));
  Showmessage(Recovered+' распакован!');
end;

end.

// ********************************************************* RecoverUni.pas ***

