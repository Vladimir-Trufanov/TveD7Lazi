unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    BitBtn1: TBitBtn;
    StaticText1: TStaticText;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
     TSL : TStringList;
     SmallIm: TImageList;
     IC1: TIcon;
     procedure AddNewFile(F:TSearchRec);
     procedure OpDir;
     procedure OpDoc;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation uses ShellAPI, ImgList;
{$R *.DFM}
Var Dira : String; SubI: Integer = 0;
 CurrentDir: String = '';
 First: boolean = true;
 edFindText: string;

function Old_Dira(const dir: string):String; 
//В строке dir находит самый правый \ и возвращает часть dir, расположенную
//левее него (т е возвращаемся из поддиректории )
var ii,lena,poza: Integer;
begin  lena := Length(dir); // длина строки dir
 If Pos ('\',dir) = 0 then // если в строке нет символа /
  begin Result := dir; exit; // возвращает исходную строку dir 
  end;
 for ii := lena downto 1 do // просматриваю строку dir справа налево
  begin if dir[ii] = '\' then // если в ii-й позиции находится /
    begin poza := ii; Result := Copy(dir,1,poza-1); break; 
     // poza - позиция в которой находится символ /
     // В переменную Result копируется часть строки от позиции 1 до позиции poza-1
     // Переменная Result является результатом работы функции.
    end;
  end;
end;

procedure TForm1.OpDir;
Var F: TSearchREc; Fa: Integer; selcap: String;
begin
If  ListView1.Selected <> Nil then // т е если выбрана какая-то строка
begin  selcap := ListView1.Selected.Caption; //selcap := Caption выбранной строки
 If pos('..',selcap) > 0  then  // если в selcap есть строка ".." 
  CurrentDir := Old_Dira(edFindText) else // Отбрасываем от edFind.Text все, что правее
   // самого правого символа / (включительно). Получаем папку, из которой мы сюда попали.
  CurrentDir := edFindText +'\'+ selcap; //  если в selcap нет строки ".." , то
  // "пристегиваем" текст selcap справа к edFind.Text, вставив перед этим символ /
 end // т е здесь мы погружаемся или всплываем по дереву папок (директорий, каталогов)
     // диска.
     else CurrentDir := edFindText;

ListView1.Items.Clear; // очищаем список 
Fa := faAnyFile; // атрибуты искомых файлов - любые;
 If FindFirst(CurrentDir+'\*.*',Fa,F) <> 0 then exit; //находим в папке CurrentDir любой файл
  AddNewFile(F); // добавляем его характеристики в список (смотри AddNewFile()
 while FindNext(F) = 0 do  AddNewFile(F); // находим остальные файлы (и папки), пока они есть
  FindClose(F); ListView1.AlphaSort; //закрываем поиск. сортируем строки списка
// ( ListView1.AlphaSort - метод, который сортирует список, используя ListView1Compare)
//см ListView1Compare. Здесь мы должны описать, какую сортировку мы хотим. 
edFindText := CurrentDir; //помещаем в edFind.Text папку, которую мы рассматриваем
Caption := CurrentDir; // ее же - в заголовок формы
if first then first:= false else
StaticText1.caption := '';
end;

procedure TForm1.OpDoc; //Процедура открытия документа.
var  zFileName: array[0..600] of Char ; //буфер (место) для хранения командной строки
  exten,ExUP,FNam,Proga: string; ii: Integer;
begin  for ii:= 0 to 600 do zFileName[ii] := #0; //очистка буфера
  exten := ExtractFileExt(ListView1.Selected.Caption);// найдем расширение файла документа
  ExUP := UPPERCASE(exten); //переводим расширение в верхний регистр (заглавные)
  Proga := TSL.Values[ExUP]; //извлекаем из TSL.Values имя программы-обработчика 
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
  FNam := Proga +'"'+ edFindText + '\'+ ListView1.Selected.Caption+'"';
  StaticText1.caption := 'Команда>' + FNam;
  StrPCopy(zFileName,FNam); //Копирование строки FNam в строку, тип которой (PChar) необъодим
  // для процедуры WinExec
  try // страховка на случай ошибки
  WinExec(zFileName,SW_SHOW);
  except
  end;
end;

procedure TForm1.FormCreate(Sender: TObject); //действия при создании формы
var ii: Integer;
begin
 edFindText := 'C:'; //папка, с которой начинаем просмотр ( корневой каталог диска С )
 //задаем характеристики списка мелких значков. ( у нас они 32х32 )
 SmallIm := TImageList.Create(Self); //создаем объект (и выделяем память)
 SmallIm.BkColor:= clBtnFace;  SmallIm.BlendColor:= clwhite;
 SmallIm.DrawingStyle:= dsTransparent;  SmallIm.masked:= false;
 SmallIm.Height := 32; SmallIm.Width := 32; SmallIm.AllocBy := 5;

 Ic1 := TIcon.Create; { т к не являются КОМПОНЕНТАМИ }
  //создаем объект (и выделяем память)

 Dira:= ExtractFileDir(paramstr(0)); //Dira - папка, из которой запущена программа

for ii:= 0 to ListView1.Columns.Count - 1 do //устанавливаем свойства столбцов (колонок)
  ListView1.Columns.Items[ii].Alignment := taCenter;

  ListView1.Columns.Items[0].Width := 200; //ширина 
  ListView1.Columns.Items[1].Width := 80;
  ListView1.Columns.Items[2].Width := 140;
  ListView1.Columns.Items[3].Width := 40;
  ListView1.Columns.Items[4].Width := 40;

  Ic1.LoadFromFile(Dira+'\16843.ico'); //загружаем иконку из файла
  SmallIm.AddIcon(Ic1);//она добавлена первой, поэтому ее индекс = 0 (начало отсчета с нуля)
  Ic1.LoadFromFile(Dira+'\3106.ico'); //загружаем иконку из файла 
  SmallIm.AddIcon(Ic1);//она добавлена второй, поэтому ее индекс = 1
  TSL := TStringList.Create; //создаем объект TSL класса TStringList.Create
  TSL.LoadFromFile(Dira+'\Exten.txt'); //загружаем в TSL текстовый файл Exten.txt
  ListView1.SmallImages := SmallIm; //"подключаем" сформированный выше список иконок
  // к списку ListView1. т е теперь им можно пользоваться, как свойством ListView1
 OpDir; //просматриваем папку (см процедуру OpDir )
end;

procedure TForm1.AddNewFile(F:TSearchRec);//вызывается из процедуры OpDir при
 //просмотре файлов находящихся в просматриваемой папке. Каждый вызов AddNewFile
 // добавляет строку в список ListVew1.
Var Hid: String;  It2: TListItem; // It2 - объект, который будет вставляться в список
begin
 {with ListView1.Items.Add, F do - проще понимать без него }
 //Оператор with одновременно над ListView1.Items.Add и над F
  begin It2:= ListView1.Items.Add; //метод Add добавляет пустой объект в список
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
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
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

procedure TForm1.ListView1DblClick(Sender: TObject);
begin //двойной щелчок по окну списка
// если щелкнули по иконке с папкой, то выполнить OpDir
// если щелкнули по иконке с файлом, то выполнить OpDoc
 If  ListView1.Selected <> Nil then
 If  ListView1.Selected.ImageIndex = 0 then  OpDir
 else OpDoc else
   showmessage('Нужно выбрать строку');//если щелкнули не по иконке
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);//щелчок по заголовку колонки 
//присваиваю SubI - индекс щелкнутой колонки  SubI := Column.Index;
begin  SubI := Column.Index;
 ListView1.AlphaSort;
   //выполняю сортировку (см также ListView1Compare, которая участвует в этом)
 Case SubI of
 0: Caption := 'Сортирую по имени';
 1: Caption := 'Сортирую по размеру';
 2: Caption := 'Сортирую по дате';
 3: Caption := 'Сортирую по скрытости';
 4: Caption := 'Сортирую по системности';
 end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin   {освобождаю объекты, созданные в методе Form1.Create }
 SmallIm.Free; IC1.Free; TSL.Free; 
