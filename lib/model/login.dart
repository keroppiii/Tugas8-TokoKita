class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;
  String? message; 
  
  Login({this.code, this.status, this.token, this.userID, this.userEmail, this.message});
  
  factory Login.fromJson(Map<String, dynamic> obj) {
    if (obj['code'] == 200) {
      return Login(
        code: obj['code'],
        status: obj['status'],
        token: obj['data']['token'],
        userID: int.parse(obj['data']['user']['id'].toString()),
        userEmail: obj['data']['user']['email'],
      );
    } else {
      return Login(
        code: obj['code'],
        status: obj['status'],
        message: obj['data'], 
      );
    }
  }
}