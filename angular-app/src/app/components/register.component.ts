import { Component, ViewContainerRef } from '@angular/core';
import { Router }                      from '@angular/router';
import { Overlay }                     from 'angular2-modal';
import { Modal }                       from 'angular2-modal/plugins/bootstrap';
import { Angular2TokenService }        from 'angular2-token';

@Component({
    selector: 'register',
    templateUrl: '../templates/register.component.html',
    styleUrls: ['../styles/forms.style.css']
})

export class RegisterComponent{
    userData = { email: '', password: '', passwordConfirmation: ''};

    constructor(
        private router: Router,
        overlay: Overlay,
        vcRef: ViewContainerRef,
        public modal: Modal,
        private _tokenService: Angular2TokenService
    ) {
        overlay.defaultViewContainer = vcRef;
    }

    create(): void {
        this._tokenService.registerAccount(this.userData)
        .subscribe(
            () =>      this.successRedirect(),
            error =>    this.showModal(error)
        )
    }

    private successRedirect(): void {
        let link = ['/login']
        this.router.navigate(link)
    }

    private showModal(error: any) {
        this.modal.alert()
            .size('sm')
            .title('Registration error')
            .body(`
                    <h4>There was a problem with registration</h4>
                    <h4>Please double check if your</h4>
                    <ul>
                        <li>Email</li>
                        <li>Password</li>
                        <li>Password confirmation</li>
                    </ul>

                    <h4>are correct.</h4>
            `)
            .open()
    }
}
