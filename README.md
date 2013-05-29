Simple plugin that uses Conque-Shell to run tests from a grails app. To use this
you need to have conque-shell installed beforehand. I recommend using [pathogen](https://github.com/tpope/vim-pathogen "Pathogen").

If thats the case you can do:
```sh
cd ~/.vim/bundle
git clone https://github.com/rosenfeld/conque-term.git
git clone https://github.com/hoffoo/vim-grails-console.git
```

Recommended Conque settings:
```vim
let g:ConqueTerm_ReadUnfocused = 1 " run while not the selected window
let g:ConqueTerm_CloseOnEnd = 1 " quit grails when done
```
You can either run the entire file or the test function under your cursor. 

Example mappings:

To start the grails shell - 
```vim
:StartGrailsConque

" Map to run the whole file - 
:map <leader>t :RunGrailsTestFile<cr>

" Map to run the Test under the cursor -
:map <leader>s :RunSingleGrailsTest<cr>

" You can also run a test by name making it more convenient to map a specific run:
:RunGrailsTest TestName

" You can also override the path to the executable using:

let g:GrailsShellExecutable = "grails"
```

The defalt behavior of this plugin is to enter insert mode when switching back to it so Conque gets updated.

![Screenshot](http://i.imgur.com/eOxz0d3.png)

TODO:

- Search upwards if we are in a sub directory of a grails project

Resources:
http://www.objectpartners.com/2012/02/28/using-vim-as-your-grails-ide-part-2/ - mostly modified the test script from here
