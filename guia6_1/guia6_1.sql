create database guia4_1;
use guia4_1;

create table equipo(
	equipoid int auto_increment primary key,
    nombre varchar(50)
);

create table jugadores(
	jugadorid int auto_increment primary key,
    equipoid int,
    nombre varchar(30),
    apellido varchar(45),
	
    foreign key(equipoid) references equipo(equipoid)  
);

create table partido(
	partidoid int auto_increment primary key,
    equipoidLocal int, 
    equipoidVisitante int,
    fecha datetime
    
);

alter table partido
add constraint fk_equipoLocal
foreign key (equipoidLocal) references equipo(equipoid),
add constraint fk_equipoVisitante
foreign key (equipoidVisitante) references equipo(equipoid);

create table jugadores_x_equipo_x_partido(
	jugEquiParid int auto_increment primary key,
    jugadorid int, 
    partidoid int,
    puntos int,
    rebotes int, 
    asist int, 
    min float,
    faltas int,
    
    foreign key (jugadorid) references jugadores(jugadorid),
    foreign key (partidoid) references partido(partidoid)
);


/* Agregar todos los datos para poder hacer los ejercicios de consultas */

insert into equipo(nombre) values('Basquemania');
insert into equipo(nombre) values('Delorean');
insert into equipo(nombre) values('Celtics');
insert into equipo(nombre) values('Vikings');
insert into equipo(nombre) values('PCR');
insert into equipo(nombre) values('Mamba');
insert into equipo(nombre) values('Atletico Mar del Plata');

insert into jugadores(equipoid,nombre, apellido) values(6,'Michael' ,'Verstappen');
insert into jugadores(equipoid,nombre, apellido) values(6,'Emanuel','Leclerc');
insert into jugadores(equipoid,nombre, apellido) values(6,'Luis','Alonzo');
insert into jugadores(equipoid,nombre, apellido) values(6,'Facundo' , 'Perez');
insert into jugadores(equipoid,nombre, apellido) values(6,'Pablo','Sainz');
insert into jugadores(equipoid,nombre, apellido) values(7,'Lionel','Sainz');


select * from jugadores;


insert into partido(equipoidLocal,equipoidVisitante,fecha) values(1,2,'2023-01-01 20:00:00');
insert into partido(equipoidLocal,equipoidVisitante,fecha) values(1,3,'2023-01-10 20:00:00');
insert into partido(equipoidLocal,equipoidVisitante,fecha) values(1,4,'2023-01-20 20:00:00');
insert into partido(equipoidLocal,equipoidVisitante,fecha) values(1,5,'2023-01-28 20:00:00');
insert into partido(equipoidLocal,equipoidVisitante,fecha) values(1,6,'2023-02-07 20:00:00');
insert into partido(equipoidLocal,equipoidVisitante,fecha) values(7,1,'2023-02-14 20:00:00');

insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(1,1,18,5,3,35.5,4);
insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(2,1,6,5,3,35.5,4);
insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(1,2,12,5,3,35.5,4);
insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(1,3,8,5,3,35.5,4);
insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(1,4,38,5,3,35.5,4);
insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(1,5,21,5,3,35.5,4);

insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(6,1,21,5,3,35.5,4);

insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(7,6,14,5,3,35.5,4);

insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(4,1,12,5,3,35.5,4);

insert into jugadores_x_equipo_x_partido (jugadorid,partidoid,puntos,rebotes,asist,min,faltas)
values(4,1,12,5,3,35.5,4);

select * from jugadores_x_equipo_x_partido;

select j.nombre, jep.puntos from jugadores_x_equipo_x_partido as jep
inner join jugadores j on jep.jugadorid = j.jugadorid; 

/* 1. Listar los jugadores y a que equipo pertenecen (nombre, apellido ,
nombre_equipo). */
select j.nombre, j.apellido, e.nombre from equipo e 
inner join jugadores j on j.equipoid = e.equipoid;

/* 2. Listar los equipos cuyo nombre comience con la letra P.*/
select e.nombre from equipo e
where substring(e.nombre,1,1) = 'P';


/* OPCION 2 - el like únicamente se puede utilizar con el where*/ 

select e.nombre from equipo e
where e.nombre like 'P%';

