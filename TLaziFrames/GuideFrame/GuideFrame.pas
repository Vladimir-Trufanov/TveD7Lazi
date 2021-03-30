unit GuideFrame;

{$mode objfpc}{$H+}

interface

uses
  NumgressFrame,
  Classes, FileUtil, Forms, Controls, Graphics, ExtCtrls, Buttons,
  Dialogs, StdCtrls, Menus, ComCtrls, ImgList, Windows, SysUtils;

type

  { TframeGuide }

  TframeGuide = class(TFrame)
    il: TImageList;
    lvGuide: TListView;
    mmiSignFolder: TMenuItem;
    mmiSelZ: TMenuItem;
    mmiSelD: TMenuItem;
    mmiDoubleClick: TMenuItem;
    mmiSelC: TMenuItem;
    mmiSelA: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    mmiSelectDisk: TMenuItem;
    pnlNumgress: TPanel;
    pnl: TPanel;
    pm: TPopupMenu;
    procedure FrameClick(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure lvGuideChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvGuideClick(Sender: TObject);
    procedure lvGuideColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvGuideCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvGuideDblClick(Sender: TObject);
    procedure mmiDoubleClickClick(Sender: TObject);
    // Выбрать диск
    procedure mmiSelAClick(Sender: TObject);
    procedure mmiSelCClick(Sender: TObject);
    procedure mmiSelDClick(Sender: TObject);
    procedure mmiSelZClick(Sender: TObject);
    procedure mmiSignFolderClick(Sender: TObject);
    //
    procedure pnlResize(Sender: TObject);
  private
    // Хранители свойств класса
    FRootView: String;     // Начало просмотра (каталог, база данных, ...
    FDblClick: Boolean;    // True - двойной клик по одинарному
    // Внутренние переменные
    cDirExe: String;       // Каталог, из которого запущена программа
    cCurrentDir: String;
    nRowIndex: Integer;    // Индекс выделенной строки навигатора (-1 не выделена)
    // Приватные компоненты
    ilSmallIm: TImageList; // Набор мелких значков (32х32)
    ic: TIcon;             // Текущая иконка
    sl: TStringList;       // Список расширений и программ обработки
    ng: TframeNumgress;    // Индикатор событий и процессов
    // Поcтроить внутренние объекты фрэйма
    procedure ObjCreate;
    // Показать список каталогов и файлов внутри текущего каталога
    procedure ViewDir;
    // Открыть документ
    procedure OpenDoc;
    //
    procedure AddNewFile(F:TSearchRec);
    // Обслуживание свойств
    procedure SetDblClick(Value: Boolean);
    function GetDblClick: Boolean;
  public
    function OpenDir(cDir:String): Integer;
    // Уничтожить и пометить внутренние объекты фрэйма кроме его самого
    procedure ObjFree;
  published
    property DblClick:Boolean read GetDblClick write SetDblClick;
  end;

implementation

uses
  TellmeFrm,LaziFramesAlerts;

var
  First: boolean=true;
  SubI: Integer=0;

{$R *.lfm}

// ****************************************************************************
// *                    Определить путь родительского каталога                *
// ****************************************************************************
function GetParentDir(const Dir:String):String;
// По входной строке находим самый правый \ и возвращает часть, расположенную
// левее него (т.е. возвращаемся из поддиректории)
var ii,lena,poza: Integer;
begin
  Result:=Dir;
  lena:=Length(Dir);
  // Если во входной строке нет "\", то исходную строку и возвращаем
  if Pos('\',Dir)=0 then exit;
  // Просматриваем строку Dir справа налево, если в ii-й позиции находится "\",
  // то poza присваивается номер этой позиции, а в переменную Result копируется
  // часть строки от позиции 1 до позиции poza-1
  for ii := lena downto 1 do begin
    if dir[ii]='\' then begin
      poza:=ii; Result:=Copy(dir,1,poza-1); break;
    end;
  end;
end;

// ****************************************************************************
// *                        Определить расширение файла                       *
// ****************************************************************************
function GetExtension(const FileName:String):String;
// По входной строке находим самую правую "." и возвращаем часть,
// расположенную правее неё
var
  i,nLen,nPoz: Integer;
begin
  Result:='';
  nLen:=Length(FileName);
  // Если во входной строке нет ".", то возвращаем ""
  if Pos('.',FileName)=0 then exit;
  // Просматриваем строку справа налево, если в i-й позиции находится ".",
  // то nPoz присваиваем номер этой позиции, а в переменную Result копируем
  // часть строки от следующей позиции до конца строки
  for i:=nLen downto 1 do begin
    if FileName[i]='.' then begin
      nPoz:=i; Result:=Copy(FileName,nPoz+1,MaxInt); break;
    end;
  end;
end;

{ TframeGuide }

// Считаем, что все объекты фрэйма (и публичные, и приватные, и имеющие Parrent,
// и не имеющие) создаются один раз при первом входе во фрэйм и умирают вместе с
// родительской формой фрэйма, поэтому их не уничтожаем при уходе фокуса из фрэйма

// Сам фрэйм уничтожается при уничтожении родительской формы, но предварительно
// фрэйм предоставляет возможность родительской форме уничтожить объекты фрэйма
// через публичный метод ObjFree

// Активируется фрэйм передачей фокуса на него в родительской форме

// ****************************************************************************
// *                     Поcтроить внутренние объекты фрэйма                  *
// ****************************************************************************
procedure TframeGuide.ObjCreate;
begin
  if not assigned(ilSmallIm) then begin
    ilSmallIm:=TImageList.Create(Self);
  end;
  if not assigned(ic) then begin
    ic:=TIcon.Create;
  end;
  if not assigned(sl) then begin
    sl:=TStringList.Create;
  end;
    // Устанавливаем фрэйм проводника
  if not assigned(ng) then begin
    ng:=TframeNumgress.Create(self);
    ng.Parent:=pnlNumgress;
    pnlNumgress.Height:=ng.Height;
    ng.Caption:='';
  end;
end;

// ****************************************************************************
// *     Уничтожить и пометить внутренние объекты фрэйма кроме его самого     *
// ****************************************************************************
procedure TframeGuide.ObjFree;
begin
  ng.Free; ng:=NIL;
  sl.Free; sl:=NIL;
  ic.Free; ic:=NIL;
  ilSmallIm.Free; ilSmallIm:=NIL;
end;

// Выполнить инициализацию фрэйма при выводе фокуса на него (так как событие
// создания фрэйма не управляемо из кода, то стандартная техника - извне
// перевести фокус на фрэйм и по этому событию выполнить начальные настройки
procedure TframeGuide.FrameEnter(Sender:TObject);
var
  i: Integer;
begin
  // Создаем объекты фрэйма один раз
  ObjCreate;
  // Инициализируем элементы для работы проводника
  // http://www.win-ni.narod.ru/lect/progListView.htm
  FRootView:='C:'; // указали папку начала просмотра (корневой каталог диска С)
  // Задаем характеристики списка мелких значков (у нас они 32х32)
  ilSmallIm.BkColor:= clBtnFace;
  ilSmallIm.BlendColor:= clwhite;
  ilSmallIm.DrawingStyle:= dsTransparent;
  ilSmallIm.masked:= false;
  ilSmallIm.Height := 32;
  ilSmallIm.Width := 32;
  ilSmallIm.AllocBy := 5;
  // Устанавливаем свойства столбцов (колонок)
  // lvGuide.Color:=$00CCCC99;
  lvGuide.Columns.Items[0].Width:=250; // ширина
  lvGuide.Columns.Items[0].Alignment:=taLeftJustify;
  lvGuide.Columns.Items[1].Width:=80;
  lvGuide.Columns.Items[1].Alignment:=taRightJustify;
  lvGuide.Columns.Items[2].Width:=120;
  lvGuide.Columns.Items[3].Width:=40;
  lvGuide.Columns.Items[4].Width:=40;
  for i:=2 to lvGuide.Columns.Count-1 do
    lvGuide.Columns.Items[i].Alignment:=taCenter;
  // Определяем папку, из которой запущена программа
  cDirExe:=ExtractFileDir(paramstr(0));
  // Загружаем иконку с изображением каталога из файла (индекс = 0)
  ic.LoadFromFile(cDirExe+'\Icons\SimpleDir32.ico');
  ilSmallIm.AddIcon(ic);
  // Загружаем иконку всяких-разных файлов (индекс = 1)
  ic.LoadFromFile(cDirExe+'\Icons\SimpleFile16.ico');
  ilSmallIm.AddIcon(ic);
  // Базы данных sqlite3 (индекс = 2)
  ic.LoadFromFile(cDirExe+'\Icons\Sqlite3-26.ico');
  ilSmallIm.AddIcon(ic);
  // Загружаем список расширений и программ обработки из файла Exten.txt
  sl.LoadFromFile(cDirExe+'\Exten.txt');
  // Подключаем иконки к ListView
  lvGuide.SmallImages:=ilSmallIm;
  // TellMe(lzfAllGreetings);
  // Просматриваем выбранную папку
  ViewDir;
end;

procedure TframeGuide.FrameClick(Sender: TObject);
begin
  //
end;

procedure TframeGuide.FrameExit(Sender: TObject);
begin
  // Из фрэйма пользователь всегда может уйти, переключившись на другую
  // форму, а объекты уничтожаются
  // TellMe(lzfTurnsOffWork);
end;

// ****************************************************************************
// *     Зафиксировать выделение пункта меню при перемещении по стрелке       *
// ****************************************************************************
procedure TframeGuide.lvGuideChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  nIndex: Integer;
begin
  nRowIndex:=self.lvGuide.ItemIndex;
  ng.Caption:='Change: '+IntToStr(nRowIndex);
end;

// ****************************************************************************
// *        Обеспечить двойной клик вместо одинарного при необходимости       *
// ****************************************************************************
procedure TframeGuide.lvGuideClick(Sender:TObject);
var
  nIndex: Integer;
begin
 nIndex:=self.lvGuide.ItemIndex;
 ng.Caption:='Click: '+IntToStr(self.lvGuide.ItemIndex);
 // if FDblClick then lvGuideDblClick(Sender);
end;

procedure TframeGuide.lvGuideColumnClick(Sender: TObject; Column: TListColumn);
  //щелчок по заголовку колонки
  //присваиваю SubI - индекс щелкнутой колонки  SubI := Column.Index;
  begin  SubI := Column.Index;
  lvGuide.AlphaSort;
   //выполняю сортировку (см также ListView1Compare, которая участвует в этом)
  Case SubI of
  0: Caption := 'Сортирую по имени';
  1: Caption := 'Сортирую по размеру';
  2: Caption := 'Сортирую по дате';
  3: Caption := 'Сортирую по скрытости';
  4: Caption := 'Сортирую по системности';
  end;
end;
procedure TframeGuide.lvGuideCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
Var s1,s2,st1,st2 : String;
{здесь задаем - по какому признаку (функции) сортировать. Заготовку для процедуры
получаем в инспекторе объектов. Если по нашему мнению, f(Item1) < f(Item2), то
мы должны присвоить переменной Compare величину -1, если  f(Item1) > f(Item2),
то Compare = 1, если  f(Item1) = f(Item2), то Compare = 0;
Например, нужно сортировать по размеру файла. Тогда функция f(Item)
 - это размер файла, т е Item1.SubItems[0]. Дело осложняется тем, что размер
 - это число, а Item1.SubItems[0] - строка.
 строки сортируются иначе, например '100' < '44' (сравниваются вначале 1-е символы).
  Чтобы обойти это осложнение, дополняем числа слева нулями до длины 12 -
 если сортируем по имени файла.  Тогда функция f(Item) - это имя файла,
 те Item.Caption.
 Глобальная переменая SubI задает вид сортрировки. Ее величина задается при
 щелчке по заголоку сортируемой колонки (см процедуру ListView1ColumnClick).
 Другое осложнение связано с тем, что папки должны при любой сортировке
 располагаться выше файлов т е быть "меньше". Для этого к сформированным строкам
 слева приписывается '0' - для папок и '1' - для файлов. Тогда всегда
 папка < файл. }
begin
  Case SubI of
  0:begin s1 := Item1.Caption; s2 := Item2.Caption;
    end;
  1: begin
      s1:= {Item1.SubItems.Strings[0]; а можно короче: } Item1.SubItems[0];
         while length(s1) < 12 do s1 := '0'+s1;
      s2:= Item2.SubItems.Strings[0]; while length(s2) < 12 do s2 := '0'+s2;
     end;
  2: begin  Str(StrToDateTime(Item1.SubItems.Strings[1]):10:10,s1);
            Str(StrToDateTime(Item2.SubItems.Strings[1]):10:10,s2);
     end;
  3:Begin
    s1 :=  Item1.SubItems.Strings[SubI - 1];
    s2 :=  Item2.SubItems.Strings[SubI - 1];
    end;
  end;

  st1 := IntToStr(Item1.ImageIndex)+ s1;
  st2 := IntToStr(Item2.ImageIndex)+ s2;
{чтобы сортировать, во первых папка-файл, во вторых: по имени, алфавитно}
If st1 = st2 then Compare := 0 else
If st1 < st2 then Compare := -1 else Compare := 1;
end;

// ****************************************************************************
// *                         Обслужить двойной щелчок                         *
// ****************************************************************************
procedure TframeGuide.lvGuideDblClick(Sender: TObject);
begin
  // если щелкнули по иконке с папкой, то выполнить ViewDir
  // если щелкнули по иконке с файлом, то выполнить OpenDoc
  //if lvGuide.Selected<>NIL then
  //if lvGuide.Selected.ImageIndex=0 then ViewDir else OpenDoc
  //else ShowMessage('Нужно выбрать строку'); // Если щелкнули не по иконке
end;

procedure TframeGuide.mmiDoubleClickClick(Sender: TObject);
begin
  if mmiDoubleClick.ImageIndex=1 then begin
    mmiDoubleClick.Caption:='Вернуться к одинарному щелчку';
    mmiDoubleClick.ImageIndex:=0;
    DblClick:=True;
  end else begin
    mmiDoubleClick.Caption:='Включить двойной щелчок';
    mmiDoubleClick.ImageIndex:=1;
    DblClick:=False;
  end;
end;

// ****************************************************************************
//  *                                Выбрать диск                             *
// ****************************************************************************
procedure TframeGuide.mmiSelAClick(Sender: TObject);
begin
  OpenDir('A:\')
end;
procedure TframeGuide.mmiSelCClick(Sender: TObject);
begin
  OpenDir('C:\')
end;
procedure TframeGuide.mmiSelDClick(Sender: TObject);
begin
  OpenDir('D:\')
end;
procedure TframeGuide.mmiSelZClick(Sender: TObject);
begin
  OpenDir('Z:\')
end;

// ****************************************************************************
//  *                        Подписать выбранный каталог                      *
// ****************************************************************************
procedure TframeGuide.mmiSignFolderClick(Sender: TObject);
begin
  Showmessage('Каталог '+FRootView+' подписан!');
end;

// ****************************************************************************
//  *       Показать список каталогов и файлов внутри текущего каталога       *
// ****************************************************************************
procedure TframeGuide.ViewDir;
var
  FilesDir: TSearchRec;   // Поисковик каталогов и файлов
  Fa: Integer;
  selcap: String;
begin
 if  lvGuide.Selected <> Nil then // т е если выбрана какая-то строка
   begin
     selcap := lvGuide.Selected.Caption; //selcap := Caption выбранной строки
     If pos('..',selcap) > 0  then  // если в selcap есть строка ".."
       cCurrentDir := GetParentDir(FRootView) else // Отбрасываем от edFind.Text все, что правее
       // самого правого символа / (включительно). Получаем папку, из которой мы сюда попали.
       cCurrentDir := FRootView +'\'+ selcap; //  если в selcap нет строки ".." , то
       // "пристегиваем" текст selcap справа к edFind.Text, вставив перед этим символ /
   end // т е здесь мы погружаемся или всплываем по дереву папок (директорий, каталогов)
       // диска.
 else cCurrentDir := FRootView;

 lvGuide.Items.Clear; // очищаем список
 Fa := faAnyFile; // атрибуты искомых файлов - любые;
 If FindFirst(cCurrentDir+'\*.*',Fa,FilesDir) <> 0 then exit; //находим в папке CurrentDir любой файл
 AddNewFile(FilesDir); // добавляем его характеристики в список (смотри AddNewFile()
 while FindNext(FilesDir) = 0 do  AddNewFile(FilesDir); // находим остальные файлы (и папки), пока они есть
 FindClose(FilesDir); lvGuide.AlphaSort; //закрываем поиск. сортируем строки списка
 // ( ListView1.AlphaSort - метод, который сортирует список, используя ListView1Compare)
 //см ListView1Compare. Здесь мы должны описать, какую сортировку мы хотим.
 FRootView := cCurrentDir; //помещаем в edFind.Text папку, которую мы рассматриваем
 Caption := cCurrentDir; // ее же - в заголовок формы
 if first then first:= false;
end;

procedure TframeGuide.OpenDoc; //Процедура открытия документа.
var  zFileName: array[0..600] of Char ; //буфер (место) для хранения командной строки
  exten,ExUP,FNam,Proga: string; ii: Integer;
begin  for ii:= 0 to 600 do zFileName[ii] := #0; //очистка буфера
  exten := ExtractFileExt(lvGuide.Selected.Caption);// найдем расширение файла документа
  ExUP := UPPERCASE(exten); //переводим расширение в верхний регистр (заглавные)
  Proga :=sl.Values[ExUP]; //извлекаем из TSL.Values имя программы-обработчика
  //(по известному расширению). Для этого используется файл Exten.txt, заполняемый вручную
  // Содержимое файла загружается в объект TSL в процедуре TForm1.Create (смотри)
  If (length(Proga)<3) and (ExUP<>'.EXE') then showmessage
   ('Не известен обработчик этого расширения>'+ExUp+'<-->'+Proga+'<'+#13#10+
   'добавьте его в файл Exten.txt');
  //FNam - это текст команды, которая будет передана операционной системе. Команда состоит
  // из двух частей. Сначала - имя программы обработчика (Proga), затем (через пробел, храня
  //щийся в файле Exten.txt) - имя документа. Обе эти части дожны содержать полный путь.
  // Имя документа составляется из 2-х частей: путь (папка)(edFind.Text) и имя документа
  //(ListView1.Selected.Caption).  между ними - знак /
  FNam := Proga +'"'+ FRootView + '\'+ lvGuide.Selected.Caption+'"';
  //StaticText1.caption := 'Команда>' + FNam;
  StrPCopy(zFileName,FNam); //Копирование строки FNam в строку, тип которой (PChar) необъодим
  // для процедуры WinExec
  try // страховка на случай ошибки
    // WinExec(zFileName,SW_SHOW);
  except
  end;
end;

// ****************************************************************************
// *      Добавить в список папки просмотра, очередной каталог или файл       *
// ****************************************************************************
procedure TframeGuide.AddNewFile(F:TSearchRec);
var
  Hid: String;
  It2: TListItem; // It2 - объект, который будет вставляться в список
  cExt: String;
begin
  // Добавляем пустой объект в список
  It2:=lvGuide.Items.Add;
  It2.Caption:=F.Name; // в первой колонке строки добавили имя файла или папки
  // Если F есть каталог (F.Attr and faDirectory) <> 0, то берем иконку с
  // индексом 0, а во второй колонке разместим соответствующий текст
  // (каждый SubItems.Add добавляет субайтем, т.е. переводит нас
  // в следующую колонку. Начало с нулевого субайтема
  if (F.Attr and faDirectory) <> 0 then begin
    It2.ImageIndex:=0;
    It2.SubItems.Add(' папка '); // во 2-ую колонку "размер" вложили "папка"
  end
  // Иначе считаем, что это файл и анализируем расширение
  else begin
    cExt:=GetExtension(F.Name);
    // Как правило, это обычная иконка с индексом 1
    It2.ImageIndex:=1;
    // Отмечаем 2 иконкой базы данных SQLite3
    if AnsiUpperCase(cExt)='DB3' then It2.ImageIndex := 2;
    // Во второй колонке размещаем размер файла
    It2.SubItems.Add(IntToStr(F.Size));
  end;
  // В 3-ю колонку записываем время сохранения файла F.Time
  It2.SubItems.Add(DateTimeToStr((FileDateToDateTime(F.Time))));
  // Показываем скрытые и системные файлы
  if (F.Attr and faHidden) <> 0 then Hid := 'да' else Hid := 'нет';
  It2.SubItems.Add(Hid);
  if (F.Attr and faSysFile) <> 0 then Hid := 'да' else Hid := 'нет';
  It2.SubItems.Add(Hid);
end;

{procedure TframeGuide.AddNewFile(F:TSearchRec);//вызывается из процедуры OpDir при
 //просмотре файлов находящихся в просматриваемой папке. Каждый вызов AddNewFile
 // добавляет строку в список ListVew1.
Var Hid: String;  It2: TListItem; // It2 - объект, который будет вставляться в список
begin
 {with ListView1.Items.Add, F do - проще понимать без него }
 //Оператор with одновременно над ListView1.Items.Add и над F
  begin It2:= lvGuide.Items.Add; //метод Add добавляет пустой объект в список
     It2.Caption := F.Name; //имя файла (из F ) передается в св-во Caption, т е
      //будет видно в первой колонке строки
     if (F.Attr and faDirectory) <> 0 then // F.Attr - атрибут файла или папки.
      // если F есть директория (папка), то (F.Attr and faDirectory) <> 0
      begin It2.ImageIndex := 0; //тогда для него будет иконка с индексом 0
       It2.SubItems.Add(' папка ');//а во второй колонке (размер) будет " папка"
      end
      else //иначе (т е это не папка а файл)
      begin It2.ImageIndex := 1; //тогда для него будет иконка с индексом 1
       It2.SubItems.Add(IntToStr(F.Size));
        //а во второй колонке (размер) будет размер файла
      end;
    It2.SubItems.Add(DateTimeToStr((FileDateToDateTime(F.Time))));
    // в 3-ю колонку запишем
    // время сохранения файла F.Time (каждый SubItems.Add добавляет субитем,
    // т е переводит нас
    // в следующую колонку. Начало с нулевого субитема
    //(он будет во 2-й колонке - "размер")

    If (F.Attr and faHidden) <> 0 then Hid := 'да' else Hid := 'нет';
    It2.SubItems.Add(Hid);
    If (F.Attr and faSysFile) <> 0 then Hid := 'да' else Hid := 'нет';
    It2.SubItems.Add(Hid);
  end;
end;}

procedure TframeGuide.pnlResize(Sender: TObject);
var
  nmesHeight: Integer; // Высота поля редактирования
begin
  // Пересчитываем nmesHeight, так как во время жизни фрэйма (от его неявного
  // создания до вывода фокуса на него и далее до закрытия фрэйма) не всегда
  // присутствует поле редактировани
  {if assigned(edtMessage) then nmesHeight:=edtMessage.Height
  else nmesHeight:=0;}
  // Позиционируем кнопки на фрэйме
  {bbtnOk.Left:=Self.Width-10-bbtnOk.Width-bbtnCancel.Width;
  bbtnCancel.Left:=Self.Width-5-bbtnCancel.Width;
  bbtnOk.Top:=Self.Height-6-bbtnOk.Height-nmesHeight;
  bbtnCancel.Top:=Self.Height-6-bbtnOk.Height-nmesHeight;}
end;

function TframeGuide.OpenDir(cDir:String): Integer;
begin
  FRootView:=cDir; cCurrentDir:=cDir; ViewDir;
end;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// Обеспечить доступ к свойству "Двойной клик"
procedure TframeGuide.SetDblClick(Value:Boolean);
begin
  FDblClick:=Value;
end;
function TframeGuide.GetDblClick:Boolean;
begin
  Result:=DblClick;
end;


end.

