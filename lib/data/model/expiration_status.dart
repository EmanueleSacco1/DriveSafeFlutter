/// Enum class representing the possible expiration statuses for events
/// such as RCA, Revision, and Bollo (car tax).
/// Used to determine the countdown text and indicator color in the UI.
/// Equivalente a ExpirationStatus.kt.
enum ExpirationStatus {
  /// Status: The expiration date is in the past.
  expired,

  /// Status: The expiration date is today.
  today,

  /// Status: The expiration date is in the future but within a certain limit (e.g., <= 30 days).
  near,

  /// Status: The expiration date is in the future and beyond the "near" limit.
  future,

  /// Status: The expiration date is not defined or is invalid.
  unknown,
}
