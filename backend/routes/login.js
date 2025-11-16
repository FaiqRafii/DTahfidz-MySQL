const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const {login}=require('../controllers/user_controller')

router.post("/", login);

module.exports = router;
//nanti ganti paka bcrypt buat hash password kalo udah selesai fitur ganti password
