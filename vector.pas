unit vector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math,Dialogs,Grids, MatrizFloat;

type
    TVector= class
    private
      lista:TList;

    public
      fil :Integer;
      col :Integer;
      constructor create;
      procedure push_list( list_rec : TMFloat );
      function sub_list( i : Integer):TMFloat;
end;

implementation

constructor TVector.create;
begin
    lista :=TList.Create;
end;

procedure TVector.push_list( list_rec : TMFloat );
var
  plist : ^TMFloat;
begin
     new(plist);
     plist^:=list_rec;
     lista.Add(plist);
end;

function TVector.sub_list( i : Integer ): TMFloat;
var
   plist : ^TMFloat;
begin
   new(plist);
   plist:=lista.Items[i];
   sub_list:= plist^;
end;





end.

