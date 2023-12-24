import 'package:activites_management/composant/navbar.dart';
import 'package:activites_management/liste_activites.dart';
import 'package:activites_management/profil.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:activites_management/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titreController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController nbrMinController = TextEditingController();
  TextEditingController categorieController = TextEditingController();

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
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _addActivityToFirebase() {
    FirebaseFirestore.instance.collection('activities').add({
      'titre': titreController.text,
      'prix': double.parse(prixController.text),
      'image': imageController.text,
      'lieu': lieuController.text,
      'nbr_min': int.parse(nbrMinController.text),
      'categorie': categorieController.text,
    }).then((value) {
      titreController.clear();
      prixController.clear();
      imageController.clear();
      lieuController.clear();
      nbrMinController.clear();
      categorieController.clear();
      _showSuccessToast('Activité ajoutée avec succès');
    }).catchError((error) {
      print("Erreur d'ajout: $error");
      _showErrorToast("Erreur d'ajout d'activité", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EventFlow'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _signOut(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Ajouter une activité',
                style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              _buildTextField(titreController, 'Titre'),
              _buildTextField(prixController, 'Prix',
                  TextInputType.numberWithOptions(decimal: true)),
              _buildTextField(imageController, 'URL de l\'image'),
              _buildTextField(lieuController, 'Lieu'),
              _buildTextField(nbrMinController,
                  'Nombre minimum de participants', TextInputType.number),
              _buildTextField(categorieController, 'Catégorie'),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _addActivityToFirebase();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                ),
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // L'index actuel correspond à la page actuelle
        onTap: _onNavBarItemTapped,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      [TextInputType inputType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: labelText,
              border: OutlineInputBorder(),
            ),
            keyboardType: inputType,
          ),
        ],
      ),
    );
  }

  void _onNavBarItemTapped(int index) {
    if (index == 0) {
      // Logique pour naviguer vers la page "Ajouter Activité"
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      // Logique pour naviguer vers la page "Profil"
      // Remplacez '/profil' par le nom de votre route
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 2) {
      // Logique pour naviguer vers la page "Liste des Activités"
      // Aucune action nécessaire ici, car c'est la page actuelle
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListeActivites()),
      );
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      _showErrorToast("Déconnexion avec succès", context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginEcran(),
        ),
      );
      _showSuccessToast("Déconnexion avec succées");
    } catch (e) {
      print('Erreur de déconnexion: $e');
      _showErrorToast("Erreur de déconnexion", context);
    }
  }
}
