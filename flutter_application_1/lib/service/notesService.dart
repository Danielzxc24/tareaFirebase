import '../model/notesModel.dart';
import '../repository/notesRepository.dart';

class NotesService {
  final notasRepository _repository = notasRepository();

  Future<void> addNota(notasModel nota) async {
    await _repository.addNota(nota);
  }

  Stream<List<notasModel>?> getNotas() {
    return _repository.getNotas();
  }

  Future<notasModel?> getNotaPorId(String id) async {
    return await _repository.getNotaPorId(id);
  }

  Future<void> updateNota(notasModel nota) async {
    await _repository.updateNota(nota);
  }

  Future<void> deleteNota(String id) async {
    await _repository.deleteNota(id);
  }
}
