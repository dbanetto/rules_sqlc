"Public API re-exports"

load("//sqlc/private:generate.bzl", _sqlc_generate_go = "sqlc_generate_go")

sqlc_generate_go = _sqlc_generate_go
