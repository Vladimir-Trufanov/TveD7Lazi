object Form1: TForm1
  Left = 425
  Top = 50
  Width = 545
  Height = 502
  Caption = '  ��� ���������'
  Color = 13421721
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    537
    472)
  PixelsPerInch = 96
  TextHeight = 16
  object ListView1: TListView
    Left = 4
    Top = 2
    Width = 530
    Height = 375
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Color = 13421721
    Columns = <
      item
        Caption = '��������'
      end
      item
        Caption = '������, ����'
      end
      item
        Caption = '����� ����������'
      end
      item
        Caption = '���.'
      end
      item
        Caption = '���.'
      end>
    GridLines = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = ListView1Click
    OnColumnClick = ListView1ColumnClick
    OnCompare = ListView1Compare
    OnDblClick = ListView1DblClick
  end
  object BitBtn1: TBitBtn
    Left = 435
    Top = 439
    Width = 99
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = '�����'
    TabOrder = 1
    Kind = bkClose
  end
  object StaticText1: TStaticText
    Left = 5
    Top = 382
    Width = 529
    Height = 54
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 
      '�������� �: �: D: ��������� ����������. ������� / ��������� ����' +
      '��� �� ����� - �������� �����. ������� / ��������� ������� �� ��' +
      '������� - �������� ��������. ������ ������������ ���������� - � ' +
      '�����  Exten.txt (���������)'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 38
    Top = 444
    Width = 27
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'C:'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 71
    Top = 444
    Width = 26
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'D:'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 5
    Top = 444
    Width = 28
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'A:'
    TabOrder = 5
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 274
    Top = 446
    Width = 151
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '��������� ������'
    TabOrder = 6
  end
  object Button1: TButton
    Left = 104
    Top = 443
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'E'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button5: TButton
    Left = 136
    Top = 443
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'F'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 168
    Top = 443
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'G'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 200
    Top = 443
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'H'
    TabOrder = 10
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 232
    Top = 443
    Width = 25
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Z'
    TabOrder = 11
    OnClick = Button8Click
  end
end