import 'package:activites_management/home.dart';
import 'package:activites_management/profil.dart';
import 'package:flutter/material.dart';
import 'package:activites_management/login.dart';
import 'package:activites_management/models/model_activite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListeActivites extends StatefulWidget {
  @override
  _ListeActivitesState createState() => _ListeActivitesState();
}

class _ListeActivitesState extends State<ListeActivites> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Liste des activités',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.black,
            onPressed: () async {
              await _signOut(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activities').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur s\'est produite.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Aucune activité pour le moment.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final activityDetails = Activite.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
                );
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                  ),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection('activities')
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: EdgeInsets.all(16),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: GestureDetector(
                          onTap: () {
                            _afficherDetailsActivite(context, activityDetails);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              activityDetails.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            activityDetails.titre,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.attach_money),
                          Text(
                            '${activityDetails.prix.toStringAsFixed(2)}',
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.location_on),
                          Text(activityDetails.lieu),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: _currentIndex !=
              1 // Ne pas afficher la barre de navigation sur la page de profil
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _onNavBarItemTapped(index);
              },
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
            )
          : null, // Masquer la barre de navigation sur la page de profil
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListeActivites()),
      );
    }
  }

  void _showErrorToast(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
    } catch (e) {
      print('Erreur de déconnexion: $e');
      _showErrorToast("Erreur de déconnexion", context);
    }
  }

  void _afficherDetailsActivite(BuildContext context, Activite activite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails de l\'activité'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: activite.image.isNotEmpty
                      ? Image.network(
                          activite.image,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Titre: ${activite.titre}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Lieu: ${activite.lieu}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Catégorie: ${activite.categorie}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Prix: ${activite.prix.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Nombre minimal de participants : ${activite.nbr_min}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
