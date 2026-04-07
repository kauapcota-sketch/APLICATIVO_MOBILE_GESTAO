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
      home: const telaCompras(),
    );
  }
}

class telaCompras extends StatefulWidget {
  const telaCompras({super.key});
  
  @override
  State<telaCompras> createState() => _PaginaCompras();
}


class _PaginaCompras extends State<telaCompras> {
  final List<Map<String, String>> produtos = [
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3209/3209265.png",
      "preco": "R\$ 263,29"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771551.png",
      "preco": "R\$ 19,99"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771556.png",
      "preco": "R\$ 200,39"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771560.png",
      "preco": "R\$ 82,99"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771551.png",
      "preco": "R\$ 25,70"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771556.png",
      "preco": "R\$ 9,29"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771560.png",
      "preco": "R\$ 10,29"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771551.png",
      "preco": "R\$ 79,99"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771560.png",
      "preco": "R\$ 57,39"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771556.png",
      "preco": "R\$ 32,70"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/512/3771/3771560.png",
      "preco": "R\$ 51,99"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1C2E),
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 Barra superior
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                 IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaInicial()),
                );
                  
             
                    },
                   ),

                  SizedBox(width: 10),

                  // 🔍 Busca
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.search, color: Colors.white70),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  // 🛒 Carrinho 
                  Stack(
                    children: [
                      IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                     onPressed: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaInicial()),
                     );
                    },
                   ),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🛍️ Lista de produtos
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: produtos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final produto = produtos[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          produto["img"]!,
                          height: 70,
                        ),
                        SizedBox(height: 10),
                        Text(
                          produto["preco"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}