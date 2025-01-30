use institutodb;

-- 1. Mostrar los alumnos del instituto, pero que solo aparezcan desde el quinto al noveno.
select * from alumno limit 4,5;

-- 2. Realiza una consulta de todos los alumnos repetidores.
select * from alumno where es_repetidor='si';

-- 3. Realiza una consulta de todos los alumnos repetidores nacidos entre el año 1995 y el 2000
select * from alumno where es_repetidor='si' and year(fecha_nacimiento) between 1995 and 2000 order by fecha_nacimiento;

-- 4. Realiza una consulta de los no repetidores nacidos después de 1998
select * from alumno where es_repetidor='no' and year(fecha_nacimiento) >= 1998 order by fecha_nacimiento;

-- 5. Realiza una consulta de alumnos que nacieron en 1998, y otra de los que no nacieron ese año
select * from alumno where year(fecha_nacimiento) = 1998 order by fecha_nacimiento;

select * from alumno where not year(fecha_nacimiento) = 1998 order by fecha_nacimiento;

-- 6. Consulta los alumnos que tienen un identificador entre 4 y 9.
select * from alumno where id between 4 and 9;

-- 7. Consulta los alumnos mayores de edad y menores de 25 que no tienen teléfono
select * from alumno
	where year(date(now())) - year(fecha_nacimiento) between 18 and 24
    and telefono is null
    order by fecha_nacimiento;
    
-- 8. Calcular la circunferencia de un círculo de radio 5 cm. (circunferencia = 2 * pi * radio) y mostrarla en los siguientes formatos:
-- 		a) Sin truncar ni redondear
select 2 * pi() * 5;

-- 		b) Redondeando sin decimales.
select round(2 * pi() * 5);

-- 		c) Redondear con dos decimales
select round(2 * pi() * 5, 2);

-- 9. ¿Cuántos bytes tiene un KB? ¿Y un MB?
select pow(2, 10) as KB;

select pow(2, 20) as MB;

-- 10. Mostrar la hora actual mostrando 4 columnas:
-- 		a) Hora completa: hh:mm:ss
-- 		b) Solo la hora.
-- 		c) Solo los minutos.
-- 		d) Solo segundos.
select time(now()) as 'hora_completa',
	hour(time(now())) as 'solo_hora', 
	minute(time(now())) as 'solo_minutos', 
    second(time(now())) as 'solo_segundos';

-- 11. De la tabla alumnos queremos obtener un listado de las onomásticas ordenado. Repite la búsqueda sobre la tabla contactos. Mostrar de 15 en 15.
select nombre from alumno order by nombre;

use contactosdb;

select nombre from contactos order by nombre;

-- 12. Mostrar un listado de los alumnos en el que aparezcan tres columnas: id, nombre completo
-- (apellido1, apellido2, nombre) y es_repetidor. Estará ordenada por: el campo es_repetidor y
-- por nombre completo (apellido1, apellido2, nombre). Ambos criterios ascendentes.
-- Observa cuidadosamente los resultados y explica la ordenación.
use institutodb;

select id, concat_ws(", ", apellido1, apellido2, nombre) as 'nombre_completo', es_repetidor from alumno order by es_repetidor, apellido1, apellido2, nombre;

-- 13. Listado de todos los alumnos con su edad actual. Para el cálculo considera que todos los
-- años tienen 365.242 días (365 días, 5 horas y 48 minutos)
select nombre, round(datediff(now(), fecha_nacimiento)/365) as 'edad_aproximada' from alumno order by 'edad';


-- 14. Listado de todos los alumnos cuyo segundo apellido termine en “ez”
select * from alumno where apellido2 regexp 'ez$';

select * from alumno;
-- 15. De la base de datos institutodb:
-- 		a) Eliminar el segundo apellido del primer alumno. (..set apellido2= NULL..).
update alumno set apellido2=NULL where id=2;

-- 		b) Mostrar un listado en el que aparezcan dos columnas: id y “apellido1 apellido2, nombre”. En cabecera ha de aparecer: Código y Nombre de alumno.
select id as 'Código', concat_ws(", ", concat_ws(" ", apellido1, apellido2), nombre) as 'Nombre de alumno' from alumno order by 2;

