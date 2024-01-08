function [scodigos] = JJComprime_cv(imagen, CodeBook, fDist) ;
% Autor:   Dr. Juan Jose Aranda Aboy;        Prof. Titular UV
%          CHILE -- CUBA ;                   15 de Octubre de 2004
%
% Descripcion:
% Esta funcion Comprime por Cuantificacion de Vectores una imagen dados
% ella y el libro de codigo de 256 vectores generado por el
% Algoritmo de Cuantificacion de Vectores en la funcion JJgencodebook
%
% Parametros de Entrada:
%   imagen   - Matriz 2D de imagen que contiene los datos cuyo libro de codigos se
%              desea obtener. Debe ser tipo uint8
%   CodeBook - Vector con los 256 bloques correspondientes que forman el
%              libro de codigo. Tipo uint8.
%   fDist    - funcion que se utiliza para calcular la Distancia entre
%              bloques. OPCIONAL.
%              Si vale 1 - Minkowski
%              Si vale 2 - Euclideana (asumida!)
%
% Retorna:
%   codigos  - Matriz que indica el indice dentro del libro de codigo de cada sub-bloque en la imagen .
%
%disp("Inicia COM")
if nargin < 3
    fDist = 2 ;
end
[MaxFil,MaxCol] = size(imagen) ;
[MaxNiveles,blkfil,blkcol] = size(CodeBook) ;
NVectFil = round(MaxFil / blkfil) -1 ; %% Ojo! Verificar que numero de filas sea correcto
NVectCol = round(MaxCol / blkcol) ;
Actual = zeros(blkfil,blkcol) ;
codigos = zeros(NVectFil,NVectCol) ;
for i=1:1:NVectFil
    indfil = (i-1)*blkfil+1 ;
    finfil = indfil + blkfil -1 ;
    for j=1:1:NVectCol
        % Tomar el bloque correspondiente en la imagen
        indcol = (j-1)*blkcol+1 ;
        fincol = indcol + blkcol - 1;
        Actual = double( imagen( indfil:finfil, indcol:fincol ) ) ;
        % Asignar el vector actual al cluster donde tiene menor distancia
        Dist = Inf ;
        for k=1:1:MaxNiveles
            DistAux = norm( Actual - double( CodeBook(k) ), fDist ) ; %% fDist
            if DistAux < Dist
                lugar = k ;
                Dist = DistAux ;
            end
        end
        codigos(i,j) = lugar ;
    end
end
scodigos = uint8(codigos) ;
%disp("Fin COM")
return
