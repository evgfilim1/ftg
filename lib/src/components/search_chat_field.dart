import 'package:flutter/material.dart';

class SearchChatField extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SearchChatField({
    super.key,
    required this.controller,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      right: 8,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            padding: const EdgeInsets.all(6),
            splashRadius: 16,
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              child: Icon(Icons.account_circle),
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          hintText: "Search",
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}