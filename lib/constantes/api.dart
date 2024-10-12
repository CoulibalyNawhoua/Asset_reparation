class Api {
  static const url = "https://assets-api.distriforce.shop/api";
  static const imageUrl = 'https://assets-api.distriforce.shop/storage/';
  
  // static const url = "http://192.168.1.73:8000/api";
  // static const imageUrl = "http://192.168.1.73:8000/storage/";

  
  static const login = '$url/login-reparateur';

  static const listTicket = '$url/list-interventions-reparateurs';

  static String ticketDetails(String uuid) {
    return '$url/intervention-view-mobile/$uuid';
  }
  static String confirmation(String uuid) {
    return '$url/confirm-intervention-by-reparateur/$uuid';
  }
  static String annulation(String uuid) {
    return '$url/rejete-intervention-by-reparateur/$uuid';
  }


  static String createDevis(String uuid) {
    return '$url/creation-new-devis/$uuid';
  }
  static String createFacture(String uuid) {
    return '$url/creation-new-facture/$uuid';
  }

  static const listDevis = '$url/list-devis-intervention';
  static const listFacture = '$url/list-factures-intervention';

  static String detailFacture(int id) {
    return '$url/view-devis-factures/$id';
  }

  static const dash = '$url/dashbord-stat-reparateur';

}




