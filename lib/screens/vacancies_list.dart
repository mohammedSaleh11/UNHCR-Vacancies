import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vacancy_unhcr/vacancyService.dart';
import 'package:vacancy_unhcr/screens/job_details.dart';

//here we created a stateful widget for the vacancies list(because we are using initsate)
class VacanciesList extends StatefulWidget {
  const VacanciesList({super.key});

  @override
  State<VacanciesList> createState() => VacanciesListState();
}

class VacanciesListState extends State<VacanciesList> {
  late Future<List<dynamic>> vacancies;

//here we make an instance of VacancyService
  final VacancyService vacancyService = VacancyService();

//here as the screen loads the vacancies will be fetched and saved in vacancies
  @override
  void initState() {
    super.initState();
    vacancies = getVacancies();
  }

//this the function for fetching the vacancies and getting the response back
  Future<List<dynamic>> getVacancies() async {
    try {
      final response = await vacancyService.fetchVacancies();

      if (response.statusCode == 200) {
        // 200 response is ok
        return json.decode(response.body);
      } else {
        switch (response.statusCode) {
          case 400: //if 400 response, it is Bad request
            throw Exception('Bad Request: Client error.');
          case 403: //if 403 response, it is Forbidden
            throw Exception('Forbidden: Access denied.');
          case 404: //if 404 response, it is not found
            throw Exception('Not Found: Vacancies not found.');
          case 500:
          case 503: //500 and 503 are server errors
            throw Exception('Server Error: Please try again later.');
          default:
            throw Exception('Error: Status code ${response.statusCode}.');
        }
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

// this is the scaffold widget that is the basic layout structure
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UNHCR Vacancies',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05),
        ),
        backgroundColor: Color(0xFF0072CE),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Scrollbar(
        thumbVisibility: true,
        child: FutureBuilder<List<dynamic>>(
          future: vacancies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); //if the vacancies are still getting fetched an idicator will be displayed
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //if there are no vacancies a message will be displayes to the user
              return Center(
                  child: Text('No vacancies available',
                      style: TextStyle(color: Colors.grey)));
            }

            return ListView.builder(
              // a listview builder widget is used to display a list of items
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var vacancy = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    //here when we press on a vacancy, the user will get sent to the vacancy details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailScreen(
                          jobId: vacancy['job_id'],
                          title: vacancy['title'],
                          company: vacancy['company'],
                          location: vacancy['location'],
                          description: vacancy['description'],
                          longDescription: vacancy['long_description'],
                          salary: vacancy['salary'],
                          datePosted: vacancy['date_posted'],
                          imageUrl: vacancy['image_url'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: screenWidth * 0.3,
                              height: screenWidth * 0.4,
                              child: vacancy['image_url'] != null
                                  ? Image.network(
                                      vacancy['image_url'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Icon(Icons.image_not_supported,
                                              color: Colors.grey),
                                    )
                                  : const Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vacancy['title'],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0072CE),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  vacancy['company'],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  vacancy['description'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Posted on: ${vacancy['date_posted']}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
