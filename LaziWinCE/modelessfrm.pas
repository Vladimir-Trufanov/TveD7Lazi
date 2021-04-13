unit ModeLessFrm;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  lconvencoding, Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
	ComCtrls, StdCtrls, Grids;

type

			{ TfrmModeless }

      TfrmModeless = class(TForm)
						btnFindWindow: TButton;
						btnCloseMainWindow: TButton;
						StringGrid1: TStringGrid;
						// Найти окно
            procedure btnFindWindowClick(Sender: TObject);
            // Закрыть главное окно
            procedure btnCloseMainWindowClick(Sender: TObject);
      private
      public

      end;

var
      frmModeless: TfrmModeless;

implementation

{$R *.lfm}

{ TfrmModeless }

// Найти окно
procedure TfrmModeless.btnFindWindowClick(Sender: TObject);
var
  l,ldelta:integer;
  cs,cdelta:String;
  Form: HWnd;
  {$IFDEF wince}
  WindowCaption: PWideChar;
  {$ELSE}
  WindowCaption: PChar;
  {$ENDIF}
begin
  // Задаем название заголовка окна и ищем окно
  WindowCaption:='frmLaziWinCE';
  Form := FindWindow (nil, WindowCaption);
  if Form <> 0 then begin
    // Формируем постфикс сообщения
    cdelta:=': окно найдено!';
    ldelta:=length(cdelta);
    // Вытаскиваем название окна
    l := Windows.GetWindowTextLength(Form);
    SetLength(cs, l);
    Windows.GetWindowText(Form, @cs[1], 100);//l+ldelta);
    Caption:=cs+cdelta;
  end
  // Отмечем, что окно не найдено
  else begin
    Caption:='Окно '+WindowCaption+' не найдено!';
	end;
end;
// Закрыть главное окно
procedure TfrmModeless.btnCloseMainWindowClick(Sender: TObject);
var
  l,ldelta:integer;
  cs,cdelta:String;
  Form: HWnd;
  {$IFDEF wince}
  WindowCaption: PWideChar;
  {$ELSE}
  WindowCaption: PChar;
  {$ENDIF}
begin
  // Задаем название заголовка окна и ищем окно
  WindowCaption:='frmLaziWinCE';
  Form := FindWindow (nil, WindowCaption);
  if Form <> 0 then begin
    //ShowWindow (Form, SW_SHOW);
    SetForegroundWindow (Form);
    ExitProcess (0);
  end
  // Отмечем, что окно не найдено
  else begin
    Caption:='Окно '+WindowCaption+' не найдено!';
	end;
end;

end.

