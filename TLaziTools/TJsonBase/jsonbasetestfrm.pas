unit JsonBaseTestFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, DBGrids, StdCtrls, ZConnection, ZDataset, db;

// http://www.delphi-dev.ru/index.php/lazarus/lazarus-ustanovka-zeosilb.html
// http://mirsovetov.net/delphi-connect-mysql.html

type

  { TForm1 }

  TForm1 = class(TForm)
    btnConnect: TButton;
    DataSource1: TDataSource;
    dbg: TDBGrid;
    ListBox1: TListBox;
    mem: TMemo;
    pnlText: TPanel;
    pnlTables: TPanel;
    pnlGrid: TPanel;
    pnlButtons: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    DocsConn: TZConnection;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure btnConnectClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  {// Указываем что будем работать с sqlite
  ZConnection1.Protocol:='sqlite-3';
  // Указываем базу данных и кодировку
  ZConnection1.Database:='C:\TVED7\TLaziTools\TJsonBase\Prefs.db3';
  ZConnection1.ClientCodepage:='UTF8';
  try
    // Пробуем подключиться
    ZConnection1.Connect;
    // Проверяем что подключились
    if ZConnection1.Connected then
    ShowMessage('Подключение успешно');
    // Вставляем sql  код
    ZQuery1.SQL.Text:='select * from rbitem ';
    // Выполняем запрос
    ZQuery1.Open;
  except
    ShowMessage('Ошибка подключения');
  end;}

  // Указываем что будем работать с FireBird
  ZConnection1.Protocol:='firebird-2.5'; //'interbase-6';
  // Указываем базу данных и кодировку
  ZConnection1.Database:='C:\TVED7\TLaziTools\TJsonBase\senscha.fdb';
  //ZConnection1.ClientCodepage:='UTF8';
  ZConnection1.User:='SYSDBA';
  ZConnection1.Password:='masterkey';
  try
    // Пробуем подключиться
    ZConnection1.Connect;
    // Проверяем что подключились
    if ZConnection1.Connected then
    ShowMessage('Подключение успешно');
    // Вставляем sql  код
    ZQuery1.SQL.Text:='select * from codif';
    // Выполняем запрос
    ZQuery1.Open;
  except
    ShowMessage('Ошибка подключения');
  end;
end;

end.

