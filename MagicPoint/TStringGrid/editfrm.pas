unit EditFrm;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;


const
  //Некоторые константы
  SIPF_OFF    =	$00000000;
  SIPF_ON     =	$00000001;
  SIPF_DOCKED =	$00000002;
  SIPF_LOCKED =	$00000004;


type

			{ TfEdit }

      TfEdit = class(TForm)
						bSave: TButton;
						bCancel: TButton;
						Button1: TButton;
						Button2: TButton;
						CBNote: TComboBox;
						eName: TEdit;
						eTelephone: TEdit;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						procedure bSaveClick(Sender: TObject);
						procedure bCancelClick(Sender: TObject);
						procedure Button1Click(Sender: TObject);
						procedure Button2Click(Sender: TObject);
						procedure FormCreate(Sender: TObject);


      private

      public
        nModalResult: integer;
        procedure Butt;
      end;

      function SipShowIM(IPStatus:DWORD):Integer; stdcall; external 'coredll.dll' name 'SipShowIM';


var
      fEdit: TfEdit;

implementation


//begin
//  SipShowIM(SIPF_ON)
//end;


{$R *.lfm}

{ TfEdit }

procedure TfEdit.bSaveClick(Sender: TObject);
begin
  nModalResult:=mrOk;
  Close;
end;

procedure TfEdit.bCancelClick(Sender: TObject);
begin
  nModalResult:=mrCancel;
  Close;
end;

procedure TfEdit.Button1Click(Sender: TObject);
begin
  eName.Text:=eName.Text+'1';
end;

procedure TfEdit.Button2Click(Sender: TObject);
begin
  eName.Text:=eName.Text+'2';
end;

procedure TfEdit.FormCreate(Sender: TObject);
begin
  eName.Text:='ee';
end;

procedure TfEdit.Butt;
begin
  SipShowIM(SIPF_ON)
end;

end.

