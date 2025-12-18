import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/customTextField.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/app_texts.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/helpler_classes/util.dart';
import 'package:ladenlaunch/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ladenlaunch/viewmodel/business_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  final InAppPurchase _iap = InAppPurchase.instance;

  bool _available = false;
  List<ProductDetails> _products = [];
  bool _loading = true;
  bool _isPurchasing = false;

  late StreamSubscription<List<PurchaseDetails>> _purchaseSub;
  final String _productId = 'com.live.monthly';
  bool _isSubscribed = false;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _initStore();               // load products + setup listener
    Picker.showLoading();
   _isSubscribed = await SubscriptionService().isSubscribed();
    Picker.hideLoading();// now check status
  print(_isSubscribed);
  }

  @override
  void dispose() {
    _purchaseSub.cancel();
    super.dispose();
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      List<PurchaseDetails> purchases = [];

      final StreamSubscription<List<PurchaseDetails>> tempSub =
      _iap.purchaseStream.listen((data) {
        purchases = data;
      });

      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 2));
      await tempSub.cancel();

      final active = purchases.any(
            (p) =>
        p.productID == _productId &&
            (p.status == PurchaseStatus.purchased ||
                p.status == PurchaseStatus.restored),
      );

      if (mounted) {
        print(_isSubscribed);
        setState(() => _isSubscribed = active);
      }
    } catch (e) {
      debugPrint("Check subscription failed: $e");
    }
  }

  Future<void> _initStore() async {
    _available = await _iap.isAvailable();

    if (!_available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('store_not_available'.tr)),
      );
      setState(() => _loading = false);
      return;
    }

    const ids = {'com.live.monthly'};
    final response = await _iap.queryProductDetails(ids);

    if (response.error != null || response.productDetails.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error?.message ?? "no_products_found".tr}')),
      );
      setState(() => _loading = false);
      return;
    }

    _products = response.productDetails;

    // Listen to purchase updates safely
    _purchaseSub = _iap.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onError: (error) {
        if (mounted) {
          setState(() => _isPurchasing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('purchase_stream_error'.tr)
            ),
          );
        }
      },
    );

    if (!mounted) return;
    setState(() => _loading = false);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      debugPrint('Purchase status: ${purchase.status} (${purchase.productID})');

      switch (purchase.status) {
        case PurchaseStatus.pending:
          if (mounted) setState(() => _isPurchasing = true);
          break;

        case PurchaseStatus.purchased:
          await _verifyPurchase(purchase); // new purchase only
          await _iap.completePurchase(purchase);
        case PurchaseStatus.restored:

          if (mounted) {
            setState(() {
              _isSubscribed = true;
              _isPurchasing = false; // ✅ stop loader
            });
          }

          await _iap.completePurchase(purchase);
          break;

        case PurchaseStatus.error:
          if (purchase.error?.message.contains("cancelled") ?? false) {
            // ✅ User cancelled — show light message or ignore
            debugPrint("User cancelled purchase.");
            if (mounted) {
              setState(() => _isPurchasing = false);
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("purchase_cancelled".tr)),
              );
            }
          } else {
            // ❌ Real error
            if (mounted) {
              setState(() => _isPurchasing = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error: ${purchase.error?.message ?? "Purchase failed"}',
                  ),
                ),
              );
            }
          }
          break;

        default:
          if (mounted) setState(() => _isPurchasing = false);
          break;
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    // TODO: Send purchase to your backend for real validation
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('subscription_activated_success'.tr)),
    );

    // ✅ Go back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Get.back();
    });
  }

  Future<void> _buySubscription() async {
    if (_products.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('no_subscription_product_found'.tr)),
      );
      return;
    }

    if (mounted) setState(() => _isPurchasing = true);

    try {
      // ✅ Check if already purchased
      List<PurchaseDetails> restoredPurchases = [];
      final StreamSubscription<List<PurchaseDetails>> tempSub =
      _iap.purchaseStream.listen((purchases) {
        restoredPurchases = purchases;
      });

      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 2));
      await tempSub.cancel();

      final alreadyPurchased = restoredPurchases.any((purchase) =>
      purchase.productID == _productId &&
          (purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored));

      if (alreadyPurchased) {
        if (mounted) setState(() => _isPurchasing = false);
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:  Text('already_subscribed'.tr),
            content:  Text(
              'subscription_already_active'.tr,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text('ok_button'.tr),
              ),
            ],
          ),
        );
        return;
      }

      // ✅ Proceed to purchase
      final product = _products.firstWhere((p) => p.id == _productId);
      final purchaseParam = PurchaseParam(productDetails: product);

      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      debugPrint('✅ Started auto-renewable subscription for ${product.id}');
    } catch (e) {
      if (mounted) {
        setState(() => _isPurchasing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('purchase_is_cancelled'.tr)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: AppBar(
        title:  Text('subscription'.tr),
        backgroundColor: Colors.transparent,
      ),
        body: Stack(
          children: [
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                           Text(
                            'choose_subscription_plan'.tr,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SubscriptionCard(
                            title: 'monthly_subscription'.tr,
                            description: 'subscription_unlimited_emails'.tr, // keep static
                            price: _products.isNotEmpty
                                ? _products.first.price
                                : '\$4.99/month',
                            isActive: _isSubscribed, // ⭐ show yellow badge
                            onTap: _buySubscription,
                          ),
                        ],
                      ),
                    ),
                  ),



                  // ✅ Apple subscription guideline notice
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'subscription_free_trial_info'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),


                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'subscription_terms_prefix'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: 'privacy_policy'.tr,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url = "https://www.termsfeed.com/live/681008b1-ea12-4e60-8b5f-a79b21bd9a63";
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  },
                              ),

                              const TextSpan(text: 'and'),

                              // ⭐ ADD THIS — Terms of Use link
                              TextSpan(
                                text: 'terms_of_use'.tr,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url = "https://www.termsfeed.com/live/74bff403-9631-4fd9-8ce1-cb872ceab021";  // Replace this
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  },
                              ),

                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),

            // ✅ Loader overlay
            if (_isPurchasing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        )

    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final VoidCallback onTap;
  final bool isActive; // NEW

  const SubscriptionCard({
    required this.title,
    required this.description,
    required this.price,
    required this.onTap,
    this.isActive = false, // default false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(
          children: [
            // ✅ Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('start_free_trial'.tr,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 12),
                Text(price,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),

            // ⭐ Active badge inside card
            if (isActive)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child:  Text(
                    'active'.tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}





