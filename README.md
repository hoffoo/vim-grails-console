Simple plugin that uses Conque-Shell to run tests from a grails app

To start the shell map a key to call StartGrailsConque() - you can either run the 
entire file or the function under your cursor. Example mappings:

map to run the whole file
map <F12> :call RunGrailsTestFile()<CR>


run the function under the cursor
map <F11> :call RunSingleGrailsTest()<CR>

You can also override the shell name and the path to the executable using:

<code>let g:GrailsShellName = "grails"</code><br>
<code>let g:GrailsShellExecutable = "grails"</code>

By default they are both grails - name will be the buffer name and executable
can be the full path.

![Screenshot](http://i.imgur.com/eOxz0d3.png)

TODO:

- Easy close of the buffer after it has exited
- Search upwards if we are in a sub directory of a grails project
- Alias to commands rather than calling the functions directly
- 

Resources:
http://www.objectpartners.com/2012/02/28/using-vim-as-your-grails-ide-part-2/ - mostly modified the test script from here
