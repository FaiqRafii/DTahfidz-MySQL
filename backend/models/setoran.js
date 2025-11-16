const mongoose=require('mongoose')

const Schema=mongoose.Schema

const setoranSchema=new Schema({
    tanggal:{
        type:Date,
        required:true
    },
    jam:{
        type:String,
        required:true
    },
    id_surah_mulai:{
        type:Number,
        required:true
    },
    ayat_mulai:{
        type:Number,
        required:true
    },
    id_surah_akhir:{
        type:Number,
        required:true
    },
    ayat_akhir:{
        type:Number,
        required:true
    },
    id_santri:{
        type:Schema.Types.ObjectId,
        ref:'Santri',
        required:true
    }
},
{timestamps:true})

module.exports=mongoose.model('Setoran',setoranSchema)