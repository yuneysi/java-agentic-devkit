# Migration Planning Phase

## Responsibility

Turn baseline findings into a direct, reversible Java 8 -> Java 21 migration plan.

## Inputs

- baseline readiness verdict
- dependency and plugin inventory
- known failing tests or fragile modules
- team constraints (timeline, risk appetite, release windows)

## Outputs

- direct migration plan: Java 8 -> Java 21
- migration slices with one primary risk bucket each
- gate checklist per slice (compile/test/contract/runtime/evidence)
- dependencies and rollback plan for each slice

## Mandatory steps

1. Derive work only from baseline evidence, compatibility constraints, and approved goals.
2. Partition work into coherent slices that address one primary compatibility concern, are independently reviewable, and can be reverted without unrelated changes.
3. Order slices by prerequisites and risk reduction. Establish build/toolchain compatibility before source or runtime behavior changes that depend on it.
4. Assign one primary risk area and list affected modules for each slice.
5. Define applicable gates, exact proof commands, expected results, and evidence paths per slice.
6. Define rollback triggers and steps, including data or configuration rollback when applicable.
7. Record the approved sequence and material trade-offs in `opencode/memory/decisions.md`.

## Exit criteria

- no slice mixes independent compatibility concerns without a documented reason,
- each slice has measurable gate checks,
- dependencies, rollback path, and stop conditions exist for each slice,
- migration sequence is ready for implementation phase.
