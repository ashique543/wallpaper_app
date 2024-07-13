import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'NavBar.dart';
import 'bottom_nav_pages.dart'; // Import Google Fonts package

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List _data = [];
  List<Widget> _bottomPages=[];
  int _selectedItem = 0;


  @override
  void initState() {
    super.initState();
    fetchData();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://mobileland.in/WallpaperAdmin/public/fetchAPI.php'));
      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
          _bottomPages = [
            HomePage(data: _data),
            CategoryPage(data: _data),
            ExplorePage(data: _data),
          ];
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff232121),

      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
        title:  Text("Wallpaper", style: GoogleFonts.roboto(color: Colors.white,fontSize: 25),),
        backgroundColor: Color(0xc6000000),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
        centerTitle: true,
        elevation: 8
      ),
      body: _bottomPages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _bottomPages[_selectedItem],

      bottomNavigationBar:ClipRRect(
        borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
        ),
        child: BottomNavigationBar(

            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xc6000000),
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.white,
            selectedFontSize: 16,
            unselectedFontSize: 16,
         items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'All',),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/icons/icons_anime.png")),label: 'Category'),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/icons/fire.png")),label: 'Explore'),
        ],currentIndex: _selectedItem,
          onTap: (setValue){
              setState(() {
                _selectedItem=setValue;
              });
          },
        ),
      ),
    );
  }
}
