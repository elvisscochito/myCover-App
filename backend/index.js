const functions = require("firebase-functions")
const PKPass = require("passkit-generator")
const admin = require("firebase-admin")
var fs = require("file-system")
var path = require("path")
var axios = require("axios")

/* init */
admin.initializeApp({

})

const express = require("express")

const app = express()

app.set("port", process.env.PORT || 3000)
const PORT = app.get("port")

app.get("/", (req, res) => {
    res.send("Hello world!")
})

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`)
})
