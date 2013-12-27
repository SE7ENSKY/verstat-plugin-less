module.exports = (next) ->
	resolveDependencies = (file) =>
		deps = []
		if imports = file.source.match ///@import\s+".+";///g
			for importString in imports
				fullname = importString.match(///@import\s+"(.+)";///)[1].replace(///\.less$///, '')
				importFile = @queryFile
					srcExtname: '.less'
					fullname: $in: [ fullname, file.dir + '/' + fullname ]
				if importFile
					deps.push importFile
					deps = deps.concat resolveDependencies importFile # recursive or linear?
		deps

	less = require 'less'
	@processor 'less',
		srcExtname: '.less'
		extname: '.css'
		compile: (file, options = {}, done) =>
			@depends file, deps if deps = resolveDependencies file

			parser = new less.Parser
				paths: @config.src
				filename: file.srcFilePath

			parser.parse file.source, (err, tree) =>
				if err then done err else
					done null, tree.toCSS compress: no
	next()