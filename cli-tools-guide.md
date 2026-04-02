# CLI Tools Guide (Windows PowerShell)

## Установка всего одной командой

```powershell
# Шрифт и промпт
winget install DEVCOM.JetBrainsMonoNerdFont
winget install JanDeDobbeleer.OhMyPosh

# Навигация и файлы
winget install ajeetdsouza.zoxide        # умный cd
winget install eza-community.eza         # красивый ls
winget install junegunn.fzf              # fuzzy поиск
winget install sharkdp.bat               # cat с подсветкой
winget install sharkdp.fd                # быстрый find
winget install BurntSushi.ripgrep.MSVC   # быстрый grep

# Мониторинг
winget install aristocratos.btop4win     # системный монитор
winget install bootandy.dust             # размер директорий
winget install XAMPPRocky.tokei          # статистика кода

# Git
winget install JesseDuffield.lazygit     # git TUI
winget install dandavison.delta          # красивые diff

# Приложения
winget install sxyazi.yazi               # файловый менеджер
winget install charmbracelet.glow        # Markdown рендер
winget install Neovim.Neovim             # текстовый редактор
```

После установки перезапустить терминал.

---

## Справочник инструментов

### eza — красивый ls с иконками

Замена стандартного `ls`. Показывает файлы с цветами, иконками, git-статусом.

```powershell
eza                              # список файлов (как ls)
eza --icons                      # с иконками файлов
eza --long --icons               # подробный список (как ls -la)
eza --long --git                 # + git-статус каждого файла (M/N/-)
eza --tree --level=2             # дерево на 2 уровня
eza --tree --level=3 --icons     # дерево на 3 уровня с иконками
eza -la --sort=modified          # сортировка по дате изменения
eza -la --sort=size              # сортировка по размеру
```

Алиасы в профиле:
- `ls` → `eza --icons`
- `ll` → `eza --icons --long --git`
- `lt` → `eza --icons --tree --level=2`

---

### zoxide — умный cd, запоминает частые папки

Учится по мере использования. Чем чаще заходишь в папку — тем выше её приоритет.

```powershell
z billing          # перейдёт в C:\efs\billing_reports (если ходил туда раньше)
z scripts          # перейдёт в последнюю папку со "scripts" в пути
z efs              # перейдёт в C:\efs
zi                 # интерактивный выбор из всех запомненных папок (через fzf)
z -                # вернуться в предыдущую папку
```

Первый раз нужно пройтись по папкам обычным `cd` или `Set-Location`,
чтобы zoxide их запомнил. Потом можно использовать `z`.

---

### fzf — fuzzy поиск по чему угодно

Интерактивный фильтр. Принимает список строк, позволяет искать по подстроке.

```powershell
# Поиск файлов
fd --type f | fzf                       # найти файл по имени
fd --type f -e sql | fzf                # только .sql файлы

# Поиск по истории команд
Get-Content (Get-PSReadLineOption).HistorySavePath | fzf   # поиск по истории

# Открыть файл в блокноте через поиск
notepad (fd --type f | fzf)

# Просмотреть файл с подсветкой через поиск
bat (fd --type f | fzf)

# Git: выбрать ветку
git branch | fzf                        # выбрать ветку

# Комбинация: найти файл и посмотреть содержимое
fd --type f | fzf --preview "bat --color=always {}"
```

---

### bat — cat с подсветкой синтаксиса

Замена стандартного `cat`/`type`. Подсветка кода, номера строк, git-изменения.

```powershell
bat run.py                       # просмотр файла с подсветкой
bat run.py -l python             # принудительно задать язык
bat run.py --range 10:20         # показать только строки 10-20
bat *.sql                        # несколько файлов подряд
bat -d run.py                    # только diff (git changes)
bat --style=plain run.py         # без рамок и номеров строк
bat -A run.py                    # показать невидимые символы (табы, переносы)
```

Алиас в профиле: `cat` → `bat`

---

### fd — быстрый поиск файлов

Замена `find`. Быстрее, удобнее, игнорирует .git и .gitignore по умолчанию.

