program JsonBaseTest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, JsonBaseTestFrm, JsonToStringUni, DatasetToJsonStringUni,
  JsonBaseClass, JsonToDatasetUni, JsonStringToDatasetUni, LazitoolsOutfit,
  sqlite3laz;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

