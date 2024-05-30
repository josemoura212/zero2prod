// use std::fs::Metadata;

pub mod configuration;
pub mod routes;
pub mod startup;

// A trait encapsulating the operations required of a logger.
// pub trait Log: Sync + Send {
//     /// Determines if a log message with the specified metadata would be
//     /// logged.
//     ///
//     /// This is used by the `log_enabled!` macro to allow callers to avoid
//     /// expensive computation of log message arguments if the message would be
//     /// discarded anyway.
//     fn enabled(&self, metadata: &Metadata) -> bool;

//     /// Logs the `Record`.
//     ///
//     /// Note that `enabled` is *not* necessarily called before this method.
//     /// Implementations of `log` should perform all necessary filtering
//     /// internally.
//     fn log(&self, record: &Record);

//     /// Flushes any buffered records.
//     fn flush(&self);
// }
