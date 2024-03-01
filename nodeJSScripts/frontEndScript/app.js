const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;

// API URL configuration using environment variable
const apiUrl = process.env.API_URL || 'https://jsonplaceholder.typicode.com/todos/1';

// API endpoint to fetch data and print as HTML response
app.get('/api/data', async (req, res) => {
  try {
    // Make a GET request to the API
    const response = await axios.get(apiUrl);

    // Print the API response as HTML
    const htmlResponse = `
      <html>
        <head>
          <title>API Response</title>
        </head>
        <body>
          <h1>API Response</h1>
          <pre>${JSON.stringify(response.data, null, 2)}</pre>
        </body>
      </html>
    `;

    // Send the HTML response
    res.send(htmlResponse);
  } catch (error) {
    console.error('Error fetching data from API:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