end;

procedure TForm1.Button2Click(Sender: TObject);
begin {перехожу на С: }//кнопка быстрого перехода на С: 
 edFindText := 'C:'; CurrentDir := 'C:'; OpDir;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin  {перехожу на D }//кнопка быстрого перехода на D:
 edFindText := 'D:';  CurrentDir := 'D:'; OpDir;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin  {перехожу на A }//кнопка быстрого перехода на A: 
 edFindText := 'A:';  CurrentDir := 'A:'; OpDir;
end;

procedure TForm1.ListView1Click(Sender: TObject);
begin //эта проц написана, чтобы одинарным щелчком делать то, что обычно делается
 // двойным щелчком. Вначале проверяется - установлена ли птичка на CheckBox1
  If CheckBox1.Checked then ListView1DblClick(Sender);
 // если птичка установлена (.Checked) то вызывается процедура, обрабатывающая двойной щелчок
 // (ListView1DblClick)
end;

procedure TForm1.Button1Click(Sender: TObject);
begin  {перехожу на E }//кнопка быстрого перехода на E:
 edFindText := 'E:';  CurrentDir := 'E:'; OpDir;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin  {перехожу на F }//кнопка быстрого перехода на F:
 edFindText := 'F:';  CurrentDir := 'F:'; OpDir;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin  {перехожу на G }//кнопка быстрого перехода на G:
 edFindText := 'G:';  CurrentDir := 'G:'; OpDir;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin  {перехожу на H }//кнопка быстрого перехода на H:
 edFindText := 'H:';  CurrentDir := 'H:'; OpDir;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin  {перехожу на Z }//кнопка быстрого перехода на Z:
 edFindText := 'Z:';  CurrentDir := 'Z:'; OpDir;
end;

end.

