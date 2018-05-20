unit class_open;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, fpexprpars, variable;

type
  TOpen = class
    Error: Real;
    x: Real;
    h: real;
    OpenType, maxIteration: Integer;
    function execute: Real;

    private
      step: Integer;
      xn,
      xnant,
      ErrorCal: real;
      function equation(xx: real): real;
      function derivate(xx: real): real;
      function newt(): real;
      function seca(): real;

    public
      Lxn: TStringList;
      Parse1: TParseMath;
      Parse2: TParseMath;
      constructor create;
      destructor Destroy; override;

  end;

const
  F_NEW = 0;
  F_SEC = 1;

procedure newton(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure secante(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation


procedure newton(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Open: TOpen;
begin
   Open:=TOpen.create;
   Open.Parse1.Expression:=Args[0].ResString;
   Open.Parse1.AddVariable(Args[2].ResString,0);
   Open.Parse2.Expression:=Args[1].ResString;
   Open.Parse2.AddVariable(Args[2].ResString,0);
   Open.x:=ArgToFloat(Args[2]);
   Open.OpenType:=0;
   Result.resFloat := Open.execute;
   ActualVariable:=TVariable.create(Result.ResFloat);
end;

procedure secante(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Open: TOpen;
begin
   Open:=TOpen.create;
   Open.Parse1.Expression:=Args[0].ResString;
   Open.Parse1.AddVariable(Args[1].ResString,0);
   Open.x:=ArgToFloat(Args[2]);
   Open.OpenType:=1;
   Result.resFloat := Open.execute;
   ActualVariable:=TVariable.create(Result.ResFloat);
end;

constructor TOpen.create;
begin
  Parse1:= TParseMath.Create;
  Parse2:= TParseMath.Create;
  Lxn:= TStringList.Create;
  xn:= 0;
  xnant:= 0;
  step:= 0;
  OpenType:=0;
  Error:=0.0001;
  maxIteration:= 100000;
  ErrorCal:= 1000000;

end;

destructor TOpen.Destroy;
begin
   Lxn.Destroy;
end;

function TOpen.execute: Real;
begin
     case OpenType of
          F_NEW: Result:= newt();
          F_SEC: Result:= seca();

     end;
end;

function TOpen.equation(xx: Real): Real;
begin
  Parse1.NewValue('x',xx);
  Result:= Parse1.Evaluate();
end;

function TOpen.derivate(xx: Real): Real;
begin
  Parse2.NewValue('x',xx);
  Result:= Parse2.Evaluate();
end;

function TOpen.newt(): Real;
var StayInWhile: Boolean;
var deriv: real;
begin
  Lxn.Clear;
  step:= 0;
  xn:= x;
  ErrorCal:=2*Error;
  StayInWhile:= ( ErrorCal >= Error) and (step < MaxIteration);

  while StayInWhile do begin
      xnant:= xn;
      deriv:= derivate(xn);
      if(deriv=0) then begin
         xn:=xn+error;
         deriv:=derivate(xn);
      end;
      xn := xn - equation(xn) / deriv;
      Lxn.Add( FloatToStr( xn ) );
      ErrorCal:= abs( xn - xnant );
      step:= step + 1;
      StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
  end;
  Result:= xn;
end;

function TOpen.seca(): Real;
var StayInWhile: Boolean;
begin
  Lxn.Clear;
  step:= 0;
  h:=error/10;
  xn:=x;
  ErrorCal:=2*Error;
  StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
  while StayInWhile do begin
      xnant:= xn;
      xn := xn - 2*h*equation(xn) / (equation(xn+h)-equation(xn-h));
      Lxn.Add( FloatToStr( xn ) );
      ErrorCal:= abs( xn - xnant );
      step:= step + 1;
      StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
  end;
  Result:= xn;
end;

end.

