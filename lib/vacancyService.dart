import 'package:http/http.dart' as http;

class VacancyService {
  Future<http.Response> fetchVacancies() {
    final url = Uri.parse('https://www.unhcrjo.org/jobs/api');
    return http.get(url);
  }
}
