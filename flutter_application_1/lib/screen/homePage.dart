import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/model/notesModel.dart';
import 'package:flutter_application_1/service/notesService.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final NotesService _notesService = NotesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Gestión de notas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          _mostrarFormularioNota(context, null);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<notasModel>?>(
        stream: _notesService.getNotas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay notas'));
          } else {
            final notas = snapshot.data!;
            return ListView.builder(
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final nota = notas[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      nota.descripcion,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha: ${DateFormat('yyyy-MM-dd').format(nota.fecha)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Estado: ${nota.estado}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Importante: ${nota.importante ? 'Sí' : 'No'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _mostrarFormularioNota(context, nota);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _notesService.deleteNota(nota.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _mostrarFormularioNota(BuildContext context, notasModel? nota) {
  final TextEditingController descripcionController =
      TextEditingController(text: nota?.descripcion ?? '');
  String estado = nota?.estado ?? 'creado';
  bool importante = nota?.importante ?? false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nota != null ? 'Editar Nota' : 'Agregar Nota',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estado',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          DropdownButton<String>(
                            value: estado,
                            onChanged: (String? newValue) {
                              setState(() {
                                estado = newValue!;
                              });
                            },
                            items: <String>[
                              'creado',
                              'por hacer',
                              'trabajando',
                              'finalizado'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Importante',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          Checkbox(
                            value: importante,
                            onChanged: (bool? value) {
                              setState(() {
                                importante = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      SizedBox(width: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (nota != null) {
                            final notaActualizada = notasModel(
                              id: nota.id,
                              descripcion: descripcionController.text,
                              fecha: nota.fecha,
                              estado: estado,
                              importante: importante,
                            );
                            await _notesService.updateNota(notaActualizada);
                          } else {
                            final nuevaNota = notasModel(
                              id: '',
                              descripcion: descripcionController.text,
                              fecha: DateTime.now(),
                              estado: estado,
                              importante: importante,
                            );
                            await _notesService.addNota(nuevaNota);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(nota != null ? 'Actualizar' : 'Guardar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

}
