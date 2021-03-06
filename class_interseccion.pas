unit class_interseccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath,fpexprpars, class_close, class_open, math, matrizfloat, matrizX, variable;

type
  TInter = class
    //Conf
    left, right: real;
    xleft, xright: real;
    error: real;
    derivate1: string;
    derivate2: string;
    result1, result2, x: real;
    //useClose: boolean;
    //useOpen: boolean;
    close_type, open_type: integer;
    max_it: integer;
    parse: TParseMath;
    isbolzan: boolean;
    function bolzano: boolean;
    function execute: Real;
    procedure setFunctions(function1: string; function2: string);
    procedure setDerivates(derivat1: string; derivat2: string);
    function getInterPoints(close_t,open_t:integer): TMFloat;
    public
      open_methods: TOpen;
      close_methods: TClose;
      constructor create;
      destructor Destroy; override;
    private
    Parse1: TParseMath;
      function getInter: Real;
  end;

//procedure interseccion(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

procedure intersec(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure intersecplus(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation

procedure intersec(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Inter: TInter;
  points: TMFloat;
begin
   Inter:=TInter.create;
   Inter.setFunctions(Args[0].ResString, Args[1].ResString);
   Inter.left:=ArgToFloat(Args[2]);
   Inter.right:=ArgToFloat(Args[3]);
   points:=Inter.getInterPoints(1,1);
   ActualVariable:=TVariable.create( TMatriz.create(points));
   Result.ResString:=points.contenido();
   Result.ResFloat:=NaN;//points.sub_list(points.fil-1).get_val(0);
end;

procedure intersecplus(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Inter: TInter;
  points: TMFloat;
begin
   Inter:=TInter.create;
   Inter.setFunctions(Args[0].ResString, Args[1].ResString);
   Inter.left:=ArgToFloat(Args[2]);
   Inter.right:=ArgToFloat(Args[3]);
   Inter.max_it:=Round(ArgToFloat(Args[4]));
   Inter.error:=ArgToFloat(Args[4]);
   points:=Inter.getInterPoints(1,1);
   ActualVariable:=TVariable.create( TMatriz.create(points));
   Result.ResString:=points.contenido();
   Result.ResFloat:=NaN;//points.sub_list(points.fil-1).get_val(0);
end;

constructor TInter.create;
begin
  //default configuration
  error:= 0.00000001;
  max_it:=10000;
  //useOpen:=true;
  close_type:=0;
  open_type:=1;
  Parse:= TParseMath.create();
  Parse1:= TParseMath.create();
  Parse.AddVariable('x',0);
  Parse1.AddVariable('x',0);
  open_methods:= TOpen.create;
  open_methods.Parse1.AddVariable('x',0);
  open_methods.Parse2.AddVariable('x',0);
  close_methods:= TClose.create;
  close_methods.Parse.AddVariable('x',0);
end;

procedure TInter.setFunctions(function1: string; function2: string);
begin
  Parse.Expression := function1 + '-(' + function2 + ')';
  Parse1.Expression:=function1;
  close_methods.Parse.Expression:=Parse.Expression;
  open_methods.Parse1.Expression:=Parse.Expression;
end;

procedure TInter.setDerivates(derivat1: string; derivat2: string);
begin
  open_methods.Parse2.Expression:=derivat1 + '-(' + derivat2 + ')';
end;

function TInter.getInterPoints(close_t, open_t: integer): TMFloat;
var inc,xl,xinter,yinter: real;
  points:TMFloat;
begin
  inc:=(right-left)/max_it;
  xl:=left;
  points:=TMFloat.create;

  repeat
       xleft:=xl;
       xl:=xl+inc;
       xright:=xl;
       xinter:=self.execute;
       self.Parse.NewValue('x',xinter);
       yinter:=self.parse.Evaluate();
       if ( (isNan(xinter)=false) and (xinter>xleft) and (xinter<=xright) and (isNaN(yinter)=false) ) and ( (abs(yinter)<=error) or (isbolzan)) then begin
         Parse1.NewValue('x',xinter);
         yinter:=Parse1.Evaluate();
         points.push_list('{'+floattostr(xinter)+';'+floattostr(yinter)+'}',false);
       end;
  until (( xleft>= right )) ;
  getInterPoints:=points;
end;

function TInter.bolzano: boolean;
begin
  Result:= false;
  Parse.NewValue('x', xleft);
  result1:=Parse.Evaluate();
  Parse.NewValue('x', xright);
  result2:=Parse.Evaluate();
  if (IsNan(result1)=false) and (IsNan(result2)=false) then begin
      if ((result1<0) and (result2>0)) or ((result1>0) and (result2<0)) then begin
         Result:=true;
      end;
  end;
end;

function TInter.getInter: Real;
begin
  if (bolzano) then begin//{SI CUMPLE BOLZANO *sin saber si es continuo*}
    close_methods.maxIteration:=max_it*10000;
    Result:=close_methods.execute;
    Parse.NewValue('x',Result);
    if(close_methods.isPoint=false) or (abs(parse.Evaluate()) > power(error,0.65)) then
      isbolzan := false;
  end else begin//{SI NO SE CUMPLE BOLZANO}
    isbolzan:=false;
    close_methods.maxIteration:=0;
    Result:=close_methods.execute;
    if (IsNan(result1)=false) and (IsNan(result2)=false) and (abs(result1)>error) then begin
      open_methods.x:=Result;
      open_methods.maxIteration:=sqr(max_it);
      Parse.NewValue('x',Result);
      if (Result>xleft) and (Result<xright) and (Parse.Evaluate()<power(error,0.65)) then begin
        open_methods.maxIteration:=max_it;
        Result:=open_methods.execute;
      end else begin
      end;
    end else begin
        Result:=NaN;
    end;
  end;
end;

function TInter.execute: Real;
begin
  isbolzan:=true;
  Parse.NewValue('x', xleft);
  result1:=Parse.Evaluate();
  Parse.NewValue('x', xright);
  result2:=Parse.Evaluate();
  if(abs(result2)<error) then begin//<]
    Result:=xright;
  end else begin
    if (IsNan(result1)) or (abs(result1)<error) then begin//<]
      xleft:=xleft+10*error;//+error/10;
    end;
    if(IsNan(result2)) then begin//<>
      xright:=xright-error;
    end;
    {INIT CLOSE METHODS}
    close_methods.xleft:=xleft;
    close_methods.xright:=xright;
    close_methods.CloseType:=close_type;
    close_methods.Error:=error;
    {INIT OPEN METHOS}
    open_methods.OpenType:=open_type;
    open_methods.Error:=error;
    Result:=getInter();
  end;
end;

destructor TInter.Destroy;
begin
   close_methods.Destroy;
   open_methods.Destroy;
end;
end.

