// DELPHI7, WIN98\XP                                      *** IniMesLib.pas ***

// ****************************************************************************
// *      Вывести сообщение об ошибке/предупреждение из модуля приложения     *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  28.12.2004
// Copyright © 2004 TVE                              Посл.изменение: 26.10.2005

// Синтаксис
//
//   function IniMessage(nNumber:Integer; cMessage,cModulName:String): Byte;

// Параметры
//
//   nNumber - номер сообщения (номера 3 разрядные: 1<=nnn<500,  предупреждение
// без завершения приложения; 500<=nnn<=999, ошибка с завершением приложения)
//   cMessage - текст сообщения
//   cModulName - наименование модуля, инициировавшего сообщение

// Возвращаемое значение
//
//   Result = 0, функция завершена успешно

unit IniMesLib;

interface

uses
  Dialogs,Forms,SysUtils;

function IniMessage(nNumber:Integer; cMessage,cModulName:String): Byte;

implementation

// ****************************************************************************
// *         Вывести сообщение и прервать/продолжить работу приложения        *
// ****************************************************************************

function IniMessage(nNumber:Integer; cMessage,cModulName:String): Byte;

begin
  Result:=0;
  MessageDlg(cModulName+' ['+IntToStr(nNumber)+'] '+chr(13)+chr(10)+
    cMessage+'!',mtError,[mbOk],0);
  if nNumber>=500 then begin
    Application.Terminate;
  end;
end;

end.

// ********************************************************** IniMesLib.pas ***
