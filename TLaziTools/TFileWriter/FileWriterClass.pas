// LAZARUS, WIN10\XP                                *** FileWriterClass.pas ***

// ****************************************************************************
// * FileWriter [160]        Класс побайтовой записи строк в файл через буфер *
// ****************************************************************************

// Автор: Труфанов В.Е.                              Дата создания:  08.10.2017
// Copyright © 2017 tve                              Посл.изменение: 27.10.2017

// Свойства
//
//   FileName:String - имя файла;
//   Path:String - путь к файлу;

// Методы
//
//   Write(Str:String):Byte - передать строку в файл (в буфер)
//   Close:Byte - записать последний кусочек буфера и закрыть поток файла

//   Важно: метод Close в необходимых случаях (например, LempeZiwClass) может
//   быть вызван автоматически методом Write, когда поступает признак завершения
//   потока символов - fwEOC = "-2"

// Возвращаемые значения методов
//
//   Result=0, метод завершился успешно

unit FileWriterClass;

{$mode objfpc}{$H+}

interface

uses
  ConvertUni,LazitoolsOutfit,
  Classes,Dialogs,SysUtils;

type
  TFileWriter = class
  private
    // Хранители свойств класса
    FFileName: String;        // Имя файла
    FPath: String;            // Путь к файлу
    FVersDate: String;        // Версия, учтенная дата модификации
    // Внутренние переменные класса
    FileStream: TFileStream;  // Поток файла
    ChrBuffer: array [0..BufferSize-1] of char;  // Буфер чтения из файла
    lFirst: Boolean;          // True - ожидается занесение первой строки
    cFile: String;            // Спецификация файла (путь+имя)
    Position: Integer;        // Позиция очередного символа в буфере
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
    // Передать строку в файл (в буфер)
    function Write(Str:String): Byte;
    // Записать последний кусочек буфера и закрыть поток файла
    function Close: Byte;
  published
    property FileName:String read GetFileName write SetFileName;
    property Path:String read GetPath write SetPath;
    property VersDate:String read GetVersDate;
  end;

implementation

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TFileWriter.Create;
begin
  inherited;
  FVersDate:='v2.1,27.10.2017';
  FPath:=''; FFileName:='';
  // Ждём первый символ
  lFirst:=True;
end;

// ****************************************************************************
// *                            Уничтожить объект                             *
// ****************************************************************************
destructor TFileWriter.Destroy;
begin
  Close;
  inherited;
end;


// ****************************************************************************
// *                 Передать строку в файл (в буфер)                         *
// ****************************************************************************
function TFileWriter.Write(Str:String): Byte;
var
  nPreSize: Integer;   // Предварительный размер заполненного буфера
  nDelta: Integer;     // Число байт превышения буфера, что перенести в след.буфер
  cStr: String;
begin
  Result:=0;
  // Если первый раз запускается метод, то выполняем настройки записи в файл
  if lFirst then begin
    if FPath='' then cFile:=FFileName
    else cFile:=FPath+'/'+FFileName;
    // Инициируем поток выходных символов
    FileStream:=TFileStream.Create(cFile,fmCreate);
    // Инициализируем заполнение буфера
    ChrBuffer:=''; Position:=0;
    // Отмечаем, что настройки к первому символу сделаны
    lFirst:=False;
  end;
  // Вызываем метод Close, если поступает признак завершения потока символов:
  // fwEOC = "-2" (если поступает отдельной строкой)
  if Str=IntToStr(fwEOC) then Close else begin
    // Определяем предварительный размер заполняемого буфера
    nPreSize:=Length(String(ChrBuffer))+length(Str);
    // Если за размер буфера не выходим, то дозаполняем буфер новой строкой
    if nPreSize<BufferSize then begin
      ChrBuffer:=ChrBuffer+Str;
      Position:=Position+Length(Str);
      //Showmessage(CP1251ToUTF8('Write: Str:'+Str+'***'));
    end
    else if nPreSize=BufferSize then begin
      ChrBuffer:=ChrBuffer+Str;
      Position:=Position+Length(Str);
      FileStream.Write(ChrBuffer,sizeof(ChrBuffer));
      ChrBuffer:=''; Position:=0;
    end
    // Если превышаем размер буфера, то неполной строкой дозаполняем буфер,
    // записываем буфер в файл и оставшимся кусочком строки начинаем новый буфер
    else begin
      nDelta:=nPreSize-BufferSize;
      // Выбираем, что занести в текущий буфер
      cStr:=Copy(Str,1,(Length(Str)-nDelta));
      ChrBuffer:=ChrBuffer+cStr;
      // Трассируем заполнение текущего буфера
      // Showmessage(CP1251ToUTF8('Delta='+IntToStr(nDelta)+' '+
      //   'Old ChrBuffer='+ChrBuffer+' ['+cStr+']'));
      FileStream.Write(ChrBuffer,sizeof(ChrBuffer));
      // Начинаем новый буфер
      cStr:=Copy(Str,(Length(Str)-nDelta)+1,MaxInt);
      ChrBuffer:=cStr; Position:=Length(cStr);
      // Трассируем начало нового буфера
      // Showmessage(CP1251ToUTF8('New ChrBuffer='+ChrBuffer));
    end;
  end;
end;

// ****************************************************************************
// *         Записать последний кусочек буфера и закрыть поток файла          *
// ****************************************************************************
function TFileWriter.Close: Byte;
begin
  Result:=0;
  // Дописываем кусочек заполненного буфера
  FileStream.Write(ChrBuffer,Position);
  ChrBuffer:=''; Position:=0;
  // Удаляем поток
  FileStream.Destroy;
end;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// Обеспечить доступ к свойству "Имя файла"
procedure TFileWriter.SetFileName(Value:String);
begin
  FFileName:=Value;
end;
function TFileWriter.GetFileName:String;
begin
  Result:=FFileName;
end;
// Обеспечить доступ к свойству "Путь к файлу"
procedure TFileWriter.SetPath(Value:String);
begin
  FPath:=Value;
end;
function TFileWriter.GetPath:String;
begin
  Result:=FPath;
end;
// Обеспечить доступ к свойству "Версия, учтенная дата модификации"
function TFileWriter.GetVersDate:String;
begin
  Result:=FVersDate;
end;

end.

// **************************************************** FileWriterClass.pas ***

