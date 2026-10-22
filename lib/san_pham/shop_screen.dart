    import 'dart:async';
    import 'package:flutter/material.dart';
    import 'package:vi_dieu_khien_iot/data/app_colors.dart';
    import 'package:vi_dieu_khien_iot/san_pham/product_mode1.dart';
    import 'widgets/product_card.dart';
    import 'widgets/search_filter_bar.dart';
    import 'widgets/add_product_dialog.dart';
    import 'widgets/add_product_button.dart';
    import 'package:vi_dieu_khien_iot/san_pham/product_detail_screen.dart';
    import 'package:vi_dieu_khien_iot/thongtincanha/my_orders_screen.dart';

    class ShopScreen extends StatefulWidget {
      const ShopScreen({super.key});

      @override
      State<ShopScreen> createState() => _ShopScreenState();
    }

    class _ShopScreenState extends State<ShopScreen> {
      int _selectedCategoryIndex = 0;
      final TextEditingController _searchController = TextEditingController();
      String _searchQuery = '';

      final PageController _pageController = PageController(viewportFraction: 0.92);
      int _currentPage = 0;
      Timer? _timer;

      List<Product> get _bannerProducts {
        if (ProductData.products.isEmpty) return [];
        return ProductData.products.take(5).toList();
      }

      @override
      void initState() {
        super.initState();
        _startAutoScroll();
      }

      void _startAutoScroll() {
        _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
          if (_bannerProducts.isEmpty) return;

          if (_currentPage < _bannerProducts.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }

          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
          }
        });
      }

      @override
      void dispose() {
        _timer?.cancel();
        _pageController.dispose();
        _searchController.dispose();
        super.dispose();
      }

      void _deleteProduct(int indexInGlobalList) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
        final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: cardColor,
            title: Text('Xóa sản phẩm', style: TextStyle(color: textColor)),
            content: Text(
              'Bạn có chắc chắn muốn xóa sản phẩm này không?',
              style: TextStyle(color: textColor.withValues(alpha: 0.7)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(color: textColor.withValues(alpha: 0.5))),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    ProductData.products.removeAt(indexInGlobalList);
                  });
                  Navigator.pop(context);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã xóa sản phẩm thành công!')),
                    );
                  }
                },
                child: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        );
      }

      Future<void> _editProduct(int indexInGlobalList, Product product) async {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
        final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;
        final subColor = isDarkMode ? AppColors.greenLight.withValues(alpha: 0.6) : Colors.grey[700]!;
        final primaryLight = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;

        final updatedProduct = await showDialog<Product>(
          context: context,
          builder: (context) => AddProductDialog(
            cardColor: cardColor,
            textColor: textColor,
            subTextColor: subColor,
            primaryLight: primaryLight,
            productToEdit: product,
          ),
        );

        if (updatedProduct != null) {
          setState(() {
            ProductData.products[indexInGlobalList] = updatedProduct;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật sản phẩm thành công!')),
            );
          }
        }
      }

      @override
      Widget build(BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        // 👇 MÀU SẮC ĐỒNG BỘ & MỀM MẠI
        final bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;
        final cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
        final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;
        final subTextColor = isDarkMode ? AppColors.greenLight.withValues(alpha: 0.6) : Colors.grey[600]!;
        final primaryLight = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;

        // 👇 APPBAR: Đổi sang màu sáng để không bị "đen thui"
        final appBarColor = isDarkMode ? AppColors.navyDark : Colors.white;
        final appBarIconColor = isDarkMode ? Colors.white : AppColors.navyDark;

        final categories = ProductData.categories;

        final displayProducts = ProductData.products.where((p) {
          final matchCategory = _selectedCategoryIndex == 0 ||
              p.category == categories[_selectedCategoryIndex];
          final matchSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchCategory && matchSearch;
        }).toList();

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0, // Bỏ đổ bóng để phẳng và sạch
            iconTheme: IconThemeData(color: appBarIconColor),
            title: Text(
              'IoT Store',
              style: TextStyle(color: appBarIconColor, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: appBarIconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyOrdersScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: AddProductButton(
            cardColor: cardColor,
            textColor: textColor,
            subTextColor: subTextColor,
            primaryLight: primaryLight,
            onProductAdded: () {
              setState(() {
                _selectedCategoryIndex = 0;
                _searchController.clear();
                _searchQuery = '';
              });
            },
          ),

          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    AspectRatio(
                      aspectRatio: 2.2,
                      child: _bannerProducts.isEmpty
                          ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(child: Text('Chưa có sản phẩm nào', style: TextStyle(color: textColor))),
                      )
                          : PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemCount: _bannerProducts.length,
                        itemBuilder: (context, index) {
                          final product = _bannerProducts[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: cardColor,
                                      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                                    ),
                                  ),
                                  // 👇 Đổi Gradient sang tông Xanh Navy mờ
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          AppColors.navyDark.withValues(alpha: 0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 80,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product.price,
                                          style: const TextStyle(
                                            color: AppColors.greenLight,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 👇 Nút Mua Ngay màu Navy
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailScreen(product: product),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isDarkMode ? AppColors.greenPastel : AppColors.navyDark, // Đổi sang màu tối/sáng
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'MUA NGAY',
                                          style: TextStyle(
                                            color: isDarkMode ? AppColors.navyDark : Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Nhãn HOT
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.pink,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'HOT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_bannerProducts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _bannerProducts.length,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: _currentPage == index ? 18 : 6,
                              decoration: BoxDecoration(
                                color: _currentPage == index ? primaryLight : subTextColor.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: SearchFilterBar(
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  onSearchChanged: (value) => setState(() => _searchQuery = value),
                  onClearSearch: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  categories: categories,
                  selectedCategoryIndex: _selectedCategoryIndex,
                  onCategorySelected: (index) => setState(() => _selectedCategoryIndex = index),
                  cardColor: cardColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primaryLight: primaryLight,
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Tất cả sản phẩm',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              displayProducts.isEmpty
                  ? SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Không tìm thấy sản phẩm nào',
                    style: TextStyle(color: subTextColor, fontSize: 16),
                  ),
                ),
              )
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = displayProducts[index];
                    final originalIndex = ProductData.products.indexOf(product);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ProductCard(
                        product: product,
                        index: index,
                        isDarkMode: isDarkMode,
                        onEdit: () => _editProduct(originalIndex, product),
                        onDelete: () => _deleteProduct(originalIndex),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: displayProducts.length,
                ),
              ),
            ],
          ),
        );
      }
    }