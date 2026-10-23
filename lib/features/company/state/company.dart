import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/company/data/company_api.dart';

/// The user's company, fetched once per login and kept; re-fetched when the session changes.
final currentCompanyProvider = FutureProvider<CompanyInfo?>((ref) async {
  if (ref.watch(authProvider) is! Authenticated) return null;
  return await ref.watch(companyApiProvider).current();
});

/// Whether photo buttons are shown at all. Unknown (not loaded yet, request failed) counts as off.
final photosEnabledProvider = Provider<bool>(
  (ref) => ref.watch(currentCompanyProvider).value?.photosEnabled ?? false,
);
