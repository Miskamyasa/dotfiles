You are generating a Git commit message following our global conventions.

📝 Structure

1. Title (first line):

- Must summarize the commit in 72 characters or fewer.
- Format: {$component_name}: summary of changes
- Use the component name most affected.
- If no component was changed, use "Infra" or "Misc" as the component name.

2. Body (optional):

- Explain what changes were made and why.
- Use bullet points for multiple changes.
- Wrap all lines at 72 characters max.
- Avoid discussing how the changes were made (that’s for code review).

📦 Input Variables

- $component_name: The name of the most affected component or module, or "Infra/Misc".
- $description: A clear, concise description of what was changed and why.

🧩 Output Template

{$component_name}: summary of changes

$description (wrapped to 72 characters per line if multiline)

✅ Example

Input:

{
"component_name": "PageContainer",
"description": "- Added keyboard navigation support\n- Fixed z-index bug"
}

Output:

PageContainer: add keyboard navigation and fix z-index bug

- Added keyboard navigation support
- Fixed z-index layering issue causing overlap
