# Metadata:
#   File: internal/provider/template.go
#   Covers: Template engine

Feature: Template engine for documentation generation
  In order to have flexible and powerful documentation templates
  As a provider developer
  I want to use the template engine's functions and data fields

  Scenario Outline: Using template functions
    Given a template with the content "{{ <function> }}"
    And the following data:
      | Name      | Value |
      | test_string | "Hello World" |
    When the template is rendered
    Then the output should be "<expected_output>"

    Examples:
      | function                  | expected_output            |
      | 'codefile "file.txt"'     | ```\nHello from file\n```   |
      | 'lower test_string'       | "hello world"              |
      | 'plainmarkdown `**foo**`' | "foo"                      |
      | 'prefixlines "  " "foo\nbar"' | "  foo\n  bar"             |
      | 'printf "%s %s" "foo" "bar"' | "foo bar"                  |
      | 'split "foo_bar" "_"'     | "[foo bar]"                |
      | 'title test_string'       | "Hello World"              |
      | 'tffile "file.tf"'        | ```terraform\nresource "test" {}\n``` |
      | 'trimspace "  foo  "'     | "foo"                      |
      | 'upper test_string'       | "HELLO WORLD"              |

  Scenario Outline: Using data fields
    Given a template with the content "{{ .<field> }}"
    And the following data for a "<type>":
      | field                | value                     |
      | -------------------- | ------------------------- |
      | Description          | "This is a test"          |
      | HasExample           | "true"                    |
      | ExampleFile          | "examples/test/test.tf"   |
      | ProviderName         | "terraform-provider-test" |
      | ProviderShortName    | "test"                    |
      | RenderedProviderName | "Test Provider"           |
      | SchemaMarkdown       | "## Schema"               |
      | Name                 | "test_resource"           |
      | Type                 | "Resource"                |
      | HasImport            | "true"                    |
      | ImportFile           | "examples/test/import.sh" |
      | HasImportIDConfig    | "true"                    |
      | ImportIDConfigFile   | "examples/test/import-id.tf" |
      | HasImportIdentityConfig | "true"                    |
      | ImportIdentityConfigFile | "examples/test/import-identity.tf" |
      | IdentitySchemaMarkdown | "## Identity Schema"      |
      | Summary              | "This is a summary"       |
      | FunctionSignatureMarkdown | "## Signature"            |
      | FunctionArgumentsMarkdown | "## Arguments"            |
      | HasVariadic          | "true"                    |
      | FunctionVariadicArgumentMarkdown | "## Variadic Argument"  |
    When the template is rendered
    Then the output should be "<value>"

    Examples:
      | type       | field                | value                     |
      | Provider   | Description          | "This is a test"          |
      | Provider   | HasExample           | "true"                    |
      | Provider   | ExampleFile          | "examples/test/test.tf"   |
      | Provider   | ProviderName         | "terraform-provider-test" |
      | Provider   | ProviderShortName    | "test"                    |
      | Provider   | RenderedProviderName | "Test Provider"           |
      | Provider   | SchemaMarkdown       | "## Schema"               |
      | Resource   | Name                 | "test_resource"           |
      | Resource   | Type                 | "Resource"                |
      | Resource   | Description          | "This is a test"          |
      | Resource   | HasExample           | "true"                    |
      | Resource   | ExampleFile          | "examples/test/test.tf"   |
      | Resource   | HasImport            | "true"                    |
      | Resource   | ImportFile           | "examples/test/import.sh" |
      | Resource   | HasImportIDConfig    | "true"                    |
      | Resource   | ImportIDConfigFile   | "examples/test/import-id.tf" |
      | Resource   | HasImportIdentityConfig | "true"                    |
      | Resource   | ImportIdentityConfigFile | "examples/test/import-identity.tf" |
      | Resource   | IdentitySchemaMarkdown | "## Identity Schema"      |
      | Resource   | ProviderName         | "terraform-provider-test" |
      | Resource   | ProviderShortName    | "test"                    |
      | Resource   | RenderedProviderName | "Test Provider"           |
      | Resource   | SchemaMarkdown       | "## Schema"               |
      | Function   | Name                 | "test_function"           |
      | Function   | Type                 | "Function"                |
      | Function   | Description          | "This is a test"          |
      | Function   | Summary              | "This is a summary"       |
      | Function   | HasExample           | "true"                    |
      | Function   | ExampleFile          | "examples/test/test.tf"   |
      | Function   | ProviderName         | "terraform-provider-test" |
      | Function   | ProviderShortName    | "test"                    |
      | Function   | RenderedProviderName | "Test Provider"           |
      | Function   | FunctionSignatureMarkdown | "## Signature"            |
      | Function   | FunctionArgumentsMarkdown | "## Arguments"            |
      | Function   | HasVariadic          | "true"                    |
      | Function   | FunctionVariadicArgumentMarkdown | "## Variadic Argument"  |
