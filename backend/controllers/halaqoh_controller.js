const db=require('../config/db')

const addHalaqoh=async(req,res)=>{
    const {halaqoh,jumlah_santri,lokasi_halaqoh,id_user}=req.body

    db.query('INSERT INTO halaqoh(id_user,halaqoh,jumlah_santri,lokasi_halaqoh) VALUES(?,?,?,?)',[id_user,halaqoh,jumlah_santri,lokasi_halaqoh],(err,result)=>{
      if(err){
        return res.status(500).json({message:`Error memasukkan halaqoh ${halaqoh} ke database: ${err}`})
      }

      res.sendStatus(201)
    })

    // try{
    //     Halaqoh.create({
    //         halaqoh:halaqoh,
    //         jumlah_santri:jumlah_santri,
    //         lokasi_halaqoh:lokasi_halaqoh,
    //         id_user:new mongoose.Types.ObjectId(id_user)
    //     })

    //     res.sendStatus(201)
    // }catch(e){
    //     res.status(500).send("Error adding halaqoh into database "+e)
    // }
}

const getHalaqohByUser = async (req, res) => {
  const id_user = req.query.id_user;

  // try{
  //   const halaqoh = await Halaqoh.findOne(
  //       { id_user: id_user },
  //       {
  //         halaqoh: 1,
  //         jumlah_santri: 1,
  //         lokasi_halaqoh: 1,
  //         id_user:1,
  //         _id: 1
  //       }
  //     );
    
  //     if (!halaqoh) {
  //       res.status(400).send(`Halaqoh data not found`);
  //     }

  //   res.status(200).json(halaqoh);

  // }catch(err){
  //   res.status(500).send(`Error retrieving halaqoh data from database: ${err}`)
  // }

  db.query('SELECT id_halaqoh,id_user,halaqoh,jumlah_santri,lokasi_halaqoh FROM halaqoh WHERE id_user=?',[id_user],(err,result)=>{
      if(err){
          return res.status(500).send("Error retrieving halaqoh from database")
      }

      if (result.length > 0) {
        res.json(result[0]);
      } else {
        res.status(404).json({ message: "Not found" });
      }
      
  })
};



module.exports = { getHalaqohByUser , addHalaqoh};
