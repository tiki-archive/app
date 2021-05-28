import 'package:app/src/features/home/home_screen/widgets/home_screen_add_email/bloc/home_screen_add_email_state.dart';
import 'package:app/src/utils/helper/helper_google_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AddEmailCubit extends Cubit<AddEmailState> {

  AddEmailCubit() : super(InitialState()) {
    if(HelperGoogleAuth().isConnected()){
      emit(AddedState(HelperGoogleAuth().connect()));
    }
  }

  void addAccount() async {
    try {
      emit(AddingState());
      GoogleSignInAccount? googleAccount = HelperGoogleAuth().connect();
      emit(AddedState(googleAccount));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void removeAccount() async{
    try {
      emit(AddingState());
      GoogleSignInAccount? googleAccount = HelperGoogleAuth().connect();
      emit(AddedState(googleAccount));
    } catch (e) {
      emit(ErrorState());
    }
  }
}