module.exports = app => {
  const readings = require("../controllers/reading_controller.js");

  var router = require("express").Router();

  // Create a new Tutorial
  router.post("/", readings.create);

  // Retrieve all readings
  router.get("/", readings.findAll);

  // Retrieve 10 latest readings
  router.get("/latest10", readings.findLatest10);

  // Retrieve all published readings
  router.get("/published", readings.findAllPublished);

  // Retrieve a single Tutorial with id
  router.get("/:id", readings.findOne);

  // Update a Tutorial with id
  router.put("/:id", readings.update);

  // Delete a Tutorial with id
  router.delete("/:id", readings.delete);

  // Delete all readings
  router.delete("/", readings.deleteAll);

  app.use('/api/readings', router);
};