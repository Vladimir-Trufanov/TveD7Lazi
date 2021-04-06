// LAZARUS-1.2.4, WIN10\XP                             *** ViewLogerFrm.pas ***

// ****************************************************************************
// * VIEWLOGER: Визуализатор трассировщика сообщений по выполненным действиям *
// *   (приложение с интервалом в полсекунды проверяет изменения в заданном   *
// *                 лог-файле и показывает их на экране)                     *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  05.10.2016
// Copyright © 2016 TVE                              Посл.изменение: 05.04.2021

unit ViewLogerFrm;

{$mode objfpc}{$H+}

interface

uses
  Windows,Shfolder,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, Menus;

const
  ViewHeight   = 20;
  LogNoConnect = 'Log-файл не подключен!';

type

  { TfrmViewLoger }

  TfrmViewLoger = class(TForm)
    mmiHope: TMenuItem;
    mmiLoadAll: TMenuItem;
    mmiOpenFile: TMenuItem;
    mm: TMainMenu;
    memOne: TMemo;
    memAll: TMemo;
    od: TOpenDialog;
    Split: TSplitter;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure mmiHopeClick(Sender: TObject);
    procedure mmiLoadAllClick(Sender: TObject);
    procedure mmiOpenFileClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    NextPos: Integer;   // Первый непоказанный символ файла
    NextLine: Integer;  // Первая непоказанная строка файла
    StreamBuf: string;  // Буфер чтения порции потока
    LenScrap: Integer;  // Размер буфера порции
    LogName: String;    // Спецификация log-файла
    aViewLine: array [1..ViewHeight] of String;
    function ReadScrap(out cScrap:String): Integer;
    function PickLine(cScrap:String; out IsLFCR:Boolean): String;
    function DefineLength: Integer;
  public
    { public declarations }
  end;

var
  frmViewLoger: TfrmViewLoger;

implementation

{$R *.lfm}

{ TfrmViewLoger }

uses
  AtUni,SubstrUni,windirs;

procedure TfrmViewLoger.FormCreate(Sender: TObject);
var cSpecFolder: String;  // Спец.папка, в которой формируется Log-файл
begin
  NextPos:=0;             // Первый непоказанный символ файла
  LenScrap:=1024;         // Размер буфера порции
  memOne.Clear; memAll.Clear;
  // Назначаем, что только разрешенные существующие файлы могут быть выбраны
  od.Options:=[ofFileMustExist];
  // Разрешаем выбирать только .txt и .ini файлы
  od.Filter:='Log-файлы *.txt|*.txt|Файлы настроек *.ini|*.ini';
  // Назначаем txt, как стартовый тип фильтра
  od.FilterIndex:=1;
  od.FileName:='LogStream.txt';
  // Определяем каталог и имя файла по умалчанию
  cSpecFolder:=''; // GetWindowsSpecialDir(CSIDL_PROGRAM_FILES_COMMON);
  LogName:=cSpecFolder+od.FileName;
  Caption:='View: '+LogName;
end;

procedure TfrmViewLoger.FormWindowStateChange(Sender: TObject);

{ Определения модуля Forms
  // form position policies:
  TPosition = (
    poDesigned,        // use bounds from the designer (read from stream)
    poDefault,         // LCL decision (normally window manager decides)
    poDefaultPosOnly,  // designed size and LCL position
    poDefaultSizeOnly, // designed position and LCL size
    poScreenCenter,    // center form on screen (depends on DefaultMonitor)
    poDesktopCenter,   // center form on desktop (total of all screens)
    poMainFormCenter,  // center form on main form (depends on DefaultMonitor)
    poOwnerFormCenter  // center form on owner form (depends on DefaultMonitor)
    );
  TWindowState = (wsNormal, wsMinimized, wsMaximized, wsFullScreen);
  TCloseAction = (caNone, caHide, caFree, caMinimize);
}
begin
  if (WindowState=wsMaximized)or(WindowState=wsNormal) then begin
    Split.Color:=clGradientInactiveCaption;
    Split.Enabled:=True;
  end;
end;

procedure TfrmViewLoger.mmiHopeClick(Sender: TObject);
begin
  Split.Color:=clBtnFace;
  Split.Enabled:=False;
  frmViewLoger.Height:=frmViewLoger.Height-memAll.Height;
end;

procedure TfrmViewLoger.mmiLoadAllClick(Sender: TObject);
var
  Buffer: string;
  Stream: TFileStream;
