### CPC (Cam Position Changer)

#### Описание
Изменение положение камеры водителя в разные стороны, оставляя прикрепленной при этом машину к камере.
#### Как использовать
- Камера должна быть в режиме водителя
- `V` и режим включается
- Для корректировки позиции(а именно перенос камеры куда вам нужно) меняете кнопками shift+up/down/left/right/pageup/pagedown
#### Установка
В Releases доступен архив мода, необходимо его положить в папку с модами игры.

#### Пример работы
video_add_soon

#### Документация
Скоро
#### Структура
```
.
| - README.md
| - modmeta.json
| - lua/ge/extensions
|    | - core/
|    |    | - cameraModes
|    |    |    \ - cpc.lua
|    |    \ - input/actions
|    |         \ - cpc.json
|    \ - cpc
|         | - main.lua
|         \ - state.lua
| - scripts/
|    \ - modScipt.lua
\ - settings/inputmaps
     \ - keyboard_mod.diff
```