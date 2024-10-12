class User {
  int id;
  String useNom;
  String email;
  dynamic usePrenom;
  String phone;
  dynamic phoneTwo;
  dynamic useLieuNaissance;
  dynamic useDateNaissance;
  int societeId;
  dynamic sexe;
  dynamic emailVerifiedAt;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String uuid;
  List<Role> roles;

  User({
    required this.id,
    required this.useNom,
    required this.email,
    required this.usePrenom,
    required this.phone,
    required this.phoneTwo,
    required this.useLieuNaissance,
    required this.useDateNaissance,
    required this.societeId,
    required this.sexe,
    required this.emailVerifiedAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.uuid,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    useNom: json["use_nom"],
    email: json["email"],
    usePrenom: json["use_prenom"],
    phone: json["phone"],
    phoneTwo: json["phone_two"],
    useLieuNaissance: json["use_lieu_naissance"],
    useDateNaissance: json["use_date_naissance"],
    societeId: json["societe_id"],
    sexe: json["sexe"],
    emailVerifiedAt: json["email_verified_at"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    uuid: json["uuid"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "use_nom": useNom,
    "email": email,
    "use_prenom": usePrenom,
    "phone": phone,
    "phone_two": phoneTwo,
    "use_lieu_naissance": useLieuNaissance,
    "use_date_naissance": useDateNaissance,
    "societe_id": societeId,
    "sexe": sexe,
    "email_verified_at": emailVerifiedAt,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "uuid": uuid,
    "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
  };
}

class Role {
  int id;
  String name;
  String guardName;
  DateTime createdAt;
  DateTime updatedAt;
  Pivot pivot;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
    guardName: json["guard_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "guard_name": guardName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "pivot": pivot.toJson(),
  };
}

class Pivot {
  int modelId;
  int roleId;
  String modelType;

  Pivot({
    required this.modelId,
    required this.roleId,
    required this.modelType,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    modelId: json["model_id"],
    roleId: json["role_id"],
    modelType: json["model_type"],
  );

  Map<String, dynamic> toJson() => {
    "model_id": modelId,
    "role_id": roleId,
    "model_type": modelType,
  };
}
class UserResponse {
  String accessToken;
  String tokenType;
  User user;
  Societe societe;

  UserResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    required this.societe,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    user: User.fromJson(json["user"]),
    societe: Societe.fromJson(json["societe"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "user": user.toJson(),
    "societe": societe.toJson(),
  };
}

class Societe {
  int id;
  String name;
  String adresse;
  String tel;

  Societe({
    required this.id,
    required this.name,
    required this.adresse,
    required this.tel,
  });

  factory Societe.fromJson(Map<String, dynamic> json) => Societe(
    id: json["id"],
    name: json["name"],
    adresse: json["adresse"],
    tel: json["tel"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "adresse": adresse,
    "tel": tel,
  };
}
