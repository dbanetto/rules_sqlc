"""Mirror of release info

TODO: generate this file from GitHub API"""

# The integrity hashes can be computed with
# shasum -b -a 384 [downloaded file] | awk '{ print $1 }' | xxd -r -p | base64
TOOL_VERSIONS = {
    "1.27.0": {
        "darwin_arm64": "sha384-0zAr+AO9WUQAl3yD/hhh0MnN4oKVruUfMopwGR8cf3s8S0feG0d4G1PHFB5/5cGa",
        "darwin_amd64": "sha384-MD6vjOseVQ04wtMzYxRgO4U7rh3/e2mw16kwYQJJErR3K/mOepkJ9RWNUjp0ugjp",
        "linux_amd64": "sha384-NpRYM+ca1wV1/txH0arZosBP8TS7q2s8jy1E4Ce1c+Tw58bJmkAz9x4oFDxDJoWD",
        "linux_arm64": "sha384-Xe4moSzGUKze3/IR2jDo/bml8Yf+wigLyUU9YM69abwfdJQU0vpir+eq/9r7vq14",
        "windows_amd64": "sha384-fBNPCU30+h8oNmcFpeaYWKlhoFtrV1sMvMJhQcd6pakpCL4H/l6vAVdiN9lKfx4L",
    },
}
