import 'package:activites_management/home.dart';
import 'package:activites_management/liste_activites.dart';
import 'package:activites_management/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user; // L'utilisateur actuellement connecté
  int _currentIndex = 1; // Index actuel dans le BottomNavigationBar

  @override
  void initState() {
    super.initState();
    // Récupérer l'utilisateur actuellement connecté au lancement de la page
    _user = FirebaseAuth.instance.currentUser!;
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      // Logique pour naviguer vers la page "Ajouter Activité"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      // Logique pour naviguer vers la page "Profil" (déjà sur la page Profil)
    } else if (index == 2) {
      // Logique pour naviguer vers la page "Liste des Activités"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListeActivites()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _signOut(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(_user.photoURL ?? ''),
            ),
            SizedBox(height: 20.0),
            Text(
              'Nom d\'utilisateur: ${_user.displayName}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: ${_user.email}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'UID: ${_user.uid}',
              style: TextStyle(fontSize: 18.0),
            ),
            // Ajoutez d'autres informations de profil si nécessaire
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajouter Activité',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste des Activités',
          ),
        ],
      ),
    );
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
}
