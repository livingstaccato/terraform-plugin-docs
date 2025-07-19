# Metadata:
#   File: internal/schemamd/render.go
#   Covers: Schema to Markdown rendering

Feature: Render Terraform provider schema to Markdown
  In order to have accurate and readable documentation for my provider's schema
  As a provider developer
  I want to render the schema to Markdown

  Scenario: Rendering a simple schema
    Given a Terraform provider schema with the following attributes:
      | Name      | Type   | Required | Optional | Computed | Description      |
      |-----------|--------|----------|----------|----------|------------------|
      | name      | String | true     | false    | false    | The name of the resource. |
      | location  | String | false    | true     | false    | The location of the resource. |
      | arn       | String | false    | false    | true     | The ARN of the resource. |
    When the schema is rendered to Markdown
    Then the output should be:
      """
      ## Schema

      ### Required

      - `name` (String) The name of the resource.

      ### Optional

      - `location` (String) The location of the resource.

      ### Read-Only

      - `arn` (String) The ARN of the resource.
      """

  Scenario: Rendering a schema with nested attributes
    Given a Terraform provider schema with a nested attribute "network" with the following attributes:
      | Name      | Type   | Required | Optional | Computed | Description      |
      |-----------|--------|----------|----------|----------|------------------|
      | cidr_block | String | true     | false    | false    | The CIDR block for the network. |
      | name      | String | false    | true     | false    | The name of the network. |
    When the schema is rendered to Markdown
    Then the output should contain:
      """
      ### Nested Schema for `network`

      #### Required:

      - `cidr_block` (String) The CIDR block for the network.

      #### Optional:

      - `name` (String) The name of the network.
      """

  Scenario: Rendering a schema with a nested block
    Given a Terraform provider schema with a nested block "ingress" with the following attributes:
      | Name        | Type   | Required | Optional | Computed | Description        |
      |-------------|--------|----------|----------|----------|--------------------|
      | from_port   | Number | true     | false    | false    | The start of the port range. |
      | to_port     | Number | true     | false    | false    | The end of the port range. |
      | protocol    | String | true     | false    | false    | The protocol.      |
      | cidr_blocks | List   | false    | true     | false    | The CIDR blocks.   |
    When the schema is rendered to Markdown
    Then the output should contain:
      """
      ### Nested Schema for `ingress`

      #### Required:

      - `from_port` (Number) The start of the port range.
      - `to_port` (Number) The end of the port range.
      - `protocol` (String) The protocol.

      #### Optional:

      - `cidr_blocks` (List of String) The CIDR blocks.
      """
