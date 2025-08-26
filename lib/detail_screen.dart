import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // for time formatting

class DetailScreen extends StatefulWidget {
  final String city;
  const DetailScreen({super.key, required this.city});

  @override
  State<DetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<DetailScreen> {
  final String apiKey = "8cdfed27e68826033fb4be25bb221882";

  String weather = "Loading...";
  double temp = 0.0;
  double feelsLike = 0.0;
  int humidity = 0;
  double wind = 0.0;
  int pressure = 0;
  int sunrise = 0;
  int sunset = 0;

  List hourlyForecast = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.city);
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city,PK&appid=$apiKey&units=metric");
    final hourlyUrl = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city,PK&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);
      final hourlyResponse = await http.get(hourlyUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          temp = data["main"]["temp"];
          feelsLike = data["main"]["feels_like"];
          humidity = data["main"]["humidity"];
          pressure = data["main"]["pressure"];
          wind = data["wind"]["speed"];
          sunrise = data["sys"]["sunrise"];
          sunset = data["sys"]["sunset"];
          weather = data["weather"][0]["description"];
        });
      }

      if (hourlyResponse.statusCode == 200) {
        final forecastData = jsonDecode(hourlyResponse.body);
        setState(() {
          // Sirf next 6 entries (3-hour intervals) dikhani
          hourlyForecast = forecastData["list"].take(6).toList();
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        weather = "Error: $e";
        isLoading = false;
      });
    }
  }

  String formatTime(int timestamp) {
    return DateFormat.jm()
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              weather.contains("rain")
                  ? Colors.blueGrey.shade800
                  : weather.contains("cloud")
                  ? Colors.blueGrey.shade600
                  : Colors.indigo,
              Colors.black87
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              isLoading
                  ? Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    // 🌆 City Name
                    Text(
                      widget.city,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // 🌡️ Temperature Card
                    Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Colors.white.withOpacity(0.15),
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Icon(
                              _getWeatherIcon(weather),
                              size: 80,
                              color: Colors.amberAccent,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "${temp.toStringAsFixed(1)} °C",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              weather.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // 📊 Extra Info Row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _infoCard(Icons.thermostat, "Feels Like",
                              "${feelsLike.toStringAsFixed(1)}°C"),
                          _infoCard(Icons.water_drop, "Humidity",
                              "$humidity%"),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _infoCard(Icons.air, "Wind", "$wind m/s"),
                          _infoCard(Icons.speed, "Pressure",
                              "$pressure hPa"),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _infoCard(Icons.wb_sunny, "Sunrise",
                              formatTime(sunrise)),
                          _infoCard(Icons.nightlight_round, "Sunset",
                              formatTime(sunset)),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    // ⏰ Hourly Forecast
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hourlyForecast.length,
                        itemBuilder: (context, index) {
                          final hour = hourlyForecast[index];
                          final time = DateFormat.jm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  hour["dt"] * 1000));
                          final temp =
                          hour["main"]["temp"].toStringAsFixed(1);
                          final desc = hour["weather"][0]["main"];
                          return Container(
                            width: 110,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Card(
                              color: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20)),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(time,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14)),
                                    SizedBox(height: 8),
                                    Icon(_getWeatherIcon(desc),
                                        size: 32,
                                        color: Colors.amberAccent),
                                    SizedBox(height: 8),
                                    Text("$temp°C",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    // 🔄 Refresh Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () => fetchWeather(widget.city),
                      icon: Icon(Icons.refresh, color: Colors.black),
                      label: Text(
                        "Refresh",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Powered by OpenWeather",
                      style:
                      TextStyle(color: Colors.white70, fontSize: 14),
                    )
                  ],
                ),
              ),

              // ⬅️ Back Button
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Expanded(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.amberAccent),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String desc) {
    if (desc.toLowerCase().contains("cloud")) return Icons.cloud;
    if (desc.toLowerCase().contains("rain")) return Icons.beach_access;
    if (desc.toLowerCase().contains("sun") ||
        desc.toLowerCase().contains("clear")) return Icons.wb_sunny;
    if (desc.toLowerCase().contains("snow")) return Icons.ac_unit;
    return Icons.wb_cloudy;
  }
}
