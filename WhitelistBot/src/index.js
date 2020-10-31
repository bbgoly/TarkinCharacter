const Discord = require("discord.js");
const Client = new Discord.Client();
require("dotenv").config();

Client.once("ready", () => console.log("Bot is ready"));

Client.login(process.env.BOT_TOKEN);
