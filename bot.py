import discord
from dotenv import load_dotenv
import os
import discord.ui
from discord.ext import commands

intents = discord.Intents.all()

bot = commands.Bot(command_prefix='.', intents=intents, help_command = None)

@bot.event
async def on_ready():
    print('System rebooting')
    bot.add_view(Roles())

class Roles(discord.ui.View):
    def __init__(self):
        super().__init__(timeout=None)
    #Back-end
    @discord.ui.button(label = "Back-end", custom_id = "Back-end", style = discord.ButtonStyle.secondary)
    async def button1(self, interaction, button):
        role = 992133047954702477
        user = interaction.user
        if role in [y.id for y in user.roles]:
            await user.remove_roles(user.guild.get_role(role))
            await interaction.response.send_message('Você removeu a Role!', ephemeral = True, delete_after = 5.0)
        else:
            await user.add_roles(user.guild.get_role(role))
            await interaction.response.send_message('Você adicionou a Role!', ephemeral = True, delete_after = 5.0)
    #Front-end
    @discord.ui.button(label = "Front-end", custom_id = "Front-end", style = discord.ButtonStyle.secondary)
    async def button2(self, interaction, button):
        role = 992133005000843336
        user = interaction.user
        if role in [y.id for y in user.roles]:
            await user.remove_roles(user.guild.get_role(role))
            await interaction.response.send_message('Você removeu a Role!', ephemeral = True, delete_after = 5.0)
        else:
            await user.add_roles(user.guild.get_role(role))
            await interaction.response.send_message('Você adicionou a Role!', ephemeral = True, delete_after = 5.0)
    #Data
    @discord.ui.button(label = "Data Science", custom_id = "Data Science", style = discord.ButtonStyle.secondary)
    async def button3(self, interaction, button):
        role = 992133977882230825
        user = interaction.user
        if role in [y.id for y in user.roles]:
            await user.remove_roles(user.guild.get_role(role))
            await interaction.response.send_message('Você removeu a Role!', ephemeral = True, delete_after = 5.0)
        else:
            await user.add_roles(user.guild.get_role(role))
            await interaction.response.send_message('Você adicionou a Role!', ephemeral = True, delete_after = 5.0)

@bot.command()
async def roles(ctx):
    embed = discord.Embed(title = "Selecionar Roles", description='Aperte para adicionar ou remover uma role.')
    await ctx.send(embed = embed, view = Roles())

intents = discord.Intents.default()
intents.message_content = True

load_dotenv()
TOKEN = os.getenv('TUTORIAL_BOT_TOKEN')
bot.run(TOKEN)