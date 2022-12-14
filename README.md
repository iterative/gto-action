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
  - id: gto
    uses: iterative/gto-action@v1
```

For a complete CI example, see
[this workflow](https://github.com/iterative/example-gto/blob/main/.github/workflows/gto-act-on-tags.yml)
in the GTO example repo.

## Inputs

The following inputs are supported.

- `show` - (optional) Whether to run `gto show`.
- `history` - (optional) Whether to run `gto history`.
- `print-outputs` - (optional) Whether to print action outputs.

Note if the Git tag that triggered the workflow conforms the GTO format,
`gto show $NAME` and `gto history $NAME` are run each time regardless of these
options (`$NAME` is the name of artifact Git tag refers to).

## Outputs

- `event` - Type of triggering event
- `name` - The name of the artifact
- `version` - The version of the artifact
- `stage` - The stage - if the events is a stage assignment
- `type` - The type of the artifact (if annotated)
- `path` - The path of the artifact (if annotated)
- `description` - The description of the artifact (if annotated)
