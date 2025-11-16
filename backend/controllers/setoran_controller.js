const db = require("../config/db");

const loadSetoranById = async (req, res) => {
  const { id_santri } = req.query;

  // try {
  //   const setoran = await Setoran.find({
  //     id_santri: new mongoose.Types.ObjectId(id_santri),
  //   }).sort({tanggal:-1});

  //   if (!setoran) {
  //     res.status(404).send("No Setoran Found");
  //   }

  //   res.status(200).json(setoran);
  // } catch (e) {
  //   res.status(500).send("Error retrieving setoran from database" + e);
  // }

  db.query(
    "SELECT id_setoran, id_santri, DATE_FORMAT(tanggal, '%Y-%m-%d') AS tanggal, jam, id_surah_mulai, ayat_mulai, id_surah_akhir, ayat_akhir FROM setoran_santri WHERE id_santri = ? ORDER BY tanggal DESC, jam ASC",
    [id_santri],
    (err, result) => {
      if (err) {
        res
          .status(500)
          .send("Error retrieving setoran santri from database " + err);
      }

      res.json(result);
    }
  );
};

const addSetoran = async (req, res) => {
  const {
    id_santri,
    tanggal,
    jam,
    id_surah_mulai,
    ayat_mulai,
    id_surah_akhir,
    ayat_akhir,
  } = req.body;

  const [hari, bulan, tahun] = tanggal.split("-");
  const formattedDate = `${tahun}-${bulan}-${hari}`;

  db.query(
    "INSERT INTO setoran_santri(id_santri,tanggal,jam,id_surah_mulai,ayat_mulai,id_surah_akhir,ayat_akhir) VALUES(?,?,?,?,?,?,?)",
    [
      id_santri,
      formattedDate,
      jam,
      id_surah_mulai,
      ayat_mulai,
      id_surah_akhir,
      ayat_akhir,
    ],
    (err, result) => {
      if (err) {
        res
          .status(500)
          .json({ message: `Error memasukkan setoran ke database: ${e}` });
      } else {
        res.sendStatus(201);
      }
    }
  );

  // try {
  //   Setoran.create({
  //     tanggal: formattedDate,
  //     jam: jam,
  //     id_surah_mulai: id_surah_mulai,
  //     ayat_mulai: ayat_mulai,
  //     id_surah_akhir: id_surah_akhir,
  //     ayat_akhir: ayat_akhir,
  //     id_santri: new mongoose.Types.ObjectId(id_santri),
  //   });

  //   res.sendStatus(201);
  // } catch (e) {
  //   res.status(500).send("Error inserting setoran into database" + e);
  // }
};

const updateSetoran = async (req, res) => {
  const {
    id_setoran,
    tanggal,
    jam,
    id_surah_mulai,
    ayat_mulai,
    id_surah_akhir,
    ayat_akhir,
  } = req.body;

  const [hari, bulan, tahun] = tanggal.split("-");
  const formattedDate = `${tahun}-${bulan}-${hari}`;

  db.query(
    "UPDATE setoran_santri SET tanggal=?, jam=?, id_surah_mulai=?, ayat_mulai=?,id_surah_akhir=?,ayat_akhir=? WHERE id_setoran=?",
    [
      formattedDate,
      jam,
      id_surah_mulai,
      ayat_mulai,
      id_surah_akhir,
      ayat_akhir,
      id_setoran,
    ],
    (err, result) => {
      if (err) {
        return res
          .status(500)
          .json({ message: `Error update setoran santri: ${err}` });
      }

      if (result.affectedRows === 0) {
        return res
          .status(404)
          .json({ message: `Setoran santri id ${id_setoran} not found` });
      }

      res.sendStatus(200);
    }
  );

  // try{
  //   const existingSetoran=await Setoran.findById(id_setoran)

  //   existingSetoran.tanggal=formattedDate
  //   existingSetoran.jam=jam
  //   existingSetoran.id_surah_mulai=id_surah_mulai
  //   existingSetoran.ayat_mulai=ayat_mulai
  //   existingSetoran.id_surah_akhir=id_surah_akhir
  //   existingSetoran.ayat_akhir=ayat_akhir

  //   await existingSetoran.save()

  //   res.sendStatus(200)
  // }catch(e){
  //   res.status(500).json({message:`Error dalam mengupdate data setoran id: ${id_setoran}: ${e}`})
  // }
};

const deleteSetoran = async (req, res) => {
  const { id_setoran } = req.query;

  db.query(
    "DELETE FROM setoran_santri WHERE id_setoran=?",
    [id_setoran],
    (err, result) => {
      if (err) {
        return res
          .status(500)
          .json({
            message: `Error menghapus setoran santri id ${id_setoran}: ${err}`,
          });
      }

      if (result.affectedRows === 0) {
        return res
          .status(404)
          .json({ message: `Setoran santri id ${id_setoran} tidak ditemukan` });
      }

      res.sendStatus(200);
    }
  );

  // try{
  //   await Setoran.findByIdAndDelete(id_setoran)

  //   res.sendStatus(200)
  // }catch(e){
  //   res.status(500).json({messsage:`Error menghapus setoran dari database: ${e}`})
  // }
};

module.exports = { loadSetoranById, addSetoran, updateSetoran, deleteSetoran };
