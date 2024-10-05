
def _sqlc_generate_go(ctx):
    toolchain = ctx.toolchains["//sqlc:toolchain_type"]

    out_db = ctx.actions.declare_file("db.go")
    out_models = ctx.actions.declare_file("models.go")
    out_queries = ctx.actions.declare_file("query.sql.go")
    outputs = [out_db, out_models, out_queries]

    # Generate the configuration file in the v2 format
    # See https://docs.sqlc.dev/en/latest/reference/config.html
    config_file = ctx.actions.declare_file(ctx.label.name + ".sqlc.json")
    # All paths are relative from the config
    relative = "/".join([ ".." for _ in config_file.path.split('/')[1:] ])

    sqlc_config = {
        "version": 2,
        "sql": [
            {
                "engine": ctx.attr.engine,
                "queries": [ relative + "/" + f.path for f in ctx.files.queries ],
                "schema": [ relative + "/" + f.path for f in ctx.files.schema ],
                "gen": {
                    "go":{
                        "package": ctx.attr.package,
                        "out": relative + "/" + out_db.dirname,
                    },
                },
            }
        ],
    }

    ctx.actions.write(config_file, json.encode(sqlc_config))

    args = ctx.actions.args()
    args.add("generate")
    args.add("--no-remote")
    args.add("--file", config_file)

    ctx.actions.run(
        mnemonic="SqlcGenerateGo",
        outputs=outputs,
        inputs=[config_file] + ctx.files.schema + ctx.files.queries,
        executable=toolchain.sqlcinfo.tool_files[0],
        arguments=[ args ],
    )

    return [
        DefaultInfo(files = depset(outputs)),
        OutputGroupInfo(
            go_generated_srcs=outputs,
        ),
    ]

sqlc_generate_go = rule(
    _sqlc_generate_go,
    attrs = {
        "engine": attr.string(
            doc = "SQL engine",
            mandatory = True,
            values = ["postgresql", "mysql", "sqlite"],
        ),
        "schema": attr.label_list(
            doc = "SQL schema",
            allow_files = [".sql"],
        ),
        "queries": attr.label_list(
            doc = "SQL Schema",
            allow_files = [".sql"],
        ),
        "package": attr.string(),
    },
    toolchains = ["//sqlc:toolchain_type"],
)
