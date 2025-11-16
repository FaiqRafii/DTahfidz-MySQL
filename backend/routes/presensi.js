const express = require("express");
const router = express.Router();
const {addPresensiSantri,addPresensiMusyrif,loadPresensiSantri,loadPresensiMusyrif}=require('../controllers/presensi_controller')

router.route("/santri").get(loadPresensiSantri).post(addPresensiSantri)

router.route("/musyrif").get(loadPresensiMusyrif).post(addPresensiMusyrif)

module.exports = router;
