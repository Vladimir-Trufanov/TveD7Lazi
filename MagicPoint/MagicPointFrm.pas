unit MagicPointFrm;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
			StdCtrls;

type

			{ TfrmMagicPoint }

      TfrmMagicPoint = class(TForm)
						Button1: TButton;
						Button2: TButton;
						Button3: TButton;
						Button4: TButton;
						Button5: TButton;
						Button6: TButton;
						il: TImageList;
						lvGuide: TListView;
						pnl: TPanel;
						procedure Button6Click(Sender: TObject);
      private

      public

      end;

var
      frmMagicPoint: TfrmMagicPoint;

implementation

{$R *.lfm}

{ TfrmMagicPoint }

procedure TfrmMagicPoint.Button6Click(Sender: TObject);
begin
  Close;
end;

end.

