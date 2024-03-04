const express = require('express');
const mysql = require('mysql');
// require('dotenv').config();

const app = express();
const port = 3000;

// MySQL database connection configuration using environment variables
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'your_username',
  password: process.env.DB_PASSWORD || 'your_password'
};

const dbName = process.env.DB_NAME || 'default_database';

const productsData = [
  { name: 'Product1', price: 19.99 },
  { name: 'Product2', price: 29.99 },
  { name: 'Product3', price: 39.99 },
];

const tableName = 'products';

const connection = mysql.createConnection(dbConfig);

// Connect to the MySQL server
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }

  console.log('Connected to MySQL server');

  // Check if the default database is initialized
  connection.query(`CREATE DATABASE IF NOT EXISTS ${dbName}`, (createDbErr) => {
    if (createDbErr) {
      console.error('Error creating database:', createDbErr);
    }

    // Switch to the default database
    connection.query(`USE ${dbName}`, (useDbErr) => {
      if (useDbErr) {
        console.error('Error switching to default database:', useDbErr);
      }

      // Check if 'products' table exists, create it if not
      connection.query(`CREATE TABLE IF NOT EXISTS ${tableName} (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), price DECIMAL(10, 2))`, (createTableErr) => {
        if (createTableErr) {
          console.error('Error creating products table:', createTableErr);
        }

        console.log('Database and table initialization complete');

        // Check if the products table is empty
  connection.query(`SELECT COUNT(*) AS count FROM ${tableName}`, (error, results, fields) => {
    if (error) {
      console.error('Error checking for existing rows: ' + error.stack);
      connection.end();
      return;
    }
    const rowCount = results[0].count;

    if (rowCount === 0) {
      // Insert rows into the products table
        connection.query(`INSERT INTO ${tableName} (name, price) VALUES ?`, [productsData.map(product => [product.name, product.price])], (err, res) => {
          if (err) {
            console.error('Error inserting rows: ' + err.stack);
          } else {
          console.log('Inserted ' + res.affectedRows + ' row(s) into products table');
        }
      });
    } else {
      console.log('Products table is not empty. No action taken.');
    }
  });


      });
    });
  });
});


// API endpoint to get products
app.get('/api/products', (req, res) => {
  connection.query('SELECT * FROM products', (queryErr, results) => {
    if (queryErr) {
      console.error('Error querying products:', queryErr);
      res.status(500).send('Internal Server Error');
      return;
    }
    const rowCount = results[0].count;

    if (rowCount === 0) {
      console.log(`The table ${tableName} is empty, time to insert some rows.`);
    } else {
      console.log(`The table ${tableName} has ${rowCount} row(s).`);
    }

    res.json(results);
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
