// LAZARUS, WIN10\XP                                  *** LempeZiwClass.pas ***

// ****************************************************************************
// * LempeZiw [130]                      Архиватор-подписант текстовых файлов *
// ****************************************************************************
{http://wiki.freepascal.org/File_Handling_In_Pascal/ru}

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  18.08.2017
// Copyright © 2017 tve                              Посл.изменение: 30.10.2017

// Свойства
//   Origin: String;      - Спецификация оригинального файла (путь+имя)
//   Compressed: String;  - Спецификация сжатого файла (путь+имя)
//   Recovered: String;   - Спецификация восстановленного файла (путь+имя)

// Методы
//   Compress: Byte;      // Заархивировать как подпись, файл FOrigin в файл FCompressed
//   Recover: Byte;       // Распаковать заархивированный файл
//   Compare: Integer;    // Сравнить оригинальный файл с распакованным после
//                        // сжатия до первого несовпадения ( <=2147483647 байт)

// Возвращаемые значения методов
//   Result=0, метод завершен успешно
//   Result>0 (Compare), произошло несовпадение между оригинальным файлом
//     и воспроизведенным на указанном порядковым номером через Result символе

unit LempeZiwClass;

{$mode objfpc}{$H+}

interface

uses
  LazitoolsOutfit,Math,
  ArrayFrm,Variants,Forms,
  Classes, SysUtils, Dialogs;

type
  TLempeZiw = class
  private
    // Хранители свойств класса
    FDict: TStringList;       // Словарь
    FOrigin: String;          // Спецификация оригинального файла (путь+имя)
    FCompressed: String;      // Спецификация сжатого файла (путь+имя)
    FRecovered: String;       // Спецификация восстановленного файла (путь+имя)
    FVersDate: String;        // Версия, учтенная дата модификации
    FViewCode: Integer;       // Способ представления кодов сжатого текста
    // Обслуживание свойств
    procedure SetOrigin(Value:String);
    function GetOrigin:String;
    procedure SetCompressed(Value:String);
    function GetCompressed:String;
    procedure SetRecovered(Value:String);
    function GetRecovered:String;
    function GetDict:TStringList;
    function GetVersDate: String;
  protected
    { Protected declarations }
  public
    constructor Create;
    destructor Destroy;
    // Сжать (заархивировать), как подпись, файл FOrigin в файл FCompressed
    function Compress: Byte;
    // Распаковать заархивированный файл
    function Recover: Byte;
    // Сравнить оригинальный файл с распакованным после сжатия
    function Compare: Integer;
  published
    property Origin:String read GetOrigin write SetOrigin;
    property Compressed:String read GetCompressed write SetCompressed;
    property Recovered:String read GetRecovered write SetRecovered;
    property Dictionary:TStringList read GetDict;
    property VersDate:String read GetVersDate;
end;


implementation

uses
  CompressUni,RecoverUni,ConvertUni;

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TLempeZiw.Create;
begin
  inherited;
  FVersDate:='v3.1,30.10.2017';
  // Устанавливаем представление кодов сжатого текста по умолчанию
  FViewCode:=vic12;
end;

// ****************************************************************************
// *                            Уничтожить объект                             *
// ****************************************************************************
destructor TLempeZiw.Destroy;
begin
  inherited;
end;

// ****************************************************************************
// *   Сжать (заархивировать), как подпись, файл FOrigin в файл FCompressed   *
// ****************************************************************************
function TLempeZiw.Compress: Byte;
begin
  Result:=MakeCompress(FOrigin,FCompressed,FDict,FViewCode);
end;

// ****************************************************************************
// *                   Распаковать заархивированный файл                      *
// ****************************************************************************
function TLempeZiw.Recover: Byte;
begin
  Result:=MakeRecover(FCompressed,FRecovered,FDict,FViewCode);
end;


// ****************************************************************************
// *          Сравнить оригинальный файл с распакованным после сжатия         *
// *                  до первого несовпадения ( <=2147483647 байт)            *
// ****************************************************************************
//
function TLempeZiw.Compare: Integer;
begin
  Result:=0;
end;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// Обеспечить доступ к свойству "Спецификация оригинального файла (путь+имя)"
procedure TLempeZiw.SetOrigin(Value:String);
begin
  FOrigin:=Value;
end;
function TLempeZiw.GetOrigin:String;
begin
  Result:=FOrigin;
end;

// Обеспечить доступ к свойству "Спецификация сжатого файла (путь+имя)"
procedure TLempeZiw.SetCompressed(Value:String);
begin
  FCompressed:=Value;
end;
function TLempeZiw.GetCompressed:String;
begin
  Result:=FCompressed;
end;

// Обеспечить доступ к свойству "Спецификация восстановленного файла (путь+имя)"
procedure TLempeZiw.SetRecovered(Value:String);
begin
  FRecovered:=Value;
end;
function TLempeZiw.GetRecovered:String;
begin
  Result:=FRecovered;
end;
// Обеспечить выборку словаря наружу
function TLempeZiw.GetDict:TStringList;
begin
  Result:=FDict;
end;
// Обеспечить доступ к свойству "Версия, учтенная дата модификации"
function TLempeZiw.GetVersDate:String;
begin
  Result:=FVersDate;
end;

end.
// ****************************************************** LempeZiwClass.pas ***


