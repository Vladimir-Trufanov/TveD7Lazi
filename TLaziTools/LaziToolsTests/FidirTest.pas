program FidirTest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FidirtestFrm, FidirCheckClass, gaFileNamesUni, ArrayFrm,
MakeFilesDirarrayUni, convertuni;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmFidirTest, frmFidirTest);
  Application.Run;
end.

