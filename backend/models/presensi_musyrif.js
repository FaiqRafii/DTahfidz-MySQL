const mongoose=require('mongoose')
const { Types } = require('mysql2')

const Schema=mongoose.Schema

const presensi_musyrifSchema=new Schema({
    tanggal:{
        type:Date,
        required:true
    },
    jam:{
        type:String,
        required:true
    },
    id_user:{
        type:Schema.Types.ObjectId,
        ref:'Users',
        required:true
    }
},
{timestamps:true}
)

module.exports=mongoose.model("PresensiMusyrif",presensi_musyrifSchema)