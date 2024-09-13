import 'package:flutter/material.dart';

//this is a stateless widget as we dont need to change the state of the screen
class JobDetailScreen extends StatelessWidget {
  //these are the variables that we going to recieve from the vacancy list screen
  final String? jobId;
  final String title;
  final String company;
  final String location;
  final String description;
  final String longDescription;
  final String salary;
  final String datePosted;
  final String imageUrl;

  const JobDetailScreen({
    Key? key,
    required this.jobId,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.longDescription,
    required this.salary,
    required this.datePosted,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //for responsiveness we use MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Details',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05),
        ),
        backgroundColor: Color(0xFF0072CE),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        // we use the SingleChildScrollView to keep scrolling down the elements
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                // this is used to modify the image style
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl.isNotEmpty
                      ? imageUrl
                      : 'https://example.com/default_image.png',
                  width: screenWidth,
                  height: screenWidth * 0.6,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: screenWidth * 0.4,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 30,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0072CE),
                ),
              ),
            ),
            SizedBox(height: 20),
            buildDetailRow('Job ID', jobId ?? 'N/A', isSmallScreen),
            buildDetailRow('Posted on', datePosted, isSmallScreen),
            buildDetailRow('Company', company, isSmallScreen),
            buildDetailRow('Location', location, isSmallScreen),
            buildDetailRow('Description', description, isSmallScreen),
            SizedBox(height: 16),
            Text(
              'Long Description:',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              longDescription.isNotEmpty
                  ? longDescription
                  : 'No additional information available.',
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            SizedBox(height: 16),
            buildDetailRow('Salary', salary, isSmallScreen),
          ],
        ),
      ),
    );
  }

// here we style the label and its value in its own custom widget
  Widget buildDetailRow(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }
}
