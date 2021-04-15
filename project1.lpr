program project1;

{$mode objfpc}{$H+}{$codepage UTF8}

uses
      {$IFDEF UNIX}{$IFDEF UseCThreads}
      cthreads,
      {$ENDIF}{$ENDIF}
      Classes,SysUtils,Windows
      { you can add units after this };

type
  TMyFunc = function(c:String): boolean;

var
  a, b: Integer;

function AAA(c:String): boolean;
begin
  Result:=true;
  writeln(c);
end;

procedure BBB(Fnk: TMyFunc);
begin
  Fnk('Привет!');
end;

function FindWindowByEnumProc(h:HWND; L:LPARAM): WINBOOL; stdcall;
begin
  {
    if ( IsConsole(hwnd) )         // use hwnd.
        return FALSE;
    }
  result:=TRUE;
end;

begin
  a:= 5;
  b:= 10;
  writeln('Всем привет!!!');
  writeln('Переменная a = ', a, '; переменная b = ', b);

  BBB(@AAA);
  EnumWindows(@FindWindowByEnumProc, NULL);

  readln();
end.