/*3. Listar los jugadores que pertenezcan a un equipo que contenga una “Atletico” o
“Atlética” en su nombre (Por ej : Atletico Tucuman o Asociacion Atletica
Patronato ”. */
select j.nombre, j.apellido, e.nombre as 'Team' from jugadores j
inner join equipo e on e.equipoid = j.equipoid
where (locate('Atletico',e.nombre) >0 );

/* 4. Listar los jugadores y su equipo siempre y cuando el jugador haya jugado al menos
un partido.*/

select count(jep.jugadorid) as 'Game played' ,j.nombre, j.apellido, e.nombre as 'Equipo Pertenece' from jugadores_x_equipo_x_partido jep
inner join jugadores j on j.jugadorid = jep.jugadorid
inner join equipo e on j.equipoid = e.equipoid 
group by j.nombre
having count(jep.jugadorid) >0;

select * from jugadores_x_equipo_x_partido;


/* 5. Listar los partidos con su fecha y los nombres de los equipos local y visitante. */ 
select p.fecha, equipoLocal.nombre as 'LOCAL', equipoVisitante.nombre AS 'VISIT' from partido p
join equipo as equipoLocal on  p.equipoidLocal = equipoLocal.equipoid
join equipo as equipoVisitante on p.equipoidVisitante = equipoVisitante.equipoid;

/* 6. Listar los equipos y la cantidad de jugadores que tiene */
select e.nombre as 'Nombre Equipo', count(j.jugadorid) as 'Cant jug'  from equipo e
join jugadores j on e.equipoid = j.equipoid
group by (e.nombre);

select * from jugadores;

/* 7. Listar los jugadores y la cantidad de partidos que jugó. */ 
select j.nombre, j.apellido, count(jep.jugadorid) as 'Partidos jugados' from jugadores j
join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
group by j.nombre, j.apellido;

/* 8. Elaborar un ranking con los jugadores que más puntos hicieron en el torneo */ 
select j.jugadorid, j.equipoid,j.nombre, j.apellido, sum(jep.puntos) as 'Cant Puntos' from jugadores j
join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
group by(j.nombre)
order by sum(jep.puntos) desc;

/* 9. Elaborar un ranking con los jugadores que más promedio de puntos tienen en el
torneo. */ 
select j.nombre, j.apellido, avg(jep.puntos) as 'Prom Puntos' from jugadores j
join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
group by (j.nombre)
order by avg(jep.puntos) desc;

/* 10. Para cada jugador, mostrar la fecha del primer y último partido que jugo. */
select j.nombre, j.apellido, min(primerPartido.fecha) as 'primer' , max(ultimoPartido.fecha) as 'ultimo' from jugadores j
join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
join partido as primerPartido on primerPartido.partidoid = jep.partidoid
join partido as ultimoPartido on ultimoPartido.partidoid = jep.partidoid
group by j.nombre;


/* 11. Listar los equipos que tengan registrados mas de 10 jugadores */ 
select e.nombre, count(j.jugadorid) from jugadores j
join equipo e on j.equipoid = e.equipoid
group by e.nombre
having count(j.jugadorid) > 10;

select * from equipo e
join jugadores j on j.equipoid = e.equipoid;

/* 12. Listar los jugadores que hayan jugado más de 5 partidos y promediado más de 10
puntos por partido.  */
select concat(j.nombre, ' ', j.apellido) as 'Full Name Player', avg(jep.puntos) as 'PPP' from jugadores j
join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
group by j.nombre
having count(jep.jugadorid) > 4 and avg(jep.puntos) >10;   

/* 13. Listar los jugadores que en promedio tengan más de 10 puntos , 10 asistencias y
10 rebotes por partido. */ 

select j.nombre, j.apellido, avg(jep.puntos) as 'ppp' , avg(jep.asist) as 'app', avg(rebotes) as 'rpp' from jugadores j
join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
group by j.nombre
having avg(jep.puntos) >10 and avg(jep.asist) >2 and avg(jep.rebotes) >1; 

select * from jugadores_x_equipo_x_partido; 

/* 14. Dado un equipo y un partido, devolver cuantos puntos hizo cada equipo en cada
uno de los partidos que jugo como local. */ 

