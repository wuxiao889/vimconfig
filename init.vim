"
" .vimrc used by a naive C++ coder: github.com/archibate
"
" I manage plugins using vim-plug (already bundled in my .vim folder):
" https://github.com/junegunn/vim-plug
"
" IMPORTANT: Simply put this .vimrc and .vim to your home folder won't work
" immediately. You need to run
"
" :PlugInstall
"
" when you launch Vim for the first time.
" This will initialize all the plugins, otherwise they will not shows up.
"
" Scroll to the end of this file to see my plugin list.
" Comment or uncomment some of them as you wish.
"
"
" Key maps
" --------
"
" q     - equivalent to :wq, save and exit current window
" <C-q> - equivalent to :bd, close current opening file
" Q     - equivalent to q in old mappings, to record macros
" H     - equivalent to ^, goto start of line, 3H for goto the 3rd char
" L     - equivalent to $, goto end of line, 3L for the 3rd char from end
" kj    - equivalent to <ESC>, exit insert mode
" ,c     - find character over lines (vim-easymotion)
"
" <F1>  - save and switch to last used tab
" <F2>  - save and switch to previous tab
" <F3>  - save and switch to next tab
" <F4>  - save all opened files
"
" gcc       - comment selected code (support visual mode)
" gcu       - uncomment selected code (support visual mode)
" gc<space> - toggle comment of selected code (support visual mode)
" gci       - invert comment of selected code (support visual mode)
" gc$       - comment until EOL using line comment
" gcA       - append line comment on current line
"
" <F8>     - start shell in fullscreen (equivalent to :sh)
" <F10>    - toggle project file tree window (:NERDTreeToggle)
"
" <F5>     - build and run current CMake project
" <F6>     - build current CMake project, but don't run
" <F7>     - run current file as a single script (.c .cpp .py)
" <S-F7>   - configure current CMake project (via ccmake)
" <S-F10>  - toggle compile error window (equivalent to :QFix)
" <F12>    - search for required-from-here (useful for errors)
"
" <C-t>    - toggle built-in terminal
" <ESC>    - enter normal mode in terminal (to select text)
" i or a   - get back to insert mode in terminal
" <C-w> w  - switch out of terminal window (back to editor)
" <C-w> "" - paste from vim clipboard to terminal
"
"
" Build and Run
" =============
"
" For build and run projects, I use the plugin 'asynctasks.vim'.
"
" By default <F5> will build the CMake project, and run the target named 'main'.
" This is defined in the '~/.vim/tasks.ini', which is bundled in my '.vim':
"
" [+]
" build_type=Release
" build_target=main
" build_dir=build
" build_generator=Ninja
" run_target="$(VIM:build_dir)/$(VIM:build_target)"
" build_options=--parallel
" build_configs=
"
" [project-build]
" command=cmake -G "$(VIM:build_generator)" -B "$(VIM:build_dir)" -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON -DCMAKE_BUILD_TYPE="$(VIM:build_type)" $(VIM:build_configs) && cmake --build "$(VIM:build_dir)" --target "$(VIM:build_target)" --config "$(VIM:build_type)" $(VIM:build_options)
" output=quickfix
" cwd=$(VIM_ROOT)
"
" [project-run]
" command=$(VIM:run_target)
" output=quickfix
" cwd=$(VIM_ROOT)
"
" You can create a file named '.tasks' locally in the root of your project to
" override the default rules and variables, customized for your project, e.g.:
"
" [+]
" build_type=Debug
" build_target=zeno_pybind_module
" build_generator=Unix Makefiles
" run_target=python my_start_script.py
"
" May also use the :AsyncTaskEdit to create the '.tasks' file in project root.
" It will recognize the first directory containing '.tasks' or '.git' as root.
"
" See https://github.com/skywind3000/asynctasks.vim/blob/master/README-cn.md
"
"
" Auto completion
" ===============
"
" For auto-completion, I use the plugin 'coc.nvim', recommended by my students.
" Although 'coc.nvim' sounds like a NeoVim plugin, it works well in Vim too.
"
" IMPORTANT: Even after running :PlugInstall, auto-completion still won't work.
" You need the follow the below instructions carefully to set it up as well.
"
" To make 'coc.nvim' work at all, you need to first install Node.js:
"
" $ pacman -S nodejs          # Arch Linux
" $ apt install nodejs        # Ubuntu
" $ brew install -g node      # MacOS
" $ node --version            # check if installation succeed
"
"
" For C++ developers
" ------------------
"
" To make 'coc.nvim' work for C++, you need to install 'ccls'.
" First, run this command in Vim to enable 'ccls' in 'coc.nvim':
"
" :CocInstall coc-ccls
"
" Second, you need to install 'ccls' to your system.
" Arch Linux could install from their package manager:
"
" $ sudo pacman -S ccls
" $ ccls --version
"
" Ubuntu and MacOS could build ccls from source (tested on clang-13):
"
" $ git clone --depth=1 --recursive https://github.com/MaskRay/ccls.git
" $ cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang++
" $ cmake --build build --parallel 4
" $ sudo cmake --build build --target install
" $ ccls --version
"
" Now create a C++ file to test if auto-completion works, say:
"
" $ vim /tmp/test.cpp
"
" If it complains an error: 'extension "coc-ccls" doesn't contain main file'
" Don't worry, I meet this error too. Fix it by executing:
"
" $ cd ~/.config/coc/extensions/node_modules/coc-ccls/
" $ ln -s node_modules/ws/lib/ ./
"
" Now restart Vim and the error is gone, and another error occurs:
"
" [coc.nvim] Server languageserver.ccls failed to start: Error: invalid params
" of initialize: expected array for /workspaceFolders
"
" This means it doesn't find the 'compile_commands.json' of your project.
" This file contains information like compiler flags, include directories which
" are required by 'ccls' for providing auto-completion.
"
" If your project is CMake, simply set CMAKE_EXPORT_COMPILE_COMMANDS to ON:
"
" $ cd MyProject/
" $ cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON
" $ vim MySourceFile.cpp
"
" CMake will automatically create the file 'build/compile_commands.json'.
" 'ccls' will recognize it. Now restart Vim, and auto-completion should work.
" If you use other build systems, search Bing: 'Bazel compile_commands.json'
"
" If you are using my <F5> key mapping to build your CMake project, then the
" '-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON' is automatically added, no worry.
"
" Note that the build directory must be 'build', otherwise ccls won't find it.
"
" Also try run :CocConfig to open the ~/.vim/coc-settings.json file. This file
" is already bundled in my .vim folder, containing a C/C++ configuration.
"
"
" For Python developers
" ---------------------
"
" To make 'coc.nvim' work for Python, you need 'pyright'.
" First, run this command in Vim to enable 'pyright' in 'coc.nvim':
"
" :CocInstall coc-pyright
"
" For more details (e.g. work with Conda), see their official document:
" https://github.com/fannheyward/coc-pyright
"
" For other languages support of 'coc.nvim', see their official support list:
"
" https://github.com/neoclide/coc.nvim/wiki/Language-servers#ccobjective-c
"
"
" Key maps
" --------
"
" <c-space> - trigger completion (in insert mode)
" <tab>     - next completion (in insert mode)
" <s-tab>   - previous completion (in insert mode)
"
" gd - goto definition
" gD - goto implementation
" gy - goto type definition
" gY - goto declaration
" gr - goto references
" gR - rename current symbol under cursor
" gq - format selected code (visual mode)
" gf - goto file path under cursor (no line number)
" gF - goto file path under cursor (with line number)
" gx - open url under cursor in default browser
" K  - show documentation of symbol under cursor
"
" gaga - show code actions on current line
" gaq  - quick fix error on current line
"
" vif  - select current function scope (inner)
" vaf  - select current function scope (outer)
" vic  - select current class scope (inner)
" vac  - select current class scope (outer)
"
"
" Fuzzy find
" ==========
"
" For fuzzy find, I use the plugin 'LeaderF'. It uses the Unix command
" line tools 'rg'. So make sure you have installed it first:
"
" $ pacman -S ripgrep                  # Arch Linux
" $ apt-get install ripgrep            # Ubuntu
" $ brew install ripgrep               # MacOS
" $ rg --version                       # check if installation succeed
"
"
" Key maps
" --------
"
" ,e - fuzzy find file names in project directory
" ,k - fuzzy find string in project directory (ripgrep)
" ,b - fuzzy find file names in all opened files
" ,m - fuzzy find most-recently-used opened files
" ,: - fuzzy find runned ex-commands (:) in history
" ,/ - fuzzy find searched strings (/) in history
" ,x - fuzzy find vim ex-commands (including plugins)
" ,j - fuzzy find in vim jump history (related to Ctrl-I Ctrl-O)
" ,h - fuzzy find in vim marks (related to m<char> and '<char>)
" ,f - fuzzy find function name in opened files
" ,l - fuzzy find string in current opened file
" ,t - fuzzy find tags in current opened file
" ,q - fuzzy find string in quickfix result
" ,i - fuzzy find string under cursor in current file (may visual)
" ,a - fuzzy find string under cursor in project directory (may visual)
" ,. - recall last fuzzy find window
"
" <C-j> - select next fuzzy candidate (in fuzzy find window)
" <C-k> - select previous fuzzy candidate (in fuzzy find window)
" <C-p>  - peek the current selected candidate in popup window (fuzzy find window)
" <C-r> - toggle between normal search and regex search (fuzzy find window)
" <C-f> - toggle between full path search and name-only search (fuzzy find window)
" <C-v> - paste from system clipboard (fuzzy find window)
" <C-\> - choose the split method to open selected target (fuzzy find window)
" <CR>  - open current selected candidate (double click will work too)
" <TAB> - switch between normal mode / insert mode (in fuzzy find window)
" p     - peek the current selected candidate in popup window (fuzzy normal mode)
" v     - open current selected candidate in vertical splitted window (fuzzy normal mode)
" x     - open current selected candidate in horizontal splitted window (fuzzy normal mode)
" Q     - add current selected candidate to quickfix list (fuzzy normal mode)
" L     - add current selected candidate to location list (fuzzy normal mode)
" d     - delete current selected candidate (fuzzy normal mode)
" q     - quit fuzzy search window (fuzzy normal mode)
"
set backspace=indent,eol,start
set clipboard=unnamedplus
set showcmd
set cursorline
set incsearch
set nocompatible
set encoding=utf-8
set et ts=2 sts=2 sw=2
set ls=2  fdl=100
set nu rnu ru
set hls is si
set cinoptions=j1,(0,ws,Ws,g0
set timeout nottimeout ttimeoutlen=10
set mouse=a
set laststatus=2
set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set list
set virtualedit=all
set hidden
set nobackup
set nowritebackup
set updatetime=300
set cmdheight=1
set shortmess+=c
"set noek
"set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
"set switchbuf=usetab
set undofile
"if has('nvim')
  "set undodir=/tmp//,.
  "set backupdir=/tmp//,.
  "set directory=/tmp//,.
"else
  "set undodir=/tmp//,.
  "set backupdir=/tmp//,.
  "set directory=/tmp//,.
"endif

"nnoremap w+ :resize +10<CR>
"nnoremap w- :resize -10<CR>
"nnoremap w> :vertical resize +10<CR>
"nnoremap w< :vertical resize -10<CR>

syntax on
filetype on
filetype plugin on
filetype indent on

let g:mapleader = ','

nnoremap <silent><C-h>  <C-w>h
nnoremap <silent><C-j>  <C-w>j
nnoremap <silent><C-k>  <C-w>k
nnoremap <silent><C-l>  <C-w>l
nnoremap <silent><S-h> :bp<CR>
nnoremap <silent><S-l> :bn<CR>

"nnoremap <silent> <F1> :wa<CR>:b#<CR>
"nnoremap <silent> <F2> :wa<CR>:bp<CR>
"nnoremap <silent> <F3> :wa<CR>:bn<CR>
nnoremap <silent> <F4> :wa<CR>
inoremap <silent> <F1> <ESC>
vnoremap <silent> <F1> <ESC>
vmap <F2> <ESC><F2>
imap <F2> <ESC><F2>
tmap <F2> <ESC><F2>
vmap <F3> <ESC><F3>
imap <F3> <ESC><F3>
tmap <F3> <ESC><F3>
vmap <F4> <ESC><F4>
imap <F4> <ESC><F4>
tmap <F4> <ESC><F4>
"nnoremap <F5> :AsyncTasks project-build project-run<CR>
"vmap <F5> <ESC><F5>
"imap <F5> <ESC><F5>
"tmap <F5> <ESC><F5>
"if has('nvim')
"nnoremap <F17> :AsyncStop<CR>
"vmap <F17> <ESC><F17>
"imap <F17> <ESC><F17>
"tmap <F17> <ESC><F17>
"else
"nnoremap <S-F5> :AsyncStop<CR>
"vmap <S-F5> <ESC><S-F5>
"imap <S-F5> <ESC><S-F5>
"tmap <S-F5> <ESC><S-F5>
"endif
"nnoremap <F6> :AsyncTask project-build<CR>
"vmap <F6> <ESC><F6>
"imap <F6> <ESC><F6>
"tmap <F6> <ESC><F6>
"nnoremap <F7> :AsyncTasks file-build file-run<CR>
"vmap <F7> <ESC><F7>
"imap <F7> <ESC><F7>
"tmap <F7> <ESC><F7>
"if has('nvim')
"nnoremap <F19> :AsyncTask project-config<CR>
"vmap <F19> <ESC><F19>
"imap <F19> <ESC><F19>
"tmap <F19> <ESC><F19>
"else
"nnoremap <S-F7> :AsyncTask project-config<CR>
"vmap <S-F7> <ESC><S-F7>
"imap <S-F7> <ESC><S-F7>
"tmap <S-F7> <ESC><S-F7>
"endif
"nnoremap <silent> <F8> :wa<CR>:sh<CR><CR>
vmap <F8> <ESC><F8>
imap <F8> <ESC><F8>
tmap <F8> <ESC><F8>
nnoremap <silent> <F10> :wa<CR>:NERDTreeToggle<CR><C-w>l:Vista!!<CR><C-w>h
vmap <F10> <ESC><F10>
imap <F10> <ESC><F10>
tmap <F10> <ESC><F10>
if has('nvim')
nnoremap <silent> <F22> :wa<CR>:QFix<CR>
vmap <F22> <ESC><F22>
imap <F22> <ESC><F22>
tmap <F22> <ESC><F22>
else
nnoremap <silent> <S-F10> :wa<CR>:QFix<CR>
vmap <S-F10> <ESC><S-F10>
imap <S-F10> <ESC><S-F10>
tmap <S-F10> <ESC><S-F10>
endif
"nnoremap <silent> <F12> /required from here<CR>
nnoremap <silent> <F12> :nohlsearch<CR>
vmap <F12> <ESC><F12>
imap <F12> <ESC><F12>
tmap <F12> <ESC><F12>
"nnoremap <silent> <C-k> <C-w>k:q<CR>
"nnoremap <silent> <C-j> <C-w>j
inoremap kj <ESC>
inoremap jk <ESC>
"inoremap <DEL> <ESC>
"nnoremap <DEL> <ESC>
"vnoremap <DEL> <ESC>
"set pastetoggle=<F1>

vmap Q <ESC>
nnoremap Q <ESC>

tnoremap <ESC> <C-\><C-n>
if !has('nvim')
tnoremap <ScrollWheelUp> <C-\><C-n><ScrollWheelUp>
tnoremap <ScrollWheelDown> <C-\><C-n><ScrollWheelDown>
tnoremap <S-PageUp> <C-\><C-n><C-u>
tnoremap <S-PageDown> <C-\><C-n><C-d>
endif
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>
vnoremap <PageUp> <C-u>
vnoremap <PageDown> <C-d>

if executable("xsel")
vnoremap zy :w !xsel -ib<CR><CR>
elseif executable("pbcopy")
vnoremap zy :w !pbcopy<CR><CR>
endif

augroup insert_curline
autocmd InsertEnter,InsertLeave * set cul!
augroup end

"augroup archibate_abbrs
"autocmd!
"exec "au FileType py iabbr gc subprocess.check_call(["
"exec "au FileType py iabbr gj os.path.join("
"exec "au FileType cpp iabbr gi #include <"
"exec "au FileType cpp iabbr gv std::vector<"
"exec "au FileType cpp iabbr gs std::string"
"exec "au FileType cpp iabbr gt std::tuple<"
"exec "au FileType cpp iabbr ga std::array<"
"exec "au FileType cpp iabbr gm std::map<"
"exec "au FileType cpp iabbr gum std::unordered_map<"
"exec "au FileType cpp iabbr gf std::function<"
"exec "au FileType cpp iabbr gfv std::function<void()>"
"exec "au FileType cpp iabbr gsc static_cast<"
"exec "au FileType cpp iabbr gdc dynamic_cast<"
"exec "au FileType cpp iabbr gspc std::static_pointer_cast<"
"exec "au FileType cpp iabbr gdpc std::dynamic_pointer_cast<"
"exec "au FileType cpp iabbr gms std::make_shared<"
"exec "au FileType cpp iabbr gmu std::make_unique<"
"exec "au FileType cpp iabbr gsp std::shared_ptr<"
"exec "au FileType cpp iabbr gup std::unique_ptr<"
"exec "au FileType cpp iabbr gwp std::weak_ptr<"
"exec "au FileType cpp iabbr gnz namespace zeno {"
"exec "au FileType cpp iabbr gnv namespace zenovis {"
"augroup end

" no longer used vimspector:
"nmap <S-F3> <Plug>VimspectorStop
"nmap <S-F4> <Plug>VimspectorRestart
"nmap <S-F5> <Plug>VimspectorContinue
"nmap <S-F6> <Plug>VimspectorPause
"nmap <S-F8> <Plug>VimspectorRunToCursor
"nmap <C-S-F8> <Plug>VimspectorAddFunctionBreakpoint
"nmap <S-F9> <Plug>VimspectorToggleBreakpoint
"nmap <C-S-F9> <Plug>VimspectorToggleConditionalBreakpoint
"nmap <S-F10> <Plug>VimspectorStepOver
"nmap <S-F11> <Plug>VimspectorStepInfo
"nmap <S-F12> <Plug>VimspectorStepOut
"nmap <LEADER>= <Plug>VimspectorBalloonEval
"xmap <LEADER>= <Plug>VimspectorBalloonEval
"let g:ycm_semantic_triggers = {'VimspectorPrompt': ['.', '->', ':', '<']}
"let g:cmake_vimspector_support = 1
"let g:cmake_vimspector_default_configuration = {
"\ 'adapter': 'vscode-cpptools',
"\ 'configuration': {
"\ 'type': '',
"\ 'request': 'launch',
"\ 'cwd': '${workspaceRoot}',
"\ 'Mimode': '',
"\ 'args': [],
"\ 'program': '',
"\ "setupCommands": [
"\ {
"\ "description": "Enable pretty-printing for gdb",
"\ "text": "-enable-pretty-printing",
"\ "ignoreFailures": 'true',
"\ }
"\ ],
"\ }
"\ }

" don't extend the stupid comments:
autocmd FileType * setlocal formatoptions-=cro

" rid annoying swap prompts:
autocmd SwapExists * let v:swapchoice = "e"

" goto last location on open:
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" open NERDTree on vim start:
"autocmd VimEnter * NERDTree | wincmd p
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" no longer used cmake4vim:
"let g:cmake_usr_args = '-GNinja'
"let g:cmake_build_target = 'main'
"let g:cmake_build_type = 'Release'
"let g:cmake_compile_commands = 1
"let g:cmake_build_path_pattern = ["%s/build", "getcwd()"]

" no longer used YouCompleteMe:
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_error_symbol = '✗'
"let g:ycm_warning_symbol = '⚠'
"let g:ycm_filetype_whitelist = {"c": 1, "cpp": 1, "python": 1}
"let g:ycm_min_num_of_chars_for_completion = 2
"let g:ycm_show_diagnostics_ui = 1
"let g:ycm_key_invoke_completion = '<c-z>'
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 1
""let g:ycm_show_diagnostics_ui = 0
""let g:ycm_key_list_select_completion = ['<TAB>']
""let g:ycm_key_list_previous_completion = []

" no longer used ultisnips:
"let g:UltiSnipsExpandTrigger="<c-s>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"let g:UltiSnipsEditSplit="vertical"

" no longer used vim-cpp-modern:
"let g:cpp_attributes_highlight = 1
"let g:cpp_member_highlight = 1

" no longer used vim-airline:
"let g:airline#extensions#coc#enabled = 1
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_alt_sep = '|'
"let g:airline#extensions#tabline#buffer_nr_show = 0
"let g:airline#extensions#tabline#formatter = 'default'
"let g:airline#extensions#keymap#enabled = 1
"let g:airline#extensions#tabline#buffer_idx_mode = 1
"" 设置切换tab的快捷键 <\> + <i> 切换到第i个 tab
"nmap <silent> g1 <Plug>AirlineSelectTab1
"nmap <silent> g2 <Plug>AirlineSelectTab2
"nmap <silent> g3 <Plug>AirlineSelectTab3
"nmap <silent> g4 <Plug>AirlineSelectTab4
"nmap <silent> g5 <Plug>AirlineSelectTab5
"nmap <silent> g6 <Plug>AirlineSelectTab6
"nmap <silent> g7 <Plug>AirlineSelectTab7
"nmap <silent> g8 <Plug>AirlineSelectTab8
"nmap <silent> g9 <Plug>AirlineSelectTab9
""nmap <silent> g1 :tab1<CR>
""nmap <silent> g2 :tab2<CR>
""nmap <silent> g3 :tab3<CR>
""nmap <silent> g4 :tab4<CR>
""nmap <silent> g5 :tab5<CR>
""nmap <silent> g6 :tab6<CR>
""nmap <silent> g7 :tab7<CR>
""nmap <silent> g8 :tab8<CR>
""nmap <silent> g9 :tab9<CR>
""cabbrev o tab drop
""cabbrev e tabe
""cabbrev m tabm
""cabbrev a tab ball
""autocmd BufReadPost * tab ball

" no longer used vim-terminal-help:

"let g:terminal_key = '<c-=>'
"let g:terminal_default_mapping = 1

"inoremap ÏF <ESC>A
"inoremap ÏH <ESC>I
"nnoremap ÏH ^
"nnoremap ÏF $
"vnoremap ÏH ^
"vnoremap ÏF $

" no longer used YouCompleteMe:
"nnoremap <LEADER><LEADER> :YcmCompleter GoTo<CR>
"nnoremap <LEADER>[ :YcmCompleter GoToDefinitionElseDeclaration<CR>
"nnoremap <LEADER>d :YcmCompleter GetDoc<CR>
"nnoremap <LEADER>r :YcmCompleter RefactorRename<SPACE>
"nnoremap <LEADER>f :YcmCompleter FixIt<CR>1
"nnoremap <LEADER>y :call ToggleYcmDiagnostics()<CR><CR>:wa<CR>:e<CR>
"func! ToggleYcmDiagnostics()
"let g:ycm_show_diagnostics_ui = !g:ycm_show_diagnostics_ui
"YcmRestartServer
"endfunc

" no longer used vim-ctrlspace:
"if has('nvim')
"let g:CtrlSpaceDefaultMappingKey = "<C-space> "
"endif

"let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
"let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
"let g:CtrlSpaceSaveWorkspaceOnExit = 1
"if executable('rg')
"let g:CtrlSpaceGlobCommand = 'rg --color=never --files'
"elseif executable('ag')
"let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
"endif
"nnoremap <silent><C-p> :CtrlSpace O<CR>

" for LeaderF:
"let s:project_root = ['.root', '.svn', '.git', '.hg', '.project']
let g:Lf_HideHelp = 1
let g:Lf_PreviewInPopup = 1
let g:Lf_PreviewCode = 1
let g:Lf_WildIgnore = {
        \ 'dir': ['build','.git', '.cclscache'],
        \ 'file': ['*.o', '*.exe', '*.so'],
        \}
let g:Lf_ShowRelativePath = 0
let g:Lf_UseCache = 0
"let g:Lf_WindowPosition='popup' " 悬浮显示
"let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
"jet g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutB = ''
let g:Lf_ShortcutF = ''
noremap <Leader>r :Leaderf rg --regexMode<CR>
noremap <Leader>e :Leaderf --nameOnly file<CR>
noremap <Leader>b :Leaderf buffer<CR>
noremap <Leader>m :Leaderf mru<CR>
"noremap <Leader>m :<C-U><C-R>=printf("Leaderf mru --input %s/", expand('%:p:h'))<CR><CR>
"noremap <Leader>t :Leaderf! bufTag<CR>
noremap <Leader>l :Leaderf line<CR>
noremap <Leader>c :Leaderf command<CR>
noremap <Leader>: :Leaderf! cmdHistory<CR>
noremap <Leader>/ :Leaderf! searchHistory<CR>
noremap <Leader>w :Leaderf! window<CR>
"noremap <Leader>fh :Leaderf! marks<CR>
noremap <Leader>j :Leaderf! jumps<CR>
noremap <Leader>n :Leaderf  function<CR>
noremap <Leader>q :Leaderf quickfix<CR>
noremap <Leader>i :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s", expand("<cword>"))<CR><CR>
noremap <Leader>a :<C-U><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>
xnoremap <Leader>i :<C-U><C-R>=printf("Leaderf! rg --current-buffer -F -e %s", leaderf#Rg#visual())<CR><CR>
xnoremap <Leader>a :<C-U><C-R>=printf("Leaderf! rg -F -e %s", leaderf#Rg#visual())<CR><CR>
noremap <Leader>. :<C-U>Leaderf! --recall<CR>

" should use `Leaderf gtags --update` first
"let g:Lf_GtagsAutoGenerate = 0.
"let g:Lf_Gtagslabel = 'native-pygments'
"noremap gfr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
"noremap gfd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
"noremap gfo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
"noremap gfn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
"noremap gfp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

" for vim-easymotion:
let g:EasyMotion_do_mapping = 0

" <Leader>c{char} to move to {char}
map  s <Plug>(easymotion-bd-f)
nmap s <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
"map  <Leader>w <Plug>(easymotion-bd-w)
"nmap <Leader>w <Plug>(easymotion-overwin-w)

" BEGIN_COC_NVIM {{{
" References: https://github.com/neoclide/coc.nvim#example-vim-configuration

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
inoremap <silent><expr> <c-space> coc#pum#visible() ? coc#pum#confirm() : coc#refresh()
else
inoremap <silent><expr> <c-@> coc#pum#visible() ? coc#pum#confirm() : coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm()
                          "\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"inoremap <silent><expr> <space> coc#pum#visible() ? (<SID>check_back_space() ? "\<space>" : coc#pum#confirm()) : "\<space>"

let g:coc_global_extensions = [
            \ 'coc-marketplace',
            \ 'coc-json',
            \ 'coc-jedi'
            \]

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> gl[ <Plug>(coc-diagnostic-prev)
nmap <silent> gl] <Plug>(coc-diagnostic-next)


" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gs :vsp<Esc><Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gY <Plug>(coc-declaration)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap gR <Plug>(coc-rename)

" Formatting selected code.
xmap gq <Plug>(coc-format-selected)
"nmap gq <Plug>(coc-format-selected)
nnoremap gq :Format<CR>

" Restart CoC
"nmap <silent> gt :CocRestart<CR><CR>

" Applying codeAction to the selected region.
" Example: `gaap` for current paragraph
xmap ga  <Plug>(coc-codeaction-selected)
nmap ga  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap gac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap gaq  <Plug>(coc-fix-current)
" Run the Code Lens action on the current line.
nmap gal <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
if (index(['vim', 'help'], &filetype) >= 0)
execute 'h '.expand('<cword>')
elseif (coc#rpc#ready())
call CocActionAsync('doHover')
else
execute '!' . &keywordprg . " " . expand('<cword>')
endif
endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

augroup coc_group_ts_json
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format    :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold      :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OrgImport :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Using CocList
" Show all diagnostics
nnoremap <silent> gla  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> gle  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> glc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> glo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> gls  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> glj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> glk  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> glp  :<C-u>CocListResume<CR>
" Show git status
nnoremap <silent> glg  :<C-u>CocList --normal gstatus<CR>

" }}} END_COC_NVIM

" for coc-snippets:

let g:coc_snippet_next = '<tab>'

"" for incsearch.vim

"map /  <Plug>(incsearch-forward)
"map ?  <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)

"" below integrate with easymotion:
"function! s:config_easyfuzzymotion(...) abort
  "return extend(copy({
  "\   'converters': [incsearch#config#fuzzyword#converter()],
  "\   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  "\   'keymap': {"\<CR>": '<Over>(easymotion)'},
  "\   'is_expr': 0,
  "\   'is_stay': 1
  "\ }), get(a:, 1, {}))
"endfunction

"noremap <silent><expr> g? incsearch#go(<SID>config_easyfuzzymotion())

"set hlsearch
"let g:incsearch#auto_nohlsearch = 1
"map n  <Plug>(incsearch-nohl-n)
"map N  <Plug>(incsearch-nohl-N)
"map *  <Plug>(incsearch-nohl-*)
"map #  <Plug>(incsearch-nohl-#)
"map g* <Plug>(incsearch-nohl-g*)
"map g# <Plug>(incsearch-nohl-g#)

"function! s:noregexp(pattern) abort
  "return '\V' . escape(a:pattern, '\')
"endfunction

"function! s:incsconfig() abort
  "return {'converters': [function('s:noregexp')]}
"endfunction

"noremap <silent><expr> z/ incsearch#go(<SID>incsconfig())



" begin plugin list
call plug#begin()

"Plug 'vim-scripts/surround.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree',
Plug 'archibate/QFixToggle', {'on': 'QFix'}
Plug 'tpope/vim-fugitive'        " git extension
" "show contents of reg
Plug 'junegunn/vim-peekaboo' " reg plug
"Plug 'bfrg/vim-cpp-modern', {'for': 'cpp'}
"Plug 'vim-scripts/vim-airline'
"Plug 'cskeeters/vim-smooth-scroll'
"Plug 'junegunn/vim-slash'
"Plug 'vim-scripts/a.vim', {'for': ['c', 'cpp', 'cuda']}
"Plug 'machakann/vim-swap'
Plug 'preservim/nerdcommenter'
" <Leader>cc comment
" <Leader>cu uncomment
"Plug 'preservim/vimux'
"Plug 'peterhoeg/vim-qml', {'for': 'qml'}
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"Plug 'neoclide/coc-snippets'
"Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
"Plug 'ilyachur/cmake4vim', {'on': ['CMake', 'CMakeBuild', 'CMakeInfo', 'CMakeRun']}
"Plug 'puremourning/vimspector'
"Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlP']}
"Plug 'ycm-core/YouCompleteMe', {'do': './install.py --clang-completer', 'for': ['c', 'cpp', 'python']}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
"Plug 'skywind3000/asynctasks.vim'
"Plug 'skywind3000/asyncrun.vim'
"Plug 'skywind3000/vim-terminal-help'
"Plug 'aben20807/vim-runner'
"Plug 'christoomey/vim-tmux-runner'
"Plug 'viniciusgerevini/tmux-runner.vim'
"Plug 'vim-ctrlspace/vim-ctrlspace'
"Plug 'haya14busa/incsearch.vim'
"Plug 'haya14busa/incsearch-fuzzy.vim'
"Plug 'haya14busa/incsearch-easymotion.vim'
"Plug 'findango/vim-mdx', {'for': 'mdx'}
Plug 'Yggdroot/LeaderF' , { 'do': ':LeaderfInstallCExtension' }
"Plug 'liuchengxu/vista.vim', {'on': 'Vista!!'}
Plug 'morhetz/gruvbox'
Plug 'tweekmonster/startuptime.vim'
Plug 'tomasr/molokai' " color scheme plug
Plug 'xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
"Plug 'thaerkh/vim-workspace'
Plug 'itchyny/lightline.vim'
Plug 'sinetoami/lightline-hunks'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'mkitt/tabline.vim'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion' "fast move
"Plug 'liuchengxu/vim-which-key' " command prompt
Plug 'derekwyatt/vim-fswitch' " switch bewteen header and src file
"Plug 'wincent/terminus'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar' " outline plug
"Plug 'mhinz/vim-startify' " a start screen for vim
Plug 'lfv89/vim-interestingwords' " highlight current word
Plug 'machakann/vim-highlightedyank' "automatic highlight after yank
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ap/vim-buftabline'
"Plug 'frazrepo/vim-rainbow'
"Plug 'xolox/vim-session'
Plug 'qpkorr/vim-bufkill'
call plug#end()

fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  let str =  getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
  return str
endfun

"let g:rainbow_active = 1

" for lightline.vim:
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [
      \             [ 'mode', 'paste', ],
      \             [ 'hunks'],
      \             [ 'readonly', 'filename', 'modified', ],
      \           ],
      \   'right': [
      \             [ 'lineinfo', ],
      \             [ 'percent', ],
      \             [ 'func', 'fileformat', 'fileencoding', 'filetype', ],
      \            ],
      \ },
      \ 'tab': {
      \   'active': [ 'tabnum', 'filename', 'modified', ],
      \   'inactive': [ 'tabnum', 'filename', 'modified', ],
      \ },
      \ 'component_function': {
      \   'readonly' : 'LightlineReadonly',
      \   'hunks': 'lightline#hunks#composer',
      \   'func': 'Getfuncname',
      \ },
      \ 'enable': { 'statusline': 1, 'tabline': 1, },
      \ }

let g:lightline#hunks#exclude_filetypes = [ 'startify', 'nerdtree', 'vista_kind', 'tagbar' ]

function! LightlineReadonly()
    return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction


if !exists('g:lightline_tagbar#format')
  let lightline_tagbar#format = '%s'
endif

if !exists('g:lightline_tagbar#flags')
  let lightline_tagbar#flags = 'f'
endif


function Getfuncname() abort
  return tagbar#currenttag(
        \g:lightline_tagbar#format,
        \'',
        \g:lightline_tagbar#flags,
        \)
endfunction

" vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1

"derekwyatt/vim-fswitch
"switch between header and source file
nnoremap ,h :FSHere<CR> 
augroup mycppfiles
  au!
  au BufEnter *.h let b:fswitchdst  = 'cpp,cc,c'
  au BufEnter *.cc let b:fswitchdst  = 'h'
  au BufEnter *.c let b:fswitchdst  = 'h'
augroup END

function! LightlineGitBranch() abort
  let branch = get(g:, 'coc_git_status', '')
  return branch
endfunction

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction

" for vim-which-key:
" 开启了g gt会有问题
"nnoremap <silent> g :<C-u>WhichKey 'g'<CR>
"nnoremap <silent> ,n :<C-u>WhichKey ',n'<CR>
"nnoremap <silent> ,f :<C-u>WhichKey ',f'<CR>
"nnoremap <silent> <Leader> :<C-u>WhichKey '<Leader>'<CR>

" for tagbar
nmap <Space>t :TagbarToggle<CR>

" Plug 'scrooloose/nerdtree'
"nnoremap <Space>c :NERDTreeFocus<CR>
nnoremap <Space>e :NERDTreeToggle<CR>
nnoremap <Space>f :NERDTreeFind<CR>
nnoremap <Space>h :noh<CR>

set bg=dark
colorscheme gruvbox
"colorscheme yuejiu
hi LineNrAbove guifg=#cc6666 ctermfg=red
hi LineNrBelow guifg=#66cc66 ctermfg=green
hi Normal ctermbg=none
hi SignColumn ctermbg=none
hi FloatermNC guifg=gray
"set termguicolors

"if filereadable(".vim_localrc")
        "source .vim_localrc
"endif

augroup nerdtree_group
    au!
    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    " Close the tab if NERDTree is the only window remaining in it.
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
command VimConfig :edit ~/.vim/init.vim

" my custom theme settings, you may change it:
"if has('gui_running')
    "set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
    "set guifont="Source Code Pro Medium 20"
"endif


" for vim-gitgutter
set updatetime=100

" for vim-airline
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = ']'
"let g:airline#extensions#tabline#formatter = 'unique_tail'

vmap X y/<C-R>"<CR>

" learn vimscript the hard way
inoremap <c-u> <Esc>viwUea
nnoremap <c-u> viwU

:nnoremap <leader>ev :vsplit ~/.vim/init.vim<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>
