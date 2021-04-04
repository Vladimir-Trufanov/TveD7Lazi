unit FilesFrm;

{$mode objfpc}

interface

uses
      Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
			Grids;

type

			{ TfrmFiles }

      TfrmFiles = class(TForm)
						btnRoot: TButton;
						btnSd: TButton;
						btnUsb: TButton;
						btnClose: TButton;
						btnVverh: TButton;
						btnVniz: TButton;
						lblMess: TLabel;
						pnlRight: TPanel;
						pnlButtom: TPanel;
						sgFiles: TStringGrid;
						procedure btnCloseClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      private

      public

      end;

var
      frmFiles: TfrmFiles;

implementation

{$R *.lfm}

{ TfrmFiles }

procedure TfrmFiles.FormCreate(Sender: TObject);
begin
  Width:=770;
  Height:=440;
  Position:=poScreenCenter;
  lblMess.Left:=8;

  pnlButtom.Top:=407;
  pnlButtom.Left:=8;
  pnlButtom.Width:=754;
  btnRoot.Left:=8;
  btnRoot.Width:=94;
  btnSd.Left:=128;
  btnSd.Width:=94;
  btnUsb.Left:=248;
  btnUsb.Width:=94;

  pnlRight.Top:=40;

  lblMess.Color:=Color;
  pnlRight.Color:=Color;
  pnlButtom.Color:=Color;

  sgFiles.Cells[1, 1]:= 'Название';
  sgFiles.Cells[1, 2]:= 'Телефон';
  sgFiles.Cells[1, 3]:= 'Примечание';
  sgFiles.ColWidths[0]:= 60;
  sgFiles.ColWidths[1]:= 200;
  sgFiles.ColWidths[2]:= 150;
  sgFiles.ColWidths[3]:= 150;


  {$IFDEF wince}
    BorderStyle:=bsNone;
  {$ELSE}
    BorderStyle:=bsSizeable;
    btnRoot.Caption:='C:';
    btnSd.Caption:='D:';
    btnUsb.Caption:='F:';
  {$ENDIF}
end;

procedure TfrmFiles.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

