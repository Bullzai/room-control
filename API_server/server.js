const express = require("express");
const multer = require('multer');
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, '/your/path/to/image/destination/')
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname)
  }
});
const upload = multer({ storage: storage });
const app = express();

// parse requests of content-type - application/json
app.use(express.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));

// simple route
app.get("/", (req, res) => {
  res.json({ message: "Welcome to V IoT." });
});

app.post('/upload', upload.single('image'), function (req, res, next) {
  console.log(req.file)
  res.send("done");
});
require("./routes/routes.js")(app);

// set port, listen for requests
const PORT = process.env.PORT || 25998;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});