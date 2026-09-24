# WCS-Light — Undead Scourge for Counter-Strike: Source


<details>
<summary>English</summary>

A lightweight SourceMod addon for **existing** Counter-Strike: Source servers. Every human player gets the four level-8 Undead Scourge skills; bots do not.

## Requirements

- An already installed Counter-Strike: Source dedicated server.
- MetaMod:Source and SourceMod 1.11 or newer, already installed and loading correctly.
- No database or additional extension: the plugin uses SourceMod's built-in SDKTools and SDKHooks.

## Install on an existing server

1. Download the latest ready-to-install ZIP from [GitHub Releases](https://github.com/RoxasYTB/WCS-Light/releases).
2. Extract it into the server's **game directory** and merge the folders. For a standard CSS server this is `cstrike/`; use the equivalent game directory if your installation is customized.
3. Confirm these files are in place:
   - `addons/sourcemod/plugins/wcs_light.smx`
   - `cfg/sourcemod/wcs_light.cfg`
4. Load the plugin from the server console or RCON: `sm plugins load wcs_light`. If it is already loaded, use `sm plugins reload wcs_light`.
5. Check `sm plugins list`. In game, `!undead` displays the skill summary.

This adds the plugin and its configuration to your existing SourceMod installation. It does not install or replace the game server, MetaMod:Source, or SourceMod.

## Configuration

Edit `<game directory>/cfg/sourcemod/wcs_light.cfg`. The file includes comments for every setting. Reload the plugin after editing with `sm plugins reload wcs_light`, or restart the server. You can also change a setting at runtime with `sm_cvar <name> <value>`.

| ConVar | Default | Effect |
| --- | ---: | --- |
| `wcs_light_vampiric_chance` | `15` | WCS leech roll: succeeds when a random integer from 0–100 is at most this value |
| `wcs_light_vampiric_min_heal` / `wcs_light_vampiric_max_heal` | `4` / `21` | Random health gained on a successful roll |
| `wcs_light_max_health` | `200` | Health threshold used by Vampiric Aura; WCS's original overflow behavior is retained |
| `wcs_light_unholy_speed` | `1.45` | Movement speed multiplier |
| `wcs_light_levitation_gravity` | `0.35` | Gravity multiplier |
| `wcs_light_suicide_chance` | `65` | WCS bomber roll: succeeds when a random integer from 0–100 is at most this value |
| `wcs_light_suicide_radius` | `180.0` | Blast radius in Source units |
| `wcs_light_suicide_magnitude` | `130.0` | Magnitude used in the WCS damage formula |

## Skills

- **Vampiric Aura:** On non-lethal damage to an opponent, the WCS chance roll can restore the configured amount of health. Surviving headshots count. The original HUD text is `Leeched N health!`.
- **Unholy Aura:** Uses the configured movement speed multiplier.
- **Levitation:** Uses the configured gravity multiplier.
- **Suicide Bomber:** On a human player's death, the WCS chance roll can trigger a blast. Opponents in range take `magnitude × radius / distance` damage. Walls do not block the blast, matching WCS.

No XP, saved progression, alternate races, or database are used. Defaults match level 8 Undead Scourge values.

## Source and license

The repository contains the SourcePawn source and the commented configuration. Releases include the compiled plugin for direct installation. WCS-Light is inspired by the Undead Scourge race in [Warcraft: Source](https://github.com/ThaPwned/WCS) and its published values in [WCS-Contents](https://github.com/ThaPwned/WCS-Contents). Licensed under GPL-3.0-or-later; see [`LICENSE`](LICENSE).

</details>

<details>
<summary>Français</summary>

Un addon SourceMod léger à greffer sur un serveur Counter-Strike: Source **déjà existant**. Tous les joueurs humains reçoivent les quatre compétences Undead Scourge niveau 8 ; les bots n’en bénéficient pas.

## Prérequis

- Un serveur dédié Counter-Strike: Source déjà installé.
- MetaMod:Source et SourceMod 1.11 ou plus récent, déjà installés et fonctionnels.
- Aucune base de données ni extension supplémentaire : le plugin utilise SDKTools et SDKHooks, inclus avec SourceMod.

## Installation sur un serveur existant

1. Télécharge le ZIP prêt à installer depuis les [releases GitHub](https://github.com/RoxasYTB/WCS-Light/releases).
2. Décompresse-le dans le **répertoire du jeu** de ton serveur et fusionne les dossiers. Pour une installation CSS standard, il s’agit de `cstrike/` ; utilise le répertoire de jeu équivalent si ton installation est personnalisée.
3. Vérifie la présence de ces fichiers :
   - `addons/sourcemod/plugins/wcs_light.smx`
   - `cfg/sourcemod/wcs_light.cfg`
4. Charge le plugin depuis la console serveur ou RCON : `sm plugins load wcs_light`. S’il est déjà chargé, utilise `sm plugins reload wcs_light`.
5. Vérifie avec `sm plugins list`. En jeu, `!undead` affiche un résumé des compétences.

Cette installation ajoute le plugin et sa configuration à SourceMod déjà présent. Elle n’installe ni ne remplace le serveur de jeu, MetaMod:Source ou SourceMod.

## Configuration

Modifie `<répertoire du jeu>/cfg/sourcemod/wcs_light.cfg`. Le fichier contient des commentaires pour chaque réglage. Après une modification, recharge le plugin avec `sm plugins reload wcs_light` ou redémarre le serveur. Tu peux aussi changer une valeur à chaud avec `sm_cvar <nom> <valeur>`.

| ConVar | Par défaut | Effet |
| --- | ---: | --- |
| `wcs_light_vampiric_chance` | `15` | Tirage WCS du leech : réussite si l’entier tiré entre 0 et 100 est inférieur ou égal à cette valeur |
| `wcs_light_vampiric_min_heal` / `wcs_light_vampiric_max_heal` | `4` / `21` | PV récupérés au hasard en cas de réussite |
| `wcs_light_max_health` | `200` | Seuil de santé du Vampiric Aura ; le débordement original de WCS est conservé |
| `wcs_light_unholy_speed` | `1.45` | Multiplicateur de vitesse |
| `wcs_light_levitation_gravity` | `0.35` | Multiplicateur de gravité |
| `wcs_light_suicide_chance` | `65` | Tirage WCS du bomber : réussite si l’entier tiré entre 0 et 100 est inférieur ou égal à cette valeur |
| `wcs_light_suicide_radius` | `180.0` | Rayon de l’explosion en unités Source |
| `wcs_light_suicide_magnitude` | `130.0` | Magnitude utilisée par la formule de dégâts WCS |

## Compétences

- **Vampiric Aura :** lorsqu’un adversaire subit des dégâts non létaux, le tirage WCS peut rendre la quantité de PV configurée. Les headshots comptent si la victime survit. Le HUD affiche le message d’origine : `Leeched N health!`.
- **Unholy Aura :** applique le multiplicateur de vitesse configuré.
- **Levitation :** applique le multiplicateur de gravité configuré.
- **Suicide Bomber :** à la mort d’un joueur humain, le tirage WCS peut déclencher une explosion. Les adversaires dans le rayon reçoivent `magnitude × rayon / distance` dégâts. Les murs ne bloquent pas l’explosion, comme dans WCS.

Le plugin ne gère ni XP, ni progression sauvegardée, ni autres races, ni base de données. Les valeurs par défaut correspondent au niveau 8 d’Undead Scourge.

## Code source et licence

Le dépôt contient le code SourcePawn et la configuration commentée. Les releases fournissent le plugin compilé, prêt à installer. WCS-Light s’inspire de la race Undead Scourge de [Warcraft: Source](https://github.com/ThaPwned/WCS) et de ses valeurs publiées dans [WCS-Contents](https://github.com/ThaPwned/WCS-Contents). Licence GPL-3.0-or-later ; voir [`LICENSE`](LICENSE).

</details>
