function [CodeBook, X, Y, Z] = JJcvprog03(blkfil,blkcol,fDist) ;
%function [CodeBook, X, Y, Z, distorsion, media, varian, reseru] = JJcvprog03(blkfil,blkcol,fDist) ;
% Autor:   Dr. Juan Jose Aranda Aboy;        Prof. Titular UV
%          CHILE -- CUBA ;                   19 de Octubre de 2004
%
% Descripcion:
%   Programa Principal que sirve como ejemplo acerca del uso de las
%   funciones desarrolladas.
%
% Parametros de Entrada:
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
%   X, Y, Z     - Secuencias original, comprimida y diferencia
%
% Funciones utilizadas:
%   JJAsa01            - Lectura de imagen mediante dialogo
%   JJGenCodeBook      - Crea libro de codigos a partir de imagen leida
%   JJComprime_cv      - Realiza la compresion
%   JJDescomprime_cv   - Genera imagen comprimida para mostrar en pantalla
%   JJecm              - Evaluador de la calidad de la compresion realizada.
%
% Referencias:
%   1. Aranda,J.J.
%      "Compresion de Secuencias de Imagenes Ecocardiograficas"
%      Ingenieria Electronica, Automatica y Comunicaciones
%      Vol. XVI, Nros. 2-3, 1995
%   2. Linde, Y., A. Buzo, and R. M. Gray,
%      "An Algorithm for vector quantiser design,"
%      IEEE Trans Communications, vol. 28, pp.84-95, Jan 1980.
%
clear all
% Si no se especifica tamaño de bloque, se asume 4 x 4:
if nargin == 0
    blkfil = 4 ;
    blkcol = 4 ;
end
% Si solo se especifica un parametro, se asume que es vector:
if nargin == 1
    blkcol = 1 ;
end
if nargin < 3
    fDist = 2 ;
end

% Ejecutar el dialogo
[nam,X] = JJAsa01;
% Obtener informacion sobre la secuencia:
% Utilizar el comando:
[altoframe, anchoframe, profundidad, nframes] = size(X) ;

% Tomar primera imagen de la secuencia
imagen = X(:,:,:,1) ;

% Proceso del cuadro seleccionado de acuerdo con la profundidad de la
% imagen
Y = uint8( zeros(size(X)) ) ;
Z = uint8( zeros(size(X)) ) ;
tic ;
[CodeBook,distorsion] = JJgencodebook(imagen, 256, blkfil, blkcol, fDist ) ;
tiempogen = toc ;
nivreales = length(CodeBook) ;
media  = zeros(1, nframes) ;
varian = zeros(1, nframes) ;
reseru = zeros(1, nframes) ;
mistr  = strcat('Compresion por Cuantificacion de Vectores: ', nam) ;

tiempocom = 0.0 ;
for k =1:1:nframes ;
    imagen = X( :, :, 1, k ) ;
    tic ;
    [codigos] = JJComprime_cv(imagen, CodeBook) ;
    tiempocom = tiempocom + toc ;
    [imacod] = JJDescomprime_cv(codigos, CodeBook) ;
    [rf, rc] = size(imacod) ;
    Y(1 :rf, 1:rc, 1, k) = imacod ;
    [media(k), varian(k), reseru(k), imadif]=JJecm(imagen(1:rf,1:rc),imacod);
    Z(1 :rf, 1:rc, 1, k) = imadif ;
    %f = figure ;
    %set(f, 'NumberTitle', 'off') ;
    %set(f, 'Name', mistr ) ;
    %subplot(1,3,1), imshow(imagen) ;  % Graficar pedazo seleccionado
    %title 'Original'
    %subplot(1,3,2), imshow(imacod) ;  % Graficar compresion
    %title 'Comprimida'
    %subplot(1,3,3), imshow(imadif) ;  % Graficar diferencia
    %title 'Diferencia'
end

f1 = figure ;
set(f1, 'NumberTitle', 'off') ;
set(f1, 'Name', mistr ) ;
montage(X);
title 'Original'
f2 = figure ;
set(f2, 'NumberTitle', 'off') ;
set(f2, 'Name', mistr ) ;
montage(Y);
title 'Comprimida'
f3 = figure ;
set(f3, 'NumberTitle', 'off') ;
set(f3, 'Name', mistr ) ;
montage(Z);
title 'Diferencia'

% Imprimir resultados
fprintf( '\n Tiempo de generacion:                   %3d segundos.\n', round(tiempogen) ) ;
fprintf( '\n Tiempo de compresion de los %2d cuadros: %3d segundos.\n', nframes, round(tiempocom) ) ;
fprintf( '\n Distorsion durante generacion del libro = %7.4f\n', distorsion ) ;
fprintf( '\n Total de Niveles generados del libro: %3d\n', nivreales ) ;
fprintf( '\n   MEDIA   SDEV    SNR \n') ;
for k =1:1:nframes
    fprintf( ' %7.4f %7.4f %7.4f\n', media(k), sqrt( varian(k) ), reseru(k) ) ;
end
% That's all folks!
fprintf( '\n ¡Fin de la cita!\n' ) ; %%
return
