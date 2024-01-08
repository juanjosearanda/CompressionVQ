function [media, varian, reseru, imadif] = JJecm(imagen, imacod) ;
% Autor:   Dr. Juan Jose Aranda Aboy;        Prof. Titular UV
%          CHILE -- CUBA ;                   15 de Octubre de 2004
%
% Descripcion:
% Esta funcion calcula el Error Cuadratico Medio entre la imagen original
% y la imagen comprimida por Cuantificacion de Vectores.
%
% Parametros de Entrada:
%   imagen   - Imagen original.
%   imacod   - Imagen comprimida.
%              Ambas imagenes deben ser de tipo uint8!!!
%
% Retorna:
%   media  - Media de la imagen diferencia
%   varian - Varianza de la diferencia
%   reseru - Relacion Señal / Ruido (en decibeles)
%   imadif - Imagen diferencia.
%
%disp("Inicia ECM")
[MaxFil,MaxCol] = size(imacod) ;
imadif = uint8( zeros(MaxFil,MaxCol) ) ;
N = MaxFil * MaxCol ;
media  = 0.0 ;
reseru = 0.0 ;
varian = 0.0 ;
dif2   = 0.0 ;
for i=1:1:MaxFil
    for j=1:1:MaxCol
        dif = abs( double(imagen(i,j)) - double(imacod(i,j)) ) ;
        if dif > 255
            dif = 255 ;
        end
        imadif(i,j) = uint8( dif ) ;
        media = media + dif ;
        reseru = reseru + double(imacod(i,j))^2 ;
        dif2 = dif2 + dif^2 ;
    end
end
varian = (dif2 - media^2 / N) / (N-1) ;
media  = media / N ;
reseru = 10 * log10(reseru/dif2) ;
%disp("Fin ECM")
return
