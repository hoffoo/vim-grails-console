command! -nargs=0 RunSingleGrailsTest call RunSingleGrailsTest()
command! -nargs=0 RunGrailsTestFile call RunGrailsTestFile()
command! -nargs=0 StartGrailsConque call StartGrailsConque()

if !exists('g:GrailsShellName')
	let g:GrailsShellName = "grails"
endif

if !exists('g:GrailsShellExecutable')
	let g:GrailsShellExecutable = "grails"
endif

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
	execute ":drop grails"
	execute ":startinsert"
	execute ":normal i" . a:testcmd . "\<CR>"
endfunction

function! StartGrailsConque()
	execute ":ConqueTermSplit " . g:GrailsShellExecutable
	execute ":file " . g:GrailsShellName
endfunction

"function! TestResults()
"endfunction
