import unittest

from scripts.import_stage_tests import merge_release_tests


class ImportStageTests(unittest.TestCase):
    def test_imports_table_and_column_tests_without_rewriting_arguments(self):
        test = {
            "relationships": {
                "arguments": {
                    "to": "source('release', 'other_table')",
                    "field": '"other_id"',
                    "column_name": '"record_id"',
                }
            }
        }
        release = {
            "sources": [{
                "name": "release",
                "tables": [{
                    "name": "some_link_table",
                    "tests": ["release_table_test"],
                    "columns": [{"name": '"record_id"', "tests": ["not_null", test]}],
                }],
            }],
        }
        column = {"name": "study_stb_Record_ID", "data_tests": ["unique", "not_null"]}
        model = {"name": "Study_STB_SomeLink Table", "description": "Keep me", "columns": [column]}
        stage = {"models": [model]}

        self.assertEqual(merge_release_tests(release, stage, "study_stb"), (2, []))
        self.assertEqual(model["tests"], ["release_table_test"])
        self.assertEqual(model["description"], "Keep me")
        self.assertEqual(model["name"], "Study_STB_SomeLink Table")
        self.assertEqual(column, {
            "name": "study_stb_Record_ID",
            "data_tests": ["unique", "not_null", test],
        })
        self.assertEqual(merge_release_tests(release, stage, "study_stb"), (0, []))

    def test_reports_unmatched_tests_without_creating_models_or_columns(self):
        release = {"models": [
            {"name": "only_release", "data_tests": ["table_check"]},
            {"name": "shared", "columns": [{"name": "missing", "tests": ["not_null"]}]},
        ]}
        stage = {"models": [{"name": "shared"}]}

        self.assertEqual(
            merge_release_tests(release, stage, ""),
            (0, ["only_release", "shared.missing"]),
        )
        self.assertEqual(stage, {"models": [{"name": "shared"}]})

    def test_rejects_ambiguous_model_names(self):
        release = {"models": [{"name": "a_b", "tests": ["table_check"]}]}
        stage = {"models": [{"name": "prefix_ab"}, {"name": "prefix_a_b"}]}

        with self.assertRaisesRegex(ValueError, "ambiguous names"):
            merge_release_tests(release, stage, "prefix")


if __name__ == "__main__":
    unittest.main()
