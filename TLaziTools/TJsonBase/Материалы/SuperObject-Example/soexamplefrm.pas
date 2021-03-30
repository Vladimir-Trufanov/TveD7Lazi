unit SOExampleFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  superobject;

// http://www.webdelphi.ru/2012/05/primer-ispolzovaniya-perechislitelej-v-superobject/

// {
//   8:[2,'Республика Калмыкия','Калмыкия','elista',246,
//     {
//       447:['Городовиковск','gorodovikovsk',0],
//       704:['Лагань','lagan',0],
//       246:['Элиста','elista',1]
//     }
//   ],
//   10:[3,'Республика Карелия','Карелия','karelia',121,
//     {
//       340:['Беломорск','belomorsk',0],
//       599:['Кемь','kem',0],
//       639:['Кондопога','kondopoga',0],
//       651:['Костомукша','kostomuksha',0],
//       708:['Лахденпохья','lahdenpohiya',0],
//       756:['Медвежьегорск','medvezhyegorsk',0],
//       864:['Олонец','olonets',0],
//       121:['Петрозаводск','petrozavodsk',1],
//       901:['Питкяранта','pitkyaranta',0],
//       931:['Пудож','pudozh',0],
//       978:['Сегежа','segezha',0],
//       1016:['Сортавала','sortavala',0],
//       1040:['Суоярви','suoyarvi',0]
//     }
//   ],
// }

const
  cRegionNameID = 1;
  cCityURLID = 1;
  cCityNameID = 0;
  cCitiesArrID = 5;

// Каждый элемент нашего JSON-объекта представляет из себя массив. Имя каждого
// элемента — какое-либо число, при этом: элемент с индексом 1 — это название
// области/края/республики. Это значение нам надо использовать в программе.
// Элемент с индексом 5 — это JSON-объект, содержащий список населенных пунктов.
// При этом: каждый элемент этого объекта, как и в случае с основным json-объектом
// — это массив, в котором: элемент с индексом 0 — название города. Это значение
// используется в программе. Элемент с индексом 1 — URL города. Это значение
// также используется в программе.

type
  TRegions = class
  private
    FJSONObject: ISuperObject;
    FAvlEnum:  TSuperAvlIterator;
    function GetRegionObject(const ARegion: string; out RegionID:integer): ISuperObject;
  public
    constructor Create(const AJsonString: string);
    destructor Destroy; override;
    // Заполнить список List названиями регионов
    function GetRegions(List: TStrings):integer;
    // Возвратить ID региона в основном объекта JSON
    function GetCities(const ARegion: string; List:TStrings):integer;
    // Возвратить название города на латинице (URL города)
    function GetCityURL(const ARegionID:integer; ACity: string):string;
end;


type

  { TForm8 }

  TForm8 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Regions: TRegions;
    CurrentRegion: integer;
  public
    { public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.lfm}

{ TForm8 }

procedure TForm8.Button1Click(Sender: TObject);
var
  Stream: TMemoryStream;
  SS:TStringStream;
  s:string;
begin
  if OpenDialog1.Execute then begin
    Edit1.Text:=OpenDialog1.FileName;
    Stream:=TMemoryStream.Create;
    try
      Stream.LoadFromFile(Edit1.Text);
      Stream.Seek(0,0);
      SS:=TStringStream.Create('');
      SS.CopyFrom(Stream,Stream.Size);
      s:=SS.DataString;
      //showmessage(s);
      FreeAndNil(SS);
      FreeAndNil(Stream);
      Regions:=TRegions.Create(s);
      Regions.GetRegions(ComboBox1.Items);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TForm8.ComboBox1Change(Sender: TObject);
begin
  CurrentRegion:=Regions.GetCities(ComboBox1.Items.Strings[ComboBox1.ItemIndex],ComboBox2.Items);
end;

procedure TForm8.ComboBox2Change(Sender: TObject);
begin
  Label5.Caption:=Regions.GetCityURL(CurrentRegion,ComboBox2.Items.Strings[ComboBox2.ItemIndex])
end;

procedure TForm8.FormDestroy(Sender: TObject);
begin
  if Assigned(Regions) then Regions.Free;
end;

{ TRegions }

