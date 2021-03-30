// LAZARUS WIN10\XP                                  *** ProbaLaPr02Frm.pas ***

// ****************************************************************************
// *                    Второй блок тестов библиотеки TLaziPrown              *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  12.08.2017
// Copyright © 2017 TVE                              Посл.изменение: 29.08.2017

unit ProbaLaPr02Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type

  { TfrmProbaLaPr02 }

  TfrmProbaLaPr02 = class(TForm)
    btnTellme: TButton;
    btnShowmessage: TButton;
    btnqueryTerminate: TButton;
    btnyesTerminate: TButton;
    btnnoTerminate: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    procedure btnnoTerminateClick(Sender: TObject);
    procedure btnTellmeClick(Sender: TObject);
    procedure btnyesTerminateClick(Sender: TObject);
    procedure btnShowmessageClick(Sender: TObject);
    procedure btnqueryTerminateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProbaLaPr02: TfrmProbaLaPr02;

implementation

{$R *.lfm}

uses
  TellmeFrm;

procedure TfrmProbaLaPr02.btnTellmeClick(Sender: TObject);
begin
  Tellme('Сообщение без кода и без ключевого слова');
end;

procedure TfrmProbaLaPr02.btnnoTerminateClick(Sender: TObject);
begin
  Tellme('cMessage',100,noTerminate,'cKeyWord');
end;

procedure TfrmProbaLaPr02.btnyesTerminateClick(Sender: TObject);
begin
  Tellme('cMessage',100,yesTerminate,'cKeyWord');
end;

procedure TfrmProbaLaPr02.btnShowmessageClick(Sender: TObject);
begin
  Showmessage('Привет!');
end;

procedure TfrmProbaLaPr02.btnqueryTerminateClick(Sender: TObject);
begin
  Tellme('cMessage',100,queryTerminate,'cKeyWord');
end;

end.

// ***************************************************** ProbaLaPr02Frm.pas ***

