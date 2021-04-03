unit MagicPointFrm;

{$mode objfpc}{$H+}

interface

uses
  GuideFrame, NumgressFrame,
  Classes, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, ExtCtrls, StdCtrls, ImgList,Windows, SysUtils;

type

  { TfrmMagicPoint }

  TfrmMagicPoint = class(TForm)
    lvLog: TListView;
    mmiDoubleClick: TMenuItem;
    mmiOpenTable: TMenuItem;
    mmiConnectingBase: TMenuItem;
    mmiSettings: TMenuItem;
    mmiSelZ: TMenuItem;
    mmiSelD: TMenuItem;
    mmiSelC: TMenuItem;
    mmiSelA: TMenuItem;
    mmiSelectDisk: TMenuItem;
    mm: TMainMenu;
    mmiActions: TMenuItem;
    od: TOpenDialog;
    Panel1: TPanel;
    pnlBottom: TPanel;
    pnlRight: TPanel;
    pnlLeft: TPanel;
    splitBottom: TSplitter;
    splitLeft: TSplitter;
    StaticText1: TStaticText;
    StatusBar1: TStatusBar;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmiDoubleClickClick(Sender: TObject);
    procedure mmiSelAClick(Sender: TObject);
    procedure mmiSelCClick(Sender: TObject);
    procedure mmiSelDClick(Sender: TObject);
    procedure mmiActionsClick(Sender: TObject);
    procedure mmiSelZClick(Sender: TObject);
  private
    cConnectMessage: String;  // Сообщение о соединении
    cFileBaseName:   String;  // Наименование файла базы данных
    cNameDisk:       String;  // Имя текущего диска

    fr: TframeGuide;          // Фрэйм проводника
    ng: TframeNumgress;       // Фрэйм индикатора продвижения


    TSL : TStringList;
    SmallIm: TImageList;      // Набор иконок каталогов и файлов
    IC1: TIcon;


  public
    { public declarations }
  end;

var
  frmMagicPoint: TfrmMagicPoint;

implementation

uses
  MagicMessagesUni;

{$R *.lfm}

var
  Dira: String;           // Каталог, из которого запущена программа
  SubI: Integer=0;
  CurrentDir: String='';
  First: boolean=true;
  edFindText: String;

{ TfrmMagicPoint }

// Породить форму
procedure TfrmMagicPoint.FormCreate(Sender: TObject);
var
  ii: Integer;
begin
  Top:=0;
  Left:=0;
  // Устанавливаем фрэйм проводника
  if not assigned(fr) then begin
    fr:=TframeGuide.Create(self);
    fr.Parent:=pnlLeft;
  end;
  // Устанавливаем фрэйм индикатора продвижения
  //if not assigned(ng) then begin
  //  ng:=TframeNumgress.Create(self);
  //  ng.Parent:=Panel1;
  //end;

  cConnectMessage:=NoConnectBase;

 end;

procedure TfrmMagicPoint.FormDestroy(Sender: TObject);
begin
  // Уничтожаем фрэймы и их объекты, отмечаем, что они уже не назначены
  if assigned(fr) then begin
    fr.ObjFree; fr.Free; fr:=NIL;
  end;
  //ng.Free; ng:=NIL;
  // Удаляем другие объекты и освобождаем память
  SmallIm.Free; IC1.Free; TSL.Free;
end;

procedure TfrmMagicPoint.mmiDoubleClickClick(Sender: TObject);
begin
  if mmiDoubleClick.Tag=1 then begin
    mmiDoubleClick.Caption:='Вернуться к одинарному щелчку';
    mmiDoubleClick.Tag:=0;
    fr.DblClick:=True;
  end else begin
    mmiDoubleClick.Caption:='Включить двойной щелчок';
    mmiDoubleClick.Tag:=1;
    fr.DblClick:=False;
  end;
end;

// Развернуть форму
procedure TfrmMagicPoint.FormActivate(Sender: TObject);
begin
  // Устанавливаем заголовок главной формы
  Caption:=ApplicationName+': '+cConnectMessage;
  // Активируем индикатор движения и проводника
  // ng.SetFocus;
  // fr.SetFocus;
end;

// Перейти на указанный диск:
procedure TfrmMagicPoint.mmiSelAClick(Sender: TObject);
begin
  fr.OpenDir('A:\');
end;
procedure TfrmMagicPoint.mmiSelCClick(Sender: TObject);
begin
  fr.OpenDir('C:\');
end;
procedure TfrmMagicPoint.mmiSelDClick(Sender: TObject);
begin
  fr.OpenDir('D:\');
end;
procedure TfrmMagicPoint.mmiSelZClick(Sender: TObject);
begin
  fr.OpenDir('Z:\');
end;

// Подключиться к базе данных
procedure TfrmMagicPoint.mmiActionsClick(Sender: TObject);
begin
  {if od.Execute then begin
    ShowMessage(ConnectingBase);
    cFileBaseName:=od.FileName; // Чтобы исправленный текст не затёр источник
    Caption:=ApplicationName+': '+cFileBaseName;
  end;}
end;

end.

