import discord
from dotenv import load_dotenv
import os
import discord.ui
from discord.ext import commands
import json

intents = discord.Intents.all()
bot = commands.Bot(command_prefix='.', intents=intents, help_command = None)

# Setup Roles Array Information for developer roles buttons
dictDataRoles = json.load(open('button.roles.json'))
arrRolesDev = dictDataRoles['devRoles']

@bot.event
async def on_ready():
    print('System Ready')

async def handleBtnRoleClick(interaction, role):
    user = interaction.user
    if role in [y.id for y in user.roles]:
        await user.remove_roles(user.guild.get_role(role))
        await interaction.response.send_message('Você removeu a Role!', ephemeral = True, delete_after = 5.0)
    else:
        await user.add_roles(user.guild.get_role(role))
        await interaction.response.send_message('Você adicionou a Role!', ephemeral = True, delete_after = 5.0)

class RoleBtn(discord.ui.Button):
    def __init__(self, label='0', **kwargs):
        super().__init__(label=label, **kwargs)

    async def callback(self, interaction: discord.Interaction):
        for role in arrRolesDev:
                if role['id_custom'] == self.custom_id:
                    await handleBtnRoleClick(interaction, role['id_role'])
                    
@bot.command()
async def roles(ctx):
    embed = discord.Embed(title = "Selecionar Roles", description='Reaja com a sua role correspondente:')
    view = discord.ui.View(timeout=None)
    
    # Create a button for each role
    for role in arrRolesDev:
        if "emoji" in role:
            view.add_item(RoleBtn(emoji=role['emoji'], label=role['label'], custom_id=role['id_custom'], style=discord.ButtonStyle.secondary))
        else:
            view.add_item(RoleBtn(label=role['label'], custom_id=role['id_custom'], style=discord.ButtonStyle.secondary))

    await ctx.send(embed = embed, view = view)

intents = discord.Intents.default()
intents.message_content = True

load_dotenv()
TOKEN = os.getenv('TUTORIAL_BOT_TOKEN')
bot.run(TOKEN)
