// LAZARUS, WIN10\XP                                *** FidirCheckClass.pas ***

// ****************************************************************************
// * FidirCheck [120]                           Анализатор файлов и каталогов *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  05.03.2003
// Copyright © 2003 TVE, v3.2                        Посл.изменение: 18.08.2017

// Свойства
//
//   CheckDir - каталог, который проверяется анализатором

// Методы
//
//   -Log(cMessage:String) - записать новое сообщение;
//   -View - развернуть форму с сообщениями;

// Возвращаемые значения методов
//
//   -Result=0, метод завершен успешно

unit FidirCheckClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  TFidirCheck = class
  private
    // Хранители свойств класса
    FCheckDir: String;    // Контроллируемый каталог анализатора
    FFilesDir: Variant;   // Массив данных о файлах и каталогах
    // Внутренние элементы класса
    //-FLoger: TForm;
    //-FLogFile: TFileStream;    // Оперативный Log-файл
    //-cNameFile: String;        // Наименоваие оперативного Log-файла
    // Обслуживание свойства CheckDir
    procedure SetCheckDir(Value:String);
    function GetCheckDir:String;
    function GetFilesDir:Variant;
    // Обслуживание существования формы с сообщениями
    //procedure ViewOnActivateEvent(Sender: TObject);
    //procedure ViewOnCloseEvent(Sender: TObject; var Action: TCloseAction);
  //protected
    { Protected declarations }
  public
    constructor Create;
    destructor Destroy;
    function Make: Byte;
    function View: Byte;
  published
    property CheckDir:String read GetCheckDir write SetCheckDir;
    property FilesDir:Variant read GetFilesDir;
 end;


implementation

uses
  ArrayFrm,MakeFilesDirarrayUni;

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TFidirCheck.Create;
begin
  inherited;
end;

// ****************************************************************************
// *                            Уничтожить объект                             *
// ****************************************************************************
destructor TFidirCheck.Destroy;
begin
  inherited;
end;

// ****************************************************************************
// *            Выбрать в массив информацию о каталогах и файлах              *               *
// ****************************************************************************
function TFidirCheck.Make: Byte;
begin
  Result:=0;
  aCreate(FFilesDir);
  MakeFilesDirArray(FFilesDir,FCheckDir,FCheckDir);
  aSort(FFilesDir);
end;

// ****************************************************************************
// *              Показать выбранную информацию о файлах и каталогах          *
// ****************************************************************************
function TFidirCheck.View: Byte;
begin
  Result:=0;
  aSay(FFilesDir,FCheckDir);
end;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// Обеспечить доступ к свойству "Контроллируемый каталог анализатора"
procedure TFidirCheck.SetCheckDir(Value:String);
begin
  FCheckDir:=Value;
end;
function TFidirCheck.GetCheckDir:String;
begin
  Result:=FCheckDir;
end;

function TFidirCheck.GetFilesDir:Variant;
begin
  Result:=FFilesDir;
end;

end.

// **************************************************** FidirCheckClass.pas ***


