const fs = require('fs');
const path = require('path');

const filePath = process.argv[2];
const taskId = process.argv[3];
const newStatus = process.argv[4];

if (!filePath || !taskId || !newStatus) {
  console.error('Usage: node update_task.cjs <file_path> <task_id> <new_status>');
  process.exit(1);
}

try {
  let content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('
');
  let found = false;

  const updatedLines = lines.map(line => {
    // Basic regex to find the task row by ID (assuming format: | TaskID | Description | Status | ...)
    const parts = line.split('|').map(p => p.trim());
    if (parts.length >= 4 && parts[1] === taskId) {
      parts[3] = newStatus;
      found = true;
      return '| ' + parts.slice(1, -1).join(' | ') + ' |';
    }
    return line;
  });

  if (!found) {
    console.error(`Error: Task ID "${taskId}" not found in ${filePath}`);
    process.exit(1);
  }

  fs.writeFileSync(filePath, updatedLines.join('
'));
  console.log(`Success: Task "${taskId}" status updated to "${newStatus}"`);
} catch (error) {
  console.error('Error updating task:', error.message);
  process.exit(1);
}
