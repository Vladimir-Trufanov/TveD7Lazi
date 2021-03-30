// LAZARUS WIN10\XP                                  *** ProbaLaPr01Frm.pas ***

// ****************************************************************************
// *                    Первый блок тестов библиотеки TLaziPrown              *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  12.08.2017
// Copyright © 2017 TVE                              Посл.изменение: 13.08.2017

unit ProbaLaPr01Frm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmProbaLaPr01 }

  TfrmProbaLaPr01 = class(TForm)
    btnArrayUni: TButton;
    btngaFileNamesUni: TButton;
    Button1: TButton;
    mem: TMemo;
    procedure btnArrayUniClick(Sender: TObject);
    procedure btngaFileNamesUniClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  frmProbaLaPr01: TfrmProbaLaPr01;

implementation

{$R *.lfm}

uses
  ArrayFrm,gaFileNamesUni,FilesDirUni;

procedure TfrmProbaLaPr01.btnArrayUniClick(Sender: TObject);
var
  a,a1,a2:Variant;
  nPoint: Integer;
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
  // Формируем и сравниваем два массива
  aCreate(a1);
  aAdd(a1,'qwe');
  aAdd(a1,'123');
  aAdd(a1,'ячс');
  aCutTail(a2);
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

end;

procedure TfrmProbaLaPr01.btngaFileNamesUniClick(Sender: TObject);
var
  aFileNames:Variant;
begin
  gaFileNames(aFileNames,'c:\TVED7\TLaziPrown','*.*',faAnyFile);   // Возвращаемый массив данных о файлах каталога
  aSay(aFileNames,'Массив');
end;

procedure TfrmProbaLaPr01.Button1Click(Sender: TObject);
var
  oFilesDir: RFilesDir;
  cDir: String;
  cNames: TStringList;
  nState: Integer;
  i,nCount: Integer;
begin
  cNames:=TStringList.Create;
  cDir:='c:\TVED7\TLaziPrown';
  oFilesDir.Mode:=fdDir;
  oFilesDir.Limit:=300;
  oFilesDir.Count:=0;
  nState:=MakeFilesDirList(oFilesDir,cNames,cDir);
  nCount:=cNames.Count;
  mem.Clear;
  mem.Lines.Add('nState='+IntToStr(nState));
  mem.Lines.Add('nCount='+IntToStr(nCount));
  i:=1;
  for i:=0 to cNames.Count-1 do begin
    mem.Lines.Add(cNames[i]);
  end;
  mem.Lines.Add('Прошло! '+IntToStr(oFilesDir.Count));
  cNames.Free;
end;

end.

// ***************************************************** ProbaLaPr01Frm.pas ***
