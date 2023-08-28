## Blips Management System Documentation

### Overview
The Blips Management System is a resource designed to manage blips on the map within the RedM game environment. It provides a user-friendly way to add, display, and remove blips based on various conditions.

### Files Included
1. `client.lua`: Client-side script for managing blips and their display.
2. `config.lua`: Configuration file for defining color codes used in blips.
3. `data.sql`: SQL file for creating a database table to store blip data.
4. `fxmanifest.lua`: Manifest file providing resource metadata for RedM.
5. `server.lua`: Server-side logic for fetching and managing blip data.

### Features and Functionalities
1. **Client-Side (client.lua)**
   - **addBlipToMap**: Adds blips to the map based on blip data.
   - **removeBlipByName**: Removes blips from the map based on their names.
   - **stringsplit**: Utility function to split strings based on a separator.
   - **Main Loop**: Periodically fetches and displays blips on the map.

2. **Configuration (config.lua)**
   - Defines color codes used for blip modifiers.

3. **Database (data.sql)**
   - Defines the structure of the `blips` table to store blip data.

4. **Manifest (fxmanifest.lua)**
   - Provides metadata information about the resource, including version, author, and description.

5. **Server-Side Logic (server.lua)**
   - **getBlips**: Callback to fetch blip data from the database and send it to clients.
   - Database interaction to fetch blip data from the `blips` table.
   - Data transformation and sending blip data to clients.
   - Function to remove blips by name.

### How the System Works
1. Clients trigger the `getBlips` callback to request blip data from the server.
2. The server retrieves blip data from the `blips` table in the database.
3. The server transforms the blip data and sends it to the client for display.
4. Clients periodically update the displayed blips based on the fetched data.
5. Clients can add, display, and remove blips on the map using the provided functions.

### Usage Instructions
1. Ensure that the resource is properly installed and started on the server.
2. Clients will automatically receive blip data and display blips on the map.
3. Use the `addBlipToMap` function to add custom blips to the map.
4. Use the `removeBlipByName` function to remove blips from the map.

### Conclusion
The Blips Management System provides a convenient way to manage and display blips on the map in the RedM game environment. It includes client-side and server-side logic, configuration settings, and a database structure to support the blip management features.

Feel free to customize this documentation outline and content to suit your needs. If you have any specific formatting preferences or additional information to include, please let me know!