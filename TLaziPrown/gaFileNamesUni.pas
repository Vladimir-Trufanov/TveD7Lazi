// LAZARUS, WIN10\XP                                 *** gaFileNamesUni.pas ***

// ****************************************************************************
// * TLaziPrown [1500]         Выбрать в массив сведения о каталогах и файлах *
// *                                                        (на одном уровне) *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  05.03.2003
// Copyright © 2003 TVE                              Посл.изменение: 29.08.2017

// Синтаксис
//
//   procedure gaFileNames(var aFileNames:Variant; cPath:String='C:';
//     cFileMask:String='*.*';
//     nFileAttrs:Integer=SysUtils.faReadOnly+SysUtils.faHidden+SysUtils.faArchive+SysUtils.faSysFile);

// Параметры
//
//   aFileNames - возвращаемый массив данных о файлах каталога
//   cPath - путь к каталогу с файлами
//   cFileMask - маска поиска файлов в каталоге
//   nFileAttrs - атрибуты файлов для выборки

// Примеры

//   gaFileNames(aFileNames,cName,'*.b??');
//   gaFileNames(aFileNames,'c:\KwinFly','*.b??');
//   gaFileNames(aFileNames,'','c:\KwinFly\*.*');
//   gaFileNames(aFileNames,'',cName+'.X??');
{
procedure TForm1.Button2Click(Sender: TObject);
var
  aFileNames:Variant;
begin
  gaFileNames(aFileNames,'c:\TVED7\TLaziPrown','*.*',faAnyFile);
  aSay(aFileNames,'Массив');
end;
}

unit gaFileNamesUni;

interface

uses
  Dialogs,SysUtils,Variants;

procedure gaFileNames(
  var aFileNames:Variant;   // Возвращаемый массив данных о файлах каталога
  cPath:String='C:';        // Путь к каталогу с файлами
  cFileMask:String='*.*';   // Маска поиска файлов в каталоге
  nFileAttrs:Integer=SysUtils.faReadOnly+SysUtils.faHidden+SysUtils.faArchive+SysUtils.faSysFile);

implementation

uses
  ArrayFrm;

procedure gaFileNames(
  var aFileNames:Variant;   // Возвращаемый массив данных о файлах каталога
  cPath:String='C:';        // Путь к каталогу с файлами
  cFileMask:String='*.*';   // Маска поиска файлов в каталоге
  nFileAttrs:Integer=SysUtils.faReadOnly+SysUtils.faHidden+SysUtils.faArchive+SysUtils.faSysFile);

var
  sr: TSearchRec;
  cFilespec: String;

begin
  aCreate(aFileNames);
  {
  File attribute constants
  faReadOnly   = $00000001;
  faHidden     = $00000002 platform;
  faSysFile    = $00000004 platform;
  faVolumeId   = $00000008 platform deprecated;
  faDirectory  = $00000010;           // 16
  faArchive    = $00000020;           // 32
  faNormal     = $00000080;           // 128
  faTemporary  = $00000100 platform;  // 256
  faSymLink    = $00000400 platform;  // 1024
  faSymLink    = $00000040 platform;  // 64
  faCompressed = $00000800 platform;  // 2048
  faEncrypted  = $00004000 platform;  // 16384
  faVirtual    = $00010000 platform;  // 65536
  faAnyFile    = $000001FF;           // 511
  faAnyFile    = $0000003F;           // 63

  FileAttrs := faAnyFile;
  FileAttrs := faDirectory;
  FileAttrs := faReadOnly+faHidden+faArchive+faSysFile;
  }
  // Указываем путь с маской и аттрибуты
  if cPath='' then cFilespec:=cFileMask else cFilespec:=cPath+'\'+cFileMask;
  if (FindFirst(cFilespec,nFileAttrs,sr)=0) then
  repeat
    // Если аттрибуты соответствуют, то обрабатываем файл
    if (sr.Attr and nFileAttrs)=sr.Attr then begin
      aadd(aFileNames,VarArrayOf(['*',sr.Name,sr.Time,sr.Size,sr.Attr]));
    end;
  until (FindNext(sr)<>0);
end;

end.

// ***************************************************** gaFileNamesUni.pas ***

