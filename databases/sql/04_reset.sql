-- Re-apply the controlled baseline without dropping schema or routines.
-- Usage:  mysql -u root -p meridian_oms < sql/03_seed.sql
-- This file exists so the environment document has a named reset asset.

SOURCE 03_seed.sql;
