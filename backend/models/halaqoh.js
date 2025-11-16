const mongoose=require('mongoose')

const Schema=mongoose.Schema

const halaqohSchema=new Schema({
    halaqoh:{
        type: String,
        required: true
    },
    jumlah_santri:{
        type: Number,
        required: true
    },
    lokasi_halaqoh:{
        type: String,
        required: true
    },
    id_user:{
        type:Schema.Types.ObjectId,
        ref:'Users',
        required:true
    }
},
{timestamps:true}
)

module.exports=mongoose.model('Halaqoh',halaqohSchema)