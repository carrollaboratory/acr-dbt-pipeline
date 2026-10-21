{#-
  Stacks anvil_dataset across every snapshot in vars.enabled_srcs.

  No cleaning happens here. This stage only brings the sites together so the
  int stage can clean the combined table once instead of once per snapshot.
-#}
{{ union_enabled_srcs('anvil_dataset') }}
