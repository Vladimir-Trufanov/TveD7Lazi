unit Wintask1Frm;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  Messages, StdCtrls;

type
  TMyFunc = function(c:String): boolean;

			{ TWintask1 }

      TWintask1 = class(TForm)
						Button1: TButton;
						Button2: TButton;
						Button3: TButton;
						Button5: TButton;
						lblInfo: TLabel;
						Memo1: TMemo;
						procedure Button1Click(Sender: TObject);
						procedure Button2Click(Sender: TObject);
						procedure Button3Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
			procedure FormDestroy(Sender: TObject);
      private

      public

      end;

var
      Wintask1: TWintask1;

implementation

{$R *.lfm}

{ TWintask1 }

procedure TWintask1.FormCreate(Sender: TObject);
begin
end;

procedure TWintask1.FormDestroy(Sender: TObject);
begin

end;

procedure TWintask1.Button1Click(Sender: TObject);
var

    p : array[0 .. 255] of WideChar;

  n,MonolitHandle:HWND;
begin
  MonolitHandle:=GetForegroundWindow();

  GetWindowTextW(MonolitHandle, p, 256);
  if Length(Trim(StrPas(p))) > 0
  then lblInfo.Caption:=IntToStr(MonolitHandle) + ' -> ' + p
  else lblInfo.Caption:='yt yfqltyj';
  Wintask1.Memo1.Lines.Add(IntToStr(MonolitHandle) + ' -> ' + p );
  // EnumWindows();
  {
    n:=GetNextWindow(MonolitHandle,gw_HWndNext);
    GetWindowTextW(n, p, 256);
    if Length(Trim(StrPas(p))) > 0
    then lblInfo.Caption:='2 '+IntToStr(n) + ' -> ' + p
    else lblInfo.Caption:='yt yfqltyj';
    Wintask1.Memo1.Lines.Add(IntToStr(n) + ' -> ' + p );

      n:=GetNextWindow(n,gw_HWndNext);
      GetWindowTextW(n, p, 256);
      if Length(Trim(StrPas(p))) > 0
      then lblInfo.Caption:='2 '+IntToStr(n) + ' -> ' + p
      else lblInfo.Caption:='yt yfqltyj';
      Wintask1.Memo1.Lines.Add(IntToStr(n) + ' -> ' + p );

            n:=GetNextWindow(n,gw_HWndNext);
            GetWindowTextW(n, p, 256);
            if Length(Trim(StrPas(p))) > 0
            then lblInfo.Caption:='2 '+IntToStr(n) + ' -> ' + p
            else lblInfo.Caption:='yt yfqltyj';
            Wintask1.Memo1.Lines.Add(IntToStr(n) + ' -> ' + p );

                  n:=GetNextWindow(n,gw_HWndNext);
                  GetWindowTextW(n, p, 256);
                  if Length(Trim(StrPas(p))) > 0
                  then lblInfo.Caption:='2 '+IntToStr(n) + ' -> ' + p
                  else lblInfo.Caption:='yt yfqltyj';
                  Wintask1.Memo1.Lines.Add(IntToStr(n) + ' -> ' + p );

                        n:=GetNextWindow(n,gw_HWndNext);
                        GetWindowTextW(n, p, 256);
                        if Length(Trim(StrPas(p))) > 0
                        then lblInfo.Caption:='2 '+IntToStr(n) + ' -> ' + p
                        else lblInfo.Caption:='yt yfqltyj';
                        Wintask1.Memo1.Lines.Add(IntToStr(n) + ' -> ' + p );
     }

end;

//function EnumWindowsProc(h: HWND; L: LPARAM): BOOL; stdcall;
function EnumWindowsProc(h: HWND; L: LPARAM): WINBOOL; stdcall;
var
   p : array[0 .. 255] of WideChar;
begin

   {
   if IsWindowVisible(h) and (GetParent(h) = 0)then
   begin
   GetWindowTextW(h, p, 256);
   if Length(Trim(StrPas(p))) > 0 then Wintask1.Memo1.Lines.Add(IntToStr(h) + ' -> ' + p);
   end;
   Result := True;
   }
end;

procedure TWintask1.Button2Click(Sender: TObject);
var
   //h: HWND; L: LPARAM;
   f: ENUMWINDOWSPROC;
begin
  // https://www.cyberforum.ru/lazarus/thread1737344.html

   //EnumWindows(@EnumWindowsProc1, 0);
   EnumWindows(f,0);
   //lblInfo.Caption:='Прошли '+IntToStr(n2);

end;

function AAA(c:String): boolean;
begin
  Result:=true;
  ShowMessage(c);
end;

procedure BBB(Fnk: TMyFunc);
begin
  Fnk('Приветик!');
end;

procedure TWintask1.Button3Click(Sender: TObject);
begin
  BBB(@AAA);
end;


end.

