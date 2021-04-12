unit LaziWinCEfrm;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  lazutf8,
  FileUtil, StrUtils,
  ModalFrm,ModeLessFrm,
  Windows,Math,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

{ TfrmLaziWinCE }

TfrmLaziWinCE = class(TForm)
	btnCurrDir: TButton;
	btnLoadDir: TButton;
	btn3Files: TButton;
	btnMemory: TButton;
	btnTimeInOut: TButton;
	btnScreenSizes: TButton;

  Button10: TButton;
	Button11: TButton;
	Button12: TButton;
	Button13: TButton;
	Button2: TButton;
	Button9: TButton;
	lblInfo: TLabel;
  // Показать текущий каталог
  procedure btnCurrDirClick(Sender: TObject);
  // Показать наименование каталога, с которого запущена программа
  procedure btnLoadDirClick(Sender: TObject);
  // Показать 3 файла/каталога в каталоге загрузки
  procedure btn3FilesClick(Sender: TObject);
  // Показать 'Всего' и свободную память
  procedure btnMemoryClick(Sender: TObject);
  // Показать время, прошедшее с момента запуска приложения
  procedure btnTimeInOutClick(Sender: TObject);
  // Показать разрешение экрана
  procedure btnScreenSizesClick(Sender: TObject);

  procedure Button10Click(Sender: TObject);
	procedure Button11Click(Sender: TObject);
	procedure Button12Click(Sender: TObject);
	procedure Button13Click(Sender: TObject);
	procedure Button2Click(Sender: TObject);
	procedure Button9Click(Sender: TObject);
	procedure FormCreate(Sender: TObject);

  private

  public

end;

var
  frmLaziWinCE: TfrmLaziWinCE;
  nStart,nFinish: Integer;
  nStart64,nFinish64: Integer;

implementation

{$R *.lfm}

// Получить наименование каталога, с которого запущена программа
function ExePath(): widestring;
var
  Str: widestring;
  I: Integer;
begin
  Str := ParamStr (0);
  for I := Length (Str) downto 1 do
  if Str[I] = '\' then begin
    Str := Copy (Str, 1, I);
    Break;
  end;
  Result := Str;
end;

procedure DivZir;
var
  nol: double;
begin
  nol:=0;
  nol:=5/nol;
end;

{ TfrmLaziWinCE }

// Показать текущий каталог
procedure TfrmLaziWinCE.btnCurrDirClick(Sender: TObject);
begin
  lblInfo.Caption:=GetCurrentDir;
end;
// Показать наименование каталога, с которого запущена программа
procedure TfrmLaziWinCE.btnLoadDirClick(Sender: TObject);
begin
  lblInfo.Caption:=ExePath();
end;
// Показать 3 файла/каталога в каталоге загрузки
procedure TfrmLaziWinCE.btn3FilesClick(Sender: TObject);
var
  cDir, c: String;
  F: TSearchREc;
  Fa: Integer;
  selcap: String;
  n: Integer;
begin
  n:=0;
  cDir:=ExePath();
  c:=cDir+'=>';
  Fa := faAnyFile; // атрибуты искомых файлов - любые;
  If FindFirst(cDir+'*.*',Fa,F) <> 0 then begin
    c:=c+'Пусто';
	end
  else begin
    c:=c+F.Name;
    FindNext(F); c:=c+','+F.Name;
    FindNext(F); c:=c+','+F.Name;
	end;
  FindClose(F);
  lblInfo.Caption:=c;
end;
// Показать 'Всего' и свободную память
procedure TfrmLaziWinCE.btnMemoryClick(Sender: TObject);
var
  MS: TMemoryStatus;
  nAll,nFree: Integer;
begin
  MS.dwLength := SizeOf (TMemoryStatus);
  GlobalMemoryStatus (MS);
  nAll:=Floor((MS.dwTotalPhys/1024)/1024);
  nFree:=Floor((MS.dwAvailPhys/1024)/1024);
  lblInfo.Caption:='Всего: '+IntToStr(nAll)+'Мb  Свободно: '+
    IntToStr(nFree)+'Mb';