-- 16. Queremos asignar una cuenta de correo a los alumnos que estará compuesta por: letra
-- inicial, tres primeras letras del primer apellido, tres primeras letras del segundo apellido y
-- año de nacimiento (unidad y decena). El dominio será: politecnico.com
alter table alumno change correo_electronico correo_electronico varchar(30);
update alumno set 
	correo_electronico=
		concat_ws("",
		lower(left(nombre, 1)), 
		lower(left(apellido1, 3)), 
		lower(left(apellido2, 3)), 
		date_format(fecha_nacimiento, '%y'), 
		'@', 'politecnico.com')
	where id>0;
select * from alumno;


-- 17. Se ha de mostrar tres columnas: id, nombre completo (apellido1,apellido2, “, “ , nombre) y
-- correo. En las cabeceras ha de aparecer: Código, Nombre, Correo electrónico.
select id as 'Código', concat_ws(", ", concat_ws(",", apellido1, apellido2), nombre) as Nombre, correo_electronico as 'Correo electrónico' from alumno;

-- 18. En la tabla amo (veterinariodb) aparece el atributo: “apellidos”. Sobre esa tabla haz una
-- consulta en al que aparezcan tres columnas: primer apellido, segundo apellido y los dos
-- apellidos juntos (comprueba los resultados). Puede haber dueños de mascotas que solo
-- tengan un apellido o un número indeterminado de espacios en blanco al principio, final o en
-- medio.

use veterinariodb;

select 
	trim(substr(ltrim(apellidos), 1, locate(' ', ltrim(apellidos), 1))) as apellido1,
    trim(substr(ltrim(apellidos), locate(' ', ltrim(apellidos), 1))) as apellido2,
    trim(apellidos) as apellidos_juntos
from amo;

-- 19. Listado en dos columnas ordenado alfabéticamente por apellidos y nombre. En la que aparezca:
-- 		a) Nombre completo: Nombre (Primera letra mayúscula y resto minúscula), una “,” seguida de los apellidos en mayúsculas.
-- 		b) Número de caracteres que tiene el nombre completo.
select 
	concat_ws(", ", concat(upper(left(nombre, 1)), lower(right(nombre, length(nombre)-1))), ltrim(upper(apellidos))) as 'Nombre completo',
    length(concat_ws(nombre, apellidos)) as 'Número de caracteres'
from amo;

-- 20. Expresar la fecha de hoy en el formato: **lunes, 31 de enero de 2021**.
select date_format(date(now()), '**%W, %d de %M de %Y**') as 'fecha de hoy';

-- 21. De la base de datos de contactos, obtener un listado de las personas en el que aparezcan las
-- siguientes columnas:
--  a) Nombre.
--  b) Apellidos.
--  c) Nombre del mes de nacimiento.
--  d) Día de nacimiento.
--  e) Año de nacimiento.
-- El objetivo es tener una lista de los próximos cumpleaños, por lo que se ha de ordenar por:
-- mes, día y año. Para verlo cómodamente se han de mostrar de 15 en 15

use contactosdb;

select nombre as 'Nombre',
	apellidos as 'Apellidos',
    date_format(fechaNacimiento, '%M') as 'Mes de nacimiento',
    date_format(fechaNacimiento, '%d') as 'Dia de nacimiento',
    date_format(fechaNacimiento, '%Y') as 'Año de nacimiento'
    from contactos;


-- 22. Establecer la expresión regular que sea verdadera con los siguientes formatos:

-- a) Código postal: cinco números.

select 12345 regexp '^[0-9]{5}$';

-- b) Número de DNI: siete u ocho números.

select 12345678 regexp '^[0-9]{7,8}$';

-- c) Teléfono: 9 números.

select 123456789 regexp '^[0-9]{9}$';

-- d) Nif: siete u ocho números seguidos o no de un guion y un letra.

select '12345678A' regexp '^[0-9]{7,8}[A-Z]$';

-- e) Matrícula de un coche, formato nuevo: 4 números, un guión y tres letras.

select '0001-BBC' regexp '^[0-9]{4}-[A-Z]{3}$';

-- f) Matrícula de un coche, formato antiguo: una o dos letras (según provincia), guion, cuatro números, guion y una o dos letras. Guiones opcionales.

select 'CO-0001-AA' regexp '^[A-Z]{1,2}-[0-9]{4}-[A-Z]{1,2}$';

-- g) Matrícula de un coche, formato antiquísimo: una o dos letras (según provincia), un guion y entre un número y seis.

select 'CO-000001' regexp '^[A-Z]{1,2}-[0-9]{1,6}$';