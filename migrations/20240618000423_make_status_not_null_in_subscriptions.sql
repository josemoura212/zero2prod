-- Add migration script here
-- Envolvemos toda a migração em uma transação para garantir que
-- ela é bem-sucedida ou falha atomicamente. Discutiremos as transações SQL
-- com mais detalhes no final deste capítulo!
-- O `sqlx` não faz isso automaticamente para nos
BEGIN;
    -- Backfill `status` for historical entries
    UPDATE subscriptions
        SET status = 'confirmed'
        WHERE status IS NULL;
    -- Make `status` mandatory
    ALTER TABLE subscriptions ALTER COLUMN status SET NOT NULL;
COMMIT;
