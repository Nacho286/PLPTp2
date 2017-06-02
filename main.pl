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

aLista(binaria(X,Y),L):- herramienta(X,_), herramienta(Y,_), member(L,[[X,Y],[Y,X]]).
aLista(jerarquica(X,Y),L):- herramienta(X,_), herramienta(Y,_), member(L,[[X,Y],[Y,X]]).
aLista(jerarquica(X,Y),L):- herramienta(X,_), aLista(Y,LY), append([X],LY,L).
aLista(jerarquica(X,Y),L):- herramienta(Y,_), aLista(X,LX), append([Y],LX,L).
aLista(jerarquica(X,Y),L):- aLista(X,LX), aLista(Y,LY), append(LX,LY,L).

cantRepeticiones(_,[],0 ).
cantRepeticiones(X,[X|L],N):-!, cantRepeticiones(X,L,M),N is M+1.
cantRepeticiones(X,[_|L],N):- cantRepeticiones(X,L,N).


posible(XS,L):-length(XS,M),length(L,N),M=N,forall(member(X,XS),(cantRepeticiones(X,XS,I),cantRepeticiones(X,L,J),I=J)).
% posible([],_).
% posible([X|XS],L):-cantRepeticiones(X,[X|XS],N),cantRepeticiones(X,L,M),0<N,N=<M,posible(XS,L).

%configuracion(+M, ?Conf, ?P, ?C)
%configuracion(M,Conf,P,C):- not(ground(Conf)),length(M,N),between(1,N,I),aLista(Conf,L),length(L,I),posible(L,M),composicion(Conf,PC,CC), P is PC, C is CC.
%configuracion(M,Conf,P,C):- aLista(Conf,L),posible(L,M),composicion(Conf,PC,CC), P is PC, C is CC.
% configuracion(M,binaria(X,Y),P,C):- posible(L,M),aLista(binaria(X,Y),L),composicion(binaria(X,Y),PC,CC), P is PC, C is CC.
% configuracion(M,jerarquica(X,Y),P,C):-posible(L,M), aLista(jerarquica(X,Y),L),composicion(jerarquica(X,Y),PC,CC), P is PC, C is CC.
configuracion(M,Conf,P,C):-aLista(Conf,M), composicion(Conf,PC,CC), P is PC, C is CC.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MasPoderoso
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%masPoderosa(+M1,+M2)
%masPoderosa(M1,M2):- configuracion(M1,Conf,P,C),not(configuracion(M2,Conf2,P2,C2),P<P2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Mejor
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mejor(+M1,+M2)
mejor(M1,M2):- not(configuracion(M2,Conf,P,C), not(configuracion(M1,Conf,PP,CC), (PP > P, C > CC)) ).