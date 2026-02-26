import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const WageCalculatorApp());
}

class WageCalculatorApp extends StatelessWidget {
  const WageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wage Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WageCalculatorScreen(),
    );
  }
}

class WageCalculatorScreen extends StatefulWidget {
  const WageCalculatorScreen({super.key});

  @override
  State<WageCalculatorScreen> createState() => _WageCalculatorScreenState();
}

abstract class Item {
  TextEditingController quantityController = TextEditingController();
  
  double get quantity => double.tryParse(quantityController.text) ?? 0;
  double get itemTotalWeight;
  String get itemType;

  void dispose() {
    quantityController.dispose();
  }
}

class SackItem extends Item {
  TextEditingController weightController = TextEditingController();

  double get weight => double.tryParse(weightController.text) ?? 0;
  
  @override
  double get itemTotalWeight => quantity * weight;
  
  @override
  String get itemType => 'sack';

  @override
  void dispose() {
    super.dispose();
    weightController.dispose();
  }
}

class BoxItem extends Item {
  @override
  double get itemTotalWeight => 0; // Boxes don't contribute to weight
  
  @override
  String get itemType => 'box';
}

class _WageCalculatorScreenState extends State<WageCalculatorScreen> {
  late List<Item> items;
  late TextEditingController wageRateController;

  @override
  void initState() {
    super.initState();
    items = [SackItem()];
    wageRateController = TextEditingController(text: '30');
  }

  @override
  void dispose() {
    for (var item in items) {
      item.dispose();
    }
    wageRateController.dispose();
    super.dispose();
  }

  void addSack() {
    setState(() {
      items.add(SackItem());
    });
  }

  void addBox() {
    setState(() {
      items.add(BoxItem());
    });
  }

  void removeItem(int index) {
    setState(() {
      items[index].dispose();
      items.removeAt(index);
    });
  }

  double getTotalWeight() {
    return items.fold(0.0, (sum, item) => sum + item.itemTotalWeight);
  }

  double calculateWage() {
    double totalWeight = getTotalWeight();
    double wageRate = double.tryParse(wageRateController.text) ?? 0;
    return (totalWeight * wageRate) / 100;
  }

  Widget _styledNumber(double value, TextStyle style, {String prefix = '', String suffix = ''}) {
    final s = value.toStringAsFixed(2);
    final parts = s.split('.');
    final integer = parts[0];
    final integerFormatted = NumberFormat('#,##0', 'en_US').format(int.parse(integer));
    final decimal = '.' + parts[1];
    final baseColor = style.color ?? DefaultTextStyle.of(context).style.color ?? Colors.black;
    final decimalStyle = style.copyWith(color: baseColor.withOpacity(0.5));

    return RichText(
      text: TextSpan(
        children: [
          if (prefix.isNotEmpty) TextSpan(text: prefix, style: style),
          TextSpan(text: integerFormatted, style: style),
          TextSpan(text: decimal, style: decimalStyle),
          if (suffix.isNotEmpty) TextSpan(text: suffix, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalWeight = getTotalWeight();
    double wage = calculateWage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wage Calculator'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Items List
            // const Text(
            //   'Items',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSack = item is SackItem;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Item ${index + 1} (${isSack ? 'Sack' : 'Box'})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            if (items.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeItem(index),
                                iconSize: 24,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                visualDensity: VisualDensity.compact,
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (isSack)
                          Row(
                            children: [
                              Expanded(
                                flex: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Quantity',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    TextField(
                                      controller: item.quantityController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'बोरा',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                      onChanged: (_) {
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Weight (kg)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    TextField(
                                      controller: (item as SackItem).weightController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'वजन',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                      onChanged: (_) {
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Gross Weight (kg)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue.shade200),
                                      ),
                                      child: Center(
                                        child: _styledNumber(
                                          item.itemTotalWeight,
                                          const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    controller: item.quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Number of boxes',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                    ),
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Add Item Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: addSack,
                    icon: const ImageIcon(AssetImage("assets/icons/sack_icon.png"), size:24),
                    label: const Text('Add बोरा'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: addBox,
                    icon: const ImageIcon(AssetImage("assets/icons/box_icon.png"), size:24),
                    label: const Text('Add कार्टून'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Summary Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Total Weight Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Weight / कुल वजन:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        _styledNumber(
                          totalWeight,
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                          suffix: ' kg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Wage Rate Input
                  TextField(
                    controller: wageRateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Wage Rate - Rs (per 100 kg)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      suffix: Text('रु ${wageRateController.text} प्रति कुइन्टल'),
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  // Wage Calculation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Wage / ज्याला:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        _styledNumber(
                          wage,
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                          prefix: 'Rs ',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Formula Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: const Text(
                      'Formula: Wage = (Total Weight × Wage Rate) ÷ 100',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
