{% docs GWAS_ftd_datasource_external_id_description %}
Model for GWAS_ftd_datasource_external_id.
{% enddocs %}


{% docs GWAS_ftd_datasource_external_id_datasource_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_datasource_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_sample_description %}
Model for GWAS_ftd_sample.
{% enddocs %}


{% docs GWAS_ftd_sample_parent_sample %}
Sample from which this sample is derived
{% enddocs %}


{% docs GWAS_ftd_sample_sample_type %}
Type of material of which this Sample is comprised
{% enddocs %}


{% docs GWAS_ftd_sample_availablity_status %}
Can this Sample be requested for further analysis?
{% enddocs %}


{% docs GWAS_ftd_sample_quantity_number %}
The total quantity of the specimen
{% enddocs %}


{% docs GWAS_ftd_sample_quantity_units %}
The structured term defining the units of the quantity.
{% enddocs %}


{% docs GWAS_ftd_sample_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_sample_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_sample_subject_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_sample_biospecimen_collection_id %}
Biospecimen Collection that generated this sample.
{% enddocs %}


{% docs GWAS_ftd_demographics_source_data_description %}
Model for GWAS_ftd_demographics_source_data.
{% enddocs %}


{% docs GWAS_ftd_demographics_source_data_demographics_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_demographics_source_data_source_data_id %}
The sources from which this assertion was derived
{% enddocs %}


{% docs GWAS_ftd_family_description %}
Model for GWAS_ftd_family.
{% enddocs %}


{% docs GWAS_ftd_family_family_type %}
Describes the 'type' of study family, eg, trio.
{% enddocs %}


{% docs GWAS_ftd_family_family_description %}
Free title describing the study family, such as potential inheritance or details about consanguinity
{% enddocs %}


{% docs GWAS_ftd_family_consanguinity %}
Is there known or suspected consanguinity in this study family?
{% enddocs %}


{% docs GWAS_ftd_family_family_study_focus %}
What is this study family investigating? EG, a specific condition. The code should be prefixed with a recognizable curie.
{% enddocs %}


{% docs GWAS_ftd_family_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_family_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_accesscontrolledrecord_description %}
Model for GWAS_ftd_accesscontrolledrecord.
{% enddocs %}


{% docs GWAS_ftd_accesscontrolledrecord_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_accesscontrolledrecord_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_external_id_description %}
Model for GWAS_ftd_biospecimencollection_external_id.
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_external_id_biospecimencollection_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_datasource_description %}
Model for GWAS_ftd_datasource.
{% enddocs %}


{% docs GWAS_ftd_datasource_snapshot_id %}
The Terra Data Repository Snapshot ID.
{% enddocs %}


{% docs GWAS_ftd_datasource_google_data_project %}
The Google Data Project needed to query this snapshot in BigQuery.
{% enddocs %}


{% docs GWAS_ftd_datasource_snapshot_dataset %}
The Dataset within BigQuery where the table can be queried.
{% enddocs %}


{% docs GWAS_ftd_datasource_table %}
The table in the dataset that contains the row of interest.
{% enddocs %}


{% docs GWAS_ftd_datasource_parameterized_query %}
A parameterized query that contains the primary key fields and can be used to select specific rows. This should be formatted according to (https://cloud.google.com/bigquery/docs/parameterized-queries)[BigQuery instructions], including using named parameters.
{% enddocs %}


{% docs GWAS_ftd_datasource_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_description %}
Model for GWAS_ftd_subjectassertion.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_assertion_type %}
The semantic type of the resource, eg, Condition.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_age_at_assertion %}
The age in decimal years of the Subject when the assertion was made.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_age_at_event %}
The age in decimal years of the Subject at the time point which the assertion describes, | eg, age of onset or when a measurement was performed.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_age_at_resolution %}
The age in decimal years of the Subject when the asserted state was resolved.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_code %}
The structured term defining the meaning of the assertion.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_display %}
The friendly display string of the coded term
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_value_code %}
The structured term defining the value of the assertion.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_value_display %}
The friendly display string of the coded term for the value of the assertion.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_value_number %}
The numeric value of the assertion.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_value_units %}
The structured term defining the units of the value.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_value_units_display %}
The friendly display string of units of the value.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_subject_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_description %}
Model for GWAS_ftd_accesspolicy.
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_disease_limitation %}
Disease Use Limitations
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_website %}
Website
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_filemetadata_description %}
Model for GWAS_ftd_filemetadata.
{% enddocs %}


