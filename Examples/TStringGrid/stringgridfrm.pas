// http://intuit.valrkl.ru/course-1265/index.html#ID.25.lecture



unit StringGridFrm;

{$mode objfpc}{$H+}

interface

uses
  EditFrm,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
	Grids;

type

  Contacts = record
    Name: string[100];
    Telephon: string[20];
    Note: string[20];
  end;

	{ TfrmStringGrid }

  TfrmStringGrid = class(TForm)
		btnClose: TButton;
		bAdd: TButton;
		bEdit: TButton;
		bDel: TButton;
		bSort: TButton;
		lblMess: TLabel;
		pnlLead: TPanel;
		SG: TStringGrid;

		procedure bAddClick(Sender: TObject);
   procedure bEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);

    private

    public

  end;

var
  frmStringGrid: TfrmStringGrid;
  adres: string; // адрес, откуда запущена программа


implementation

{$R *.lfm}

{ TfrmStringGrid }
procedure TfrmStringGrid.FormCreate(Sender: TObject);
var
  MyCont: Contacts;    //для очередной записи
  f: file of Contacts; //файл данных
  i: integer;          //счетчик цикла
begin
  {$IFDEF wince}
    BorderStyle:=bsNone;
  {$ELSE}
    BorderStyle:=bsDialog;
    WindowState:=wsNormal;
  {$ENDIF}
  Position:=poScreenCenter;

  Width:=770;
  Height:=440;

  pnlLead.Top:=0;
  pnlLead.Left:=8;
  pnlLead.Width:=Width-4;
  // Выравниваем фонты на верхней линейке
  btnClose.Font.Size:=14;
  lblMess.Font.Size:=14;
  btnClose.Height:=36;
  btnClose.Left:=pnlLead.Width-btnClose.Width-8;
  //
  lblMess.Left:=0;

  // сначала получим адрес программы:
  adres:= ExtractFilePath(ParamStr(0));
  lblMess.Caption:=adres;
  // настроим сетку:
  SG.Cells[0, 0]:= 'Имя';
  SG.Cells[1, 0]:= 'Телефон';
  SG.Cells[2, 0]:= 'Примечание';
  SG.ColWidths[0]:= 365;
  SG.ColWidths[1]:= 150;
  SG.ColWidths[2]:= 150;
  // если файла данных нет, просто выходим:
  if not FileExists(adres + 'telephones.dat') then exit;
  // иначе файл есть, открываем его для чтения и
  // считываем данные в сетку:
  // ttry('считываем справочник'+adres + 'telephones.dat')
    AssignFile(f, adres + 'telephones.dat');
    Reset(f);
    // теперь цикл - от первой до последней записи сетки:
    while not Eof(f) do begin
      // считываем новую запись:
      Read(f, MyCont);
      // добавляем в сетку новую строку, и заполняем её:
      SG.RowCount:= SG.RowCount + 1;
      SG.Cells[0, SG.RowCount-1]:= MyCont.Name;
      SG.Cells[1, SG.RowCount-1]:= MyCont.Telephon;
      SG.Cells[2, SG.RowCount-1]:= MyCont.Note;
    end;
  // tfinally
    CloseFile(f);
  // tend;
end;

procedure TfrmStringGrid.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmStringGrid.bEditClick(Sender: TObject);
begin
  //fEdit.Show();
end;

procedure TfrmStringGrid.bAddClick(Sender: TObject);
begin
  // очищаем поля, если там что-то есть:
  fEdit.eName.Text:= '';
  fEdit.eTelephone.Text:= '';
  // устанавливаем ModalResult редактора в mrNone:
  fEdit.nModalResult:= mrNone;
  // теперь выводим форму:
  fEdit.ShowModal;
  // если пользователь ничего не ввел - отмечаем в сообщении
  if (fEdit.eName.Text= '') or (fEdit.eTelephone.Text= '')
  then lblMess.Caption:='Новые данные не введены!'
  else if fEdit.nModalResult <> mrOk
  then lblMess.Caption:='Введенные данные не сохранены!'
  else begin
    // иначе добавляем в сетку строку, и заполняем её:
    SG.RowCount:= SG.RowCount + 1;
    SG.Cells[0, SG.RowCount-1]:= fEdit.eName.Text;
    SG.Cells[1, SG.RowCount-1]:= fEdit.eTelephone.Text;
    SG.Cells[2, SG.RowCount-1]:= fEdit.CBNote.Text;
    lblMess.Caption:='Данные сохранены'
	end;
end;

end.

