const bcrypt = require("bcrypt");
const db = require("../config/db");

const createUser = async (req, res) => {
  let { email, password, nama, level } = req.body;

  password = bcrypt.hash(password, 10, async (err, encrypted) => {
    if (err) {
      return res.status(500).send("Error hashing password");
    }

    // const user = await Users.create({
    //   email: email,
    //   password: encrypted,
    //   nama: nama,
    //   level: level,
    // });

    db.query(
      "INSERT INTO user(email,password,nama,level) values(?,?,?,?)",
      [email, encrypted, nama, level],
      (err, result) => {
        if (err) {
          res
            .status(500)
            .json({ message: `Error memasukkan user baru: ${err}` });
        } else {
          res.sendStatus(201);
        }
      }
    );
  });
};

const changePassword = async (req, res) => {
  const { id_user, newPassword } = req.body;

  bcrypt.hash(newPassword,10,(err,encrypted)=>{
    if(err){
      return res.status(500).json({message:`Error hashing password: ${err}`})
    }

    db.query('UPDATE user SET password=? WHERE id_user=?',[encrypted,id_user],(err,result)=>{
      if(err){
        return res.status(500).json({message:`Error update user id: ${id_user}: ${err}`})
      }

      if(result.affectedRows===0){
        return res.status(404).json({message:'User not found'})
      }

      res.sendStatus(200)
    })
  })

  // const existingUser = await Users.findById(
  //   new mongoose.Types.ObjectId(id_user)
  // );

  // const encryptedPassword = await bcrypt.hash(newPassword, 10);

  // existingUser.password = encryptedPassword;

  // await existingUser.save();

  // res.sendStatus(200);
};

const login = async (req, res) => {
  const { email, password } = req.body;

  // try{
  //     const user=await Users.findOne({email:email},{_id:1,email:1,password:1,nama:1,level:1})

  //     if(!user){
  //         res.status(404).send("User not found")
  //     }

  //     bcrypt.compare(password, user.password,(err,same)=>{
  //         if(err){
  //             return res.status(500).send("Error comparing password");
  //         }
  //         if(!same){
  //             return res.status(401).send("Incorrect password");
  //         }
  //         res.status(200).json(user)
  //     })
  // }catch(e){
  //     res.status(500).send("Error on login from database")
  // }

  db.query(
    `SELECT id_user,email,nama,password,level from user where email=?`,
    [email],
    (err, result) => {
      if (err) {
        return res.status(500).send("Error retrieving user from database");
      }

      if (result.length === 0) {
        return res.status(404).send("User not found");
      }

      const user = result[0];
      bcrypt.compare(password, user.password, (err, same) => {
        if (err) {
          return res.status(500).send("Error comparing password");
        }

        if (!same) {
          return res.status(401).send("Incorrect passowrd");
        }

        return res.status(200).json({"id_user":user.id_user,"email":user.email,"nama":user.nama,"level":user.level});
      });
    }
  );
};

module.exports = { createUser, login, changePassword };
