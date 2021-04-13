unit Wintask1Frm;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  Messages, StdCtrls;

type

			{ TWintask1 }

      TWintask1 = class(TForm)
						Button1: TButton;
						lblInfo: TLabel;
						Memo1: TMemo;
						procedure Button1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
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



end.

