# Metadata:
#   File: internal/cmd/validate.go
#   Covers: validate command

Feature: Validate documentation for a Terraform provider
  In order to ensure my documentation is valid and follows best practices
  As a provider developer
  I want to use the `tfplugindocs validate` command

  Scenario: Valid documentation
    Given a Terraform provider with the following valid documentation:
      | File                                      | Content                                                                 |
      | docs/index.md                             | ---
layout: "test"
page_title: "Test Provider"
sidebar_current: "docs-test-index"
---
# Test Provider
 |
      | docs/resources/test_resource.md           | ---
layout: "test"
page_title: "test_resource"
sidebar_current: "docs-test-resources-test_resource"
---
# test_resource
 |
      | docs/data-sources/test_data_source.md     | ---
layout: "test"
page_title: "test_data_source"
sidebar_current: "docs-test-data-sources-test_data_source"
---
# test_data_source
 |
    And a `schema.json` file for the provider with a resource "test_resource" and a data source "test_data_source"
    When I run `tfplugindocs validate --providers-schema=schema.json`
    Then the validation should pass

  Scenario: Invalid directory structure
    Given a Terraform provider with an invalid directory structure:
      | File                    | Content |
      | invalid-dir/index.md    | # Invalid |
    When I run `tfplugindocs validate`
    Then the validation should fail with the error "invalid Terraform Provider documentation directory found"

  Scenario: Mixed legacy and registry directory structures
    Given a Terraform provider with a mixed directory structure:
      | File                    | Content |
      | website/docs/r/test.md  | # Legacy |
      | docs/resources/test.md  | # Registry |
    When I run `tfplugindocs validate`
    Then the validation should fail with the error "mixed Terraform Provider documentation directory layouts found"

  Scenario: Invalid file extension
    Given a Terraform provider with a file with an invalid extension:
      | File                    | Content |
      | docs/resources/test.txt | # Invalid |
    When I run `tfplugindocs validate`
    Then the validation should fail with the error "file does not end with a valid extension"

  Scenario: File mismatch - extraneous file
    Given a Terraform provider with an extraneous documentation file:
      | File                          | Content |
      | docs/resources/extra_file.md  | # Extra |
    And a `schema.json` file for the provider that does not contain "extra_file"
    When I run `tfplugindocs validate --providers-schema=schema.json`
    Then the validation should fail with the error "matching resource for documentation file (extra_file.md) not found"

  Scenario: File mismatch - missing file
    Given a Terraform provider with a missing documentation file for "missing_resource"
    And a `schema.json` file for the provider with a resource "missing_resource"
    When I run `tfplugindocs validate --providers-schema=schema.json`
    Then the validation should fail with the error "missing documentation file for resource: missing_resource"

  Scenario: Invalid frontmatter - missing required field
    Given a Terraform provider with a documentation file with missing frontmatter:
      | File                    | Content |
      | docs/index.md           | # Missing frontmatter |
    When I run `tfplugindocs validate --require-layout`
    Then the validation should fail with the error "YAML frontmatter missing required layout"

  Scenario: Invalid frontmatter - subcategory not in allowed list
    Given a Terraform provider with a documentation file with an invalid subcategory:
      | File                    | Content |
      | docs/resources/test.md  | ---
subcategory: "Invalid Category"
---
# Invalid Subcategory
 |
    When I run `tfplugindocs validate --allowed-resource-subcategories="Valid Category"`
    Then the validation should fail with the error "YAML frontmatter contains a subcategory (Invalid Category) that is not in the allowed list"
