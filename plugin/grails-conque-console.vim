
if !exists('g:GrailsShellExecutable')
	let g:GrailsShellExecutable = "grails"
endif

command! -nargs=0 GrailsRunTestFile call GrailsRunTestFile()
command! -nargs=0 GrailsRunCurrentTest call GrailsRunSingleTest()
command! -nargs=0 StartGrailsConque call StartGrailsConque()
command! -nargs=0 GrailsReRun call GrailsReRun()
command! -nargs=0 GrailsTestsBrowser call GrailsTestsBrowser()
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
    call GrailsRunInConque(s:lastGrailsTest)
endfunction

function! GrailsReRun()
	if (exists('s:lastGrailsTest'))
		call GrailsRunInConque(s:lastGrailsTest)
	else
		echo "No last ran test."
	endif
endfunction

function! StartGrailsConque()
	if exists('g:GrailsShellStartSplit')
		:botright sp
	endif

	execute ':ConqueTerm ' . g:GrailsShellExecutable
	:file _grails_
	:resize 18

	if exists('g:GrailsShellReturnKey')
		execute ":inoremap <buffer> " . g:GrailsShellReturnKey . " <esc><C-w>p"
	endif
endfunction

function! GrailsRunInConque(cmd)
	:drop _grails_
	:startinsert
	execute ":normal i" . a:cmd . "\<CR>"
endfunction

function! PostCode(code)
	if !exists('g:GrailsConsoleURL')
		let path = split(getcwd(), '/')
		let app_name = path[len(path)]
		let g:GrailsConsoleURL = "http://localhost:8080/" . app_name . "/console/execute"
	fi
	let res = webapi#http#post(g:GrailsConsoleURL, a:code)
	echo res
endfunction


function! GrailsTestsBrowser()
	execute ":! " . g:GrailsTestsBrowser . "" . getcwd() ."/target/test-reports/html/index.html&"
endfunction

