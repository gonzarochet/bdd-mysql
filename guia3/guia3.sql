create database guia3;
use guia3;

create table escuela (
	escuelaid int auto_increment primary key,
    nombre varchar(50),
    domicilio varchar(50)
);

create table reserva(
	reservaid int auto_increment primary key,
    escuelaid int,
    fecha date,
    foreign key(escuelaid) references escuela(escuelaid)
);

create table telEscuela(
	telEscuelaid int auto_increment primary key,
    escuelaid int,
    codigoArea int,
    nroTelefono int,
    foreign key(escuelaid) references escuela(escuelaid)
);

create table tipoVisita(
	tipoVisitaid int auto_increment primary key,
	nombre varchar(50),
    arancel float
);


create table guia(
	guiaid int auto_increment primary key,
    nombre varchar(50)
);

create table visita(
	visitaid int auto_increment primary key,
    reservaid int,
    tipoVisitaid int,
    cantAlumnos int, 
    cantAlumnosReales int, 
    grado varchar(12),
    arancel float,
    foreign key (reservaid) references reserva(reservaid),
    foreign key (tipoVisitaid)references tipoVisita(tipoVisitaid)
);


create table visitasGuias(
	visitasGuiasid int auto_increment primary key,
    visitaid int,
    guiaid int,
    foreign key (visitaid) references visita(visitaid),
    foreign key (guiaid) references guia(guiaid)
);

/* <<<<<<<<<<<<<<<<<<<<<<<-----GUIA 3.1 - MODIFICACION DE TABLAS----->>>>>>>>>>>>>>>>>>>>>>>>>>*/
 
 /* 1. Agregar al modelo, una tabla para Localidades. */
 create table localidad(
	localidadid int auto_increment primary key,
    nombre varchar(50), 
    codigo int
 );
 
 /* 2. Vincular la tabla Escuelas con la tabla Localidades, de manera que no pueda borrar
una Localidad en la que hay Escuelas cargadas. */

alter table escuela
add column localidadid int,
add constraint fk_localidadid foreign key (localidadid) references localidad(localidadid);

select * from escuela;

/* 3.Agregar una restricción a la tabla Localidades para que el IdLocalidad no sea menor
que 1000 ni superior a 9999. */
alter table localidad
add check (codigo >999 and codigo<10000);

/* 4. Agregar a la tabla Visitas una restricción para que la cantidad de AlumnosReales sea
igual o menor que la cantidad de Alumnos */

alter table visita
add check(cantAlumnosReales<= cantAlumnos);

/* 5. Agregar a la tabla Visitas una restricción para que la cantidad de AlumnosReales sea
igual a la cantidad de Alumnos, si no se ingresa un valor específico para la columna. */ 
/* alter table visita
alter column cantAlumnosReales set default cantAlumnos;

update visita
set cantAlumnosReales = cantAlumnos
where cantAlumnosReales is null ;*/


/* aGREGAR DATOS */

insert into escuela (nombre)
values ('escuela1'),('escuela2'),('escuela3'),('escuela4');

insert into telEscuela (escuelaid,codigoArea,nroTelefono)
values (1,223,6345890),(2,221,5039034),(3,2281,5455642);

insert into reserva(escuelaid,fecha)
values (1,'2018-01-01'),(1,'2018-02-01'),(1,'2018-09-01'),(1,'2018-10-01'),(2,'2018-10-01'),(1,'2018-01-02'),(2,'2018-03-02'),(2,'2018-10-02');

insert into tipoVisita(nombre,arancel)
values ('Común', 100.5),('Extendida', 150.7),('Completa', 210.8);

insert into visita(reservaid,tipoVisitaid,grado,cantAlumnos,cantAlumnosReales)
values (1,1,'1a',200,150),(2,1,'1b',200,160),(3,2,'1c',200,120),(4,3,'2a',100,80),(5,1,'1a',80,50),(6,1,'1a',232,123),(7,1,'1a',210,130),(8,1,'1a',213,50);

insert into guia(nombre)
values ('Juan'),('John'),('Marcelo'),('Nadia');

insert into visitasGuias(visitaid,guiaid)
values (1,1),(1,1),(2,1),(2,1),(3,2),(4,3),(5,1);

insert into localidad(nombre, codigo)
values ('Buenos Aires',1425),('Mar del Plata',7600);

update escuelas
set idLocalidad = 1
where idEscuela = 1;
update escuelas
set idLocalidad = 1
where idEscuela = 2;



/* <<<<<<<<<<<<<<<<<<<<<<<-----GUIA 4 - CONSULTAS---->>>>>>>>>>>>>>>>>>>>>>>>>>*/

/* 1.  Listar nombre y teléfonos de cada escuela.*/ 

select * from telEscuela;

select e.nombre, concat(t.codigoArea, t.nroTelefono) from escuela e
join telEscuela t on e.escuelaid = t.escuelaid;

/* 2. Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año.*/ 
select e.nombre, count(*) from escuela e
join reserva r on e.escuelaid = r.escuelaid
where fecha = 



