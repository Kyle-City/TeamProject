import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'dart:core';
import 'dart:io';
import 'config/network_config.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  // 表单状态变量
  String? _selectedClassification;
  String _selectedWeightUnit = 'kg';
  
  // 图片选择相关变量
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  // TextEditingController
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _shelfLifeController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  // 分类选项
  final List<String> _classifications = [
    'Vegetables',
    'Fruits', 
    'Meat',
    'Seafood',
    'Dairy',
    'Grains',
    'Spices',
    'Others'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _shelfLifeController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // 禁止页面随键盘弹出而调整布局
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0xFFFFFBF8), // 0% 位置
              Color(0xFFFFF4E0), // 50% 位置
              Color(0xFFFFF1D8), // 100% 位置
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部标题栏
              Container(
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      left: 32,
                      top: 24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/warehouse_page/Back.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 27,
                      child: Center(
                        child: Text(
                          'Enter ingredients',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 表单区域
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      
                      // 第一行：图片上传 + Name + Classification
                      Row(
                        children: [
                          // 左侧：图片显示区域（可点击选择图片）
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 182,
                              height: 182,
                              decoration: BoxDecoration(
                                color: Color(0xFFFDFDFD),
                                border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _selectedImagePath != null
                                    ? Image.file(
                                        File(_selectedImagePath!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.broken_image,
                                              color: Colors.grey[400],
                                              size: 50,
                                            ),
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/warehouse_page/MR.png',
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        ),
                          
                          SizedBox(width: 20),
                          
                          // 右侧：Name 和 Classification 输入框
                          Expanded(
                            child: Column(
                              children: [
                                // Name 输入框
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: 164,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFDFDFD),
                                        border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: TextField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Please enter',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Classification 下拉选择
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'classification',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: 164,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFDFDFD),
                                        border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFFFBC3F).withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedClassification,
                                          hint: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            child: Text(
                                              'selection',
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          icon: Padding(
                                            padding: EdgeInsets.only(right: 12),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Color(0xFFFFBC3F),
                                              size: 20,
                                            ),
                                          ),
                                          isExpanded: true,
                                          selectedItemBuilder: (BuildContext context) {
                                            return _classifications.map((String value) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(horizontal: 16),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _selectedClassification ?? value,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            }).toList();
                                          },
                                          items: _classifications.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Container(
                                                constraints: BoxConstraints(maxWidth: 120),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedClassification = newValue;
                                            });
                                          },
                                          dropdownColor: Color(0xFFFDFDFD),
                                          borderRadius: BorderRadius.circular(12),
                                          elevation: 8,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          menuMaxHeight: 300,
                                          itemHeight: 48,
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // 第二行：Weight 输入框
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'weight',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 382,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFFDFDFD),
                              border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                // 输入框部分
                                Expanded(
                                  child: TextField(
                                    controller: _weightController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Please enter a number',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                  ),
                                ),
                                // 单位选择部分
                                Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // kg 单选
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedWeightUnit = 'kg';
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: _selectedWeightUnit == 'kg' 
                                                      ? Color(0xFFFFBC3F) 
                                                      : Colors.grey,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _selectedWeightUnit == 'kg' 
                                                        ? Color(0xFFFFBC3F) 
                                                        : Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'kg',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: _selectedWeightUnit == 'kg' 
                                                    ? Color(0xFFFFBC3F) 
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      // g 单选
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedWeightUnit = 'g';
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: _selectedWeightUnit == 'g' 
                                                      ? Color(0xFFFFBC3F) 
                                                      : Colors.grey,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _selectedWeightUnit == 'g' 
                                                        ? Color(0xFFFFBC3F) 
                                                        : Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'g',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: _selectedWeightUnit == 'g' 
                                                    ? Color(0xFFFFBC3F) 
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // 第三行：Shelf Life 输入框
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'shelf life',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 382,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFFDFDFD),
                              border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                // 输入框部分
                                Expanded(
                                   child: TextField(
                                     controller: _shelfLifeController,
                                     keyboardType: TextInputType.number,
                                     decoration: InputDecoration(
                                       hintText: 'Please enter a number',
                                       border: InputBorder.none,
                                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                     ),
                                   ),
                                 ),
                                // Days 文字
                                Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Text(
                                    'Days',
                                    style: TextStyle(
                                      color: Color(0xFFFFBC3F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // 第四行：Remarks 输入框
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'remarks',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 382,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFFDFDFD),
                              border: Border.all(color: Color(0xFFFFBC3F), width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: _remarksController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Please enter remarks',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 40),
                      
                      // 提交按钮
                      // 提交按钮
                      GestureDetector(
                        onTap: _submitForm,
                        child: Image.asset(
                          'assets/warehouse_page/submit.png',
                          width: 240,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 图片选择方法
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 表单提交方法
  void _submitForm() async {
    // 必填校验
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter ingredient name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  
    if (_selectedClassification == null || _selectedClassification!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a classification'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  
    if (_weightController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter weight'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  
    if (_shelfLifeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter shelf life'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  
    // 重量单位转换
    int weightInGrams;
    try {
      double weightValue = double.parse(_weightController.text.trim());
      if (_selectedWeightUnit == 'kg') {
        weightInGrams = (weightValue * 1000).round();
      } else {
        weightInGrams = weightValue.round();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid weight format'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  
    // 准备提交数据
    final String apiUrl = '${ApiEndpoints.food}/add';

    try {
      // 创建multipart请求
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
      // 添加字段
      request.fields['ingredient_name'] = _nameController.text.trim();
      
      // 计算过期日期：当前日期 + 用户输入的天数
      try {
        int shelfLifeDays = int.parse(_shelfLifeController.text.trim());
        DateTime now = DateTime.now();
        DateTime expirationDate = now.add(Duration(days: shelfLifeDays));
        
        // 格式化为 yyyy-MM-dd
        String formattedDate = '${expirationDate.year}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}';
        request.fields['expiration_period'] = formattedDate;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid shelf life format'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      request.fields['comment'] = _remarksController.text.trim();
      request.fields['number'] = weightInGrams.toString();
      request.fields['category'] = _selectedClassification!;
      request.fields['avatar'] = _selectedClassification!; // 设置avatar与category相同的字符串
  
      // 发送请求
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
  
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
  
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ingredient added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // 返回到主页并选中仓库页面
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add ingredient: ${response.statusCode} - ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error submitting form: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}