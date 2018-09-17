unit UListUsers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid;

Type
  TOneUser = Class
  public
    Name: String;
    Subname: string;
    Family: string;
    ShortName: string;
    Login: string;
    Password: string;
    Procedure WriteToStream(F: tStream);
    Procedure ReadFromStream(F: tStream);
    Procedure Assign(User: TOneUser);
    Constructor Create;
    Destructor Destroy;
  end;

  TListUsers = Class
  public
    Count: integer;
    Users: array of TOneUser;
    Procedure WriteToFile(FileName: String);
    Procedure ReadFromFile(FileName: string);
    Procedure Clear;
    function Add: integer;
    Procedure Delete(Login: string);
    function UserExists(Login, Password: string): boolean;
    Constructor Create;
    Destructor Destroy;
  end;

var
  ListUsers: TListUsers;
  UPos: integer;

implementation

uses umain, ucommon, umyfiles;

function MyEncodeString(Step: integer; Src: String): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to length(Src) do
    result := result + chr(ord(Src[i]) - Step);
end;

function MyDecodeString(Step: integer; out Src: String): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to length(Src) do
    result := result + chr(ord(Src[i]) + Step);
end;

Constructor TOneUser.Create;
begin
  Name := '';
  Subname := '';
  Family := '';
  ShortName := '';
  Login := '';
  Password := '';
end;

Destructor TOneUser.Destroy;
begin
  FreeMem(@Name);
  FreeMem(@Subname);
  FreeMem(@Family);
  FreeMem(@ShortName);
  FreeMem(@Login);
  FreeMem(@Password);
end;

Procedure TOneUser.WriteToStream(F: tStream);
begin
  WriteBufferStr(F, MyEncodeString(StepCoding, Name));
  WriteBufferStr(F, MyEncodeString(StepCoding, Subname));
  WriteBufferStr(F, MyEncodeString(StepCoding, Family));
  WriteBufferStr(F, MyEncodeString(StepCoding, ShortName));
  WriteBufferStr(F, MyEncodeString(StepCoding, Login));
  WriteBufferStr(F, MyEncodeString(StepCoding, Password));
end;

Procedure TOneUser.ReadFromStream(F: tStream);
var
  s: string;
begin
  ReadBufferStr(F, s);
  Name := MyDecodeString(StepCoding, s);
  ReadBufferStr(F, Subname);
  Subname := MyDecodeString(StepCoding, s);
  ReadBufferStr(F, Family);
  Family := MyDecodeString(StepCoding, s);
  ReadBufferStr(F, ShortName);
  ShortName := MyDecodeString(StepCoding, s);
  ReadBufferStr(F, Login);
  Login := MyDecodeString(StepCoding, s);
  ReadBufferStr(F, Password);
  Password := MyDecodeString(StepCoding, s);
end;

Procedure TOneUser.Assign(User: TOneUser);
begin
  Name := User.Name;
  Subname := User.Subname;
  Family := User.Family;
  ShortName := User.ShortName;
  Login := User.Login;
  Password := User.Password;
end;

Constructor TListUsers.Create;
begin
  Count := 0;
end;

Destructor TListUsers.Destroy;
var
  i: integer;
begin
  Clear;
  FreeMem(@Count);
  FreeMem(@Users);
end;

Procedure TListUsers.Clear;
var
  i: integer;
begin
  for i := Count - 1 to 0 do
    Users[i].FreeInstance;
  Count := 0;
  Setlength(Users, Count);
end;

function TListUsers.UserExists(Login, Password: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to Count - 1 do
  begin
    if (trim(Users[i].Login) = trim(Login)) and
      (trim(Users[i].Password) = trim(Password)) then
    begin
      result := true;
      exit;
    end;
  end;
end;

Procedure TListUsers.WriteToFile(FileName: String);
var
  Stream: TFileStream;
  i: integer;
  renm: string;
begin
  try
    if FileExists(FileName) then
    begin
      renm := ExtractFilePath(FileName) + 'Temp.Save';
      RenameFile(FileName, renm);
      DeleteFile(renm);
    end;
    Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
    try
      Stream.WriteBuffer(Count, SizeOf(integer));
      for i := 0 to Count - 1 do
        Users[i].WriteToStream(Stream);
    finally
      FreeAndNil(Stream);
    end;
  except
  end;
end;

Procedure TListUsers.ReadFromFile(FileName: string);
var
  Stream: TFileStream;
  i, apos, cnt: integer;
begin
  if not FileExists(FileName) then
    exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
    Stream.ReadBuffer(cnt, SizeOf(integer));
    Clear;
    for i := 0 to cnt - 1 do
    begin
      apos := Add;
      Users[apos].ReadFromStream(Stream);
    end;
  finally
    FreeAndNil(Stream);
  end;
end;

function TListUsers.Add: integer;
begin
  Count := Count + 1;
  Setlength(Users, Count);
  Users[Count - 1] := TOneUser.Create;
  // Users[Count-1].Name      := User.Name;
  // Users[Count-1].Subname   := User.Subname;
  // Users[Count-1].Family    := User.Family;
  // Users[Count-1].ShortName := User.Subname;
  // Users[Count-1].Login     := User.Login;
  // Users[Count-1].Password  := User.Password;
  result := Count - 1;
end;

Procedure TListUsers.Delete(Login: string);
var
  i, apos: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if trim(Users[i].Login) = trim(Login) then
    begin
      apos := i;
      break;
    end;
  end;
  if apos < Count - 1 then
    for i := apos to Count - 1 do
      Users[apos] := Users[apos + 1];
  Count := Count - 1;
  Setlength(Users, Count);
end;

initialization

ListUsers := TListUsers.Create;
UPos := ListUsers.Add;
ListUsers.Users[UPos].Name := 'Demo';
ListUsers.Users[UPos].Subname := '';
ListUsers.Users[UPos].Family := '';
ListUsers.Users[UPos].ShortName := 'Demo';
ListUsers.Users[UPos].Login := 'Demo';
ListUsers.Users[UPos].Password := 'Demo';
UPos := ListUsers.Add;
ListUsers.Users[UPos].Name := 'Павел';
ListUsers.Users[UPos].Subname := 'Алексеевич';
ListUsers.Users[UPos].Family := 'Завьялов';
ListUsers.Users[UPos].ShortName := 'Supervisor';
ListUsers.Users[UPos].Login := 'sv';
ListUsers.Users[UPos].Password := '_cyt;yfz_';

finalization

ListUsers.Clear;
ListUsers.FreeInstance;

end.
