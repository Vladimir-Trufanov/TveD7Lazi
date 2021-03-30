unit MakeFilesDirarrayUni;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function MakeFilesDirArray(var aNames:Variant; const cDir:String;
  const cSubstrErase:String=''): Integer;

implementation

uses
  ArrayFrm,ConvertUni;

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

// ****************************************************************************
// *            Выбрать в массив информацию о каталогах и файлах              *
// ****************************************************************************
function MakeFilesDirArray(var aNames:Variant; const cDir:String;
  const cSubstrErase:String=''): Integer;
var
 ifs: Integer;      // cтатус поиска очередного каталога или файла
 fs: TSearchRec;    // объект для поиска каталогов и файлов ("поисковик")
 cNewDir: String;
 cPath: String;
 cLine: String;
 nPoint: Integer;
begin
 cPath:=cDir;
 ifs:=FindFirst(cPath+'*',faAnyFile,fs);
 while ifs=0 do begin
   if (fs.Name='.')or(fs.Name='..') then begin
   end
   else if (fs.Attr and faDirectory)=faDirectory then begin
     cNewDir:=cPath+fs.Name+'\';
     MakeFilesDirArray(aNames,cNewDir,cSubstrErase);
   end
   else begin
     cLine:=cPath+fs.Name+
       '='+IntToStr(fs.Attr)+'='+IntToStr(fs.Size)+'='+IntToStr(fs.Time);
     if cSubstrErase<>'' then begin
       cLine:=Copy(cLine,length(cSubstrErase)+1,MaxInt);
     end;
     aAdd(aNames,cLine);
   end;
   ifs:=FindNext(fs)
 end;
end;

// ****************************************************************************
// *            Выбрать в массив информацию о каталогах и файлах              *
// ****************************************************************************
{function MakeFilesDirArray(var aNames:Variant; const cDir:String): Integer;
var
 ifs: Integer;      // cтатус поиска очередного каталога или файла
 fs: TSearchRec;    // объект для поиска каталогов и файлов ("поисковик")
 cNewDir: String;
 cPath: String;
begin
 cPath:=cDir;
 ifs:=FindFirst(cPath+'*',faAnyFile,fs);
 while ifs=0 do begin
   if (fs.Name='.')or(fs.Name='..') then begin
   end
   else if (fs.Attr and faDirectory)=faDirectory then begin
     cNewDir:=cPath+fs.Name+'\';
     MakeFilesDirArray(aNames,cNewDir);
   end
   else begin
     aAdd(aNames,cPath+fs.Name+'='+
       IntToStr(fs.Attr)+'='+IntToStr(fs.Size)+'='+IntToStr(fs.Time));
   end;
   ifs:=FindNext(fs)
 end;
end;}

// ****************************************************************************
// *            Выбрать в массив информацию о каталогах и файлах              *
// ****************************************************************************
{function MakeFilesDirArray(var aNames:Variant; const cDir:String): Integer;
var
 ifs: Integer;      // cтатус поиска очередного каталога или файла
 fs: TSearchRec;    // объект для поиска каталогов и файлов ("поисковик")
 cNewDir: String;
 cPath: String;
begin
 cPath:=cDir;
 ifs:=FindFirst(cPath+'*',faAnyFile,fs);
 while ifs=0 do begin
   if (fs.Name='.')or(fs.Name='..') then begin
     aAdd(aNames,cPath+fs.Name+'='+
       IntToStr(fs.Attr)+'='+IntToStr(fs.Size)+'='+IntToStr(fs.Time));
   end
   else if (fs.Attr and faDirectory)=faDirectory then begin
     cNewDir:=cPath+fs.Name+'\';
     aAdd(aNames,cNewDir);
     MakeFilesDirArray(aNames,cNewDir);
   end
   else begin
     aAdd(aNames,cPath+fs.Name+'='+
       IntToStr(fs.Attr)+'='+IntToStr(fs.Size)+'='+IntToStr(fs.Time));
   end;
   ifs:=FindNext(fs)
 end;
end;}


end.

