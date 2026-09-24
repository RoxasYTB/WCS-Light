#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo =
{
    name = "WCS-Light: Undead Scourge",
    author = "WCS-Light contributors",
    description = "Undead Scourge level 8 for human players",
    version = "1.1.0",
    url = ""
};

ConVar g_CvarMaxHealth;
ConVar g_CvarVampiricChance;
ConVar g_CvarVampiricMinHeal;
ConVar g_CvarVampiricMaxHeal;
ConVar g_CvarUnholySpeed;
ConVar g_CvarLevitationGravity;
ConVar g_CvarSuicideChance;
ConVar g_CvarSuicideRadius;
ConVar g_CvarSuicideMagnitude;

int g_MaxHealth;
int g_VampiricChance;
int g_VampiricMinHeal;
int g_VampiricMaxHeal;
float g_UnholySpeed;
float g_LevitationGravity;
int g_SuicideChance;
float g_SuicideRadius;
float g_SuicideMagnitude;

public void OnPluginStart()
{
    g_CvarMaxHealth = CreateConVar("wcs_light_max_health", "200", "WCS-Light maximum health threshold for Vampiric Aura.", FCVAR_NONE, true, 1.0, true, 500.0);
    g_CvarVampiricChance = CreateConVar("wcs_light_vampiric_chance", "15", "Vampiric Aura chance (WCS roll: random 0-100 <= this value).", FCVAR_NONE, true, 0.0, true, 100.0);
    g_CvarVampiricMinHeal = CreateConVar("wcs_light_vampiric_min_heal", "4", "Minimum health leeched on a successful Vampiric Aura roll.", FCVAR_NONE, true, 0.0, true, 500.0);
    g_CvarVampiricMaxHeal = CreateConVar("wcs_light_vampiric_max_heal", "21", "Maximum health leeched on a successful Vampiric Aura roll.", FCVAR_NONE, true, 0.0, true, 500.0);
    g_CvarUnholySpeed = CreateConVar("wcs_light_unholy_speed", "1.45", "Movement speed multiplier from Unholy Aura.", FCVAR_NONE, true, 0.1, true, 5.0);
    g_CvarLevitationGravity = CreateConVar("wcs_light_levitation_gravity", "0.35", "Player gravity multiplier from Levitation.", FCVAR_NONE, true, 0.05, true, 2.0);
    g_CvarSuicideChance = CreateConVar("wcs_light_suicide_chance", "65", "Suicide Bomber chance (WCS roll: random 0-100 <= this value).", FCVAR_NONE, true, 0.0, true, 100.0);
    g_CvarSuicideRadius = CreateConVar("wcs_light_suicide_radius", "180.0", "Suicide Bomber blast radius in Source units.", FCVAR_NONE, true, 1.0, true, 2000.0);
    g_CvarSuicideMagnitude = CreateConVar("wcs_light_suicide_magnitude", "130.0", "Suicide Bomber WCS damage magnitude.", FCVAR_NONE, true, 0.0, true, 10000.0);
    HookConVarChange(g_CvarMaxHealth, OnSettingsChanged);
    HookConVarChange(g_CvarVampiricChance, OnSettingsChanged);
    HookConVarChange(g_CvarVampiricMinHeal, OnSettingsChanged);
    HookConVarChange(g_CvarVampiricMaxHeal, OnSettingsChanged);
    HookConVarChange(g_CvarUnholySpeed, OnSettingsChanged);
    HookConVarChange(g_CvarLevitationGravity, OnSettingsChanged);
    HookConVarChange(g_CvarSuicideChance, OnSettingsChanged);
    HookConVarChange(g_CvarSuicideRadius, OnSettingsChanged);
    HookConVarChange(g_CvarSuicideMagnitude, OnSettingsChanged);
    AutoExecConfig(true, "wcs_light");
    UpdateSettings();

    HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
    HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
    HookEvent("round_start", Event_RoundStart);
    HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Post);
    RegConsoleCmd("sm_undead", Command_UndeadInfo, "Show WCS-Light Undead skills");
}

public void OnClientPutInServer(int client)
{
    if (!IsFakeClient(client))
    {
        PrintToChat(client, "\x04[WCS-Light]\x01 Undead Scourge niveau 8 actif.");
    }
}

public Action Command_UndeadInfo(int client, int args)
{
    if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
    {
        PrintToChat(client, "\x04[WCS-Light]\x01 Vampiric Aura, Unholy Aura, Levitation et Suicide Bomber niveau 8.");
        PrintToChat(client, "\x04[WCS-Light]\x01 Bombe : %d%% environ, rayon %.0f, magnitude %.0f.", g_SuicideChance, g_SuicideRadius, g_SuicideMagnitude);
    }
    return Plugin_Handled;
}

