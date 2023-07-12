create database parcial1;
use parcial1;

create table cliente(
    clienteid int auto_increment primary key,
	nombre varchar(50),
    apellido varchar(100),
    dni int not null unique,
    telefono int
);

create table marca(
	marcaid int auto_increment primary key,
    nombre varchar(60)
);

create table reserva(
	reservaid int auto_increment primary key,
    clienteid int not null,
    fechaInicio date not null,
    fechaFinal date not null,
    precioTotal float,
	
    foreign key (clienteid) references cliente(clienteid)
);

create table detalleReserva(
	detalleReserva int auto_increment primary key,
    reservaid int,
    autoid int,
    lts int,
    
    foreign key(reservaid) references reserva(reservaid)
);

create table auto(
	autoid int auto_increment primary key,
    marcaid int,
    color varchar(10),
    matricula int unique,
    modelo varchar(20),
    precioxhora int,
    
    foreign key (marcaid) references marca(marcaid)

);

alter table auto
modify column matricula varchar(10);

alter table detalleReserva
add constraint fk_auto foreign key(autoid) references auto(autoid);


-- INSERTS

insert into marca(nombre) values('Fiat');
insert into marca(nombre) values('Chevrolet');
insert into marca(nombre) values('Ford');
insert into marca(nombre)values('Wolskwagen');

insert into auto(marcaid,matricula,modelo,color,precioxhora)values(1,'AC792WW','Argo','Negro', 182);
insert into auto(marcaid,matricula,modelo,color,precioxhora) values(1,'AA222SS','Cronos','Negro', 3182);
insert into auto(marcaid,matricula,modelo,color,precioxhora) values(1,'AC888DD','Fiat Coupe','Negro', 4182);
insert into auto(marcaid,matricula,modelo,color,precioxhora) values(1,'AC111DD','Duna','Negro', 182.32);
insert into auto(marcaid,matricula,modelo,color,precioxhora) values(1,'AC792WX','Pulse','Negro', 5182);
insert into auto(marcaid,matricula,modelo,color,precioxhora) values(3,'AC792ZX','Focus','Negro', 518);
insert into auto(marcaid,matricula,modelo,color,precioxhora) values(2,'BC792ZX','Cruze','Blanco', 7890);

insert into cliente (nombre,apellido,dni,telefono)values('Gonzalo','Rochet',43592210,2244);
insert into cliente(nombre, apellido,dni,telefono) values('Jorge','Rojas',23654955,2236);

insert into reserva (clienteid,fechaInicio,fechaFinal,precioTotal) values(1,"2022-03-01","2022-03-02",2405.67);
insert into reserva (clienteid,fechaInicio,fechaFinal,precioTotal)values(1,"2022-03-04","2022-03-05",405.67);
insert into reserva (clienteid,fechaInicio,fechaFinal,precioTotal)values(1,"2022-03-06","2022-03-07",240.67);
insert into reserva (clienteid,fechaInicio,fechaFinal,precioTotal)values(1,"2021-03-01","2021-03-01",205.67);
insert into reserva (clienteid,fechaInicio,fechaFinal,precioTotal)values(1,"2022-03-08","2022-03-09",2467);

insert into detalleReserva(reservaid,autoid,lts)values(1,1,57.8);
insert into detalleReserva(reservaid,autoid,lts) values(1,2,57.8);
insert into detalleReserva (reservaid,autoid,lts) values(2,3,57.8);
insert into detalleReserva (reservaid,autoid,lts) values(4,2,57.8);
insert into detalleReserva (reservaid,autoid,lts) values(5,5,57.8);


-- EJERCICIOS 

/* 1. Mostrar informacion de los autos de la marca fiat y clasificar por categoria (alta, media y baja)
menor a 2000, entre dosmil y cincomil, y mas de cincomil*/

select (case when a.precioxhora <2000 then a.matricula  end) as economica,
(case when precioxhora >=2000 and precioxhora< 5000 then a.matricula end ) as media,
(case when precioxhora >5000 then a.matricula end) as alta
from auto a join marca m on m.idMarca = a.idMarca
where m.nombre = 'Fiat';

/* 2. Mostrar el cliente y la cantidad de reservas realizadas con autos de la marca 'Fiat'. Mostrar 
unicamente aquellos con mas de cinco reservas realizadas.*/

select concat(cli.name, cli.lastname) as Cliente, count(r.idReserva) as cantidadReservas
from cliente cli
join reserva r on r.idCliente = cli.idCliente
join detalleReserva dr on dr.idReserva = r.idReserva
join auto a on a.idAuto = dr.idAuto
join marca m on m.idMarca = a.idMarca
where m.nombre = 'Fiat'
group by cli.idCliente
having cantidadReservas >1
order by cantidadReservas desc;


/* 3. Mostrar las reservas realizadas en el año 2022 con el siguiente formato, donde "autos" corresponde
 a la cantidad de autos reservasos en dicha reserva */
SELECT 
	r.reservaid,
    r.fechaInicio,
    concat(cli.nombre , ' ', cli.apellido) as cliente,
    (SELECT count(*) 
		from detalleReserva dt
        where dt.reservaid = r.reservaid) as autos
 FROM cliente cli
 JOIN reserva r on cli.clienteid = r.clienteid
 WHERE year(r.fechaInicio) = '2022'
 group by r.reservaid;
 
 /* 4. Crear un Store Procedure que tome por parámetro el dni de un cliente y devuelva el total abonado por auto*/ 
DELIMITER $$
CREATE PROCEDURE get_mount_by_car_and_dni(in DNI int)
BEGIN
	SELECT a.matricula,
    (SELECT SUM(r.precioTotal)
		FROM cliente cli
        JOIN reserva r on cli.clienteid = r.clienteid
        JOIN detalleReserva dr on r.reservaid = dr.reservaid
        WHERE cli.dni = DNI and a.autoid = dr.autoid) as totalAbonado
	FROM auto a
    group by(a.autoid);
END $$

DELIMITER ;


CALL get_mount_by_car_and_dni(43592210);
