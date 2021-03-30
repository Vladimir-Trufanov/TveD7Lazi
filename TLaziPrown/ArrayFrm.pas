// LAZARUS WIN10\XP                                        *** ArrayFrm.pas ***

// ****************************************************************************
// * TLaziPrown [1000]            Обеспечить работу с вариантными t-массивами *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  22.12.2005
// Copyright © 2005 TVE                              Посл.изменение: 05.09.2017

// Синтаксис
{
  // Добавить элемент в вариантный массив
  function aAdd(var a:Variant; vElem:Variant): Byte;
  // Сравнить t-массивы
  function aCompare(var a1,a2:Variant): Boolean;
  // Создать вариантный t-массив
  function aCreate(var a:Variant):Byte;
  // Отрезать последний элемент массива
  function aCutTail(var a:Variant): Byte;
  // Указать размер массива
  function aLen(var a:Variant): longint;
  // Показать содержимое массива
  function aSay(var a:Variant; aName:String): Byte;
  // Найти значение в неупорядоченном вариантном массиве и определить позицию
  function aScan(var a:Variant; v:Variant):longint;
  // Упорядочить t-массив
  function aSort(var a:Variant): Byte;
}
// Параметры
//
//   a,a1,a2 - вариантные массивы;
//   vElem - вариант, включаемый в массив;
//   aName - наименование массива;
//   v - значение элемента в массиве
//
// Возвращаемые значения
//
//   aAdd=0, Функция выполнена успешно;
//   aAdd=1, 'Недопустимое значение для включения в массив';
//   aAdd=2, 'Включение в еще не созданный массив';
//   aAdd=3, 'Неучтенный тип значения для включения в массив';
//
//   aCreate=0, Функция выполнена успешно;
//
//   aSay=0, Функция выполнена успешно;
//
//   aScan=nPoint, найдено данное значение у элемента массива с номером nPoint
//   aScan=0, Функция выполнена успешно;
//
//   aSort=0, Функция выполнена успешно;
//   aSort=1, 'Нижний параметр вне границ массива';
//   aSort=2, 'Верхний параметр вне границ массива'
//

unit ArrayFrm;

{ Пример:

procedure TFrmDocsy.btnClick(Sender: TObject);
var a:Variant;
begin
  // Формируем неупорядоченный массив
  aCreate(a);
  aAdd(a,123);
  aAdd(a,124);
  aAdd(a,122);
  aAdd(a,121);
  aAdd(a,'119');
  aAdd(a,'1119');
  aSay(a,'Неотсортированный');
  // Ищем элемент в массиве
  nPoint:=aScan(a,119);
  if nPoint>0 then ShowMessage('Элемент 119 на '+
    IntToStr(nPoint)+' месте в массиве!');
  nPoint:=aScan(a,120);
  if nPoint=0 then ShowMessage('Элемент 120 в массиве не найден!');
  // Сортируем массив
  aSort(a);
  aSay(a,'Отсортированный массив');
end;
// Формируем и сравниваем два массива
aCreate(a1);
aAdd(a1,'qwe');
aAdd(a1,'123');
aAdd(a1,'ячс');
aCreate(a2);
aAdd(a2,'qwe');
aAdd(a2,'123');
aAdd(a2,'ячс');
if aCompare(a1,a2) then ShowMessage('Массивы равны');
aSay(a2,'1');
a2[2]:=123;
aSay(a2,'2');
if not aCompare(a1,a2) then ShowMessage('Массивы НЕ равны');
// Отрезаем последний элемент массива
aCutTail(a2);
aSay(a2,'Отрезан третий элемент');
}

{$mode objfpc}{$H+}

interface

uses
  Variants,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

const
  tveNull = 'tveNull'; // начальное значение варианта
  varVarArray = 8204;  // тип - вариантный массив

type

  { TfrmArray }

  TfrmArray = class(TForm)
    lb: TListBox;
  private
    function
      UpdateListbox(listbox1:TListBox; var a:Variant; ciIndex:String): Byte;
  public
    { public declarations }
  end;

  // Добавить элемент в вариантный массив
  function aAdd(var a:Variant; vElem:Variant): Integer;
  // Сравнить t-массивы
  function aCompare(var a1,a2:Variant): Boolean;
  // Создать вариантный t-массив
  function aCreate(var a:Variant):Byte;
  // Отрезать последний элемент массива
  function aCutTail(var a:Variant): Integer;
  // Указать размер массива
  function aLen(var a:Variant): Integer;
  // Показать содержимое массива
  function aSay(var a:Variant; aName:String): Byte;
  // Найти значение в неупорядоченном вариантном массиве и определить позицию
  function aScan(var a:Variant; v:Variant):longint;
  // Упорядочить t-массив
  function aSort(var a:Variant): Byte;

