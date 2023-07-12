create database parcial2;
use parcial2; 

create table persona(
	personaid int auto_increment primary key,
    apellido varchar(100),
    nombre varchar(100),
    dni int unique
);

create table pasante(
	pasanteid int auto_increment primary key,
	personaid int unique,
    horasAsignadas int,
    activo boolean,
    tipo_tarea varchar(50),
    
    foreign key(personaid) references persona(personaid)
);

create table empleado(
	empleadoid int auto_increment primary key,
    personaid int,
    modulo int, 
    fecha_baja date,
	
    foreign key (personaid) references persona(personaid)
);

create table planillaHoras(
	hsTrabajadasid int primary key,
    personaid int,
    dia date unique,
    horas int,
    
    foreign key (personaid) references persona(personaid)
);


alter table planillaHoras
add column hsTrabajadasid int auto_increment primary key;

insert into persona(apellido,nombre,dni) values('Rochet','Gonzalo',43592210);
insert into persona(apellido,nombre,dni) values('Rojas','Jorge',21457481);
insert into persona(apellido,nombre,dni) values('Pintos','Abel',23592211);
insert into persona(apellido,nombre,dni) values('Guerra','Francisco',35922110);

insert into pasante(personaid,horasAsignadas,activo,tipo_tarea) values(1,40,true,'Sistemas');
insert into pasante(personaid,horasAsignadas,activo,tipo_tarea) values(2,40,true,'Arquitectura');
insert into pasante(personaid,horasAsignadas,activo,tipo_tarea) values(3,40,true,'Sistemas');

insert into empleado(personaid) values(4);

insert into planillaHoras(personaid,dia,horas) values(1,"2023-03-02",8);
insert into planillaHoras(personaid,dia,horas) values(1,"2023-03-01",8);
insert into planillaHoras(personaid,dia,horas) values(1,"2023-03-03",8);

insert into planillaHoras(personaid,dia,horas) values(3,"2023-03-12",16);
insert into planillaHoras(personaid,dia,horas) values(3,"2023-03-11",16);
insert into planillaHoras(personaid,dia,horas) values(3,"2023-03-10",10);

/* 1. Obstener el listado del personal activa (activo o sin fecha de baja) de la empresa con el siguiente formato: 
	Personal      | Tipo 
    Jorge Rojas 	Empleado
    Alberto Plaza 	Pasante */
SELECT 
concat(p.nombre,' ' ,p.apellido) as Personal,
CASE 
	WHEN (SELECT 1 FROM empleado emp
			WHERE  p.personaid = emp.personaid and emp.fecha_baja is null)
	then 'Empleado'
    WHEN (SELECT 1 FROM pasante pa 
			WHERE p.personaid = pa.personaid
			AND pa.activo is true) 
	then 'Pasante'
END as TIPO
FROM persona p
GROUP BY p.personaid;

-- Esta version no esta tan mal, pero arroja valores null y recorre dos veces todos los registros. 
/*  
SELECT
concat(p.nombre,' ' ,p.apellido) as Personal,
(SELECT 'Empleado' FROM empleado emp
 WHERE  p.personaid = emp.personaid and emp.fecha_baja is null) as Tipo
 FROM persona p
UNION ALL
SELECT
concat(p.nombre,' ' ,p.apellido) as Personal,
(SELECT 'Pasante' FROM pasante pa 
 WHERE p.personaid = pa.personaid
 AND pa.activo is true) as Tipo
 FROM persona p;
*/ 
select * from empleado;
select * from pasante;
select * from persona;


/* 2. Listar apellido y nombre de los pasantes que tienen más horas asignadas que el promedio de todos los pasantes activos*/
SELECT 
concat(p.nombre,' ' ,p.apellido) as Personal
FROM persona p
JOIN pasante pa on p.personaid = pa.personaid
WHERE pa.horasAsignadas >= 
			(SELECT avg(pa.horasAsignadas) FROM pasante pa WHERE pa.activo is true);
            
/*3. Mostrar los tipos de tareas que llevaron mas horas que le promedio de horas realizadas de su mismo tipo 
	TIPO TAREA  | HORAS 
    sistemas      400   */
    
SELECT pa.tipo_tarea as TipoTarea,
(SELECT SUM(ph.horas)
	FROM pasante pas
    JOIN planillaHoras ph on pas.personaid = ph.personaid
    WHERE pa.tipo_tarea = pas.tipo_tarea) as Horas
FROM pasante pa 
JOIN planillaHoras ph on pa.personaid = ph.personaid
GROUP BY pa.tipo_tarea
HAVING HORAS > 
	(SELECT AVG (ph.horas) FROM planillaHoras ph 
	 JOIN pasante pas on ph.personaid = pas.personaid
     WHERE pas.tipo_tarea = pa.tipo_tarea);

select pa.tipo_Tarea as TipoTarea, sum(ph.horas) as Horas
from pasante pa
join planillaHoras ph on ph.personaId = pa.personaId
group by pa.tipo_Tarea
having sum(ph.horas) > (select avg(ph.horas) from planillaHoras ph join pasante pa on pa.personaId = ph.personaId);


/* 4. Crear un Store Procedure que reciba por parámetro el dni de un pasante
 y devuelva las horas trabajadas x día*/ 
 DELIMITER $$ 
 CREATE PROCEDURE getHsWorkedByDni(in DNI INT)
 BEGIN
 SELECT 
 ph.dia as dia,
 ph.horas as horas
 FROM planillaHoras ph
 JOIN pasante pa on ph.personaid = ph.personaid
 JOIN persona p on pa.personaid = p.personaid
 WHERE p.dni = DNI
 group by ph.dia;
 END $$
 DELIMITER ;
 
 CALL getHsWorkedByDni(43592210);
 
 
 