// LAZARUS WIN10\XP                                     *** ProbaLaPr02.pas ***

// ****************************************************************************
// *                    Второй блок тестов библиотеки TLaziPrown              *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  12.08.2017
// Copyright © 2017 TVE                              Посл.изменение: 13.08.2017

program ProbaLaPr02;

uses
  Forms, Interfaces,
  ProbaLaPr02Frm {Form1},
  AtUni,
  FulldnUni,
  SubstrUni,
  TellmeFrm {frmMessHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmProbaLaPr02, frmProbaLaPr02);
  Application.Run;
end.

// ******************************************************** ProbaLaPr02.pas ***

