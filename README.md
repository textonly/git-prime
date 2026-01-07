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


--

# git-prime

Create git commits with prime SHA-1 hashes.

## What is this?

`git-prime` is a tool that fuzzes your commit message until it finds one that produces a **prime number** when the SHA-1 hash is interpreted as a 160-bit integer.

## Installation

**Linux/macOS:**
```bash
curl -fsSL https://textonly.github.io/git-prime/install.sh | bash
```

## Usage

### Basic
```bash
git prime-commit "Your commit message"
```

### Advanced Constraints
You can make the search harder (why?) by adding prefixes or difficulty requirements. **The result is always guaranteed to be prime**, regardless of other flags.

**Proof of Work (Leading Zeros):**
Find a prime hash that starts with 3 zeros.
```bash
git prime-commit "Initial commit" --difficulty 3
```

**Hex Vanity Prefix:**
Find a prime hash starting with `dead...`
```bash
git prime-commit "Fix bug" --hex-prefix dead
```

**Decimal Prefix:**
Find a prime hash where the integer value starts with `123...`
```bash
git prime-commit "Refactor" --prefix 123
```

**Timeout:**
Stop after 60 seconds if no prime is found (the default searches forever).
```bash
git prime-commit "WIP" --timeout 60
```

### Viewing Logs
Check which of your commits are mathematically pure:
```bash
git prime-log
```

## Why though?

### The Mathematical Explanation
SHA-1 hashes are 160-bit integers. By the Prime Number Theorem, the density of primes near $x$ is approximately $1/\ln(x)$. For a 160-bit number ($2^{160}$), $\ln(2^{160}) \approx 111$. This means roughly 1 in every 111 SHA-1 hashes is prime.

However, standard git commits are randomly distributed. `git-prime` forces the universe to align by incrementing a nonce in the commit trailer until a prime is found.

### The Philosophical Explanation
We live in a chaotic universe. Most data is composite, divisible, breakable. A prime number is atomic; it cannot be divided. 

By ensuring your commit hash is prime, you are creating an immutable, indivisible anchor in the history of your project. You are not just pushing code; you are claiming a unique coordinate in number theory space that can never be factored.

Also, it looks cool in `git prime-log`.

## License

MIT
