/// Conceptual data flow for integration readiness (non-UI).
///
/// 1) POS Provider -> SalesRecord/MenuSyncRecord
/// 2) Delivery Provider -> DeliveryOrderRecord/PromotionImpactRecord/GP Rates
/// 3) Supplier Provider -> SupplierPriceRecord -> SupplierComparison/ReorderSuggestion
/// 4) Market Data -> BenchmarkMetric/MarketTrendPoint
///
/// Data remains local-first. Any remote sync should:
/// - use businessId/userId for separation
/// - store anonymized aggregates when sharing benchmarks
/// - allow opt-in for analytics sharing
///
/// The IntegrationOrchestrator aggregates all sources and yields normalized records.
