import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/searchbar/suggestion_list.dart';
import '../services/cityfinder_service.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double screenWidth;
  final SearchController searchController;
  final String submittedSearch;
  final void Function(String value, int? index) onSubmitted;
  final void Function() onPressed;
  final Map<String, SuggestionList> cachedSuggestions;
  final void Function(String query, SuggestionList) saveSuggestions;
  final void Function() setConnectionLost;
  final bool isViewOpen;
  const MyAppBar({
    super.key,
    required this.screenWidth,
    required this.searchController,
    required this.submittedSearch,
    required this.onSubmitted,
    required this.onPressed,
    required this.saveSuggestions,
    required this.cachedSuggestions,
    required this.setConnectionLost,
    required this.isViewOpen,
  });
  @override
  Widget build(BuildContext context) {
    debugPrint('toto');
    final sugesstionTextStyle = TextStyle(color: Colors.white);
    return BackdropFilter(
      filter: isViewOpen
          ? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)
          : ImageFilter.blur(),
      child: AppBar(
          backgroundColor: Colors.transparent,
          title: Stack(alignment: Alignment.center, children: [
            Row(children: [
              SizedBox(
                  width: screenWidth * 0.7,
                  height: kToolbarHeight * 0.5,
                  child: SearchAnchor(
                      headerTextStyle: TextStyle(color: Colors.white),
                      searchController: searchController,
                      isFullScreen: false,
                      viewOnSubmitted: (String value) =>
                          onSubmitted(value, null),
                      viewBackgroundColor: Colors.black.withAlpha(180),
                      viewLeading: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      viewSurfaceTintColor: Colors.black,
                      builder: (context, searchController) {
                        return SearchBar(
                          controller: searchController,
                          hintText: 'Search location',
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          shadowColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          hintStyle: WidgetStateProperty.all(const TextStyle(
                            fontSize: 12.4,
                            color: Colors.white,
                          )),
                          textStyle: WidgetStateProperty.all(const TextStyle(
                              fontSize: 12.4, color: Colors.white)),
                          onTap: () {
                            searchController.openView();
                          },
                          leading: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        );
                      },
                      suggestionsBuilder: (context, controller) async {
                        Future<SuggestionList> searchFuture =
                            Future.value(SuggestionList(suggestion: []));
                        if (cachedSuggestions
                            .containsKey(searchController.text)) {
                          searchFuture = Future.value(
                              cachedSuggestions[searchController.text]!);
                        } else {
                          try {
                            searchFuture = suggestLocation(controller.text);
                            final suggestions = await searchFuture;
                            saveSuggestions(searchController.text, suggestions);
                          } catch (err) {
                            if (err is http.ClientException ||
                                err is TimeoutException) {
                              setConnectionLost();
                            }
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
                                      title: Text(
                                        snapshot.data!.suggestion[index].city,
                                        style: sugesstionTextStyle,
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.suggestion[index].region,
                                        style: sugesstionTextStyle,
                                      ),
                                      trailing: Text(
                                        snapshot
                                            .data!.suggestion[index].country,
                                        style: sugesstionTextStyle,
                                      ),
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
          ])),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
