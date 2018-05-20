unit variable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Menus,fpexprpars,
  matrizX, sPila;

type
  TVariable=class
    varname: string;
    varvalue: string;
    varfloat: real;
    varvector:TSPila;
    varmatriz:TMatriz;
    typevalue: integer;
    function validname(): boolean;
    function validvalue(): boolean;
    function toString(): string;
    function abrv(): string;
    private
    public
      constructor create();
      constructor create(valueR: real);
      constructor create(valueR: TSPila);
      constructor create(valueR: TMatriz);
      constructor create(valueR: string);
      constructor create(name: string; value: string);
  end;

var
  ActualVariable: TVariable;

implementation

constructor TVariable.create();
begin
  typevalue:=-1;
end;

constructor TVariable.create(valueR: real);
begin
  varname:='';
  varfloat:=valueR;
  typevalue:=0;
end;

constructor TVariable.create(valueR: TSPila);
begin
  varname:='';
  varvector:=valueR;
  typevalue:=1;
end;

constructor TVariable.create(valueR: TMatriz);
begin
  varname:='';
  varmatriz:=valueR;
  typevalue:=2;
end;

constructor TVariable.create(valueR: string);
begin
  varname:='';
  varvalue:=valueR;
  typevalue:=3;
end;

constructor TVariable.create(name: string; value: string);
begin
  varname:=Trim(name);
  varvalue:=Trim(value);
  typevalue:=0;
end;

function TVariable.validname(): boolean;
var i: integer;
begin
  result:=false;
  if(length(varname)=0) then exit;
  i:=1;
  if (ord(varname[i])<97) or (ord(varname[i])>122) then begin
    exit;
  end;
  i:=2;
  while (i<=Length(varname)) do begin
         if (ord(varname[i])<48) or (ord(varname[i])>57) then begin
           if (ord(varname[i])<97) or (ord(varname[i])>122) then begin
             exit;
           end;
         end;
         i:=i+1;
   end;
  result:=true;
end;

function TVariable.validvalue(): boolean;
var n:integer;
begin
    Result:= true;
    n:= length(varvalue);
    typevalue:=0;
    Result:=true;
    if (n>1) and (varvalue[1]='{') and (varvalue[n]='}') then begin
      varvector:=TSPila.create(varvalue);
      typevalue:=1;
      exit;
    end;
    if (n>1) and (varvalue[1]='[') and (varvalue[n]=']') and (validmat(varvalue)=true) then begin
      varmatriz:=TMatriz.create(varvalue);
      typevalue:=2;
      exit;
    end;
    if (n>1) and (varvalue[1]='''') and (varvalue[n]='''') then begin
      varvalue:=varvalue.Substring(1,length(varvalue)-2);
      typevalue:=3;
      exit;
    end;
    Result:= false;
end;

function TVariable.abrv(): string;
begin
  if(typevalue=0) then
    Result:=floattostr(varfloat);
  if(typevalue=1) then
    Result:= varvector.contenido() ;
  if(typevalue=2) then begin
    if(varmatriz.cfil>1) then begin
      Result:='matriz['+inttostr(varmatriz.cfil)+']['+inttostr(varmatriz.ccol)+']';
    end else
      Result:='mat: '+varmatriz.contenido();
  end;
  if(typevalue=3) then
    Result:=''''+varvalue+'''';
end;

function TVariable.toString(): string;
begin
  if(typevalue=0) then
    Result:=floattostr(varfloat);
  if(typevalue=1) then
    Result:=varvector.contenido ;
  if(typevalue=2) then
    Result:=varmatriz.contenido();
  if(typevalue=3) then
    Result:=varvalue;
end;

end.

