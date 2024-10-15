
def _sqlc_generate_go(ctx):
    toolchain = ctx.toolchains["//sqlc:toolchain_type"]

    out_db = ctx.actions.declare_file(ctx.label.name + "_db.go")
    out_models = ctx.actions.declare_file(ctx.label.name + "_models.go")
    outputs = [out_db, out_models]

    if len(ctx.files.queries) > 1:
        out_querier = ctx.actions.declare_file(ctx.label.name + "_querier.go")
        outputs.append(out_querier)

    # Each query file will generate a .go file based off its name.
    for query_file in ctx.files.queries:
        query_output = ctx.actions.declare_file("%s.go" % query_file.basename)
        outputs.append(query_output)

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
                        "emit_db_tags": True,
                        "emit_interface": True,
                        "emit_json_tags": True,
                        "emit_sql_as_comment": True,
                        "package": ctx.attr.package,
                        "out": relative + "/" + out_db.dirname,
                        "output_db_file_name": ctx.label.name + "_db.go",
                        "output_models_file_name": ctx.label.name + "_models.go",
                        "output_querier_file_name": ctx.label.name + "_querier.go",
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
            doc = "SQL schema files",
            allow_files = [".sql"],
        ),
        "queries": attr.label_list(
            doc = "SQL query files",
            allow_files = [".sql"],
        ),
        "package": attr.string(
            doc = "Go package name"
        ),
    },
    toolchains = ["//sqlc:toolchain_type"],
)
