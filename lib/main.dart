import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _httpLink = HttpLink(
      'https://f409900f50ac.ngrok.io/graphql',
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _httpLink as Link,
    );

    const String fetchData = r'''
      query {
           feed {
           id
           title
           content
           published
           author {
             id
             name
             email
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(document: gql(fetchData));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Container(
          child: RaisedButton(
            child: Text('hi'),
            color: Colors.black,
            textColor: Colors.white,
            onPressed: () async {
              final QueryResult result = await client.query(options);

              if (result.hasException) {
                print(result.exception.toString());
              }

              final List<dynamic> repositories =
                  result.data['feed'] as List<dynamic>;

              print(repositories);
            },
          ),
        )),
      ),
    );
  }
}

const String addStar = r'''
  mutation AddStar($starrableId: ID!) {
    action: addStar(input: {starrableId: $starrableId}) {
      starrable {
        viewerHasStarred
      }
    }
  }
''';

// final MutationOptions options = MutationOptions(
//   document: gql(addStar),
//   variables: <String, dynamic>{
//     'starrableId': repositoryID,
//   },
// );

// final QueryResult result = await client.mutate(options);

// if (result.hasException) {
//   print(result.exception.toString());
//   return;
// }

// final bool isStarred =
//     result.data['action']['starrable']['viewerHasStarred'] as bool;

// if (isStarred) {
//   print('Thanks for your star!');
//   return;
// }
