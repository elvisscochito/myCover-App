/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

/* const {onRequest} = require("firebase-functions/v2/https"); */
const functions = require("firebase-functions")
const logger = require("firebase-functions/logger");
const PKPass = require("passkit-generator")
const admin = require("firebase-admin")
var fs = require("file-system")
var path = require("path")
var axios = require("axios")

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

/* exports.helloWorld = onRequest((request, response) => {
    logger.info("Hello logs!", {structuredData: true});
    response.send("Hello from Firebase!");
}); */

/* init */
/* admin.initializeApp({
    credential: admin.credential.applicationDefault()
}) */

exports.pass = functions.https.onRequest((request, response) => { 
    PKPass.from({
        model: "glowTime.pass",
        certificates: {
            wwdr: fs.readFileSync(path.join(__dirname, "certs", "wwdr.pem")),
            signerCert: fs.readFileSync(path.join(__dirname, "certs", "signerCert.pem")),
            signerKey: {
                keyFile: fs.readFileSync(path.join(__dirname, "certs", "signerKey.pem")),
                passphrase: "root"
            }
        }
    }/* ,

    {
        authenticationToken: "pass.me",
        webServiceURL: "https://glowtime-passbook.herokuapp.com/",
        serialNumber: "123456",
        description: "Glow Time",
    } */)

    .then(async (newPass) => {
        const resp = await axios.get(request.body.thumbnail, {responseType: "arraybuffer"})
        const buffer = Buffer.from(resp.data, "utf-8")
        const bufferData = newPass.getAsBuffer()
        storageRef.file("pass.pkpass").save(bufferData)
    })
})

/* const express = require("express")

const app = express()

app.set("port", process.env.PORT || 3000)
const PORT = app.get("port")

app.get("/", (req, res) => {
    res.send("Hello world!")
})

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`)
}) */
