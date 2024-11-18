const functions = require("firebase-functions");
const { PKPass } = require("passkit-generator"); // Importa PKPass directamente desde el paquete
const fs = require("fs");
const path = require("path");
const axios = require("axios");

exports.pass = functions.https.onRequest(async (request, response) => {
    try {
      // Cargar certificados
      const wwdr = fs.readFileSync(path.join(__dirname, "certs", "wwdr.pem"), "utf8");
      const signerCert = fs.readFileSync(path.join(__dirname, "certs", "signerCert.pem"), "utf8");
      const signerKey = fs.readFileSync(path.join(__dirname, "certs", "signerKey.pem"), "utf8");
  
      // Crear un pase desde un modelo
      const pass = await PKPass.from(
        {
          model: path.join(__dirname, "glowTime.pass"),
          certificates: {
            wwdr,
            signerCert,
            signerKey,
            signerKeyPassphrase: "root", // Passphrase de la clave privada
          },
        },
        {
        description: request.body.description
    })

      /* primary fields */
      if (request.body.primaryFields) {
        const { label, value } = request.body.primaryFields;
        pass.primaryFields = [{ key: "staffName", label, value }];
      }
  
      // Generar el pase
      const buffer = pass.getAsBuffer();
      fs.writeFileSync(path.join(__dirname, "pass.pkpass"), buffer);
  
      // Enviar el pase al cliente
      response.set("Content-Type", "application/vnd.apple.pkpass");
      response.status(200).send(buffer);
    } catch (err) {
      console.error("Error creando el pase:", err);
      response.status(500).send({ error: err.message });
    }
  });
