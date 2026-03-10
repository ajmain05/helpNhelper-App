import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:helpnhelper/models/wallet_model.dart';
import 'package:helpnhelper/pages/profile/wallet_deposit_screen.dart';
import 'package:helpnhelper/service/wallet_service.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class WalletDashboard extends StatefulWidget {
  const WalletDashboard({Key? key}) : super(key: key);

  @override
  State<WalletDashboard> createState() => _WalletDashboardState();
}

class _WalletDashboardState extends State<WalletDashboard>
    with WidgetsBindingObserver {
  final WalletService _walletService = WalletService();
  bool _isLoading = true;
  CorporateWalletData? _walletData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-fetch data when user comes back to the app (e.g., from clicking a notification)
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final data = await _walletService.fetchWalletHistory();
    if (mounted) {
      setState(() {
        _walletData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeposit() async {
    // Show amount input BottomSheet
    final amountController = TextEditingController();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildDepositSheet(amountController);
      },
    );

    if (result == true) {
      // Refresh wallet balance after successful deposit
      _fetchData();
    }
  }

  Widget _buildDepositSheet(TextEditingController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1F222E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Funds',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the amount you would like to deposit to your corporate wallet.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              decoration: InputDecoration(
                prefixText: '৳ ',
                prefixStyle: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textColor.withOpacity(0.5),
                ),
                filled: true,
                fillColor:
                    isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(controller.text) ?? 0;
                  if (amount < 10) {
                    Get.snackbar(
                      'Invalid Amount',
                      'Minimum deposit is ৳10',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  if (amount > 100000) {
                    Get.snackbar(
                      'Limit Exceeded',
                      'Maximum deposit per transaction is ৳100,000',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  // Initiate Payment
                  final redirectUrl =
                      await _walletService.initiateDeposit(amount);

                  Get.back(); // close loading

                  if (redirectUrl != null) {
                    Get.back(); // close bottom sheet
                    final success = await Get.to(
                        () => WalletDepositScreen(uploadUrl: redirectUrl));
                    if (success == true) {
                      Get.back(
                          result:
                              true); // pass success signal back to dashboard
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Proceed to Payment',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      final whole = amount.truncate().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      final fraction =
          (amount - amount.truncate()).toStringAsFixed(2).substring(1);
      return fraction == '.00' ? whole : '$whole$fraction';
    }
    return amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF13151A) : const Color(0xFFF7F9FC);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final cardBg = isDark ? const Color(0xFF1F222E) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Fund Tracker',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: MyColors.primary))
          : _walletData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet_rounded,
                          size: 80, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text('Unable to load wallet data',
                          style: GoogleFonts.poppins(
                              color: textColor.withOpacity(0.6))),
                      TextButton(
                        onPressed: _fetchData,
                        child: Text('Retry',
                            style:
                                GoogleFonts.poppins(color: MyColors.primary)),
                      )
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: MyColors.primary,
                  onRefresh: _fetchData,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildBalanceCard(isDark),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Distribution History',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      if (_walletData!.allocations.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.auto_awesome_rounded,
                                      size: 50,
                                      color: MyColors.primary.withOpacity(0.5)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No allocations yet',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: textColor.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    'Funds have not been distributed to campaigns yet.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final allocation =
                                  _walletData!.allocations[index];
                              return _buildAllocationTile(
                                  allocation, cardBg, textColor, isDark);
                            },
                            childCount: _walletData!.allocations.length,
                          ),
                        ),
                      const SliverToBoxAdapter(
                          child: SizedBox(height: 100)), // Space for FAB
                    ],
                  ),
                ),
      floatingActionButton: _walletData != null
          ? FloatingActionButton.extended(
              onPressed: _handleDeposit,
              backgroundColor: MyColors.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_card_rounded),
              label: Text(
                'Add Funds',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBalanceCard(bool isDark) {
    if (_walletData == null) return const SizedBox();

    final wallet = _walletData!.wallet;
    final total = wallet.totalDeposited;
    final balance = wallet.balance;
    final used = total - balance;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            MyColors.primary,
            MyColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            right: -40,
            top: -40,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 140,
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.wallet_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Available Balance',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '৳ ',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatCurrency(balance),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Donated',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '৳ ${_formatCurrency(total)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 1,
                        height: 30,
                        color: Colors.white.withOpacity(0.2)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Allocated Used',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '৳ ${_formatCurrency(used)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }

  Widget _buildAllocationTile(CorporateAllocation allocation, Color cardBg,
      Color textColor, bool isDark) {
    String dateStr = 'Unknown Date';
    try {
      final date = DateTime.parse(allocation.allocatedAt);
      dateStr = DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          // Campaign Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            child: allocation.campaign.image != null &&
                    allocation.campaign.image!.isNotEmpty
                ? Image.network(
                    allocation.campaign.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackIcon(isDark),
                  )
                : _fallbackIcon(isDark),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allocation.campaign.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 12, color: textColor.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      dateStr,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF00C896).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '- ৳${_formatCurrency(allocation.amount)}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: const Color(0xFF00C896),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon(bool isDark) {
    return Icon(
      Icons.volunteer_activism_rounded,
      color: isDark ? Colors.white24 : Colors.grey[300],
      size: 30,
    );
  }
}
