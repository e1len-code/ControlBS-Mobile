import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/item_widget.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserItemWidget extends StatefulWidget {
  final User? user;
  const UserItemWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<UserItemWidget> createState() => _UserItemWidgetState();
}

class _UserItemWidgetState extends State<UserItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/Usuarios/${widget.user?.persIden}'),
      child: ItemWidget(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.user?.persName ?? "",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 110,
                padding: const EdgeInsets.symmetric(
                    vertical: vspaceS, horizontal: hspaceM),
                decoration: BoxDecoration(
                    color: widget.user?.persStat == 1
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  widget.user?.persStat == 1 ? "Habilitado" : "Deshabilitado",
                  //style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
