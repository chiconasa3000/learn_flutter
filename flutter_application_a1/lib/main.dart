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
        child: TodoScreen(),
      ),
    );
  }
}

//initState para el Future: Es crucial inicializar _futureTodos en el initState.
// Si pusieras _repository.fetchTodos() directamente dentro del build,
//la aplicación haría una petición HTTP cada vez que la pantalla se redibuje
//(por ejemplo, al rotar el teléfono o abrir el teclado),
//lo cual es un error grave de rendimiento.

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // Instanciamos el repositorio y guardamos el Future
  late Future<List<Todo>> _futureTodos;
  final Repository repository = Repository();

  @override
  void initState() {
    super.initState();
    _futureTodos = repository.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestor de Tareas')),
      body: FutureBuilder<List<Todo>>(
        future: _futureTodos, // Llamada al método
        builder: (context, snapshot) {
          // 1. Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 2. Manejo de errores
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar datos: ${snapshot.error}'));
          }

          // 3. Datos obtenidos con éxito
          if (snapshot.hasData) {
            final todos = snapshot.data!;

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Vista Movil
                    return ListTile(
                      title: Text(todo.title),
                      trailing: Icon(
                          todo.completed ? Icons.check_circle : Icons.pending,
                          color: todo.completed ? Colors.green : Colors.orange),
                    );
                  } else {
                    // Vista Desktop
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          CircleAvatar(child: Text(todo.userId.toString())),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              todo.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Chip(
                            label: Text(
                                todo.completed ? 'Finalizado' : 'En curso'),
                            backgroundColor: todo.completed
                                ? Colors.green[50]
                                : const Color.fromARGB(255, 255, 224, 224),
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
            );
          }

          return Center(child: Text('No hay tareas disponibles.'));
        },
      ),
    );
  }
}
