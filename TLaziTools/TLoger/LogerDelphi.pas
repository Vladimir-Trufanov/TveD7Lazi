// DELPHI7, WIN98\XP                                          *** Loger.pas ***

// ****************************************************************************
// * Loger [0140]  ����������-������������ ��������� �� ����������� ��������� *
// ****************************************************************************

//                                                   �����:       �������� �.�.
//                                                   ���� ��������:  05.03.2003
// Copyright � 2009 TVE, v 2.2                       ����.���������: 18.10.2011

// ��������
//
//   FileName - ������������ LOG-����� (c �������� ������ ����������� ��� �����:
//   FILENAMElog.txt - ����������� Log-����, FILENAMEloh.txt - Log-���� �������,
//   FILENAMElop.ini - ����������-������������� ����);
//
//   Font - ���� ��� ������ Log-�����;
//   User - ������������

// ������
//
//   Log(cMessage:String) - �������� ����� ���������;
//   View - ���������� ����� � �����������;

// ������������ �������� �������
//
//   Result=0, ����� �������� �������

unit Loger;

interface

uses
  Classes,Controls,Dialogs,Forms,Graphics,
  Messages,Menus,StrUtils,SysUtils,Windows,
  StdCtrls,
  PositionSaver;

const
  LogFile = 1;                // �������� � ������������ Log-�����
  LogHist = 2;                // �������� � Log-����� �������

type
  // ���������� ������
  TLoger = class(TComponent)
  private
    // ��������� ������� ������
    FFileName: String;
    FUser: String;
    // ���������� �������� ������
    FLoger: TForm;
    FLogFile: TFileStream;    // ����������� Log-����
    cNameFile: String;        // ����������� ������������ Log-�����
    FLogHist: TFileStream;    // Log-���� �������
    cNameHist: String;        // ������������ Log-����� �������
    FFirstActivate: Boolean;  // ������ ��������� ����� � P����������
    ps: TPositionSaver;
    FMemo: TMemo;
    //FMemo: TExtendedMemo;
    FFont: TFont;
    // �������� ������������ ����
    FPopUpMenu: TPopupMenu;   // ����������� ���� �� �����
    FmiClearLog: TMenuItem;   // ���������� ������������ Log-�����
    FmiViewHist: TMenuItem;   // ���������� Log-����� �������
    // ������������ �������� FileName - ������������ LOG-�����;
    procedure SetFileName(Value:String);
    function GetFileName:String;
    // ������������ �������� User - ������������;
    procedure SetUser(Value:String);
    function GetUser:String;
    // ������������ ������������ ����
    procedure FmiClearLogOnClickEvent(Sender: TObject);
    procedure FmiViewHistOnClickEvent(Sender: TObject);
    // ������������ ������������� ����� � �����������
    procedure ViewOnActivateEvent(Sender: TObject);
    procedure ViewOnCloseEvent(Sender: TObject; var Action: TCloseAction);
    procedure ViewOnDestroyEvent(Sender: TObject);
    // ������������ Log-������
    function Open(nLogFile:Integer):Byte;
    function Close(nLogFile:Integer):Byte;
    function LogAddString(c:String):Byte;
    function LoadMemo(nLogFile:Integer):Byte;
    procedure SetFont(Value:TFont);
    function GetFont:TFont;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Log(cMessage:String);
    procedure View;
  published
    property FileName:String read GetFileName write SetFileName;
    property Font:TFont read GetFont write SetFont;
    property User:String read GetUser write SetUser;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TD7TOOLS', [TLoger]);
end;

// ****************************************************************************
// *                ���������� ����� ��������� ����������� ������             *
// ****************************************************************************
function gMemorySize: String;
var
  MS: TMemoryStatus;
begin
  MS.dwLength:=SizeOf(TMemoryStatus);
  GlobalMemoryStatus(MS);
  Result:='['+FormatFloat('#"�"',MS.dwTotalPhys div 1048576)+']';
end;

{  ............................ ������ � ��������� ...........................}

// ****************************************************************************
// *             ���������� ������ � �������� "������������ LOG-�����"        *
// ****************************************************************************
procedure TLoger.SetFileName(Value:String);
begin
  FFileName:=Value;
end;
function TLoger.GetFileName:String;
begin
  Result:=FFileName;
end;

// ****************************************************************************
// *                 ���������� ������ � �������� "������������"              *
// ****************************************************************************
procedure TLoger.SetUser(Value:String);
begin
  FUser:=Value;
end;
function TLoger.GetUser:String;
begin
  Result:=FUser;
end;

// ****************************************************************************
// *                      ���������� ������ � �������� "����"                 *
// ****************************************************************************
procedure TLoger.SetFont(Value:TFont);
begin
  FFont:=Value;
end;
function TLoger.GetFont:TFont;
begin
  Result:=FFont;
end;

{  ................................. ������ ..................................}

// ****************************************************************************
// *                             ������� ������                               *
// ****************************************************************************
constructor TLoger.Create(AOwner:TComponent);
begin
  inherited;
  FFont:=TFont.Create;
  // �� ��������� ���������� ��� ����� �����������,
  // ��� 'Log' � �������� ����������
  FFileName:='Log';
  // ������� ������ ��������� ����� ����� ������� ����������
  FFirstActivate:=True;
