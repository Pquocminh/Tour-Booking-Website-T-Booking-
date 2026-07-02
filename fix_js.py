import re

# Read old file
with open('old_manage_schedules.jsp', 'r', encoding='utf-16') as f:
    content = f.read()

# Extract script block
match = re.search(r'(?s)<script>.*?</script>', content)
if not match:
    print("Script block not found!")
    exit(1)

script_block = match.group(0)

# Modify openEditModal
old_edit_logic = """            // Set min constraint on Total Slots to prevent dropping below booked slots
            var totalSlotsInput = document.getElementById('editTotalSlots');
            totalSlotsInput.value = totalSlots;
            totalSlotsInput.min = bookedSlots;"""

new_edit_logic = """            // Set min constraint on Total Slots to prevent dropping below booked slots
            var totalSlotsInput = document.getElementById('editTotalSlots');
            totalSlotsInput.value = totalSlots;
            
            var minSlots = Math.max(1, bookedSlots);
            totalSlotsInput.min = minSlots;
            
            totalSlotsInput.addEventListener('input', function() {
                if (parseInt(this.value) < minSlots) {
                    this.setCustomValidity('Total capacity cannot be less than the ' + bookedSlots + ' slots already booked!');
                } else {
                    this.setCustomValidity('');
                }
            });"""

script_block = script_block.replace(old_edit_logic, new_edit_logic)

# Append to current manage-schedules.jsp
with open('src/main/webapp/WEB-INF/views/admin/manage-schedules.jsp', 'a', encoding='utf-8') as f:
    f.write('\n' + script_block + '\n')

print("Script restored and updated!")
