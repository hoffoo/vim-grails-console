/*
This script allows you to run a file trough the grails console
It requires the excellent grails-console plugin installed. 

Get it here: http://grails.org/plugin/console */

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

		// run file snippet
		def result = consoleService.eval(file.text, true, request)

		// results
		println result.output + "\n"
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
