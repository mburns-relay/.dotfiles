## Code Philosophy
- Never add comments that explain _WHAT_ some code is doing. Often those kind of comments are better as an extract-method refactor in a long method. If something is particularly unusual or surprising you can always add comments to explain _WHY_ you chose to do something. But in general at least try to find a simple way forth first. Think of comments as a last resort, a signpost to future devs of how to avoid X or some other warning or apology if you couldn't think of a better approach. They're never a way to dumb down code, as often the comment will drift from the original or just distract someone perfectly capable of reading the following line.
- Regularly commit at sane points. Ideally once something works or a major component is completed. Have the commit message follow time pope's guidelines - https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
- TDD - will save time in the long run
- Make sure tests are fast, and if they're slow they better be really valuable
- Avoid workarounds. If you want a workaround - check with me first, I may agree. E.g. finding a cool simpler interesting way to do things is great. Commenting out failing tests is bad. Workaround should be more like the former, less like the latter.
- When writing markdown tables, keep the columns aligned for human readability.

## Tmux Integration
- When starting a conversation in tmux, quietly run `workon "short task description"` to name the tmux window with a kebab-case version of the task (2-4 words).
- When finishing a task, after a pr is merged, run `finish-task` to reset the worktree to main, delete the feature branch, and rename the window to `<ready>`.
