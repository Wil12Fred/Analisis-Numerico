unit ListFloat;

{$mode objfpc}{$H+}

interface

uses
  Classes,math ,Dialogs, SysUtils;
type
  TLFloat =class
    private
      lista: TList;
    public
      Count: integer;
      constructor create;
      constructor create(content: string);
      constructor create(content: string;csv: boolean);
      procedure push_float(val:float);
      function get_val(j:Integer):float;
      procedure remove_float(index :Integer);
      procedure set_val(j:Integer;val:float);
      function contenido():String;
end;

implementation
constructor  TLFloat.create;
begin
  lista:=TList.Create;
  Count:=0;
end;

constructor  TLFloat.create(content: string);
var i: integer;
var sfloat: string;
begin
  lista:=TList.Create;
  content:=Trim(content);
  sfloat:='';
  for i:=1 to length(content) do
  begin
      if(content[i]=';') then begin
          sfloat:=Trim(sfloat);
          push_float(StrToFloat(sfloat));
          sfloat:='';
      end else begin
          sfloat:=sfloat+content[i];
      end;
  end;
  sfloat:=Trim(sfloat);
  if(sfloat<>'') then begin
    push_float(StrToFloat(sfloat));
  end;
  Count:=lista.Count;
end;

constructor  TLFloat.create(content: string; csv: boolean);
var i: integer;
var sfloat: string;
begin
  lista:=TList.Create;
  content:=Trim(content);
  sfloat:='';
  for i:=1 to length(content) do
  begin
      if((content[i]=',') and (csv)) or ((content[i]=';') and (csv=false)) then begin
          sfloat:=Trim(sfloat);
          push_float(StrToFloat(sfloat));
          sfloat:='';
      end else begin
          sfloat:=sfloat+content[i];
      end;
  end;
  sfloat:=Trim(sfloat);
  if(sfloat<>'') then begin
    push_float(StrToFloat(sfloat));
  end;
  Count:=lista.Count;
end;

procedure TLFloat.remove_float(index :Integer);
begin
  lista.Delete(index);
end;

procedure TLFloat.push_float(val:float);
var
  auxval:^float;
begin
  new(auxval);
  auxval^:=val;
  lista.Add(auxval);
end;

function TLFloat.get_val(j:Integer):float;
var
  val:^float;
begin
  val:=lista.Items[j];
  get_val:=val^;
end;

procedure TLFloat.set_val(j:Integer;val:float);
var
  auxval:^float;
begin
  new(auxval);
  auxval^:=val;
  lista.Items[j]:=auxval;
end;

function TLFloat.contenido():String;
var
  conte:String;
  i:Integer;
  auxval:^float;
begin
  new(auxval);
  conte:='{';
  for i:=0 to lista.Count - 1 do
  begin
    if(i<>0) then
      conte:=conte+'; ';
    auxval:=lista.Items[i];
    conte:=conte+FloatToStr(auxval^);

  end;
  contenido:=conte+'}';
end;

end.
