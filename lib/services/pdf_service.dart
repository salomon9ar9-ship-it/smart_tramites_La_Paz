import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/comprobante_model.dart';
import '../models/user_model.dart';

class PDFService {
  static final PDFService _instance = PDFService._internal();
  factory PDFService() => _instance;
  PDFService._internal();

  static PDFService get instance => _instance;

  Future<Uint8List> generateComprobantePDF({
    required Comprobante comprobante,
    required UserModel usuario,
    Uint8List? qrImage,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Comprobante de Pago', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Divider(),
              pw.Text('Entidad: ${comprobante.entidad}'),
              pw.Text('Concepto: ${comprobante.concepto}'),
              pw.Text('Monto: ${comprobante.monto} ${comprobante.moneda}'),
              pw.Text('Referencia: ${comprobante.referenciaBancaria ?? 'N/A'}'),
              pw.Text('Estado: ${comprobante.estado}'),
              pw.Text('Fecha: ${_formatDate(comprobante.fechaEmision)}'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> previewPDF(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
  }

  Future<void> sharePDF({required Uint8List pdfBytes, required String filename}) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: '$filename.pdf');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}