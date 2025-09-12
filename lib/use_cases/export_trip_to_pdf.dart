import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../entities/trip.dart';
import '../file_repository/trip_repository.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class ExportTripToPdfUseCase {
  Future<void> exportToPdf(Trip trip);
}

class ExportTripToPdf implements ExportTripToPdfUseCase {
  final TripRepositorySQLite tripRepo = TripRepositorySQLite();

  @override
  Future<void> exportToPdf(Trip trip) async {

    bool permissionGranted = await Permission.photos.isGranted;

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

      final logoImage = (await rootBundle.load(
        'assets/images/app_icon/logo_desafio_final_light.png',
      )).buffer.asUint8List();

      //1º Page -> Capa (Dunno how I say capa in english .-.)
      pdfDocument.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    trip.title,
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Duration: ${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year} - ${trip.endDate.day}/${trip.endDate.month}/${trip.endDate.year}',
                    style: pw.TextStyle(fontSize: 18),
                  ),
                  pw.Text(
                    'Transport Method: ${trip.transportationMethod}',
                    style: pw.TextStyle(fontSize: 18),
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
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Participant List',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
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
                            pw.Text(p.name, style: pw.TextStyle()),
                            pw.Text(
                              'Age: ${DateTime.now().year - p.dateOfBirth.year}',
                              style: pw.TextStyle(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        );
      }

      //3º Page -> Stopovers and Reviews
      if (trip.stopoverList != null && trip.stopoverList!.isNotEmpty) {
        for (var stopover in trip.stopoverList!) {
          final reviews = await tripRepo.listReviewFromStopover(stopover.id!);

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
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Período: ${stopover.arrivalDate.day}/${stopover.arrivalDate.month}/${stopover.arrivalDate.year} - ${stopover.departureDate.day}/${stopover.departureDate.month}/${stopover.departureDate.year}',
                      style: pw.TextStyle(),
                    ),
                    pw.SizedBox(height: 20),
                    if (reviews.isNotEmpty)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: reviews.map((review) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 15),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (review.photoPath.isNotEmpty)
                                  pw.Image(
                                    pw.MemoryImage(
                                      File(review.photoPath).readAsBytesSync(),
                                    ),
                                    height: 200,
                                  ),
                                pw.SizedBox(height: 10),
                                pw.Text(review.message, style: pw.TextStyle()),
                                pw.Text(
                                  '- ${review.participantId}',
                                  style: pw.TextStyle(
                                    fontStyle: pw.FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
                    'UMA VIAGEM NÃO SE MEDE EM MILHAS, MAS EM MOMENTOS. CADA PÁGINA DESTE LIVRETO GUARDA MAIS DO QUE PAISAGENS: SÃO SORRISOS ESPONTÂNEOS, DESCOBERTAS INESPERADAS, CONVERSAS QUE FICARAM NA ALMA E SILÊNCIOS QUE FALARAM MAIS QUE PALAVRAS.',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 16),
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
        print('PDF salvo com sucesso em ${file.path}');
      } else {
        throw Exception('Não foi possível acessar o diretório de downloads');
      }
    } else {
      throw Exception('Permissão de armazenamento não concedida');
    }
  }
}
