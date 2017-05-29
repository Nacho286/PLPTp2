herramienta(rayo,10).
herramienta(volatilizador,40).
herramienta(encendedor,5).

composicion(binaria(X,Y),P,5):- herramienta(X, PX), herramienta(Y,PY), P is 2*PX + PY.
composicion(jerarquica(X,Y),P,C) :- herramienta(X,PA), herramienta(Y,PB), C is 2, P is PA*PB.