end;

// ****************************************************************************
// *  ��������� �������� ��� ������ ��������� ����� ����� ������� ����������  *
// ****************************************************************************
procedure TLoger.ViewOnActivateEvent(Sender: TObject);
begin
  if FFirstActivate then begin
    // ��������� Log-���� �������
    Open(LogHist);
    FFirstActivate:=False;
  end;
end;

// ****************************************************************************
// *                               ���������� ������                          *
// ****************************************************************************
destructor TLoger.Destroy;
begin
  // ��������� Log-���� �������
  Close(LogHist);
  inherited;
end;

// ****************************************************************************
// *            ������� ����� ��������� � ���� ����������� ���������          *
// ****************************************************************************
procedure TLoger.Log(cMessage:String);
begin
  try
    View;
    LogAddString(cMessage);
  except
    ShowMessage(cMessage);
  end;
  Application.ProcessMessages;
end;

{............... �������� � �������� ����� ��� ������ ��������� ..............}

// ****************************************************************************
// *               ������������ � ��������� Log-����� � ������� ���           *
// ****************************************************************************
function TLoger.Open(nLogFile: Integer): Byte;

// FLogFile: TFileStream;   - ����������� Log-����
// LogFile = 1;             - �������� � ������������ Log-�����
// FLogHist: TFileStream;   - Log-���� �������
// LogHist = 2;             - �������� � Log-����� �������

begin
  Result:=0;
  // ��������� Log-���� �������
  if nLogFile=LogHist then begin
    cNameHist:=FFileName+'loh.txt';   // Log-���� �������
    try
      if not FileExists(cNameHist) then begin
        FLogHist:=TFileStream.Create(cNameHist,fmCreate);
        FLogHist.Free;
      end;
      FLogHist:=TFileStream.Create(cNameHist,fmOpenWrite);
    except
      Result:=1;
      FLogHist.Free;
      ShowMessage('�� �������� Log-���� �������: '+cNameHist+'!')
    end;
  end
  // ��������� ����������� Log-����
  else begin
    cNameFile:=FFileName+'log.txt';   // ����������� log-����
    try
      if not FileExists(cNameFile) then begin
        FLogFile:=TFileStream.Create(cNameFile,fmCreate);
        FLogFile.Free;
      end;
      FLogFile:=TFileStream.Create(cNameFile,fmOpenWrite);
    except
      Result:=1;
      FLogFile.Free;
      ShowMessage('�� �������� ����������� Log-����: '+cNameFile+'!')
    end;
  end;
end;

// ****************************************************************************
// *                           ������� �������� Log-����                      *
// ****************************************************************************
function TLoger.Close(nLogFile: Integer): Byte;
// FLogFile: TFileStream;   // ����������� Log-����
// FLogHist: TFileStream;   // Log-���� �������
begin
  Result:=0;
  if nLogFile=LogHist then FLogHist.Free
  else FLogFile.Free;
end;

// ****************************************************************************
// *                         ������� ������ � Log-�����                        *
// ****************************************************************************
function TLoger.LogAddString(c:String): Byte;
var s:String;
begin
  Result:=0;
  // ����������� ������� � ���������
  s:=FormatDateTime('dd.mm.yyyy,hh:nn:ss ',Now)+gMemorySize+' '+FUser+#9+c;
  // ������� ������ �� �����
  FMemo.Lines.Add(s);
  // ������� ������ � Log-�����
  s:=s+#13+#10;
  if Open(LogFile)=0 then begin
    FLogFile.Seek(0,soFromEnd);
    FLogFile.WriteBuffer(Pointer(s)^,Length(s));
    Close(LogFile);
  end;
  FLogHist.Seek(0,soFromEnd);
  FLogHist.WriteBuffer(Pointer(s)^,Length(s));
end;

// ****************************************************************************
// *                                 ��������� Memo                           *
// ****************************************************************************
function TLoger.LoadMemo(nLogFile:Integer):Byte;
begin
  Result:=0;
  FMemo.Clear;
  // ��������� Log-���� �������
  if nLogFile=LogHist then begin
    FMemo.Color:=clMoneyGreen;
    try
      Close(LogHist);
      FMemo.Lines.LoadFromFile(cNameHist);
      Open(LogHist);
    except
      Result:=1;
      ShowMessage('�� ������� ��������� Log-���� �������: '+cNameHist+'!');
    end;
  end
  // ��������� ����������� Log-����
  else begin
    FMemo.Color:=clWindow;
    try
      Close(LogFile);
      FMemo.Lines.LoadFromFile(cNameFile);
      Open(LogFile);
    except
      Result:=1;
      ShowMessage('�� ������� ��������� ����������� Log-����: '+cNameFile+'!');
    end;
  end;
end;

// ****************************************************************************
// *                  ���������� ����� ��� ����������� ���������              *
// ****************************************************************************

