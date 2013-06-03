import org.codehaus.groovy.grails.plugins.testing.GrailsMockHttpServletRequest

includeTargets << grailsScript('_GrailsBootstrap')

target('runConsole': "Run target file in the console.") {
	depends(parseArguments, configureProxy, packageApp, classpath, loadApp, configureApp)

	try {

		if (!argsMap['file'])
			throw new IllegalArgumentException("--file not specified")

		def file = new File(argsMap['file'])

		if (!file.exists())
			throw new FileNotFoundException("no such file " + argsMap['file'])

		// mock a request
		def request = new GrailsMockHttpServletRequest()
		// get service
		def consoleService = appCtx.getBean('consoleService')

		// make gorm work
		def persistenceInterceptor = appCtx.getBean('persistenceInterceptor')
		persistenceInterceptor.init()

		// run file snippet
		def result = consoleService.eval(file.text, true, request)

		// cleanup
		persistenceInterceptor.flush()
		persistenceInterceptor.destroy()

		println ""

		// results
		if (result.output)
			println result.output + "\n"
			
		if (result.exception)
			println result.exception

		if (result.result)
			println result.result

		
	} catch (FileNotFoundException fE) {
		println "Error: " + fE.message
	} catch (IllegalArgumentException argE) {
		println "Error: " + argE.message
	} catch (Exception ex) {
		println ex.message
	}
}

setDefaultTarget(runConsole)
