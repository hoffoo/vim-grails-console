
if !exists('g:GrailsShellExecutable')
	let g:GrailsShellExecutable = "grails"
endif

command! -nargs=0 RunSingleGrailsTest call RunSingleGrailsTest()
command! -nargs=0 RunGrailsTestFile call RunGrailsTestFile()
command! -nargs=0 StartGrailsConque call StartGrailsConque()
command! -nargs=1 -complete=file -bar RunGrailsTest call RunGrailsTest('<args>')

autocmd BufHidden _grails_ execute ":bdel _grails_"
autocmd BufEnter _grails_ execute ":startinsert"

function! RunSingleGrailsTest()
    let testName = expand("%:t:r.") . "." . expand("<cword>")
    :call RunGrailsTest(testName)
endfunction

function! RunGrailsTestFile()
    let testName = expand("%:t:r")
    :call RunGrailsTest(testName)
endfunction

function! RunGrailsTest(testName)
    let path = expand("%:r")
    if path =~ "unit"
        let flag = "--unit"
    else
        let flag = "--integration"
    endif
    call RunInConque(" test-app " . flag . " " . a:testName)
endfunction

function! RunInConque(testcmd)
	execute ":drop _grails_"
	execute ":startinsert"
	execute ":normal i" . a:testcmd . "\<CR>"
endfunction

function! StartGrailsConque()
	execute ":ConqueTerm " . g:GrailsShellExecutable
	execute ":file _grails_"
endfunction

"function! TestResults()
"endfunction
