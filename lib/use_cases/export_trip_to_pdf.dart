import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../entities/trip.dart';
import '../file_repository/trip_repository.dart';

/// An implementation of [ExportTripToPdfUseCase] that creates a
/// PDF from trip data.
/// This class handles the entire process of generating a
/// multi-page PDF, including fetching images,
/// formatting content, and saving the file to the user's device.
class ExportTripToPdf {
  /// Represents the repository of Trip, containing its methods
  final TripRepositorySQLite tripRepo = TripRepositorySQLite();

  /// This is the main color of the PDF, following the brand's main colors
  final primaryColor = PdfColor.fromInt(0xFF197982);

  /// That is the secondary color of the PDF, following the brand's colors
  final secondaryColor = PdfColor.fromInt(0xFFFFA600);

  ///Main method, exports the [Trip] into a [PDF] and saves in the Storage
  Future<void> exportToPdf(Trip trip) async {
    var permissionGranted = await Permission.photos.isGranted;

    if (!permissionGranted) {
      final status = await Permission.photos.request();
      if (status.isGranted) {
        permissionGranted = true;
      }
    }

    if (!permissionGranted) {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        permissionGranted = true;
      }
    }

    if (permissionGranted) {
      final pdfDocument = pw.Document();

      // Load images from assets to be used in the PDF.
      final logoImage = (await rootBundle.load(
        'assets/images/app_icon/logo_desafio_final_light.png',
      )).buffer.asUint8List();

      final logoWithName = (await rootBundle.load(
        'assets/images/app_icon/logo_desafio_final_com_nome.png',
      )).buffer.asUint8List();

      //1º Page -> Cover
      pdfDocument.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(logoWithName), height: 500),
                  pw.Text(
                    trip.title,
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Duration: ${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year} - ${trip.endDate.day}/${trip.endDate.month}/${trip.endDate.year}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      color: secondaryColor,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Transport Method: ${trip.transportationMethod}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      color: secondaryColor,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      //2º Page -> Participant List
      if (trip.participantList != null && trip.participantList!.isNotEmpty) {
        pdfDocument.addPage(
          pw.Page(
            build: (context) {
              return pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Participant List',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: trip.participantList!.map((p) {
                        return pw.SizedBox(
                          width: 150,
                          child: pw.Column(
                            children: [
                              if (p.photoPath.isNotEmpty)
                                pw.ClipOval(
                                  child: pw.Image(
                                    pw.MemoryImage(
                                      File(p.photoPath).readAsBytesSync(),
                                    ),
                                    fit: pw.BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              pw.SizedBox(height: 10),
                              pw.Text(
                                p.name,
                                style: pw.TextStyle(color: primaryColor),
                              ),
                              pw.Text(
                                'Age: ${DateTime.now().year - p.dateOfBirth.year}',
                                style: pw.TextStyle(color: secondaryColor),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }

      //3º Page -> Stopovers and Reviews
      if (trip.stopoverList != null && trip.stopoverList!.isNotEmpty) {
        for (var stopover in trip.stopoverList!) {
          final reviews = await tripRepo.listReviewFromStopover(stopover.id!);

          final column1Reviews = <pw.Widget>[];
          final column2Reviews = <pw.Widget>[];

          for (var i = 0; i < reviews.length; i++) {
            final review = reviews[i];
            final participant = trip.participantList?.firstWhere(
              (p) => p.id == review.participantId,
            );

            final reviewWidget = pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 15),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (review.photoPath.isNotEmpty)
                    pw.Image(
                      pw.MemoryImage(File(review.photoPath).readAsBytesSync()),
                      height: 100,
                      fit: pw.BoxFit.cover,
                    ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    review.message,
                    style: pw.TextStyle(color: secondaryColor),
                  ),
                  pw.Text(
                    '- ${participant?.name ?? 'Unknown Participant'}',
                    style: pw.TextStyle(
                      color: primaryColor,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );

            if (i % 2 == 0) {
              column1Reviews.add(reviewWidget);
            } else {
              column2Reviews.add(reviewWidget);
            }
          }

          pdfDocument.addPage(
            pw.Page(
              build: (context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      stopover.cityName,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Duration: ${stopover.arrivalDate.day}/${stopover.arrivalDate.month}/${stopover.arrivalDate.year} - ${stopover.departureDate.day}/${stopover.departureDate.month}/${stopover.departureDate.year}',
                      style: pw.TextStyle(
                        color: secondaryColor,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    if (reviews.isNotEmpty)
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(children: column1Reviews),
                          ),
                          pw.SizedBox(width: 20),
                          pw.Expanded(
                            child: pw.Column(children: column2Reviews),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          );
        }
      }

      // 4º Page -> Final Page with logo and message
      pdfDocument.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(logoImage), height: 100),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'UMA VIAGEM NÃO SE MEDE EM MILHAS, MAS EM MOMENTOS.'
                    ' CADA PÁGINA DESTE LIVRETO GUARDA MAIS DO '
                    'QUE PAISAGENS: SÃO SORRISOS ESPONTÂNEOS, '
                    'DESCOBERTAS INESPERADAS, CONVERSAS QUE FICARAM '
                    'NA ALMA E SILÊNCIOS QUE FALARAM MAIS QUE PALAVRAS.',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Saving the PDF on the device
      final output = await getDownloadsDirectory();

      if (output != null) {
        final file = File('${output.path}/${trip.title}_livreto.pdf');
        await file.writeAsBytes(await pdfDocument.save());
      } else {
        throw Exception(
          'There was an error while trying to access downloads directory',
        );
      }
    } else {
      throw Exception('Permission to access storage was denied');
    }
  }
}
