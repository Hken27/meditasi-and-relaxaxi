import 'package:Lugowo/view/widget/location_button.dart';
import 'package:Lugowo/view/widget/maps.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  String _locationMessage = "Menunggu lokasi...";

  bool _isLoading = false;

// fungsi untuk mendapatkan lokasi
  void _updateLocation(Position position) {
    setState(() {
      _currentPosition = position;
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tampilkan loading spinner jika sedang memproses
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading)
              Text(
                _locationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),

            // Tombol untuk mendapatkan lokasi
            LocationButton(onLocationFetched: _updateLocation),
            const SizedBox(height: 20),

            // Tombol untuk membuka peta jika lokasi tersedia
            if (_currentPosition != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Maps(
                        latitude: _currentPosition!.latitude,
                        longitude: _currentPosition!.longitude,
                      ),
                    ),
                  );
                },
                child: const Text('Tampilkan di Google Maps'),
              ),
          ],
        ),
      ),
    );
  }
}
