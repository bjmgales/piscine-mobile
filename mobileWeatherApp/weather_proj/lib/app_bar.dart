import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double screenWidth;
  final TextEditingController searchController;
  final String submittedSearch;
  final void Function(String searchquery) onSubmitted;
  final void Function() onPressed;
  const MyAppBar({
    super.key,
    required this.screenWidth,
    required this.searchController,
    required this.submittedSearch,
    required this.onSubmitted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        title: Stack(alignment: Alignment.center, children: [
          Row(children: [
            SizedBox(
                width: screenWidth * 0.4,
                height: kToolbarHeight * 0.5,
                child: SearchBar(
                    controller: searchController,
                    hintText: 'Search location',
                    hintStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 12.4)),
                    textStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 12.4)),
                    // onChanged: (value) => setState(() {
                    //   searchQuery = value;
                    // }), Useless for now cause I don't suggest anything from the current user input. onSubmitted is enough.
                    onSubmitted: onSubmitted,
                    leading: const Icon(Icons.search))),
            const Spacer(),
            IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.location_on, color: Colors.white))
          ]),
          const Icon(
            Icons.sunny,
            color: Colors.yellow,
            size: 40,
          ),
        ]));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
