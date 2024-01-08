function [nam,X] = JJAsa01;
%
% Autor:   Dr. Juan Jose Aranda Aboy;        Prof. Titular UV
%          CHILE -- CUBA ;                   5 de Octubre de 2004
%
% Descripcion:
%    Determina archivo de secuencias de imagenes .ASA (formato personal) y lo transfiere a memoria
%

% As per https://la.mathworks.com/help/matlab/ref/cd.html
diract = cd("C:/Users/JuanJose/Documents/EcoCardio2023/EcoGraf/Secuencias");

%%[FN,PN] = uigetfile("*.ASA",'Secuencias de Imagenes .ASA',100,100) ;
[FN, PN] = uigetfile("*.ASA", "Secuencias de imagenes tipo ASA", "ASA-Format");

% Back to previous folder
cd(diract);

if isequal(FN,0)|isequal(PN,0)
    fprintf('\nArchivo no encontrado!\n') ;
    %% OJO: Si no hay imagen, dar el error!!!
else
    nam = strcat(PN,FN) ;
    X = imread_asa(nam);
end

return
