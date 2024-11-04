# No Login User Management Shell Script

A Bash script to manage Linux user accounts with the `/sbin/nologin` shell, which restricts users from logging into the system directly. The script provides functionalities for adding, listing, and deleting users who have `/sbin/nologin` set as their shell.

## Features

- **Add User**: Adds a new user with the `/sbin/nologin` shell and prompts for password creation.
- **List Users**: Lists all users with the `/sbin/nologin` shell, displaying their username, UID, GID, and home directory.
- **Delete User**: Deletes a specified user with the `/sbin/nologin` shell, with the option to also remove their home directory.

## Prerequisites

- The script must be run with **root privileges**.
- The user account should have Bash installed as the default shell.

## Usage

1. Clone or download the script.
2. Grant execute permissions:
   ```bash
   chmod +x user_management.sh
   ```
3. Run the script as root:
   ```bash
   sudo ./user_management.sh
   ```

## Script Functions

### `log_info()`
Logs informational messages in green.

### `log_error()`
Logs error messages in red.

### `log_warn()`
Logs warning messages in yellow.

### `check_root()`
Ensures the script is being run with root privileges.

### `check_user_exists(username)`
Checks if a user exists.

### `validate_username(username)`
Validates the username format to ensure it:
   - Starts with a letter.
   - Contains only letters, numbers, hyphens, or underscores.
   - Is between 3 and 32 characters long.

### `add_user()`
Prompts for a new username, validates it, and creates a new user with the `/sbin/nologin` shell. Sets up a password for the user.

### `list_nologin_users()`
Lists all users with the `/sbin/nologin` shell along with details (username, UID, GID, home directory).

### `delete_user()`
Prompts for a username to delete, validates it, and checks that the user has the `/sbin/nologin` shell. Optionally deletes the user's home directory.

### `main()`
Controls the script's flow, presenting a menu to the user.

## Options

After running the script, choose an option:

1. **Add user with `/sbin/nologin` shell**: Create a new user with restricted login.
2. **List users with `/sbin/nologin` shell**: Display all users with restricted login.
3. **Delete user with `/sbin/nologin` shell**: Delete a specified user with an option to remove the home directory.
4. **Exit**: Exit the script.

---

## Example Output

### Adding a User
```bash
$ sudo ./user_management.sh
[INFO] User Management System
1. Add user with /sbin/nologin shell
2. List users with /sbin/nologin shell
3. Delete user with /sbin/nologin shell
0. Exit

Select an option (0-3): 1
Enter username to add: testuser
[INFO] User testuser has been created.
Enter new UNIX password:
Retype new UNIX password:
[INFO] Password has been set successfully.
```

### Listing Users
```bash
Select an option (0-3): 2
[INFO] Users with '/sbin/nologin' shell:
------------------------
User: testuser             UID: 1002    GID: 1002    Home: /home/testuser
------------------------
```

### Deleting a User
```bash
Select an option (0-3): 3
Enter username to delete: testuser
Delete home directory as well? (y/n): y
[INFO] User testuser has been deleted along with their home directory.
```

## Notes

- This script is intended for managing non-login accounts, commonly used for system services or restricted access users.
- Use caution when deleting users and their home directories, as this action cannot be undone.

## License

This project is licensed under the Mozilla Public License 2.0 License.