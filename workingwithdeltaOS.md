Working with DeltaOS
==
 
DeltaOS comes packed with developer apis,
read this if you want to take advantage
of these APIS!
 
Installer - pastebin run 9FiUs9pZ
 
[] = Required
{} = Optional

GRAPHICS API
==

**Note: This API is also used throughout DeltaOS.**
 
graphics.reset({bgColor}, {textColor})
Pretty simple. Resets the screen, with the background color/text if specified.
bgColor can be nil if you want to only change the text color.
 
graphics.drawLine([y], [color])
Draws a line across that Y coordinate with the color specified.
 
graphics.drawImage([x], [y], [imagePath])
I don't need to explain this.

SHA256 API
==

**Note: This API is also used throughout DeltaOS.**

sha256.hash([text])
Hashes string TEXT with SHA256. Returns the hashed string.
 
sha256.sHash([text], [salt])
Hashes string TEXT with SHA256 and the hash SALT

USERS API
==

**Note: This API is also used throughout DeltaOS.**

users.getUserName()
Gets the logged in user.
 
users.getPassword([user])
Returns the password of user.
Always returns a hashed password.
 
users.isUser([user])
I don't need to explain this.
 
users.isRoot([user])
Still don't need to explain this.

Icons API
== 
icons.addIcon([progPath], [iconPath], [name], {x}, {y})
Adds an icon to the desktop.
 
icons.removeIcon([iconName])
This explains itself.

Settings API
== 
settings.getSetting([settingName], {settingNumber})
Returns the setting. Will return a table if there is no settingNumber,
will return string/number if there is settingNumber
 
settings.addSetting([settingName], [settingNumber], [newValue])
Creates/Changes a setting.
