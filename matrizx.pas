unit matrizX;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpexprpars, matrizfloat,ListFloat,Grids,math,Dialogs;

type
    TMatriz = class
    private
      listaM: TMFloat;
    public
      ccol : Integer;
      cfil : Integer;
      constructor create;
      constructor create (mfloat: TMFloat);
      constructor create (content: string);
      procedure def_matriz(i:Integer;j:Integer);
      procedure salvar_matriz(grid : TStringGrid);
      procedure set_element(i: Integer;j:Integer ;val :float );
      function get_element(i:Integer;j:Integer):float;
      function getTranspuesta(): TMatriz;
      function get_fil(i: Integer): TMatriz;
      procedure rezise(jcol : Integer);
      procedure tomar_media_matriz();
      procedure redondear_vals(n_decim : Integer);
      procedure ident_matr(ij: Integer);
      procedure print_matriz(grid : TStringGrid);
      function multi_cruz(mat: TMatriz): float;
      function convColZero(mat : TMatriz; posPte:Integer; col: integer): TMatriz;
      function distancia(mat2:TMatriz):float;
      function o_determinante_BIG() : float;
      procedure inversamat();
      function contenido(): string;
end;

    function validmat(matrizstr: string): boolean;
    function restarmat(mat1, mat2 :TMatriz ):TMatriz ;
    function multiplicacionmat(mat1,mat2 :TMatriz):TMatriz;
    function multiplicacionmat(mat1 :TMatriz; mult: real):TMatriz;
    function sumarmat(mat1,mat2 :TMatriz ):TMatriz;

implementation

function validmat(matrizstr: string): boolean;
var
  mat: TMatriz;
begin
  validmat:=true;
  try
    mat:=TMatriz.create(matrizstr);
    mat.Destroy;
  except
    validmat:=false;
  end;
end;

function restarmat(mat1, mat2 :TMatriz ):TMatriz ;
var
   aux1, aux2 : Integer;
   mat_sum : TMatriz;
   sum :float;
begin
      mat_sum := TMatriz.create;

      mat_sum.def_matriz(mat1.cfil,mat1.ccol);


      if(mat1.cfil=mat2.cfil) and (mat1.ccol=mat2.ccol)then
      begin
         for aux1 :=0 to mat1.cfil-1 do
         begin
            for aux2 :=0 to mat1.ccol-1 do
            begin
               sum := mat1.get_element(aux1,aux2)-mat2.get_element(aux1,aux2);
               mat_sum.set_element(aux1,aux2,sum);
            end;
         end;
         restarmat := mat_sum;
      end
      else
      begin
        restarmat := mat_sum;
      end;
end;

function multiplicacionmat(mat1 :TMatriz; mult: real):TMatriz;
var
i,j : Integer;
mat_sum : TMatriz;
begin
      mat_sum:=mat1;
      for i:=0 to mat1.cfil-1 do begin
        for j:=0 to mat1.ccol-1 do begin
           mat_sum.set_element(i,j,mat_sum.get_element(i,j)*mult);
        end;
      end;
      result:=mat_sum;
end;

function multiplicacionmat(mat1,mat2 :TMatriz):TMatriz;
var
aux1, aux2, aux3, i1,j1,i2,j2 : Integer;
mat_sum : TMatriz;
sum : float;
begin
 i1 := mat1.cfil;
 j1 := mat1.ccol;
 i2 := mat2.cfil;
 j2 := mat2.ccol;

 mat_sum := TMatriz.create;
 mat_sum.def_matriz(i1,j2);

 if(j1 = i2)then
 begin
  for aux1 :=0 to j2-1 do
  begin
     for aux2 := 0 to i1-1 do
     begin
          sum := 0;
          for aux3 := 0 to i2-1 do
          begin
             sum := sum + mat1.get_element(aux2,aux3)*mat2.get_element(aux3,aux1);
          end;
          mat_sum.set_element(aux2,aux1,sum);

     end;
  end;
  multiplicacionmat:=mat_sum;

end else begin
   ShowMessage('No multiplicables, hint cambia de puntos iniciales');
   multiplicacionmat := mat_sum;
end;
end;

function sumarmat(mat1,mat2 :TMatriz ):TMatriz ;
var
aux1, aux2 : Integer;
mat_sum : TMatriz;
sum :float;

begin
 mat_sum := TMatriz.create;
 mat_sum.def_matriz(mat1.cfil,mat1.ccol);
 if(mat1.cfil=mat2.cfil) and (mat1.ccol=mat2.ccol)then
 begin
    for aux1 :=0 to mat1.cfil-1 do
    begin
       for aux2 :=0 to mat1.ccol-1 do
       begin
          sum := mat1.get_element(aux1,aux2)+mat2.get_element(aux1,aux2);
          mat_sum.set_element(aux1,aux2,sum);
       end;
    end;
    sumarmat := mat_sum;
 end
 else
 begin
   ShowMessage('las matrices no tienen el mismo orden');
   sumarmat := mat_sum;
 end;
