import 'dart:js';

import 'package:activites_management/composant/widget.dart';
import 'package:activites_management/home.dart';
import 'package:activites_management/liste_activites.dart';
import 'package:activites_management/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginEcran extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListeActivites()),
      );
      _showSuccessToast("Authentification réussie");
    } catch (e) {
      print('Erreur de connexion: $e');
      _showErrorToast("Erreur de connexion", context);
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorToast(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Erreur de connexion'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.1,
              20,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Bienvenue dans EventFlow",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Image(image: AssetImage('assets/images/login.jpg')),
                Container(
                  width: 200.0, // Set your desired width
                  height: 200.0, // Set your desired height
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

                SizedBox(height: 30),
                composantTextField(
                  "Entrer votre login",
                  Icons.person_outline,
                  false,
                  emailController,
                ),
                SizedBox(height: 20),
                composantTextField(
                  "Entrer votre Mot de passe",
                  Icons.lock_outline,
                  true,
                  passwordController,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await _signInWithEmailAndPassword(context);
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
                    // Vous pouvez ajouter d'autres propriétés ici selon vos besoins
                  ),
                  child: Text('Se connecter'),
                ),
                SizedBox(height: 30),
                signUpOption(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous n'avez pas de compte?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            // Naviguer vers la page de création de compte (SignUp)

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            );
          },
          child: const Text(
            "S'inscrire",
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
