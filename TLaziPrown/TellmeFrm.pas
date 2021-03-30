// LAZARUS[DELPHI7], WIN10\XP                             *** TellmeFrm.pas ***
{$mode objfpc}{$H+}
// ****************************************************************************
// * TLaziPrown [1100]                 Просто вывести сообщение на экран (при *
// *                          необходимости вывести сообщение в лог-файл) или *
// *    показать многострочное сообщение на экране c возможностью подключения *
// *                                          расширенной помощи по сообщению *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  14.06.2012
//                                                   Посл.изменение: 26.08.2017

//{$Define TLoger}
                                                         
// Синтаксис
//
//   procedure Tellme(cMessage:String; nContext:Integer=0;
//     nQTerminate:Integer=queryTerminate; cKeyWord:String='');
//
//   function MessHelp(cKeyWord,cMessage:String;
//            nContext:Integer; nQTerminate:Integer=noTerminate):Integer;

// Параметры
//
//   nContext - контекстный идентификатор сообщения (код ошибки)
//   nQTerminate - завершаемость приложения после вывода сообщения:
//        noTerminate=0,            "Продолжить работу после вывода сообщения"
//        queryTerminate=1,      "Запросить указание на завершение приложения"
//        yesTerminate=2,          "Закрыть приложение после вывода сообщения"
//   cKeyWord - код ошибки/ключевое слово сообщения в расширенной помощи
//
// Возвращаемое значение
//
//   iRet = 0, функция завершена успешно

unit TellmeFrm;

interface

uses
  LaziPrownOutfit,LaziprownAlerts,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Math;

type
  TfrmMessHelp = class(TForm)
    memo: TMemo;
    im: TImage;      // Фиксация размещения мыши внутри значка помощи
    pnlLeft: TPanel;
    pnlRight: TPanel;
    imFront: TImage;
    imBack: TImage;
    btnTerminate: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure imClick(Sender: TObject);
    procedure imMouseMove(Sender:TObject; Shift:TShiftState; X,Y: Integer);
    procedure FormMouseMove(Sender:TObject; Shift:TShiftState; X,Y: Integer);
  private
    cKeyWord: String;      // Ключевое слово сообщения
    nContext: Integer;     // Контекстный идентификатор сообщения
    nQTerminate: Integer;  // Завершаемость приложения после вывода сообщения
    imMove: Boolean;       // True - курсор в расположении изображения значка помощи
    procedure IniElems;
  public
    { Public declarations }
  end;

procedure Tellme(cMessage:String; nContext:Integer=0;
  nQTerminate:Integer=noTerminate; cKeyWord:String=''
  {$IFDEF TLoger}; Log:TLoger=NIL {$ENDIF});

function MessHelp(ciKeyWord,cMessage:String;
  niContext:Integer; niQTerminate:Integer=noTerminate):Integer;

implementation

{$R *.lfm}

uses
  AtUni,SubstrUni,FulldnUni;

// ****************************************************************************
// *              Вывести информационное сообщение или об ошибке              *
// ****************************************************************************
procedure Tellme(cMessage:String; nContext:Integer=0;
  nQTerminate:Integer=noTerminate; cKeyWord:String=''
  {$IFDEF TLoger}; Log:TLoger=NIL {$ENDIF});
var
  c: String;
begin
  // Если заменитель Showmessage, то ретранслируем сообщение
  if (nContext=0)and(nQTerminate=noTerminate) then Showmessage(cMessage+'!')
  // Если ключевое слово и код сообщения определены то выводим многострочное
  // сообщение с возможностью подключения, как помощи, ко внешним приложениям
  else if (nContext<>0)and(cKeyWord<>'')
  then MessHelp(cKeyWord,cMessage,nContext,nQTerminate)
  // Если ключевое слово не задано, то выводим сообщение с кодом на экран или
  // в лог-файл
  else begin
    c:='['+IntToStr(nContext)+'] '+cMessage+'!';
    {$IFNDEF TLoger};
    // Если код сообщения не определен, то выдаем техническое сообщение
    // на экран или отправляем в лог-файл
    if nContext=0 then begin
      if MessageDlg(cMessage+'!'+LineEnding+LineEnding+tlmAttention+LineEnding+
      tlmCloseWork,mtError,[mbYes,mbNo],0)=mrYes
      then Application.Terminate;
    end else begin
      if MessageDlg(c+LineEnding+tlmCloseWork,mtError,[mbYes,mbNo],0)=mrYes
      then Application.Terminate;
    end;
    {$ENDIF}
    {$IFDEF TLoger}
      if Log<>NIL then Log.Log(c);
    {$ENDIF}
  end;
end;

// ****************************************************************************
// *        Вывести многострочное (не более 5 строк) сообщение на экране      *
// *         c возможностью подключения расширенной помощи по сообщению       *
// ****************************************************************************
function MessHelp(ciKeyWord,cMessage:String;
  niContext:Integer; niQTerminate:Integer=noTerminate):Integer;