end;

constructor TMatriz.create;
begin
    listaM :=TMFloat.Create;
    ccol:=0;
    cfil:=0;
end;

constructor TMatriz.create (mfloat: TMFloat);
begin
 listaM:=mfloat;
 ccol:=listaM.col;
 cfil:=listaM.fil;
end;

constructor TMatriz.create(content: string);
begin
    content:=Trim(content);
    listaM :=TMFloat.Create(content.Substring(1,length(content)-2));
    ccol:=listaM.col;
    cfil:=listaM.fil;
end;

procedure TMatriz.def_matriz(i:Integer;j:Integer);
var
  plist_fl :^ TLFloat;
  i1 , j1 :Integer;

begin
    new (plist_fl);

    ccol:=j;
    cfil:=i;

     for i1:=0 to i-1 do
     begin
        plist_fl^:=TLFloat.create;
       for j1:=0 to j-1 do
       begin
           plist_fl^.push_float(0);
       end;
       listaM.push_list(plist_fl^);
     end;
end;


procedure TMatriz.salvar_matriz(grid : TStringGrid);
var
  i1,j1,i,j :Integer;
  plist_fl :^ TLFloat;
begin

  new (plist_fl);
  i1 := grid.RowCount;
  j1 := grid.ColCount;

  cfil:=i1;
  ccol:=j1;

  for i:=0 to i1-1 do
  begin
    plist_fl^:=TLFloat.create;

    for j:=0 to j1-1 do
    begin
        plist_fl^.push_float(StrToFloat(grid.Cells[j,i]));
    end;

    listaM.push_list(plist_fl^);
  end;

end;


procedure TMatriz.set_element(i: Integer;j:Integer ;val :float );
begin
    listaM.sub_list(i).set_val(j,val);
end;


function TMatriz.getTranspuesta(): TMatriz;
var
  i,j: integer;
  aux: TMatriz;
begin
 aux:=TMatriz.create();
 aux.def_matriz(ccol, cfil);
   for i:=0 to cfil-1 do begin
     for j:=0 to ccol-1 do begin
       aux.set_element(j,i,get_element(i,j));
     end;
   end;
   getTranspuesta:=aux;
end;

function TMatriz.get_element(i:Integer;j:Integer):Float;
begin
    if (i<cfil) and (j<ccol)then
        get_element:=listaM.sub_list(i).get_val(j)
    else
      begin
           get_element := -1;
      end;

end;

function TMatriz.get_fil(i: Integer): TMatriz;
var
  LFloat: TLFloat;
  aux: TMatriz;
begin
 LFloat:=listaM.sub_list(i);
 aux:= TMatriz.create();
 aux.ccol:=LFloat.Count;
 aux.cfil:=1;
 aux.listaM.push_list(LFloat);
 get_fil:=aux;
end;

procedure TMatriz.rezise(jcol : Integer);
var
  i,j, i1,j1 :Integer;
begin
  i := cfil;
  ccol := ccol+jcol;


  for i1 := 0 to i-1 do
  begin
    for j:=0 to jcol-1 do
    begin
      if i1 = j then
          listaM.sub_list(i1).push_float(1)
      else
          listaM.sub_list(i1).push_float(0);
    end;
  end;

end;

procedure TMatriz.tomar_media_matriz();
var
  i1,j1 : Integer;
  mat_aux :TMatriz;
begin
  mat_aux := TMatriz.create;

  for i1:=0 to cfil-1 do
  begin
    for j1:=0 to (ccol shr 1)-1 do
    begin
       listaM.sub_list(i1).remove_float(0);
    end;
  end;
  ccol:= (ccol shr 1);
end;


procedure TMatriz.redondear_vals(n_decim : Integer);
var
  i , j : Integer;
begin
  for i := 0 to cfil -1 do
  begin
    for j := 0 to ccol-1 do
    begin
      set_element(i,j,RoundTo(get_element(i,j),-n_decim));
    end;
  end;
end;

procedure TMatriz.ident_matr(ij: Integer);
var
  plist_fl :^ TLFloat;
  i1 , j1 :Integer;

begin
    new (plist_fl);

    ccol:=ij;
    cfil:=ij;

     for j1:=0 to ij-1 do
     begin
        plist_fl^:=TLFloat.create;
       for i1:=0 to ij-1 do
       begin
           if i1=j1 then
           begin
             plist_fl^.push_float(1);
           end
           else
           begin
               plist_fl^.push_float(0);
           end;
       end;
       listaM.push_list(plist_fl^);
     end;
end;

procedure TMatriz.print_matriz(grid : TStringGrid);
var
  i1,j1 : Integer;
