import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const KrapowCalcApp());
}

// --- Data Models ---

class Ingredient {
  String id;
  String name;
  double price;
  String unit;

  Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
  });
}

class Packaging {
  String id;
  String name;
  double price;

  Packaging({required this.id, required this.name, required this.price});
}

class FixedCost {
  String id;
  String name;
  double amount;

  FixedCost({required this.id, required this.name, required this.amount});
}

class MenuItemData {
  String ingId;
  double quantity;

  MenuItemData({required this.ingId, required this.quantity});
}

class Menu {
  String id;
  String name;
  List<MenuItemData> items;

  Menu({required this.id, required this.name, required this.items});
}

// --- Main App ---

class KrapowCalcApp extends StatelessWidget {
  const KrapowCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krapow Calc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB), // gray-50
        fontFamily: 'Sans-Serif', // Use default or custom font
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activeTab = 'calculator';

  // --- Global State Initialization (Similar to Default Data) ---
  List<Ingredient> ingredients = [
    Ingredient(id: 'ing_1', name: 'หมูสับ', price: 0.16, unit: 'g'),
    Ingredient(id: 'ing_2', name: 'หมูชิ้น', price: 0.17, unit: 'g'),
    Ingredient(id: 'ing_3', name: 'ไก่', price: 0.12, unit: 'g'),
    Ingredient(id: 'ing_4', name: 'กุ้ง', price: 0.45, unit: 'g'),
    Ingredient(id: 'ing_5', name: 'หมึก', price: 0.28, unit: 'g'),
    Ingredient(id: 'ing_6', name: 'เนื้อวัว', price: 0.38, unit: 'g'),
    Ingredient(id: 'ing_7', name: 'เนื้อวัวสับ', price: 0.36, unit: 'g'),
    Ingredient(id: 'ing_8', name: 'ข้าว', price: 0.03, unit: 'g'),
    Ingredient(id: 'ing_9', name: 'ใบกะเพรา', price: 0.02, unit: 'g'),
    Ingredient(id: 'ing_10', name: 'พริกกระเทียม', price: 0.02, unit: 'g'),
    Ingredient(id: 'ing_11', name: 'น้ำมัน', price: 0.04, unit: 'g'),
    Ingredient(id: 'ing_12', name: 'เครื่องปรุง', price: 0.03, unit: 'g'),
    Ingredient(id: 'ing_13', name: 'ไข่ไก่', price: 4.00, unit: 'ฟอง'),
  ];

  List<Packaging> packaging = [
    Packaging(id: 'pkg_1', name: 'กล่องอาหาร', price: 3.5),
    Packaging(id: 'pkg_2', name: 'ถุง', price: 0.5),
    Packaging(id: 'pkg_3', name: 'ถ้วยน้ำจิ้ม', price: 1.0),
    Packaging(id: 'pkg_4', name: 'ช้อนส้อม', price: 0.8),
  ];

  List<FixedCost> fixedCosts = [
    FixedCost(id: 'cost_1', name: 'ค่าไฟ', amount: 300),
    FixedCost(id: 'cost_2', name: 'ค่าน้ำ', amount: 300),
    FixedCost(id: 'cost_3', name: 'ค่าแรง', amount: 6000),
    FixedCost(id: 'cost_4', name: 'ค่าแก๊ส', amount: 1000),
  ];

  double estimatedBoxes = 1200;
  double targetMargin = 20;

  late List<MenuItemData> baseRecipe;
  late List<Menu> menus;

  String? selectedMenuId;
  bool isEditingRecipe = false;

  // Temporary state for adding new items
  String newMenuName = '';
  String newCostName = '';
  String newCostAmount = '';
  String newPkgName = '';
  String newPkgPrice = '';
  String newIngName = '';
  String newIngPrice = '';
  String newIngUnit = 'g';

  // Toggle forms visibility
  bool showMenuForm = false;
  bool showCostForm = false;
  bool showPkgForm = false;
  bool showIngForm = false;

  @override
  void initState() {
    super.initState();
    baseRecipe = [
      MenuItemData(ingId: 'ing_8', quantity: 200), // Rice
      MenuItemData(ingId: 'ing_9', quantity: 10), // Basil
      MenuItemData(ingId: 'ing_10', quantity: 10), // Chili Garlic
      MenuItemData(ingId: 'ing_11', quantity: 10), // Oil
      MenuItemData(ingId: 'ing_12', quantity: 15), // Seasoning
    ];

    menus = [
      Menu(
        id: 'menu_1',
        name: 'กระเพราหมูสับ',
        items: [MenuItemData(ingId: 'ing_1', quantity: 100), ...baseRecipe],
      ),
      Menu(
        id: 'menu_2',
        name: 'กระเพราหมูชิ้น',
        items: [MenuItemData(ingId: 'ing_2', quantity: 100), ...baseRecipe],
      ),
      Menu(
        id: 'menu_3',
        name: 'กระเพราไก่ชิ้น',
        items: [MenuItemData(ingId: 'ing_3', quantity: 100), ...baseRecipe],
      ),
      Menu(
        id: 'menu_4',
        name: 'กระเพรากุ้ง',
        items: [MenuItemData(ingId: 'ing_4', quantity: 80), ...baseRecipe],
      ),
      Menu(
        id: 'menu_5',
        name: 'กระเพราหมึกวง',
        items: [MenuItemData(ingId: 'ing_5', quantity: 90), ...baseRecipe],
      ),
      Menu(
        id: 'menu_6',
        name: 'กระเพราเนื้อ',
        items: [MenuItemData(ingId: 'ing_6', quantity: 100), ...baseRecipe],
      ),
      Menu(
        id: 'menu_7',
        name: 'กระเพราเนื้อสับ',
        items: [MenuItemData(ingId: 'ing_7', quantity: 100), ...baseRecipe],
      ),
      Menu(
        id: 'menu_8',
        name: 'กระเพราไข่หมึก',
        items: [
          MenuItemData(ingId: 'ing_5', quantity: 90),
          MenuItemData(ingId: 'ing_13', quantity: 1),
          ...baseRecipe,
        ],
      ),
    ];

    if (menus.isNotEmpty) {
      selectedMenuId = menus.first.id;
    }
  }

  // --- Logic Calculations ---

  double get calculateHiddenCostPerBox {
    double totalFixed = fixedCosts.fold(0, (sum, item) => sum + item.amount);
    return estimatedBoxes > 0 ? totalFixed / estimatedBoxes : 0;
  }

  double get calculateTotalPackaging {
    return packaging.fold(0, (sum, item) => sum + item.price);
  }

  Ingredient getIngredientDetails(String ingId) {
    return ingredients.firstWhere(
      (i) => i.id == ingId,
      orElse:
          () =>
              Ingredient(id: 'unknown', name: 'Unknown', price: 0, unit: '-'),
    );
  }

  Map<String, dynamic>? get currentMenuData {
    if (selectedMenuId == null) return null;
    try {
      final menu = menus.firstWhere((m) => m.id == selectedMenuId);
      double foodCost = 0;
      List<Map<String, dynamic>> detailedItems = [];

      for (var item in menu.items) {
        final details = getIngredientDetails(item.ingId);
        final cost = details.price * item.quantity;
        foodCost += cost;
        detailedItems.add({
          ...item.toJson(), // Helper needed or manual map
          'name': details.name,
          'price': details.price,
          'unit': details.unit,
          'cost': cost,
          'rawItem': item, // Reference for editing
        });
      }

      final pkgCost = calculateTotalPackaging;
      final hiddenCost = calculateHiddenCostPerBox;
      final totalCost = foodCost + pkgCost + hiddenCost;

      final sellingPrice = totalCost * (1 + (targetMargin / 100));
      const gpRate = 0.33;
      final deliveryPrice = sellingPrice / (1 - gpRate);

      return {
        'menu': menu,
        'detailedItems': detailedItems,
        'foodCost': foodCost,
        'pkgCost': pkgCost,
        'hiddenCost': hiddenCost,
        'totalCost': totalCost,
        'sellingPrice': sellingPrice,
        'deliveryPrice': deliveryPrice,
      };
    } catch (e) {
      return null;
    }
  }

  // --- Actions ---

  void updateRecipeQuantity(MenuItemData item, String newQty) {
    setState(() {
      item.quantity = double.tryParse(newQty) ?? 0;
    });
  }

  void removeIngredientFromRecipe(int index) {
    setState(() {
      final menu = menus.firstWhere((m) => m.id == selectedMenuId);
      menu.items.removeAt(index);
    });
  }

  void addIngredientToRecipe(String ingId) {
    setState(() {
      final menu = menus.firstWhere((m) => m.id == selectedMenuId);
      // Check duplicate
      if (!menu.items.any((i) => i.ingId == ingId)) {
        menu.items.add(MenuItemData(ingId: ingId, quantity: 1));
      }
    });
  }

  void addIngredientMaster() {
    if (newIngName.isNotEmpty && newIngPrice.isNotEmpty) {
      setState(() {
        ingredients.add(
          Ingredient(
            id: 'ing_${DateTime.now().millisecondsSinceEpoch}',
            name: newIngName,
            price: double.tryParse(newIngPrice) ?? 0,
            unit: newIngUnit,
          ),
        );
        newIngName = '';
        newIngPrice = '';
        newIngUnit = 'g';
        showIngForm = false;
      });
    }
  }

  void addPackagingItem() {
    if (newPkgName.isNotEmpty && newPkgPrice.isNotEmpty) {
      setState(() {
        packaging.add(
          Packaging(
            id: 'pkg_${DateTime.now().millisecondsSinceEpoch}',
            name: newPkgName,
            price: double.tryParse(newPkgPrice) ?? 0,
          ),
        );
        newPkgName = '';
        newPkgPrice = '';
        showPkgForm = false;
      });
    }
  }

  void addFixedCost() {
    if (newCostName.isNotEmpty && newCostAmount.isNotEmpty) {
      setState(() {
        fixedCosts.add(
          FixedCost(
            id: 'cost_${DateTime.now().millisecondsSinceEpoch}',
            name: newCostName,
            amount: double.tryParse(newCostAmount) ?? 0,
          ),
        );
        newCostName = '';
        newCostAmount = '';
        showCostForm = false;
      });
    }
  }

  void addNewMenu() {
    if (newMenuName.isNotEmpty) {
      setState(() {
        final newId = 'menu_${DateTime.now().millisecondsSinceEpoch}';
        final newItems =
            baseRecipe
                .map(
                  (i) => MenuItemData(ingId: i.ingId, quantity: i.quantity),
                )
                .toList();
        menus.add(Menu(id: newId, name: newMenuName, items: newItems));
        selectedMenuId = newId;
        newMenuName = '';
        showMenuForm = false;
      });
    }
  }

  void deleteMenu(String id) {
    setState(() {
      menus.removeWhere((m) => m.id == id);
      if (selectedMenuId == id) {
        selectedMenuId = menus.isNotEmpty ? menus.first.id : null;
      }
    });
  }

  // --- UI Components ---

  @override
  Widget build(BuildContext context) {
    // Determine safe area padding for bottom nav
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  child:
                      activeTab == 'calculator'
                          ? _buildCalculatorTab()
                          : _buildSettingsTab(),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(bottomPadding),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Krapow Calc',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ระบบคำนวณต้นทุนร้านกะเพรา V2.0',
                style: TextStyle(
                  color: Colors.orange.shade100,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorTab() {
    final data = currentMenuData;
    if (data == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text(
            'กรุณาสร้างเมนูอาหารก่อน',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final double totalCost = data['totalCost'];
    final double sellingPrice = data['sellingPrice'];
    final double deliveryPrice = data['deliveryPrice'];
    final double foodCost = data['foodCost'];
    final double pkgCost = data['pkgCost'];
    final double hiddenCost = data['hiddenCost'];
    final List<dynamic> detailedItems = data['detailedItems'];

    return Column(
      children: [
        // Menu Selector
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'เมนูที่กำลังคำนวณ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.restaurant, color: Colors.deepOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedMenuId,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMenuId = newValue;
                            });
                          },
                          items:
                              menus.map<DropdownMenuItem<String>>((Menu menu) {
                                return DropdownMenuItem<String>(
                                  value: menu.id,
                                  child: Text(menu.name),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Results Cards
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey.shade800, Colors.grey.shade700],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ต้นทุนรวม/กล่อง',
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalCost.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'บาท',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange, Colors.redAccent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ราคาขายแนะนำ (${targetMargin.toInt()}%)',
                      style: TextStyle(
                        color: Colors.orange.shade100,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sellingPrice.ceil().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'บาท',
                      style: TextStyle(
                        color: Colors.orange.shade100,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Delivery Price
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ราคา Delivery (GP 33%)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  Text(
                    'ตั้งราคานี้เพื่อ cover ค่า GP',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              Text(
                '${deliveryPrice.ceil()} ฿',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Breakdown
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildBreakdownRow('ค่าวัตถุดิบ', foodCost),
              const Divider(height: 16),
              _buildBreakdownRow('ค่าบรรจุภัณฑ์', pkgCost),
              const Divider(height: 16),
              _buildBreakdownRow(
                'ต้นทุนแฝง (${estimatedBoxes.toInt()} กล่อง/ด)',
                hiddenCost,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Recipe Editor
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.orange.shade100),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 16,
                          color: Colors.deepOrange,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'สูตรอาหาร',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isEditingRecipe = !isEditingRecipe;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isEditingRecipe
                                  ? Colors.deepOrange
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isEditingRecipe
                                    ? Colors.deepOrange
                                    : Colors.deepOrange.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isEditingRecipe ? Icons.save : Icons.edit,
                              size: 12,
                              color:
                                  isEditingRecipe
                                      ? Colors.white
                                      : Colors.deepOrange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isEditingRecipe ? 'เสร็จสิ้น' : 'แก้ไขสูตร',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isEditingRecipe
                                        ? Colors.white
                                        : Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Ingredients List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: detailedItems.length,
                itemBuilder: (context, index) {
                  final item = detailedItems[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              index != detailedItems.length - 1
                                  ? Colors.grey.shade100
                                  : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'ต้นทุน: ${item['price']}/${item['unit']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isEditingRecipe) ...[
                          SizedBox(
                            width: 60,
                            height: 30,
                            child: TextField(
                              controller: TextEditingController(
                                text: item['quantity'].toString(),
                              )..selection = TextSelection.fromPosition(
                                TextPosition(
                                  offset: item['quantity'].toString().length,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(bottom: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onChanged:
                                  (val) => updateRecipeQuantity(
                                    item['rawItem'],
                                    val,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              item['unit'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => removeIngredientFromRecipe(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ] else ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Sans-Serif',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${item['quantity']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${item['unit']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${(item['cost'] as double).toStringAsFixed(2)} ฿',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),

              // Add Ingredient Dropdown (Only in Edit Mode)
              if (isEditingRecipe)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text(
                          '+ เพิ่มวัตถุดิบเข้าจานนี้',
                          style: TextStyle(fontSize: 14),
                        ),
                        isExpanded: true,
                        items:
                            ingredients
                                .where(
                                  (ing) => !detailedItems.any(
                                    (item) => item['ingId'] == ing.id,
                                  ),
                                )
                                .map(
                                  (ing) => DropdownMenuItem(
                                    value: ing.id,
                                    child: Text(ing.name),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            addIngredientToRecipe(val);
                          }
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return Column(
      children: [
        // 1. Target Margin
        _buildSettingsSection(
          icon: Icons.trending_up,
          title: 'ตั้งเป้ากำไร',
          content: Row(
            children: [
              Expanded(
                child: Slider(
                  value: targetMargin,
                  min: 0,
                  max: 100,
                  activeColor: Colors.deepOrange,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (val) => setState(() => targetMargin = val),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${targetMargin.toInt()}%',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Menu Management
        _buildSettingsSection(
          icon: Icons.store,
          title: 'จัดการเมนู',
          action: _buildAddButton(
            showMenuForm,
            () => setState(() => showMenuForm = !showMenuForm),
          ),
          content: Column(
            children: [
              if (showMenuForm)
                _buildInlineForm(
                  children: [
                    Expanded(
                      child: _buildMiniTextField(
                        'ชื่อเมนูใหม่',
                        (v) => newMenuName = v,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildMiniButton('สร้าง', addNewMenu),
                  ],
                ),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: menus.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, idx) {
                    final m = menus[idx];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            m.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => deleteMenu(m.id),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                              size: 20,
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
        const SizedBox(height: 16),

        // 3. Fixed Costs
        _buildSettingsSection(
          icon: Icons.bolt,
          title: 'ต้นทุนแฝง (ต่อเดือน)',
          action: _buildAddButton(
            showCostForm,
            () => setState(() => showCostForm = !showCostForm),
          ),
          content: Column(
            children: [
              if (showCostForm)
                _buildInlineForm(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildMiniTextField(
                        'รายการ',
                        (v) => newCostName = v,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMiniTextField(
                        'บาท',
                        (v) => newCostAmount = v,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildMiniButton('เพิ่ม', addFixedCost),
                  ],
                ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fixedCosts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, idx) {
                  final cost = fixedCosts[idx];
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          cost.name,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 30,
                        child: TextFormField(
                          initialValue: cost.amount.toString(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 14),
                          decoration: _miniInputDecoration(),
                          onChanged: (val) {
                            setState(() {
                              cost.amount = double.tryParse(val) ?? 0;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            fixedCosts.removeAt(idx);
                          });
                        },
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.inventory_2, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text(
                    'ยอดขายประเมิน (กล่อง/เดือน)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              TextField(
                controller: TextEditingController(
                  text: estimatedBoxes.toString(),
                )..selection = TextSelection.fromPosition(
                  TextPosition(offset: estimatedBoxes.toString().length),
                ),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.orange.shade50,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.orange.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.orange.shade200),
                  ),
                ),
                onChanged:
                    (val) => setState(
                      () => estimatedBoxes = double.tryParse(val) ?? 0,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFamily: 'Sans-Serif',
                    ),
                    children: [
                      const TextSpan(text: 'เฉลี่ย: '),
                      TextSpan(
                        text: calculateHiddenCostPerBox.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' บาท/กล่อง'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 4. Packaging
        _buildSettingsSection(
          icon: Icons.inventory_2,
          title: 'บรรจุภัณฑ์',
          action: _buildAddButton(
            showPkgForm,
            () => setState(() => showPkgForm = !showPkgForm),
          ),
          content: Column(
            children: [
              if (showPkgForm)
                _buildInlineForm(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildMiniTextField(
                        'ชื่อ',
                        (v) => newPkgName = v,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMiniTextField(
                        'ราคา',
                        (v) => newPkgPrice = v,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildMiniButton('+', addPackagingItem),
                  ],
                ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: packaging.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, idx) {
                  final pkg = packaging[idx];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pkg.name,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 30,
                            child: TextFormField(
                              initialValue: pkg.price.toString(),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 14),
                              decoration: _miniInputDecoration(),
                              onChanged: (val) {
                                setState(() {
                                  pkg.price = double.tryParse(val) ?? 0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'บาท',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              setState(() {
                                packaging.removeAt(idx);
                              });
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'รวมค่ากล่อง',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${calculateTotalPackaging.toStringAsFixed(2)} บาท',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 5. Ingredients Master
        _buildSettingsSection(
          icon: Icons.local_dining,
          title: 'คลังวัตถุดิบ (Master)',
          action: _buildAddButton(
            showIngForm,
            () => setState(() => showIngForm = !showIngForm),
          ),
          content: Column(
            children: [
              if (showIngForm)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildMiniTextField(
                              'ชื่อ',
                              (v) => newIngName = v,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: _buildMiniTextField(
                              'ราคา',
                              (v) => newIngPrice = v,
                              isNumber: true,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: newIngUnit,
                                isDense: true,
                                items:
                                    ['g', 'ฟอง', 'ชิ้น', 'ml']
                                        .map(
                                          (u) => DropdownMenuItem(
                                            value: u,
                                            child: Text(
                                              u,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (v) => setState(() => newIngUnit = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: addIngredientMaster,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('เพิ่มวัตถุดิบ'),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: ingredients.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, idx) {
                    final ing = ingredients[idx];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ing.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 30,
                              child: TextFormField(
                                initialValue: ing.price.toString(),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                                decoration: _miniInputDecoration(),
                                onChanged: (val) {
                                  // Update without setState to avoid redraw loop while typing
                                  ing.price = double.tryParse(val) ?? 0;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30,
                              child: Text(
                                '/${ing.unit}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  ingredients.removeAt(idx);
                                });
                              },
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper Widgets for Settings
  Widget _buildSettingsSection({
    required IconData icon,
    required String title,
    Widget? action,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.deepOrange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              ?action,
            ],
          ),
          const Divider(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildAddButton(bool isOpen, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isOpen ? Icons.close : Icons.add,
          color: Colors.deepOrange,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildInlineForm({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: children),
    );
  }

  Widget _buildMiniTextField(
    String hint,
    Function(String) onChanged, {
    bool isNumber = false,
  }) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.only(bottom: 12, left: 8),
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 12),
        ),
        style: const TextStyle(fontSize: 14),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMiniButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(text),
    );
  }

  InputDecoration _miniInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.orange),
      ),
    );
  }

  Widget _buildBottomNav(double bottomPadding) {
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding + 10, top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('calculator', Icons.calculate, 'คำนวณ'),
          _buildNavItem('settings', Icons.settings, 'ตั้งค่า'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String tabId, IconData icon, String label) {
    final bool isActive = activeTab == tabId;
    return GestureDetector(
      onTap: () => setState(() => activeTab = tabId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        transform:
            isActive
                ? Matrix4.translationValues(0, -5, 0)
                : Matrix4.translationValues(0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.deepOrange : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.deepOrange : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to simple json logic for map
extension MenuItemDataJson on MenuItemData {
  Map<String, dynamic> toJson() => {'ingId': ingId, 'quantity': quantity};
}