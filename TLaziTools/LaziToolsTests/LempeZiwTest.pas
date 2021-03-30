program LempeZiwTest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LempeZiwTestFrm, LempeZiwClass, LazitoolsOutfit,
  convertuni, ErrEventClass, ArrayFrm,
  CompressUni, FileReaderClass, DictionaryUni, FileWriterClass, Code10to12Uni,
  RecoverUni, code12to10uni;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

