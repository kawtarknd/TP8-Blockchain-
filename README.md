# 🚀 DApp "Hello World" - Flutter & Ethereum (Ganache)

Ce projet est une application décentralisée (DApp) simple développée avec **Flutter** (pour l'interface utilisateur multiplateforme) et connectée à un smart contract Ethereum déployé localement sur **Ganache**.

Cette DApp démontre la lecture (view) et l'écriture (transaction) de données sur une blockchain via la librairie Dart **`web3dart`**.

---

## I. Résultat Final et Démonstration

Le test final montre que tous les problèmes de configuration et de décodage (notamment le célèbre `RangeError: Value not in range: 32`) ont été résolus.

### Application Fonctionnelle sur le Bureau
L'application se connecte, lit la variable `bytes32` du contrat, la décode et affiche le nom.

| État Initial (Lecture) | État Final (Après Transaction) |
| :---: | :---: |
| ![Interface utilisateur affichant "Hello kawtar".](Capture%20d'%C3%A9cran%202025-12-07%20161342.png) | **Succès :** L'application a lu et décodé le nom mis à jour, confirmant la stabilité de la connexion et du décodage. |

### Confirmation Blockchain (Ganache)
Le journal des transactions confirme le cycle complet de vie du contrat : création, et appels multiples.

![Journal des transactions Ganache montrant la création du contrat et les appels ultérieurs pour lire/écrire le nom.](Capture%20d'%C3%A9cran%202025-12-07%20155659.jpg)
*Notez la **CONTRACT CREATION** et les **CONTRACT CALL** sur le Network ID **5777**.*

---

## II. Les Défis Techniques Clés (Processus de Débogage)

Ce projet a nécessité de résoudre des problèmes complexes d'environnement et de compatibilité.

### 1. Problèmes de Compatibilité Web3dart

* **Problème initial :** L'application se bloquait sur un indicateur de chargement  ou générait un **`RangeError`** lors de la lecture du contrat.
* **Solution critique :** Nous avons mis à jour la librairie `web3dart` à la version `^3.0.1` et, surtout, nous avons modifié le contrat **`HelloWorld.sol`** pour utiliser le type statique **`bytes32`** au lieu de `string` afin de stabiliser le décodage en Dart.

### 2. Résolution des Erreurs de Compilation (Gradle)

Des erreurs de compilation persistantes étaient dues à une syntaxe Kotlin DSL incorrecte et à des configurations non standard dans le fichier `android/build.gradle.kts`.

* **Erreur typique :** `Script compilation error: Line 21: tasks.register<Delete>("clean") { ^ Expecting an element` .
* **Solution :** Correction manuelle de la syntaxe et réinitialisation de la configuration Gradle aux valeurs standard.

### 3. Cycle de Déploiement

Chaque correction nécessitait un cycle de déploiement strict pour mettre à jour l'ABI lu par Flutter :

1.  Mise à jour des dépendances et du code Dart. 2.  Déploiement du contrat (mis à jour en `bytes32`) : `truffle migrate --reset`. 
---

## III. Utilisation du Projet

### 1. Prérequis

* Ganache (ou tout réseau Ethereum local)
* Node.js et Truffle
* Flutter SDK (avec support Windows Desktop configuré)

### 2. Lancement

1.  Assurez-vous que **Ganache** est lancé.
2.  Exécutez la migration (si le contrat a été modifié) : `truffle migrate --reset`
3.  Lancez l'application en ciblant Windows Desktop :
    ```bash
    flutter run
    ```
    (Sélectionnez **Windows (windows)**)

La DApp se connectera automatiquement pour lire l'état initial du contrat.
