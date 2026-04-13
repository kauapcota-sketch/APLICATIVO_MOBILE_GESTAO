import 'package:app_gestao/compras.dart';
import 'package:app_gestao/estoque.dart';
import 'package:app_gestao/main.dart';
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
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  

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
              // Título principal
              const Text(
                'Gestão de estoque',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // Subtítulo
              const Text(
                'estoque farmácia',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 40),

              // Menu principal
              const Center(
                child: Text(
                  'Menu principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Botões
           ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 241, 193, 1),
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
              ),
            ),
           onPressed: () {
            Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => telaCompras()),
                 );
           },
           child: Row(
           children: [
           Icon(Icons.shopping_cart, color: const Color.fromARGB(255, 0, 0, 0),size: 30,),
           SizedBox(width: 10),
          Text(
             'Produtos',
              style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold,),
                ),
               ],
              ),
             ),
              const SizedBox(height: 20),

             ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 43, 91, 195),
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
              ),
            ),
           onPressed: () {
            Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => TelaProdutos()),
                 );
           },
           child: Row(
           children: [
           Icon(Icons.inventory_2, color: const Color.fromARGB(255, 0, 0, 0),size: 30,),
           SizedBox(width: 10),
          Text(
             'Estoque',
              style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold,),
                ),
               ],
              ),
             ),

              const SizedBox(height: 20),

               ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 76, 175, 80),
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
              ),
            ),
           onPressed: () {
            Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => telaCompras()),
                 );
           },
           child: Row(
           children: [
           Icon(Icons.location_on, color: const Color.fromARGB(255, 0, 0, 0),size: 30,),
           SizedBox(width: 10),
          Text(
             'Mapa',
              style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold,),
                ),
               ],
              ),
             ),

              const Spacer(),

              // Botão volta 
              InkWell(
                onTap: () {
                  Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => LoginPage()),
                 );
                },
                child: Text(
                  'voltar',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 26,
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


  Widget _buildButton({
    required Color color,
    required IconData icon,
    required String text,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(icon, size: 35, color: Colors.black),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}