use actix_web::{web, HttpResponse};
use sqlx::PgPool;
use uuid::Uuid;

#[derive(serde::Deserialize)]
pub struct FormData {
    email: String,
    name: String,
}

// Let's start simple: we always return a 200 OK
pub async fn subscribe(
    form: web::Form<FormData>,
    connection: web::Data<PgPool>, // Renamed
) -> HttpResponse {
    match sqlx::query!(
        r#"
        INSERT INTO subscriptions (id,email, name)
        VALUES ($1,$2,$3)
        "#,
        Uuid::new_v4(),
        form.email,
        form.name,
    )
    .execute(connection.get_ref())
    .await
    {
        Ok(_) => HttpResponse::Ok().finish(),
        Err(e) => {
            eprintln!("Failed to execute query: {:?}", e);
            HttpResponse::InternalServerError().finish()
        }
    }
}
