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
select j.nombre, j.apellido, sum(jep.puntos) as 'Cant Puntos' from jugadores j
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







 