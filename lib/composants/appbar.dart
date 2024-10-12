import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import '../constantes/constantes.dart';
import '../controllers/auth.dart';
import '../fonctions/fonctions.dart';

class CAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String value;
  final VoidCallback onPressed;

  const CAppBarHome({
    super.key,
    required this.name,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AuthenticateController authenticateController = Get.put(AuthenticateController());

    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onPressed,
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Text(
              getInitials(name),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      actions: [
        badges.Badge(
          position: badges.BadgePosition.topEnd(top: -12, end: -8),
          badgeContent: Text(value,style: TextStyle(color: Colors.white),),
          onTap: () {},
          child: Icon(Icons.notifications, color: AppColors.primaryColor),
        ),
        SizedBox(width: 15),
        IconButton(
          onPressed: () {authenticateController.deconnectUser();},
          icon: const Icon(
            Icons.logout,
            color: AppColors.primaryColor,
          )
        ),
      ],
      automaticallyImplyLeading: false,

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressed;

  const CAppBar({
    super.key,
    required this.title,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      // elevation: 0.0,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,),
        onPressed: onPressed,
        
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
