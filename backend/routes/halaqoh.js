const express = require("express");
const router = express.Router();
const Halaqoh = require("../models/halaqoh");
const {getHalaqohByUser, addHalaqoh}=require('../controllers/halaqoh_controller')

router.route("/").get(getHalaqohByUser).post(addHalaqoh);

module.exports = router;
