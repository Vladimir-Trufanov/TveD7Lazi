unit MyPPunit1;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  Classes, SysUtils;

function RUnicodeString(c:String=''):UnicodeString;
function RRawByteStringFromUC:RawByteString;
function RRawByteStringFromS:RawByteString;
function RUTF8Str:UTF8String;
function SumUString(a,b:UnicodeString):UnicodeString;

implementation


function RUnicodeString(c:String=''):UnicodeString;
begin
  if c='' then begin Result:='АБВГД' end
  else begin Result:=c; end;
end;

function RRawByteStringFromUC:RawByteString;
begin
  Result:=RUnicodeString;
end;

function RRawByteStringFromS:RawByteString;
begin
  Result:='АБВГД в RawByte непосредственно';
end;

function RUTF8Str:UTF8String;
begin
  Result:='АБВГД в UTF8';
end;

function SumUString(a,b:UnicodeString):UnicodeString;
begin
  Result:=a+b;
end;

end.

