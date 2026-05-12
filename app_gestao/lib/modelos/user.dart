  class User {
  final int id; //campo vindo do JSON
  final String name; //campo vindo do JSON
  final String email; //campo vindo do JSON
  final String phone; //campo vindo do JSON
  final String company; //campo vindo do JSON

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) { //método que converte JSON em objeto User
    return User( //Campos vindos da API
      id: json['id'], //pega valor do JSON
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      company: json['company']['name'], //JSON aninhado (company dentro de company)
    );
  }
}