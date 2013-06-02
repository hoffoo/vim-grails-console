Simple plugin that uses Conque-Shell to run tests from a grails app. To use this
you need to have conque-shell installed beforehand. I recommend using [pathogen](https://github.com/tpope/vim-pathogen "Pathogen").

If thats the case you can do:
```sh
cd ~/.vim/bundle
git clone https://github.com/rosenfeld/conque-term.git
git clone https://github.com/hoffoo/vim-grails-console.git
```

You can either run the entire file or the test function under your cursor. 

The defalt behavior of this plugin is to enter insert mode when switching back to it so Conque gets updated.
This way it does not override the g:ConqueTerm_InsertOnEnter. You can disable this with g:GrailsShellInsertOnEnter.

For conveneince <C-w> will switch out of the shell buffer and go back
to the previous editor window.

```vim
" Settings - off by default
" NOTE: all the keymappings apply only to the _grails_ buffer so not to conflict
" with the rest of your setup

" set this to open the shell buffer across the bottom in a split
let g:GrailsShellStartSplit = 1

" remap a key to switch back to previous buffer
let g:GrailsShellReturnKey = "<C-w><C-w>"

" if this is set insert mode backspace will be remapped to <C-w> to delete 
" whole word backwards
let g:GrailsShellRemapBS = 1

" command that will be passed the tests url when running :GrailsTestsBrowser
let g:GrailsTestsBrowser = "chromium --app=file://"

" You can override the path to the grails executable using:
" default is grails
let g:GrailsShellExecutable = "/opt/grails/bin/grails"


" Recommended Conque settings
let g:ConqueTerm_ReadUnfocused = 1 " run while not the selected window
let g:ConqueTerm_CloseOnEnd = 1 " quit grails when done
```

Plugin Commands: 
```vim
" Start the grails shell
:StartGrailsConque

" Run the current file as a Grails test 
" (unit or integration is inferred by file path)
:GrailsRunTestFile

" Run the Test under the cursor -
:GrailsRunCurrentTest

" You can also run a test by name, making it convenient to map a specific run:
:GrailsRunTest TestName

" Another useful command to map is reruning the last test
:GrailsReRunTest
```

You can also open a browser frame to show the html output of your tests - 
to do this set:
```vim

" this is the executable that will be passed the tests url
" open in a no tab chromium frame
let g:GrailsTestsBrowser = 'chromium --app=file://' 
let g:GrailsTestsBrowser = 'firefox ' " NOTE: notice the space
" open with regular tab
let g:GrailsTestsBrowser = '/usr/bin/google-chrome ' 

" and open the browser with
:GrailsTestsBrowser

```

![Screenshot](http://i.imgur.com/eOxz0d3.png)

TODO:

- Search upwards if we are in a sub directory of a grails project
- Regex upwards to find the test function name, rather than passing it with the cursor 

Resources:
http://www.objectpartners.com/2012/02/28/using-vim-as-your-grails-ide-part-2/ - mostly modified the test script from here
