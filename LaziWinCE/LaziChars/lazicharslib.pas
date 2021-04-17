unit LaziCharsLib;

// Используемые сайты для познания:
//
// http://sirserge.altai.info/articles/?id=45

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  Classes, SysUtils,
  lconvencoding;

type
  { Для выборки символов и их кодов }
  AAB=array [0..65535] of byte;
  PAAB=^AAB;

function ViewChar(p:PAAB; len:integer):string;
// Получить наименование каталога, с которого запущена программа
function ExePath(): widestring;

implementation

function ViewChar(p:PAAB; len:integer):string;
var i:integer;
begin
  Result:='';
  for i:=0 to len-1 do begin
    Result+=Format('%2.2x ',[p^[i]]);
  end;
  Result:=Trim(Result);
end;

// Получить наименование каталога, с которого запущена программа
function ExePath(): widestring;
var
  Str: widestring;
  I: Integer;
begin
  Str := ParamStr (0);
  for I := Length (Str) downto 1 do
  if Str[I] = '\' then begin
    Str := Copy (Str, 1, I);
    Break;
  end;
  Result := Str;
end;


end.

