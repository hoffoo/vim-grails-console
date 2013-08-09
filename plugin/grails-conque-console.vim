" TODO open groovy/grails shell automatically

if !exists('g:GrailsShellExecutable')
	let g:GrailsShellExecutable = "grails"
endif

command! -nargs=0 StartGrailsConque call StartGrailsConque()
command! -nargs=0 StartGrailsDebugConque call StartGrailsDebugConque()
command! -nargs=0 StartGrailsTestsBrowser call GrailsTestsBrowser()
command! -nargs=0 GrailsRunTestFile call GrailsRunTestFile()
command! -nargs=0 GrailsRunCurrentTest call GrailsRunSingleTest()
command! -nargs=0 GrailsReRun call GrailsReRun()

autocmd BufHidden _grails_ execute ":bdel _grails_"
autocmd BufEnter _grails_ call GrailsEnteredConsole()
autocmd BufLeave _grails_ execute ":stopinsert"

function! GrailsEnteredConsole()
	if exists('g:GrailsInsertOnEnter')
		:startinsert
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
	call GrailsConque('')
endfunction

function! StartGrailsDebugConque()
	call GrailsConque('-debug')
endfunction

function! GrailsConque(debug)
	if exists('g:GrailsShellStartSplit')
		:botright sp
	endif

	execute ':ConqueTerm ' . g:GrailsShellExecutable . a:debug
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


if !exists('g:GroovyShellExecutable')
	let g:GroovyShellExecutable = "groovy"
endif

let g:GroovyClasspath = '"lib/*"'

let s:started = 0

command! -nargs=0 GroovyRunFile call GroovyRunFile()
command! -nargs=0 GroovyReRun call GroovyReRun()
command! -nargs=0 StartGroovyConque call StartGroovyConque()
command! -nargs=1 -complete=file -bar GroovyRun call RunGroovyTest('<args>')

autocmd BufHidden _groovy_ silent let s:started = 0
autocmd BufHidden _groovy_ silent execute ":bdel _groovy_"

autocmd BufEnter _groovy_ silent call GroovyEnteredConsole()
autocmd BufLeave _groovy_ ":stopinsert"

function! GroovyEnteredConsole()
	:startinsert
endfunction

function! GroovyRunFile()
    let filename = expand("%:p")
    :call GroovyRun(filename)
endfunction

function! GroovyRun(filename)
	let s:lastRan =  "" . g:GroovyShellExecutable . " -cp " . g:GroovyClasspath . " "  . a:filename
    call GroovyRunInConque(s:lastRan)
endfunction

function! GroovyReRun()
	if (exists('s:lastRan'))
		call GroovyRunInConque(s:lastRan)
	else
		echo "No groovy last ran."
	endif
endfunction

function! StartGroovyConque()
	:botright sp

	execute ':ConqueTerm bash'
	:file _groovy_
	:resize 18

	execute ":inoremap <buffer> <c-w> <esc><C-w>p"
endfunction

function! GroovyRunInConque(cmd)
	:drop _groovy_
	:startinsert
	execute ":normal i" . a:cmd . "\<CR>"
endfunction
