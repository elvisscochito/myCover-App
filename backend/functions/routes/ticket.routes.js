const {Router} = require("express");
const ticketController = require("../controllers/ticket.controller");
const router = new Router();

router.post("/api/postTicket", ticketController.postTicket);
module.exports = router;
