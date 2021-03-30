// LAZARUS-1.2.4, WIN10\XP                                    *** Loger.pas ***

// ****************************************************************************
// * LOGER [0140]  Собиратель-трассировщик сообщений по выполненным действиям *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  05.03.2009
// Copyright © 2009 TVE                              Посл.изменение: 11.10.2016

// Свойства
//
//   FileName - наименование Log-файла
//   FSpecFolder - спец.папка, в которой формируется Log-файл


// Методы
//
//   Log(cMessage:String) - записать новое сообщение;

// Возвращаемые значения методов
//
//   Result=0,   метод завершен успешно
//   Result=141, 'Не удалось создать Log-файл!'
//   Result=142, 'Не открылся Log-файл!'
//   Result=143, 'Не добавилось сообщение в Log-файл!'

unit Loger;

{$mode objfpc}{$H+}

interface

uses
  Classes,SysUtils,windows;

type
  // Объявление класса
  TLoger = class{(TComponent)}
  private
    // Параметры свойств класса
    FFileName:  String;       // Наименование LOG-файла
    FSpecFolder: String;      // Спец.папка, в которой формируется Log-файл
    // Внутренние параметры класса
    FResult: Integer;         // Код завершения метода
    FResume: WideString;      // Резюмирующее сообщение
    FLogFile: TFileStream;    // Log-файл, как поток
    // Общие переменные класса
    cNameFile: String;        // Спецификациия (путь+наименование) Log-файла
    // Обслуживание свойств
    procedure SetFileName(Value:String);
    function GetFileName:String;
    procedure SetSpecFolder(Value:String);
    function GetSpecFolder:String;
    // Обслуживание Log-файлов
    function Open: Integer;
    function Close: Integer;
    function LogAddString(c:String):Integer;
    // Назначить спецификацию файла
    procedure AssignFileName;
    // Сформировать контрольный лог-файл в текущем каталоге
    procedure CtrlLoger(cCtrlString: String);
  protected
    { Protected declarations }
  public
    constructor Create(ciNameFile:String='');
    destructor Destroy; {override;}
    function Log(cMessage:String): Integer;
  published
    property FileName:String read GetFileName write SetFileName;
    property SpecFolder:String read GetSpecFolder write SetSpecFolder;
  end;

implementation

uses
  windirs;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

procedure TLoger.SetFileName(Value:String);
begin
  FFileName:=Value;
  AssignFileName;
end;
function TLoger.GetFileName:String;
begin
  Result:=FFileName;
end;

procedure TLoger.SetSpecFolder(Value:String);
begin
  FSpecFolder:=Value;
  AssignFileName;
end;
function TLoger.GetSpecFolder:String;
begin
  Result:=FSpecFolder;
end;

{  ................................. МЕТОДЫ ..................................}

// ****************************************************************************
// *           Сформировать контрольный лог-файл в текущем каталоге           *
// *           (жёсткая конструкция контрольная трассировки TLoger)           *
// ****************************************************************************
procedure TLoger.CtrlLoger(cCtrlString: String);
var
  s: String;
  oCtrlLoger: TFileStream;  // Контрольный лог-файл
begin
  s:=cCtrlString+#13+#10;
  if not FileExists('CtrlLoger.txt') then begin
    oCtrlLoger:=TFileStream.Create('CtrlLoger.txt',fmCreate);
    oCtrlLoger.Free;
  end;
  oCtrlLoger:=TFileStream.Create('CtrlLoger.txt',fmOpenWrite);
  oCtrlLoger.Seek(0,soFromEnd);
  oCtrlLoger.WriteBuffer(Pointer(s)^,Length(s));
  oCtrlLoger.Free;
end;

procedure iCtrlLoger(cCtrlString: String);
var
  s: String;
  oCtrlLoger: TFileStream;  // Контрольный лог-файл
begin
  s:=cCtrlString+#13+#10;
  if not FileExists('iCtrlLoger.txt') then begin
    oCtrlLoger:=TFileStream.Create('iCtrlLoger.txt',fmCreate);
    oCtrlLoger.Free;
  end;
  oCtrlLoger:=TFileStream.Create('iCtrlLoger.txt',fmOpenWrite);
  oCtrlLoger.Seek(0,soFromEnd);
  oCtrlLoger.WriteBuffer(Pointer(s)^,Length(s));
  oCtrlLoger.Free;
