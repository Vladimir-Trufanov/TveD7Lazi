unit RamFrm;

{$mode objfpc}

interface

uses
      Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

			{ TfrmRam }

      TfrmRam = class(TForm)
						btnClose: TButton;
						lblMess: TLabel;
						procedure btnCloseClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      private

      public

      end;

var
      frmRam: TfrmRam;

implementation

{$R *.lfm}

{ TfrmRam }

procedure TfrmRam.FormCreate(Sender: TObject);
begin
  Width:=770;
  Height:=440;
  Position:=poScreenCenter;
  lblMess.Left:=8;
  btnClose.Left:=8;
  {$IFDEF wince}
    BorderStyle:=bsNone;
  {$ELSE}
    BorderStyle:=bsSizeable;
  {$ENDIF}
end;

procedure TfrmRam.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

