# GTO Action

[GTO](https://github.com/iterative/gto) is open-source tool that helps you turn
your Git repository into an Artifact Registry. Main features:

- Registry: Track new artifacts and their versions for releases and significant
  changes.
- Lifecycle Management: Create actionable stages for versions marking status of
  artifact or it's readiness to be consumed by a specific environment.
- GitOps: Signal CI/CD automation or other downstream systems to act upon these
  new versions and lifecycle updates.
- Enrichments: Annotate and query artifact metadata with additional information.

The [iterative/gto-action](https://github.com/iterative/gto-action) action is a
Docker-based action that runs [GTO](https://github.com/iterative/gto) against
the Git tag that triggered CI and finds out what this tag does, whether it's a
version registration, stage assignment or something else. This allows you to act
accordingly upon this event.

## Usage

This action can be run on `ubuntu-latest` only for now (please let us know if
you need `macos-latest` or `windows-latest`).

Basic usage:

```yaml
steps:
    - uses: actions/checkout@v3
    - name: gto
      id: gto
      uses: iterative/gto-action@main
      with:
        show: true
        history: true
```

## Inputs

The following inputs are supported.

- `show` - (optional) Whether to run `gto show`.
- `history` - (optional) Whether to run `gto history`.

## Outputs

```yaml
outputs:
  event:
    description: "Type of triggering event"
  name:
    description: "The name of the artifact"
  version:
    description: "The version of the artifact"
  stage:
    description: "The stage - if the events is a stage assignment"
  type:
    description: "The type of the artifact (if annotated)"
  path:
    description: "The path of the artifact (if annotated)"
  description:
    description: "The description of the artifact (if annotated)"
```
