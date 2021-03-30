// Lazarus 1.7  WINXP/10                                *** FilesDirUni.pas ***

// ****************************************************************************
// * FilesDir [0100]                    Анализатор файлов и каталогов системы *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  05.03.2017
// Copyright © 2017 TVE, v 1.1                       Посл.изменение: 26.03.2017

unit FilesDirUni;

{$mode objfpc}{$H+}

interface

uses
  Classes,FileUtil,SysUtils;

// Коды ошибок и сообщения
const
  State100MessageList =
  ' 101=Лимит не в диапазоне, число файлов/каталогов для поиска указано неверно'+
  ' 102=Неверное значение счетчика объектов,'+
  ' 103=Значение счетчика превысило лимит,'+
  '9999=Не найдено 100';

// Режимы поиска
const
  fdDir      = 1;        // просматривать названия каталогов
  fdFile     = 2;        // просматривать имена файлов
  fdFileDir  = 3;        // выбирать каталоги и файлы
  fdCalc     = 8;        // только считать каталоги и файлы
  fdLimit    = 1024;     // максимальное колич.объектов поиска (по умолчанию)

// Настройки анализатора файлов и каталогов системы
type
  RFilesDir = record
    Count: Integer;      // cчетчик найденных каталогов/файлов
    Comment: String;     // тексты комментариев и ошибок
    Limit: Integer;      // максимальное количество объектов для поиска
    Mode: Integer;       // режим поиска и выборки
  end;

// MakeFilesDirList: Получить список файлов и/или каталогов

// Возвращаемые значения
//   Result=n>0, обнаружено n объектов (файлов и/или каталогов), метод завершен
//   успешно. Max значение integer = 2147483647
//   Result=n<0, ошибка с кодом -n

function MakeFilesDirList(var oFilesDir:RFilesDir; cNames:TStringList;
    const cDir:String='/'): Integer;

implementation

var
  State: Integer;      // код ошибки (состояния действия) или сообщения

// ****************************************************************************
// *  Проверить соответствие режиму добавления, добавить строку в StringList  *
// *                      и увеличить значение счетчика                       *
// ****************************************************************************
procedure IncListAdd(var nCount:Integer; oCobox:TStringList; const cLine:String;
  niMode:Integer; nPosition:Integer);
var
  lMuster: Boolean;  // собирать, добавлять строки в TStringList
  nMode:Integer;
begin
  // Определяем - собирать имена или только считать
  lMuster:=true;
  nMode:=niMode;
  if nMode>fdCalc then begin
    nMode:=nMode-fdCalc;
    lMuster:=false;
  end;
  // Если передается имя файла, то в режимах {fdFile,fdFileDir} добавляем
  if ((nPosition=fdFile)and((nMode=fdFile)or(nMode=fdFileDir))) then begin
    inc(nCount); // переопределили количество объектов
    // При необходимости только считаем
    if lMuster then oCobox.Add(cLine); // поместили строку в StringList
  end
  // Если передается название каталога, то в соответствующих режимах добавляем
  else if (nPosition=nMode) then begin
    inc(nCount); // переопределили количество объектов
    // При необходимости только считаем
    if lMuster then oCobox.Add(cLine); // поместили строку в StringList
  end;
end;

// ****************************************************************************
// *                   Получить список файлов и/или каталогов                 *
// ****************************************************************************
function MakeFilesDirList(var oFilesDir:RFilesDir; cNames:TStringList;
  const cDir:String='/'): Integer;
var
  ifs: Integer;         // cтатус поиска каталога или файла
  fs: TSearchRec;       // "Поисковик" - объект для поиска каталогов и файлов
  cNewDir: String;
begin
  // Проверяем назначение лимита
  if not((oFilesDir.Limit>0)and(oFilesDir.Limit<=fdLimit)) then State:=-101
  // Проверяем определенность значения счетчика
  else if not((oFilesDir.Count>=0)and(oFilesDir.Count<=fdLimit+1)) then State:=-102
  // Выбираем список каталогов/файлов
  else begin
    State:=0;
    // Отмечаем в TStringList текущий "корневой" каталог
    IncListAdd(oFilesDir.Count,cNames,
      IntToStr(oFilesDir.Count+1)+'.D '+cDir,
      oFilesDir.Mode,fdFileDir);
    // Выходим на первый файл каталога
    ifs:=FindFirst(cDir+'*',faAnyFile and faDirectory,fs);
    // Заносим в TStringList файлы текущего "корневого" каталога
    while ifs=0 do begin
      // Пропускаем переходы на родительские каталоги
      if (fs.Name='.')or(fs.Name='..') then begin
        ifs:=FindNext(fs);
      end
      // Обрабатываем каталоги
      else begin
        // Выводим информацию по каталогу, когда выбираем только каталоги
        if (fs.Attr and faDirectory)=faDirectory then begin
          cNewDir:=cDir+fs.Name+'/';
          IncListAdd(oFilesDir.Count,cNames,
            IntToStr(oFilesDir.Count+1)+'.d '+cNewDir,
            oFilesDir.Mode,fdDir);

          // Рекурсивно разбираем текущий каталог в режиме fdFileDir
          if ((oFilesDir.Mode=fdFileDir)or(oFilesDir.Mode=fdCalc+fdFileDir))
          then MakeFilesDirList(oFilesDir,cNames,cNewDir);

          ifs:=FindNext(fs);
        end
        // Заносим информацию по файлам и считаем
        else begin
          IncListAdd(oFilesDir.Count,cNames,
            IntToStr(oFilesDir.Count+1)+'.'+IntToStr(ifs)+' '+
            cDir+fs.Name+', '+IntToStr(fs.Size),
            oFilesDir.Mode,fdFile);
          ifs:=FindNext(fs);
        end;
      end;
      // Отмечаем превышение счетчиком лимита
      if oFilesDir.Count>oFilesDir.Limit then begin
        oFilesDir.Count:=-103;
        break;
      end;
    end;
    State:=oFilesDir.Count;
    FindClose(fs);
  end;
  Result:=State;
end;

end.

// ******************************************************** FilesDirUni.pas ***

