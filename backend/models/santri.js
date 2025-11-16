const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const santriSchema = new Schema({
  nama: {
    type: String,
    required: true,
  },
  kelas: {
    type: String,
  },
  id_halaqoh: {
    type: Schema.Types.ObjectId,
    ref: "Halaqoh",
    required: true,
  },
},
{timestamps:true});

module.exports = mongoose.model("Santri", santriSchema);
