call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'
call plug#end()

" don't autoindent
filetype indent off

set nocompatible

set encoding=utf-8

syntax enable

" set tab characters to appear as 2 spaces
set tabstop=2

" don't expand a tab press to spaces
set noexpandtab

" Rust forces some tab settings, we will override them
let g:rust_recommended_style = 0
