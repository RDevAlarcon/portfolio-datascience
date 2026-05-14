-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
-- pedido.
-- CREACION DE BASE DE DATOS
CREATE DATABASE Desafio3_Ricardo_Alarcon_114;
--\c Desafio3_Ricardo_Alarcon_114 (esto es por si estamos en consola)
--seleccionamos la base de datos para crear tablas

-- CREACION DE TABLAS
-- TABLA USUARIOS
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR NOT NULL
);
-- TABLA POSTS
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL,
    destacado BOOLEAN NOT NULL,
    usuario_id BIGINT, 
    CONSTRAINT fk_posts_usuarios
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE CASCADE
);
-- TABLA COMENTARIOS
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    usuario_id BIGINT,
    post_id BIGINT,
    CONSTRAINT fk_comentarios_usuarios
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_comentarios_posts
        FOREIGN KEY (post_id)
        REFERENCES posts(id)
        ON DELETE CASCADE
);

-- Insertando datos de ejemplo

-- Tabla Usuarios
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('ricardoalarcon@desafiolatam.com', 'Ricardo', 'Alarcon', 'administrador'),
('analopez@desafiolatam.com', 'Ana', 'López', 'usuario'),
('juanperez@desafiolatam.com', 'Juan', 'Pérez', 'usuario'),
('sofiamartinez@desafiolatam.com', 'Sofía', 'Martínez', 'usuario'),
('carlosdias@desafiolatam.com', 'Carlos', 'Díaz', 'usuario');
SELECT * FROM usuarios;

-- Tabla Posts
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES
('Post Admin 1', 'Contenido del post 1', NOW(), NOW(), TRUE, 1),
('Post Admin 2', 'Contenido del post 2', NOW(), NOW(), FALSE, 1),
('Post User 1', 'Contenido del post 3', NOW(), NOW(), TRUE, 2),
('Post User 2', 'Contenido del post 4', NOW(), NOW(), FALSE, 3),
('Post sin usuario', 'Contenido del post 5', NOW(), NOW(), FALSE, NULL);
SELECT * FROM posts;

-- Tabla Comentarios
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Comentario 1', NOW(), 1, 1),
('Comentario 2', NOW(), 2, 1),
('Comentario 3', NOW(), 3, 1),
('Comentario 4', NOW(), 1, 2),
('Comentario 5', NOW(), 2, 2);
SELECT * FROM comentarios;

-- CONSULTAS SOLICITADAS EN EL DESAFIO

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
-- nombre y email del usuario junto al título y contenido del post

SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
INNER JOIN posts p ON u.id = p.usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores.
-- a. El administrador puede ser cualquier id.

SELECT p.id, p.titulo, p.contenido
FROM posts p
INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.
-- a. La tabla resultante debe mostrar el id e email del usuario junto con la
-- cantidad de posts de cada usuario.

-- INNER JOIN: solo usuarios que tienen posts (NO ES EL CORRECTO)
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios u
INNER JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- RIGHT JOIN: no muestra usuarios sin posts y puede dejar fuera 
-- usuarios si hay posts sin usuario (NO ES EL CORRECTO)
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios u
RIGHT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- LEFT JOIN: recomendado, muestra todos los usuarios incluso los que no tienen posts
-- (ESTE ES EL CORRECTO)
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 5. Muestra el email del usuario que ha creado más posts.
-- a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT u.email
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario.

SELECT u.id, u.email, MAX(p.fecha_creacion) AS ultima_fecha_post
FROM usuarios u
INNER JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT p.titulo, p.contenido
FROM posts p
INNER JOIN comentarios c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
-- de cada comentario asociado a los posts mostrados, junto con el email del usuario
-- que lo escribió.

SELECT p.titulo, p.contenido AS contenido_post, c.contenido AS contenido_comentario, u.email
FROM posts p
LEFT JOIN comentarios c ON p.id = c.post_id
LEFT JOIN usuarios u ON c.usuario_id = u.id
GROUP BY p.titulo, p.contenido, c.contenido, u.email
ORDER BY p.contenido;

-- 9. Muestra el contenido del último comentario de cada usuario.

SELECT u.email, c.contenido
FROM usuarios u
INNER JOIN comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (
    SELECT MAX(fecha_creacion)
    FROM comentarios
    WHERE usuario_id = u.id
);

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;