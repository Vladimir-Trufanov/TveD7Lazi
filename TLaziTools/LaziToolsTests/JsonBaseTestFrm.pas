unit JsonBaseTestFrm;

{$mode objfpc}{$H+}

interface

uses
  SuperObject,
  Classes, SysUtils, sqlite3conn, sqldb, db, Sqlite3DS, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, DBGrids;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    mem: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    SQLite3Connection1: TSQLite3Connection;
    dset: TSqlite3Dataset;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    cJsonString: String;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  LazitoolsOutfit,
  DatasetToJsonStringUni,JsonToDatasetUni,JsonToStringUni;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  dset.FileName:='kwiflatn.db3';
  dset.TableName:='Edizm';
  DataSource1.DataSet:=dset;
  DBGrid1.DataSource:=DataSource1;
  //
  SQLite3Connection1.DatabaseName:='kwiflatn.db3';
  SQLite3Connection1.Transaction:=SQLTransaction1;
  SQLTransaction1.DataBase:=SQLite3Connection1;
  //
  SQLQuery1.DataBase:=SQLite3Connection1;
  SQLQuery1.Transaction:=SQLTransaction1;
  //
  try
    SQLite3Connection1.Connected:=True;
    dset.Open;
  except
    on E:Exception do ShowMessage('Ошибка открытия базы: '+ E.Message);
  end
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  dset.Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  x: ISuperObject;
  c2JsonString: String;
begin
  cJsonString:=DatasetToJsonString(dset);
  x:=SO(cJsonString);
  c2JsonString:=JsonToString(x);
  mem.Text:=cJsonString+CR+LF+
  '-----'+CR+LF+
  c2JsonString+  //CR+LF+
  '-----';
end;

procedure TForm1.Button4Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.

