" Header Comments {{{
" For information on most of these settings see
" http://nvie.com/posts/how-i-boosted-my-vim/
" To start vim without using this .vimrc file, use:
"     vim -u NORC
"
" To start vim without loading any .vimrc or plugins, use:
"     vim -u NONE
" }}}

" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

" Pathogen automatically manages bundles in ~/.vim/bundles
filetype off                    " disable filetype while loading pathogen
call pathogen#infect()

" Stab: set tabstop, softtabstop and shiftwidth to the same value {{{
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
    finally
      echohl None
  endtry
endfunction
" }}}

" Preserve: run a command while preserving the cursor location {{{
function! Preserve(command)
    " save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business...
    execute a:command
    " restore previous search history and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }}}

" Editing behaviour {{{
filetype plugin indent on       " set filetype stuff to on again

set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is four spaces
set softtabstop=4
set expandtab                   " use spaces instead of tabs by default
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set shiftwidth=4                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                   " set show matching parenthesis
set foldenable                  " enable folding
set foldcolumn=2                " add a fold column
set foldmethod=marker           " detect triple-{ style fold markers
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type
set nolist                      " don't show invisible characters by default
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·,eol:¬
set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented
" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
" }}}

" Editor layout {{{
set termencoding=utf-8
set encoding=utf-8
set lazyredraw                  " don't update the display while executing macros
set laststatus=2                " tell VIM to always put a status line in, even
                                "    if there is only one window
set cmdheight=2                 " use a status bar that is 2 rows high

                                " set an informative status line
set statusline=%t%h%w\ %=[%{&ff}]\ %y\ [%l,%v]\ [%p%%/%L]

set lines=30
set columns=80

if has("gui_running")
  set guioptions=egmrt
endif
" }}}

" Vim behaviour {{{
set notitle                     " turn off the annoying xterm title behaviour
set hidden                      " hide buffers instead of closing them this
                                "    means that the current buffer can be put
                                "    to background without being written; and
                                "    that marks and undo history are preserved
set switchbuf=useopen           " reveal already opened files from the
                                " quickfix window instead of opening new
                                " buffers
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set nobackup                    " do not keep backup files, it's 70's style cluttering
set noswapfile                  " do not write annoying intermediate swap files,
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
                                " store swap files in one of these directories
set viminfo='20,\"80            " read/write a .viminfo file, don't store more
                                "    than 80 lines of registers
set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete
                                "    first full match
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd                     " show (partial) command in the last line of the screen
                                "    this also shows visual selection info
set modeline                    " allow files to include a 'mode line', to
                                "    override vim defaults
set modelines=5                 " check the first 5 lines for a modeline
" }}}

" Highlighting {{{
syntax enable
set background=dark
let g:solarized_termtrans=1
colorscheme solarized
" }}}

" Shortcut mappings {{{
" Use Q for formatting the current paragraph (or visual selection)
vmap Q gq
nmap Q gqap

" make p in Visual mode replace the selected text with the yank register
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

nmap mk :make<CR>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" Change the mapleader from \ to ,
let mapleader=","

" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Edit files relative to the working directory
cnoremap %% <C-R>=expand('%:h').'/'<CR>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Complete whole filenames/lines with a quicker shortcut key in insert mode
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

" Quick yanking to the end of the line
nmap Y y$

" Yank/paste to the OS clipboard with ,y and ,p
nmap <leader>y "+y
nmap <leader>Y "+yy
nmap <leader>p "+p
nmap <leader>P "+P
nmap <leader>r :registers<CR>

" Edit the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Clears the search register
nmap <silent> <leader>/ :nohlsearch<CR>

" Quick alignment of text
nmap <leader>al :left<CR>
nmap <leader>ar :right<CR>
nmap <leader>ac :center<CR>

" Toggle settings
nmap <leader>l :set list!<CR>
nmap <leader>w :set wrap!<CR>
nmap <leader>n :set number!<CR>

" Strip trailing whitespace
nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

" Autoformat the whole buffer
nmap <leader>= :call Preserve("normal gg=G")<CR>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null
" }}}

" Conflict markers {{{
" highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" shortcut to jump to next conflict marker
nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
" }}}

" Filetype specific handling {{{
" only do this part when compiled with support for autocommands
if has("autocmd")

    augroup vim_files
        au!
        autocmd filetype vim set expandtab    " disallow tabs in Vim files
    augroup end

   " use closetag plugin to auto-close HTML tags
   " autocmd filetype html,xml,xsl source ~/.vim/scripts/html_autoclosetag.vim

   " bind <F1> to show the keyword under cursor
   " general help can still be entered manually, with :h
   autocmd filetype vim noremap <F1> <Esc>:help <C-r><C-w><CR>
   autocmd filetype vim noremap! <F1> <Esc>:help <C-r><C-w><CR>

endif
" }}}

" Skeleton processing {{{
if has("autocmd")

    if !exists('*LoadTemplate')
    function LoadTemplate(file)
        " Add skeleton fillings for Python (normal and unittest) files
        if a:file =~ 'test_.*\.py$'
            execute "0r ~/.vim/skeleton/test_template.py"
        elseif a:file =~ '.*\.py$'
            execute "0r ~/.vim/skeleton/template.py"
        endif
    endfunction
    endif

    autocmd BufNewFile * call LoadTemplate(@%)

endif
" }}}

" Auto save/restore {{{
au BufWritePost *.* silent mkview!
au BufReadPost *.* silent loadview

" Quick write session with F2
map <F2> :mksession! .vim_session<CR>
" And load session with F3
map <F3> :source .vim_session<CR>
" }}}

" VimClojure specific configuration {{{
let vimclojure#HighlightBuiltins = 1   " Highligh Clojure special forms
let vimclojure#ParenRainbow = 1        " Use rainbow parentheses
" }}}

" Extra vi-compatibility {{{
" set extra vi-compatible options
set cpoptions+=$     " when changing a line, don't redisplay, but put a '$' at
                     " the end during the change
set formatoptions-=o " don't start new lines w/ comment leader on pressing 'o'
au filetype vim set formatoptions-=o
                     " somehow, during vim filetype detection, this gets set,
                     " so explicitly unset it again for vim files
" }}}

