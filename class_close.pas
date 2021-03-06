unit class_close;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, fpexprpars, variable;



type
  TClose = class
    Error: Real;
    xleft: real;
    xright: real;
    MaxIteration: integer;
    CloseType: Integer;
    ErrorCal: real;
    isPoint: boolean;
    function execute: Real;
    private
      xn, xnant: real;
      step: Integer;
      function equation(xx: real): real;
      function biseccion(xl: real; xr: real): real;
      function falsaposicion(xl: real; xr: real): real;

      function factorial(m: Integer): Integer;
      function exponential(xx: real; m: Integer): real;

    public
      Lxn: TStringList;
      Lxl: TStringList;
      Lxr: TStringList;
      Lxsig: TStringList;
      Parse: TParseMath;
      constructor create;
      destructor Destroy; override;

  end;

const
  F_BIS = 0;
  F_FAL = 1;

procedure biseccion(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure falsaPosicion(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation

procedure biseccion(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Close: TClose;
begin
   Close:=TClose.create;
   Close.Parse.Expression:=Args[0].ResString;
   Close.Parse.AddVariable(Args[1].ResString,0);
   Close.xleft:=ArgToFloat(Args[2]);
   Close.xright:=ArgToFloat(Args[3]);
   Close.CloseType:=0;
   Result.resFloat := Close.execute;
   ActualVariable:=TVariable.create(Result.ResFloat);
end;

procedure falsaPosicion(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Close: TClose;
begin
   Close:=TClose.create;
   Close.Parse.Expression:=Args[0].ResString;
   Close.Parse.AddVariable(Args[1].ResString,0);
   Close.xleft:=ArgToFloat(Args[2]);
   Close.xright:=ArgToFloat(Args[3]);
   Close.CloseType:=1;
   Result.resFloat := Close.execute;
   ActualVariable:=TVariable.create(Result.ResFloat);
end;

constructor TClose.create;
begin
  Parse:= TParseMath.Create;
  Lxn:= TStringList.Create;
  Lxl:= TStringList.Create;
  Lxr:= TStringList.Create;
  Lxsig:= TStringList.Create;
  xn:= 0;
  xnant:= 0;
  step:= 0;
  Error:=0.0001;
  CloseType := 0;
  MaxIteration:= 1000000;
  ErrorCal:= 1000000;
end;

destructor TClose.Destroy;
begin
   Lxn.Destroy;
end;

function TClose.execute: Real;
begin
     case CloseType of
          F_BIS: Result:= biseccion(xleft,xright);
          F_FAL: Result:= falsaposicion(xleft,xright);

     end;
end;

function TClose.factorial(m: Integer): Integer;
begin
   if ( m < 2 ) then begin
     Result:= 1;
     exit;

   end;

   Result:= m * factorial( m - 1 );

end;

function TClose.exponential(xx: real; m: Integer): real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to m do
      Result:= Result * xx;

end;

function TClose.equation(xx: Real): Real;
begin
  Parse.NewValue('x',xx);
  Result:= Parse.Evaluate();
end;

function TClose.biseccion(xl: Real; xr: Real): Real;
var StayInWhile: Boolean;
var dif, xm: Real;
var lisneg: Boolean;
begin
  isPoint:=true;
  Lxn.Clear;
  Lxl.Clear;
  Lxr.Clear;
  Lxn.Add( '-' );
  Lxl.Add( '-' );
  Lxr.Add( '-' );
  Lxsig.Add( '-' );
  step:= 0;
  xm:=100000000;
  ErrorCal:=2*Error;
  dif:=abs(equation(xl)-equation(xr));
  lisneg := false;
  if ( equation(xl) < 0 ) then
  begin
      lisneg := true;
  end;
  StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);

  while StayInWhile do begin
      xnant:= xm;
      xm := (xl+xr) / 2;
      xn := equation(xm);
      Lxn.Add( FloatToStr( xm ) );
      Lxl.Add( FloatToStr(xl));
      Lxr.Add( FloatToStr(xr));
      ErrorCal:= abs( xm - xnant ) ;
      step:= step + 1;
      if (xn<0) then
      begin
          Lxsig.Add('-');
          if (lisneg) then
               xl:=xm
          else
               xr:=xm;
      end
      else
      begin
          Lxsig.Add('+');
          if (lisneg) then
               xr:=xm
          else
               xl:=xm;
      end;
      StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
  end;
  Result:= xm;
  if(MaxIteration=0) then begin
    Result:= (xl+xr)/2;
  end else begin
    if (abs(equation(xl)-equation(xr))>dif) then begin
      isPoint:=false;
      //Result:= NaN;
    end;

  end;
end;

function TClose.falsaposicion(xl: Real; xr: Real): Real;
var StayInWhile: Boolean;
var dif, xm: Real;
var lisneg: Boolean;
var yant: real;
begin
  isPoint:=true;
  Lxn.Clear;
  Lxl.Clear;
  Lxr.Clear;
  Lxn.Add( '-' );
  Lxl.Add( '-' );
  Lxr.Add( '-' );
  Lxsig.Add( '-' );
  step:= 0;
  xm:=100000000;
  ErrorCal:=2*Error;
  dif:=abs(equation(xl)-equation(xr));
  lisneg := false;
  if ( equation(xl) < 0 ) then
  begin
      lisneg := true;
  end;
  StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);

  while StayInWhile do begin
      xnant:= xm;
      xm := xl-(equation(xl)*(xr-xl))/(equation(xr)-equation(xl));
      yant := xn;
      xn := equation(xm);
      Lxn.Add( FloatToStr( xm ) );Lxl.Add( FloatToStr(xl));Lxr.Add( FloatToStr(xr));
      ErrorCal:= abs(xm - xnant);
      step:= step + 1;
      if (xn<0) then begin
          Lxsig.Add('-');
          if (lisneg) then
               xl:=xm
          else
               xr:=xm;
      end else begin
          Lxsig.Add('+');
          if (lisneg) then
               xr:=xm
          else
               xl:=xm;
      end;
      StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
  end;
  Result:= xm;
  if(MaxIteration=0) then begin
    Result:= (xl+xr)/2;
  end else begin
    if (abs(equation(xl)-equation(xr))>dif) then begin
      isPoint:=false;
      //Result:= NaN;
    end;
  end;

end;

end.

