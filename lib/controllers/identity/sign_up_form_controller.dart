import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../constants/texts/sign_up_texts.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/facilities/hospital_search.dart';
import '../../dtos/identity/sign_up_request.dart';
import '../../enums/identity/gender.dart';
import '../../enums/identity/marital_status.dart';
import '../../interfaces/ui/search_loader.dart';
import '../../models/common/page_result.dart';
import '../../models/common/user_facing_error.dart';
import '../../models/identity/session_user.dart';
import '../../models/identity/sign_up_draft.dart';
import '../../models/ui/search_option.dart';
import '../../utilities/facilities/search_options.dart';
import '../../validations/identity/phone.dart';
import '../core/service_providers.dart';

/// The Finish signing up form; it starts empty each time the screen opens.
class SignUpFormController extends Notifier<SignUpDraft> {
  @override
  SignUpDraft build() => const SignUpDraft();

  void setGender(Gender? value) => state = state.copyWith(gender: value);
  void setMaritalStatus(MaritalStatus? value) => state = state.copyWith(maritalStatus: value);
  void setDateOfBirth(DateTime value) => state = state.copyWith(dateOfBirth: value);
  void setPhone(String value) => state = state.copyWith(phone: value);
  void setAddress(String value) => state = state.copyWith(address: value);
  void setNationality(SearchOption? value) => state = state.copyWith(nationality: value);
  void setCity(SearchOption? value) => state = state.copyWith(city: value);
  void setHospital(SearchOption? value) => state = state.copyWith(hospital: value);

  void setCountry(SearchOption? value) {
    if (value != null && value.id != state.country?.id) state = state.withCountry(value);
  }

  PageRequest _page(String term, int page) => PageRequest(
    page: page,
    pageSize: AppConstants.searchPageSize,
    filters: {'q': term.isEmpty ? null : term},
  );

  SearchLoader get countryLoader => (term, page) async =>
      (await ref.read(publicCatalogServiceProvider).allCountries(_page(term, page))).map(countryOption);

  SearchLoader get cityLoader {
    final countryId = state.country?.id;
    return (term, page) async {
      if (countryId == null) return PageResult.empty();
      return (await ref.read(publicCatalogServiceProvider).allCities(countryId, _page(term, page))).map(cityOption);
    };
  }

  /// Active hospitals of the residence country by name, those in or serving the chosen city first.
  SearchLoader get hospitalLoader {
    final search = HospitalSearch(countryId: state.country?.id, cityId: state.city?.id);
    return (term, page) async {
      if (search.countryId == null) return PageResult.empty();
      final named = HospitalSearch(countryId: search.countryId, cityId: search.cityId, name: term);
      final found = await ref.read(publicCatalogServiceProvider).hospitals(named, page, AppConstants.searchPageSize);
      return found.map(hospitalOption);
    };
  }

  /// Sends the form; a missing or invalid field marks the hints and throws a sentence to show.
  Future<SessionUser> submit() async {
    state = state.copyWith(tried: true);
    final draft = state;
    if (!draft.isComplete || !isValidOptionalPhone(draft.phone)) throw const UserFacingError(SignUpTexts.missing);
    final phone = draft.phone.trim();
    return ref.read(signUpServiceProvider).signUp(
      SignUpRequest(
        gender: draft.gender!,
        maritalStatus: draft.maritalStatus!,
        nationalityCountryId: draft.nationality!.id,
        residenceCountryId: draft.country!.id,
        residenceCityId: draft.city!.id,
        residenceAddressLine: draft.address.trim(),
        hospitalId: draft.hospital!.id,
        phoneNumber: phone.isEmpty ? null : phone,
        dateOfBirth: draft.dateOfBirth,
      ),
    );
  }
}

final signUpFormProvider = NotifierProvider.autoDispose<SignUpFormController, SignUpDraft>(SignUpFormController.new);
