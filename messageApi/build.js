const {build} = require('esbuild');

build({
    entryPoints:['./services/HandleMessage.ts'],
    bundle:true,
    platform:'node',
    logLevel:'info',
    outfile:'./dist/HandleMessage.js',
    external:['@aws-sdk/client-s3']
})