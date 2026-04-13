import 'package:app_gestao/inicial.dart';
import 'package:flutter/material.dart';

class TelaProdutos extends StatelessWidget {
  const TelaProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    final produtos = [
      "Soro Fisiológico 0,9% Sorimax - Farmax",
      "Brometo de ipratrópio (0,02 mg e 0,25 mg).",
      "Dipropionato de beclometasona",
      "Glibenclamida (5 mg)",
      "Insulina humana NPH.",
      "Besilato de anlodipino (5 mg).",
      "Captopril (25 mg).",
      "Maleato de enalapril (10 mg).",
      "Budesonida (32 mcg e 50 mcg).",
      "Sinvastatina (10 mg, 20 mg e 40 mg).",
      "Losartana potássica (50 mg).",
    ];

    return Scaffold(
      backgroundColor: Color(0xFF0A1A33),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,  
        
          ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "produtos :",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

           
            Expanded(
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  return _cardProduto(produtos[index]);
                },
              ),
            ),

            
          ],
        ),
      ),
    );
  }

  Widget _cardProduto(String texto) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF162544),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.medication, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}