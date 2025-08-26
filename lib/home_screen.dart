import 'package:flutter/material.dart';
import 'package:weather_app/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Cities list
  final List<String> cities = [
    "Islamabad",
    "Lahore",
    "Karachi",
    "Rawalpindi",
    "Murree",
    "Peshawar",
    "Quetta",
    "Faisalabad",
    "Multan",
    "Skardu",
    "Hyderabad",
    "Bahawalpur",
    "Sialkot",
    "Sukkur",
    "Gujranwala",
    "Sargodha",
    "Mardan",
    "Abbottabad",
    "Swat",
    "Chitral",
    "Gilgit",
    "Hunza",
    "Attock",
    "Jhelum",
    "Okara",
    "Dera Ghazi Khan",
    "Khuzdar",
    "Gwadar",
    "Mianwali",
    "Kotli",
    "Mirpur",
    "Muzaffarabad",
    "Larkana",
    "Nawabshah",
    "Dadu",
    "Khairpur",
    "Tando Adam",
    "Shikarpur",
    "Jacobabad",
    "Kashmore",
    "Hala",
    "Badin",
    "Thatta",
    "Umerkot",
    "Chaman",
    "Zhob",
    "Nowshera",
    "Swabi",
    "Dera Ismail Khan",
    "Bannu",
    "Lakki Marwat",
    "Haripur",
    "Mansehra",
    "Parachinar",
    "Vehari",
    "Turbat",
    "Sheikhupura",
    "Kasur",
  ];

  // Weather icons for cities

  final List<IconData> icons = [
    Icons.sunny,
    Icons.cloud,
    Icons.cloudy_snowing,
    Icons.water_drop,
    Icons.ac_unit,
    Icons.foggy,
    Icons.grain,
    Icons.wb_cloudy,
    Icons.landscape,
    Icons.nightlight_round,
    Icons.storm,
    Icons.thunderstorm,
    Icons.waves,
    Icons.wind_power,
    Icons.umbrella,
    Icons.thermostat,
    Icons.fireplace,
    Icons.snowboarding,
    Icons.ice_skating,
    Icons.surfing,
    Icons.pool,
    Icons.local_florist,
    Icons.park,
    Icons.terrain,
    Icons.flood,
    Icons.energy_savings_leaf,
    Icons.water,
    Icons.beach_access,
    Icons.spa,
    Icons.hiking,
    Icons.downhill_skiing,
    Icons.nature,
    Icons.nature_people,
    Icons.nights_stay,
    Icons.star,
    Icons.stars,
    Icons.flash_on,
    Icons.air,
    Icons.airplanemode_active,
    Icons.airline_seat_flat,
    Icons.eco,
    Icons.cloud_queue,
    Icons.sunny_snowing,
    Icons.brightness_5,
    Icons.brightness_6,
    Icons.brightness_7,
    Icons.brightness_low,
    Icons.brightness_medium,
    Icons.brightness_high,
    Icons.light_mode,
    Icons.dark_mode,
    Icons.nightlife,
    Icons.night_shelter,
    Icons.bolt,
    Icons.cyclone,
    Icons.tsunami,
    Icons.sailing,
    Icons.directions_boat,
    Icons.cloud_circle,
  ];

  // controller & filtered list
  final TextEditingController searchController = TextEditingController();
  List<String> filteredCities = [];
  bool showSearchBar = false;

  @override
  void initState() {
    super.initState();
    filteredCities = cities; //  all cities
  }

  void filterCities(String query) {
    final results = cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredCities = results;
    });
  }

  void resetSearch() {
    setState(() {
      searchController.clear();
      filteredCities = cities;
      showSearchBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Center(child: Text("Pakistan Weather",style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold),)),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
            icon:  Icon(Icons.search,color: Colors.white,),
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
              });
            },
          ),
          IconButton(
            icon:  Icon(Icons.refresh,color: Colors.white),
            onPressed: resetSearch,
          ),
          IconButton(
            icon: const Icon(Icons.settings,color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("Settings Coming Soon ⚙️")),
              );
            },
          ),
        ],
      ),

      // 🌈 Gradient Background
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            if (showSearchBar) // 🔎 Show search bar only if toggled
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextField(
                  cursorColor: Colors.white,
                  controller: searchController,
                  style:  TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search city...",
                    hintStyle:  TextStyle(color: Colors.white54),
                    prefixIcon:  Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: filterCities,
                ),
              ),

            // 📋 Cities List
            Expanded(
              child: ListView.builder(
                itemCount: filteredCities.length,
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  final icon = icons[index % icons.length]; // safe indexing
                  return Padding(
                    padding:
                     EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(city: city),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blueGrey.shade700.withOpacity(0.8),
                              Colors.blueGrey.shade500.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow:  [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:  EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          leading: Icon(
                            icon,
                            size: 32,
                            color: Colors.amberAccent,
                          ),
                          title: Text(
                            city,
                            style:  TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing:  Icon(Icons.arrow_forward_ios,
                              color: Colors.white70),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // powered by
             Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Powered by OpenWeather 🌍",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
