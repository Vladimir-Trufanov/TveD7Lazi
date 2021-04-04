unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    BitBtn1: TBitBtn;
    StaticText1: TStaticText;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
     TSL : TStringList;
     SmallIm: TImageList;
     IC1: TIcon;
     procedure AddNewFile(F:TSearchRec);
     procedure OpDir;
     procedure OpDoc;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation uses ShellAPI, ImgList;
{$R *.DFM}
Var Dira : String; SubI: Integer = 0;
 CurrentDir: String = '';
 First: boolean = true;
 edFindText: string;

function Old_Dira(const dir: string):String; 
//� ������ dir ������� ����� ������ \ � ���������� ����� dir, �������������
//����� ���� (� � ������������ �� ������������� )
var ii,lena,poza: Integer;
begin  lena := Length(dir); // ����� ������ dir
 If Pos ('\',dir) = 0 then // ���� � ������ ��� ������� /
  begin Result := dir; exit; // ���������� �������� ������ dir 
  end;
 for ii := lena downto 1 do // ������������ ������ dir ������ ������
  begin if dir[ii] = '\' then // ���� � ii-� ������� ��������� /
    begin poza := ii; Result := Copy(dir,1,poza-1); break; 
     // poza - ������� � ������� ��������� ������ /
     // � ���������� Result ���������� ����� ������ �� ������� 1 �� ������� poza-1
     // ���������� Result �������� ����������� ������ �������.
    end;
  end;
end;

procedure TForm1.OpDir;
Var F: TSearchREc; Fa: Integer; selcap: String;
begin
If  ListView1.Selected <> Nil then // � � ���� ������� �����-�� ������
begin  selcap := ListView1.Selected.Caption; //selcap := Caption ��������� ������
 If pos('..',selcap) > 0  then  // ���� � selcap ���� ������ ".." 
  CurrentDir := Old_Dira(edFindText) else // ����������� �� edFind.Text ���, ��� ������
   // ������ ������� ������� / (������������). �������� �����, �� ������� �� ���� ������.
  CurrentDir := edFindText +'\'+ selcap; //  ���� � selcap ��� ������ ".." , ��
  // "������������" ����� selcap ������ � edFind.Text, ������� ����� ���� ������ /
 end // � � ����� �� ����������� ��� ��������� �� ������ ����� (����������, ���������)
     // �����.
     else CurrentDir := edFindText;

ListView1.Items.Clear; // ������� ������ 
Fa := faAnyFile; // �������� ������� ������ - �����;
 If FindFirst(CurrentDir+'\*.*',Fa,F) <> 0 then exit; //������� � ����� CurrentDir ����� ����
  AddNewFile(F); // ��������� ��� �������������� � ������ (������ AddNewFile()
 while FindNext(F) = 0 do  AddNewFile(F); // ������� ��������� ����� (� �����), ���� ��� ����
  FindClose(F); ListView1.AlphaSort; //��������� �����. ��������� ������ ������
// ( ListView1.AlphaSort - �����, ������� ��������� ������, ��������� ListView1Compare)
//�� ListView1Compare. ����� �� ������ �������, ����� ���������� �� �����. 
edFindText := CurrentDir; //�������� � edFind.Text �����, ������� �� �������������
Caption := CurrentDir; // �� �� - � ��������� �����
if first then first:= false else
StaticText1.caption := '';
end;

procedure TForm1.OpDoc; //��������� �������� ���������.
var  zFileName: array[0..600] of Char ; //����� (�����) ��� �������� ��������� ������
  exten,ExUP,FNam,Proga: string; ii: Integer;
begin  for ii:= 0 to 600 do zFileName[ii] := #0; //������� ������
  exten := ExtractFileExt(ListView1.Selected.Caption);// ������ ���������� ����� ���������
  ExUP := UPPERCASE(exten); //��������� ���������� � ������� ������� (���������)
  Proga := TSL.Values[ExUP]; //��������� �� TSL.Values ��� ���������-����������� 
  //(�� ���������� ����������). ��� ����� ������������ ���� Exten.txt, ����������� ������� 
  // ���������� ����� ����������� � ������ TSL � ��������� TForm1.Create (������) 
  If (length(Proga)<3) and (ExUP<>'.EXE') then showmessage
   ('�� �������� ���������� ����� ����������>'+ExUp+'<-->'+Proga+'<'+#13#10+
   '�������� ��� � ���� Exten.txt');
  //FNam - ��� ����� �������, ������� ����� �������� ������������ �������. ������� �������
  // �� ���� ������. ������� - ��� ��������� ����������� (Proga), ����� (����� ������, �����
  //����� � ����� Exten.txt) - ��� ���������. ��� ��� ����� ����� ��������� ������ ����.
  // ��� ��������� ������������ �� 2-� ������: ���� (�����)(edFind.Text) � ��� ��������� 
  //(ListView1.Selected.Caption).  ����� ���� - ���� /   
  FNam := Proga +'"'+ edFindText + '\'+ ListView1.Selected.Caption+'"';
  StaticText1.caption := '�������>' + FNam;
  StrPCopy(zFileName,FNam); //����������� ������ FNam � ������, ��� ������� (PChar) ���������
  // ��� ��������� WinExec
  try // ��������� �� ������ ������
  WinExec(zFileName,SW_SHOW);
  except
  end;
end;

procedure TForm1.FormCreate(Sender: TObject); //�������� ��� �������� �����
var ii: Integer;
begin
 edFindText := 'C:'; //�����, � ������� �������� �������� ( �������� ������� ����� � )
 //������ �������������� ������ ������ �������. ( � ��� ��� 32�32 )
 SmallIm := TImageList.Create(Self); //������� ������ (� �������� ������)
 SmallIm.BkColor:= clBtnFace;  SmallIm.BlendColor:= clwhite;
 SmallIm.DrawingStyle:= dsTransparent;  SmallIm.masked:= false;
 SmallIm.Height := 32; SmallIm.Width := 32; SmallIm.AllocBy := 5;

 Ic1 := TIcon.Create; { � � �� �������� ������������ }
  //������� ������ (� �������� ������)

 Dira:= ExtractFileDir(paramstr(0)); //Dira - �����, �� ������� �������� ���������

for ii:= 0 to ListView1.Columns.Count - 1 do //������������� �������� �������� (�������)
  ListView1.Columns.Items[ii].Alignment := taCenter;

  ListView1.Columns.Items[0].Width := 200; //������ 
  ListView1.Columns.Items[1].Width := 80;
  ListView1.Columns.Items[2].Width := 140;
  ListView1.Columns.Items[3].Width := 40;
  ListView1.Columns.Items[4].Width := 40;

  Ic1.LoadFromFile(Dira+'\16843.ico'); //��������� ������ �� �����
  SmallIm.AddIcon(Ic1);//��� ��������� ������, ������� �� ������ = 0 (������ ������� � ����)
  Ic1.LoadFromFile(Dira+'\3106.ico'); //��������� ������ �� ����� 
  SmallIm.AddIcon(Ic1);//��� ��������� ������, ������� �� ������ = 1
  TSL := TStringList.Create; //������� ������ TSL ������ TStringList.Create
  TSL.LoadFromFile(Dira+'\Exten.txt'); //��������� � TSL ��������� ���� Exten.txt
  ListView1.SmallImages := SmallIm; //"����������" �������������� ���� ������ ������
  // � ������ ListView1. � � ������ �� ����� ������������, ��� ��������� ListView1
 OpDir; //������������� ����� (�� ��������� OpDir )
end;

procedure TForm1.AddNewFile(F:TSearchRec);//���������� �� ��������� OpDir ���
 //��������� ������ ����������� � ��������������� �����. ������ ����� AddNewFile
 // ��������� ������ � ������ ListVew1.
Var Hid: String;  It2: TListItem; // It2 - ������, ������� ����� ����������� � ������
begin
 {with ListView1.Items.Add, F do - ����� �������� ��� ���� }
 //�������� with ������������ ��� ListView1.Items.Add � ��� F
  begin It2:= ListView1.Items.Add; //����� Add ��������� ������ ������ � ������
     It2.Caption := F.Name; //��� ����� (�� F ) ���������� � ��-�� Caption, � � 
      //����� ����� � ������ ������� ������
     if (F.Attr and faDirectory) <> 0 then // F.Attr - ������� ����� ��� �����. 
      // ���� F ���� ���������� (�����), �� (F.Attr and faDirectory) <> 0 
      begin It2.ImageIndex := 0; //����� ��� ���� ����� ������ � �������� 0
       It2.SubItems.Add(' ����� ');//� �� ������ ������� (������) ����� " �����"
      end
      else //����� (� � ��� �� ����� � ����)
      begin It2.ImageIndex := 1; //����� ��� ���� ����� ������ � �������� 1
       It2.SubItems.Add(IntToStr(F.Size));
        //� �� ������ ������� (������) ����� ������ �����
      end;
    It2.SubItems.Add(DateTimeToStr((FileDateToDateTime(F.Time))));
    // � 3-� ������� �������
    // ����� ���������� ����� F.Time (������ SubItems.Add ��������� �������,
    // � � ��������� ���
    // � ��������� �������. ������ � �������� ��������
    //(�� ����� �� 2-� ������� - "������")

    If (F.Attr and faHidden) <> 0 then Hid := '��' else Hid := '���';
    It2.SubItems.Add(Hid);
    If (F.Attr and faSysFile) <> 0 then Hid := '��' else Hid := '���';
    It2.SubItems.Add(Hid);
  end;
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
Var s1,s2,st1,st2 : String;
{����� ������ - �� ������ �������� (�������) �����������. ��������� ��� ���������
�������� � ���������� ��������. ���� �� ������ ������, f(Item1) < f(Item2), ��
�� ������ ��������� ���������� Compare �������� -1, ����  f(Item1) > f(Item2),
�� Compare = 1, ����  f(Item1) = f(Item2), �� Compare = 0;
��������, ����� ����������� �� ������� �����. ����� ������� f(Item)
 - ��� ������ �����, � � Item1.SubItems[0]. ���� ����������� ���, ��� ������
 - ��� �����, � Item1.SubItems[0] - ������.
 ������ ����������� �����, �������� '100' < '44' (������������ ������� 1-� �������).
  ����� ������ ��� ����������, ��������� ����� ����� ������ �� ����� 12 -
 ���� ��������� �� ����� �����.  ����� ������� f(Item) - ��� ��� �����,
 �� Item.Caption.
 ���������� ��������� SubI ������ ��� �����������. �� �������� �������� ���
 ������ �� �������� ����������� ������� (�� ��������� ListView1ColumnClick).
 ������ ���������� ������� � ���, ��� ����� ������ ��� ����� ����������
 ������������� ���� ������ � � ���� "������". ��� ����� � �������������� �������
 ����� ������������� '0' - ��� ����� � '1' - ��� ������. ����� ������
 ����� < ����. }
begin
  Case SubI of
  0:begin s1 := Item1.Caption; s2 := Item2.Caption;
    end;
  1: begin
      s1:= {Item1.SubItems.Strings[0]; � ����� ������: } Item1.SubItems[0];
         while length(s1) < 12 do s1 := '0'+s1;
      s2:= Item2.SubItems.Strings[0]; while length(s2) < 12 do s2 := '0'+s2;
     end;
  2: begin  Str(StrToDateTime(Item1.SubItems.Strings[1]):10:10,s1);
            Str(StrToDateTime(Item2.SubItems.Strings[1]):10:10,s2);
     end;
  3:Begin
    s1 :=  Item1.SubItems.Strings[SubI - 1];
    s2 :=  Item2.SubItems.Strings[SubI - 1];
    end;
  end;

  st1 := IntToStr(Item1.ImageIndex)+ s1;
  st2 := IntToStr(Item2.ImageIndex)+ s2;
{����� �����������, �� ������ �����-����, �� ������: �� �����, ���������}
If st1 = st2 then Compare := 0 else
If st1 < st2 then Compare := -1 else Compare := 1;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
begin //������� ������ �� ���� ������
// ���� �������� �� ������ � ������, �� ��������� OpDir
// ���� �������� �� ������ � ������, �� ��������� OpDoc
 If  ListView1.Selected <> Nil then
 If  ListView1.Selected.ImageIndex = 0 then  OpDir
 else OpDoc else
   showmessage('����� ������� ������');//���� �������� �� �� ������
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);//������ �� ��������� ������� 
//���������� SubI - ������ ��������� �������  SubI := Column.Index;
begin  SubI := Column.Index;
 ListView1.AlphaSort;
   //�������� ���������� (�� ����� ListView1Compare, ������� ��������� � ����)
 Case SubI of
 0: Caption := '�������� �� �����';
 1: Caption := '�������� �� �������';
 2: Caption := '�������� �� ����';
 3: Caption := '�������� �� ���������';
 4: Caption := '�������� �� �����������';
 end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin   {���������� �������, ��������� � ������ Form1.Create }
 SmallIm.Free; IC1.Free; TSL.Free; 
