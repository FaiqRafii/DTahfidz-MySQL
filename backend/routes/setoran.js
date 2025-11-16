const express = require("express");
const router = express.Router();
const mongoose=require('mongoose')
const Setoran = require("../models/setoran");
const {loadSetoranById, addSetoran, updateSetoran, deleteSetoran}=require('../controllers/setoran_controller')
router
  .route("/")
  .get(loadSetoranById)
  .post(addSetoran)
  .put(updateSetoran)
  .delete(deleteSetoran)

module.exports = router;
