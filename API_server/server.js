const express = require("express");
// const cors = require("cors");

const app = express();

// var corsOptions = {
//   origin: "http://localhost:25998"
// };

// app.use(cors(corsOptions));

// parse requests of content-type - application/json
app.use(express.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));

// simple route
app.get("/", (req, res) => {
  res.json({ message: "Welcome to V IoT." });
});

require("./routes/routes.js")(app);

// set port, listen for requests
const PORT = process.env.PORT || 25998;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});