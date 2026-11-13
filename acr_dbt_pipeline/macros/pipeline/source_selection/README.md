# Source selection

Architecture-owned macros that turn `vars.enabled_srcs`, `vars.site_filters`,
`vars.consent_filters`, `vars.disabled_src_tables`, and snapshot metadata into
model enablement, site/consent tags, and canonical source model names.

Change selection through project variables, not by editing these macros.
Disable an unavailable table with a `<snapshot>.<table>` entry, such as
`cmg_uwash_gru_irb.workspace_attributes`.

Source model names come from the stable snapshot key, not the configured
`consent` value. Consent labels can therefore be replaced with metadata
`consentCode` values without renaming models or breaking `ref()` calls.
