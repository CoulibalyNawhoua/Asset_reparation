class Ticket {
  String code;
  String dPdv;
  DateTime createdAt;
  int status;
  String uuid;
  String dContact;
  String dTerritoire;
  String dLatitude;
  String dLongitude;

  Ticket({
    required this.code,
    required this.dPdv,
    required this.createdAt,
    required this.status,
    required this.uuid,
    required this.dContact,
    required this.dTerritoire,
    required this.dLatitude,
    required this.dLongitude,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    code: json["code"],
    dPdv: json["d_pdv"],
    createdAt: DateTime.parse(json["created_at"]),
    status: json["status"],
    uuid: json["uuid"],
    dContact: json["d_contact"],
    dTerritoire: json["d_territoire"],
    dLatitude: json["d_latitude"],
    dLongitude: json["d_longitude"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "d_pdv": dPdv,
    "created_at": createdAt.toIso8601String(),
    "status": status,
    "uuid": uuid,
    "d_contact": dContact,
    "d_territoire": dTerritoire,
    "d_latitude": dLatitude,
    "d_longitude": dLongitude,
  };
}

class Intervention {
  final String code;
  final int pointDeVenteId;
  final String? materielId;
  final String photoMateriel;
  final String photoMaterielTwo;
  final String noteCommercial;
  final int status;
  final String uuid;
  final String dCanal;
  final String dTerritoire;
  final String dPdvCategorie;
  final String dPdv;
  final String dContact;
  final String dAddresse;
  final String dLatitude;
  final String dLongitude;
  final String dPdvManager;
  final int typeInterventionId;
  final DateTime createdAt;
  final Materiel? materiel;
  final TypeIntervention typeIntervention;

  Intervention({
    required this.code,
    required this.pointDeVenteId,
    this.materielId,
    required this.photoMateriel,
    required this.photoMaterielTwo,
    required this.noteCommercial,
    required this.status,
    required this.uuid,
    required this.dCanal,
    required this.dTerritoire,
    required this.dPdvCategorie,
    required this.dPdv,
    required this.dContact,
    required this.dAddresse,
    required this.dLatitude,
    required this.dLongitude,
    required this.dPdvManager,
    required this.typeInterventionId,
    required this.createdAt,
    this.materiel,
    required this.typeIntervention,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      code: json['code'] ?? '',
      pointDeVenteId: json['pointdevente_id'],
      materielId: json['materiel_id'],
      photoMateriel: json['photo_materiel'] ?? '',
      photoMaterielTwo: json["photo_materiel_two"] ?? '',
      noteCommercial: json['note_commercial'] ?? '',
      status: json['status'],
      uuid: json['uuid'] ?? '',
      dCanal: json['d_canal'] ?? '',
      dTerritoire: json['d_territoire'] ?? '',
      dPdvCategorie: json['d_pdv_categorie'] ?? '',
      dPdv: json['d_pdv'] ?? '',
      dContact: json['d_contact'] ?? '',
      dAddresse: json['d_addresse'] ?? '',
      dLatitude: json['d_latitude'] ?? '',
      dLongitude: json['d_longitude'] ?? '',
      dPdvManager: json['d_pdv_manager'] ?? '',
      typeInterventionId: json['type_intervention_id'],
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      materiel: json['materiel'] != null ? Materiel.fromJson(json['materiel']) : null,
      typeIntervention: TypeIntervention.fromJson(json['type_intervention']),
    );
  }
}

class Materiel {
  final int id;
  final String numSerie;
  final int status;
  final String uuid;
  final String dateAcquisition;
  final int societeId;
  final String qrcodePath;
  final String materielId;
  final MaterielDetails materielDetails;

  Materiel({
    required this.id,
    required this.numSerie,
    required this.status,
    required this.uuid,
    required this.dateAcquisition,
    required this.societeId,
    required this.qrcodePath,
    required this.materielId,
    required this.materielDetails,
  });

  factory Materiel.fromJson(Map<String, dynamic> json) {
    return Materiel(
      id: json['id'],
      numSerie: json['num_serie'],
      status: json['status'],
      uuid: json['uuid'],
      dateAcquisition: json['date_acquisition'],
      societeId: json['societe_id'],
      qrcodePath: json['qrcode_path'],
      materielId: json['materiel_id'],
      materielDetails: MaterielDetails.fromJson(json['materiel']),
    );
  }
}

class MaterielDetails {
  final String code;
  final String libelle;
  final int categorieId;
  final int modeleId;
  final int fournisseurId;
  final int marqueId;
  final String image;
  final int prixAchat;
  final int capaciteId;
  final Categorie categorie;
  final Marque marque;
  final Modele modele;

  MaterielDetails({
    required this.code,
    required this.libelle,
    required this.categorieId,
    required this.modeleId,
    required this.fournisseurId,
    required this.marqueId,
    required this.image,
    required this.prixAchat,
    required this.capaciteId,
    required this.categorie,
    required this.marque,
    required this.modele,
  });

  factory MaterielDetails.fromJson(Map<String, dynamic> json) {
    return MaterielDetails(
      code: json['code'],
      libelle: json['libelle'],
      categorieId: json['categorie_id'],
      modeleId: json['modele_id'],
      fournisseurId: json['fournisseur_id'],
      marqueId: json['marque_id'],
      image: json['image'],
      prixAchat: json['prix_achat'],
      capaciteId: json['capacite_id'],
      categorie: Categorie.fromJson(json['categorie']),
      marque: Marque.fromJson(json['marque']),
      modele: Modele.fromJson(json['modele']),
    );
  }
}

class Categorie {
  final int id;
  final String libelle;

  Categorie({
    required this.id,
    required this.libelle,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      libelle: json['libelle'],
    );
  }
}

class Marque {
  final int id;
  final String libelle;

  Marque({
    required this.id,
    required this.libelle,
  });

  factory Marque.fromJson(Map<String, dynamic> json) {
    return Marque(
      id: json['id'],
      libelle: json['libelle'],
    );
  }
}

class Modele {
  final int id;
  final String libelle;

  Modele({
    required this.id,
    required this.libelle,
  });

  factory Modele.fromJson(Map<String, dynamic> json) {
    return Modele(
      id: json['id'],
      libelle: json['libelle'],
    );
  }
}

class TypeIntervention {
  final int id;
  final String libelle;

  TypeIntervention({
    required this.id,
    required this.libelle,
  });

  factory TypeIntervention.fromJson(Map<String, dynamic> json) {
    return TypeIntervention(
      id: json['id'],
      libelle: json['libelle'],
    );
  }
}
