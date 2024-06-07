import 'package:cargo_driver_app/alltrips/model/find_tripmodel.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<TripData> searchList = [];
  CustomSearchDelegate({required searchList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<TripData> searchResults = searchList
        .where((item) =>
            item.user!.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].user?.name ?? ''),
          onTap: () {
            // Handle the selected search result.
            close(context, searchResults[index].user?.name ?? '');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<TripData> suggestionList = query.isEmpty
        ? []
        : searchList
            .where((item) =>
                item.user!.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].user?.name ?? ''),
          onTap: () {
            query = suggestionList[index].user?.name ?? '';
            // Show the search results based on the selected suggestion.
          },
        );
      },
    );
  }
}
