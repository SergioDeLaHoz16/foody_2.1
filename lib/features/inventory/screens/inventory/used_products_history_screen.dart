import 'package:flutter/material.dart';
import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/features/auth/controllers/controllers.dart';

class UsedProductsHistoryScreen extends StatefulWidget {
  const UsedProductsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<UsedProductsHistoryScreen> createState() =>
      _UsedProductsHistoryScreenState();
}

class _UsedProductsHistoryScreenState extends State<UsedProductsHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final userEmail = AuthController().user.correo ?? '';
    final collection = MongoDBHelper.db.collection('used_products');
    final result = await collection.find({'usedBy': userEmail}).toList();
    final history = result.cast<Map<String, dynamic>>();
    // Ordenar por fecha descendente en Dart
    history.sort((a, b) {
      final aDate = DateTime.tryParse(a['usedDate'] ?? '') ?? DateTime(1970);
      final bDate = DateTime.tryParse(b['usedDate'] ?? '') ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    return history;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Productos Usados'),
        backgroundColor: isDark ? CColors.dark : CColors.light,
        iconTheme: IconThemeData(
          color: isDark ? CColors.light : CColors.primaryTextColor,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar historial: ${snapshot.error}'),
            );
          }
          final history = snapshot.data ?? [];
          if (history.isEmpty) {
            return const Center(
              child: Text('No hay historial de productos usados.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.blue),
                title: Text(
                  '${item['productName']} (x${item['usedQuantity']})',
                ),
                subtitle: Text('Receta: ${item['recipeName']}'),
                trailing: Text(
                  item['usedDate'] != null
                      ? DateTime.tryParse(item['usedDate']) != null
                          ? _formatDate(DateTime.parse(item['usedDate']))
                          : item['usedDate']
                      : '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
