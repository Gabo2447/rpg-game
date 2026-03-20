# Reestructuración del Proyecto RPG Game

## Cambios Realizados

He reestructurado el proyecto para organizar mejor los archivos y evitar el desorden. Aquí están los cambios principales:

### Estructura Anterior vs Nueva

**Antes:**

```
src/
├── assets/
│   ├── Decorations/
│   ├── Resources/
│   ├── Tileset/
│   └── animated_tiles/
├── core/
├── features/
│   └── knights/
│       └── Troops/
│           └── Warrior/
│               ├── player.gd
│               ├── player.tscn
│               └── enemie.tscn
├── resources/
│   ├── Gold Mine/
│   ├── Resources/
│   ├── Sheep/
│   ├── Tileset/
│   │   └── Props.tres
│   └── Trees/
├── terrain/
├── ui/
└── world/
	├── decoration/
	├── interactables/
	├── maps/
	│   └── tile_map.tscn
	└── npcs/
```

**Después:**

```
src/
├── assets/
│   ├── Decorations/          # Incluye decoraciones del mundo
│   ├── Resources/            # Recursos recolectables
│   ├── Tileset/              # Tilesets gráficos
│   ├── sprites/              # Sprites de personajes y objetos
│   │   ├── characters/
│   │   ├── Gold Mine/
│   │   ├── Resources/
│   │   ├── Sheep/
│   │   └── Trees/
│   ├── terrain/              # Assets de terreno
│   ├── tilesets/             # Recursos de tilesets (.tres)
│   │   └── Props.tres
│   └── ui/                   # UI assets
├── core/                     # Autoloads, clases base, sistemas
├── scenes/                   # Todas las escenas .tscn
│   ├── characters/
│   │   ├── enemie.tscn
│   │   └── player.tscn
│   └── world/
│       └── tile_map.tscn
└── scripts/                  # Todos los scripts .gd
	└── characters/
		└── player.gd
```

### Archivos Movidos

1. **Scripts:**
   - `src/features/knights/Troops/Warrior/player.gd` → `src/scripts/characters/player.gd`

2. **Escenas:**
   - `src/features/knights/Troops/Warrior/player.tscn` → `src/scenes/characters/player.tscn`
   - `src/features/knights/Troops/Warrior/enemie.tscn` → `src/scenes/characters/enemie.tscn`
   - `src/world/maps/tile_map.tscn` → `src/scenes/world/tile_map.tscn`

3. **Assets:**
   - Contenido de `src/resources/` movido a `src/assets/sprites/`
   - `src/resources/Tileset/Props.tres` → `src/assets/tilesets/Props.tres`
   - `src/terrain/` → `src/assets/terrain/`
   - Decoraciones del mundo movidas a `src/assets/Decorations/`
   - Assets de caballeros y globins de `download_assets/Tiny Swords/Tiny Swords (Update 010)/Factions/Knights/` → `src/assets/sprites/characters/Knights/`
   - Assets de globins de `download_assets/Tiny Swords/Tiny Swords (Update 010)/Factions/Goblins/` → `src/assets/sprites/characters/Goblins/`
   - Assets adicionales de `download_assets/Tiny Swords/Tiny Swords (Update 010)/` consolidados en `src/assets/` (Deco/, Effects/, Resources/, UI/)

4. **Directorios Eliminados:**
   - `src/features/` (ya que solo contenía los archivos movidos)
   - `src/resources/` (consolidado en assets)
   - `src/world/` (escenas movidas, assets consolidados)

### Rutas Actualizadas

Se actualizaron las referencias en los archivos .tscn para reflejar las nuevas rutas:

- Rutas de scripts en escenas de personajes
- Referencia a la escena del jugador en `tile_map.tscn`
- Referencia al tileset `Props.tres` en `tile_map.tscn`
- Escena principal en `project.godot`

### ¿Se Rompió Algo?

Las escenas deberían seguir funcionando correctamente ya que todas las referencias se actualizaron. Si encuentras algún error al ejecutar el juego, verifica:

1. Que las rutas en los archivos .tscn sean correctas
2. Que el script esté correctamente referenciado
3. Que los assets sean accesibles desde sus nuevas ubicaciones

Si algo no funciona, puedes revertir moviendo los archivos de vuelta a sus ubicaciones originales y restaurando las rutas en los .tscn.

### Beneficios de la Nueva Estructura

- **Separación clara:** Assets, scripts y escenas en carpetas dedicadas
- **Consolidación:** Todos los assets gráficos en `assets/`
- **Organización lógica:** Scripts y escenas agrupados por tipo
- **Escalabilidad:** Fácil agregar nuevos personajes, mapas, etc.

¡Espero que esta reestructuración haga el proyecto más manejable!
