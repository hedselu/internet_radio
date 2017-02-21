import { Component, ViewContainerRef } from '@angular/core';
import { Router } from '@angular/router';
import { ChannelService }  from '../services/channel.service'
import { Overlay } from 'angular2-modal';
import { Modal } from 'angular2-modal/plugins/bootstrap';
import { Angular2TokenService } from 'angular2-token';

@Component({
    selector: 'setup',
    templateUrl: '../templates/setup.component.html',
    styleUrls: ['../styles/forms.style.css']
})

export class SetupComponent{
    channelData = { name: ''}

    constructor(
        private router: Router,
        private setup: ChannelService,
        overlay: Overlay,
        vcRef: ViewContainerRef,
        public modal: Modal,
        private _tokenService: Angular2TokenService
    ) {
        overlay.defaultViewContainer = vcRef;
    }

    create(): void {
        this._tokenService.post('channels', this.channelData)
            .subscribe(
            () => this.successRedirect(),
            error => this.showModal(error)
        );
    }

    private successRedirect(): void {
        let link = ['/songs']
        this.router.navigate(link)
    }

    private showModal(error: any) {
        this.modal.alert()
            .size('sm')
            .title('Creation error!')
            .body(`<h4>This channel name has already been taken.</h4>`)
            .open()
    }
}
