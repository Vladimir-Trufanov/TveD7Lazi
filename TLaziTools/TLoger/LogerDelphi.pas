// DELPHI7, WIN98\XP                                          *** Loger.pas ***

// ****************************************************************************
// * Loger [0140]  Собиратель-трассировщик сообщений по выполненным действиям *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  05.03.2003
// Copyright © 2009 TVE, v 2.2                       Посл.изменение: 18.10.2011

// Свойства
//
//   FileName - наименование LOG-файла (c объектом класса связываются три файла:
//   FILENAMElog.txt - оперативный Log-файл, FILENAMEloh.txt - Log-файл истории,
//   FILENAMElop.ini - позиционно-настраивающий файл);
//
//   Font - фонт при показе Log-файла;
//   User - пользователь

// Методы
//
//   Log(cMessage:String) - записать новое сообщение;
//   View - развернуть форму с сообщениями;

// Возвращаемые значения методов
//
//   Result=0, метод завершен успешно

unit Loger;

interface

uses
  Classes,Controls,Dialogs,Forms,Graphics,
  Messages,Menus,StrUtils,SysUtils,Windows,
  StdCtrls,
  PositionSaver;

const
  LogFile = 1;                // Привязка к оперативному Log-файлу
  LogHist = 2;                // Привязка к Log-файлу истории

type
  // Объявление класса
  TLoger = class(TComponent)
  private
    // Хранители свойств класса
    FFileName: String;
    FUser: String;
    // Внутренние элементы класса
    FLoger: TForm;
    FLogFile: TFileStream;    // Оперативный Log-файл
    cNameFile: String;        // Наименоваие оперативного Log-файла
    FLogHist: TFileStream;    // Log-файл истории
    cNameHist: String;        // Наименование Log-файла истории
    FFirstActivate: Boolean;  // Первая активация формы в Pприложении
    ps: TPositionSaver;
    FMemo: TMemo;
    //FMemo: TExtendedMemo;
    FFont: TFont;
    // Элементы всплывающего меню
    FPopUpMenu: TPopupMenu;   // Всплывающее меню на форме
    FmiClearLog: TMenuItem;   // Очиститель оперативного Log-файла
    FmiViewHist: TMenuItem;   // Включатель Log-файла истории
    // Обслуживание свойства FileName - наименование LOG-файла;
    procedure SetFileName(Value:String);
    function GetFileName:String;
    // Обслуживание свойства User - пользователь;
    procedure SetUser(Value:String);
    function GetUser:String;
    // Обслуживание всплывающего меню
    procedure FmiClearLogOnClickEvent(Sender: TObject);
    procedure FmiViewHistOnClickEvent(Sender: TObject);
    // Обслуживание существования формы с сообщениями
    procedure ViewOnActivateEvent(Sender: TObject);
    procedure ViewOnCloseEvent(Sender: TObject; var Action: TCloseAction);
    procedure ViewOnDestroyEvent(Sender: TObject);
    // Обслуживание Log-файлов
    function Open(nLogFile:Integer):Byte;
    function Close(nLogFile:Integer):Byte;
    function LogAddString(c:String):Byte;
    function LoadMemo(nLogFile:Integer):Byte;
    procedure SetFont(Value:TFont);
    function GetFont:TFont;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Log(cMessage:String);
    procedure View;
  published
    property FileName:String read GetFileName write SetFileName;
    property Font:TFont read GetFont write SetFont;
    property User:String read GetUser write SetUser;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TD7TOOLS', [TLoger]);
end;

// ****************************************************************************
// *                Определить объем свободной оперативной памяти             *
// ****************************************************************************
function gMemorySize: String;
var
  MS: TMemoryStatus;
begin
  MS.dwLength:=SizeOf(TMemoryStatus);
  GlobalMemoryStatus(MS);
  Result:='['+FormatFloat('#"М"',MS.dwTotalPhys div 1048576)+']';
end;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// ****************************************************************************
// *             Обеспечить доступ к свойству "Наименование LOG-файла"        *
// ****************************************************************************
procedure TLoger.SetFileName(Value:String);
begin
  FFileName:=Value;
end;
function TLoger.GetFileName:String;
begin
  Result:=FFileName;
end;

// ****************************************************************************
// *                 Обеспечить доступ к свойству "Пользователь"              *
// ****************************************************************************
procedure TLoger.SetUser(Value:String);
begin
  FUser:=Value;
end;
function TLoger.GetUser:String;
begin
  Result:=FUser;
end;

// ****************************************************************************
// *                      Обеспечить доступ к свойству "Фонт"                 *
// ****************************************************************************
procedure TLoger.SetFont(Value:TFont);
begin
  FFont:=Value;
end;
function TLoger.GetFont:TFont;
begin
  Result:=FFont;
end;

{  ................................. МЕТОДЫ ..................................}

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TLoger.Create(AOwner:TComponent);
begin
  inherited;
  FFont:=TFont.Create;
  // По умолчанию определяем имя файла трассировки,
  // как 'Log' в каталоге приложения
  FFileName:='Log';
  // Готовим первую активацию формы после запуска приложения
  FFirstActivate:=True;
