unit class_integral;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fpexprpars, variable,
    FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
    ComCtrls, Spin, StdCtrls, Types, math,
    matrizfloat, listfloat, ParseMath;

type
  TIntegral=class
    n: integer;
    private
    public
      cArea: boolean;
      Parse: TParseMath;
      points: TMFloat;
      function f(x:real): real;
      function puntomedio(xleft: real; xright: real): real;
      function trapecio(xleft: real; xright: real): real;
      function simpson1(xleft: real; xright: real): real;
      function simpson1(): real;
      function simpson3(xleft: real; xright: real): real;
      constructor create();
  end;

 procedure trapecio(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
 procedure puntomedio(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
 procedure simpson1(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
 procedure simpson1P(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
 procedure simpson3(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation

procedure trapecio(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Integral: TIntegral;
begin
    Integral:=TIntegral.create();
    Integral.Parse.Expression:=(Args[0].ResString);
    Integral.Parse.AddVariable(Args[1].ResString,0);
    Integral.n:=1000;
    Result.ResFloat:=Integral.trapecio(ArgToFloat(Args[2]),ArgToFloat(Args[3]));
    ActualVariable.create(Result.ResFloat);
end;

procedure puntomedio(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Integral: TIntegral;
begin
    Integral:=TIntegral.create();
    Integral.Parse.Expression:=(Args[0].ResString);
    Integral.Parse.AddVariable(Args[1].ResString,0);
    Integral.n:=1000;
    Result.ResFloat:=Integral.puntomedio(ArgToFloat(Args[2]),ArgToFloat(Args[3]));
    ActualVariable.create(Result.ResFloat);
end;

procedure simpson1(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Integral: TIntegral;
begin
    Integral:=TIntegral.create();
    Integral.Parse.Expression:=(Args[0].ResString);
    Integral.Parse.AddVariable(Args[1].ResString,0);
    Integral.n:=1000;
    Result.ResFloat:=Integral.simpson1(ArgToFloat(Args[2]),ArgToFloat(Args[3]));
    ActualVariable.create(Result.ResFloat);
end;

procedure simpson1P(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Integral: TIntegral;
begin
    Integral:=TIntegral.create();
    Integral.points:=TMFloat.create(Args[0].ResString);
    Result.ResFloat:=Integral.simpson1();
    ActualVariable.create(Result.ResFloat);
end;

procedure simpson3(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Integral: TIntegral;
begin
    Integral:=TIntegral.create();
    Integral.Parse.Expression:=(Args[0].ResString);
    Integral.Parse.AddVariable(Args[1].ResString,0);
    Integral.n:=10000;
    Result.ResFloat:=Integral.simpson3(ArgToFloat(Args[2]),ArgToFloat(Args[3]));
    ActualVariable.create(Result.ResFloat);
end;

constructor TIntegral.create();
begin
  Parse:=TParseMath.create();
  cArea:=false;
end;

function TIntegral.f(x: real): real;
begin
  Parse.NewValue(Parse.identifier[0].Name,x);
  f:=Parse.Evaluate();
  if(cArea) then
    f:=abs(f);
end;

//trap('power(x,2)','x',0,2)

function TIntegral.puntomedio(xleft: real; xright: real): real;
 var
  h: real;
  xk: real;
  k: integer;
  nf: real;
begin
  nf:= n;
  h:= (xright-xleft)/n ;
  xk:= xleft;
  puntomedio:=0;
  for k:=0 to n-1 do begin
    puntomedio:=puntomedio+h*f(xk+h/2);
    xk:=xk+h;
  end;
end;

function TIntegral.trapecio(xleft: real; xright: real): real;
var
  h: real;
  xk: real;
  k: integer;
  nf: real;
begin
  nf:= n;
  h:= (xright-xleft)/n ;
  xk:= xleft;
  trapecio:=f(xk);
  for k:=1 to n-1 do begin
    xk:=xk+h;
    trapecio:=trapecio+2*f(xk);
  end;
  xk:=xk+h;
  trapecio:=h/2*(trapecio+f(xk));
end;

//sim1('power(x,2)','x',0,2)

function TIntegral.simpson1(xleft: real; xright: real): real;
var
  h: real;
  xk: real;
  k: integer;
  nf: real;
begin
  nf:= n;
  h:= (xright-xleft)/n ;
  simpson1:=f(xleft);
  for k:=1 to round(n/2)-1 do begin
    simpson1:=simpson1+2*f(xleft+2*k*h);
    simpson1:=simpson1+4*f(xleft+(2*k-1)*h);
  end;
  simpson1:=simpson1+4*f(xleft+(n-1)*h);
  simpson1:=h/3*(simpson1+f(xright));
end;


function TIntegral.simpson1(): real;
var
  k: integer;
begin
  n:=points.fil-1;
  simpson1:=points.sub_list(0).get_val(1);
  for k:=1 to round(n/2)-1 do begin
    simpson1:=simpson1+2*points.sub_list(2*k).get_val(1);
    simpson1:=simpson1+4*points.sub_list(2*k-1).get_val(1);
  end;
  simpson1:=simpson1+4*points.sub_list(n-1).get_val(1);
  simpson1:=((points.sub_list(n).get_val(0)-points.sub_list(0).get_val(0))/n)/3*(simpson1+points.sub_list(n).get_val(1));
end;

function TIntegral.simpson3(xleft: real; xright: real): real;
var
  h: real;
  xk: real;
  k,n3: integer;
  nf: real;
begin
  nf:= n;
  if(n mod 3<>0) then
    n3:= n + 3-(n mod 3);
  h:= (xright-xleft)/(n3) ;
  simpson3:=f(xleft);
  k:=1;
  while(k<=n3-2) do begin
    simpson3:=simpson3+3*f(xleft+h*k);
    k+=3;
  end;
  k:=2;
  while(k<=n3-1) do begin
    simpson3:=simpson3+3*f(xleft+h*k);
    k+=3;
  end;
  k:=3;
  while(k<=n3-3) do begin
    simpson3:=simpson3+2*f(xleft+h*k);
    k+=3;
  end;
  simpson3:=h*3/8*(simpson3+f(xright));
end;

end.

