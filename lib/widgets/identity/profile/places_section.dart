import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/texts/profile_texts.dart';
import '../../../controllers/care/patient_context_controller.dart';
import '../../../controllers/identity/my_places_controller.dart';
import '../../common/display/section_card.dart';
import '../../common/feedback/async_body.dart';

/// The hospitals or Organizations the person belongs to on the side they are on.
class PlacesSection extends ConsumerWidget {
  const PlacesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountant = ref.watch(onAccountantSideProvider);
    return SectionCard(
      title: accountant ? ProfileTexts.organizationsTitle : ProfileTexts.hospitalsTitle,
      children: [
        AsyncBody(
          value: ref.watch(myPlacesProvider),
          skeletonRows: 1,
          onRetry: () => ref.invalidate(patientContextProvider),
          data: (places) => places.isEmpty
              ? const Text(ProfileTexts.noPlaces)
              : Column(
                  children: [
                    for (final place in places)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(accountant ? Icons.domain_rounded : Icons.local_hospital_rounded),
                        title: Text(place.name),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
