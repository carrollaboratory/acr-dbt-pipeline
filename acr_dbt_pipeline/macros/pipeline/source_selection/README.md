# Source selection

Architecture-owned macros that turn `vars.enabled_srcs`, `vars.disabled_src_tables`,
and snapshot metadata into model enablement, site/consent tags, and canonical
source model names.

Change selection through project variables, not by editing these macros.
Disable an unavailable table with a `<snapshot>.<table>` entry, such as
`cmg_uwash_gru_irb.workspace_attributes`.
