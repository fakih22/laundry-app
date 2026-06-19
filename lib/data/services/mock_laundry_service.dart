import '../../domain/models/laundry_service.dart';
import '../../domain/models/promo_model.dart';
import '../../domain/services/laundry_service.dart';

class MockLaundryService implements LaundryServiceContract {
  @override
  Future<List<LaundryService>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      LaundryService(
        id: 'svc-1',
        name: 'Cuci & Lipat',
        description: 'Pencucian premium dengan pelipatan rapih menggunakan detergen ramah lingkungans.',
        icon: 'local_laundry_service',
        basePrice: 6000.0,
        unit: 'kg',
        items: [
          LaundryItem(id: 'item-1', name: 'Kaos', price: 5000.0, icon: 'apparel'),
          LaundryItem(id: 'item-2', name: 'Celana Jeans', price: 8000.0, icon: 'dry_cleaning'),
          LaundryItem(id: 'item-3', name: 'Gaun/Dress', price: 12000.0, icon: 'woman_2'),
        ],
      ),
      LaundryService(
        id: 'svc-2',
        name: 'Cuci Kering',
        description: 'Perawatan khusus untuk pakaian sensitif menggunakan metode dry cleaning higienis.',
        icon: 'iron',
        basePrice: 15000.0,
        unit: 'pc',
        items: [
          LaundryItem(id: 'item-4', name: 'Jas / Blazer', price: 25000.0, icon: 'checkroom'),
          LaundryItem(id: 'item-5', name: 'Gaun Sutra', price: 40000.0, icon: 'woman'),
          LaundryItem(id: 'item-6', name: 'Selimut Tebals', price: 20000.0, icon: 'bed'),
        ],
      ),
      LaundryService(
        id: 'svc-3',
        name: 'Setrika Saja',
        description: 'Penyetrikaan profesional dengan uap air bertekanan tinggi untuk hasil ekstra rapi dan klimis.',
        icon: 'checkroom',
        basePrice: 4000.0,
        unit: 'kg',
        items: [
          LaundryItem(id: 'item-7', name: 'Kemeja', price: 3000.0, icon: 'apparel'),
          LaundryItem(id: 'item-8', name: 'Celana Kain', price: 3000.0, icon: 'dry_cleaning'),
          LaundryItem(id: 'item-9', name: 'Sprei', price: 5000.0, icon: 'bed'),
        ],
      ),
      LaundryService(
        id: 'svc-4',
        name: 'Premium & Tas/Sepatu',
        description: 'Pembersihan mendalam untuk jaket kulit, sepatu, dan tas branded Anda.',
        icon: 'stars',
        basePrice: 25000.0,
        unit: 'pc',
        items: [
          LaundryItem(id: 'item-10', name: 'Jaket Kulit', price: 75000.0, icon: 'apparel'),
          LaundryItem(id: 'item-11', name: 'Tas Branded', price: 100000.0, icon: 'shopping_bag'),
          LaundryItem(id: 'item-12', name: 'Sepatu', price: 50000.0, icon: 'roller_skating'),
        ],
      ),
    ];
  }

  @override
  Future<List<PromoModel>> getPromos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      PromoModel(
        code: 'LAUNDRYBARU',
        title: 'Pengguna Baru',
        description: 'Potongan Rp 15.000 untuk pesanan pertama Anda.',
        discountAmount: 15000.0,
        minTransaction: 40000.0,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
      PromoModel(
        code: 'PLATINUMECO',
        title: 'Eco Friendly Champion',
        description: 'Potongan Rp 20.000 khusus pengguna tingkat Platinum.',
        discountAmount: 20000.0,
        minTransaction: 60000.0,
        expiryDate: DateTime.now().add(const Duration(days: 15)),
      ),
      PromoModel(
        code: 'BERSIHHEMAT',
        title: 'Hemat Akhir Pekan',
        description: 'Potongan Rp 10.000 untuk semua jenis layanan.',
        discountAmount: 10000.0,
        minTransaction: 30000.0,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      ),
    ];
  }
}
