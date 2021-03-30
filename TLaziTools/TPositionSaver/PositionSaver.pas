// DELPHI7, WIN98\XP                                  *** PositionSaver.pas ***

// ****************************************************************************
// * PositionSaver [0150]     Хранитель местоположений элементов, размещенных *
// *  на форме, при необходимости, выполняющий сброс местоположений элементов *
// *                                                      в начальные условия *
// ****************************************************************************

//                                                   Автор:      Труфанов В.Е..
//                                                   Дата создания:  21.01.2007
// Copyright © 2011 TVE                              Посл.изменение: 13.10.2011

// Свойства
//
//   FileName - наименование конфигурационного файла с местоположениями элемен-
//       тов следующих типов: TDBGrid, TPanel, TSplitter, TDBNavigator, TDBMemo
//
//   CharDefault -  код клавиши сброса местоположений активной формы в  началь-
//  ные условия. По умолчанию установлена клавиша "F7", код клавиши VK_F7 = 118
//
// Методы
//
//   _Open(AOwner:TComponent; lSaved:Boolean=True) [private] -  установить  па-
// раметры компонентов формы,  согласно конфигурационному файлу lSaved=True или
// в сброшенном состоянии lSaved=False.  Метод всегда запускается из компонента
// при его создании вместе с родительской формой.
//
//   Open(AOwner:TComponent; lMake:Boolean=False) [public]  - метод запускается
// из приложения.   По умолчанию lMake=False выводится сообщение, что метод уже
// был выполнен при создании формы. Если необходимо перевоспроизвести положение
// компонентов в иной ситуации, отличной от создания формы  (например, при каж-
// дой активации окна), то при вызове метода нужно установить lMake=True.
//
//   _Save(AOwner:TComponent) [private] - сохранить параметры компонентов формы
// в конфигурационном файле. Метод запускается автоматически при закрытии роди-
// тельской формы компонента.
//
//   Save(AOwner:TComponent; lMake:Boolean=False) [public]  - принудительно со-
// хранить параметры компонентов формы в конфигурационном файле lMake=True.

// Замечания по использованию:
//
//   Сохраняется информации о позиции и размере формы,  а также  о положениях и
// и размерах всех стоблцов всех DBGrid формы. Кроме этого сохраняются местопо-
// ложения сплиттеров на форме.

unit PositionSaver;

interface

uses
  //AppEvnts,
  SysUtils, Classes, forms,
  //Registry,
  Messages, Windows, Grids, DBGrids,
  //QExtCtrls,
  STDCTRLS,  Graphics, Controls,ExtCtrls,DBCtrls, DB;

const
  Component_version=301;  // 3.01  Номер редакции компонента

type
  TPositionSaver = class
  private
    // Хранители свойств объекта
    FForm: TForm;         // Контроллируемая форма
    FIniName: string;     // Наименование Ini-файла
    FCharDefault: Word;   // Код клавиши сброса местоположения в начальные условия


    // Объектовые параметры
    aDefault: Variant;    // Массив с настройками компонентов формы


    //fp: TextFile;         // Файл с сохраненными настройками
    //FFirstOpen: Boolean;  // True - предстоит первое сообщение форме для Open
    //FCleaPosit: Boolean;  // True - стереть позиции элементов текущей формы
    //FAppliEvents: TApplicationEvents;
    //FOnClose: TCloseQueryEvent;
    //procedure _Open(AOwner:TComponent; lSaved:Boolean=True);
    //procedure _Save(AOwner:TComponent);
    procedure Default;
    function isControlPlace(Control:TComponent): Boolean;
    //procedure FormReplace(var fp:textfile; AOwner:TComponent; lSaved:Boolean);
    //procedure ControlReplace(Control:TControl; var fp:textfile; lSaved:Boolean);
    //procedure ControlSetBound(Control:TControl; var fp:textfile; lSaved:Boolean);
    //procedure SetDefault(Control:TControl);
    //procedure SaveControl(MainControl: TControl; fname: String);
    //procedure AppliEventsMessage(var Msg:tagMSG; var Handled:Boolean);
    //procedure OnFormCloseQuery(Sender:TObject; var CanClose:Boolean);
  protected
    { Protected declarations }
  public
    constructor Create(oOwner:TForm); //override;
    //procedure Open(AOwner:TComponent; lMake:Boolean=False);
    //procedure Save(AOwner:TComponent; lMake:Boolean=False);
    function GetForm:TForm;
    procedure SetForm(Value:TForm);
    function GetFileName:string;
    procedure SetFileName(Value:string);
    function GetCharDefault:Word;
    procedure SetCharDefault(Value:Word);
    destructor Destroy; override;
  published
    property Form:TForm read GetForm write SetForm;
    property CharDefault:Word read GetCharDefault write SetCharDefault;
    property FileName:string read GetFileName write SetFileName;
  end;

