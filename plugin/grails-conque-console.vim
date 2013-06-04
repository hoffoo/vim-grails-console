
if !exists('g:GrailsShellExecutable')
	let g:GrailsShellExecutable = "grails"
endif

command! -nargs=0 GrailsRunTestFile call GrailsRunTestFile()
command! -nargs=0 GrailsRunCurrentTest call GrailsRunSingleTest()
command! -nargs=0 StartGrailsConque call StartGrailsConque()
command! -nargs=0 GrailsReRun call GrailsReRun()
command! -nargs=0 GrailsTestsBrowser call GrailsTestsBrowser()
command! -nargs=1 -complete=file -bar GrailsRunConsole call GrailsRunConsole('<args>')
command! -nargs=1 -complete=file -bar GrailsRunTest call RunGrailsTest('<args>')

autocmd BufHidden _grails_ execute ":bdel _grails_"
autocmd BufEnter _grails_ call GrailsEnteredConsole()
autocmd BufLeave _grails_ execute ":stopinsert"

function! GrailsEnteredConsole()
	if exists('g:GrailsInsertOnEnter')
		if (g:GrailsInsertOnEnter == 1)
			:startinsert
		endif
	endif 
endfunction

function! GrailsRunSingleTest()
    let testName = expand("%:t:r.") . "." . expand("<cword>")
    :call RunGrailsTest(testName)
endfunction

function! GrailsRunTestFile()
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
	let s:lastGrailsTest = " test-app " . flag . " " . a:testName
    call RunInConque(s:lastGrailsTest)
endfunction

function! GrailsReRun()
	if (exists('s:lastGrailsTest'))
		call RunInConque(s:lastGrailsTest)
	else
		echo "No last ran test."
	endif
endfunction

function! GrailsRunConsole(filename)
	let l:consoleCommand = "RunConsole --file=" . a:filename
	if (exists('g:GrailsReRunConsole'))
		if (g:GrailsReRunConsole == 1)
			let s:lastGrailsTest = l:consoleCommand
		endif 
	endif
	call RunInConque(l:consoleCommand)
endfunction

function! StartGrailsConque()
	if exists('g:GrailsShellStartSplit')
		:botright sp
	endif

	execute ":ConqueTerm " . g:GrailsShellExecutable
	:file _grails_

	if exists('g:GrailsShellReturnKey')
		execute ":inoremap <buffer> " . g:GrailsShellReturnKey . " <esc><C-w>p"
	endif
endfunction

function! RunInConque(cmd)
	:drop _grails_
	:startinsert
	execute ":normal i" . a:cmd . "\<CR>"
endfunction


function! GrailsTestsBrowser()
	execute ":! " . g:GrailsTestsBrowser . "" . getcwd() ."/target/test-reports/html/index.html&"
endfunction

