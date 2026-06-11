# Release a version

## Purpose
Cut a new ChangeFlow plugin version cleanly.

## When to use
When shipping a versioned release.

## Steps
1. Bump `version` in **both** `.claude-plugin/plugin.json` and the plugin entry in
   `.claude-plugin/marketplace.json` — they must agree.
2. Update `README.md` / CHANGELOG if present.
3. Run `claude plugin validate . --strict` — must pass.
4. Commit. Get explicit permission, then push.
5. (Optional) `claude plugin tag .` to create the `<name>--v<version>` git tag
   (it validates that plugin.json and the marketplace entry agree).

## Gotchas
- If `plugin.json` and the marketplace entry disagree on `version`, `tag` and
  strict validation complain.
- `skills-dir` installs track the symlink/commit (live); marketplace installs
  track the published `version` — only bumping it gives marketplace users the update.

## Related
- Contracts: `docs/CONTRACTS.md#docs-tooling`
