const {PKPass} = require("passkit-generator");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
const admin = require("firebase-admin");
const storageRef = admin.storage().bucket();

const postTicket = async (request, response) => {
  try {
    if (!request.body || !request.body.description || !request.body.eventTicket.primaryFields) {
      return response.status(400).send({error: "El cuerpo de la solicitud debe incluir 'description' y 'eventTicket.primaryFields'."});
    }

    // Cargar certificados
    const wwdr = fs.readFileSync(path.join(__dirname, "..", "certs", "wwdr.pem"), "utf8");
    const signerCert = fs.readFileSync(path.join(__dirname, "..", "certs", "signerCert.pem"), "utf8");
    const signerKey = fs.readFileSync(path.join(__dirname, "..", "certs", "signerKey.pem"), "utf8");
    const pass = await PKPass.from(
        {
          model: path.join(__dirname, "..", "models", "model.pass"),
          certificates: {
            wwdr,
            signerCert,
            signerKey,
            signerKeyPassphrase: "root", // Passphrase de la clave privada
          },
        },
        {
          description: request.body.description,
          organizationName: request.body.organizationName,
          // Pasar directamente los primaryFields desde eventTicket
        },
    );
    if (pass.type === "eventTicket") {
      if (Array.isArray(request.body.eventTicket.primaryFields)) {
      // Limpiamos los campos existentes
        pass.primaryFields = [];

        // Agregamos los nuevos valores proporcionados en la solicitud
        request.body.eventTicket.primaryFields.forEach((field) => {
          if (field.label && field.value) {
            console.log("firstField.key:", field.key);
            console.log("firstField.label:", field.label);
            console.log("firstField.value:", field.value);
            pass.primaryFields.push({
              key: field.key,
              label: field.label,
              value: field.value,
            });
          }
        });
      }
      if (Array.isArray(request.body.eventTicket.secondaryFields)) {
        pass.secondaryFields = [];
        request.body.eventTicket.secondaryFields.forEach((field) => {
          if (field.label && field.value) {
            console.log("firstField.key:", field.key);
            console.log("firstField.label:", field.label);
            console.log("firstField.value:", field.value);
            pass.secondaryFields.push({
              key: field.key,
              label: field.label,
              value: field.value,
            });
          }
        });
      }
    }

    // Generar un `passID` único usando los datos de la solicitud
    const allStrings = JSON.stringify(request.body); // Combinar todos los datos como un solo string
    const passID = crypto
        .createHash("md5")
        .update(`${allStrings}_${Date.now()}`) // Combinar con la marca de tiempo para asegurar unicidad
        .digest("hex");
    console.log("passID", passID);

    // Configurar los códigos de barras usando .setBarcodes()
    pass.setBarcodes({
      message: passID,
      format: "PKBarcodeFormatQR",
    });

    // pass.primaryFields.push({
    //   key: "staffName",
    //   label: "bb",
    //   value: "bb",
    // });
    /* primary fields */
    // if (request.body.primaryFields) {
    //   const {key,label, value } = request.body.primaryFields;
    //   pass.primaryFields.push( { key , label, value });
    // }

    /* primary fields */
    /* if (request.body.primaryFields) {
        const {key,label, value } = request.body.primaryFields;
        pass.primaryFields = [{ key , label, value }];
    } */
    // Crear una carpeta para el pase usando el organizationName
    const organizationName = request.body.organizationName.replace(/[^a-z0-9]/gi, "_").toLowerCase();
    const passDir = path.join(__dirname, "..", "passes", organizationName);
    if (!fs.existsSync(passDir)) {
      fs.mkdirSync(passDir, {recursive: true});
    }
    // Generar el pase
    const buffer = pass.getAsBuffer();
    // Guardar el pase en la carpeta creada
    const passPath = path.join(passDir, `${passID}.pkpass`);
    fs.writeFileSync(passPath, buffer);
    // Enviar el pase al cliente
    response.set("Content-Type", "application/vnd.apple.pkpass");
    response.status(200).send(buffer);
    storageRef.file(`passes/${organizationName}/${passID}.pkpass`).save(buffer, (error) => {
      if (error) {
        console.error("Error guardando el pase:", error);
      } else {
        console.log("Pase guardado en Cloud Storage");
        response.status(200).send({success: "Pase guardado en Cloud Storage"});
      }
    });
  } catch (err) {
    console.error("Error creando el pase:", err);
    response.status(500).send({error: err.message});
  }
};

module.exports = {
  postTicket,
};
