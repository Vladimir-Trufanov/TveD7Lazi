// LAZARUS, WIN-10\XP                              *** JsonToDatasetUni.pas ***

// ****************************************************************************
// * TJsonBase:                         Переложить Json-объект в набор данных *
// ****************************************************************************

//                                                   Автор:       Труфанов В.Е.
//                                                   Дата создания:  10.11.2017
// Copyright © 2017 tve                              Посл.изменение: 13.11.2017

unit JsonToDatasetUni;

interface

uses
  SysUtils,Classes,
  SuperObject,DB;

procedure JsonToDataset(Recs:ISuperObject; Mem:TDataSet);

implementation

uses
  TypInfo;

function Iso8601StrToDateTime(Value: String): Variant;
var
  i: Integer;
  FS: TFormatSettings;
begin
  if Value = '' then begin
    Result := Null;
    Exit;
  end;
  FS := DefaultFormatSettings;
  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.ShortTimeFormat := 'hh:nn:ss,zzz';
  FS.TimeSeparator := ':';
  i := Pos('T', Value);
  if i = 0 then begin
    Result := StrToDateTime(Value, FS);
  end else begin
    Result := StrToDateTime(Copy(Value, 1, i - 1), FS) +
      StrToDateTime(Copy(Value, i + 1, Length(Value)), FS);
  end;
end;

// ****************************************************************************
// *                    Переложить Json-объект в набор данных                 *
// ****************************************************************************
procedure JsonToDataset(Recs:ISuperObject; Mem:TDataSet);
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
  // Признак того, что таблица обновилась
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
  Mem.EnableControls;
end;

end.

// *************************************************** JsonToDatasetUni.pas ***

