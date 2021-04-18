// FPC-3.2.0,LCL-2.0.12, WIN10\CE                       *** ModeLessFrm.pas ***

// ****************************************************************************
// *      Проверить поиск, показ и закрытие окон в Windows10 и WindowsCE      *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  30.03.2021
// Copyright © 2021 TVE                              Посл.изменение: 18.04.2021

unit ModeLessFrm;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  lconvencoding, Windows,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, Grids;

type
  TMyActionForm = function(Form:HWnd):PWideChar;

{ TfrmModeless }

TfrmModeless = class(TForm)
  btnFindWindow: TButton;
  btnCloseMainWindow: TButton;
  Button1: TButton;
  StringGrid1: TStringGrid;
  // Найти окно
  procedure btnFindWindowClick(Sender: TObject);
    // Закрыть главное окно
    procedure btnCloseMainWindowClick(Sender: TObject);
		procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  frmModeless: TfrmModeless;

implementation

{$R *.lfm}

// Получить название окна по дескриптору Handle
function actGetWindowName(Form:HWnd):PWideChar;
var
  l:integer;
  cs:String;
  cPWSTR:PWideChar;
begin
  Result:='';
  // Вытаскиваем название окна
  l:=Windows.GetWindowTextLength(Form);
  SetLength(cs,l+1);
  //Windows.GetWindowText(Form,@cs[1],l+1);
  //Windows.GetWindowText(Form,cPWSTR,100);
  //Result:=cs;
  Result:=cPWSTR;
end;

// Получить дескриптор окна по заголовку
{$IFDEF wince}
function GetWindowOnCaption(WindowCaption:PWideChar; Fnk:TMyActionForm):PWideChar;
{$ELSE}
function GetWindowOnCaption(WindowCaption:PChar; Fnk:TMyActionForm):String;
{$ENDIF}
var
  Form: HWnd;
begin
  // Подставляем заголовок окна и ищем дескриптор этого окна
  Form := FindWindow (nil, WindowCaption);
  if Form <> 0 then begin
    GetWindowOnCaption:=Fnk(Form);
	end
  else begin
    //GetWindowOnCaption:='Окно '+WindowCaption+' не найдено!';
	end;
end;

{ TfrmModeless }

// Найти окно
procedure TfrmModeless.btnFindWindowClick(Sender: TObject);
var
  l,ldelta:integer;
  cs,cdelta:String;
  Form: HWnd;
  {$IFDEF wince}
  WindowCaption:  PWideChar;
  cWindowCaption: PWideChar=': окно найдено!';
  {$ELSE}
  WindowCaption:  PChar;
  cWindowCaption: PChar;
  {$ENDIF}
  p: PString;
begin
  cWindowCaption:=': окно найдено!';
  {
  p:=@cs;
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
    Windows.GetWindowText(Form, @cs[1], l+ldelta);
    Caption:=cs+cdelta;
  end
  // Отмечем, что окно не найдено
  else begin
    Caption:='Окно '+WindowCaption+' не найдено!';
  end;
  }
  Caption:=cWindowCaption;
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
    //ShowWindow (Form, SW_HIDE);
    //ShowWindow (Form, SW_SHOW);
    //SetForegroundWindow (Form);
    // Жестко завершаем работу, убивая процесс. Могли бы мягче,
    // если бы воспользовалисть методом Application.Terminate; }
    ExitProcess(0);
  end
  // Отмечем, что окно не найдено
  else begin
    Caption:='Окно '+WindowCaption+' не найдено!';
	end;
end;

procedure TfrmModeless.Button1Click(Sender: TObject);
var
  {$IFDEF wince}
  WindowCaption: PWideChar;
  {$ELSE}
  WindowCaption: PChar;
  {$ENDIF}
  cp:PWideChar;
begin
  cp:='Привет!';
  WindowCaption:='frmLaziWinCE';
  //cp:=GetWindowOnCaption(WindowCaption,@actGetWindowName);
  Caption:=IntToStr(StringCodePage(cp));
  //Caption:=GetWindowOnCaption(WindowCaption,@actGetWindowName);
  Caption:=cp;
end;

end.

// ******************************************************** ModeLessFrm.pas ***


