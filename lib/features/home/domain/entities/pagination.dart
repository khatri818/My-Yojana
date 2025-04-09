import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final bool? hasnext;
  final bool? hasprev;
  final int? page;
  final int? perpage;
  final int? totalitems;
  final int? totalpages;

  const Pagination({
    this.hasnext,
    this.hasprev,
    this.page,
    this.perpage,
    this.totalitems,
    this.totalpages,
  });

  @override
  List<Object?> get props => [
    hasnext,
    hasprev,
    page,
    perpage,
    totalitems,
    totalpages,
  ];
}
