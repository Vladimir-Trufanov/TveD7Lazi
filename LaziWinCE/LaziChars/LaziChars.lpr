program LaziChars;

{$mode objfpc}{$H+}{$codepage UTF8}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LaziCharsFrm, LaziCharsLib
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmLaziChars, frmLaziChars);
  Application.Run;
end.