select e.nombre, sum(jep.puntos) as 'Puntos Realizados',  equipoLocal.fecha  from equipo e 
join partido as equipoLocal on equipoLocal.equipoidLocal = e.equipoid
join jugadores_x_equipo_x_partido jep on equipoLocal.partidoid = jep.partidoid
group by(equipoLocal.fecha);
 
 select * from partido p; 
 
/* 15. Listar los equipos que hayan jugado como local mas de 3 partidos. */ 
select e.nombre, count(e.equipoid) as 'Local game' from equipo e
join partido p on e.equipoid = p.equipoidLocal
group by e.nombre
having count(e.equipoid) > 3;


/** GUIA 6.1 - ADICIONAL INTEGRADORA **/

/* 1. Generar una consulta para conocer los jugadores y cuantos puntos , rebotes,
asistencias y faltas hicieron de promedio. Listar los mejores 5 y los peores 5 en base
a un coeficiente (promedio*1 + rebotes*0.5 + asistencias*0.5 + (faltas * -1)) .
Identificar cada grupo diciendo si está entre los mejores 5 o los peores 5. */ 


select * from jugadores;
select * from partido;
select * from jugadores_x_equipo_x_partido;
select * from equipo;

insert into jugadores_x_equipo_x_partido(jugadorid,partidoid,puntos,rebotes,asist,min,faltas) 
values(9,1,2,1,4,8,1),(10,1,2,1,6,21,1),(11,2,21,2,4,29,4),(12,2,4,2,2,20,1),(14,2,6,7,1,29,2),(2,4,38,4,6,40,7);

insert into jugadores_x_equipo_x_partido(jugadorid,partidoid,puntos,rebotes,asist,min,faltas) values
(2,4,38,4,6,40,7);
 SELECT
   concat(jug.nombre, ' ', jug.apellido) as nombre,
	(SELECT ifnull((avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 +(jep.faltas) * -1),0) as coeficiente
	 FROM jugadores j
	 JOIN jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
	 WHERE j.jugadorid = jug.jugadorid)
     as coeficienteJug
FROM jugadores jug
GROUP BY jug.jugadorid
HAVING coeficienteJug >0
order by coeficienteJug ASC limit 4;

 SELECT
  concat(jug.nombre, ' ', jug.apellido) as nombre,
	(SELECT ifnull((avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 +(jep.faltas) * -1),0) as coeficiente
	 FROM jugadores j
	 JOIN jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
	 WHERE j.jugadorid = jug.jugadorid)
     as coeficienteJug
FROM jugadores jug
GROUP BY jug.jugadorid
HAVING coeficienteJug >0
order by coeficienteJug DESC limit 4;


    



/*

SELECT j.jugadorid,(avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 +(jep.faltas) * -1) as coeficiente
FROM jugadores j
JOIN jugadores_x_equipo_x_partido jep 
		on j.jugadorid = jep.jugadorid
GROUP BY j.jugadorid
ORDER BY coeficiente ASC LIMIT 5;

SELECT j.jugadorid,
	(avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 + (AVG(jep.faltas) * -1) ) as coeficiente, 
    CASE 
		WHEN ((avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 + (AVG(jep.faltas) * -1) )  = 
			(SELECT avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 + (AVG(jep.faltas) * -1)
			FROM jugadores j join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
			GROUP BY j.jugadorid
			ORDER BY (avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 + (AVG(jep.faltas) * -1))asc limit 1)) then 'bajo'
		WHEN (avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 + (AVG(jep.faltas) * -1) ) = 
                (SELECT avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 + (AVG(jep.faltas) * -1)
				from jugadores j join jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
                group by j.jugadorid
                order by (avg(jep.puntos)*1 + avg(jep.rebotes)* 0.5 + avg(jep.asist) * 0.5 + (AVG(jep.faltas) * -1) )desc limit 1) then 'alto' 
end as grupo
FROM jugadores j
JOIN jugadores_x_equipo_x_partido jep 
	on j.jugadorid = jep.jugadorid
GROUP BY j.jugadorid
ORDER BY coeficiente DESC;

*/