end;

// ****************************************************************************
// *  Выполнить действия при первой активации формы после запуска приложения  *
// ****************************************************************************
procedure TLoger.ViewOnActivateEvent(Sender: TObject);
begin
  if FFirstActivate then begin
    // Открываем Log-файл истории
    Open(LogHist);
    FFirstActivate:=False;
  end;
end;

// ****************************************************************************
// *                               Уничтожить объект                          *
// ****************************************************************************
destructor TLoger.Destroy;
begin
  // Закрываем Log-файл истории
  Close(LogHist);
  inherited;
end;

// ****************************************************************************
// *            Занести новое сообщение в файл трассировки сообщений          *
// ****************************************************************************
procedure TLoger.Log(cMessage:String);
begin
  try
    View;
    LogAddString(cMessage);
  except
    ShowMessage(cMessage);
  end;
  Application.ProcessMessages;
end;

{............... СОЗДАНИЕ И УДАЛЕНИЕ ФОРМЫ ДЛЯ ПОКАЗА СООБЩЕНИЙ ..............}

// ****************************************************************************
// *               Подключиться к заданному Log-файлу и открыть его           *
// ****************************************************************************
function TLoger.Open(nLogFile: Integer): Byte;

// FLogFile: TFileStream;   - оперативный Log-файл
// LogFile = 1;             - привязка к оперативному Log-файлу
// FLogHist: TFileStream;   - Log-файл истории
// LogHist = 2;             - привязка к Log-файлу истории

begin
  Result:=0;
  // Открываем Log-файл истории
  if nLogFile=LogHist then begin
    cNameHist:=FFileName+'loh.txt';   // Log-файл истории
    try
      if not FileExists(cNameHist) then begin
        FLogHist:=TFileStream.Create(cNameHist,fmCreate);
        FLogHist.Free;
      end;
      FLogHist:=TFileStream.Create(cNameHist,fmOpenWrite);
    except
      Result:=1;
      FLogHist.Free;
      ShowMessage('Не открылся Log-файл истории: '+cNameHist+'!')
    end;
  end
  // Открываем оперативный Log-файл
  else begin
    cNameFile:=FFileName+'log.txt';   // Оперативный log-файл
    try
      if not FileExists(cNameFile) then begin
        FLogFile:=TFileStream.Create(cNameFile,fmCreate);
        FLogFile.Free;
      end;
      FLogFile:=TFileStream.Create(cNameFile,fmOpenWrite);
    except
      Result:=1;
      FLogFile.Free;
      ShowMessage('Не открылся оперативный Log-файл: '+cNameFile+'!')
    end;
  end;
end;

// ****************************************************************************
// *                           Закрыть заданный Log-файл                      *
// ****************************************************************************
function TLoger.Close(nLogFile: Integer): Byte;
// FLogFile: TFileStream;   // Оперативный Log-файл
// FLogHist: TFileStream;   // Log-файл истории
begin
  Result:=0;
  if nLogFile=LogHist then FLogHist.Free
  else FLogFile.Free;
end;

// ****************************************************************************
// *                         Занести строку в Log-файлы                        *
// ****************************************************************************
function TLoger.LogAddString(c:String): Byte;
var s:String;
begin
  Result:=0;
  // Подвешиваем префикс к сообщению
  s:=FormatDateTime('dd.mm.yyyy,hh:nn:ss ',Now)+gMemorySize+' '+FUser+#9+c;
  // Выводим строку на экран
  FMemo.Lines.Add(s);
  // Заносим строку в Log-файлы
  s:=s+#13+#10;
  if Open(LogFile)=0 then begin
    FLogFile.Seek(0,soFromEnd);
    FLogFile.WriteBuffer(Pointer(s)^,Length(s));
    Close(LogFile);
  end;
  FLogHist.Seek(0,soFromEnd);
  FLogHist.WriteBuffer(Pointer(s)^,Length(s));
end;

// ****************************************************************************
// *                                 Загрузить Memo                           *
// ****************************************************************************
function TLoger.LoadMemo(nLogFile:Integer):Byte;
begin
  Result:=0;
  FMemo.Clear;
  // Загружаем Log-файл истории
  if nLogFile=LogHist then begin
    FMemo.Color:=clMoneyGreen;
    try
      Close(LogHist);
      FMemo.Lines.LoadFromFile(cNameHist);
      Open(LogHist);
    except
      Result:=1;
      ShowMessage('Не удалось загрузить Log-файл истории: '+cNameHist+'!');
    end;
  end
  // Открываем оперативный Log-файл
  else begin
    FMemo.Color:=clWindow;
    try
      Close(LogFile);
      FMemo.Lines.LoadFromFile(cNameFile);
      Open(LogFile);
    except
      Result:=1;
      ShowMessage('Не удалось загрузить оперативный Log-файл: '+cNameFile+'!');
    end;
  end;
end;

// ****************************************************************************
// *                  Развернуть форму для трассировки сообщений              *
// ****************************************************************************

