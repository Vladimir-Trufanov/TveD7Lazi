// DELPHI7, WIN98\XP                                  *** PositionSaver.pas ***

// ****************************************************************************
// * PositionSaver [0150]     ��������� �������������� ���������, ����������� *
// *  �� �����, ��� �������������, ����������� ����� �������������� ��������� *
// *                                                      � ��������� ������� *
// ****************************************************************************

//                                                   �����:      �������� �.�..
//                                                   ���� ��������:  21.01.2007
// Copyright � 2011 TVE                              ����.���������: 13.10.2011

// ��������
//
//   FileName - ������������ ����������������� ����� � ���������������� ������-
//       ��� ��������� �����: TDBGrid, TPanel, TSplitter, TDBNavigator, TDBMemo
//
//   CharDefault -  ��� ������� ������ �������������� �������� ����� �  ������-
//  ��� �������. �� ��������� ����������� ������� "F7", ��� ������� VK_F7 = 118
//
// ������
//
//   _Open(AOwner:TComponent; lSaved:Boolean=True) [private] -  ����������  ��-
// ������� ����������� �����,  �������� ����������������� ����� lSaved=True ���
// � ���������� ��������� lSaved=False.  ����� ������ ����������� �� ����������
// ��� ��� �������� ������ � ������������ ������.
//
//   Open(AOwner:TComponent; lMake:Boolean=False) [public]  - ����� �����������
// �� ����������.   �� ��������� lMake=False ��������� ���������, ��� ����� ���
// ��� �������� ��� �������� �����. ���� ���������� ����������������� ���������
// ����������� � ���� ��������, �������� �� �������� �����  (��������, ��� ���-
// ��� ��������� ����), �� ��� ������ ������ ����� ���������� lMake=True.
//
//   _Save(AOwner:TComponent) [private] - ��������� ��������� ����������� �����
// � ���������������� �����. ����� ����������� ������������� ��� �������� ����-
// �������� ����� ����������.
//
//   Save(AOwner:TComponent; lMake:Boolean=False) [public]  - ������������� ��-
// ������� ��������� ����������� ����� � ���������������� ����� lMake=True.

// ��������� �� �������������:
//
//   ����������� ���������� � ������� � ������� �����,  � �����  � ���������� �
// � �������� ���� �������� ���� DBGrid �����. ����� ����� ����������� �������-
// ������� ���������� �� �����.

unit PositionSaver;

interface

uses
  //AppEvnts,
  SysUtils, Classes, forms,
  //Registry,
  Messages, Windows, Grids, DBGrids,
  //QExtCtrls,
  STDCTRLS,  Graphics, Controls,ExtCtrls,DBCtrls, DB;

const
  Component_version=301;  // 3.01  ����� �������� ����������

type
  TPositionSaver = class
  private
    // ��������� ������� �������
    FForm: TForm;         // ��������������� �����
    FIniName: string;     // ������������ Ini-�����
    FCharDefault: Word;   // ��� ������� ������ �������������� � ��������� �������


    // ���������� ���������
    aDefault: Variant;    // ������ � ����������� ����������� �����


    //fp: TextFile;         // ���� � ������������ �����������
    //FFirstOpen: Boolean;  // True - ��������� ������ ��������� ����� ��� Open
    //FCleaPosit: Boolean;  // True - ������� ������� ��������� ������� �����
    //FAppliEvents: TApplicationEvents;
    //FOnClose: TCloseQueryEvent;
    //procedure _Open(AOwner:TComponent; lSaved:Boolean=True);
    //procedure _Save(AOwner:TComponent);
    procedure Default;
    function isControlPlace(Control:TComponent): Boolean;
    //procedure FormReplace(var fp:textfile; AOwner:TComponent; lSaved:Boolean);
    //procedure ControlReplace(Control:TControl; var fp:textfile; lSaved:Boolean);
    //procedure ControlSetBound(Control:TControl; var fp:textfile; lSaved:Boolean);
    //procedure SetDefault(Control:TControl);
    //procedure SaveControl(MainControl: TControl; fname: String);
    //procedure AppliEventsMessage(var Msg:tagMSG; var Handled:Boolean);
    //procedure OnFormCloseQuery(Sender:TObject; var CanClose:Boolean);
  protected
    { Protected declarations }
  public
    constructor Create(oOwner:TForm); //override;
    //procedure Open(AOwner:TComponent; lMake:Boolean=False);
    //procedure Save(AOwner:TComponent; lMake:Boolean=False);
    function GetForm:TForm;
    procedure SetForm(Value:TForm);
    function GetFileName:string;
    procedure SetFileName(Value:string);
    function GetCharDefault:Word;
    procedure SetCharDefault(Value:Word);
    destructor Destroy; override;
  published
    property Form:TForm read GetForm write SetForm;
    property CharDefault:Word read GetCharDefault write SetCharDefault;
    property FileName:string read GetFileName write SetFileName;
  end;

implementation

uses
  ArrayLib,
  Variants,Dialogs,Math,
  //DBTables,
  IniFiles;

{  ............................ ������ � ��������� ...........................}

// ���������� ������ � �������� "��������������� �����"
function TPositionSaver.GetForm:TForm;
begin
  Result:=FForm;
end;
procedure TPositionSaver.SetForm(Value:TForm);
begin
  FForm:=Value;
end;

// ���������� ������ � �������� "������������ INI-�����"
function TPositionSaver.GetFileName:String;
begin
  Result:=FIniName;
end;
procedure TPositionSaver.SetFileName(Value:String);
begin
  FIniName:=Value;
  //_Open(Owner,True);
end;

// ���������� ������ � ��������
// "��� ������� ������ �������������� � ��������� �������"
function TPositionSaver.GetCharDefault:Word;
begin
  Result:=FCharDefault;
end;
procedure TPositionSaver.SetCharDefault(Value:Word);
begin
  FCharDefault:=Value;
end;

{  ................................. ������ ..................................}

// ****************************************************************************
// *                         ��������� �� ������� �����                       *
// ****************************************************************************
{function GetMainForm(AOwner:TComponent):TForm;
var
  oComponent: TComponent;
begin
  if (AOwner is TForm) then Result:=AOwner as TForm else Result:=NIL;
  oComponent:=AOwner;
  while Assigned(oComponent) do begin
    oComponent:=oComponent.Owner;
    if (oComponent is TForm) then Result:=oComponent as TForm;
  end;
end;}

// ****************************************************************************
// *                             ������� ������                               *
// ****************************************************************************
constructor TPositionSaver.Create(oOwner:TForm);
begin
  // ��������� � �������� ��������������� ����� oOwner. ��� ����������
  // ������� PositionSaver ��������� ����� ������ ���� � ���������:
  // oOwner.Position:=poDesigned
  FForm:=oOwner;
  //if AOwner.Name=GetMainForm(AOwner).Name
  //then GetMainForm(AOwner).Position:=poDesigned;
  
  //if not(csDesigning in ComponentState) then begin
  //  FAppliEvents:=TApplicationEvents.Create(AOwner);
  //  FAppliEvents.OnMessage:=AppliEventsMessage;
  //end;
  //if (AOwner is TForm) then begin
  //  FOnClose:=(AOwner as TForm).OnCloseQuery;
  //  (AOwner as TForm).OnCloseQuery:=OnFormCloseQuery;
  //end;
  //Tag:=0;   // ��������� ������� ����������� ���������
  //FCharDefault:=VK_F7;
  // ���������� ������������ ��������� ������������ ����������� ����� 
  Default;
  //FCleaPosit:=False;  // True - ������� ������� ��������� ������� �����
  //
  // ����� ����� ���� �� ������� _Open(AOwner,True), �� �� DBGrid � ���� �����
  // ����� ������� ����� 0, ������� ����� ������ ����� �������� ������ �
  // ��������� ���������� OnMessage ��������� �����
  //FFirstOpen:=True;
end;

{// ****************************************************************************
// *               �������� ��������� � �������� ����� ����������             *
// ****************************************************************************
procedure TPositionSaver.OnFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  _Save(Owner);
  if Assigned(FOnClose) then FOnClose(Sender, CanClose);
  FCleaPosit:=False;  // True - ������� ������� ��������� ������� �����
end;}

