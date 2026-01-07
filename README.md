# git-prime

Create git commits with prime SHA-1 hashes.

## What is this?

`git-prime` is a tool that fuzzes your commit message until it finds one that produces a **prime number** when the SHA-1 hash is interpreted as a 160-bit integer.

Why? Because you can. And because prime commit hashes are cool.

## Installation

**Linux/macOS:**
```bash
curl -fsSL https://textonly.github.io/git-prime/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://textonly.github.io/git-prime/install.ps1 | iex
```

Or manually:
```bash
curl -fsSL https://textonly.github.io/git-prime/git-prime-commit -o ~/.local/bin/git-prime-commit
chmod +x ~/.local/bin/git-prime-commit
```

## Usage

Instead of `git commit`, use:

```bash
git prime-commit "Your commit message"
# or
git prime-commit -m "Your commit message"
```

The tool will:
1. Try committing with your message
2. Check if the SHA-1 hash is prime (160-bit primality test)
3. If not prime, append a nonce and try again
4. Repeat until a prime hash is found

Example output:
```
Searching for prime commit hash...
Base message: Fix bug in parser
Attempt 10: d051b974ece9d844... not prime
Attempt 20: 954de912a9e5bbce... not prime
...
Attempt 168: cb80ebbd975f0028... not prime

[PRIME] Found after 168 attempts!
  Commit: cb80ebbd975f00288dca70d8fa735c688755f947
  Hash as int: 1161800157764419353674868058637793188631547345223
  Message nonce: 167
```

## How it works

- **SHA-1 hashes** are 160 bits (40 hex characters)
- Interpreted as integers, they range from 0 to ~10^48
- **Miller-Rabin primality test** checks if the hash is prime (probabilistic, 40 rounds)
- **Message fuzzing** appends `\n\nNonce: N` to find different hashes
- On average, expects ~368 attempts (prime density at this scale)

## Requirements

- Python 3.6+
- Git
- POSIX shell (bash/zsh) for installer

## Performance

Typical runtime: 30-120 seconds depending on luck and hardware.

Each attempt involves:
- Creating a git commit object
- Computing SHA-1 hash
- Miller-Rabin primality test (fast for 160-bit numbers)
- Soft-reset if not prime

## Git subcommand integration

Once installed, git automatically discovers `git-prime-commit` as a subcommand, so you can use:

```bash
git prime-commit "message"
```

No special configuration needed!

## License

MIT - Do whatever you want with it.

## Why though?

Because hunting for prime commit hashes is more fun than arguing about commit message conventions.
