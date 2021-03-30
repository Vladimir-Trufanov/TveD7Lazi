// LAZARUS, WIN10\XP                                *** FileReaderClass.pas ***

// ****************************************************************************
// * FileReader [150]           Класс побайтового чтения из файла через буфер *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  08.10.2017
// Copyright © 2017 TVE                              Посл.изменение: 25.10.2017

// Свойства
//
//   FileName:String - имя файла для побайтового чтения;
//   Path:String - путь к файлу;

// Метод
//
//   ReadChar(var Symb:Char):Byte - выдать очередной символ из файла;

// Возвращаемые значения метода
//
//   Result=0, когда символ выбран успешно
//   Result=-2, символ не считан, так как файл закончился

unit FileReaderClass;

{$mode objfpc}{$H+}

interface

uses
  LazitoolsOutfit,
  Classes,SysUtils,Dialogs;

type
  TFileReader = class
  private
    // Хранители свойств класса
    FFileName: String;        // Имя файла
    FPath: String;            // Путь к файлу
    FVersDate: String;        // Версия, учтенная дата модификации
    // Внутренние переменные класса
    FileStream: TFileStream;  // Поток файла
    ChrBuffer: array [0..ReadBuffer-1] of char;  // Буфер чтения из файла
    TotalBytesRead: Integer;  // Считано символов на данный момент
    lFirst: Boolean;          // True - ожидается первый символ для ReadChar
    Position: Integer;        // Позиция очередного символа в буфере
    BytesRead: Integer;       // Количество считанных символов в буфер
    cFile: String;            // Спецификация файла (путь+имя)
    // Обслуживание свойств
    procedure SetFileName(Value: String);
    function GetFileName: String;
    procedure SetPath(Value: String);
    function GetPath: String;
    function GetVersDate: String;
  protected
  public
    constructor Create;
    destructor Destroy;
    // Выдать очередной байт из файла
    function ReadChar(var Symb:Char):Byte;
  published
    property FileName:String read GetFileName write SetFileName;
    property Path:String read GetPath write SetPath;
    property VersDate:String read GetVersDate;
  end;

implementation

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TFileReader.Create;
begin
  inherited;
  FVersDate:='v3.1,25.10.2017';
  // Сбрасываем путь и имя файла
  FPath:=''; FFileName:='FileRead';
  // Ждём первый символ (для ReadChar)
  lFirst:=True;
  // Инициируем общее количество считанных символов
  TotalBytesRead:=0;
  // Указываем позицию чтения первого символа из буфера
  Position:=0;
end;

// ****************************************************************************
// *                            Уничтожить объект                             *
// ****************************************************************************
destructor TFileReader.Destroy;
begin
  FileStream.Free;
  inherited;
end;

// ****************************************************************************
// *                       Выдать очередной байт из файла                     *
// ****************************************************************************
function TFileReader.ReadChar(var Symb:Char):Byte;
var
  i: Integer; c:Char;

// Собственно считать символ из буфера, передвинуть указатель символа по буферу
// и по файлу
function _ReadChar(var Symb:Char):Byte;
begin
  Symb:=Char(ChrBuffer[Position]);
  Result:=frOK;
  // Отмечаем общее количество считанных символов
  TotalBytesRead:=TotalBytesRead+1;
  // Перемещаемся на след символ в буфере
  Position:=Position+1;

  // Showmessage('_ReadChar='+IntToStr(ord(Symb)));

end;

begin
  // Если первый раз запускается метод, то выполняем настройки на чтение файла
  // и делаем первое чтение
  if lFirst then begin
    if FPath='' then cFile:=FFileName
    else cFile:=FPath+'/'+FFileName;
    // Инициируем поток входных символов
    FileStream:=TFileStream.Create(cFile,fmOpenRead);
    // Отмечаем, что настройки к первому символу сделаны
    lFirst:=False;
    // Делаем первое считывание из файла в буфер
    BytesRead:=FileStream.Read(ChrBuffer,sizeof(ChrBuffer));
  end;

  // Трассируем выполнение считывания на входе
  // Showmessage('НА ВХОДЕ: '+
  //   'Position='+IntToStr(Position)+' TotalBytesRead='+IntToStr(TotalBytesRead)+' '+
  //   'FileStream.Size='+IntToStr(FileStream.Size));

  // Возвращаем символ из буфера с учетом в последнем чтении из файла
  // количества считанных в буфер символов
  if Position<BytesRead then begin
    Result:=_ReadChar(Symb);
  end
  // Если заехали за размер считанного буфер, делаем новое чтение из файла
  // и считываем символы, пока количество считанных данных меньше размера файла
  else if TotalBytesRead<FileStream.Size then begin
    BytesRead:=FileStream.Read(ChrBuffer,sizeof(ChrBuffer));
    // Настраиваемся на чтение первого символа из буфера
    Position:=0;
    Result:=_ReadChar(Symb);
  end
  // Иначе отмечаем конец файла и закрываем поток
  else begin
    Result:=frEOF; Symb:=chr(0); destroy;
  end;

  // Трассируем выполнение считывания
  // Showmessage('Symb='+IntToStr(ord(Symb))+' Result='+IntToStr(Result));
end;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// Обеспечить доступ к свойству "Имя файла"
procedure TFileReader.SetFileName(Value:String);
begin
  FFileName:=Value;
end;
function TFileReader.GetFileName:String;
begin
  Result:=FFileName;
end;
// Обеспечить доступ к свойству "Путь к файлу"
procedure TFileReader.SetPath(Value:String);
begin
  FPath:=Value;
end;
function TFileReader.GetPath:String;
begin
  Result:=FPath;
end;
// Обеспечить доступ к свойству "Версия, учтенная дата модификации"
function TFileReader.GetVersDate:String;
begin
  Result:=FVersDate;
end;

end.

// **************************************************** FileReaderClass.pas ***

