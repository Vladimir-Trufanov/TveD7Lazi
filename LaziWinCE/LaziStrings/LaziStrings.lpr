program LaziStrings;

{$mode objfpc}{$H+}

uses
      {$IFDEF UNIX}{$IFDEF UseCThreads}
      cthreads,
      {$ENDIF}{$ENDIF}
      Interfaces, // this includes the LCL widgetset
      Forms, LaziStringsFrm
      { you can add units after this };

{$R *.res}

begin
      RequireDerivedFormResource:=True;
      Application.Scaled:=True;
      Application.Initialize;
			Application.CreateForm(TfrmLaziStrings, frmLaziStrings);
      Application.Run;
end.

