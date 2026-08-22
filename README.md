[ENG](README_eng.md)

### CPC (Cam Position Changer)
<img width="913" height="100" alt="ai_warn" src="https://github.com/user-attachments/assets/f5110056-367a-4461-9219-68d8b3b8bc38" />

#### Описание
Изменение положение камеры водителя в разные стороны через стрелки вместо пролета в Relative Camera
#### Как использовать
- Камера должна быть в режиме водителя
- `V` и режим включается
- Для корректировки позиции(а именно перенос камеры куда вам нужно) меняете кнопками shift+up/down/left/right/pageup/pagedown
#### Установка
В Releases доступен архив мода, необходимо его положить в папку с модами игры.

#### Пример работы
https://github.com/user-attachments/assets/033afe6e-5b21-4119-85f5-ad135f59593b

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
