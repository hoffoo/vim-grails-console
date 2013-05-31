
if !exists('g:GrailsShellExecutable')
	let g:GrailsShellExecutable = "grails"
endif

if exists('g:GrailsTestsOutputChromium')
	let g:GrailsTestsBrowser = "chromium --app=file://"
endif

if exists('g:GrailsTestsOutputChrome')
	let g:GrailsTestsBrowser = "google-chrome --app=file://"
endif

command! -nargs=0 RunSingleGrailsTest call RunSingleGrailsTest()
command! -nargs=0 RunGrailsTestFile call RunGrailsTestFile()
command! -nargs=0 StartGrailsConque call StartGrailsConque()
command! -nargs=0 ReRunGrailsTest call ReRunGrailsTest()
command! -nargs=1 -complete=file -bar RunGrailsTest call RunGrailsTest('<args>')

autocmd BufHidden _grails_ execute ":bdel _grails_"
autocmd BufEnter _grails_ execute ":startinsert"
autocmd BufLeave _grails_ execute ":stopinsert"

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
	let g:lastGrailsTest = " test-app " . flag . " " . a:testName
    call RunInConque(g:lastGrailsTest)
endfunction

function! ReRunGrailsTest()
	call RunInConque(g:lastGrailsTest)
endfunction

function! RunInConque(testcmd)
	execute ":drop _grails_"
	execute ":startinsert"
	execute ":normal i" . a:testcmd . "\<CR>"
endfunction

function! StartGrailsConque()
	if exists('g:GrailsShellStartSplit')
		execute ":botright sp"
	endif

	execute ":ConqueTerm " . g:GrailsShellExecutable
	execute ":file _grails_"

	if exists('g:GrailsTestsBrowser')
		execute ":! " . g:GrailsTestsBrowser . "`pwd`/target/test-reports/html/index.html&"
	endif
endfunction

"function! TestResults()
"endfunction
