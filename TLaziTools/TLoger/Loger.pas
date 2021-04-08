unit Loger;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF win32}
     Dialogs,WinDirs,
  {$ENDIF}
  Classes,SysUtils;
type
  TLoger = class(TComponent)
  private
    // Параметры класса
    FFileName: String;        // Наименование LOG-файла
    FDirName: String;         // Папка, в которой формируется Log-файл
    FLogFile: TFileStream;    // Log-файл, как поток
    // Внутренние параметры класса
    //FResult: Integer;         // Код завершения метода
    //FResume: String;          // Резюмирующее сообщение
    cNameFile: String;        // Спецификациия (путь+наименование) Log-файла
    // Закрыть Log-файл
    function Close: Integer;
    // Получить наименование каталога, c которого запущена внешняя программа
    function ExePath(): widestring;
    // Занести строку сообщения  в Log-файл
    function LogAddString(c:String):Integer;
    // Подключиться к Log-файлу и открыть его
    function Open:Integer;
  public
    constructor Create(ciNameDir:PChar=''; ciNameFile:PChar='');
    destructor Destroy; override;
    // Занести новое сообщение в файл трассировки сообщений
    function Log(cMessage:PChar):Integer;
  published
    //property SomeVar: integer read GetSomeVar write SetSomeVar default 0;
  end;


implementation

// ---------------------------------------------------- Публичные методы класса

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TLoger.Create(ciNameDir:PChar=''; ciNameFile:PChar='');
begin
  // Рекомендуется использовать папку CSIDL_PROGRAM_FILES_COMMON для файла
  // трассировки, то есть для XP "C:\Program Files\Common Files\"
  {$IFDEF win32}
    FDirName:=GetWindowsSpecialDir(CSIDL_PROGRAM_FILES_COMMON);
  {$ENDIF}
  // Если каталог для размещения Log-файла не задан, то выбираем каталог,
  // из которого запущено внешнее приложение
  if ciNameDir='' then FDirName:=ExePath
  // Иначе настраиваемся на заданный каталог
  // (здесь обыграть возможные ошибки)
  else FDirName:=ciNameDir;
  //FDirName:='\Storage Card\';
  if ciNameFile='' then FFileName:='LogStream.txt';
  cNameFile:=FDirName+FFileName;
  //cNameFile:='Storage Card\LogStream.txt';
end;

// Получить наименование каталога,
// с которого запущена программа
function TLoger.ExePath(): widestring;
var Str: widestring;
  I: Integer;
begin
  Str := ParamStr (0);
  for I := Length (Str) downto 1 do
    if Str[I] = '\' then
    begin
      Str := Copy (Str, 1, I);
      Break;
    end; {if}
  Result := Str;
end;


// ****************************************************************************
// *                               Уничтожить объект                          *
// ****************************************************************************
destructor TLoger.Destroy;
begin
  inherited;
end;

// ****************************************************************************
// *            Занести новое сообщение в файл трассировки сообщений          *
// ****************************************************************************
function TLoger.Log(cMessage:PChar):Integer;
var cOut: String;
begin
  cOut:=cMessage;
  cOut:=ExePath+' +*-';
  Result:=LogAddString(cOut);
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
  // Открываем файл
  Result:=Open;
  // Заносим строку в Log-файл
  if Result=0 then begin
    FLogFile.Seek(0,soFromEnd);
    FLogFile.WriteBuffer(Pointer(s)^,Length(s));
    Close;
  end;
end;

// ****************************************************************************
// *                    Подключиться к Log-файлу и открыть его                *
// ****************************************************************************
function TLoger.Open: Integer;
begin
  Result:=0;
  // Если Log-файла не было, то создаем его
  if not FileExists(cNameFile) then begin
    FLogFile:=TFileStream.Create(cNameFile,fmCreate);
    FLogFile.Free;
  end;
  // Открываем существующий log-файл для записи
  FLogFile:=TFileStream.Create(cNameFile,fmOpenWrite);
end;

// ****************************************************************************
// *                               Закрыть Log-файл                           *
// ****************************************************************************
function TLoger.Close: Integer;
begin
  Result:=0;
  FLogFile.Free;
end;





end.

