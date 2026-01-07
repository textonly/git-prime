# git-prime

Create git commits with prime SHA-1 hashes.

## What is this?

`git-prime` is a tool that fuzzes your commit message until it finds one that produces a **prime number** when the SHA-1 hash is interpreted as a 160-bit integer.

Why? Because you can. And because prime commit hashes are mathematically indivisible.

## Installation

**Linux/macOS:**
```bash
curl -fsSL https://textonly.github.io/git-prime/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://textonly.github.io/git-prime/install.ps1 | iex
```

**Manual Installation:**
If you prefer not to pipe URLs to bash:
1. Download the scripts from this repo.
2. Place them in your `$PATH`.
3. Ensure they are executable (`chmod +x`).

## Usage

### Basic Commit
Instead of `git commit`, use:
```bash
git prime-commit "Your commit message"
# or
git prime-commit -m "Your commit message"
```

The tool will:
1. Create a commit object.
2. Check if the hash is prime.
3. If not, append a `Prime-Nonce: N` trailer to the message and try again.
4. Repeat until a prime hash is found.

### Advanced Constraints
You can make the search harder by adding prefixes or difficulty requirements. **The result is always guaranteed to be prime**, regardless of other flags.

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
Check which of your commits are mathematically pure using the custom log viewer:
```bash
git prime-log
```

## How it works

- **SHA-1 hashes** are 160 bits (40 hex characters).
- Interpreted as integers, they range from 0 to ~$10^{48}$.
- **Miller-Rabin primality test** checks if the hash is prime (probabilistic, 40 rounds).
- **Message fuzzing** appends a Git trailer (`Prime-Nonce: 1`, `Prime-Nonce: 2`, etc.) to find different hashes without changing the commit body significantly.

**Performance:**
Typical runtime is 30–120 seconds. The tool uses fast string matching for prefixes/difficulty first, then runs the computationally expensive primality test only on candidates that match the structure.

## Why though?

### The Mathematical Explanation
SHA-1 hashes are 160-bit integers. By the Prime Number Theorem, the density of primes near $x$ is approximately $1/\ln(x)$. For a 160-bit number ($2^{160}$), $\ln(2^{160}) \approx 111$. This means roughly 1 in every 111 SHA-1 hashes is prime.

However, standard git commits are randomly distributed. `git-prime` forces the universe to align by incrementing a nonce until a prime is found.

### The Philosophical Explanation
We live in a chaotic universe. Most data is composite, divisible, breakable. A prime number is atomic; it cannot be divided.

By ensuring your commit hash is prime, you are creating an immutable, indivisible anchor in the history of your project. You are not just pushing code; you are claiming a unique coordinate in number theory space that can never be factored.

### Security & Collisions
**Does this weaken the repository security?**

Technically, yes. Practically, no.

Restricting hashes to prime numbers reduces the search space by a factor of ~111. In information theoretic terms, this reduces the entropy by $\log_2(111) \approx 6.79$ bits.

- **Standard SHA-1:** 160 bits of entropy.
- **Prime SHA-1:** ~153.2 bits of entropy.

While SHA-1 has known collision vulnerabilities (SHAttered), losing 7 bits of entropy to primality constraints does not meaningfully increase the risk of accidental collisions in any universe we currently inhabit.

## License

MIT
