unit class_lag;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath, Dialogs, math, fpexprpars, matrizx,variable;

type
  TLag= class
    size: integer;
    DatX: array of real;
    DatY: array of real;
    //procedure sort();
    function getFunction: string;
    function getProduct(i: integer): string;
    function interPolar(x: real): real;
    function find(x: real): integer;
    procedure insert(x,y: real);
    end;

  procedure lagrange(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation

procedure lagrange(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var points: TMatriz;
var lag: TLag;
  var i: integer;
begin
  points:=TMatriz.create(Args[0].resString);
  i:=0;
  lag:= TLag.Create;
  while(i<points.cfil) do begin
      lag.insert(points.get_element(i,0),points.get_element(i,1));
      i:=i+1;
  end;
  Result.ResString:=lag.getFunction;
  ActualVariable:=TVariable.create(Result.ResString);
  Result.ResString:=''''+Result.ResString+'''';
  Result.ResFloat:=NaN;
end;

function TLag.getProduct(i: integer): string;
var j: integer;
begin
   j:=0;
   Result:='';
   while(j<length(datx)) do begin
     if(j<>i) then begin
        Result:= Result+'(x'+'-'+FloatToStr(datx[j])+')/'+'('+FloatToStr(datx[i]-datx[j])+')*';
     end;
     j:=j+1;
   end;
   Result := Result+'1';
end;

function TLag.find(x: real): integer;
var i: integer;
begin
   i:=0;
   while(i<length(DatX)) and (DatX[i]<x) do begin
      i:=i+1;
    end;
   find:=i;
end;

{
 x=[{1;2.4}{2;0}{3;4.1}]
 lag(x)
}

procedure TLag.insert(x,y: real);
var i,j: integer;
  Xaux: array of real;
  Yaux: array of real;
begin
    Xaux:=DatX;
    Yaux:=DatY;
    i:=find(x);
    if(i=length(DatX)) or (DatX[i]=x) then begin
       SetLength(DatX,length(DatX)+1);
       SetLength(DatY,length(DatY)+1);
    end;
    j:=0;
    while(j<i) do begin
       DatX[j]:=Xaux[j];
       j:=j+1;
    end;
    DatX[i]:=x;
    DatY[i]:=y;
    j:=j+1;
    if(i<length(Xaux)) and (Xaux[i]=x) then
      i:=i+1;
    while(i<length(Xaux)) do begin
         DatX[j]:=XAux[i];
         DatY[j]:=YAux[j];
    end;
end;

function TLag.getFunction: string;
var i: integer;
begin
   Result:='';
   i:=0;
   while(i<Length(datx)) do begin
         Result:=Result+'(('+FloatToStr(daty[i])+')*('+getProduct(i)+'))+';
         i:=i+1;
   end;
   Result:=Result+'0';
end;

function TLag.interPolar(x: real): real;
var Parse: TParseMath;
  i,j,k: integer;
  lagaux: TLag;
begin
   lagaux:=tlag.Create;
    Parse:= TParseMath.create();
    if(length(DatX)>7) then begin
   i:=find(x);
   k:=min(i+3,length(DatX)-1);
   for j:=max(i-3,0) to k do begin
      lagaux.insert(DatX[j],DatY[j]);
   end;
   Parse.Expression:=lagaux.getFunction;
   Parse.AddVariable('x',x);
   Result:= Parse.Evaluate();

   end else begin
      Parse.Expression:=getFunction;
      Parse.AddVariable('x',x);
      Result:= Parse.Evaluate();
   end;
   lagaux.Destroy;
end;

end.