public void OnSettingsChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    UpdateSettings();
    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsHumanPlayer(client) && IsPlayerAlive(client))
        {
            ApplyUndead(client);
        }
    }
}

void UpdateSettings()
{
    g_MaxHealth = g_CvarMaxHealth.IntValue;
    g_VampiricChance = g_CvarVampiricChance.IntValue;
    g_VampiricMinHeal = g_CvarVampiricMinHeal.IntValue;
    g_VampiricMaxHeal = g_CvarVampiricMaxHeal.IntValue;
    if (g_VampiricMaxHeal < g_VampiricMinHeal)
    {
        g_VampiricMaxHeal = g_VampiricMinHeal;
    }
    g_UnholySpeed = g_CvarUnholySpeed.FloatValue;
    g_LevitationGravity = g_CvarLevitationGravity.FloatValue;
    g_SuicideChance = g_CvarSuicideChance.IntValue;
    g_SuicideRadius = g_CvarSuicideRadius.FloatValue;
    g_SuicideMagnitude = g_CvarSuicideMagnitude.FloatValue;
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
    for (int client = 1; client <= MaxClients; client++)
    {
        if (IsHumanPlayer(client) && IsPlayerAlive(client))
        {
            ApplyUndead(client);
        }
    }
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if (IsHumanPlayer(client))
    {
        CreateTimer(0.1, Timer_ApplyUndead, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
    }
}

public Action Timer_ApplyUndead(Handle timer, any userid)
{
    int client = GetClientOfUserId(userid);
    if (IsHumanPlayer(client) && IsPlayerAlive(client))
    {
        ApplyUndead(client);
    }
    return Plugin_Stop;
}

void ApplyUndead(int client)
{
    SetEntityGravity(client, g_LevitationGravity);
    SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", g_UnholySpeed);
}

public void Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("userid"));
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    char weapon[32];
    event.GetString("weapon", weapon, sizeof(weapon));

    // Match WCS player_hurt handling: skip self/world/mod damage and lethal hits.
    if (!IsHumanPlayer(attacker) || victim <= 0 || !IsClientInGame(victim) || attacker == victim || !IsPlayerAlive(attacker))
    {
        return;
    }
    if (event.GetInt("health") <= 0 || GetClientTeam(attacker) == GetClientTeam(victim)
        || StrEqual(weapon, "worldspawn", false) || StrEqual(weapon, "point_hurt", false)
        || StrContains(weapon, "wcs_", false) == 0)
    {
        return;
    }

    // WCS uses randint(0, 100) <= the configured chance.
    if (GetRandomInt(0, 100) <= g_VampiricChance)
    {
        int health = GetClientHealth(attacker);
        if (health < g_MaxHealth)
        {
            int value = GetRandomInt(g_VampiricMinHeal, g_VampiricMaxHeal);
            value = (health + value <= g_MaxHealth) ? value : health + value - g_MaxHealth;
            SetEntityHealth(attacker, health + value);
            SetHudTextParams(-1.0, 0.20, 2.0, 255, 255, 255, 255);
            ShowHudText(attacker, -1, "Leeched %d health!", value);
        }
    }
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    // WCS uses randint(0, 100) <= chance (101 possible values).
    if (!IsHumanPlayer(client) || GetRandomInt(0, 100) > g_SuicideChance)
    {
        return;
    }

    float origin[3];
    GetClientAbsOrigin(client, origin);
    int deadTeam = GetClientTeam(client);

    for (int target = 1; target <= MaxClients; target++)
    {
        if (!IsClientInGame(target) || !IsPlayerAlive(target) || GetClientTeam(target) == deadTeam)
        {
            continue;
        }

        float targetOrigin[3];
        GetClientAbsOrigin(target, targetOrigin);
        float distance = GetVectorDistance(origin, targetOrigin);
        if (distance <= g_SuicideRadius)
        {
            // WCS level 8: damage = magnitude * radius / distance.
            float damage = g_SuicideMagnitude * g_SuicideRadius / (distance < 1.0 ? 1.0 : distance);
            // WCS uses ENERGYBEAM and the custom weapon as inflictor/weapon.
            SDKHooks_TakeDamage(target, client, client, damage, DMG_ENERGYBEAM, -1);
        }
    }
}

bool IsHumanPlayer(int client)
{
    return client > 0 && client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client);
}
