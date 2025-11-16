const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const Users=require('../models/users')
const {createUser}=require('../controllers/user_controller')

router.post("/", createUser)

module.exports=router
