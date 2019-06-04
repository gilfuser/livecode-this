# Cheatsheet

## Some of my own customized stuff and some other stuff I tend to forget

## (Neo)Vim Stuff (mostly from init.vim)

### NerdTree

#### open NerdTree > leader + n
#### open buffer in a new tab staying in NerdTree > T

### Navigation

#### Between tabs > Alt + h or l

#### smoothly scroll up
Ctrl e

#### smoothly scroll down
Ctrl y

#### move lines up and down > leader + Alt + [ j k ]

#### find and substitute a little bit faster
 <leader>7 

#### linewise:
<leader>8

#### Select word faster
<leader>w

####... and change
<leader>q

#### to select in between "" [] {} () <>
<leader> 
"" <A-2>
[] <A-8>
{} <A-7>
() <A-9>
<> <A-y>

#### select whole line from last to first non-empty char
<leader>l

#### Create line without leaving mode
down:
<localleader>o
up:
<localleader>O

#### go back to last edit
<A-#>
<A-'>

#### turn search highlight off
<leader><A-n>

#### go to mark and (sometimes not working) put it the middle of screen
'a...z

#### turn search highlight off
<leader><A-n>

### NERD Commenter
<Leader>cc

### Easy Motion

#### search forward and backwards
<Leader>s

#### all the oder search modes follow the normal jumping mappings

### vim-tidal

#### <localleader>s'.i.' :TidalPlay '.i.'

