herramienta(rayo,10).
herramienta(volatilizador,40).
herramienta(encendedor,5).

composicion(binaria(X,Y),P,5):- herramienta(X, PX), herramienta(Y,PY), P is 2*PX + PY.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Composicion de jerarquicas
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Caso base
composicion(jerarquica(X,Y),P,C) :- herramienta(X,PX), herramienta(Y,PY), C is 2, P is PX*PY.
%Caso general
composicion(jerarquica(binaria(X,Y),Z),P,C) :- herramienta(Z,PZ), composicion(binaria(X,Y),PB,CB), P is PB*PZ, C is CB+1.
