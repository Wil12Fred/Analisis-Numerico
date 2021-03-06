unit matrizfloat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math,Dialogs,Grids, ListFloat;

type
    TMFloat= class
    private
    public
      lista:TList;
      fil :Integer;
      col :Integer;
      constructor create;
      constructor create(content: string);
      procedure push_list( list_rec : TLFloat );
      procedure push_list( list_rec : string ; csv:boolean);
      function sub_list( i : Integer):TLFloat;
      function contenido():string;
end;

implementation

constructor TMFloat.create;
begin
    lista :=TList.Create;
end;

constructor TMFloat.create(content: string);
var i,j: integer;
var lista_rec: TLFloat;
begin
    lista := TList.Create;
    content:=Trim(content);
    for i:=1 to length(content) do begin
        if(content[i]='{') then
          j:=i;
        if(content[i]='}') then begin
            lista_rec:=TLFloat.create(content.Substring(j,i-j-1));
            push_list(lista_rec);
        end;
    end;
    fil:=lista.Count;
    col:=0;
    if (fil>0) then
        col:=sub_list(0).Count;
end;

procedure TMFloat.push_list( list_rec : TLFloat );
var
  plist : ^TLFloat;
begin
     new(plist);
     plist^:=list_rec;
     fil:=fil+1;
     col:=plist^.count;
     lista.Add(plist);
end;

procedure TMFloat.push_list( list_rec : string ; csv: boolean);
var
  plist : ^TLFloat;
begin
     new(plist);
     if(list_rec[1]='{') then
       list_rec:=list_rec.Substring(1,length(list_rec)-2);
     plist^:=TLFloat.create(list_rec, csv);
     fil:=fil+1;
     col:=plist^.Count;
     lista.Add(plist);
end;

function TMFloat.sub_list( i : Integer ): TLFloat;
var
   plist : ^TLFloat;
begin
   new(plist);
   plist:=lista.Items[i];
   sub_list:= plist^;
end;

function TMFloat.contenido(): string;
var
   i: integer;
begin
   contenido:='[';
   for i:=0 to fil-1 do begin
       if(i<>0) then
         contenido:=contenido+' ';
       contenido:=contenido+sub_list(i).contenido();
   end;
   contenido:=contenido+']';
end;

end.
