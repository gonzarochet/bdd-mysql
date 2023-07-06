use guia3;
/***** SUBCONSULTAS ****/ 

/* 1. Listar Código y Nombre de cada Escuela, y obtener la cantidad de Reservas realizadas con una subconsulta */ 
SELECT e.escuelaid, e.nombre, 
	(SELECT count(*) 
    FROM reserva r 
	WHERE e.escuelaid = r.escuelaid) as 'Cant reservas'
FROM escuela e;

SELECT e.escuelaid , e.nombre, ifnull( count(r.reservaid),0)
FROM escuela e 
JOIN reserva r
	on e.escuelaid = r.escuelaid
GROUP BY e.escuelaid ASC;


/* 2. Listar Código y Nombre de cada Escuela, y obtener la cantidad de Reservas realizadas durante el
presente año, con una subconsuta. En caso de no haber realizado Reservas, mostrar el número
cero. */ 

SELECT e.escuelaid, e.nombre, 
	ifnull((SELECT count(*) 
	 FROM reserva r
     where (r.escuelaid = e.escuelaid) and r.fecha > (current_date() + interval- 1 year)
     ),0) as cantReservas
FROM escuela e;

SELECT
	e.escuelaid, 
	e.nombre,
	coalesce(count(*),0) as cantRESERVAS
FROM escuela e
JOIN reserva r
	on r.escuelaid = e.escuelaid
WHERE
	r.fecha > (current_date() + interval -1 year) 
GROUP BY e.escuelaid;


/* 3. Para cada Tipo de Visita, listar el nombre y obtener con una subconsulta como tabla derivada la
cantidad de Reservas realizadas. */ 


SELECT tv.nombre,
(SELECT count(*) 
FROM reserva r 
JOIN visita v on v.reservaid = r.reservaid 
WHERE v.tipoVisitaid = tv.tipoVisitaid) as 'cant Reserva'
FROM tipovisita tv;

select tv.nombre, count(*) 
from tipovisita tv
join visita v on tv.tipoVisitaid = v.tipovisitaid
join reserva r on v.reservaid = r.reservaid
group by tv.tipoVisitaid;

/* extra */

select * from tipovisita;
select * from reserva r
join visita  v on r.reservaid = v.reservaid ;


/* 4.  Para cada Guía, listar el nombre y obtener con una subconsulta como tabla derivada la cantidad de
Visitas en las que participó como Responsable. En caso de no haber participado en ninguna,
mostrar el número cero.  */ 

SELECT g.nombre,
	(SELECT ifnull(count(*),0)
	 FROM visitasguias vg 
	 JOIN visita v on vg.visitaid = v.visitaid
     WHERE vg.guiaid = g.guiaid
	) as CantVisitas
FROM guia g;


SELECT g.nombre, ifnull(count(*),0) as CantVisitasHechas
FROM guia g
JOIN visitasguias vg on g.guiaid = vg.guiaid
JOIN visita v on vg.visitaid = v.visitaid
GROUP BY g.guiaid;


/* 6. Listar el nombre de las Escuelas que realizaron Reservas. Resolver con Exists. */ 
SELECT e.nombre
FROM escuela e
WHERE EXISTS 
	(SELECT 1 
    FROM reserva r 
	WHERE r.escuelaid = e.escuelaid);
    
SELECT e.nombre
FROM escuela e
JOIN reserva r on e.escuelaid = r.escuelaid
GROUP BY e.escuelaid;


/* 7. Listar el nombre de la Escuelas que realizaron Reservas. Resolver con IN*/
SELECT e.nombre
FROM escuela e
WHERE e.escuelaid in 
	(SELECT r.escuelaid FROM reserva r); 
