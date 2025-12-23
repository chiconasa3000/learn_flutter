import 'package:flutter/material.dart';
import './repositories/repo.dart';
import './modelo/todo_model.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  final Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas')),
      body: FutureBuilder<List<Todo>>(
        future: repository.fetchTodos(), // Llamada al método
        builder: (context, snapshot) {
          // 1. Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 2. Manejo de errores
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          }

          // 3. Datos obtenidos con éxito
          if (snapshot.hasData) {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                var item = todos[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title),
                      Icon(item.completed ? Icons.check : Icons.pending),
                    ],
                  ),
                );
              },
            );
          }

          return Center(child: Text('No hay tareas disponibles.'));
        },
      ),
    );
  }
}
