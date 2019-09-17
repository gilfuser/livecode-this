# Cheatsheet

## Some of my own customized stuff and some other stuff I tend to forget

- [Navigation](#navigation)
- [Select and Change](#select-and-change)
- [NERD Commenter](#nerd-commenter)
- [Easy Motion](#easy-motion)
- [Vim-Tidal](#vim-tidal)

---

## (Neo)Vim Stuff

> Some come from plugins and others are from mappings. You will find it in the init.vim file

### Navigation

#### Between tabs

Alt + h or l

#### smoothly scroll up

Ctrl e

#### smoothly scroll down

Ctrl y

#### move lines up and down

\<leader> + Alt + [ j k ]

[Back To The Top](#cheatsheet)

### Select and Change

#### find and substitute a little bit faster

 \<leader>7

#### linewise

\<leader>8

#### Select word faster

\<leader>w

#### ... and change it

\<leader>q

#### to select in between "" [] {} () <>

\<leader>
"" \<A-2>
[] \<A-8>
{} \<A-7>
() \<A-9>
<> \<A-y>

#### select whole line from last to first non-empty char

\<leader>l

#### Create line without leaving mode

down:
\<localleader>o
up:
\<localleader>O

#### go back to last edit

\<A-#>
\<A-'>

#### turn search highlight off

\<leader>\<A-n>

#### go to mark and put it the middle of screen

' a...z

[Back To The Top](#cheatsheet)

### NERD Commenter

#### comment

\<leader>cc

#### invert comment

\<leader>ci

### Easy Motion

#### search forward and backwards

\<leader>s

> all the oder search modes follow the normal jumping mappings

### **TODO:** Ultisnips

---

## Vim-Tidal

### silence a pattern

```<localleader>[pattern number]```

> let's say you want to silence ```p 1 $ "bd"``` and your localleader is **ä** as mine.  
Then press ```ä + 1```

### **TODO:** more vim-tidal stuff

[Back To The Top](#cheatsheet)
