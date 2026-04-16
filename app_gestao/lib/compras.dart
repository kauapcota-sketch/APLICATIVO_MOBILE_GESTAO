import 'package:app_gestao/finalizarCompra.dart';
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

  TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> produtos = [
    {
      "nome": "Soro Fisiológico 0,9% Sorimax - Farmax",
      "img": "",
      "preco": "R\$ 263,29"
    },
    {
      "nome": "Brometo de ipratrópio (0,02 mg e 0,25 mg)",
      "img": "",
      "preco": "R\$ 19,99"
    },
    {
      "nome": "Dipropionato de beclometasona",
      "img": "",
      "preco": "R\$ 200,39"
    },
    {
      "nome": "Glibenclamida (5 mg)",
      "img": "",
      "preco": "R\$ 82,99"
    },
    {
      "nome": "Insulina humana NPH",
      "img": "",
      "preco": "R\$ 25,70"
    },
    {
      "nome": "Besilato de anlodipino (5 mg)",
      "img": "",
      "preco": "R\$ 9,29"
    },
    {
      "nome": "Captopril (25 mg)",
      "img": "",
      "preco": "R\$ 9,29"
    },
    {
      "nome": "Maleato de enalapril (10 mg)",
      "img": "",
      "preco": "R\$ 9,29"
    },
    {
      "nome": "Budesonida (32 mcg e 50 mcg)",
      "img": "",
      "preco": "R\$ 9,29"
    },
    {
      "nome": "Sinvastatina (10 mg, 20 mg e 40 mg)",
      "img": "",
      "preco": "R\$ 9,29"
    },
    {
      "nome": "Losartana potássica (50 mg)",
      "img": "",
      "preco": "R\$ 9,29"
    },
    
  ];

  List<Map<String, String>> produtosFiltrados = [];
  List<Map<String, String>> carrinho = []; 

  @override
  void initState() {
    super.initState();
    produtosFiltrados = produtos;
  }

  void filtrar(String valor) {
    setState(() {
      produtosFiltrados = produtos.where((produto) {
        final nome = produto["nome"]!.toLowerCase();
        return nome.contains(valor.toLowerCase());
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1C2E),
      body: SafeArea(
        child: Column(
          children: [

         

            Padding(
  padding: const EdgeInsets.all(10),
  child: Column(
    children: [

      // 🔝 LINHA ORIGINAL (busca + ícones)
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaInicial()),
              );
            },
          ),

          SizedBox(width: 10),

          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: filtrar,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Buscar...",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(width: 10),

          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TelaCarrinho(carrinho: carrinho),
                    ),
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
                    carrinho.length.toString(),
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

      SizedBox(height: 10),

      // 🔥 DUAS CAIXAS (Remédios / Cosméticos)
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // REMÉDIOS
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Remédios",
              style: TextStyle(color: Colors.white),
            ),
          ),

          SizedBox(width: 10),

          // COSMÉTICOS
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Cosméticos",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ],
  ),
),

          
            
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: produtosFiltrados.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final produto = produtosFiltrados[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        carrinho.add(produto);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("${produto["nome"]} adicionado ao carrinho"),
                        ),
                      ); 
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(produto["img"]!, height: 70),
                          SizedBox(height: 10),
                          Text(produto["preco"]!),
                          Text(produto["nome"]!),
                        ],
                      ),
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