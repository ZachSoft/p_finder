import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:p_finder/Models/UserModel.dart';
import 'package:p_finder/Repositories/FirebaseRepository.dart';
import 'package:get_storage/get_storage.dart';
import 'package:p_finder/constants/Constants.dart';

class AuthController extends GetxController {
  final FirebaseRepository _firebaseRepo = Get.put(FirebaseRepository());
  final GetStorage storage = GetStorage();

  // Initialize with an empty user object.
  var currentUser =
      UserModel(uid: "", email: "", userType: "", profileImage: "",phoneNumber: '').obs;

  @override
  void onInit() {
    super.onInit();
    // Try to restore user from local storage.
    var storedUser = storage.read('user');
    if (storedUser != null) {
      try {
        currentUser.value = UserModel.fromJson(storedUser);
      } catch (e) {
        Helper.showError("Failed to load user: ${e.toString()}");
      }
    } else {
      // Optionally, you can also check FirebaseAuth.currentUser here.
      var firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // You might want to fetch additional user data from Firestore.
        _firebaseRepo.getUser(firebaseUser.uid).then((user) {
          currentUser.value = user;
          storage.write('user', user.toJson());
        });
      }
    }
  }

  Future<void> signup(String email, String password, String userType,
      {String? base64Image, phoneNumber}) async {
    try {
      UserCredential userCredential =
          await _firebaseRepo.signUp(email, password);
      // Create user model and store it in Firestore
      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        userType: userType,
        profileImage: base64Image ?? '',
        phoneNumber: phoneNumber,
      );
      await _firebaseRepo.createUser(user);
      currentUser.value = user;
      storage.write('user', user.toJson());
      Get.offAllNamed('/home');
    } catch (e) {
      Helper.showError(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseRepo.login(email, password);
      // Get user details from Firestore
      UserModel user = await _firebaseRepo.getUser(userCredential.user!.uid);
      currentUser.value = user;
      storage.write('user', user.toJson());
      Get.offAllNamed('/home');
    } catch (e) {
      Helper.showError(e.toString());
    }
  }

  Future<void> logout() async {
    await _firebaseRepo.logout();
    currentUser.value =
        UserModel(uid: "", email: "", userType: "", profileImage: "",phoneNumber: '');
    storage.remove('user');
    Get.offAllNamed('/login');
  }
}