begin
  if LogName=LogNoConnect
  then ShowMessage(LogNoConnect)
  else begin
    memAll.Visible:=True;
    memAll.Clear;
    Stream:=TFileStream.Create(LogName,fmOpenRead);
    try
      SetLength(buffer,Stream.Size);
      Stream.Read(Buffer[1],Stream.Size);
      memAll.Lines.Text:=Buffer;
      memAll.Lines.Add('***');
    finally
      Stream.Free;
    end;
  end;
end;

procedure TfrmViewLoger.mmiOpenFileClick(Sender: TObject);
var
  cLine: String;
begin
  if od.Execute then begin
    LogName:=od.FileName;
    Caption:='View: '+LogName;
    memOne.Clear; memAll.Clear;
    NextPos:=0; // Первый непоказанный символ файла
    memOne.Enabled:=False;
    while (ReadScrap(cLine)>=0) do memOne.Lines.Add(cLine);
    memOne.Enabled:=True;
  end
  else ShowMessage('Открытие файла '+od.FileName+' остановлено');
end;

procedure TfrmViewLoger.Timer1Timer(Sender: TObject);
var
  cLine: String;
begin
  // memOne.Lines.Add(FormatDateTime('dd.mm.yyyy,hh:nn:ss ',Now));
  if ReadScrap(cLine)>0 then memOne.Lines.Add(cLine);
end;

{function LockCharMe32(cIni:String):String;
var
  cIn,cOut,cNextChar: String;
  i: Integer;
  lOneSpace: Boolean;   // true - уже получен один пробел
 begin
  cOut:=''; lOneSpace:=False;
  cIn:=cIni;
  // Перебираем символы строки и выполняем преобразования
  for i:=1 to length(cIn) do begin
    // Подменяем управляющие символы на пробелы,

    //if ord(cIn[i])<32 then cNextChar:=' ' else cNextChar:=cIn[i];
    if ord(cIn[i])=9 then cNextChar:=' ' else cNextChar:=cIn[i];

    // Не пропускаем в получающуюся строку более 2 пробелов подряд
    if lOneSpace then begin
      // Если следующий символ не пробел, то сбрасываем признак и
      // включаем символ в выходную строку, иначе символ пропускаем
      if cNextChar<>' ' then begin
        lOneSpace:=False;
        cOut:=cOut+cNextChar;
      end
    end
    else begin
      cOut:=cOut+cNextChar;  // передали символ (в т.ч. первый пробел)
      if cNextChar=' ' then lOneSpace:=True else lOneSpace:=False;
    end;
  end;
   Result:=cOut;
end;}

function TfrmViewLoger.DefineLength: Integer;
begin
  Result:=FileSize(LogName);
end;

function TfrmViewLoger.ReadScrap(out cScrap:String): Integer;
var
  Buffer: string;
  Stream: TFileStream;
  IsLFCR:Boolean;
begin
  if NextPos>=DefineLength
  then begin
    Result:=-1; cScrap:='NoDefine';
    // ShowMessage('Файл закончился!');
    { C этой идеей разбираться!
    memOne.Clear; memAll.Clear;
    NextPos:=0;}
  end
  else begin
    Result:=NextPos;
    Stream:=TFileStream.Create(LogName,fmOpenRead);
    Stream.Seek(NextPos,soFromBeginning);
    try
      SetLength(buffer,LenScrap);
      Stream.Read(Buffer[1],LenScrap);
      cScrap:=PickLine(Buffer,IsLFCR);
      if IsLFCR
      then NextPos:=NextPos+Length(cScrap)+2
      else NextPos:=NextPos+Length(cScrap);
      // Трассируем продвижение курсора по файлу
      // cScrap:=cScrap+'#'+IntToStr(NextPos)+'-'+IntToStr(DefineLength)+'#';
    except
    end;
    Stream.Free;
  end;
end;

function TfrmViewLoger.PickLine(cScrap:String; out IsLFCR:Boolean): String;
var
  nPoint: Integer;
begin
  nPoint:=at(#13+#10,cScrap);
  if nPoint>0 then begin
    Result:=substr(cScrap,1,nPoint-1);
    IsLFCR:=True;
  end
  else begin
    Result:=cScrap;
    IsLFCR:=False;
  end;
end;

end.

// ******************************************************* ViewLogerFrm.pas ***

