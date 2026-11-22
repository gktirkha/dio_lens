/// A kind of delete. `DioLensSettings.deleteConfirmation` lists the ones that
/// ask before deleting.
enum DioLensDeleteConfirmation {
  /// Deleting one request, from its row or its detail page.
  single,

  /// Clearing every captured request.
  all,
}
