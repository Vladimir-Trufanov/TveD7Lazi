unit LempeZiwTestFrm;

{ http://wiki.freepascal.org/File_Handling_In_Pascal/ru }

// {$I+} // В случаи ошибки будет вызвано исключение EInOutError (по умолчанию)
// {$I-} // Подавлять ошибки ввода-вывода: проверьте переменную IOResult для получения кода ошибки.

// ОБРАБОТКА ФАЙЛОВ В КОДИРОВКЕ ANSI,UTF8,bUTF8

{$mode objfpc}{$H+}

interface

uses
  ErrEventClass,FileReaderClass,FileWriterClass,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls;

const
  BuffersSize = 512;         // Размерности входного-выходного буферов потоков
  LF = '$0A';                // "Перевод строки"
  CR = '$0D';                // "Возврат каретки"
  maxlongint = 2147483647;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnLoad1251: TButton;
    btnMakeCompress: TButton;
    btnMakeRecover: TButton;
    btnRead: TButton;
    btnWriter: TButton;
    GroupBox1: TGroupBox;
    lblMemPress: TLabel;
    lblMem: TLabel;
    mem: TMemo;
    memPress: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Splitter1: TSplitter;
    sb: TStatusBar;
    procedure btnLoad1251Click(Sender: TObject);
    procedure btnMakeCompressClick(Sender: TObject);
    procedure btnMakeRecoverClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure btnWriterClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    oErrEvent: TErrEvent;
  public

  end;

var
  Form1: TForm1;

implementation

uses
  ConvertUni,
  LempeZiwClass,
  LazitoolsOutfit;

var
  LempeZiw: TLempeZiw;

{$R *.lfm}

{ TForm1 }

// Загрузить файл с кодировкой CP1251 без проверки его на то,
// что он закодирован для данной кодовой страницы: русский, Windows
procedure TForm1.btnMakeCompressClick(Sender: TObject);
var
  i: Integer;
begin
  LempeZiw.Origin:='PROBA.asc';
  LempeZiw.Compressed:='PROBA.bin';
  LempeZiw.Compress;
  mem.Clear;
  for i:=0 to LempeZiw.Dictionary.Count-1 do begin
    mem.Lines.Add(CP1251ToUTF8('['+IntToStr(i+1)+'] '+LempeZiw.Dictionary[i]));
  end;
  ShowMessage('Сжатие завершено!');
end;

procedure TForm1.btnLoad1251Click(Sender: TObject);
begin
  Showmessage('Заархивирован файл CP1251 и восстановлен без проверки!');
end;

procedure TForm1.btnMakeRecoverClick(Sender: TObject);
var
  i: Integer;
begin
  LempeZiw.Compressed:='PROBA.bin';
  LempeZiw.Recovered:='PROBA.res';
  LempeZiw.Recover;
  mem.Clear;
  for i:=0 to LempeZiw.Dictionary.Count-1 do begin
    mem.Lines.Add(CP1251ToUTF8('['+IntToStr(i+1)+'] '+LempeZiw.Dictionary[i]));
  end;
  {ShowMessage('Сжатие завершено!'); }
end;

procedure TForm1.btnReadClick(Sender: TObject);
var
  oReader: TFileReader;  // Объект побайтового чтения из файла через буфер
  cReadChar: Char;       // Символ из входного потока
  nResult: Byte;
begin
  mem.Clear;
  Showmessage('Привет!');
  oReader:=TFileReader.Create;
  btnRead.Caption:=oReader.VersDate;
  btnRead.Width:=100;
  oReader.Path:='';
  oReader.FileName:='PROBA.asc';
  nResult:=oReader.ReadChar(cReadChar);
  while nResult=frOK do begin
    mem.Lines.Add(IntToStr(ord(cReadChar))+': '+CP1251ToUTF8(cReadChar));
    nResult:=oReader.ReadChar(cReadChar);
  end;
end;

procedure TForm1.btnWriterClick(Sender: TObject);
var
  oWriter: TFileWriter;  // Объект побайтового чтения из файла через буфер
begin
  mem.Clear;
  Showmessage('Привет!');
  oWriter:=TFileWriter.Create;
  oWriter.Path:='';
  oWriter.FileName:='PROBA.res';
  oWriter.Write('ABC');
  oWriter.Write('1'); oWriter.Write(chr(1)); oWriter.Write('3');
  oWriter.Write('abc');
  oWriter.Write(IntToStr(fwEOC));
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  LempeZiw.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  oErrEvent:=TErrEvent.Create;
  LempeZiw:=TLempeZiw.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
end;

end.

