unit class_prediccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, math, fpexprpars, Dialogs,  ExtCtrls,LCLType, ucmdbox, StdCtrls,
  class_regresion,class_lag, matrizX, ParseMath,variable;

type
  TPrediccion = Class
      data: TMatriz;
      extra: TRegresion;
      intra: TLag;
      private
      public
          aproxfunc: string;
          R: real;
          function getAproxFunc(): string;
          procedure setdata(dataM: TMatriz);
          function execute(x: real): real;
          constructor create();
  end;

procedure aproxFunc(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation
{
x=pointsfile('exp.csv')
aproxfunc(x)
}
procedure aproxFunc(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  Predic:TPrediccion;
begin
  Predic:=TPrediccion.create();
  Predic.setData(TMatriz.create(Args[0].resString));
  ActualVariable:=TVariable.create(Predic.aproxfunc);
  Result.ResString:=''''+Predic.aproxfunc+'''';
  showmessage('Mejor prescision: ' +floattostr(predic.R));
  Result.ResFloat:=NaN;
end;

constructor TPrediccion.create();
begin
  data:=TMatriz.create();
  extra:=TRegresion.create;
  intra:=TLag.Create;
end;

function TPrediccion.getAproxFunc(): string;
var
funcl,funcexp,funcln, fexpr: string;
rl,rexp,rln: real;
begin
    funcl:=extra.lineal();
       rl:=extra.R;
       funcexp:=extra.nolinealexp();
       rexp:=extra.R;
       funcln:=extra.nolinealln();
       rln:=extra.R;
       if(rl>rexp) then begin
         fexpr:=funcl;
         r:=rl;
         if(rln>rl) then begin
           fexpr:=funcln;
           r:=rexp;
         end;
       end else begin
         fexpr:=funcexp;
         r:=rl;
         if(rln>rexp) then begin
           fexpr:=funcln;
           r:=rln;
         end;
       end;
       result:= fexpr;
end;

procedure TPrediccion.setdata(dataM: TMatriz);
var i: integer;

begin
  data:=dataM;
  for i:=0 to data.cfil-1 do begin
      intra.insert(data.get_element(i,0),data.get_element(i,1));
  end;
  extra.data:=data;
  aproxfunc:=getAproxFunc();
end;

function TPrediccion.execute(x: real): real;
var
  Parse: TParseMath;
begin
   if (x>=intra.DatX[0]) and (x<=intra.DatX[length(intra.DatX)-1]) then begin
     result:=intra.interPolar(x);
     exit;
   end;
   Parse:=TParseMath.create();
   Parse.AddVariable('x',x);
       Parse.Expression:=aproxfunc;
     result:=Parse.Evaluate();
end;

end.

