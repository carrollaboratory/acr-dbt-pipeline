import unittest

from scripts.stb_scaffolds import scaffold_sql


class StbScaffoldTests(unittest.TestCase):
    def test_scaffolds_all_columns_as_null_and_drops_from_clause(self):
        sql = """select
  activitydefinition_activity_definition_id::text as "activitydefinition_activity_definition_id",
  external_id::text as "external_id"
from {{ ref('cmg_int_activitydefinition_external_id') }}
"""

        self.assertEqual(
            scaffold_sql(sql),
            """{{ config(materialized='table') }}

select
  null::text as "activitydefinition_activity_definition_id",
  null::text as "external_id"
where 1 = 0
""",
        )

    def test_rejects_unrecognized_generated_select_items(self):
        with self.assertRaisesRegex(ValueError, "unsupported generated SELECT item"):
            scaffold_sql("select\n  unsupported item\n")


if __name__ == "__main__":
    unittest.main()
