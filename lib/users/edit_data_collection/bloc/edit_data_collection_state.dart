abstract class EditDataCollectionState {}

class EditInitailState extends EditDataCollectionState {
  
}

class EditLoadingState extends EditDataCollectionState {
  
}

class EditFailureState extends EditDataCollectionState {
  String message;
  EditFailureState({required this.message});
}

class EditSuccessState extends EditDataCollectionState {
  
}
