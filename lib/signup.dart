import 'package:activites_management/composant/widget.dart';
import 'package:activites_management/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Importez Fluttertoast

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();

  // Ajoutez une fonction pour gérer l'inscription
  void _signUp() {
    String username = _usernameTextController.text;
    String email = _emailTextController.text;
    String password = _passwordTextController.text;

    // Vous pouvez ajouter ici la logique pour traiter l'inscription
    // (envoyer des données au serveur, enregistrer dans une base de données, etc.)

    // Affichez un toast pour indiquer que l'inscription n'est pas encore implémentée
    _showErrorToast("L'inscription n'est pas encore implémentée!", context);
  }

  void _showErrorToast(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("L'inscription n'est pas encore implémentée!"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Créer un compte",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF87CEEB),
              Color(0xFFADD8E6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child: Image(
                      image: AssetImage('assets/images/loisirs.jpg'),
                      fit: BoxFit.cover,
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                composantTextField(
                  "Entrer votre Nom",
                  Icons.person_outline,
                  false,
                  _usernameTextController,
                ),
                SizedBox(height: 20),
                composantTextField(
                  "Entrer votre login",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                SizedBox(height: 20),
                composantTextField(
                  "Entrer votre mot de passe",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Appeler la fonction _signUp lorsque le bouton est pressé
                    _signUp();
                    // Appeler la fonction _showToast lorsque le bouton est pressé
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue), // Couleur de fond du bouton
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Couleur du texte du bouton
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Rayon de bordure du bouton
                        // Vous pouvez ajuster ce rayon selon vos besoins
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(
                        4.0), // Ombre du bouton
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(fontSize: 18.0), // Taille du texte du bouton
                    ),
                  ),
                  child: Text('S\'inscrire'),
                ),
                SizedBox(height: 20),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Avez-vous déjà un compte?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            // Naviguer vers la page de création de compte (SignUp)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginEcran()),
            );
          },
          child: const Text(
            "Se connecter",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