constructor TRegions.Create(const AJsonString: string);
begin
  inherited Create;
  // Выбираем SO из текстовой строки
  FJSONObject:=TSuperObject.ParseString(PChar(AJsonString),false);
  if not Assigned(FJSONObject)
  then raise Exception.Create('Невозможно распарсить JSON')

  // Кроме обозначенного метода TSuperObject.ParseString
  // можно было бы напрямую передать в парсер поток или файл с данными:

  //   class function ParseStream(stream: TStream; strict: Boolean;
  //     partial: boolean = true; const this: ISuperObject = nil;
  //     options: TSuperFindOptions = []; const put: ISuperObject = nil;
  //     dt: TSuperType = stNull): ISuperObject;

  //   class function ParseFile(const FileName: string; strict: Boolean;
  //     partial: boolean = true; const this: ISuperObject = nil;
  //     options: TSuperFindOptions = []; const put: ISuperObject = nil;
  //     dt: TSuperType = stNull): ISuperObject;

  // Или же воспользоваться одной из вспомогательных функций в модуле superobject.pas:
  //   function SO(const s: SOString = '{}'): ISuperObject; overload;
  //   function SO(const value: Variant): ISuperObject; overload;
  //   function SO(const Args: array of const): ISuperObject; overload;

  // Например, могли бы написать так:
  //   FJSONObject:=SO(AJsonString);
  // и результат, в нашем случае, был бы идентичным.

  // Запрашиваем перечислитель TSuperAvlIterator. Перечислитель этого типа
  // удобно использовать, когда нам надо получать не только значение (Value)
  // какой-либо пары, но и её имя (Name).
  else FAvlEnum:=FJSONObject.AsObject.GetEnumerator;

  // Класс TSuperAvlIterator имеет следующее описание:
  //
  // TSuperAvlIterator = class
  // private
  //   FTree: TSuperAvlTree;
  //   FBranch: TSuperAvlBitArray;
  //   FDepth: LongInt;
  //   FPath: array[0..SUPER_AVL_MAX_DEPTH - 2] of TSuperAvlEntry;
  // public
  //   constructor Create(tree: TSuperAvlTree); virtual;
  //   procedure Search(const k: SOString; st: TSuperAvlSearchTypes = [stEQual]);
  //   procedure First;
  //   procedure Last;
  //   function GetIter: TSuperAvlEntry;
  //   procedure Next;
  //   procedure Prior;
  //   function MoveNext: Boolean;
  //   property Current: TSuperAvlEntry read GetIter;
  // end;
  // В принципе, здесь все методы и свойства должны быть понятны: First —
  // переход к первому элементу, Prior — к предыдущему, MoveNext — вернет True,
  // если удалось перейти к следующему и т.д. Соответственно TSuperAvlEntry —
  // это класс, представляющий отдельную пару (ака TJsonPair в DBXJSON).
  // И этот перечислитель мы запрашиваем для того, чтобы потом с помощью него
  // «бегать» по парам нашего JSON-объекта и получать необходимую информацию
end;

destructor TRegions.Destroy;
begin
  if Assigned(FAvlEnum) then FAvlEnum.Free;
  inherited;
end;

function TRegions.GetRegionObject(const ARegion: string; out RegionID:integer): ISuperObject;
begin
  if not Assigned(FAvlEnum) then Exit;
  FAvlEnum.First;
  repeat
    if SameText(FAvlEnum.Current.Value.AsArray.S[1], ARegion) then begin
      RegionID:=StrToInt(FAvlEnum.Current.Name);
      Exit(FAvlEnum.Current.Value);
    end;
  until not FAvlEnum.MoveNext;
end;

function TRegions.GetRegions(List: TStrings): integer;
begin
  Result:=0;
  if (not Assigned(FAvlEnum))or(not Assigned(List)) then Exit;
  List.Clear;
  FAvlEnum.First;
  repeat
    List.Add(FAvlEnum.Current.Value.AsArray.S[cRegionNameID]);
  until not FAvlEnum.MoveNext;
  Result:=List.Count;
end;

function TRegions.GetCities(const ARegion: string; List:TStrings): integer;
// Для парсинга JSON в SuperObject имеется сразу два типа перечислителей.

// Первый тип перечислителей TSuperAvlIterator, если в ходе перечисления нам
// необходимо получить пару целиком.

// Второй тип перечислителей — TSuperEnumerator использует в работе
// TSuperAvlIterator и может перечислять только значения пар. Использование
// второго типа перечислителей оправдано в случае, если нас не интересуют имена
// пар, а также, в том, случае, если нам необходимо перечислить элементы
// в масиве TSuperArray.

// Для получения значений пар из JSON-объекта можно не использовать вообще
// перечислители напрямую, если нам известно имя пары — в этом случае мы можем
// просто воспользоваться одним из методов у ISuperObject и получить необходимое
// нам значение буквально в одну строку.
var
  RegionObject,CityObject: ISuperObject;
  ID: integer;
  CityEnum: TSuperEnumerator;
begin
  if (not Assigned(FAvlEnum))or(not Assigned(List)) then Exit;
  List.Clear;
  RegionObject:=GetRegionObject(ARegion,ID);
  if Assigned(RegionObject) then begin
    CityObject:=RegionObject.AsArray.O[cCitiesArrID];
    if Assigned(CityObject) then begin
      CityEnum:=CityObject.GetEnumerator;
      try
        while CityEnum.MoveNext
        do List.Add(CityEnum.Current.AsArray.S[cCityNameID])
      finally
        CityEnum.Free;
      end;
      Exit(ID);
    end;
  end;
end;

function TRegions.GetCityURL(const ARegionID: integer; ACity: string): string;
var
  Region: TSuperArray;
  CityEnum: TSuperEnumerator;
begin
  if not Assigned(FJSONObject) then Exit;
  Region:=FJSONObject.A[IntToStr(ARegionID)];
  if Assigned(Region) then begin
    CityEnum:=Region.O[5].GetEnumerator;
    try
      while CityEnum.MoveNext do begin
        if SameText(CityEnum.Current.AsArray.S[cCityNameID],ACity) then begin
          Result:=CityEnum.Current.AsArray.S[cCityURLID];
          break;
        end;
      end;
    finally
      CityEnum.Free;
    end;
  end;
end;

end.

