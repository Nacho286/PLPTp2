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
composicion(jerarquica(X,Y),P,C) :- herramienta(Y,PY), composicion(X,PX,CX),  P is PX*PY, C is 2*(CX+1).
composicion(jerarquica(X,Y),P,C) :- herramienta(X,PX), composicion(Y,PY,CY),  P is PX*PY, C is 2*(CY+1).
composicion(jerarquica(X,Y),P,C) :- composicion(X,PX,CX), composicion(Y,PY,CY),  P is PX*PY, C is 2*(CX+CY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Configuracion
%%%%%%%%%%%%%%%%%%%%%%%%%%%

aLista(binaria(X,Y),L):- herramienta(X,_), herramienta(Y,_), L = [X,Y].
aLista(jerarquica(X,Y),L):- herramienta(X,_), herramienta(Y,_), L = [X,Y].
aLista(jerarquica(X,Y),L):- herramienta(X,_), aLista(Y,LY), append([X],LY,L).
aLista(jerarquica(X,Y),L):- herramienta(Y,_), aLista(X,LX), append([Y],LX,L).
aLista(jerarquica(X,Y),L):- aLista(X,LX), aLista(Y,LY), append(LX,LY,L).

cantRepeticiones(_,[],0 ).
cantRepeticiones(X,[X|L],N):-!, cantRepeticiones(X,L,M),N is M+1.
cantRepeticiones(X,[_|L],N):- cantRepeticiones(X,L,N).

posible([],_).
posible([X|XS],L):-cantRepeticiones(X,[X|XS],N),cantRepeticiones(X,L,M),N=<M,0<N,posible(XS,L).

%configuracion(+M, ?Conf, ?P, ?C)
configuracion(M,binaria(X,Y),P,C):- aLista(binaria(X,Y),L),posible(L,M),composicion(binaria(X,Y),PC,CC), P is PC, C is CC.
configuracion(M,jerarquica(X,Y),P,C):- aLista(jerarquica(X,Y),L),posible(L,M),composicion(jerarquica(X,Y),PC,CC), P is PC, C is CC.
