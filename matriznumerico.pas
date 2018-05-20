unit matrizNumerico;

{$mode objfpc}{$H+}



interface



uses
  Classes, SysUtils,matrizX,fpexprpars,math, variable, dialogs;

procedure multMatrices(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure sumMatrices(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure resMatrices(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure transMat(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure multrealmat(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
procedure getrow(var Result: TFPExpressionResult; Const Args: TExprParameterArray);

implementation

procedure multMatrices(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  A,B,C: TMatriz;
begin
    A:=TMatriz.create(Args[0].ResString);
    B:=TMatriz.create(Args[1].ResString);
    C:=multiplicacionmat(A,B);
    ActualVariable:=TVariable.create(C);
    Result.ResString:=C.contenido();
    Result.ResFloat:=NaN;
end;

procedure sumMatrices(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  A,B,C: TMatriz;
begin
    A:=TMatriz.create(Args[0].ResString);
    B:=TMatriz.create(Args[1].ResString);
    C:=sumarmat(A,B);
    ActualVariable:=TVariable.create(C);
    Result.ResString:=C.contenido();
    Result.ResFloat:=NaN;
end;

procedure resMatrices(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  A,B,C: TMatriz;
begin
    A:=TMatriz.create(Args[0].ResString);
    B:=TMatriz.create(Args[1].ResString);
    C:=restarmat(A,B);
    ActualVariable:=TVariable.create(C);
    Result.ResString:=C.contenido();
    Result.ResFloat:=NaN;
end;

procedure getRow(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  A,B,C: TMatriz;
begin
    A:=TMatriz.create(Args[0].ResString);
    C:=A.get_fil(Round(ArgToFloat(Args[1])));
    ActualVariable:=TVariable.create(C);
    Result.ResString:=C.contenido();
    Result.ResFloat:=NaN;
end;

procedure transMat(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  A,C: TMatriz;
begin
    A:=TMatriz.create(Args[0].ResString);
    C:=A.getTranspuesta();
    ActualVariable:=TVariable.create(C);
    Result.ResString:=C.contenido();
    Result.ResFloat:=NaN;
end;

procedure multrealmat(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  A,C: TMatriz;
  mult: real;
begin
    A:=TMatriz.create(Args[0].ResString);
    mult:= ArgToFloat(Args[1]);
    C:=multiplicacionmat(A,mult);
    ActualVariable:=TVariable.create(C);
    Result.ResString:=C.contenido();
    Result.ResFloat:=NaN;
end;


end.

