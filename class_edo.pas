unit class_edo;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fpexprpars,
    FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
    ComCtrls, Spin, StdCtrls, Types, math,
    matrizX, matrizfloat, listfloat, ParseMath, variable;

type
  TEdo=class
    n: integer;
    h: real;
    private
      A, c, by, bz: TMatriz;
    public
      Parse: TParseMath;
      points: TMatriz;
      function fd(x:real; y:real): real;
      function euler(fin:real; x0: real; y0: real): real;
      function heun(fin:real; x0: real; y0: real): real;
      function runge4(fin:real; x0: real; y0: real): real;
      function dormand(fin:real; x0:real; y0: real): real;
      constructor create();
  end;


  procedure euler(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  procedure heun(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  procedure runge4(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  procedure dormand(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  procedure dormand2(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation

procedure euler(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Edo: TEdo;
begin
    Edo:=TEdo.create();
    Edo.Parse.Expression:=(Args[0].ResString);
    Edo.Parse.AddVariable(Args[1].ResString,0);
    Edo.Parse.AddVariable(Args[2].ResString,0);
    Edo.n:=3;
    Edo.euler(ArgToFloat(Args[5]),ArgToFloat(Args[3]),ArgToFloat(Args[4]));
    ActualVariable:=TVariable.create(Edo.points);
    Result.ResString:=Edo.points.contenido();
    Result.ResFloat:=NaN;//
end;

procedure heun(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Edo: TEdo;
begin
    Edo:=TEdo.create();
    Edo.Parse.Expression:=(Args[0].ResString);
    Edo.Parse.AddVariable(Args[1].ResString,0);
    Edo.Parse.AddVariable(Args[2].ResString,0);
    Edo.n:=1000;
    Edo.heun(ArgToFloat(Args[5]),ArgToFloat(Args[3]),ArgToFloat(Args[4]));
    ActualVariable:=TVariable.create(Edo.points);
    Result.ResString:=Edo.points.contenido();
    Result.ResFloat:=NaN;//
end;

procedure runge4(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Edo: TEdo;
begin
    Edo:=TEdo.create();
    Edo.Parse.Expression:=(Args[0].ResString);
    Edo.Parse.AddVariable(Args[1].ResString,0);
    Edo.Parse.AddVariable(Args[2].ResString,0);
    Edo.n:=1000;
    Edo.runge4(ArgToFloat(Args[5]),ArgToFloat(Args[3]),ArgToFloat(Args[4]));
    ActualVariable:=TVariable.create(Edo.points);
    Result.ResString:=Edo.points.contenido();
    Result.ResFloat:=NaN;//
end;

procedure dormand(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Edo: TEdo;
begin
    Edo:=TEdo.create();
    Edo.Parse.Expression:=(Args[0].ResString);
    Edo.Parse.AddVariable(Args[1].ResString,0);
    Edo.Parse.AddVariable(Args[2].ResString,0);
    Edo.n:=10000;
    Edo.dormand(ArgToFloat(Args[5]),ArgToFloat(Args[3]),ArgToFloat(Args[4]));
    ActualVariable:=TVariable.create(Edo.points);
    Result.ResString:=Edo.points.contenido();
    Result.ResFloat:=NaN;//
end;

procedure dormand2(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Edo: TEdo;
begin
    Edo:=TEdo.create();
    Edo.Parse.Expression:=(Args[0].ResString);
    Edo.Parse.AddVariable('x',0);
    Edo.Parse.AddVariable('y',0);
    Edo.n:=1000;
    Edo.dormand(ArgToFloat(Args[3]),ArgToFloat(Args[1]),ArgToFloat(Args[2]));
    ActualVariable:=TVariable.create(Edo.points);
    Result.ResString:=Edo.points.contenido();
    Result.ResFloat:=NaN;//
end;

constructor TEdo.create();
begin
  Parse:=TParseMath.create();
  points:=TMatriz.create();
  A:=TMatriz.create('[{0;0;0;0;0;0;0}'+
                      '{1;0;0;0;0;0;0}' +
                      '{'+floattostr(1/4)+';'+floattostr(3/4)+';0;0;0;0;0}'+
                      '{'+floattostr(11/9)+';'+floattostr(-14/3)+';'+floattostr(40/9)+';0;0;0;0}'+
                      '{'+floattostr(4843/1458)+';'+floattostr(-3170/243)+';'+floattostr(8056/729)+';'+floattostr(-53/162)+';0;0;0}'+
                      '{'+floattostr(9017/3168)+';'+floattostr(-355/33)+';'+floattostr(46732/5247)+';'+floattostr(49/176)+';'+floattostr(-5103/18656)+';0;0}'+
                      '{'+floattostr(35/384)+';0;'+floattostr(500/1113)+';'+floattostr(125/192)+';'+floattostr(-2187/6784)+';'+floattostr(11/84)+';0}]');
  by:= TMatriz.create('[{'+floattostr(5179/57600)+';0;'+floattostr(7571/16695)+';'+floattostr(393/640)+';'+floattostr(-92097/339200)+';'+floattostr(187/2100)+';'+floattostr(1/40)+'}]');
  bz:= TMatriz.create('[{'+floattostr(35/384)+';0;'+floattostr(500/1113)+';'+floattostr(125/192)+';'+floattostr(-2187/6784)+';'+floattostr(11/84)+';0}]');
  c:= TMatriz.create('[{0;'+floattostr(1/5)+';'+floattostr(3/10)+';'+floattostr(4/5)+';'+floattostr(8/9)+';1;1}]');
end;

function TEdo.fd(x:real; y:real): real;
begin
  Parse.NewValue(Parse.identifier[0].Name,x);
  Parse.NewValue(Parse.identifier[1].Name,y);
  fd:=Parse.Evaluate();
end;

function TEdo.euler(fin: real; x0: real; y0: real): real;
var
  i : integer;
  x,y: real;
begin
  points.def_matriz(n+1,2);
  h:= (fin-x0)/n;
  x:=x0;
  y:=y0;
  points.set_element(0,0,x);
  points.set_element(0,1,y);
  for i:=1 to n do begin
     y:=y+h*fd(x,y);
     x:=x+h;
     points.set_element(i,0,x);
     points.set_element(i,1,y);
  end;
  euler:=y;
end;

function TEdo.heun(fin: real; x0: real; y0: real): real;
var
  i : integer;
  x,y: real;
begin
  points.def_matriz(n+1,2);
  h:= (fin-x0)/n;
  x:=x0;
  y:=y0;
  points.set_element(0,0,x);
  points.set_element(0,1,y);
  for i:=1 to n do begin
     y:=y+h*0.5*(fd(x,y)+fd(x+h,y+h*fd(x,h)));
     x:=x+h;
     points.set_element(i,0,x);
     points.set_element(i,1,y);
  end;
  heun:=y;
end;

function TEdo.runge4(fin: real; x0: real; y0: real): real;
var
  i : integer;
  x,y: real;
  k1,k2,k3,k4: real;
begin
  points.def_matriz(n+1,2);
  h:= (fin-x0)/n;
  x:=x0;
  y:=y0;
  points.set_element(0,0,x);
  points.set_element(0,1,y);
  for i:=1 to n do begin
     k1:=fd(x,y);
     k2:=fd(x+h/2,y+k1*h/2);
     k3:=fd(x+h/2,y+k2*h/2);
     k4:=fd(x+h,y+k3*h);
     y:=y+h*(k1+2*(k2+k3)+k4)/6;
     x:=x+h;
     points.set_element(i,0,x);
     points.set_element(i,1,y);
  end;
  runge4:=y;
end;

function TEdo.dormand(fin: real; x0: real; y0: real): real;
var
  x,y,y_temp,z_temp,s,eps: real;
    k,aux: tmatriz;
    i: integer;
    pointL: TLFloat;
    pointsM: TMFloat;
begin
  pointL:=TLFloat.create();
  pointsM:=TMFloat.create();
  eps:=0.00001;
  h:=(fin-x0)/n;
  x:=x0;
  y:=y0;
  pointL.push_float(x);
  pointL.push_float(y);
  pointsM.push_list(pointL.contenido(),false);
  while(x<fin) do begin
    k:= TMatriz.create('[{0;0;0;0;0;0;0}]');
    for i:=0 to 6 do begin
       aux:=multiplicacionmat(k,A.get_fil(i).getTranspuesta());
       k.set_element(0,i,fd(x+h*c.get_element(0,i),y+h*c.get_element(0,i)*aux.get_element(0,0)));
    end;
    aux:=multiplicacionmat(k,by.getTranspuesta());
    y_temp:=y+h*aux.get_element(0,0);
    aux:=multiplicacionmat(k,bz.getTranspuesta());
    z_temp:=y+h*aux.get_element(0,0);
    s:=power(h*eps/(2*(fin-x0)*abs(y_temp-z_temp)), 0.25);
    if(s>=2) then begin
            y:=y_temp;
      x:=x+h;
      h:=h*2;
      pointL.set_val(0,x);
      pointL.set_val(1,y);
      pointsM.push_list(pointL.contenido(),false);
    end else if (s>=1) then begin
      y:=y_temp;
      x:=x+h;
      pointL.set_val(0,x);
      pointL.set_val(1,y);
      pointsM.push_list(pointL.contenido(),false);
    end else
      h:=h/2;
  end;
  points:=TMatriz.create(pointsM.contenido());
  dormand:=y;
end;

end.