```powershell
fd                               # все файлы рекурсивно
fd .sql                          # файлы содержащие ".sql" в имени
fd .sql scripts/                 # только в папке scripts/
fd --type f                      # только файлы (не папки)
fd --type d                      # только папки
fd --type f -e py                # только .py файлы
fd --type f -e py -e sql         # .py и .sql файлы
fd --hidden                      # включая скрытые файлы
fd -s "Run"                      # чувствительный к регистру поиск
fd "test" --exec bat {}          # найти и показать каждый файл через bat
fd -e log --changed-within 1h    # логи, изменённые за последний час
```

---

### rg (ripgrep) — быстрый поиск по содержимому файлов

Замена `grep`. Очень быстрый, автоматически игнорирует .git.

```powershell
rg "collect"                     # найти "collect" во всех файлах
rg "collect" --type py           # только в .py файлах
rg "TODO"                        # все TODO в проекте
rg "def \w+" --type py           # regex: все определения функций
rg "password" -i                 # без учёта регистра
rg "from_dt" -l                  # только имена файлов (без содержимого)
rg "error" logs/                 # поиск в конкретной папке
rg "billing" -C 3                # 3 строки контекста вокруг совпадения
rg "SELECT" -g "*.sql"           # только в .sql файлах (через glob)
rg "collect" --count             # количество совпадений на файл
```

---

### lazygit — графический интерфейс для Git в терминале

Полноценный TUI для git: коммиты, ветки, stash, merge, rebase — всё мышкой/клавишами.

```powershell
lazygit                          # открыть в текущей папке (или алиас: lg)
```

Горячие клавиши внутри lazygit:
- `1-5` — переключение между панелями (Status, Files, Branches, Commits, Stash)
- `Space` — stage/unstage файла
- `c` — commit
- `p` — push
- `P` — pull
- `Enter` — посмотреть diff / войти в деталь
- `?` — справка по клавишам
- `q` — выход

---

### delta — красивые git diff

Автоматически работает с git после настройки. Не вызывается напрямую — git сам его использует.

```powershell
git diff                         # красивый diff с подсветкой и номерами строк
git log -p                       # логи с красивыми diff-ами
git show HEAD                    # последний коммит с красивым diff
git diff --stat                  # только статистика изменений
```

Настройка (уже выполнена):
```powershell
git config --global core.pager delta
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global delta.line-numbers true
```

---

### btop — системный монитор

Красивый TUI-монитор: CPU, RAM, диск, сеть, процессы.

```powershell
btop                             # запустить монитор
```

Горячие клавиши:
- `1` — подробный CPU
- `2` — подробная память
- `3` — сеть
- `Esc` / `q` — выход
- `f` — фильтр процессов
- `k` — kill процесса

---

### dust — визуализация занятого места на диске

Замена `du`. Показывает дерево папок с размерами и прогресс-барами.

```powershell
dust                             # текущая папка
dust C:\efs                      # конкретная папка
dust -n 20                       # топ-20 самых больших
dust -d 2                        # глубина 2 уровня
dust -r                          # в обратном порядке (мелкие сверху)
```

---

### tokei — статистика строк кода

Показывает сколько строк кода, комментариев, пустых строк по языкам.

```powershell
tokei                            # статистика текущего проекта
tokei C:\efs\billing_reports     # конкретная папка
tokei --files                    # с разбивкой по файлам
tokei --sort code                # сортировка по количеству кода
```

---

### yazi — терминальный файловый менеджер

Быстрый файловый менеджер с превью файлов, изображений, подсветкой синтаксиса.

```powershell
yazi                             # открыть в текущей папке
yazi C:\efs                      # открыть конкретную папку
```

Горячие клавиши внутри yazi:
- `j` / `k` — вверх/вниз
- `l` / `Enter` — войти в папку / открыть файл
- `h` / `Backspace` — назад (родительская папка)
- `Space` — выделить файл
- `d` — удалить
- `r` — переименовать
- `y` — копировать, `x` — вырезать, `p` — вставить
- `/` — поиск по имени
- `z` — переход через zoxide (умный cd)
- `~` — домашняя папка
- `.` — показать скрытые файлы
- `q` — выход
- `Tab` — переключение панелей

---

### glow — красивый рендер Markdown в терминале