end;

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TLoger.Create(ciNameFile:String='');
begin
  // Принимаем указанную спецификацию файла
  if ciNameFile<>'' then begin
    FFileName:=ciNameFile;
    FSpecFolder:='';
    cNameFile:=ciNameFile;
  end
  // По умолчанию определяем имя файла трассировки,
  // как 'LogStream' в каталоге Application Data

  // 11.10.2016 Ранее предполагалось умалчиваемым каталогом файла трассировки
  // сделать CSIDL_APPDATA. Но получалось путь к каталогу Application Data для
  // службы не соответстует каталогу для пользователя
  // (например,XP: C:\Documents and Settings\LocalService\Application Data <==>
  // C:\Documents and Settings\User\Application Data)

  // По умолчанию определяем каталог файла трассировки CSIDL_PROGRAM_FILES_COMMON,
  // то есть для XP "C:\Program Files\Common Files\"
  else begin
    FFileName:='LogStream';
    FSpecFolder:=''; //GetWindowsSpecialDir(CSIDL_PROGRAM_FILES_COMMON);
    AssignFileName;
  end;
  // Контроллируем создание объекта класса
  // CtrlLoger(FSpecFolder+FFileName);
end;

// ****************************************************************************
// *                               Уничтожить объект                          *
// ****************************************************************************
destructor TLoger.Destroy;
begin
  //inherited;
end;

// ****************************************************************************
// *                       Назначить спецификацию файла                       *
// ****************************************************************************
procedure TLoger.AssignFileName;
begin
  cNameFile:=FSpecFolder+FFileName+'.txt';
end;

// ****************************************************************************
// *                    Подключиться к Log-файлу и открыть его                *
// ****************************************************************************
function TLoger.Open: Integer;
begin
  Result:=0; FResume:='Успешно!';
  // Если Log-файла не было, то создаем его
  try
    if not FileExists(cNameFile) then begin
      FLogFile:=TFileStream.Create(cNameFile,fmCreate);
      FLogFile.Free;
    end;
    // Открываем существующий log-файл для записи
    try
      FLogFile:=TFileStream.Create(cNameFile,fmOpenWrite);
    except
      // on E:Exception do iCtrlLoger('142. Exception: '+E.Message);
      // on E:Exception do CtrlLoger('142. Exception: '+E.Message);
      Result:=142;
      FResume:='Не открылся Log-файл: '+cNameFile+'!';
      CtrlLoger(IntToStr(Result)+'^ '+FResume);
      FLogFile.Free;
    end;
  except
    Result:=141;
    FResume:='Не удалось создать Log-файл: '+cNameFile+'!';
    CtrlLoger(IntToStr(Result)+'^ '+FResume);
    FLogFile.Free;
  end;
end;

// ****************************************************************************
// *                               Закрыть Log-файл                           *
// ****************************************************************************
function TLoger.Close: Integer;
begin
  Result:=0;
  FLogFile.Free;
end;

// ****************************************************************************
// *                     Занести строку сообщения  в Log-файл                 *
// ****************************************************************************
function TLoger.LogAddString(c:String): Integer;
var s: String;
begin
  // Подвешиваем префикс и конец строки к сообщению
  s:=FormatDateTime('dd.mm.yyyy,hh:nn:ss ',Now)+c;
  s:=s+#13+#10;
  try
    // Открываем файл
    Result:=Open;
    // Заносим строку в Log-файл
    if Result=0 then begin
      FLogFile.Seek(0,soFromEnd);
      FLogFile.WriteBuffer(Pointer(s)^,Length(s));
      Close;
    end;
  except
    Result:=143;
    FResume:='Не добавилось сообщение в Log-файл'+'!';
    CtrlLoger(IntToStr(Result)+'^ '+FResume);
  end;
end;

// ****************************************************************************
// *            Занести новое сообщение в файл трассировки сообщений          *
// ****************************************************************************
function TLoger.Log(cMessage:String): Integer;
var cOut: String;
begin
  cOut:=cMessage;
  Result:=LogAddString(cOut);
end;

end.

// ************************************************************** Loger.pas ***

