{
  "env": {
    "global": [
      "PLATFORMS=\"linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x,linux/ppc64le\"",
      "CROSS_PLATFORMS=\"${PLATFORMS},darwin/amd64,windows/amd64\"",
      "PREFER_BUILDCTL=\"1\""
    ]
  },
  "dist": "trusty",
  "sudo": "required",
  "deploy": [
    {
      "true": {
        "repo": "docker/buildx",
        "tags": true,
        "condition": "$TRAVIS_TAG =~ ^v[0-9]"
      },
      "script": "PLATFORMS=\"${CROSS_PLATFORMS}\" ./hack/release $TRAVIS_TAG release-out",
      "provider": "script"
    },
    {
      "file": "release-out/**/*",
      "true": {
        "repo": "docker/buildx",
        "tags": true,
        "condition": "$TRAVIS_TAG =~ ^v[0-9]"
      },
      "api_key": {
        "secure": "VKVL+tyS3BfqjM4VMGHoHJbcKY4mqq4AGrclVEvBnt0gm1LkGeKxSheCZgF1EC4oSV8rCy6dkoRWL0PLkl895MIl20Z4v53o1NOQ4Fn0A+eptnrld8jYUkL5PcD+kdEqv2GkBn7vO6E/fwYY/wH9FYlE+fXUa0c/YQGqNGS+XVDtgkftqBV+F2EzaIwk+D+QClFBRmKvIbXrUQASi1K6K2eT3gvzR4zh679TSdI2nbnTKtE06xG1PBFVmb1Ux3/Jz4yHFvf2d3M1mOyqIBsozKoyxisiFQxnm3FjhPrdlZJ9oy/nsQM3ahQKJ3DF8hiLI1LxcxRa6wo//t3uu2eJSYl/c5nu0T7gVw4sChQNy52fUhEGoDTDwYoAxsLSDXcpj1jevRsKvxt/dh2e2De1a9HYj5oM+z2O+pcyiY98cKDbhe2miUqUdiYMBy24xUunB46zVcJF3pIqCYtw5ts8ES6Ixn3u+4OGV/hMDrVdiG2bOZtNVkdbKMEkOEBGa3parPJ69jh6og639kdAD3DFxyZn3YKYuJlcNShn3tj6iPokBYhlLwwf8vuEV7gK7G0rDS9yxuF03jgkwpBBF2wy+u1AbJv241T7v2ZB8H8VlYyHA0E5pnoWbw+lIOTy4IAc8gIesMvDuFFi4r1okhiAt/24U0p4aAohjh1nPuU3spY="
      },
      "provider": "releases",
      "file_glob": true,
      "skip_cleanup": true
    }
  ],
  "script": [
    "make binaries validate-all && TARGETPLATFORM=\"${CROSS_PLATFORMS}\" ./hack/cross"
  ],
  "install": [
    "docker run --name buildkit --rm -d --privileged -p 1234:1234 $REPO_SLUG_ORIGIN --addr tcp://0.0.0.0:1234",
    "sudo docker cp buildkit:/usr/bin/buildctl /usr/bin/",
    "export BUILDKIT_HOST=tcp://0.0.0.0:1234"
  ]
}
