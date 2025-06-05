const express = require('express');
const mysql = require('mysql2');
const os = require('os');
const app = express();
const port = 3000;

// Middleware
app.use(express.json());

// Configuración de base de datos con retry
function createConnection() {
  return mysql.createConnection({
    host: 'mysql',
    user: 'root',
    password: 'password',
    database: 'testdb',
    acquireTimeout: 60000,
    timeout: 60000,
  });
}

let db;

function handleDisconnect() {
  db = createConnection();
  
  db.connect((err) => {
    if (err) {
      console.log('Error connecting to database. Retrying in 5 seconds...');
      setTimeout(handleDisconnect, 5000);
    } else {
      console.log('Connected to MySQL database');
    }
  });
  
  db.on('error', (err) => {
    console.log('Database error', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
      handleDisconnect();
    } else {
      throw err;
    }
  });
}

handleDisconnect();

// Rutas
app.get('/', (req, res) => {
  res.json({
    message: 'Docker Lab - Aplicación funcionando correctamente',
    timestamp: new Date().toISOString(),
    container_id: os.hostname(), // Este mostrará el ID del contenedor
    hostname: os.hostname(),
    version: '1.0.0',
    status: 'active'
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    database: db.state === 'authenticated' ? 'connected' : 'disconnected',
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    container_id: os.hostname(), // Agregar container_id aquí también
    hostname: os.hostname()
  });
});

app.get('/users', (req, res) => {
  db.query('SELECT * FROM users', (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      res.status(500).json({ 
        error: 'Database error', 
        details: err.message,
        container_id: os.hostname()
      });
    } else {
      res.json({
        users: results,
        count: results.length,
        container_id: os.hostname(),
        hostname: os.hostname(),
        served_by: `Container ${os.hostname()}`
      });
    }
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Aplicación ejecutándose en puerto ${port}`);
  console.log(`Container ID: ${os.hostname()}`); // Cambiar a os.hostname()
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});