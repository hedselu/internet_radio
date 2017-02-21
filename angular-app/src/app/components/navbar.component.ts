import { Component }                from '@angular/core';
import { Router }                   from '@angular/router';
import { Angular2TokenService }     from 'angular2-token';

@Component({
    selector: 'navbar',
    templateUrl: '../templates/navbar.component.html'
})

export class NavbarComponent{
    constructor(
        private router: Router,
        public _tokenService: Angular2TokenService
    ) {}

    destroy(): void {
        this._tokenService.signOut().subscribe(
            () =>       this.successLogoutRedirect(),
            error =>    console.log(error)
        );
    }

    private successLogoutRedirect(): void {
        let link = ['/landing'];
        this.router.navigate(link)
    }
}
