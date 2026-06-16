import '../models/laundry_service.dart';
import '../models/promo_model.dart';

abstract class LaundryServiceContract {
  Future<List<LaundryService>> getServices();
  Future<List<PromoModel>> getPromos();
}