begin
   grid.Clean;
   grid.ColCount:=ccol;
   grid.RowCount:=cfil;

   for i1 := 0 to cfil-1 do
   begin
     for j1:=0 to ccol-1 do
     begin
       grid.Cells[j1,i1]:=FloatToStr(listaM.sub_list(i1).get_val(j1));
     end;
   end;
end;


function TMatriz.multi_cruz(mat: TMatriz): float;
var
  mul_cruz :float;
begin
   if(mat.ccol=2) and (mat.cfil=2)then
   begin
       mul_cruz :=  mat.listaM.sub_list(0).get_val(0)*mat.listaM.sub_list(1).get_val(1);
       mul_cruz :=  mul_cruz - mat.listaM.sub_list(1).get_val(0)*mat.listaM.sub_list(0).get_val(1);
       multi_cruz := mul_cruz;
   end
   else
   begin
     multi_cruz := -1;
   end;
end;

function TMatriz.contenido(): string;
begin
   listaM.col:=ccol;
   listaM.fil:=cfil;
    contenido:= Self.listaM.contenido();
end;

function TMatriz.convColZero(mat:TMatriz; posPte:Integer; col: integer): TMatriz;
var
  i,j: integer;
begin
     for i:=0 to mat.cfil-1 do
     begin
          if (i <> posPte) then
          begin
             mat.listaM.sub_list(i).set_val(col,0);
          end;
     convColZero:=mat;
     end;

end;

function TMatriz.distancia(mat2:TMatriz):float;
var
  res:float;
  i:Integer;
begin
  res:=0;
  for i:=0 to self.cfil-1 do
  begin
    res:=res+power(self.get_element(i,0)-mat2.get_element(i,0),2)
  end;
  distancia:=power(res,0.5);
end;

function TMatriz.o_determinante_BIG() : float;
var
  max , i, j, n : Integer;
  det_answ : float;
  matB : TMatriz;
begin

   max := self.ccol;
   matB := TMatriz.create;


   if max=2 then
   begin
      o_determinante_BIG:=self.get_element(0,0)*self.get_element(1,1)-self.get_element(0,1)*self.get_element(1,0);
   end
   else
   begin
       det_answ:=0;

       for n:=0 to max-1 do
       begin

           matB.def_matriz(max-1,max-1);
           for i:=1 to max-1 do
           begin

               for j:=0 to n-1 do
                   matB.set_element(i-1,j,self.get_element(i,j));
               for j:=n+1 to max-1 do
                   matB.set_element(i-1,j-1,self.get_element(i,j));

           end;

           if (n+2) mod 2 = 0 then
              i:=1
           else
              i := -1;
           det_answ := det_answ + i * self.get_element(0,n) * matB.o_determinante_BIG;
       end;
       o_determinante_BIG := det_answ;

   end;
end;

procedure TMatriz.inversamat();
  const
    error=0.00000001;
  var
    paso,c1,c2: Integer;
    PivCorrect: Boolean;
    pivote,aux: float;
    det: Boolean;
  begin
    self.rezise(self.ccol);

    for paso:=0 to (self.ccol shr 1 -1) do begin
      PivCorrect := False;
      c1:= paso;
      while (not PivCorrect) and (c1< self.ccol shr 1 ) do
        If abs(self.get_element(c1,paso))>error then
          PivCorrect:=true
        else
          c1:=c1+1;
      If PivCorrect then begin
        pivote:=self.get_element(c1,paso);
        for c2:=paso to ((self.ccol)-1) do
          if c1<>paso then begin
            aux:=self.get_element(paso,c2);
            self.set_element(paso,c2, self.get_element(c1,c2)/pivote );
            self.set_element(c1,c2,aux)
          end else
            self.set_element(c1,c2,self.get_element(c1,c2)/pivote);
      end;
     for c1:=(paso+1) to (self.ccol  shr 1 - 1) do begin
       aux:=self.get_element(c1,paso);
       for c2:=paso to ((self.ccol)-1) do
         self.set_element(c1,c2,self.get_element(c1,c2)-aux*self.get_element(paso,c2) )
     end;
    end;

    det:=true;
    for c1:=0 to (self.ccol shr 1 -1) do
      if abs( self.get_element(c1,c1) )<error then
        det:=false;


    if det then begin
      for paso:=(self.ccol shr 1 -1 ) downto 0 do begin
        pivote:=self.get_element(paso,paso);
        self.set_element(paso,paso,1);
        for c2:=(self.ccol shr 1 ) to (self.ccol-1) do
          self.set_element(paso,c2, self.get_element(paso,c2)/pivote );
        for c1:=(paso-1) downto 0 do begin
          aux:=self.get_element(c1,paso);
          for c2:=paso to (self.ccol-1) do
            self.set_element(c1,c2, self.get_element(c1,c2)-self.get_element(paso,c2)*aux )
        end
      end;
      self.tomar_media_matriz();
    end;
end;

end.

