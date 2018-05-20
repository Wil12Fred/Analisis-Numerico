unit sPila;

interface

uses
    Classes, Math,Dialogs, sysutils;

type
     TSPila=class
    private
      lista:TList;

    public
      Count: integer;
      constructor create;
      constructor create(content: string);
      function tamano_pila(): Integer;
      procedure push(val:String);
      function get(i :Integer) :String;
      function contenido() :String;
  end;

implementation

constructor TSPila.create;
  begin
    lista:=TList.Create;
  end;

//raph('x','power(x,2)-2','1')

constructor TSPila.create(content: string);
var i: integer;
var svalue: string;
  begin
    //showmessage(content);
    lista:=TList.Create;
    content:=Trim(content);
    content:=content.substring(1,length(content)-2);
    //showmessage(content);
    svalue:='';
    for i:=1 to length(content) do
    begin
      if(content[i]=';') then begin
          svalue:=Trim(svalue);
          self.push(svalue);
          svalue:='';
      end else begin
          svalue:=svalue+content[i];
      end;
   end;
   svalue:=Trim(svalue);
   if(svalue<>'') then begin
     self.push(svalue);
   end;
   Count:=lista.Count;
  end;

function TSPila.tamano_pila(): Integer;
begin
  tamano_pila := lista.Count;
end;

procedure TSPila.push(val: String);
var
   pInt:^String;
begin
   new(pInt);
   pInt^:=val;
   lista.Add(pInt);
end;


function TSPila.get(i : Integer): String;
var
   ptop : ^String;
begin
   ptop := lista.Items[i];
   get := ptop^;
end;



function TSPila.contenido(): String;
var
   ptr_str : ^String;
   i : Integer;
begin
 new (ptr_str);
   contenido:='{ ';
   for i:=0 to lista.Count-1 do
   begin
     ptr_str:=lista.Items[i];
     if(i<>0) then
       contenido := contenido+' ; ';
     contenido := contenido + ptr_str^;
   end;
   contenido:=contenido+' }';
end;


end.

