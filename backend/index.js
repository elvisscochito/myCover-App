import express from "express";
/* import { PKPass } from "passkit-generator"
import path from "path"
import fs from "file-system" */

import admin from "firebase-admin";
import serviceAccount from "path/to/serviceAccountKey.json";

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});


const app = express()

app.set("port", process.env.PORT || 3000)
const PORT = app.get("port")

app.get("/", (req, res) => {
    res.send("Hello world!")
})

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`)
})
