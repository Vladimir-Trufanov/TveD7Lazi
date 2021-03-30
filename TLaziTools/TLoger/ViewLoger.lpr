// LAZARUS-1.2.4, WIN10\XP                                *** ViewLoger.lpr ***

// ****************************************************************************
// * VIEWLOGER: Визуализатор трассировщика сообщений по выполненным действиям *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  05.10.2016
// Copyright © 2016 TVE                              Посл.изменение: 11.10.2016

program ViewLoger;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ViewLogerFrm, Loger, AtLib, SubStrLib
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmViewLoger, frmViewLoger);
  Application.Run;
end.

// ********************************************************** ViewLoger.lpr ***
