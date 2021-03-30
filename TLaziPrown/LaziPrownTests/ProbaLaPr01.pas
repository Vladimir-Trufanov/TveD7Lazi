// LAZARUS WIN10\XP                                     *** ProbaLaPr01.pas ***

// ****************************************************************************
// *                    Первый блок тестов библиотеки TLaziPrown              *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  12.08.2017
// Copyright © 2017 TVE                              Посл.изменение: 13.08.2017

program ProbaLaPr01;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ProbaLaPr01Frm, ArrayFrm, gaFileNamesUni, FilesDirUni,
LaziprownAlerts, TellmeFrm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmProbaLaPr01, frmProbaLaPr01);
  Application.Run;
end.

// ******************************************************** ProbaLaPr01.pas ***

