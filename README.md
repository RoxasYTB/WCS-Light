# WCS-Light — Undead Scourge

Version 1.1.0

Petit plugin SourceMod pour Counter-Strike: Source. Tous les joueurs humains ont la race Undead Scourge, avec ses quatre compétences au niveau 8. Les bots n’ont aucune compétence.

Téléchargement prêt à installer : [releases GitHub](https://github.com/RoxasYTB/WCS-Light/releases). Le dépôt contient les sources SourcePawn et les réglages ; la release fournit aussi le plugin compilé.

## Dépendances

- Un serveur Counter-Strike: Source.
- MetaMod:Source et SourceMod 1.11 ou plus récents déjà installés.

Aucune base de données, extension tierce ou autre race. Le plugin utilise SDKTools et SDKHooks inclus avec SourceMod. Un seul fichier de configuration permet d’ajuster ses valeurs.

## Installation

1. Décompresse l’archive dans le dossier du jeu (`cstrike/`).
2. Vérifie que `addons/sourcemod/plugins/wcs_light.smx` et `cfg/sourcemod/wcs_light.cfg` sont dans les dossiers correspondants de `cstrike/`.
3. Redémarre le serveur ou exécute `sm plugins load wcs_light` dans la console serveur.
4. Vérifie le chargement avec `sm plugins list`. En jeu, `!undead` affiche les compétences.

## Configuration

Édite `cstrike/cfg/sourcemod/wcs_light.cfg`. Les commentaires du fichier décrivent chaque réglage et ses unités. Après une modification, exécute `sm plugins reload wcs_light` depuis la console serveur (ou redémarre le serveur). Les variables peuvent aussi être réglées à chaud avec `sm_cvar <nom> <valeur>`.

| Variable | Valeur par défaut | Rôle |
| --- | ---: | --- |
| `wcs_light_vampiric_chance` | `15` | Chance WCS de leech (tirage entier `0–100 <= valeur`) |
| `wcs_light_vampiric_min_heal` / `wcs_light_vampiric_max_heal` | `4` / `21` | PV de leech tirés au hasard |
| `wcs_light_max_health` | `200` | Seuil de santé du Vampiric Aura, avec le débordement WCS conservé |
| `wcs_light_unholy_speed` | `1.45` | Multiplicateur de vitesse |
| `wcs_light_levitation_gravity` | `0.35` | Multiplicateur de gravité |
| `wcs_light_suicide_chance` | `65` | Chance WCS de déclenchement du bomber (`0–100 <= valeur`) |
| `wcs_light_suicide_radius` | `180.0` | Rayon de l’explosion en unités Source |
| `wcs_light_suicide_magnitude` | `130.0` | Magnitude du calcul de dégâts WCS |

## Compétences niveau 8

- **Vampiric Aura** : sur un coup non létal porté à un ennemi, le tirage WCS donne une chance de récupérer les PV configurés (seuil de santé par défaut : 200). Cela comprend les headshots qui laissent la cible en vie. Le HUD affiche le texte original WCS : `Leeched N health!`.
- **Unholy Aura** : vitesse réglée à `wcs_light_unholy_speed` (1,45 par défaut).
- **Levitation** : gravité réglée à `wcs_light_levitation_gravity` (0,35 par défaut).
- **Suicide Bomber** : à la mort, le tirage WCS peut déclencher la bombe. Les ennemis dans le rayon configuré reçoivent `magnitude × rayon / distance` dégâts. Le type de dégâts reprend celui de WCS (`ENERGYBEAM`) et les murs ne bloquent pas l’explosion.

Le plugin ne sauvegarde ni XP ni progression. Les valeurs par défaut correspondent au niveau 8 d’Undead Scourge.

## Licence et origine

WCS-Light est inspiré de la race Undead Scourge de [Warcraft: Source](https://github.com/ThaPwned/WCS) et de ses réglages publiés dans [WCS-Contents](https://github.com/ThaPwned/WCS-Contents). Distribué sous GPL-3.0-or-later ; voir `LICENSE`.
