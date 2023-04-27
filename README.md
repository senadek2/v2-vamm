# Prerequistes

- Node v18 and `yarn`/`pnpm`
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Create global `.yarnrc.yml` file: `touch ~/.yarnrc.yml` and paste the following:
  ```
  npmRegistries:
    https://npm.pkg.github.com/:
      npmAuthToken: <Your GitHub Personal Access Token>
  ```

- Run `yarn` to install dependencies

# Testing

Install [foundry](https://book.getfoundry.sh/getting-started/installation) and run: `forge test`. E.g.

- `forge test --no-match-test "SlowFuzz"` will run all of the tests except some exceptionally slow fuzzing tests.
- `forge test -vvv"` will run all of the tests and provide verbose output (for even more verbose, add more `v`s).

# Gas costs

We have saved some gas cost snapshots, with the latest typically being saved at `.gas-snapshot`. To see all snapshots run `ls -a .gas*`.

To generate and updated gas snapshot, run `forge snapshot --no-match-test "SlowFuzz"`.

To diff current gas costs with an earlier snapshot, pass the earlier snapshot as the `--diff` argument, e.g.: `forge snapshot --diff .gas_snapshot.preOptimisations --no-match-test "SlowFuzz"`

# Deployment

TODO.

# Open issues

- Testing is very much a work in progress. _Lots_ still to test.
- Need to add the concept of spread to all trades, so that LPs take the spread. (Safest to do this alongside relevant tests.)
- Deployment logic is non-existent
- We need to integrate with the `v2-core` repo, and in doing so we will presumably discover some API incompatibilities.
- Authorisation of many non-view functions is absent. Need a clear design and implementation here. msg.sender will probably not be the end user, but one of our contracts.
- (how/when) are old positions removed from the positions list, to speed up future operations?
- Measure code coverage, gas usage etc.
- Linting, formatting, git hooks and CI config, etc.

# Testing plan

Continue with docs and tests of low-level functions in isolation, and work up to higher functions that call them.

Docs will act as a sanity check that I'm testing the right thing.

- flipTicks?
- trackFixedTokens
- trackValuesBetweenTicks
- calculateUpdatedGlobalTrackerValues
- getAccountUnfilledBases
- getAccountFilledBases
- trackValuesBetweenTicksOutside
- growthBetweenTicks

Fix issues found.

Once we have tests, we can refactor some of the above to be more efficient. E.g. remove substantial re-fetching of the same data within a swap's tick iteration loop.

Then move on to higher level functions:

- vammMint
- vammSwap
