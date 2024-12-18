import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

//  izin lokasi 
class LocationButton extends StatelessWidget {
  final Function(Position) onLocationFetched;

  const LocationButton({required this.onLocationFetched, super.key});

  Future<void> _fetchLocation(BuildContext context) async {
    try {
      
      // Periksa apakah layanan lokasi aktif
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Layanan lokasi tidak aktif')),
        );
        return;
      }

      // Periksa dan minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak secara permanen');
      }

      // Ambil lokasi terkini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      onLocationFetched(position);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _fetchLocation(context),
      child: const Text('Cari Lokasi'),
    );
  }
}