// ****************************************************************************
// *  �������� ��������� � ��������� ����� �������������� ��������� � ������- *
// *  ��� ������� ��� ��������� �������������� (��������� ��������� ��������� *
// *                           ������ � �������� ����                         *
// ****************************************************************************
{procedure TPositionSaver.AppliEventsMessage(var Msg:tagMSG; var Handled: Boolean);
var
  TypeMess: Cardinal;
begin
  TypeMess:=msg.message;
  // ��� ���������� ������� ���������� (�������� ��� ����������� ���������)
  // �� ������� "�" ������������� ����
  if (TypeMess=WM_KEYDOWN)and(67=msg.wParam)
  then begin
    Tag:=1;  // ��������� ������� ����������� ���������
  end
  // �� ������� "������" ���������� ����
  else if (TypeMess=WM_KEYDOWN)and(32=msg.wParam)
  then begin
    Tag:=0;   // ��������� ������� ����������� ���������
  end;
  // ���������� ���������������� ��������� ������
  // ��� ��������� ���������� ����
  // (��� ������� ����� ���� �� ���������� = 13.10.2011)
  if (Owner is TForm)and(Owner as TForm).Active then begin
    TypeMess:=msg.message;
    if FFirstOpen then begin
      FFirstOpen:=False;
      _Open(Owner,True);
    end;
    // ����������� � ������������ ������� �� ������� 'F7' (�� ���������)
    // � ���������� �������������� � ������� �������� ����
    if (TypeMess=WM_KEYDOWN)and(msg.wParam=FCharDefault) then begin
      FCleaPosit:=True;  // True - ������� ������� ��������� ������� �����
      (Owner as TForm).Close;
    end;
  end;
  Handled:=False;
end;}

// ****************************************************************************
// *                               ���������� ������                          *
// ****************************************************************************
destructor TPositionSaver.Destroy;
begin
  //inherited Destroy;
end;

{function ReadInteger(var F: TextFile; out Value: Integer): Boolean;
begin
  Result := False;
  {$I-}
  ReadLn(F, Value);
  if IOResult = 0 then
    Result := True;
  {$I+}
end;

const
  ERROR_AOWNER = '����� ������ ���� �������� � �������� ��������� ������ %s';

procedure TPositionSaver.SetDefault(Control:TControl);
var
  i: Integer;
begin
  for i:=1 to aLen(aDefault) do begin
    if Control.Name=Trim(aDefault[i][1])
    then begin
      Control.Width:=aDefault[i][2];
      Control.Height:=aDefault[i][3];
      Control.Top:=aDefault[i][4];
      Control.Left:=aDefault[i][5];
      break;
    end;
  end;
end;}

// ****************************************************************************
// *                ���������� ����� ���������� Control-��������              *
// ****************************************************************************
{procedure TPositionSaver.ControlSetBound(Control:TControl; var fp:textfile; lSaved:Boolean);

  function SetBound(var fp:textfile): Integer;
  var
    ntmp: Integer;
  begin
    SetBound:=0;
    if ReadInteger(fp,ntmp) then begin
      SetBound:=ntmp;
    end;
  end;

begin
  if isControlPlace(Control)
  then begin
    if lSaved then begin
      Control.Width:=SetBound(fp);
      Control.Height:=SetBound(fp);
      Control.Top:=SetBound(fp);
      Control.Left:=SetBound(fp);
    end
    else SetDefault(Control);
  end;
end;}

// ****************************************************************************
// *             ��������� ������� Control � ����������� ���������            *
// ****************************************************************************
{ procedure TPositionSaver.ControlReplace(Control:TControl; var fp:textfile; lSaved:Boolean);
var
  dbntmp: TDBGrid;
  ntmp,cln,j: integer;
begin
  // ��������������� ��������� � ������� ������, ����� ������� ���� ��������
  if (Control is TDBGrid)and((Control as TDBGrid).Columns.Count>0) then begin
    ControlSetBound(Control,fp,lSaved);
    // ��������������� ��������� ������� TDBGrid
    dbntmp:=(Control as TDBGrid);
    // ��� �����������
    if lSaved then begin
      ReadInteger(fp, cln);
      cln := Min(cln, dbntmp.Columns.Count);
      for j:=0 to cln-1 do begin
        if ReadInteger(fp,ntmp) then begin
          dbntmp.Columns[j].Width:=ntmp;
        end;
      end;
    end
    // ��� ������� �� ���������
    else begin
      for j:=0 to dbntmp.Columns.Count-1 do begin
        dbntmp.Columns[j].Width:=16;
      end;
    end;
  end
  // ��������������� ��������� � ������� ������ ���������
  else begin
    ControlSetBound(Control,fp,lSaved);
  end;
end;}

