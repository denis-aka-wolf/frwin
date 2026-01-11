// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:frwin/providers/funding_rate/funding_rate_bloc.dart' as _i776;
import 'package:frwin/providers/instrument/instrument_bloc.dart' as _i223;
import 'package:frwin/providers/settings/settings_bloc.dart' as _i387;
import 'package:frwin/services/bybit_api_service.dart' as _i485;
import 'package:frwin/services/funding_rate_repository.dart' as _i680;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i387.SettingsBloc>(() => _i387.SettingsBloc());
    gh.lazySingleton<_i485.BybitApiService>(() => _i485.BybitApiService());
    gh.factory<_i680.FundingRateRepository>(
      () => _i680.FundingRateRepository(gh<_i485.BybitApiService>()),
    );
    gh.factory<_i223.InstrumentBloc>(
      () => _i223.InstrumentBloc(gh<_i485.BybitApiService>()),
    );
    gh.factory<_i776.FundingRateBloc>(
      () => _i776.FundingRateBloc(gh<_i680.FundingRateRepository>()),
    );
    return this;
  }
}
