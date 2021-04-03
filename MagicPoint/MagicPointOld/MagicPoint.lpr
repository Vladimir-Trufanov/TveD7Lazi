program MagicPoint;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, MagicPointFrm, MagicMessagesUni,
  NumgressFrame, LaziframesOutfit, LaziFramesAlerts, TellmeFrm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMagicPoint, frmMagicPoint);
  Application.Run;
end.

