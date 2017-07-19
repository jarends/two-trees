module.exports = (config) ->
    config.set
        plugins:[
            'karma-mocha'
            'karma-chai'
            'karma-chrome-launcher'
            'karma-mocha-clean-reporter'
        ]

        frameworks:           ['mocha', 'chai']
        files:                ['test/js/index.pack.js']
        reporters:            ['mocha-clean']
        port:                 9876  #karma web server port
        colors:               true
        logLevel:             config.LOG_INFO
        browsers:             ['ChromeHeadless']
        autoWatch:            true
        failOnEmptyTestSuite: false
        singleRun:            false
        concurrency:          Infinity
