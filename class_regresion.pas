unit class_regresion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,fpexprpars, Dialogs,  ExtCtrls,LCLType, ucmdbox, StdCtrls,
  matrizX, parsemath, math,variable;

type
  TRegresion=class
    data: TMatriz;
    R: real;
    function lineal() : string;
    function nolinealexp() : string;
    function nolinealln() : string;
    private
      Parse: TParseMath;
    public
      b,m,A,miny,minx: real;
      constructor create;
  end;

  procedure regLineal(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  procedure regNoLinealexp(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  procedure regNoLinealln(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation

procedure regLineal(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Reg: TRegresion;
begin
    Reg:=TRegresion.create();
    Reg.data:=TMatriz.create(Args[0].ResString);
    Result.ResString:=Reg.lineal();
    showmessage('presc: '+floattostr(reg.R));
    ActualVariable:=TVariable.create(Result.ResString);
    Result.ResString:=''''+Result.ResString+'''';
    Result.resfloat:=NaN;
end;

procedure regNoLinealexp(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Reg: TRegresion;
begin
    Reg:=TRegresion.create();
    Reg.data:=TMatriz.create(Args[0].ResString);
    Result.ResString:=Reg.nolinealexp();
    showmessage('presc: '+floattostr(reg.R));
    ActualVariable:=TVariable.create(Result.ResString);
    Result.ResString:=''''+Result.ResString+'''';
    Result.resfloat:=NaN;
end;

procedure regNoLinealln(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Reg: TRegresion;
begin
    Reg:=TRegresion.create();
    Reg.data:=TMatriz.create(Args[0].ResString);
    Result.ResString:=Reg.nolinealln();
    showmessage('presc: '+floattostr(reg.R));
    ActualVariable:=TVariable.create(Result.ResString);
    Result.ResString:=''''+Result.ResString+'''';
    Result.resfloat:=NaN;
end;

constructor TRegresion.create;
begin
   data:=TMatriz.create();
   Parse:=TParseMath.create();
   Parse.AddVariable('x',0);
end;

function TRegresion.lineal(): string;
var
  mediax,mediay: real;
  n,i: integer;
  c1,c2,r1,r2: real;
begin
   n:=data.cfil;
   mediax:=0;
   mediay:=0;
   for i:=0 to n-1 do begin
      mediax:=mediax+data.get_element(i,0);
      mediay:=mediay+data.get_element(i,1);
   end;
   mediax:=mediax/n;
   mediay:=mediay/n;
   c1:=0;
   c2:=0;
   r2:=0;
   for i:=0 to n-1 do begin
      c1:=c1+(data.get_element(i,0)-mediax)*(data.get_element(i,0)-mediax);
      c2:=c2+(data.get_element(i,0)-mediax)*(data.get_element(i,1)-mediay);
      r2:=r2+(data.get_element(i,1)-mediay)*(data.get_element(i,1)-mediay);
   end;
   m:=c2/c1;
   b:=mediay-m*mediax;
   lineal:='x*'+floattostr(m)+'+('+floattostr(b)+')';
   Parse.Expression:=lineal;
   r1:=0;
   for i:=0 to n-1 do begin
      Parse.NewValue('x',data.get_element(i,0));
      r1:= r1+(Parse.Evaluate()-mediay)*(Parse.Evaluate()-mediay);
   end;
   R:=sqrt(r1/r2);
end;

function TRegresion.nolinealexp(): string;
var
  mediax,mediay: real;
  n,i: integer;
  c1,c2,r1,r2: real;
begin
   n:=data.cfil;
   mediax:=0;
   mediay:=0;
   miny:=Infinity;
   for i:=0 to n-1 do begin
      miny:=min(miny,data.get_element(i,1));
   end;
   if(miny<=0) then begin
     miny:=abs(miny)+0.0001;
   end else
     miny:=0;
   for i:=0 to n-1 do begin
      mediax:=mediax+data.get_element(i,0);
      mediay:=mediay+ln(data.get_element(i,1)+miny);
   end;
   mediax:=mediax/n;
   mediay:=mediay/n;
   c1:=0;
   c2:=0;
   r2:=0;
   for i:=0 to n-1 do begin
      c1:=c1+(data.get_element(i,0)-mediax)*(data.get_element(i,0)-mediax);
      c2:=c2+(data.get_element(i,0)-mediax)*(ln(data.get_element(i,1)+miny)-mediay);
      r2:=r2+(ln(data.get_element(i,1)+miny)-mediay)*(ln(data.get_element(i,1)+miny)-mediay);
   end;
   m:=c2/c1;
   b:=mediay-m*mediax;
   A:=exp(b);
   result:=floattostr(A)+'*exp('+floattostr(m)+'*x)-('+floattostr(miny)+')';
   Parse.Expression:=result;
   r1:=0;
   for i:=0 to n-1 do begin
      Parse.NewValue('x',data.get_element(i,0));
      r1:= r1+(ln(Parse.Evaluate())-mediay)*(ln(Parse.Evaluate())-mediay);
   end;
   R:=sqrt(r1/r2);
end;

function TRegresion.nolinealln(): string;
var
   Regaux:TRegresion;
   Mataux:TMatriz;
   floataux: float;
   i,n:integer;
begin
   Regaux:=TRegresion.create;
   Mataux:=data;
   n:=data.cfil;
   for i:=0 to n-1 do begin
       floataux:=mataux.get_element(i,0);
       mataux.set_element(i,0,mataux.get_element(i,1));
       mataux.set_element(i,1,floataux);
   end;
   regaux.data:=mataux;
   regaux.nolinealexp();
   A:=1/regaux.A;
   m:=1/regaux.m;
   minx:=regaux.miny;
   result:=floattostr(m)+'*ln('+floattostr(A)+'*(x+'+floattostr(minx)+'))';
   R:=regaux.R;
end;


end.

