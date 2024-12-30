import 'package:flutter/material.dart';
import 'package:weather_proj/models/searchbar/suggestion_list.dart';
import '../services/cityfinder_service.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double screenWidth;
  final SearchController searchController;
  final String submittedSearch;
  final void Function(String value, int? index) onSubmitted;
  final void Function() onPressed;
  final Map<String, SuggestionList> cachedSuggestions;
  final void Function(String query, SuggestionList) saveSuggestions;
  const MyAppBar(
      {super.key,
      required this.screenWidth,
      required this.searchController,
      required this.submittedSearch,
      required this.onSubmitted,
      required this.onPressed,
      required this.saveSuggestions,
      required this.cachedSuggestions});

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'APPBAR WIDGET IS BUILDING searchQuery = ${searchController.text}');
    return AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        title: Stack(alignment: Alignment.center, children: [
          Row(children: [
            SizedBox(
                width: screenWidth * 0.4,
                height: kToolbarHeight * 0.5,
                child: SearchAnchor(
                    searchController: searchController,
                    isFullScreen: false,
                    viewOnSubmitted: (String value) => onSubmitted(value, null),
                    viewLeading: const Icon(Icons.search),
                    builder: (context, controller) {
                      return SearchBar(
                        controller: controller,
                        hintText: 'Search location',
                        hintStyle: WidgetStateProperty.all(
                            const TextStyle(fontSize: 12.4)),
                        textStyle: WidgetStateProperty.all(
                            const TextStyle(fontSize: 12.4)),
                        onTap: controller.openView,
                        leading: const Icon(Icons.search),
                      );
                    },
                    suggestionsBuilder: (context, controller) async {
                      Future<SuggestionList> searchFuture = Future.value(SuggestionList(suggestion: []));
                      if (cachedSuggestions
                          .containsKey(searchController.text)) {
                        searchFuture = Future.value(cachedSuggestions[searchController.text]!);
                      }
                      else {
                        try {
                          searchFuture = suggestLocation(controller.text);
                          final suggestions = await searchFuture;
                          saveSuggestions(searchController.text, suggestions);
                        } catch (err) {
                          debugPrint('$err');
                        }
                      }

                      return [
                        FutureBuilder<SuggestionList>(
                          future: searchFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('No suggestions.'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.suggestion.isEmpty) {
                              return const Center(
                                  child: Text('No suggestions found'));
                            } else {
                              return Column(
                                children: List<Widget>.generate(
                                    snapshot.data!.suggestion.length,
                                    (index) {
                                  return ListTile(
                                    title: Text(snapshot
                                        .data!.suggestion[index].city),
                                    subtitle: Text(snapshot
                                        .data!.suggestion[index].region),
                                    trailing: Text(snapshot
                                        .data!.suggestion[index].country),
                                    onTap: () {
                                      onSubmitted(
                                          '${snapshot.data!.suggestion[index].city}, ${snapshot.data!.suggestion[index].region},'
                                          ' ${snapshot.data!.suggestion[index].country}',
                                          index);
                                    },
                                  );
                                }),
                              );
                            }
                          },
                        )
                      ];
                    })),
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
