const express=require('express')
const { changePassword } = require('../controllers/user_controller')
const router=express.Router()

router.post('/change-password',changePassword)

module.exports=router;