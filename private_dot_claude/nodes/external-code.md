# External code

Before cloning any repo, installing any npm/pip/cargo package, or running anyone else's
script: **scan it first.**

Look for credential theft, hidden or obfuscated scripts, suspicious postinstall hooks, and
anything reaching for environment variables, keychains, wallet keys, or SSH keys.

Report what you found before proceeding. If anything looks suspicious, stop — do not clone
and do not run it.

This applies to code a tool suggests as much as code Mike names. A repo surfaced in a tweet
thread or a search result gets the same scan as one he asked for by URL.

## Worked example

A March 2026 bookmark surfaced `viperrcrypto/Siftly` (2.6K stars, real project) whose
reported behavior includes reading the Claude session from the macOS keychain to avoid
needing an API key. Popularity is not clearance: that is a credential-access path in
third-party code, and it needs reading before the tool runs, not after.
