unit JsonToStringUni;

{$mode objfpc}{$H+}

interface

uses
  SuperObject,db,
  Classes, SysUtils;

function JsonToString(Recs:ISuperObject): String;

implementation

uses
  LazitoolsOutfit;

// ****************************************************************************
// *                       Вложить SO в оперативную таблицу                   *
// ****************************************************************************
function JsonToString(Recs:ISuperObject): String;
var
  J: ISuperObject;
  JRow: TSuperEnumerator;
  Ji: TSuperObjectIter;
  Ja: TSuperArray;
  size: Integer;
  reg: Boolean;
  width: Integer;
  ft: TFieldType;
  Field: TField;
  Filtered: Boolean;
begin
  Result:='';
  JRow:=Recs.GetEnumerator;
  if JRow.MoveNext then begin
    J:=JRow.Current;
    if ObjectFindFirst(J,Ji) then repeat
      {Ja:=Ji.val.AsArray;
      ft:=ftLargeInt;
      if Ja.Length>0 then ft:=TFieldType(GetEnumValue(TypeInfo(TFieldType),Ja.S[0]));
      size:=0;
      if Ja.Length>1 then size:=Ja.I[1];
      reg:=False;
      if Ja.Length>2 then reg:=Ja.B[2];
      if size=16384 then size:=8191;}
      Result:=Result+'"'+Ji.key+'":'+CR+LF;
      // Mem.FieldDefs.Add(Ji.key, ft, size, reg);
    until not ObjectFindNext(Ji);
    ObjectFindClose(Ji);
  end;
  JRow.Free;
  //Result:=''+'Ghb!';

  //







  {JRow := Recs.GetEnumerator;
  if JRow.MoveNext then begin
    J := JRow.Current;
    if ObjectFindFirst(J, Ji) then
    repeat
      Ja := Ji.val.AsArray;
      ft := ftLargeInt;
      if Ja.Length > 0 then
        ft := TFieldType(GetEnumValue(TypeInfo(TFieldType), Ja.S[0]));
      size := 0;
      if Ja.Length > 1 then
        size := Ja.I[1];
      reg := False;
      if Ja.Length > 2 then
        reg := Ja.B[2];
      if size = 16384 then
        size := 8191;
      Mem.FieldDefs.Add(Ji.key, ft, size, reg);
    until not ObjectFindNext(Ji);
    ObjectFindClose(Ji);
  end;
  Mem.Open;
  JRow.Free; }



  {// Признак того, что таблица обновилась
  Mem.Tag := 1;
  JRow := Recs.GetEnumerator;
  Mem.DisableControls;
  Filtered := Mem.Filtered;
  Mem.Filtered := False;
  Mem.Close;
  Mem.Open;
  Mem.First;
  while not Mem.EOF do
    Mem.Delete;
  Mem.Close;
  Mem.FieldDefs.Clear;
  if JRow.MoveNext then begin
    J := JRow.Current;
    if ObjectFindFirst(J, Ji) then
    repeat
      Ja := Ji.val.AsArray;
      ft := ftLargeInt;
      if Ja.Length > 0 then
        ft := TFieldType(GetEnumValue(TypeInfo(TFieldType), Ja.S[0]));
      size := 0;
      if Ja.Length > 1 then
        size := Ja.I[1];
      reg := False;
      if Ja.Length > 2 then
        reg := Ja.B[2];
      if size = 16384 then
        size := 8191;
      Mem.FieldDefs.Add(Ji.key, ft, size, reg);
    until not ObjectFindNext(Ji);
    ObjectFindClose(Ji);
  end;
  Mem.Open;
  JRow.Free;
  JRow := Recs.GetEnumerator;
  if JRow.MoveNext then begin
    J := JRow.Current;
    if ObjectFindFirst(J, Ji) then
    repeat
      Ja := Ji.val.AsArray;
      if Ja.Length > 3 then begin
        width := Ja.I[3];
        Field := Mem.FieldByName(Ji.key);
        Field.DisplayWidth:= width;
      end;
    until not ObjectFindNext(Ji);
    ObjectFindClose(Ji);
  end;
  while JRow.MoveNext do begin
    J := JRow.Current;
    Mem.Append;
    if ObjectFindFirst(J, Ji) then
    repeat
      Field := Mem.FieldByName(Ji.key);
      case Field.DataType of
      ftDate, ftDateTime: Field.Value := Iso8601StrToDateTime(Ji.val.AsString);
      else
        Field.Value := Ji.val.AsString;
      end;
    until not ObjectFindNext(Ji);
    Mem.Post;
    ObjectFindClose(Ji);
  end;
  JRow.Free;
  Mem.Filtered := Filtered;
  Mem.First;
  Mem.EnableControls; }

end;


end.

