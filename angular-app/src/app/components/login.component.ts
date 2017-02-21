import { Component, ViewContainerRef }    from '@angular/core';
import { Router }                         from '@angular/router';
import { Overlay }                        from 'angular2-modal';
import { Modal }                          from 'angular2-modal/plugins/bootstrap';
import { User }                           from '../models/user.models'
import { Angular2TokenService }           from 'angular2-token';

@Component({
    selector: 'login',
    templateUrl: '../templates/login.component.html',
    styleUrls: ['../styles/forms.style.css']
})

export class LoginComponent{
    userCredentials = { email: '', password: ''}

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
        this._tokenService.signIn(this.userCredentials)
            .map(res => res.json())
            .subscribe(
                res => this.successLoginRedirect(res.data as User),
                error => this.showModal(error)
            )
    }
    
    private successLoginRedirect(user: User): void {
        let link = [];
        if(user.channel) {
            link = ['/player']
        } else {
            link = ['/setup']
        }
        this.router.navigate(link)
    }
    
    private showModal(error: any) {
        this.modal.alert()
            .size('sm')
            .title('Authentication error')
            .body(`
                    <h4>There was a problem with authentication.</h4>
                    <h4>Please double check your</h4>
                    <ul>
                        <li>Email</li>
                        <li>Password</li>
                    </ul>
            `)
            .open()
    }
}
