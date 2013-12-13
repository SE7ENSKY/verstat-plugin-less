module.exports = (next) ->
	less = require 'less'
	@processor 'less',
		srcExtname: '.less'
		extname: '.css'
		compile: (file, options = {}, done) =>
			parser = new less.Parser
				paths: @config.src
				filename: file.srcFilePath

			parser.parse file.source, (err, tree) =>
				if err then done err else
					done null, tree.toCSS compress: no
	next()