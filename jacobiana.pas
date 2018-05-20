unit Jacobiana;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath,Dialogs, matrizX, math, Grids,sPila;
type
   TJacobiana = Class

  Private
      Mat_var : TSPila;
      Mat_func : TSPila;
      Mat_val : TMatriz;
      fil_col :Integer;

      function derivadaParcial(fun:TParseMath;x:string;valor:float): float;

  Public
      function Evaluate(): TMatriz;
      constructor create(grid1 :TSPila ;grid2 :TSPila; grid3 :TSPila ;n:integer);
      destructor destroy;

  end;



implementation

constructor TJacobiana.create(grid1 :TSPila ;grid2 :TSPila; grid3 :TSPila ;n:integer);
var
  i1 : Integer;
begin

   Mat_var := TSPila.create;
   Mat_func := TSPila.create;
   Mat_val := TMatriz.create;
   fil_col := n;
   Mat_var:=grid1;
   Mat_func:=grid2;
   Mat_val.def_matriz(n,1);
   for i1:=0 to n-1 do
   begin
     Mat_val.set_element(i1,0,StrToFloat(grid3.get(i1)));
   end;
end;


destructor TJacobiana.destroy;
begin
end;

function TJacobiana.Evaluate(): TMatriz;
var
  m_function:TParseMath;
  aux_mat:TMatriz;
  i,j:integer;
begin
  aux_mat:= TMatriz.create;
  m_function:=TParseMath.create();
  for i:=0 to fil_col-1  do
      begin
        m_function.AddVariable(Mat_var.get(i),Mat_val.get_element(i,0));
      end;
  aux_mat.def_matriz(fil_col,fil_col);
  for i:=0 to fil_col-1  do
      begin
        m_function.Expression:= Mat_func.get(i);
        for j:=0 to fil_col-1  do
          begin
            aux_mat.set_element(i,j,derivadaParcial(m_function,Mat_var.get(j),Mat_val.get_element(j,0)));
          end;
      end;
  Evaluate:=aux_mat;
end;

function TJacobiana.derivadaParcial(fun:TParseMath;x:string;valor:float): float;
var
  h,a,b,v:real;
  funaux:TParseMath;
begin
  h:=0.0001;
  v:=valor;
  funaux:=fun;
  funaux.NewValue(x,v);
  b:=funaux.Evaluate();
  funaux.NewValue(x,v+h);
  a:=funaux.Evaluate();
  derivadaParcial:=(a-b)/h;
end;


end.