implementation

{$R *.lfm}

uses
  TellmeFrm,LaziprownAlerts;

// ****************************************************************************
// *                  Проверить отсортированность элементов                   *
// ****************************************************************************
function Sort7(var vElem1,vElem2:Variant):Boolean;
begin
  // ShowMessage('Sort7: '+VarToStr(vElem1)+'<='+VarToStr(vElem2));
  Sort7:=False;
  if vElem1<=vElem2 then Sort7:=True
end;

// ****************************************************************************
// *                    Показать низ, середину и верх массива                 *
// ****************************************************************************
procedure Say7(a:Variant; nLo,nMid,nHi:longint);
begin
  ShowMessage('Say7: '+
    'a['+IntToStr(nLo)+']='+VarToStr(a[nLo])+' '
    );
end;

// ****************************************************************************
// *       Проверить учтенность типа элемента, вкладываемого в массив         *
// ****************************************************************************
function isVarType(var vElem:Variant): Boolean;
begin
  isVarType:=True;
  //if VarType(vElem)<>varBoolean then
  if VarType(vElem)<>varByte then
  if VarType(vElem)<>varCurrency then
  if VarType(vElem)<>varDate then
  if VarType(vElem)<>varDouble then
  if VarType(vElem)<>varEmpty then
  if VarType(vElem)<>varInteger then
  if VarType(vElem)<>varLongWord then
  if VarType(vElem)<>varNull then
  if VarType(vElem)<>varOleStr then
  if VarType(vElem)<>varString then
  if VarType(vElem)<>varVarArray then
  if VarType(vElem)<>varWord then
  if VarType(vElem)<>varshortint then
    isVarType:=False;
end;

// ****************************************************************************
// *                  Добавить элемент в вариантный массив                    *
// ****************************************************************************
function aAdd(var a:Variant; vElem:Variant): Integer;
var
  n: Integer;
begin
  aAdd:=0;
  // Showmessage('VarType(vElem): '+IntToStr(VarType(vElem)));
  // Контроллируем ошибочный параметр и не включаем его в массив
  if (VarType(vElem)=varString)and(vElem=tveNull) then begin
    aAdd:=1001; Tellme(arrInvalidIncludeArray,aAdd);
  end
  // Контроллируем передачу немассива
  else if not VarIsArray(a) then begin
    aAdd:=1002; Tellme(arrIncluArrayNotCreated,aAdd);
  end
  // Контроллируем неучтенный тип значения
  else if not isVarType(vElem) then begin
    aAdd:=1003;
    Tellme(Format(arrUnrecognizeIncluArray,[VarToStr(vElem),IntToStr(VarType(vElem))]),aAdd);
  end
  else begin
    n:=VarArrayHighBound(a,1);
    // Если передается первый элемент, то будем замещать начальное значение
    if (VarType(a[1])=varOleStr)and(a[1]=tveNull) then a[1]:=vElem
    // Иначе увеличиваем размерность массива
    else begin
      inc(n);
      VarArrayRedim(a,n);
      a[n]:=vElem;
    end;
  end;
end;

// ****************************************************************************
// *                              Сравнить t-массивы                          *
// ****************************************************************************
function aCompare(var a1,a2:Variant): Boolean;
var
  i: Integer;
begin
  Result:=False;
  if (not VarIsArray(a1))and(not VarIsArray(a2)) then Result:=True
  else if (VarIsArray(a1))and(VarIsArray(a2)) then begin
    if aLen(a1)=aLen(a2) then begin
      // Сравниваем элементы по одному
      i:=1;
      while i<=aLen(a1) do begin
        // Вначале типы
        if VarType(a1[i])<>VarType(a2[i]) then break;
        // Затем значения
        if a1[i]<>a2[i] then break;
        inc(i);
      end;
      // Если все элементы совпали, то отмечаем это
      if i>aLen(a1) then Result:=True;
    end;
  end;
end;

// ****************************************************************************
// *                           Создать вариантный t-массив                    *
// ****************************************************************************
function aCreate(var a:Variant):Byte;
begin
  aCreate:=0;
  a:=VarArrayCreate([1,1],varVariant);
  a[1]:=tveNull;
end;
// ****************************************************************************
// *                      Отрезать последний элемент массива                  *
// ****************************************************************************
function aCutTail(var a:Variant): Integer;
var
  n: Integer;
