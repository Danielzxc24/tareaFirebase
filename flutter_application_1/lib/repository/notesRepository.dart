import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notesModel.dart';

class notasRepository {
  final FirebaseFirestore _baseDatos = FirebaseFirestore.instance;

  Future<void> addNota(notasModel nota) async {
    await _baseDatos.collection('notas').add(nota.toFirestore());
  }

  Stream<List<notasModel>> getNotas() {
    return _baseDatos.collection('notas').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => notasModel.fromFirestore(doc)).toList());
  }

  Future<notasModel?> getNotaPorId(String id) async {
    final doc = await _baseDatos.collection('notas').doc(id).get();
    if (doc.exists) {
      return notasModel.fromFirestore(doc);
    }
    return null;
  }

  Future<void> updateNota(notasModel nota) async {
    await _baseDatos
        .collection('notas')
        .doc(nota.id)
        .update(nota.toFirestore());
  }

  Future<void> deleteNota(String id) async {
    await _baseDatos.collection('notas').doc(id).delete();
  }
}
