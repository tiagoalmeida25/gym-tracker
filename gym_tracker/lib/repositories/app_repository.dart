import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_tracker/model/classes.dart';
import 'package:gym_tracker/model/sports.dart';
import 'package:gym_tracker/model/train.dart';
import 'package:gym_tracker/model/exercise.dart';

class FirebaseAppRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Train>> loadTrains(String userId) async {
    final snapshot = await firestore.collection('users').doc(userId).collection('workouts').get();

    final result = snapshot.docs.map((doc) async {
      final exerciseSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(doc.id)
          .collection('exercises')
          .get();

      List<Exercise> exercises = exerciseSnapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();

      exercises.sort((a, b) => a.order.compareTo(b.order));

      final sportsSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(doc.id)
          .collection('sports')
          .get();

      final sports = sportsSnapshot.docs.map((doc) => Sport.fromJson(doc.data())).toList();

      final classesSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(doc.id)
          .collection('classes')
          .get();

      final classes = classesSnapshot.docs.map((doc) => Class.fromJson(doc.data())).toList();

      final data = doc.data();
      return Train(
        date: DateTime.parse(data['date']),
        exercises: exercises,
        sports: sports,
        classes: classes,
      );
    }).toList();

    return Future.wait(result);
  }

  Future<Train> loadTrainOf(String userId, DateTime date) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: date.toIso8601String())
        .get();

    final exerciseSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(snapshot.docs.first.id)
        .collection('exercises')
        .get();

    List<Exercise> exercises = exerciseSnapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();

    exercises.sort((a, b) => a.order.compareTo(b.order));

    final sportsSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(snapshot.docs.first.id)
        .collection('sports')
        .get();

    final sports = sportsSnapshot.docs.map((doc) => Sport.fromJson(doc.data())).toList();

    final classesSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(snapshot.docs.first.id)
        .collection('classes')
        .get();

    final classes = classesSnapshot.docs.map((doc) => Class.fromJson(doc.data())).toList();

    return Train(
      date: date,
      exercises: exercises,
      sports: sports,
      classes: classes,
    );
  }

  Future<void> addTrain(String userId, Train train) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .add({'date': DateTime(train.date.year, train.date.month, train.date.day).toIso8601String()});
  }

  Future<void> updateTrain(String userId, Train prevTrain, Train train) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: prevTrain.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .update({'date': DateTime(train.date.year, train.date.month, train.date.day).toIso8601String()});

    for (var exercise in train.exercises) {
      exercise.order = train.exercises.indexOf(exercise);
      await firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(docId)
          .collection('exercises')
          .doc(exercise.name)
          .set(exercise.toJson());
    }

    for (var sport in train.sports) {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(docId)
          .collection('sports')
          .doc(sport.name)
          .set(sport.toJson());
    }

    for (var class_ in train.classes) {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(docId)
          .collection('classes')
          .doc(class_.name)
          .set(class_.toJson());
    }
  }

  Future<void> deleteTrain(String userId, Train train) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore.collection('users').doc(userId).collection('workouts').doc(docId).delete();
  }

  Future<List<Exercise>> loadExercises(String userId, Train train) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    final exercises = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('exercises')
        .get();
    List<Exercise> result = exercises.docs.map((doc) => Exercise.fromJson(doc.data())).toList();
    result.sort((a, b) => a.order.compareTo(b.order));

    return result;
  }

  Future<void> addExercise(String userId, Train train, Exercise exercise) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('exercises')
        .doc(exercise.name)
        .set(exercise.toJson());
  }

  Future<void> updateExercise(String userId, Train train, Exercise prevExercise, Exercise exercise) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('exercises')
        .doc(prevExercise.name)
        .delete();
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('exercises')
        .doc(exercise.name)
        .set(exercise.toJson());
  }

  Future<void> deleteExercise(String userId, Train train, Exercise exercise) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('exercises')
        .doc(exercise.name)
        .delete();
  }

  Future<List<Sport>> loadSports(String userId, Train train) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    final sports = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('sports')
        .get();
    return sports.docs.map((doc) => Sport.fromJson(doc.data())).toList();
  }

  Future<void> addSport(String userId, Train train, Sport sport) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('sports')
        .doc(sport.name)
        .set(sport.toJson());
  }

  Future<void> deleteSport(String userId, Train train, Sport sport) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('sports')
        .doc(sport.name)
        .delete();
  }

  Future<void> updateSport(String userId, Train train, Sport prevSport, Sport sport) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('sports')
        .doc(prevSport.name)
        .delete();
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('sports')
        .doc(sport.name)
        .set(sport.toJson());
  }

  Future<List<Class>> loadClasses(String userId, Train train) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    final classes = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('classes')
        .get();
    return classes.docs.map((doc) => Class.fromJson(doc.data())).toList();
  }

  Future<void> addClass(String userId, Train train, Class class_) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('classes')
        .doc(class_.name)
        .set(class_.toJson());
  }

  Future<void> deleteClass(String userId, Train train, Class class_) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('classes')
        .doc(class_.name)
        .delete();
  }

  Future<void> updateClass(String userId, Train train, Class prevClass, Class class_) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .where('date', isEqualTo: train.date.toIso8601String())
        .get();
    final docId = snapshot.docs.first.id;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('classes')
        .doc(prevClass.name)
        .delete();
    await firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(docId)
        .collection('classes')
        .doc(class_.name)
        .set(class_.toJson());
  }

  Future<List<String>> loadCategories() async {
    final snapshot = await firestore.collection('categories').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> loadMuscles(String category) async {
    final snapshot = await firestore.collection('categories').doc(category).collection('muscles').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> loadMuscleExercises(String category, String muscle) async {
    final snapshot = await firestore
        .collection('categories')
        .doc(category)
        .collection('muscles')
        .doc(muscle)
        .collection('exercises')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> loadAllSports() async {
    final snapshot = await firestore.collection('sports').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> loadAllClasses() async {
    final snapshot = await firestore.collection('classes').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