{% docs GWAS_ftd_filemetadata_code %}
The structured term defining the meaning of the assertion.
{% enddocs %}


{% docs GWAS_ftd_filemetadata_display %}
The friendly display string of the coded term
{% enddocs %}


{% docs GWAS_ftd_filemetadata_value_code %}
The structured term defining the value of the assertion.
{% enddocs %}


{% docs GWAS_ftd_filemetadata_value_display %}
The friendly display string of the coded term for the value of the assertion.
{% enddocs %}


{% docs GWAS_ftd_filemetadata_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_file_description %}
Model for GWAS_ftd_file.
{% enddocs %}


{% docs GWAS_ftd_file_filename %}
The name of the file.
{% enddocs %}


{% docs GWAS_ftd_file_format %}
The format of the file.
{% enddocs %}


{% docs GWAS_ftd_file_data_type %}
The type of data within this file.
{% enddocs %}


{% docs GWAS_ftd_file_size %}
Size of the file, in Bytes.
{% enddocs %}


{% docs GWAS_ftd_file_drs_uri %}
DRS location to access the data.
{% enddocs %}


{% docs GWAS_ftd_file_file_metadata %}
Additional metadata about the contents of the file, eg, genome reference build.
{% enddocs %}


{% docs GWAS_ftd_file_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_file_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_sample_processing_description %}
Model for GWAS_ftd_sample_processing.
{% enddocs %}


{% docs GWAS_ftd_sample_processing_sample_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_sample_processing_processing %}
Processing that was applied to the Parent Sample or from the Biospecimen Collection that yielded this distinct sample
{% enddocs %}


{% docs GWAS_ftd_file_sample_description %}
Model for GWAS_ftd_file_sample.
{% enddocs %}


{% docs GWAS_ftd_file_sample_file_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_file_sample_sample_id %}
The Samples(s) used to generate data in this file.
{% enddocs %}


{% docs GWAS_ftd_filemetadata_external_id_description %}
Model for GWAS_ftd_filemetadata_external_id.
{% enddocs %}


{% docs GWAS_ftd_filemetadata_external_id_filemetadata_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_filemetadata_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_subject_description %}
Model for GWAS_ftd_subject.
{% enddocs %}


{% docs GWAS_ftd_subject_subject_type %}
Type of entity this record represents
{% enddocs %}


{% docs GWAS_ftd_subject_organism_type %}
Organism Type Label
{% enddocs %}


{% docs GWAS_ftd_subject_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_subject_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_subject_has_demographics_id %}
A demographic summary of the participant.
{% enddocs %}


{% docs GWAS_ftd_sourcedata_query_parameter_description %}
Model for GWAS_ftd_sourcedata_query_parameter.
{% enddocs %}


{% docs GWAS_ftd_sourcedata_query_parameter_sourcedata_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_sourcedata_query_parameter_query_parameter %}
One or more query parameters used to select the specific row. It will leverage the parameterized_query defined by a data_source. This should be formatted according to (https://cloud.google.com/bigquery/docs/parameterized-queries)[BigQuery instructions], specifically the bq CLI version with named parameters, ie, "<parameter name>:<data type>:<value>".
{% enddocs %}


{% docs GWAS_ftd_sample_storage_method_description %}
Model for GWAS_ftd_sample_storage_method.
{% enddocs %}


{% docs GWAS_ftd_sample_storage_method_sample_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_sample_storage_method_storage_method %}
Sample storage method, eg, Frozen or with additives
{% enddocs %}


{% docs GWAS_ftd_sample_external_id_description %}
Model for GWAS_ftd_sample_external_id.
{% enddocs %}


{% docs GWAS_ftd_sample_external_id_sample_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_sample_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_external_id_description %}
Model for GWAS_ftd_familyrelationship_external_id.
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_external_id_familyrelationship_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_family_family_relationships_description %}
Model for GWAS_ftd_family_family_relationships.
{% enddocs %}