// Форма показа сообщений является немодальной формой, создается, разворачива-
// ется и висит, пока ее не закроют "крестом на форме".  Форма может быть соз-
// дана и развернута, как следствие 2 событий:  поступило новое сообщение  или
// пользователь  нажал клавишу  принудительного  вызова  формы  c  сообщениями
// (по умолчанию F2)

// Создаем и разворачиваем форму с содержимым Log-файла
procedure TLoger.View; 
const MaxLen = 20;
begin
  // Проверяем, существует ли форма, если форма отсутствует, то ее создаем
  // и таким образом предупреждаем создание нескольких форм
  if not Assigned(FLoger) then begin
    // Создаем форму
    FLoger:=TForm.Create(Application);
    FLoger.FormStyle:=fsStayOnTop;
    // Готовим заголовок формы и обновляем имена файлов
    if FFileName='Log' then FLoger.Caption:='Log-файл ...'+Application.Title
    else FLoger.Caption:='Log-файл ... '+RightStr(FFileName,MaxLen);
    // Готовим события корректного закрытия формы Logera
    Floger.OnActivate:=ViewOnActivateEvent;
    Floger.OnClose:=ViewOnCloseEvent;
    Floger.OnDestroy:=ViewOnDestroyEvent;
    // Размещаем Мемо для log-текстов
    //FMemo:=TExtendedMemo.Create(FLoger);
    FMemo:=TMemo.Create(FLoger);
    FMemo.Parent:=FLoger;
    FMemo.Align:=alClient;

    FMemo.Font.Name:=FFont.Name; // 'MS Sans Serif'
    FMemo.Font.Size:=FFont.Size; // 8

    FMemo.ScrollBars:=ssBoth;    //ssVertical;
    FMemo.WordWrap:=True;
    FMemo.ReadOnly:=True;
    // Размещаем всплывающее меню на форме
    FPopUpMenu:=TPopupMenu.Create(FLoger);
    FLoger.PopupMenu:=FPopUpMenu;
    FPopUpMenu.Items.Clear;
    // Готовим обработку кликов меню
    FmiClearLog:=TMenuItem.Create(FLoger);
    FmiClearLog.Caption:='Очистить оперативный Log-файл';
    FPopUpMenu.Items.Add(FmiClearLog);
    FmiClearLog.OnClick:=FmiClearLogOnClickEvent;

    FmiViewHist:=TMenuItem.Create(FLoger);
    FmiViewHist.Caption:='Переключиться на Log-файл истории';
    FPopUpMenu.Items.Add(FmiViewHist);
    FmiViewHist.OnClick:=FmiViewHistOnClickEvent;
    // Уточняем позицию на экране монитора
    ps:=TPositionSaver.Create(FLoger);
    if FFileName='Log' then ps.FileName:=Application.Title+'lop.ini'
    else ps.FileName:=FFileName+'lop.ini';
    // Заполняем Memo на форме из оперативного Log-файла
    if Open(LogFile)=0 then begin
      LoadMemo(LogFile);
      Close(LogFile);
    end;
    // Выводим форму
    FLoger.Show;
    FMemo.Lines.Add('');
  end;
end;

// ****************************************************************************
// *  Освободить (удалить из памяти) экземпляр объекта формы при ее закрытии  *
// ****************************************************************************
procedure TLoger.ViewOnCloseEvent(Sender: TObject; var Action: TCloseAction);
begin
  // Запоминаем позицию Logerа на экране
  // При закрытии формы (по команде меню или "по кресту на форме") экземпляр
  // формы остается в памяти до закрытия приложения. Поэтому принудительно
  // память от формы освобождаем на событии OnClose действием Action:=caFree;
  Action:=caFree;
  inherited;
end;

// ****************************************************************************
// *          Сбросить ссылку на экземпляр формы после его уничтожения        *
// ****************************************************************************
procedure TLoger.ViewOnDestroyEvent(Sender: TObject);
begin
  // Проверка наличия  экземпляра  формы - if not Assigned(FLoger)  фактически
  // проверяется на значение NIL, но подпрограммы библиотеки VCL автоматически
  // не присваивают этого значения при освобождении формы, так как не известно
  // когда форма закрывается. Поэтому это делает сама форма перед уничтожением
  FLoger:=NIL;
  inherited;
end;

// ****************************************************************************
// *              Очистить Memo c содержимым оперативного Log-файла           *
// ****************************************************************************
procedure TLoger.FmiClearLogOnClickEvent(Sender: TObject);
var cFileName: PAnsiChar;
begin
  cFileName:=PAnsiChar(cNameFile);
  if not DeleteFile(cFileName) then
    MessageDlg('Ошибка удаления оперативного Log-файла:'+
    cFileName,mtInformation,[mbOk],0);
  FMemo.Clear;
end;

// ****************************************************************************
// *                      Переключиться на Log-файл истории                   *
// ****************************************************************************
procedure TLoger.FmiViewHistOnClickEvent(Sender: TObject);
begin
  LoadMemo(LogHist);
end;

end.

// *********************************************************** VarSaver.pas ***
