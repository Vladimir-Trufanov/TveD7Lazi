// LAZARUS WIN10\XP                                 *** LazitoolsOutfit.pas ***

// ****************************************************************************
// *               Реестр настроек библиотеки фрэймов TLaziFrames             *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  07.12.2017
// Copyright © 2017 TVE                              Посл.изменение: 11.12.2017

unit LaziframesOutfit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

// Реестр фрэймов TLaziFrames
// 610 TframeGuide        GuideFrame
// 620 TframeNumgress     NumgressFrame

const

CR = #13;          // "Возврат каретки"
LF = #10;          // "Перевод строки"

// 610 ========================================================= GuideFrame ===

// Режимы формирования и вывода сообщений
//ermString = 1;   // Просто сформировать строку сообщения (по умолчанию)
//ermLog    = 2;   // Разместить сообщение во внешнем лог-файле
//ermShow   = 3;   // Показать сообщение в приложении через обычный Showmessage

// 620 ====================================================== NumgressFrame ===

// Режимы формирования и вывода сообщений
//lzwOrigin     = 1; // Оригинальный текст
//lzwCompressed = 2; // Сжатый текст
//lzwRecovered  = 3; // Восстановленный текст

implementation

end.

// **************************************************** LazitoolsOutfit.pas ***