// ����� ������ ��������� �������� ����������� ������, ���������, �����������-
// ���� � �����, ���� �� �� ������� "������� �� �����".  ����� ����� ���� ���-
// ���� � ����������, ��� ��������� 2 �������:  ��������� ����� ���������  ���
// ������������  ����� �������  ���������������  ������  �����  c  �����������
// (�� ��������� F2)

// ������� � ������������� ����� � ���������� Log-�����
procedure TLoger.View; 
const MaxLen = 20;
begin
  // ���������, ���������� �� �����, ���� ����� �����������, �� �� �������
  // � ����� ������� ������������� �������� ���������� ����
  if not Assigned(FLoger) then begin
    // ������� �����
    FLoger:=TForm.Create(Application);
    FLoger.FormStyle:=fsStayOnTop;
    // ������� ��������� ����� � ��������� ����� ������
    if FFileName='Log' then FLoger.Caption:='Log-���� ...'+Application.Title
    else FLoger.Caption:='Log-���� ... '+RightStr(FFileName,MaxLen);
    // ������� ������� ����������� �������� ����� Logera
    Floger.OnActivate:=ViewOnActivateEvent;
    Floger.OnClose:=ViewOnCloseEvent;
    Floger.OnDestroy:=ViewOnDestroyEvent;
    // ��������� ���� ��� log-�������
    //FMemo:=TExtendedMemo.Create(FLoger);
    FMemo:=TMemo.Create(FLoger);
    FMemo.Parent:=FLoger;
    FMemo.Align:=alClient;

    FMemo.Font.Name:=FFont.Name; // 'MS Sans Serif'
    FMemo.Font.Size:=FFont.Size; // 8

    FMemo.ScrollBars:=ssBoth;    //ssVertical;
    FMemo.WordWrap:=True;
    FMemo.ReadOnly:=True;
    // ��������� ����������� ���� �� �����
    FPopUpMenu:=TPopupMenu.Create(FLoger);
    FLoger.PopupMenu:=FPopUpMenu;
    FPopUpMenu.Items.Clear;
    // ������� ��������� ������ ����
    FmiClearLog:=TMenuItem.Create(FLoger);
    FmiClearLog.Caption:='�������� ����������� Log-����';
    FPopUpMenu.Items.Add(FmiClearLog);
    FmiClearLog.OnClick:=FmiClearLogOnClickEvent;

    FmiViewHist:=TMenuItem.Create(FLoger);
    FmiViewHist.Caption:='������������� �� Log-���� �������';
    FPopUpMenu.Items.Add(FmiViewHist);
    FmiViewHist.OnClick:=FmiViewHistOnClickEvent;
    // �������� ������� �� ������ ��������
    ps:=TPositionSaver.Create(FLoger);
    if FFileName='Log' then ps.FileName:=Application.Title+'lop.ini'
    else ps.FileName:=FFileName+'lop.ini';
    // ��������� Memo �� ����� �� ������������ Log-�����
    if Open(LogFile)=0 then begin
      LoadMemo(LogFile);
      Close(LogFile);
    end;
    // ������� �����
    FLoger.Show;
    FMemo.Lines.Add('');
  end;
end;

// ****************************************************************************
// *  ���������� (������� �� ������) ��������� ������� ����� ��� �� ��������  *
// ****************************************************************************
procedure TLoger.ViewOnCloseEvent(Sender: TObject; var Action: TCloseAction);
begin
  // ���������� ������� Loger� �� ������
  // ��� �������� ����� (�� ������� ���� ��� "�� ������ �� �����") ���������
  // ����� �������� � ������ �� �������� ����������. ������� �������������
  // ������ �� ����� ����������� �� ������� OnClose ��������� Action:=caFree;
  Action:=caFree;
  inherited;
end;

// ****************************************************************************
// *          �������� ������ �� ��������� ����� ����� ��� �����������        *
// ****************************************************************************
procedure TLoger.ViewOnDestroyEvent(Sender: TObject);
begin
  // �������� �������  ����������  ����� - if not Assigned(FLoger)  ����������
  // ����������� �� �������� NIL, �� ������������ ���������� VCL �������������
  // �� ����������� ����� �������� ��� ������������ �����, ��� ��� �� ��������
  // ����� ����� �����������. ������� ��� ������ ���� ����� ����� ������������
  FLoger:=NIL;
  inherited;
end;

// ****************************************************************************
// *              �������� Memo c ���������� ������������ Log-�����           *
// ****************************************************************************
procedure TLoger.FmiClearLogOnClickEvent(Sender: TObject);
var cFileName: PAnsiChar;
begin
  cFileName:=PAnsiChar(cNameFile);
  if not DeleteFile(cFileName) then
    MessageDlg('������ �������� ������������ Log-�����:'+
    cFileName,mtInformation,[mbOk],0);
  FMemo.Clear;
end;

// ****************************************************************************
// *                      ������������� �� Log-���� �������                   *
// ****************************************************************************
procedure TLoger.FmiViewHistOnClickEvent(Sender: TObject);
begin
  LoadMemo(LogHist);
end;

end.

// *********************************************************** VarSaver.pas ***
