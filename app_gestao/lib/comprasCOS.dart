import 'package:app_gestao/compras.dart';
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
      home: const telaComprascos(),
    );
  }
}

class telaComprascos extends StatefulWidget {
  final List<Map<String, String>>? carrinho;

  const telaComprascos({super.key, this.carrinho});

  @override
  State<telaComprascos> createState() => _PaginaComprasCos();
}

class _PaginaComprasCos extends State<telaComprascos> {

  TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> produtos = [
    {
      "nome": "Protetor Solar FPS 50",
      "img": "",
      "preco": "R\$ 45,90"
    },
    {
      "nome": "Hidratante Corporal",
      "img": "",
      "preco": "R\$ 32,50"
    },
    {
      "nome": "Shampoo Anticaspa",
      "img": "",
      "preco": "R\$ 18,90"
    },
    {
      "nome": "Condicionador Hidratante",
      "img": "",
      "preco": "R\$ 20,00"
    },
    {
      "nome": "Creme Facial Noturno",
      "img": "",
      "preco": "R\$ 89,90"
    },
    {
      "nome": "Sérum Vitamina C",
      "img": "",
      "preco": "R\$ 120,00"
    },
    {
      "nome": "Gel de Limpeza Facial",
      "img": "",
      "preco": "R\$ 35,00"
    },
    {
      "nome": "Demaquilante Bifásico",
      "img": "",
      "preco": "R\$ 28,90"
    },
    {
      "nome": "Desodorante Roll-on",
      "img": "",
      "preco": "R\$ 14,90"
    },
    {
      "nome": "Sabonete Líquido Íntimo",
      "img": "",
      "preco": "R\$ 22,50"
    },
    {
      "nome": "Óleo de Amêndoas",
      "img": "",
      "preco": "R\$ 55,00"
    },
  ];

  List<Map<String, String>> produtosFiltrados = [];
  late List<Map<String, String>> carrinho;

  @override
  void initState() {
    super.initState();
    produtosFiltrados = produtos;
    // Usa o carrinho recebido por parâmetro ou cria um novo
    carrinho = widget.carrinho ?? [];
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => telaCompras(carrinho: carrinho),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Remédios"),
                      ),

                      SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Cosméticos"),
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
                          content: Text("${produto["nome"]} adicionado ao carrinho"),
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