/* 3. Generar una consulta que nos devuelva el resultado de un partido. 
SELECT
	(SELECT SUM(jep.puntos)
	 FROM partido par
     JOIN jugadores_x_equipo_x_partido jep on par.partidoid = jep.partidoid
     JOIN jugadores j on jep.jugadorid = jep.jugadorid
     JOIN equipo e on e.equipoid = par.equipoidLocal
     WHERE e.equipoid = 1 AND jep.partidoid = 1) AS ptsLocal,
     (SELECT SUM(jep.puntos)
	 FROM partido par
     JOIN jugadores_x_equipo_x_partido jep on par.partidoid = jep.partidoid
     JOIN jugadores j on jep.jugadorid = jep.jugadorid
     WHERE j.equipoid = 2 AND jep.partidoid = 1) AS ptsLocal
FROM partido p
JOIN equipo as equipoLocal on p.equipoidLocal = equipoLocal.equipoid
JOIN equipo as equipoVisitante on p.equipoidVisitante = equipoVisitante.equipoid
WHERE p.partidoid = 1
group by p.partidoid; */

/* Este es el que vale, muestra todos los resultados por partido y dice cual es cada equipo y sus respectivos puntos*/ 
SELECT pa.partidoid, equipLocal.nombre,
(select ifnull(sum(jeps.puntos),0)
FROM partido p
JOIN equipo as equipoLocal on p.equipoidLocal = equipoLocal.equipoid
JOIN equipo as equipoVisitante on p.equipoidVisitante = equipoVisitante.equipoid
JOIN jugadores_x_equipo_x_partido jeps on jeps.partidoid = p.partidoid
JOIN jugadores j on jeps.jugadorid = j.jugadorid
WHERE jeps.partidoid = jep.partidoid and j.equipoid = equipoLocal.equipoid) AS ptsLocal,
equipVisitante.nombre,
(
select ifnull(sum(jeps.puntos),0)
FROM partido p
JOIN equipo as equipoLocal on p.equipoidLocal = equipoLocal.equipoid
JOIN equipo as equipoVisitante on p.equipoidVisitante = equipoVisitante.equipoid
JOIN jugadores_x_equipo_x_partido jeps on jeps.partidoid = p.partidoid
JOIN jugadores j on jeps.jugadorid = j.jugadorid
WHERE jeps.partidoid = jep.partidoid and j.equipoid = equipoVisitante.equipoid
) as ptsVisit
from jugadores_x_equipo_x_partido jep
join partido pa on jep.partidoid = pa.partidoid -- si quiero un partido en particular, solo cambio lo que le paso aqui. 
join equipo as equipLocal on equipLocal.equipoid = pa.equipoidLocal
join equipo as equipVisitante on equipVisitante.equipoid = pa.equipoidVisitante
group by jep.partidoid;

/* 4. Generar una consulta que nos permita visualizar la tabla de posiciones de un torneo*/ 
SELECT
e.nombre,
	(CASE
			WHEN (e.equipoid = par.equipoidLocal) and 
				(SELECT ifnull(sum(jeps.puntos),0)
				FROM partido p
				JOIN equipo as el on p.equipoidLocal = el.equipoid
				JOIN equipo as ev on p.equipoidVisitante = ev.equipoid
				JOIN jugadores_x_equipo_x_partido jeps on jeps.partidoid = p.partidoid
				JOIN jugadores j on jeps.jugadorid = j.jugadorid
				WHERE par.partidoid = jeps.partidoid and j.equipoid = el.equipoid -- jep.equipoid
                ) >  (SELECT ifnull(sum(jeps.puntos),0)
					FROM partido p
					JOIN equipo as el on p.equipoidLocal = el.equipoid
					JOIN equipo as ev on p.equipoidVisitante = ev.equipoid
					JOIN jugadores_x_equipo_x_partido jeps on jeps.partidoid = p.partidoid
					JOIN jugadores j on jeps.jugadorid = j.jugadorid
					WHERE par.partidoid = jeps.partidoid and j.equipoid = ev.equipoid -- jep.equipoid
			) 
            THEN 2
           WHEN (e.equipoid = par.equipoidVisitante) and (
				(SELECT ifnull(sum(jeps.puntos),0)
				FROM partido p
				JOIN equipo as el on p.equipoidLocal = el.equipoid
				JOIN equipo as ev on p.equipoidVisitante = ev.equipoid
				JOIN jugadores_x_equipo_x_partido jeps on jeps.partidoid = p.partidoid
				JOIN jugadores j on jeps.jugadorid = j.jugadorid
				WHERE par.partidoid = jeps.partidoid and j.equipoid = el.equipoid -- jep.equipoid
                ) <  (SELECT ifnull(sum(jeps.puntos),0)
					FROM partido p
					JOIN equipo as el on p.equipoidLocal = el.equipoid
					JOIN equipo as ev on p.equipoidVisitante = ev.equipoid
					JOIN jugadores_x_equipo_x_partido jeps on jeps.partidoid = p.partidoid
					JOIN jugadores j on jeps.jugadorid = j.jugadorid
					WHERE par.partidoid = jeps.partidoid and j.equipoid = ev.equipoid )-- jep.equipoid
			)
            THEN 2 
            ELSE 0 END 
		) as Puntos
