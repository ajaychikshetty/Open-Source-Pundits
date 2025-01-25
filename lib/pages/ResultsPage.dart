import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const/AppColors.dart';
import '../widgets/CustomBottomNavBar.dart';

class ResultsPage extends StatelessWidget {
  final File imageFile;
  final String predictionResult;

  const ResultsPage(
      {Key? key, required this.imageFile, required this.predictionResult})
      : super(key: key);

  // Utility method to launch URLs
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Could not launch $url')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse the JSON string
    Map<String, dynamic> resultData;
    try {
      resultData = json.decode(predictionResult);
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error parsing prediction result',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              pinned: true,
              title: Text(
                "Prediction Results",
                style: GoogleFonts.spaceMono(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Crop Image from Network
                    if (resultData['crop_image'] != null)
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(resultData['crop_image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'Title',
                      content: resultData['title'] ?? 'No title available',
                    ),
                    // Description Section
                    _buildSectionCard(
                      title: 'Description',
                      content: resultData['description'] ??
                          'No description available',
                    ),

                    const SizedBox(height: 20),

                    // Prevention Section
                    _buildSectionCard(
                      title: 'Prevention',
                      content: resultData['prevent'] ??
                          'No prevention details available',
                    ),

                    const SizedBox(height: 20),

                    // Supplement Section
                    if (resultData['supplement_name'] != null)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommended Supplement',
                                style: GoogleFonts.rajdhani(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Supplement Image
                              if (resultData['supplement_image_url'] != null)
                                Center(
                                  child: Image.network(
                                    resultData['supplement_image_url'],
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                              const SizedBox(height: 10),

                              // Supplement Name and Buy Link
                              Text(
                                resultData['supplement_name'] ??
                                    'No supplement details',
                                style: GoogleFonts.poppins(),
                              ),

                              const SizedBox(height: 10),

                              ElevatedButton(
                                onPressed:
                                    resultData['supplement_buy_link'] != null
                                        ? () => _launchURL(
                                            resultData['supplement_buy_link'])
                                        : null,
                                child: Text('Buy Now'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildSectionCard({required String title, required String content}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Text(
            title,
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Content Section (full width)
          Container(
            width: double.infinity,
            child: Text(
              content,
              textAlign: TextAlign.start, // Ensure left alignment for full width
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    ),
  );
}
}