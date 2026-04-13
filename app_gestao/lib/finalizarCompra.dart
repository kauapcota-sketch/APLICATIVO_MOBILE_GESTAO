import 'package:app_gestao/compras.dart';
import 'package:app_gestao/estoque.dart';
import 'package:flutter/material.dart';

class TelaCarrinho extends StatefulWidget {
  final List<Map<String, String>> carrinho;

  const TelaCarrinho({super.key, required this.carrinho});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {

  double calcularTotal() {
    double total = 0;

    for (var item in widget.carrinho) {
      String preco = item["preco"]!
          .replaceAll("R\$", "")
          .replaceAll(".", "")
          .replaceAll(",", ".");

      total += double.parse(preco);
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1C2E),

      appBar: AppBar(
        title: Text("Carrinho"),
        backgroundColor: Color(0xFF162544),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: widget.carrinho.isEmpty
          ? Center(
              child: Text(
                "Carrinho vazio 🛒",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [

                
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.carrinho.length,
                    itemBuilder: (context, index) {
                      final produto = widget.carrinho[index];

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
               
                          title: Text(produto["nome"]!),
                          subtitle: Text(produto["preco"]!),

                        
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                widget.carrinho.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

            
                Text(
                  "Total: R\$ ${calcularTotal().toStringAsFixed(2).replaceAll(".", ",")}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

           
                Text(
                  "Formas de pagamento:",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _pagamento("PayPal"),
                    _pagamento("VISA"),
                    _pagamento("Mastercard"),
                    _pagamento("Amex"),
                  ],
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9CD323),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Compra finalizada! 🛍️")),
                    );
                  },
                  child: Text(
                    
                    "Finalizar compra"
                    ),
                ),

                SizedBox(height: 15),
              ],
            ),
    );
  }

  
  Widget _pagamento(String nome) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        nome,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}