FROM equipo e
JOIN partido par on e.equipoid = par.equipoidLocal or par.equipoidVisitante = e.equipoid
GROUP BY e.equipoid;


/* 5. Generar una consulta que nos permita conocer los jugadores con mejor promedio de
puntos es decir: Si hay dos jugadores que hicieron 30 puntos por partido listarlos a
ambos. */
SELECT 
j.nombre, j.apellido, avg(jep.puntos) as puntosJug
FROM jugadores j
JOIN jugadores_x_equipo_x_partido jep 
	on jep.jugadorid = j.jugadorid
GROUP BY j.jugadorid
having puntosJug = (SELECT MAX(jugMaxPuntos) 
					FROM (SELECT AVG(jep.puntos) as jugMaxPuntos from jugadores j 
                    join jugadores_x_equipo_x_partido jep on jep.jugadorid = j.jugadorid
                    group by j.jugadorid)as jugadoresPuntos); 
                    
/* 6. Generar una consulta que nos permita conocer los jugadores que hicieron más
puntos en un partido y en qué partido lo hicieron (Poner Equipo Local y Equipo
Visitante). */ 

SELECT
concat(j.nombre, ' ', j.apellido),
jep.puntos as pts,
el.nombre as equipolocal, 
ev.nombre as equipoVis
FROM jugadores j
JOIN jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
JOIN partido p on jep.partidoid = p.partidoid
JOIN equipo as el on el.equipoid = p.equipoidLocal
JOIN equipo as ev on ev.equipoid = p.equipoidVisitante
having pts = (SELECT MAX(jep.puntos) from jugadores j 
				join jugadores_x_equipo_x_partido jep on jep.jugadorid = j.jugadorid);
                
/* 7. Listar los equipos y en el mismo registro listar cual es el jugador con el mayor
promedio de puntos.*/ 
SELECT
e.nombre as 'Nombre Equipo ',
(
SELECT concat(j.nombre, ' ', j.apellido) 
FROM jugadores j
JOIN jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
group by j.jugadorid
having avg(jep.puntos) = 
			(
            SELECT max(ptsJug) FROM (select avg(jep.puntos) as ptsJug
									FROM jugadores j 
                                    JOIN jugadores_x_equipo_x_partido jep 
                                    on j.jugadorid = jep.jugadorid
                                    group by j.jugadorid) 
			as tabla
		) 
)as jugMaxPuntos
FROM equipo e; 


select e.nombre from equipo e
union all
SELECT concat(j.nombre, ' ', j.apellido) 
FROM jugadores j
JOIN jugadores_x_equipo_x_partido jep on j.jugadorid = jep.jugadorid
group by j.jugadorid
having avg(jep.puntos) = 
			(
            SELECT max(ptsJug) FROM (select avg(jep.puntos) as ptsJug
									FROM jugadores j 
                                    JOIN jugadores_x_equipo_x_partido jep 
                                    on j.jugadorid = jep.jugadorid
                                    group by j.jugadorid) 
			as tabla
		);
/* 8. Listar los equipos en el mismo registro listar cual es el jugador que hizo más puntos
en un partido, cuantos puntos y en qué partido lo hizo. */ 
SELECT e.nombre from equipo e
UNION
SELECT concat(j.nombre, ' ', j.apellido)FROM jugadores j
join jugadores_x_equipo_x_partido jep on jep.jugadorid = j.jugadorid
having max(jep.puntos)
UNION
select p.partidoid from partido p
where p.partidoid = (SELECT jep.partidoid FROM jugadores j
join jugadores_x_equipo_x_partido jep on jep.jugadorid = j.jugadorid
order by jep.puntos desc limit 1) ;

select * from jugadores_x_equipo_x_partido;

 