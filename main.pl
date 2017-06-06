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
aLista(jerarquica(X,Y),L):- herramienta(X,_), append([X],LY,S), permutation(L,S) , aLista(Y,LY) .
aLista(jerarquica(X,Y),L):- herramienta(Y,_), append([Y],LX,S), permutation(L,S), aLista(X,LX) .

aConf([X,Y],Conf):-herramienta(X,_),herramienta(Y,_),member(Conf,[binaria(X,Y),binaria(Y,X),jerarquica(X,Y),jerarquica(Y,X)]).
aConf([X,Y,W,Z|XS],Conf):-aConf([W,Z|XS],Conf2),member(Conf,[jerarquica(binaria(X,Y),Conf2),jerarquica(binaria(Y,X),Conf2),jerarquica(Conf2,binaria(X,Y)),jerarquica(Conf2,binaria(Y,X))]).
aConf([X|XS],Conf):-aConf(XS,Conf2),member(Conf,[jerarquica(Conf2,X),jerarquica(X,Conf2)]).

allConf(M,Conf):- permutation(M,N),aConf(N,Conf).


cantRepeticiones(_,[],0 ).
cantRepeticiones(X,[X|L],N):-!, cantRepeticiones(X,L,M),N is M+1.
cantRepeticiones(X,[_|L],N):- cantRepeticiones(X,L,N).


posible(XS,L):-length(XS,M),length(L,N),M=N,forall(member(X,XS),(cantRepeticiones(X,XS,I),cantRepeticiones(X,L,J),I=J)).
%configuracion(+M, ?Conf, ?P, ?C)
configuracion(M,Conf,P,C):- setof(Conf2,allConf(M,Conf2),Configs),member(Conf,Configs),composicion(Conf,PC,CC), P is PC, C is CC.
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MasPoderoso
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%masPoderosa(+M1,+M2)
masPoderosa(M1,M2):- configuracion(M1,_,P,_),not((configuracion(M2,_,P2,_),P<P2)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Mejor
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mejor(+M1,+M2)
mejor(M1,M2):- not((configuracion(M2,_,P,C), not((configuracion(M1,_,PP,CC), (PP >= P, C > CC))))).
mejor2(M1,M2):- forall(configuracion(M2,_,P,C), (configuracion(M1,_,PP,CC),PP >= P, C > CC) ).	

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usar
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%usar(+M1,+Ps,?Cs,?M2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Comprar
%%%%%%%%%%%%%%%%%%%%%%%%%%%

allMochilas(0,[]).
allMochilas(N,M1):- herramienta(Y,_),M2=[Y],L is N-1,L>=0,allMochilas(L,M3),append(M2,M3,M1).
%comprar(+P,+C,?M)
comprar(P,C,M):-between(2,C,N),allMochilas(N,M), configuracion(M,_,PC,C),PC>=P.
