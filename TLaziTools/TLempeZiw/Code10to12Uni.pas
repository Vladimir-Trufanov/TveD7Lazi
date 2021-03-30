// LAZARUS, WIN10\XP                                  *** Code10to12Uni.pas ***

// ****************************************************************************
// *         Преобразовать визуализированный 10-ый код к 12-разрядному        *
// ****************************************************************************

// Автор: Труфанов В.Е.                              Дата создания:  08.10.2017
// Copyright © 2017 tve                              Посл.изменение: 27.10.2017

unit Code10to12Uni;

{$mode objfpc}{$H+}

interface

uses
  Classes,Dialogs,Math,SysUtils,
  LazitoolsOutfit;

type
  TCode10to12 = class
  private
    // Хранители свойств класса
    FViewCode: Integer;    // Способ представления кодов сжатого текста
    // Внутренние переменные класса
    Chetny: Boolean;       // True - четный код
    NechVerh: Integer;
    // Сменить чётность
    procedure SmenityChet;
    // Просто ретранслировать подготовленный вид кода
    function MakeCode(const str:String): String;
    // Преобразовать визуализированный 10-ый код к 12-ричному визуализированному
    function MakeView(Str:String): String;
  protected
  public
    // Создать объект
    constructor Create(ViewCode:Integer=vicInteger);
    // Преобразовать визуализированный 10-ый код к 12-разрядному
    function Make(Str:String): String;
    // Преобразовать визуализированный 10-ый код к 12-разрядному (основной метод)
    function Make12(Str:String): String;
  published
  end;

implementation

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TCode10to12.Create(ViewCode:Integer=vicInteger);
begin
  FViewCode:=ViewCode;
  // Ждём первый (нечетный) код
  Chetny:=False;
end;

// ****************************************************************************
// *                             Сменить четность                             *
// ****************************************************************************
procedure TCode10to12.SmenityChet;
begin
  Chetny:=not Chetny;
end;

// ****************************************************************************
// *              Просто ретранслировать подготовленный вид кода              *
// ****************************************************************************
function TCode10to12.MakeCode(const str:String): String;
begin
  Result:=str;
end;

// ****************************************************************************
// * Преобразовать визуализированный 10-ый код к 12-ричному визуализированному
// ****************************************************************************
function TCode10to12.MakeView(Str:String): String;
var
  ic,icVerh,icNiz: Integer;
begin
  Result:='';
  ic:=StrToInt(Copy(Str,1,length(Str)-1));
  icNiz:=ic mod 256;
  icVerh:=Floor(Double(ic)/256);
  // Если нечетный по порядку код
  if not Chetny then begin
    Result:=IntToStr(icNiz)+'['+IntToStr(icVerh)+'].';
  end
  // Если ЧЁТНЫЙ по порядку код
  else begin
    Result:='['+IntToStr(icVerh)+']'+IntToStr(icNiz)+'.';
  end;
  SmenityChet;
end;

// ****************************************************************************
// * Преобразовать визуализированный 10-ый код к 12-разрядному (основной метод)
// ****************************************************************************
function TCode10to12.Make12(Str:String): String;
var
  ic,icVerh,icNiz: Integer;
  cTrass: String;
begin
  // Трассируем поступающие коды в обработку
  // Showmessage('Make12-IN: '+Str);
  if Str=IntToStr(fwEOC) then begin
    // Если нечетный по порядку код
    if not Chetny then begin
     Result:='';
     cTrass:=Str;
    end
    // Если ЧЁТНЫЙ по порядку код
    else begin
      Result:=chr(NechVerh*16+1);
      cTrass:='['+IntToStr(NechVerh)+'].'+Str;
    end;
  end
  else begin
    Result:='';
    ic:=StrToInt(Copy(Str,1,length(Str)-1));
    icNiz:=ic mod 256;
    icVerh:=Floor(Double(ic)/256);
    // Если нечетный по порядку код
    if not Chetny then begin
      Result:=chr(icNiz);
      NechVerh:=icVerh;
      cTrass:=IntToStr(icNiz);
    end
    // Если ЧЁТНЫЙ по порядку код
    else begin
      // "здесь" добавляется 1, чтобы не затирался 0-ой остаток - chr(0)
      Result:=chr(NechVerh*16+icVerh+1)+chr(icNiz);
      cTrass:='['+IntToStr(NechVerh)+'].['+IntToStr(icVerh)+']'+IntToStr(icNiz)+'.';
    end;
  end;
  SmenityChet;
  // Трассируем обработанные коды
  // Showmessage('Make12-OUT: '+cTrass);
end;

// ****************************************************************************
// *      Преобразовать визуализированный 10-ый код к 12-разрядному виду      *
// ****************************************************************************
function TCode10to12.Make(Str:String): String;
begin
  if FViewCode=vicInteger then Result:=MakeCode(Str)
  else if FViewCode=vicSimple then Result:=MakeView(Str)
  else Result:=Make12(Str)
end;

end.

// ****************************************************** Code10to12Uni.pas ***