implementation

uses
  ArrayLib,
  Variants,Dialogs,Math,
  //DBTables,
  IniFiles;

{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// Обеспечить доступ к свойству "Контроллируемая форма"
function TPositionSaver.GetForm:TForm;
begin
  Result:=FForm;
end;
procedure TPositionSaver.SetForm(Value:TForm);
begin
  FForm:=Value;
end;

// Обеспечить доступ к свойству "Наименование INI-файла"
function TPositionSaver.GetFileName:String;
begin
  Result:=FIniName;
end;
procedure TPositionSaver.SetFileName(Value:String);
begin
  FIniName:=Value;
  //_Open(Owner,True);
end;

// Обеспечить доступ к свойству
// "Код клавиши сброса местоположения в начальные условия"
function TPositionSaver.GetCharDefault:Word;
begin
  Result:=FCharDefault;
end;
procedure TPositionSaver.SetCharDefault(Value:Word);
begin
  FCharDefault:=Value;
end;

{  ................................. МЕТОДЫ ..................................}

// ****************************************************************************
// *                         Добраться до главной формы                       *
// ****************************************************************************
{function GetMainForm(AOwner:TComponent):TForm;
var
  oComponent: TComponent;
begin
  if (AOwner is TForm) then Result:=AOwner as TForm else Result:=NIL;
  oComponent:=AOwner;
  while Assigned(oComponent) do begin
    oComponent:=oComponent.Owner;
    if (oComponent is TForm) then Result:=oComponent as TForm;
  end;
end;}

// ****************************************************************************
// *                             Создать объект                               *
// ****************************************************************************
constructor TPositionSaver.Create(oOwner:TForm);
begin
  // Загружаем в свойство контроллируемую форму oOwner. Для подчинения
  // объекту PositionSaver указанная форма должна быть в состоянии:
  // oOwner.Position:=poDesigned
  FForm:=oOwner;
  //if AOwner.Name=GetMainForm(AOwner).Name
  //then GetMainForm(AOwner).Position:=poDesigned;
  
  //if not(csDesigning in ComponentState) then begin
  //  FAppliEvents:=TApplicationEvents.Create(AOwner);
  //  FAppliEvents.OnMessage:=AppliEventsMessage;
  //end;
  //if (AOwner is TForm) then begin
  //  FOnClose:=(AOwner as TForm).OnCloseQuery;
  //  (AOwner as TForm).OnCloseQuery:=OnFormCloseQuery;
  //end;
  //Tag:=0;   // Запретили внешнюю трассировку сообщений
  //FCharDefault:=VK_F7;
  // Инициируем умалчиваемые параметры расположения компонентов формы 
  Default;
  //FCleaPosit:=False;  // True - стереть позиции элементов текущей формы
  //
  // Здесь можно было бы вызвать _Open(AOwner,True), но по DBGrid в этом месте
  // число колонок равно 0, поэтому вызов метода будет делаться вместе с
  // ближайшим сообщением OnMessage хозяйской форме
  //FFirstOpen:=True;
end;

{// ****************************************************************************
// *               Отловить сообщение о закрытии формы приложения             *
// ****************************************************************************
procedure TPositionSaver.OnFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  _Save(Owner);
  if Assigned(FOnClose) then FOnClose(Sender, CanClose);
  FCleaPosit:=False;  // True - стереть позиции элементов текущей формы
end;}

// ****************************************************************************
// *  Отловить сообщения и выполнить сброс местоположений элементов в началь- *
// *  ные условия или сохранить местоположения (отработку сообщений выполняем *
// *                           только в активном окне                         *
// ****************************************************************************
{procedure TPositionSaver.AppliEventsMessage(var Msg:tagMSG; var Handled: Boolean);
var
  TypeMess: Cardinal;
begin
  TypeMess:=msg.message;
  // Для управления внешней программой (например для трассировки сообщений)
  // по клавише "с" устанавливаем флаг
  if (TypeMess=WM_KEYDOWN)and(67=msg.wParam)
  then begin
    Tag:=1;  // Разрешили внешнюю трассировку сообщений
  end
  // По клавише "пробел" сбрасываем флаг
  else if (TypeMess=WM_KEYDOWN)and(32=msg.wParam)
  then begin
    Tag:=0;   // Запретили внешнюю трассировку сообщений
  end;
  // Управление местоположениями выполняем только
  // для активного хозяйского окна
  // (для главной формы пока не получается = 13.10.2011)
  if (Owner is TForm)and(Owner as TForm).Active then begin
    TypeMess:=msg.message;
    if FFirstOpen then begin
      FFirstOpen:=False;
      _Open(Owner,True);
    end;
    // Отлавливаем и отрабатываем нажатие на клавишу 'F7' (по умолчанию)
    // и сбрасываем местоположение в текущем активном окне
    if (TypeMess=WM_KEYDOWN)and(msg.wParam=FCharDefault) then begin
      FCleaPosit:=True;  // True - стереть позиции элементов текущей формы
      (Owner as TForm).Close;
    end;
  end;
  Handled:=False;
end;}

// ****************************************************************************
// *                               Уничтожить объект                          *
// ****************************************************************************
destructor TPositionSaver.Destroy;
begin
  //inherited Destroy;
end;

{function ReadInteger(var F: TextFile; out Value: Integer): Boolean;
begin
  Result := False;
  {$I-}
  ReadLn(F, Value);
  if IOResult = 0 then
    Result := True;
  {$I+}
end;

const
  ERROR_AOWNER = 'Форма должна быть передана в качестве параметра метода %s';

procedure TPositionSaver.SetDefault(Control:TControl);
var
  i: Integer;
begin
  for i:=1 to aLen(aDefault) do begin
    if Control.Name=Trim(aDefault[i][1])
    then begin
      Control.Width:=aDefault[i][2];
      Control.Height:=aDefault[i][3];
      Control.Top:=aDefault[i][4];
      Control.Left:=aDefault[i][5];
      break;
    end;
  end;
end;}

// ****************************************************************************
// *                Установить новое размещение Control-элемента              *
// ****************************************************************************
{procedure TPositionSaver.ControlSetBound(Control:TControl; var fp:textfile; lSaved:Boolean);

  function SetBound(var fp:textfile): Integer;
  var
    ntmp: Integer;
  begin
    SetBound:=0;
    if ReadInteger(fp,ntmp) then begin
      SetBound:=ntmp;
    end;
  end;

begin
  if isControlPlace(Control)
  then begin
    if lSaved then begin
      Control.Width:=SetBound(fp);
      Control.Height:=SetBound(fp);
      Control.Top:=SetBound(fp);
      Control.Left:=SetBound(fp);
    end
    else SetDefault(Control);
  end;
end;}

// ****************************************************************************
// *             Перевести элемент Control в сохраненное положение            *
// ****************************************************************************
{ procedure TPositionSaver.ControlReplace(Control:TControl; var fp:textfile; lSaved:Boolean);
var
  dbntmp: TDBGrid;
  ntmp,cln,j: integer;
begin
  // Восстанавливаем положение и размеры таблиц, задаём размеры всех столбцов
  if (Control is TDBGrid)and((Control as TDBGrid).Columns.Count>0) then begin
    ControlSetBound(Control,fp,lSaved);
    // Восстанавливаем положение колонок TDBGrid
    dbntmp:=(Control as TDBGrid);
    // Как сохраненные
    if lSaved then begin
      ReadInteger(fp, cln);
      cln := Min(cln, dbntmp.Columns.Count);
      for j:=0 to cln-1 do begin
        if ReadInteger(fp,ntmp) then begin
          dbntmp.Columns[j].Width:=ntmp;
        end;
      end;
    end
    // Все колонки по умолчанию
    else begin
      for j:=0 to dbntmp.Columns.Count-1 do begin
        dbntmp.Columns[j].Width:=16;
      end;
    end;
  end
  // Восстанавливаем положение и размеры других компонент
  else begin
    ControlSetBound(Control,fp,lSaved);
  end;
end;}

// ****************************************************************************
// *          Восстановить форму и ее элементы в умалчиваемом состоянии       *
// *                              или в сохраненном                           *
// ****************************************************************************
{procedure TPositionSaver.FormReplace(var fp:textfile; AOwner:TComponent; lSaved:Boolean);
var
  ctemp: string;
  fname: string;
  i,ntmp,cn: integer;
  vNames,vAli: variant;
  Component: TComponent;
  Control: TControl;
  Form: TForm;
begin
  while not(eof(fp)) do begin
    fname:=AOwner.Name;
    // Просматриваем файл для поиска координат и элементов формы
    repeat Readln(fp,ctemp)
    until (Copy(ctemp,2,length(ctemp)-2)=fname) or (eof(fp));
    if (eof(fp)) then break;  // форма не найдена, элементы не изменяем
    // Определяем по условию положение формы
    Form:=AOwner as TForm;
    if lSaved then begin
      if ReadInteger(fp,ntmp) then Form.Width:=ntmp;
      if ReadInteger(fp,ntmp) then Form.Height:=ntmp;
      if ReadInteger(fp,ntmp) then Form.Top:=ntmp;
      if ReadInteger(fp,ntmp) then Form.Left:=ntmp;
    end
    else begin
      Form.Width:=aDefault[1][2];
      Form.Height:=aDefault[1][3];
      Form.Top:=aDefault[1][4];
      Form.Left:=aDefault[1][5];
    end;
    ReadInteger(fp, cn);
    vNames:=VarArrayCreate([1,cn], varVariant);
    vAli:=VarArrayCreate([1,cn], varVariant);
    // Обрабатываем все компоненты формы
    for i:=1 to cn do begin
      Readln(fp, ctemp);
      ctemp:=Copy(ctemp, 2, length(ctemp)-2);
      Component:=AOwner.FindComponent(ctemp);
      if Component is TControl then Control:=Component as TControl
      else Control:=nil;
      if Component is TControl then begin
        vNames[i]:=Component.Name;
        vAli[i]:=Control.Align;
        Control.Align:=alCustom;
        // Восстанавливаем положение и размеры таблиц,
        // задаём размеры всех столбцов
        ControlReplace(Control,fp,lSaved);
      end;
    end;
    // Восстанавливаем старые значения align
    for i:=cn downto 1 do begin
      Component:=AOwner.FindComponent(vNames[i]);
      if Component is TControl then (Component as TControl).Align:=vAli[i];
    end;
  end;
end;}

// ****************************************************************************
// *     Проверить является ли компонент формы компонентом с сохраняемым      *
// *                         местоположением на экране                        *
// ****************************************************************************
function TPositionSaver.isControlPlace(Control:TComponent): Boolean;
begin
  Result:=False;
  if (Control is TDBGrid)
  or(Control is TPanel)
  or(Control is TSplitter)
  or(Control is TDBNavigator)
  or(Control is TDBMemo)
  then Result:=True;
end;

// ****************************************************************************
// *  Инициировать умалчиваемые параметры расположения компонентов формы      *
// ****************************************************************************
procedure TPositionSaver.Default;
var
  i: integer;
  // Form: TForm;
  Control: TControl;
  aOne: Variant;      // Один компонент с сохраняемым местоположением на экране
begin
  // Фиксируем координаты формы по умолчанию
  aCreate(aDefault);
  //Form:=AOwner as TForm;
  aCreate(aOne);
  {aadd(aOne,Form.Name);
  aadd(aOne,Form.Width);
  aadd(aOne,Form.Height);
  aadd(aOne,Form.Top);
  aadd(aOne,Form.Left);}

  aadd(aOne,FForm.Name);
  aadd(aOne,FForm.Width);
  aadd(aOne,FForm.Height);
  aadd(aOne,FForm.Top);
  aadd(aOne,FForm.Left);

  aadd(aDefault,aOne);
  // Фиксируем координаты control-ов по умолчанию
  for i:=0 to FForm.ComponentCount-1 do begin
    if isControlPlace(FForm.Components[i]) then begin
      Control:=FForm.Components[i] as TControl;
      aCreate(aOne);
      aadd(aOne,Control.Name);
      aadd(aOne,Control.Width);
      aadd(aOne,Control.Height);
      aadd(aOne,Control.Top);
      aadd(aOne,Control.Left);
      aadd(aDefault,aOne);
    end;
  end;

  aSay(aDefault,'aDefault');


end;

// ****************************************************************************
// *  Установить параметры компонентов формы согласно конфигурационному файлу *
// *                     или с умалчиваемыми параметрами                      *
// ****************************************************************************
{procedure TPositionSaver.Open(AOwner:TComponent; lMake:Boolean=False);
begin
  // Если явно требуется, то перезапускаем метод
  if lMake then begin
    if (AOwner is TForm) then begin _Save(AOwner); _Open(AOwner) end;
  end
  // Иначе предупреждаем пользователя о лишнем употреблении метода Open
  else ShowMessage('Метод PositionSaver.Open явно не используется! '+
    chr(13)+chr(10)+'Метод был выполнен при создании формы: '+Owner.Name);
end;}

{procedure TPositionSaver._Open(AOwner:TComponent; lSaved:Boolean=True);
var
  ctemp:string;
  nver, nvcode:integer;
begin
  // Вызываем исключение, если вызов не от формы
  if not (AOwner is TForm) then Exception.CreateFmt(ERROR_AOWNER,['Open']);
  // Если имя файла не определено, то открывать объект для сохранения
  // местоположений не будем
  if (Trim(cIniName)='_Reset')or(cIniName='') then begin
  end
  else begin
    // Если конфиг. файла не существует, создаём его.
    if (not FileExists(cIniName)) then _Save(AOwner);
    // Привязываемся к файлу и начинаем его считывать
    AssignFile(fp,cIniName);
    Reset(fp);
    Readln(fp,ctemp);
    ctemp:=copy(ctemp,1,pos(#9,ctemp)-1);
    val(ctemp,nver,nvcode);
    // Проверяем версию файла
    if (nvcode>0) or (nver < component_version) or (length(ctemp)<1) then begin
      close(fp);
      Erase(fp);
      Save(AOwner);
      exit;
    end;
    // Восстанавливаем форму и ее элементы в сохраненном или умалчиваемом состоянии
    FormReplace(fp,AOwner,lSaved);
    CloseFile(fp);
  end;
end;}

// ****************************************************************************
// *           Сохранить размеры и положение формы или ее элемента            *
// ****************************************************************************
{procedure SaveControlSize(var fp:TextFile; Control:TControl);
var
  s: String;
begin
  s:=Control.Name;
  if Control is TForm then Writeln(fp,'['+s+']')
  else Writeln(fp,'{'+s+'}');
  s:='%d'#9'# %s %s';
  Writeln(fp, Format(s, [Control.Width,  Control.Name, 'Width']));
  Writeln(fp, Format(s, [Control.Height, Control.Name, 'Height']));
  Writeln(fp, Format(s, [Control.Top,    Control.Name, 'Top']));
  Writeln(fp, Format(s, [Control.Left,   Control.Name, 'Left']));
end;}

// ****************************************************************************
// *              Сохранить количество и ширины столбцов DBGrid               *
// ****************************************************************************
{procedure SaveDBGridColumns(var fp:TextFile; DBGrid:TDBGrid);
var
  i: Integer;
begin
  Writeln(fp, IntToStr(DBGrid.Columns.Count)+#9'# Column Count');
  for i:=0 to DBGrid.Columns.Count-1 do
    Writeln(fp,Format('%d'#9'# Columns[%d] width',[DBGrid.Columns[i].Width,i+1]));
end;}

// ****************************************************************************
// * Сохранить местоположения компонентов текущей формы в конфигурационный файл
// ****************************************************************************
{procedure TPositionSaver.SaveControl(MainControl:TControl; fname:String);
var
  i: Integer;
  Component: TComponent;
  Control: TControl;
  s: String;
  Names: THashedStringList;
begin
  // Сохраняем размеры и положение текущей формы
  SaveControlSize(fp, MainControl);
  if MainControl is TDBGrid then SaveDBGridColumns(fp, MainControl as TDBGrid)
  else begin
    Names:=THashedStringList.Create;
    try
      // Считаем кол-во компонент для сохранения
      for i:=0 to MainControl.ComponentCount-1 do begin
        Component:=MainControl.Components[i];
        if isControlPlace(Component) then begin
          s := Format('%.9d', [(Component as TControl).Top]) + '=' + Component.Name;
          Names.Add(s);
        end;
      end;
      // Сортируем для правильного создания свойства align при чтении конфиг. файла
      Names.Sort;
      // Сохраняем размеры и положения компонент, размеры полей таблиц
      writeln(fp,inttostr(Names.Count)+#9'# Number of Components on form');
      for i:=0 to Names.Count - 1 do begin
        Component:=MainControl.FindComponent(Names.ValueFromIndex[i]);
        if not (Component is TControl) then Continue;
        Control:=Component as TControl;
        if isControlPlace(Control) then SaveControlSize(fp,Control);
        if Control is TDBGrid then SaveDBGridColumns(fp, Control as TDBGrid);
      end;
    finally
      Names.Free;
    end;
  end;
end;}

// ****************************************************************************
// *      Сохранить параметры компонентов формы, в конфигурационный файл      *
// ****************************************************************************
{procedure TPositionSaver.Save(AOwner:TComponent; lMake:Boolean=False);
begin
  // Если явно требуется, то перезапускаем метод
  if lMake then _Save(Owner)
  // Иначе предупреждаем пользователя о лишнем употреблении метода Save
  else ShowMessage('Метод PositionSaver.Save явно не используется! '+
    chr(13)+chr(10)+'Метод будет выполнен перед закрытием формы: '+Owner.Name);
end;}

{procedure TPositionSaver._Save(Aowner:TComponent);
var
  fname:string;
  ltend:boolean;
  tfp: textfile;
  ctemp:string;
  Control: TControl;
begin
  // Если имя файла не определено, то и закрывать объект для сохранения
  // местоположений не будем
  if (Trim(cIniName)='_Reset')or(cIniName='') then begin
  end
  else begin
    if not (AOwner is TForm) then Exception.CreateFmt(ERROR_AOWNER, ['Save']);
    // Определяем имя текущей формы, координаты местоположения элементов
    // которой будем обновлять в конфигурационном файле
    Control:=AOwner as TControl;
    fname:=Control.Name;
    // Делаем копию старого конфиг. файла
    CopyFile(pchar(cIniName),pchar(cIniName+'.tmp'),false);
    // Открываем файл для перезаписи
    AssignFile(fp,cIniName);
    Rewrite(fp);
    // Отмечаем версию компонента в файле
    WriteLn (fp, inttostr(Component_version)+#9'# Component Version');
    // Начинаем переносить параметры других форм и их компонентов
    // из копии старого конфиг. файла
    if (FileExists(cIniName+'.tmp')) then begin
      AssignFile(tfp, cIniName+'.tmp');
      Reset(tfp);
      Readln(tfp, ctemp);  // Проскакиваем версию компонента
      // Копируем записи из старого файла
      // до появления координат местоположения текущей формы
      ctemp:='';
      while not(eof(tfp)) do begin
        Readln(tfp,ctemp);
        if (Copy(ctemp,2,length(ctemp)-2)=fname) then break;
        writeln(fp,ctemp);
      end;
      // Проскакиваем старые координаты местоположений текущей формы
      ltend:=true;
      while (ltend) do begin
        Readln(tfp, ctemp);
        if (eof(tfp)) then ltend:=false;
        if (length(ctemp))>2 then begin
          if (ctemp[1]='[') and (ctemp[length(ctemp)]=']')
          then ltend:=false;
        end;
      end;
      // Если до конца файла не доехали, значит уже считали первую строку
      // описания местоположений элементов другой формы
      if not(eof(tfp)) then writeln(fp, ctemp);
      // Дописываем оставшиеся местоположения
      while not(eof(tfp)) do begin
        Readln(tfp, ctemp);
        writeln(fp, ctemp);
      end;
      // Закрываем и удаляем старый файл
      CloseFile(tfp);
      DeleteFile(pchar(cIniName+'.tmp'));
    end;
    if not FCleaPosit then SaveControl(Control,fname);
    CloseFile(fp);
  end;
end;}

end.

// ****************************************************** PositionSaver.pas ***

