unit ModeLessFrm;

{$mode objfpc}

interface

uses
  Windows,
      Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls;

type

			{ TfrmModeless }

      TfrmModeless = class(TForm)
						Button1: TButton;
						ListView1: TListView;
						procedure Button1Click(Sender: TObject);
      private

      public

      end;

var
      frmModeless: TfrmModeless;

implementation

{$R *.lfm}

{ TfrmModeless }

procedure TfrmModeless.Button1Click(Sender: TObject);
var
  Form: HWnd;
  {$IFDEF wince}
  WindowCaption: PWideChar;
  {$ELSE}
  WindowCaption: PChar;
  {$ENDIF}
begin
 WindowCaption:='frmLaziWinCE';

 Form := FindWindow (nil, WindowCaption);
  if Form <> 0 then
  begin
    GetWindowText(Form,WindowCaption,100);
    Caption:=WindowCaption+' exist';
    //ShowWindow (Form, SW_SHOW);
    //SetForegroundWindow (Form);
    //ExitProcess (0);
  end;

end;

end.

