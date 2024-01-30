CREATE TABLE "usuario" (
  "id" SERIAL PRIMARY KEY,
  "email" varchar UNIQUE NOT NULL,
  "nombre" varchar(50) NOT NULL,
  "apellido" varchar(50) NOT NULL,
  "rol" varchar(20),
  CONSTRAINT check_rol CHECK (rol='Usuario' OR rol='Administrador')
);

CREATE TABLE "post" (
  "id" SERIAL PRIMARY KEY,
  "titulo" varchar(20),
  "contenido" text,
  "fecha_creacion" timestamp DEFAULT 'now()',
  "fecha_actualizacion" timestamp DEFAULT 'now()',
  "destacado" boolean DEFAULT false,
  "usuario_id" int
);

CREATE TABLE "comentario" (
  "id" SERIAL PRIMARY KEY,
  "contenido" text,
  "fecha_creacion" timestamp DEFAULT 'now()',
  "usuario_id" int,
  "post_id" int
);

ALTER TABLE "post" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id");

ALTER TABLE "comentario" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id");

ALTER TABLE "comentario" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");


-- Primer insert usuario
insert into usuario
VALUES 
(1, 'correo1@correo.cl', 'Francisco', 'Meza', 'Administrador'),
(2, 'correo2@correo.cl', 'Daniel', 'Paredes', 'Usuario'),
(3, 'correo3@correo.cl', 'Alfredo', 'Paladin', 'Usuario'),
(4, 'correo4@correo.cl', 'Junior', 'Rodriguez', 'Usuario'),
(5, 'correo5@correo.cl', 'Shappi', 'Pastelito', 'Usuario');

-- Segunda de post
INSERT INTO public.post(
	id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
	VALUES (1, 'Como aprender', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.',
			default, default, default, 1),
			(2, 'Como aprender', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.',
			default, default, default, 1),
			(3, 'Como aprender', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.',
			default, default, default, 2),
			(4, 'Como aprender', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.',
			default, default, default, 2),
			(5, 'Como aprender', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.',
			default, default, default,1);

-- Tercera de comentario
INSERT INTO public.comentario(
	id, contenido, fecha_creacion, usuario_id, post_id)
	VALUES 
	 (1, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.', default, 1, 1),
	 (2, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.', default, 2, 1),
	 (3, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.', default, 3, 1),
	 (4, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.', default, 1, 2),
	 (5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium.', default, 2, 2);

-- Requerimiento 2 
-- Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
-- nombre y email del usuario junto al título y contenido del post.
select tabla_usuario.nombre, tabla_usuario.email, tabla_post.titulo, tabla_post.contenido from usuario as tabla_usuario
join post as tabla_post on tabla_usuario.id = tabla_post.usuario_id

-- Muestra el id, título y contenido de los posts de los administradores.
--a. El administrador puede ser cualquier id.


select a.id, a.titulo, a.contenido from post a
join usuario b on b.id = a.usuario_id 
where b.rol = 'Administrador'

--Cuenta la cantidad de posts de cada usuario.
--a. La tabla resultante debe mostrar el id e email del usuario junto con la
--cantidad de posts de cada usuario.
select usuario.id, usuario.email, count(*) as count_post from post
join usuario on usuario.id = post.usuario_id
GROUP BY usuario.id, usuario.email;

-- requerimiento 5 Muestra el email del usuario que ha creado más posts.
--a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
select usuario.email, count(*) as count_post from post
join usuario on usuario.id = post.usuario_id
GROUP BY usuario.id, usuario.email
order by count_post desc
limit 1

-- requerimineto 6 Muestra la fecha del último post de cada usuario
select max(fecha_creacion) as maximo, usuario.nombre from post
join usuario on usuario.id = post.usuario_id
GROUP by usuario.nombre

-- req 7 Muestra el título y contenido del post (artículo) con más comentarios
select post.titulo, post.contenido, count(*) from post
join comentario on comentario.post_id = post.id
group by post.titulo, post.contenido
limit 1

-- req 8 Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--de cada comentario asociado a los posts mostrados, junto con el email del usuario
--que lo escribió.
select post.titulo, post.contenido, comentario.contenido as comentario_contenido, usuario.email as email from post
join comentario on post.id = comentario.post_id
join usuario on usuario.id = post.id

-- req 9 Muestra el contenido del último comentario de cada usuario.
SELECT DISTINCT ON (usuario_id)
  id,
  contenido,
  fecha_creacion,
  usuario_id
FROM comentario
ORDER BY usuario_id, fecha_creacion DESC;

-- req 10 Muestra los emails de los usuarios que no han escrito ningún comentario
select usuario.email from usuario
left join comentario on usuario.id = comentario.usuario_id
where comentario.contenido IS NULL

