unit unit2;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  Windows,
      Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

			{ TForm1 }

      TForm1 = class(TForm)
						Button1: TButton;
						Memo1: TMemo;
						procedure Button1Click(Sender: TObject);
      private

      public

      end;

var
      Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function FindWindowByEnumProc(h:HWND; L:LPARAM): WINBOOL; stdcall;
var
   p : array[0 .. 255] of WideChar;
begin
  //Form1.Memo1.Clear;
  if IsWindowVisible(h) and (GetParent(h) = 0)then begin
    GetWindowTextW(h, p, 256);
    if Length(Trim(StrPas(p))) > 0
    then Form1.Memo1.Lines.Add(IntToStr(h) + ' -> ' + p);
  end;
  Result := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  p : array[0 .. 255] of WideChar;
  nHandle,MonolitHandle:HWND;
begin
  MonolitHandle:=GetForegroundWindow();
  //EnumWindows(@FindWindowByEnumProc,0);
  nHandle:=GetWindow(MonolitHandle,GW_HWNDNEXT); // gw_HWNDNext
  GetWindowTextW(nHandle, p, 256);
  if Length(Trim(StrPas(p))) > 0
  then Form1.Memo1.Lines.Add(IntToStr(nHandle) + ' -> ' + p )
  else Form1.Memo1.Lines.Add(IntToStr(nHandle) + ' проблема с окном ');

  nHandle:=GetWindow(nHandle,GW_HWNDNEXT); // gw_HWNDNext
  GetWindowTextW(nHandle, p, 256);
  if Length(Trim(StrPas(p))) > 0
  then Form1.Memo1.Lines.Add(IntToStr(nHandle) + ' -> ' + p )
  else Form1.Memo1.Lines.Add(IntToStr(nHandle) + ' проблема с окном ');
  Caption:='все';
end;

end.

