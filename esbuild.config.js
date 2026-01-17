const esbuild = require('esbuild')
const path = require('path')

let mode = (process.env.RAILS_ENV === "production" ? "production" : "build")
process.argv.slice(2).forEach((arg) => {
    if (arg === '--watch') {
        mode = 'watch'
    } else if (arg === '--production') {
        mode = 'production'
    } else if(arg === '--test') {
        mode = 'test';
    }
})


let opts = {
    entryPoints: [
        'app/javascript/packs/application.js',
    ],
    bundle: true,
    sourcemap: true,
    logLevel: 'info',
    target: 'es2016',
    outdir: path.join(process.cwd(), "app/assets/builds"),
    plugins: [],
    loader: { '.js': 'jsx' }
}
if (mode === 'watch') {
    opts = {
        sourcemap: 'inline',
        ...opts
    }
}
if (mode === 'production') {
    opts = {
        minify: true,
        ...opts
    }
}

if (mode === 'watch') {
  esbuild.context(opts).then((context) => {
    context.watch()
    process.stdin.pipe(process.stdout)
    process.stdin.on('end', () => { context.dispose() })
  }).catch(() => process.exit(1))
} else {
  esbuild.build(opts).catch(() => process.exit(1))
}