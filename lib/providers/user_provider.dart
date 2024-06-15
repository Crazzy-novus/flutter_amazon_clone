import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/models/user.dart';


class UserProvider extends ChangeNotifier {
  User _user = User (id: '', name: '', email: '', password: '', address: '', type: '', token: '', cart: []);

  User get user => _user;  // function to get user data

  void setUser (String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = User.fromJson(user.toJson());
    notifyListeners();
  }

}