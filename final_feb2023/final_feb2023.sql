create database final_feb2023;
use final_fec2023;

create table clientes(
	clienteid int auto_increment primary key,
    nombre varchar(60),
    categoria char(1)
);

create table viajes(
	viajeid int auto_increment primary key,
    clienteid int not null,
    trayectoid int not null,
    fecha datetime not null,
    
    foreign key (clienteid) references clientes(clienteid)
); 

create table trayectos(
	trayectoid int auto_increment primary key,
    origenid int not null,
    destinoid int not null, 
    distancia int not null
);


create table ciudades(
	ciudadid int auto_increment primary key,
    nombre varchar(60)
);


alter table viajes
add constraint fk_trayectoid foreign key(trayectoid) references trayectos(trayectoid);

alter table trayectos
add constraint fk_ciudadOrigen foreign key(origenid) references ciudades(ciudadid),
add constraint fk_ciudadDestino foreign key(destinoid) references ciudades(ciudadid);

insert into clientes(nombre,categoria)
values('Gonzalo Rochet','A'),('Jorge Rojas','B'),('Julian Alvarez','C');

insert into ciudades(nombre)
values('Cordoba Capital'),('Calchin'),('San Luis'),('Mar del Plata');

insert into trayectos(origenid,destinoid,distancia)
values(4,1,800),(1,4,800),(1,2,116),(2,1,116),(4,3,1071),(3,4,1076);


insert into viajes(clienteid,trayectoid,fecha)
values(1,2,'2009-01-01'),(1,1,'2009-01-06'),(1,2,'2011-01-01'),(1,1,'2009-01-06'),(2,3,'2009-01-01'),(2,4,'2009-01-06'),(2,3,'2022-01-01'),(2,4,'2016-01-06'),(1,2,'2020-01-01'),(1,1,'2006-01-06');

select * from viajes;
select * from trayectos;
select * from ciudades;
select * from clientes;

/* 1. Algunos clientes han realizado Viajes y otros no. Escribir todas las sentencia para agregar a la tabla clientes
una columna "Viajero". Si el cliente realizo viajes, actualizarla con un 'SI', en caso contrario, 'NO'. */

ALTER table clientes
add column viajero char(2) default 'NO';

UPDATE clientes
SET clientes.viajero = 'SI'
WHERE(
(SELECT COUNT(*) FROM viajes v
WHERE v.clienteid = clientes.clienteid) >0); 

UPDATE clientes
SET Viajero = (
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM viajes
            WHERE viajes.clienteid = clientes.clienteid
        ) THEN 'SI'
        ELSE 'NO'
    END
);

/* 2. Listar la cantidad de viajes por cliente entre 2009 y 2011. 
Debe por cada cliente, mostrar la cantidad de viajes en columnas que se diviidan por año*/
SELECT cli.nombre,
count(CASE WHEN year(v.fecha) = '2009' THEN 1 end) as '2009',
count(CASE WHEN year(v.fecha) = '2010' THEN 1 end) as '2010',
count(CASE WHEN year(v.fecha) = '2011' THEN 1 end) as '2011'
FROM clientes cli
JOIN viajes v on cli.clienteid = v.clienteid
GROUP BY cli.clienteid;

/* 3. Listar la cantidad de viajes que se realizaron desde y hacia "Cordoba" en el año 2022. */

SELECT count(*)
FROM viajes v
JOIN trayectos t on v.trayectoid = t.trayectoid
JOIN ciudades as ciuOrigen on t.origenid = ciuOrigen.ciudadid
JOIN ciudades as ciuDestino on t.destinoid = ciuDestino.ciudadid
WHERE (((ciuOrigen.nombre = 'Cordoba Capital') OR (ciuDestino.nombre = 'Cordoba Capital') ) 
AND year(v.fecha) = '2022'); 


select * from viajes;
select * from ciudades;

/* 4. Con un Store Procedure que recibe el identificador de cliente, listar los destinos que todavia no realizó en ningun viaje. */
DELIMITER $$ 
CREATE PROCEDURE obtener_destinos_sin_hacer_x_cliente(
	in idCliente int 
)
BEGIN
SELECT ciu.nombre
FROM ciudades ciu
WHERE ciu.ciudadid NOT IN 
	(
		SELECT c.ciudadid
		FROM clientes cli
        JOIN viajes via on cli.clienteid = via.clienteid
		JOIN trayectos t on via.trayectoid = t.trayectoid
		JOIN ciudades c on t.origenid = c.ciudadid or t.destinoid = c.ciudadid
		where via.clienteid = idCliente
        group by c.ciudadid
	) 
GROUP BY ciu.ciudadid;
END $$

DELIMITER ;

call obtener_destinos_sin_hacer_x_cliente(1);


select * from clientes cli
join viajes v on v.clienteid = cli.clienteid;

select * from trayectos t
JOIN ciudades as ciuOrigen on t.origenid = ciuOrigen.ciudadid
JOIN ciudades as ciuDestino on t.destinoid = ciuDestino.ciudadid
