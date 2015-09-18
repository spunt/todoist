# todoist

Add Todoist tasks from MATLAB command line. Supports adding labels, due dates, and multiple notes. 

---

This is inspired by the Alfred Workflow [Todoistify](https://github.com/JamesMowery/todoistify) by James Mowery. I wrote it because I work a lot in MATLAB and this would allow me to batch add tasks; moreover, you can't add Notes using Todoistify. 

For this to work, you need to locate your Todoist API key, which you can find under the "Account" tab of the "Todoist Settings" in the [web app](https://todoist.com). Near the top of the function code (below the documentation), you'll find a section API TOKEN where the variable "token" is defined. Replace the value with your own token and you should be good to go. This has only been tested on a Mac OS X running El Capitan.

---

## USAGE: todoist(content, duedate, notes)

### ARGUMENTS

CONTENT
- task description (can include labels, e.g. 'Purchase laptop @finances @work')

DUEDATE (optional, default = 'today')
- Human:      today, tomorrow, friday, next friday, tom at 16:30, fri at 2pm
- Normal:     May 29, 5/29, 10/29/15, 10-29-15, 10.29.15
- Relative:   +5 (5 days from now)

NOTES (optional, default is to add no notes)
- notes to add to the added task. if CHAR, it will be added as a single note. if CELL array of strings, each cell will be added as a separate note.
