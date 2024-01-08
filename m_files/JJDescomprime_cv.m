function [imacod] = JJDescomprime_cv(codigos, CodeBook) ;
% Autor:   Dr. Juan Jose Aranda Aboy;        Prof. Titular UV
%          CHILE -- CUBA ;                   15 de Octubre de 2004
%
% Descripcion:
% Esta funcion muestra la imagen comprimida por Cuantificacion de Vectores dados:
% 1) los indices de cada posicion generados por la funcion JJComprime-cv y
% 2) el libro de codigo de 256 vectores generado por el Algoritmo
%    de Cuantificacion de Vectores en la funcion JJgencodebook
%
% Parametros de Entrada:
%   codigos  - Matriz que indica el indice dentro del libro de codigo de cada sub-bloque en la imagen  .
%   CodeBook - Vector con los 256 bloques correspondientes que forman el
%              libro de codigo. Tipo uint8.
%
% Retorna:
%   imacod   - Imagen comprimida. Es de Tipo uint8!!!
%
%disp("Inicia DEC")
[MaxNiveles,blkfil,blkcol] = size(CodeBook) ;
[NVectFil,NVectCol] = size(codigos) ;
imacod = uint8( zeros( NVectFil*blkfil, NVectCol*blkcol) ) ;
for i=1:1:NVectFil
    indfil = (i-1)*blkfil ;
    for j=1:1:NVectCol
        cual = codigos(i,j) ;
        indcol = (j-1)*blkcol ;
        for i1=1:1:blkfil
            for j1=1:1:blkcol
                imacod( indfil+i1, indcol+j1 ) =  CodeBook(cual, i1, j1 ) ;
            end
        end
    end
end
%disp("Fin DEC")
return
