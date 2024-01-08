function [sCodeBook,d_1] = JJgencodebook(imagen, MaxNiveles, blkfil, blkcol, fDist ) ;
%
% Autor:   Dr. Juan Jose Aranda Aboy;        Prof. Titular UV
%          CHILE -- CUBA ;                   5 de Octubre de 2004
%
% Descripcion:
% Esta funcion genera un libro de codigo de 256 vectores por el
% Algoritmo de Cuantificacion de Vectores de Gray, Linde y Buzo
% para una imagen
%
% Parametros de Entrada:
%   imagen - Matriz 2D de imagen que contiene los datos cuyo libro de codigos se
%            desea obtener. Debe ser tipo uint8
%   MaxNiveles - Total de elementos deseados en el libro de codigo. Entero.
%   blkfil - filas de cada bloque. Entero.
%   blkcol - columnas de cada bloque. Entero.
%   fDist    - funcion que se utiliza para calcular la Distancia entre
%              bloques. OPCIONAL.
%              Si vale 1 - Minkowski
%              Si vale 2 - Euclideana (asumida!)
%
% Retorna:
%   CodeBook    - Vector con los 256 bloques correspondientes que forman el
%                 libro de codigo. Tipo uint8.
%   d_1         - Distorsion calculada. Tipo Double.
%
%disp("Inicia GEN")
if nargin < 5
    fDist = 2 ;
end
[MaxFil,MaxCol] = size(imagen) ;
NVectFil = MaxFil / blkfil ;
NVectCol = MaxCol / blkcol ;
Actual = zeros(blkfil,blkcol) ;
NivAux = zeros(blkfil,blkcol) ;
minimos = zeros(blkfil,blkcol) ;
maximos = 255.*ones(blkfil,blkcol) ;
CodeBook = zeros(MaxNiveles,blkfil,blkcol) ;  %% inicia el libro en 0
% Obtener Centroide de toda la imagen
% Hallar promedio de todos los bloques
for i=1:1:NVectFil
    indfil = (i-1)*blkfil+1 ;
    finfil = indfil + blkfil -1 ;
    for j=1:1:NVectCol
        indcol = (j-1)*blkcol+1 ;
        fincol = indcol + blkcol - 1;
        Actual = Actual + double( imagen( indfil:finfil, indcol:fincol ) ) ;
    end
end
Actual = Actual ./  (NVectFil*NVectCol) ;
% Inicializar variables para cuerpo central de la funcion
Niveles = 1 ;
m = 0 ;
d_1 = Inf ;
epsilon = 1.0e-6 ;
VectorEpsilon = ones(blkfil, blkcol) ;
% Comienza ahora hasta que haya tantos Niveles como tamaño deseado del
% libro de codigo
while Niveles < MaxNiveles
    % Cambia de posicion los vectores de codigo obtenidos en la vuelta
    % anterior, y genera el doble de nuevos centroides tentativos
    for i=Niveles:-1:1
            NivAux = CodeBook(i) ;
            NivAux = NivAux + VectorEpsilon ;
            if NivAux <= maximos
                CodeBook(2*i,:,:) = NivAux(:,:) ;
            else
                CodeBook(2*i,:,:) = maximos(:,:) ;
            end
            NivAux = CodeBook(i) ;
            NivAux = NivAux - VectorEpsilon ;
            if NivAux >= minimos
                CodeBook(2*i-1,:,:) = NivAux(:,:) ;
            else
                CodeBook(2*i-1,:,:) = minimos(:,:) ;
            end
    end
    % Inicializar variables para calcular el paso del siguiente nivel
    Niveles = 2 * Niveles ;%% OJO-> ;
    distorsion = 0.0 ;
    ndistorsion = 0 ;
    Promedios = zeros(Niveles,blkfil,blkcol) ;
    NProm = zeros(Niveles) ;
    % Calcular las nuevas distancias hasta los nuevos centroides
    for i=1:1:NVectFil
        indfil = (i-1)*blkfil+1 ;
        finfil = indfil + blkfil -1 ;
        for j=1:1:NVectCol
            % Tomar el bloque correspondiente en la imagen
            indcol = (j-1)*blkcol+1 ;
            fincol = indcol + blkcol - 1;
            Actual = double( imagen( indfil:finfil, indcol:fincol ) ) ;
            % Asignar el vector actual al cluster donde tiene menor
            % distancia
            Dist = Inf ;
            for k=1:1:Niveles
                DistAux = norm( Actual-CodeBook(k), fDist ) ; %% OJO: Provisional!
                if DistAux < Dist
                    lugar = k ;
                    Dist = DistAux ;
                end
            end
            % Evalua distorsion respecto a todos los clusters
            distorsion = distorsion + Dist ;
            ndistorsion = ndistorsion + 1 ;
            % Para despues calcular centroide como promedio
            NProm(lugar) = NProm(lugar) + 1 ;
            for i1=1:1:blkfil
                for j1=1:1:blkcol
                    Promedios(lugar,i1,j1) = Promedios(lugar,i1,j1) + Actual(i1,j1) ;
                end
            end
            % Final del ciclo de recorrido por bloques
        end
    end
    % Calcula los promedios de los nuevos clusters
    for i = 1:1:Niveles
        if NProm(i) > 0
            N = NProm(i) ;
            Promedios(i) = Promedios(i)./N ;
            CodeBook(i) = round( Promedios(i) ) ;
        else
            CodeBook(i,:,:) = minimos(:,:) ;
        end
    end
    % Obtiene distorsion y coeficiente para esta iteracion
    distorsion = distorsion / ndistorsion ;
    coef = (d_1 - distorsion) / distorsion ;
    if coef < epsilon
        Niveles = MaxNiveles ;
    end
    d_1 = distorsion ;
end
sCodeBook = uint8( CodeBook ) ;
%disp("Fin GEN")
return
