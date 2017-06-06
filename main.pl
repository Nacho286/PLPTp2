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

%Dada una lista damos las posibles configuraciones que se arman con esa lista en el orden dado 
aConf([X,Y],Conf):-herramienta(X,_),herramienta(Y,_),member(Conf,[binaria(X,Y),binaria(Y,X),jerarquica(X,Y),jerarquica(Y,X)]).
aConf([X,Y,W,Z|XS],Conf):-aConf([W,Z|XS],Conf2),member(Conf,[jerarquica(binaria(X,Y),Conf2),jerarquica(binaria(Y,X),Conf2),jerarquica(Conf2,binaria(X,Y)),jerarquica(Conf2,binaria(Y,X))]).
aConf([X|XS],Conf):-aConf(XS,Conf2),member(Conf,[jerarquica(Conf2,X),jerarquica(X,Conf2)]).

%Dada una lista generarmos todas las configuraciones posibles
allConf(M,Conf):- permutation(M,N),aConf(N,Conf).

%configuracion(+M, ?Conf, ?P, ?C)
configuracion(M,Conf,P,C):- setof(Conf2,allConf(M,Conf2),Configs),member(Conf,Configs),composicion(Conf,PC,CC), P is PC, C is CC.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MasPoderoso
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%masPoderosa(+M1,+M2)
%Ejemplo1: masPoderosa([volatilizador,volatilizador,rayo],[volatilizador,rayo,rayo]) = true
%Ejemplo2: masPoderosa([volatilizador,volatilizador,rayo],[rayo,rayo,rayo]) = true
%Ejemplo2: masPoderosa([volatilizador,volatilizador,rayo],[volatilizador,volatilizador,volatilizador]) = false

masPoderosa(M1,M2):- configuracion(M1,_,P,_),not((configuracion(M2,_,P2,_),P<P2)),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Mejor
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mejor(+M1,+M2)
%Ejemplo1:mejor([volatilizador,volatilizador],[rayo,rayo,rayo]) = true
%Ejemplo2:mejor([volatilizador,volatilizador],[rayo]) = true trivialmente por ser singleton.

mejor(M1,M2):- not((configuracion(M2,_,P,C), not((configuracion(M1,_,PP,CC), (PP >= P, C > CC))))).
%mejor2(M1,M2):- forall(configuracion(M2,_,P,C), (configuracion(M1,_,PP,CC),PP >= P, C > CC) ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usar
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%usar(+M1,+Ps,?Cs,?M2)
usar(M1,Ps,Cs,M2) :-  subConj(M1,M2), extraerConj(M1,M2,M3), usarReducida(Ps,M3,Cs).


%Le saco lo que no voy a usar y trabajo con esa mochila. 
%Me quedo con todas las posibles formas de particionar a esa mochila reducida en tantos subconjuntos como potenciales haya.
%Dada la lista de un posible particion de mochila, armo una onfiguraciones por cada una de ellas,
%Finalmente, pruebo si esa lista hace que se verifiquen los potenciales. 
%Backtracking despues...
usarReducida(Ps,M3,Cs) :- generarParticionMochila(M3,PM), length(PM,N), length(Ps,N), generarConfs(PM,Cs),  verificanPotencial(Ps,Cs).

generarParticionMochila([],[]).
generarParticionMochila(M3,[C|CS]) :- subConj(M3,C), C \= [], extraerConj(M3,C,M4), generarParticionMochila(M4,CS).


generarConfs([],[]).
generarConfs([M|MS],[Conf|CS]) :- configuracion(M,Conf,_,_), generarConfs(MS,CS).

verificanPotencial([],[]).
verificanPotencial([P|PS],[C|CS]) :- length(PS,N), length(CS,N), composicion(C,PP,_), PP >= P, verificanPotencial(PS,CS).

extraerConj(M1,[],M1).
extraerConj(M1,[X|XS],M3) :-  extraerConj(M1,XS,C),  quitar(X,C,M3).

quitar(X,[X|CS],CS).
quitar(X,[Y|CS],[Y|C]) :- X \= Y, quitar(X,CS,C). 

subConj([], []).
subConj([X|XS], [Y|YS]):- X = Y, subConj(XS, YS).
subConj([_|XS], YS):- subConj(XS, YS).


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Comprar
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Genero todas las mochilas posibles de entre cierto tamaño
allMochilas(0,[]).
allMochilas(N,M1):- herramienta(Y,_),M2=[Y],L is N-1,L>=0,allMochilas(L,M3),append(M2,M3,M1).
%comprar(+P,+C,?M)
comprar(P,C,M):-between(2,C,N),allMochilas(N,M), configuracion(M,_,PC,_),PC>=P.
