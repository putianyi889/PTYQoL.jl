# PTY-QoL (PTY's Quality of Life package)

[![Build Status](https://github.com/putianyi889/PTY-QoL.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/putianyi889/PTY-QoL.jl/actions/workflows/CI.yml?query=branch%3Amaster)

Want just an easy feature that Julia or some package doesn't have, while the PR gets rejected/takes forever to get merged? This is a personal collection of little things that makes coding easier while not breaking existing things.

Full of type piracies. However they are not supposed to break anything. They only brings an extension of the functionalities. Do file an issue if this package does break other things or becomes a part of Julia/some other package.

**Remark** Technically this package does break things. Due to the extension, some method errors are eliminated, so if you rely on those errors, don't use this package.

This package should be only guaranteed to support the latest stable version of Julia.

Rule of new version:
- `(It's been at least 24 hrs since the last version) && ((an external PR is merged) || (an issue is resolved) || (the number of line changes reach 100)`
