use std::convert::TryFrom;
#[derive(serde::Deserialize)]
pub struct Settings {
    pub database: DatabaseSettings,
    pub application_port: u16,
}

#[derive(serde::Deserialize)]
pub struct DatabaseSettings {
    pub username: String,
    pub password: String,
    pub port: u16,
    pub host: String,
    pub database_name: String,
}

impl DatabaseSettings {
    pub fn connection_string(&self) -> String {
        format!(
            "postgres://{}:{}@{}:{}/{}",
            self.username, self.password, self.host, self.port, self.database_name
        )
    }
}

pub fn get_configuration() -> Result<Settings, config::ConfigError> {
    impl TryFrom<config::Config> for Settings {
        type Error = config::ConfigError;

        fn try_from(config: config::Config) -> Result<Self, Self::Error> {
            let database = config.get::<DatabaseSettings>("database")?;
            let application_port = config.get::<u16>("application_port")?;

            Ok(Settings {
                database,
                application_port,
            })
        }
    }

    let mut settings = config::Config::builder();

    // Add configuration values from a file named `configuration`.
    // It will look for any top-level file with an extension
    // that `config` knows how to parse: yaml, json, etc.
    settings = settings.add_source(config::File::with_name("configuration"));

    // Build the configuration and unwrap it, handling any errors
    let settings = settings.build()?;

    // Try to convert the configuration values you read into
    // our Settings type
    // nosso tipo Settings
    settings.try_into()
}
