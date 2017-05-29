herramienta(rayo,10).
herramienta(volatilizador,40).
herramienta(encendedor,5).

composicion(binaria(X,Y),P,5):- herramienta(X, PX), herramienta(Y,PY), P is 2*PX + PY.
composicion(jerarquica(X,Y),P,C) :- X = herramienta(A,PA), Y = herramienta(B,PB), C is 2, P is PA*PB