var
  frmMessHelp: TfrmMessHelp;
  i: Integer; c: String;
  nHeightLines: Integer;

begin
  Result:=0;
  frmMessHelp:=TfrmMessHelp.Create(Application);
  try
    with frmMessHelp do begin
      // Устанавливаем свойства сообщения
      cKeyWord:=ciKeyWord;       // Ключевое слово сообщения
      nContext:=niContext;       // Контекстный идентификатор сообщения
      nQTerminate:=niQTerminate; // Завершаемость приложения после вывода сообщения
      // Начинаем формировать сообщение
      c:=ExtractFileName(Application.ExeName);
      i:=at('.',c);
      c:=substr(c,1,i-1)+': cообщение № '+cKeyWord;
      Caption:=c;
      // В случае безусловного завершения программы
      // предупреждаем пользователя об этом
      if nQTerminate=yesTerminate then begin
        memo.Lines[1]:=cMessage+'.';
        memo.Lines.Add(tlmAppWillbeComplet);
        memo.Lines.Add(' ');
      end
      // Иначе просто загружаем строки сообщения с 1 строки memo-поля формы
      else begin
        memo.Lines[1]:=cMessage+'!';
      end;
      // Для размещения запроса завершения программы
      // добавляем строку в поле избражения
      if nQTerminate=queryTerminate then begin
        memo.Lines.Add(tlmCloseWork);
        memo.Lines.Add(' ');
      end
      else begin
        btnTerminate.Visible:=False;
      end;
      // Снизу добавляем строку для уравновешенного представления сообщения
      memo.Lines.Add(' ');
      // Инициируем данные, раскрываем форму сообщения
      imMove:=False;
      Screen.Cursor:=crHelp;
      im.Picture:=imFront.Picture;
      memo.Font.Height:=16;
      nHeightLines:=memo.Lines.Count*memo.Font.Height;
      memo.Height:=nHeightLines;
      btnTerminate.Top:=memo.Top+memo.Height-btnTerminate.Height-
        Floor(memo.Font.Height/2);
      AutoSize:=True;
      ShowModal;
      // Если нажата кнопка "Завершить приложение" или определено
      // безусловное завершение приложения, завершаем программу
      if (nQTerminate=yesTerminate) or (ModalResult=idNO)
      then Application.Terminate;
    end;
  finally
    frmMessHelp.Free;
  end;
end;

// ****************************************************************************
// *            Инициировать начальное состояние элементов изображения        *
// ****************************************************************************
procedure TfrmMessHelp.IniElems;
begin
  im.Picture:=imFront.Picture;
  pnlRight.SetFocus;
  Screen.Cursor:=crArrow;
end;

// ****************************************************************************
// *     Инициировать форму курсора и фокус ввода убрать на фоновую панель    *
// ****************************************************************************
procedure TfrmMessHelp.FormActivate(Sender: TObject);
begin
  IniElems;
end;

// ****************************************************************************
// *                Вывести расширенный комментарий по сообщению              *
// ****************************************************************************
procedure TfrmMessHelp.imClick(Sender: TObject);
var
  cCurCtrlFile,cHelpFile: String;  // Имя файла помощи приложения
begin
  cHelpFile:=Application.HelpFile;  // Имя файла помощи приложения
  cCurCtrlFile:='chd_ErrEvent.cnt';
  if not FileExists(cCurCtrlFile)
  then ShowMessage('Отсутствует файл содержания помощи по сообщениям: '+
    cCurCtrlFile+'!')
  else begin
    cCurCtrlFile:='chd_ErrEvent.hlp';
    if not FileExists(cCurCtrlFile)
    then ShowMessage('Отсутствует файл помощи по сообщениям: '+cCurCtrlFile+'!')
    else begin
      Application.HelpFile:=cCurCtrlFile;
      Application.HelpContext(nContext);
    end;
  end;
  Application.HelpFile:=cHelpFile;
  IniElems;
end;

// ****************************************************************************
// *    Отметить, что курсор попал в расположения изображения значка помощи   *
// ****************************************************************************
procedure TfrmMessHelp.imMouseMove(Sender:TObject; Shift:TShiftState; X,Y:Integer);
begin
  if not imMove then begin im.Picture:=imBack.Picture; Screen.Cursor:=crHelp; end;
  imMove:=True;
end;

// ****************************************************************************
// *   Отметить, что курсор вышел из расположения изображения значка помощи   *
// ****************************************************************************
procedure TfrmMessHelp.FormMouseMove(Sender:TObject; Shift:TShiftState; X,Y:Integer);
begin
  if imMove then begin im.Picture:=imFront.Picture; Screen.Cursor:=crArrow; end;
  imMove:=False;
end;

end.

// ********************************************************** TellmeFrm.pas ***
