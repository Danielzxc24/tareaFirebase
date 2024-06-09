import 'package:cloud_firestore/cloud_firestore.dart';

class notasModel {
  String id;
  String descripcion;
  DateTime fecha;
  String estado;
  bool importante;

  notasModel({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.estado,
    required this.importante,
  });

  factory notasModel.fromFirestore(DocumentSnapshot note) {
    Map<String, dynamic> data = note.data() as Map<String, dynamic>;
    return notasModel(
      id: note.id,
      descripcion: data['descripcion'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      estado: data['estado'] ?? 'creado',
      importante: data['importante'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'descripcion': descripcion,
      'fecha': fecha,
      'estado': estado,
      'importante': importante,
    };
  }
}
