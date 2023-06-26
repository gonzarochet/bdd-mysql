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



/*insert into cerveza (nombre,tipo,graduacion) values ('Esp','Rubia',8.7);*/


