

import 'package:app_gestao/inicial.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const telaCadastro(),
    );
  }
}

class telaCadastro extends StatefulWidget {
  const telaCadastro({super.key});
  
  @override
  State<telaCadastro> createState() => _PaginaCadastro();

}

 class _PaginaCadastro extends State<telaCadastro> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final  _obscure = true;


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F2A44),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              const Text(
                'Gestão de estoque',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'estoque farmácia',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),

              SizedBox(height: 40),

              const Center(
                child: Text(
                  'Tela cadastro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 30),

              TextField(        
             keyboardType: TextInputType.emailAddress,
             style: TextStyle(
             color: Colors.white,
             ),
            decoration: InputDecoration(
            labelText: "E-mail",
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            ),
           focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: BorderSide(
           color: Colors.white,
           width: 2,
             ),
            ),
           ),
          ),
              

              SizedBox(height: 15),

              // Campo Senha
             TextField(
               controller: senhaController,
               obscureText: _obscure,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: Colors.white,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
                 focusedBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                   borderSide: BorderSide(
                   color: const Color.fromARGB(255, 255, 255, 255),
                  width: 2,
                 ),
              ),
            ),
            ),


              SizedBox(height: 15),

          
               TextField(        
             keyboardType: TextInputType.emailAddress,
             style: TextStyle(
             color: Colors.white,
             ),
            decoration: InputDecoration(
            labelText: "Endereço",
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            ),
           focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: BorderSide(
           color: Colors.white,
           width: 2,
             ),
            ),
           ),
          ),
           

              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              
             ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaInicial()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.blue,
            
                
              ),
              child: const Text("Entrar", style: TextStyle(fontSize: 18)),
            ),

                 
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                    height: 120,
                  ),
                ],
              ),

              Spacer(),

              // Voltar
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'voltar',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildInput(TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
