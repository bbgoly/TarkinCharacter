// npm i @types/discord.js
import { Client } from "discord.js";
import { Events, BOT_TOKEN } from "./Constants";
const client = new Client();

client.once(Events.Ready, () => console.log("Bot is ready"));

client.login(BOT_TOKEN);
