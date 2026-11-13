
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Email and password sign-up
  Future<UserCredential?> signupWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential =
          await _auth.createUserWithEmailAndPassword(
        email: emailAddress.trim(),
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Sign-up error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected sign-up error: $e');
      rethrow;
    }
  }

  // Email and password login
  Future<UserCredential?> signinWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String name,
  }) async {
    try {
      final credential =
          await _auth.signInWithEmailAndPassword(
        email: emailAddress.trim(),
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        // Create the user document if it doesn't exist.
        final userDocument =
            _firestore.collection('users').doc(user.uid);

        final snapshot = await userDocument.get();

        if (!snapshot.exists) {
          await userDocument.set({
            'vid': user.uid,
            'name': user.displayName ?? name,
            'email': user.email ?? emailAddress.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected login error: $e');
      rethrow;
    }
  }

  // Google sign-in / sign-up
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Open the Google account picker.
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      // Get the Google authentication token.
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // Create a Firebase credential.
      final OAuthCredential credential =
          GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Authenticate with Firebase.
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Save Google user information in Firestore.
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({
          'vid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Google authentication error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Google sign-in error: $e');
      rethrow;
    }
  }
}
