const mongoose=require('mongoose')
const { Types } = require('mysql2')

const Schema=mongoose.Schema

const presensi_santriSchema=new Schema({
    tanggal:{
        type:Date,
        required:true
    },
    jam:{
        type:String,
        required:true
    },
    status:{
        type:String,
        required:true
    },
    id_santri:{
        type:Schema.Types.ObjectId,
        ref:'Santri',
        required:true
    }
},
{timestamps:true}
)

module.exports=mongoose.model("PresensiSantri",presensi_santriSchema)