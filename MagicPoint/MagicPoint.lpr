program MagicPoint;

{$mode objfpc}{$H+}

uses
      {$IFDEF UNIX}{$IFDEF UseCThreads}
      cthreads,
      {$ENDIF}{$ENDIF}
      Interfaces, // this includes the LCL widgetset
      Forms, MagicPointFrm, FilesFrm, RamFrm, Loger;

{$R *.res}

begin
      RequireDerivedFormResource:=True;
      Application.Scaled:=True;
      Application.Initialize;
			Application.CreateForm(TfrmMagicPoint, frmMagicPoint);
			Application.CreateForm(TfrmFiles, frmFiles);
			Application.CreateForm(TfrmRam, frmRam);
      Application.Run;
end.

