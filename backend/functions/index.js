const functions = require("firebase-functions");
const express = require("express");
const app = express();
const admin = require("firebase-admin");

admin.initializeApp();
app.get("/hello", (request, response) => {
  response.send("Hello, world!");
});

app.use(require("./routes/ticket.routes"));

exports.app = functions.https.onRequest(app);