{% docs GWAS_ftd_family_family_relationships_family_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_family_family_relationships_family_relationships_id %}
Family relationships associated with this family.
{% enddocs %}


{% docs GWAS_ftd_demographics_race_description %}
Model for GWAS_ftd_demographics_race.
{% enddocs %}


{% docs GWAS_ftd_demographics_race_demographics_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_demographics_race_race %}
Reported race as defined by the 1997 OMB directives.
{% enddocs %}


{% docs GWAS_ftd_study_funding_source_description %}
Model for GWAS_ftd_study_funding_source.
{% enddocs %}


{% docs GWAS_ftd_study_funding_source_study_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_study_funding_source_funding_source %}
Funding Source
{% enddocs %}


{% docs GWAS_ftd_family_external_id_description %}
Model for GWAS_ftd_family_external_id.
{% enddocs %}


{% docs GWAS_ftd_family_external_id_family_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_family_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_external_id_description %}
Model for GWAS_ftd_accesspolicy_external_id.
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_external_id_accesspolicy_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_aliquot_description %}
Model for GWAS_ftd_aliquot.
{% enddocs %}


{% docs GWAS_ftd_aliquot_availablity_status %}
Can this Sample be requested for further analysis?
{% enddocs %}


{% docs GWAS_ftd_aliquot_quantity_number %}
The total quantity of the specimen
{% enddocs %}


{% docs GWAS_ftd_aliquot_quantity_units %}
The structured term defining the units of the quantity.
{% enddocs %}


{% docs GWAS_ftd_aliquot_concentration_number %}
What is the concentration of the analyte in the Aliquot?
{% enddocs %}


{% docs GWAS_ftd_aliquot_concentration_unit %}
Units associated with the concentration of the analyte in the Aliquot? UCUM coding preferred (with curie, UCUM)
{% enddocs %}


{% docs GWAS_ftd_aliquot_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_aliquot_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_aliquot_sample_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_demographics_description %}
Model for GWAS_ftd_demographics.
{% enddocs %}


{% docs GWAS_ftd_demographics_date_of_birth %}
Date at which the individual was born. May be impacted by privacy rules described in date_of_birth_type.
{% enddocs %}


{% docs GWAS_ftd_demographics_date_of_birth_type %}
Privacy rule modification applied to date_of_birth.
{% enddocs %}


{% docs GWAS_ftd_demographics_sex %}
Sex of the individual
{% enddocs %}


{% docs GWAS_ftd_demographics_sex_display %}
The friendly display string of the coded term for Sex
{% enddocs %}


{% docs GWAS_ftd_demographics_race_display %}
The friendly display string of the coded term(s) for Race
{% enddocs %}


{% docs GWAS_ftd_demographics_ethnicity %}
Reported ethnicity as defined by the 1997 OMB directives.
{% enddocs %}


{% docs GWAS_ftd_demographics_ethnicity_display %}
The friendly display string of the coded term for Ethnicity
{% enddocs %}


{% docs GWAS_ftd_demographics_age_at_last_vital_status %}
Age at last vital status in decimal years.
{% enddocs %}


{% docs GWAS_ftd_demographics_vital_status %}
Vital Status
{% enddocs %}


{% docs GWAS_ftd_demographics_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_demographics_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_familymember_external_id_description %}
Model for GWAS_ftd_familymember_external_id.
{% enddocs %}


{% docs GWAS_ftd_familymember_external_id_familymember_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_familymember_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_access_policy_code_description %}
Model for GWAS_ftd_accesspolicy_access_policy_code.
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_access_policy_code_accesspolicy_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_access_policy_code_access_policy_code %}
Access Policy Code
{% enddocs %}


{% docs GWAS_ftd_study_description %}
Model for GWAS_ftd_study.
{% enddocs %}


{% docs GWAS_ftd_study_parent_study_id %}
Parent Study ID
{% enddocs %}


{% docs GWAS_ftd_study_study_title %}
Study Title
{% enddocs %}


