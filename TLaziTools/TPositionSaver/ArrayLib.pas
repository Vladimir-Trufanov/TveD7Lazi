// LAZARUS WIN10\XP                                        *** ArrayLib.pas ***

// ****************************************************************************
// *                  Обеспечить работу с вариантными t-массивами             *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  22.12.2005
// Copyright © 2005 TVE                              Посл.изменение: 11.08.2017

// Синтаксис
//
// type
//   FScan = function(var vElem:Variant): Boolean;
//   FSort = function(var vElem1,vElem2:Variant): Boolean;
//
//   function aAdd(var a:Variant; vElem:Variant): Byte;
//   function aCompare(var a1,a2:Variant): Boolean;
//   function aCreate(var a:Variant): Byte;
//   function aCutTail(var a:Variant): Byte;
//   function aLen(var a:Variant): Integer;
//   function aSay(var a:Variant; aName:String): Byte;
//   function aScan(var a:Variant; f:FScan): Integer;
//   function aSort(var a:Variant): Byte;

// Параметры
//
//   a - вариантный массив;
//   vElem - вариант, включаемый в массив;
//   aName - наименование массива;
//   f:Fscan - функция проверки элемента в массиве при его сканировании;
//   условию сортировки;
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
// Пример 1:
//
// // Найти заданный элемент в массиве
// function get7(var vElem:Variant):Boolean;
// begin
//   get7:=False;
//   if varType(vElem)<>varVarArray then
//     if VarToStr(vElem)='-7,45' then get7:=True;
// end;
//
// procedure TfrmKVSOL.Button1Click(Sender: TObject);
//
// const
//   varVarArray = 8204;  // Тип - вариантный массив
//
// var
//   a,a1,a2: Variant;
//   //nPoint: Integer;
//
// begin
//   aCreate(a);
//   aAdd(a,123);
//   //aAdd(a,True);
//   //aAdd(a,False);
//   aAdd(a,124);
//   aAdd(a,122);
//   aAdd(a,'121');
//   aAdd(a,'1216');
//   aAdd(a,'Привет!');
//   aAdd(a,'0Привет!');
//   aAdd(a,'Privet!');
//   aAdd(a,120);
//   //aAdd(a,True);
//   //aAdd(a,-7.45);
//   //a2:=VarArrayOf(['D1','DelphiDelphiDelphiDelphiDelphiDelphi','2.2','7']);
//   //a1:=VarArrayOf([1,'DelphiDelphiDelphiDelphiDelphiDelphiDelphi',a2,2.2,7]);
//   //aAdd(a,a1);
//   //nPoint:=aScan(a,get7);
//   //ShowMessage('nPoint: '+IntToStr(nPoint));
//   aAdd(a,125);
//   aAdd(a,124);
//   aSay(a,'aa');
//   aSort(a,sort7);
//   aSay(a,'as');
// end;
//
// Пример 2:
//
// // Проверить элементы массива для их сортировки
// function sort7(var vElem1,vElem2:Variant):Boolean;
// begin
//   sort7:=False;
//   if vElem1[0]<=vElem2[0] then sort7:=True
//   //if vElem1[0]>vElem2[0] then sort7:=True
//   //if VarToStr(vElem1[1])>VarToStr(vElem2[1]) then sort7:=True
// end;
//
// procedure TfrmKVSOL.Button1Click(Sender: TObject);
//
// var
//   a,a1,a2: Variant;
//  c: String;
//  n: Byte;
//
// begin
//   aCreate(a);
//   c:='Три';
//   n:=3;
//   aAdd(a,VarArrayOf([n,c]));
//   a2:=VarArrayOf([2,'Два']);
//   a1:=VarArrayOf([1,'Один']);
//   aAdd(a,a2);
//   aAdd(a,a1);
//   aSay(a,'aa');
//   aSort(a,sort7);
//   aSay(a,'as');
// end;

unit ArrayLib;

{$mode objfpc}{$H+}

interface

uses
  Variants,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

const
  tveNull = 'tveNull'; // начальное значение варианта
  varVarArray = 8204;  // тип - вариантный массив

type
  FScan = function(var vElem:Variant): Boolean;
  FSort = function(var vElem1,vElem2:Variant): Boolean;

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
  function aAdd(var a:Variant; vElem:Variant): Byte;
  // Создать вариантный t-массив
  function aCreate(var a:Variant):Byte;
  // Указать размер массива
  function aLen(var a:Variant): Integer;
  // Показать содержимое массива
  function aSay(var a:Variant; aName:String): Byte;
  // Упорядочить t-массив
  function aSort(var a:Variant): Byte;

implementation

{$R *.lfm}

uses
  IniMesLib;

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
procedure Say7(a:Variant; nLo,nMid,nHi:Integer);
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
  if VarType(vElem)<>varBoolean then
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
function aAdd(var a:Variant; vElem:Variant): Byte;
var
  n: Integer;
begin
  aAdd:=0;
  //Showmessage('VarType(vElem): '+IntToStr(VarType(vElem)));
  // Контроллируем ошибочный параметр и не включаем его в массив
  if (VarType(vElem)=varString)and(vElem=tveNull) then begin
    aAdd:=1;
    IniMessage(1,'Недопустимое значение для включения в массив','aAdd')
  end
  // Контроллируем передачу немассива
  else if not VarIsArray(a) then begin
    aAdd:=2;
    IniMessage(2,'Включение в еще не созданный массив','aAdd')
  end
  // Контроллируем неучтенный тип значения
  else if not isVarType(vElem) then begin
    aAdd:=3;
    IniMessage(3,'Неучтенный тип значения для включения в массив'+chr(13)+
      chr(10)+VarToStr(vElem)+'=>'+IntToStr(VarType(vElem)),'aAdd')
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
// *                           Создать вариантный t-массив                    *
// ****************************************************************************
function aCreate(var a:Variant):Byte;
begin
  aCreate:=0;
  a:=VarArrayCreate([1,1],varVariant);
  a[1]:=tveNull;
end;

// ****************************************************************************
// *                             Указать размер массива                       *
// ****************************************************************************
function aLen(var a:Variant): Integer;
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
      if aLen(a)<1 then ShowMessage(Caption+' не заполнен!')
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
  nNumb: Integer;
  cIndex: String;
  a1: Variant;
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
    else
      listbox1.Items.add('['+cIndex+']  '+VarToStr(a[nNumb]));
    inc(nNumb);
  end;
end;

// Пример 1'
//
{procedure TFrmDocsy.btnClick(Sender: TObject);
var a:Variant;
begin
  aCreate(a);
  aAdd(a,123);
  aAdd(a,124);
  aAdd(a,122);
  aAdd(a,121);
  aAdd(a,'119');
  aAdd(a,'1119');
  aSay(a,'Неотсортированный');
  aSort(a);
  aSay(a,'Отсортированный массив');
end;}

// ****************************************************************************
// *  Упорядочить участок вариантного массива v (l,h-границы участка массива) *
// ****************************************************************************
procedure qSort(var v:Variant; l,h:longint);
var i,j:longint;
    w,q:Variant;
begin
  i := l; j := h;
  q := v[(l+h) div 2];
  repeat
    while (v[i] < q) do inc(i);
    while (q < v[j]) do dec(j);
    if (i <= j) then
    begin
      w:=v[i]; v[i]:=v[j]; v[j]:=w;
      inc(i); dec(j);
    end;
  until (i > j);
  if (l < j) then qSort(v,l,j);
  if (i < h) then qSort(v,i,h);
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

// *********************************************************** ArrayLib.pas ***

