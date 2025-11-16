const express=require('express')
const router=express.Router()
const Santri=require('../models/santri')
const {insertSantri,getSantriByHalaqoh}=require('../controllers/santri_controller')

router.route('/').get(getSantriByHalaqoh).post(insertSantri)

module.exports=router