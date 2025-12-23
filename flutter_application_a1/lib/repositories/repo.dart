import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelo/todo_model.dart';

class Repository {
  final String _baseUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);

        //mapeamos cada elemento a un objeto de tipo Todo
        List<Todo> todos =
            body.map((dynamic item) => Todo.fromJson(item)).toList();

        return todos;
      } else {
        throw Exception("Error de servidor: ${response.statusCode}");
      }
    } catch (e) {
      // Captura errores de red o de parsing
      throw Exception("Error de conexion: $e");
    }
  }
}