end;

procedure TForm1.Button2Click(Sender: TObject);
begin {�������� �� �: }//������ �������� �������� �� �: 
 edFindText := 'C:'; CurrentDir := 'C:'; OpDir;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin  {�������� �� D }//������ �������� �������� �� D:
 edFindText := 'D:';  CurrentDir := 'D:'; OpDir;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin  {�������� �� A }//������ �������� �������� �� A: 
 edFindText := 'A:';  CurrentDir := 'A:'; OpDir;
end;

procedure TForm1.ListView1Click(Sender: TObject);
begin //��� ���� ��������, ����� ��������� ������� ������ ��, ��� ������ ��������
 // ������� �������. ������� ����������� - ����������� �� ������ �� CheckBox1
  If CheckBox1.Checked then ListView1DblClick(Sender);
 // ���� ������ ����������� (.Checked) �� ���������� ���������, �������������� ������� ������
 // (ListView1DblClick)
end;

procedure TForm1.Button1Click(Sender: TObject);
begin  {�������� �� E }//������ �������� �������� �� E:
 edFindText := 'E:';  CurrentDir := 'E:'; OpDir;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin  {�������� �� F }//������ �������� �������� �� F:
 edFindText := 'F:';  CurrentDir := 'F:'; OpDir;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin  {�������� �� G }//������ �������� �������� �� G:
 edFindText := 'G:';  CurrentDir := 'G:'; OpDir;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin  {�������� �� H }//������ �������� �������� �� H:
 edFindText := 'H:';  CurrentDir := 'H:'; OpDir;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin  {�������� �� Z }//������ �������� �������� �� Z:
 edFindText := 'Z:';  CurrentDir := 'Z:'; OpDir;
end;

end.

