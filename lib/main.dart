import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulaire Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FormulaireScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Écran principal : Formulaire
// ─────────────────────────────────────────────────────────────
class FormulaireScreen extends StatefulWidget {
  const FormulaireScreen({super.key});

  @override
  State<FormulaireScreen> createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  // ── Clé du formulaire (pour la validation) ──────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Contrôleur pour récupérer le texte du TextField ─────────
  final TextEditingController _nomController = TextEditingController();

  // ── États des widgets booléens ───────────────────────────────
  bool _accepterConditions = false; // Checkbox
  bool _recevoirNotifications = false; // Switch

  // ── Données affichées après soumission ───────────────────────
  String? _nomSoumis;
  bool? _conditionsSoumises;
  bool? _notifSoumises;

  // ── Libération de la mémoire ─────────────────────────────────
  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  // ── Soumission du formulaire ─────────────────────────────────
  void _soumettre() {
    if (_formKey.currentState!.validate()) {
      if (!_accepterConditions) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Vous devez accepter les conditions !'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      setState(() {
        _nomSoumis = _nomController.text.trim();
        _conditionsSoumises = _accepterConditions;
        _notifSoumises = _recevoirNotifications;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Formulaire soumis avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Formulaire Flutter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section : Formulaire ──────────────────────────
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inscription',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── TextField : Nom ───────────────────
                      // TextEditingController : permet de lire/modifier la valeur
                      // validator : vérifie que le champ n'est pas vide
                      TextFormField(
                        controller: _nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom complet',
                          hintText: 'Entrez votre nom...',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        // Validation : champ obligatoire
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom est obligatoire';
                          }
                          return null; // null = pas d'erreur
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Checkbox : Accepter les conditions ──
                      // value  : état actuel (true/false)
                      // onChanged : appelé quand l'utilisateur clique
                      Row(
                        children: [
                          Checkbox(
                            value: _accepterConditions,
                            onChanged: (bool? newValue) {
                              setState(() {
                                // setState() déclenche un re-rendu
                                _accepterConditions = newValue ?? false;
                              });
                            },
                            activeColor: Colors.deepPurple,
                          ),
                          const Expanded(
                            child: Text(
                              "J'accepte les conditions d'utilisation",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ── Switch : Recevoir notifications ──────
                      // Fonctionne comme Checkbox mais avec un design toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recevoir les notifications',
                            style: TextStyle(fontSize: 15),
                          ),
                          Switch(
                            value: _recevoirNotifications,
                            onChanged: (bool newValue) {
                              setState(() {
                                _recevoirNotifications = newValue;
                              });
                            },
                            activeThumbColor: Colors.deepPurple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ── Bouton de soumission ─────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _soumettre,
                          icon: const Icon(Icons.send),
                          label: const Text(
                            'Soumettre',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Section : Affichage des données saisies (Bonus) ──
            if (_nomSoumis != null) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                color: Colors.deepPurple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.deepPurple.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Données saisies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const Divider(height: 20),
                      _ligneInfo('👤 Nom', _nomSoumis!),
                      _ligneInfo(
                        '📄 Conditions acceptées',
                        _conditionsSoumises! ? 'Oui ✅' : 'Non ❌',
                      ),
                      _ligneInfo(
                        '🔔 Notifications',
                        _notifSoumises! ? 'Activées ✅' : 'Désactivées ❌',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Widget helper : affiche une ligne label / valeur ─────────
  Widget _ligneInfo(String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(valeur),
        ],
      ),
    );
  }
}
