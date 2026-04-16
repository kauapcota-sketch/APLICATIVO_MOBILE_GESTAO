import 'package:app_gestao/cadastro.dart';
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
      
        
            Align(
              alignment: Alignment.topLeft,
               child: Text(
                'Gestão estoque',
                style: TextStyle(
                  fontSize: 40,
                   color: Colors.white,
                    fontFamily: "arial"),
                ),        
            ),
            Align(
              alignment: Alignment.topRight,
               child: Text(
                'Farmácia',
                style: TextStyle(
                  fontSize: 30,
                   color: Colors.white,
                    fontFamily: "arial"),
                ),        
            ),
            const SizedBox(height: 140),

            
            TextField(
              onTap: () {
                
              },
             controller: _emailController,
             
             keyboardType: TextInputType.emailAddress,
             style: TextStyle(
             color: const Color.fromARGB(255, 255, 255, 255),
             ),
            decoration: InputDecoration(
            labelText: "E-mail",
            labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            ),
           focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: BorderSide(
           color: const Color.fromARGB(255, 255, 255, 255),
           width: 2,
             ),
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
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: Colors.white),
            
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
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
          
            const SizedBox(height: 50),

            ElevatedButton(
           onPressed: () {
           if (_emailController.text == widget.email &&
               _senhaController.text == widget.senha) {
        
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => TelaInicial()),
             );
        
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text("Acesso liberado")),
             );
        
           } else {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text("Senha ou usuário incorretos")),
             );
           }
         },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.blue,
            ),

           child: Text("Entrar"),
),

            const SizedBox(height: 180),


            InkWell(
               onTap: () {
                Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => telaCadastro()),
                 );
               },
               child: Text(
                'Não tem conta? Cadastre-se!',
                
                style: TextStyle(
                  fontSize: 20,
                   color: const Color.fromARGB(255, 255, 255, 255),
                    fontFamily: "arial"),
                ),        
            ),
          ],
        ),
      ),
    );
  }
}