unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, TAGraph, TASeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Menus, ValEdit, ComCtrls, Jacobiana,
  matrizX, parsenumerico;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    CharFrame: TFrame;
    CmdFrame: TFrame;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ValueListEditor1: TValueListEditor;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure showChart();
    procedure minimizeChart();
    procedure resizeChart(i,j: real);
    procedure resizeXChart(i,j: real);
    procedure unresize();
    procedure unresize2();
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    panelh: Integer;
    { private declarations }
  public
    minY,maxY,minX,maxX: real;
    FunctionList: TList;
    InterSeries: TLineSeries;
    ActiveFunction: integer;
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  unit2, unit4;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
   ValueListEditor1.Clear;
   Panel4.Visible:=false;
   Splitter2.Visible:=false;
   Splitter2.Align:=alTop;
   Panel3.Align:=alClient;
   panelh:=250;
   CmdFrame := TFrame3.Create(Panel3);
   CmdFrame.Parent:=Panel3;
   TFrame3(CmdFrame).initCmd();
   TFrame3(CmdFrame).pointsToPlot:=TMatriz.create();
   TFrame3(CmdFrame).Parse:=TParseMath.create();
   CharFrame := TFrame1.Create(Panel4);
   CharFrame.Parent:= Panel4;
   FunctionList:=TList.Create;
   InterSeries:=TLineSeries.Create(TFrame1(CharFrame).Chart1);
   TFrame1(CharFrame).Chart1.AddSeries(InterSeries);
   ActiveFunction:=-1;
  minY:= -5.0;
  maxY:= 5.0;
  TFrame1(CharFrame).chart1.Extent.UseYMin:=false;
  TFrame1(CharFrame).chart1.Extent.UseYMax:=false;
  TFrame1(CharFrame).chart1.Extent.YMin:=minY;
  TFrame1(CharFrame).chart1.Extent.YMax:=maxY;
end;

procedure TForm1.showChart();
begin
   Panel3.Align:=alBottom;
   Panel3.Height:=panelh;
   Splitter2.Visible:=true;
   Splitter2.Align:=alBottom;
   Panel4.Visible:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   resizeXChart(StrToFloat(edit3.Caption),StrToFloat(edit4.Caption));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  unresize();
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  unresize2();
end;

procedure TForm1.resizeChart(i,j: real);
begin
    TFrame1(CharFrame).chart1.Extent.UseYMin:=true;
    TFrame1(CharFrame).chart1.Extent.UseYMax:=true;
    minY:=i;
    maxY:=j;
    TFrame1(CharFrame).chart1.Extent.YMin:=minY;
    TFrame1(CharFrame).chart1.Extent.YMax:=maxY;
end;

procedure TForm1.resizeXChart(i,j: real);
begin
    TFrame1(CharFrame).chart1.Extent.UseXMin:=true;
    TFrame1(CharFrame).chart1.Extent.UseXMax:=true;
    minX:=i;
    maxX:=j;
    TFrame1(CharFrame).chart1.Extent.XMin:=minX;
    TFrame1(CharFrame).chart1.Extent.XMax:=maxX;
end;

procedure TForm1.unresize();
begin
    TFrame1(CharFrame).chart1.Extent.UseXMin:=false;
    TFrame1(CharFrame).chart1.Extent.UseXMax:=false;
end;

procedure TForm1.unresize2();
begin
    TFrame1(CharFrame).chart1.Extent.UseYMin:=false;
    TFrame1(CharFrame).chart1.Extent.UseYMax:=false;
end;

procedure TForm1.minimizeChart();
begin
   Panel4.Visible:=false;
   Splitter2.Align:=alTop;
   Splitter2.Visible:=false;
   Panel3.Align:=alClient;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   resizeChart(StrToFloat(edit1.Caption),StrToFloat(edit2.Caption));
end;


end.
