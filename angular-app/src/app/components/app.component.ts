import {Component} from '@angular/core';
import { Angular2TokenService } from 'angular2-token';

@Component({
    selector: "app",
    templateUrl: '../templates/app.component.html'
})


export class AppComponent {
    constructor(
        private _tokenService: Angular2TokenService
    ) {
        this._tokenService.init({
            apiPath: 'http://localhost:3000'
        });
    }
    title = 'Internet Radio';
}
