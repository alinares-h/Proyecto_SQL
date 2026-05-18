-- CONSULTAS SOLICITADAS EN EL PROYECTO INCLUIDAS A CONTINUACIÓN DE CADA ENUNCIADO

-- 1. Crea el esquema de la BBDD.
-- Se importa la base de datos facilitada (Proyecto_shakila) a través de la creación de una nueva BBDD y se establece por defecto de forma previa a la ejecución de cualquier consulta.

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
select title as "Título", rating as "Clasificación"
from film
where rating = 'R'
order by "Clasificación", "Título";

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
select actor_id, concat(first_name ,' ',last_name ) as "Nombre_actor"
from actor
where actor_id between 30 and 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select original_language_id 
from film
group by original_language_id;
/* Se hace una consulta de agrupación para ver cuáles son los idiomas originales en la tabla y se observa que no contiene datos (todos son nulos),
por lo que no se puede realizar esta consulta.*/

-- 5. Ordena las películas por duración de forma ascendente.
select film_id , title, length 
from film
order by length;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
select first_name , last_name 
from actor
where last_name like '%ALLEN%';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
select rating, count(film_id) as "Número_películas"
from film
group by rating;

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
select film_id, title 
from film
where rating = 'PG-13' or length > 180; -- El tiempo en el campo length viene en minutos por lo que el criterio que se incluye es mayor de 180.

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select round(avg(replacement_cost),2) as "Media", round(stddev(replacement_cost),2) as "Desaviación_estándar", round(variance(replacement_cost),2) as "Varianza"
from film; -- Se indica tanto la media como los dos principales indicadores estadísticos de dispersión (valores altos de en ambos, alta dispersión)

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select max(length) as "Duración_máxima", min(length) as "Duración_mínima"
from film;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select rental_id, amount, payment_date 
from payment
order by payment_date desc, rental_id  desc
limit 1 offset 2; 
/* Como el criterio de fecha es igual para varias operaciones, se ha ordenado también por operación descendente suponiendo que cuando más alto sea
el rental_id, más reciente es la operación. De esta forma se acota el criterio del limit.
*/

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.
select title 
from film
where rating not in ('NC-17', 'G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
select rating as "Clasificación", round(avg(length),0) as "Promedio_duración"
from film
group by rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select title
from film
where length > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
select SUM(amount)
from payment;

-- 16. Muestra los 10 clientes con mayor valor de id.
select customer_id, first_name, last_name 
from customer
order by customer_id desc
limit 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’
select a.first_name, a.last_name 
from actor a
where a.actor_id in (
	select fa.actor_id 
	from film f
	inner join film_actor fa
	on f.film_id = fa.film_id
	where f.title  = 'EGG IGBY'); -- Se utiliza una subconsulta para incluir los ID de los actores de la película.

-- 18. Selecciona todos los nombres de las películas únicos.
select distinct(title) 
from film;
	
-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
select f.film_id as "Título" ,f.length as "Duración" ,c."name" as "Categoría"
from film f 
	left join film_category fc 
	on f.film_id = fc.film_id 
	left join category c 
	on fc.category_id = c.category_id
where
c."name"= 'Comedy'
and
f.length > 180;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
select c."name" as "Categoría", round(AVG(f.length),0) as "Promedio_duración" 
from film f 
	left join film_category fc 
	on f.film_id = fc.film_id 
	left join category c 
	on fc.category_id = c.category_id
group by c."name"
having  AVG(f.length) > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
select avg(return_date - rental_date)
from rental;-- Utilizo la ayuda de una fórmula a través de consulta a IA porque el resultado de la diferencia y media no tiene sentido: 4días, 24horas, 36minutos...
select round(avg(extract(epoch from (return_date - rental_date)) / 3600),0) as "Tiempo_medio_alquiler(horas)"
from rental;--Con la fórmula, permite trabajar en horas. Se elimina la visualización de la parte decimal porque está en base 100 y así se evita confundir.

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select distinct(concat(first_name,' ', last_name)) as "Nombre_actores"
from actor
order by "Nombre_actores";

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select left(rental_date::text, 10) as "Fecha", count(rental_id) as "Cantidad_alquileres" --Me apoyo en una biblioteca para hacer funcionar el LEFT con un campo tipo Timestamp
from rental
group by left(rental_date::text, 10)
order by "Cantidad_alquileres" DESC;

-- 24. Encuentra las películas con una duración superior al promedio.
select title as "Título", length as "Duración"
from film
where length > (
	select avg(length)
	from film
	)
order by length DESC;

-- 25. Averigua el número de alquileres registrados por mes.
select extract(month from rental_date) as "Mes", count(rental_id) as "Número_alquileres"
from rental
group by extract(month from rental_date)
order by extract(month from rental_date);-- Me apoyo en biblioteca para extraer el mes del campo rental_date

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select round(avg(amount), 2) as "Valor_medio_pagos", round(stddev(amount),2) as "Desv_estándar_pagos", round(variance(amount),2) as "Varianza_pagos"
from payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
with resumen_peliculas as (
select p.rental_id, p.amount, r.inventory_id, i.film_id, f.title 
from payment p 
	left join rental r 
	on p.rental_id = r.rental_id
	left join inventory i 
	on r.inventory_id = i.inventory_id 
	left join film f 
	on i.film_id = f.film_id 
where p.amount > (
	select AVG(p.amount)
	from payment p)
order by p.rental_id
)
select title as "Títulos"
from resumen_peliculas
group by title
order by "Títulos" ;

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
select actor_id, count(film_id) as "Número_películas"
from film_actor
group by actor_id
having count(film_id) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible
with titulos_peliculas as (
select f.film_id, f.title as "Título"
from film f
),
inventario_peliculas as (
select i.film_id, count(i.inventory_id) as "Cantidad_Inventario"
from inventory i
group by i.film_id
)
select "Título", "Cantidad_Inventario"
from titulos_peliculas
left join inventario_peliculas
on titulos_peliculas.film_id = inventario_peliculas.film_id
;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
with actores as (
select actor_id as "ID", concat(first_name, ' ', last_name ) as "Nombre_actor"
from actor
order by actor_id
),
peliculas as (
select actor_id, count(film_id) as "Número_de_películas"
from film_actor
group by actor_id
)
select "ID","Nombre_actor","Número_de_películas" 
from actores
left join peliculas
on "ID"  = peliculas.actor_id
;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
with titulos_peliculas as (
select film_id as "ID", title as "Nombre_película"
from film
),
lista_peliculas as (
select film_id, actor_id
from film_actor
order by film_id, actor_id
),
nombre_actores as (
select actor_id, concat(first_name, ' ', last_name ) as "Nombre_actor"
from actor
)
select "ID", "Nombre_película", "Nombre_actor" 
from titulos_peliculas
left join lista_peliculas
on "ID"  = lista_peliculas.film_id
left join nombre_actores
on lista_peliculas.actor_id = nombre_actores.actor_id
;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
with nombre_actores as (
select actor_id as "ID", concat(first_name, ' ', last_name ) as "Nombre_actor"
from actor
),
lista_peliculas as (
select actor_id, film_id
from film_actor
order by actor_id, film_id
),
titulos_peliculas as (
select film_id, title as "Nombre_película"
from film
)
select "ID", "Nombre_actor","Nombre_película"
from nombre_actores
left join lista_peliculas
on "ID"  = lista_peliculas.actor_id
left join titulos_peliculas
on lista_peliculas.film_id = titulos_peliculas.film_id
;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
create temporary table detalle_inventarios as
select i.film_id as "ID_película", i.inventory_id as "Número_inventario", count(r.rental_id) as "Nº_alquileres_inventario"
from inventory i
left join rental r
on i.inventory_id = r.inventory_id
group by i.film_id, i.inventory_id
order by i.film_id, i.inventory_id;

create temporary table alquiler_pelicula as
select "ID_película", SUM("Nº_alquileres_inventario") as "Nº_total_alquileres_película"
from detalle_inventarios
group by "ID_película"
order by "ID_película";-- Se utilizan tablas temporales para simplificar el cálculo del número de alquileres por inventario y por película.

select "detalle_inventarios"."ID_película", f.title as "Título_película", "detalle_inventarios"."Número_inventario", "detalle_inventarios"."Nº_alquileres_inventario",
"alquiler_pelicula"."Nº_total_alquileres_película"
from detalle_inventarios
left join alquiler_pelicula
on "detalle_inventarios"."ID_película" = "alquiler_pelicula"."ID_película"
left join film f 
on "detalle_inventarios"."ID_película" = f.film_id 
;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select p.customer_id as "ID_cliente", concat(c.first_name,' ',c.last_name) as "Nombre_cliente", SUM(p.amount) as "Gasto_total"
from payment p
left join customer c
on p.customer_id = c.customer_id 
group by p.customer_id, concat(c.first_name,' ',c.last_name)
order by "Gasto_total" desc
limit 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select actor_id, first_name, last_name
from actor
where first_name = 'JOHNNY';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
select actor_id, first_name as "Nombre", last_name as "Apellido"
from actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select min(actor_id) as "actor_id_MIN", max(actor_id) as "actor_id_MAX"
from actor;

-- 38. Cuenta cuántos actores hay en la tabla “actor”
select count(actor_id) as "Número_total_actores"
from actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select actor_id, first_name as "Nombre", last_name as "Apellido"
from actor
order by "Apellido", "Nombre";

-- 40. Selecciona las primeras 5 películas de la tabla “film”
select film_id, title
from film
limit 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select first_name as "Nombre_actor", count(actor_id) as "Número_actores"
from actor
group by first_name
order by "Número_actores" DESC; -- Hay 3 nombres que son los más repetidos: Kenneth, Penelope, Julia

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r.rental_id, concat(c.first_name, ' ', c.last_name) as "Nombre_cliente"
from rental r
left join customer c
on r.customer_id = c.customer_id;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select c.customer_id as "ID_cliente", concat(c.first_name, ' ', c.last_name) as "Nombre_cliente", r.rental_id as "Número_alquiler"
from customer c
left join rental r
on c.customer_id = r.customer_id 
group by c.customer_id, concat(c.first_name, ' ', c.last_name), r.rental_id 
order by "ID_cliente", "Número_alquiler";

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select *
from film f
cross join category c;
-- No porque las películas tienen una única ategoría a través de la tabla film_category, por lo que construir una tabla con todos los géneros por película no tiene sentido.

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
with categoria_peliculas as (
	select f.film_id as "ID_pelicula", f.title as "Nombre_pelicula", fc.category_id as "Categoria_pelicula", c."name" as "Nombre_categoria"
	from film f
	left join film_category fc
	on f.film_id = fc.film_id 
	left join category c 
	on fc.category_id = c.category_id
	where c."name" = 'Action'
),
actores_peliculas as(
	select f.film_id as "ID_pelicula", fa.actor_id as "ID_actor", concat(a.first_name, ' ',a.last_name) as "Nombre_actor"
	from film f
	left join film_actor fa
	on f.film_id = fa.film_id 
	left join actor a
	on fa.actor_id = a.actor_id
	order by f.film_id, fa.actor_id
)
select categoria_peliculas."ID_pelicula", categoria_peliculas."Nombre_pelicula", categoria_peliculas."Nombre_categoria", actores_peliculas."Nombre_actor" 
from categoria_peliculas
inner join actores_peliculas
on categoria_peliculas."ID_pelicula" = actores_peliculas."ID_pelicula" 
;

-- 46. Encuentra todos los actores que no han participado en películas.
select a.actor_id as "ID_actor", concat(a.first_name, ' ', a.last_name) as "Nombre_actor", count(fa.film_id) as "Numero_peliculas"
from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
group by a.actor_id, concat(a.first_name, ' ', a.last_name)
having count(fa.film_id) = 0;

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select concat(a.first_name, ' ', a.last_name) as "Nombre_actor", count(fa.film_id) as "Numero_peliculas"
from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
group by a.actor_id, concat(a.first_name, ' ', a.last_name)
order by "Nombre_actor";

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
create view "actor_num_peliculas" as
	select concat(a.first_name, ' ', a.last_name) as "Nombre_actor", count(fa.film_id) as "Numero_peliculas"
	from actor a
	left join film_actor fa
	on a.actor_id = fa.actor_id
	group by a.actor_id, concat(a.first_name, ' ', a.last_name)
	order by "Nombre_actor"
;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select r.customer_id as "ID_cliente", concat(c.first_name, ' ',c.last_name) as "Nombre_cliente",count(r.rental_id) as "Número_alquileres"
from rental r
left join customer c 
on r.customer_id = c.customer_id 
group by r.customer_id,concat(c.first_name, ' ',c.last_name)
order by r.customer_id;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select f.film_id as "ID_pelicula", f.title as "Titulo_pelicula", f.length as "Duración (min)", c."name" as "Categoría"
from film f
left join film_category fc 
on f.film_id = fc.film_id
left join category c 
on fc.category_id = c.category_id
where c."name" = 'Action';

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
create temporary table cliente_rentas_temporal as
	select r.customer_id as "ID_cliente", concat(c.first_name, ' ',c.last_name) as "Nombre_cliente",count(r.rental_id) as "Número_alquileres"
	from rental r
	left join customer c 
	on r.customer_id = c.customer_id 
	group by r.customer_id,concat(c.first_name, ' ',c.last_name)
	order by r.customer_id
;
select *
from cliente_rentas_temporal;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
create temporary table peliculas_alquiladas as
	select i.film_id as "ID_película", f.title as "Título_película", count(r.rental_id) as "Nº_total_alquileres"
	from inventory i
	left join rental r
	on i.inventory_id = r.inventory_id
	left join film f 
	on i.film_id = f.film_id
	group by i.film_id, f.title
	having count(r.rental_id) > 9
	order by i.film_id
;
select *
from peliculas_alquiladas;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
select f.title as "Título_película"
from rental r
left join customer c 
on r.customer_id = c.customer_id
left join inventory i 
on r.inventory_id = i.inventory_id 
left join film f 
on i.film_id = f.film_id 
where r.return_date is null and concat(c.first_name, ' ', c.last_name) = 'TAMMY SANDERS'
order by f.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
with datos_SciFi as (
	select f.title as "Título_película", c."name" as "Categoría", a.first_name as "Nombre_actor", a.last_name as "Apellido_actor"
	from film f 
	inner join film_category fc 
	on f.film_id = fc.film_id 
	inner join category c 
	on fc.category_id = c.category_id 
	inner join film_actor fa 
	on f.film_id = fa.film_id 
	inner join actor a 
	on fa.actor_id = a.actor_id
	where c."name" = 'Sci-Fi'
	order by a.first_name 
)
select datos_SciFi."Nombre_actor", datos_SciFi."Apellido_actor"
from datos_SciFi
group by datos_SciFi."Nombre_actor", datos_SciFi."Apellido_actor"
order by datos_SciFi."Apellido_actor";

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
create temporary table tabla_consolida as 
select a.first_name as "Nombre_Actor", a.last_name as "Apellido_Actor", r.rental_id,  max(r.rental_date) as "Fecha_alquila",
	(select min(r.rental_date) as "Fecha_ref"
	from rental r
	inner join inventory i
	on r.inventory_id = i.inventory_id
	inner join film f 
	on i.film_id = f.film_id
	where f.title = 'SPARTACUS CHEAPER') as "Fecha_spartacus"
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f 
on i.film_id = f.film_id
inner join film_actor fa 
on f.film_id = fa.film_id 
inner join actor a 
on fa.actor_id = a.actor_id
group by a.first_name, a.last_name, r.rental_id
order by "Apellido_Actor", "Nombre_Actor"; -- Se consolida la información en una sola tabla incluyendo la fecha de referencia de corte.

create temporary table tabla_consolida2 as
select *
from tabla_consolida
where tabla_consolida."Fecha_alquila" > tabla_consolida."Fecha_spartacus"; -- Se filtra para eliminar todos los registros por debajo de la fecha de corte.

select tabla_consolida2."Nombre_Actor", tabla_consolida2."Apellido_Actor"
from tabla_consolida2
group by tabla_consolida2."Nombre_Actor", tabla_consolida2."Apellido_Actor"
order by tabla_consolida2."Apellido_Actor";-- Finalmente se agrupa para obtener un solo registro por actor.

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
with categoria_peliculas as (
	select f.film_id as "ID_pelicula", f.title as "Nombre_pelicula", fc.category_id as "Categoria_pelicula", c."name" as "Nombre_categoria"
	from film f
	left join film_category fc
	on f.film_id = fc.film_id 
	left join category c 
	on fc.category_id = c.category_id
	where c."name" = 'Music'
),-- Primero se buscan las películas de la categoría Music
actores_peliculas as(
	select f.film_id as "ID_pelicula", fa.actor_id as "ID_actor", concat(a.first_name, ' ',a.last_name) as "Nombre_actor"
	from film f
	left join film_actor fa
	on f.film_id = fa.film_id 
	left join actor a
	on fa.actor_id = a.actor_id
	order by f.film_id, fa.actor_id
),-- Segundo se buscan el total de los actores que han actuado en cada película
actores_music as(
	select actores_peliculas."Nombre_actor", categoria_peliculas."Nombre_categoria" 
	from categoria_peliculas
	inner join actores_peliculas
	on categoria_peliculas."ID_pelicula" = actores_peliculas."ID_pelicula" 
	group by actores_peliculas."Nombre_actor", categoria_peliculas."Nombre_categoria" 
	having actores_peliculas."Nombre_actor" <> ' '
	order by actores_peliculas."Nombre_actor" 
),-- Tercero se buscan los actores que han actuado en las películas con categoría Music
actores_total as(
	select concat(a.first_name, ' ',a.last_name) as "Nombre_actor"
	from actor a
)-- Cuarto se buscan el total de actores
select actores_total."Nombre_actor"
from actores_total
left  join actores_music
on actores_total."Nombre_actor" = actores_music."Nombre_actor"
where actores_music."Nombre_categoria" is null
order by actores_total."Nombre_actor"
-- Quinto se cruzan total de actores con los que han actuado en Music para seleccionar los que no
;

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
with dias_alquiler_titulo as (
	select r.rental_id, r.inventory_id, (r.return_date - r.rental_date ) as "Días_alquiler", i.film_id, f.title as "Título_película"
	from rental r
	left join inventory i 
	on r.inventory_id = i.inventory_id 
	left join film f 
	on i.film_id = f.film_id 
	where (r.return_date - r.rental_date ) > interval '8 days'
)
select dias_alquiler_titulo."Título_película"
from dias_alquiler_titulo
group by  dias_alquiler_titulo."Título_película"
order by  dias_alquiler_titulo."Título_película"
;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
select f.title as "Nombre_pelicula"
from film f
left join film_category fc
on f.film_id = fc.film_id 
left join category c 
on fc.category_id = c.category_id
group by f.title, c."name"
having c."name" = 'Animation'
order by "Nombre_pelicula";

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
select f.title as "Título_película"
from film f
where f.length = (
	select f.length 
	from film f
	where f.title = 'DANCING FEVER'
	)
order by f.title
;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
with cliente_peliculas as (
	select r.customer_id as "ID_cliente", c.first_name as "Nombre_cliente", c.last_name as "Apellido_cliente", i.film_id as "ID_película"
	from rental r
	inner join inventory i 
	on r.inventory_id = i.inventory_id
	inner join customer c 
	on r.customer_id = c.customer_id 
	group by r.customer_id, c.first_name, c.last_name, i.film_id
	order by r.customer_id
)
select cliente_peliculas."Nombre_cliente", cliente_peliculas."Apellido_cliente", count(cliente_peliculas."ID_película") as "Películas_distintas_alquiladas"
from cliente_peliculas
group by cliente_peliculas."Nombre_cliente", cliente_peliculas."Apellido_cliente"
having count(cliente_peliculas."ID_película") > 6
order by cliente_peliculas."Apellido_cliente", cliente_peliculas."Nombre_cliente";

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
with alquileres_categoria as (
	select r.inventory_id as "ID_inventario", i.film_id as "ID_pelicula", fc.category_id as "ID_categoria", c."name" as "Nombre_categoria", count(r.rental_id) as "Nº_alquileres"
	from rental r
	left join inventory i 
	on r.inventory_id = i.inventory_id
	left join film f 
	on i.film_id = f.film_id 
	left join film_category fc 
	on f.film_id = fc.film_id 
	left join category c 
	on fc.category_id = c.category_id 
	group by r.inventory_id, i.film_id,fc.category_id, c."name"
)
select alquileres_categoria."Nombre_categoria", sum(alquileres_categoria."Nº_alquileres") as "Nº_alquileres_categoria"
from alquileres_categoria
group by alquileres_categoria."Nombre_categoria"
order by alquileres_categoria."Nombre_categoria"
;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select  c."name" as "Nombre_categoria" , count(f.film_id) as "Nº_peliculas"
from film f
left join film_category fc 
on f.film_id = fc.film_id 
left join category c 
on fc.category_id = c.category_id
group by c."name", f.release_year 
having f.release_year = 2006
order by c."name";

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select s.store_id, s2.staff_id, concat(s2.first_name, ' ', s2.last_name) as "Nombre_staff"
from store s 
cross join staff s2;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select r.customer_id as "ID_cliente", concat(c.first_name, ' ', c.last_name) as "Nombre_cliente", count(r.rental_id) as "Nº_alquileres"
from rental r
left join customer c 
on r.customer_id = c.customer_id 
group by r.customer_id, concat(c.first_name, ' ', c.last_name)
order by r.customer_id;





























