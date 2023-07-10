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

/* 1. Generar un Stored Procedure que permite ingresar un equipo. */ 

DELIMITER $$
create procedure sp_insertar_equipo(
		nombreEquipo varchar(50)
)
BEGIN
	INSERT INTO equipo(nombre) 
    VALUES(nombreEquipo);
END $$

DELIMITER ;

CALL sp_insertar_equipo('Kinder Bologna');

select * from equipo


/* 2.  Generar un Stored Procedure que permita agregar un jugador pero se debe pasar el
nombre del equipo y no el Id.*/

DELIMITER $$
CREATE PROCEDURE sp_agregar_jugador_x_nombre_equipo
(
	nombreJugador varchar(30),
    apellidoJugador varchar(40),
    nombreEquipo varchar(50)
)
BEGIN 
	DECLARE idEquipoVar varchar(50);
    SET idEquipoVar = (SELECT equipoid FROM equipo e WHERE e.nombre = nombreEquipo);
    INSERT INTO jugadores(nombre, apellido,equipoid)
    VALUES(nombreJugador, apellidoJugador, idEquipoVar);
END $$

DELIMITER ;

CALL sp_agregar_jugador_x_nombre_equipo('Jorge','Rojas','Basquemania'); 
		
select * from jugadores;


/* 3. Generar un Stored Procedure que permita dar de alta un equipo y sus jugadores.
Devolver en un parámetro output el id del equipo. 

DELIMITER $$ 
CREATE PROCEDURE sp_alta_equipo_jugador
(
	IN nombreEquipo varchar(50),
    IN jugadoresArray JSON,
    OUT idEquipo int
)
BEGIN
	INSERT INTO equipo(nombre)
    values(nombreEquipo);
    
    SET idEquipo = (SELECT equipoid FROM equipo e WHERE e.nombre = nombreEquipo);
    
    INSERT INTO jugadores(nombre, apellido,equipoid)
    SELECT jug.nombre, jug.apellido, idEquipo
	FROM JSON_TABLE
		(
			jugadoresArray,
            '$[*]' COLUMNS (nombre varchar(30), apellido varchar(40))
		)
        as jug;

            
   -- FROM JSON_TABLE(jugadores, '$[*]' COLUMNS (nombre VARCHAR(255))) AS jugador;

END $$

DELIMITER ;

*/


/* 4. Generar un Stored Procedure que liste los partidos de un mes y año, pasado por
parametro. */

/* 5. Generar un Stored Procedure que devuelva el resultado de un partido pasando por
parámetro los nombres de los equipos. El resultado debe ser devuelto en dos
variables output */

DELIMITER $$ 
CREATE PROCEDURE sp_get_partido_resultado
(
	IN nombreEquipo1 varchar(50),
	IN nombreEquipo2 varchar(50),
    OUT ptsEquipo1 INT,
    OUT ptsEquipo2 INT
)
BEGIN 
	DECLARE equipo1id int;
    DECLARE equipo2id int;
    DECLARE partidoRealid int;
	
    SET	equipo1id = (SELECT equipoid FROM equipo e WHERE e.nombre = nombreEquipo1);
    SET	equipo2id = (SELECT equipoid FROM equipo e WHERE e.nombre = nombreEquipo2);
    
	IF (SELECT COUNT(*) FROM partido p 
		WHERE (p.equipoidLocal = equipo1id and p.equipoidVisitante = equipo2id) or
			 (p.equipoidLocal = equipo2id and p.equipoidVisitante = equipo1id))
	 = 1 THEN
		(Select p.partidoid INTO partidoRealid FROM partido p
        WHERE (p.equipoidLocal = equipo1id and p.equipoidVisitante = equipo2id) or
			 (p.equipoidLocal = equipo2id and p.equipoidVisitante = equipo1id));
        
        SET ptsEquipo1 = (SELECT SUM(jep.puntos) FROM jugadores_x_equipo_x_partido jep
							JOIN jugadores j on jep.jugadorid = j.jugadorid
                            WHERE j.equipoid = equipo1id and jep.partidoid = partidoRealid);
                            
		SET ptsEquipo2 = (SELECT SUM(jep.puntos) FROM jugadores_x_equipo_x_partido jep
							JOIN jugadores j on jep.jugadorid = j.jugadorid
                            WHERE j.equipoid = equipo2id and jep.partidoid = partidoRealid);
	ELSE
		set ptsEquipo1 = 0;
		set ptsEquipo2 = 0;
	END IF;
    
END $$
    
DELIMITER ;
select * from partido;
select * from equipo;
select * from jugadores_x_equipo_x_partido;

call sp_get_partido_resultado('Basquemania','Delorean',@ptsBasquetmania, @ptsDelorean);
SELECT @ptsBasquetmania , @ptsDelorean;


/* 6. Generar un stored procedure que muestre las estadisticas promedio de los jugadores
de un equipo.. */
DELIMITER $$
CREATE PROCEDURE sp_get_avg_stats_x_team
(
	in equipoid int
)
BEGIN
	SELECT j.nombre, j.apellido, ifnull(avg(jep.puntos),0),avg(jep.asist), avg(jep.rebotes), avg(jep.min),avg(jep.faltas)
    FROM jugadores_x_equipo_x_partido jep
    JOIN jugadores j on jep.jugadorid = j.jugadorid
	WHERE j.equipoid = equipoid
    GROUP BY j.jugadorid;
END $$
DELIMITER ;

CALL sp_get_avg_stats_x_team(1);












