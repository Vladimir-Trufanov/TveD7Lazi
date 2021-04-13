unit ModalFrm;

{$mode objfpc}

interface

uses
  Windows,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

			{ TfrmModal }

      TfrmModal = class(TForm)
						Button1: TButton;
						Button2: TButton;
						Memo1: TMemo;
						procedure Button1Click(Sender: TObject);
						procedure Button2Click(Sender: TObject);
      private

      public

      end;

var
      frmModal: TfrmModal;

implementation

{$R *.lfm}

{ TfrmModal }

procedure TfrmModal.Button1Click(Sender: TObject);
var
  p : array[0 .. 255] of WideChar;
begin
  if IsWindowVisible(Handle) and (GetParent(Handle) = 0)then
  begin
    GetWindowTextW(Handle, p, 256);
    if Length(Trim(StrPas(p))) > 0
    then frmModal.Memo1.Lines.Add(IntToStr(Handle) + ' -> ' + p);
  end;
end;

procedure TfrmModal.Button2Click(Sender: TObject);
begin
  //EnumWindows();
end;

end.

