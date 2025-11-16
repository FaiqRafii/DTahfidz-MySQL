const db=require('../config/db')

const getSantriByHalaqoh = (req, res) => {
  const { id_halaqoh } = req.query;

  // try {
  //   const santri = await Santri.find(
  //     { id_halaqoh: new mongoose.Types.ObjectId(id_halaqoh) },
  //     { _id: 1, nama: 1, id_halaqoh: 1,kelas:1}
  //   ).sort({nama:1});
  //   res.status(200).json(santri);
  // } catch (e) {
  //   res.status(500).send(`Error retrieving santri from database ${e}`);
  // }

  db.query("select id_santri,id_halaqoh,nama,kelas from santri where id_halaqoh=?",[id_halaqoh],(err,result)=>{
      if(err){
          res.status(500).send("Error retrieving santri from database " + err);
      }

      res.json(result)
  })
};

const insertSantri = async (req, res) => {
  const { nama, kelas, id_halaqoh } = req.body;
  // try {
  //   const santri = await Santri.create({
  //     nama: nama,
  //     kelas: kelas,
  //     id_halaqoh: new mongoose.Types.ObjectId(id_halaqoh),
  //   });

  //   res.sendStatus(201);
  // } catch (err) {
  //   res.status(500).send(`Error inserting halaqoh data into database: ${err}`);
  // }

  db.query('INSERT INTO santri(id_halaqoh,nama,kelas) VALUES(?,?,?)',[id_halaqoh,nama,kelas],(err,result)=>{
    if(err){
      res.status(500).json({message:`Error memasukkan santri: ${e}`})
    }else{
      res.sendStatus(201)
    }
  })
};

module.exports = { getSantriByHalaqoh, insertSantri };
