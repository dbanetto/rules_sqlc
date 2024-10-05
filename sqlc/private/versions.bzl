"""Mirror of release info

TODO: generate this file from GitHub API"""

# The integrity hashes can be computed with
# shasum -b -a 384 [downloaded file] | awk '{ print $1 }' | xxd -r -p | base64
TOOL_VERSIONS = {
    "1.27.0": {
        "darwin_arm64": "sha384-0zAr+AO9WUQAl3yD/hhh0MnN4oKVruUfMopwGR8cf3s8S0feG0d4G1PHFB5/5cGa",
    },
}