// ****************************************************************************
// *          ������������ ����� � �� �������� � ������������ ���������       *
// *                              ��� � �����������                           *
// ****************************************************************************
{procedure TPositionSaver.FormReplace(var fp:textfile; AOwner:TComponent; lSaved:Boolean);
var
  ctemp: string;
  fname: string;
  i,ntmp,cn: integer;
  vNames,vAli: variant;
  Component: TComponent;
  Control: TControl;
  Form: TForm;
begin
  while not(eof(fp)) do begin
    fname:=AOwner.Name;
    // ������������� ���� ��� ������ ��������� � ��������� �����
    repeat Readln(fp,ctemp)
    until (Copy(ctemp,2,length(ctemp)-2)=fname) or (eof(fp));
    if (eof(fp)) then break;  // ����� �� �������, �������� �� ��������
    // ���������� �� ������� ��������� �����
    Form:=AOwner as TForm;
    if lSaved then begin
      if ReadInteger(fp,ntmp) then Form.Width:=ntmp;
      if ReadInteger(fp,ntmp) then Form.Height:=ntmp;
      if ReadInteger(fp,ntmp) then Form.Top:=ntmp;
      if ReadInteger(fp,ntmp) then Form.Left:=ntmp;
    end
    else begin
      Form.Width:=aDefault[1][2];
      Form.Height:=aDefault[1][3];
      Form.Top:=aDefault[1][4];
      Form.Left:=aDefault[1][5];
    end;
    ReadInteger(fp, cn);
    vNames:=VarArrayCreate([1,cn], varVariant);
    vAli:=VarArrayCreate([1,cn], varVariant);
    // ������������ ��� ���������� �����
    for i:=1 to cn do begin
      Readln(fp, ctemp);
      ctemp:=Copy(ctemp, 2, length(ctemp)-2);
      Component:=AOwner.FindComponent(ctemp);
      if Component is TControl then Control:=Component as TControl
      else Control:=nil;
      if Component is TControl then begin
        vNames[i]:=Component.Name;
        vAli[i]:=Control.Align;
        Control.Align:=alCustom;
        // ��������������� ��������� � ������� ������,
        // ����� ������� ���� ��������
        ControlReplace(Control,fp,lSaved);
      end;
    end;
    // ��������������� ������ �������� align
    for i:=cn downto 1 do begin
      Component:=AOwner.FindComponent(vNames[i]);
      if Component is TControl then (Component as TControl).Align:=vAli[i];
    end;
  end;
end;}

// ****************************************************************************
// *     ��������� �������� �� ��������� ����� ����������� � �����������      *
// *                         ��������������� �� ������                        *
// ****************************************************************************
function TPositionSaver.isControlPlace(Control:TComponent): Boolean;
begin
  Result:=False;
  if (Control is TDBGrid)
  or(Control is TPanel)
  or(Control is TSplitter)
  or(Control is TDBNavigator)
  or(Control is TDBMemo)
  then Result:=True;
end;

// ****************************************************************************
// *  ������������ ������������ ��������� ������������ ����������� �����      *
// ****************************************************************************
procedure TPositionSaver.Default;
var
  i: integer;
  // Form: TForm;
  Control: TControl;
  aOne: Variant;      // ���� ��������� � ����������� ��������������� �� ������
begin
  // ��������� ���������� ����� �� ���������
  aCreate(aDefault);
  //Form:=AOwner as TForm;
  aCreate(aOne);
  {aadd(aOne,Form.Name);
  aadd(aOne,Form.Width);
  aadd(aOne,Form.Height);
  aadd(aOne,Form.Top);
  aadd(aOne,Form.Left);}

  aadd(aOne,FForm.Name);
  aadd(aOne,FForm.Width);
  aadd(aOne,FForm.Height);
  aadd(aOne,FForm.Top);
  aadd(aOne,FForm.Left);

  aadd(aDefault,aOne);
  // ��������� ���������� control-�� �� ���������
  for i:=0 to FForm.ComponentCount-1 do begin
    if isControlPlace(FForm.Components[i]) then begin
      Control:=FForm.Components[i] as TControl;
      aCreate(aOne);
      aadd(aOne,Control.Name);
      aadd(aOne,Control.Width);
      aadd(aOne,Control.Height);
      aadd(aOne,Control.Top);
      aadd(aOne,Control.Left);
      aadd(aDefault,aOne);
    end;
  end;

  aSay(aDefault,'aDefault');


