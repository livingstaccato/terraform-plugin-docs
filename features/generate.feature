# Metadata:
#   File: cmd/tfplugindocs/main.go
#   Covers: generate command

Feature: Generate documentation for a Terraform provider
  In order to have up-to-date documentation for my Terraform provider
  As a provider developer
  I want to use the `tfplugindocs generate` command

  Scenario: Generating documentation with generic templates
    Given a Terraform provider with the following files:
      | File                                                               | Content                                                               |
      | templates/index.md.tmpl                                            | # {{ .ProviderName }}                                                 |
      | templates/resources.md.tmpl                                        | # {{ .Name }}                                                         |
      | templates/data-sources.md.tmpl                                     | # {{ .Name }}                                                         |
      | examples/provider/provider.tf                                      | provider "test" {}                                                    |
      | examples/resources/test_resource/resource.tf                       | resource "test_resource" "example" {}                                 |
      | examples/data-sources/test_data_source/data-source.tf              | data "test_data_source" "example" {}                                  |
      | internal/provider/provider.go                                      | // Go source code for the provider                                    |
      | internal/provider/example_resource.go                              | // Go source code for the resource                                    |
      | internal/provider/example_data_source.go                           | // Go source code for the data source                                 |
      | main.go                                                            | // Go source code for the main package                                |
      | go.mod                                                             | module test                                                           |
    And a `schema.json` file for the provider
    When I run `tfplugindocs generate --providers-schema=schema.json`
    Then the following files should be generated:
      | File                     | Content                               |
      | docs/index.md            | # test                                |
      | docs/resources/test_resource.md | # test_resource                       |
      | docs/data-sources/test_data_source.md | # test_data_source                    |

  Scenario: Generating documentation with named templates
    Given a Terraform provider with the following files:
      | File                                                               | Content                                                               |
      | templates/index.md.tmpl                                            | # {{ .ProviderName }}                                                 |
      | templates/resources/test_resource.md.tmpl                          | # {{ .Name }} - Named Template                                        |
      | templates/data-sources/test_data_source.md.tmpl                      | # {{ .Name }} - Named Template                                        |
      | examples/provider/provider.tf                                      | provider "test" {}                                                    |
      | examples/resources/test_resource/resource.tf                       | resource "test_resource" "example" {}                                 |
      | examples/data-sources/test_data_source/data-source.tf              | data "test_data_source" "example" {}                                  |
      | internal/provider/provider.go                                      | // Go source code for the provider                                    |
      | internal/provider/example_resource.go                              | // Go source code for the resource                                    |
      | internal/provider/example_data_source.go                           | // Go source code for the data source                                 |
      | main.go                                                            | // Go source code for the main package                                |
      | go.mod                                                             | module test                                                           |
    And a `schema.json` file for the provider
    When I run `tfplugindocs generate --providers-schema=schema.json`
    Then the following files should be generated:
      | File                     | Content                               |
      | docs/index.md            | # test                                |
      | docs/resources/test_resource.md | # test_resource - Named Template      |
      | docs/data-sources/test_data_source.md | # test_data_source - Named Template |

  Scenario: Generating documentation with no templates
    Given a Terraform provider with the following files:
      | File                                                               | Content                                                               |
      | examples/provider/provider.tf                                      | provider "test" {}                                                    |
      | examples/resources/test_resource/resource.tf                       | resource "test_resource" "example" {}                                 |
      | examples/data-sources/test_data_source/data-source.tf              | data "test_data_source" "example" {}                                  |
      | internal/provider/provider.go                                      | // Go source code for the provider                                    |
      | internal/provider/example_resource.go                              | // Go source code for the resource                                    |
      | internal/provider/example_data_source.go                           | // Go source code for the data source                                 |
      | main.go                                                            | // Go source code for the main package                                |
      | go.mod                                                             | module test                                                           |
    And a `schema.json` file for the provider
    When I run `tfplugindocs generate --providers-schema=schema.json`
    Then the following files should be generated:
      | File                     |
      | docs/index.md            |
      | docs/resources/test_resource.md |
      | docs/data-sources/test_data_source.md |
    And the file "docs/index.md" should contain "# test"
    And the file "docs/resources/test_resource.md" should contain "<!-- schema generated by tfplugindocs -->"
    And the file "docs/data-sources/test_data_source.md" should contain "<!-- schema generated by tfplugindocs -->"
