const sql = require("./db.js");

// constructor
const Reading = function (reading) {
  this.id = reading.id;
  this.humidity = reading.humidity;
  this.date = reading.date;
};

Reading.create = (newReading, result) => {
  sql.query("INSERT INTO readings SET ?", newReading, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created reading: ", { id: res.insertId, ...newReading });
    result(null, { id: res.insertId, ...newReading });
  });
};

Reading.findById = (id, result) => {
  sql.query(`SELECT * FROM readings WHERE id = ${id}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found reading: ", res[0]);
      result(null, res[0]);
      return;
    }

    // reading with the id not found
    result({ kind: "not_found" }, null);
  });
};

Reading.getAll = (id, result) => {
  let query = "SELECT * FROM readings";

  if (id) {
    query += ` WHERE title LIKE '%${id}%'`;
  }

  sql.query(query, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("readings: ", res);
    result(null, res);
  });
};

Reading.getLatest5 = (id, result) => {
  let query = "SELECT * FROM readings ORDER BY DATE DESC LIMIT 5";

  sql.query(query, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("readings: ", res);
    result(null, res);
  });
};

Reading.getHighestHumidity = result => {
  sql.query("SELECT * FROM readings WHERE humidity > 75", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("readings: ", res);
    result(null, res);
  });
};

module.exports = Reading;