end;

// ****************************************************************************
// *  ���������� ��������� ����������� ����� �������� ����������������� ����� *
// *                     ��� � ������������� �����������                      *
// ****************************************************************************
{procedure TPositionSaver.Open(AOwner:TComponent; lMake:Boolean=False);
begin
  // ���� ���� ���������, �� ������������� �����
  if lMake then begin
    if (AOwner is TForm) then begin _Save(AOwner); _Open(AOwner) end;
  end
  // ����� ������������� ������������ � ������ ������������ ������ Open
  else ShowMessage('����� PositionSaver.Open ���� �� ������������! '+
    chr(13)+chr(10)+'����� ��� �������� ��� �������� �����: '+Owner.Name);
end;}

{procedure TPositionSaver._Open(AOwner:TComponent; lSaved:Boolean=True);
var
  ctemp:string;
  nver, nvcode:integer;
begin
  // �������� ����������, ���� ����� �� �� �����
  if not (AOwner is TForm) then Exception.CreateFmt(ERROR_AOWNER,['Open']);
  // ���� ��� ����� �� ����������, �� ��������� ������ ��� ����������
  // �������������� �� �����
  if (Trim(cIniName)='_Reset')or(cIniName='') then begin
  end
  else begin
    // ���� ������. ����� �� ����������, ������ ���.
    if (not FileExists(cIniName)) then _Save(AOwner);
    // ������������� � ����� � �������� ��� ���������
    AssignFile(fp,cIniName);
    Reset(fp);
    Readln(fp,ctemp);
    ctemp:=copy(ctemp,1,pos(#9,ctemp)-1);
    val(ctemp,nver,nvcode);
    // ��������� ������ �����
    if (nvcode>0) or (nver < component_version) or (length(ctemp)<1) then begin
      close(fp);
      Erase(fp);
      Save(AOwner);
      exit;
    end;
    // ��������������� ����� � �� �������� � ����������� ��� ������������ ���������
    FormReplace(fp,AOwner,lSaved);
    CloseFile(fp);
  end;
end;}

// ****************************************************************************
// *           ��������� ������� � ��������� ����� ��� �� ��������            *
// ****************************************************************************
{procedure SaveControlSize(var fp:TextFile; Control:TControl);
var
  s: String;
begin
  s:=Control.Name;
  if Control is TForm then Writeln(fp,'['+s+']')
  else Writeln(fp,'{'+s+'}');
  s:='%d'#9'# %s %s';
  Writeln(fp, Format(s, [Control.Width,  Control.Name, 'Width']));
  Writeln(fp, Format(s, [Control.Height, Control.Name, 'Height']));
  Writeln(fp, Format(s, [Control.Top,    Control.Name, 'Top']));
  Writeln(fp, Format(s, [Control.Left,   Control.Name, 'Left']));
end;}

// ****************************************************************************
// *              ��������� ���������� � ������ �������� DBGrid               *
// ****************************************************************************
{procedure SaveDBGridColumns(var fp:TextFile; DBGrid:TDBGrid);
var
  i: Integer;
begin
  Writeln(fp, IntToStr(DBGrid.Columns.Count)+#9'# Column Count');
  for i:=0 to DBGrid.Columns.Count-1 do
    Writeln(fp,Format('%d'#9'# Columns[%d] width',[DBGrid.Columns[i].Width,i+1]));
end;}

// ****************************************************************************
// * ��������� �������������� ����������� ������� ����� � ���������������� ����
// ****************************************************************************
{procedure TPositionSaver.SaveControl(MainControl:TControl; fname:String);
var
  i: Integer;
  Component: TComponent;
  Control: TControl;
  s: String;
  Names: THashedStringList;
begin
  // ��������� ������� � ��������� ������� �����
  SaveControlSize(fp, MainControl);
  if MainControl is TDBGrid then SaveDBGridColumns(fp, MainControl as TDBGrid)
  else begin
    Names:=THashedStringList.Create;
    try
      // ������� ���-�� ��������� ��� ����������
      for i:=0 to MainControl.ComponentCount-1 do begin
        Component:=MainControl.Components[i];
        if isControlPlace(Component) then begin
          s := Format('%.9d', [(Component as TControl).Top]) + '=' + Component.Name;
          Names.Add(s);
        end;
      end;
      // ��������� ��� ����������� �������� �������� align ��� ������ ������. �����
      Names.Sort;
      // ��������� ������� � ��������� ���������, ������� ����� ������
      writeln(fp,inttostr(Names.Count)+#9'# Number of Components on form');
      for i:=0 to Names.Count - 1 do begin
        Component:=MainControl.FindComponent(Names.ValueFromIndex[i]);
        if not (Component is TControl) then Continue;
        Control:=Component as TControl;
        if isControlPlace(Control) then SaveControlSize(fp,Control);
        if Control is TDBGrid then SaveDBGridColumns(fp, Control as TDBGrid);
      end;
    finally
      Names.Free;
    end;
  end;
end;}

// ****************************************************************************
// *      ��������� ��������� ����������� �����, � ���������������� ����      *
// ****************************************************************************
{procedure TPositionSaver.Save(AOwner:TComponent; lMake:Boolean=False);
begin
  // ���� ���� ���������, �� ������������� �����
  if lMake then _Save(Owner)
  // ����� ������������� ������������ � ������ ������������ ������ Save
  else ShowMessage('����� PositionSaver.Save ���� �� ������������! '+
    chr(13)+chr(10)+'����� ����� �������� ����� ��������� �����: '+Owner.Name);
end;}

{procedure TPositionSaver._Save(Aowner:TComponent);
var
  fname:string;
  ltend:boolean;
  tfp: textfile;
  ctemp:string;
  Control: TControl;
begin
  // ���� ��� ����� �� ����������, �� � ��������� ������ ��� ����������
  // �������������� �� �����
  if (Trim(cIniName)='_Reset')or(cIniName='') then begin
  end
  else begin
    if not (AOwner is TForm) then Exception.CreateFmt(ERROR_AOWNER, ['Save']);
    // ���������� ��� ������� �����, ���������� �������������� ���������
    // ������� ����� ��������� � ���������������� �����
    Control:=AOwner as TControl;
    fname:=Control.Name;
    // ������ ����� ������� ������. �����
    CopyFile(pchar(cIniName),pchar(cIniName+'.tmp'),false);
    // ��������� ���� ��� ����������
    AssignFile(fp,cIniName);
    Rewrite(fp);
    // �������� ������ ���������� � �����
    WriteLn (fp, inttostr(Component_version)+#9'# Component Version');
    // �������� ���������� ��������� ������ ���� � �� �����������
    // �� ����� ������� ������. �����
    if (FileExists(cIniName+'.tmp')) then begin
      AssignFile(tfp, cIniName+'.tmp');
      Reset(tfp);
      Readln(tfp, ctemp);  // ������������ ������ ����������
      // �������� ������ �� ������� �����
      // �� ��������� ��������� �������������� ������� �����
      ctemp:='';
      while not(eof(tfp)) do begin
        Readln(tfp,ctemp);
        if (Copy(ctemp,2,length(ctemp)-2)=fname) then break;
        writeln(fp,ctemp);
      end;
      // ������������ ������ ���������� �������������� ������� �����
      ltend:=true;
      while (ltend) do begin
        Readln(tfp, ctemp);
        if (eof(tfp)) then ltend:=false;
        if (length(ctemp))>2 then begin
          if (ctemp[1]='[') and (ctemp[length(ctemp)]=']')
          then ltend:=false;
        end;
      end;
      // ���� �� ����� ����� �� �������, ������ ��� ������� ������ ������
      // �������� �������������� ��������� ������ �����
      if not(eof(tfp)) then writeln(fp, ctemp);
      // ���������� ���������� ��������������
      while not(eof(tfp)) do begin
        Readln(tfp, ctemp);
        writeln(fp, ctemp);
      end;
      // ��������� � ������� ������ ����
      CloseFile(tfp);
      DeleteFile(pchar(cIniName+'.tmp'));
    end;
    if not FCleaPosit then SaveControl(Control,fname);
    CloseFile(fp);
  end;
end;}

end.

// ****************************************************** PositionSaver.pas ***

