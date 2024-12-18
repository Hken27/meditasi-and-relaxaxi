// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:meditasi_app/controller/album_api_controller.dart';

// class AlbumListScreen extends StatelessWidget {
//   final AlbumController albumController = Get.put(AlbumController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (albumController.isLoading.value) {
//           return const Center(child: const CircularProgressIndicator());
//         }
//         return ListView.builder(
//           itemCount: albumController.albums.length,
//           itemBuilder: (context, index) {
//             final album = albumController.albums[index];
//             return Card(
//               margin: const EdgeInsets.all(10),
//               child: ListTile(
//                 leading: Image.network(
//                   album.images.isNotEmpty ? album.images.first : '',
//                   width: 50,
//                   height: 50,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Icon(Icons.album); // Placeholder if image fails to load
//                   },
//                 ),
//                 title: Text(album.name),
//                 subtitle: Text(
//                   'Artist: ${album.artists.join(", ")}\nRelease Date: ${album.releaseDate}',
//                 ),
//                 trailing: Text('Popularity: ${album.popularity}'),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }