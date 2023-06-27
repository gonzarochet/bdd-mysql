create database guia5;
use guia5;

create table cerveza(	
    cervezaid int auto_increment primary key,
    nombre varchar(50),
    tipo varchar(50),
    graduacion float

);

create table receta(
	recetaid int auto_increment primary key, 
    nombre varchar(50),
    cervezaid int,
    
    foreign key (cervezaid) references cerveza(cervezaid)
);

create table ingrediente_x_receta(
	ingRecid int auto_increment primary key,
    recetaid int, 
    ingredienteid int,
	cantidad int,
    foreign key (recetaid) references receta(recetaid)
); 


create table ingrediente(
	 ingredienteid int auto_increment primary key,
     nombre varchar(50),
     unidadMedidad varchar(20),
     stock int
);


alter table ingrediente_x_receta
add constraint fk_ingredienteid 
foreign key (ingredienteid) references ingrediente(ingredienteid);



insert into cerveza (nombre,tipo,graduacion) values ('Imperial','Rubia',8.7);
insert into cerveza (nombre,tipo,graduacion) values ('Ambsterdan','Rubia',5.5);
insert into cerveza (nombre,tipo,graduacion) values ('Quilmes','Rubia',10);
insert into cerveza (nombre,tipo,graduacion) values ('Budweisser','Roja',2.1);
insert into cerveza (nombre,tipo,graduacion) values ('Stella Artois','Roja',1.3);
insert into cerveza (nombre,tipo,graduacion) values ('Patagonia','Negra',5.3);


insert into ingrediente (nombre,unidadMedidad,stock) values('Sesamo','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Tomate','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Lechuga','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Malta','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Cafe','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Agua','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Te hierbas','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Tanino','gramos',12000);
insert into ingrediente (nombre,unidadMedidad,stock) values('Lupulo','gramos',12000);

insert into receta (nombre,cervezaid) values('ImperialReceta',1);
insert into receta (nombre,cervezaid) values('AmbstedanReceta',2);
insert into receta (nombre,cervezaid) values('QuilmesReceta',3);
insert into receta (nombre,cervezaid) values('BudweisserReceta',4);
insert into receta (nombre,cervezaid) values('StellaArtoisReceta',5);
insert into receta (nombre,cervezaid) values('PatagoniaReceta',6);

insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(1,1,100);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(1,2,150);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(1,3,200);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(1,4,500);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(2,1,25);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(2,2,67);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(2,9,45);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(2,5,124);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(2,8,56);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(3,8,98);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(3,2,345);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(3,5,156);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(4,8,454);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(4,9,111);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(4,7,124);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(4,5,235);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(4,3,546);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(4,2,256);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(5,8,110);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(5,9,47);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(5,5,123);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(6,6,121);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(6,7,44);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(6,1,97);
insert into ingrediente_x_receta(recetaid,ingredienteid,cantidad)values(6,9,99);

/* 1. Mostrar la información de todas las cervezas junto con el respectivo nombre de su receta segun corresponda. */
select * from cerveza c
join receta r on r.cervezaid = c.cervezaid;

/* 2. listar 3 de las recetas que contengan mas de 5 ingredientes. */
select r.nombre , count(ir.ingRecid) as 'cant ingredientes'from receta r
join ingrediente_x_receta ir on r.recetaid = ir.recetaid
group by r.nombre
having count(ir.ingRecid) >3 limit 3;

/* 3. Ordenar los ingredientes de cada receta junto con el nombre de cada ingrediente de forma descendente. */ 
select r.nombre, i.nombre from receta r
join ingrediente_x_receta ir on ir.recetaid = r.recetaid
join ingrediente i on ir.ingredienteid = i.ingredienteid
order by r.nombre, i.nombre desc;

/* 4. Consultar el Promedio de ingredientes de todas las recetas. */
select avg(contador) as ' Promedio ingredientes' 
from (select count(ir.ingRecid) as contador
	from receta r 
    join ingrediente_x_receta ir on r.recetaid = ir.recetaid
    group by r.recetaid
    ) as conteos; 

/* 5. Listar toda la informacion de cada una de las recetas y toda la informacion de los ingredientes. */ 
select * from receta r
join ingrediente_x_receta ir on r.recetaid = ir.recetaid
join ingrediente i on ir.ingredienteid = i.ingredienteid;


/* 6. Listar las cervezas que se encuentren entre la letras C y P, junto al nombre de su receta. */ 
select c.nombre, r.nombre from cerveza c 
join receta r on c.cervezaid = r.cervezaid
where (c.nombre > 'C' ) and (c.nombre < 'Q') 
group by c.nombre
order by c. nombre asc;

/* 7. Listar la receta que más ingredientes contenga*/

select r.nombre, count(*) as cantIngredientes from receta r
join ingrediente_x_receta ir on r.recetaid = ir.recetaid
group by r.recetaid
order by count(ir.ingRecid) desc limit 1;

 /* creo que me echan de la facultad si algún profesor ve esto, jeje*/ 
select r.nombre, count(*) as cantIngredientes from receta r
join ingrediente_x_receta ir on r.recetaid = ir.recetaid
group by r.recetaid
having count(*) = (select max(contador) from (select count(ir.ingRecid) as contador from ingrediente_x_receta ir
	join receta r on ir.recetaid = r.recetaid group by r.recetaid) as conteo);

/* 8. Listar los 2 ingredientes que menos se utilizan (en menos recetas se encuentre). */ 
        
select i.nombre, count(*), ir.ingRecid from ingrediente i
join ingrediente_x_receta ir on ir.ingredienteid = i.ingredienteid
group by i.ingredienteid
order by count(ir.ingredienteid) asc limit 2 ;


/* 9. Listar todos los Ingredientes que en Stock tengan mas de 120xx. */ 
select * from ingrediente i
where i.stock > 120;

/* 10. Listar los Ingredientes que NO se utilicen en ninguna de las Recetas. */
select * from ingrediente i
left join ingrediente_x_receta ir on i.ingredienteid = ir.ingredienteid
where ir.ingredienteid is null


