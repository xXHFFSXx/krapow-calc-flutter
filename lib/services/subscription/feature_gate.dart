import 'subscription_models.dart';

class FeatureGate {
  const FeatureGate();

  static const featureAnalytics = 'analytics_dashboard';
  static const featurePromotionSimulator = 'promotion_simulator';
  static const featureExportReports = 'export_reports';
  static const featureOcrScanner = 'ocr_scanner';
  static const featureMultiUserSync = 'multi_user_sync';

  FeatureGateStatus check({
    required SubscriptionState state,
    required String featureKey,
  }) {
    if (state.plan.isPro) {
      return FeatureGateStatus(featureKey: featureKey, isEnabled: true);
    }

    final freeFeatures = <String>{
      featureAnalytics,
    };

    if (freeFeatures.contains(featureKey)) {
      return FeatureGateStatus(featureKey: featureKey, isEnabled: true);
    }

    return FeatureGateStatus(
      featureKey: featureKey,
      isEnabled: false,
      upgradeMessage: 'ฟีเจอร์นี้สำหรับแพ็กเกจ Pro เพื่อธุรกิจที่เติบโต',
    );
  }
}
