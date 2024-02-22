import '../../data/models/auth_data.dart';

class AuthManager {
  Future<bool> login(String nomeDocumento, String numeroDocumento, String senha) async {
    if (nomeDocumento == AuthData.nomeDocumento &&
        numeroDocumento == AuthData.numeroDocumento &&
        senha == AuthData.senha) {
      return true;
    } else {
      return false;
    }
  }
}