Читает .md файлы с форматированием, цветами, таблицами.

```powershell
glow README.md                   # показать конкретный файл
glow .                           # выбрать из файлов в папке (интерактивно)
glow -p README.md                # pager-режим (со скроллом)
glow -w 80 README.md             # ширина вывода 80 символов
```

---

### Neovim — продвинутый текстовый редактор

Замена vim/vi. С плагинами — полноценная IDE в терминале.

```powershell
nvim run.py                      # открыть файл (или алиасы: vim, vi)
nvim .                           # открыть текущую папку
nvim +42 run.py                  # открыть файл на строке 42
```

Горячие клавиши (настроены):
- `Space` — leader key (префикс для команд)
- `Space + e` — файловое дерево (слева)
- `Space + ff` — поиск файлов (fuzzy)
- `Space + fg` — поиск по содержимому (grep)
- `Space + fb` — переключение между открытыми файлами
- `Space + w` — сохранить
- `Space + q` — выйти
- `Ctrl+h/j/k/l` — навигация между окнами
- `Esc` — очистить поиск

При первом запуске Neovim автоматически скачает плагины (Catppuccin тема, файловое дерево, fuzzy finder, подсветка синтаксиса, git markers, Markdown рендер).

---

## Настройка профиля PowerShell

Файл: `C:\Users\<USER>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

Открыть для редактирования:
```powershell
notepad $PROFILE
```

### Что добавить в профиль

```powershell
# ========== MODERN CLI ALIASES ==========

# eza вместо ls
function List-Pretty { eza --icons --group-directories-first @args }
function List-Long { eza --icons --long --group-directories-first --git @args }
function List-Tree { eza --icons --tree --level=2 --group-directories-first @args }
Set-Alias -Name ls -Value List-Pretty -Option AllScope -Force
Set-Alias -Name ll -Value List-Long
Set-Alias -Name lt -Value List-Tree

# bat вместо cat
function Read-Pretty { bat --style=auto @args }
Set-Alias -Name cat -Value Read-Pretty -Option AllScope -Force

# lazygit & neovim
Set-Alias -Name lg -Value lazygit
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim

# ========== ZOXIDE ==========
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# ========== FZF (Catppuccin Mocha colors) ==========
$env:FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# ========== OH MY POSH ==========
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json" | Invoke-Expression
```

### Настройка delta для git

```powershell
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global delta.line-numbers true
git config --global merge.conflictstyle diff3
```

---

## Настройка Windows Terminal

Файл: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

В `profiles.defaults`:
```json
"defaults": {
    "colorScheme": "Catppuccin Mocha",
    "font": { "face": "JetBrainsMono Nerd Font", "size": 11 },
    "opacity": 95,
    "padding": "8",
    "cursorShape": "bar"
}
```

Цветовая схема — добавить в `schemes`:
```json
{
    "name": "Catppuccin Mocha",
    "cursorColor": "#F5E0DC",
    "selectionBackground": "#585B70",
    "background": "#1E1E2E",
    "foreground": "#CDD6F4",
    "black": "#45475A",
    "red": "#F38BA8",
    "green": "#A6E3A1",
    "yellow": "#F9E2AF",
    "blue": "#89B4FA",
    "purple": "#F5C2E7",
    "cyan": "#94E2D5",
    "white": "#BAC2DE",
    "brightBlack": "#585B70",
    "brightRed": "#F38BA8",
    "brightGreen": "#A6E3A1",
    "brightYellow": "#F9E2AF",
    "brightBlue": "#89B4FA",
    "brightPurple": "#F5C2E7",
    "brightCyan": "#94E2D5",
    "brightWhite": "#A6ADC8"
}
```

## Горячие клавиши Windows Terminal

| Комбинация | Действие |
|-----------|----------|
| `Alt+Shift+D` | Разделить панель (авто) |
| `Alt+Shift+-` | Горизонтальный сплит |
| `Alt+Shift++` | Вертикальный сплит |
| `Alt+стрелки` | Переключение между панелями |
| `Ctrl+Shift+W` | Закрыть панель |
| `Ctrl+Shift+T` | Новая вкладка |
| `Ctrl+Tab` | Следующая вкладка |
