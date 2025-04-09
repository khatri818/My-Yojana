import '../../domain/entities/pagination.dart';
import '../../domain/entities/scheme.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    this.hasnext,
    this.hasprev,
    this.page,
    this.perpage,
    this.totalitems,
    this.totalpages,
  });

  final bool? hasnext;
  final bool? hasprev;
  final int? page;
  final int? perpage;
  final int? totalitems;
  final int? totalpages;

  factory PaginationModel.fromJson(Map<String, dynamic> map) {
    return PaginationModel(
      hasnext: map['has_next'],
      hasprev: map['has_prev'],
      page: map['page'],
      perpage: map['per_page'],
      totalitems: map['total_items'],
      totalpages: map['total_pages']);
  }

  Map<String, dynamic> toJson() {
    return {
      'has_next':hasnext,
      'has_prev':hasprev,
      'page':page,
      'per_page':perpage,
      'total_items':totalitems,
      'total_pages':totalpages,
    };
  }
}
