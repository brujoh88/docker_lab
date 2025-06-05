-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insertar datos de ejemplo
INSERT INTO users (name, email) VALUES 
('Gustavo Hernan Tiseira', 'ejemplo1@email.com'),
('Daiana Anahi Trejo', 'ejemplo2@email.com');