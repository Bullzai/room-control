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

    // not found reading with the id
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

Reading.getLatest10 = (id, result) => {
  let query = "SELECT * FROM readings ORDER BY DATE DESC LIMIT 10";

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

Reading.getAllPublished = result => {
  sql.query("SELECT * FROM readings WHERE published=true", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("readings: ", res);
    result(null, res);
  });
};

// Reading.updateById = (id, reading, result) => {
//   sql.query(
//     "UPDATE readings SET title = ?, humidity = ?, published = ? WHERE id = ?",
//     [reading.title, reading.humidity, reading.published, id],
//     (err, res) => {
//       if (err) {
//         console.log("error: ", err);
//         result(null, err);
//         return;
//       }

//       if (res.affectedRows == 0) {
//         // not found Tutorial with the id
//         result({ kind: "not_found" }, null);
//         return;
//       }

//       console.log("updated tutorial: ", { id: id, ...tutorial });
//       result(null, { id: id, ...tutorial });
//     }
//   );
// };

Reading.remove = (id, result) => {
  sql.query("DELETE FROM readings WHERE id = ?", id, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      // not found Tutorial with the id
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted tutorial with id: ", id);
    result(null, res);
  });
};

Reading.removeAll = result => {
  sql.query("DELETE FROM readings", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log(`deleted ${res.affectedRows} readings`);
    result(null, res);
  });
};

module.exports = Reading;