import sys

file_path = r'd:\\Flutter\\Resources\\helpNhelper-handover-new-mobile-app\\lib\\pages\\volunteer\\transaction_method_list.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

fab_start = content.find('      floatingActionButton: FloatingActionButton.extended(')
if fab_start == -1:
    print('Failed to find FAB')
    sys.exit(1)

scaffold_end = content.find('    );\n  }\n', fab_start)
if scaffold_end == -1:
    scaffold_end = content.find('    );\n  }')
if scaffold_end == -1:
    print('Failed to find scaffold end')
    sys.exit(1)

build_end = scaffold_end + 10
fab_block = content[fab_start:build_end]

dialog_content = """    void _showMethodDialog(BuildContext context, {TransactionMethodModel? editItem}) {
      if (editItem != null) {
        if (editItem.type == 'mfs') {
          methodTypeController.text = 'MFS';
          if (editItem.bkash != null && editItem.bkash.toString() != 'null' && editItem.bkash.toString().isNotEmpty) {
            mfsTypeController.text = 'Bkash';
            phoneController.text = editItem.bkash.toString();
          } else {
            mfsTypeController.text = 'Nagad';
            phoneController.text = editItem.nagad.toString();
          }
        } else {
          methodTypeController.text = 'BANK';
          bankNameController.text = editItem.bankName ?? '';
          branchNameController.text = editItem.branchName ?? '';
          routeController.text = editItem.routingNumber ?? '';
          holderController.text = editItem.holderName ?? '';
          accountNumberController.text = editItem.accountNumber ?? '';
        }
      } else {
        methodTypeController.clear();
        mfsTypeController.clear();
        phoneController.clear();
        bankNameController.clear();
        branchNameController.clear();
        routeController.clear();
        holderController.clear();
        accountNumberController.clear();
      }

      showDialog(
""" + fab_block.split('showDialog(')[1].split('          );\n        },')[0] + """          );
    }

    void _deleteConfirm(BuildContext context, TransactionMethodModel item) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: sheetBg,
          title: Text('Delete Method', style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.w600)),
          content: Text('Are you sure you want to delete this transaction method?', style: GoogleFonts.poppins(color: subColor)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.poppins(color: subColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(ctx);
                if (item.id != null) {
                  Get.find<VolunteerController>().deleteTransactionMethod(item.id!);
                }
              },
              child: Text('Delete', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
    }

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MyColors.primary,
        onPressed: () {
          _showMethodDialog(context);
        },
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Method',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }"""


dialog_content = dialog_content.replace("child: Text('Add Method',", "child: Text(editItem != null ? 'Update Method' : 'Add Method',")
dialog_content = dialog_content.replace("Text('Add Payment Method',", "Text(editItem != null ? 'Edit Payment Method' : 'Add Payment Method',")

update_logic = """Get.find<VolunteerController>()
                                                  .addTransactionMethod(map)"""
update_replacement = """if (editItem != null && editItem.id != null) {
                                                Get.find<VolunteerController>().updateTransactionMethod(map, editItem.id!).then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(ctx);
                                                    _createWallet(context);
                                                  }
                                                });
                                              } else {
                                                Get.find<VolunteerController>()
                                                    .addTransactionMethod(map)
                                                    .then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(ctx);
                                                    _createWallet(context);
                                                  }
                                                });
                                              }"""

dialog_content = dialog_content.replace(update_logic + """
                                                  .then((value) {
                                                if (value == true) {
                                                  Navigator.pop(ctx);
                                                  _createWallet(context);
                                                }
                                              });""", update_replacement)

new_content = content[:fab_start] + dialog_content + content[build_end:]

badge_str = """Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: MyColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(isMfs ? 'MFS' : 'BANK',
                                      style: GoogleFonts.poppins(
                                          color: isMfs
                                              ? const Color(0xFF7C4DFF)
                                              : MyColors.primary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700)),
                                ),"""
replacement_badge = """Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: MyColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(isMfs ? 'MFS' : 'BANK',
                                          style: GoogleFonts.poppins(
                                              color: isMfs
                                                  ? const Color(0xFF7C4DFF)
                                                  : MyColors.primary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 4),
                                    PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.more_vert, color: subColor, size: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onSelected: (val) {
                                        if (val == 'edit') {
                                           _showMethodDialog(context, editItem: item);
                                        } else if (val == 'delete') {
                                           _deleteConfirm(context, item);
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                        PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit, size: 18), const SizedBox(width: 8), const Text('Edit')])),
                                        PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete, color: Colors.red, size: 18), const SizedBox(width: 8), const Text('Delete', style: TextStyle(color: Colors.red))])),
                                      ],
                                    ),
                                  ],
                                ),"""

new_content = new_content.replace(badge_str, replacement_badge)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_content)
print('Done!')
