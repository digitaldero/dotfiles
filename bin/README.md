# bin/

Collection of personal scripts and utilities.

## How the PATH works here

Only scripts placed **directly** in this `bin/` directory are available in your `$PATH`.

Scripts living in subfolders (`utils/`, `media/`, `legacy/`, etc.) are **not** automatically in your PATH.

### Recommended approach

- Keep frequently used, general-purpose scripts directly in `bin/`.
- Move specialized, old, or category-specific scripts into the appropriate subfolder.
- If you want something in a subfolder to be easily runnable by name, you can either:
  - Move it back to the top level of `bin/`, or
  - Create a small wrapper script in `bin/` that calls the one in the subfolder.

## Current Structure

- `utils/` — General purpose, actively used scripts
- `legacy/` — Old or deprecated tools
  - `drupal/` — Old Drupal 6/7 related scripts
- `media/` — Audio and video conversion / processing scripts
- `music/` — Music/instrument related scripts
- `security/` — Certificate and key generation tools
- `openbox/` — Openbox-specific scripts
- `bots/` — Automation and bot-related scripts
- `archive/` — Old scripts kept for reference only (safe to delete when no longer needed)

## Notes

This structure was created during a 2026 cleanup pass. Many older scripts were moved into `legacy/` and `media/`.

Feel free to promote scripts back to the top level of `bin/` if you use them frequently.
