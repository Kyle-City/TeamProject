import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String recipeName;
  final List<String> requiredIngredients;
  final List<String> steps;

  const RecipeDetailsPage({
    super.key,
    required this.recipeName,
    required this.requiredIngredients,
    required this.steps,
  });

  // 解析食材字符串，按最后一个空格拆分name和amount
  Map<String, String> _parseIngredient(String ingredient) {
    final lastSpaceIndex = ingredient.lastIndexOf(' ');
    if (lastSpaceIndex == -1) {
      // 没有空格，整行当name，amount为空
      return {
        'name': ingredient,
        'amount': '',
      };
    } else {
      // 按最后一个空格拆分
      return {
        'name': ingredient.substring(0, lastSpaceIndex),
        'amount': ingredient.substring(lastSpaceIndex + 1),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
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
      child: Column(
        children: [
          // 顶部标题栏
          Container(
            padding: const EdgeInsets.only(
              left: 32,
              right: 32,
              top: 52,
            ),
            child: Row(
              children: [
                // 返回按钮
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/aicook_page/Back.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
                
                // 标题
                Expanded(
                  child: Center(
                      child: Text(
                        recipeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF000000),
                          decoration: TextDecoration.none,
                          decorationColor: Colors.transparent,
                        ),
                      ),
                    ),
                ),
                
                // 占位符保持标题居中
                const SizedBox(width: 24),
              ],
            ),
          ),
          
          // 主要内容区
          Container(
            margin: const EdgeInsets.only(
              left: 32,
              right: 32,
              top: 16,
            ),
            width: double.infinity,
            height: 900,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(128, 128, 128, 0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 食材清单区域
                    const SizedBox(height: 20),
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:Color(0xFFFFBC3F),
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // 食材列表
                    Column(
                      children: requiredIngredients.map((ingredient) {
                        final parsed = _parseIngredient(ingredient);
                        return Column(
                          children: [
                            _buildIngredientRow(parsed['name']!, parsed['amount']!),
                            if (ingredient != requiredIngredients.last) _buildDivider(),
                          ],
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 20), // 食材列表和步骤说明之间的8px间隔
                    
                    // 步骤说明区域标题
                    const Text(
                      'To Cook',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFBC3F),
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                      ),
                    ),
                    
                    const SizedBox(height: 12), // 标题和步骤内容之间的间隔
                    
                    // 步骤说明内容
                    ...steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 20),
                          _buildStepSection('Step${index + 1}', step),
                        ],
                      );
                    }),
                    
                    const SizedBox(height: 30), // 底部间距
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建食材行
  Widget _buildIngredientRow(String name, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  // 构建灰色虚线分隔符
  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Color(0xFF9B9B9B),
    );
  }

  // 构建步骤区域
  Widget _buildStepSection(String stepTitle, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stepTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.4,
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}