import 'package:flutter/material.dart';
import 'dart:convert';

class AlbumListScreen extends StatelessWidget {
  // Example JSON string (you will replace this with your actual JSON data)
  final String jsonString = '''
  {
    "albums": [
      {
        "album_type": "single",
        "artists": ["Artist 1"],
        "available_markets": ["US", "UK"],
        "copyrights": ["Copyright Info"],
        "external_ids": {},
        "external_urls": {},
        "genres": ["Pop"],
        "href": "http://example.com",
        "id": "1",
        "images": ["http://image.com/1.jpg"],
        "name": "Album 1",
        "popularity": 80,
        "release_date": "2024-01-01",
        "release_date_precision": "day",
        "tracks": {},
        "type": "album",
        "uri": "spotify:album:1"
      },
      {
        "album_type": "album",
        "artists": ["Artist 2"],
        "available_markets": ["CA"],
        "copyrights": ["Copyright Info 2"],
        "external_ids": {},
        "external_urls": {},
        "genres": ["Rock"],
        "href": "http://example.com",
        "id": "2",
        "images": ["http://image.com/2.jpg"],
        "name": "Album 2",
        "popularity": 90,
        "release_date": "2023-12-25",
        "release_date_precision": "day",
        "tracks": {},
        "type": "album",
        "uri": "spotify:album:2"
      }
    ]
  }
  ''';


// =======================================
// kode konvert API ke Dart
// =======================================

  @override
  Widget build(BuildContext context) {
    // Parsing the JSON data
    Album albumData = albumFromJson(jsonString);

    return Scaffold(
      body: ListView.builder(
        itemCount: albumData.albums.length,
        itemBuilder: (context, index) {
          final album = albumData.albums[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(
                album.images.isNotEmpty ? album.images.first : '',
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.album); // Placeholder if image fails to load
                },
              ),
              title: Text(album.name),
              subtitle: Text(
                'Artist: ${album.artists.join(", ")}\nRelease Date: ${album.releaseDate}',
              ),
              trailing: Text('Popularity: ${album.popularity}'),
            ),
          );
        },
      ),
    );
  }
}

// Model parsing classes (as provided in your original code)
Album albumFromJson(String str) => Album.fromJson(json.decode(str));

String albumToJson(Album data) => json.encode(data.toJson());

class Album {
  List<AlbumElement> albums;

  Album({
    required this.albums,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        albums: List<AlbumElement>.from(
            json["albums"].map((x) => AlbumElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "albums": List<dynamic>.from(albums.map((x) => x.toJson())),
      };
}

class AlbumElement {
  String albumType;
  List<dynamic> artists;
  List<dynamic> availableMarkets;
  List<dynamic> copyrights;
  ExternalIds externalIds;
  ExternalIds externalUrls;
  List<dynamic> genres;
  String href;
  String id;
  List<dynamic> images;
  String name;
  int popularity;
  String releaseDate;
  String releaseDatePrecision;
  ExternalIds tracks;
  String type;
  String uri;

  AlbumElement({
    required this.albumType,
    required this.artists,
    required this.availableMarkets,
    required this.copyrights,
    required this.externalIds,
    required this.externalUrls,
    required this.genres,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.popularity,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  factory AlbumElement.fromJson(Map<String, dynamic> json) => AlbumElement(
        albumType: json["album_type"],
        artists: List<dynamic>.from(json["artists"].map((x) => x)),
        availableMarkets:
            List<dynamic>.from(json["available_markets"].map((x) => x)),
        copyrights: List<dynamic>.from(json["copyrights"].map((x) => x)),
        externalIds: ExternalIds.fromJson(json["external_ids"]),
        externalUrls: ExternalIds.fromJson(json["external_urls"]),
        genres: List<dynamic>.from(json["genres"].map((x) => x)),
        href: json["href"],
        id: json["id"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        name: json["name"],
        popularity: json["popularity"],
        releaseDate: json["release_date"],
        releaseDatePrecision: json["release_date_precision"],
        tracks: ExternalIds.fromJson(json["tracks"]),
        type: json["type"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "album_type": albumType,
        "artists": List<dynamic>.from(artists.map((x) => x)),
        "available_markets": List<dynamic>.from(availableMarkets.map((x) => x)),
        "copyrights": List<dynamic>.from(copyrights.map((x) => x)),
        "external_ids": externalIds.toJson(),
        "external_urls": externalUrls.toJson(),
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "href": href,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x)),
        "name": name,
        "popularity": popularity,
        "release_date": releaseDate,
        "release_date_precision": releaseDatePrecision,
        "tracks": tracks.toJson(),
        "type": type,
        "uri": uri,
      };
}

class ExternalIds {
  ExternalIds();

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds();

  Map<String, dynamic> toJson() => {};
}
