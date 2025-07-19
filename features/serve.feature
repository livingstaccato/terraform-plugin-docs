# Metadata:
#   File: internal/cmd/serve.go
#   Covers: serve command

Feature: Serve documentation for a Terraform provider
  NOTE: The serve command is not yet implemented.

  Scenario: Running the serve command
    Given a Terraform provider
    When I run `tfplugindocs serve`
    Then the command should fail with a "not implemented" error
