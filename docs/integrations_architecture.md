# Integrations Architecture (POS, Delivery, Suppliers)

## Goals
- Provide a clean API abstraction layer for external systems without binding to any vendor SDKs yet.
- Use an adapter pattern to allow multiple providers per category (POS, delivery, supplier).
- Support sync-safe design (idempotent imports, conflict handling, offline-first).
- Keep the architecture SaaS-ready (multi-tenant, scalable ingestion, observability).

> This document is design-only. No real API integrations are implemented here.

---

## 1) High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                             UI/Features                          │
│  (Dashboards, Pricing, Analytics, Alerts, Reports, etc.)          │
└──────────────────────────────────────────────────────────────────┘
                     ▲
                     │ Domain Services (existing)
                     │ CostCalculationService, Pricing, etc.
                     ▼
┌──────────────────────────────────────────────────────────────────┐
│                    Integration Facade Layer                      │
│  - IntegrationFacade                                             │
│  - SyncCoordinator                                               │
│  - DataNormalizer                                                │
└──────────────────────────────────────────────────────────────────┘
                     ▲
                     │ Provider Interfaces (abstraction)
                     ▼
┌──────────────────────────────────────────────────────────────────┐
│                    Adapter Implementations                       │
│ POS: PosIntegrationProvider                                      │
│ Delivery: DeliveryIntegrationProvider                            │
│ Supplier: SupplierIntegrationProvider                            │
└──────────────────────────────────────────────────────────────────┘
                     ▲
                     │ Vendor APIs (not integrated yet)
                     ▼
┌──────────────────────────────────────────────────────────────────┐
│               External POS / Delivery / Supplier APIs             │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2) API Abstraction Layer

### 2.1 Provider Interfaces (existing)
Use the existing provider interfaces as the canonical abstraction layer:
- `PosIntegrationProvider`
- `DeliveryIntegrationProvider`
- `SupplierIntegrationProvider`
- `MarketDataProvider` (future)

These interfaces define *what* data is needed, not *how* it is fetched.

### 2.2 Facade Layer (proposed)
Introduce a façade to orchestrate provider calls and normalization:

- **IntegrationFacade**
  - Single entrypoint for feature code.
  - Delegates to `SyncCoordinator` and `DataNormalizer`.

- **SyncCoordinator**
  - Handles sync windows (from/to timestamps).
  - Enforces idempotent pulls and retries.
  - Stores sync checkpoints (per provider + scope).

- **DataNormalizer**
  - Converts provider outputs into app domain types
    (e.g., `SalesRecord`, `DeliveryOrderRecord`, `SupplierPriceRecord`).

---

## 3) Adapter Pattern

### 3.1 Adapter Layout
Suggested location: `lib/services/integrations/adapters/<provider_name>_adapter.dart`

Each adapter:
- Implements one of the provider interfaces.
- Owns provider-specific request/response mapping.
- Translates raw API payloads into normalized records.

### 3.2 Example (Pseudo)
```dart
class GrabDeliveryAdapter implements DeliveryIntegrationProvider {
  @override
  String get platformName => 'Grab';

  @override
  Future<List<DeliveryOrderRecord>> fetchOrders(DateTime from, DateTime to) async {
    // TODO: integrate real API later
    return [];
  }
}
```

---

## 4) Sync-Safe Design

### 4.1 Sync Checkpoints
Suggested location: `lib/services/integrations/sync/sync_checkpoint.dart`

- `lastSyncedAt` per provider, per business/user scope.
- Stored locally (Hive) and optionally mirrored in cloud later.

### 4.2 Idempotency & De-duplication
Suggested location: `lib/services/integrations/sync/sync_deduper.dart`

- Deduplicate by provider `externalId` + scope.
- If records already exist, ignore or update.
- Never double-count revenue in analytics.

### 4.3 Partial Sync / Failures
Suggested location: `lib/services/integrations/sync/sync_status.dart`

- Track per-provider sync status (success, partial, failed).
- Retry window logic (exponential backoff later).

---

## 5) Future SaaS Scalability

### 5.1 Multi-Tenancy
Suggested location: `lib/services/integrations/scopes/tenant_scope.dart`

- Use the existing `UserScope` model as the base for all integration calls.
- Provider calls should always include `businessId/userId` for partitioning.

### 5.2 Queue-Ready Ingestion (Future)
Suggested location: `lib/services/integrations/ingestion/ingestion_job.dart`

- Supports async ingestion and batching later.
- Allows server-side ingestion service for SaaS.

### 5.3 Observability Hooks
Suggested location: `lib/services/integrations/telemetry/integration_metrics.dart`

- Track latency, API errors, sync duration.
- Useful for SaaS monitoring and SLAs.

---

## 6) Data Consistency Guarantees

- **Single source of truth:** normalized records from `IntegrationFacade`.
- **Immutable imports:** once imported, only updated with same `externalId`.
- **Stable mapping:** provider adapters convert raw payloads into known models.

---

## 7) Suggested Implementation Order (Safe, Incremental)

1. **Create facade + sync coordinator skeletons** (no API calls).
2. **Add sync checkpoint model** and store locally.
3. **Add adapter stubs for one provider per category** (POS/Delivery/Supplier).
4. **Route UI or analytics through the facade** once records are available.

> This keeps changes small and avoids breaking existing analytics or pricing logic.

---

## 8) Non-Goals (Explicitly Out of Scope)

- No real network API integrations yet.
- No authentication or OAuth flows.
- No server-side sync jobs yet.
