# Todo

## Client:

## Server:

### Modules

-   CharacterData.lua

    -   Save should work
    -   Load should work
    -   Caches data
    -   Checks if required from server

-   Whitelist.lua
    -   Checks if user can use Berserker class
    -   Checks if user is a nitro booster
    -   Creates a proxy table to prevent infinite recursion on indexed table
    -   Indexes the proxy table to check if player's user exists within any of the keys
        ? Removed the subset keys that were set to boolean values for performance & ease of access

### Core Scripts

-   CharacterCustomization.server.lua
    -   Fetches player data on player added
    -   Creates new player data if no data has been found
    -   Sets all humanoid physics states to save performance
    -   Fires the "charSelectEvent" on the client while passing the data created/found and whether the player is whitelisted to the client

### Shared

-   Fill in settings as you program