{% docs GWAS_ftd_study_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_external_id_description %}
Model for GWAS_ftd_subjectassertion_external_id.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_external_id_subjectassertion_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_description %}
Model for GWAS_ftd_biospecimencollection.
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_age_at_collection %}
The age at which this biospecimen was collected.
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_method %}
The approach used to collect the biospecimen.
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_site %}
The location of the specimen collection.
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_spatial_qualifier %}
Any spatial/location qualifiers
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_laterality %}
Laterality information for the site
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_biospecimencollection_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_description %}
Model for GWAS_ftd_familyrelationship.
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_family_member %}
The family member Subject who is the relationship "subject".
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_other_family_member %}
The family member Subject for the relationship "object".
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_relationship_code %}
Code definting the relationship predicate. Relationship of the "Family Member" to the "Other Family Member" (i.e. mother, father, etc). Code must be from the HL7 [FamilyMember ValueSet](https://terminology.hl7.org/6.2.0/ValueSet-v3-FamilyMember.html)
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_familyrelationship_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_aliquot_external_id_description %}
Model for GWAS_ftd_aliquot_external_id.
{% enddocs %}


{% docs GWAS_ftd_aliquot_external_id_aliquot_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_aliquot_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_familymember_description %}
Model for GWAS_ftd_familymember.
{% enddocs %}


{% docs GWAS_ftd_familymember_family_member %}
The family member Subject who is the relationship "subject".
{% enddocs %}


{% docs GWAS_ftd_familymember_family_role %}
The "role" of this indiviudal in this family.
{% enddocs %}


{% docs GWAS_ftd_familymember_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_familymember_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_familymember_family_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_subject_external_id_description %}
Model for GWAS_ftd_subject_external_id.
{% enddocs %}


{% docs GWAS_ftd_subject_external_id_subject_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_subject_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_file_external_id_description %}
Model for GWAS_ftd_file_external_id.
{% enddocs %}


{% docs GWAS_ftd_file_external_id_file_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_file_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_demographics_external_id_description %}
Model for GWAS_ftd_demographics_external_id.
{% enddocs %}


{% docs GWAS_ftd_demographics_external_id_demographics_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_demographics_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_source_data_description %}
Model for GWAS_ftd_subjectassertion_source_data.
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_source_data_subjectassertion_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_subjectassertion_source_data_source_data_id %}
The sources from which this assertion was derived
{% enddocs %}


{% docs GWAS_ftd_file_subject_description %}
Model for GWAS_ftd_file_subject.
{% enddocs %}


{% docs GWAS_ftd_file_subject_file_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_file_subject_subject_id %}
The Subject(s) which this file describes.
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_data_access_type_description %}
Model for GWAS_ftd_accesspolicy_data_access_type.
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_data_access_type_accesspolicy_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_accesspolicy_data_access_type_data_access_type %}
Data Access Type
{% enddocs %}


{% docs GWAS_ftd_accesscontrolledrecord_external_id_description %}
Model for GWAS_ftd_accesscontrolledrecord_external_id.
{% enddocs %}


{% docs GWAS_ftd_accesscontrolledrecord_external_id_accesscontrolledrecord_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_accesscontrolledrecord_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_sourcedata_description %}
Model for GWAS_ftd_sourcedata.
{% enddocs %}


{% docs GWAS_ftd_sourcedata_data_source %}
Defines the location of data and how to query it.
{% enddocs %}


{% docs GWAS_ftd_sourcedata_has_access_policy %}
Which access policy applies to this element?
{% enddocs %}


{% docs GWAS_ftd_sourcedata_id %}
ID associated with a class
{% enddocs %}


{% docs GWAS_ftd_sourcedata_external_id_description %}
Model for GWAS_ftd_sourcedata_external_id.
{% enddocs %}


{% docs GWAS_ftd_sourcedata_external_id_sourcedata_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_sourcedata_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}


{% docs GWAS_ftd_study_principal_investigator_description %}
Model for GWAS_ftd_study_principal_investigator.
{% enddocs %}


{% docs GWAS_ftd_study_principal_investigator_study_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_study_principal_investigator_principal_investigator %}
Principal Investigator
{% enddocs %}


{% docs GWAS_ftd_study_external_id_description %}
Model for GWAS_ftd_study_external_id.
{% enddocs %}


{% docs GWAS_ftd_study_external_id_study_id %}
Autocreated FK slot
{% enddocs %}


{% docs GWAS_ftd_study_external_id_external_id %}
Other identifiers for this entity, eg, from the submitting study or in systems link dbGaP
{% enddocs %}