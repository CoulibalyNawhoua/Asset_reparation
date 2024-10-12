class Devis {
  int id;
  String libelle;
  String reference;
  int societeId;
  int interventionId;
  int category;
  String photo;
  int montant;
  int status;
  int addBy;
  DateTime createdAt;

  Devis({
    required this.id,
    required this.libelle,
    required this.reference,
    required this.societeId,
    required this.interventionId,
    required this.category,
    required this.photo,
    required this.montant,
    required this.status,
    required this.addBy,
    required this.createdAt,
  });

  factory Devis.fromJson(Map<String, dynamic> json) => Devis(
    id: json["id"],
    libelle: json["libelle"],
    reference: json["reference"],
    societeId: json["societe_id"],
    interventionId: json["intervention_id"],
    category: json["category"],
    photo: json["photo"],
    montant: json["montant"],
    status: json["status"],
    addBy: json["add_by"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle": libelle,
    "reference": reference,
    "societe_id": societeId,
    "intervention_id": interventionId,
    "category": category,
    "photo": photo,
    "montant": montant,
    "status": status,
    "add_by": addBy,
    "created_at": createdAt.toIso8601String(),
  };
}

class DetailDevis {
    int id;
    String libelle;
    String reference;
    int societeId;
    int interventionId;
    int category;
    String photo;
    dynamic commentaire;
    int montant;
    int status;
    int addBy;
    DateTime createdAt;
    Intervention intervention;

    DetailDevis({
        required this.id,
        required this.libelle,
        required this.reference,
        required this.societeId,
        required this.interventionId,
        required this.category,
        required this.photo,
        required this.commentaire,
        required this.montant,
        required this.status,
        required this.addBy,
        required this.createdAt,
        required this.intervention,
    });

    factory DetailDevis.fromJson(Map<String, dynamic> json) => DetailDevis(
        id: json["id"],
        libelle: json["libelle"],
        reference: json["reference"],
        societeId: json["societe_id"],
        interventionId: json["intervention_id"],
        category: json["category"],
        photo: json["photo"],
        commentaire: json["commentaire"],
        montant: json["montant"],
        status: json["status"],
        addBy: json["add_by"],
        createdAt: DateTime.parse(json["created_at"]),
        intervention: Intervention.fromJson(json["intervention"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "reference": reference,
        "societe_id": societeId,
        "intervention_id": interventionId,
        "category": category,
        "photo": photo,
        "commentaire": commentaire,
        "montant": montant,
        "status": status,
        "add_by": addBy,
        "created_at": createdAt.toIso8601String(),
        "intervention": intervention.toJson(),
    };
}

class Intervention {
    int id;
    String code;
    String dPdv;
    String dContact;
    String dAddresse;
    String dTerritoire;
    String dSecteur;
    int typeInterventionId;
    String materielId;
    TypeIntervention typeIntervention;
    Materiel materiel;

    Intervention({
        required this.id,
        required this.code,
        required this.dPdv,
        required this.dContact,
        required this.dAddresse,
        required this.dTerritoire,
        required this.dSecteur,
        required this.typeInterventionId,
        required this.materielId,
        required this.typeIntervention,
        required this.materiel,
    });

    factory Intervention.fromJson(Map<String, dynamic> json) => Intervention(
        id: json["id"],
        code: json["code"],
        dPdv: json["d_pdv"],
        dContact: json["d_contact"],
        dAddresse: json["d_addresse"],
        dTerritoire: json["d_territoire"],
        dSecteur: json["d_secteur"],
        typeInterventionId: json["type_intervention_id"],
        materielId: json["materiel_id"],
        typeIntervention: TypeIntervention.fromJson(json["type_intervention"]),
        materiel: Materiel.fromJson(json["materiel"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "d_pdv": dPdv,
        "d_contact": dContact,
        "d_addresse": dAddresse,
        "d_territoire": dTerritoire,
        "d_secteur": dSecteur,
        "type_intervention_id": typeInterventionId,
        "materiel_id": materielId,
        "type_intervention": typeIntervention.toJson(),
        "materiel": materiel.toJson(),
    };
}

class Materiel {
    int id;
    String numSerie;
    int status;
    String uuid;
    DateTime dateAcquisition;
    int societeId;
    String qrcodePath;
    String materielId;
    Article article;

    Materiel({
        required this.id,
        required this.numSerie,
        required this.status,
        required this.uuid,
        required this.dateAcquisition,
        required this.societeId,
        required this.qrcodePath,
        required this.materielId,
        required this.article,
    });

    factory Materiel.fromJson(Map<String, dynamic> json) => Materiel(
        id: json["id"],
        numSerie: json["num_serie"],
        status: json["status"],
        uuid: json["uuid"],
        dateAcquisition: DateTime.parse(json["date_acquisition"]),
        societeId: json["societe_id"],
        qrcodePath: json["qrcode_path"],
        materielId: json["materiel_id"],
        article: Article.fromJson(json["article"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "num_serie": numSerie,
        "status": status,
        "uuid": uuid,
        "date_acquisition": dateAcquisition.toIso8601String(),
        "societe_id": societeId,
        "qrcode_path": qrcodePath,
        "materiel_id": materielId,
        "article": article.toJson(),
    };
}

class Article {
    String code;
    String libelle;

    Article({
        required this.code,
        required this.libelle,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        code: json["code"],
        libelle: json["libelle"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "libelle": libelle,
    };
}

class TypeIntervention {
    int id;
    String libelle;

    TypeIntervention({
        required this.id,
        required this.libelle,
    });

    factory TypeIntervention.fromJson(Map<String, dynamic> json) => TypeIntervention(
        id: json["id"],
        libelle: json["libelle"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
    };
}
