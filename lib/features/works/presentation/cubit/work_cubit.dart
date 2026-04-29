import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/work.dart';
import '../../domain/repositories/i_work_repository.dart';
import 'work_state.dart';

class WorkCubit extends Cubit<WorkState> {
  final IWorkRepository _workRepository;

  WorkCubit({required IWorkRepository workRepository})
      : _workRepository = workRepository,
        super(const WorkInitial());

  Future<void> getWorks() async {
    emit(const WorkLoading());
    final result = await _workRepository.getWorks();

    switch (result) {
      case Success(data: final works):
        emit(WorkLoaded(works));
      case Error(failure: final failure):
        emit(WorkError(failure.message));
    }
  }

  Future<void> addWork(Work work) async {
    print('Ekleme işlemi başladı: ${work.title}');
    // Optimistic UI implementation
    final previousState = state;
    List<Work> currentWorks = [];
    
    if (previousState is WorkLoaded) {
      currentWorks = List.from(previousState.works);
    }
    
    // Hemen listeye ekleyip arayüzü güncelleyelim (En başa ekliyoruz, DESC sırası için)
    final updatedWorks = [work, ...currentWorks];
    emit(WorkLoaded(updatedWorks));

    // Veritabanına kaydetmeyi deneyelim
    final result = await _workRepository.addWork(work);

    switch (result) {
      case Success():
        // Başarılıysa yapacak bir şey yok, liste zaten güncel.
        break;
      case Error(failure: final failure):
        // Başarısızlık durumunda rollback (geri alma) yapalım
        emit(WorkError(failure.message));
        // Hata mesajını kısa süre gösterdikten sonra eski durumu yayınlıyoruz ki liste bozulmasın
        emit(previousState);
    }
  }
  Future<void> updateWork(Work work) async {
    final previousState = state;
    List<Work> currentWorks = [];
    
    if (previousState is WorkLoaded) {
      currentWorks = List.from(previousState.works);
    }
    
    final updatedWorks = currentWorks.map((e) => e.id == work.id ? work : e).toList();
    emit(WorkLoaded(updatedWorks));

    final result = await _workRepository.updateWork(work);

    switch (result) {
      case Success():
        break;
      case Error(failure: final failure):
        emit(WorkError(failure.message));
        emit(previousState);
    }
  }

  Future<void> updateWorkStatus(Work work) async {
    final updatedWork = Work(
      id: work.id,
      title: work.title,
      price: work.price,
      isPaid: !work.isPaid,
      createdAt: work.createdAt,
    );
    await updateWork(updatedWork);
  }

  Future<void> deleteWork(String id) async {
    final previousState = state;
    List<Work> currentWorks = [];
    
    if (previousState is WorkLoaded) {
      currentWorks = List.from(previousState.works);
    }
    
    final updatedWorks = currentWorks.where((e) => e.id != id).toList();
    emit(WorkLoaded(updatedWorks));

    final result = await _workRepository.deleteWork(id);

    switch (result) {
      case Success():
        break;
      case Error(failure: final failure):
        emit(WorkError(failure.message));
        emit(previousState);
    }
  }
}
