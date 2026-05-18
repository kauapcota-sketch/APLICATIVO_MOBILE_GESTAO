import 'package:app_gestao/cadastro.dart';
import 'package:app_gestao/database/database.dart';
import 'package:app_gestao/inicial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String email;
  final String senha;

  const LoginPage({
    super.key,
    this.email = "",
    this.senha = "",
  });

  @override
  State<LoginPage> createState() => _PaginaLogin();
}

class _PaginaLogin extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _obscure = true;
  bool _entrando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha email e senha")),
      );
      return;
    }

    setState(() => _entrando = true);

      Map<String, dynamic>? usuarioLocal;
    try {
      usuarioLocal = await DatabaseHelper.instance.getUserByEmailAndSenha(
        email: email,
        senha: senha,
      );
    } catch (_) {
      usuarioLocal = null;
    }

    final acessoPorParametro =
        widget.email.isNotEmpty && email == widget.email && senha == widget.senha;
    final acessoLiberado = usuarioLocal != null || acessoPorParametro;

    if (!mounted) return;
    setState(() => _entrando = false);

    if (acessoLiberado) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TelaInicial()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Acesso liberado")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senha ou usuario incorretos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2A44),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Gestao estoque',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: "arial",
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topRight,
              child: Text(
                'Farmacia',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: "arial",
                ),
              ),
            ),
            const SizedBox(height: 140),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _senhaController,
              obscureText: _obscure,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _entrando ? null : _entrar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blue,
              ),
              child: _entrando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Entrar"),
            ),
            const SizedBox(height: 180),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const telaCadastro()),
                );
              },
              child: const Text(
                'Nao tem conta? Cadastre-se!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: "arial",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}