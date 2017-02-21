(function (global) {
    System.config({
        // map tells the System loader where to look for things
        map: {
            // our app is within the app folder
            app: 'app',
            // angular bundles
            '@angular/core': 'assets/@angular/core/bundles/core.umd.js',
            '@angular/common': 'assets/@angular/common/bundles/common.umd.js',
            '@angular/compiler': 'assets/@angular/compiler/bundles/compiler.umd.js',
            '@angular/platform-browser': 'assets/@angular/platform-browser/bundles/platform-browser.umd.js',
            '@angular/platform-browser-dynamic': 'assets/@angular/platform-browser-dynamic/bundles/platform-browser-dynamic.umd.js',
            '@angular/http': 'assets/@angular/http/bundles/http.umd.js',
            '@angular/router': 'assets/@angular/router/bundles/router.umd.js',
            '@angular/forms': 'assets/@angular/forms/bundles/forms.umd.js',
            // other libraries
            'rxjs':                      'assets/rxjs',
            'moment': 'assets/moment/moment.js'
        },
        // packages tells the System loader how to load when no filename and/or no extension
        packages: {
            app: {
                main: './main.js',
                defaultExtension: 'js'
            },
            rxjs: {
                defaultExtension: 'js'
            }
        }
    });
})(this);
