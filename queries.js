//Imports required modules 
require("dotenv").config();

//Imports required modules
const pgp = require('pg-promise')();

//Sets up database connection
const db = pgp({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
  })

module.exports = {db};

console.log(process.env.DB_USERNAME)