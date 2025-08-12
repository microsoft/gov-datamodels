# Release 1.0.2.0 (Jun-06, 2025)

- **Action Item**
   - Added Action Item - New activity table to refactor (combine) the needs of Action Assignment, Project Work Item, and all other "tasking" use cases where a unit of work is assigned to a team or individual to complete. Purposely separate from Tasks to avoid conflicts with other existing implementations and to allow users to have personal productivity items (Tasks), vs. organization-assigned and tracked items (Action Items).
   - Added Action Item field to Collaboration Space table.
   - Added Action Item field to Document table.
   - Add Action Item field to Discussion Item table.
- **Interactive Prompt Choice**
   - Added Interactive Prompt Choice - New table to store choice options for interactive prompts.
- **Primary Action Item**
   - Added Primary Action Item field - This field is for tying all descendent Action Items back to the primary action item at the root of a process instance. This is needed so that just-in-time action item creation can occur at any level in the process tree without having the action item hierarchy built out at the level of interaction.
