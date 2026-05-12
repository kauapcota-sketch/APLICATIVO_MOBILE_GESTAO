import 'package:app_gestao/inicial.dart';
import 'package:app_gestao/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_gestao/modelos/user.dart';
import 'package:app_gestao/servicos/apiService.dart';

class telaCadastro extends StatefulWidget {
  const telaCadastro({super.key});

  @override
  State<telaCadastro> createState() => _PaginaCadastro();
}

class _PaginaCadastro extends State<telaCadastro> {
  // Controllers dos campos
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController senhaController    = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController buscaController    = TextEditingController();

  // Dados da API
  late Future<List<User>> futureUsers;
  List<User> allUsers      = [];
  List<User> filteredUsers = [];

  bool _obscure  = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    loadUsers(); // chama API ao iniciar
  }

  // ─── API ───────────────────────────────────────

  void loadUsers() {
    futureUsers = ApiService.fetchUsers(); // faz a requisição
    futureUsers.then((data) {
      setState(() {
        allUsers      = data; // guarda dados da API
        filteredUsers = data; // usa dados da API
      });
    });
  }

  void search(String text) {
    setState(() {
      filteredUsers = allUsers // filtra dados da API (não chama API)
          .where((user) =>
              user.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void refresh() {
    setState(() {
      buscaController.clear();
      loadUsers(); // chama API novamente
    });
  }

  // ─── CADASTRAR ─────────────────────────────────

  void _cadastrar() {
    final email    = emailController.text.trim();
    final senha    = senhaController.text.trim();
    final endereco = enderecoController.text.trim();

    if (email.isEmpty || senha.isEmpty || endereco.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    if (!email.endsWith("@gmail.com")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Digite um email válido com @gmail.com")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cadastro realizado com sucesso!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(email: email, senha: senha),
      ),
    );
  }

  // ─── UI ────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2A44),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Títulos
              const Text('Gestão de estoque',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text('estoque farmácia',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 30),

              const Center(
                child: Text('Tela cadastro',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              // ─── Campo e-mail ───
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // ─── Campo senha ───
              TextField(
                controller: senhaController,
                obscureText: _obscure,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white),
                    onPressed: () =>
                        setState(() => _obscure = !_obscure),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // ─── Campo endereço ───
              TextField(
                controller: enderecoController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Endereço",
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ─── Botão + imagem ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _salvando ? null : _cadastrar,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.blue,
                    ),
                    child: _salvando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("Cadastrar",
                            style: TextStyle(
                                fontSize: 18, color: Colors.white)),
                  ),
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                    height: 100,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),

              // ─── Busca da API ───
              TextField(
                controller: buscaController,
                style: const TextStyle(color: Colors.white),
                onChanged: search, // filtra dados da API
                decoration: InputDecoration(
                  hintText: 'Buscar usuário da API...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white54),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh,
                        color: Colors.white54),
                    onPressed: refresh, // recarrega API
                  ),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),

              // ─── Lista da API ───
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: futureUsers, // futuro da API
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.white));
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Erro: ${snapshot.error}',
                              style: const TextStyle(
                                  color: Colors.red)));
                    }
                    return ListView.builder(
                      itemCount: filteredUsers.length, // dados da API
                      itemBuilder: (_, i) {
                        final user = filteredUsers[i]; // item da API
                        return ListTile(
                          leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person,
                                  color: Colors.white)),
                          title: Text(user.name, // dado da API
                              style: const TextStyle(
                                  color: Colors.white)),
                          subtitle: Text(user.email, // dado da API
                              style: const TextStyle(
                                  color: Colors.white54)),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    UserDetailPage(user: user)), // envia dado da API
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // ─── Voltar ───
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text('voltar',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontStyle: FontStyle.italic)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tela de detalhes do usuário da API ──────────

class UserDetailPage extends StatelessWidget {
  final User user; // recebe dados da API

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2A44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A44),
        title: Text(user.name, // dado da API
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detalhe(Icons.email,    'Email',    user.email),
            _detalhe(Icons.phone,    'Telefone', user.phone),
            _detalhe(Icons.business, 'Empresa',  user.company),
          ],
        ),
      ),
    );
  }

  Widget _detalhe(IconData icone, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Icon(icone, color: Colors.white54),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 12)),
          Text(valor,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16)),
        ]),
      ]),
    );
  }
}