unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Menus, variable, ParseNumerico, matrizX;

type

  { TFrame3 }

  TFrame3 = class(TFrame)
    CmdBox1: TCmdBox;
    procedure CmdBox1Input(ACmdBox: TCmdBox; Input: string);
  private
    variable: TVariable;
    function isnewvariable(Input: string): boolean;
    function execute(expression: string): boolean;
    { private declarations }
  public
    Parse: TParseMath;
    pointsToPlot: TMatriz;
    procedure initCmd();
    { public declarations }
  end;

implementation

uses unit2, unit1;

{$R *.lfm}

function TFrame3.execute(expression: string): boolean;
begin
      Parse.Expression:=expression;
      parse.Evaluate();
      Result:=parse.exist;
end;

function TFrame3.isnewvariable(Input: string): boolean;
var equalindex: integer;
  newVarName: string;
begin
  result:=false;
  equalindex:=Input.IndexOf('=');
  if (equalindex>0) and (equalindex<Length(Input)-1) then begin
    variable := TVariable.create(Input.Substring(0,equalindex),Input.Substring(equalindex+1,Input.Length-equalindex));
    if (variable.validname()=false) then
      exit;
    newVarName:= variable.varname;
    if (variable.validvalue()=false) then begin
       if(execute(variable.varvalue)=false) then //si es expresion pero no es ejecutable
        ActualVariable:=TVariable.create(variable.varvalue);
    end else
       actualvariable:=variable;
    actualvariable.varname:=newvarname;
    //showmessage(inttostr(actualvariable.typevalue));showmessage(actualvariable.toString());
    Parse.AddVariable(actualvariable);
    result:=true;
    exit;
  end;
end;

procedure TFrame3.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
var
  out: string;
  isplot: boolean;
begin
  Input:=LowerCase(Input);
  Input:= Trim(Input);
  try
  case input of
    'clear': CmdBox1.Clear;
    'exit': Application.Terminate;
    'clearplots': TFrame1(Form1.CharFrame).clearGraphics;
    else begin
      if isnewvariable(Input) then begin
        if(parse.find(variable.varname)<>length(parse.variables)) then begin
          form1.ValueListEditor1.Values[actualvariable.varname]:=actualvariable.abrv();
        end else
         form1.ValueListEditor1.InsertRow(actualvariable.varname,actualvariable.abrv(),false);
      end else begin
        isplot:=false;
        if(Input.substring(0,4)='plot') or (Input.substring(0,4)='show') then begin
          isplot:=true;
          Input:=Input.Substring(4,length(Input)-4);
        end;
        if(execute(Input)) then begin
          if (isplot) then begin
          Form1.showchart();
          pointsToPlot:=TMatriz.create(parse.ResultParser.ResString);
          if(Input.substring(0,4)='func') then
            TFrame1(Form1.CharFrame).Graphic2D;
          if(Input.Substring(0,5)='inter') or (Input.Substring(0,6)='points') then
            TFrame1(Form1.CharFrame).Points2D;
        end else if (Parse.exist) then begin
          out:=parse.ResultParser.ResString;
          if(out='') then
            out:=floattostr(parse.ResultParser.ResFloat);
          cmdbox1.writeln(#27#179+out);
        end else begin
            cmdbox1.writeln(#27#179+'expression no valida');
        end;
        CmdBox1.ClearLine;
        end;
      end;
    end;
  end;
  initCmd();
  except
    initcmd();
  end;
end;

procedure TFrame3.initCmd();
begin
  CmdBox1.StartRead(clSilver,clNavy,'➳ ~ ',clYellow,clNavy);
end;

end.

