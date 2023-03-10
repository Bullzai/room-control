const Reading = require("../models/readings_model.js");

// Create and Save a new Reading
exports.create = (req, res) => {
  // Validate request
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  // Create a Reading
  const reading = new Reading({
    id: req.body.id,
    humidity: req.body.humidity,
    date: req.body.date
  });

  // Save Reading in the database
  Reading.create(reading, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Reading."
      });
    else res.send(data);
  });
};

// Retrieve all Readings from the database (with condition).
exports.findAll = (req, res) => {
  const title = req.query.title;

  Reading.getAll(title, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving readings."
      });
    else res.send(data);
  });
};

// Find the latest 5 readings
exports.findLatest5 = (req, res) => {
  const title = req.query.title;

  Reading.getLatest5(title, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving readings."
      });
    else res.send(data);
  });
};

exports.findHighestHumidity = (req, res) => {
  Reading.getHighestHumidity((err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving readings."
      });
    else res.send(data);
  });
};

// Find a single Reading with a id
exports.findOne = (req, res) => {
  Reading.findById(req.params.id, (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `No Reading found with id ${req.params.id}.`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving Reading with id " + req.params.id
        });
      }
    } else res.send(data);
  });
};