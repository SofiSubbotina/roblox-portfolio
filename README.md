# roblox-portfolio
Roblox Luau scripts: data saving system and moving platforms mechanics.
# Roblox Portfolio

A collection of Luau scripts developed for Roblox games.

## Scripts

### DataSave_Game.lua
Server-side data saving system using DataStoreService.
Handles player data on join, update, leave, and server shutdown.
Includes protection against frequent saves.

### MovingPlatforms.lua
Dynamic platform system with sine-wave animation.
Platforms react to player contact — delay, fall, and smoothly return to start position.
Uses Lerp for smooth movement and Heartbeat for per-frame updates.