begin
  aCutTail:=0;
  // Контроллируем наличие элемента в массиве для снятия
  if aLen(a)<1 then begin
    aCutTail:=1004; Tellme(arrNoItemsInArray,aCutTail);
  end
  // Отрезаем последний элемент массива
  else begin
    n:=VarArrayHighBound(a,1);
    if n>1 then begin
      dec(n);
      VarArrayRedim(a,n);
    end
    else a[1]:=tveNull;
  end;
end;

// ****************************************************************************
// *                             Указать размер массива                       *
// ****************************************************************************
function aLen(var a:Variant): longint;
begin
  //ShowMessage(IntToStr(Integer(VarType(a[1]))));
  if not VarIsArray(a) then aLen:=0
  else if ((VarType(a[1])=varString) or (VarType(a[1])=varOleStr))
    and (a[1]=tveNull) then aLen:=0
  else aLen:=VarArrayHighBound(a,1);
end;

// ****************************************************************************
// *                          Показать содержимое массива                     *
// ****************************************************************************
function aSay(var a:Variant; aName:String): Byte;
var
  frmArray: TfrmArray;
begin
  aSay:=0;
  frmArray:=TfrmArray.Create(Application);
  try
    with frmArray do begin
      Caption:='Массив: '+aName;
      // Если массив пустой, то просто выводим сообщение
      if aLen(a)<1 then Tellme(Format(arrArrayNotFill,[aName]),1007)
      // Если массив заполнен, то показываем содержимое массива
      else begin
        lb.Items.Clear;
        UpdateListbox(lb,a,tveNull);
        ShowModal;
      end;
    end;
  finally
    if Assigned(frmArray) then frmArray.Free;
  end;
end;

// Вывести содержимое массива в ListBox
function TfrmArray.
  UpdateListbox(listbox1:TListBox; var a:Variant; ciIndex:String): Byte;
var
  nNumb,i: Integer;
  cIndex: String;
  a1: Variant;
  s:AnsiString;
begin
  UpdateListBox:=0;
  nNumb:=VarArrayLowBound(a,1);
  while nNumb<=VarArrayHighBound(a,1) do begin
    if ciIndex=tveNull then cIndex:=IntToStr(nNumb)
      else cIndex:=ciIndex+','+IntToStr(nNumb);
    if varType(a[nNumb])=varVarArray then begin
      listbox1.Items.add('['+cIndex+']  '+'<< VarArray >>');
      a1:=a[nNumb];
      UpdateListbox(listbox1,a1,cIndex);
    end
    else begin
      s:=VarToStr(a[nNumb]);
      listbox1.Items.add('['+cIndex+']  '+s);
    end;
    inc(nNumb);
  end;
end;

// ****************************************************************************
// *           Найти значение в неупорядоченном вариантном массиве            *
// *                        и определить его позицию                          *
// ****************************************************************************
function aScan(var a:Variant; v:Variant):longint;
var
  nPoint: longint;
begin
  aScan:=0;
  nPoint:=1;
  while nPoint<=VarArrayHighBound(a,1) do begin
    if a[nPoint]=v then begin
      aScan:=nPoint;
      break;
    end;
    inc(nPoint);
  end;
end;

// ****************************************************************************
// *  Упорядочить участок вариантного массива v (l,h-границы участка массива) *
// ****************************************************************************
function qSort(var a:Variant; l,h:longint): Byte;
var i,j:longint;
    w,q:Variant;
begin
  // Выполняем контроли по границам массивов
  if not ((l>=VarArrayLowBound(a,1))
  and (l<=VarArrayHighBound(a,1))) then begin
    Result:=1005; Tellme(arrLowerParameterOutside,Result);
  end
  else if not ((h>=VarArrayLowBound(a,1))
  and(h<=VarArrayHighBound(a,1))) then begin
    Result:=1006; Tellme(arrUpperParameterOutside,Result);
  end
  // С границами нормально, сортируем массив
  else begin
    Result:=0;
    i := l; j := h;
    q := a[(l+h) div 2];
    repeat
      while (a[i] < q) do inc(i);
      while (q < a[j]) do dec(j);
      if (i <= j) then
      begin
        w:=a[i]; a[i]:=a[j]; a[j]:=w;
        inc(i); dec(j);
      end;
    until (i > j);
    if (l < j) then qSort(a,l,j);
    if (i < h) then qSort(a,i,h);
  end;
end;

// ****************************************************************************
// *                            Упорядочить t-массив                          *
// ****************************************************************************
function aSort(var a:Variant):Byte;
begin
  aSort:=0;
  qSort(a,VarArrayLowBound(a,1),VarArrayHighBound(a,1));
end;

end.

// *********************************************************** ArrayFrm.pas ***

