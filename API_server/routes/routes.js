module.exports = app => {
  const readings = require("../controllers/reading_controller.js");

  var router = require("express").Router();

  // Create a new Reading
  router.post("/", readings.create);

  // Retrieve all readings
  router.get("/", readings.findAll);

  // Retrieve 5 latest readings
  router.get("/latest5", readings.findLatest5);

  // Retrieve all highest readings
  router.get("/highest", readings.findHighestHumidity);

  // Retrieve a single Reading with id
  router.get("/:id", readings.findOne);

  app.use('/api/readings', router);
};