end;
// Показать время, прошедшее с момента запуска приложения
procedure TfrmLaziWinCE.btnTimeInOutClick(Sender: TObject);
begin
  nFinish:=GetTickCount;
  nFinish64:=GetTickCount64;
  lblInfo.Caption:='Прошло: '+IntToStr(nFinish-nStart)+' ['+
    IntToStr(nFinish64-nStart64)+'] миллисекунд!';
end;
// Показать разрешение экрана
procedure TfrmLaziWinCE.btnScreenSizesClick(Sender: TObject);
var
  oPoint: TPoint;
function GetDisplaySize: TPoint;
begin
  Result.X := GetSystemMetrics (SM_CXSCREEN);
  Result.Y := GetSystemMetrics (SM_CYSCREEN);
end;
begin
  oPoint:=GetDisplaySize();
  lblInfo.Caption:=IntToStr(oPoint.X)+'x'+IntToStr(oPoint.Y);
end;

procedure TfrmLaziWinCE.Button10Click(Sender: TObject);
begin
  frmModal.ShowModal
end;

procedure TfrmLaziWinCE.Button11Click(Sender: TObject);
begin
  frmModeLess.Show();
end;

procedure TfrmLaziWinCE.Button12Click(Sender: TObject);
  var
   wideChars   : array[0..11] of WideChar;
   myString    : String;
   myString1    : PChar;
   S : PWideChar;

  begin
   // Задание значения нашей строке
    //myString := "Hello World";
    S := 'Hello World';
    S := 'Привет, мир!';
    S := 'П';

   // Копирование в формат WideChar в наш массив
   StringToWideChar(myString, wideChars, 12);

   // Показываем, что копирование дало
   //ShowMessage(
   WideCharToString(wideChars);
   //);

   myString:=WideCharToString(S);
   caption:=myString;
  end;

procedure TfrmLaziWinCE.Button13Click(Sender: TObject);
var
  Form: HWnd;
  {$IFDEF wince}
  WindowCaption: PWideChar;
  {$ELSE}
  WindowCaption: PChar;
  {$ENDIF}
begin
 WindowCaption:='frmLaziWinCE';
 Form := FindWindow (nil, WindowCaption);
  if Form <> 0 then
  begin
    ShowWindow (Form, SW_MAXIMIZE); //SW_SHOW);
    SetForegroundWindow (Form);
    //ExitProcess (0);
  end;
end;


// Завершаем приложение
procedure TfrmLaziWinCE.Button2Click(Sender: TObject);
begin
  Application.Terminate;
end;

// Получить заголовок активного окна
{$IFDEF wince}
function GetActiveCaption:Pwidechar;
var
  h: HWnd;
  cStr: Pwidechar;
{$ELSE}
function GetActiveCaption:PChar;
var
  h: HWnd;
  cStr: PChar;
{$ENDIF}
begin
  h:=GetActiveWindow;
  GetWindowText(h,cStr,100);
  GetActiveCaption:=cStr;
end;

procedure TfrmLaziWinCE.Button9Click(Sender: TObject);
var
  h: HWnd;
  {$IFDEF wince}
  cStr: PWideChar;
  {$ELSE}
  cStr: PChar;
  cCaption: PChar='Zagolovok';
  {$ENDIF}
begin
  //WideCharToString(S):;
  h:=GetActiveWindow;
  //cStr:='Rus10-РРРус        '+#0;
  //GetWindowText(h,cStr,15);
  MessageBox(h,'cStr','cCaption',MB_OK);
  //Showmessage(cStr);
    //cStr:=UTF8ToSys('Это текст сообщения');
    //MessageBox(h,cStr,'Заголовок',1);
    //MessageBox(h,'qwert','jhhgf',1);
    //cStr:=GetCurrentDir;
    //MessageBox(h,cStr,'Caption',1);
end;

procedure TfrmLaziWinCE.FormCreate(Sender: TObject);
begin
  {$IFDEF wince}
    //Top:=0; Left:=0;
    //BorderIcons:=[biSystemMenu];
    //BorderStyle:=bsNone;
    //WindowState:=wsFullScreen;
  {$ELSE}
    Top:=32; Left:=32;
  {$ENDIF}
  lblInfo.Top:=0;
  lblInfo.Left:=0;
  LblInfo.Width:=Width;
  // Фиксируем относительное время запуска приложения
  nStart:=GetTickCount;
  nStart64:=GetTickCount64;
end;

end.

